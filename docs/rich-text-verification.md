# Rich text verification

Verification is complete for the checks recorded below. Counts and measurements
are executed results. The two unchanged baseline WGPU failures and the limits of
native input, heap and performance evidence are stated explicitly.

## Executed checks

On macOS, Apple M3 Pro, Rust 1.98.1:

| Command | Result |
| --- | --- |
| `cargo test -p gpui-ce --lib` | 406 passed, 0 failed |
| `cargo test -p gpui_ce_elements -- --nocapture` | 155 library, 8 integration and 17 documentation tests passed |
| `cargo test -p gpui_ce_wgpu --features test-support --test rich_text_shaping` | 1 passed; Cosmic shaping with actual bundled fonts |
| `cargo test -p gpui_ce_wgpu --lib --features test-support` | 52 passed, 2 known baseline pixel failures |
| `cargo test -p gpui_ce_wgpu --example rich_text_studio --features test-support` | 4 passed after bundled-font correction |

The GPUI run includes multiline Unicode font/decorations, trailing empty paragraphs,
zero/positive clamps, combined hard and wrapped lines, and unclamped layout reuse.
The shaping integration uses actual glyph/font identifiers; it does not itself prove
GPU pixels. Studio tests use the real WGPU renderer and Cosmic font system, pointer
selection, toolbar actions, native keystrokes, editable task/code blocks, and Edit/Read
snapshots at desktop and compact logical dimensions.

The broad WGPU suite reproduces only the two previously confirmed unchanged HEAD
failures. `quad_backgrounds_match_legacy_metal_pixels` differs at (2,2), blue 151 versus
152. `quad_border_backgrounds_use_the_fill_coordinate_space` differs at (1,6), actual
[168,58,187,255] versus expected [166,58,186,255]. Tolerances were not changed.

Early pre-freeze runs exposed selection affinity, paragraph scrolling and fixture
failures. Owners corrected them and the final elements run above includes their
regressions; those earlier attempts are not counted as passes.

## Adversarial review and independent harness

`crates/gpui_elements/tests/rich_text_adversarial.rs` compares persistent edits with
contiguous application, checks inverses and mapped UTF-8 boundaries across valid
pairs of Unicode edits, exercises four touching edits with insertions at both ends,
compares interval-tree queries with a linear half-open reference, and checks native
line/UTF-16 indexes through chunk seams and repeated edits.

Review found that a scoped builder closure could replace its builder and leave a
stale internal span index. The range owner changed the closure interface and added
builder identity handling. Review also identified the need for pointer-equality
shortcuts when comparing shared immutable range sets, native UTF-16 overrides in
the document storage adapter, exact optional-wrap-width cache comparison, avoiding
style lowering before an unchanged-layout cache hit, and using the actual element
line height for navigation. The final elements run checks the resulting edits.

The independent harness checks 1,170 valid pairs of Unicode edits and 36 touching
four-edit variants. Atomic dispatch rejects invalid post-edit UTF-8 style ranges
without mutation; valid reversed Unicode selections apply; stale or foreign-owner
transactions reject. Snapshot text, style payload sharing, formatting event gates,
and text/format undo-redo are asserted. The scrolling regression covers both a
30-line paste and a 113 px viewport where the caret top fits but its bottom does not.

Internal integration tests assert unchanged WrappedLine Arc reuse after selection
and fresh equal decoration payloads, actual width/font/theme/style invalidation,
and 4,200 untouched paragraphs reused in a 4,201-line active document. A default
Document IME regression checks multiple Japanese composition stages over an emoji,
UTF-16 selection mapping, commit/unmark, one undo restoring original styles and
selection, and read-only refusal. These layout tests use NoopTextSystem; real font
and pixel coverage comes from the WGPU tests and demo.

The first retention fixture observed 512 chunks in a 1,048,576-byte source, 513 chunks
in the 1,048,579-byte edited snapshot, and 509 unchanged shared chunk allocations.
Clones shared their snapshot's lazy contiguous buffer; different edited snapshots
had separate buffers once explicitly flattened. These are observations about sharing
and retained references, not measurements of process heap size.

