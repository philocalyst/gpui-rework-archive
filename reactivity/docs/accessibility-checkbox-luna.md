# Accessibility next slice: a typed two-state checkbox

**Integration disposition.** Supplied SHA-256 `f462d2fbbb0e61e4fc584383fd20e42397350d61d2afd514359a8b027817754e`. The [controlled checkbox implementation](../evidence/typed-checkbox/README.md) is now integrated from shipping source `ddb0649e94`; its separate qualification pin `a2fc724bd4` changes only a must-use test discard. The simpler `CheckBox(bool)` kind normalizes state out of mount identity, while two Content tags freeze the state. All 29 measured carriers retain their layouts. Public lifecycle/identity, sparse/full Consumer comparison and actual native role/action/checked-event gates pass at those producer pins. This historical report remains research, not additional verification or a general accessible-widget parity claim.

Research-only audit of cleanroom GPUI at immutable commit `cc0f7aa5262fd90676ca44305303cbea851d2648` (tree `cd8039ef471c64c03f569251be30cac0625990d2`). No checkout, build, or implementation was performed for this report. The live worktree `/root/gpui-acknowledged-text-geometry` was on branch `acknowledged-text-geometry-sol`, HEAD `866e612d912c0e0e1a022552617acd3880ee9eb2`, not at the audited commit. Every GPUI source/document read below came from the shared Git object database with `git -C /root/gpui-acknowledged-text-geometry show cc0f7aa526:<path>` (the selected `<path>` is named below); source lines should not be read as live-worktree line numbers.

## Recommendation

Add one typed, controlled, two-state checkbox to the public element/query/native-projection path. Represent `checked` in the existing closed `NodeKind` carried by `Content` and `Presented`; derive `Role::CheckBox` and `Part::checked() -> Option<bool>` from that one tag. Reuse the existing `.on_click` owner route as the state transition, `ActionKind::Activate` as its advertised operation, and `Key::Space` as keyboard activation. The native AccessKit projection should emit `Role::CheckBox` plus `Toggled::True` or `Toggled::False` from the same acknowledged `Presented` state.

This is a narrow ordinary-control slice: it adds the missing boolean state-valued role while exercising the existing action and focus paths end to end. It does not add a general `role(...)` override, arbitrary AccessKit node writer, semantic state registry, reflected accessibility schema, numeric range API, or native widget binding. `Part::value()` remains the current text-input string accessor; checkbox state is checked/toggled state, not a string value.

An API sketch (not compiled) is:

```rust
fn view(&self) -> El<'_> {
    checkbox("Show hidden files", self.show_hidden)
        .on_click(Model::toggle_hidden)
}

fn toggle_hidden(&mut self) {
    self.show_hidden = !self.show_hidden;
}
```

The model remains the source of truth. Each render supplies its current boolean; the published `Presented` kind freezes the checked bit for queries and native projection. The callback must update that model value. Existing style/layout and GPU rendering continue to own appearance; the proposal adds no OS-specific control or platform binding.

## Why this is the next slice, rather than repeating the existing frontier

I read these documents at `cc0f7aa526` before tracing code:

- `reactivity/docs/production-gaps-luna.md` (especially lines 3–32): its own audit-source note points to older commit `36921e2c42efe8569889d16a27295d8ee7b790a2`; the claim at line 28 that text-selection actions and native text-run projection are missing is stale at `cc0f7aa526`. The current pinned code already contains `SetTextSelection`, `ReplaceSelectedText`, text-run projection and native action ingress. Do not carry that gap forward.
- `reactivity/docs/accessibility-frontier-luna.md` (lines 5–11, 31–65, 67–107): its recommendations already cover acknowledged-`Presented` authority, no second GPUI semantic tree, compact kind-derived role/default actions, tree-level focus, virtual lists, full bounds and action lifecycle. This proposal follows that ownership design; it does not reopen those projects.
- `reactivity/docs/accessibility-transition-descriptor-luna.md` (lines 5–40, 55–70): sparse publication must be exact against the complete consumer tree, and transitions should compare emitted semantics rather than retain another semantic cache. Current transition collection already compares `Presented.kind` and `actions`, so an on/off kind transition naturally becomes a dirty entry.

