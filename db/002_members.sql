create table members (
	id uuid primary key default gen_random_uuid(),
	hive_id uuid not null references hives(id) on delete cascade,
	user_id uuid,
	guest_name text,
	joined_at timestamptz not null default now(),
	role text not null default 'member'
);
