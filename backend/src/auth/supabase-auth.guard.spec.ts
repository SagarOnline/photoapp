import { ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createClient } from '@supabase/supabase-js';
import { AuthenticatedRequest } from './authenticated-request';
import { SupabaseAuthGuard } from './supabase-auth.guard';

jest.mock('@supabase/supabase-js', () => ({ createClient: jest.fn() }));

describe('SupabaseAuthGuard', () => {
  const request = { headers: { authorization: 'Bearer token' } } as unknown as AuthenticatedRequest;
  const context = {
    switchToHttp: () => ({ getRequest: () => request }),
  } as ExecutionContext;
  const config = {
    get: (key: string) => key === 'SUPABASE_URL' ? 'https://auth.example.test' : 'anon-key',
  } as ConfigService;

  beforeEach(() => jest.clearAllMocks());

  it('attaches the identity from the verified token', async () => {
    (createClient as unknown as jest.Mock).mockReturnValue({
      auth: { getUser: jest.fn().mockResolvedValue({ data: { user: { id: 'verified-user' } }, error: null }) },
    });
    const guard = new SupabaseAuthGuard(config);

    await expect(guard.canActivate(context)).resolves.toBe(true);
    expect(request.userId).toBe('verified-user');
  });

  it('rejects tokens Supabase does not validate', async () => {
    (createClient as unknown as jest.Mock).mockReturnValue({
      auth: { getUser: jest.fn().mockResolvedValue({ data: { user: null }, error: new Error('invalid') }) },
    });
    const guard = new SupabaseAuthGuard(config);

    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });
});