#!/bin/sh
set -e

cd /app/apps/web
export PATH="/app/apps/web/node_modules/.bin:/app/node_modules/.bin:$PATH"

prisma migrate deploy --schema=/app/apps/web/prisma/schema.prisma

exec node /app/apps/web/server.js
