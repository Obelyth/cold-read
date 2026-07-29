The timeout probably stems from the connection pool, though we haven't confirmed
it. Raising the pool size appeared to help in staging, and we think the same
change will hold up in production.
