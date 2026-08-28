---
name: pr-conflicts
description: Use when the user wants to resolve git conflicts, rebase, or merge upstream changes into their current branch.
---

# Resolve Git Conflicts

## Parameters

- **target_branch**: The branch to merge/compare against. Ask the user if not provided. Default: `exfy/main` for Expensify projects.

## Steps

1. **REQUIRED:** Run `/pr-understand` to build full context on the PR, our changes, and upstream divergence before touching anything (this fetches latest automatically).

2. **Act on assessment**:
   - If pr-understand flagged the PR as obsolete — stop and tell the user.
   - If upstream requires a rework — explain and propose a plan.
   - Only if it's purely mechanical conflicts with no logical impact, proceed to resolve.

3. **Resolve conflicts**: Run `git merge <target_branch>` (or rebase if user prefers).
   - **CRITICAL**: You MUST run the actual merge/rebase command first. Do NOT skip this step and edit files directly — the working tree must be in a merge/rebase state with real conflict markers before resolving anything. Verify with `git status` that you are in a merge state.
   - For each conflict:
     - Keep our logical changes intact.
     - Adapt to upstream's new code structure, naming, and patterns.
     - Never silently drop upstream changes — if in doubt, ask.

4. **Verify**: After resolution, run typecheck/lint on affected files to make sure nothing broke.
