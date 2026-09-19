# Database Schema

## collections

| Column | Type |
|--------|------|
| id | UUID |
| name | TEXT |
| invite_code | TEXT UNIQUE |
| cover_image | TEXT |
| created_at | TIMESTAMP |

## members

| Column | Type |
|--------|------|
| id | UUID |
| collection_id | UUID |
| user_id | UUID NULL |
| guest_name | TEXT |
| joined_at | TIMESTAMP |

## media

| Column | Type |
|--------|------|
| id | UUID |
| collection_id | UUID |
| uploaded_by | UUID NULL |
| file_url | TEXT |
| thumbnail_url | TEXT |
| media_type | TEXT |
| uploaded_at | TIMESTAMP |

## Notes

- UUID primary keys.
- Soft deletes in later phase.
- Add Row Level Security policies before public launch.