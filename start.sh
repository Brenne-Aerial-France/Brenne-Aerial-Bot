#!/bin/sh
set -e

echo "[PROD] Démarrage du bot Discord Brenne Aerial..."
node artifacts/discord-bot/src/index.js &
BOT_PID=$!

echo "[PROD] Démarrage de l'API server..."
exec node --enable-source-maps artifacts/api-server/dist/index.mjs
