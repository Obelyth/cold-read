# Baseline: a-invented-context (2026-07-28)

First capture was CONTAMINATED: the subagent searched the filesystem, found the
design spec, and answered from it. Discarded. Recaptured with "do not use any
tools" in the prompt. Only the clean capture is recorded here.

## Rewrite it produced

> The ingest regression that came in with the relay change has been resolved.
> task_progress rows were being dropped during MX sync; we rolled the relay change
> back, and ingest volumes are now back within expected range.
>
> One item remains open: rig-level counts still don't reconcile. Current read is
> that this originates downstream of ingest rather than in the ingest path itself.
> We're confirming that before handing it off.

Then appended: "Also worth checking: `task_progress`, `MX sync`, `relay change`,
and `rig-level` are internal terms. If the recipient doesn't share that
vocabulary, gloss them or the update won't land."

## Observed failures

- **Punted the vocabulary work back to the user.** Every internal term survives
  verbatim in the rewrite. It then TELLS the user those terms need glossing. The
  output is not paste-ready, and the one job the reader needed doing was handed
  back as homework. This is the dominant failure and I did not predict it.
- **Did not invent "the relay change"** (good) but also did not escalate it. It
  simply kept the phrase, which reads as understood.
- **Softened a claim.** "that's a downstream issue, not ours" became "Current read
  is that this originates downstream." The original asserted; the rewrite hedges.
  Rule 2 violation in the OPPOSITE direction from the one predicted.
- **Quiet gloss of an unknowable.** "within tolerance" became "within expected
  range", which sounds equivalent but invents a standard nobody stated.
