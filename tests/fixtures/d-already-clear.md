We found the cause of last week's slow checkout page. One database query was
running once per item in the cart instead of once per cart, so a cart with 40 items
ran 40 queries. We changed it to a single query. Checkout now loads in about half a
second, down from four seconds. No action needed from your team.
