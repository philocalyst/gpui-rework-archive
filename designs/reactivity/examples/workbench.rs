//! Workbench — the pressure test, consolidated (13-composition.md).
//!
//! This file merges three earlier drafts, kept only in git history now:
//!   - `async_workbench.rs` — the original end-to-end pressure test (identity records, per-phase
//!     `DisplayPipeline`, `SurfacePhases` sextuple, `RuntimeSet` threading);
//!   - `async_workbench_lite.rs` — 12-example-review.md's ceremony pass over the same test;
//!   - `workbench_composed.rs` — 13-composition.md's composition pass, which is the shape this
//!     file is based on.
//!
//! What the composition pass removed, and where the burden went (13 §§1–4):
//!   - no `ItemInstanceId`, `StoredItem`, `ItemKind`, locator/state records, or `ItemCatalog`
//!     → structural journaling; identity lives in the journal, never in app types (13 §1)
//!   - no separate `open` vs `restore` factories → one constructor path; restoring sources
//!     re-arms every declared producer (13 §1.2)
//!   - no `DisplayPipeline` fields, `ViewportSpec`, `.snapshot()` threading, or `SurfacePhases`
//!     → `code(…)`'s mount owns the projection; the minimap is a second mount (13 §2)
//!   - no `Layer` trait, no `layers()`/`.overlay()` split, no `cx.quad` vocabulary → marks are
//!     elements, geometry is an inherited source, placement is a value (13 §3)
//!   - no `Effects`, no `RuntimeSet` threading through constructors, no epoch fields, no `if_`
//!     (11/12, carried forward)
//!
//! Still here, because it is semantics and not ceremony: request stamps and admission (07 §7.5),
//! cohort coherence, boundaries, the presence protocol (received/transport_lost/admission — that
//! code was never ceremony), and typed targets/slots at the seams where the app genuinely decides
//! something. The test module below carries forward the richest assertions from the original
//! pressure test — the §7.0 wake law, A→B→A stale-completion rejection, presence resync across a
//! leader/incarnation change, a true weak-cycle teardown, and durable-vs-live identity — recast
//! against the journal model instead of `StoredItem`/`ItemCatalog`.
//!
//! Two latent bugs in the composition-pass draft are fixed here rather than carried forward:
//! `Editor::view` called `self.presence()` and `self.focus_target()`, neither of which `Editor`
//! had a field or method for. Presence and the editor's focus target are owned by `Workbench`,
//! not `Editor`, so they cross the component boundary as arguments — `Tab`/`Editor` grow a
//! `view_with(&self, …)` method instead of a zero-argument `View::view` (11 §13's "methods are
//! views" law is exactly for this: a child that needs per-frame data from its parent that isn't
//! itself a source).

use gpui::prelude::*;

// ════════════════════════════════════════════════════════════════════════════════════════════
// State. Every field is a SOURCE (13 §5.1). Persistence is plain serde — no GPUI trait, no GPUI
// derive (13 §1.2). GPUI's containers implement Serialize/Deserialize; the journal is a serde
// format with an identity side channel, so this exact state tree also exports to JSON for a bug
// report or a test fixture. The field law is closed (14 §4, 18 §5's final surface): a field is
// data, a source, a `Handoff<T>` cell, or `Target<K>` — two different kinds of "not quite data,"
// and it matters which: `Target<K>` serializes like `PhantomData` (unit out, fresh mint in on
// restore — it names a SLOT, not a value), while `Handoff<T>` is journaled STATE (18 §2 point 1)
// — a value given but not yet taken survives the exact same round trip as `text: Signal<String>`
// would. Both still need no `#[serde(skip)]` anywhere on this struct or on any variant of `Tab`;
// they just need it for different reasons.
// ════════════════════════════════════════════════════════════════════════════════════════════

