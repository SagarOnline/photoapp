# Architecture

The Flutter application and NestJS API are separate deployable applications in this repository. Flutter lives in `frontend/`, the API in `backend/`, and shared SQL bootstrap scripts and documentation remain in root-level `db/` and `docs/`.

```text
Flutter client ── HTTPS/JSON ──> NestJS API ──> PostgreSQL
      │                              │
      └── Supabase Auth              └── Cloudflare R2 (authorized media operations)
```

## Frontend

Flutter uses feature-first architecture, Riverpod for state management, and GoRouter for navigation. The client owns presentation, local interaction state, media selection, and pre-upload compression. Feature repositories call the versioned API; widgets and feature state do not depend on HTTP, SQL, or storage-provider details.

Supabase is used only as the identity provider. Flutter signs in with Supabase and sends the current access token as a bearer token to protected API routes. Do not use the Supabase database client from Flutter for Hive, profile, membership, or media metadata operations.

## Backend

NestJS in `backend/` exposes `/api/v1` feature APIs. Controllers validate and map HTTP requests; services enforce product rules; repositories own PostgreSQL access. The API verifies Supabase access tokens, derives the user ID from verified identity claims, checks profile registration and Hive membership, and is the only application component that accesses PostgreSQL.

The backend owns invite-code generation and uniqueness handling. It must not trust user IDs supplied by clients. Database credentials, Supabase server configuration, and privileged R2 credentials are server-only environment configuration.

## Data and Identity

- Supabase Auth manages registered authentication identities; anonymous sign-in and guest Hive membership are not supported.
- PostgreSQL stores profiles, Hives, memberships, and media metadata.
- A profile is complete only after the required name, gender, and birth date have been persisted.
- A valid authenticated identity is not by itself a registered application profile.
- Every protected Hive operation requires a valid bearer token and a complete profile. Membership-specific operations additionally require membership in the requested Hive.

## Media Flow

1. Flutter selects and compresses media.
2. Flutter asks the API for upload authorization. The API verifies profile and Hive membership and returns a short-lived, object-scoped R2 upload URL.
3. Flutter uploads the compressed file directly to R2 using that URL.
4. Flutter asks the API to record the media metadata. The API validates the authorized object and persists metadata in PostgreSQL.
5. Gallery requests are paginated API calls; the API checks membership and returns media metadata and display URLs.

The API must never return privileged R2 credentials. Actual media files are stored in Cloudflare R2; PostgreSQL stores metadata only.

## Repository Layout

- `frontend/`: Flutter application, including `lib/`, tests, dependency manifests, and platform projects.
- `backend/`: NestJS API and backend tests.
- `db/`: Root-level SQL development/bootstrap scripts, kept aligned with the backend schema.
- `docs/`: Root-level requirements, contracts, architecture, and decisions.

Accepted architecture rationale is recorded in [ADR-002](decisions/ADR-002-feature-api.md).
