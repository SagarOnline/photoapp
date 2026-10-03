import { IsIn, IsInt, IsNotEmpty, IsString, Max, MaxLength, Min } from 'class-validator';

const CONTENT_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'video/mp4'] as const;

export class AuthorizeUploadDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  fileName!: string;

  @IsIn(CONTENT_TYPES)
  contentType!: (typeof CONTENT_TYPES)[number];

  @IsInt()
  @Min(1)
  @Max(25000000)
  sizeBytes!: number;
}

export class RecordMediaDto {
  @IsString()
  @IsNotEmpty()
  objectKey!: string;

  @IsIn(['image', 'video'])
  mediaType!: 'image' | 'video';
}