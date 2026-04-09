#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/app

MAX_RETRIES=20
SLEEP_SECONDS=3

attempt=1
until npx prisma migrate deploy; do
  if [ "$attempt" -ge "$MAX_RETRIES" ]; then
    echo "❌ Impossible d'initialiser la base après ${MAX_RETRIES} tentatives."
    exit 1
  fi

  echo "⏳ Base de données indisponible, nouvelle tentative dans ${SLEEP_SECONDS}s... (${attempt}/${MAX_RETRIES})"
  attempt=$((attempt + 1))
  sleep "$SLEEP_SECONDS"
done

npm run prisma:seed

echo "✅ Base Prisma initialisée et données de démonstration chargées."
