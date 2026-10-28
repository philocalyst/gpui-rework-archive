# Direct style inputs

Existing style builders accept literals, copied references to literals and borrowed
signals. For example:

```rust
# use gpui::prelude::*;
# struct Panel { width: Signal<u32>, surface: Signal<Color>, wrap: Signal<bool> }
# impl View for Panel {
# fn view(&self) -> El<'_> {
div().w(&self.width).bg(&self.surface)
    .layout(Flex::row().align(Align::Center).gap(8).wrap(&self.wrap))
# }
# }
```

The implemented builders are `w`, `h`, `size`, `gap`, `p`, `font_size`, `fg`, `bg`,
`transform`, `flow`, `align`, `justify`, `wrap`, and `rounded`. Numeric lengths
accept all existing `IntoLength` primitives: f32/f64 and u8/u16/u32/u64/usize and
i8/i16/i32/i64/isize. They retain the wide conversion until finite, range and
property validation. Corner radius preserves its existing f32 domain: f32,
`&f32` and `&Signal<f32>`. Literal radius errors still return typed geometry
admission errors; existing length builders still reject invalid literal authoring
at construction. Dynamic errors return typed post-commit errors.

Exact observation requires registering the field in `View::sources`. A `direct`
source promises the owner does not also snapshot-read it for branches or formatted
values. An unregistered signal is a read-only snapshot: it refreshes on a later
owner description, and installs no observer or retained signal address. Ordinary
`field` and `component` registrations keep their conservative owner refresh rules.

This is direct `Signal` binding through the current typed field registry. It does
not implement the future general Source, Reader, Motion or token value algebra.
Whole `Signal<Flex>` recipes and optional recipe retraction are deferred. Flex
supports borrowed individual fields and copied literal or borrowed recipes;
unspecified recipe fields leave previous declarations untouched. Repeated builders
use their last operand, including a literal removing an earlier signal edge.

A registered direct update freezes its source once. Every subscribed sink is
validated before any text, style or inspector base changes. Inspector `Set` masks
the effective value while its lower source base continues to advance; `Inherit`
reveals that latest value. Source mutations have already committed if a subsequent
sink or renderer rejects them. The error is explicit, old acknowledged geometry
and pixels stay authoritative, and a later valid owner turn can recover.

Paint changes skip layout; layout sinks mark layout dirty, and font-size also
retires shaping. Geometry sinks use the existing frozen geometry cohort. Ordinary
retained trees need no View rerun for these exact edits. Mixed virtual-list windows
skip description for Paint-only style publications. Layout or geometry sinks
conservatively re-describe once because realization still depends on authored
layout and visibility. Presentation still walks and
records the retained scene; this feature does not claim sublinear painting or zero
accessibility traversal.

`Flex::row()`, `Flex::column()` and the four field builders are const on stable
Rust. Recipes store original Copy operands; the sealed lowering converts only
present fields when `El::layout` consumes or copies the recipe. No const trait
call is required. Default literal recipes retain their original12B size and need
no lifetime annotation. For named constants, the default gap type is f32:

```rust
# use gpui::prelude::*;
const TOOLBAR: Flex = Flex::row().gap(8.0).align(Align::Center).wrap(true);
const INTEGER_GAP: Flex<i32> = Flex::row().gap(8);
```

Inline `.layout(Flex::row().gap(8).wrap(&self.wrap))` infers the operand types.
A recipe with four borrowed signals stores four thin references (40B with flow),
remains Copy and allocates nothing. Explicit `const TOOLBAR: Flex = ...gap(8)`
needs either8.0 or the integer generic annotation above; that exact default-typed
integer spelling is not silently claimed to compile. Whole `Signal<Flex>` remains
deferred. Numeric narrowing preserves the immediate f019 literal policy,
including inherited integer→f64→f32 double rounding at large midpoint values.

Literal style inputs allocate no cold payload. Dynamic inputs share one normalized
cold decoration box with radius, scrolling and names; a closed leaf payload means
alternating builders cannot grow recursive wrapper chains. Detailed requested-byte
and construction ledgers accompany the implementation evidence; these are separate
from RSS and OS resource costs.
