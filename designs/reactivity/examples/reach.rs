//! Reach without the bag — a mini-Workspace in the final (07/11/12/13/18) vocabulary.
//!
//! What this demonstrates, and what it deliberately does NOT contain:
//! - `Entity<T>: Deref` — peeking another entity is FIELD ACCESS; a view port wires straight into
//!   another entity's cell (`text_input(&self.buffer.text)`). No `.read()` anywhere. In a describe
//!   these reads record entity-grain dependencies (07 §13).
//! - No `Watched<T>`, no `on_change: Output<()>` field, no `when`/`Emitter`, and — as of 18 — no
//!   `Output<E>` at all, anywhere, for anything: observing another entity is just a FIELD of
//!   `Workspace`, so `Workspace::changed` reaches it off the turn's delta — `d.buffer.any()` for
//!   entity-grain, `&d.project.root` for a rename, both field syntax (18 §1/§3). There is no
//!   stored `Subscription`, weak handle, untyped `()` bus, and no declared edge of any kind: the
//!   subscription set IS `Workspace`'s field set.
//! - No epoch field, no capture tuple, no manual stale-reject guard: `self.spawn_latest` is the
//!   stamped, latest-wins owner-spawn verb (12 §2a) — the index rebuild below is exactly the
//!   shape that finding names. Revoked on unmount; a superseded completion cannot publish.
//! - No `.guard` chord: a key handler guards ITSELF with Rust control flow and returns the event
//!   (07 §6.1). `Key::Comma.primary()` is a chord modifier, which is fine.
//! - `send` for cross-entity writes; `Win<Self>` + the `Windows` capability to open a window;
//!   `Target`-based focus with `.trap_focus()`.
//! - `Selected<T>` (11 §9) is `Signal<Option<Slot<T>>>` — reinstated as a named alias, not
//!   respelled by hand at each call site.
//! - No `Emitter`/`type Event`, no back-edge field of ANY kind on `Project`: a rename is not an
//!   occurrence reported outward, it is `root` changing — the parent observes the FIELD, not a
//!   notification about the field (18 §1). This file is 18 §1's law made concrete: state is the
//!   protocol; an occurrence is a state transition; old AND new ride the `Change` a parent reads
//!   off its own `changed`, with nothing declared, raised, or emitted anywhere in between.

use gpui::prelude::*;

pub struct Buffer {
    text: Signal<String>,
    saved: String, // plain: only changes on save, and save re-describes anyway
}

impl Buffer {
    pub fn new() -> Self {
        Self {
            text: Signal::new(String::new()),
            saved: String::new(),
        }
    }

    /// Derived state is a METHOD, not a `dirty: Signal<bool>`. Starred reads inside record
    /// through the call, so a view using this is correct; a live version is a derived wire.
    pub fn dirty(&self) -> bool {
        *self.text != self.saved
    }

    fn retitle(&mut self, name: String) {
        self.text.insert_str(0, &name); // autoderef publish
        // No manual emit, no give: a committed &mut turn dirties Buffer, so `d.buffer.any()`
        // sees it in whatever host's `changed` reads through this field next turn (18 §1).
    }
}

pub struct Project {
    root: Signal<PathBuf>,
    // No `renamed` endpoint (18 §1/§5): a rename IS `root` changing. There is nothing else to
    // declare — the transition's old AND new value both ride the `Change<PathBuf>` a host reads
    // straight off `&d.project.root` in its own `changed`.
}

impl Project {
    pub fn new() -> Self {
        Self {
            root: Signal::new("/repo".into()),
        }
    }

    fn rename(&mut self, name: String) {
        *self.root = name.into(); // publishes; the parent observes the FIELD, nothing is raised
    }
}

enum Mode {
    Normal,
    Insert,
}

struct Pane {
    title: String,
}

struct Workspace {
    buffer: Entity<Buffer>,
    project: Entity<Project>,
    mode: Signal<Mode>,          // Vim-ish mode: an ordinary signal
    active_pane: Selected<Pane>, // 11 §9's alias for Signal<Option<Slot<Pane>>>
    panes: List<Pane>,
    index: Option<SearchIndex>, // domain status; was `Task<SearchIndex>`
    search: Target<TextInput>,
    palette_open: Signal<bool>,
}

