import { ForbiddenException } from '@nestjs/common';
import { AppRepository } from '../database/app.repository';
import { ProfilesService } from './profiles.service';

describe('ProfilesService', () => {
  it('reports an identity without a profile as unregistered', async () => {
    const repository = { query: jest.fn().mockResolvedValue({ rows: [] }) } as unknown as AppRepository;
    const service = new ProfilesService(repository);

    await expect(service.get('user-id')).resolves.toEqual({ registered: false, profile: null });
  });

  it('blocks protected operations for incomplete profiles', async () => {
    const repository = { query: jest.fn().mockResolvedValue({ rows: [] }) } as unknown as AppRepository;
    const service = new ProfilesService(repository);

    await expect(service.assertRegistered('user-id')).rejects.toBeInstanceOf(ForbiddenException);
  });
});