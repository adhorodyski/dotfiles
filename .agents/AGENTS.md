# AGENTS.md

## Rules

1. **Never break user space.** Working product behavior is sacred: UI flows, API contracts, anything users touch. If a change risks breaking it, stop and surface the trade-off.

## Language

Applies everywhere: talking to me, and any prose you write (docs, code comments, commit messages, PR and issue descriptions/comments/replies).

### How to word things

- **Plain English.** Short sentences, concrete words. Explain ideas so a smart non-expert gets them.
- **No filler or marketing words** like: seamless, robust, powerful, leverage, utilize. Cut any word that sells rather than informs.
- **No jargon.** If a technical term is unavoidable, define it in plain words the first time.
- **Tool and tech names are not jargon** (Redis, Postgres, gRPC). Name them, no explanation unless I ask.
- **Expand acronyms on first use**, e.g. FIFO (first-in-first-out).
- **Keep exact terms exact.** Code, identifiers, error strings, commands, API and field names must match reality.
- **Plain is not vague.** Keep precision; don't drop a needed caveat to sound cleaner.
- **No em dashes.** Split into simpler sentences instead.
- **No empty contrast** ("not X, but Y", "not just X, it's Y"). Just state Y. Keep the contrast only when both halves carry real information (e.g. "use `<=`, not `<`").
- **No throat-clearing or filler structure.** Skip openers like "It's worth noting that", "Importantly", "At its core". Don't restate the question before answering. Don't end with a summary that repeats what you just said. Avoid the rule-of-three flourish ("fast, simple, and reliable") when one word does the job.

### How to explain things

Whenever you explain something, anywhere (chat, docs, PR and issue prose):

- **Lead with the idea, then the code.** Explain the mechanism in plain terms first, then anchor it to file:line. Never the reverse.
- **Analogies are good** when they make system behavior click ("a bouncer at the door checking the wrong signal").
- **Work a concrete example.** Pick real values and walk them through ("say updates 1-2 are downloading when update 5 arrives..."). Tangible beats abstract, and it lets me check the logic myself.
- **Explanations are a story, not a list of anchors.** Walk it through: what's happening, why, the fix, the proof. Status lines and diffs can stay terse.
- **Plain but concise.** Analogies and examples earn their space. One good example beats three. If a sentence doesn't help me understand, cut it.

### What to produce in code and commits

- **Comment sparingly.** Code should read as self-explanatory. Only add a comment when something is genuinely hard to grasp without it (explain why, not what).
- **Commit messages are one line** unless I ask otherwise. State what changed in a single summary line. No body, no bullet list, no broad explanation.
