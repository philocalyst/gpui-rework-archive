# Intrinsic text measurement work elimination

**Integration disposition.** Research only, supplied report SHA-256 `89b3dec64b71a5196d7392f1d3c328dc9ca2462dc5a957b56b0edd145a2dba7c`. Root reviewed the complete report. The direct metric path is not implemented: callback authority and admission equivalence remain hard gates. The isolated `dcba9ba1e8` control merely suppresses unpublished interaction maps during intrinsic probes; it still shapes and breaks lines. Min-content width can normalize to the same key as final zero width, so a final interactive upgrade may reshape that case. Do not claim intrinsic and final keys can never coincide.

## Result

The smallest credible source-level elimination is a **min-content width-only query** that shapes the paragraph once and reads Parley’s existing Layout::calculate_content_widths().min, without asking Parley to materialize wrapped lines or Canvas to build a TextLayout. GPUI already sets OverflowWrap::Anywhere, and Parley’s calculator scans the same shaped clusters and accounts for that property and forced line breaks. It is therefore a candidate replacement for the current Some(f32::MIN_POSITIVE) -> break_all_lines -> planned.width() route, not a second font shaper or a handwritten width algorithm.

That candidate is not safe to route in the current callback. Cephal erases the requested run mode and axis before calling GPUI’s MeasureInput; there are real callers which request both axes while width is min-content. The fast path must be limited to a ComputeSize / Horizontal request with unknown width, and only min-content. It also needs a pre-break equivalent for Canvas’s glyph, geometry, font and resource-limit validation before it can replace the existing path. Keep the old shaping path as the fallback until those gates and bitwise output checks are implemented.

No build or benchmark was run for this research. No speedup or byte saving is predicted.

## Audited source pins

Provenance correction: `/root/gpui-acknowledged-text-geometry` was **not** checked out at GPUI commit `007f10ccbdf278dc16242b157d19e12075d5ba2f`; its worktree HEAD when this correction was made is `866e612d912c0e0e1a022552617acd3880ee9eb2`. The GPUI reads in the original audit were extracted from the shared Git object database with `git -C /root/gpui-acknowledged-text-geometry show 007f10ccbdf278dc16242b157d19e12075d5ba2f:<path>`, not from that worktree's files. The cited local paths were `reactivity/crates/gpui/src/runtime.rs`, `reactivity/crates/canvas/src/text.rs`, `reactivity/crates/canvas/src/text/planner.rs`, and `reactivity/crates/canvas/src/text/paragraph.rs`; the vendor Parley reads were `reactivity/vendor/parley/src/layout/layout.rs`, `data.rs`, and `line_break.rs`. The Cephal reads used the pinned source files `src/tree/traits.rs`, `src/tree/input.rs`, `src/compute/leaf.rs`, `src/compute/mod.rs`, `src/compute/grid/alignment.rs`, and `src/compute/flex/mod.rs` at `20c4c494179078ddfde7e8532ffc93f28cf5b531`. To make the provenance reproducible, for example, the runtime read is `git -C /root/gpui-acknowledged-text-geometry show 007f10ccbdf278dc16242b157d19e12075d5ba2f:reactivity/crates/gpui/src/runtime.rs`. No historical checkout at `007f10...` is implied.

The Parley and Cephal code cited below is also available as first-party source at the linked upstream pins:

