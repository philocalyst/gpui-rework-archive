# Public selection and canonical property-state sketch

Reviewed base: `f0bd5335aeb831523f5c52777911b6052c7cabac`.
This commit contains declarations/layout controls and evidence only. No production
code changes, native opening, callback execution or new public API is implemented.
`tests/mount_api_controls.rs` compiles against actual Window, Win, Component,
LibraryButton and ValueEntry. Its hypothetical provider traits have no impls and
are compile-only notation, not a proposed generic callback-shape API.

The preferred boundary leaves Window::document, Win and native ownership alone:

```rust
pub struct PropertyState {
    pub target: Target,
    pub id: PropertyId,
    pub value: PropertyValue,
    pub contribution: Contribution<PropertyValue>,
}
// Upgrade the existing new pre-1.0 constructor's reply:
property_action(propose: Fn(&M) -> Option<PropertyChange>,
                reply: Fn(&mut M, Result<PropertyState, &Error>));
// Add one explicit selection/refresh constructor:
property_selection(propose: Fn(&M, Target) -> Option<(Target, PropertyId)>,
                   reply: Fn(&mut M, Result<PropertyState, &Error>));
```

These are signatures, with ordinary 'static callback bounds omitted for brevity.
Self Target is derived on the activation stack from the already resolved route
site and Sites namespace. Selection can return that target, or Refresh/catalog
controls can return an existing stored target. No callback is bound during mount,
no model address is stored, no node/header/context field is added, and ordinary
Route::invoke stays unchanged. Both constructors use the existing opt-in property
phase and route slot. The implementation can use a private Inspect/Edit request;
this is one synchronous transaction, not a queued command/effect system.

Canonical state is captured immediately after a successful property kernel edit,
or directly for Inspect, and before mutable reply. It is a snapshot at that exact
point. If reply changes an underlying source, the later description may produce
a newer value; the snapshot does not promise that future current value or ACK.
A Refresh route reads that later state. On rejection, reply receives the ordinary
borrowed Error. Source/barrier panic and component-projector quarantine semantics
remain the existing transaction's duties.

This solves the concrete public composition gap: the parent can explicitly bind
a selection action to APP.view(self), receive that root's Target and logical
property into its contained editor, and run with Window::document normally.
Subsequent Inherit returns the newly revealed canonical lower value. A callback
that returns only Target would leave the editor's canonical value unresolved.
A current ValueEntry keeps a PropertyValue from selection; that is insufficient
when Set masks an application source change. The typed control demonstrates the
required Set193.25 → source170 → Inherit → read170 path using existing public APIs,
but does not execute it. The implementation needs an actual behavior test.

Selection replaces the explicitly chosen root's on_click action. It does not add
bubbling, arbitrary descendant picking, or intercept all input in a component.
A consumer should expose an intentional selection mode/surface; normal mode keeps
the library's supplied click behavior. Component mapping must keep parent versus
child receiver authority explicit. No claim is made that a replaced action is
still invoked.

Actual x86_64 native-profile layout captures (bytes):

| Carrier | Size |
| --- | ---: |
| Win<empty> / Option<Win<empty>> | 8 / 16 |
| Window<empty> / Option<Window<empty>> | 72 / 72 |
| Window<8-byte model> / Window<128-byte model> | 80 / 200 |
| Window<actual Companion> | 208 |
| Owned PropertyState / Result<PropertyState,&Error> | 80 / 80 |
| Existing PropertyChange / proposed Inspect-or-Edit request / Option<request> | 48 / 48 / 48 |
| Current phase mirror | 32 |
| Naive phase with owned result / preferred private borrowed result phase | 96 / 40 |
| Proposed route with two method-item captures | 0 |

The borrowed private reply carries Result<&PropertyState,&Error>; its adapter
copies the owned public outcome once. This avoids embedding80 bytes in every
phase value. These are sizeof carriers, not proof of whole-function stack frames.
Full target/id/value/contribution are charged even when resolved and Set values
happen to agree. The existing Handler remains a16-byte trait-object box and
Admission16; neither needs growth. Private phase sizes are faithful type-shape
controls, not a compiled production implementation.

