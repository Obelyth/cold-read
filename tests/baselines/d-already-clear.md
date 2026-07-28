# Baseline: d-already-clear (2026-07-28)

## Rewrite it produced

TWO complete rewrites. A formatted version with a subject line and bold
Cause/Fix/Result labels, plus an alternate "plain prose" version. For a source
that was already clear.

## Observed failures

- **The no-op trap worked perfectly.** Text that needed nothing got restructured
  twice. It even acknowledged "the original was already accurate, so this is
  structural, not substantive" and then restructured it anyway. Recognizing the
  text is fine does not stop the rewriting.
- **Added an em dash** that was not in the source: "once per cart — so a 40-item
  cart triggered 40 separate queries."
- **Invented a delivery concern.** It raised whether the fix is deployed or merely
  merged. Reasonable instinct, but nothing in the source suggests it.
