# Scoped slots and cached boundary controls

These are separate correctness/cost controls, not adopted performance wins.
The initial 16-byte stream's measured loss remains in `../control16`; its
production, binaries and timings were not changed by these successors.

| Control | Shipping pin | Source geometry code lines | Example .text | Bulk body / local reservation |
| --- | --- | ---: | ---: | ---: |
| old indexed baseline | 1d5bc3061cce3beb3c4857102ed651da501b5cfd | 142 | 0x11e358 | not applicable |
| 16-byte slots | 62ef2508c2346fcd71d4616a85000da530313e1e | 369 | 0x120d78 | 6903 / 1960 bytes |
| 8-byte Vec slots | c3acaf4681150494dd0fa3a73e0e59a3333068ea | 372 | 0x120b38 | 6935 / 1960 bytes |
| 8-byte inline-one + spill | cca9061a22b5385c7ca6fdcb0663f318851dd8b7 | 387 | 0x120dc8 | 7017 / 1960 bytes |
| cached boundary owners | 8d8afa5dc2aa56d370961c1b82ece01a3eec91ba | 474 | 0x121b08 | 8259 / 2056 bytes |

Body sizes include the complete monomorphized bulk visitor. Cached lowering also
has a 1113-byte cold helper with a 472-byte local reservation and a distinct
936-byte `geometry_with` instantiation. The old indexed cold pair remains
774 bytes plus its own 1080-byte geometry body. Frame figures are individual
local reservations, not aggregate peak stack. The cached control duplicates
the indexed pair policy; a shared-helper successor must have its own pin.
All four successors count 30,432 first-party shipping code lines, including
18 build-script lines, versus baseline 30,420. Authored vendor changes above
are additional shipping source, not excluded costs. No retained owner/header
changed. `lines-summary.json` and compressed full counter outputs qualify this.

Each source passed the independent ordinary-cursor / packed-stop bit oracle:
94,176 accepted pairs, 41,760 snapped requests and 11,096 distinct pairs.
The slot controls also passed seven private source/admission cases, including
396 actual producer layouts (2468 lines, 629 split runs, 144 empty edge runs).
Those actual layouts contain no empty run between other runs. Cached lowering
passed eight cases, adding deliberately constructed admitted trailing-gap and
empty-middle-run layouts. Its final test source is 2fa22b179c02bd3ff863176ddb75a93e8d6bc4f2.
The rejected nonexistent-field attempt is preserved. The qualification JSON
records the actual overlay file hashes and test features; it preserves the
earlier generated provenance rather than pretending that provenance described
the subsequently corrected test. These targeted controls do not claim the
initial 16-byte control's full-suite, public-owner or strict qualification.

Already-shaped API measurements retain zero bytes. The common single-run
scratch requested/peak changes 64 -> 32 -> 0 bytes (16-byte, 8-byte, inline).
RTL changes 316 -> 172 -> 172 and mixed 252 -> 132 -> 132 bytes. The old-index
fallback remains live alongside spill scratch when needed; out-of-order
disjoint source ranges request 364 -> 332 -> 300 bytes. All allocation rows
and checksums are preserved, including the tiny Canvas path which remains
direct. Fourteen ordinary scoped-shaper rows have matching baseline checksums;
cached boundaries match inline's actual allocation rows. This is allocation
evidence, not a claim about speed or the unrelated process startup cost.

`census-inline` and `census-boundary` are separately compiled, instrumented
private copies; their ordinary Canvas client is unchanged. Font priming makes
two shapes in cold processes and three in warm processes. STREAM delimiters
identify each bulk call; outside counts retain the unchanged tiny/direct path.
For one bulk call, both cold and warm have these exact counts:

| Source | Old direct pairs | Old cursor geometry / visual_offset | Old preceding-run steps | Old prefix-cluster steps | New cached pairs |
| --- | ---: | ---: | ---: | ---: | ---: |
| label | 2 | 4 | 0 | 34 | 2 |
| Latin | 601 | 1202 | 0 | 30251 | 601 |
| RTL | 5401 | 10802 | 91817 | 10804 | 5401 |
| mixed | 4640 | 9280 | 58308 | 13368 | 4640 |

Cached bulk calls have zero direct pairs, ordinary cursor geometry calls,
visual-offset calls and prefix-scan steps. Tiny, paragraph-chunk and one-large-
grapheme direct paths remain identical. Raw marker transcripts, exact probe
patches, lockfiles, client/manifest hashes, binaries' hashes, and source guards
before/after every process are included. Markers perturb execution and allocator
behavior: their allocator stdout and duration are explicitly unqualified.
No timing campaign was run for these three successors.

Each variant's `source.patch.gz` is the complete binary Git diff from baseline
1d5bc3061c through its shipping pin restricted to crates/vendor. The common
`support.patch.gz` is the complete span-fixture/helper diff through d53f785e60.
Apply one source patch and the support patch at that baseline to reconstruct
without unpublished branch objects. Generate a local commit and pass its ref
to the span `prepare.py` helper. The ordinary example builds with the root
lockfile, offline, release/default SIMD, empty encoded Rust flags and two jobs;
compiler JSON, source maps and exact executable hashes are archived per variant.
Paths in manifests/metadata describe this machine; relocate paths explicitly
when reconstructing. The census preparer accepts repo/ref/output; its runner's
recorded `/tmp` inputs are ordinary filesystem paths, not production APIs.

Additional non-test evidence source is charged: prepare.py 84, owner.rs 94,
prepare_census.py 81, run_census.py 40 code lines (299 total). The earlier
timing driver is another 72 lines in control16's support archive. Private test
source is 190 + 162 + 92 code lines. All counts exclude comments/blanks only;
there is no hidden shipping test API. Imported fonts and producer code retain
their existing licenses and exact source pins.
