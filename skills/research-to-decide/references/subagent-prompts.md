# Subagent prompt templates

Copy-ready prompts for the two fan-out waves. Spawn each wave in a single turn so
the agents run concurrently. Give each agent a narrow, named slice — overlap wastes
tokens and produces redundant reports.

## Phase 2 — current-state audit agent

One per coherent slice of the system (a surface, a module, a data path).

```
Map how <SLICE> works today, end to end, in <PROJECT>. Working dir: <ABS PATH>.

Read the actual files and follow every import/call in the chain — do not
summarize from names. Trace the real flow.

Report, with file:line for EVERY step:
1. Entry point (function + file:line)
2. <the specific steps this slice has — e.g. for retrieval: query prep, embed
   model + dims, retrieval method, fusion, rerank, context assembly, LLM call,
   citation tracing, caching>
3. Exact values: model names, parameters, sizes, top-k, thresholds
4. Branches/modes and what triggers each
5. Gaps / smells you see vs what good looks like

Return a step-by-step map with file:line throughout. State uncertainty explicitly
rather than guessing.
```

When the agents return, **reconcile any factual conflict by reading the source
yourself** — don't average two disagreeing reports.

## Phase 3 — SOTA research agent

One per dimension of the problem. Each searches widely and returns pros/cons.

```
Research best-in-class approaches to <DIMENSION> as of <CURRENT PERIOD>. Use web
search extensively: papers (arXiv), engineering blogs, Hacker News, Reddit,
X/practitioner writing, vendor docs. Cite URLs.

Target stack (be specific to it): <STACK — language, framework, db, key libs>.

For EACH technique:
(a) how it works in 2 sentences
(b) PROS
(c) CONS
(d) measured improvement — with source; FLAG any number that is the vendor's own
    benchmark (directional, not independent)
(e) implementation cost + latency impact
(f) explicit line: "applies to OUR stack & case? yes / no / maybe — why"

Cover: <list the specific techniques/sub-questions for this dimension>.

Return markdown: one section per technique with a clear PROS/CONS block, source
URLs, and the applies-to-us line. End with a ranked recommendation for our stack.
```

## Phase 3 — community/sentiment agent (always include one)

```
Research what practitioners ACTUALLY ship and regret for <TOPIC> as of <PERIOD> —
sentiment, not just papers. Find Reddit threads, X posts, Hacker News discussions,
engineering blogs. Cite URLs and representative quotes.

Separate findings into:
- CONSENSUS BEST PRACTICE (what people ship and don't regret)
- CONTESTED (genuine "it depends" disagreement)
- OVERRATED (concrete "we tried X, not worth it" reports)
- UNDERRATED (works better than its reputation)

Flag vendor blog posts as [VENDOR] so marketing isn't mistaken for practitioner
belief. Note any access limits (e.g. a site blocked the crawler) honestly.
```

## Notes

- If a research agent only sends an idle/finished notification without the report
  body, message it back and ask it to send the full findings.
- Keep each agent's scope to ~one report. If a dimension is huge, split it rather
  than asking one agent to cover everything shallowly.
