# AGENTS.md

## Project Overview

This repository contains the MVP for **Shared Memory**, a mobile-first application that lets groups collect and preserve photos and videos from shared events such as trips, weddings, birthdays, reunions, treks, and office events.

The primary goal is **maximum adoption** by making media sharing easier than WhatsApp while preserving memories in an organized gallery.

## Mission

Build a production-quality MVP with clean architecture, strong typing, and scalable backend design while optimizing for rapid iteration.

## Tech Stack

- Flutter (Android-first, later iOS/Web)
- Dart 3
- Riverpod for state management
- GoRouter for navigation
- Supabase
  - PostgreSQL
  - Authentication
  - Edge Functions (later phases)
- Cloudflare R2 for media storage.
- GitHub Actions for CI/CD.

## Core Product Principles

1. Guest users should be able to join HIves with minimal friction.
2. Sharing a HIve should be easier than sharing photos in WhatsApp.
3. Every feature should be optimized for mobile devices and slow networks.
4. Media uploads should be compressed before upload.
5. Design APIs to remain compatible with a future NestJS backend.

## Engineering Principles

- Prefer feature-first architecture.
- Keep UI separate from business logic.
- Use immutable models.
- Avoid global mutable state.
- Use repository pattern between UI and backend.
- Keep networking isolated inside services.
- Every public method should be documented.

## Product Terminology

- The shared event concept is always called a HIve; use HIves for the plural.
- Do not introduce new uses of collection or collections for this concept.
- Use gallery, never gallary.
- Apply HIve terminology consistently in Dart symbols, routes, APIs, database names, documentation, and user-facing text.

## AI Coding Rules

When generating code:

- Produce complete production-ready code.
- Never generate placeholder TODO implementations unless explicitly requested.
- Explain architectural decisions only when they affect implementation.
- Keep widgets small and composable.
- Prefer async/await over callback chains.
- Avoid duplicated code.
- Keep files under roughly 250 lines where practical.
- Always refer to [docs/README.md](docs/README.md) and the relevant documents under [docs](docs) before implementing features, changing architecture, or making product decisions.
- Treat the docs files as the source of truth for product direction, engineering standards, API contracts, and data design.

## Documentation Map

Use the docs files in the order below whenever you need product, technical, or implementation guidance:

- [docs/README.md](docs/README.md) — Documentation index, ownership, and update rules.
- [docs/PRODUCT.md](docs/PRODUCT.md) — Product vision, target users, MVP goals, success criteria, and non-goals.
- [docs/ROADMAP.md](docs/ROADMAP.md) — Delivery phases and planned feature milestones for the MVP and future roadmap.
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — System architecture, responsibilities, data flow, and the intended frontend/backend boundaries.
- [docs/API_CONTRACTS.md](docs/API_CONTRACTS.md) — Expected endpoints, payloads, and responses for HIve, join, upload, and media APIs.
- [docs/DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md) — Core database tables, key fields, and persistence requirements.
- [docs/CODING_STANDARDS.md](docs/CODING_STANDARDS.md) — Dart, widget, naming, testing, and error-handling standards to follow during implementation.
- [docs/requirements/](docs/requirements/) — Stable, domain-specific functional and non-functional requirements.
- [docs/decisions/](docs/decisions/) — Accepted architectural decisions and their consequences.

## Directory Ownership

- lib/features → UI and feature logic (`hives`, `gallery`, `upload`).
- lib/models → Data models only.
- lib/services → Backend clients and repositories.
- lib/core → Shared utilities, constants, theme, router.
- db → SQL schema and seed scripts.

## Out of Scope for MVP

Do not implement unless requested:

- Face recognition.
- AI photo ranking.
- Social feed.
- Likes/comments.
- Premium subscriptions.
- Push notifications.
- Original-quality storage.

This file becomes the primary context for any AI coding assistant. Before changing code, identify the relevant requirement, architecture, contract, schema, and decision documents. Update documentation in the same change when behavior or a public contract changes.