import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { DatabaseModule } from './database/database.module';
import { HealthController } from './health.controller';
import { HivesModule } from './hives/hives.module';
import { MediaModule } from './media/media.module';
import { ProfilesModule } from './profiles/profiles.module';

function validateConfiguration(values: Record<string, unknown>): Record<string, unknown> {
  for (const key of ['DATABASE_URL', 'SUPABASE_URL', 'SUPABASE_ANON_KEY']) {
    if (typeof values[key] !== 'string' || values[key] === '') {
      throw new Error(`${key} is required.`);
    }
  }
  const port = Number(values.PORT ?? 3000);
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    throw new Error('PORT must be an integer between 1 and 65535.');
  }
  for (const key of ['SUPABASE_URL', 'DATABASE_URL']) {
    try {
      new URL(values[key] as string);
    } catch {
      throw new Error(`${key} must be a valid URL.`);
    }
  }
  const storageKeys = [
    'R2_ACCOUNT_ID',
    'R2_ACCESS_KEY_ID',
    'R2_SECRET_ACCESS_KEY',
    'R2_BUCKET',
  ];
  const configuredStorageKeys = storageKeys.filter(
    (key) => typeof values[key] === 'string' && values[key] !== '',
  );
  if (configuredStorageKeys.length !== 0 && configuredStorageKeys.length !== storageKeys.length) {
    throw new Error('R2_ACCOUNT_ID, R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, and R2_BUCKET must be configured together.');
  }
  for (const key of ['R2_UPLOAD_MAX_BYTES', 'R2_UPLOAD_TTL_SECONDS']) {
    if (values[key] !== undefined) {
      const value = Number(values[key]);
      if (!Number.isInteger(value) || value < 1) {
        throw new Error(`${key} must be a positive integer.`);
      }
    }
  }
  return values;
}

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, validate: validateConfiguration }),
    DatabaseModule,
    AuthModule,
    ProfilesModule,
    HivesModule,
    MediaModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}