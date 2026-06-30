---
name: research-to-decide
description: >-
  Research industry best-in-class practices and produce a decision-support
  artifact BEFORE building a feature or changing code. Use this whenever the
  user wants to know the best/SOTA way to do something before committing to an
  approach — phrases like "research best practices for X", "what's the
  industry standard for Y", "should we adopt Z", "how do ChatGPT/Perplexity/
  competitors do this", "audit how we do X and what's the best way", "explore
  options before we build", or any request that pairs "research" with a
  pending technical decision. Trigger even when the user doesn't say the word
  "skill" — if they're researching an approach before implementing, use this.
  Produces a published decision-support artifact (current-state map +
  methodology catalog with pros/cons + section-by-section recommendations +
  phased roadmap + explicit decision points), not a verdict. The user decides.
---

# research-to-decide

Run a disciplined **research-before-build** loop: map what exists today, research
what the field considers best-in-class, verify the facts, stress-test the plan
with a critic, and hand the user a decision-support artifact they can act on.

The output is **decision-support, not a verdict.** The user makes the call — your
job is to give them the evidence, the trade-offs, and a clear recommendation they
can overrule.

## Why this exists

Teams reach for the newest trick (or the loudest blog post) and over-build, or
they guess at "best practice" from stale training data. Both produce expensive
wrong turns. This loop forces three things that prevent that: grounding
recommendations in the *actual* current code, in *current* external evidence
(verified, not remembered), and in a *critic pass* before anything is declared.

## The loop

Work the phases in order. Each phase feeds the next. Use a TODO item per phase.

### Phase 1 — Scope & ground

Before any research, understand the problem and the ground you stand on.

- Pin the **one concrete question** the research must answer and the surfaces it
  touches. If it's fuzzy, ask the user 1–2 clarifying questions — scope creep here
  wastes the whole loop.
- Read the project's stack: dependency files, README, the modules the change
  touches. (If the `leverage-init` skill exists, run it.) Recommendations that
  conflict with what's installed or already-chosen are noise.
- Decide breadth: how many research/audit angles, and whether a current-state
  codebase audit is needed (usually yes; skip only for greenfield).

### Phase 2 — Map the current state (parallel subagents, read-only)

Fan out subagents to trace how the relevant subsystem works **today**, end to end.
This is read-only reconnaissance — no edits.

- One agent per coherent slice (e.g. one per surface/module/data-path). Have each
  trace the real flow and report with **file:line** references, exact values
  (models, params, sizes), and the gaps it sees.
- Spawn them in a single turn so they run concurrently. Prefer direct parallel
  subagents over a heavier orchestration tool unless the user asks otherwise.
- When they return, **reconcile conflicts between agents by reading the source
  yourself** — two agents will sometimes disagree on a fact; resolve it, don't
  average it.

The goal: a verified current-state map so every recommendation rests on what's
actually there, not on assumptions.

### Phase 3 — Research the field (parallel subagents, web)

Fan out a second wave to research best-in-class practice. Each agent owns a
dimension of the problem and searches widely: **papers (arXiv), engineering
blogs, Hacker News, Reddit, X/practitioner writing, vendor docs.**

For every technique an agent surfaces, require:
- how it works (briefly), **PROS**, **CONS**, measured improvement (with source),
  implementation cost / latency, and an explicit **"applies to *our* stack &
  case? yes/no/maybe + why"** line.
- source URLs, and a flag on any number that is **vendor-self-reported** (a
  vendor's own benchmark is directional, not independent — say so).

Cover the dimensions the problem actually has. Also commission one agent on
**community/practitioner sentiment** — what people *ship and regret*, what's
hyped vs underrated. The gap between papers and production is where the real
decision lives.

### Phase 4 — Verify external facts yourself

**Do not trust a subagent's confident specifics about anything past your training
cutoff** — model versions, prices, API names, current SOTA. Subagents confabulate
confident detail. For any fact a recommendation *rests on* (a vendor model name, a
price, "X is now the latest"), **fetch the live source yourself** and confirm
before stating it as fact. If you can't verify, hedge explicitly.

### Phase 5 — Critic pass

Before building the artifact, get the synthesis plan reviewed. Lay out your draft
recommendation (what to do, what to skip, the phasing) and call the strongest
reviewer available (the `advisor` tool if present, otherwise spawn a critic
subagent with the full context). Apply what holds; surface genuine conflicts back
to the user rather than silently switching.

Common things a critic catches here: an unverified external fact, a roadmap that
can't be measured, over-building from overlapping options, a recommendation stated
as a verdict when the user wanted options.

### Phase 6 — Build the decision-support artifact

Synthesize everything into a published artifact. Load the `artifact-design` skill
for treatment, then build (see structure below). Write it as decision-support: the
user reads it and decides.

### Phase 7 — Hand off

Summarize the headline findings and the open decisions. Offer to turn the chosen
option into an implementation plan. Don't start building the feature unless asked —
the point of this loop is to inform the decision, not pre-empt it.

## Principles that make the output good

These are the difference between a useful decision doc and a glossy survey:

- **Decision-support, not a verdict.** Even for techniques you recommend skipping,
  keep their pros visible so the user can overrule. You're informing a choice, not
  announcing one.
- **Ground every recommendation in the actual stack and current code.** "Use X"
  is weak; "Use X — you already run Y, it's a drop-in at file:line, here's the
  measured gain" is decision-grade.
- **Mark overlapping options PICK-ONE.** When three techniques solve the same
  problem at different cost, say so and recommend one — otherwise the user
  over-builds all three.
- **Lead the roadmap with measurement.** If there's no way to tell whether a change
  helped, every later recommendation is unfalsifiable. Put eval / a baseline first
  and gate each phase behind "can we measure this before the next?".
- **Flag vendor-self-reported numbers** and separate "consensus best practice" from
  "contested" from "hyped/overrated." Practitioners regret different things than
  papers celebrate.
- **Sequence by value-per-effort, not by excitement.** Correctness fixes and the
  single highest-ROI gap come before the impressive-but-heavy rebuilds.

## Artifact structure

Adapt to the subject, but this skeleton serves most research-to-decide outputs.
See `references/artifact-structure.md` for a fuller template and section notes.

```
1. How to read this        — it's decision-support; verdict legend (recommend /
                             phase-later / skip-with-reason / pick-one); fact-flags
2. Field consensus         — what the field actually agrees on vs contests vs hypes
3. Methodology catalog     — one card per technique: PROS / CONS / verdict /
                             "fit for us + why". Group by dimension.
4. Section-by-section plan  — each part of OUR system: current state → recommended
                             change → why. The core deliverable.
5. Phased roadmap          — eval/measurement first, then by value-per-effort
6. Decisions for the user   — the explicit open choices only they can make
```

## Subagent prompt patterns

See `references/subagent-prompts.md` for copy-ready templates for the audit agents
(Phase 2) and research agents (Phase 3), including the required PROS/CONS +
"applies to us" + source-URL + vendor-flag format.

## Adapting the loop

Match effort to the decision. A localized choice needs one research agent and a
short doc; a foundational, hard-to-reverse one (a framework, a schema, a vendor)
earns the full fan-out and the critic pass. The phases are a reflex, not a
ceremony — but never skip Phase 4 (verify) or Phase 5 (critic) on a decision that
locks in a contract, because those are exactly where confident-but-wrong slips
through.
