import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { AppRepository } from '../database/app.repository';
import { ProfilesController } from './profiles.controller';
import { ProfilesService } from './profiles.service';

@Module({
  imports: [AuthModule],
  controllers: [ProfilesController],
  providers: [AppRepository, ProfilesService],
  exports: [ProfilesService],
})
export class ProfilesModule {}