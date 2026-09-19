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

1. Guest users should be able to join collections with minimal friction.
2. Sharing a collection should be easier than sharing photos in WhatsApp.
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

## AI Coding Rules

When generating code:

- Produce complete production-ready code.
- Never generate placeholder TODO implementations unless explicitly requested.
- Explain architectural decisions only when they affect implementation.
- Keep widgets small and composable.
- Prefer async/await over callback chains.
- Avoid duplicated code.
- Keep files under roughly 250 lines where practical.

## Directory Ownership

- lib/features → UI and feature logic.
- lib/models → Data models only.
- lib/services → Backend clients and repositories.
- lib/core → Shared utilities, constants, theme, router.
- supabase → SQL migrations and policies.

## Out of Scope for MVP

Do not implement unless requested:

- Face recognition.
- AI photo ranking.
- Social feed.
- Likes/comments.
- Premium subscriptions.
- Push notifications.
- Original-quality storage.

This file becomes the primary context for any AI coding assistant.