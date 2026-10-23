# Final borrowed bulk-caret control

Shipping source: **81bd9e53b7a18161903dad3816d494ed1afdfce3**. Base and matched
indexed baseline: **1d5bc3061cce3beb3c4857102ed651da501b5cfd**. Worktree:
`/root/gpui-monotonic-caret-borrowed`. This is a correctness/allocation/code control;
no speed result is claimed here. A later paired campaign must keep these labels.

The final production difference from the separately archived 0cbd control is only
the generic private visitor name and `&Self` callback spelling: four insertions,
four deletions, no algorithm/header/owner changes. `repair.patch.gz` preserves it.
The final binary is `/tmp/gpui-monotonic-control-bin/stream-final`, SHA-256
`d8d8141d5b46a7c16f2e177ed3ead2e60599be6ce7f9956f1b43f4143b432f98`.
Old binaries and their raw results were not overwritten or relabelled.

The stream preflights fonts and checked source/run/range admission before any
callback. It reuses an 8-byte source-run scatter (one slot inline; spill for
multiple runs) and one RTL visual-prefix scratch, plus previous/current ordinary
Entry values. Cached source owners feed the same cold pair policy as the random
index. No whole scalar Entry/byte-owner map is built on the monotonic admitted
path. Out-of-source-order disjoint runs, duplicate span ownership, and general
large-source fallbacks retain the existing indexed policy; decreasing requests
drain through ordinary cursors. Direct <=8 Canvas requests stay direct. Font
rejection still precedes geometry rejection. No reverse f32 subtraction or
narrowing of source authority was introduced.

Public owned Cluster iteration and private borrowed lowering use the same
`advance_cursor` recurrence. Range-only preflight uses line-scoped graphemes,
projected through the full run slice; lowering borrows Run/Atom/Grapheme and uses
the exact existing spacing/newline/path formulas. Trusted private Layout
Grapheme/Atom invariants remain a limit: corrupt internal Atom state may panic
during emission after earlier callbacks. The checked font/source admission is
atomic; this does not promise atomic handling of arbitrary private corruption.

Exact final-source checks:

* Canvas parallel: 193 passed /4 ignored; scalar:183 /3; 28 harnesses each.
* Independent direct/packed pair oracle:94,176 accepted /41,760 snapped /
  11,096 distinct, including full f64 box bits and packed stop behavior.
* Nine private stream tests passed, covering396 real producer layouts and
  malformed range/run/font cases, gaps, empty edges/middle, decreasing/repeated
  requests, spacing/justification, early completion and callback errors.
* Scoped allocation probe passed separately. Canvas all-target parallel Clippy
  with `-D warnings` passed. Standalone vendor Clippy still rejects the exact
  three pre-existing baseline diagnostics (two collapsible-if and one doc
  backtick); the introduced `use_self` warning is gone. No allowance was added.
* Public83 recording-owner transcript:2,678,729 bytes, SHA-256
  `1d529192f8bce827403feb865c800d20054ef98b96fa8043e29edce018f69a4f`,
  byte-identical to the indexed baseline and prior controls. All four owner
  lifetime/allocator rows match shared/0cbd exactly. Old P survives a failed new
  L and old-C ACK publishes the correct frozen map with zero allocations.
* All421 source guards pass after qualification and around public captures;
  final allocator rows also match the prior borrowed control byte for byte.

Scoped geometry-only transient requested/peak bytes:32KiB ASCII655,360 ->0;
Latin616,000 ->0; RTL367,200 ->172; mixed417,600 ->132; paragraph chunks187,200
->0; one long grapheme288,020 ->0. These exclude shaping and retained maps.
Out-of-order fallback keeps the indexed300B in its fixture. Whole-owner first C
is383 ->381 allocations,21,246,272 ->20,590,912 requested bytes,
12,817,120 ->12,170,700 peak, unchanged1,091,736 retained. These are allocator
requested/live measures, not RSS, native frame latency, or startup claims.

Final linked code matches the old borrowed control numerically: stream4612B /
local920B, logical visitor1979/600, RTL404/360, shared advance1538/136,
constructor747/56, cold pair1113/472, Planner14570/4536. Total .text0x121428 is
384B above the shared-pair formulation and12,496B above indexed baseline.
The hot visitors construct the272B iterator state directly in their locals;
the extra272B staging memcpy and144/136B public Cluster result moves are absent.
The state still exists. The152B offset construction and168B cold fallback move
remain. Individual stack reservations must not be summed into a peak claim.

Source ledger: six first-party shipping libraries30,432 non-test code lines,
including18 build-script lines; unchanged by later vendor refinements. Vendor
geometry476 lines and run362 (baseline142 and342). Total shipping change from
1d5 is **366 code lines**, including12 first-party and354 vendor. The existing
prepare/owner/census support is299, generic paired runner73, historical runner72;
these are non-test source too. This archive adds four capture scripts103 and
copied public clients165 physical code lines. Earlier copied clients/censuses
remain charged in their own archives. Private tests are190+253+92=535 code lines.
No retained field, global cache, sort, unsafe code, second shaped tree or new
font/layout algorithm was added.

Reproduction: apply complete `source.patch.gz` and `support.patch.gz` at1d5,
commit locally, then use the included span preparation and public sources with
paths relocated. Source patch contains only the three production files and the
Canvas oracle test. Support includes final nine private tests and timing driver.
Compiler JSON, exact locks/manifests, source/artifact guards, raw logs, linked
assembly, source counts and public transcript are included. `capture/` contains
the actual final freezing/inspection/capture/archive scripts with fixed local
paths; they document commands and must be relocated for another checkout.

The baseline is explicitly built at1d5. Its actual83 Cargo artifact records and
81 local rustc dependency inputs, plus root manifest/lock, are byte-identical to
main89aeabd53942c3a4643bcb6fd978e6a24703f6d2. The full path/hash proof is included;
WGPU is absent from that scoped shaper build. This does not turn the frozen
baseline into an89ae binary or qualify a current-main application build. Public
fixtures here are recording-owner gates, not native protocol/foreign runtime.
