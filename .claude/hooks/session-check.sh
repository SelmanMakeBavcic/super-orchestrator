#!/usr/bin/env bash
# session-check.sh - SessionStart injects the boot checklist + a drift warning; Stop nags when
# state sits uncommitted for hours (the handoff was not done). Reads no secrets, prints JSON only.
cd "$(dirname "$0")/../.." 2>/dev/null || exit 0
EVENT="${1:-stop}"
cont=$(ls -t plan/chats/CONTINUATION-*.md 2>/dev/null | head -1)
dirty=$(git status --porcelain -- state operating plan CLAUDE.md soul.md 2>/dev/null | wc -l | tr -d ' ')
last_commit_age_h=$(( ( $(date +%s) - $(git log -1 --format=%ct 2>/dev/null || echo 0) ) / 3600 ))
j() { python3 -c 'import json,sys;print(json.dumps(sys.stdin.read()))'; }
if [ "$EVENT" = "start" ]; then
  msg="Boot: read state/STATE.md, operating/workflow.md, then your tracker (the needs-you label = your inbox), then ${cont:-<no continuation file yet>}. Last commit ${last_commit_age_h}h ago."
  # First-run hint: if STATE.md still has template placeholders, point at onboarding.
  if grep -q '{{' state/STATE.md 2>/dev/null; then
    msg="This repo is not set up yet. Run /onboard to configure the workflow for your project."
  elif [ "$dirty" != "0" ]; then
    msg="$msg WARNING: $dirty uncommitted file(s) left by the previous session; reconcile (git status) before trusting any doc, and finish that session's close checklist first."
  fi
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}\n' "$(printf '%s' "$msg" | j)"
else
  [ "$dirty" = "0" ] && exit 0
  [ "$last_commit_age_h" -lt 3 ] && exit 0
  msg="Session-close check: $dirty uncommitted file(s) and no commit for ${last_commit_age_h}h. Before ending: update tracker issues, STATE.md, the continuation; then commit + pull --rebase + push (CLAUDE.md: Session boot and close)."
  printf '{"systemMessage":%s}\n' "$(printf '%s' "$msg" | j)"
fi
