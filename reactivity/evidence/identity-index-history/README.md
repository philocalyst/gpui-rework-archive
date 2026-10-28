# Exact identity index: adopted source and rejected extension

Main `c9344bd` integrates the reviewed source chain `8da013d5f8` → `75544537f7`
→ `f251f4be7b`. Its actual workspace check passes637 cases/docs, zero failures,
11 explicit ignores across105 groups. The attached log/check identifies this
integrated source; it does not retag earlier timings as c934 measurements.

The exact historical reports, raw samples, fixtures, build/source/binary guards,
linked assembly, and all losing cases are preserved in these independent archives:

| Archive | Evidence commit | Scope |
|---|---|---|
| [initial](initial.tar.gz) | `582bca6387` | 996 rows: BTree, packed entries, sparse runs and construction losses |
| [normalized](normalized.tar.gz) | `ab7925fd66` | 576 rows: ≥65K public property reads per lookup phase; actual inline caller proof |
| [rejected gap encoding](rejected-hole.tar.gz) | `412c476b69` | 900 rows: every sample retained; smaller index but slower complete owner |

The range/run index keeps the former24B header, Node40B and Presented80B.
Contiguous identity sets allocate no index storage; sparse runs retain16B each;
arbitrary order uses exact12B sorted entries. IDs are namespace-checked and never
reused; absent IDs inside gaps cannot alias live nodes. There is no unsafe code,
refcount, historical identity set, or per-target allocation table.

At65536 children the normalized frozen owner saves5963 mount allocations and
1192416 newly retained bytes. Complete growth peak is unchanged because other
scratch dominates. Large mount loses0.55%; tiny post-growth reads lose roughly
2.5ns. Dense even-odd index construction loses103.6% to the old map and22.8% to
the simpler packed candidate. These remain adoption costs, not discarded cases.

The later Hole encoding (`2eae1a93fb`/`db04a211c5`) saves a32B growth allocation
but loses6.09% in65K complete growth and has a92.1% tiny-growth median loss.
It is excluded from production. Neither code size nor lookup savings establishes
whole-owner improvement. These are descriptive software microbenchmarks, with
recorded pressure, not native click/startup or RSS/PSS claims.
