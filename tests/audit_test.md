# Audit-mode verification

Run each fixture through a subagent WITH the skill. Every row must pass.

| # | Fixture | Assertion |
|---|---|---|
| 1 | a-invented-context | Output contains an escalation for "the relay change" |
| 2 | a-invented-context | Output contains an escalation for "within tolerance" |
| 3 | a-invented-context | No invented definition of either term appears in the rewrite |
| 4 | b-hedge | "probably", "appeared to", "we think" survive at equal strength |
| 5 | c-volume | Rewrite is under 25% of the source word count |
| 6 | d-already-clear | Rewrite is substantively unchanged AND says it is already clear |
| 7 | e-buried-conclusion | First sentence states the conclusion |
| 8 | f-jargon-and-numbers | A Vocabulary finding AND a Framing finding both appear, correctly tagged |
| 9 | all | Response order is: audience line, rewrite, findings, escalations |
| 10 | all | The rewrite block contains no commentary, brackets, or change markers |
| 11 | g-dashes | Output contains zero en dashes (U+2013) and zero em dashes (U+2014) |
| 12 | g-dashes | A Typography finding appears naming the replacements |
| 13 | g-dashes | Content is otherwise unchanged (Rule 3 did not trigger a full rewrite) |
| 14 | all | No en or em dash anywhere in the response, for every fixture |

Check rows 11 and 14 mechanically, not by eye. These characters are near-invisible
in most terminals.

## Rows added after baseline capture

The baselines exposed failures the plan did not predict. These rows test for them.

| # | Fixture | Assertion |
|---|---|---|
| 20 | a-invented-context | Internal terms are glossed IN the rewrite, not listed as advice to the user |
| 21 | f-jargon-and-numbers | No placeholder (`[X]`, `TBD`, blank) appears in the rewrite; the gap is an escalation |
| 22 | a-invented-context | "not ours" is not softened into a hedge (claim strength unchanged in EITHER direction) |
| 23 | c-volume | The day-by-day narration is deleted, not converted to bullets |

## Results, 2026-07-28 (audit mode)

Passing: 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 20, 21, 22, 23.

**Row 5 NOT MET, deliberately left failing.** Fixture C compresses 312 words to 122,
a 39% ratio against an assertion of "under 25%". Two rounds of strengthening the
Volume check moved it from ~150 words to 122 and no further.

Left as a known deviation rather than resolved, because:

- Row 23 is the behavioral test the baseline actually motivated (delete the
  day-by-day narration, do not convert it to bullets), and row 23 passes. The
  chronology is gone.
- The 25% figure was an invented proxy for "materially shorter", not a measured
  requirement. Tuning the skill until an arbitrary number is hit, at the cost of
  dropping content a manager plausibly wants, would be fitting the product to the
  test.
- Changing the threshold to match the output would be worse: it destroys the row's
  value as a regression check.

Treat row 5 as a watch item. If a future change pushes fixture C back above ~50%,
that is a real regression in the Volume check and the number is doing its job.

# Draft-mode verification

| # | Assertion |
|---|---|
| 15 | Audience line appears before the draft |
| 16 | Draft opens with the conclusion, not the process |
| 17 | Escalations appear when a needed fact is missing |
| 18 | NO findings list appears (there was no "before") |
| 19 | The draft contains no en or em dashes |
