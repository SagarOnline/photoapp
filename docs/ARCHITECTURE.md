# Architecture

## Frontend

Flutter using Feature-First Clean Architecture.

lib/
  core/
  features/
    hives/
    gallery/
    upload/
    onboarding/
  models/
  services/

### State Management

Riverpod.

### Routing

GoRouter.

## Backend

Supabase initially.

Responsibilities:

- PostgreSQL stores metadata.
- Auth manages registered user accounts; anonymous authentication is not used.
- Users must complete sign-up or sign in before joining a Hive.
- Storage metadata stored in PostgreSQL.
- Actual media stored in Cloudflare R2.

Future backend migration:

Flutter → NestJS API → PostgreSQL → R2

Flutter should never depend directly on SQL schema outside repositories. The shared event concept is called a Hive throughout the application.

## Media Upload Flow

User selects image.

Flutter compresses image.

Upload to R2.

Insert metadata into PostgreSQL.

Gallery listens for metadata changes.
