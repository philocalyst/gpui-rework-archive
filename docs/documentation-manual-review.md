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
| Assets and image caches | Public contracts and complete registry, image-cache, and image-loader implementations read; source selection, errors, notification ownership, BGRA storage, and explicit retries expanded with asserting examples | Browser and native walkthrough checks with missing and decoded assets |
| Window and prompts | Public method inventory, complete constructor, focus queries, hit testing, cursor selection, frame completion, deferred/cached drawing paths, and complete prompt module read; native prompt implementations, Wayland, and browser geometry checked; prompt response ownership, replacement, focus restoration, and keyboard behavior corrected | Remaining platform-specific paths and a final complete reading |
| TestApp, TestAppContext, HeadlessAppContext, VisualTestAppContext | All public methods and context implementations read; complete TestWindow and VisualTestPlatform implementations read; timing, effect, input, capture, and delegated native-service claims corrected | Native visual tests and scheduler internals beyond the paths already checked |
| BenchAppContext, BenchWindowContext, BenchReport | All public methods and context implementations read; strict feature-specific docs and seven report-budget regression tests pass | Final contextual reading |
| Accessibility subtree builder | Public contracts, construction path, private tree helpers, and regressions read | Native assistive-technology checks |
| Text and fonts | Text, StyledText, InteractiveText, text-system, complete line/layout cache, font features, fallbacks, and width public contracts read; caret normalization traced through source/paragraph adapters to Parley 0.11.1's cursor and cluster lookup; complete composed-input example reviewed and repaired, including UTF-16 composition, shared-buffer observation, painted geometry, and accessible field names | Final reading in rustdoc and walkthrough; remaining backend paths |
| Companion editable fields | All public storage and history contracts, production implementations, field state methods, action mappings, caret scheduling, and module examples read; ownership, UTF conversion, logical/visual movement, command defaults, and patch inversion corrected; grouped history regressions reproduced and fixed | Remaining rendered action/state/storage examples and native interaction checks |
| Styling, transitions, motion, geometry, painting, scenes, paths | Styled, Style, generated style methods, all geometry implementations, PathBuilder, complete Spring, Lerp, Motion, and style-transition modules read; Scene, capture, render-plan, embed, atlas, and shader-record production implementations and complete capture/embed test modules read; capture/import ownership and transform composition explained | Remaining scene tests and final contextual reading |
| Touch and scroll gestures | All public APIs and complete portable recognition, momentum, and velocity-estimation implementations read; synthesized-tap, absent portable pinch, claim routing, and axis-unlock contracts corrected | Remaining recognizer tests and final contextual reading |
| Keymaps, focus/tab stops, executors | Keymap public contracts, binding and collection implementations, complete context parser and its tests, complete tab-stop module, complete GPUI executor module, scheduler executor, scheduler entry, clock, test scheduler, scheduler tests, and TestDispatcher modules read; cancellation, logging-executor, browser fallback, explicit-handle tab configuration, and parser failure cases corrected; ThreadedDispatcher implementation and tests read, ready-queue and shutdown claims corrected; local inequality and path-wide negation distinguished with assertions | Final contextual reading |
| Platform traits and adapters, profiling | Platform and PlatformWindow public contracts, complete simulated text system, capture adapters, and diagnostics read; PlatformTextSystem checked against Parley/DirectWrite; input, clipboard, window options, keyboard mapping, keystrokes, menus, popups, and layer-shell reviewed; profiler/action timing, complete journal module including tests, complete hang module, and priority queue read | Remaining platform implementation paths; final contextual reading |
| Inspector, colors, prelude, and small public helpers | Complete inspector, FluentBuilder/FutureExt, Global, SharedUri, Subscription, Colors, and prelude implementations read; palette installation and observation traced through App and Context | Final contextual reading |
| Re-exported string and refinement types | Complete SharedString, ArcCow, Refineable, Cascade, and refinement-derive implementations read; storage, conversion, merge order, defaults, and derive dependency explained | Final contextual reading in the GPUI reference |
| SVG rasterization and intrinsic layout | Complete SVG element and renderer modules, including tests, read against usvg parsing and image resolvers; source precedence, synchronous work, alpha tinting, width-based scaling, font registry, skipped content, and transformations corrected; AvailableSpace variants and conversions read and explained | Final contextual reading |
| Shared conceptual chapters | Ownership, rendering, layout, lists, animation, text, drawing, assets, input, scheduling, accessibility, testing, and platforms mirrored into mdBook; search paste, clipboard contents, keyboard contents toggle, and actual automatic reload checked | Final contextual edit and combined-artifact checks, including responsive layout and theme contrast |
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
tests pass with the browser-only server default. Two subsequent bundle tests
bring that suite to nine passing tests; they reject a stale canonical starter,
a missing Worker, and an asset path outside its bundle.

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

The isolated browser-runtime checkpoint `63cf69c558` was imported locally as
`0438e88a9a`. Its supplied bundle contains all twelve canonical component sources
byte-for-byte. The site now enables `browser-miri`, loads its bootstrap only for
the editor, and ships the full compiler, interpreter, and metadata. The first
combined build with those assets passed the strict API, book, and site audit.
Independent browser editing checks are in progress. The supplied metadata still
predates this branch's four core behavior fixes; an isolated export,
`8bd47fe45e`, has been sent to the runtime owner for the next dependency build.
Current runtime performance and cancellation limitations remain open.

The next complete library runs passed 500 and then 502 tests. The latest adds
two independently reproduced regressions: `ApplicationHandle::update` allowed
nested entity creation to flush effects before the outer closure returned,
and a removed tab group let a later group reuse another live group's ID. Both
fixtures failed before their fixes and pass in the 502-test run. The changes
were exported separately as `1fe6574e2b`, without the documentation rewrite.
Browser-session checks also passed all six CodePen library tests and five
session tests.

The next doctest runs passed 161, 164, and 169 examples. The latest includes
the worked key-context test, GPU surface sizing, explicit contain/cover
geometry, teardown leak snapshots, exact registry keys and duplicate handling,
and a complete delayed-image asset implementation. The 169-example result
comprises 163 merged examples and six executed test-harness examples, with two
ignored. Subsequent SVG examples and the asset retry and decoded-pixel examples
bring the total to 174 passing examples: 168 merged and six executed
test-harness examples, with two ignored. Strict default-feature rustdoc also
passes after those additions. Generator and book-adaptation checks now pass
all 25 tests.

The assets review found that the authored site and rendering chapter described
`Image` as decoded CPU pixels. They now distinguish encoded `Image`, decoded
BGRA `RenderImage`, asynchronous typed requests, synchronous byte registration,
provider caches, renderer uploads, and backend-owned surfaces. The new
canonical assets chapter is shared by rustdoc, mdBook, and the existing Zola
guide route. The image implementation and its cover-cropping regression were
read again: image elements crop cover fitting to their own box, whereas a
surface's fit requires a separate mask for clipping.

The assembled browser editor retained its last successful frame on a compile
error and underlined the correct editable line after a Unicode character.
The compiler's primary span pointed into the appended harness; the displayed
related span was checked against the actual source text. A stale cached editor
script initially hid that underline. Editor builds now version both the script
and stylesheet by their content hashes. Evidence:
`target/documentation-proof/browser-miri-source-diagnostic.png`.

The canonical counter initially reset on a compatible helper edit in the assembled
site. The runtime owner traced this to different `file!()` paths inside the
starter and edited `text!` identities, then verified retained state and exact
native frames after normalizing those paths. The isolated fix `1dd319015c` was
imported as `adfee6b55d`. The primary editor repeated the assembled-site check
with `miri-13f9de5c0d1c51b414e9.wasm.gz` on the static server: count zero,
click to one, change the helper increment to five, run with one retained,
then click to six. The edit reported 1351 ms and the click 734 ms. Evidence:
`target/documentation-proof/browser-miri-retained-counter.png`. This closes
that exact state-retention failure; the other walkthroughs and remaining
performance work still need review. The canonical source was restored after
the check, with the earlier local draft saved separately.

The actual development server rebuilt the checked artifact after a save
during its first build, then automatically reloaded the open book after a
later source edit. A regression covers the initially missed-save race. All ten
site script tests pass. Generation and backlink synchronization now preserve
unchanged file timestamps, as does the canonical-guide mirror; the generated
guide body no longer retriggers its own watcher. The real three-build smoke
check is recorded in `target/documentation-live-reload-smoke.log`.

The next doctest run passed 177 examples: 170 merged examples and seven
executed test-harness examples, with two ignored. The latest additions cover
image-source conversions, local versus path-wide key-context exclusions, and
two ordered event payloads from one update. The testing dependency example now
uses the checkout rather than implying that its declared version identifies
the already-published source. The key-context implementation and every test in
its module were read in full. Strict default-feature rustdoc passed after the
accessibility callback documentation was expanded; the later key-context
changes still need that separate default-feature check.

The accessibility review read the macOS, Windows, X11, and Wayland adapter
hooks against AccessKit 0.24.1's activation, action, and deactivation contracts.
The public callback docs now distinguish adapter-thread delivery, activation
from frame updates, Unix deactivation, and platform-owned bounds. The browser
backend has no AccessKit adapter or semantic HTML tree for painted controls;
the accessibility and platform chapters state that limitation explicitly.
One implementation concern remains: GPUI's native activation callback returns
a minimal initial root before a later full frame, whereas AccessKit advises
returning `None` for an asynchronous full update instead of a placeholder.
No unverified native adapter change was made during this prose pass.

Further assembled-site checks on the `13f9` runtime verified async completion,
then rapid Start/Stop cancellation with Stopped still visible 23 seconds after
the gesture. The model-observation walkthrough changed both Count and
Notifications received from zero to one. A fragment-only editor route change
previously kept the old source and program; reloading on `hashchange` fixed the
async-to-subscriptions switch. Evidence:
`target/documentation-proof/browser-miri-cancelled-task.png` and
`target/documentation-proof/browser-miri-subscriptions.png`.

The same browser review found a keyboard discrepancy: Space
increments the canonical compiled actions preview, but not its interpreted
workbench counterpart on `13f9`, despite the iframe and its input being focused.
The runtime owner has the reproduction. The newly supplied
`miri-eb03a9c48281fb4e4498.wasm.gz` bundle includes the two app lifecycle fixes
and reproduces that discrepancy in the assembled site. Its demand-paged
compiler experiment is not enabled here.

The runtime owner traced the defect to host listener placement: the preview's
focus handle belonged to the parent div, while the key listeners belonged to
its canvas child, outside the focused path. Isolated fix `f2fc94b866` was
imported as `53fdfe7d71`. The primary editor reviewed it, passed its focused
host regression (including the other-focus negative control), rebuilt the
assembled site, and repeated the same Space gesture. The interpreted actions
preview now changes Count from zero to one. Evidence:
`target/documentation-proof/actions-interpreted-space-success.png`.
The original compiled success and interpreted failure are preserved beside it.

The assets book chapter fits a 390-pixel viewport. Its source-selection table
uses a named, focusable scrolling region; Arrow Right scrolls the table without
turning the chapter. Evidence: `target/documentation-proof/assets-book-narrow.png`.
The editor's native-source exporter now combines the edited component with
the canonical launcher. All twelve resulting native programs passed offline
`cargo check`; five editor JavaScript tests pass. The primary editor then
downloaded the counter after changing its helper to `saturating_add(5)` through
the browser's actual Download button. That file contains the edited helper and
native launcher and passes offline `cargo check` in the matching Cargo project.
Two browser activations display ten. Evidence:
`target/documentation-proof/browser-downloaded-counter-edit.png` and
`target/documentation-downloaded-counter-check.log`.
The live-editing guide was rewritten to describe the actual
browser compiler/interpreter workflow and native export, replacing stale
native-companion availability claims.

The corrected drawing exercise was executed in the editor: a 100-by-100 canvas
shows twenty pixels of its sixty-pixel blue quad under the explicit mask;
removing that mask exposes the full quad beyond the canvas. Both frames are
saved as `drawing-100px-mask.png` and `drawing-100px-no-mask.png` in the proof
directory. The canonical source was restored after the comparison.

