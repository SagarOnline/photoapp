import { IsDateString, IsNotEmpty, IsString, Matches, MaxLength } from 'class-validator';

export class UpdateProfileDto {
  @IsString()
  @IsNotEmpty()
  @Matches(/\S/)
  @MaxLength(120)
  name!: string;

  @IsString()
  @IsNotEmpty()
  @Matches(/\S/)
  @MaxLength(80)
  gender!: string;

  @IsDateString({ strict: true })
  birthDate!: string;
}