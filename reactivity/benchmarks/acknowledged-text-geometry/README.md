# Acknowledged text geometry: immutable-map correctness control

This records formulation A, not a memory winner or a claim of complete browser
editing parity. Its shipping source is `86dd5861429522a2ce4dd8c0edb3a6f3483a7d04`.
The baseline library is `6d77c71c1227bd2609518cc5f3a49e37fc176f82`; baseline
probe-only commit `58f4a18593` changes tests, not the library. Raw successes,
failed controls, manifests and assembly are retained under `evidence/`.

## Authority and public operations

Every shaped text site has one immutable Canvas `Arc<TextGeometry>` containing
source runs, line metrics and the canonical byte/affinity caret map. It retains
neither glyph buffers nor font faces. Mutable logical glyph layout L, local
preparation T, the latest complete candidate C and acknowledged presentation P
have separate lifetimes. A failed new L/T leaves C and P intact; acknowledging
an eligible old C transfers that exact column. KEEP does not relabel a column.
Native activation after the original ACK reads this existing P, even when AT was
inactive at that ACK. All labels are interactively shaped to support this rule.

`Part::text_geometry()` borrows the exact P map, text origin, affine, viewport
clip and target predicate. Content coordinates are logical layout units; placed
queries use window physical pixels, including DPI once. It exposes directional
runs, grapheme advances, caret bounds/line, selection rectangles, a nearest-caret
query and a distinct containing-unit query. `hit_position` uses the ordinary P
dispatcher predicate, including rounded targets and ancestor viewports;
`position_at` deliberately clamps outside the target for drag policy. Semantic
viewport geometry is continuous; raster/sample clipping is a separate policy.

Line ownership is derived from authoritative source starts/ends and affinity,
not caret y. Thus zero/small line height and overlapping caret tops cannot move
a source unit to another line. At soft wraps the affinity aliases can differ;
after a hard separator both affinities belong to the following line. Public
`TextLine::text_range()` now consistently excludes hard separators, including
producer-flagged U+2028. Glyph runs/document ranges retain their separator bytes.
The native caret run must match the ordinary `caret_line` query.

AccessKit reuses ordinary leaf Label/TextInput nodes as local geometry carriers.
TextRun children are directional, source-ordered, legal-grapheme spans split at
visual affinity discontinuities. No parent is added to every text row. Existing
renamed Label children and Button text carriers are structural exceptions. El
admits app children only on Div/Button/Scroll; Input/Text children are rejected.
Input root IDs survive font/wrap/map-only changes while old child-run positions
retire. A source/field lease rebind retires the input root too. Queued actions
remain cohort/window/source qualified and use the ordinary selection/edit path.

## Retained and construction costs

The matched default-feature baseline/A probes use the same bundled font and
fresh processes. Font acquisition is outside scoped Canvas measurements; the
temporary shaper is dropped before retained bytes are read.

| Item | Baseline | A |
|---|---:|---:|
| Node / Presented / TextSite / Prepared | 40 / 80 / 80 / 40 B | unchanged |
| Part / Metadata / Handler / El | 16 / 264 / 16 / 176 B | unchanged |
| Runtime, default features | 1,888 B | 1,824 B |
| TextLayout / Details / Stop / Run / Line | 56 / 80 / 24 / 24 / 24 B | unchanged |
| Cold TextResources / C-or-P Entry | absent | 120 / 24 B |
| Plain owner | 21 alloc, 5,636 B | 21 alloc, 5,572 B |
| 28-node inspector | 250 alloc, 64,862 B | 356 alloc, 82,678 B |
| Warm idle inspector | 0 alloc | 0 alloc |

The inspector loses 106 allocations and 17,816 retained bytes relative to the
baseline. Full-feature `cephal/verify-cache` adds 16 B to Runtime/owner totals:
the final A probe is Runtime 1,840 B, plain 5,588 B, inspector 82,694 B. Do not
compare those totals against the default-feature baseline without that charge.

A 32 KiB ASCII paragraph at width 400 has 32,768 glyphs, 745 lines/runs and
33,513 stops. Stop capacity is 65,536: the geometry allocation capacity is
1,622,016 B, versus 49,152 B without interaction. Retained shape bytes are
2,146,424 versus 573,560 in the matched default control; requested construction
bytes are 8,056,186 versus 4,255,194; peak bytes are 7,001,412 versus 3,999,044.
This stop payload/slack is the next optimization target, before an arena.

The owner epoch probe retains approximately 1.65 MB per additional old map:
old P + new C costs 1,651,944 B; old P + old C + failed new L costs another
1,655,160 B. ACK of old C frees 1,655,232 B with no allocation. L alone retains
the current glyph buffer; P/C geometry leases retain no glyph/font payload.
The exact source/feature-qualified final rerun is in `final-a-refined-native/`.
That complete first-C construction costs 33,912 allocations / 26,284,998
requested bytes / 15,569,632 peak extra bytes; old-P + new-C construction costs
33,945 allocations / 26,270,772 requested bytes / 15,005,860 peak extra bytes.
These broader owner measurements differ from the scoped shaper control. Their
approximately one-per-source-unit allocation component needs independent stack
attribution; retained-stop compression alone does not explain or remove it.

