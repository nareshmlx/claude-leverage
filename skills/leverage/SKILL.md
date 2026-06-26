---
name: leverage
description: >
  Use this skill before implementing ANY feature, function, module, or piece of logic —
  it finds an existing library, wrapper, SDK, or API that already solves the problem
  instead of writing custom code. Use whenever the user wants to add, build, implement,
  create, set up, or wire up functionality, or asks "how do I X" / "I need X" — even when
  they don't name a library. Covers payments, auth, email, storage, caching, queues,
  search, real-time, AI/LLM, validation, UI, testing, and deploy, across any tech stack
  (Node/TS, Python, and more).
---

# leverage — find the existing solution before writing code

The rule is simple: **the best code is the code someone else already wrote, tested, and maintains.**

Every session, every task, no exceptions.

---

## step 0 — read the project first (do this once per session)

Before making any recommendation, read:
- `package.json` → detect Node/JS/TS stack, frameworks, already-installed libs
- `requirements.txt` / `pyproject.toml` / `Pipfile` → detect Python stack
- `go.mod` → Go stack
- `Cargo.toml` → Rust stack
- `Gemfile` → Ruby stack
- `composer.json` → PHP stack
- `README.md`, `CLAUDE.md`, `.env.example` → understand project purpose and integrations
- Any existing `src/` or `app/` structure → understand patterns already in use

Build a mental model:
- What language / framework is this?
- What is already installed? (never suggest something already there)
- What is this project trying to do? (payments app, SaaS, API, internal tool, etc.)

---

## step 1 — the lookup ladder (run for EVERY feature request)

```
1. Already in the codebase?              → use it (search before suggesting anything)
2. Already installed (dep files)?        → use it (never add a dup)
3. Platform / stdlib covers it?          → use it (no dep needed)
4. A SOTA tool exists?                   → use the ★ STANDARD pick below (add the dep, show usage)
5. Only then: write the minimum custom code possible
```

---

## step 2 — domain lookup table (tiered — as of 2026-06)

For each request, identify the domain and look up the SOTA solution for the detected stack.

Default to the **★ STANDARD** pick: boring, maintained, safe — one per domain. Offer **◆ newer-proven** or **⚡ cutting-edge** only when the user asks or ★ doesn't fit, and name the trade-off. **⚠️ = avoid / declining**, never for new work.

Legend: **★** standard default · **◆** newer-proven · **⚡** cutting-edge · **⚠️** avoid. Tool names + tiers only — pin exact versions from the live registry at use time.

### 💳 Payments & Billing
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| payments, checkout, subscriptions | ★ `stripe`<br>◆ `polar` / `paddle` (MoR) | ★ `stripe`<br>◆ `paddle` | Stripe default; polar/paddle = merchant-of-record. ⚠️ lemonsqueezy (folding into Stripe) |
| usage-based billing | ★ `stripe` metered billing<br>◆ `orb` | ★ `stripe`<br>◆ `orb-billing` | |
| invoicing | ★ `stripe` | ★ `stripe` | |
| crypto payments | `coinbase-commerce` | `coinbase-commerce` | |

### 📧 Email & Notifications
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| transactional email | ★ `resend`<br>◆ `postmark` (deliverability) | ★ `resend`<br>◆ `postmarker` | Resend is modern/dev-friendly. ⚠️ sendgrid (legacy, free tier gone) |
| email templates | ★ `react-email`<br>◆ `mjml` | ★ `mjml`<br>◆ `jinja2` + premailer | |
| SMS | ★ `twilio`<br>◆ `plivo` / `telnyx` | ★ `twilio` | |
| push notifications | ★ `web-push`<br>◆ `firebase-admin` (FCM) | ★ `pywebpush`<br>◆ `firebase-admin` | |
| in-app / multi-channel notifications | ★ `knock`<br>◆ `novu` (self-host) | ★ `knock-api`<br>◆ `novu-py` | open-source notification infra |
| webhooks (send + verify) | ★ `svix` | ★ `svix` | |

