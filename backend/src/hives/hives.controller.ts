import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { AuthenticatedRequest } from '../auth/authenticated-request';
import { SupabaseAuthGuard } from '../auth/supabase-auth.guard';
import { CreateHiveDto, JoinHiveDto } from './hive.dto';
import { HivesService } from './hives.service';

@Controller('hives')
@UseGuards(SupabaseAuthGuard)
export class HivesController {
  constructor(private readonly hives: HivesService) {}

  @Get()
  list(@Req() request: AuthenticatedRequest) {
    return this.hives.list(request.userId);
  }

  @Post()
  create(@Req() request: AuthenticatedRequest, @Body() body: CreateHiveDto) {
    return this.hives.create(request.userId, body);
  }

  @Post('join')
  join(@Req() request: AuthenticatedRequest, @Body() body: JoinHiveDto) {
    return this.hives.join(request.userId, body.inviteCode);
  }
}