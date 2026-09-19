# Architecture

## Frontend

Flutter using Feature-First Clean Architecture.

lib/
  core/
  features/
    collection/
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
- Auth manages anonymous and authenticated users.
- Storage metadata stored in PostgreSQL.
- Actual media stored in Cloudflare R2.

Future backend migration:

Flutter → NestJS API → PostgreSQL → R2

Flutter should never depend directly on SQL schema outside repositories.

## Media Upload Flow

User selects image.

Flutter compresses image.

Upload to R2.

Insert metadata into PostgreSQL.

Gallery listens for metadata changes.
