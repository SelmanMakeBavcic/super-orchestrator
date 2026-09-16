# operating/documentation.md — one source of truth per question

_The rule exists because two documents both claiming to be "the backlog" is how drift starts:
when two docs claim authority, neither has it, and both rot — because writing to one feels like
updating "the" doc._

## The failure this prevents

**A stale doc that claims authority is worse than no doc.** The cost is not the wasted read — it is
that work gets queued against fiction. It happens whenever a second file answers a question that
another file already owns.

## One question, one file

| Question | The ONLY home | Shape |
|---|---|---|
| How do I start a session? | `state/STATE.md` | The one boot doc. Never a second `NEW-SESSION.md`. |
| What is happening right now? | `state/STATE.md` | Rewritten **wholesale**, never appended. If it is long, it is wrong. |
| What is still open? | **the tracker** | THE backlog. Never a `BACKLOG.md` / `TODO.md` / `STATUS.md` beside it. |
| What did we settle? | `state/decisions.md` | Append-only ledger. Settled = do not relitigate. |
| Why does this capability work this way? | `knowledge/<capability>.md` | Durable reference, grep on demand. |
| What should this unit do? | the **tracker issue** (body = Agent Brief) | Long specs live in `plan/`. |
| How do we operate? | `operating/*.md` | this file + workflow, autonomy, verification, eye-test, review, linear, delegation. |

**Do not create a second file that answers a question already owned above.** If a doc is wrong, fix
that doc. Do not write a parallel one.

## `plan/` is for designs, not status

`plan/` holds **specs and runbooks** — durable documents about how a thing should be built. It is
**not** a status directory. Session-handoff / continuation documents are inherently ephemeral:
- **At most ONE continuation document exists at a time.** Writing a new one archives the old.
- A continuation may describe *what to do next*. It must not become the record of *what is open* —
  that belongs in the tracker, which the continuation links to.
- A spec whose work has fully shipped moves to an archive, with the durable knowledge extracted into
  `knowledge/` first.

## Verify before you write, not after

Every status line must be traceable to something live: a PR number, a file and symbol, a command
output. When reconciling, pull merged PRs and the real SHAs, and `grep` the code for the thing the
doc claims is missing — a doc saying "NOT built" is not evidence of anything. Prefer "OPEN — grepped
`X`, no hits" over "OPEN". Reading one doc to update another is what produces drift; do not do it.

## Never delete

Keep an archive folder as the never-delete vault. Superseded documents move there in a dated folder so
history stays recoverable and the working tree stays honest. `git mv`, never `rm`.
