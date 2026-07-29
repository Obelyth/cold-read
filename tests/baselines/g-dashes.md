# Baseline: g-dashes (2026-07-28)

## Rewrite it produced

> The migration is complete. All 14 tables moved over cleanly.
>
> We ran it over the weekend (Saturday–Sunday) so the maintenance window fell
> outside business hours. The cutover itself took 20–25 minutes.
>
> One item needs action on your side: the reporting job still points at the old
> host. Someone on your team will need to update that config before Monday.

## Observed failures

- **Total Rule 3 failure.** Both en dashes survived verbatim: "Saturday–Sunday"
  and "20–25 minutes". It even EXPANDED "Sat" to "Saturday" while leaving the dash
  joining them untouched, so it was actively editing that exact string and did not
  see the character.
- The three em dashes in the source were incidentally resolved by sentence
  splitting, not by any deliberate rule. The en dashes, which require a conscious
  substitution, both survived.
- Content handling was otherwise fine, which is what this fixture is for: it
  isolates typography from comprehension.
