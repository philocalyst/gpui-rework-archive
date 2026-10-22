# Retained inspector UI

`Window::document(model).inspector()` opens the real application beside a retained
inspector. `cargo run -p gpui --features x11 --example inspector -- --cpu` runs the
native example. `Win::with_inspector(model, options)` and
`Win::recording_with_inspector(model, options)` expose the same UI and ordinary
pointer/keyboard paths without an OS window.

Pick selects the foremost application shape using the ordinary rounded/clip hit
kernel. It consumes the click without activating the application. The panel's own
subtree cannot be selected. Parent walks the actual retained parent relation and
stops at the application root. Width supports Set(Some(value)), Set(None), and
Inherit; background supports Set(color) and Inherit. Inherit reveals the latest
application declaration, including declarations changed while an override exists.

The selected target is window-qualified and checked against the current logical
cohort before dispatch. Removal clears selection; a replacement cannot inherit
its predecessor's authority. Pointer selection requires a current acknowledged
presentation and consumes failed releases. Logical keyboard activation remains
available after a preparation failure, using the same repair path as other
controls. Inspector edits call the very same typed style setter as
`Win::set_property`; validation and source admission are shared.

The panel distinguishes current logical properties and computed local layout from
acknowledged displayed bounds and total transform. Displayed geometry carries its
presentation epoch. It can lag the logical epoch during pending or failed
presentation; the UI does not label an old displayed rectangle as current logical
geometry.

The shell is installed only at initial mount and retains the application's parent
path. The private panel has a fixed 17-node description. Its few ordinary text
slots are refreshed from the selection; panel root and offsets are rediscovered
inside the current cohort after every description. No application snapshot,
shadow tree, node registry, AnyMap, shared owner, or interior-mutability wrapper is
retained. Updating these text slots does not rerun the application's `View`.
Native resizing updates the private shell's dimensions, preserving app dimensions.

On 64-bit targets the opt-in state is 24 bytes plus its allocation. `Metadata`
gains one 8-byte optional box; the existing optional `Metadata` owner stays absent
in plain windows. `Handler` remains 16 bytes; ordinary method-item route payloads
remain zero sized. Seven tool routes each allocate one 1-byte closed effect.
`Runtime`, logical node headers, and presented node headers do not grow. Opted-in
windows additionally retain two shell nodes and 17 ordinary panel nodes, with
ordinary style/text/layout/paint storage and font resources. The inspector unit
ledger prints concrete runtime, metadata, route, and text-capacity sizes.

The first iteration is visible for the lifetime of a configured window. It does
not yet provide a keyboard visibility toggle, hovered outlines, depth selection,
arbitrary numeric text entry, or controls for every typed property. Those can
extend the same retained UI and typed setters.

Validation covers real controls through normalized pointer/keyboard input,
noninteractive rounded picking, foreign/removed/panel targets, Set(None), updated
inheritance, target stability, failed-presentation repair, and native X11 delivery.
The ignored native test fetches the actual server image after successful native
presentation and checks application tint and independent panel pixels.

At the pre-bank source baseline `131c6123f5`, the 64-bit X11-minimal test reports
`Node=40`, `Runtime=2320`, `Metadata=264`, `Inspector=24`, `Handler=16`, and
`WindowAction=1` bytes. A blank 800×560 headless mount retains 1,797,324 bytes in
21 allocations without tools and 1,856,788 bytes in 197 allocations with tools:
59,464 additional bytes, including actual font/text/layout/paint resources. The
panel's ordinary text lane has 14 live slots and capacity 14. These are source-
and fixture-qualified allocation-counter observations, not a per-window constant.

The change adds 533 non-test Rust physical lines, including comments and blanks:
370 in the inspector module, 64 in the native example, and net 99 in the route,
mount, input, metadata, and turn hooks. Existing production prefixes are counted
before their embedded `#[cfg(test)] mod tests`; test-only modules and integration
tests are excluded. The shared style setter moves without adding a second setter.
