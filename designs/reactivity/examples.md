# Typed Incremental API Examples

> **Historical (03-era).** The `Scope`/`State<T>`/`ListDelta` spellings below are superseded by
> [07-the-ladder.md](07-the-ladder.md); current worked examples live in 07 §5/§11. Kept for the
> record of how the design evolved — do not learn the API from this file.

These are normative API/semantic sketches for the architecture in
[03-hybrid-plan.md](03-hybrid-plan.md). They are deliberately small enough to expose the cost
model. They are not source-compatible with current GPUI yet.

The point is not to make application types carry a graph in their generic parameters. The public
types are shallow; generated schema and sealed retained ports put the useful, stable facts into
types and code generation while dynamic facts remain checked at runtime.

## 1. Simple: a settings counter is a direct typed patch

The old immediate-style spelling threads a context through allocation, reads, and writes:

```rust,ignore
fn settings(cx: &mut Context<Self>) -> impl IntoElement {
    let count = cx.state(0_u64);
    button(count.read(cx)).on_click(move |_, cx| count.update(cx, |n| *n += 1))
}
```

The retained API makes field handles inert, copyable generational keys. They can be passed through
builders and captured freely; only mounting, reading, and writing receive an access capability:

```rust
#[derive(Reactive)] // generates an inferred handle with typed fields; no public field enum
struct Settings {
    count: u64,
    accent: Color,
    sidebar_width: Pixels,
}

fn settings(scope: &mut Scope<'_>) -> impl IntoElement {
    let settings = scope.model(Settings {
        count: 0,
        accent: rgb(0x3b_82_f6),
        sidebar_width: px(280.0),
    });

    div()
        .w(settings.sidebar_width)          // State<Pixels> -> typed layout port
        .bg(settings.accent)                // State<Color> -> typed paint port
        // `text!` lowers the static segment to a constant and the argument to the sealed decimal
        // formatting circuit (inline itoa-style, no heap allocation for short output). An
        // arbitrary `map(f)` would instead be a static-edge computed node because Rust cannot
        // prove `f` pure. Fixed containment is intentional in this benchmark fixture: new text is
        // reshaped, but its intrinsic size cannot change the surrounding Taffy layout.
        .child(text!("Count: {}", settings.count)
            .single_line()
            .fixed_size(size(px(128.0), px(20.0)))
            .overflow_clip())
        // An inert #[must_use] mutation descriptor: no event closure, no nested edit closure.
        // The closure forms remain available: `.on_click(|update| ...)` and
        // `.on_click(|update, click| ...)`.
        .child(button("+").on_click(settings.count.add(1)))
}
```

Conceptually the derive emits this hidden/inferred shape (plus schema metadata):

```rust,ignore
#[derive(Copy, Clone)]
struct SettingsState {
    _group: private::GroupKey<Settings>,
    count: State<u64>,
    accent: State<Color>,
    sidebar_width: State<Pixels>,
}
```

There is no `SettingsFields::count`, no projection call, and no `clone()`. Reusing
`settings.count` is an integer-key copy and does not duplicate storage or a subscription.

For an arbitrary, branch-dependent computation the dependency-recording authority is explicit
instead of being discovered through thread-local ambient state:

```rust
let label = scope.memo(move |read| {
    if read.get(settings.count) == 0 {
        "Ready".into()
    } else {
        read.get(settings.accent).to_string().into()
    }
});
```

`read.get(state)` is the only operation that records an arbitrary dynamic edge. An event reads with
`update.get(state)`; mount-time frozen configuration reads with `scope.initial(state)`. A bare
`State<T>` has no dereference method. This makes graph expansion and actual data access visible,
while direct field ports and sealed framework circuits
avoid general graph/effect allocations after warm-up. Their value operation may still allocate
when the semantic output requires owned storage (for example, a non-inline formatted string). A public `map(user_fn)` may be convenient,
but it lowers as a static-edge computed node and is not entitled to the sealed-circuit gate.

The framework-generated port is conceptually, but not publicly, equivalent to:

