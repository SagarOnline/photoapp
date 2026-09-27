import { Injectable, NotFoundException } from '@nestjs/common';
import { randomInt } from 'node:crypto';
import { AppRepository } from '../database/app.repository';
import { ProfilesService } from '../profiles/profiles.service';
import { CreateHiveDto } from './hive.dto';

const INVITE_CHARACTERS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

@Injectable()
export class HivesService {
  constructor(
    private readonly repository: AppRepository,
    private readonly profiles: ProfilesService,
  ) {}

  async list(userId: string) {
    await this.profiles.assertRegistered(userId);
    const { rows } = await this.repository.query(
      `select h.id, h.name, h.invite_code as "inviteCode", h.cover_image as "coverImage",
        h.created_at as "createdAt"
       from hives h join members m on m.hive_id = h.id
       where m.user_id = $1 order by h.created_at desc`,
      [userId],
    );
    return { items: rows };
  }

  async create(userId: string, dto: CreateHiveDto) {
    await this.profiles.assertRegistered(userId);
    for (let attempt = 0; attempt < 5; attempt += 1) {
      const inviteCode = this.generateInviteCode();
      try {
        return await this.repository.transaction(async (client) => {
          const inserted = await client.query(
            `insert into hives (name, invite_code, created_by)
             values ($1, $2, $3)
             returning id, name, invite_code as "inviteCode", cover_image as "coverImage", created_at as "createdAt"`,
            [dto.name.trim(), inviteCode, userId],
          );
          await client.query(
            `insert into members (hive_id, user_id, role) values ($1, $2, 'owner')`,
            [inserted.rows[0].id, userId],
          );
          return inserted.rows[0];
        });
      } catch (error) {
        if (!this.isUniqueViolation(error) || attempt === 4) throw error;
      }
    }
    throw new Error('Unable to allocate a unique invite code.');
  }

  async join(userId: string, inviteCode: string) {
    await this.profiles.assertRegistered(userId);
    const { rows } = await this.repository.query<{ id: string }>(
      'select id from hives where invite_code = $1',
      [inviteCode.trim().toUpperCase()],
    );
    if (!rows[0]) throw new NotFoundException({ code: 'HIVE_NOT_FOUND', message: 'Invite code was not found.' });
    await this.repository.query(
      `insert into members (hive_id, user_id) values ($1, $2)
       on conflict (hive_id, user_id) do nothing`,
      [rows[0].id, userId],
    );
    return { hiveId: rows[0].id };
  }

  private generateInviteCode(): string {
    return Array.from({ length: 8 }, () => INVITE_CHARACTERS[randomInt(INVITE_CHARACTERS.length)]).join('');
  }

  private isUniqueViolation(error: unknown): boolean {
    return typeof error === 'object' && error !== null && 'code' in error && error.code === '23505';
  }
}