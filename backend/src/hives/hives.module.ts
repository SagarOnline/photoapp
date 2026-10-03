import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { AppRepository } from '../database/app.repository';
import { ProfilesModule } from '../profiles/profiles.module';
import { HivesController } from './hives.controller';
import { HivesService } from './hives.service';

@Module({
  imports: [AuthModule, ProfilesModule],
  controllers: [HivesController],
  providers: [AppRepository, HivesService],
})
export class HivesModule {}