### 🔐 Auth & Identity
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| full auth (login, social, MFA) | ★ `clerk`<br>◆ `better-auth` (self-host)<br>⚠️ next-auth/Auth.js | ★ `authlib` + FastAPI Security<br>◆ `supabase` auth | Clerk for zero-config; better-auth for self-host |
| JWT | ★ `jose` | ★ `PyJWT`<br>◆ `authlib`<br>⚠️ python-jose | python-jose: stale + CVE history |
| OAuth2 | ★ `arctic` / clerk | ★ `authlib` | |
| password hashing | ★ `bcrypt` | ★ `passlib` / `argon2-cffi` | |
| session management | ★ `iron-session` | FastAPI sessions | |
| authz / RBAC / permissions | ★ `oso` / `cerbos`<br>◆ `openfga` (ReBAC) | ★ `oso` / `cerbos-sdk-python`<br>◆ `openfga-sdk` | policy-as-data; don't hand-roll roles |
| secrets management | ★ `doppler`<br>◆ `infisical` | same | ⚠️ vault (BSL relicense) |
| captcha / bot protection | ★ cloudflare `turnstile`<br>◆ `hcaptcha` | ★ turnstile verify (`httpx`)<br>◆ `hcaptcha` | |
| SSO / enterprise auth | ★ `workos` | ★ `workos` | |

### 🗄️ Database & Storage
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| hosted Postgres | ★ supabase / neon<br>◆ turso (libsql edge)<br>⚠️ planetscale (no free tier) | same | serverless PG; pick by project need |
| ORM | ★ `prisma`<br>◆ `drizzle` (edge/serverless) | ★ `sqlalchemy` async<br>◆ `sqlmodel` | Drizzle for type-safe; Prisma for DX |
| migrations | ★ `prisma migrate` / `drizzle-kit` | ★ `alembic` | |
| file / object storage | ★ S3 SDK / Cloudflare R2<br>◆ `uploadthing` (TS DX) | ★ `boto3` (S3/R2) | R2 = no egress fees; uploadthing for easy |
| image processing | ★ `sharp` | ★ `Pillow`<br>◆ `pyvips` | |
| image CDN | ★ `cloudinary`<br>◆ cloudflare images | ★ `cloudinary` | |
| local file upload | ★ uploadthing / Next.js native<br>◆ `uppy` + tus (resumable) | ★ `python-multipart` + FastAPI | |
| key-value / cache | ★ `ioredis`<br>◆ `@upstash/redis` (serverless) | ★ `redis` (`redis.asyncio`)<br>⚠️ aioredis | aioredis dead since 2021, merged into redis-py. Upstash for serverless |
| in-memory cache | stdlib `Map` with TTL | `functools.lru_cache` | zero deps for simple cases |

### 🔍 Search
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| full-text search | ★ `meilisearch` (OSS) / `algolia` (managed)<br>◆ `typesense` | same | both self-hostable and fast |
| managed search | ★ `algoliasearch` | ★ `algoliasearch` | SaaS, generous free tier |
| vector / semantic search | ★ pgvector (have PG) / `pinecone` (managed)<br>◆ `qdrant` (OSS)<br>⚡ `turbopuffer` / `lancedb` | same | pgvector if already on Postgres |
| hybrid search | ★ pgvector with `tsvector` | ★ pgvector | use what's already there |

### ⚡ Background Jobs & Queues
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| job queue | ★ `bullmq`<br>◆ inngest / trigger.dev<br>⚡ temporal | ★ `celery`<br>◆ `arq` / `dramatiq`<br>⚡ temporal | BullMQ on Redis; arq for async Python |
| scheduled / cron jobs | ★ platform cron (vercel/cf)<br>◆ inngest | ★ `apscheduler`<br>◆ celery beat | |
| workflow / durable exec | ★ `inngest`<br>◆ trigger.dev<br>⚡ temporal | ★ temporal<br>◆ prefect | event-driven, managed, no infra |
| retry logic | ★ `ky` built-in / `p-retry` | ★ `tenacity` | |