```rust
Port::<DivProps, Pixels, LayoutThenPaint>::WIDTH
Port::<DivProps, Color, Paint>::BACKGROUND
Port::<TextProps, SharedString, TextShapeThenMaybeLayout>::CONTENT
```

At mount, `settings.count` lowers to a source revision plus its generated field id; the sealed decimal
format circuit may lower to a monomorphic patch thunk. `accent` and `width` are direct
sinks. After retained slab capacity has grown, a direct field binding has a performance
target of **zero per-binding heap allocations**; this is measured rather than assumed.

For the `count += 1` event, the intended trace is:

```text
Settings.count revision +1
  -> generated field id for `Settings.count` only
  -> fused decimal-format / TextProps::content port
  -> TextShape(changed text) + Paint(text fragment)
  -> old/new text ink damage + retained renderer packet delta
```

`accent` and `sidebar_width` do not run. Text content normally has a conditional intrinsic-size
obligation; this fixture's explicit fixed box resolves it to reshape+paint without Taffy layout.
Removing that containment must deliberately exercise and count the layout path. Counters for the
contained fixture must show `static_circuit_evals=1`, `sink_patches=1`,
`dynamic_computed_runs=0`,
`layout_nodes_visited=0`, no component reinvocation, and exactly the expected text/fragment/damage
work. A width mutation instead proves the metadata path: one direct sink, a `LayoutThenPaint`
obligation, then only the true layout dependency closure.

### Misuses that are compile errors

```rust,compile_fail
fn write_count(update: &mut Update<'_>, state: &State<u64>) {
    update.edit(*state, |n| *n = 3);
}

fn measure_bad(layout: &mut LayoutCx<'_>, state: &State<u64>) {
    write_count(layout, state); // error: expected `Update`, found `LayoutCx`
}

fn paint_bad(paint: &mut PaintCx<'_>, state: &State<u64>) {
    write_count(paint, state); // error: expected `Update`, found `PaintCx`
}

fn wrong_port(color: State<Color>) {
    div().w(color); // error: `w` requires `Property<Pixels>`
}

fn no_ambient_read(state: State<u64>) {
    let _ = state.get(); // error: `State` is a key; use `update.get` or `scope.initial`
}

fn interactive_positional_row() {
    positional(labels, |label, item_scope| {
        row(label).drag(label) // error: `ItemScope` has no drag/focus/local-state capability
    });
}

fn contradictory_motion() {
    animate(open.select(1.0, 0.0)).spring(Spring::snappy()).ease(Ease::OutCubic);
    // error: no method `ease` on `Motion<Sprung>`; easing belongs to `.over(...)` timelines
}
```

Rust also proves that a `State<T>` cannot cross threads. A one-way builder accepts any sealed
`Property<T>`, while a two-way method such as `bind_checked` accepts exactly `State<bool>`; there is
no separately paired read/write handle. The generated schema proves that `settings.count` is a real
field with the correct value type and that a port has reviewed obligation metadata. It does
**not** prove a retained node remains alive, that equality/classification code does not panic, or
that a backend can fulfill a composite-only request; those are diagnosed/fallback runtime cases.
Capturing a key in a forbidden callback is harmless because that callback has no capability that can
resolve it.

An arbitrary whole-model closure deliberately sacrifices precision:

```rust
update.edit_all(settings, |s| unknown_helper(s)); // only if Settings declares a draft policy
// Emits `ModelDelta::Wildcard`; all generated field consumers are conservatively invalidated.
```

`Update::edit` mutates an isolated draft and publishes only after normal return. A panic discards it;
committed state and the retained frame remain untouched. Exact generated field edits journal that
field; model drafts publish `Wildcard`—the `_all` suffix names that cost at the call site. A type
without a rollback-capable aggregate draft policy supports `update.replace(model, replacement)` and
typed deltas, not arbitrary in-place edit. Unsafe user claims of mutation precision are not accepted.

## 2. Complex: an editor workspace with exact deltas and protocol types

