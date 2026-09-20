# Shared Memory Copilot Instructions

Before making product, architecture, API, database, or UI decisions:

1. Read `AGENTS.md`.
2. Read `docs/README.md`.
3. Identify and read the relevant files under `docs/requirements/`.
4. Read related architecture, contract, schema, and decision documents.
5. Check for conflicting, deprecated, or proposed requirements.
6. State assumptions when the requirements do not define the behavior.
7. Update documentation in the same change when behavior, APIs, schema, or architecture changes.

Project terminology is authoritative:

- The shared event concept is always a `HIve`; the plural is `HIves`.
- Do not introduce `collection` or `collections` as names for this concept.
- Use `gallery`, never `gallary`.
- Use `hive` and `hives` in code, routes, APIs, and database names.

Requirement priority:

1. Accepted requirements.
2. Accepted architecture decisions.
3. Product and roadmap documents.
4. Existing implementation details.
5. Proposed requirements.

Never silently override an accepted requirement or decision.