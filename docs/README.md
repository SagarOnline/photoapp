# Documentation Guide

This directory is the source of truth for product behavior, architecture, contracts, data design, and engineering standards.

## Reading Order

1. [PRODUCT.md](PRODUCT.md)
2. [ROADMAP.md](ROADMAP.md)
3. Relevant files under [requirements](requirements/)
4. [ARCHITECTURE.md](ARCHITECTURE.md)
5. [API_CONTRACTS.md](API_CONTRACTS.md) and [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)
6. Relevant files under [decisions](decisions/)
7. [CODING_STANDARDS.md](CODING_STANDARDS.md)

## Ownership

- Product behavior belongs in `requirements/`.
- Product direction and sequencing belong in `PRODUCT.md` and `ROADMAP.md`.
- Technical structure belongs in `ARCHITECTURE.md`.
- External and persistence contracts belong in `API_CONTRACTS.md` and `DATABASE_SCHEMA.md`.
- Rationale for accepted choices belongs in `decisions/`.

Every requirement uses a stable identifier and a status such as Proposed, Accepted, In Progress, Implemented, Deprecated, or Rejected. Update the relevant document in the same change as the implementation.

## Canonical Terminology

The product concept is always a HIve, with HIves as the plural. Code and database identifiers use `hive` and `hives`. The media browsing feature is always called gallery.