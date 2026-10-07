# Elements API documentation audit

This pass covers the public documentation in the element and layout surface. It keeps signatures
and executable code unchanged and concentrates on the contracts a reader needs before using an API:
frame lifecycle, persistent identity, layout constraints, measurement assumptions, units, and
failure boundaries.

## Files revised

- `crates/gpui/src/element.rs` — request-layout, prepaint, paint lifecycle; custom element guidance;
  links to layout and drawing walkthroughs.
- `crates/gpui/src/view.rs` — view identity, invalidation, and `Render`/`RenderOnce` choice.
- `crates/gpui/src/style.rs` and `crates/gpui/src/styled.rs` — refinement versus resolved style,
  logical-pixel units, composition and layout/paint timing.
- `crates/gpui/src/taffy.rs` — public layout-engine boundary and `AvailableSpace` contract.
- `crates/gpui/src/elements/mod.rs` — element selection guide and example links.
- `crates/gpui/src/elements/div.rs` — container and interaction role.
- `crates/gpui/src/elements/list.rs` — virtualization, measurement invalidation, callback order.
- `crates/gpui/src/elements/uniform_list.rs` — uniform-height invariant and visible-range contract.
- `crates/gpui/src/elements/canvas.rs` — one-shot prepaint/paint callback semantics.
- `crates/gpui/src/elements/deferred.rs` — deferred draw behavior and depth limit.
- `crates/gpui/src/elements/container_query.rs` — post-layout callback and sizing constraint.
- `crates/gpui/src/elements/image_cache.rs` — provider scope and pending-load result semantics.
- `crates/gpui/src/elements/anchored.rs` — fitting, coordinate mode, offsets, and margins.
- `crates/gpui/src/elements/svg.rs` — source selection and transform hitbox behavior.
- `crates/gpui/src/elements/img.rs` — image source variants and loader boundaries.
- `crates/gpui/src/elements/text.rs` — stable accessibility IDs and UTF-8 byte-index warning.
- `crates/gpui/src/elements/animation.rs` — animation policy and reduced-motion behavior.
- `crates/gpui/src/elements/surface.rs` — surface source and object-fit defaults.

## Coverage notes

The new links use the planned Zola routes for constraints, visible list ranges, custom paint, and
the stateful counter. The docs.rs layer can use these module-level links as anchors for the future
post-processor that maps API items to walkthrough sections.

The API docs now carry the contracts needed to use the generated style methods and interaction
matrix directly. Site pages may add longer walkthroughs and platform-specific demonstrations, but
there are no intentionally deferred API documentation gaps in this scope.

## Declaration inventory

The source-level inventory below was rerun after this pass with a declaration-line scan. It counts
externally visible `pub` items (public fields are described with their enclosing type rather than
counted as separate API pages). The `Styled` source contains one macro invocation, which expands to
149 fluent methods; those generated methods were read against `crates/gpui_macros/src/styles.rs`
and their shared overwrite, inheritance, unit, and append/replace semantics are documented on the
trait and in each generated method's rustdoc.

| File | Public declarations reviewed | Status |
| --- | ---: | --- |
| `element.rs` | 17 | Reworked lifecycle, identity, conversion, and render contracts; retained detailed accessibility docs. |
| `view.rs` | 14 | Reworked view identity and invalidation; retained method-level handle docs. |
| `style.rs` | 58 | Reworked module contract; retained type and variant semantics. |
| `styled.rs` | 1 + 149 generated methods | Reworked trait semantics and corrected stale/duplicate method wording; generated docs retained where precise. |
| `taffy.rs` | 11 | Reworked layout-engine and available-space boundary; retained implementation details. |
| `elements/anchored.rs` | 11 | Reworked fitting, coordinate, offset, and margin contracts. |
| `elements/animation.rs` | 17 | Reworked animation policy and reduced-motion contract; retained easing docs. |
| `elements/canvas.rs` | 2 | Reworked one-shot prepaint/paint contract. |
| `elements/container_query.rs` | 2 | Reworked post-layout sizing constraint. |
| `elements/deferred.rs` | 6 | Reworked deferred paint and depth-limit contract. |
| `elements/div.rs` | 102 | Reworked module contract and event dispatch matrix; retained individual callback docs. |
| `elements/image_cache.rs` | 18 | Reworked cache scope and pending-load semantics. |
| `elements/img.rs` | 14 | Reworked image source and loader boundaries. |
| `elements/list.rs` | 42 | Reworked virtualization and measurement invalidation contract. |
| `elements/surface.rs` | 4 | Reworked source and object-fit defaults. |
| `elements/svg.rs` | 13 | Reworked source selection and transform/hitbox contract. |
| `elements/text.rs` | 36 | Reworked accessibility identity and UTF-8 index contract. |
| `elements/uniform_list.rs` | 27 | Reworked uniform-height and visible-range contract. |

That is 395 externally visible source declarations plus 149 generated `Styled` methods. All listed
items were read; existing precise method and variant docs were retained, while the entries marked
reworked received contract-level edits. The remaining generated methods have explicit rustdoc in
the macro expansion and were checked for tautologies, stale links, and unit/overwrite accuracy.
