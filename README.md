# leverage

> Before writing a line, find the existing solution.

An AI agent skill that intercepts every feature request, reads your project context,
and recommends the best existing library, SDK, or API — before any custom code is written.
Works for any tech stack. Stack-aware from session start.

---

## how it works

**Session start** (`leverage-init`): Reads your `package.json` / `requirements.txt` / `.env.example` /
`docker-compose.yml` to understand your stack, framework, and what's already installed.

**Every feature request** (`leverage`): Before any implementation, looks up the best existing
tool for the domain — payments, auth, email, queuing, search, real-time, file storage, AI, etc.
Tells you: what to use, whether it's already installed, and the minimal integration code.

Every pick is **tiered** (as of 2026-06): **★ standard** (the boring, maintained default —
one per domain) · **◆ newer-proven** (younger, real production adoption) · **⚡ cutting-edge**
(early adopter) · **⚠️ avoid** (declining / unmaintained / CVE history). You get the safe
default by default, and the advanced alternatives only when you ask.

**On-demand audit** (`leverage-scan`): Points at any file or diff and returns a list of
custom code that a standard library handles better.

---

## install

### Claude Code — plugin (recommended, one command)
This repo is a self-contained Claude Code plugin (`.claude-plugin/plugin.json`) and its own
marketplace (`.claude-plugin/marketplace.json`). The 3 skills are auto-discovered from `skills/`.

```bash
# from a published git repo
/plugin marketplace add <your-org>/leverage
/plugin install leverage

# or from a local clone
/plugin marketplace add ./path/to/leverage
/plugin install leverage
```
> Publishing: push this repo to GitHub, then `/plugin marketplace add <org>/<repo>`. Update the
> `author`/`source` in `.claude-plugin/*.json` if your repo path differs.

### Claude Code — manual copy (skills only, no plugin)
User level (global — every project):
```bash
mkdir -p ~/.claude/skills
cp -r skills/leverage skills/leverage-init skills/leverage-scan ~/.claude/skills/
```
Project level (this repo only):
```bash
mkdir -p .claude/skills
cp -r skills/leverage skills/leverage-init skills/leverage-scan .claude/skills/
```

> The canonical content lives in `skills/leverage/SKILL.md`. The repo-root `CLAUDE.md` is
> just a pointer to it — a plugin never loads a `CLAUDE.md`, so the skill is the source of truth.

---

## commands

| Skill | When | What |
|-------|------|------|
| `leverage-init` | Session start | Read project, detect stack, build context |
| `leverage` | Every feature request | Find the existing solution |
| `leverage-scan` | On demand | Audit codebase for reinvented wheels |

---

## example

**You**: "I need to add email verification when users sign up"

**Without leverage** → agent writes custom SMTP code with token generation

**With leverage**:
```
[leverage]
intent    : send email verification on user signup
domain    : email (transactional)
solution  : resend
installed : no
install   : pip install resend

import resend

resend.api_key = os.environ["RESEND_API_KEY"]

resend.Emails.send({
  "from": "noreply@yourdomain.com",
  "to": user.email,
  "subject": "Verify your email",
  "html": f"<a href='{verification_url}'>Verify</a>"
})
```

---

## covered domains

payments · billing · subscriptions · email · email templating · SMS · push · webhooks · notifications ·
auth · JWT · OAuth · sessions · password hashing · authz/RBAC · secrets · captcha · security headers ·
file storage · upload · image processing · image CDN ·
database ORM · migrations · DB hosting · caching · rate limiting ·
background jobs · queuing · durable workflows · retries · scheduling ·
real-time · websockets · SSE · event streaming ·
search (FTS) · search (vector/semantic) · RAG ·
LLM calls · agents · embeddings · LLM observability/evals ·
error tracking · logging · metrics · tracing · profiling · dashboards · analytics · feature flags ·
HTTP clients · type-safe API (tRPC / OpenAPI codegen) · GraphQL · validation · env config ·
PDF · Excel · CSV · Markdown · rich text ·
i18n · date/time · charts · maps · icons · drag-drop · animation ·
UI components · styling · forms · data fetching · global state · tables ·
meta-framework · runtime/bundler · testing (unit · E2E · mocking) ·
deploy/hosting · containers · edge · IaC · CI/CD · CDN · monitoring

---

MIT
