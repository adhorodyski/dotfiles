---
name: investigate
description: >
  Test a reported problem's claims against real evidence, unattended. Turns the
  report into falsifiable hypotheses and tests each in parallel against the
  telemetry and code this session can reach. Red-teams what comes back, closes
  its own open questions, and returns the problem, what to build, and what is
  dead. Use when the user says "investigate <thing>", "verify this", "is this
  real", or invokes /investigate.
---

Prove or kill a report's claims before anyone writes code. Every number comes from something that ran in this session.

Everything below produces one artifact:

```
**Problem**

<one sentence: what is actually wrong, in plain language, with the number that sizes it.>

**Build**

1. **<the change>.** <one sentence on what this solves.> <the number.>

**Dead**

- <the claim>. <what killed it>

<details><summary>rerun</summary>

1. `<verbatim>`

</details>
```

## 1. Read the subject

An issue, ticket, thread, pasted report, or a claim the user just made. Infer it from context, or ask. Use `/read-issue`, `/read-pr`, or the fetch tool when they apply. Read every comment, not the summary.

## 2. Write hypotheses

Numbered and falsifiable. Falsifiable means you can name the source that would prove it wrong, and reach that source from here. "Reconnects are too frequent" fails. "Over 20% of reconnects happen within 5s of a previous one" passes.

Always include two: the report's own stated cause, and one that sizes the problem as a share of a population over a window. Beyond those, write one per distinct claim. Never merge two claims to stay under a count.

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

After every batch returns, dispatch one more subagent with all the findings and one job: break them. Give it the same tool access the others had, because some of its checks re-run queries and read git history. Verdict per claim: `HOLDS`, `DOWNGRADE` (state the weaker surviving claim), or `BROKEN`. It checks each claim for

- a window overlapping a release, incident, or rollout ramp,
- a population narrower than the claim describes,
- correlation stated as cause,
- a denominator that changed between the two numbers compared,
- a cause attributed to code that was not live in the measured window,
- a `rerun` line that does not reproduce the number when run.

## 5. Close the gaps

Any question still open that would change what gets built goes back through step 3 as another batch, then through step 4 again. Repeat until nothing open changes the build list, or two extra rounds have run.

A question the sources cannot answer at all stops there. The field does not exist, or the log line is never written. Adding that instrumentation becomes a build item.

Never hand back a query to run later. If it was worth running, it ran here.

## 6. Report

Draft the block at the top of this skill, held to these:

- The `Problem` line is your conclusion, not the report's claim repeated. When the report named the wrong thing, name the right one. "Nothing is broken" is a valid `Problem` line.
- The sentence on each `Build` entry says what it solves for the people hitting it. Plain words, under twenty of them. No `file:line`, no function or symbol names, no jargon. Someone who has never opened the repo understands it.
- `Build` is ordered by size of effect. Every entry is work that starts today, including instrumentation to add where the measurement was blocked.
- No entry asks the user to run, check, watch, or look into anything. Step 5 already ran it.
- Bold is for the three section labels and the change on each `Build` entry. Nothing else in the report is bold. A period ends the bold change, then the sentence. Longer than one sentence means it is two entries.
- Every `rerun` line lives in the collapsed block at the bottom, numbered to match its `Build` entry, and nowhere else. The report body carries no queries.
- `Dead` is one line per killed claim, and that is all it is. No numbers, no `rerun`, no explanation. It exists so nobody builds for a dead premise.
- `Build` empty is a complete result. Say so in the `Problem` line, and let `Dead` carry the reason.
- Each section label sits on its own line with a blank line after it. One screen with the rerun block collapsed. Nothing before **Problem** and nothing after the rerun block.

Then pipe the draft through `/write`: artifact `investigation report`, cap 150 words of prose. Tell its critic the three blocks are required shape, so it rules on the `Problem` line and the `Build` sentences only. Suppress its closing note about what it caught.

## Rules

- A number without a `rerun` line that ran here does not go in the report.
- No progress narration. No "dispatching", no "waiting on", no per-batch summary, no round counts. The next thing the user sees after the hypotheses is the report.
- Never say a fix worked because a metric moved. Name what else changed in that window, or say you checked and nothing did.
- Every hypothesis refuted is a complete result. Do not go hunting for another problem to solve. An alternative reaches `Build` only when a query surfaced it with a number.
- The report is for the user, not a thread. No draft comment, no posting.
- Never post, open a PR, or write code.