At this source pin, public `Role` has eight variants and no checkbox; it is derived from private `NodeKind`. `Part::value()` returns text only for `Input`. The framework already has `Activate`, `Focus`, and `Blur`, a one-byte action mask, owner-thread activation, keyboard focus, and a native AccessKit Click mapping. A checkbox is therefore a smaller missing-value/control slice than a slider: a slider needs a numeric value contract, min/max/step semantics, Increment/Decrement routing, bounds validation and its keyboard policy. The proposed checkbox contributes the missing non-text state without inventing a generic state schema.

| Dimension | Existing at `cc0f7aa526` | Checkbox slice |
|---|---|---|
| Role | `Generic`, `Text`, `TextInput`, `Button`, `List`, `ListItem`, `Image`, `ScrollView` | Add public `Role::CheckBox`, derived from the private kind |
| State/value | `Part::value() -> Option<&str>` for text inputs | Add `Part::checked() -> Option<bool>`; native state is AccessKit `Toggled`, not `Node::value` |
| Action | `Activate`, `Focus`, `Blur` already exist; handlers make generic controls interactive | Reuse `Activate`/AccessKit `Click`; do not add a `Toggle` action bit |
| Focus | logical `Target` focus and `TreeUpdate.focus` already exist | `.on_click` makes the checkbox focusable using current rules; Tab/Space use existing owner paths |

## Concrete source path and retained representation

Local implementation sources, all read with the `git show` form stated above:

- `reactivity/crates/gpui/src/element.rs`: `NodeKind` and public `Role` are at lines 17–53; optional `name`/`description` builders and `.on_click` are at 387–426; child admission at 404–416; constructors at 852–879.
- `reactivity/crates/gpui/src/runtime.rs`: `Content(u32)` packs eight kind tags in three low bits and text/image payload above them at 499–569; `Node::focusable` derives focus from input/button or handler at 584–600; `Presented` already stores `kind` and `Actions` at 701–711; `present_inner` freezes kind and derives actions from kind/handler at 2925–2942. `MAX_NODES` is 100,000; the existing `PresentedLink` bound is stricter at fewer than `2^17` nodes.
- `reactivity/crates/gpui/src/runtime/query.rs`: borrowed `Part::focused`, `actions`, `role`, and `text` are at 172–185; name fallback and description at 240–259; input-only value at 289–293. `Part::checked()` can be a direct match over the already-frozen private kind.
- `reactivity/crates/gpui/src/runtime/semantics.rs`: action bits are in a one-byte `Actions(u8)` and `for_node` currently derives activation/focus from handler and kind at 60–103; `Win::perform` checks the acknowledged action mask and routes activation/focus at 106 onward.
- `reactivity/crates/gpui/src/runtime/input.rs`: `Key` includes `Tab`, `ReverseTab`, `Enter`, and `Space` at 47–61; Tab traversal is at 177–219, and Enter/Space route focused non-input nodes to activation at 221–246. `Runtime::focusable` and the focus predicate are at 250–261.
- `reactivity/crates/gpui/src/native/accessibility.rs`: native actions decode Click to `Command::Activate` at 153–175; `projected_node` maps roles, names/values, bounds, and action bits at 490–578. Add the checkbox match and set its `toggled` state there; preserve `Part::value()` for text input.
- `reactivity/crates/gpui/src/runtime/accessibility.rs`: sparse transition comparison checks `previous.kind != next.kind` and actions at 182–205. This already captures the checked transition if on/off are distinct `NodeKind` values. Re-project the complete AccessKit node for that changed index, as the transition document requires.
- `reactivity/crates/gpui/src/lib.rs`: public element functions and `Role` exports at 31–35; public runtime query types at 56–60; prelude at 87–94. Export the constructor consistently if adopted.
- `reactivity/Cargo.lock` pins `accesskit 0.25.1` at lines 6–8.

