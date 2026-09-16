# skills/ — the agent skills this workflow leans on

The pipeline in `operating/workflow.md` names skills at each step (brainstorm, spec, tickets, build,
review, QA). Those skills are **not vendored into this repo** — they are public plugins you install
once, so you get the real thing, correctly attributed to its author, and auto-updating. This file
maps each pipeline role to a skill that fills it and how to get it.

Nothing here is required to *start*. `/onboard` will ask which of these you want and wire the docs to
match. Install the ones for the steps you actually run; skip the rest.

## How skills reach Claude Code

Skills ship as **plugins** from a marketplace. Add the marketplace once, then install a plugin:

```
/plugin marketplace add anthropics/claude-plugins-official
/plugin install superpowers@claude-plugins-official
/plugin install mattpocock-skills@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
```

`/plugin` lists what you have and lets you enable/disable per project. A skill is invoked by name
(the docs write it as `` `skill-name` ``) or offered automatically when its description matches.

## The map: pipeline role → skill → source

| Pipeline step (`workflow.md`) | What the skill does | A skill that fills it | Source |
|---|---|---|---|
| 1. Brainstorm / grill | interview until the design has no open branch | `brainstorming`, `grilling` | superpowers, mattpocock-skills |
| 1. Model the domain | name the entities and states before coding | `domain-modeling` | mattpocock-skills |
| 2. Prototype (if needed) | a runnable answer to a design question | `prototype` | mattpocock-skills |
| 3. Spec | turn the thread into a written plan | `writing-plans`, `to-spec` | superpowers, mattpocock-skills |
| 4. Tickets | split the spec into vertical slices with blocking edges | `to-tickets` | mattpocock-skills |
| 5. Build | implement against the ticket, test-first | `implement`, `test-driven-development` | mattpocock-skills, superpowers |
| 6. Research (Loop A) | build the feedback loop / find the cause, no code | `research`, `systematic-debugging` | mattpocock-skills, superpowers |
| 7. Independent review | a reviewer that did **not** write the code | `/code-review`, `/security-review` | **built into Claude Code** |
| 8. QA / eye-test | verify the change in the real running system | your own — see `operating/eye-test.md` | this repo (`operating/`) |

The **independent review** step (7) is the single biggest quality lever and needs no plugin —
`/code-review` and `/security-review` ship with Claude Code. Run them as a fresh agent on the branch
diff (see `operating/review.md`).

## Front-end / design-quality skills (optional)

If your product has a UI, a design-quality skill raises the bar on the interfaces agents produce and
review. `frontend-design@claude-plugins-official` is the cleanly-installable option. There are also
community skills focused on visual taste and polish (search `/plugin marketplace` for design/UI
skills); pick one whose philosophy matches your product and wire it into your build and eye-test
steps. These are opinionated by nature — treat them as *your* house style, set during onboarding.

## Writing your own

When a correction turns into a repeatable procedure, make it a skill instead of repeating yourself
(the same instinct as `knowledge/` for facts). `skill-creator@claude-plugins-official` scaffolds one.
Keep project-specific skills in this repo under `.claude/skills/<name>/SKILL.md`; the bundled
`onboarding` skill is the worked example.

## The one skill this repo ships

`.claude/skills/onboarding/` — the first-run interview that adapts everything else to your project.
Everything above is something you add; this is the only one that lives here, because it is about
*this* template, not about any product.
