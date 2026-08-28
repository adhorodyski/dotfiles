---
name: pr-triage
description: >
  Triage open PR review feedback. Verifies every unresolved comment against the
  current code, drops the ones already handled or already wrong, and presents
  only what survives with a proposed fix. Runs one PR or sweeps every open PR
  you own. Triggers on "/pr-triage", "what's left on this PR", "open PR
  comments", "triage all my PRs".
---

Every review comment is a claim about the code. Test each claim, show only the ones that hold. Present, do not apply.

## Target

A PR number or URL, or `all` for every open PR you own, or nothing for the current branch.

```bash
gh pr list --author @me --state open --json number,title,headRepository
```

## 1. Dispatch

One subagent per PR, all in one message, even for a single PR. Cap at eight; with more, take the eight with the most unresolved threads and name the rest as untriaged. Each runs section 2 in its own context, so the diffs never enter this conversation.

## 2. The subagent's job

Run `/read-pr` on its PR, then fetch the unresolved threads. Resolved state is GraphQL only; REST `pulls/{PR}/comments` has no such field.

```bash
gh api graphql -F owner='{owner}' -F repo='{repo}' -F pr={PR} -f query='
  query($owner:String!,$repo:String!,$pr:Int!){
    repository(owner:$owner,name:$repo){ pullRequest(number:$pr){
      reviewThreads(first:100){ nodes{ isResolved
        comments(first:20){ nodes{ author{login} body path line url } } } } } }
  }' --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved | not) | .comments.nodes'
```

Review summaries and issue-style comments come from `/read-pr`.

Drop a comment when the author replied to settle it, when a later commit does what it asked, or when it is the author talking to themselves. A commit touching the same lines is not enough; the change must match the ask. When unsure, keep it.

For each comment left, open the current source at its path and lines and read it. Decide from the code, not from the reviewer's description of the code. A comment is not valid because a reviewer is senior. Then write one block:

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

## 3. Report

One table, then the blocks ordered by 🟢 count, highest first.

| PR | title | 🟢 | 🟡 | 🔴 | ❓ |

A PR with nothing open gets one line under the table. Give a count of comments dropped as already handled, not a list.

## Rules

- Never apply code, push, post a reply, or resolve a thread.
- No reviewer-by-reviewer ceremony, no summary at the end.
- A 🔴 without a line number proving it is a 🟢 you did not check.
