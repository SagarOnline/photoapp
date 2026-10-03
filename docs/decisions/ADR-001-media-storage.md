# ADR-001: Media Storage

Status: Accepted  
Date: 2026-09-20

## Decision

Actual media files are stored in Cloudflare R2. PostgreSQL stores media metadata.

## Reason

This keeps the database lightweight and allows the NestJS API to control authorization and media metadata.

## Consequences

- Flutter accesses media through repository abstractions and the NestJS feature API.
- The backend authorizes short-lived, object-scoped R2 upload URLs and persists media metadata in PostgreSQL after validating the upload.
- The backend checks registered-profile and Hive-membership authorization for media operations.
- Flutter never receives privileged R2 credentials and does not access PostgreSQL.
- UI code must not depend directly on R2, HTTP transport, or SQL details.