### 📡 Real-time & Streaming
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| websockets | ★ socket.io / native WS<br>⚡ partykit (CF DO) | ★ `websockets` / django-channels | |
| server-sent events | ★ native `EventSource` | ★ `sse-starlette` | |
| real-time pub/sub | ★ `pusher` / `ably`<br>◆ liveblocks (CRDT) | ★ pusher/ably SDK | Supabase Realtime if on Supabase |
| live collaboration | ★ `liveblocks` | via REST API | |

### 🤖 AI & LLM
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| LLM calls (any model) | ★ Vercel AI SDK (`ai`)<br>◆ openai/anthropic SDK direct | ★ `litellm`<br>◆ openai/anthropic SDK<br>⚡ bifrost | unified interface, model-agnostic |
| agent / tool-use | ★ `mastra`<br>◆ langgraph.js / AI SDK agents | ★ `langgraph`<br>◆ pydantic-ai / crewai<br>⚡ agno | langgraph is the Python default |
| embeddings | ★ `openai` (text-embedding-3)<br>◆ voyageai / cohere | ★ `voyageai`<br>◆ cohere | |
| vector store | ★ `pinecone` / pgvector | same | |
| LLM observability / evals | ★ `langfuse` (OSS) / langsmith<br>◆ braintrust / helicone | ★ `langfuse` | |
| AI UI components | ★ `ai` SDK `useChat` | via REST | |

### 📊 Analytics & Monitoring
Self-host observability stack = **Grafana + OpenTelemetry**, one tool per signal: metrics→`prometheus` · logs→`loki` · traces→`tempo` · profiles→`pyroscope` · errors→`sentry` · dashboards→`grafana`. Instrument once with OTel, swap backends freely.

| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| product analytics | ★ `posthog-js`<br>◆ plausible (privacy web) | ★ `posthog-python`<br>◆ plausible | ⚠️ june (shut down) |
| error tracking | ★ `@sentry/nextjs` | ★ `sentry-sdk` | |
| logging | ★ `pino` → loki | ★ `structlog` → loki<br>◆ loguru | aggregate to Loki |
| metrics / tracing | ★ `prometheus` + `opentelemetry` → tempo | ★ `prometheus-client` + `opentelemetry-sdk` | OTel = vendor-neutral |
| profiling (continuous) | ★ grafana `pyroscope` | ★ `pyroscope-io`<br>◆ py-spy (ad-hoc) | |
| dashboards / uptime | ★ `grafana` / betterstack<br>◆ checkly (as-code) | same | |
| feature flags | ★ `openfeature` spec → unleash (OSS) / launchdarkly / posthog<br>◆ flipt | ★ `openfeature` + unleash-client | wrap in OpenFeature, swap providers freely |

### 🌐 HTTP & API
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| HTTP client | ★ `ky` (fetch + retry)<br>◆ native fetch (Node 20+) | ★ `httpx` (async) | ky is modern; httpx for async Python |
| API validation | ★ `zod` | ★ `pydantic` | already in most projects |
| type-safe API across the wire | ★ `trpc` (TS-only) | FastAPI auto-emits OpenAPI → codegen TS client: ★ `orval` (react-query hooks) · ◆ `@hey-api/openapi-ts` | trpc can't cross to Python; for FastAPI backend, codegen the TS client from OpenAPI. Re-run on schema change |
| rate limiting | ★ `@upstash/ratelimit`<br>◆ rate-limiter-flexible | ★ `slowapi`<br>◆ upstash-ratelimit | |
| security headers / CSP | ★ `helmet` / next middleware<br>◆ @next-safe/middleware | ★ `secure` / django SecurityMiddleware | never ship without CSP |
| API mocking (dev) | ★ `msw` | ★ `respx` | |
| cron / scheduled API | ★ Vercel Cron, GitHub Actions | ★ APScheduler | |

