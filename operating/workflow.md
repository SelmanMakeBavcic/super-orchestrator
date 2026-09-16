# operating/workflow.md — how work flows end to end

_The one answer to "how do we work." A self-healing loop and a collision-free build pipeline that can
run with agents. The tracker safety line stays in `linear.md`._

---

## 0. The shape

Two loops feed one pipeline. Everything that becomes work is a **tracker issue** (Linear by default);
the issue is the brief, the lock, the evidence log, and your inbox item, all at once.

```
 LOOP B: launch work                         LOOP A: self-healing
 idea / launch todo                          Sentry · PostHog · a session finds a bug
      │ brainstorm (grill until clear)            │ ingest: dedup · rate-limit · threshold
      ▼                                           ▼
   spec  ──► tickets (blocking edges) ──►  tracker issue  ◄──  triage: verify · reproduce · route
                                               │  ready-for-agent
                                               ▼
                              WORKER  claims (assignee = lock) · own worktree · own branch · PR to dev
                                               │
                              REVIEWER  independent · Standards + Spec + Security · verdict as comment
                                               │
                              LANDER   ONE serialized role · re-fetch tip · gate the MERGED result · merge to dev
                                               │
                                        On DEV — QA owed · eye-test · evidence on the issue
                                               │
                                        needs-you  (your single inbox)
                                               │
                              PROMOTER  you + the orchestrator · bundle + rollback nets · PRODUCTION
                                               │
                                        issue → Done  (auto-closes on merge to main)
```

The human gate sits at **promote** and nowhere earlier. Everything before it is autonomous and
reversible. Everything at and after it is your typed word.

## 0.5 The quality bar (every unit is checked against it)

Set during onboarding and written into `soul.md`. Every spec, ticket, review and promote carries it,
and the Reviewer scores it as a named axis (section 3, step 7). Make it specific enough to pass/fail
against — for example: **secure by default** (fail closed, secrets never in a chat or tracker, every
merge security-reviewed); **correct** (tested at the level it runs, not just the helper); and
**{{your bar}}** (fast, accessible, simple over clever — whatever matters most for your product).

---

## 1. Source of truth: one question, one home

| Question | The ONLY home | Notes |
|---|---|---|
| What is open, in flight, blocked, awaiting you? | **the tracker** | states + a `needs-you` label. Nothing else is a backlog. |
| What exactly should this unit do? | **the tracker issue body** | Agent Brief format (section 6). Long specs live in `plan/<spec>.md`; the issue links them. |
| What happened on this unit (gate, review, QA, SHAs)? | **tracker issue comments** + the PR | evidence goes on the issue, never into a state doc. |
| What is the live system doing right now? | `state/STATE.md` | short, rewritten wholesale, boot doc only. If it lists open work, it is wrong. |
| What did we decide, and what did we park? | `state/decisions.md` | append-only ledger. |
| Why does capability X work this way? | `knowledge/` | durable, grep on demand. |
| How do we work? | `operating/` | this file + autonomy, verification, eye-test, review, linear, delegation. |
| Session handoff | **one** `plan/chats/CONTINUATION-*.md` | what to do next, never what is open. |
| Signals | Sentry, PostHog, cron liveness | inputs to Loop A, never a tracker themselves. |

**Why keep them separate:** a single file that holds the backlog, the journal, the lessons, and the
decisions grows unbounded and drifts. The tracker takes the backlog and the journal (comments).
Lessons go to `knowledge/`. Decisions stay in the ledger. Each file gets one job.

---

## 2. Roles ("somebody" has five names)

For a solo developer, you play several of these yourself — the value is that each role has a
different job, and the review/land roles are done by an agent (or a fresh context) that did **not**
write the code.