The next manual context pass read every rendered inherent `Context` method,
then corrected construction wording and notification coalescing. Source review
also established the different window choices in `observe_in`, `subscribe_in`,
`defer_in`, and `observe_global_in`; the ownership chapter now explains how to
choose an explicit window. Restart callbacks borrow synchronously, and the
docs now show when to defer the request. Shutdown guidance follows its actual
order: callbacks run before windows are removed, returned futures afterward.
New examples cover that snapshot, explicit async-window updates, and typed
event payloads. The doctest run passes 180 examples (173 merged and seven
test-harness examples), with two ignored.

The keyboard review read raw dispatch, modifiers, replay, and element
registration together. Capture of raw keys follows binding resolution; key-up
delivery follows current focus. The public interactive-element handlers and
window-level registration docs now describe those boundaries and the focused
ancestor path. The context-site build passes strict feature-enabled rustdoc,
Zola, mdBook, and the combined audit with the rebuilt host. Strict default-feature
rustdoc also passed before the latest small wording and window-key updates;
the next combined artifact will include those final updates.

## Consumer-source evidence

The canonical text-hit-testing walkthrough failed on its initial frame in
both the compiled browser preview and Miri. A block div had gathered its
text into a paragraph, leaving the separately queried `TextLayout` handle
unmeasured. The initial native regression reproduced the panic at
`TextLayout::measured`. The example now uses a flex column for independently
measured text. All twelve canonical programs pass the new initial-and-rebuilt
frame tests, which include their actual Rust source; CI runs the same suite.
The browser edit also accepts a click on the combining accent and places its
marker at byte 3. Evidence: `target/documentation-canonical-frames.log`,
`target/documentation-hit-testing-before.log`, and
`target/documentation-proof/text-hit-testing-combining-accent.png`.
The `StyledText::layout`, `TextLayout`, and shared text chapter explain the
independent-layout requirement. The corrected browser starter still needs
to be synchronized with the runtime owner's next stable bundle before the
assembled site is rebuilt.

The walkthrough's marker code now lives beside its marker explanation in a
small helper, rather than inside the unrelated render setup. The latest actual
canonical sources still pass all twelve frame tests. The text guide at the
Zola route now mirrors the canonical chapter too; its earlier claim that all
layout indices addressed the original string was wrong after display-text
rewriting. The chapter distinguishes the measured string from the editing buffer.

The shortcut review reproduced a separate implementation error: the two
current-focus lookup methods used the dispatch tree's temporary paint context
stack, returning the last painted field's binding instead of the focused
field's binding. Both now obtain the current focus path. The regression checks
two rendered targets, changes focus without another draw, queries a candidate
target without moving focus, and checks blur. The complete core library run
passes 503 tests with both test and benchmark support. Evidence:
`target/documentation-shortcut-before.log` and
`target/documentation-shortcut-library-tests.log`. Isolated prerequisite commit
`06c845b63b55bb596ece52bff053e7be7a8850b3` contains only the implementation
corrections and regression; the browser runtime owner has applied it to the
next SDK fixture. The matching final browser bundle is still pending.

The companion field review found a detached subscription created in a render
helper, which would add listeners each time the example was rebuilt. The new
module example creates state and a retained subscription once in the owning
view's constructor. A separate example shows keyed state and explains its
unmounting lifetime. Constructor docs now agree with the actual removal of
CR/LF from paste and IME input, distinguish that path from programmatic
replacement, and describe Up/Down and Shift-Up/Down behavior. The module also
corrects its obsolete claim that no accessibility text is emitted and its
claim that custom storage avoids whole-value snapshots.

Strict rustdoc passes for the core and companion crates with missing-doc,
broken-link, private-link, and bare-URL errors denied. The combined doctest run
passes 180 core examples and seven companion examples, with two core examples
ignored. Evidence: `target/documentation-text-ownership-rustdoc.log` and
`target/documentation-text-ownership-doctests.log`. CI now includes the
companion doctests and strict reference checks. The primary editor read all
rendered inherent `Window` methods in the cargo-doc instance on port 1114,
as well as the revised editable-field module and element methods. Trait
implementations and backend-specific paths remain separate review work.

The storage pass corrected forward rounding inside UTF-8 characters and UTF-16
surrogate pairs, the inclusive end used by word selection, and the absence of
visual wrapping in storage-only navigation. Two asserting conversion/word
examples passed. The history pass then reproduced lost replacement text during
grouping, lost text during repeated forward deletion, redo entries surviving
a grouped new edit, wrong selection restoration on redo, and missing
`TextChanged` events during undo/redo. All five regressions failed before their
fixes. The complete companion library now passes 127 tests; its eleven doctests
pass, including a byte-accurate undo/inversion example. History types are
re-exported so callers can actually name `HistoryKind` when querying the
public `history()` result. Evidence: `target/documentation-history-before.log`,
`target/documentation-redo-selection-before.log`,
`target/documentation-history-events-before.log`,
`target/documentation-field-history-tests.log`, and
`target/documentation-field-history-doctests.log`.

Strict default-feature cargo docs for both core and companion passed after
the history rewrite (`target/documentation-field-default-rustdoc.log`).
The primary editor also read the resulting `EditableTextHistory` and
`HistoryEntry` pages, including every field and inherent method. The subsequent
action and caret prose adjustments still require the next combined build.

The action/caret pass now passes strict feature-enabled rustdoc and twelve
companion doctests (`target/documentation-field-final-rustdoc.log` and
`target/documentation-field-final-doctests.log`). The primary editor read every
rendered inherent `EditableTextState` method too. That browser review found
imported focus, styling, conversion, and view links rendered as literal bracketed
references despite successful strict checks. Explicit public paths replace
those references; the next build must confirm the rendered links themselves.

Runtime export `edba695b71` was imported locally as `0b65a518c5`, preserving the
documentation branch's production renderer fixes and adopting the expanded
focus regression. The full paged bundle has eighteen exact starters, including
all twelve canonical walkthroughs, and module `06509386dfbe3ef708a6`.
The runtime owner reports complete native-frame parity and compiler recovery;
the primary editor's own browser pass on the assembled bundle remains open.
Locally, all seven CodePen library tests pass, as do the transport/prewarm,
immutable metadata, and paged-packaging test suites. The first combined site
build passes strict rustdoc, Zola, mdBook, and the HTML audit at
`target/documentation-paged-review`; a subsequent link edit requires a fresh
build before publication. Packaging now checks every cold metadata chunk as
well as the bootstrap, and its regression preserves the previous runtime when
a chunk is missing. No changes have been pushed.

The second assembled build at `018b6124fc` was promoted to the local server on
port 1111. Its source digest is
`8a7eb5ca860c3020563ca9264cf61bfeebc23d1086b2deebf4bb1188e7d1e01f`.
The primary editor independently repeated the counter sequence on this bundle:
zero to one, edit the helper to add five while retaining one, then click to six.
A syntax error kept six visible and paused input; fixing the program retained
six, and the next click reached eleven. Restoring the canonical increment kept
eleven. At a 390-pixel viewport the panels stacked without document-wide
horizontal overflow, and another click reached twelve. The emulated viewport
was restored afterward. The narrow screenshot has a repeated header below the
host's original 720-pixel capture boundary that is absent from the DOM; its
capture/rendering origin remains unconfirmed. The geometry and pointer checks
passed, but that image is not evidence of flawless responsive painting.
Evidence: `counter-paged-recovery.png` and `counter-paged-mobile.png` in the
proof directory. The compiled text-hit-testing page also now renders its first
frame in this artifact; its synchronized source uses the independent flex layout.

The rendered-link review found the cause of unresolved companion references:
the core crate had no `html_root_url`. It now supplies the version root, and
local publication adapts that root for both API and source links. Rustdoc's
private-module paths can be valid redirects to public re-exports; the site audit
now follows those redirects while preserving fragments. A regression checks
that case, an unresolved Rust-path URI, and a missing target anchor. External
dependency links are outside that project's link check. `TextLayoutOptions`
and `ParagraphDirection` are now visible because public shaping methods expose
them. Hidden view-implementation references were replaced with public entry
points, and the SVG, AccessKit, and small-string dependency targets were checked
against their published versions.

The primary editor read every `Style` field again with its defaults, Taffy
adapter, scroll listener, box painter, opacity scope, and mask implementation.
The rewrite distinguishes authored text refinements from inherited typography,
preferred sizes from minima, box wrapping from word wrapping, child alignment
from parent alignment, and grid-track definitions from item placement. It also
corrects the nonexistent `Overflow::Auto` reference, the flex cross-axis reversal
claims, and the description of a `Fill::Color` as necessarily solid. Typography,
highlight merging, decoration color fallback, and finite rectangular masks now
describe the actual implementations. The cross-axis check includes Taffy
0.12.2's alignment calculation and GPUI's left-to-right box-layout adapter.

Parley's shaping implementation was read again against the text options. Its
line clamp limits soft breaking, not every visual row: hard breaks can still
produce rows and the remaining soft line can overflow. An explicit alignment
width is used only without wrapping or clamping; wrapped text aligns within
its wrap width. The API and canonical text chapter now agree on those limits.
The new `TextLayoutOptions` example passes. All twelve companion doctests pass
after the editing-command review, which distinguishes byte offsets, graphemes,
visual rows, and hard lines. An ambiguous `Copy` action link initially failed
strict rustdoc and was corrected explicitly. The latest style prose still
requires the next combined strict build and rendered-page reading.

The four style doctests pass, including the new refinement and relative-line-height
examples. The line-height example initially omitted the conversion into
`DefiniteLength`; the corrected sample was executed successfully. All twelve
site tests pass with the cross-crate redirect regression. Evidence:
`target/documentation-style-doctests.log` and
`target/documentation-style-site-tests.log`.

The `b061273f95` build passed strict rustdoc, Zola, and mdBook but the expanded
audit initially rejected 63 source links. Every failure was a rustdoc
JavaScript line-range fragment, such as `#2147-2152`, whose endpoints exist as
separate HTML IDs. The audit now requires both endpoints in ascending order;
the regression rejects a missing start, missing end, and reversed range.
All thirteen site tests pass, and rechecking that assembled artifact passes
(`target/documentation-style-repaired-audit.log`). The next combined build
will include the correction and the later font prose.

The primary editor read every rendered `Style` field and inherent method,
then every rendered `TextStyle` field and inherent method on the cargo-doc
server. The next edit shortens link labels that read awkwardly in sentences
and corrects the rings' solid-color claim. The companion state overview now
renders `Focusable` and `FocusHandle` as actual versioned core links rather
than Rust-path URIs. Their adaptation to local links still needs a browser
check in the next assembled artifact.

The font pass read the complete feature, fallback, and width types again,
alongside Parley's family selection, feature parsing, face synthesis, and
variable-width regressions. It also read the complete native text-system font
and paragraph recipes. New API examples show applying tabular digits, Serde
feature values, ordered fallback names, and bare-number width parsing. All
four pass (`target/documentation-font-request-doctests.log`). The feature docs
now lead with use, put serialization in its own section, and state the Parley
`u16` value limit and panic path. `shape_text` currently wraps an infallible
backend layout in `Ok`; it does not return backend invariant failures as `Err`.
The shared text chapter and all public shaping operations now explain that
boundary. `Styled::font` also documents the actual refinement semantics of
an absent fallback list rather than implying it clears inherited preferences.
All five canonical text-chapter examples also pass, including the new total
label (`target/documentation-font-chapter-doctests.log`).

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
rounding options and `SpanRelativeTo`, including every fixed-day marker example
(through line 5745), have also been read; some intervening private
helper implementations were skipped. Jiff's `civil/date.rs` was subsequently
read through line 3395, including its overview, parsing, arithmetic, rounding,
constructors, weekday searches, week dates, zoned conversion and midnight
ambiguity, checked and saturating arithmetic, reversible differences, signed
durations, periodic series, printf-style parsing and formatting, arithmetic
conversions, difference configuration, and all date-builder examples. Private
helpers before the conversion block and tests after the builders remain outside
that reading. The subsequent framework pass read egui 0.36.2's complete
top-level prose and examples, the Iced Book's architecture chapter body, and
Ratatui's snapshot-testing recipe body. These readings sharpen the distinction
between a framework's state model, rendering boundary, and test boundary; they
do not close the remaining reference-example review.

