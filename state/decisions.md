# decisions.md — the settled-decisions ledger

_Append-only. A decision here is settled: do not relitigate it. When a new decision reverses an old
one, add a new dated entry that says so; never edit the old line away._

Format: one entry per decision.

```
## YYYY-MM-DD — <short title>
**Decision:** <what was decided, one or two sentences>
**Why:** <the reason, so future-you does not reopen it>
**Reverses:** <the earlier decision this supersedes, if any>
```

---

## 2026-01-01 — adopted super-orchestrator
**Decision:** Use this pipeline (brainstorm → spec → tickets → build → independent review → QA →
land) with the tracker as the single backlog.
**Why:** more PRs, faster, at higher quality; independent review is where the quality comes from.
