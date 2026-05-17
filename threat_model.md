# Threat Model

## Project Overview

Brenne Aerial Bot is a pnpm monorepo with two production-facing services: an Express API server under `artifacts/api-server` and a Discord bot under `artifacts/discord-bot`. The API currently exposes only a health endpoint. The Discord bot handles support tickets, mission logging, operational information, music playback through Lavalink, and AI-assisted responses through OpenAI. Shared PostgreSQL access lives in `lib/db`.

Per project assumptions, `artifacts/mockup-sandbox` is a design/mockup environment and is not considered production unless future scans prove production reachability.

## Assets

- **Discord bot credentials and service secrets** — Discord token, OpenAI integration credentials, Lavalink credentials, and database URL. Compromise would allow bot takeover, paid API abuse, or downstream service access.
- **Operational support data** — ticket channels, ticket logs, mission summaries, and staff communications inside Discord. Tampering or unauthorized disclosure would affect support operations and trust.
- **AI usage budget and service availability** — the bot can trigger paid LLM calls from member-controlled input. Abuse can create cost spikes or deny service to legitimate users.
- **Database connectivity** — `lib/db` centralizes PostgreSQL access for the API server. Any future injection or overbroad queries here would directly expose backend data.

## Trust Boundaries

- **Discord members to bot handlers** — slash command options, button clicks, select menu values, message mentions, and voice-state changes are untrusted input.
- **Bot to external services** — the bot sends traffic to Discord, OpenAI, and Lavalink nodes using privileged credentials.
- **HTTP clients to Express API** — all requests to `/api/*` are untrusted and must be validated server-side.
- **Application code to PostgreSQL** — shared DB code holds direct database connectivity; misuse would expose or alter stored data.
- **Production vs dev-only artifacts** — `artifacts/mockup-sandbox` is excluded from production scanning by default; findings there should not be reported unless production reachability changes.

## Scan Anchors

- Production entry points: `artifacts/api-server/src/index.ts`, `artifacts/api-server/src/app.ts`, `artifacts/discord-bot/src/index.js`.
- Highest-risk areas: `artifacts/discord-bot/src/events/interactionCreate.js`, `artifacts/discord-bot/src/events/messageCreate.js`, `artifacts/discord-bot/src/utils/ai.js`, `artifacts/discord-bot/src/commands/support/**`.
- Public/authenticated/admin surfaces: API `/api/healthz` is public; Discord bot commands are reachable by guild members unless explicit permission checks are present; `/annonce` is intended admin-only.
- Dev-only area usually ignored: `artifacts/mockup-sandbox/**` mounted under `/__mockup`.

## Threat Categories

### Spoofing

Discord role-based and command-level permissions must be enforced server-side inside the bot handlers, not only in command descriptions. Administrative or staff-only actions must verify the acting member's privileges at execution time.

### Tampering

Guild members must not be able to alter operational data or support workflows beyond their intended scope. Ticket management, mission logging, and announcement features must enforce authorization checks on every state-changing action.

### Information Disclosure

Ticket channels, logs, bot credentials, cookies, authorization headers, and any future database-backed data must not be exposed to unauthorized users, logs, or public channels. Error handling must avoid leaking stack traces or secret values.

### Denial of Service

Member-controlled bot features that call external services or create Discord resources must apply abuse controls. AI-triggering paths, ticket creation, and any expensive external calls must enforce rate limits, cooldowns, or equivalent throttling so a single guild member cannot exhaust credits or degrade service.

### Elevation of Privilege

Any feature that lets a guild member act on behalf of staff, create or close channels, send official announcements, or influence backend/external-service requests must validate authorization at the handler layer. Database access and future API expansion must continue using parameterized ORM queries and explicit authorization boundaries.
