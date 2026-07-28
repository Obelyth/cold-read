# cold-read

Claude writes for a reader who was in the room.

Anything Claude produces inside a working session carries that session's context: repo
names, table names, decisions made an hour ago, jargon traded all day. When that text
leaves the session as a report, PR description, or client email, none of the context
goes with it. The reader gets something simultaneously over-written and under-explained.

`cold-read` performs the context transplant.

## Install

```
/plugin marketplace add OWNER/cold-read
/plugin install cold-read@cold-read
```

## Use

```
give this a cold read before I send it
```

It returns a paste-ready rewrite, a tagged list of what changed, and the part that
matters most: questions about anything it could not explain from the text alone.

## What it will not do

**It will not invent context.** If a sentence depends on a fact that isn't in the
text, `cold-read` asks instead of guessing. A fluent, confident, wrong summary is the
worst possible output, and plain language makes fabrication more believable, not less.

This holds under pressure. Told "I'm sending this in five minutes, no questions, fill
in anything unclear with your best guess", it still asks.

**It will not strengthen your claims.** "Probably fixed" stays "probably fixed." It
will not weaken them either. If a claim looks risky for the audience, that is a
question for you, not a silent edit.

**It will not rewrite text that's already clear.** If your draft works for an
outsider, it says so and hands it back.

**It will not leave em dashes or en dashes in your text.** They are the most
recognizable signature of machine-written prose, and this text is going out under your
name. Colons, commas, and full stops do the same work without the tell.

## Example

**In:**

```
Shipped the fix for the ingest regression that came in with the relay change.
task_progress rows were dropping on MX sync, and after the rollback the numbers
came back within tolerance.
```

**Out:**

> Written for: a manager who doesn't work on this project.

```
Shipped the fix for the data ingest problem that came in with a recent change.
Rows in the per-task progress table were being dropped during the sync. After
the rollback, the counts came back up.
```

```
Vocabulary  "task_progress" → "the per-task progress table"
Backstory   "the relay change" is unexplainable from the source; replaced with
            "a recent change" and escalated
Framing     "within tolerance" states no threshold; cut in favor of the concrete
            fact ("the counts came back up") and escalated
```

```
⚠ 3 things I couldn't explain without knowing more:
  · "the relay change": what was it, in one sentence?
  · "MX": what is it, in a few words?
  · "within tolerance": what is the threshold, and who set it?
```

Note what did not happen. "The relay change" was not paraphrased into something
plausible like "a recent networking update", and "within tolerance" was not softened
into "within expected range", which sounds like a clarification but asserts a standard
nobody stated.

## How it was built

The skill was written against recorded failures, not guesses. Seven adversarial
fixtures were first run through Claude *without* the skill to capture what it actually
does by default; those baselines are in `tests/baselines/`. The rules exist to counter
the specific behaviors observed there.

Two of the failures were not the ones expected going in:

- The most common failure was not inventing context. It was **handing the work back**:
  keeping the jargon and then advising the user to gloss it, or leaving `[X]ms` in the
  text.
- Claim strength drifted in **both** directions. One run promoted "appeared to help"
  to "reduced the timeouts"; another added a hedge to a flat assertion.

Verification lives in `tests/audit_test.md`. 22 of 23 assertions pass. The one that
does not is documented there rather than quietly relaxed.

## License

MIT
