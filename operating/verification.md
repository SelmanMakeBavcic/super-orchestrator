# operating/verification.md

_What "done" means. Verify the artifact, not the config._

## The rule underneath all of it

Never report done from a self-report. Check the actual state: the deployed commit, the served page,
the real database row, the rendered screen. A green exit code is necessary, never sufficient.

## Ground truth (run before trusting any state doc)

Before you believe `state/STATE.md` or any status claim, check the live system. Adapt these to your
stack; the point is that each answer comes from the running system, not a document:

```bash
# what is actually deployed on production
<your prod host> 'cd <app dir> && git log --oneline -1'
<your prod host> '<your migration tool> current'      # e.g. alembic current, prisma migrate status
# what main actually is
git ls-remote origin refs/heads/main
```

Write today's real answers into `state/STATE.md` and re-verify them; never trust the numbers a doc
carries.

## The gate (mechanical check for your repo)

The gate is the full, reproducible test/build run for your project. Two rules make it trustworthy:

1. **Run it from a fresh worktree off the branch you claim to be testing**, with a scratch database
   and **no production `.env`** — copying a real `.env` in can add phantom failures or, worse, touch
   real data. Use throwaway secrets generated per run.
2. **Compare the FAILED set against a committed baseline.** A repo often has known-failing or
   environment-dependent tests. The gate passes only if the failure set matches the baseline exactly
   — a new name in the set is a regression. Keep the baseline in the repo (`docs/test-baseline.txt`
   or similar) and update it only as its own reviewed change.

Common traps: capturing a coloured (ANSI) test log and grepping `^FAILED` — strip ANSI first or the
grep matches nothing and reads as false-green; omitting the scratch `DATABASE_URL` so tests error
before they run and the count looks small.

**One gate per landing batch**, on the merged tree of `dev` + every reviewed PR that is ready — not
per PR (that double-runs and starves a shared box). Per PR, only the targeted tests run, plus the CI
gate on the PR. Every landed tree still gets one full gate.

## Fix the seam, do not wrap it

A fix replaces the broken path; it does not add a second writer, a normaliser that accepts the old
shape too, a flag or try/except around a path known to be wrong, or a fallback that keeps the old
path alive "for callers" or "for the tests." Name the producer of the wrong value and change it
there; a check that has to be repeated at two sites is at the wrong site. If the diff must keep the
old path, the PR says why in one line and files the removal as its own ticket. A bug fixed twice in
one session is the tell that the first diagnosis was accepted before the live system confirmed it —
re-run the ground-truth check before the second fix, not after.

## What a review actually looks for (from hard-won lessons)

- Test the behaviour the commit is **named for**, at the level it runs (the route, not just the
  helper). Defects live in the gap between a tested helper and an argued integration.
- An **absence assertion proves nothing** (a test can pass because the thing is missing). Assert the
  presence and the value.
- Grep every **writer** of a value, not just the function you changed.
- Verify the **served** artifact, not the source — the rendered page, the actual response.
