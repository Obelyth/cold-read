# Baseline: c-volume (2026-07-28)

## Rewrite it produced

A "Bottom line" paragraph, a "What changed" section, then a "How the week went"
section preserving all five days as bullets (Mon/Tue/Wed/Thu/Fri), then "Notes".
Roughly the same length as the 380-word source.

## Observed failures

- **Reformatted instead of cutting.** Every day of build-log narration survived,
  converted from prose to bullets. Rebasing 40 commits, the eleven-minute test
  suite, the lint rule, the two naming comments: all still there. The reader of an
  outward-facing update needs none of it.
- **Structure check passed.** It did move the outcome to the top as "Bottom line",
  unprompted. Structure is not the weak spot; Volume is.
- **Invented a fact.** "The batch window is now configurable at runtime" does not
  follow from the source, which says only that it *could* be tuned without a
  deploy. It flagged this itself as a judgment call, but shipped it in the rewrite
  anyway rather than escalating.
