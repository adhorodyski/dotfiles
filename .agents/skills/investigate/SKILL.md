---
name: investigate
description: >
  Test a reported problem's claims against real evidence, unattended. Turns the
  report into falsifiable hypotheses, tests each in parallel against whatever
  telemetry and code this session can reach, red-teams the results, and drafts
  findings containing only what survived. Use when the user says "investigate
  <thing>", "verify this", "is this real", or invokes /investigate.
---

Prove or kill a report's claims before anyone writes code. Every number comes from something that ran in this session.

## 1. Read the subject

An issue, ticket, thread, pasted report, or a claim the user just made. Infer it from context, or ask. Use `/read-issue`, `/read-pr`, or the fetch tool when they apply. Read every comment, not the summary.

## 2. Write hypotheses

Numbered and falsifiable. Falsifiable means you can name the source that would prove it wrong, and you can reach that source from here. "Reconnects are too frequent" fails. "Over 20% of reconnects happen within 5s of a previous one" passes.

Always include two: the report's own stated cause, and one that sizes the problem as a share of a population over a window. Beyond those, write one per distinct claim; do not merge two claims to stay under a count.

If no hypothesis is testable with the sources you have, stop and say so. Do not substitute reasoning for measurement.

## 3. Test in parallel

One subagent per hypothesis, dispatched in batches of six per message. Give each the hypothesis verbatim. Each must attempt confirmation *and* refutation, and returns at most ten lines:

```
H<n>: CONFIRMED | REFUTED | INCONCLUSIVE
number: <measurement, with units and denominator>
scope: <time range, population, filters>
rerun: <query, command, or file:line that reproduces it, verbatim>
where: <file:line of the mechanism, when the evidence pinned it>
also: <a larger adjacent effect this query surfaced, with its own number and rerun line, or nothing>
refutation attempted: <what you tried that would have broken this, and what it showed>
```

An `also` without a number and a `rerun` line is speculation. Leave it empty.

`INCONCLUSIVE` is the honest answer when the source does not exist or lacks the field. Never estimate instead.

## 4. Red-team

After every batch returns, dispatch one more subagent with all the findings and one job: break them. Give it the same tool access the others had, because two of its checks require re-running things. It checks each claim for

- a window overlapping a release, incident, or rollout ramp,
- a population narrower than the claim describes,
- correlation stated as cause,
- a denominator that changed between the two numbers compared,
- a cause attributed to code that was not live in the measured window,
- a `rerun` line that does not reproduce the number when run.

Verdict per claim: `HOLDS`, `DOWNGRADE` (state the weaker surviving claim), or `BROKEN`.

## 5. Report

Hand the result to `/write` as an issue comment, or whatever artifact the subject calls for. It must stand on its own for someone reading it a year later. Use this order, and omit any section with nothing in it.

- **Verdict.** One sentence: the claim as stated, and whether it stands.
- **Magnitude.** What share of what population, over what window. If the sizing hypothesis came back `INCONCLUSIVE`, say so and name the missing source.
- **What holds.** `CONFIRMED` claims the red-team marked `HOLDS`, and `DOWNGRADE` claims at their weaker version. Each with its number and `rerun` line.
- **What does not.** Refuted claims and anything marked `BROKEN`. A dead premise is what stops the wrong fix from shipping, so report it, never drop it.
- **Where it lives.** The `file:line` of the mechanism, when the evidence pinned it.
- **Also found.** An adjacent effect a query surfaced. If the verdict is that the claim stands, this is a follow-up and is phrased as one. Only when the claim is refuted may it be offered as the thing to look at instead.
- **Not measured.** `INCONCLUSIVE` hypotheses, one line each naming the missing source. Never phrased as findings.

Close with the one open question that would most change the fix, or nothing.

Print the draft, then `red-team killed <n> claims, downgraded <m>.` outside it. The tally is for you, not for the issue.

## Rules

- A number without a `rerun` line that ran here does not go in the draft.
- Never say a fix worked because a metric moved. Name what else changed in that window, or say you checked and nothing did.
- Every hypothesis refuted is a complete result. Report it. Do not go hunting for a different problem to solve; an alternative belongs in the draft only when a query already surfaced it with a number.
- Never post, open a PR, or write code.
