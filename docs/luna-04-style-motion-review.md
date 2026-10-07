# Style and motion documentation review

This pass is limited to public style, geometry, color, interpolation, and motion contracts. It does not change runtime behavior. The generated examples include blocks and their macro attachment directives remain intact.

## Files read

In the assigned GPUI scope:

- `crates/gpui/src/style.rs`
- `crates/gpui/src/styled.rs`
- `crates/gpui/src/style_transitions.rs`
- `crates/gpui/src/transition.rs`
- `crates/gpui/src/animated.rs`
- `crates/gpui/src/motion.rs`
- `crates/gpui/src/spring.rs`
- `crates/gpui/src/lerp.rs`
- `crates/gpui/src/geometry.rs`
- `crates/gpui/src/color.rs`
- `crates/gpui/src/colors.rs`

The `crates/gpui/src/colors/` directory does not exist in this checkout. Supporting implementation read for generated style families and transition builders: `crates/gpui_macros/src/styles.rs`. Supporting integration read for transition state identity and reduced-motion handling: `crates/gpui/src/elements/div.rs` and `crates/gpui/src/window.rs`. Authoring rules read: `docs/documentation-authoring.md`.

The generated `Styled` surface was reviewed family by family in `crates/gpui_macros/src/styles.rs`: margin, padding, position/inset, size constraints and gap presets; radius and corner smoothing; border widths; visibility; overflow; cursor aliases; shadows; and outer/inset rings. The generated `StyleTransitions` builders were checked against every spec in `style_transition_specs()`, including their field groups, unit-resolution paths, optional-property handling, and overlap behavior. Only documentation literals and the documentation lookup helper changed in the macro; setter expansion logic and source include blocks were preserved.

## Pinned references and usages

The local Zed documentation reference is pinned at `da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f`. Its checkout is sparse, so source was read from the pinned Git objects.

- `crates/acp_tools/src/acp_tools.rs` uses a themed `.border_color(...)`, a `.hover(...)` refinement that changes the background, and `.flex_shrink_0()` for compact controls. This grounds the distinction between base style, interaction-state refinement, and shrink behavior.
- `crates/agent_ui/src/agent_configuration/configure_context_server_modal.rs` uses `rounded_md`, border and background colors, and an explicit width in rems. This shows utility-style helpers alongside direct lengths.
- Zed's pinned `crates/gpui/src/styled.rs` still describes `Styled` as a CSS-like utility API and delegates large method families to macros. I treated that as a usage and discoverability reference only; the documentation here follows this checkout's current implementation and generated contracts.

The local Hummingbird documentation reference is pinned at `2e1ee5f1c8d415ef7f835801fe368ab4106035b5`.

- `src/ui/about.rs` styles links with `.text_color(...)` and a hover refinement, then composes direct pixel widths and margins in a layout. The hover closure refines style while the element's children and dimensions remain separately composed.
- `src/ui/components/button.rs` builds a button from a base style, intent-specific background/text/border colors, and separate hover/active refinements. This is a concrete example of choosing state-specific style instead of treating a style setter as inherited state.
- `src/ui/components/callout.rs` combines flex sizing, `.flex_shrink(1.0)`, overflow clipping, and text styles. It illustrates that a preferred width and a shrink factor jointly affect layout.

The Jiff primary references read were the docs.rs overview and its long-form design and comparison pages. The overview distinguishes common entry points and links to the rest of the documentation; the design FAQ gives reasons for API choices while labeling opinion; the comparison page states its factual scope and acknowledges incompleteness and author bias. This pass applied those editorial practices: define the domain before edge cases, identify the precise scope of each claim, and keep implementation-specific claims tied to this checkout.

## Corrections and clarifications

