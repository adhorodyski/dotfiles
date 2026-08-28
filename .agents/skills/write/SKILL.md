---
name: write
description: >
  Draft user-facing prose and critique it before showing it. Use when the user
  says "/write <artifact>", "write the PR description", "draft an issue
  comment", "reply to this reviewer", or asks for a Slack summary, commit
  message, or doc section. Drafts, deslops, then runs an independent critic
  until the text passes a length and honesty contract.
---

Produce the final text. The user sees one version.

## Artifact

`/write <artifact>`. Match against the table, or take the closest row and say which.

| Artifact | Cap | Shape |
| --- | --- | --- |
| PR description | 150 words | Fill the repo template. Prose in the body sections. |
| PR explanation | 120 words | What changed, why, what it does not cover. |
| Issue comment | 200 words | Finding, then evidence, then open question if any. |
| Review reply | 60 words | Agree or disagree in the first sentence. |
| Slack message | 100 words | One paragraph. |
| Commit message | subject + 5 body lines | Imperative subject. Body says why. |
| Doc section | none | Every contract rule still applies per paragraph. |

## Steps

1. Draft it. Do not show it.
2. Run `/deslop` on the draft.
3. Dispatch a critic subagent. Give it the artifact type, its cap, the contract, and the text alone, with no context about who wrote it or why. It returns `PASS` or numbered violations, each quoting the offending span.
4. Revise, re-run `/deslop`, re-critique. Up to three rounds. Still failing: show the text and name what you could not fix.
5. Output the final text, then one line on what the critic caught.

## Contract

Wording is `/deslop`'s job. The critic never rules on it. The critic checks three things and quotes every violation.

**Length.** Over the cap. Any sentence over 25 words. A header or list with fewer than three parallel items.

**Honesty.** A quantitative claim with no number ("significantly faster"). A number with no source. A claim not traceable to code or a query from this session. Cause where only correlation was shown. Hedge stacks ("may potentially").

**Order.** Change before rationale. Finding before method.

## Rules

- Never post, commit, or push.
- Identifiers, commands, error strings, and paths stay verbatim.
- Keep every caveat that changes what the reader does. The critic does not reward cuts that drop a real constraint.
