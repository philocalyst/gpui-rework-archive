# Luna 05: input and focus documentation review

## Read inventory

Read the local public contracts and implementation in:

- `crates/gpui/src/action.rs`: `Action`, action registration, derive requirements, and action-build errors.
- `crates/gpui/src/input.rs`: `EntityInputHandler`, `ElementInputHandler`, and UTF-8/UTF-16 offset conversions.
- `crates/gpui/src/interactive.rs`: key, mouse, touch, click, scroll, drag/drop, and platform input event types.
- `crates/gpui/src/key_dispatch.rs`: dispatch-tree construction, action/key listeners, focus-path lookup, and chord matching.
- `crates/gpui/src/keymap.rs`, `keymap/binding.rs`, `keymap/context.rs`, and `keymap/collection.rs`: keymap precedence, context grammar, binding parsing, and action-binding helpers.
- `crates/gpui/src/tab_stop.rs`: focus-handle ordering, nested tab groups, wrapping, and skipped stops.
- `crates/gpui/src/gestures.rs`: touch gesture lifecycle, thresholds, prediction, scroll phases, fling models, and platform tuning interface.
- `crates/gpui/src/inspector.rs`: inspector element identity and selection state.
- `crates/gpui/src/_accessibility.rs`: element/global IDs, roles, labels, hidden subtrees, accessible actions, and synthetic children.
- Dependencies read without editing: `crates/gpui/src/window.rs` for event and action dispatch, focus, hit testing, pointer capture, and touch integration; `crates/gpui/src/app.rs` for app interceptors, observers, and global action handling; `crates/gpui/src/platform.rs` for the `InputHandler` callback contract.
- Existing guides: `crates/gpui/docs/input.md` and `crates/gpui/docs/key_dispatch.md`.

Coverage: I reviewed the exported public methods/fields for `Action` and its errors, both offset helpers and every `EntityInputHandler`/`ElementInputHandler` method, the public event types and methods in `interactive.rs`, the public `Keymap`/`KeyBinding`/`KeyContext`/predicate/collection methods, the public tab-order operations, the public gesture types/methods, and the inspector/accessibility documentation. `ActionRegistry` and the dispatch-tree types in `key_dispatch.rs` are crate-private; I read their relevant construction, precedence, and dispatch code but did not write rustdoc for their implementation-only methods. The private touch recognizer was read around its state transitions and outputs, not line-by-line through its velocity and spline math. Focus-handle APIs in `window.rs` were read as dependencies only, per scope.

## Documentation changes and factual fixes

`crates/gpui/docs/input.md` now walks from platform event through target selection and propagation, then explains pointer activation, focus attachment versus requesting focus, action/keymap selection, chords and their timeout, text input, offsets, and accessibility. It includes an API choice guide: use an action for a shared operation, a raw key handler when the keystroke itself matters, and `EntityInputHandler` for text composition and replacement. It includes a coherent editor action/binding snippet and links the terms back to GPUI APIs and the existing actions walkthrough.

`crates/gpui/docs/key_dispatch.md` is aligned with that guide: it now explains the action/key-context/listener division, focus attachment, context precedence, configuration errors, null/`Unbind` removal semantics, and chord replay timing. Its JSON example is explicitly a Zed-style entry in an application-owned keymap format, not a GPUI-owned file schema.

The guide distinguishes ordinary event propagation from action propagation. Window dispatch runs ordinary capture handlers root-to-target and bubble handlers target-to-root (`window.rs:6423-6444`); action handlers have a capture phase and stop by default as each matching bubble handler is reached (`window.rs:6860-6923`). The previous guide's basic propagation note lacked this difference and did not explain capture stopping the subsequent bubble phase.

Click documentation distinguishes the mouse and keyboard variants from a direct touch-activation variant, and records that the portable touch recognizer currently routes taps as synthesized mouse input. `ClickEvent::mouse_position()` only has a value for the `Mouse` variant, and keyboard `position()` is a bounds-derived coordinate (`interactive.rs:302-364`). The guide also separates press from completed activation and explains hitbox occlusion and pointer capture (`window.rs:788-843`, `window.rs:3217-3234`).

Focus documentation separates keeping a `FocusHandle`, attaching it to the element tree with `track_focus`, and requesting it through `Window::focus`. The window stores a requested focus ID; the current dispatch tree resolves a missing focus node to the root, so unattached focus does not give the element its own key-handler node (`window.rs:2397-2410`, `window.rs:6780-6797`). It also says pending chords are cleared on focus changes, which is explicit in `Window::focus`.

Keymap documentation now defines context identifiers, key/value entries, descendant predicates, and the depth/later-binding precedence rules. `Keymap::bindings_for_input` orders matches by context depth then insertion index (`keymap.rs:177-214`); the implementation also handles disabled bindings and prefixes. The chord discussion names the one-second flush timer (`window.rs:6560-6589`) and focus-bound pending state (`window.rs:6580-6585`). It notes that application keystroke interceptors run before resolution and raw key listeners follow binding matching (`app.rs:2383-2425`, `window.rs:6601-6668`).

The text-input section states that platform ranges are UTF-16 code units and that the conversion helpers clamp beyond the end and snap interior code-unit/byte offsets to an encoded character boundary (`input.rs:7-44`). It directs reader to the `InputHandler` callback contract for optional returns and composition semantics (`platform.rs:2577-2740`).

Accessibility guidance now differentiates `AccessibleAction` from GPUI `Action`, and points to stable element IDs, roles, hidden-subtree behavior, and synthetic descendants in `_accessibility.rs`. The source guide there also warns that a hidden element retains input/focus behavior.