Use two private kind tags, e.g. `CheckBoxOff`/`CheckBoxOn`, both mapping to public `Role::CheckBox`; derive checked state from those variants. This stores no additional per-node boolean or semantic sidecar. `Content` currently uses all eight 3-bit kind values; two new variants require a 4-bit low tag. `Content` itself remains a `u32`, while its text/image payload shifts change from 3 to 4 bits. At `MAX_NODES = 100,000`, the 28-bit text payload is ample, and the doubled image resource/sampling payload also fits comfortably; keep the compile-time capacity assertions honest and test the highest admitted encodings. No `Content`, `Presented`, `Annotations`, or `Metadata` field is added by this design. This is a representation argument, not a measured memory result: `NodeKind`, `Role`, `El`, `Node`, `DraftNode`, and `Presented` sizes/strides must be recorded after an implementation build before claiming unchanged hot-object sizes.

The other plausible compact encoding would reuse the otherwise payload-free Scroll tag and branch on its upper payload to distinguish checkbox text/state from Scroll. It avoids changing the global shift but makes `kind()` and `text_slot()` depend on sentinel/payload arithmetic. The explicit 4-bit tags are clearer and easier to round-trip exhaustively; the small available capacity reduction is immaterial under the pinned 100,000-node limit. Do not add the checked bit to `Annotations`, a new semantic column, a per-node AccessKit cache, or a reflected `Property` schema.

The existing action mask consumes all eight bits (Activate, Focus, Blur, SetValue, Scroll, ScrollIntoView, SetTextSelection, ReplaceSelectedText). A new Toggle action would widen retained action state without adding an operation that the existing route lacks. Checkbox activation is the existing `Activate`; AccessKit defines `Click` as the equivalent of a click/tap. Focus remains one current tree focus in `TreeUpdate`, not a checkbox-local bool. With an attached handler, `Actions::for_node` already gives the checkbox Activate/Focus/Blur, `Node::focusable` admits it, Tab sees it, Space activates it, and the native Click ingress queues the same owner action.

No duplicate role/state switch should be created: `NodeKind::role()` remains the source for query and native role; `NodeKind::checked()` (or equivalent) is the source for query state and `Node::set_toggled`. Since the existing sparse observer compares the whole kind, changing checked state changes the same node and requires no second dirty schema. GPUI continues to retain only its acknowledged `Presented` authority; the active AccessKit adapter retains the native-facing consumer tree it already needs.

## Standards and upstream precedent

