# API Contracts

Base path: `/api/v1`. Requests and responses use JSON unless the endpoint explicitly returns an upload URL. Protected endpoints require `Authorization: Bearer <Supabase access token>`. The API validates the token and derives the user ID from the verified identity; clients must not send an authoritative user ID.

Protected Hive endpoints require a complete registered profile. Hive media and upload operations also require Hive membership.

## Errors

Errors use NestJS's standard JSON shape:

```json
{
  "statusCode": 400,
  "code": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": [],
  "path": "/api/v1/hives"
}
```

`details` is optional and `path` identifies the request path. Use `401` for missing/invalid identity tokens, `403` for incomplete profiles, `404` for missing or inaccessible Hive resources, `409` for conflicts, and `400` for invalid input. Error messages must not disclose credentials or internal database details.

## Current Profile

`GET /me` (authenticated)

Returns whether the authenticated identity has a complete profile:

```json
{
  "registered": false,
  "profile": null
}
```

When registered, `profile` contains `name`, `gender`, and ISO-8601 `birthDate`.

`PUT /me/profile` (authenticated)

Request:

```json
{
  "name": "Asha Patel",
  "gender": "...",
  "birthDate": "1990-05-14"
}
```

Upserts the authenticated user's profile and returns `{ "registered": true, "profile": { ... } }`. All fields are required; `gender` is stored as user-provided text because accepted requirements do not prescribe a closed set of values.

## Hives

`GET /hives` (authenticated, complete profile)

Returns the authenticated user's memberships as `{ "items": [Hive] }`, ordered by most recently created. A Hive has `id`, `name`, `inviteCode`, nullable `coverImage`, and `createdAt`.

`POST /hives` (authenticated, complete profile)

Request: `{ "name": "Goa Trip 2026" }`

Creates a Hive and creator membership. Returns the created Hive. Invite-code generation and collision handling are server-side.

`POST /hives/join` (authenticated, complete profile)

Request: `{ "inviteCode": "ABCD2345" }`

Adds the authenticated user as a member of the matching Hive and returns `{ "hiveId": "uuid" }`. Invalid codes return `404`; an existing membership is idempotent.

## Gallery and Uploads

`GET /hives/{hiveId}/media?limit=30&cursor={opaque}` (authenticated Hive member)

Returns `{ "items": [Media], "nextCursor": "..." }`; `nextCursor` is null when there are no more results. Results are ordered newest-first. Media contains `id`, `hiveId`, `fileUrl`, nullable `thumbnailUrl`, `mediaType`, `uploadedAt`, and `uploadedBy`.

`POST /hives/{hiveId}/media/upload-authorization` (authenticated Hive member)

Request: `{ "fileName": "photo.jpg", "contentType": "image/jpeg", "sizeBytes": 12345 }`.

Returns `{ "uploadUrl": "...", "objectKey": "...", "expiresAt": "..." }`. The URL is short-lived and scoped to one object. The API enforces accepted media types and configured size limits.

`POST /hives/{hiveId}/media` (authenticated Hive member)

Request: `{ "objectKey": "...", "mediaType": "image" }`.

Records metadata only after validating that the object key was authorized for this user and Hive. Returns the created Media (`id`, `hiveId`, `fileUrl`, `thumbnailUrl`, `mediaType`, `uploadedAt`, `uploadedBy`). The API, not the client, determines the final display URL.