`interactive.rs` had a stale `TouchEvent` comment claiming a “core implementation pending” and a fixed touch-start hit-test contract. The current window dispatches raw touch updates through the mouse-event path at each update's current position, then feeds them to the touch recognizer (`window.rs:6200-6207`, `window.rs:6284-6310`). I replaced the stale promise with the implemented raw-event/recognizer distinction and the `TouchId` lifecycle. The portable recognizer synthesizes mouse press/release events for taps, emits phased scroll events for pans, offers a phased `LongPressEvent`, and does not implement pinch (`gestures.rs:488-497`, `gestures.rs:551-567`, `window.rs:6284-6359`). The input guide records these outputs, cancellation behavior, and default gesture thresholds (`gestures.rs:119-145`).

`ClickEvent`'s type-level documentation also implied that portable touch taps and long presses currently arrive through click callbacks. The active pipeline instead synthesizes mouse events for taps and emits `LongPressEvent` directly; I corrected the event docs to distinguish those paths (`interactive.rs:283-318`, `gestures.rs:488-497`, `window.rs:6348-6370`). The guide warns that `mouse_position()` being present does not prove a physical mouse source because the synthesized tap uses the `Mouse` variant.

`keymap/context.rs` now documents that `KeyContext::set` and `extend` insert only missing keys (existing entries win), and that malformed context predicates return an error. This behavior was easy to mistake for replacement/overwrite semantics (`context.rs:117-150`, `context.rs:235-273`).

The `KeyBinding` accessors now state whether they return clones, a borrowed action, or a structural sequence match; the docs call out constructor panics, explicit mapper/error handling, and empty-stroke bindings. `Keymap` now distinguishes context-free display lookup from runtime path dispatch, documents proper-prefix results, and describes the opaque revision's equality-only use. `ActionBindingCollection` docs name its parser panics and dummy mapper limitation. `EntityInputHandler` methods now explain UTF-16 query/update semantics, `None` cases, default paste behavior, geometry units, and which optional defaults leave text input unbounded or disabled; `ElementInputHandler::new` clarifies its entity/bounds lifetime. `ScrollDelta` docs now explain line-height scaling and mixed-unit coalescing. Gesture docs state that core currently ignores `native_recognizers()` and validate the tuning units/ranges.

## Pinned consumer references

The Zed reference clone is pinned at `da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f` (`markdown: Fix code block scrollbar track leaking past rounded corners (#64978)`). Useful paths:

- `crates/workspace/src/pane.rs:4424-4456` combines a pane's runtime key context, focus handle, and scoped split actions. This is a concrete example of why context belongs to a component boundary and why action listeners need not live on the top-level view.
- `crates/gpui/examples/input.rs:591-610` gives a text input both a `TextInput` context and a focus handle, binds editing operations as actions, and handles pointer placement through mouse events.
- `crates/gpui/examples/tab_stop.rs:72-108` demonstrates explicit per-item focus handles and skipping elements whose `tab_stop` flag is false.
- `assets/keymaps/default-macos.json:49-56,155-198,268-277` shows actual context predicates: simple identifiers, `&&`, values, negation, and the descendant operator. Linux defaults also use grouped boolean expressions, such as `assets/keymaps/default-linux.json:620`.

The Hummingbird reference clone is pinned at `2e1ee5f1c8d415ef7f835801fe368ab4106035b5` (`fix: another non-runtime error`). Useful paths:

- `src/ui/components/input.rs:878-915` uses a focused `TextInput` context for editing actions while retaining raw mouse handlers for cursor placement.
- `src/ui/components/dropdown.rs:189-224` gives a popup a stable ID, occlusion behavior, focus handle, context, and action listeners for navigation. Its `.occlude()` call is a practical reminder that visual overlay/input eligibility is separate from event callbacks.
- `src/ui/keymap.rs:55-80` loads actions and predicate strings from JSON, surfaces invalid action/context/keystroke configuration, and installs bindings through `App::bind_keys`.
- `src/ui/global_actions.rs:43-65` registers app-level actions; `src/ui/command_palette.rs:369-383` uses a global action to open a command palette.

These references informed the usage scenarios and terminology, but local code remains authoritative.

## Jiff documentation model

I read the primary [Jiff crate documentation](https://docs.rs/jiff/latest/jiff/). Its useful editorial pattern is to orient readers with the essential concepts, show a complete, runnable core example, and send each concept to a focused API page. The input guide follows the concept-first and linked-terms pattern; it deliberately avoids presenting incomplete GPUI code as a standalone runnable project.

## Remaining gaps for the final pass

- `crates/gpui/docs/key_dispatch.md` is aligned with the input guide, but the two pages still repeat the action and binding example. If the API changes, keep those examples synchronized or reduce one page to a focused overview.
- The public `PlatformGestures::native_recognizers` method is currently only declared in `gestures.rs`; local GPUI code reads platform `tuning()` but has no call site for `native_recognizers()` (`rg` found only the declaration and documentation). Do not describe native recognizers as replacing core recognizers until there is an implementation path.
- `TouchEvent`'s public docs now describe the implemented current-position routing and ID lifecycle, but the precise hit-test/occlusion contract for a moving touch is not separately specified as a stable public guarantee. The guide avoids promising a fixed target across the contact.
- The guide includes an action handler and app-binding snippet, but it was not compile-verified under the no-build instruction and does not render a complete application or show an ancestor handler receiving a propagated action. The existing actions walkthrough remains the full runnable example; a future pass could add a parent handler if it can be kept synchronized.
- Accessibility identity and synthetic-child rules already have substantial source documentation in `_accessibility.rs`; future edits should preserve that detail and link to it rather than duplicating the entire guide.

No build or tests were run, per the task instruction.
