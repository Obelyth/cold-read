# cold-read — design

**Date:** 2026-07-28
**Status:** Approved, ready for implementation planning

## Problem

Claude writes for a reader who was in the room.

When Claude produces text that leaves the session — a status report, PR description,
client email, summary, or published doc — it draws on the full working context of the
session: repo names, table names, prior turns, decisions made an hour ago, jargon the
user and Claude have been trading all day. The reader has none of it.

The result is text that is simultaneously over-written and under-explained. Long,
because Claude had context to spend. Opaque, because that context was never transferred.
Claude is good at producing the analysis; it is bad at noticing that the analysis is
unreadable to anyone outside the project.

`cold-read` is a skill that performs the context transplant.

## Solution overview

A single skill with two modes sharing one rule set:

- **Audit mode (core).** Given existing text, perform a cold-reader pass, return a
  rewrite plus a findings list plus escalations.
- **Draft mode (secondary).** Invoked before writing, the same rules act as constraints
  so the first draft is already readable.

Draft mode is a section of `SKILL.md`, not a second engine. Both modes reference the
same six checks and the same three hard rules.

## Naming and trigger

**Name:** `cold-read`. "Give this a cold read" is the mental move the skill performs.

**Description (the trigger surface):**

> Use when text is going to be read by someone outside this session: a report, PR
> description, email, summary, doc, or post. Rewrites project-context-heavy writing so a
> smart reader with zero background can follow it, and flags where context is missing
> rather than inventing it.

**Invocation is explicit.** The skill does not claim broad auto-trigger territory over
ordinary writing tasks. The description is written to match deliberate requests
("make this readable for someone outside the project", "give this a cold read") without
hijacking every drafting task. This is a deliberate trade: the skill helps less often
than a broad trigger would, but it is never noise, and a muted skill helps nobody.

## Audience model

**Infer, state, floor.**

1. **Infer** the audience from the artifact type — a PR description is read by another
   engineer, a status report by a manager, a client email by a non-technical outsider.
2. **State** the inference in one line before the rewrite: *"Written for: a manager who
   doesn't work on this project."* Cheap to skim, cheap to correct.
3. **Floor** the assumption at *smart person, zero project context*. The skill never
   assumes more shared background than that, regardless of inferred audience. Inference
   can raise the register; it can never license unexplained internal vocabulary.

The skill asks about audience only when the inference is genuinely ambiguous.

## The six checks

The cold-reader pass runs these in order. Every finding is tagged with its check, which
is what makes the findings list actionable instead of vague.

| Check | Catches | Example |
|---|---|---|
| **Vocabulary** | Internal names, acronyms, repo/service/table names, ticket IDs, tool names used without gloss | "task_progress rows dropped after the MX sync" |
| **Backstory** | Sentences that only parse if you know what happened before | "Fixed the regression from the relay change" |
| **Stakes** | States what happened, never why the reader should care | Findings with no "so what" |
| **Framing** | Numbers and technical detail with no reference point | "p99 dropped to 340ms" — from what? is that good? |
| **Structure** | Organized the way the work happened (chronological, per-file, per-commit) rather than conclusion-first | A report that buries the answer in section 4 |
| **Volume** | Long because Claude had context to spend, not because the reader needs it | Cut, do not merely simplify |

**On Volume:** the check explicitly authorizes deletion. Most attempts at "make this
clearer" make text longer by appending explanations. Much over-written,
context-heavy text should simply be shorter. Cutting is a valid finding.

## Hard rules

Three rules override everything else in the skill.

### Rule 1 — Never invent context

If a sentence cannot be made clear without a fact that is not present in the source
text, it does **not** receive a plausible-sounding gloss. It becomes an escalation: a
direct question to the user.

This is the rule that separates `cold-read` from a generic "simplify this" prompt.
Without it, the skill's characteristic failure is confident, fluent, wrong summaries —
the worst possible output, because plain language makes fabrication *more* believable,
not less.

### Rule 2 — Preserve claim strength

The rewrite may cut, reorder, retitle, and re-register freely. It may not change how
strongly a claim is made. "Probably fixed" does not become "fixed." "Appears related to"
does not become "caused by."

Plain language drifts toward false confidence; hedges are usually load-bearing. This
rule guards the second failure mode.

### Rule 3 — No en dashes or em dashes

The rewrite, findings, and escalations must contain no en dash (U+2013) and no em dash
(U+2014). Hyphens in compound words are unaffected.

This is a mechanical constraint, not a style preference, and it is the one place this
skill touches typography. Text produced here goes out under a person's name, and
dash-heavy punctuation is the most recognizable signature of machine-written prose. A
reader who notices it stops evaluating the content and starts evaluating its origin,
which defeats the skill's entire purpose.

Dashes are replaced, not deleted: a colon for an introduced explanation, commas or
parentheses for an aside, a full stop for two joined clauses, "3 to 5" for a numeric
range. Splitting the sentence is usually the best fix.

