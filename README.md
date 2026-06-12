# Training Activity

A small, read-only Business Central extension for **PrintVis** that shows a
per-employee snapshot of onboarding/training milestones.

For each Business Central user it counts (and dates) the first and latest time
they performed a set of monitored activities: creating customers, vendors,
items, completing a case estimate, moving a quote to order, creating sales
orders, scheduling production, purchasing, posting receipts, shop-floor
registrations, and releasing inventory. Each milestone is proven by data
Business Central already stamps (`SystemCreatedBy` / `SystemCreatedAt`, plus
`PVS Case` datetime fields). **Nothing is written** to the database.

Open the **Training Activity** page (search for it in Tell Me) and use
**Refresh** to rebuild the snapshot. Drill into any cell for the underlying
records.

## Notes

- **Attribution** is based on `SystemCreatedBy`. Records created by an
  integration, a data migration, or a job-queue account are credited to that
  account, not to a trainee. Expect those to show up as their own rows.
- **"Released"** counts positive `Item Ledger Entry` rows (output or other
  receipts into inventory), dated by when the entry was created.

## Requirements

- Business Central 26.x
- PrintVis 26.0.0.0 or later (uses the `PVS Case` table)

## Object range

Objects use IDs **50000–50005** with **no name prefix**. This is the shared
per-tenant range, fine for testing as-is.

## Before you ship this to your own customers

This is a courtesy starter. Make it yours first:

- Move the objects into **your own registered ID range**.
- Add **your own affix/prefix** to the object names.
- Set **`publisher`** (and `name`) in `app.json` to your own.

## License

Released into the public domain under **The Unlicense** (see `LICENSE`).
Anyone can use it, for any purpose, **at their own risk**. Provided AS IS,
with no warranty, no liability, and no support.