```rust
#[derive(Reactive)]
struct WorkspaceModel {
    active_file: Option<FileId>,
    palette: ThemePalette,
    zoom: f32,
}

#[derive(Reactive)]
struct FileRow {
    name: SharedString,
    modified: bool,
    diagnostics: u32,
}

fn workspace(scope: &mut Scope<'_>) -> impl IntoElement {
    let workspace = scope.model(load_workspace());
    let files: KeyedList<FileId, FileRow> = scope.keyed_list();
    let document: TextDocument = scope.text_document(); // rope + revisioned EditDelta stream
    // `document` has a sealed freeze-to-DocumentSnapshot implementation. `index_document` is an
    // ordinary `fn(DocumentSnapshot) -> Result<Index, IndexError>` and is trivial to unit-test.
    // The inferred `Work<Index, IndexError>` handle refers to runtime-owned value/pending/error
    // cells, cancellation, owner epoch, revisions, scheduling, and stale-result rejection.
    let index = scope.compute(document, index_document);

    split_pane()
        .theme_palette(workspace.palette) // copyable key; token indirection, not 10k closures
        .child(
            list(files.view(), move |file, _row_scope| {
                    let row = files.row(file);
                    button(row.name)
                        .selected(workspace.active_file.eq(file)) // sealed static circuit
                        .badge(row.diagnostics)
                })
                .virtualize(px(24.0))
                .semantics(file_semantics)
        )
        .child(
            show(workspace.active_file.is_some(), move || {
                text_editor(document)
                    .zoom(workspace.zoom)
                    .ime_protocol(TextProtocol::<Utf16CodeUnits, Revisioned>::required())
                    .selection_units(Utf16CodeUnits)
                    .scene_fragment_mode(FragmentMode::StableGlyphRanges)
            })
            .fallback(|| empty_editor())
        )
        .child(minimap().palette(workspace.palette).animate(workspace.zoom))
        .child(index_panel(index))
}
```

The removed spelling is worth making explicit:

```rust,ignore
let tx = scope.sender(index_results);
let snapshot = scope.snapshot(document, make_index_input);
scope.worker().spawn(move || tx.send(index(snapshot)));
```

That version states one dependency edge four times and permits destination/revision/owner policy to
drift apart. `scope.compute(source, ordinary_fn)` installs one typed work edge. A source implements a
sealed freeze protocol (for example, `TextDocument -> DocumentSnapshot` or
`State<Arc<T>> -> Arc<T>`); tuples compose. Only the values actually crossing to a worker require
owned `Send + 'static` input,
never a local state key. A newer source revision is latest-wins by default; reliable event-triggered
work is spelled `scope.action(function)` instead. Dropping the owner revokes delivery and cancels
queued work, while already-running CPU code may finish and have its result discarded. Cooperative
CPU cancellation is an explicit token-taking API; ordinary functions are never falsely called
preemptible.

This is not a claim that background work is free. One mounted work edge still needs an owner/task
record, executor task (normally allocated), frozen/retained input, output/status storage if observed,
queue/wake synchronization, and revision/cancellation checks. The target is **zero user-managed
transport declarations and no additional steady-state work versus an equivalent hand-written path**;
the fused runtime record still contains the necessary transport state.
Allocation, retained bytes, freeze cost, wakes, and completion latency are compared directly in the
performance matrix. True streams/progress/services, dedicated realtime work, blocking foreign calls,
and framework-internal frame-parallel stages retain specialized APIs.

`Work<T, E>` is a concrete copyable handle whose generic arguments are normally inferred, not an
opaque `impl Trait` pretending to expose fields. Its `value()`, `pending()`, and `error()` methods
return opaque read-only properties; product code cannot obtain writable `State` keys for the
runtime-owned status. A load-state destination may instead consume the handle directly, as
`index_panel(index)` does above. This costs no wrapper allocation: the handle is a generational key,
while the irreducible task and result state lives in the one mounted work record.

The list's **structural** lane is `ListDelta<FileId>` (`Insert`, `Remove`, `Move`, `Reset`); its
resident-value lane is `FieldDelta<FileRow>` (`key`, exact field mask, revision). Editing a file
name does not scan or remount other rows. A filter/sort key update does the explicitly documented
index/order work. The document emits `TextEditDelta` with UTF-8 rope ranges, UTF-16 IME mappings,
and source/target revisions; it is not a `State<String>` replacement.