- Parley v0.12.0, which is the version in reactivity/vendor/parley/Cargo.toml.
- Cephal 20c4c494179078ddfde7e8532ffc93f28cf5b531. This is the out-of-flow placement-retention change; its commit note reports 2–3× for a 100k-node random-tree width edit and 1–2% higher cold layout. Those numbers concern out-of-flow placement reuse and are not evidence for text shaping or this proposal. [Pinned commit](https://github.com/zortax/cephal/commit/20c4c494179078ddfde7e8532ffc93f28cf5b531)

The allocation observation supplied by the root is from the adjacent source snapshot 86dd5861429522a2ce4dd8c0edb3a6f3483a7d04: a 32 KiB ASCII owner at 400 px produced a 32,768-line min-content shape and 745-line final shape; the trace attributed 33,511 deep snapshots to Parley’s two-byte Vec<u16> state. That is a prior host trace, not a new result from this report. The audited Parley source files are unchanged between 86dd586... and 007f10.... This is not a claim that each snapshot allocates.

## Current GPUI path

At reactivity/crates/gpui/src/runtime.rs:2551-2582, GPUI maps width availability as follows:

- Known or definite width becomes Some(width).
- MinContent becomes Some(f32::MIN_POSITIVE).
- MaxContent becomes None.

The callback then calls TextSite::shape_for(..., interactive = true). At runtime.rs:2773-2787, final paint asks for an interactive shape at the definite content-box width and retains its geometry. The final caret and selection map therefore remains on the ordinary final-width path.

TextSite::shape_for at runtime.rs:601-630 is a one-entry layout cache keyed by width bits, with an extra check that an interactive request has a caret at byte zero. The pass-scoped TextShaper and its reusable Parley Layout are described at reactivity/crates/canvas/src/text.rs:261-315; the final TextLayout owns a Canvas glyph vector, a font-set lease and optional details at text.rs:226-237.

At reactivity/crates/canvas/src/text/planner.rs:163-194, each paragraph is built into the reusable Parley layout with the same family, font size and OverflowWrap::Anywhere, then break_all_lines(max_width) is called. The planner computes Canvas glyphs and the Details line map at lines 196-245, validates positioned runs and glyph/source data at lines 251-335, optionally appends carets at lines 337-339, and accumulates paragraph height at line 340. The returned width is planned.width() for any Some(max_width), and planned.full_width() for None (lines 238-244).

The paragraph adapter at reactivity/crates/canvas/src/text/paragraph.rs:12-42 splits CR, LF, CRLF, NEL and paragraph separator while keeping source byte ranges; U+2028 stays inside a Parley paragraph. It intentionally yields an empty paragraph for empty input and a trailing empty paragraph after a final separator. A direct metric method must preserve the same paragraph iteration and take the maximum over paragraph widths; it must not include separator bytes in shaping.

## What Parley already provides

The pinned public method is Layout::calculate_content_widths() at reactivity/vendor/parley/src/layout/layout.rs:125-132. Its contract says min-content is measured with all soft opportunities and max-content with forced breaks only; it recalculates on each call and warns that mixed-direction text may be incorrect. The implementation is at reactivity/vendor/parley/src/layout/data.rs:382-401, 491-561, 564-660.

The implementation scans shaped layout items and their cluster slices. For text it applies the run spacing, checks grapheme/atom starts, recognizes OverflowWrap::Anywhere as a soft opportunity, handles Whitespace::Newline as forced breaks, and tracks hanging whitespace. It returns two scalars. There is no line vector or cache in this method. For this GPUI builder, indent is left at its default zero and there are no inline boxes, but the method itself supports broader Parley layouts.

This is a more direct formulation than calling the line breaker at a nearly-zero width. It reads the shaped output the existing builder already produced and can return only one f32; no source copy, font parsing API, owner cache, Canvas glyph vector, line map or caret map is required for the metric result. The same RangedBuilder and build_into can be shared, so the proposal does not add a second shaping frontend. It still performs font coverage and shaping, and the final-width interactive shape still runs when painting.

There are two important limits:

1. The current GPUI min-width result is planned.width() after break_all_lines(Some(f32::MIN_POSITIVE)). Parley says its direct widths calculation should mirror its line breaker, but the local vendored version has no Canvas-level test asserting bitwise equivalence for GPUI’s exact builder inputs. Treat equality as unproven until a differential oracle compares f32::to_bits().
2. Do not substitute ContentWidths.max for the current planned.full_width(). Parley’s content-max method applies CSS hanging-whitespace rules and can subtract unconditionally hanging trailing whitespace. GPUI’s None branch explicitly asks for full_width(), whose Parley documentation says it includes trailing whitespace. A dedicated no-wrap/full-width scan may be possible later, but requires a separate equivalence proof, including bidi ordering and non-finite advances.

The direct min method also carries Parley’s mixed-direction limitation. The current source comment in data.rs:498-503 explains that it only knows trailing whitespace can hang when the item’s bidi level equals the paragraph level; layout.rs:128-130 warns callers about mixed directions. Do not apply it to mixed-direction text without a fail-closed condition. A small vendor refinement could make the method return None when the shaped items contain a level other than the base level; then GPUI can use its existing path. That check should inspect Parley’s shaped bidi levels, not infer direction from ASCII or a language/profile allowlist.

## Cephal call contract blocks an available-space-only switch

The pinned Cephal MeasureInput at upstream src/tree/traits.rs:24-38 contains only known_dimensions and available_space. The richer LayoutInput has run_mode, sizing_mode and axis at src/tree/input.rs:69-88, but compute/leaf.rs:265-286 strips those fields before calling the measure callback.

Cephal’s LayoutTreeExt::measure_child_size explicitly asks for one axis and returns only that component at src/compute/mod.rs:723-755; measure_child_size_both asks for both at lines 758-784. This distinction matters:

- flex::shrink_row_to_fit at src/compute/flex/mod.rs:253-275 has a real width-MinContent, horizontal-only query. It is a valid kind of call for a future scalar width fast path.
- grid/alignment.rs:186-195 calls measure_child_size_both when both width and height sizing keywords require measurement. Its width can be MinContent; the callback must still return a real height for this request.
- grid/item.rs:628-634 can measure either an abstract horizontal or vertical axis. Out-of-flow sizing also has horizontal, vertical and both-axis requests at compute/oof.rs:995-1025, 1107-1135.
- RunMode distinguishes PerformLayout and ComputeSize at tree/input.rs:4-12. The existing callback sees neither, so testing only available_space.width == MinContent is not a valid guard.

A scoped API change should pass the request context to the measure callback (at minimum run_mode and axis, or one explicit HorizontalMinContentSize request kind). The fast path should require all of: ComputeSize, Horizontal, unknown width, and available_space.width == MinContent. Every PerformLayout, Vertical, Both, known-width, max-content and definite-width query must keep the ordinary shape path. The callback only needs a correct horizontal width for the single-axis query; it must not manufacture height or baseline values for requests which read those fields. Cephal documents a single-axis measurement’s other size as unspecified at compute/mod.rs:725-755; the Both and final-layout paths still need full metrics.

## Error, resource and ownership adversaries

The existing planner’s post-break validation is observable behavior, not optional work. A scalar-only path must preserve it or remain a fallback:

- MAX_TEXT and MAX_GLYPHS are both 32 KiB at reactivity/crates/canvas/src/text.rs:31-33; shape_mode checks text length at lines 299-315. The planner counts laid-out glyphs and rejects above MAX_GLYPHS at planner.rs:214-228.
- After breaking, the planner rejects non-glyph positioned items (InvalidGeometry), nonzero normalized coordinates (UnsupportedFontFormat), unrecognized font IDs (ForeignLayout), invalid source ranges or cluster cardinality (InvalidFont), non-ignorable glyph zero (MissingGlyph), non-finite positioned coordinates (InvalidGeometry) and glyph IDs that do not fit u16 (InvalidFont) at planner.rs:251-310.
- coverage() validates code points and loads fallback faces at planner.rs:89-132, but it does not subsume all of the later shaped-glyph and positioned-geometry checks.

A direct min-width method that returns success without a shaped-glyph count and equivalent validation changes the error/admission contract for malformed or unusual custom fonts, even if final painting often shapes the text later. Do not assume every measured node reaches paint. The smallest robust follow-up is a Parley pre-break validation/count interface over the already-shaped data, or a narrower gate whose complete error-equivalence can be proved. Keep custom fonts, bidi, and anything outside that gate on the old path. Do not impose a new public text limit or treat an ASCII heuristic as a font-validity proof.

A scalar method should not retain a second result per text owner. It can use the existing pass-owned Parley scratch and return a scalar, leaving Canvas’s final TextLayout and interactive TextGeometry unchanged. BreakLines::new swaps reusable output vectors into the breaker and clears them at line_break.rs:843-861; BreakLines::drop calculates width/height and swaps them back at lines 1629-1668. Skipping min-content breaking therefore also avoids growing those line output vectors for that query. The next implementation should decide what happens to a stale one-entry TextSite.shaped entry when the scalar path misses: do not add a parallel cache, and do not accidentally retain an old map/font lease longer than the current replacement behavior.

## Bounded next slice and verification

1. Add measure request context to the Cephal-to-GPUI callback. Route only the exact horizontal ComputeSize min-content case; preserve existing behavior for every other context.
2. Factor Canvas’s current paragraph setup so normal shape and a private min_content_width method share coverage, builder, font fallback and build_into. Use Parley’s existing calculator. Add a fail-closed mixed-bidi signal from shaped layout data rather than a text-language heuristic.
3. Do not remove the old post-break validation unless a pre-break Parley API preserves the glyph count, glyph/source errors and geometry error contract. If that is not a small diff, stop at the current non-interactive measurement change and keep the old min-content path.
4. Differential tests must compare old min-content width and candidate width bit-for-bit across empty and trailing-empty paragraphs; CR/LF/CRLF/NEL/paragraph separator and U+2028; normal and hanging trailing whitespace; zero-advance, long-grapheme, combining and emoji sequences; fallback and mixed-direction text; and font-size/text-limit/error boundaries. Assert fast-path dispatch only for horizontal single-axis size queries, and fallback for grid Both, vertical, definite/max-content and final layout. Add adversarial font fixtures for glyph zero, invalid source mapping, non-finite positions, normalized coordinates and glyph counts if the source suite can construct them.
5. Only after correctness, measure both retained and peak bytes, allocation counts, shaping/line-break call counts and end-to-end host work on the existing 32 KiB owner, a tiny label, mixed-script/emoji text, and separator-heavy text. Record per-pass scratch after the final layout and after drop. There is no measured speedup or memory result for this candidate yet.

## Primary references

- [Parley 0.12.0 Layout API and mixed-direction warning](https://github.com/linebender/parley/blob/v0.12.0/parley/src/layout/layout.rs#L95-L141)
- [Parley 0.12.0 content-width semantics and scan](https://github.com/linebender/parley/blob/v0.12.0/parley/src/layout/data.rs#L382-L401) and [cluster/hanging rules](https://github.com/linebender/parley/blob/v0.12.0/parley/src/layout/data.rs#L491-L660)
- [Parley 0.12.0 line break snapshots](https://github.com/linebender/parley/blob/v0.12.0/parley/src/layout/line_break.rs#L1026-L1041) and [line-vector scratch lifecycle](https://github.com/linebender/parley/blob/v0.12.0/parley/src/layout/line_break.rs#L1629-L1668)
- [Cephal pinned MeasureInput and MeasureOutput](https://github.com/zortax/cephal/blob/20c4c494179078ddfde7e8532ffc93f28cf5b531/src/tree/traits.rs#L24-L45), [request axes and run modes](https://github.com/zortax/cephal/blob/20c4c494179078ddfde7e8532ffc93f28cf5b531/src/tree/input.rs#L4-L28), and [leaf callback boundary](https://github.com/zortax/cephal/blob/20c4c494179078ddfde7e8532ffc93f28cf5b531/src/compute/leaf.rs#L249-L286)
- [Cephal single-axis and both-axis helpers](https://github.com/zortax/cephal/blob/20c4c494179078ddfde7e8532ffc93f28cf5b531/src/compute/mod.rs#L723-L784), [grid Both-axis caller](https://github.com/zortax/cephal/blob/20c4c494179078ddfde7e8532ffc93f28cf5b531/src/compute/grid/alignment.rs#L186-L196), [flex horizontal min-content caller](https://github.com/zortax/cephal/blob/20c4c494179078ddfde7e8532ffc93f28cf5b531/src/compute/flex/mod.rs#L253-L275)
- [W3C CSS Sizing Level 3 intrinsic sizing](https://www.w3.org/TR/css-sizing-3/#intrinsic-sizes) and [CSS Text Level 4 wrapping and forced breaks](https://www.w3.org/TR/css-text-4/#text-wrapping)

All GPUI line references above identify paths in the `007f10...` Git tree as read with `git show`, not files from the local worktree HEAD. Parley paths were likewise read from the pinned tree; the allocation-trace observation is specifically attributed to source snapshot `86dd5861429522a2ce4dd8c0edb3a6f3483a7d04`. The Cephal files were read from the pinned `20c4c494...` source tree. This report does not retag the `007f10...` source reads as reads of `cc0f7aa...` or of the current worktree.
