# Worked examples

Two full audits. The first is a heavy rewrite with escalations; the second is close
to a no-op.

Neither output contains an en dash or an em dash, including the second example where
the input had them. That is Rule 3, and these examples are what it looks like in
practice.

## Example 1. Heavy audit

**Input:**

```
Shipped the fix for the ingest regression that came in with the relay change.
task_progress rows were dropping on MX sync, and after the rollback the numbers
came back within tolerance. Rig-level counts are still off, but that's a
downstream issue, not ours.
```

**Output:**

Written for: a manager who does not work on this project.

```
Shipped the fix for the data ingest problem that came in with a recent change.
Rows in the per-task progress table were being dropped during the sync. After
the rollback, the counts came back up. Counts at the rig level are still off,
but that is a downstream issue, not ours.
```

```
Vocabulary  "task_progress" → "the per-task progress table"
Vocabulary  "MX sync" → "the sync"; the system name is escalated, not guessed
Backstory   "the relay change" is unexplainable from the source; replaced with
            "a recent change" and escalated
Backstory   "shipped the fix" and "after the rollback" describe two different
            events; escalated rather than reconciled
Framing     "within tolerance" states no threshold; cut in favor of the concrete
            fact ("the counts came back up") and escalated
```

```
⚠ 4 things I couldn't explain without knowing more:
  · "the relay change": what was it, in one sentence?
  · "MX": what is it, in a few words?
  · "within tolerance": what is the threshold, and who set it?
  · Was the shipped fix the rollback itself, or did a separate fix go out
    after the rollback?
```

Three things worth noticing.

**"The relay change" was not paraphrased into something plausible** like "a recent
networking update." It became "a recent change", which is honest about knowing
nothing, and the real question went to the escalations.

**"Within tolerance" was cut, not softened.** Rewriting it as "within expected
range" would read as a clarification and would actually assert a standard nobody
stated. The rewrite says the concrete thing the source supports, which is that the
counts came back up.

**"Not ours" stayed flat.** It is a strong claim to make in writing to an outside
reader, and the temptation is to hedge it. Hedging is an edit. If the assertion
deserves scrutiny, that is a question for the user, not a silent change.

## Example 2. Near no-op, dashes only

**Input:**

<!-- dash-demo: this block intentionally contains the characters Rule 3 forbids -->

```
We found the cause of last week's slow checkout page — one database query was
running once per item in the cart instead of once per cart, so a cart with 40
items ran 40 queries. We changed it to a single query. Checkout now loads in
about half a second, down from four seconds. Traffic was normal all week
(Mon–Fri). No action needed from your team.
```

**Output:**

Written for: a manager on another team.

```
We found the cause of last week's slow checkout page: one database query was
running once per item in the cart instead of once per cart, so a cart with 40
items ran 40 queries. We changed it to a single query. Checkout now loads in
about half a second, down from four seconds. Traffic was normal all week
(Monday to Friday). No action needed from your team.
```

```
Typography  Em dash → colon; the "Mon-Fri" range → "Monday to Friday"
```

```
Nothing else changed. This already works for a cold reader: the one technical
term is explained in the same sentence, the numbers have a before and after,
the conclusion is first, and it says what the reader has to do.
```

This is the shape a no-op takes once Rule 3 exists. The content needed nothing. Two
punctuation marks still had to go, and the findings list says so plainly rather than
inventing other changes to look busy.

What would have been wrong here: adding a subject line, splitting it into
Cause/Fix/Result headings, or offering a second "plain prose" version alongside a
formatted one. All three are rewriting text that was already doing its job.
