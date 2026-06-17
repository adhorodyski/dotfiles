---
name: read-issue
description: >
  Build deep context from a GitHub issue and its whole thread before further
  work. Use when given a GitHub issue URL, when the user says "read <issue
  link>", "read this issue", or invokes /read-issue. Reads the description and
  every comment in full, follows directly-linked PRs and related issues one hop
  deep, and loads it all into context.
---

Build a full mental model of a GitHub issue so the work that follows has every fact. Read everything; absorb it into the conversation; do not write anything to disk.

## Steps

1. **Resolve the URL.** Use the one given, or infer it from context. If you can't find one, ask.
2. **Read the issue in full:**
   ```bash
   gh issue view <url> --comments
   ```
   Read the description and every comment top to bottom. Skim nothing.
3. **Read its sub-issues, if any.** Sub-issues are GitHub's native parent/child breakdown. They are this issue's own scope, not just a link, so always expand them in full even though they sit below the one-hop link rule:
   ```bash
   gh api repos/<owner>/<repo>/issues/<number>/sub_issues
   ```
   For each sub-issue returned, invoke `read-issue` on it (dedup-guarded).
4. **Capture every linked resource** in the description and thread: other issues, PRs, docs, dashboards, external links. Hold them in context.
5. **Follow links one hop deep** (see Recursion):
   - Linked or referenced **PRs** -> invoke `read-pr` on each.
   - Related or mentioned **issues** -> invoke `read-issue` on each.

## Recursion

One hop only, dedup-guarded.

- Keep a **visited-URL set** for this whole turn, shared with `read-pr`. Before reading any issue or PR, check the set; if it's there, skip it. After reading, add it.
- This visited set is what breaks issue<->PR cycles. Honor it across every nested invocation.
- Follow only links found in the **original** issue (depth 1). Links discovered inside those nested issues/PRs are **listed, not auto-expanded**. Mention them so the user can ask to go deeper.

## Output

Unless the user asked for more than reading, your only allowed output after the reads is this template, nothing before or after:

```
Ready.

**Issues:**
- <url>

**PRs:**
- <url>
```

One bullet per URL. Issues = the original issue, its sub-issues, and any nested issues. PRs = any PRs read. Empty group: `- (none)`.