#[derive(Serialize, Deserialize)]
struct Workbench {
    project: Entity<Project>,
    tabs: List<Tab>,
    active: Selected<Tab>,            // Signal<Option<Slot<Tab>>>; the journal remaps the slot
    // `Target<K>` serializes like `PhantomData` (14 §4): unit out, fresh mint in on restore — no
    // `#[serde(skip)]` anywhere on this struct, and the derive below just works.
    editor_focus: Target<TextInput>,
    presence: Entity<PresenceSession>,
}

/// A closed set of item types is an enum, matched exhaustively — not a catalog (13 §1.3).
/// Plugins that add open-ended kinds cross the §9.2 protocol; this app loads none.
#[derive(Serialize, Deserialize)]
enum Tab {
    Editor(Editor),
    Terminal(Terminal),
}

impl Tab {
    fn title(&self) -> &str {
        match self {
            Tab::Editor(editor) => editor.document.file_name(),
            Tab::Terminal(terminal) => &terminal.title,
        }
    }

    // NOTE: 07/11/12/13 define `is_pending` over `impl Source`, but don't say how a hand-rolled
    // enum of heterogeneous items opts in (that machinery belonged to the deleted `ItemCatalog`).
    // Smallest spelling: a plain bool method per variant, passed to `.pending(…)` the same way
    // any `Prop<bool>` would be — no blanket `Source` impl invented for `Tab`.
    fn is_loading(&self) -> bool {
        match self {
            Tab::Editor(editor) => is_pending(&editor.document),
            Tab::Terminal(_) => false,
        }
    }

    /// Methods are views (11 §13): `Tab` has no per-frame data of its own to receive, but its
    /// `Editor` variant does (presence, the shared focus target) — arguments neither variant
    /// stores as a field, because they belong to `Workbench`. Both arms are already the same
    /// nominal `El<'a>` (`Editor::view_with` below, `Terminal::view` via `View`), so they unify
    /// with zero ceremony — no `el(…)` join, no `.any()`, no box, no erasure (14 §1.2/§1.3).
    fn view_with<'a>(&'a self, presence: &'a Signal<PresenceSnapshot>, focus: Target<TextInput>) -> El<'a> {
        match self {
            Tab::Editor(editor) => editor.view_with(presence, focus),
            Tab::Terminal(terminal) => terminal.view(),
        }
    }

    fn apply_remote_selection(&mut self, selection: RemoteSelection) {
        if let Tab::Editor(editor) = self {
            *editor.selection = selection.into();
        }
    }
}

#[derive(Serialize, Deserialize)]
struct Editor {
    /// The document entity: shared, journaled by reference into the project's document set.
    document: Entity<Document>,
    /// View-local sources. Anchors, not offsets — they rebase across edits (07 §15.4).
    selection: Signal<Selections>,
    scroll: Signal<ScrollAnchor>,
    folds: Signal<FoldSet>,
}

impl Editor {
    /// The ONLY constructor. Cold start, session restore, and collaborative acquisition all
    /// come through here, because the async work is declared FROM the sources: `documents.open`
    /// returns the entity immediately and its content producer arms on the installed I/O lane.
    /// On restore, every editor's producer arms in the same turn — parallel fetch-high restore
    /// is §7.3 behaving normally, not a workspace feature (13 §1.2).
    fn open(project: &Entity<Project>, path: PathBuf) -> Self {
        Self {
            document: project.documents.open(path),
            selection: Signal::new(Selections::caret_at_start()),
            scroll: Signal::new(ScrollAnchor::top()),
            folds: Signal::new(FoldSet::none()),
        }
    }

    /// `code(…)` owns its display projection at the mount: transform stack, async wrap,
    /// provisional snapshots, coherent admission — configured, never constructed (13 §2). Wrap
    /// width comes from this element's own laid-out box. There is ONE child verb; decorations,
    /// the minimap, everything stacks in document order inside this surface's stacking context,
    /// and placement values say where (13 §3.3).
    /// Branched over by `Tab::view_with` above (joined against `Terminal::view()` in a `match`),
    /// so this returns the branch-friendly `El<'a>` rather than the leaf `impl Element` (14 §1.2)
    /// — not because the surface is large, but because a caller unifies it with another view.
    fn view_with<'a>(&'a self, presence: &'a Signal<PresenceSnapshot>, focus: Target<TextInput>) -> El<'a> {
        code(&self.document)
            .selection(&self.selection)
            .scroll(&self.scroll)
            .folds(&self.folds)
            .child(diagnostics(&self.document.diagnostics))
            .child(peer_cursors(presence))
            .child(
                // A second mount over the same sources — its own wrap width, geometry, and
                // damage; shared logical layers and atlas by revision, invisibly. Box-space
                // placement, web semantics: out of flow, top-right inset.
                minimap(&self.document).follows(&self.scroll).align(TopRight),
            )
            .target(focus)
    }

