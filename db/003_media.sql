create table media (
	id uuid primary key default gen_random_uuid(),
	hive_id uuid not null references hives(id) on delete cascade,
	uploaded_by uuid not null references profiles(user_id),
	object_key text not null unique,
	thumbnail_url text,
	media_type text not null,
	content_type text not null,
	size_bytes bigint not null,
	uploaded_at timestamptz not null default now()
);

create table media_upload_authorizations (
	object_key text primary key,
	hive_id uuid not null references hives(id) on delete cascade,
	user_id uuid not null references profiles(user_id) on delete cascade,
	content_type text not null,
	size_bytes bigint not null,
	expires_at timestamptz not null,
	consumed_at timestamptz
);
