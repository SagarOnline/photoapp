# Database Schema

PostgreSQL is accessed only by the NestJS backend. UUID identity values reference Supabase Auth users; the backend derives these from verified access tokens.

## profiles

| Column | Type |
|--------|------|
| user_id | UUID PRIMARY KEY |
| name | TEXT NOT NULL |
| gender | TEXT NOT NULL |
| birth_date | DATE NOT NULL |
| created_at | TIMESTAMPTZ NOT NULL |
| updated_at | TIMESTAMPTZ NOT NULL |

## hives

| Column | Type |
|--------|------|
| id | UUID |
| name | TEXT |
| invite_code | TEXT UNIQUE |
| cover_image | TEXT |
| created_by | UUID NOT NULL REFERENCES profiles(user_id) |
| created_at | TIMESTAMPTZ NOT NULL |
| updated_at | TIMESTAMPTZ NOT NULL |

## members

| Column | Type |
|--------|------|
| id | UUID |
| hive_id | UUID |
| user_id | UUID NOT NULL REFERENCES profiles(user_id) |
| joined_at | TIMESTAMPTZ NOT NULL |
| role | TEXT NOT NULL |

Unique constraint: `(hive_id, user_id)`.

## media

| Column | Type |
|--------|------|
| id | UUID |
| hive_id | UUID NOT NULL REFERENCES hives(id) |
| uploaded_by | UUID NOT NULL REFERENCES profiles(user_id) |
| object_key | TEXT UNIQUE NOT NULL |
| thumbnail_url | TEXT |
| media_type | TEXT NOT NULL |
| content_type | TEXT NOT NULL |
| size_bytes | BIGINT NOT NULL |
| uploaded_at | TIMESTAMPTZ NOT NULL |

## media_upload_authorizations

| Column | Type |
|--------|------|
| object_key | TEXT PRIMARY KEY |
| hive_id | UUID NOT NULL REFERENCES hives(id) |
| user_id | UUID NOT NULL REFERENCES profiles(user_id) |
| content_type | TEXT NOT NULL |
| size_bytes | BIGINT NOT NULL |
| expires_at | TIMESTAMPTZ NOT NULL |
| consumed_at | TIMESTAMPTZ NULL |

## Notes

- UUID primary keys.
- `members.user_id` references an authenticated Supabase Auth identity; guest membership is not supported.
- `hives.created_by`, `members.user_id`, and `media.uploaded_by` are identity UUIDs verified by the backend.
- Media object keys are stored instead of client-authored file URLs; the API resolves display URLs.
- Add Row Level Security policies before public launch if any direct administrative Supabase access is enabled. The application client accesses data through the API.
- Development SQL scripts may be reset to this schema because no deployed data exists. Production schema changes must use reviewed forward migrations and backups.