    async fn save(&self) -> Result<(), SaveError> {
        self.document.save_to_disk().await
    }
}

#[derive(Serialize, Deserialize)]
struct Terminal {
    title: String,
}

impl View for Terminal {
    fn view(&self) -> El<'_> {
        // Styled box, one child (14 §2.1) — `column()` never takes zero args.
        div().p(12).child(text(&self.title))
    }
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// Handlers: methods, slots from validated site context, queued verbs.
// ════════════════════════════════════════════════════════════════════════════════════════════

impl Workbench {
    fn new(project: Entity<Project>, transport: PresenceTransport) -> Self {
        Self {
            project,
            tabs: List::new(),
            active: Signal::new(None),
            editor_focus: Target::new(),
            presence: PresenceSession::connect(transport), // no route (18 §5) — see `changed` below
        }
    }

    fn open_file(&mut self, path: PathBuf) {
        let slot = self.tabs.push(Tab::Editor(Editor::open(&self.project, path)));
        *self.active = Some(slot);
    }

    fn select(&mut self, slot: Slot<Tab>) {
        *self.active = self.tabs.contains(slot).then_some(slot);
    }

    fn close(&mut self, slot: Slot<Tab>) {
        self.tabs.remove(slot); // producers, projections, and in-flight work die with the mount
    }

    /// A save is a reliable, user-triggered action — rung 2 of the async ladder (12 §6), not a
    /// latest-wins derived reader. This is distinct from the journal: the journal persists
    /// session/UI state automatically; `save` writes the document's own content back to disk.
    fn save(&mut self, slot: Slot<Tab>) {
        let Some(Tab::Editor(editor)) = self.tabs.get(slot) else { return };
        self.action(editor.save())
            .queue(Queue::Reliable)
            .then(Workbench::saved.with(slot))
            .catch(Workbench::save_failed.with(slot));
    }

    fn saved(&mut self, _slot: Slot<Tab>) {}

    fn save_failed(&mut self, slot: Slot<Tab>, error: SaveError) {
        if let Some(Tab::Editor(editor)) = self.tabs.get_mut(slot) {
            editor.note_failed_save(error);
        }
    }

    fn palette_closed(&mut self) {
        self.editor_focus.claim_focus();
    }

    /// Called from `Workbench::changed` once it takes `d.presence.applied` (18 §2, §5): taking
    /// the handoff IS the atomic-apply acknowledgement — `PresenceSession::received` never routes
    /// anywhere, it just gives.
    fn apply_presence_batch(&mut self, batch: PresenceBatch) {
        for op in batch.operations {
            match op {
                PresenceOp::Select { local, selection } => {
                    self.tabs.send(local, Tab::apply_remote_selection.with(selection))
                }
                PresenceOp::Close { local } => self.tabs.remove(local),
            }
        }
    }
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// Views. Encapsulation is a struct view, not a return type (14 §1.2 revises 13 §4): `Workbench`
// and `Tab`/`Editor`/`Terminal` seal by being struct `View`s embedded as fields — module privacy
// is the style boundary, and every one of them returns the same standard `El<'_>` view contract.
// `tab_label` below is a function component that stays OPEN — it advertises restylability across
// an opaque return with `impl Element + Styled` (14 §1.2's remaining use for the bound) — but
// note that `El<'_>` would permit the identical `.something()` call today too, now that per-kind
// method gating on finished elements is retired; the two spellings differ in ceremony, not in
// what compiles.
// ════════════════════════════════════════════════════════════════════════════════════════════

impl View for Workbench {
    fn view(&self) -> El<'_> {
        let tab_strip = tabs(&self.tabs, |tab| tab_label(tab.title()).pending(tab.is_loading()))
            .active(&self.active)
            .on_select(Workbench::select)
            .on_close(Workbench::close);