The type-level configuration prevents several expensive protocol mistakes before runtime:

```rust,compile_fail
list(files.view(), row_view).virtualize(extent);
// error: a virtualized interactive list requires a semantic provider

text_editor().selection_units(GraphemeClusters).ime_protocol(
    TextProtocol::<Utf16CodeUnits, Revisioned>::required(),
);
// error: platform IME and selection range units disagree
```

The generated schema proves field names/types and the sealed requirements builder proves that a
virtualized interactive list supplied identity and semantic materialization policy. Rust proves
that `TextProtocol<Utf16CodeUnits, Revisioned>` cannot be passed to a UTF-8-only platform adapter,
that `scope.compute(document, index_document)` can freeze only the sealed owned input required by
`index_document: fn(DocumentSnapshot) -> _`; neither a local key nor graph borrow can cross. It does
not prove a platform screen reader accepts the requested virtual
materialization, a row key is unique at runtime, or an external text edit can be transformed through an
active composition; those are runtime contracts with precise errors/fallbacks.

On a palette update with 10,000 users, token indirection updates only changed palette entries and
the indexed consumers of each entry; an opacity change can promote a token from paint-only to a
composite/isolated-layer class, and that promotion is counted. Active animations occupy dense,
kind-segregated vectorized lanes (`paint`, `transform/opacity`, `layout`, `structural`), not one
dynamic computed closure per property. The editor's frame therefore separates:

```text
write-incapable tracked computations -> structural/list/text draft -> properties introduced
-> compact direct/field/sealed-circuit sinks -> atomic logical publication -> after-publication effects
-> sparse presentation draft -> style -> layout -> sealed geometry feedback -> bounded relayout
-> hit/a11y/prepaint/paint/composite -> atomic interaction/presentation publication
```

Stable glyph-range slots and dirty GPU buffer ranges are a later backend tier. They let a small
edit replace affected glyph-instance ranges and damage the corresponding spatial tiles, while the
submitted packet pins old versions until its fence retires. If the renderer stalls, pinned bytes
are bounded; the runtime coalesces/reduces packets or conservatively falls back to a full-scene
contiguous packet rather than mutate data still used by the GPU.

## 3. Drag and drop: types remove protocol code instead of adding it

A drag protocol spans unrelated pointer, keyboard, accessibility, window, async, and teardown
events. Stable Rust cannot honestly keep a public `Dragging<'session>` typestate alive through all
of them. The retained runtime owns that state machine; the type system establishes payload and
collection compatibility at its entry points.

```rust
#[derive(Copy, Clone, Eq, PartialEq, Hash)]
struct ColumnId(u64);

#[derive(Copy, Clone, Eq, PartialEq, Hash)]
struct CardId(u64);

#[derive(Reactive)]
struct Card {
    title: SharedString,
    locked: bool,
}

fn kanban(scope: &mut Scope<'_>) -> impl IntoElement {
    // Fields are contiguous direct cells; membership/order is a sum-tree lane.
    let cards = scope.grouped_list::<ColumnId, CardId, Card>(load_board());

    h_stack().children_keyed(cards.groups(), move |column| {
        let lane = cards.in_group(column); // Copy: collection id + group key

        list(lane, move |card, _row_scope| {
                card_row(card.title)
                    .enabled(card.locked.not())
                    .opacity(card.is_dragging().select(0.45, 1.0))
                    .drag(card)
                    .drag_preview(move || card_ghost(card.title))
            })
        .virtualize(Extent::measured(px(44.0)))
        .semantics(card_semantics)
        .drop_zone(lane)
    })
}
```

There is no public drag session object, cloned domain payload, source index, target index, pointer-capture token,
portal handle, or drop callback. `card` is an inferred copyable bundle containing the collection/
row identity and direct field keys; it does not contain `Card`. `lane` identifies the same grouped
collection and a stable `ColumnId`. The two destination methods install one retained drag route.