| Role | Who | Mode | May | Never |
|---|---|---|---|---|
| **Planner** | you, interactive | in the loop | brainstorm, spec, ticket, triage, scope | write code without a ticket |
| **Worker** | an agent (or you) | can run unattended | claim one issue, build in its own worktree, open a PR to `dev` | merge, deploy, touch `main`, touch another issue's files |
| **Reviewer** | an agent that did NOT write the code | unattended | two-axis review (Standards + Spec) + security + quality-bar, verdict as a comment | approve its own work |
| **Lander** | ONE serialized role | in the loop | re-fetch tip, gate the merged result, merge to `dev`, verify, move the issue | land two batches at once, land to `main` |
| **Promoter** | you | in the loop | promote `dev` → `main`, production deploy | be skipped |

An agent Worker is a flat-rate engine: a fix costs no marginal thought from you. Its permission rules
make "never merges, never deploys" mechanical, not a matter of remembering.

---

## 3. Loop B: launch work (idea → production)

Each step names the skill it runs and the tracker transition it makes.

| # | Step | Skill / tool | Tracker |
|---|---|---|---|
| 1 | **Brainstorm / grill.** Interview until the design tree has no open branch. Facts are the agent's job; decisions are yours. Capture terminology in a `CONTEXT.md` and hard-to-reverse choices as ADRs in the product repo. | `brainstorming` / `grilling` + `domain-modeling` | none yet |
| 2 | **Prototype** only if a question needs a runnable answer (a state model, a UI you must see). Throwaway, kept on a `prototype/<name>` branch as a primary source. | `prototype` | link from the spec |
| 3 | **Spec.** Synthesize the thread into a spec: problem, solution, user stories, implementation + testing decisions, out of scope. No file paths (they go stale). Long spec → `plan/<spec>.md`, summary + link in the issue. | `writing-plans` / `to-spec` | parent issue, `Todo` |
| 4 | **Tickets.** Split into tracer-bullet vertical slices, each sized to one context window, each declaring what blocks it. Wide refactors go expand → migrate → contract. | `to-tickets` | child issues, `blockedBy` wired, `ready-for-agent` |
| 5 | **Claim + build.** A Worker takes the first open, unblocked, unassigned `ready-for-agent` child. Assigns itself FIRST. Branch = the tracker's suggested branch name. TDD at the seams the spec agreed. | `implement` → `tdd` | assignee set, `In Progress` |
| 6 | **PR + targeted tests.** Push, open a draft PR to `dev` with the evidence bundle in the body: branch, the targeted tests (this unit's files + neighbouring suites, fast), and the **red proof** (the test that failed before the change, or why there is none). The full gate runs in CI on the PR, not by hand. | targeted tests + CI gate | PR auto-linked to the issue; `BUILT` comment |
| 7 | **Review, before the full gate.** A read-only reviewer that did not write the code runs Standards + Spec + **Security + quality-bar** (section 0.5). Its `REVIEW` comment carries three named lines, each with a verdict: `Security:`, `Correctness:`, `Quality-bar:`; a review without them is not a review and the Lander does not land on it. Fixes land on the same branch BEFORE the gate. | `review` / `code-review` (two-axis) + security axis | `REVIEW` comment |
| 8 | **One full gate per landing batch, then land dark on DEV.** The Lander collects every reviewed PR whose fixes are applied into one batch, merges them onto the current `dev` tip in a fresh worktree, and runs ONE full gate on that merged tree against the baseline. Green → re-fetch each tip, merge the batch to `dev`, verify the deploy, post SHAs on each issue. Then **eye-test** per `operating/eye-test.md`. | full gate on the merged tree + `verification.md` + `eye-test.md` | `In Review` → `On DEV — QA owed` → `On DEV — QA done` |
| 9 | **Promote, once per session.** You read the issues (diff, gate, review, QA, preview URL) and say go. The orchestrator brings the promote bundle + rollback nets. Merge to `main`, deploy, verify. | promote runbook | `Done` (auto on merge to `main`) |

**Big, foggy efforts** (a launch, an architecture research list): chart a **wayfinder map** first —
one parent issue, child **decision tickets** (research / prototype / brainstorm / task), resolved one
per session, decisions not deliverables. When the map clears, merge onto step 3.

**Context hygiene.** Steps 1–4 stay in one unbroken context window. Each step 5 starts fresh from the
ticket. At a phase boundary pick, in order: continue, `/clear`, handoff, subagent, `/compact`.

---

## 4. Loop A: self-healing (signal → fix)

```
signal ──► ingest ──► tracker issue (Bug, needs-triage) ──► triage ──► route ──► Loop B from step 5
```

**Signals.** Sentry (5xx, new issue groups, regressions — read breadcrumbs, not tags), PostHog
(error tracking, product/LLM anomalies, Signals), cron liveness (a missed check-in), and a session
that finds a bug in passing (file it yourself, same shape).

**Ingest (runs unattended, with API keys, never through interactive connectors).** Rules, each one a
scar:
- **One source id = one tracker issue.** The Sentry/PostHog id lives on the issue; check before
  creating. Never a second issue for the same group.
- **Threshold + rate-limit.** File on N occurrences or a severity floor, never on the first event.
  A loop without this firewall is a paging machine (an orphaned monitor once fired ~975 times).
- **Enrich.** Attach the breadcrumb that names the real host/route, counts, and (when enabled) an
  AI root-cause draft. Metadata only; the safety line applies.

**Triage (you, or the orchestrator alone for the clear cases).**
1. Gather: read the issue, the breadcrumbs, prior notes; run the **redundancy** check (already fixed
   on `dev`?) and the **prior-rejection** check.
2. Verify the claim: reproduce it, or build the feedback loop that goes red on this bug. No loop, no
   hypothesis.
3. Route:

| Case | Route | Label | What happens |
|---|---|---|---|
| clear repro, low blast radius, known pattern | **FIX** | `ready-for-agent` | Worker builds it → Loop B step 5 |
| clear symptom, unknown cause | **RESEARCH** | `ready-for-agent` + `research` | Worker builds the loop, writes findings on the issue, no code |
| ambiguous, design fork, product call | **SCOPE** | `ready-for-human` + `needs-you` | Planner drafts a plan on the issue; you decide. Never auto-code a fork |
| already fixed / duplicate / cry-wolf | **SUPPRESS** | `wontfix` or Duplicate | close with the pointer |
| needs more from the reporter | **WAIT** | `needs-info` | triage notes on the issue |

4. Post the **Agent Brief** (section 6) when routing to an agent.

**Loop-guard.** A Worker whose fix fails the gate twice stops, comments what it tried, and flips the
issue to `ready-for-human` + `needs-you`. No thrashing, no third attempt unattended.

---

## 5. Collision-free git (the rules that make many workers safe)

1. **One issue = one branch = one worktree = one PR.** Branch name is the tracker's suggested name,
   so the PR auto-links and the state moves on merge.
2. **The assignee is the lock.** A Worker claims by assigning itself before any work. Open +
   unassigned + unblocked = takeable. Assigned = hands off.
3. **Worktrees only, never the shared checkout.** Under the repo (`.wt/<issue>`). Parallel writes to
   one checkout are the classic multi-agent corruption.
4. **Branch off `origin/dev`, freshly fetched.** Rebase onto `origin/dev` before opening or updating
   the PR. Never branch off local HEAD.
5. **A no-touch list per issue** for the merge-conflict magnets (shared config, migrations, generated
   files). A Worker that needs one stops and says so; the Lander applies it once.
6. **Landing is serialized.** Only the Lander merges to `dev`, one issue at a time, gating the MERGED
   result (not the branch), after re-fetching the tip. Diff landed vs gated.
7. **One migration in flight.** The Lander assigns the migration/revision number at landing, so two
   Workers never mint the same one.
8. **Lanes are independent; gates are not.** Frontend and backend issues can run in parallel; builds
   that share one machine queue — two gates starve each other.

---

## 6. Tracker conventions (the filing flow)

See `operating/linear.md` for the full setup. In short:

**States:** `Backlog` → `Todo` (specced/ready) → `In Progress` → `In Review` → **`On DEV — QA owed`**
→ **`On DEV — QA done`** (your inbox) → `Done`; plus `Blocked`, `Canceled`, `Duplicate`.

**Labels:** `area/*` (backend · frontend · infra), `type/*` (feature · bug · chore · decision),
`triage/*` (needs-triage · needs-info · ready-for-agent · ready-for-human · wontfix), `needs-you`
(your single inbox), `risk:prod`.

**The issue body is the brief**, in the Agent Brief shape: category, one-line summary, current
behaviour, desired behaviour, key interfaces (types and contracts, never file paths — they go stale),
acceptance criteria (each independently checkable), out of scope. Durable over precise: the issue may
wait weeks.

**No unfinishable tickets.** File a ticket only if one is true, and the body says which: (1) an agent
can finish it NOW (`ready-for-agent`, full brief, no open question); (2) it is blocked with a NAMED
unblock (who + the concrete event) and sits in `Blocked`; (3) it is a pure decision, carrying ONE
question, which is ALSO written into the session Q&A so you answer once. Never file a ticket whose
only next step is "needs you" without putting its question in the Q&A.

**Evidence template (every unit, every stage, on the issue).** One comment per stage, first line in
caps so it is countable:
- `BUILT: branch, PR <url>, targeted tests <counts>, Red proof: <the test that failed before | n/a (<why>)>`
- `GATE: <passed/failed>, <n> tests, baseline diff <n>, log <path>`
- `REVIEW: <reviewer/model>, <APPROVE|FIX>, <n> blocking, <m> should-fix` + the three named lines
  `Security:` / `Correctness:` / `Quality-bar:` (each a verdict; "n/a" only with a reason)
- `LANDED DARK ON DEV: PR <url>, dev tip <sha>`
- `QA on <dev|prod>: environment, checklist results, defects found + fixed, screenshots attached: <N>`
  — an API- or log-only check is posted as `VERIFIED (API/log): …`, never as QA
- `PROMOTE: main <sha>, prod verified <how>`

Every AI-written comment starts `> *Generated by the orchestrator.*`

**You are informed, never surprised.** Anything that needs you gets one ping (`operating/notifications.md`).
Promotes to production happen only on your typed word, never from a click, a label, or silence.

---

## 7. Tools and cost

| Tool | Role in the loop | Cost |
|---|---|---|
| **Linear** | tracker, queue, inbox, evidence log | free tier |
| **GitHub + Actions** | code, PRs, the CI gate, the webhook bus | free |
| **Sentry** | error signal, cron liveness, AI root-cause draft | free tier |
| **PostHog** | product + LLM analytics, error tracking, Signals | free tier |
| **A chat/notify sink** (Slack, Discord, email) | where you get pinged, not a tracker | free |
| An always-on box + a flat-rate agent subscription | the unattended Worker | your call |

Setup for the first four is in `integrations/`. Skip the paid glue (PagerDuty, Zapier, Jira) until
you actually hit a wall a free tool cannot handle.

---

## 8. Guardrails (each one a scar, restated once)

1. **Never production without your typed word.** Workers land dark on `dev` only.
2. **Cry-wolf firewall** on every signal source (dedup, threshold, rate-limit) before anything files.
3. **Loop-guard**: two failed gates → stop and escalate, never a third unattended attempt.
4. **Gate the merged result by name**, re-fetch the tip, diff landed vs gated. Tests-green is not
   sufficient to merge, even to `dev`.
5. **Eye-test the real path.** Gate + review are necessary, not sufficient.
6. **The safety line into the tracker.** Metadata only; no secrets, no private data.
7. **A doc that lists open work is a second backlog.** Stamp it, move the items to the tracker.
