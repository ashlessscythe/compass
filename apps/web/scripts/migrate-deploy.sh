#!/bin/sh
set -e
cd "$(dirname "$0")/.."

if [ -f .env.local ]; then
  exec dotenv -e .env.local -- prisma migrate deploy
fi

exec prisma migrate deploy