On commit, that route validates source/target owner epochs, `CardId`, `ColumnId`, and both order
revisions, then applies one typed list delta. Same-lane reorder adjusts around removal; cross-lane
move preserves application/collection-owned row state; window/node/platform-local state remounts on
a cross-window handoff. A stale target uses the collection's declared rebase-or-reject policy for
unvalidated local moves. Public code never manipulates `usize`, so it cannot accidentally apply an
old visual index to a new order.

The protocol also owns behavior that callback examples usually omit:

- threshold crossing acquires platform pointer capture; Escape, release, window loss, and owner
  teardown perform exactly one cancellation;
- the preview is a mount-owned overlay portal while logical/a11y ownership stays with the card;
- active and pending source/target rows are virtualization-pinned;
- Space/Enter picks up, arrows choose a key-relative landing position, Enter commits, Escape
  cancels, and semantic announcements reuse the card label and set position;
- app-owned collections can cross windows on the same UI executor: the preview remounts in the new
  surface and the retained row moves by state handoff, never by migrating a node/arena reference;
- OS/external or cross-process drag is a separate serialized file/text protocol, not falsely typed
  as an in-process payload.

An asynchronous business rule adds one ordinary function at the destination:

```rust
async fn may_move(request: MoveRequest<ColumnId, CardId>) -> Result<(), MoveDenied> {
    permissions_service().check(request).await
}

// Same UI above, with one policy addition:
list(/* ... */)
    .virtualize(extent)
    .drop_zone(lane)
    .validate(may_move)
```

`MoveRequest` is owned worker input: card/group keys, exact key-relative landing operation,
source/target order revisions, drag/request generation, request fingerprint, and permission epoch—not
a UI key or `Update`. The retained drop route uses the same work-edge machinery as
`scope.resource`: pending state releases platform pointer capture but retains the rows/preview under
a bounded timeout; Escape, teardown, deletion, or a newer drag cancels that request. Completion must
match every epoch/revision/fingerprint and revalidate draggable/locked state before opening an
internal update. A changed operation is rejected or validated again; it is never silently rebased
under an authorization granted for different inputs unless the returned permit explicitly authorizes
key-relative rebasing. Product code does not build a sender, task, or completion bridge.

The useful compile-time failures are at real boundaries:

```rust,compile_fail
// Card lanes accept this collection/group/card family, not another keyed list family.
card_list.drop_zone(task_lane);

// A raw domain value is not retained drag identity; use the keyed row bundle.
card_row(title).drag(Card { title, locked: false });

// Order mutation requires the retained route's internal Update or an explicit application Update.
cards.move_before(card, target); // missing `&mut Update`

// A local collection/key cannot cross to validation work; MoveRequest is the owned boundary.
scope.compute(cards, validate_cards);
```

Two different live collections with identical `ColumnId/CardId/Card` types are distinguishable only
by generational collection id, so mixing them remains a located runtime error unless the application
introduces different newtype ids. Key uniqueness, owner liveness, current order, platform capture,
authorization freshness, and cross-window platform support are likewise runtime facts. The types
eliminate payload/value/unit mismatches and mutation authority mistakes; the retained state machine
handles time.

## 4. Arbitrary placement, motion, shaders, and tests are one system

The same retained contracts cover a shader-backed editor overlay without dropping into a separate
UI model:

