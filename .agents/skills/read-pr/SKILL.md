---
name: read-pr
description: >
  Build deep context from a GitHub pull request, its thread, its full diff, and
  before further work. Use when given a GitHub PR URL, when the user says
  "read <PR link>", "read this PR", or invokes /read-pr. Reads the description
  and every comment in full, fetches the whole diff, and follows mentioned
  issues and PRs one hop deep.
---

Build a full mental model of a pull request: what it changes and what people said about it. Read everything; absorb it into the conversation; do not write anything to disk. No local checkout or fetch (gh API only).

## Steps

1. **Resolve the URL.** Use the one given, or infer it from context. If you can't find one, ask.
2. **Read the PR in full:**
   ```bash
   gh pr view <url> --comments
   ```
   Read the description and every comment and review comment top to bottom.
3. **Fetch the whole diff** to map what changed:
   ```bash
   gh pr diff <url>
   ```
   Build a mental map: files touched, the shape of each change, the approach.
4. **Capture every linked resource** in the description and thread: issues, other PRs, docs, dashboards, external links.
5. **Follow links one hop deep** (see Recursion):
   - Mentioned **issues** -> invoke `read-issue` on each.
   - Other **PRs** -> invoke `read-pr` on each.

## Recursion

One hop only, dedup-guarded.

- Keep a **visited-URL set** for this whole turn, shared with `read-issue`. Before reading any issue or PR, check the set; if it's there, skip it. After reading, add it.
- This visited set is what breaks PR<->issue cycles. Honor it across every nested invocation.
- Follow only links found in the **original** PR (depth 1). Links discovered inside those nested issues/PRs are **listed, not auto-expanded**. Mention them so the user can ask to go deeper.

## Output

Unless the user asked for more than reading, your only allowed output after the reads is this template, nothing before or after:

```
Ready.

**Issues:**
- <url>

**PRs:**
- <url>
```

One bullet per URL. PRs = the original PR and any nested PRs. Issues = any issues read. Empty group: `- (none)`.
