---
name: pr-triage
description: >
  Triage open PR review feedback. Verifies every unresolved comment against the
  current code, drops the ones already handled or already wrong, and lists only
  what survives with a short take and a proposed fix. Triggers on "/pr-triage",
  "what's left on this PR", "open PR comments".
---

Every review comment is a claim about the code. Test each claim, list only the ones that hold. Present, do not apply.

## Parameter

A PR number, passed as an argument or taken from the current branch.

## 1. Build context

Run `/read-pr`. Do not triage before it finishes.

## 2. Fetch the unresolved threads

Resolved state is GraphQL only; REST `pulls/{PR}/comments` has no such field.

```bash
gh api graphql -F owner='{owner}' -F repo='{repo}' -F pr={PR} -f query='
  query($owner:String!,$repo:String!,$pr:Int!){
    repository(owner:$owner,name:$repo){ pullRequest(number:$pr){
      reviewThreads(first:100){ nodes{ isResolved
        comments(first:20){ nodes{ author{login} body path line url } } } } } }
  }' --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved | not) | .comments.nodes'
```

Review summaries and issue-style comments come from step 1.

## 3. Drop the handled ones

Skip a comment when the author replied to settle it, when a later commit does what it asked, or when it is the author talking to themselves. A commit touching the same lines is not enough; the change must match the ask. When unsure, keep it.

## 4. Test what is left

Open the current source at each comment's path and lines and read it. Decide from the code, not from the reviewer's description of the code. A comment is not valid because a reviewer is senior. Then write one block per comment:

```
🟢|🟡|🔴|❓ {path}:{line} — [link]({url})
> reviewer's point, trimmed
what the code at that line does, and whether that matches the claim.

**fix:**
the change to make, or a one-line reply to post.
```

- 🟢 claim holds, code needs changing.
- 🟡 claim holds, not blocking.
- 🔴 claim does not hold. Say which line proves it.
- ❓ untestable until the reviewer clarifies.

Give a count of the comments dropped in step 3, not a list.

## Rules

- Never apply code, push, post a reply, or resolve a thread.
- No reviewer-by-reviewer ceremony, no summary at the end.
- A 🔴 without a line number proving it is a 🟢 you did not check.