The paragraph cache initially retained up to 4,096 historical layouts without a byte
budget and could thrash on a larger active document. Review led to replacing that
cache with a map of the active layout's paragraphs. Cold layout and reconstruction
still visit the document; this is not viewport-bounded layout.

## Rendering and native startup

The final images use bundled IBM Plex Sans and Lilex with concrete font-family
aliases. The regression test checks distinct regular/bold/italic font IDs and equal
monospace advances for `iiii` and `WWWW`. Each image was regenerated after this fix
and visually reviewed for glyphs, emphasis, code alignment, wrapping and bounds:

- [Desktop Edit](rich-text-studio-desktop-edit.png)
- [Desktop Read](rich-text-studio-desktop-read.png)
- [Compact Edit](rich-text-studio-compact-edit.png)
- [Compact Read](rich-text-studio-compact-read.png)

Logical desktop 1280×820 renders a 2560×1640 PNG; compact 880×640 renders 1760×1280.
The compact Edit page extends below the viewport and scrolls; all three code lines
are visible. Edit and Read preserve the same authored inline styles. Separate
native title, task and code states are composed alongside the prose document.

`cargo run -p gpui_ce_wgpu --example rich_text_studio --features test-support --
--size 1280 820` launched the native macOS path and remained running without a panic
until its own process was stopped with Ctrl-C. Computer Use could not bind the raw
executable by path or process name, so this is a startup/liveness smoke check;
native window pixels and physical keyboard/IME were not independently captured.
The actual WGPU headless interaction tests and images are the rendering evidence.

## API and cost boundaries

The persistent UTF-8 document and immutable annotations form a useful foundation
for source-preserving inline composition. Snapshot text chunks and style payloads
share allocations, and stable revision/owner validation rejects stale edits.
`EditableTextState::revision()` is the monotonic editor generation suitable for
async syntax results; bare Document revisions are branch-local. Coordinates are
UTF-8 bytes; native IME adapters convert UTF-16, and callers must supply valid byte
boundaries. Zero-width annotation points have distinct semantics from half-open
nonempty intervals.

The current paragraph cache is bounded by the active document's layouts rather
than an arbitrary historical entry count. A changed-layout rebuild still traverses
and hashes/clips the active paragraphs; retained shape objects do not make cold
layout or revision rebuild viewport-bounded. Large single paragraphs also incur
whole-paragraph shaping on a local edit. The exact unchanged-layout path skips
style lowering and reconstruction; warm selection reuse is asserted separately.

RangeSet mapping reconstructs coordinates and its index; shared payloads do not
eliminate that cost. History retains up to 1,000 entries and shares document/style
payloads, but successive coordinate/index arrays and edited chunks still retain
memory. No byte-budget eviction or heap-byte guarantee is claimed. The first
legacy contiguous read per Document snapshot allocates a whole-document buffer;
snapshots can retain both chunks and that lazy buffer. Repeated reads reuse it.

The demo is a native composition example with separate block states, not a complete
Notion document schema. The fixed Rust token adapter supplies example ranges and
is not a parser. Inline widgets, hidden Markdown syntax projection, collaboration,
and cold viewport-limited shaping remain future work. Read composition and code
highlighting keep their source characters visible.

## Workspace checks

`cargo check --workspace --all-targets --features gpui_ce_wgpu/test-support` passed.
`cargo clippy --workspace --all-targets --features gpui_ce_wgpu/test-support --
-D warnings` passed after removing last-use clones, using reverse word iteration,
and spelling deliberately invalid test ranges with explicit start/end fields.
`cargo fmt --all -- --check` passed. The modified invalid-range tests were rerun:
9 passed. Cargo reports a future Rust incompatibility in dependency `block 0.1.6`;
this is not a project Clippy warning. `git diff --check` passed after final source/doc changes.

## Performance measurements

