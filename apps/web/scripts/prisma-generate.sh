#!/bin/sh
# prisma generate does not connect to Postgres. DATABASE_URL / DIRECT_URL only
# need to exist so schema validation succeeds. Prefer .env.local when present.
set -e
cd "$(dirname "$0")/.."

if [ -f .env.local ]; then
  exec dotenv -e .env.local -- prisma generate "$@"
fi

export DATABASE_URL="${DATABASE_URL:-postgresql://postgres:postgres@127.0.0.1:5432/compass}"
export DIRECT_URL="${DIRECT_URL:-$DATABASE_URL}"
exec prisma generate "$@"
