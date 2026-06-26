# leverage

The canonical instructions for this project live in the **leverage skill**, not in this file:

- `skills/leverage/SKILL.md` — the lookup ladder, the tiered domain→tool tables (Node/TS +
  Python), the Next.js + FastAPI stack recipe, the output format, and the rules.
- `skills/leverage-init/SKILL.md` — read a project's stack before recommending anything.
- `skills/leverage-scan/SKILL.md` — audit a codebase for reinvented wheels.

`SKILL.md` is the **single source of truth** and the thing that ships in the plugin
(`.claude-plugin/`). A Claude Code plugin delivers skills / commands / agents / hooks / MCP —
it does **not** load a `CLAUDE.md` (CLAUDE.md is project/user memory, resolved by walking up
from the working directory; the plugin cache is never on that path). Duplicating the tool
tables here would only drift out of sync, so this file is intentionally a pointer.

**Working in this repo?** Follow `skills/leverage/SKILL.md`.
**Want leverage in your own projects?** Install it as a skill or plugin — see `README.md`.