Because the constraint is regex-enforceable, it is verified by a script
(`tests/no_dashes.sh`) rather than trusted to judgment, per the guidance in
`superpowers:writing-skills` that mechanical constraints belong in validation. The same
script gates every shipped file, so the skill's own documentation and examples cannot
model the behavior they forbid.

Rule 3 is the one rule that can force a change to otherwise-clean text. If the source
contains these characters, replacing them is required even when the no-op corollary
would otherwise apply.

### Corollary — No-op is a valid result

If the text is already clear to a cold reader, the skill says so and returns it
near-unchanged. An invoked skill feels pressure to justify itself by rewriting. That
pressure is explicitly rejected in `SKILL.md`.

## Output contract

Audit mode returns a fixed response, always in this order: an audience line, the
rewrite, the findings, and escalations when they exist.

### 1. Audience line

One line, before everything:

```
Written for: a manager who doesn't work on this project.
```

### 2. The rewrite

Clean text, ready to paste. No commentary inside it, no `[explanation]` brackets, no
change markers, no tracked diffs. If it cannot be pasted as-is, the skill has failed.

### 3. Findings

One line per change, tagged by check. Compressed, not prose:

```
Vocabulary  "task_progress" → "the per-task progress table"
Backstory   Added one sentence explaining why the sync was rebuilt
Stakes      Opened with the outcome; the fix detail moved down
Volume      Cut §3 (build log narration), 240 words, no reader value
Typography  Replaced 3 em dashes with colons and full stops
```

### 4. Escalations

Included only when they exist. Always questions, never guesses:

```
⚠ 2 things I couldn't explain without knowing more:
  · Line 12 "the relay change" — what was it, in one sentence?
  · "within tolerance" — what's the threshold, and who set it?
```

## Draft mode

Same rules, applied earlier. When invoked before writing, or when the user asks for
something written for an outside audience:

1. State the audience line first and allow one beat for correction.
2. Draft conclusion-first, with the six checks as constraints rather than a post-pass.
3. Run the audit on the resulting draft anyway, and report **only escalations** — no
   findings list, because the user never saw a "before."

Rule 1 applies in both directions: even when drafting, a fact Claude does not have is
asked for, not invented.

## Packaging

A single public GitHub repo serving as both marketplace and plugin host, installed with
`/plugin marketplace add OWNER/cold-read`. The GitHub owner (personal account or the
Obelyth org) is confirmed with the user at publish time; it is the one value in this
design that implementation cannot derive on its own.

```
cold-read/
├── .claude-plugin/marketplace.json      # marketplace manifest
├── plugins/cold-read/
│   ├── .claude-plugin/plugin.json
│   └── skills/cold-read/
│       ├── SKILL.md                     # rules, checks, output contract
│       └── references/examples.md       # worked before/afters (ships)
├── tests/fixtures/                      # adversarial fixtures (not shipped)
├── tests/baselines/                     # captured no-skill behavior (not shipped)
├── docs/superpowers/specs/              # this document
└── README.md                            # install line, what it does, example
```

Manifest schemas are to be verified against the locally installed
`claude-plugins-official` marketplace during implementation rather than written from
memory.

`SKILL.md` stays lean: the six checks, the two hard rules, the output contract, and the
draft-mode section. Worked examples live in `references/examples.md` so they load only
when needed.

Owning the marketplace leaves the door open to submitting the plugin to
`anthropics/claude-plugins-official` later, once it is proven in use.

## Testing

`cold-read` is a prose skill, so its tests are adversarial fixtures, stored in
`tests/fixtures/` and run against subagents before publishing. Each fixture pins one
failure mode. Fixtures are not shipped with the plugin; `references/examples.md` ships
and holds only the two teaching examples.

| Fixture | Required behavior |
|---|---|
| Text with an unexplained internal reference | Escalates; does not gloss |
| Text containing a hedge ("probably fixed") | Hedge survives the rewrite verbatim in strength |
| Bloated multi-section status report | Output is materially shorter |
| Text that is already plain and clear | Returns near-unchanged; states that it is already fine |
| Text with a buried conclusion | Conclusion moves to the top |
| Text mixing internal jargon with real numbers | Both Vocabulary and Framing findings appear, correctly tagged |
| Clear text containing en and em dashes | Zero dashes in output; a Typography finding; content otherwise untouched |

The already-clear fixture is the sneakiest: an invoked skill wants to justify itself by
rewriting. It is tested explicitly.

## Out of scope

- Automatic firing on artifact types (PR descriptions, commit messages, and similar).
  Explicit invocation only, per the trigger decision above.
- Tone, brand, or house-style enforcement. `cold-read` targets comprehensibility, not
  voice. Rule 3 is the sole typography constraint and is included because it is
  mechanical and because dash punctuation is an origin signal rather than a style
  choice; it is not a precedent for further style rules.
- Translation between human languages.
- Reading-level scoring or readability metrics. The six checks are the standard; a
  Flesch score is not.