### 🎨 Frontend UI
| Domain | Node/TS/React | Notes |
|--------|---------------|-------|
| component library | ★ `shadcn/ui` (Radix)<br>⚡ Base UI | unstyled + accessible; best default |
| styling | ★ `tailwindcss`<br>⚠️ runtime CSS-in-JS (emotion/styled-components) | utility-first |
| forms | ★ `react-hook-form` + `zod`<br>◆ @tanstack/react-form | don't use controlled inputs manually |
| data tables | ★ `@tanstack/react-table`<br>◆ ag-grid (enterprise) | headless, composable |
| data fetching | ★ `@tanstack/react-query`<br>◆ swr | always; not manual useEffect fetch |
| state (global) | ★ `zustand`<br>◆ jotai<br>⚠️ Redux (enterprise/legacy only) | simple; reach for Redux only at team scale |
| date/time display | ★ `date-fns`<br>⚡ Temporal API (polyfill)<br>⚠️ moment.js | moment is dead (bloat, no tree-shake) |
| charts | ★ `recharts`<br>◆ echarts / visx | simple; visx/d3 for custom |
| rich text editor | ★ `tiptap`<br>◆ lexical / blocknote | extensible, modern |
| drag and drop | ★ `@dnd-kit`<br>◆ pragmatic-drag-and-drop (momentum)<br>⚠️ react-beautiful-dnd | dnd-kit replaces the old react-dnd / react-beautiful-dnd |
| animation / motion | ★ `motion` (was framer-motion)<br>◆ gsap (now free) | |
| icons | ★ `lucide-react`<br>◆ @tabler/icons-react | |
| virtual lists | ★ `@tanstack/react-virtual` | for large lists |
| modals / toasts / cmd-k | ★ shadcn Dialog / `sonner` / `cmdk` | shadcn `toast` deprecated → sonner |
| maps | ★ `maplibre-gl` + react-map-gl<br>◆ mapbox-gl / leaflet<br>⚡ deck.gl | maplibre = open-source default |

### 📄 Documents & Files
| Domain | Node/TS | Python | Notes |
|--------|---------|--------|-------|
| PDF generation | ★ `@react-pdf/renderer`<br>◆ puppeteer/playwright (charts/SPA) | ★ `weasyprint`<br>◆ playwright | |
| HTML → PDF | ★ `puppeteer` | ★ `playwright` | |
| PDF parsing | ★ `unpdf`<br>◆ pdfjs-dist<br>⚠️ pdf-parse | ★ `pdfplumber`<br>◆ docling / unstructured (RAG) | pdf-parse unmaintained |
| Excel read/write | ★ `exceljs`<br>⚠️ xlsx (SheetJS) | ★ `openpyxl`<br>◆ polars (data/perf) | xlsx npm build ships unpatched CVE-2023-30533 (CDN build only) |
| CSV | ★ native `csv` module | ★ `csv` stdlib or `polars`/`pandas` | |
| Markdown → HTML | ★ `marked` / `remark` | ★ `mistune` / `markdown` | |
| Word docs | ★ `docx` | ★ `python-docx` | |

### 🔧 Validation & Schema
| Domain | Node/TS | Python |
|--------|---------|--------|
| schema validation | ★ `zod`<br>◆ valibot / arktype | ★ `pydantic`<br>◆ msgspec |
| environment variables | ★ `@t3-oss/env` + `zod` | ★ `pydantic-settings` |
| date validation | ★ `zod` + `date-fns` | ★ `pydantic` + `pendulum` |

### 🧪 Testing
| Domain | Node/TS | Python |
|--------|---------|--------|
| unit tests | ★ `vitest`<br>◆ jest (legacy/large) | ★ `pytest` |
| component tests | ★ `@testing-library/react` | |
| E2E tests | ★ `playwright`<br>⚠️ cypress (declining, no WebKit) | ★ `playwright` |
| HTTP mocking | ★ `msw` | ★ `respx` |
| snapshot tests | ★ `vitest` | ★ `syrupy` |

---

## step 2.5 — stack recipe: Next.js + FastAPI (common default split)