impl Workspace {
    fn new() -> Self {
        Self {
            buffer: Entity::new(Buffer::new()),
            project: Entity::new(Project::new()),
            mode: Signal::new(Mode::Normal),
            active_pane: Signal::new(None),
            panes: List::new(),
            index: None,
            search: Target::default(),
            palette_open: Signal::new(false),
        }
    }

    /// Buffer changed: rebuild the search index off-thread. `self.spawn_latest` is the stamped
    /// owner-spawn verb (12 §2a) — latest-wins by construction, revoked on unmount, no epoch
    /// field, no capture tuple, no manual guard.
    fn persist(&mut self) {
        self.spawn_latest(Workspace::indexed, build_index(self.buffer.text.clone()));
    }

    fn indexed(&mut self, index: SearchIndex) {
        self.index = Some(index);
    }

    /// Open Settings in its own window. `Win<Self>` is the dispatching window (validated site
    /// context); `Windows` is the sealed capability that actually opens one (07 §12/§16.4).
    fn open_settings(&mut self, win: Win<Self>, windows: Windows) {
        let _ = windows.open(Window::utility(Settings::default()).near(win));
    }

    fn to_normal(&mut self) {
        *self.mode = Mode::Normal;
    }

    fn in_insert(&self) -> bool {
        matches!(*self.mode, Mode::Insert)
    }

    /// Escape guards itself — no `.guard` on the chord (07 §6.1).
    fn escape(&mut self, event: KeyEvent) -> KeyEvent {
        if !self.in_insert() {
            return event.propagate();
        }
        self.to_normal();
        event.consume()
    }

    /// Derived label: a method at the floor; wire it with `.project` if it must be live.
    fn title(&self) -> String {
        // Entity deref: field access into committed Project/Buffer state.
        format!(
            "{}{}",
            self.project.root.display(),
            if self.buffer.dirty() { " •" } else { "" }
        )
    }
}

impl View for Workspace {
    fn view(&self) -> El<'_> {
        column((
            text(self.title()), // derived method; recorded through the call
            row((
                // A port INTO ANOTHER ENTITY'S CELL — plain field access via the deref;
                // patches with no describe of Workspace or Buffer:
                text_input(&self.buffer.text)
                    .target(self.search)
                    .focus_default(),
                button("Find").focuses(self.search),
            )),
            dialog(command_palette())
                .open(&self.palette_open)
                .trap_focus() // Tab cycles inside while open (the dialog convention)
                .initial_focus(self.search),
        ))
        .on_key(Key::Escape, Workspace::escape) // guard is in the handler, not the chord
        .on_key(Key::Comma.primary(), Workspace::open_settings)
    }

    /// The one reaction surface (18 §1). The subscription set is `Workspace`'s field set: no
    /// edge to declare for either observation this file used to need `when` for. `d.buffer.any()`
    /// replaces the entity-grain `when(&self.buffer, Workspace::persist)` — `Buffer` derives no
    /// `Delta`, so its delta degrades to a changed/unchanged marker (15 §3, 18 §1); `.any()` asks
    /// exactly that question. `&d.project.root` replaces the typed-`Emitter` edge AND the
    /// `renamed: Output<String>` endpoint that briefly replaced it — a rename is read as an
    /// ordinary field change, field syntax (18 §3), with `c.new` carrying the value a `renamed`
    /// occurrence used to carry.
    fn changed(&mut self, d: Changed<'_, Workspace>) {
        if d.buffer.any() {
            self.persist();
        }
        if let Some(c) = &d.project.root {
            self.buffer.send(Buffer::retitle.with(c.new.display().to_string()));
        }
    }
}

#[derive(Default)]
struct Settings;

impl View for Settings {
    fn view(&self) -> El<'_> {
        // Styled box, one child (14 §2.1) — `column()` never takes zero args.
        div().p(12).child(text("Settings"))
    }
}

fn main() {
    Application::run(Window::document(Workspace::new()).title("Reach"));
}