```rust,ignore
#[derive(Canvas)]
struct Spectrum {
    samples: AudioSamples,
    cursor: Timecode,
    accent: Color,
}

#[gpu_shader(path = "shaders/spectrum.wgsl")]
struct SpectrumShader {
    #[uniform]
    accent: Color,
    #[storage(read_only)]
    samples: GpuBuffer<Sample>,
}

fn audio_editor(scope: &mut Scope<'_>) -> impl IntoElement {
    let editor = scope.model(load_editor());
    let timeline_geometry = scope.anchor();
    let timeline = canvas("spectrum", Spectrum {
        samples: editor.samples,
        cursor: editor.cursor,
        accent: editor.accent,
    })
    .as_anchor(timeline_geometry)
    .shader(SpectrumShader::default())
    .role(Role::Image)
    .accessible_name("Audio spectrum");

    stack()
        .child(timeline)
        .child(
            playhead()
                .test_id("playhead")
                .place_in(timeline_geometry)
                .x(editor.cursor.normalized())
                .height_like(timeline_geometry)
                .opacity(animate(editor.playing.select(1.0, 0.55))
                    .over(ms(120))
                    .ease(Ease::OutCubic)),
        )
        .child(
            tooltip(editor.hover_label)
                .place_above(editor.hover_geometry)
                .flip_or_slide_within(surface_safe_area())
                .opacity(animate(editor.hovered.select(1.0, 0.0))
                    .spring(Spring::snappy().preserve_velocity())),
        )
}
```

`place_in`, `place_above`, `height_like`, and collision fallback lower to retained placement edges.
They can refer to unrelated nodes because geometry is a separate presentation graph, but cannot feed
ordinary intrinsic measurement and accidentally form a global layout cycle. Scroll, transform,
scale, clip, hit testing, and accessibility bounds use the same published geometry revision.

The animation descriptors are mount blueprints. Their active records live in dense typed lanes,
sample one injected monotonic clock, and patch the opacity/placement/uniform destination directly;
they neither write source state nor allocate a dynamic computation each frame. Interruption samples
the presented value first. The spectrum retains its scene/pass/buffer ranges; an accent edit patches
one typed uniform, and a sample delta uploads only its declared range. Static WGSL mismatch is a
compile error; invalid hot reload keeps the previous pipeline and appears in the inspector.

An integration test uses the same retained semantic, hit, clock, animation, work, and presentation
machinery as the application:

```rust,ignore
#[ui_test]
fn scrub_and_inspect(test: &mut UiTest) {
    test.clock().freeze();
    test.mount(audio_editor_fixture());

    let timeline = test.get_by_role(Role::Image, "Audio spectrum");
    timeline.drag_from(0.25, 0.5).to(0.75, 0.5);
    test.settle();
    test.clock().advance(ms(120));
    test.present();

    timeline.expect().receives_events().has_bounds(rect_fixture("spectrum"));
    test.get_by_test_id("playhead").expect().relative_x_near(0.75, 0.01);
    test.expect_a11y_tree("audio-editor-scrubbed");
    test.expect_scene("audio-editor-scrubbed");
    test.expect_image("audio-editor-scrubbed");
    test.trace().expect_no(LayoutReason::UnrelatedSubtree);
}
```

The locator re-resolves at use time and the drag must pass real visibility, stability, enabled, hit,
and event-receiving checks. `settle()` drains finite logical/presentation work but never advances an
animation or waits forever for a stream; time and background completions are controlled explicitly.
The inspector and test failure report consume the same immutable `UiSnapshot`, so node picking,
box/constraint inspection, accessibility, event routes, property provenance, animation tracks,
shader diagnostics, damage, and “why changed?” cannot disagree with the assertions.

## 5. Images and video: source changes, the destination does not

Common sources occupy the same ordinary argument position. There is no cache object, task poll,
`Arc<RenderImage>`, source enum match, platform surface, sender, or apply callback:

```rust,ignore
fn gallery(local_path: PathBuf, avatar_url: Url, http: &HttpClient) -> impl IntoElement {
    row()
        .child(image(asset!("gallery/cover.avif")))
        .child(image(local_path))
        .child(image(http.get(avatar_url).header(ACCEPT, "image/avif,image/webp,*/*")))
}
```

Those inputs differ only during acquisition. Once bytes arrive, they share format detection,
metadata, scale/color/orientation variants, decoding, renderer residency, damage, budgets and
inspection. A custom authenticated/content-addressed store remains equally small at the call site:

```rust,ignore
fn profile(scope: &mut Scope<'_>, avatars: AvatarStore) -> impl IntoElement {
    let user = scope.model(load_user());

    image(scope.media(avatars, user.avatar_id))
        .fit(ObjectFit::Cover)
        .placeholder(asset!("avatar-placeholder.svg"))
        .on_error(asset!("avatar-error.svg"))
        .accessible_name(user.display_name)
}
```

