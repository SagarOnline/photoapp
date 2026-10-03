import { Body, Controller, Get, Put, Req, UseGuards } from '@nestjs/common';
import { AuthenticatedRequest } from '../auth/authenticated-request';
import { SupabaseAuthGuard } from '../auth/supabase-auth.guard';
import { UpdateProfileDto } from './profile.dto';
import { ProfilesService } from './profiles.service';

@Controller('me')
@UseGuards(SupabaseAuthGuard)
export class ProfilesController {
  constructor(private readonly profiles: ProfilesService) {}

  @Get()
  get(@Req() request: AuthenticatedRequest) {
    return this.profiles.get(request.userId);
  }

  @Put('profile')
  update(@Req() request: AuthenticatedRequest, @Body() body: UpdateProfileDto) {
    return this.profiles.update(request.userId, body);
  }
}