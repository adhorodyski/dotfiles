---
name: proposal
description: Use when the user wants to write a new proposal in the hourglass problem/solution format, or review a draft proposal against hourglass rules (Strategy/Background/Problem/Solution structure). Triggers on "/proposal", "review this proposal", "help me write a proposal", "draft a P/S".
---

# Proposal

Two modes, auto-detected from input:

- **Review** — analyze a draft proposal against the hourglass rubric.
- **Write** — interview the user via `grill-me`, then synthesize a hourglass-shaped draft.

## Mode detection

Inspect the input/args the user passed to `/proposal`:

| Signal                                                                                                     | Mode                                                     |
| ---------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| Input contains 2+ of `Strategy:`, `Background:`, `Problem:`, `Solution:`, `Proposal:` headers              | **Review**                                               |
| Input is empty, or contains intent like "help me write", "draft a proposal", "new P/S", "start a proposal" | **Write**                                                |
| Ambiguous (short prose, no headers, no clear intent)                                                       | Ask once: _"Review existing draft, or write a new one?"_ |

Do not guess on ambiguous input — ask.

## Review mode

1. Read the sibling file `review-rubric.md` in this skill directory.
2. Treat that file as the system prompt for review.
3. The user's proposal is the text they passed to `/proposal` (or pasted after invoking).
4. Apply the rubric verbatim. Produce its required output:
   - Sectional Analysis (Proposal Name, Strategic Alignment, Background, Problem Clarity, Reverse Solution Trap, Solution Specificity, Hourglass Shape Compliance, Other Notes)
   - Specific Recommendations (prioritized, quoting the original)
   - Final Edit (or rewrite request if changes are substantial — bold-remind the author it's illustrative only)
5. Run the rubric's self-check before sending: reread your output, confirm compliance with the rubric instructions, correct as needed.

## Write mode

1. Invoke the `grill-me` skill with this framing:

   > Interview me to elicit a proposal in the hourglass problem/solution format. Walk through the four sections in this order:
   >
   > 1. **Strategy** — which subset of company strategy this supports (red ocean / blue ocean, CAC / LTV / FCF). 2–4 sentences. No problem or solution hint.
   > 2. **Background** — current state of the world. Factual, quantified where possible. No problem or solution hint.
   > 3. **Problem** — single sentence: _"When `<preconditions>`, if `<action>`, then `<impact>`."_ Do not let me write a reverse-solution problem ("we don't have X"), an information-as-problem ("we lack visibility"), a multi-problem stuffing, or a vague qualifier ("inefficient") without quantification. Push back relentlessly if I drift.
   > 4. **Solution** — specific and actionable. Names vendors, numbered steps, named buttons, screen contents, CSV columns. Addresses every part of the problem; doesn't oversolve.
   >
   > Resolve dependencies between sections one at a time. Do not move on until each section is sharp.

2. After `grill-me` concludes, synthesize the answers into a draft using exactly this shape:

   ```
   **Proposal: <single memorable line in active voice>**

   **Strategy:** <2–4 sentences>

   **Background:** <factual context, quantified>

   **Problem:** When <preconditions>, if <action>, then <impact>.

   **Solution:** <specific, addresses every part of the problem>
   ```

3. Self-review the draft by loading `review-rubric.md` and applying it to your own draft as a sanity check. Surface any weaknesses you find before presenting.

4. Present the draft + the self-review to the user, and remind them in **bold** that the draft is theirs to defend — they should be ready to argue every word and stay open to constructive feedback.

## Hourglass framework (summary, for write-mode synthesis)

- **Title** — single memorable line, active voice ("Do X"), not passive ("X will happen").
- **Strategy** — 2–4 sentences. Ties to red/blue ocean or CAC/LTV/FCF. No problem hint, no solution hint.
- **Background** — factual current state, quantified where possible. No problem hint, no solution hint.
- **Problem** — one sentence. _"When `<preconditions>`, if `<action>`, then `<impact>`."_ Customer perspective. Not a reverse-solution.
- **Solution** — specific, addresses every part of the problem, doesn't oversolve, doesn't solve unlisted problems.

## Common mistakes (write-mode synthesis must avoid)

| Anti-pattern                                | Why it's bad                                    | Fix                                                              |
| ------------------------------------------- | ----------------------------------------------- | ---------------------------------------------------------------- |
| "We don't have X"                           | Reverse-solution; infinite things we don't have | State the consequence of not having X, without naming X          |
| "We lack visibility/insight/awareness"      | Information isn't itself a problem              | Name the decision or action that's blocked, not the missing data |
| "Problems A, B, C, D, E"                    | Fitting problem to a solution                   | Lead with one. Save the rest for separate proposals              |
| "X is inefficient/confusing/error-prone"    | Everything is. Unquantified                     | Decompose into specific common actions and what blocks them      |
| Strategy that summarizes the whole proposal | Strategy section ≠ executive summary            | Strategy contextualizes, doesn't preview                         |
| Background that hints at the problem        | Hourglass collapses                             | Background sets the stage; problem owns the conflict             |

## Red flags (stop and reconsider)

- Problem statement is the negation of the solution.
- Solution introduces things not traceable to the problem.
- Strategy section names a specific feature or fix.
- Background says "the issue is" or "the gap is".
- Problem statement uses "we" instead of describing customer experience.

If any red flag fires during review or self-review, call it out explicitly.
