import { NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppRepository } from '../database/app.repository';
import { ProfilesService } from '../profiles/profiles.service';
import { MediaService } from './media.service';

describe('MediaService', () => {
  it('refuses gallery access when the caller is not a Hive member', async () => {
    const repository = { query: jest.fn().mockResolvedValue({ rows: [] }) } as unknown as AppRepository;
    const profiles = { assertRegistered: jest.fn().mockResolvedValue(undefined) } as unknown as ProfilesService;
    const config = { get: jest.fn().mockReturnValue(undefined) } as unknown as ConfigService;
    const service = new MediaService(repository, profiles, config);

    await expect(service.list('user-id', 'hive-id')).rejects.toBeInstanceOf(NotFoundException);
    expect(repository.query).toHaveBeenCalledWith(
      'select 1 from members where hive_id = $1 and user_id = $2',
      ['hive-id', 'user-id'],
    );
  });
});