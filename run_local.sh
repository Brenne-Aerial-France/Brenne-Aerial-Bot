#!/bin/sh
# Lancer le bot Discord Brenne Aerial en développement local
# Exit code  0 = redémarrage automatique (ex: /admin restart)
# Exit code 42 = arrêt définitif demandé (/admin shutdown)

while true; do
  node artifacts/discord-bot/src/index.js
  EXIT_CODE=$?

  if [ $EXIT_CODE -eq 42 ]; then
    echo "[DEV] Arrêt définitif demandé (code 42) — bot désactivé."
    break
  fi

  echo "[DEV] Bot arrêté (code $EXIT_CODE) — redémarrage dans 3s…"
  sleep 3
done
