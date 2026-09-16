# integrations/github-actions.md — the CI gate from zero

The gate is the mechanical check that makes the pipeline trustworthy: it runs your full test/build on
every PR, off your machine, so a red PR is known before it joins a landing batch. Combined with the
Linear ↔ GitHub link, it makes state moves and quality checks automatic instead of remembered.

## 1. The branch model

- `main` — production. Protected. Only a human promotes to it.
- `dev` — the integration branch. Workers open PRs here; the Lander merges here.
- feature branches — one per issue, named with the issue id (`feat/app-12-...`).

Set `dev` as the default PR base so Workers target it automatically.

## 2. The gate workflow

Add `.github/workflows/gate.yml` that runs on PRs to `dev` (and to `main`). It must reproduce the
`operating/verification.md` gate: a **fresh checkout**, **no production `.env`**, a **scratch
database**, **throwaway secrets generated per run**, and a **failure set diffed against a committed
baseline** — not a bare pass/fail, so known-flaky tests do not block and a new failure does. Skeleton
(adapt to your stack):

```yaml
name: gate
on:
  pull_request:
    branches: [dev, main]
jobs:
  gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4      # or setup-python, etc.
        with: { node-version: 22 }
      - run: <install>                    # npm ci / pip install -r ...
      - run: <typecheck>                  # tsc --noEmit / mypy
      - run: <lint>                       # must be warning-free
      - run: <test>                       # scratch DB, throwaway secrets in env below
      - run: <build>
    env:
      DATABASE_URL: sqlite:///./gate.db   # scratch, never a real DB
      # generate throwaway secrets in a step; never reference production secrets here
```

Then make it a **required status check** on `dev` (Settings → Branches → branch protection). Now a red
PR physically cannot be landed.

## 3. Batch discipline

Do not run the full gate twice per unit. Per PR: the targeted tests (in the PR body) + this CI gate.
Per **landing batch**: one full gate on the merged tree (`dev` + every reviewed, ready PR), run by the
Lander locally or in a dedicated job. See `operating/verification.md`.

## 4. Deploy previews (optional, high value)

If you host on a platform with per-PR previews (Cloudflare Pages, Vercel, Netlify), connect it so
every PR gets a live URL. That URL is what you click during QA and what goes on the tracker issue —
it closes the "I can't see the change without deploying it" gap.

## 5. Auto-linking to the tracker

With the Linear ↔ GitHub integration (`integrations/linear.md`) and issue-id branch names, the PR
auto-links to its issue and moves its state on open/review/merge. No manual status updates.

## Verify it works

- Open a PR with a deliberately failing test; confirm the gate goes red and the PR cannot merge.
- Fix it; confirm green, the state moves to `In Review`, and the preview URL appears.
