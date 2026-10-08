# Manual documentation review

This records the primary editor's source review. The twelve Luna reports are
first-pass material, not evidence that this review is complete. Prose is edited
by hand. Generation adapts links and publishes canonical sources; it does not
write API explanations.

The complete public-surface review remains in progress. A clean rustdoc build
establishes that links and examples compile, not that a contract is accurate or
that its explanation is sufficient.

| Surface | Primary-editor review | Work still needed |
| --- | --- | --- |
| Application, App, entity contexts, async contexts, entities, actions | Public contracts read with their relevant implementations; rewritten | Final reading in the generated API and cross-check with the finished walkthroughs |
| Element lifecycle and views | Public contracts and complete cached-view implementation read; rendering lifecycle rewritten | Review rendered examples and invalidation guidance together |
| Div and interactive elements | Public methods, complete inline-paragraph implementation, input dispatch, private tooltip path, and complete input-event module read; propagation, drag/drop, focus, accessibility, scrolling, image loading, inline flow, and window-activation flag contracts corrected | Review all rendered method examples together |
| Lists, uniform lists, anchored/deferred/canvas/container-query elements | Public contracts and complete variable-list module, including tests, read; anchored local coordinates and offsets corrected; list callback range, measurement invalidation, and tail-following guidance corrected | Final contextual reading |
| Assets and image caches | Public contracts and implementations read | Browser and native walkthrough checks with missing and decoded assets |
| Window and prompts | Public method inventory, complete constructor, focus queries, hit testing, cursor selection, frame completion, deferred/cached drawing paths, and complete prompt module read; native prompt implementations, Wayland, and browser geometry checked; prompt response ownership, replacement, focus restoration, and keyboard behavior corrected | Remaining platform-specific paths and a final complete reading |
| TestApp, TestAppContext, HeadlessAppContext, VisualTestAppContext | All public methods and context implementations read; complete TestWindow and VisualTestPlatform implementations read; timing, effect, input, capture, and delegated native-service claims corrected | Native visual tests and scheduler internals beyond the paths already checked |
| BenchAppContext, BenchWindowContext, BenchReport | All public methods and context implementations read; strict feature-specific docs and seven report-budget regression tests pass | Final contextual reading |
| Accessibility subtree builder | Public contracts, construction path, private tree helpers, and regressions read | Native assistive-technology checks |
| Text and fonts | Text, StyledText, InteractiveText, text-system, complete line/layout cache, font features, fallbacks, and width public contracts read; caret normalization traced through source/paragraph adapters to Parley 0.11.1's cursor and cluster lookup; complete composed-input example reviewed and repaired, including UTF-16 composition, shared-buffer observation, painted geometry, and accessible field names | Final reading in rustdoc and walkthrough; remaining backend paths |
| Styling, transitions, motion, geometry, painting, scenes, paths | Styled, Style, generated style methods, all geometry implementations, PathBuilder, complete Spring, Lerp, Motion, and style-transition modules read; Scene, capture, render-plan, embed, atlas, and shader-record production implementations and complete capture/embed test modules read; capture/import ownership and transform composition explained | Remaining scene tests and final contextual reading |
| Touch and scroll gestures | All public APIs and complete portable recognition, momentum, and velocity-estimation implementations read; synthesized-tap, absent portable pinch, claim routing, and axis-unlock contracts corrected | Remaining recognizer tests and final contextual reading |
| Keymaps, focus/tab stops, executors | Keymap public contracts, binding and collection implementations, context parser, complete tab-stop module, complete GPUI executor module, scheduler executor, scheduler entry, clock, test scheduler, scheduler tests, and TestDispatcher modules read; cancellation, logging-executor, browser fallback, explicit-handle tab configuration, and parser failure cases corrected; ThreadedDispatcher implementation and tests read, ready-queue and shutdown claims corrected | Remaining key-context tests and final contextual reading |
| Platform traits and adapters, profiling | Platform and PlatformWindow public contracts, complete simulated text system, capture adapters, and diagnostics read; PlatformTextSystem checked against Parley/DirectWrite; input, clipboard, window options, keyboard mapping, keystrokes, menus, popups, and layer-shell reviewed; profiler/action timing, journal production implementation, complete hang module, and priority queue read | Remaining journal tests and platform implementation paths; final contextual reading |
| Inspector, colors, prelude, and small public helpers | Complete inspector, FluentBuilder/FutureExt, Global, SharedUri, Subscription, Colors, and prelude implementations read; palette installation and observation traced through App and Context | Final contextual reading |
| Re-exported string and refinement types | Complete SharedString, ArcCow, Refineable, Cascade, and refinement-derive implementations read; storage, conversion, merge order, defaults, and derive dependency explained | Final contextual reading in the GPUI reference |
| SVG rasterization and intrinsic layout | Complete SVG module, including tests, and all public contracts read against usvg parsing and image resolvers; font registry, skipped content, size preservation, and stretching corrected; AvailableSpace variants and conversions read and explained | Final contextual reading |
| Shared conceptual chapters | Ownership, rendering, layout, animation, text, drawing, input, scheduling, accessibility, testing, and platforms mirrored into mdBook; strict API/site/book audit passes; search paste, clipboard contents, and keyboard contents toggle checked | Final contextual edit and final combined-artifact checks, including responsive layout and theme contrast |
| Walkthroughs and authoring DSL | Primary editor read all twelve canonical programs; eleven corrected for accessible text, button roles/names, tab stops, focus rings, and accurate claims; all twelve pass native `cargo check --examples` | Rebuild final browser programs and exercise every walkthrough in the final site |