Route currently has four methods. Reusing its property slot adds no method to
its vtable. The selected standalone compiler control emits two56-byte x86 tables
(three metadata words plus four method pointers), zero-sized route payloads and
no route allocation for method-item captures. This models slot/header costs only;
its intentionally simplified method ABI is not a production-dispatch proof.
New callback monomorphizations/vtable instances and transient state copying are
real code/work costs. Final linked bytes require the implementation, not this
sketch. `vtable/control.ll` preserves the selected LLVM output.

Ownership alternatives were rejected for this slice:

- Adopting an existing Win can seed selection through current public queries, but
  Root-or-Win opening control grows empty/small/large envelopes to88/88/208 bytes
  versus current72/80/200. Win and Option<Win> are distinct8/16-byte carriers.
  Adoption must disable automatic presentation, revoke old P and old prepared
  tokens even for equal native size/DPI, rebuild at actual physical size/DPI,
  preserve exclusive lanes and close-before-model order, and audit wake attachment.
  Inbox wake is OnceLock-bound to an event loop; blindly reattaching is unsound
  lifecycle design. No such adoption implementation is proposed here.
- An initializer adds16 bytes as an optional boxed closure, or8 as an optional
  function pointer. A generic one-shot callback can erase default-instance storage
  but spreads another Window/NativeHost type parameter; binding inboxes after it
  changes Win's L type and needs an ordering/API rule. Before first native ACK,
  public query().one() rejects because recording S0 has no authoritative P. Running
  after first ACK requires another model operation/frame and explicit callback
  failure, close and wake handling. Neither initializer nor adoption solves later
  masked property reads without the state exchange.

The preferred design preserves native independent size/DPI, old-P coordinate
revocation, actual ACK, wake attachment, lanes, close and drop order by leaving
their owner path unchanged. Selected Targets remain inert logical capabilities,
checked on every Inspect/Edit. Source changes and replies must flow through the
corrected source barrier, never a fabricated changed_nodes edit count. Another
agent owns that correction; implementation will start from its qualified pin.

Simply upgrading property_action is smaller than a second state-returning edit
constructor: no legacy adapter/read-suppression branch or overlapping reply-shape
trait. In this tree, two explicit Result<(),&Error> callback signatures and one
Ok(()) pattern need migration; other callbacks ignore the payload. This is a real
pre-1.0 source compatibility change for explicit downstream unit-result handlers.
No ambiguous |_, _| overload is proposed.

Bounded implementation estimate: roughly90–130 net shipping Rust lines in element,
turn and exports, plus consumer example/tests. This is an estimate to compare with
the actual diff, not a code-golf allowance. Required gates include a real public
Window consumer with no private target seeding; masked-source/read proof; stale
selection/Refresh; wrong contained component; reply source mutation timing;
failed preparation, old P and ACK behavior; slot restoration on panic; exact
header/code bills; default/native/strict and desktop cross compilation.

Compile-only check passed:

```sh
source /tmp/gpui-native-env.sh
CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR=/tmp/gpui-presented-basis-target \
  cargo check --manifest-path reactivity/Cargo.toml -p gpui \
  --features desktop,x11,wayland,gpui_canvas/parallel \
  --test mount_api_controls --offline --locked
```

Initial deliberate zero-array diagnostics report concrete sizes; final controls
replace them with exact compile-time guards. No target was mounted or test run.
The vtable control uses rustc edition2024, --crate-type lib, --emit llvm-ir and
-C opt-level=3. Evidence includes source/toolchain hashes and source-line charges.
No timing, allocation or whole-application binary-size result is claimed.

Compile-only control source commit: `bb46a8c85c` (full hash is resolvable from this
archive's parent). Evidence follows separately; neither changes production code.