[Full performance JSON](rich-text-performance.json) publishes 36 cases from two
verified runs, with per-case run/source SHA provenance: 28 unchanged model/state
cases from the 19:32:13–20:05:00 UTC run and 8 corrected frame cases from
21:09:36–21:10:17 UTC on 2026-09-26. The original frame results are omitted because
test-support effect flushing automatically drew dirty windows before the intended
cold timer and added a second draw to changed-frame routines. The model/state
sections are byte-identical between the two measured benchmark sources.

The corrected fixture creates populated state before opening an empty container.
It then attaches the editor without notifying. Preflight proves the total view
render count is unchanged from the empty-container baseline and the final paragraph
has no bounds before timing. The timed refresh/draw adds exactly one render and
produces final-paragraph bounds. Edit and width/color mutations occur inside the
same window update as their refresh/draw, preventing an additional effect-flush
draw; their preflights also require count +1. All 36 Criterion `--test` cases pass
with these assertions, and the corrected benchmark passes workspace Clippy.

JSON preserves all absolute estimates, 95% confidence intervals, raw estimate
statistics, sample counts, nanosecond units, operation/batch descriptions and both
run/source identities. Criterion 0.5.1 used 20 samples, 1 s warmup and a 3 s
measurement target per case, in the optimized bench profile. Other task Cargo
builds and our renderer process were stopped; ordinary OS activity was not
suppressed. Untimed setup/teardown contributes wall time, and some confidence
bounds are wide. These are local estimates rather than a stable comparative baseline.

Representative primary estimates (slope when available, otherwise mean):

| Workload | Estimate | 95% interval |
| --- | ---: | ---: |
| 1 MiB Document edit | 31.045 µs | 29.565–32.396 µs |
| 1 MiB edit plus first contiguous read | 189.031 µs | 177.512–206.916 µs |
| Map 16,384 annotations | 663.212 µs | 467.307–817.453 µs |
| One batch of 64 sparse queries over 16,384 annotations | 9.206 µs | 9.003–9.474 µs |
| State build+dispatch, 1 MiB / 1,000 styles, no render | 129.061 µs | 126.139–131.235 µs |
| Warm unchanged frame, 128 paragraphs | 32.827 µs | 32.502–33.214 µs |
| Warm unchanged frame, 4,097 paragraphs | 35.086 µs | 34.479–36.020 µs |
| Localized edit+draw, 128 paragraphs | 203.374 µs | 181.563–227.820 µs |
| Localized edit+draw, 4,097 paragraphs | 5.960 ms | 5.803–6.164 ms |
| Cold document draw, 128 paragraphs | 334.857 µs | 311.651–354.296 µs |
| Cold document draw, 4,097 paragraphs | 12.004 ms | 11.779–12.356 ms |
| Width invalidation, 128 paragraphs | 325.587 µs | 312.198–339.995 µs |
| Foreground invalidation, 128 paragraphs | 296.660 µs | 267.380–344.746 µs |

Document/RangeSet cases do not need a text system. State dispatch uses a headless
context without rendering. Frame cases use NoopTextSystem and measure view render,
layout, prepaint and scene work, excluding OS/Cosmic font shaping, rasterization,
presentation and GPU work. Frame timings are not GUI FPS. State/frame setup and
teardown are excluded. Localized edit includes transaction construction,
dispatch/history and one draw. Warm frames force one view render with refresh;
width invalidation toggles 320/640 px and text-style invalidation toggles foreground
color. Edit-case snapshot setup and batched output destruction are excluded;
cheap-clone uses `iter`, including returned-handle destruction. Criterion byte
throughput for Document cases normalizes by input size; it does not measure actual
bytes processed or memory bandwidth.

Warm unchanged frames remain similar at 128 and 4,097 paragraphs, while cold layout
and localized revision rebuilds grow substantially. Reusing intact shaped
paragraphs avoids their reshaping but does not remove whole-document traversal and
cache/index reconstruction after edits. The first contiguous read also materially
increases the measured 1 MiB edit cost. No allocation profiler or byte-accurate
retained-heap measurement was performed; the chunk-sharing fixture above supplies
the actual retention observation.
