# integrations/linear.md — set up Linear from zero

Linear is the spine of this workflow: the tracker, the queue, your inbox, and the evidence log. This
sets it up so the pipeline in `operating/workflow.md` runs end to end. Read the safety line in
`operating/linear.md` first — it governs what may ever go into the tracker.

The `[you]` steps are clicks only you can do; the orchestrator can do the rest via the API once it
has a key.

## 1. Create the workspace and team `[you]`

1. Sign up at linear.app (free tier is enough to start).
2. Create a **team** for your project (a short key like `APP` becomes your issue prefix, e.g.
   `APP-12`).
3. Keep the workspace **private / invite-only**.

## 2. Build the pipeline states `[you]`

Linear's workflow states are created in the UI (the API cannot add them). Under **Settings → Team →
Workflow**, make the states match the pipeline:

```
Backlog → Todo → In Progress → In Review → On DEV — QA owed → On DEV — QA done → Done
```
plus `Blocked`, `Canceled`, `Duplicate`.

If you would rather not add custom states on day one, the two QA columns can ride on labels until you
do — but native columns are what make your inbox glanceable, so add them when you can.

## 3. Get an API key for the orchestrator `[you]`

**Settings → API → Personal API keys → Create.** This lets an unattended agent create and update
issues without your browser. It is a **secret**: put it in the agent's environment as
`LINEAR_API_KEY`, never in a chat, a commit, or an issue.

## 4. Create the labels (orchestrator, via API)

Once the key is set, the orchestrator creates the label groups from `operating/linear.md`:
`area/*`, `type/*`, `triage/*`, `needs-you`, `risk:prod`. Ask it to "create the tracker labels."

## 5. Connect GitHub `[you]`

**Settings → Integrations → GitHub.** This is safe (your code is clean by rule) and gives you:
- PRs surfacing on their issue with deploy previews inline.
- Automatic state moves: PR opened → `In Progress`; review requested → `In Review`;
  **PR merged → `On DEV — QA owed`** (not Done — merge ≠ done).

Name branches with the issue id (`feat/app-12-...`) so GitHub ↔ Linear auto-links.

Do **not** connect user-data integrations (a support inbox, email) — they would sync PII into the
tracker.

## 6. Verify it works

- Create a test issue via the API (ask the orchestrator to file one), confirm it appears.
- Open a throwaway PR with the issue id in the branch name, confirm it links and moves the state.
- Delete the test issue.

## The API in one line

The orchestrator talks to Linear's GraphQL API at `https://api.linear.app/graphql` with the header
`Authorization: <LINEAR_API_KEY>`. It can list, create, comment, move state, and attach files. A small
`linear.py` wrapper (list / get / create / comment / state / attach) is worth writing once; ask the
orchestrator to scaffold it for your team key.

## The inbox

`On DEV — QA done` + `needs-you` is everything gated on your call. Entering it pings you once
(`operating/notifications.md`). That is where you spend your review time, and nowhere else.
