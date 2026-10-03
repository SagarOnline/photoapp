import { Controller, Get, Param, Post, Body, Query, Req, UseGuards } from '@nestjs/common';
import { AuthenticatedRequest } from '../auth/authenticated-request';
import { SupabaseAuthGuard } from '../auth/supabase-auth.guard';
import { AuthorizeUploadDto, RecordMediaDto } from './media.dto';
import { MediaService } from './media.service';

@Controller('hives/:hiveId/media')
@UseGuards(SupabaseAuthGuard)
export class MediaController {
  constructor(private readonly media: MediaService) {}

  @Get()
  list(
    @Req() request: AuthenticatedRequest,
    @Param('hiveId') hiveId: string,
    @Query('limit') limit?: string,
    @Query('cursor') cursor?: string,
  ) {
    return this.media.list(request.userId, hiveId, limit, cursor);
  }

  @Post('upload-authorization')
  authorize(
    @Req() request: AuthenticatedRequest,
    @Param('hiveId') hiveId: string,
    @Body() body: AuthorizeUploadDto,
  ) {
    return this.media.authorizeUpload(request.userId, hiveId, body);
  }

  @Post()
  record(
    @Req() request: AuthenticatedRequest,
    @Param('hiveId') hiveId: string,
    @Body() body: RecordMediaDto,
  ) {
    return this.media.record(request.userId, hiveId, body);
  }
}