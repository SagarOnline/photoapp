import { ForbiddenException, Injectable } from '@nestjs/common';
import { AppRepository } from '../database/app.repository';
import { UpdateProfileDto } from './profile.dto';

export interface ProfileRecord {
  user_id: string;
  name: string;
  gender: string;
  birth_date: string;
}

@Injectable()
export class ProfilesService {
  constructor(private readonly repository: AppRepository) {}

  async get(userId: string): Promise<{ registered: boolean; profile: object | null }> {
    const { rows } = await this.repository.query<ProfileRecord>(
      'select user_id, name, gender, birth_date::text from profiles where user_id = $1',
      [userId],
    );
    const profile = rows[0];
    return {
      registered: Boolean(profile?.name && profile.gender && profile.birth_date),
      profile: profile
        ? { name: profile.name, gender: profile.gender, birthDate: profile.birth_date }
        : null,
    };
  }

  async update(userId: string, dto: UpdateProfileDto) {
    const { rows } = await this.repository.query<ProfileRecord>(
      `insert into profiles (user_id, name, gender, birth_date)
       values ($1, $2, $3, $4::date)
       on conflict (user_id) do update set name = excluded.name, gender = excluded.gender,
         birth_date = excluded.birth_date, updated_at = now()
       returning user_id, name, gender, birth_date::text`,
      [userId, dto.name.trim(), dto.gender.trim(), dto.birthDate],
    );
    const profile = rows[0];
    return {
      registered: true,
      profile: { name: profile.name, gender: profile.gender, birthDate: profile.birth_date },
    };
  }

  async assertRegistered(userId: string): Promise<void> {
    const { registered } = await this.get(userId);
    if (!registered) {
      throw new ForbiddenException({ code: 'PROFILE_INCOMPLETE', message: 'Complete your profile first.' });
    }
  }
}