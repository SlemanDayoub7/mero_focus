# ADR-0004: Drift (SQLite) as the Local Database

**Status:** Accepted

## Context
The single most important feature of the app is detailed statistics across multiple time granularities (hour/day/week/month/year/years/custom range). This requires complex, frequent aggregation queries (GROUP BY date, SUM duration, overlapping-range filters).

## Decision
Adopt **Drift** (built on SQLite) as the sole local database.

## Rejected Alternatives
- **Isar**: faster for simple reads/writes (NoSQL), but complex aggregation queries (central to our statistics feature) are harder and less efficient than real SQL.
- **Hive**: suitable for simple key-value storage, not suitable at all for analytical queries.

## Rationale
- Real SQL (via `GROUP BY`, `strftime`, etc.) is the natural and most powerful tool for computing multi-granularity time-based statistics.
- Full type-safety between code and Dart via Drift's generated code.
- Mature migration support, important since the schema will grow (e.g. when `mode_system` is activated later, or new fields are added).

## Consequences
- All statistics queries are written as `customSelect` or via Drift's query builder within the `data/` layer of the `statistics` feature.
- See `data-model.md` for the full schema.