        let bodies = tab_bodies(&self.tabs, |tab| {
            // One policy stated; failed → retry card, faulted → supervisor (12 §7c).
            boundary()
                .loading(tab_skeleton)
                .child(tab.view_with(&self.presence.snapshot, self.editor_focus))
        });

        column((
            tab_strip,
            row((bodies, self.presence.snapshot.project(peer_sidebar))),
        ))
    }

    /// The one reaction surface (18 §1): `d.presence.applied` is `PresenceSession`'s `Handoff`
    /// off the recursive delta through `Entity<PresenceSession>` — no route bound at `connect`,
    /// no forwarding method on `Workbench`'s own construction path. Taking it here, rather than
    /// inside `PresenceSession::received`, keeps the atomic apply on the side that owns `tabs`.
    fn changed(&mut self, d: Changed<'_, Workbench>) {
        if let Some(batch) = d.presence.applied.take() {
            self.apply_presence_batch(batch);
        }
    }
}

/// An OPEN component: `impl Element + Styled` advertises restylability across an opaque return
/// (14 §1.2). It is no longer the ONLY spelling that permits the caller's `.something()` call —
/// `El<'_>` would type-check the identical chain now that per-kind method gating on finished
/// elements is retired — so the choice here is about advertising the contract, not enforcing it.
fn tab_label(title: &str) -> impl Element + Styled + '_ {
    row((file_icon(title), text(title).text_sm())).gap(6).px(10)
}

/// A style mixin with an honest bound (13 §4.2). Two equal spellings: mid-chain `.apply(card)`,
/// or plain function application `card(column((…)))` — a mixin is just a function.
fn card<E: Element + Styled>(e: E) -> E {
    e.p(16).rounded_lg().bg(theme.container)
}

