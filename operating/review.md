# operating/review.md — the independent-review discipline

_Every serious defect in a codebase is found by a reviewer who did not write the code. Review is not
a courtesy; it is where the quality comes from. This is the default gate for this workflow._

## The rule

For anything non-trivial, a **read-only reviewer that did not write the code** reviews the branch
diff before it lands — even to `dev`. Tests-green is not sufficient to merge. `dev` is where
regressions and defects first land and where QA runs, so a broken `dev` is a real cost.

In practice: run `/code-review` (and `/security-review` for gated changes) as an independent agent on
the two-dot diff, or dispatch a fresh subagent with no memory of writing the code. The author never
reviews their own work.

## Order and shape

Review **before** the full gate, never in parallel with it:

```
targeted tests → review → fixes on the branch → one full gate on the merged tree
```

The `REVIEW` comment on the tracker issue carries three named lines, each with a verdict. A review
missing any of them is not a review, and the Lander does not land on it:

- **`Security:`** — fail-closed, egress gated, secrets never in a log/commit/tracker, auth intact.
- **`Correctness:`** — tested at the level it runs; the named behaviour actually exercised; every
  writer of a changed value checked; the served artifact verified.
- **`Quality-bar:`** — your bar from `soul.md` (e.g. accessible, fast, simple over clever, scalable).

Each is a verdict, not a description. `n/a` is allowed only with a reason.

## Two axes plus security

- **Standards** — does the code follow this repo's documented conventions and patterns?
- **Spec** — does the code do what the originating issue asked for, no more and no less?
- **Security + quality-bar** — the three named lines above.

Run Standards and Spec as independent passes (they catch different things), then the security/quality
pass. For a big change, fan them out to parallel reviewers and merge the findings.

## What blocks vs what is noted

- **Blocking:** a security hole, a correctness defect, a spec miss, a violation of the quality bar.
  These are fixed on the same branch before the gate.
- **Should-fix:** style, naming, a smaller/simpler alternative. Noted; fixed now if cheap, else filed
  as its own ticket.

Never let a "should-fix" become a reason to hold a correct change; never let a "blocking" through
because the change is otherwise nice.

## Receiving review feedback

Verify each point technically before implementing it — a reviewer can be wrong. Do not perform
agreement; either the point is correct (fix it) or it is not (say why, once). Silent compliance with
a wrong suggestion is its own defect.
