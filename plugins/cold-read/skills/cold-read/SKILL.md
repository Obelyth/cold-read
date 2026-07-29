---
name: cold-read
description: Use when text is going to be read by someone outside this session: a report, PR description, email, summary, doc, or post. Rewrites project-context-heavy writing so a smart reader with zero background can follow it, and flags where context is missing rather than inventing it.
---

# Cold Read

## Overview

Claude writes for a reader who was in the room.

Text produced inside a working session carries that session's context: repo names,
table names, decisions made an hour ago, jargon traded all day. The reader has none
of it. The result is text that is over-written and under-explained at the same time.
Long, because there was context to spend. Opaque, because none of it transferred.

This skill performs the context transplant. Give it text, and it returns a version a
smart reader with zero project background can follow, and tells you where it could
not, instead of guessing.

**Two modes, one rule set:**

- **Audit** (default). You have text; the skill rewrites it and reports what changed.
- **Draft.** You are about to write; the skill applies the same checks up front. See
  "Draft mode" below.

## Audience: infer, state, floor

1. **Infer** the reader from the artifact. A PR description is read by another
   engineer; a status report by a manager; a client email by a non-technical outsider.
2. **State** the inference in one line, before anything else, so it can be corrected
   cheaply.
3. **Floor** every assumption at *smart person, zero project context*. Inference may
   raise the register. It may never license unexplained internal vocabulary.

Ask about the audience only when the inference is genuinely ambiguous. One question,
then proceed.

## The six checks

Run all six, in order. Every finding is tagged with the check that produced it.

| Check | Catches |
|---|---|
| **Vocabulary** | Internal names, acronyms, repo/service/table names, ticket IDs, tool names used without a gloss |
| **Backstory** | Sentences that only parse if you know what happened earlier |
| **Stakes** | Says what happened, never why the reader should care |
| **Framing** | Numbers and technical detail with no reference point |
| **Structure** | Organized the way the work happened (chronological, per-file, per-commit) instead of conclusion-first |
| **Volume** | Long because there was context to spend, not because the reader needs it |

**Volume authorizes deletion.** The reflex when asked to clarify is to *add*
explanation, or to convert prose into bullets, which changes the shape without
changing the length. Neither is the job. Most over-written context-heavy text should
come out shorter. Cutting a section is a legitimate finding; say what you cut and why.

Reformatting is not cutting. If the source walks through five days of work and your
version has five bullets, you have not applied this check.

Neither is compressing each part. Turning five days of narration into four tight
paragraphs that still cover all five days is the same failure at a smaller size. Ask
what the reader will act on or remember, keep that, and drop the rest entirely. For a
process-heavy source, the honest answer is usually a small fraction of the original.
"Where the week went" is rarely one of the things worth keeping.

## Hard rules

These override everything else, including the user's apparent wish for a finished
document.

### Rule 1. Never invent context

If a sentence cannot be made clear without a fact that is not in the source text, it
does not get a plausible gloss. It becomes an escalation: a direct question.

This is the whole difference between this skill and "simplify this." Without it, the
characteristic failure is a confident, fluent, wrong summary. Plain language makes
fabrication *more* believable, not less, so a smooth guess here is worse than an
awkward question.

You are not failing the task by escalating. Escalating **is** the task.

Watch for the quiet version of this. Replacing "within tolerance" with "within
expected range" feels like a clarification and is actually an invention: it asserts a
standard nobody stated. If you cannot name the threshold, the phrase is an escalation,
not a rewording.

### Rule 2. Preserve claim strength

Cut, reorder, retitle, and re-register freely. Never change how strongly a claim is
made, **in either direction**.

Do not strengthen:

- "Probably fixed" does not become "fixed."
- "Appeared to help" does not become "reduced the timeouts."
- "We think it will hold" does not become "it will hold."

Do not weaken either:

- "That's a downstream issue, not ours" does not become "our current read is that it
  may originate downstream."
- A flat statement does not acquire a hedge because the claim seems risky to you.

