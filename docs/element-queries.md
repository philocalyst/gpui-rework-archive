# Query ordinary Rust values

A component needs only a `RenderOnce` implementation (or any `View` implementation). GPUI supplies
the conversion to `IntoElement`; no derive is needed. A selector can borrow the authored component
before `render` consumes it:

```rust,ignore
struct Card { title: String }

impl RenderOnce for Card {
    fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
        div().child(self.title)
    }
}

let tree = div()
    .select(Select::children().class("card"), |card: &mut Card| {
        card.title.push('!');
    })
    .child(Card { title: "Hello".into() }.class("card"));
```

The callback type identifies the value to borrow, and Rust checks its methods and fields as usual.
Selectors can also borrow concrete `Element` values. Associated types, generic methods, GATs, and
borrowed returns keep ordinary Rust semantics. No reflection registration is needed for these
native callbacks.

Use `.component::<Card>()` to select the authored component explicitly when needed. `Card` only
needs to implement `View` (as every `RenderOnce` type does), and ordinary `.select` callbacks can
borrow it just like an element:

```rust,ignore
root.select(Select::children().class("card").component::<Card>(), |card| {
    card.title.push('!');
});
```

To edit a model owned by a matching entity, use `select_entity`. GPUI updates the entity and lends
both the model and its context before rendering:

```rust,ignore
root.select_entity(
    Select::children().class("counter"),
    |model: &mut Counter, _cx| model.value = 42,
)
```

The current render sees the updated value without an extra `notify` call. Keep edits repeatable:
the callback can run again in a later render or layout session.

## Describe a module once

Use one attribute when you need field discovery, typed paths, or native trait views:

```rust,ignore
#[gpui::reflect]
mod cards {
    use gpui::*;

    pub struct Details { pub title: String, pub width: Pixels }
    pub struct Card { pub details: Details }

    impl Card {
        pub fn rename(&mut self, title: &str) { self.details.title = title.into(); }
        pub fn title(&self) -> &str { &self.details.title }
    }

    pub trait Labelled {
        fn rename(&mut self, title: &str);
    }

    impl Labelled for Card {
        fn rename(&mut self, title: &str) { self.rename(title); }
    }

    impl RenderOnce for Card {
        fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
            div().w(self.details.width).child(self.details.title)
        }
    }
}
```

The module produces typed field and method handles, a runtime schema, and native role adapters
from the declarations. `Card::fields()` and `Card::methods()` are convenient when those names are
available. The collision-free alternatives are `reflection::fields::<Card>()`,
`reflection::methods::<Card>()`, and for enums `reflection::variant_fields::<State>()`;
they preserve any inherent methods already named `fields`, `methods`, or `variant_fields`.
There are no per-trait reflection attributes, trait-set declarations, or capability constants in
this interface.

The attribute requires an inline module. It only sees types, traits, and implementations declared
there; implementations written elsewhere remain ordinary Rust. Typed field handles work with
borrowed, non-`'static` structs, while runtime `Describe` schemas and `Value`/`ValueMut` use
`Any` and therefore require `'static` types. Typed handles can access private fields and methods
through safe generated borrows where Rust visibility permits; they do not make private members
public. Dynamic name-based field lookup exposes public fields only. Conditional fields, variants,
methods, and eligible local trait implementations retain their `cfg` attributes. Trait
implementations with generic bounds are omitted from automatic role discovery; use
`.view(...)` or a manual role projection for those cases.
Tuple handles use `field_0`, `field_1`, and so on; dynamic names are `"0"`, `"1"`, and so on.
These refer to declaration positions, which stay stable when `cfg` removes an earlier field.
For generic `Element`, `View`, or `RenderOnce` implementations, name the GPUI trait explicitly or
import it directly from `gpui`; renamed imports work too. The module attribute can then supply the
schema hook without confusing an unrelated trait with the same name. It does not resolve arbitrary
glob imports or re-exports. Monomorphic types also have linked discovery, and the aggregate
`Element` derive probes its concrete receiver directly.

## Typed paths flow into selectors

A field carries its root and leaf types. Nested paths compose with `then`:

```rust,ignore
use cards::{Card, Details};
use gpui::reflection::TypedPath;

let width = gpui::reflection::fields::<Card>()
    .details
    .then(gpui::reflection::fields::<Details>().width);
let tree = root.select(Select::descendants().field(width), |width| {
    *width = px(120.);
});
```

Each path carries its exact root and leaf types. Paths compose through borrowed intermediate
fields, so a borrowed root or field type does not need to be `'static` when using the path's native
`get` or `get_mut` methods. A selector's erased query subject still requires a `'static` root.
The selector callback type infers from the path and cannot receive a different leaf type. Field
predicates preserve the root type, so the callback can edit the whole value:

```rust,ignore
let title = Card::fields().details.then(Details::fields().title);
let tree = root.select(
    Select::descendants().where_field(title, |title| title.starts_with("Draft")),
    |card| card.rename("Ready"),
);
```

Inactive enum paths are excluded before `nth` and `every` count matches. Additional field
predicates on a selected root must use paths from that same root type.

Filtering by a field keeps that exact root available for a native role or custom view projection:

```rust,ignore
let selector = Select::descendants()
    .where_field(title, |title| title.starts_with("Draft"))
    .role::<dyn cards::Labelled>();
root.select(selector, |label| label.rename("Ready"));
```

`.view(...)` works after the same filter and receives `&mut Card` in its projection function.

## Inspect through one borrowed value

`Value` and `ValueMut` pair a borrow with its runtime type. They work on `'static` data as well as
GPUI query subjects:

