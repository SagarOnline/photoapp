# ADR-002: NestJS Feature API Boundary

Status: Accepted  
Date: 2026-09-27

## Decision

Maintain the Flutter application under `frontend/` and a separately deployable NestJS feature API under `backend/`. Keep shared SQL bootstrap scripts and documentation in root-level `db/` and `docs/`. Flutter uses Supabase Auth as the identity provider and sends its access token to the API. The API validates the token, derives the user identity from verified claims, and is the only application component that accesses PostgreSQL or privileged Cloudflare R2 credentials.

Hive, profile, membership, and media feature data are accessed through versioned API endpoints. The backend owns profile completeness checks, Hive authorization, invite-code generation, persistence, and media metadata.

Media uploads use short-lived, object-scoped R2 signed URLs issued only to registered Hive members. The API validates the uploaded object and records metadata in PostgreSQL. Privileged storage credentials are never returned to clients.

## Rationale

This keeps frontend and backend deployable independently while allowing both applications, shared contracts, and database setup to be maintained in one repository. It establishes a clear security and persistence boundary without replacing the accepted Supabase identity provider.

## Consequences

- Flutter and NestJS have independent dependencies, commands, and tests; Flutter commands run from `frontend/` and backend commands from `backend/`.
- API contracts, schema documentation, and SQL changes must be kept synchronized.
- Feature API configuration is environment-specific; secrets must not be committed.
- Existing development guest seed data is replaced by an authenticated-profile example. The SQL files under `db/` are fresh-development bootstrap scripts, not production migrations. Production data requires a reviewed forward migration and backup before schema changes.