Shipped the fix for the ingest regression that came in with the relay change.
task_progress rows were dropping on MX sync, and after the rollback the numbers
came back within tolerance. Rig-level counts are still off, but that's a
downstream issue, not ours.