Jiff 0.2.35's `zoned.rs` has now been read from its overview through
`nth_weekday_of_month` (line 1680), including its complete examples for
construction, time-zone conversion, civil field access, fractional seconds
before the epoch, day boundaries and overflow, month/year boundaries, missing
calendar dates, and tomorrow/yesterday disambiguation. This reading reinforces
two checks in the GPUI pass: name the reference system of a returned value,
and show what an apparently ordinary operation does at its boundary.

The subsequent `Zoned` reading covers every example through `saturating_sub`,
including forward/backward weekday searches, week-boundary inclusion,
timestamp/civil/ISO-week projections, offsets, calendar versus absolute
arithmetic, automatic disambiguation, negative durations, overflow, and
saturation. The later reading covers every `Zoned` example through line 4535:
`until` and `since`, calendar versus absolute differences, rounding and invalid
increments, periodic series across gaps and folds, skipped dates, printf-style
parsing and formatting, Debug/Display, arithmetic operators and their ownership
and panic contracts, series iteration, arithmetic conversions, and the complete
public `ZonedDifference` configuration. Its default-unit prose itself contains
stale statements, reinforcing the need to compare reference patterns with code
rather than copying their claims. `ZonedRound`'s overview examples were read;
its methods and later builders remain open.

The subsequent reading completes every public `ZonedRound` and `ZonedWith`
example through the end of the public API, plus the remaining tests through
the file's end. It covers builder override order and validation at `build`,
individual versus whole fractional-second settings, offset preference,
disambiguation, and exact counterexamples across time-zone gaps and folds.
Every public example in Jiff 0.2.35's `zoned.rs` has now been read; private
helpers skipped in earlier portions remain outside that claim. Other Jiff
types and the wider reference inventory remain open.

The Rand book's guide overview, getting-started page, error handling,
function-testing recipe, all seeding examples, and reproducibility chapter
were also read. The testing recipe mixes RNG APIs from different releases;
its fixture pattern is useful, but its code is not evidence for this checkout.
The GPUI test chapter now asks readers to retain the failing checkout and
dependency lockfile with a scheduler seed rather than implying replay across
arbitrary revisions.

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

The complete new assets chapter was scanned with Scribbr model v7.1.0 at
SHA-256 `b1725f5b5367327818377b57bc2fe4fd50931d4f19bc0089a3b224111c92115b`.
It reported 27% AI-generated, 0% human-written and AI-refined, and 73%
human-written for 1,133 displayed words. Several strong flags cover Rust
statements or code adjacent to prose. Evidence:
`target/documentation-proof/scribbr-assets-chapter.png`. This is a separate
chapter and cannot be compared to the text chapter as a before/after result.
It does not satisfy the requested checker standard.

The scheduling chapter exceeds Scribbr's 1,200-word limit. It was scanned as
two contiguous sections, split immediately before `## Capture shutdown work
before windows close`, with Markdown and code intact. Model v7.1.0 reported
19% AI-generated, 0% AI-refined, and 81% human-written for the first 904
displayed words, then 25%, 0%, and 75% for the remaining 634. These are separate
section results, not a whole-chapter score. The complete source SHA-256 is
`5dda718541d3094a8fce8d56ad65139d80c55312d96be8511a94af7a5b4ab239`.
Evidence: `scribbr-scheduling-first-sections.png` and
`scribbr-scheduling-final-sections.png` in the proof directory. Strong flags
again include complete Rust samples. A fresh Pangram attempt reached its
guest dashboard, but the approved verification checkbox could not be
operated because browser control cannot click inside its closed shadow root.
No Pangram result was obtained and no credits were used.

The same two scheduling sections were then scanned with fenced Rust examples
removed, leaving the prose, Markdown links, and API table unchanged. The first
839 displayed words returned 0% AI-generated, 0% AI-refined, and 100%
human-written; the remaining 562 returned 2%, 0%, and 98%. These are explicitly
prose-only section results. The earlier full-Markdown scores remain above.
Screenshots are `scribbr-scheduling-first-prose-only.png` and
`scribbr-scheduling-final-prose-only.png`; the exact extracted text is saved
as `scheduling-prose-only.md` in the proof directory. Neither scan replaces
source review or execution of the Rust examples.

The `Style` overview and field comments were extracted in source order, retaining
the refinement example and Rustdoc link notation but excluding declarations.
This includes the hidden bidi-authorship flag's comment. The 1,347-word input
was split before the flex-direction field to fit the checker limit. Scribbr
v7.1.0 displayed 819 words for the first section and 520 for the second; it
reported 6% AI-generated, 0% AI-refined, 94% human-written, then 2%, 0%, 98%.
The first result flags the Rust example and an adjacent field summary; the
second flags the grid-template reference. These are section results from the
extracted comments, not a score for the complete style module or documentation.
Exact input SHA-256:
`aa4c9acb6260a3c1d7672a5ca6b4ca6dd0300ec030ae7487a0d25277f7981990`.
Inputs and screenshots are `style-api-checker-input.md`, `style-api-first.md`,
`style-api-final.md`, `scribbr-style-first.png`, and `scribbr-style-final.png`
under `target/documentation-proof`.

That style scan records the comments at `b061273f95`. Later link-label and
ring-description changes have not been rescanned.

## Animation, list geometry, and the resize boundary

The solo pass reread the complete production Transition, Animated, and
animation-element paths, all three transition tests, and their retaining and
observing window hooks. Contracts now distinguish entity lifetime from wrapper
cache lifetime, goal from presentation, equal-target updates from retargeting,
and executor time from `std::time::Instant`. Clones share the animated entity
but copy the cache. Cache-borrow panics and notification ownership are explicit.
Duration playback explains identity-based replay, changes to configuration at
an existing elapsed time, sequence boundaries, and mapped-element callbacks.
Asserting bounce and sinusoidal-pulse examples and an equal-goal interruption
assertion pass. Reduced-motion documentation now states that the flag starts
false and is not populated automatically from OS or browser preferences. The
W3C `prefers-reduced-motion` section was checked and linked.

The uniform-list constructor, sizing, measurement, prepaint, item requests,
flipping, and decoration paths were reread. The walkthrough's overdraw claim
was wrong: configurable overdraw belongs to variable lists. Uniform lists
request intersecting rows and separate measurement samples. Row roots receive
available width without automatically stretching. Horizontal extent comes
from a representative row, not a scan of all rows. Decoration bounds already
include scroll offset; their range names physical slots even when rows are
reversed. Geometry describes the preceding prepaint; item requests are
deferred and do not notify.

Variable-list sizing, measurement policies, row replacement, anchoring, focus
retention, scrollbar adaptation, and viewport queries were rechecked against
implementation. `splice` does not restart a completed `measure_all` pass.
Adding uniform hints after measurement demotes measured records to hints.
Reset clears the explicit anchor while retaining alignment and follow policy;
active following can still select the end. The new canonical lists chapter
connects these decisions and appears in rustdoc, mdBook, and the Zola guide.

An API concern remains: feature-gated
`UniformListScrollHandle::logical_scroll_top_index` reads a pending target or
the base ScrollHandle's child-bound index, but uniform-list prepaint does not
populate those child bounds. Its docs now warn against using it as an actual
visible-row assertion after drawing; its behavior was not changed here.
`is_scrolled_to_end` reports physical bottom even when `scroll_to_bottom`
requests a reversed list's logical end.

The testing chapter checks initial, intermediate, and final painted animation
widths, separating clock advancement from frame delivery. A new list recipe
checks row 5,000 before and after a queued scroll and after resizing. It
initially failed: the painted row stayed 1,920 logical pixels wide after a
300-pixel resize. TestAppWindow held the app borrow while invoking a platform
callback that must reacquire it. `simulate_resize` now clones the simulated
window handle, releases the borrow, then invokes the callback. Its two-resize
viewport regression passes. The full library run passes 504 tests; the full
doctest run passes 193 examples (186 merged and seven test-harness examples),
with two ignored. Logs under `target/`: `documentation-test-window-resize.log`,
`documentation-animation-lists-all-tests.log`, and
`documentation-animation-lists-all-doctests.log`. All 25 generator, book,
link-adaptation, and postprocessor tests pass.

### Combined artifact and actual browser use

The full font-review build at `418f0782aa` passed. All 19 changed files in
isolated runtime checkpoint `6a4a4303ae1969948ebf458f28f8911d00d31147` were
reviewed before its local import as `ab20ec12d9`. All eight CodePen library
tests pass here, including native driver-path checks. Native patched-interpreter
CTFE and interruption tests were reported by the runtime thread, not executed
in this workspace. No fixed speed improvement is claimed from its variable
benchmark results.

The combined strict API, Zola, mdBook, compiled-preview, and browser-Miri build
at `ab20ec12d9` passed and was served at port 1111. Source digest:
`b0ed6f21ec145ebf5eec17e6e3412449a6aa5b4203dac3b793966c2494a22d3f`.
Interpreter: `miri-dea00e88313656025d67.wasm.gz`. Runtime-manifest SHA-256:
`9c69e9709b1922c946d8d166d4b51647df650a7223e26abda80b98fe8c1ef2d6`.
The preceding artifact remains at
`target/documentation-before-runtime-b-ab20ec12d9`.

Independent counter checks pass: click 0 to 1, change the helper to add five
while retaining 1, click to 6, introduce a syntax error while retaining 6,
verify input pauses, repair the helper while retaining 6, then click to 7.
Proof files under `target/documentation-proof/`:
`counter-runtime-b-helper.png`, `counter-runtime-b-error.png`, and
`counter-runtime-b-recovered.png`.

Actual navigation from companion editable-state docs through FocusHandle,
the postprocessed keyboard-action walkthrough link, and its source-step link
reaches the expected local pages and line. The compiled list scrolls to row
5,000, keeps it when resized to 240 pixels, then scrolls to row 5,020. The
compiled animation replays, continues through a width change, and reaches its
endpoint. Proof: `lists-scrolled-resized.png`,
`animation-replay-intermediate.png`, and `animation-resized-settled.png`.

The browser-only interpreter plays the animation too. A temporary 30-second
duration made intermediate frames observable: Replay starts with a short pale
bar, then grows and darkens it. Setting reduced motion in setup and resetting
the app presents the full 124-pixel endpoint. Replay then presents that endpoint
on the next result, before the 30-second interval elapses. Proof:
`animation-miri-progress.png`, `animation-miri-later-progress.png`, and
`animation-miri-reduced-motion.png`. This checks behavior, not smooth frame
pacing or performance equivalence. These checks preceded the latest prose
checkpoint; its combined build and rendered-page reading remain required.

### List-chapter detector checks

Scribbr v7.1.0 scanned two contiguous sections. The first full-Markdown section,
before button-accessibility additions, displayed 750 words and returned 16%
AI-generated, 0% AI-refined, 84% human-written. Its strongest flags include
the Rust sample. Input SHA-256:
`8d50f34e9185d0bf46e5535381227a1382905cfceeb1362574455108fda4ea55`.
The initial remainder displayed 614 words and returned 7%, 0%, 93%, at SHA-256
`68e76da06e1b389c542026aa3fa5bfb1e185d774084a60222752c8ae10215c10`.
After correcting reset's interaction with following and linking the actual
painted-row recipe, it displayed 632 words and returned 8%, 0%, 92%, at SHA-256
`cc61cab81a55822bca5450493eeabf01dd731d73c2f9978a5e4cc94c98d5edb1`.
The accuracy correction is retained despite the increased score.

The revised first section with its fenced Rust sample removed displayed 687
words and returned 3% AI-generated, 0% AI-refined, 97% human-written. Input:
`8973349be3abbbff85fe3fa3a393967edafcbc65c5fafcb16c1aad5ae6c9e049`.
Inputs and screenshots use `lists-` and `scribbr-lists-` prefixes in the proof
directory. These are section results, not a whole-framework score, and do not
establish accuracy or authorship. The complete final chapter has not passed
the user's requested checker standard.

### Further Jiff reading

The primary editor read Jiff 0.2.35's `civil/time.rs` from its overview through
all examples ending with `saturating_sub` (approximately line 1,071): parsing
time from larger datetimes, leap-second constraining, default and comparison,
validated construction, fractional fields before the Unix epoch, date
combination, and wrapping, checked, and saturating arithmetic. Later Time
APIs remain open. This does not claim a complete reading of Jiff or every
article-linked project.

