import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { AppRepository } from '../database/app.repository';
import { ProfilesModule } from '../profiles/profiles.module';
import { MediaController } from './media.controller';
import { MediaService } from './media.service';

@Module({
  imports: [AuthModule, ProfilesModule],
  controllers: [MediaController],
  providers: [AppRepository, MediaService],
})
export class MediaModule {}