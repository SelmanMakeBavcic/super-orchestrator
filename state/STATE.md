# STATE.md — the live state of {{your project}}

_The one boot doc. Read this first, every session. Rewritten wholesale, never appended. If it lists
open work, it is wrong — open work lives in the tracker._

> **This repo is not set up yet.** Run `/onboard` to fill this in.

## New session

1. Read this file.
2. Read `operating/workflow.md`.
3. Open your tracker; filter to the `needs-you` label (your inbox).
4. Read the one `plan/chats/CONTINUATION-*.md`.

## The project

- **What it is:** {{one line}}
- **Stack:** {{language / framework / test runner}}
- **Repo(s):** {{where the code lives}}
- **Run it:** {{command}}
- **Gate it (the full test/build):** {{command}}
- **Deploy:** {{how a change reaches production}}

## Environments (how dev and prod differ — for QA)

| Axis | dev | production |
|---|---|---|
| Code | {{branch / how it deploys}} | {{branch / how it deploys}} |
| Data | {{test/seed}} | real users |
| Integrations | {{which are wired}} | {{which are wired}} |
| Observability | {{Sentry/PostHog live?}} | {{Sentry/PostHog live?}} |

## Ground truth (verify before trusting this doc)

- production is on commit: {{sha}} · migration head: {{n}} · test baseline: {{n}}
- Re-run the checks in `operating/verification.md` before believing these numbers.

## Setup TODO (from onboarding)

- [ ] {{integration}} — {{the [you] click}}
- [ ] ...
