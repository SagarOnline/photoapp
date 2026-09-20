# ADR-001: Media Storage

Status: Accepted  
Date: 2026-09-20

## Decision

Actual media files are stored in Cloudflare R2. PostgreSQL stores media metadata.

## Reason

This keeps the database lightweight and preserves compatibility with the planned NestJS backend.

## Consequences

- Flutter accesses media through repository abstractions.
- UI code must not depend directly on R2 or SQL details.