The `3c9b750bca` combined build subsequently passed and was promoted at port
1111 with source digest
`1bfc8b7dc7978bd3b36bb1a42fb2b8c5fad40519b99cb2bc7be5ea558705249f`.
The browser-Miri runtime manifest is unchanged from `ab20ec12d9`. All 13 site
tests and the core formatting check also pass. Further source review then
traced the variable list's scroll-handler invocation and row renderers under
the ListState mutable borrow. The API and shared chapter now explain that
reentering its query/mutation methods from either callback panics and link
Window::defer as the mutation boundary. That final addition needs the next
combined artifact and has not been included in the preceding detector scores.

Browser checks completed for the first-window, layout, and custom-element
compiled previews. The greeting renders and remains centered at a 120-pixel
viewport, with slight horizontal clipping at that width. At 390 pixels the
layout shows a yielding pane beside the 180-pixel fixed pane; at 240 pixels
it clips as its documented desktop constraints predict. The custom element
paints its 192-by-96 quad and clips it within a 120-pixel iframe. Proof files:
`first-window-120.png`, `layout-390.png`, `layout-240.png`,
`custom-element-preview.png`, and `custom-element-120.png`.

The subsequent Jiff reading completes every public example in `civil/time.rs`
through TimeWith (approximately line 3,200), including differences, signed and
unsigned duration conversions, rounding and wraparound, periodic iteration,
printf-style parsing and formatting, precision, operators, TimeArithmetic,
TimeDifference, TimeRound, and whole versus individual fractional-field
configuration. Private production helpers in that interval were read too;
the remaining tests are outside this claim. The earlier limited reading scope
above records the preceding checkpoint rather than the current endpoint.

The combined artifact at `e15a831ba1` also passed, including the callback-borrow
warning. A subsequent 390-pixel book check found that Right Arrow on a link
inside an overflowing table invoked mdBook's next-chapter shortcut. The table
handler now stops that shortcut for descendants as well as its wrapper, leaving
the browser's default horizontal scroll intact. Actual key presses on the
UniformListScrollHandle link and wrapper keep the lists chapter open and scroll
the table. Left Arrow scrolls back. At desktop width both tables lose their
extra tab stop and region role. This isolated book check used port 1118; the
next combined artifact must include the fix. Proof:
`lists-book-mobile-keyboard-fixed.png`.

The animation editor was also checked at 390 by 844 pixels. Its source and
result panels stack, the document stays 390 pixels wide, and the live result
settles to the new canvas dimensions. A capture made during resizing showed
an incomplete result; the settled frame contains Replay and the full endpoint
without the duplicated-header capture seen under the earlier emulation setup.
This check uses a single-pixel-scale CDP capture, not the tab screenshot API's
incorrectly sized emulation output. Proof: `animation-editor-390.png`. Both
temporary viewport overrides were cleared afterward.

## Focus, bindings, and action configuration

The next contextual pass reread FocusId, FocusHandle, weak handles, Focusable,
ManagedView, the Window focus setters and queries, focus notifications, the
relevant dispatch-tree construction and lookup paths, tab-stop ordering, and
the element focus/tab builders with their group-entry regression. It also
reread the full Keymap production implementation, KeyBinding and binding
collection implementations, Action's public contracts and registry, and the
action derive implementation.

The docs now distinguish a selected identity from a rendered target, describe
the direct focus fields as snapshots of shared configuration, explain negative
tab indices and builder-call order, and correct the old claim that a tab group
resets its children's indices. A new asserting test moves a focused field out
of its panel while retaining the identity, checking old ancestry before the
next draw and new ancestry afterward. The setup assertions run inside the
window builder because App::open_window draws the initial root before returning.
The focused testing-chapter run passes all 15 examples at that checkpoint.

The source comparison also exposed a live discrepancy between shortcut
dispatch and shortcut labels. A weaker-source NoAction marker preserved a
stronger binding during input lookup, but action lookup discarded it before
the window's label query. The new regression failed before the fix. The
isolated implementation and two regressions are committed as `8634be1bc2`;
all 506 core library tests pass. The browser bundle B predates this label fix;
its owner received the isolated commit for the next SDK refresh. None of the
twelve starter components changed.

New Keymap examples assert context-depth precedence, removal and restoration,
and a complete shortcut that is also a chord prefix. The source descriptions
separate structural sequence inspection, context-aware candidate lookup,
shortcut display, listener presence, and actual handling. The focus task guide
uses those APIs as a diagnostic path and links both the binding and rendered
focus tests. All 25 documentation-tool tests, all 13 site tests, and formatting
pass at this checkpoint. The complete final doctest and combined-artifact runs
remain required after the configuration documentation is finished.

The intervening complete doctest run passes 196 examples (189 merged and
seven test-harness examples), with two ignored. The action-configuration pass
then expands App's named construction and metadata APIs, Action's builder and
metadata hooks, ActionBuildError's requested-name fields, and the re-exported
derive and registration macro docs. In particular, schema absence is distinct
from an unknown action and from JSON construction being disabled; aliases use
the canonical builder but metadata maps use canonical names. The new direct
builder example asserts valid data, payload-sensitive equality, wrong field
types, and unknown-field rejection. The subsequent complete run passes 197
examples (190 merged and seven test-harness examples), with two ignored.

The combined browser-program, strict API, Zola, and mdBook build then passed
at `7360ebfc34089ed5024efe3ceaf9f82c71e50af1`. The first attempt exhausted disk
space while writing Cargo incremental caches. Only reproducible incremental
caches were cleared; the source and previous site artifacts were preserved.
The successful rerun used `CARGO_INCREMENTAL=0`. Its source digest is
`ad8a594ce413773c975c7478f76cd4d26b9cdf5e910118a381cb7f24c139256d`, and its
browser runtime manifest remains bundle B's
`9c69e9709b1922c946d8d166d4b51647df650a7223e26abda80b98fe8c1ef2d6`.
That checked artifact replaced the local site on port 1111; the prior artifact
is preserved in `target/documentation-before-focus-actions-7360ebfc34`.

The primary editor read the rendered Keymap and Action contracts, followed the
focus guide's link to the rendered focus test, and inspected the guide at a
390px CSS viewport. The table stayed within the document width but squeezed
API names and questions into difficult fragments. The source now expresses
those checks as an ordered diagnostic sequence. A fresh combined build and
browser check are required for that change; absence of horizontal overflow
alone did not establish readability.

Scribbr v7.1.0 scanned the complete Keymap Markdown sample, including Rust,
at 452 displayed words: 32% AI-generated, 0% AI-refined, 68% human. The input
is `target/documentation-proof/keymap-complete-checker-input.md`, SHA-256
`f7aafeb51ea87e5a43880ed3b934f908a5e68b151c817fa63a3dd9a6ef2204a2`;
the result is `scribbr-keymap-complete.png` in the same directory.
The same text with fenced code removed, without a prose rewrite, scored
0% AI-generated, 0% AI-refined, 100% human at 360 displayed words. That input
is `keymap-prose-checker-input.md`, SHA-256
`9140648a60b463eac48d25e5cc40114605cb5d29b1743790a9241a48902c6aab`;
its result is `scribbr-keymap-prose.png`. These are sample-specific scores,
not evidence of accuracy or a framework-wide result. No Pangram score was
obtained, and no paraphraser was used.

## Entity, task, and window ownership

The next solo pass read the complete production implementations of Context,
AsyncApp, and AsyncWindowContext; AppContext and VisualContext; the public
entity and weak-entity methods; the leak detector's production implementation;
Global and Subscription; and all WindowHandle and AnyWindowHandle methods.
It traced window lookup, association, entity creation, and observer/release
registration into App. This does not claim the remaining entity-map or
subscription test modules were read in this pass.

The existing Context overview grouped weak listeners and spawned futures
together too loosely. A listener skips a released consumer, but an externally
owned or detached task can continue after entity release. The docs now state
who owns cancellation, and the testing chapter adds a controlled completion
channel that proves the task runs after release and returns a failed weak
update. Scheduling, ownership, and the async task guide link that assertion.
The async guide's repeated generation-counter paragraphs were rewritten as
one request-identity explanation linked to the existing out-of-order test.

Async window construction has two contracts: AppContext creation falls back
to app-only state when the window is unavailable; VisualContext creation
requires a window and skips the constructor on failure. A new asserting
example closes the window and checks both outcomes. Window access docs also
distinguish an already borrowed window's update error from read_window's panic,
and WeakEntity's release error from async app-borrow panics. The ignored leak
assertion snippet was replaced with an executable effect-flush example.
Global's overview no longer implies all globals share one notification stream.

Consumer comparisons included Hummingbird's complete
`src/ui/components/async_resource.rs`, including its tests, and complete
`src/ui/search/model.rs`, at
`2e1ee5f1c8d415ef7f835801fe368ab4106035b5`. The async resource retains a Tokio
abort handle while detaching its GPUI completion task; its tests distinguish
bridge completion, foreground publication, replacement, and stale results.
The search model checks both generation and visibility before publication.
Zed's `crates/acp_thread/src/acp_thread.rs` lines 4950–5030 at
`da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f` were reread: its streaming loop
explicitly exits when a weak update fails. These consumer sources were read,
not executed here. The canonical async-task and subscriptions walkthroughs,
ownership chapter, and state, async, focus, and live-editing guides were also
reread for this ownership correction.

The first complete doctest run for this pass, with `test-support`, passed
198 examples (191 merged and seven test-harness examples), with one ignored.
The subsequent complete run with both `test-support` and `bench-support`
passes 200 examples (193 merged and seven test-harness examples), with one
ignored. This executes the new task-ownership, closed-window construction,
and leak-cleanup assertions. Strict default-feature rustdoc for the core and
companion crates also passes, with broken/private links, bare URLs, and missing
docs denied. Formatting and the diff whitespace check pass. Final rendering
remains to be checked for this pass.

### Further reference reading

The primary editor reread the ecosystem review's complete article prose and
code snippets from the cached 2026-10-07 HTML, including its comparisons,
analysis, and conclusion. The web tool could not reopen the article during
this pass. This does not claim a new visual review of its embedded images or
a complete reading of every linked site's examples.

