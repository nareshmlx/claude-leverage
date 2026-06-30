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

**Before committing to an approach** (`research-to-decide`): When the open question is *how*
to do something (methodology, not just which library), researches best-in-class practices,
verifies against current evidence, and hands you a decision-support artifact — current-state
map + options with pros/cons + recommendation + phased roadmap. You make the call.

---

## install

### Claude Code — plugin (recommended)
This repo is a self-contained Claude Code plugin + its own marketplace. The 3 skills
auto-discover from `skills/`.

```bash
/plugin marketplace add nareshmlx/claude-leverage
/plugin install leverage@leverage
/reload-plugins
```
Run `/doctor` to confirm 0 plugin errors.

**Updating later** — the install cache is keyed by version, so a marketplace refresh alone
won't replace the installed copy; reinstall:
```bash
/plugin marketplace update leverage
/plugin uninstall leverage@leverage
/plugin install leverage@leverage
/reload-plugins
```
> Forking your own copy? Edit `author` + repo URL in `.claude-plugin/plugin.json` and
> `marketplace.json`, push, then `/plugin marketplace add <your-org>/<repo>`.

> **Don't also manual-copy the skills** (below) if you installed the plugin — you'll get
> duplicate entries in the skill menu. Pick one method.

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

## usage — step by step

After install the skills fire **automatically on intent** — no slash command needed.
Just talk normally; they trigger on what you're doing.

**0. Deciding *how* to do something (approach unclear) → `research-to-decide`**
Purpose: research the best-in-class approach before committing, when the question is
methodology — not just which library. Say *"research best practices for X"*, *"what's the
industry standard for Y"*, *"should we adopt Z"*. Produces a decision-support artifact (you decide).

**1. Starting on a project → `leverage-init`**
Purpose: map your stack so nothing gets recommended that you already have.
Say *"read my project"* / *"understand my stack"* (or it auto-runs each session via the
SessionStart hook). It reports language, framework, installed deps, and integrations.

**2. About to build a feature → `leverage`**
Purpose: find the existing library/SDK/API instead of writing custom code.
Just describe the feature — *"add login"*, *"I need file uploads"*, *"how do I send email"*.
It returns the standard tool for that domain, whether it's already installed, and the
minimal integration snippet.

**3. Cleaning up existing code → `leverage-scan`**
Purpose: spot where you reinvented something a library already does.
Say *"audit dependencies"* / *"what am I reinventing"* (or `/leverage-scan`). It returns a
findings list — it never edits your code.

**One-liner:** open approach → `research-to-decide` · new project → `init` · new feature → `leverage` · old code → `scan`.

Every recommendation is **tiered**: **★ standard** (the safe default you get automatically) ·
**◆ newer-proven** · **⚡ cutting-edge** · **⚠️ avoid**. Ask for *"the newer / advanced option"*
to get the ◆/⚡ picks.

| Skill | Use when | Purpose |
|-------|----------|---------|
| `research-to-decide` | Approach/methodology is the open question | Research best practice → decision-support artifact |
| `leverage-init` | Starting on a project (once) | Detect stack + what's installed |
| `leverage` | Before building any feature | Find the existing solution, tiered |
| `leverage-scan` | Reviewing existing code | List reinvented wheels (no edits) |

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
