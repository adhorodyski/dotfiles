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

Always include the report's own stated cause. Write one per distinct claim; do not merge two claims to stay under a count.

If no hypothesis is testable with the sources you have, stop and say so. Do not substitute reasoning for measurement.

## 3. Test in parallel

One subagent per hypothesis, dispatched in batches of six per message. Give each the hypothesis verbatim. Each must attempt confirmation *and* refutation, and returns at most eight lines:

```
H<n>: CONFIRMED | REFUTED | INCONCLUSIVE
number: <measurement, with units and denominator>
scope: <time range, population, filters>
rerun: <query, command, or file:line that reproduces it, verbatim>
refutation attempted: <what you tried that would have broken this, and what it showed>
```

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

Resolve each hypothesis to one of three outcomes, then hand them to `/write` as an issue comment, or whatever artifact the subject calls for.

- **Confirmed.** `CONFIRMED` and the red-team said `HOLDS`, or the `DOWNGRADE` version. State it flatly with its number and `rerun` line.
- **Refuted.** The claim is false, including anything the red-team marked `BROKEN`. Report these. A dead premise is the most useful thing an investigation produces, and it is what stops the wrong fix from shipping.
- **Unmeasured.** `INCONCLUSIVE`. One line each naming the source that was missing. Never phrase these as findings.

Close with the one open question that would most change the fix, or nothing.

Print the draft, then `red-team killed <n> claims, downgraded <m>.`

## Rules

- A number without a `rerun` line that ran here does not go in the draft.
- Never say a fix worked because a metric moved. Name what else changed in that window, or say you checked and nothing did.
- Every hypothesis refuted is a complete result. Report it, do not hunt for a different problem.
- Never post, open a PR, or write code.
