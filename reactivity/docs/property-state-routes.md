# Contained property selection and edits

`property_selection` resolves an activation site's mounted Target without adding
a window initializer, storing a Win in the model or introducing another owner.
Its proposal reads `&Model` and receives that site's Target. It can select that
target or refresh a previously selected `(Target, PropertyId)` pair. `None` is an
idle operation. Installing it with `on_click` replaces that site's previous
action; descendant picking, bubbling and additive interception are separate work.

`property_action` proposes a typed `PropertyChange` from `&Model`. Both routes
then call an ordinary mutable model method with `Result<PropertyState, &Error>`.
This is an explicit pre-1.0 change from the earlier unit-valued edit reply.
The public snapshot contains the target, property ID, canonical logical value
and current Set/Inherit contribution. An accepted edit captures that state
after the canonical property kernel and before the mutable reply. A reply that
changes a masked source can therefore produce newer state at the subsequent
source barrier; Refresh reads that newer state. The snapshot carries no source
revision or presentation authority. Native semantic queries still read the
acknowledged sheet, including its matching text geometry.

The public [property_editor example](../crates/gpui/examples/property_editor.rs)
composes a library control and a reusable contained value editor. Enable
**Inspect application**, activate the library button, then Apply, Inherit or
Refresh selection. Ordinary mode preserves the library's supplied action;
inspection replaces only the explicit application root action. The editor
decodes values through the existing typed property catalog and refreshes its
draft from accepted canonical state. It does not seed a Target through private
native hooks.

```sh
cargo run -p gpui --features x11 --example property_editor -- --cpu
```

The implementation extends the existing property exchange with private Inspect
and Edit requests. The request, activation Target and borrowed reply exist only
on the activation stack. The installed handler is still 16 bytes; a method-item
selection route has a zero-sized capture. Runtime ownership and ordinary invoke
admission stay unchanged. One existing source barrier handles reply changes and
the exact union of property and description changes. Current source admission
precedes both edit and reply; stale and rejected property requests can update
the tool's ordinary error state, while operational failure and malformed
component projection follow the existing quarantine rules.

Source `c717df64a9` integrates the reviewed producer `021dcb5d29`. Public cases
cover all 13 properties, masked source changes, inherited refresh, stale/foreign
selection, empty proposals, pending and failed candidates, and malformed mutable
component projections. The external native replay launches the unmodified
example and uses the actual Registry, checkbox Action, library Action,
EditableText, Apply, Inherit and Refresh. It verifies acknowledged draft text,
character extents and the application's changed and restored width. Source and
executable guards qualify that functional proof; it measures no native latency
or RSS. The [combined main campaign](../evidence/property-selection-main/README.md)
and [producer cost controls](../evidence/property-selection/final/README.md) retain
their own source pins.