// Never branched over (passed by value to `.loading(…)`, not joined against another type in this
// file), so it takes the lifetime-hiding leaf spelling `impl Element`, not `El<'static>` (14 §1.2).
fn tab_skeleton() -> impl Element {
    card(column((skeleton_line(0.7), skeleton_line(0.9), skeleton_line(0.5))).gap(8))
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// A decoration, to prove the surface story has no second world (13 §3): no Layer trait, no
// paint callback, no cx.quad vocabulary. Marks ARE elements; the enclosing surface's geometry
// is an inherited source (resolved at mount, like a theme token); placement values carry the
// coordinate space in their type. It reruns exactly when presence or geometry publishes — the
// same scheduling law as every other region. A mark that wanted interaction would attach a
// route like any element; these attach none, so they cost nothing at dispatch.
// ════════════════════════════════════════════════════════════════════════════════════════════

fn peer_cursors(presence: &Signal<PresenceSnapshot>) -> impl Element + '_ {
    (presence, Code::geometry()).project(|(peers, code)| {
        peers.iter().filter_map(|peer| {
            let caret = code.caret(peer.anchor)?; // typed anchor → placed handle; None = off-screen
            Some((
                rect(caret).fill(peer.color.alpha(0.8)),
                label(&peer.name).above(caret).fg(peer.color),
            ))
        })
    })
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// Presence — a protocol actor. `received`/`transport_lost`/admission were never ceremony; only
// their construction and snapshot access changed (12 §7e): one `connect` call replaces
// `Entity::new` + `attach` + a stored `Reader` field, and the snapshot is read straight through
// the entity (`self.presence.snapshot`) instead of a clone-per-read accessor.
// ════════════════════════════════════════════════════════════════════════════════════════════

#[derive(Clone)]
struct PresenceEnvelope {
    session: SessionId,
    leader: CollaboratorId,
    incarnation: u64,
    peer: CollaboratorId,
    lane: PresenceLane,
    sequence: u64,
    origin: OpId,
    item: DomainItemKey, // a journaled path/anchor set — never a runtime Slot/Entity id
    payload: PresencePayload,
}

struct PresenceSession {
    replica: PresenceReplica,
    health: Signal<PresenceHealth>,
    snapshot: Signal<PresenceSnapshot>,
    /// `Handoff<PresenceBatch>` (18 §2), not an endpoint: journaled STATE, unlike `Target`'s
    /// `PhantomData`-style unit serialization — a batch given but not yet taken by `Workbench`
    /// survives a checkpoint/restore round trip the same way any other field would (18 §2 point
    /// 1). NOTE: this struct still isn't `#[derive(Serialize, Deserialize)]` (see `connect`
    /// below, unchanged from before this pass) — a service's own durability for a Handoff it
    /// owns, when the service itself opts out of the derive, is a real tension 18 doesn't spell
    /// out; flagged rather than resolved by inventing new API surface.
    applied: Handoff<PresenceBatch>,
}

impl PresenceSession {
    /// One call: constructs the entity and attaches the transport (12 §7e). `Remote<Self>` is
    /// only valid once the entity has published, so `attach` runs after `Entity::new` returns
    /// rather than inside a `new_cyclic` closure — the same discipline the weak-cycle test below
    /// pins for every constructor, not only this one.
    ///
    /// `connect` takes NO route (18 §5, decision list #4): services take no constructor routes
    /// any more than a mounted component takes an embed argument — `applied` is a field like any
    /// other, and the workspace takes `d.presence.applied` in its own `changed`, exactly the way
    /// `Workbench::changed` below reads any other child's `Handoff`. (Compare `Typeahead::new()`
    /// in typeahead.rs, which also takes no route — the SAME rule now covers a mounted component
    /// and a bare service uniformly; 16's split between them is gone.)
    fn connect(transport: PresenceTransport) -> Entity<Self> {
        let session = Entity::new(Self {
            replica: PresenceReplica::new(),
            health: Signal::new(PresenceHealth::Connecting),
            snapshot: Signal::new(PresenceSnapshot::empty()),
            applied: Handoff::new(),
        });
        Self::attach(session.remote(), transport);
        session
    }

    // NOTE: 07/11/12/13 name `self.spawn_latest` (owner-scoped, rung 1) and raw `runtime.spawn`
    // (rung 3, protocol streams — this is exactly that case) but the installed-runtime handle
    // itself is described as ambient after 12 §1 ("runtimes are installed once on Application,
    // never threaded"), without naming the free function that reaches it from a bare fn. Smallest
    // spelling consistent with that decision: `runtime::spawn`, resolving the installed driver
    // the same way theme tokens resolve the installed cascade (12 §8) — flagged as open, not
    // invented API surface.
    fn attach(ingress: Remote<Self>, mut transport: PresenceTransport) {
        runtime::spawn(async move {
            while let Some(event) = transport.next().await {
                match event {
                    Ok(envelope) => ingress.send(PresenceSession::received.with(envelope)),
                    Err(error) => ingress.send(PresenceSession::transport_lost.with(error)),
                }
            }
        });
    }

    fn received(&mut self, envelope: PresenceEnvelope) {
        // Reliable control is contiguous/bounded FIFO; ephemeral cursor/scroll is latest per
        // (peer, item, field). Duplicate origin/sequence is ignored; gaps resync; a new leader or
        // incarnation requires an authoritative snapshot before deltas.
        match self.replica.admit(envelope) {
            Admission::Duplicate | Admission::OldIncarnation => {}
            Admission::NeedSnapshot(request) => self.request_snapshot(request),
            Admission::Batch { batch, snapshot } => {
                *self.snapshot = snapshot;
                self.applied.give(batch); // durable; Workbench takes and applies it atomically
            }
        }
    }

    fn transport_lost(&mut self, error: TransportError) {
        // Offline/retry is typed health, not a Reader fault and not a workbench crash.
        *self.health = PresenceHealth::Offline {
            diagnostic: error.into(),
            retry: RetryPolicy::Backoff,
        };
    }

    fn request_snapshot(&mut self, request: SnapshotRequest) {
        self.replica.request_snapshot(request);
    }
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// Launch and the restore proof. `journal("workbench")` is the ONE line where persistence is
// visible: it restores the source tree if a journal exists, then every producer re-derives.
// ════════════════════════════════════════════════════════════════════════════════════════════

fn main() {
    Application::new()
        .runtime(AsyncDriver::tokio(tokio::runtime::Handle::current()))
        .journal("workbench")
        .open(
            Window::document(Workbench::new(
                Entity::new(Project::open("demo-project")),
                PresenceTransport::connect("demo-session"),
            ))
            .title("Workbench")
            .size(1280, 800),
        )
        .run();
}

#[cfg(test)]
mod tests {
    use super::*;

    /// The identity machinery the original spent ~80 lines maintaining, asserted with none of it.
    #[test]
    fn restore_is_rederivation() {
        let runtime = RuntimeSet::manual();
        let mut app = Application::demo().runtime(runtime.clone());
        let win = app.open(Window::document(Workbench::new(
            app.entity(Project::open("demo")),
            PresenceTransport::loopback(),
        )));

        win.root_mut().open_file("src/main.rs".into());
        win.root_mut().open_file("README.md".into());
        win.key(Key::Tab.ctrl()); // active = first tab
        let journal = app.journal_checkpoint();

        // Restart: same constructor path, no restore code anywhere in the app.
        let mut restarted = Application::demo().runtime(runtime.clone()).restore(journal);
        let win = restarted.window();

        // Sources came back — tabs, the active SLOT (remapped by the journal), selection.
        assert_eq!(win.root().tabs.len(), 2);
        assert!(win.root().active.is_some());

        // And the derived world rebuilt itself: both document producers armed in ONE turn
        // (fetch-high parallel restore is §7.3, not a workspace feature), each tab body
        // blocking only its own boundary.
        assert_eq!(runtime.started_document_loads(), 2);
        assert_eq!(win.visible_loading_boundaries(), 2);
        runtime.complete_document("src/main.rs");
        restarted.flush_next_turn();
        assert!(win.contains_text("fn main"));
        assert_eq!(win.visible_loading_boundaries(), 1);
    }

    /// Stale completions still die by stamps — dissolving the nouns kept the guarantees.
    #[test]
    fn closed_tab_completion_is_inert() {
        let runtime = RuntimeSet::manual();
        let mut app = Application::demo().runtime(runtime.clone());
        let win = app.open(Window::document(Workbench::new(
            app.entity(Project::open("demo")),
            PresenceTransport::loopback(),
        )));

        win.root_mut().open_file("src/main.rs".into());
        let slot = win.root().active.unwrap();
        win.root_mut().close(slot);

        runtime.complete_document("src/main.rs"); // arrives after the mount died
        app.flush_next_turn();
        assert!(!win.contains_text("fn main")); // revoked delivery cannot publish (§7.5)
    }

    /// §7.0's wake law: `PollWake` never crosses into a value, and one `Poll::Ready` produces
    /// exactly one stamped next-turn memo update — never a reentrant publish mid-poll.
    #[test]
    fn wake_is_not_ready_and_ready_is_one_next_turn_memo_update() {
        let runtime = RuntimeSet::manual();
        let mut app = Application::demo().runtime(runtime.clone());
        app.open(Window::document(Workbench::new(
            app.entity(Project::open("demo")),
            PresenceTransport::loopback(),
        )));
        app.window_mut().open_file("src/main.rs".into());

        runtime.wake_pending(100);
        assert_eq!(app.counters().signal_writes, 0);
        assert_eq!(app.counters().memo_evaluations, 0);

        runtime.complete_document("src/main.rs");
        assert!(!app.window().contains_text("fn main")); // completion cannot publish reentrantly
        app.flush_next_turn();
        assert_eq!(app.counters().accepted_async_completions, 1);
        assert!(app.window().contains_text("fn main"));
    }

    /// A → B → A: two resizes in one turn produce two wrap tickets; only the LATEST ticket's
    /// completion may publish, and the coherent (old or provisional) content stays displayed
    /// while a request is outstanding — revalidation never mixes epochs.
    #[test]
    fn revalidation_never_mixes_epochs_across_a_b_a_resizes() {
        let runtime = RuntimeSet::manual();
        let mut app = Application::demo().runtime(runtime.clone());
        app.open(Window::document(Workbench::new(
            app.entity(Project::open("demo")),
            PresenceTransport::loopback(),
        )));
        app.window_mut().open_file("src/main.rs".into());
        runtime.complete_document("src/main.rs");
        app.flush_next_turn();
        let original_revision = app.window().display_revision();

        app.window_mut().resize_editor(px(900.0)); // A -> B, ticket 1
        app.window_mut().resize_editor(px(700.0)); // B -> A-sized, but ticket 2 — a NEW request
        assert!(app.window().editor_is_pending());
        assert!(app.window().old_or_provisional_text_is_coherent());

        runtime.complete_wrap_ticket(1); // stale A -> B completion
        app.flush_next_turn();
        assert_eq!(app.window().display_revision(), original_revision); // ticket 1 was inert

        runtime.complete_wrap_ticket(2);
        app.flush_next_turn();
        assert!(app.window().paint_hit_a11y_share_one_display_revision());
    }

    /// A true reference cycle, without `weak_self` ever being upgraded partway through
    /// construction, and without any window in which a half-built owner is visible.
    #[test]
    fn a_true_weak_cycle_dies_without_upgrade_or_partial_visibility() {
        struct Loop {
            me: WeakEntity<Loop>,
        }

        let entity = Entity::new_cyclic(|me| Loop { me });
        let weak = entity.downgrade();
        assert!(weak.inspect(|owner| owner.me.send(|_| ())).is_some());

        drop(entity);
        assert!(weak.inspect(|_| ()).is_none());
        assert_eq!(weak.send(|_| ()), Delivery::Closed);

        let leaked = std::cell::RefCell::new(None);
        let failed = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let _: Entity<Loop> = Entity::new_cyclic(|me| {
                *leaked.borrow_mut() = Some(me);
                panic!("constructor fault")
            });
        }));
        assert!(failed.is_err());
        assert!(leaked
            .into_inner()
            .expect("constructor exposed its weak proof")
            .inspect(|_| ())
            .is_none()); // the initializing slot was never published
    }

    /// Recast from the original's `durable_item_identity_is_not_live_runtime_identity`: with
    /// `ItemInstanceId`/`StoredItem` gone (13 §1), durable identity is simply the journaled path
    /// — two tabs on the SAME path get different `Slot<Tab>`/`Entity<Document>` generations
    /// across a restart, but the SAME journaled document reference, and neither app type carries
    /// an id anywhere in its fields (13 §1.2).
    #[test]
    fn durable_document_identity_is_not_live_slot_identity() {
        let runtime = RuntimeSet::manual();
        let mut app = Application::demo().runtime(runtime.clone());
        let win = app.open(Window::document(Workbench::new(
            app.entity(Project::open("demo")),
            PresenceTransport::loopback(),
        )));
        win.root_mut().open_file("src/main.rs".into());
        win.root_mut().open_file("src/main.rs".into()); // same path, a second tab
        let first_slot = win.root().tabs.slots().next().unwrap();
        let journal = app.journal_checkpoint();

        let mut restarted = Application::demo().runtime(runtime).restore(journal);
        let restored_slot = restarted.window().root().tabs.slots().next().unwrap();

        assert_ne!(first_slot, restored_slot); // fresh Slot generation after restart
        assert!(!restarted.window().root().tabs.get(restored_slot).unwrap().contains_any_id());
        assert_eq!(
            restarted.window().root().tabs.get(restored_slot).unwrap().title(),
            win.root().tabs.get(first_slot).unwrap().title(),
        ); // the journaled path — the durable identity — survived unchanged
    }

    /// Faults, focus, and presence stay on three separate axes: a domain error on one tab and a
    /// panicking wrap worker on another don't cross-contaminate, `claim_focus` still applies
    /// after commit with no `Effects` parameter, and remote presence never echoes local writes.
    #[test]
    fn faults_focus_and_presence_remain_separate() {
        let runtime = RuntimeSet::manual();
        let mut app = Application::demo().runtime(runtime.clone());
        app.open(Window::document(Workbench::new(
            app.entity(Project::open("demo")),
            PresenceTransport::loopback(),
        )));
        app.window_mut().open_file("does-not-exist.rs".into());
        app.window_mut().open_file("src/main.rs".into());

        runtime.fail_document_with_domain_error("does-not-exist.rs");
        runtime.panic_wrap_worker("src/main.rs");
        app.flush_next_turn();
        assert!(app.window().unknown_document_shows_retry_card());
        assert!(app.window().editor_keeps_last_coherent_display_with_fault_badge());

        app.window_mut().close_palette();
        assert!(!app.window().editor_is_focused());
        app.flush_next_turn();
        assert!(app.window().editor_is_focused());

        app.remote(PresenceSession::received.with(fixtures::cursor_storm()));
        app.remote(PresenceSession::transport_lost.with(fixtures::offline()));
        app.flush_next_turn();
        assert_eq!(app.window().applied_cursor_updates(), 1); // latest ephemeral value
        assert!(app.window().remote_changes_were_not_echoed());
        assert!(app.window().workbench_remains_ready_while_presence_is_offline());
    }

    /// Gaps resync from an authoritative snapshot; a delta from a superseded leader/incarnation
    /// never applies, atomically with the resync — the presence protocol's own guarantees,
    /// unchanged by the ceremony that used to surround it.
    #[test]
    fn presence_resyncs_gaps_and_rejects_old_leaders_atomically() {
        let runtime = RuntimeSet::manual();
        let mut app = Application::demo().runtime(runtime.clone());
        app.open(Window::document(Workbench::new(
            app.entity(Project::open("demo")),
            PresenceTransport::loopback(),
        )));
        app.window_mut().open_file("src/main.rs".into());
        runtime.complete_document("src/main.rs");
        app.flush_next_turn();

        app.remote(PresenceSession::received.with(fixtures::delta(7, 12))); // gap before 8..11
        app.flush_next_turn();
        assert!(app.window().presence_requested_snapshot());
        assert!(!app.window().contains_partial_presence_delta(12));

        app.remote(PresenceSession::received.with(fixtures::snapshot(8, 20)));
        app.remote(PresenceSession::received.with(fixtures::delta(7, 13))); // old incarnation
        app.flush_next_turn();

        assert_eq!(app.window().presence_incarnation(), 8);
        assert!(!app.window().contains_presence_from_incarnation(7));
        assert!(app.window().presence_snapshot_was_one_atomic_batch());
    }
}

// Compile-fail fixtures belonging beside this example once the API exists. Carried over from the
// original pressure test — the laws they pin are unchanged by the composition pass; only the
// second fixture's app-facing surface moved (there is no application-authored item factory to
// borrow across an await anymore, so it is restated against the shape that remains: a producer
// closure declared from a source).
//
// ```rust,compile_fail
// let leaked: DisplayPos<'static> = code.with_snapshot(|map| map.to_display(anchor));
// // DisplayPos cannot escape its snapshot scope, even though `code(&document)`'s mount now owns
// // the DisplayPipeline the app used to construct by hand (13 §2).
// ```
//
// ```rust,compile_fail
// let retained = RetainedBlock::new(block_id, element());
// // Element<'f> cannot enter a retained display record or an async wrap request.
// ```
//
// ```rust,compile_fail
// async fn bad_producer(editor: &Editor) { backend().await; editor.document.something(); }
// // A producer closure declared from a source (`.try_map_async(f)`, `self.spawn_latest(…)`) owns
// // its captures; it cannot borrow Editor/Workbench/Window/App across an await.
// ```