The complete [Rocket 0.5 pastebin tutorial](https://rocket.rs/guide/v0.5/pastebin/)
was read from the official site: the working result, incremental setup,
storage decisions, first retrieval attempt and its validation problem,
typed parameter repair, streamed upload, verification commands, and proposed
extensions. Its useful pattern is to give each new part an observable result
and a reason before introducing the next part. Its code was read, not executed
in this workspace. The Embassy Book's introduction was also revisited; its
remaining chapters and FAQ body were not completed in this pass.

The next editorial reference pass read Gwern's condensed manual, opening
writing guidance, prose/reference conventions, and complete LLM Writing Guide
(including its examples, workflow, pitfalls, checklist, and footnotes). It did
not read every section of the full style-guide page. The applicable principles
are to preserve concrete constraints, make formatting carry meaning, link
unfamiliar terms where they first matter, and check claims against their source
before polishing the sentence.

Wikipedia's Signs of AI Writing introduction and caveats, selected content
examples, language/grammar section, and style section were read. This was a
selected-section reading, not the whole page. Its advice describes patterns
seen in encyclopedia contributions; it does not justify removing useful
Markdown structure from API documentation. Correcting an unsupported claim
matters more than replacing a detector-associated word.

Fasterthanlime's complete Updating fasterthanli.me for 2022 series index was
read, along with the content-pipeline and local-workflow excerpt of My Ideal
Rust Workflow. The linked installments and the whole workflow article were
not read in this pass. The relevant comparison is a local replica with an
observable reload path and reproducible content/assets, while retaining this
site's smaller canonical-source workflow.

Jiff 0.2.35's rendered Timestamp page was read through all inherent methods
and their examples, including configurable differences, rounding, periodic
iteration, parsing, and formatting. Its Debug/Display examples, subtraction
operators, and system-time conversions were also read. This extends the earlier
Jiff reading without claiming every Jiff API example has been read.

## Cached views and repeated component identity

The next solo pass read the complete production `view.rs` and `element.rs`,
the canonical rendering chapter, and the window-lifetime guide. It traced
render-time entity reads through App's accessed-entity tracking, notification
routing, WindowInvalidator, dirty-view ancestry, and cached-view reuse. It
also read the state-hook implementation and IntoElement derive. Consumer
comparisons included Zed's editor constructor observations at lines 2495–2550
of `crates/editor/src/editor.rs` at
`da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f`, Hummingbird's complete
`src/ui/right_sidebar.rs`, and its cached page helper at lines 630–685 of
`src/ui/library.rs`, at `2e1ee5f1c8d415ef7f835801fe368ab4106035b5`.
These source comparisons were read, not executed here.

The previous notification wording obscured a cache boundary: a shared model's
notification can request a window redraw without invalidating a cached view
that read it. Context, AppContext, Entity::cached, View, ownership, and rendering
now distinguish those operations and show where a retained observation must
notify the view. A new testing example checks unchanged reuse and the changed
painted color. Removing notification forwarding made the render assertion fail;
restoring it passes. The failing run is retained in
`target/documentation-cached-view-without-forwarding.log`.

RenderOnce and the rendering chapter now explain the automatic type-name scope,
its limits for repeated instances, and why an ID on the returned element cannot
scope an earlier state hook. A new asserting example changes one row's state,
reverses the records, and checks distinct, preserved state identities. The
AsyncWindowContext example also now checks explicit app-only updating after
window close, alongside the window-scoped update error. The window guide no
longer implies all operations need a live window.

The complete doctest run with `test-support,bench-support` passes 205 examples
(198 merged and seven test-harness examples), with one ignored. Formatting and
diff whitespace checks pass. The canonical chapters were mirrored into the
site guides; the combined artifact and its browser checks remain pending for
this checkpoint.

### Browser runtime integration

The isolated SDK inlining commit `2ac6e12ac4` was imported locally as
`2aafb11043`. The primary editor read its source changes, verified all seven
source hashes and all 2,196 exported asset hashes against the supplied
provenance, checked protocol 8, and matched all twelve canonical walkthrough
sources byte-for-byte against the eighteen compiled starters. The candidate
manifest SHA-256 is
`ec1f024edfb3793c03c6968764bf53abb386e3d1c53d4f66d816cbcaec14f994`.
The previous runtime is preserved at
`target/documentation-runtime-before-sdk-inline`; 1,693 previous assets absent
from the new bundle were retained for already-open Workers.

The independent paged-packaging check passes byte reconstruction, bootstrap
offsets, partial-page handling, and malformed-profile rejection. The native
engine test target compiles, but its seventeen tests are ignored by default;
this checkout lacks the prepared native interpreter/sysroot, so that compile
is not reported as seventeen passing engine tests. The runtime owner's native
parity, browser probe, and performance results remain supplied evidence. The
primary editor's browser editing checks on the new combined artifact are
still pending here.

Scribbr v7.1.0 scanned the cached-view section of the rendering chapter,
including its heading and Markdown links. It displayed 189 words and reported
0% AI-generated, 0% AI-refined, and 100% human-written. The input is
`target/documentation-proof/cached-view-checker-input.md`, SHA-256
`83e93757850a4acff32b5ff10946b700ac25575df295a7d505c45494cde6c618`;
the result screenshot is `target/documentation-proof/scribbr-cached-view.png`.
The subsequent default-feature rustdoc check caught links to the conditional
testing module. Those four links now use the always-published guide; the prose
is unchanged from the scanned sample. This is one sample's classifier result,
not a whole-framework result. No paraphraser was used.

## Coordinates, clipping, and the rendered integration

The combined build at `f3cbf04eff49d573cb5d3c5d7584ace7c267b089` passed
strict feature-enabled rustdoc, Zola, mdBook, and the HTML/link audit. Its source
digest is `86ddd29ead5ba01b3efc7668865887fe92b7d3b92953f1ace3658823f744867a`;
the published runtime manifest matches the verified SDK-inlining candidate.
It replaced the local site only after the build passed. The preceding `bec3`
site is preserved in `target/documentation-before-rendering-runtime-f3cbf04eff`.
The separate strict default-feature API build also passed after the four
conditional testing links were corrected.

The primary editor followed Entity::cached's test link into the new guide,
read the rendered RenderOnce contract and keyed example, and read the rendering
chapter in mdBook. At a 390-pixel viewport, that book page's document width
remained 390 pixels and its main reading area was 350 pixels. The screenshot
is `target/documentation-proof/book-rendering-mobile.png`. This checks that
page and width, not every chapter's responsive layout.

The primary editor independently executed the production WASM Worker probe
against the integrated bundle. Six counter generations matched the supplied
native reference frames, including compatible helper and local-variable edits;
both patches were accepted, with one interpreter boot. Its log is
`target/documentation-sdk-inline-probe.log`. The native reference frames came
from the runtime owner's fixture directory; this is an independent Worker run,
not a new native reference run or a performance benchmark.

Actual browser checks then exercised the newly served editor: canonical
increment to one, helper replacement with `saturating_add(5)`, preserved count
one, and the next click producing six. An undefined `missing_step` produced
the compiler's E0425 diagnostic while six remained visible. Restoring the last
valid source retained six; explicit Reset state returned zero. Complete source
copied through the editor matched the intended edit byte-for-byte. Temporary
logging in the ignored rendered runtime confirmed an accepted patch without
a VM restart; that file was restored byte-for-byte afterward. Intermediate
screenshots that appeared to show zero were rechecked against the settled
frame before drawing a conclusion. Evidence is in
`target/documentation-proof/counter-compatible-helper-six.png`,
`counter-compiler-error-retains-six.png`, and `counter-recovery-retains-six.png`.

The already-open page also accepted a click after site replacement. The local
server's automatic HTML reload means this alone does not establish that an
old Worker stays alive indefinitely across upgrades. Retained immutable assets
and their matching hashes remain the separate compatibility evidence.

The next manual pass read the complete canonical layout chapter, the first
half of the testing chapter, the complete custom-element program and canvas
implementation, Window's coordinate/clip/layout/hitbox methods, Drawable's
layout and prepaint paths, and the corresponding Taffy registration,
computation, measurement, and snapping implementations. It corrected guidance
that implied ordinary elements must compute their own layout and a prepaint
panic claim that confused requested layout with computed layout. Offset scopes
now distinguish translation from layout and clipping; AnyElement's placement
helpers preserve an already-computed child position. Hitbox geometry now explains
fragments, fades, capture, modality, and occlusion at their respective boundaries.

An independent drawing assertion checks a child laid out at `(12, 0)` and
prepainted with translation `(20, 30)`: its painted origin is `(32, 30)` before
density conversion. The check is saved in
`target/documentation-clipping-negative/translated-root.md`, with the passing
run in `translated-child.log`. An earlier proposed root-margin example failed:
a separately computed root did not retain that margin as an origin offset.
That claim was removed before publication. The coordinate rules describe
computed positions, not an assumed root-margin behavior.

A new layout section connects these APIs, and an executable clipping example
checks a 100-pixel quad through a 40-pixel mask plus presses inside and outside
that mask. All nineteen testing-chapter examples pass. The same new example
was executed independently with each mask removed: omitting the prepaint mask
fails the outside-press assertion; omitting the paint mask fails the
recorded-mask assertion. Those intentional failures are saved in
`target/documentation-clipping-negative/`. The complete doctest run passes
206 examples (199 merged and seven test-harness examples), with one ignored.
Formatting and whitespace checks pass. The next rendered build remains
pending at this entry.

The strict default-feature API build passes for GPUI and the companion elements
crate. Its log is `target/documentation-coordinate-default-api.log`; the next
combined build will validate the final feature-enabled API and book links.

Scribbr v7.1.0 scanned the complete new coordinate-space section, including
its heading, Markdown table, inline code, and links. It displayed 303 words
and reported 5% AI-generated, 0% AI-refined, and 95% human-written. The exact
input is `target/documentation-proof/coordinates-checker-input.md`, SHA-256
`44c9b19d2445e39e9f1c8c35ff26479954bd6cb4af979ce076c524ee039dc6c7`;
the screenshot is `target/documentation-proof/scribbr-coordinates.png`.
The detector highlighted the sentence linking the clipping test. That useful
cross-reference was retained. This is a recorded sample result, not a score
for the full documentation. No paraphraser was used.

### Further reference reading

The complete combined [Embassy Book](https://embassy.dev/book/) prose and code
were read, including setup, the PAC-to-HAL-to-async progression, shared-peripheral
choices, and the entire FAQ. Its diagrams were not visually reviewed and its
code was not executed. The useful comparison is one observable task developed
through successive abstractions, with specific troubleshooting repairs.

The complete text and snippet of the [published GPUI homepage](https://gpui-ce.github.io/)
were also read. Its snippet uses an older Render signature and listener
arguments; its claims are not treated as implementation evidence. This was
a text review, not a visual or execution check of the old site.

Jiff 0.2.35's [Unit introduction, variants, and all examples](https://docs.rs/jiff/0.2.35/jiff/enum.Unit.html)
were read. It introduces a type through its uses, links directly to those APIs,
and gives a short asserting example for ordering before stating the unit-specific
constraints. This extends the reference reading; the wider survey is still
incomplete.

## Entity lifetimes, window routing, and keyboard entry

The coordinate build at `0c59c48a93dfcfa461eaab4ef8ad7d2aeed60317`
passed strict feature-enabled rustdoc, Zola, mdBook, and the HTML/link audit.
Its source digest is `1135d3f41bb67de12ad39ff0e317fe6facd144a2f1ad5e1b08b8b79abe5d18d5`;
the build log is `target/documentation-coordinate-site.log`. The primary
editor read the rendered content-mask, layout-request, element-offset, and
prepaint-placement contracts and followed the clipping test into the guide.
At 390 pixels, the layout book chapter kept its document width at 390 and its
reading area at 350; wider tables scrolled inside that area. Evidence is
`target/documentation-proof/book-coordinates-mobile.png`.

The next manual pass read the complete scheduling and ownership chapters,
Context's production/public implementation, the Task and FallibleTask
implementations, the synchronous and asynchronous entity-update paths, and
entity-map storage/release paths. It found three foreground priority helpers
whose docs promised a scheduling distinction that the executor ignores. The
helpers and scheduling chapter now state that actual behavior.

A new executed two-window example establishes which window Entity::update_in
selects. Drawing a shared entity in a second window replaces its association;
an AsyncWindowContext remembering the first window does not override that
selection. Explicit context.update chooses the remembered window. Closing
the associated window makes the inferred operation fail, and drawing the
first window establishes a usable association again. The passing chapter
run is `target/documentation-window-routing-doctests.log`.

Entity, AnyEntity, and WeakEntity introductions now contain executed
assertions, including failed downcast recovery and the immediate failure of
weak upgrade after the last strong handle drops. Release assertions now
distinguish removal of the entity slot from destruction of its value. An
executed Context::on_release example records the release callback before
Drop, and establishes that assert_released can pass inside that callback.
All 210 doctests passed before the subsequent keyboard changes (203 merged,
seven test-harness examples, one ignored). The log is
`target/documentation-lifetime-complete-doctests.log`.

Actual browser checks of the compiled asynchronous walkthrough passed both
Stop-before-deadline and later completion. Screenshots are
`target/documentation-proof/async-stopped-after-deadline.png` and
`async-completed-after-delay.png`. A subscriptions click changed both count
and delivered-observation count to one. Its keyboard check failed: Tab moved
browser focus to Edit Rust. The image named subscriptions-pointer-and-keyboard
records an intermediate editor load, not successful keyboard activation.

Source tracing found no Tab traversal binding in the shared launcher or guest
harness. tab_index records order; it does not bind a key. A first new dispatch
test then exposed the additional initial-focus requirement: a root element
listener below GPUI's fallback dispatch root cannot receive keys while none
of its descendants is selected. The four button walkthroughs now explicitly
select and attach a retained root focus identity, and route Tab/Shift+Tab
through the recorded stops. The input chapter has an executed two-target
traversal example; the canonical counter test also checks keyboard activation
and the returned propagation flag. These changes still require final build
and browser verification at this entry.

The browser shell reserves Escape to leave the wrapped GPUI order. Its parent
validates message source and origin before returning focus to Edit Rust or
the workbench's Reset state control. The exit is described before each embed
and in the editor. This follows the scope of W3C's
[keyboard-trap explanation](https://www.w3.org/WAI/WCAG22/Understanding/no-keyboard-trap.html),
whose criterion, intent, examples, and technique links were read; it does not
constitute a complete accessibility audit.

Four revised starter programs were compiled against byte-exact copies of
the previously verified GPUI and guest SDK metadata. They were appended to
the existing paged bundle, preserving the browser compiler, runtime sources,
SDK bytes, and old immutable assets. The manifest changes from
`ec1f024edfb3793c03c6968764bf53abb386e3d1c53d4f66d816cbcaec14f994` to
`fe33dbceb23f9b069901bb0bb31e724d2712a3deea69d254118cde058f14e896`.
The build-only script and provenance are under
`target/documentation-tab-starters/` and
`target/prepare-documentation-tab-starters.py`; no internal testing-branch
source was merged. Packaging reconstruction tests pass. Execution of these
new starters in the served browser remains pending at this entry.

The complete available Iced Book prose and code were read, including its
introduction, architecture, state-first counter, runtime, Text and Container
chapters, and complete FAQ. The text marks the book unfinished. Its useful
patterns are assertions before UI construction and showing why alignment
does nothing until a container gains space; its polemical FAQ tone is not a
model for these docs. Images were not visually reviewed and code was not run.
The time book overview and mdBook's complete SUMMARY format page and example
were also read. The broader reference survey remains incomplete.

The primary editor additionally read the complete input chapter, all focus
handle and Focusable implementations, and interactive.rs through ScrollDelta.
The changes connect key routing and traversal to initial focus, explain that
release delivery need not pair with a press on the same element, and give an
asserting example of a keyboard click's bottom-left anchor. This is manual
source review; it is not a claim that every remaining public API has received
the final solo pass.

The subsequent complete interactive.rs read includes scrolling, pinch,
incoming and outgoing file drags, PlatformInput, and its tests. Incoming file
paths now explain acceptance versus loading and the browser limitation;
outgoing payloads explain the directory flag, lack of filesystem validation,
and the distinction between offering data and the recipient accepting it.

The new canonical counter test passes, and all twelve programs pass their
initial/rebuilt-frame tests: thirteen passing tests total, logged in
`target/documentation-canonical-tab-test.log`. The filtered input-chapter
doctests also pass. All twenty-five documentation-generation tests and the
paged-packaging tests pass. A full doctest run remains pending here.

Scribbr v7.1.0 scanned the new traversal section's prose, with its Rust fence
omitted but its heading, inline code, and Markdown links retained. It displayed
201 words and reported 0% AI-generated, 0% AI-refined, and 100% human-written.
The exact input is `target/documentation-proof/traversal-checker-input.md`,
SHA-256 `2fdc2201c80404a43149b6a95740d049a16c274d2ed00f1957ef52a126788ca1`;
the screenshot is `target/documentation-proof/scribbr-traversal.png`.
This is one prose sample, not the Rust example or the whole framework.
No paraphraser was used.

The complete post-edit doctest run passes 212 examples: 205 in the merged
run and seven test-harness examples, with one ignored. Its log is
`target/documentation-input-lifetime-complete-doctests.log`. Formatting,
whitespace, JavaScript syntax, canonical generation, and link-generation
checks pass. The combined artifact and its browser checks are the next
validation boundary.

### Host focus and strict-link repairs

The combined build rejected two new intra-doc links: `on_drop` belongs to
InteractiveElement, and the Focusable page needed a crate-qualified
track_focus target. Both are corrected. The failed build log remains
`target/documentation-input-lifetime-site.log`; it is not a successful artifact.

A fresh browser-only counter session also exposed a second focus boundary.
The browser textarea received focus, but the host GPUI preview had no selected
focus handle. Pressing Tab moved to the workbench's Diagnostics control. A
pointer click had concealed this omission in earlier checks. Codepen now
exposes focus_preview, and the documentation host selects that surface during
construction. The method explains the distinct host, interpreted-component,
and browser-document focus requirements. Browser verification follows the
next combined build.

The complete Actix and Tokio homepages were read, including Actix's four code
examples; the complete wgpu homepage text was read. These checks did not run
their code or inspect their images. The egui homepage initially exposed only
Loading to text extraction. Its loaded browser demo was then visually read:
the complete visible About panel, its save-button example, the Arthur/age
code example, and the visible widget gallery. Other demos and off-screen
content remain unreviewed. The useful comparison is code beside an immediately
usable result, with clear links to each example's source.

## Canvas, responsive subtrees, overlays, and test-window ownership

The host-focus artifact at `63da94018dd511f4bac547b797d0cfbd537a2dad`
passed the combined strict feature-enabled API, Zola, mdBook, and HTML/link
checks. Its source digest is
`70aabd62501d661d6e299f73eb9cbe94f61f389323d3067ed05e89337ff9971e`,
with runtime manifest `fe33dbceb23f9b069901bb0bb31e724d2712a3deea69d254118cde058f14e896`.
It was promoted to the local server. The build log is
`target/documentation-host-focus-site.log`.

Without clicking the preview, the primary editor used normal browser Tab
navigation to enter the Miri counter, selected its button with Tab, activated
it with Enter, traversed backward with Shift-Tab, and activated it with Space.
The count reached two. Escape selected the workbench's Reset state control.
The source editor's Escape-then-Tab exit also worked. Evidence is
`target/documentation-proof/miri-counter-keyboard.png`.
The compiled subscriptions preview passed the corresponding route; both
count and notifications reached two, and Escape selected Edit Rust.
Evidence is `target/documentation-proof/compiled-subscriptions-keyboard.png`.
The revised subscriptions starter also executed in Miri: Tab then Enter
produced count one and notification one. Evidence is
`target/documentation-proof/miri-subscriptions-keyboard.png`.

The primary editor read the complete canvas, container-query, anchored, and
deferred production implementations; Style::paint and overflow-mask paths;
the relevant AnyElement lifecycle, hitbox insertion, and mouse-listener paths;
and both complete canonical drawing/custom-element programs. Reference reads
included Zed's scrollbar canvas and gradient canvas, and Hummingbird's
window-chrome canvas. These are source reads, not execution of those projects.

Canvas now explains size, coordinate origin, phase handoff, retained-state
ownership, invalidation, clipping, hit testing, and its style boundary. Its
new inset-swatch example asserts the recorded rectangle. Container queries
now assert the compact/full boundary and resulting bounds at three widths.
Anchored placement asserts ordinary placement and both-axis edge fitting.
Deferred's constructor explains same-frame deferral and connects layout,
dispatch ancestry, placement, clipping, and popup ownership.
The drawing chapter carries the shared explanation into the site and book.

The complete TestApp/TestAppWindow implementation and tests, the complete
testing chapter, test.rs including seed logic, and TestAppContext through
the VisualTestContext constructor/input entry points were read again.
TestAppWindow now explains that its clones retain the app and dropping the
handle does not close the window. An executed example checks explicit closure
and independent root ownership. Drawing clears temporary element storage;
it does not erase the scene. Input helpers now distinguish press/release,
committed text, IME composition, pointer movement, and scroll phases, and
state which boundary drains tasks. simulate_resize's closed-window no-op is
documented rather than covered by a false general panic claim.

The full post-edit doctest run passes 216 examples: 209 merged and seven
test-harness examples, with one ignored. Its log is
`target/documentation-canvas-neighbors-doctests.log`. The new canvas example
also passed separately. The default-feature strict API build caught a link
to the feature-gated testing module; the canvas page now links to the canonical
book instead. The corrected strict build and combined artifact remain pending
at this entry. All five edited GPUI source files pass rustfmt; the workspace
check still reports formatting in the previously integrated codepen runtime.

The corrected default-feature strict API build and the feature-enabled strict
API build both pass. Logs are `target/documentation-canvas-default-api.log`
and `target/documentation-canvas-feature-api.log`. The site guide mirror was
then refreshed against the feature-enabled API. The combined artifact is the
remaining check for this batch.

The revised async starter also passed browser-only keyboard checks: Start
reached Complete, and Start then Tab then Enter reached Stopped. The completed
state is recorded in
`target/documentation-proof/miri-async-complete-keyboard.png`. These checks use
the served host-focus artifact above, not the as-yet-unbuilt canvas revision.

The complete Rust blog homepage/index, This Week in Rust homepage, and Pinoy
Websites webring homepage were read. Linked articles and member sites were
not read by implication. These are reference/navigation surveys, without
code execution or image review. The broader linked-example review remains open.

A fresh Scribbr visit left its detector panel blank; its linked QuillBot
fallback failed with a connection reset. No new detector score is claimed
for this batch. Earlier recorded samples are still only samples.

## Test-context contracts and rendered API notes

The canvas batch at `ce6f9b3734ac5c4cf2e9e37c4fb90e3c351b7906`
passed the complete API/site/book build and link audit. Its source digest is
`8c29bf70416141af068bd842aa7632da66b5cc5423d856723bf76718279fc6c5`;
the runtime manifest remains `fe33dbceb23f9b069901bb0bb31e724d2712a3deea69d254118cde058f14e896`.
The artifact was served locally. The primary editor read the rendered canvas
constructor and type explanation and followed its clipping link into the
local book. The type's warning had no visible boundary: the HTML conversion
removed rustdoc's blockquote styling without supplying replacement styles.
The postprocessor now styles notes and walkthrough backlinks using rustdoc's
own theme variables, including pages absent from the walkthrough index.
Two new regression tests check theme-aware, idempotent formatting and an
unindexed warning page. All 27 documentation-tool tests pass.

The primary editor reread the complete TestAppContext/VisualTestContext module,
the complete VisualTestAppContext module, prompt queues, resize and activation
callbacks, key parsing and dispatch, window updates and removal, and the
automatic-drawing branch in effect flushing. The rewrite distinguishes app
effects, ready tasks, elapsed test time, and dirty-window drawing. It covers
constructor defaults, cleanup ordering, window and root ownership, queued
prompt answers, global leases, input event details, and diagnostic selectors.
The debug-selector docs incorrectly described a release-profile no-op; the
actual switch is the headless/test feature configuration, including release.

simulate_close calls and restores the installed close-request callback. It
does not remove a window when that callback allows closing. The new canonical
testing fixture checks a veto, an allowed request, the still-open window,
explicit removal, and root release after dropping the test's independent
handle. next_notification now distinguishes a notification from a value
mutation and demonstrates that installing its observation and advancing time
happen before the returned future is awaited.

The first doctest run caught missing constructor type information; the next
caught an immutable context passed to WindowHandle::root. Both were corrected.
The corrected run passes 218 doctests (211 merged, seven harness examples),
with one ignored: `target/documentation-close-request-doctest.log`.
The first strict API check caught a method link addressed to App instead of
its BorrowAppContext trait; the corrected feature-enabled check passes in
`target/documentation-test-context-api-corrected.log`. A final default-feature
check and combined artifact are pending at this entry. Edited Rust files pass
rustfmt and the diff passes whitespace checks.

The served browser-only counter retained one across an edit from +1 to +5;
the next keyboard activation produced six. A syntax error preserved that
result and showed its compiler diagnostic; repairing it recovered without
resetting state. Reset state then produced zero. The original source and
auto-run setting were restored. Evidence is under
`target/documentation-proof/miri-counter-{hotpatch-six,compile-error,reset-zero}.png`.
The canonical animation source was restored from an older local draft and
executed successfully; keyboard Replay completed without a runtime error.
Its final state is recorded in `miri-animation-keyboard.png`; that still image
does not establish smooth frame pacing or verify an intermediate width.
The stopped async state is recorded in `miri-async-stopped-keyboard.png`.

A fresh GPTZero navigation failed with a connection reset. Together with the
blank Scribbr detector and QuillBot reset above, this leaves no new detector
score for these revised API passages. The reference article also remained
unavailable to the web tool on this attempt; earlier source/reference reads
remain the evidence for its survey.

No Luna agent is currently running. Their earlier reports are incomplete
first-pass material; the primary editor's source and browser review remains
unfinished. This entry records the specific work above, not complete coverage
of all APIs or an overall Jiff-quality judgment.

The final doctest run also passes all 218 examples (211 merged, seven harness
examples), with one ignored, in `target/documentation-test-context-doctests-final.log`.
The strict default-feature API build passes in
`target/documentation-test-context-default-api.log`. The combined feature-enabled
artifact and rendered callout checks follow this revision.

## Child draw sequences and visible API explanations (2026-10-08)

Revision `767b1d4231` passed the combined API, Zola, mdBook, and link audit and
was served locally. The primary editor checked the canvas warning in both
rustdoc themes: the dark background was `rgb(42, 42, 42)` with light text,
the light background was `rgb(245, 245, 245)` with black text, and both used
the four-pixel warning border. The original system theme setting was restored.
Screenshots are `target/documentation-proof/canvas-warning-styled-{dark,light}.png`.
The editor also followed `VisualTestContext::simulate_close` into its canonical
test, read that section in mdBook, and read the rendered `next_notification`
contract and timer fixture.

The complete cached ecosystem-review article was subsequently read as text,
including its examples, in bounded excerpts. This does not cover its images
or establish that every linked site has been read. A fresh attempt to read
the pinned Jiff Zoned page through the web tool failed; the previously recorded
Jiff reads remain the source evidence.

The primary editor reread the complete Element, View, Arena, and Subscription
implementations; the window's arena scopes, layout bounds, absolute and relative
offsets, and layout computation paths; and the complete SharedUri, Global, and
HTTP client modules. Zed's complete `crates/ui/src/components/sticky_items.rs`
was read in the pinned reference checkout. Hummingbird's MaybeStateful wrapper
and the opening rendering branches in Lyrics were read as excerpts. These
consumer implementations informed the distinction between ordinary child
layout and independently positioned subtrees; GPUI CE's implementation remains
the contract being documented.

AnyElement now explains both draw sequences, preservation of the same child
between phases, repeated measurement, coordinate translation, and the arena
lifetime. Its worked prepaint-as-root example asserts the marker's painted
origin and size inside a padded parent. The canonical rendering chapter shares
that guidance with mdBook. Subscription's constructor and join examples check
cleanup; the join example also checks that detaching calls neither cleanup.
Detach's explanation now distinguishes dropping the cancellation closure from
removing the registered observer.

SharedUri's useful explanation was attached to a private module and therefore
absent from its public type page. It now appears on the type, with assertions
for spelling-sensitive keys and Resource conversion. This was a visibility
gap, not just a shortage of source comments. App's overview now qualifies
background execution on the browser, and the App and cached-view explanations
use readable chapter labels. EmptyView explains when a view placeholder is
needed instead of an Empty child.

The rendered AnyView introduction and all five inherent methods, AnyWeakView's
introduction and upgrade method, and Entity::cached were read together. The
cached-view test link was followed into the Zola testing guide. Its opening
now describes establishing a frame, checking reuse, then checking invalidation;
the previous wording implied that two draws covered the complete fixture.

The first doctest run caught a missing ParentElement import in the mixed-child
example. After correction, all 222 doctests pass (215 merged examples and
seven harness examples), with one ignored:
`target/documentation-element-phases-doctests-corrected.log`. The strict
default and feature-enabled API builds pass in
`target/documentation-element-phases-default-api-complete.log` and
`target/documentation-element-phases-feature-api.log`. Subsequent edits change
prose and link labels only. The combined artifact and its rendered review follow
this revision. No new detector score or complete-framework quality claim is
made by this entry.

Revision `52944affa7` then passed the combined build and was served locally.
The complete new AnyElement introduction and prepaint-as-root example were
read in rustdoc, following the link from prepaint_at. Drawing and the custom
element ran successfully in browser Miri, with their expected rectangles
visible. At an actual 390-pixel CSS viewport, rustdoc's four-column phase table
wrapped method identifiers into fragments despite having no document-wide
horizontal overflow. Both versions now use two columns for placement and call
sequence, with layout timing explained beneath the table. The revised rendering
checks follow this entry; the browser viewport will be restored afterward.

## Context construction and native window configuration (2026-10-08)

Revision `518e8b6e45` passed the combined build and was served locally. The
revised two-column AnyElement table fits a 390-pixel CSS viewport without
fragmenting method names. The book's matching table still required horizontal
scrolling because the custom theme imposed a 36-em minimum width on every
table. That minimum has been removed; the rendered book check follows this
revision. This review distinguishes readable content from merely having no
document-wide overflow.

The browser-only drawing and custom-element programs completed and showed
their expected rectangles. The list program completed after a real wheel
event and showed rows 21–25. Evidence is in
`target/documentation-proof/miri-{drawing-preview,custom-element-preview,list-scroll}.png`.
These checks exercise those programs, not every input path or animation frame.

The primary editor reread the complete key-context parser and tests, complete
binding and action-binding-collection modules, the keymap's production lookup
implementation, and the canonical input chapter. The rendered KeyContext
methods and WindowOptions introduction and fields were also read. The context
rewrite supplies asserting examples for constructing facts, insertion without
replacement, order-sensitive equality, syntax errors, deepest matching, and
path-wide negation. Binding examples check incomplete, complete, and rejected
sequences and preserve the offending stroke in a load error. The collection
example checks actual alternatives and their predicate instead of just length.

Two contracts were misleading. `key_context` logs a failed conversion while
retaining a previously set context. `ActionBindingCollection::with` stores
the first default action for its type; conversion clones that stored action.
Its context parse happens on the conversion call, while stroke parsing happens
as the iterator advances. The revised docs distinguish these cases. The input
chapter explains rebuilding current facts on render and links to the mutation
example; the same canonical source feeds mdBook.

Window configuration was checked against GPUI's complete option resolution
and the relevant native creation, titlebar, parenting, tabbing, decoration,
and browser-window paths. This was a focused backend review, not a complete
rereading of those backend modules. The revised WindowOptions, WindowBounds,
TitlebarOptions, and WindowKind pages cover defaults, logical units, restore
geometry, native activation versus control focus, hidden-window creation,
animation throttling, chrome, and backend limits. Window's resize/minimize
policy queries now say that they return the supplied options, rather than
probing current native capabilities. PopUp and Floating no longer promise
universal stacking or parenting behavior. The canonical platform chapter adds
a choice guide connecting ordinary windows, in-window overlays, native anchored
popups, prompts, and separate dialogs.

For consumer context, the complete pinned Hummingbird `src/ui/keymap.rs` was
read again, and Zed's Pane context construction and scoped action registration
were read as an excerpt. Jiff 0.2.38's Date type overview was read from both its
published API and local source, including its construction/error examples.
No claim is made that every Jiff example or every ecosystem-review link has
been read. No detector was run for this batch.

All 230 doctests pass: 223 merged examples and seven executed harness examples,
with one ignored, in `target/documentation-window-options-doctests.log`.
The earlier keymap-only run passed 229. Subsequent changes only refine prose
and links. The six edited Rust files pass rustfmt, generated walkthrough
sources and backlinks are current, and the diff passes whitespace checks.
The strict default-feature API check passes in
`target/documentation-keymap-window-default-api.log`; the complete combined
build follows this revision. The final rendered review remains a primary-editor task; no subagents
were used for these passes, and the complete public-surface review is unfinished.

## Gesture ownership and rendered-link correction (2026-10-08)

The combined build for `3efbe940d9` compiled the browser programs, strict
feature-enabled API, Zola site, and mdBook, then failed its link audit. The new
WindowKind introduction linked to a nonexistent overlays walkthrough. It now
links to the drawing chapter's actual worked overlay example. The failed
artifact was not served; its metadata and build log remain in
`target/documentation-proof/3efbe940d9-failed-build.json` and
`target/documentation-keymap-window-site.log`. The book table correction in that
commit still needs its rendered check on the replacement artifact.

The primary editor read the public gesture contracts, portable recognizer's
state transitions and momentum path, and window touch dispatch, timer, claim,
hit-test, and capture paths. This pass did not reread every recognizer test or
the complete velocity estimator. Useful recognition guidance was attached to a
private module. The public GestureTuning, TouchDragEvent, and LongPressEvent
introductions now explain when offers arrive, how prevent_default claims them,
which later phases follow, and which position controls hit testing. Long-press
capture stores an entity ID; it neither retains that entity nor reroutes input.
The window helpers and canonical input chapter now explain retaining ownership
across redraws and accepting movement outside the original hitbox.

The new complete listener example checks the initial wait, timed Started,
movement outside its 100-by-100 canvas, cancellation, and clearing ownership.
All 231 doctests pass: 224 merged examples and seven executed harness examples,
with one ignored, in `target/documentation-gesture-contract-doctests.log`.
Strict default-feature rustdoc passes in
`target/documentation-gesture-default-api.log`. The integration note's obsolete
description of a server-backed editor was also corrected after checking the
development server, bundle builder, and browser Worker paths.

These are source-checked contracts and executable examples, not a claim that
the entire API now meets the editorial target. The combined build and rendered
review follow this revision. No subagents or prose generators were used for
this pass; no new detector score is reported.

## Action fallback and reading the rendered reference (2026-10-08)

Revision `c7169c894e` passed the complete browser-program, strict API, Zola,
mdBook, and link-audit build and was served locally. The primary editor read
the new KeyContext introduction and eleven inherent method contracts;
predicate parsing, depth, evaluation, and suppression contracts; binding
construction/loading/matching; and the shortcut collection's introduction and
two methods. WindowOptions and all seventeen fields visible on macOS,
WindowBounds, TitlebarOptions, WindowKind, the gesture introductions, and the
revised window helpers were read in the generated reference. The repaired
drawing link and long-press chapter link were followed, and the canonical
long-press and window-configuration sections were read in mdBook.

This caught a formatting error that compilation and link auditing did not:
the OR operator split its predicate-table row into extra cells. The pipes are
now escaped. The corrected child-phase table fits a 390-pixel CSS viewport,
with complete method names and 152/197-pixel content columns. The earlier
three-column frame-phase table still needed horizontal scrolling; it is now an
ordered explanation. Window-choice links use short variant labels after
introducing WindowKind, so a long qualified name no longer forces the table
wide. The last two changes still need their replacement-artifact browser check.

The KeyBinding introduction incorrectly required an element handler. Window
dispatch and App::on_action show that an app handler can consume the action
after element propagation. The introduction now links that fallback. The
canonical editor example now runs the actual shortcut twice: the editor
consumes the first action, then propagates the second to an app handler after
its state changes. Assertions check both local and fallback counts. A further
KeyContext example checks primary/secondary ordering and a bare fact's
presence without a value. Its introduction distinguishes unvalidated string
insertion from parsing the textual grammar.

The focus-handle production implementation and the input chapter's focus and
action sections were reread together. The activity question now asks whether
the native window is reported active, rather than treating that query as proof
of actual key delivery. Jiff 0.2.38's Date source was read further, covering all
public examples from constant through saturating_add. The useful pattern here
is to connect a method's default to observable behavior and include the case
where that behavior changes; it does not establish that all Jiff examples have
been read.

The assembled browser-only list, layout, text, and first-window programs
reached complete Live frames with the unchanged `fe33dbce…` runtime manifest.
The text program displayed its accented Unicode sentence on two lines; layout
kept its fixed pane beside wrapping text. These were execution/render checks,
not edited-source or native-platform checks. Screenshots are
`target/documentation-proof/miri-{list-rebuilt,layout,text,first-window}-c716.png`.

All 232 doctests pass: 225 merged examples and seven executed harness examples,
with one ignored, in `target/documentation-action-fallback-doctests.log`.
The extended standalone editor fixture is one of those executed examples.
Strict default-feature rustdoc passes in
`target/documentation-action-fallback-default-api.log`. The combined artifact
check follows this revision. The
public-surface review remains unfinished, and this batch makes no detector or
framework-wide quality claim. The primary editor worked alone.

## Shadow and filter contracts across the public entry points (2026-10-08)

Revision `d3aa64131e` passed the combined browser-program, strict API, Zola,
mdBook, and link-audit build and was served locally. The rendered predicate
table now gives `Editor || Terminal` exactly two cells. At a 390-pixel CSS
viewport, the ordered frame-phase explanation and window-choice table both
fit the 350-pixel content column. The Save fixture was read in rustdoc and
mdBook, and the canvas constructor's complete visible explanation and example
were read in rustdoc. This does not claim that the wider platform comparison
tables fit without their horizontal scrolling containers.

The primary editor reread the complete testing chapter, canvas and surface
modules, path builder including its tests, quad constructors/builders, and
the window's shadow, filter, and paint-recording paths. The style box's
production paint order, scene filter records and radius reduction, bounded
filter target allocation, relevant scene ordering tests, and the Metal, WGPU,
and DirectX filter dispatch paths were checked together. Shared quad and
shadow shader excerpts were read for border placement and inset clipping;
this is not a complete shader-math or native-renderer execution audit.

The existing Luna scene report recorded the two-level isolation limit, but
the public style and window entry points did not explain it. Their filter
prose also implied successive operations, while all three supplied renderer
paths reduce the list to its largest blur radius. Filter, ScaledFilter,
Styled's four filter methods, both scene filter records, and the window's
shadow/filter methods now describe those actual contracts. The shared drawing
chapter contrasts sharp content over a blurred backdrop with content that is
itself blurred, gives styled and custom-paint examples, defines the offscreen
target, and explains the radius and nesting limits. Layout links that account.

BoxShadow now explains its zero-blur/zero-spread defaults, the opposite effects
of signed spread on outer silhouettes and inset holes, and the two paint
passes. PaintQuad explains its outer bounds, inside borders, unclamped corner
radii, dash defaults, and why setting a fill's border color alone draws no
border. A complete construction example sets both color and width and links
the phase handoff in the custom-element walkthrough. Runtime behavior is
unchanged in this batch.

The browser-only editor compiled a temporary comparison against runtime
manifest `fe33dbce…`. The initial draft omitted the required component
constructor and received a compiler error; after adding it, the comparison
reached Live in 7426 ms and its resized result in 2440 ms. The upper notice
kept sharp text above blurred stripes; the lower notice blurred its text and
box while stripes outside it remained sharp. Source and screenshot are
`target/documentation-proof/filter-comparison-component.rs` and
`target/documentation-proof/browser-miri-filter-comparison.png`.
The canonical drawing program was restored and reached Live again. This
checks those two visual effects through the assembled browser runtime, not
native renderer parity or every nesting case.

The testing chapter linked to main's older four-test example while describing
this checkout's composition tests. The linked editor on main also returned no
marked range or geometry. Input and testing now identify the same-checkout
files and give the exact Cargo command instead of promising those features
in the older source. That command passes all twelve tests in
`target/documentation-native-composition-tests.log`, including the editor's
geometry and UTF-offset fixtures.

All 236 doctests pass: 229 merged examples and seven executed harness examples,
with one ignored, in `target/documentation-paint-quad-doctests.log`.
Strict default-feature rustdoc passes in
`target/documentation-paint-final-default-api.log`. An earlier strict run
caught a test-support-only chapter link and an unqualified Styled link; both
were repaired before that result. Strict feature-enabled rustdoc passes in
`target/documentation-paint-feature-api.log`, and canonical guide mirroring
passes against it. All 27 documentation-tool tests pass in
`target/documentation-paint-generator-tests.log`; the edited Rust files pass
rustfmt, generated examples and backlinks are current, and the diff passes
whitespace checks. The complete combined artifact check follows this source
revision.

Jiff 0.2.38's Date reading now covers every public example before its internal
API block, including differences, reversibility, series, parsing, and lenient
versus fallible formatting. The complete pinned Hummingbird window-chrome
source and excerpts of Zed's painting example were also read. Their usage is
comparative evidence; this checkout defines the contracts. No detector was
run, no subagents were used, and the complete public-surface review remains
unfinished.

## Length choices and rounding boundaries (2026-10-08)

Revision `9e396a0d20` passed the complete strict API, browser-program, Zola,
mdBook, and link-audit build and was promoted to the server on port 1111.
The primary editor read the rendered Filter and ScaledFilter introductions,
variants, and inherent methods; all BoxShadow fields and builders; Styled's
four filter methods; Window's shadow and filter methods, including corner
smoothing, and paint_quad; all PaintQuad fields and builders; both scene filter
records and their radius queries; and the shared depth constant. The actual
Window-to-drawing and input-to-composition-testing links were followed. The
complete blur section was read in rustdoc, mdBook, and Zola. The book's
390-pixel viewport kept the document at 390 pixels and code containers at
350 pixels; temporary viewport overrides were restored. Evidence is in
`target/documentation-proof/9e396a0d20-review-evidence.json`.

A fresh Sapling page accepted four prose paragraphs from the blur section,
without the code examples, and its Check again button was activated. No score
or error appeared in the visible result area. The 1198-character attempt is
recorded in that evidence file and its screenshot; no passing detector result
is claimed. It occurred after the preceding source checkpoint's statement
that no detector had been run.

The next source pass reread the angle and length types, conversions, parsers,
and arithmetic implementations from Radians through Length; the layout
adapter's unit conversions; the window constructor's rem default, rem queries,
base setter, scoped override, and snapping functions; the rounding helpers;
the text-style line-height resolution; and deferred drawing's rem scopes.
The existing layout chapter's length and coordinate sections were read with
those paths. Rust's primary numeric-cast reference was checked for integer
conversion semantics. Jiff's Timestamp::round explanation and all three of
its examples were read, along with Date's arithmetic trait contracts.

Pixels now directs normal callers to pass logical values to window methods
and distinguishes units from coordinate origins. Its finite constants and
integer-conversion account are explicit. ScaledPixels demonstrates the
one-pixel allocation difference between upward rounding and truncation.
DevicePixels explains signed coordinates, unchecked integer conversions,
and packed row-byte sizing without redundant arithmetic comments. Rems shows
the same authored spacing resolved at two text scales, and from_pixels explains
what happens when that scale later changes. Relative distinguishes layout
fractions from Percentage and connects its numeric and parsed forms.

AbsoluteLength now compares the three accepted-length types, demonstrates a
valid rem value and rejected percentage, and links the layout guidance. Its
and DefiniteLength's resolution examples use the public constructor functions
and conversions instead of nested enum constructors. Length explains why auto
has no general conversion to pixels. Window's rem APIs explain the default,
override precedence, redraw ownership, and drawing-phase boundary. pixel_snap
states its halfway-toward-zero rule and contrasts logical rounding at a twofold
display scale. The canonical layout chapter mirrors that distinction in the
book and demonstrates the texture-extent conversion. Four corner-smoothing
method summaries were also rewritten after their rendered reading.

All 240 doctests pass: 233 merged examples and seven executed harness examples,
with one ignored, in `target/documentation-units-doctests.log`. The edited Rust
files pass rustfmt. Strict default-feature rustdoc for core and companion
passes in `target/documentation-units-default-api.log`; generated examples and
backlinks are current, and the diff passes whitespace checks. The complete
combined-artifact check follows this source revision. This batch changes documentation only;
the broader review remains open, and the primary editor worked alone.

## Independent compiler deadlines and stopped-worker recovery (2026-10-08)

The primary editor reviewed export `19162ba3a1230c1949251a1164d18e72eba018da`
against this checkout and its production parent `2ac6e12ac4c20a97dfed85c65b9a7709522a7f28`.
Only the controller, browser client, and browser scheduling regression were
imported. The editable-text history notification change was omitted because
this checkout already emits the required source-change events for Undo/Redo.
No testing-branch merge, interpreter binary, SDK, or asset manifest was imported.

The browser regression was first run against this checkout's original client,
which is identical to the export's production-parent client. It failed because
cancelling a VM input removed the independent warming compiler's deadline.
With the reviewed four-line client change, the complete same scheduling suite
passed, including background expiry retaining the live application. Logs are
`target/documentation-runtime-cancel-before.log` and
`target/documentation-runtime-cancel-after.log`. These are mocked scheduling
tests, not browser timing measurements.

The native controller now releases replies when its worker stops, installs a
replacement for a current-generation failure, and reports the failure rather
than leaving the session pending. Its paused label distinguishes an edited
source from the retained scene, and an obsolete overflow notice is cleared.
All nine native CodePen library tests pass, including the new bounded worker-
panic regression, in `target/documentation-runtime-scheduling-tests.log`.

The target browser bundle received only the matching client file. Its existing
runtime manifest remains `fe33dbceb23f9b069901bb0bb31e724d2712a3deea69d254118cde058f14e896`.
The served site still carries the preceding client until the next complete
artifact build is checked and promoted. Incoming provenance is preserved in
`target/documentation-proof/incoming-browser-scheduling-export-provenance.json`;
its author's broader test results are separate from the checks above.

## Vector paths and the drawing lifecycle (2026-10-08)

Revision `c84a314d04` passed the complete strict API, browser-program, Zola,
mdBook, and link-audit build in `target/documentation-units-site.log` and was
promoted. The primary editor read the rendered length-family introductions,
fields, and inherent methods, and Window's rem and snapping methods. The
Length-to-layout link was followed. The complete new rounding section was
read in the book. Browser review found that its heading separated the
coordinate explanation from its clipping paragraphs, and its table required
scrolling at 390 CSS pixels. This pass moves the heading below those
paragraphs and shortens the table's labels. It also links Percentage to
Relative, clarifies DefiniteLength's property-dependent reference, and
standardizes the length methods' summary verbs. These follow-ups await the
next rendered-artifact check; the preceding review is preserved in
`target/documentation-proof/c84a314d04-review-evidence.json`.

The primary editor reread the complete canvas and path-builder implementations,
all Path and PathVertex methods, Window::paint_path, path insertion into Scene,
the renderer's complete path-record and path-shader modules, the complete
canonical drawing and custom-element programs, the drawing chapter, and the
native custom-drawing primitives module. The pinned lyon SVG builder's
contour and arc paths, its fill/stroke defaults, its ellipse conversion, and
euclid's transform composition were checked. The W3C arc and fill-rule
references were checked. Jiff 0.2.38's Span introduction through its two
day-length examples was read for patterns in explaining similar-looking
operations and their differing results.

PathBuilder now defines contours and connects preparation, window-local
placement, and painting. Every inherent method was checked in context.
The documentation explains endpoint-first curve arguments, absolute versus
relative arc endpoints, degree units, clockwise sweep, closed joins versus
separate caps, fill rules, style replacement, and transform call order.
Examples demonstrate nested same-direction contours, a valid dashed line
and an invalid empty pattern, a quadratic curve, an upper semicircle, and a
scaled then translated triangle. The arc example checks its upper extent;
the transform example checks resulting bounds.

Path now distinguishes its low-level triangle/fan helpers from general vector
tessellation. Its ownership, clone cost, bounds maintenance, paint-time
replacement of metadata, and display scaling are explicit. push_triangle
demonstrates filled shader coordinates and the resulting vertex count and
bounds. Window::paint_path explains that element-offset scopes do not move
arbitrary vertices. The canonical drawing chapter carries the shared guidance
into the site and book, including which changes invalidate prepared geometry.
The native example's claim that it caches geometry was removed: it builds
paths in its paint callback.

All 246 core doctests pass: 239 merged examples and seven harness examples,
with one ignored, in `target/documentation-paths-doctests.log`. The four edited
core Rust files pass rustfmt, and the diff passes whitespace checks. Strict
default-feature rustdoc for core and companion passes in
`target/documentation-paths-default-api.log`; generated examples and backlinks
are current. The complete combined artifact is the remaining build check for
this batch. This is a manual source pass without subagents or scripted prose
replacement; the complete public-surface review remains open.

## Keep a full input batch within the protocol limit (2026-10-08)

The primary editor reviewed the one-file follow-up
`852b7060bb21eddf69602b1d99d21f4e3cf95415` against Session::request,
PreviewContext::validate, the controller's input queue, and its accepted-reply
follow-up scheduling. A captured first event can be accompanied by 128 queued
events before the request task runs. Draining the whole queue produced 129
events, exceeding the protocol limit.

The imported headless-controller regression, with formatting adjusted locally,
failed against this checkout's original drain with actual 129 versus expected
128. Reserving room for the captured event makes the first request validate
and leaves one event for the existing follow-up request. All ten native
CodePen library tests then pass. Logs are
`target/documentation-input-boundary-before.log` and
`target/documentation-input-boundary-after.log`; incoming provenance is in
`target/documentation-proof/incoming-bounded-input-export-provenance.json`.
This imports no batching delay or interpreter/SDK experiment and makes no
claim that Miri frame throughput has improved.