```rust,ignore
use gpui::reflection::{ValueMut, Type};

let mut value = ValueMut::new(&mut card);
value.field("details").unwrap().field("title").unwrap()
    .downcast_mut::<String>().unwrap().push('!');

assert_eq!(Type::of::<Card>().type_id(), std::any::TypeId::of::<Card>());
```

Named access returns a checked child value. `index` traverses standard `Vec`, `Option`, `Box`, and
fixed-size array values, including nested combinations and external type aliases. Discovery uses
the actual Rust type and its proven bounds, not a final identifier in the type's syntax. A child
can have a complete schema, a partial container shape, or remain opaque. Concrete described types
are discoverable across modules; generic children use type-directed discovery when Rust can prove
their schema. An unconstrained `T` cannot be assumed to implement `Describe` for every
monomorphization, so it may stay opaque until a concrete described monomorphization is linked or
its schema is initialized with `Type::of::<Concrete>()`. Use `Type::discover::<T>()` to look up
linked metadata explicitly. Existing handles to the canonical type slot observe metadata
published later. Schema field and role registrations keep the exact root type through assembly,
so a registration for a wrong root does not type-check.
`variant` identifies an active enum variant; repeated field names resolve within that variant.
`walk_mut` visits reachable values one borrow at a time. Typed `at(path)` access keeps exact field
types while operating on an erased root.

An inspector can use the same interface in a selector:

```rust,ignore
root.inspect(Select::descendants().class("card"), |mut value| {
    value.field("details").unwrap().field("title").unwrap()
        .downcast_mut::<String>().unwrap().push('!');
});
```

Dynamic schemas expose public struct fields. Private and restricted fields retain their Rust
visibility on typed handles and are not a public dynamic write interface. Enum payloads follow
the enum's visibility. Unknown child types stay opaque until discovery finds metadata; native
downcasts remain checked.

## Use ordinary trait views

```rust,ignore
root.select(Select::descendants().role::<dyn cards::Labelled>(), |label| {
    label.rename("Ready");
});
```

The callback type infers from the trait object. The module supplies safe native coercions for
local, dyn-compatible trait implementations. No vtable is fabricated, and no borrowed trait
object is retained in a schema. Fixed associated types are part of the exact trait-object type.
Traits with GATs or generic methods use concrete callbacks, where Rust imposes no reflection
signature restrictions.

For a described data value, `Type::role::<dyn Trait>()` prepares a copyable native projection,
which can lend the trait view from successive concrete values:

```rust,ignore
let role = Type::of::<Card>().role::<dyn cards::Labelled>().unwrap();
role.get_mut(&mut first_card).unwrap().rename("First");
role.get_mut(&mut second_card).unwrap().rename("Second");
```

Each borrow is checked against the root type. `ValueMut::cast_mut::<dyn Trait>()` uses the same
registered projection; `into_cast_mut` consumes a temporary wrapper and preserves the borrow.
`.role()` only uses role projections generated for trait implementations visible to the inline
module. `.view()` accepts a higher-ranked function pointer such as
`|card: &mut Card| -> &mut dyn ExternalTrait { card }`; a function item or noncapturing closure
can coerce to this pointer, so the projection can be reused. Use this for external trait
implementations, conditionally bounded implementations, or a custom field borrow. Manual
`Role<Root, Target>` adapters are another option for described data.
For a named projection function, write its trait-object result as
`&mut (dyn ExternalTrait + 'static)`: the target type is static, while the reference still borrows
the receiver. Inline closures infer that object bound from the selector.

## Call native methods through typed handles

Ordinary callbacks use ordinary Rust calls such as `card.rename("Ready")`. Use a generated handle
when you want an explicit method descriptor with the original signature and borrow behavior:

```rust,ignore
gpui::reflection::methods::<Card>().rename.call(&mut card, "Ready");
let title = gpui::reflection::methods::<Card>().title.call(&card);
```

Generated calls preserve native argument and return types, receiver borrows, method generics,
implementation bounds, async behavior, and unsafe requirements. Method descriptors are copyable
values; returned iterators and futures do not borrow a temporary descriptor. Nested function
signatures keep their own lifetime rules. Methods with the same name in
disjoint inherent impls share one handle field named after the method; for example,
`Card::methods().same.call(&mut card)` keeps the native method name. No synthetic `same_for_root`
name is needed. Calling an unsafe method handle requires an unsafe block just as calling its
original method does.

Write lifetime arguments explicitly in method return types, for example `Chars<'_>` rather than
`Chars`. The generated wrapper binds `'_` to the original receiver while keeping independent
argument lifetimes separate. An omitted lifetime on an external type cannot be recovered from
syntax alone when the wrapper has multiple input lifetimes.

## Layout and replacement

Selectors edit before layout. Measurement and retry paths can invoke callbacks again, so edits
should be repeatable. Class and ID conditions refer to the annotated node. `children` selects
direct child nodes; `descendants` crosses rendered subtrees. A component and its rendered root
remain separate nodes, while queries on the component borrow the authored component directly.
After that component is consumed, its authored value is unavailable.

Borrowed fields and role views cannot escape callbacks or overlap another mutable borrow.
Schemas contain immutable metadata and safe projection functions. They never contain element
addresses, mutable state, or references into a rendered frame. Child schemas resolve lazily;
recursive types do not recursively initialize under a registry lock.

Use `map_selected` when a callback needs to replace a node. The lower-level `select_mut`,
`reflect_mut`, `reflect_trait`, `trait_set`, and keyed `Capability` APIs remain available for
existing reflected builders and explicit adapter compositions. The legacy reflection macros and
capability APIs are lower-level tools; ordinary components, typed fields, and native trait views
use the interfaces above.

See [testing](element-api-testing.md), [performance](element-query-performance.md), and the
[experiment record](../tooling/api-experiments/README.md) for validation and the explored alternatives.
