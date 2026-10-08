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
| Shared conceptual chapters | Ownership, rendering, layout, animation, text, drawing, assets, input, scheduling, accessibility, testing, and platforms mirrored into mdBook; search paste, clipboard contents, keyboard contents toggle, and actual automatic reload checked | Final contextual edit and combined-artifact checks, including responsive layout and theme contrast |
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
