import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { AuthenticatedRequest } from './authenticated-request';

@Injectable()
export class SupabaseAuthGuard implements CanActivate {
  private readonly supabase: SupabaseClient;

  constructor(config: ConfigService) {
    const url = config.get<string>('SUPABASE_URL');
    const key = config.get<string>('SUPABASE_ANON_KEY');
    if (!url || !key) {
      throw new Error('SUPABASE_URL and SUPABASE_ANON_KEY are required.');
    }
    this.supabase = createClient(url, key, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const authorization = request.headers.authorization;
    const match = authorization?.match(/^Bearer\s+(.+)$/i);
    if (!match) {
      throw new UnauthorizedException({ code: 'UNAUTHENTICATED', message: 'Bearer token required.' });
    }

    const { data, error } = await this.supabase.auth.getUser(match[1]);
    if (error || !data.user) {
      throw new UnauthorizedException({ code: 'UNAUTHENTICATED', message: 'Invalid access token.' });
    }
    request.userId = data.user.id;
    return true;
  }
}