Native Cohort is 40 B and each published text record is 56 B (static records
currently carry redundant input-only fields). A single-text cohort uses one
56 B allocation. A 32 KiB input at width 392 produces 763 runs / 765 nodes /
32,768 units. Projection costs 6,885 allocations, 906,623 requested bytes,
733,455 retained bytes and 733,606 peak bytes. Consumer construction is measured
separately while consuming that update; those deltas must not be blindly added.

## Correctness controls and gates

`33382d8771` freezes A's public/ownership foundation. `b305496eeb` is a losing
native control: grouping equal-direction source spans across a bidi isolate
created a run AABB covering an unrelated visual gap. `59128ac541` fixes this by
requiring visual edge continuity. The actual nested-isolate fixture and failed
log are preserved. `eace5a4a6d` updates the obsolete active-input-only map test;
the original campaign's 505-case GPUI / 185-case Canvas / 209-case Consumer and
actual native logs retain their original disposition, never relabeled as the
final source.

The independent zero-line-height Parley fixture found byte 0..1 incorrectly
owned by line 6 instead of line 0. `ec5a8d8910` fixes ownership without retained
bytes and compares actual producer cluster paths and cursor affinity at line
heights 0/1/4/22, including CRLF/U+2028/empty/trailing lines and bidi. An inline
box duplicate-start experiment is retained as an InvalidFont rejection control,
not counted as admitted behavior. `86dd586142` separately shares f64 affine
extrema for zero-area semantic bounds while preserving damage empty/outward
rounding. The 2^24 shear/cancellation fixture exposes the old early-f32 loss of
one-unit caret height. Core tests include reflection and f32/f64 extremes.

Final-source gates and artifact hashes are listed in `evidence/gates.json`.
They include 188 Canvas cases, 506 GPUI cases (including 23 doctests), 18 core
cases and strict full-feature/all-target checks. The shipping library counter is
29,109 non-test code lines (29,096 src + 13 build), versus baseline 28,403. The
separate full inventory charges all source: 316,917 active non-test physical
lines, including 56,955 first-party, 39,955 generated and 220,007 vendor lines.
Those full-inventory numbers pin shipping source 86dd before this evidence
archive is added. After the archive, the f131 ledger is 319,534 active
non-test physical lines / 59,572 first-party non-test lines; generated/vendor
counts stay unchanged. This charges the archived helpers, fixtures and assembly.
The shipping core remains 29,109 code lines. Flattened release client manifests
are raw original inputs; recreate `src/main.rs` from adjacent `client.rs` in a
scratch directory before rebuilding, and provide the pinned worktree paths.
Actual Linux tests roundtrip AT-SPI Unicode character extents → hit offset →
ordinary P oracle, plus reversed selection, caret, UTF-8 InsertText/DeleteText,
invalid ranges, late service/provider activation and owner replacement/destruction.
Apple/MSVC gates compile adapters and tests; they are not foreign runtime claims.

## Release query/code comparison

The same external 32-row client was built against clean detached 6d77/eace
worktrees, same x11 features, toolchain, package versions and release settings
(debug info 1, otherwise Cargo defaults). Both return checksum `96262292106`.
No timing was taken. Manifests, lockfiles, binary digests and complete selected
function bodies are archived, including moved out-of-line helpers.

The indexed Part is not free: a row bounds branch remains in the candidate
visitor and `target()` checks again. Baseline visitor body is 345 B; candidate
has a 171 B wrapper plus a 322 B inner loop. `target()` grows 43→84 B. Native
project is 1,240→1,264 B; projected_node is 2,986→2,670 B, but Cohort::append
grows 1,923→7,125 B and prior projected_text is inlined/replaced. Whole linked
text grows 21,697,805→21,727,445 B. Native code implements additional semantics;
these body sizes do not isolate the index cost or establish a performance win.
This release candidate is frozen eace, before the final line/bounds correction.
A separate safe usize/borrow-bound/inline control will test check elimination.

## Limits and next controls

The map is always interactive and currently costs 24 B per stop plus Vec slack.
Arc operations are atomic, and this is not an arena comparison. Native decoded
length validation rescans the immutable run on conversions; conversions are not
constant-time. Static/input cohort role splitting and native projection arrays
remain charged. Arbitrary affine clipping produces a conservative AABB, while
point admission uses the exact inverse/rounded predicate. Public f32 bounds and
native f64 bounds have different final output precision. Damage rounding and
continuous zero-area semantics intentionally remain distinct.

Next comparisons are exact capacity, 16 B stops, a simple source-derived 12 B
control if justified, and common 8 B stops with sparse affinity/wrap exceptions.
They must preserve producer f32-add / f64-subtract caret width arithmetic and
all L/T/C/P, Unicode, clipping and stale-action gates. No arena, second character
tree, unsafe check bypass or narrowed source limits is included here. Reusable
contained-owner inspector arbitrary text entry remains a separate required task.
