# Match borrowed SQL text before owning result rows

Source `2c2d8d3e93` fuses SQLite retrieval and Nucleo matching; its original
control is `56e1f5ddf1`. All 39 real migrations and the original nine domain rows
are used, plus 25,000 explicitly seeded tracks (IDs 20,000 through 44,999).
These are database rows for a search allocation experiment, not a claim to have
ported a 25k-track player's entire UI. Database construction and Matcher creation
are outside the measured scope.

The unchanged external driver runs three fresh processes per executable. Cold
and warm searches reuse the same worker scratch within each query case. Allocation
fields match exactly across repeats; row counts and ordered-ID diagnostic digests
match across versions. The digest is FNV-1a64, not an assertion of byte-for-byte
serialized ID equality. The separate real query/public-owner tests assert exact
expected IDs and ordering on the original edge-case fixture.

| Cold query | Results | Requested Rust bytes, before → fused | Allocation calls, before → fused | Peak requested bytes, before → fused |
| --- | ---: | ---: | ---: | ---: |
| All rows | 25,009 | 10,387,410 → 5,669,106 | 50,053 → 50,039 | 6,848,506 → 4,161,844 |
| No match | 0 | 5,669,245 → 783 | 50,043 → 14 | 4,161,736 → 525 |
| Greek artist | 1 | 5,669,558 → 1,122 | 50,043 → 16 | 4,161,736 → 818 |
| Worker artist | 25,000 | 10,387,544 → 5,669,082 | 50,055 → 50,026 | 6,848,582 → 4,162,072 |

Retained requested bytes match for every case. Rejected rows no longer allocate
owned title/artist strings or an intermediate row vector. Accepted rows still
own their result strings. All-match searches still materialize the entire result
set, and the reused corpus still copies text for Nucleo's contiguous haystack.
Every row validates projected types and UTF-8 before filtering; a malformed
nonmatching SQLite value remains an error. Cancellation discards partial results
and checks again before returning a complete page.

All nine standalone query/search/public-owner cases, strict headless all-target
Clippy and the shared headless executable transcript pass. These results do not
retag the earlier native port transcript as this later source. Raw logs preserve
an initial external-driver compile error (one excess unwrap), followed by the
corrected, identical driver used for both measured binaries.

`provenance.json` records source/driver/lock/executable hashes and capture guards.
The baseline source hashes were recorded after building and before edits; no
prebuild dirty-status capture is claimed. The driver manifest retains its actual
absolute paths. To reproduce elsewhere, point its port and vendor paths at a
checkout of each stated source, build with the same debug profile and run the
executable three times. Source and evidence are committed separately.

These are current-thread Rust allocation-counter measurements. SQLite's C heap,
existing matcher memory, database initialization, the UI runtime/window, RSS and
elapsed time are excluded. No native latency, GPU, SIMD or assembly result is
inferred from this allocation reduction.
