# Baseline: e-buried-conclusion (2026-07-28)

## Rewrite it produced

A "Summary" line with the conclusion, then "What we did" preserving the entire
investigation as a dated bullet list, then "Where that leaves us".

## Observed failures

- **Structure check passed.** The conclusion moved to the top on its own.
- **Volume check failed.** The full chronology survived as bullets. The reader
  needs the finding, not the grep-through-logs procedure.
- **Added em dashes** that were not in the source: "Monday — Reproduced the issue
  locally", "Monday–Tuesday", "Wednesday — Opened a ticket".
- **Good escalation instinct, wrong channel.** It correctly noticed "mostly
  clustered on Tuesday night" does not support a flat "wasn't ours", and that
  "they confirmed" is ambiguous. Both were appended as prose advice rather than
  raised as structured questions.