WAI-ARIA requires `aria-checked` for the checkbox role, with `true`, `false`, or `mixed`; a two-state checkbox is a legitimate subset. The APG checkbox pattern requires an accessible label and says Space changes the state when focused. Therefore a boolean API must emit explicit true/false and must not silently encode the checked state as a label string or as the text-input `value` slot. [WAI-ARIA 1.2 checkbox role](https://www.w3.org/TR/wai-aria-1.2/#checkbox), [WAI-ARIA 1.2 `aria-checked`](https://www.w3.org/TR/wai-aria-1.2/#aria-checked), [WAI-ARIA APG checkbox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/checkbox/).

The pinned lockfile's AccessKit 0.25.1 has `Role::CheckBox`, `Toggled::{False, True, Mixed}`, and `Node::set_toggled`; its docs say this is the checked or pressed state of a toggle control, interpreted using the node role. For this control, emit only `False`/`True`. AccessKit's `Click` is its standard single-click/tap action. Use the exact pinned API rather than inventing a platform-specific state or projecting the bool through `Node::set_value`. [AccessKit 0.25.1 `Role::CheckBox`](https://docs.rs/accesskit/0.25.1/accesskit/enum.Role.html#variant.CheckBox), [`Toggled`](https://docs.rs/accesskit/0.25.1/accesskit/enum.Toggled.html), [`Node::set_toggled`](https://docs.rs/accesskit/0.25.1/accesskit/struct.Node.html#method.set_toggled), [`Action::Click`](https://docs.rs/accesskit/0.25.1/accesskit/enum.Action.html#variant.Click).

Original GPUI exposes a much broader author-controlled route: the pinned GPUI `Element` trait permits `a11y_role` and arbitrary `write_a11y_info`, while its guide demonstrates a role plus `on_a11y_action(Increment)` and says `.on_click()` also registers AccessibleAction::Click. This is precedent for role/action coverage, not a reason to add raw-node escape hatches to the cleanroom's narrow typed model. [Original GPUI `Element` at `566f893ee3b52eae87957ee6ba0edea89b7783b1`](https://github.com/zed-industries/zed/blob/566f893ee3b52eae87957ee6ba0edea89b7783b1/crates/gpui/src/element.rs#L2365-L2390), [original GPUI accessibility guide at the same pin](https://github.com/zed-industries/zed/blob/566f893ee3b52eae87957ee6ba0edea89b7783b1/crates/gpui/src/_accessibility.rs#L1173-L1202).

## Adversarial acceptance cases

1. **Complete representation round-trip.** Cover `CheckBoxOff`/`CheckBoxOn` with text/no-text policy, all existing kinds, image resource and sampling values, first/last admitted text slots, and checked state. `Content` must remain four bytes; the 4-bit-tag assertions must cover normal text packing and image packing.
2. **State provenance and acknowledgement.** `Part::checked()` and native projection read the acknowledged `Presented` sheet only. Mutate the model and prepare a candidate without acknowledging it: the old checked state remains exposed. On acknowledgement, the new value appears. A failed newer prepare must not leak newer state into the last coherent P.
3. **One operation, three routes.** Mouse press/release, `Key::Space` while focused, and AccessKit `Click` each invoke the same handler once. State changes only if the callback changes the model; callback no-op leaves the published state unchanged. Verify ordinary focus, blur, Tab and reverse-Tab continue through existing owner logic. Existing `Key::Enter` also activates non-input controls; explicitly decide and document whether that framework-wide behavior is retained for checkboxes (APG requires Space but does not specify Enter).
4. **Fresh capability and state transition.** Removed/replaced/foreign/stale `Target`s still fail normal identity/action checks. After an on/off publication, apply the sparse update to pinned AccessKit Consumer and compare role, label, toggled state, bounds, actions, children and focus with a complete fresh projection. Verify a focus-only change sends the normal focus update and does not create a per-node focused flag.
5. **Name/value separation.** Visible label is the checkbox's default name; explicit `.name()` overrides it; `.description()` remains separate. Empty or absent accessible labels should be detected in tests/documentation rather than substituted with checked state. Verify text inputs still expose string `value`, while checkboxes expose boolean `checked` and AccessKit toggled state.
6. **Handler presence and unsupported states.** A checkbox with `.on_click` must advertise Activate/Focus/Blur and be focusable. Decide what a checkbox without a handler means before shipping; current generic action policy makes handler-backed non-input nodes interactive, but the runtime's keyboard path can return `NotInteractive` if a focusable control has no route. The cleanest bounded contract is to document `.on_click` as required for interactive use and ensure a handler-less checkbox is not advertised as actionable/focusable, or make the constructor require a handler. Do not claim disabled/read-only semantics without representing them. This first API is dual-state only; mixed state requires a later explicit type/tag and its own tests.
7. **Cross-platform proof.** Run the AccessKit Consumer oracle and the existing actual Linux/AT-SPI, macOS and Windows native compile gates after implementation. The source path is cross-platform because all platforms consume AccessKit semantics; this research does not claim VoiceOver, UIA, Orca, or Windows screen-reader speech was executed.

One compatibility issue needs an explicit release decision: `Role` is public, derives `Serialize`, and is not `#[non_exhaustive]`. Adding `Role::CheckBox` can break downstream exhaustive matches. Do not hide that consequence with a parallel role enum; accept it under the crate's current compatibility policy or schedule it for a compatible major/pre-1.0 boundary.

## Measurement gates (not measurements)

This report measured no source/header count, memory, render behavior, adapter behavior, or performance. After a bounded implementation, record `size_of`/`align_of` for `Content`, `NodeKind`, `Presented`, `Node`, `DraftNode`, and `El`; compare `Vec<Presented>` bytes at equal node counts to the pinned baseline. Also record authored-source delta and the checkbox fixture's generated native node/update allocations. Do not infer a zero-stride increase for `NodeKind` from its declaration. Run the Consumer differential test for both state transitions and native lifecycle tests before claiming production readiness.
