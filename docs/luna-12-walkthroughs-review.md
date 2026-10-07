# Luna 12: walkthrough and authored-site prose review

First-pass review for the walkthrough narratives, authoring instructions, and
task guides. This report is evidence for the root pass, not a final acceptance
review. All runtime descriptions need to be reconciled with the eventual
browser compiler/Miri Worker and checked again after that implementation lands.

## Editorial sources read

- [Jiff crate documentation](https://docs.rs/jiff/latest/jiff/), live 0.2.38 on
  2026-10-07. Its overview introduces the domain types and their relationships,
  then points to usage, task examples, features, and longer design/platform
  documents. The examples pair a common operation with ambiguity, fallible
  inputs, alternatives, and limits. GPUI pages should use the same progression:
  name the user's goal, explain the relevant relationship, show the working
  path, and put constraints next to the operation that triggers them.
- [Gwern's style guide](https://gwern.net/style-guide), read 2026-10-07. The
  useful principles here are durable, self-documenting hypertext, deep links,
  progressive detail, and primary-source verification. Its “iceberg” hierarchy
  keeps essential instructions visible and moves supporting material into a
  deeper layer. GPUI's pages should link each claim to the contract or example
  that can substantiate it.
- [Wikipedia's signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing),
  read 2026-10-07. The review used its warning against importance-sounding
  generalities, repetitive constructions, and claims whose support is vague.
  Replace those with a concrete trigger, observed effect, and reader action.

## Files read

Authored site content reviewed (generated `site/content/examples/*.md` and
`site/content/sources/*.md` were not edited):

- `site/content/_index.md`
- `site/content/about/_index.md`
- `site/content/about/contributing.md`
- `site/content/about/references.md`
- `site/content/about/writing.md`
- `site/content/examples/_index.md`
- `site/content/guides/_index.md`
- `site/content/guides/assets.md`
- `site/content/guides/async.md`
- `site/content/guides/drawing.md`
- `site/content/guides/focus.md`
- `site/content/guides/lists.md`
- `site/content/guides/live-editing.md`
- `site/content/guides/performance.md`
- `site/content/guides/platforms.md`
- `site/content/guides/setup.md`
- `site/content/guides/start-a-project.md`
- `site/content/guides/state.md`
- `site/content/guides/testing.md`
- `site/content/guides/text.md`
- `site/content/guides/windows.md`
- `site/content/reference/_index.md`
- `site/content/reference/input.md`
- `site/content/reference/ownership.md`
- `site/content/reference/rendering.md`
- `site/content/reference/scheduling.md`
- `site/content/reference/versions.md`
- `site/content/search.md`
- `docs/documentation-authoring.md`
- `docs/documentation-research.md`
- `docs/documentation-integration-audit.md`
- `docs/miri-documentation-integration.md`
- `docs/examples.md`
- `docs/luna-03-elements-review.md`

All 12 canonical walkthrough sources were read and their narrative comments
were revised: `site/examples/examples/{actions,animation,async-task,counter,
custom-element,drawing,first-window,layout,lists,subscriptions,
text-hit-testing,text}.rs`. The component code and launcher were left untouched.

Direct implementation reads included `site/examples/src/support.rs`,
`crates/gpui/src/app/context.rs`, `crates/gpui/src/app/async_context.rs`,
`crates/gpui/src/window.rs`, `crates/gpui/src/elements/div.rs`,
`crates/gpui/src/elements/list.rs`, `crates/gpui/src/elements/uniform_list.rs`,
`crates/gpui/src/elements/text.rs`, `crates/gpui/src/elements/animation.rs`,
`crates/gpui/src/element.rs`, `crates/gpui/src/view.rs`,
`crates/gpui/src/elements/canvas.rs`, and `crates/gpui/src/taffy.rs`.
For the remaining guide revisions I also read the relevant sections in
`crates/gpui/src/assets.rs`, `crates/gpui/src/asset_cache.rs`,
`crates/gpui/src/elements/img.rs`, `crates/gpui/src/elements/image_cache.rs`,
`crates/gpui/src/elements/svg.rs`, `crates/gpui/src/elements/surface.rs`,
`crates/gpui/src/app/test_app.rs`, `crates/gpui/src/app/test_context.rs`,
`crates/gpui/src/profiler.rs`, `crates/gpui_web/src/platform.rs`,
`crates/gpui_web/src/display.rs`, `crates/gpui/src/app.rs`,
`crates/gpui/src/global.rs`, and `crates/gpui_platform/Cargo.toml`.
The existing [Luna 03 element review](luna-03-elements-review.md) supplies
additional source-backed rendering findings; it was reread, not treated as a
replacement for this checkout.

## Corrections made in this pass

- The first-window and counter walkthroughs now explain the ownership chain:
  `AppContext::new` creates the entity, the window retains the root, `Render`
  returns a frame's element tree, and `notify` schedules affected rendering.
  They distinguish a stable interaction ID from the short-lived element value.
- The subscriptions walkthrough separates model notification, observer
  delivery, and the view's own invalidation. It now says the displayed count
  measures callback deliveries because notifications can coalesce, and links
  that choice to typed events when each operation needs its own payload.
- The input walkthrough defines the two focus boundaries in a browser, then
  connects a handle, `track_focus`, key context, key binding, typed action, and
  action listener as distinct steps.
- The animation walkthrough explains the animation key as retained identity,
  separates width/layout from opacity/appearance, and describes reduced motion
  as skipping intermediate progress for this one-shot motion.
- The async walkthrough distinguishes dropping a task from rolling back an
  external side effect. It explains why a weak entity is reacquired after an
  await and why a generation check and cancellation solve different problems.
- The custom-element and drawing walkthroughs distinguish frame-local phase
  state from retained state, layout bounds from clipping, and drawing from
  hit-testing/accessibility. A requested size is described as a layout input.
- The list walkthroughs define the half-open requested range and the uniform
  height invariant, explain list IDs versus row IDs, and give concrete state
  update choices for `reset`/`splice`, `remeasure`/`remeasure_items`, and
  `measure_all`.
- Text walkthroughs define byte offsets, Unicode scalar values, grapheme
  boundaries, shaped glyphs, and when `TextLayout` position data is available.
  They state that hit testing is not an editor caret policy.
- `docs/documentation-authoring.md`, `site/content/about/writing.md`,
  `site/content/examples/_index.md`, `site/content/reference/versions.md`, and
  `site/content/guides/live-editing.md` no longer describe the native Miri
  companion as browser-portable. The walkthrough index identifies compiled
  previews and editable Miri sessions as separate paths. The live-editing page
  says browser editing must wait for an entirely-WASM Miri runtime to be
  implemented and verified.
- The remaining authored task pages now give a decision path and concrete
  boundary: `assets.md` distinguishes exact asset keys, synchronous registry
  loaders, async image resources, cache ownership, SVG, and platform surfaces;
  `drawing.md` walks from prepaint bounds to paint, clipping, and path errors;
  `performance.md` separates task/input/draw/presentation timing and limits
  interpretation to the profiler's scheduler clock; `platforms.md` explains
  the core/platform division, web one-window model, and that compiled Wasm
  previews do not prove a portable Miri runtime.
- `setup.md` now ties native prerequisites to the actual downloaded features
  and categorizes common build failures. `start-a-project.md` explains why the
  download needs its helper, same-checkout path dependencies, and when to move
  state into a separate entity. `state.md` distinguishes strong/weak handles,
  exclusive entity leases, invalidation, subscriptions, and globals.
- `testing.md` now describes test-window input simulation, fake HTTP/text
  limits, custom text/asset setup, and virtual-clock limits. `text.md` defines
  storage, grapheme, shaping, and native offset units and explains why hit-test
  output is not a caret policy. `windows.md` distinguishes root ownership,
  typed handles, async reacquisition, frame-local versus retained state, and
  frame callbacks that wake the source without invalidating the view.
- The reference landing pages now route readers by the concept they need and
  connect ownership, dispatch, rendering, and scheduling to the corresponding
  walkthroughs.

The linked API names used in new Rust-comment prose were checked against the
API catalog in `site/examples.toml`; new conceptual terms without catalog
entries remain code-formatted rather than becoming invalid generated links.

## Pinned consumer usages checked

The consumer checkouts were verified at these exact commits:

- Zed: `target/zed-documentation-reference`,
  `da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f`.
- Hummingbird: `target/hummingbird-documentation-reference`,
  `2e1ee5f1c8d415ef7f835801fe368ab4106035b5`.

Concrete call sites inspected at those pins:

- Zed `crates/gpui/examples/uniform_list.rs` uses a range callback to create
  interactive, fixed-height rows with per-row IDs. This confirms the simple
  virtualization pattern, but is a framework example rather than an app
  consumer.
- Zed `crates/editor/src/code_context_menus.rs` around line 966 builds a
  completion list from the requested range; its scroll handle is attached
  later in the element chain around line 1211. It shows virtualization in a
  real editor interaction.
- Zed `crates/ui/src/components/choice_card.rs` implements a prop-driven
  `RenderOnce` component with internal canvas paint and explicit focus,
  selection, and accessibility behavior. Zed `crates/workspace/src/welcome.rs`
  around lines 40–100 shows small `RenderOnce` components composing labels,
  divs, and buttons from owned props.
- Hummingbird `src/ui/library/files_view.rs` around line 532 maps only the
  requested file-row range to fixed-height rows and attaches a
  `UniformListScrollHandle`.
- Hummingbird `src/ui/components/window_chrome.rs` around line 51 uses canvas
  prepaint to register a hitbox, then paint to inspect the pointer and set a
  resize cursor. This demonstrates that custom paint can participate in input
  only when the code explicitly registers the hitbox.
- Hummingbird `src/ui/components/table.rs` around line 747 and `src/ui/queue.rs`
  around line 1137 also use uniform rows. `src/ui/components/palette/finder.rs`
  owns a `ListState` for variable-height content.

The prior Luna 03 references are valid at the pinned commit. They were absent
from my sparse working-tree view, not from the commit. `git ls-tree HEAD` and
`git show HEAD:<path>` confirm both paths and their usage: Zed
`crates/component/src/component_layout.rs` defines prop-driven
`ComponentExample`/`ComponentExampleGroup` as `RenderOnce`; Zed
`crates/agent_ui/src/agent_registry_ui.rs` around lines 677–685 renders
registry rows through `uniform_list`, a stable list ID, and a tracked scroll
handle. The additional usages above remain useful. Consumer code is comparative
evidence only; this local GPUI checkout remains the behavioral source of truth.

## Remaining checks for root

- Audit every deep link against the generated local docs for this checkout and
  docs.rs for 0.2.2. Rustdoc paths can be exact while the versioned page still
  describes a published release rather than the development source.
- Check source links after regeneration. The generated example pages were not
  edited here, and this pass did not run the generator, tests, or a site build.
- The text guide's source links point at an older pinned GitHub revision; decide
  whether those are intentionally historical examples or should move to a
  current, verified source target.
- Revisit all claims about the editable workbench when the WebAssembly
  compiler/Miri Worker is ready. Verify where compilation and interpretation
  happen, which inputs and platform services are available, and what happens on
  compile failure before documenting the runtime as portable.
