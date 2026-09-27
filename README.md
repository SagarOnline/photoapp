# Shared Memory

Shared Memory contains a Flutter client in `frontend/` and a NestJS feature API in `backend/`. Both applications are maintained in this repository; shared SQL bootstrap scripts remain in `db/` and product and technical documentation remains in `docs/`.

## Requirements

- Flutter SDK compatible with the constraint in `frontend/pubspec.yaml`.
- Node.js 20 or newer and npm for the backend.
- A PostgreSQL database, Supabase Auth project, and Cloudflare R2-compatible bucket for full integration.

## Flutter

```sh
cd frontend
flutter pub get
flutter run \
  --dart-define=API_BASE_URL=http://localhost:3000/api/v1 \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"
```

The Flutter client uses Supabase Auth for identity and the NestJS API for profile, Hive, membership, and media feature data. Export `SUPABASE_URL` and `SUPABASE_ANON_KEY` in the shell before running; these build-time values must not include privileged server keys. Android emulators should use `http://10.0.2.2:3000/api/v1` for the local API host.

## Backend

```sh
cd backend
npm install
cp .env.example .env
npm run start:dev
```

Set local environment values in `backend/.env` before starting the API. Do not commit `.env`. Set `CORS_ORIGINS` to the exact browser origins that should call the API; native mobile requests do not use browser CORS. Configure the R2 bucket CORS policy to permit `PUT` from supported browser origins and the signed `Content-Type` header. The SQL files in `db/` are bootstrap scripts for a fresh or reset development database, not forward migrations; back up any data before resetting.

## Checks

```sh
cd frontend
flutter analyze
flutter test
cd ../backend
npm run lint
npm test
```

See `docs/` for architecture, requirements, API contracts, schema, and decisions.
