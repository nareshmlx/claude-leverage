# Decision-support artifact structure

The deliverable is a published artifact the user reads to make a decision. Load
the `artifact-design` skill first for visual treatment. Below is the content
skeleton and what each section is for. Adapt to the subject — not every research
question needs all six, but the spine (catalog → our-system mapping → roadmap →
decisions) is what makes it decision-grade rather than a survey.

## Sections

### 1. How to read this
Set the frame: this is decision-support, the user decides. Define the verdict
legend used throughout, and the fact-flag convention.
- **Verdict legend:** RECOMMEND / PHASE-LATER / SKIP (with reason) / PICK-ONE.
- **Fact flag:** mark vendor-self-reported numbers inline (directional, not
  independent).
- **The one rule:** if relevant, lead with "measure on your own data first" —
  state whether measurement/eval exists today.

### 2. Field consensus
What the field actually agrees on, in one tight block. Separate **consensus best
practice** from **contested ("it depends")** from **overrated/hyped**. This is
where the community/sentiment agent's findings land. A short "the boring winner"
diagram of the convergent stack helps.

### 3. Methodology catalog
The pros/cons heart. One card per technique, grouped by dimension. Each card:
- name + verdict badge
- 1–2 sentence "how it works"
- **PROS** column / **CONS** column (keep CONS visible even on RECOMMEND items,
  and keep PROS visible even on SKIP items — the user can overrule)
- a "fit for *us*" line naming the specific surface/stack it applies to
- mark overlapping techniques as **PICK-ONE** with a recommended primary

### 4. Section-by-section plan
The core deliverable. For each part of *our* system: current state → recommended
change → why. A two-column (current / recommend) card per surface reads well.
Note which changes are foundational (flow to many surfaces) vs surface-local.

### 5. Phased roadmap
Sequenced so each phase is measurable before the next.
- **Phase 0 = eval/measurement** if none exists — the gate for everything.
- then by value-per-effort: correctness fixes + the #1 gap before heavy rebuilds.
- each phase: a short list of concrete items with file:line / model names where
  known.

### 6. Decisions for the user
The explicit open choices only they can make — the ones where evidence narrows it
but the call is theirs (cost vs completeness, migration windows, how aggressive to
go, what to invest in eval). State each as a question with the trade-off and your
recommendation.

## Build notes

- Cite sources (arXiv IDs, blog URLs) in a footnote; flag vendor numbers.
- If this artifact has a sibling (e.g. a current-state audit artifact), cross-link
  them and say which to read first.
- Keep it scannable: tables for comparisons, cards for techniques, a sticky nav for
  long docs. It's operated, not read top-to-bottom.
