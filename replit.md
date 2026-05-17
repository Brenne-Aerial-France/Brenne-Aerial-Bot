# Brenne Aerial Bot

Bot Discord professionnel pour Brenne Aerial — support opérationnel (tickets, missions drone, checklist) et système musical haute qualité via Lavalink.

## Run & Operate

- `node artifacts/discord-bot/src/index.js` — lancer le bot Discord
- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)
- Discord Bot: discord.js v14, Kazagumo (Lavalink), Shoukaku

## Where things live

- `artifacts/discord-bot/` — Bot Discord Brenne Aerial (JS, ESM)
  - `src/index.js` — Point d'entrée principal
  - `src/commands/support/` — Commandes support/entreprise
  - `src/commands/music/` — Commandes musicales (Lavalink)
  - `src/events/` — Handlers d'événements Discord
  - `src/handlers/` — Loaders dynamiques (commandes/events)
  - `src/utils/` — Logger, embeds
  - `src/config/lavalink.js` — Configuration nœuds Lavalink
  - `.env.example` — Template de configuration
  - `README.md` — Documentation complète

## Architecture decisions

- Bot Discord séparé de l'API serveur — isolation des concerns
- Kazagumo (sur Shoukaku) pour Lavalink : abstraction plus simple que Shoukaku seul, reconnexion automatique
- ESM natif (type: "module") pour le bot — compatibilité Node.js 18+
- Handlers dynamiques pour commandes/events : ajout de nouvelles commandes sans toucher à l'index
- Anti-crash global (uncaughtException, unhandledRejection) pour la stabilité en production

## Product

Bot Discord professionnel Brenne Aerial combinant :
- Système de tickets privés par catégorie (5 catégories)
- Gestion de missions drone (enregistrement, résumé)
- Checklist de sécurité avant vol
- Annonces officielles (admin)
- Statut de maintenance des services
- Système musical complet via Lavalink (9 commandes)
- Compatible Serenitia & ajieblogs Lavalink

## User preferences

- Code en JavaScript (pas TypeScript) pour le bot Discord
- Code modulaire et commenté
- Style professionnel, branding Brenne Aerial (bleu/cyan/vert)
- Variables d'environnement dans .env

## Gotchas

- Le bot nécessite un fichier `.env` rempli avant de démarrer (DISCORD_TOKEN, CLIENT_ID, GUILD_ID)
- Les commandes slash sont enregistrées en mode guild (instantané) — pas global (délai 1h)
- Lavalink doit être actif pour les commandes musique — le bot gère la reconnexion automatiquement
- Copier `.env.example` en `.env` et remplir toutes les valeurs avant de lancer

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
- See `artifacts/discord-bot/README.md` for the full bot documentation
