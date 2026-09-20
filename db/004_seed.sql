-- Optional development seed data. Run after 001_hives.sql, 002_members.sql,
-- and 003_media.sql.

insert into hives (id, name, description, invite_code)
values (
  '00000000-0000-0000-0000-000000000001',
  'Goa Trip 2026',
  'Shared memories from the Goa trip.',
  'GOA2026'
);

insert into members (hive_id, guest_name, role)
values (
  '00000000-0000-0000-0000-000000000001',
  'Guest',
  'member'
);

insert into media (hive_id, file_url, media_type)
values (
  '00000000-0000-0000-0000-000000000001',
  'https://example.invalid/media/goa-trip-2026-placeholder.jpg',
  'image'
);