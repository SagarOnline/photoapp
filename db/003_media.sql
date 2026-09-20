create table media (
	id uuid primary key default gen_random_uuid(),
	hive_id uuid not null references hives(id) on delete cascade,
	uploaded_by uuid,
	file_url text not null,
	thumbnail_url text,
	media_type text not null,
	uploaded_at timestamptz not null default now()
);