- `Pixels` now describes a fractional logical unit without claiming that values are typically rounded. Conversion to scene or device space is explicit; raster snapping is renderer- and operation-dependent.
- `DevicePixels` and `ScaledPixels` are distinguished as integer physical counts versus floating-point scene-space coordinates. `Rems` now points to the window's configured rem size without implying an automatic accessibility or display-density policy.
- `Point<T>` and `Size<T>` docs now state their actual `PartialEq` bound. The size description also names its shared unit.
- The resolved `Style` docs distinguish a partial `StyleRefinement` from frame style, layout inputs from post-layout paint, and per-element geometry/paint from text-style inheritance and inherited inline direction.
- `Style::size` now says the requested size can be reduced by flex layout and points readers to minimum size or shrink control. The grow-factor docs no longer imply that zero is invalid; the shrink description calls out zero as the opt-out.
- `scrollbar_width` was documented in “points,” which obscured the logical-pixel length type. It now describes reserved logical layout space and its zero-width behavior.
- `Lerp` docs now state that progress is unclamped, output can differ from input type, and variants or units can switch discretely. They call out that `Background` only blends solid-to-solid and that `Hsla` interpolation through `Lerp` uses sRGB, distinct from the configured color space used to paint gradient stops.
- Color docs now specify that gradient stop positions are normalized fractions and are preserved as given, that gradient angles are stored without normalization, and that `linear_gradient` starts with Oklab stop interpolation. `oklcha` is documented as an unclamped constructor.
- Spring docs now name the finite/positive parameter contract, the lack of constructor/step validation, seconds as the time unit, and the positive finite epsilon needed for a finite settling estimate. `Interpolate` now states that values beyond its endpoints extrapolate.
- Motion sampling docs now distinguish pre-delay holding, pass-boundary samples, and inclusive finite completion. Spring motion's epsilon behavior at invalid values is explicit.
- `Animated` docs explain that its owner must preserve the same state across renders, that motion sampling uses an explicit clock origin, and that setting an equal target does not replace the active run.
- Style-transition internals now record that per-element state needs stable identity, repeated elements at one call site need explicit distinct IDs, and reduced motion presents authored endpoints. `Transition` clarifies its restart anchor and states that its generic value-transition API does not automatically consult reduced-motion preference; `Window::use_keyed_transition` is linked for persistent ownership.

- Generated spacing, sizing, inset, border, radius, and gap helpers now explain which fields each family writes, how numeric/rem/pixel/relative suffixes are interpreted, and where layout constraints such as flex shrinking still affect the result. Margin, padding, and inset variants identify physical edges and their grouping. Visibility, absolute/relative positioning, overflow clipping, and cursor aliases now distinguish their actual GPUI behavior.
- Generated border widths are documented as logical pixels for numbered presets, with custom absolute lengths preserving pixel/rem units. Radius presets explain the root-rem scale and rendering bounds; corner smoothing describes its separate shape parameter. Shadow presets document replacement semantics, while ring width and color setters explain their independent fields.
- Generated transition-builder docs enumerate every selected property group, identify corresponding `Styled` setters, note auto/relative-size resolution where layout context is used, and describe special color, optional-property, reduced-motion, stable-identity, and integer line-clamp behavior. Overlapping builders now document last-configuration-wins per shared property.
- The generated `5_6` spacing/size preset was described as 80% even though its formula is five sixths. Its documentation now says five sixths. Gap docs no longer imply that the API only applies to flex rows and explain horizontal/vertical axes in row versus column flow.

## Boundaries and remaining uncertainty

No claim was copied from Zed or Hummingbird as if it were a GPUI-CE guarantee. Their pinned code demonstrates use, not a normative contract. The app-level `StyleTransitions` builder is generated by a macro and attached by `Div::transitions`; that method is outside this assignment's edit scope. Its source comment already says repeated elements at one call site need distinct explicit IDs. The generated method expansions were not changed, and this pass did not edit generated examples or include directives. Generated macro documentation has not been validated by a full rustdoc build in this pass.

The docs do not claim that `Styled` offers general element transforms: this API exposes filters and layout/paint properties, while scene transforms are a separate API. Nor do they promise that arbitrary easing closures are pure or that a custom easing curve starts at zero and ends at one. Those endpoint choices affect the first and final presentation and remain the caller's responsibility.
