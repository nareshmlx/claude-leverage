---
name: leverage-init
description: >
  Use this skill to map a project's stack before giving any tool recommendation — it reads
  the dependency files (package.json, requirements.txt, pyproject.toml, go.mod, etc.), the
  README, and the directory structure to build a context map of the language/framework,
  what's already installed, what the project does, and which domains will come up. Best run
  once at the start of work on a project. Use when the user says "leverage init",
  "/leverage-init", "read my project", "understand my stack", or "what's in my project", or
  before the `leverage` skill recommends anything on an unfamiliar codebase.
---

# leverage-init — read the project before making any recommendation

Run this once at the start of a session. It grounds all `leverage` recommendations
in what the project actually has, not in generic assumptions.

---

## what to read

Read all of these that exist (skip gracefully if missing):

```
package.json              → JS/TS stack, framework, installed libs
package-lock.json         → exact versions (skip — package.json is enough)
requirements.txt          → Python deps
pyproject.toml            → Python deps (Poetry / PDM)
Pipfile                   → Python deps (Pipenv)
go.mod                    → Go modules
Cargo.toml                → Rust crates
Gemfile                   → Ruby gems
composer.json             → PHP deps

README.md                 → what the project does, tech decisions
CLAUDE.md                 → agent context, constraints, preferences
.env.example              → what services are integrated (Stripe key? Sentry DSN? etc.)
docker-compose.yml        → what infrastructure is running (Redis? Postgres? etc.)
src/ or app/ structure    → what patterns are already established
```

---

## what to extract

From the above, build a mental context block:

```
PROJECT CONTEXT
---------------
language/runtime : {Python 3.11 / Node 20 / Go 1.22 / ...}
framework        : {FastAPI / Next.js 14 / Express / Django / ...}
database         : {PostgreSQL / MySQL / MongoDB / SQLite / ...}
orm              : {SQLAlchemy / Prisma / Drizzle / Django ORM / ...}
already installed: [list every dep name — no descriptions needed]
infra (from compose/env): [Redis? Postgres? Kafka? etc.]
project type     : {SaaS / API / internal tool / mobile backend / ...}
integrations     : [Stripe? Sentry? SendGrid? anything in .env.example]
```

---

## output after init

Print this block clearly so the agent and user can verify it:

```
[leverage-init] project context loaded

stack       : {language} + {framework}
db          : {database + ORM}
installed   : {count} packages — {comma-separated list of notable ones}
infra       : {Redis, Postgres, etc. from compose/env}
integrations: {external services detected}
type        : {what this project does}

leverage is ready. Every feature request will check this context
before suggesting any new library or dependency.
```

---

## what this enables

After init, the `leverage` skill:
- Will NEVER suggest installing something already in the lockfile
- Will NEVER suggest a library that conflicts with the current framework
- Will prefer the patterns already established in the project
- Will know if Redis is already running (cache → Redis, not a new service)
- Will know if Stripe is already wired (payments → Stripe, not "consider Stripe")

---

## when to re-run

- New project, new session
- After major dependency changes (added a new framework, migrated DB, etc.)
- When `leverage` recommendations feel off — run init to reset context