When the project is **Next.js (frontend) + FastAPI (backend)**, read the **Node/TS** column
for the frontend and the **Python** column for the backend. The cross-boundary seams that
trip people up:

- **Type safety across the wire** — tRPC is TS-only, skip it. FastAPI auto-emits OpenAPI →
  codegen a typed TS client: ★ `orval` (generates @tanstack/react-query hooks) ·
  ◆ `@hey-api/openapi-ts` · `openapi-typescript` + `openapi-fetch`. Re-run on schema change.
- **Validation** — `zod` (Next) + `pydantic` (FastAPI). Standard Schema does NOT cross
  languages, so pydantic is the source of truth — codegen the TS types from OpenAPI, don't
  hand-duplicate.
- **Auth** — ★ clerk (Next issues the session) → verify the JWT in FastAPI with `jose` /
  `PyJWT`; or ◆ better-auth / supabase auth. Don't reinvent auth on the Python side.
- **Data fetch** — @tanstack/react-query (Next) → FastAPI REST; orval wires the hooks.
- **Realtime** — FastAPI native WebSocket for simple cases; ◆ pusher / ably (managed,
  language-agnostic) beyond that.
- **Background work** — celery / arq on the FastAPI side (Python column), not bullmq.
- **Deploy** — two targets: Next → vercel · FastAPI → render / railway / fly (⚡ modal for
  ML). Watch CORS + a shared auth domain.

---

## step 3 — output format (always use this)

```
[leverage]
intent    : {what was asked, in one line}
domain    : {payments / auth / search / queue / ...}
solution  : {library or service name}
installed : yes | no
install   : {pip install X / npm install X — omit if already installed}
why       : {one sentence — why this over rolling your own}

{minimal setup/usage snippet — only the relevant lines, no boilerplate}
```

If the request is genuinely novel with no standard solution:
```
[leverage]
intent    : {what was asked}
domain    : custom
solution  : none found — writing minimum custom code
```

---

## rules that don't bend

1. **Never implement from scratch what a SOTA library handles.** Payments, auth, email, file upload, queuing, real-time, search — these are all solved problems.
2. **Check installed deps first.** Never add a duplicate. Never suggest installing something already in the lockfile.
3. **Default to the ★ STANDARD pick** — boring, maintained, widely-used (10k+ stars, recent commits). One ★ per domain.
4. **◆ newer-proven / ⚡ cutting-edge are deliberate opt-ins.** Reach for them only on request or when ★ clearly doesn't fit, and name the trade-off. **Never recommend ⚠️ for new work** (declining, unmaintained, or carries a security/CVE history).
5. **One tool per domain.** Don't pull in two form libraries, two HTTP clients, two date libraries.
6. **Serverless vs self-hosted awareness.** If the project is on Vercel/serverless, prefer managed (Upstash, Vercel KV, Cloudflare) over self-hosted. If self-hosted, prefer open-source over paid SaaS.
7. **Security, validation, and error handling are never skipped** regardless of how minimal the implementation.
8. **Show the minimal integration.** Not a full tutorial. Just the few lines needed to plug it in.
9. **This file tracks choices, not versions** — pin the exact version from the live registry at use time (context7 / the package registry).

---

## not a library problem? reach for a skill or agent

Some needs have no package — a dedicated skill or subagent owns them. If the environment
has one available, prefer it over hand-rolling:

- **UI / design quality** → a frontend-design skill (e.g. `frontend-design` / `impeccable`)
- **Accessibility audit** → an accessibility-auditor agent (+ `axe-core` from the table)
- **Security / threat review** → a security-engineer agent or `/security-review`
- **Doc / PDF / PPTX / XLSX authoring** → the `docx` / `pdf` / `pptx` / `xlsx` skills
- **Live, version-accurate library docs** → the context7 MCP (`resolve-library-id` → `query-docs`)
- **Process discipline** (brainstorm / plan / TDD / debug) → the matching process skills (e.g. superpowers)
