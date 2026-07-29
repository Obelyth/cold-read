# Cross-cutting patterns (2026-07-28)

Six of seven baselines were clean captures (fixture A was recaptured after
filesystem contamination). Patterns that appear across fixtures, ranked by how
badly they break the deliverable:

1. **Deferring the work back to the user.** (A, F) The rewrite keeps the jargon or
   leaves "[X]ms" in the text, then tells the user to fix it. The output is not
   paste-ready. This was the single most common failure and it was NOT predicted
   in the plan. The output contract's "ready to paste" clause needs to be loud.

2. **Reformatting instead of cutting.** (C, E) Prose becomes bullets, length holds
   roughly constant, and every build-log detail survives. "Make it clearer" is
   consistently read as "restructure", never as "delete".

3. **Claim strength drifts in both directions.** (B strengthened, A weakened.) The
   plan predicted only strengthening. Rule 2 must forbid any change, not just
   promotion.

4. **Rewriting text that needs nothing.** (D) Acknowledging the text is already
   fine does not prevent rewriting it. Twice.

5. **Dashes are invisible.** (D, E added them; G kept both en dashes while
   actively editing the surrounding words.) No baseline treated them as a defect.

6. **Escalations happen, but as appended prose.** Every single baseline ended with
   a "two things to check before you send" section. The instinct is already there.
   The skill's job is to structure it, not to create it, and to stop the questions
   from leaking into the rewrite itself.
