import { NotFoundException } from '@nestjs/common';
import { AppRepository } from '../database/app.repository';
import { ProfilesService } from '../profiles/profiles.service';
import { HivesService } from './hives.service';

describe('HivesService', () => {
  const profiles = { assertRegistered: jest.fn().mockResolvedValue(undefined) } as unknown as ProfilesService;

  beforeEach(() => jest.clearAllMocks());

  it('creates a Hive and owner membership in one transaction', async () => {
    const repository = {
      transaction: jest.fn().mockImplementation(
        async (work: (client: { query: jest.Mock }) => Promise<unknown>) =>
          work({
            query: jest.fn().mockResolvedValue({ rows: [{ id: 'hive-id', name: 'Trip' }] }),
          }),
      ),
    } as unknown as AppRepository;
    const service = new HivesService(repository, profiles);

    await expect(service.create('user-id', { name: ' Trip ' })).resolves.toMatchObject({
      id: 'hive-id',
      name: 'Trip',
    });
    expect(repository.transaction).toHaveBeenCalledTimes(1);
  });

  it('rejects an unknown invite code', async () => {
    const repository = { query: jest.fn().mockResolvedValue({ rows: [] }) } as unknown as AppRepository;
    const service = new HivesService(repository, profiles);

    await expect(service.join('user-id', 'NOPE1234')).rejects.toBeInstanceOf(NotFoundException);
  });
});