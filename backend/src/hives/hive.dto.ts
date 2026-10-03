import { IsNotEmpty, IsString, MaxLength } from 'class-validator';

export class CreateHiveDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  name!: string;
}

export class JoinHiveDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(32)
  inviteCode!: string;
}