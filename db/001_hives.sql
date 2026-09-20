create extension if not exists pgcrypto;

create table hives (
	id uuid primary key default gen_random_uuid(),
	name text not null,
	description text,
	invite_code text not null unique,
	cover_image text,
	created_by uuid,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);
