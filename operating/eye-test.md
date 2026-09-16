# operating/eye-test.md — QA: verifying a change in the real running system

_An eye-test is a gate (`verification.md`), not a courtesy. Gate + review are necessary, not
sufficient. The classic escape is a change that passes tests and review, then breaks the moment a
human opens the real app — because nobody opened it._

## 1. Dev and production are not the same. Know the difference before you judge.

Keep a short table in `state/STATE.md` of how your environments differ, so whoever QAs a unit knows
what a dev pass does and does not prove. The axes that usually differ:

| Axis | What to note |
|---|---|
| Code | which branch/commit is deployed where; how each deploys (auto vs manual promote) |
| Data | real users on prod; seeded/test data on dev |
| Integrations | which third-party connectors are wired on dev vs prod (often only prod has the real OAuth apps) |
| Feature flags / env | which flags and keys are set where |
| Observability | whether error/analytics SDKs are actually live on each (a dev bundle that ships no DSN is deaf) |

**Every QA report starts with an environment card**: which host, which commit (served, not merged),
which of the above apply. A reviewer who cannot state the difference does not judge.

**Where a unit can be QA'd:** anything backed by a third-party connector that only exists on prod is
QA'd on prod after promote. Everything else is QA'd on dev first. Say which in the card.

## 2. Should dev and prod be made identical? No. Close the cheap gaps, accept the rest.

Full parity means copying every secret onto a box that also runs unattended agents — more risk, real
cost, and still no real user data. Instead: turn on the *free* flags on dev so it exercises the same
code paths; seed a clearly-fake demo account so QA has realistic data without touching a real user;
and QA everything vendor-backed on prod after promote, with rollback nets listed on the issue first.

## 3. How an eye-test runs (dev, after a unit lands dark)

**Pre-flight, before judging anything:**
- Confirm the deployed commit equals the landed commit (fetch the served artifact, not the source).
  For web, fetch the cache-busted root and confirm the served bundle contains a marker from the unit.
  If the deploy has not propagated yet, wait — do not judge old code.
- Post the environment card as the first line of the report.

**The checklist is the issue.** The tracker issue's acceptance criteria are the test steps. Add the
standing four for any visual change: **both themes, both languages (if you localize), desktop and
375px, realistic data.**

**Mechanism:** drive a real browser (a Playwright script, or you clicking through the checklist). For
unattended QA, a Playwright run against dev with a dedicated test account, screenshotting each step.
The agent never types a real password into a real account you own — either it uses a scoped test
account or you drive.

## 4. Pixels, or it is not an eye-test

- Assert on **rendered text** (`page.inner_text`) for the thing the unit changed, not on the HTTP
  response. A 200 from the API is not proof the dialog rendered.
- The QA comment states `Screenshots attached: N` and the images are **embedded in the comment** so
  they render inline (an attachment alone shows only as a link card). Take them in light + dark,
  desktop + 375px.
- A check that can only be made at the API or log level (a cron, a 429 branch, an auth path) is posted
  as `VERIFIED (API/log): …`, never as an eye-test, so the report does not overstate it.

## 5. Production eye-test, the same way, after a promote

Same checklist, same evidence shape, on production, on your own account. Differences: the rollback
nets (a pre-promote backup, a tagged image, git tags, the previous bundle) are listed on the issue
**before** the promote; a failed criterion on prod is a fix-forward or rollback decision within the
same session, never left overnight. Vendor-backed surfaces get their first real QA here.

## 6. You are told when it is done

Every eye-test ends with, in order: (1) the evidence comment on the issue, verdict in the first line;
(2) one line to your notify sink (`RAN-n QA PASS on dev @sha` or `FAIL: <criterion>`); (3) a push to
your device if enabled. On PASS with a promote owed, the issue moves to your inbox.

## 7. Roles

The Reviewer QAs on dev; production is always you (with the orchestrator driving or you clicking). The
author of a change never signs off its own eye-test.