## Testing evidence

On 2026-10-08, the core library run with `test-support` passed 411 tests. It
includes regressions for drag payload type checks, independent unkeyed
transitions, flipped uniform-list scroll targets, and child-prepaint callbacks
combined with tracked scrolling. Seven benchmark-context tests subsequently
passed with `test-support,bench-support`, including zero frame-budget rejection.
A complete run with both features passed 490 tests, including malformed key
contexts, invalid/non-advancing path dashes, and nonduplicated environment seeds.
It also exposed a benchmark fixture that assumed no other test could draw a
frame. Its assertion now uses that test's foreground journal rather than the
process-wide frame collector. The anchored-overlay and reversed-IME selection
regressions pass in that run too.
Color compositing now places an overlay over its base, with regressions for
transparent, opaque, and partially transparent colors and transparent text
highlights.
The run also includes three timing-ranking regressions and two queue regressions
for receiver wakeup on the last sender's drop and fused iteration after an empty
queue. The four queue tests passed again after the wakeup test's synchronization
was tightened.

The composed-input example passed all twelve tests, including candidate
replacement and commitment, selection direction, surrogate clamping,
external-buffer repair, and stale geometry. Its multiline geometry fixture
uses Parley with an explicitly bundled font: the simulated text system keeps
all source text on one row and cannot establish that contract. The same
fixture checks pointer placement and reversed Shift-selection against the
painted layout.

The doctest run with `test-support,bench-support` passed 160 examples (154 in
the merged run and six test-harness examples), with two ignored. The latest
additions exercise anchored/deferred notice construction, retaining a root
entity after its window closes, operation errors inside fallible tasks,
shared text-paint placement, caret-coordinate conversion, type-erased view
collections, variable-list data updates, and a paragraph with inline spans and
an embedded badge.
The testing chapter's notification, timer, cancellation, stale-result, and input examples were
executed. Macro-based examples use `rust,test_harness`, so their assertions run
rather than merely compiling an uncalled test function. The corrected platform
example passed, as did the later layout, drawing, input, geometry, and clipboard
examples.
The animation samples, transform composition, keystroke round-trip,
retained-identity example, and painted-swatch assertion also pass. A separate
run of the string and refinement packages passed three doctests and an empty
named-struct derive regression. The derive previously generated an invalid
`IsEmpty` implementation for that case.

Four prompt regressions pass. They cover accessible answer names, Tab and
Shift-Tab wrapping, Enter/Space activation, default and cancellation roles,
empty answer lists, redraw requests, and late responses from replaced views.
The replacement test retains both views so the older response channel stays
alive; its response must leave the current prompt and focus untouched. The
current response restores the original pre-prompt focus. The close-confirmation
example, PromptButton example, and ElementId example pass as doctests.
A subsequent complete library run passed 494 tests, including those four prompt
regressions. The deferred-overlay review then found that an explicit mask
clipped paint but not hitboxes. Deferred prepaint now applies the same mask.
Both deferred tests pass, including a new regression that sends presses inside
and outside the visible region across two cached redraws.
A complete library run then passed 495 tests. The later executor review found
that a panic during scoped-job registration waited for channel senders held
inside its own unsubmitted futures. Scope cleanup now drops those futures
before waiting. A bounded regression confirms that registration unwinds and
destroys the job without running it.
The complete library run with that fix passed 496 tests. The documentation
generator, book, link-adaptation, and HTML postprocessor tests passed all 24
checks.
The variable-list review then found that scroll callbacks computed their
reported range from the preceding viewport. The callback now uses the resulting
position and bounds its range by the item count. Its regression passes for
both list alignments, including the bottom anchor. The complete library run
with that change passed 497 tests. All seven site audit and development-server
tests pass with the browser-only server default.

