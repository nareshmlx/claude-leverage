---
name: leverage-scan
description: >
  Use this skill to scan an existing codebase (or a specific file or diff) and list the
  places where custom code reinvents something an existing SOTA library, API, or SDK
  handles better — one line per finding. Use when the user says "scan for tools", "what am
  I reinventing", "leverage scan", "audit dependencies", "where am I over-building", or
  "/leverage-scan". Produces a list of opportunities only — it does NOT apply fixes.
---

# leverage-scan — find every solved problem you're solving again

Scan the provided code/file/diff. Return a flat findings list, then a summary.

---

## what to look for

Flag custom implementations in these categories:

**Auth & Security**
- Custom JWT encode/decode → `jose` (Node) / `PyJWT` (Python — not `python-jose`, it's stale with CVE history)
- Custom password hashing instead of `bcrypt` / `passlib`
- Manual OAuth flow when `authlib` / `next-auth` handles it
- Custom API key middleware when FastAPI Security / Express middleware covers it
- Hand-rolled permission / role / RBAC checks → `oso` / `cerbos` / `openfga`
- Manual request-count throttling → `@upstash/ratelimit` (Node) / `slowapi` (Python)
- Secrets hardcoded or read ad-hoc from env without a manager → `doppler` / `infisical`
- Custom webhook signature verify → `svix` / `standardwebhooks`

**HTTP & Networking**
- Manual `fetch` with retry loops → `ky` / `httpx` + `tenacity`
- Custom exponential backoff → `tenacity` / `backoff`
- Manual `urllib` / `http.client` when `httpx`/`requests` is installed

**Validation**
- Manual type-checking / if-statement validation → `zod` / `pydantic`
- Custom email regex → `pydantic EmailStr` / `zod.string().email()`
- Manual env var parsing → `pydantic-settings` / `@t3-oss/env`

**Data & Database**
- Manual SQL string building → ORM query builder
- Custom pagination logic → ORM `limit/offset` or keyset
- Manual connection pool → SQLAlchemy pool config
- Custom CSV parser → `csv` stdlib / `papaparse`
- Custom JSON file reader → stdlib `json`

**Queuing & Jobs**
- `threading.Thread` for background work → FastAPI `BackgroundTasks` / ARQ / BullMQ
- Manual `time.sleep` retry loop → `tenacity` / `bullmq` retries
- Custom scheduler → `apscheduler` / `node-cron`

**Caching**
- Custom in-memory dict with manual TTL → `functools.lru_cache` / Redis (`redis.asyncio` — not `aioredis`, merged into `redis`)
- Manual cache invalidation logic → Redis with `ex=` TTL

**File & Storage**
- Custom file upload handler → `uploadthing` / `python-multipart` (already in FastAPI)
- Manual S3 presigned URL generation → AWS SDK helpers

**Email & Notifications**
- Custom SMTP client → `resend`
- Manual email template string builder → `react-email` / Jinja2 templates

**Frontend**
- Manual `useEffect` + `fetch` for data → `@tanstack/react-query`
- Manual form state with `useState` → `react-hook-form`
- `localStorage` for global state → `zustand`
- Custom debounce implementation → `use-debounce`
- Custom date formatting → `date-fns` (or the native Temporal API as the forward path)
- Custom modal logic → shadcn/ui Dialog (Radix)
- Hand-written fetch wrappers mirroring backend types → generate from OpenAPI (`orval` / `@hey-api/openapi-ts`) when backend is FastAPI; `trpc` when full-TS

---

## output format

One line per finding:

```
{file}:L{line}  [{tag}]  {what custom code does}  →  use {tool} ({installed: yes/no})
```

Tags:
- `[swap]` — direct drop-in, no logic change needed
- `[refactor]` — tool exists but requires a small restructure
- `[consider]` — tool applies, but verify there isn't a reason for the custom code

Example output:
```
auth/tokens.py:L12-44   [swap]     custom JWT sign/verify         → PyJWT (installed: yes)
workers/send_email.py:L8 [swap]    manual smtplib.SMTP client     → resend SDK (installed: no — pip install resend)
frontend/Form.tsx:L1-80  [swap]    manual useState form handling  → react-hook-form (installed: no — npm i react-hook-form)
api/users.py:L33         [swap]    time.sleep retry loop          → tenacity (installed: no — pip install tenacity)
utils/cache.py:L1-50     [refactor] dict-based cache with TTL     → Redis already running
components/Table.tsx     [refactor] custom sort/filter/pagination → @tanstack/react-table (installed: no)
db/search.py:L22         [consider] custom LIKE search            → pg_trgm (verify PG extension enabled)
```

End with:
```
{N} findings: {swap count} direct swaps · {refactor count} refactors · {consider count} to verify
estimated impact: ~{N} files, ~{LOC} lines removable
```
