# Baseline: f-jargon-and-numbers (2026-07-28)

## Rewrite it produced

> We changed how the /sync endpoint retrieves SKU data — those lookups no longer
> happen during the request itself and are now served from a cache instead. As a
> result, the slowest 1% of /sync requests now complete in 340ms or less
> (previously [X]ms). We saw no change in click-through rate.

## Observed failures

- **Left a literal placeholder in the rewrite.** "(previously [X]ms)" is in the
  paste-ready text. It correctly identified the missing baseline, then put the gap
  INTO the deliverable instead of into a question. This is the exact right
  instinct routed to the exact wrong place.
- **Added an em dash** not present in the source.
- **Vocabulary and Framing both handled well otherwise.** p99 became "the slowest
  1%", hot path and warm cache were unpacked, CTR was spelled out. This fixture is
  the closest any baseline came to correct.