The preview-width controls were exercised on the counter and drawing pages.
After incrementing the counter to one, resizing its existing iframe to 120 px
retained that count. Opening the editor hides the width controls and expands
the panel; restoring the preview reapplies the selected width. Space, Arrow Up,
and Enter changed the native select from 120 to 240 px. The drawing preview at
120 px shows the blue quad clipped at the edge while the red quad keeps its
60-pixel width. Counter evidence is saved at
`target/documentation-proof/counter-preview-width.png`.

The strict API, Zola, and mdBook build includes both features. A separate strict
`cargo doc --no-deps` run also passed with the crate's default features, after
conditional testing links were corrected. Book search was
checked with a pasted query; copying was checked against actual clipboard text,
including keyboard activation. The contents toggle was changed from an
unfocusable label to a native button and checked with Enter and Space. A 390px
viewport check found no document-wide horizontal overflow in the text chapter.
Search for `stale result` also reaches the cancellation section's exact anchor.

The portable compiler/Miri bundle is still being built in the runtime checkout.
A successful native companion preview does not establish browser-only execution.

## Consumer-source evidence

Zed was inspected at `da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f` and Hummingbird
at `2e1ee5f1c8d415ef7f835801fe368ab4106035b5`. The testing pass read Zed's
collaboration update-button timer test and context-menu action tests, and
Hummingbird's complete async-resource test module with its implementation.
These show useful fixture and assertion patterns. Their APIs come from their
own GPUI versions; the code in this checkout decides the documented contract.

## Reference reading

The reference inventory distinguishes reading from fetching. All linked URLs
in the supplied ecosystem review were fetched in the initial survey; that is
not a claim that every linked example has been read. The detailed primary-source
example reading and the final editorial pass remain open. The primary editor
has also read every top-level cookbook example in Jiff 0.2.35's `lib.rs`; this
does not mean every example in Jiff's individual API pages has been read.
Jiff's complete `DESIGN.md` and public `Span` examples through its duration
conversions, `SpanFieldwise`, `ToSpan`, arithmetic, comparison, total, and
rounding options (through line 5240) have also been read; some intervening private
helper implementations were skipped. The subsequent framework pass read egui 0.36.2's complete
top-level prose and examples, the Iced Book's architecture chapter body, and
Ratatui's snapshot-testing recipe body. These readings sharpen the distinction
between a framework's state model, rendering boundary, and test boundary; they
do not close the remaining reference-example review.

## Writing-detector check

On 2026-10-08, Scribbr's detector (model v7.1.0) scanned the complete canonical
`crates/gpui/docs/text.md`, including Markdown, code fences, and its API table.
It reported 36% AI-generated, 0% human-written and AI-refined, and 64%
human-written. This is the obtained result, not a passing score or a measure of
technical accuracy. Its strongest highlighted passage combines Rust code and
the API table. Source SHA-256:
`94c4459a4c6db840c600e8e087d24171e953f216a31f37c3abbe48e8668da7a7`.
The screenshot is saved at `target/documentation-proof/scribbr-text-chapter.png`.
The revised chapter was checked again with the same detector and model. It
reported 35% AI-generated, 0% human-written and AI-refined, and 65%
human-written, at source SHA-256
`04f3a46ac6408f00c5e0954afe2d6523479545039b911d288d1cee1444b9b403`.
Its strongest flag again includes the Rust sample and API table. Evidence:
`target/documentation-proof/scribbr-text-chapter-revised.png`. This remains an
unsatisfactory checker result; neither scan establishes authorship or accuracy.
Pangram reached a human-verification challenge; after the user's approval,
browser control could not operate that challenge, so Scribbr was used as the
requested fallback. No account, payment, or paraphrasing service was used.
