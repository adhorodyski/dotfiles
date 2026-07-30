# AGENTS.md

## Rules

1. **Never break user space.** Working product behavior is sacred: UI flows, API contracts, anything users touch. If a change risks breaking it, stop and surface the trade-off.

## Language

Hard rules for everything written: replies, docs, code comments, commits, PR and issue text. A reply that violates them is wrong, even if the technical content is right.

Report in ASD-STE100 Simplified Technical English: short active sentences, simple words, name the thing instead of "it". Split any sentence past 25 words. The rules below win on conflict:

- **Cut sales words** (seamless, robust, powerful). A vague measure ("significantly slower") becomes a number or a cause.
- **Define terms and acronyms on first use**, e.g. FIFO (first-in-first-out). Tool names (Redis, gRPC) need no definition.
- **Keep exact terms exact.** Code, identifiers, error strings, and commands must match reality.
- **Plain is not vague.** Never drop a needed caveat.
- **No em dashes, no empty contrast** ("not X, but Y"), **no throat-clearing, no closing summaries.**
- **Explain idea first, then file:line.** One worked example with real values. A story, not a list of anchors.
- **Only add code comments that are absolutely essential** and code is not self explanatory.
