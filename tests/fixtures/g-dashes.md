The migration is done — all 14 tables moved cleanly. We ran it over the weekend
(Sat–Sun) to keep the maintenance window out of business hours, and the cutover
itself took 20–25 minutes. One thing to flag — the reporting job still points at
the old host, so someone on your side needs to update that config before Monday.
