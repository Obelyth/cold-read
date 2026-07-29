p99 on the /sync endpoint dropped to 340ms after we moved SKU lookups off the hot
path and into the warm cache. CTR unaffected.
