#!/usr/bin/env bash
# leverage — SessionStart hook.
# Injects a directive so every session starts in "find the existing solution" mode.
# This is the plugin-native way to make leverage-init / leverage behave as always-on
# (skills cannot self-fire at session start; a SessionStart hook can).

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "leverage plugin active. Before writing or recommending any library/SDK/API code this session: run the `leverage-init` skill once to map the project (read package.json / requirements.txt / pyproject.toml / go.mod / README / structure — note what is already installed). Then for every feature request, follow the `leverage` skill: check the codebase, then installed deps, then stdlib/platform, then a SOTA library, and only then write custom code. Prefer the standard pick per domain; do not reinvent solved problems."
  }
}
EOF
exit 0