Hedges are load-bearing, and so is their absence. If a claim looks overconfident for
the audience, that is an escalation ("you assert this is not our issue; do you want
that stated flatly to an outside reader?"), not a silent edit.

Note the trap: rewriting hedges into "plain statements of what we know versus what we
assume" feels like clarity work. It is a Rule 2 violation wearing a good disguise.

### Rule 3. No en dashes or em dashes

The rewrite, the findings, and the escalations must contain no en dash (U+2013) and
no em dash (U+2014). Hyphens in compound words are fine.

This is not a style preference. Text produced here goes out under a person's name,
and dash-heavy punctuation is the most recognizable signature of machine-written
prose. A reader who notices it stops evaluating the content and starts evaluating
where it came from.

Replace them, do not delete them:

| Where a dash was doing the work | Use instead |
|---|---|
| Setting off an aside | Commas, or parentheses |
| Introducing an explanation | A colon |
| Joining two independent clauses | A full stop, or a semicolon |
| A numeric range | "3 to 5" |
| A date span | "Monday to Friday" |

Splitting into two sentences is almost always the best fix. A sentence that needed a
dash was usually doing two jobs.

This section deliberately describes the characters rather than printing them, so that
this file passes its own check.

Check the finished output for both characters before returning it. This one is
mechanical, so there is no judgment call and no excuse for a miss. Note that a range
written with a dash survives editing very easily: expanding "Sat" to "Saturday" while
leaving the dash between the two days is a miss, not a partial success.

### Corollary. No-op is a valid result

If the text already reads cleanly to an outsider, say so and return it essentially
unchanged. An invoked skill feels pressure to justify itself by rewriting. Reject that
pressure. "This is already clear; I changed two words" is a good outcome, not a
wasted turn.

Noticing that the text is already fine does not license restructuring it anyway.
Adding headers, subject lines, or bold labels to clear prose is rewriting, and
offering two alternative versions is rewriting twice.

Rule 3 is the one exception. If the source text contains en or em dashes, replacing
them is a required change even when nothing else needs touching.

## Output contract

Always this order. Never reordered, never merged.

**1. Audience line.** One line, before everything:

```
Written for: a manager who doesn't work on this project.
```

**2. The rewrite.** Clean text, ready to paste.

"Ready to paste" is a hard constraint, and it is the one most often broken. The
rewrite must contain:

- No placeholders. Not `[X]ms`, not `TBD`, not a blank to fill in.
- No vestigial comparisons. "Down from before the change", "faster than it was",
  "improved versus the previous figure" are placeholders in prose form: they promise
  a number and deliver nothing. If you do not have the baseline, state the figure
  you do have and escalate the missing one. "Now finishes in 340 milliseconds" is
  complete; "340 milliseconds, down from before" is a gap wearing a sentence.
- No bracketed notes, change markers, or tracked diffs.
- No advice to the reader about the text. "These are internal terms, gloss them if
  your recipient does not share the vocabulary" is not a rewrite. It is the job,
  handed back undone.
- No jargon left standing on the theory that the user can decide.

If you know a term needs glossing, gloss it. If you cannot gloss it without a fact
you do not have, escalate it and leave it out of the rewrite. Those are the only two
options. Passing the decision back to the user is the failure this skill exists to
prevent, because the user is the one person who cannot see the problem: they have the
context.

A term you escalate does not also stay in the rewrite. Escalating "within tolerance"
and then writing "the counts came back within tolerance" is both options at once,
which leaves the reader exactly where they started. Cut the phrase, or say the
concrete thing you do know ("the counts came back up"), and ask your question in the
escalations.

**Return one rewrite.** Do your checking before you answer, not in front of the user.
If you draft something and then notice it breaks a rule, fix it silently and return
the fixed version. A visible correction, a second "here it is without the
placeholder" pass, or two alternative versions to choose from all put your working
process into a deliverable that is supposed to be paste-ready. The user asked for
text to send, not a demonstration that the rules were followed.

**3. Findings.** One line per change, tagged by check, compressed.

Use only these tags: **Vocabulary**, **Backstory**, **Stakes**, **Framing**,
**Structure**, **Volume**, **Typography**. Do not invent new ones. "Claim", "No-op",
and "Tone" are not tags; if a claim was preserved rather than changed, that is not a
finding at all, because nothing changed.

Tag by the check that caught the problem, not by what you did about it. A number with
no baseline is a **Framing** finding even when the resolution was to escalate rather
than to fix it. If a check found something you could not resolve, say so on its line
and point at the escalation.

```
Vocabulary  "task_progress" → "the per-task progress table"
Backstory   Added one sentence on why the sync was rebuilt
Stakes      Opened with the outcome; fix detail moved down
Volume      Cut §3 (build log narration), 240 words, no reader value
Typography  Replaced 3 em dashes with colons and full stops
```

**4. Escalations.** Only when they exist. Always questions, never guesses:

```
⚠ 2 things I couldn't explain without knowing more:
  · Line 12 "the relay change": what was it, in one sentence?
  · "within tolerance": what's the threshold, and who set it?
```

Escalations belong here and nowhere else. Do not append them to the rewrite as a
closing paragraph of advice, and do not let them leak into the rewrite as a
parenthetical. The rewrite is for the reader; the escalations are for the user.

## Draft mode

Same rules, applied before the fact rather than after. Use when you are writing
something outward-facing from scratch, or when the user hands you raw notes and asks
for the finished piece.

1. **State the audience line first** and allow one beat for correction.
2. **Draft conclusion-first**, treating the six checks as constraints while writing
   rather than as a cleanup pass.
3. **Audit your own draft anyway**, and report **only escalations**.

**No findings list in draft mode.** A findings list describes changes between a
before and an after. The user never saw a before, so listing your own edits to your
own draft is noise at best and misleading at worst: it presents choices you made
while writing as though they were corrections to the user's work.

The output is exactly three parts: audience line, the draft, then escalations if any.
If you catch yourself writing "Vocabulary: glossed X" about a sentence you wrote
thirty seconds ago, delete the whole section.

Rule 1 applies in both directions. When drafting, a fact you do not have is asked
for, not filled in. The temptation is stronger here: a draft with a gap looks
unfinished, while a draft with an invented detail looks complete. The
complete-looking one is the failure.

When the notes mention something you cannot explain, leave it out of the draft and
escalate it. Do not gesture at it vaguely to cover the gap.

Rule 3 applies to drafts too, and it is easier to honor here. You are writing the
sentences fresh, so write them without en or em dashes in the first place rather
than stripping them afterward.

## Red flags

These thoughts mean stop. You are rationalizing.

Rows marked with a dot were observed verbatim in testing, either in baseline runs
without this skill or in early runs against it. They are not hypothetical.

| Thought | Reality |
|---|---|
| · "I'll note that these are internal terms and let the user decide whether to gloss them" | That is the job, handed back undone. Gloss it or escalate it. |
| · "I'll leave a placeholder for the number I don't have" | A placeholder in a paste-ready rewrite is a defect. The gap is an escalation. |
| · "I'll replace the hedges with plain statements of what we know versus what we assume" | That is a Rule 2 violation with a respectable name. The hedges are the content. |
| · "The uncertainty is intact" | You are grading your own work on the rule you just broke. Compare the actual words. |
| · "This claim looks risky for an outside reader, I'll soften it" | Rule 2 runs both ways. Softening is an edit. Ask instead. |
| · "The original was already accurate, so this is structural, not substantive" | Then leave the structure alone too. Recognizing the text is fine does not license rewriting it. |
| · "I'll give them a formatted version and a plain prose version" | Two rewrites is rewriting twice. Return one. |
| · "I drafted something that broke a rule, I'll show the corrected version after it" | Fix it silently. Your working process is not the deliverable. |
| · "I turned the five days into five bullets" | Reformatting is not cutting. The chronology should be gone, not restyled. |
| · "I'll tag this finding Claim / No-op / Tone" | The tag list is closed. Seven tags, no additions. |
| "The reader probably knows what X is" | The floor is zero context. Gloss it or escalate it. |
| "A short gloss is better than bothering the user" | A wrong gloss is worse than any question. Rule 1. |
| "Within expected range is just a clearer way to say within tolerance" | It invents a standard nobody stated. Rule 1. |
| "This is already pretty clear" | Maybe. Run all six checks explicitly before concluding that. |
| "Cutting this might lose information" | It loses information the reader was never going to use. Volume authorizes cutting. |
| "It's short, so it's fine" | Short and contextless is the most common failure, not the exception. |
| "I should rewrite something to show I did the work" | No-op is a valid result. Say it's already clear and stop. |
| "This em dash is genuinely the clearest punctuation here" | Rule 3 is mechanical and has no exceptions. Use a colon or split the sentence. |
| "The dashes were in the user's original, so they're intentional" | Rule 3 applies to your output regardless of the input. Replace them. |
| · "I expanded Sat to Saturday, so I handled that range" | Expanding the words while leaving the dash between them is a miss. Check the character. |
| "It's only one dash" | Check the output for both characters before returning. One is a miss. |

## Worked examples

See `references/examples.md` for two full before/afters: one heavy audit with
escalations, one no-op.