The provider implements acquisition once; `scope.media` installs its reactive request recipe and
the image owns its loading/error/presentation subscription. Changing `avatar_id` cancels or
supersedes the old generation. The type system guarantees source kind and provider request/error
types; owner liveness, network ordering, content identity, cache freshness and renderer capability
remain stamped runtime facts.

Video uses the same rule and does not expose decoded frame ownership:

```rust,ignore
fn trailer(scope: &mut Scope<'_>, http: &HttpClient, movie: Url) -> impl IntoElement {
    let controls = scope.model(Playback::default());

    video(http.get(movie).bearer_auth(session_token()))
        .fit(ObjectFit::Contain)
        .playing(controls.playing)
        .position(controls.position)
        .volume(controls.volume)
        .poster(asset!("trailer-poster.avif"))
        .captions(asset!("trailer-captions.vtt"))
}
```

Here `playing`, `position`, and `volume` are destination-owned editable controls, using the same
direct typed state keys as text fields; there is no second `bind_video` object. Internally, a seek
changes the seek generation, bounded decode chooses frames by the injected media clock, and the
renderer either imports native planes or records a counted fallback. A test controls the whole
pipeline without sleeping:

```rust,ignore
#[ui_test]
fn video_seek_rejects_the_old_frame(test: &mut UiTest) {
    let media = test.media().script("trailer", fixture("trailer-nv12.media"));
    test.mount(trailer_fixture(media.request()));

    test.get_by_role(Role::Slider, "Playback position").set_value(seconds(42));
    media.complete_old_seek_frame(seconds(3));
    media.complete_frame(seconds(42));
    test.clock().advance(ms(16));
    test.present();

    test.get_by_role(Role::Video, "Trailer").expect().frame_at(seconds(42));
    test.expect_trace().contains(MediaEvent::StaleSeekRejected);
    test.expect_trace().contains(MediaImport::NativePlanes { cpu_copies: 0 });
}
```

The native-import assertion is capability-fixture-specific. Portable tests assert the selected
frame, crop/color plan and declared fallback, not a fictional universal zero-copy guarantee.

## What these examples prove—and do not

They prove that important behavior can be encoded without forcing a type-level dependency graph:
source/destination type compatibility, exact generated model fields, reviewed obligation classes,
phase capability, protocol/unit compatibility, and thread ownership are compile-time facts. They
also specify a fast lowering that a benchmark can falsify. Dynamic ownership, keys, dependency
edges, user code purity, equality/classifier panics, renderer capabilities, and work budgets remain
runtime-validated by design. That boundary is what keeps the API usable on stable Rust.

Several of these compile-time facts map one-to-one onto named, currently-unsolved runtime bug
classes in the web ecosystem, and are claimed as such rather than as generic type-safety:

- the TC39 signals proposal must *document* “do not read or write signals inside a watcher
  callback”; the phase capabilities make that class of misuse a missing method, not a rule;
- `Send`-bounded work inputs replace the worker `DataCloneError`—a purely runtime failure in every
  JS app using workers—with a signature error;
- typed text units (`Utf16CodeUnits` vs UTF-8 ranges) address the surrogate-pair cursor/selection
  bug class that recurs in CodeMirror/Monaco/ProseMirror trackers;
- the sealed `LayoutCell` feedback loop removes the failure mode browsers report as the
  “ResizeObserver loop limit exceeded” error;
- `#[gpu_shader]` typed bind layouts replace the stringly uniform lookups that fail at draw time in
  Three.js/regl/raw WebGPU;
- a virtualized interactive list without a semantic provider does not compile, where JS
  virtualization libraries leave ARIA wiring to the caller and audits routinely find it missing;
- `list` is keyed by construction, so React's index-as-`key` silent misbehavior has no spelling;
  and drag/drop compatibility is collection-family-typed where JS DnD libraries match string tags
  at drop time.
