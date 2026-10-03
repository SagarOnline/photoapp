-- Optional development Hive row. It is not visible to a user until an
-- authenticated profile and membership are created for that user.

insert into profiles (user_id, name, gender, birth_date)
values (
  '00000000-0000-0000-0000-000000000002',
  'Development Owner',
  'unspecified',
  '1990-01-01'
)
on conflict (user_id) do nothing;

insert into hives (id, name, description, invite_code, created_by)
values (
  '00000000-0000-0000-0000-000000000001',
  'Goa Trip 2026',
  'Shared memories from the Goa trip.',
  'GOA2026',
  '00000000-0000-0000-0000-000000000002'
)
on conflict (id) do nothing;

insert into members (hive_id, user_id, role)
values (
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000002',
  'owner'
)
on conflict (hive_id, user_id) do nothing;