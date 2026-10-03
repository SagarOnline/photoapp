import {
  ForbiddenException,
  BadRequestException,
  Injectable,
  NotFoundException,
  ServiceUnavailableException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GetObjectCommand, HeadObjectCommand, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { randomUUID } from 'node:crypto';
import { AppRepository } from '../database/app.repository';
import { ProfilesService } from '../profiles/profiles.service';
import { AuthorizeUploadDto, RecordMediaDto } from './media.dto';

@Injectable()
export class MediaService {
  private readonly bucket: string;
  private readonly client: S3Client | null;
  private readonly maxBytes: number;
  private readonly uploadTtl: number;

  constructor(
    private readonly repository: AppRepository,
    private readonly profiles: ProfilesService,
    config: ConfigService,
  ) {
    this.bucket = config.get<string>('R2_BUCKET') ?? '';
    const accountId = config.get<string>('R2_ACCOUNT_ID');
    const accessKeyId = config.get<string>('R2_ACCESS_KEY_ID');
    const secretAccessKey = config.get<string>('R2_SECRET_ACCESS_KEY');
    this.client = accountId && accessKeyId && secretAccessKey
      ? new S3Client({
          region: 'auto',
          endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
          credentials: { accessKeyId, secretAccessKey },
        })
      : null;
    this.maxBytes = Number(config.get<string>('R2_UPLOAD_MAX_BYTES') ?? 25000000);
    this.uploadTtl = Number(config.get<string>('R2_UPLOAD_TTL_SECONDS') ?? 300);
  }

  async list(userId: string, hiveId: string, limitValue?: string, cursor?: string) {
    await this.assertMember(userId, hiveId);
    const limit = Math.min(Math.max(Number.parseInt(limitValue ?? '30', 10) || 30, 1), 100);
    let cursorDate: string | null = null;
    let cursorId: string | null = null;
    if (cursor) {
      try {
        const decoded = Buffer.from(cursor, 'base64url').toString('utf8').split('|');
        if (
          decoded.length !== 2 ||
          !Number.isFinite(Date.parse(decoded[0])) ||
          !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(decoded[1])
        ) throw new Error();
        cursorDate = decoded[0];
        cursorId = decoded[1];
      } catch {
        throw new BadRequestException({ code: 'INVALID_CURSOR', message: 'Gallery cursor is invalid.' });
      }
    }
    const { rows } = await this.repository.query(
      `select id, hive_id as "hiveId", object_key as "objectKey", media_type as "mediaType",
        uploaded_by as "uploadedBy",
        to_char(uploaded_at at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') as "uploadedAt"
       from media where hive_id = $1
       and ($2::timestamptz is null or (uploaded_at, id) < ($2::timestamptz, $3::uuid))
       order by uploaded_at desc, id desc limit $4`,
      [hiveId, cursorDate, cursorId, limit + 1],
    );
    const hasMore = rows.length > limit;
    const page = rows.slice(0, limit);
    const items = await Promise.all(page.map(async (row) => ({
      id: row.id,
      hiveId: row.hiveId,
      fileUrl: await this.signedGetUrl(row.objectKey),
      thumbnailUrl: null,
      mediaType: row.mediaType,
      uploadedAt: row.uploadedAt,
      uploadedBy: row.uploadedBy,
    })));
    const last = page[page.length - 1];
    return {
      items,
      nextCursor: hasMore && last
        ? Buffer.from(`${last.uploadedAt}|${last.id}`).toString('base64url')
        : null,
    };
  }

  async authorizeUpload(userId: string, hiveId: string, dto: AuthorizeUploadDto) {
    await this.assertMember(userId, hiveId);
    if (dto.sizeBytes > this.maxBytes) {
      throw new ForbiddenException({ code: 'UPLOAD_TOO_LARGE', message: 'Media exceeds the upload size limit.' });
    }
    const client = this.requireStorage();
    const objectKey = `hives/${hiveId}/${userId}/${randomUUID()}`;
    const expiresAt = new Date(Date.now() + this.uploadTtl * 1000);
    await this.repository.query(
      `insert into media_upload_authorizations
       (object_key, hive_id, user_id, content_type, size_bytes, expires_at)
       values ($1, $2, $3, $4, $5, $6)`,
      [objectKey, hiveId, userId, dto.contentType, dto.sizeBytes, expiresAt],
    );
    const uploadUrl = await getSignedUrl(
      client,
      new PutObjectCommand({
        Bucket: this.bucket,
        Key: objectKey,
        ContentType: dto.contentType,
        ContentLength: dto.sizeBytes,
      }),
      { expiresIn: this.uploadTtl },
    );
    return { uploadUrl, objectKey, expiresAt: expiresAt.toISOString() };
  }

  async record(userId: string, hiveId: string, dto: RecordMediaDto) {
    await this.assertMember(userId, hiveId);
    const client = this.requireStorage();
    const pending = await this.repository.query(
      `select content_type as "contentType", size_bytes as "sizeBytes"
       from media_upload_authorizations
       where object_key = $1 and hive_id = $2 and user_id = $3
         and consumed_at is null and expires_at > now()`,
      [dto.objectKey, hiveId, userId],
    );
    if (!pending.rows[0]) {
      throw new ForbiddenException({ code: 'UPLOAD_NOT_AUTHORIZED', message: 'Upload authorization is missing or expired.' });
    }
    const expected = pending.rows[0];
    if ((expected.contentType as string).startsWith('image/') !== (dto.mediaType === 'image')) {
      throw new ForbiddenException({ code: 'UPLOAD_MISMATCH', message: 'Media type does not match its authorization.' });
    }
    if (!dto.objectKey.startsWith(`hives/${hiveId}/${userId}/`)) {
      throw new ForbiddenException({ code: 'UPLOAD_NOT_AUTHORIZED', message: 'Object is not authorized for this Hive.' });
    }
    const head = await client.send(new HeadObjectCommand({ Bucket: this.bucket, Key: dto.objectKey }));
    if (head.ContentType !== expected.contentType || head.ContentLength !== Number(expected.sizeBytes)) {
      throw new ForbiddenException({ code: 'UPLOAD_MISMATCH', message: 'Uploaded media does not match its authorization.' });
    }
    const media = await this.repository.transaction(async (transaction) => {
      const locked = await transaction.query(
        `select object_key from media_upload_authorizations
         where object_key = $1 and consumed_at is null and expires_at > now() for update`,
        [dto.objectKey],
      );
      if (!locked.rows[0]) throw new ForbiddenException({ code: 'UPLOAD_ALREADY_RECORDED', message: 'Upload was already recorded.' });
      const result = await transaction.query(
        `insert into media (hive_id, uploaded_by, object_key, media_type, content_type, size_bytes)
         values ($1, $2, $3, $4, $5, $6)
         returning id, hive_id as "hiveId", object_key as "objectKey", media_type as "mediaType",
           uploaded_by as "uploadedBy", uploaded_at as "uploadedAt"`,
        [hiveId, userId, dto.objectKey, dto.mediaType, expected.contentType, expected.sizeBytes],
      );
      await transaction.query(
        'update media_upload_authorizations set consumed_at = now() where object_key = $1',
        [dto.objectKey],
      );
      return result.rows[0];
    });
    return {
      id: media.id,
      hiveId: media.hiveId,
      fileUrl: await this.signedGetUrl(media.objectKey),
      thumbnailUrl: null,
      mediaType: media.mediaType,
      uploadedAt: media.uploadedAt,
      uploadedBy: media.uploadedBy,
    };
  }

  private async assertMember(userId: string, hiveId: string): Promise<void> {
    await this.profiles.assertRegistered(userId);
    const { rows } = await this.repository.query(
      'select 1 from members where hive_id = $1 and user_id = $2',
      [hiveId, userId],
    );
    if (!rows[0]) throw new NotFoundException({ code: 'HIVE_NOT_FOUND', message: 'Hive not found.' });
  }

  private requireStorage(): S3Client {
    if (!this.client || !this.bucket) {
      throw new ServiceUnavailableException({ code: 'STORAGE_UNAVAILABLE', message: 'Media storage is not configured.' });
    }
    return this.client;
  }

  private async signedGetUrl(objectKey: string): Promise<string> {
    return getSignedUrl(
      this.requireStorage(),
      new GetObjectCommand({ Bucket: this.bucket, Key: objectKey }),
      { expiresIn: 300 },
    );
  }
}