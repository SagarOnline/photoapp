create extension if not exists pgcrypto;

create table profiles (
	user_id uuid primary key,
	name text not null,
	gender text not null,
	birth_date date not null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create table hives (
	id uuid primary key default gen_random_uuid(),
	name text not null,
	description text,
	invite_code text not null unique,
	cover_image text,
	created_by uuid not null references profiles(user_id),
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);
