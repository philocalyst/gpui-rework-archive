//! Migrating an observer-heavy Zed test — the real `Editor::new` subscription list, and a test
//! that exercises it, moved to the final (07/10/18) vocabulary.
//!
//! ## The real source
//!
//! [10-from-cx.md §2.2](../10-from-cx.md) quotes `Editor::new`'s `_subscriptions: Vec<Subscription>`
//! verbatim (checked against Zed `editor.rs:2434`, commit
//! [`fd82517`](https://github.com/zed-industries/zed/blob/fd82517a115d97a07835b52f0512b22b38e38ccf)
//! — the same commit [07 §15](../07-the-ladder.md) audits):
//!
//! ```rust,ignore
//! cx.observe(&buffer, Self::on_buffer_changed),
//! cx.subscribe(&buffer, Self::on_buffer_event),
//! cx.observe(&display_map, Self::on_display_map_changed),
//! cx.observe(&blink_manager, |_, _, cx| cx.notify()),
//! cx.observe_global::<SettingsStore>(Self::settings_changed),
//! cx.observe_window_activation(…),
//! ```
//!
//! plus a second `Vec` of *project* observes/subscribes `extend`ed in after construction. This file
//! migrates that list — and a representative test that exercises it — one clause at a time.
//!
//! ## Before: the real Zed test shape
//!
//! Zed does not usually call `cx.observe`/`cx.subscribe` *inside* a test; the test instead exercises
//! the subscriptions `Editor::new` already installed and asserts on the resulting side effects,
//! often through a hand-rolled counter closed over an `Rc<RefCell<_>>` because "did the observer
//! fire, and how many times" is itself the thing under test:
//!
//! ```rust,ignore
//! #[gpui::test]
//! fn test_editor_reacts_to_buffer_settings_and_focus(cx: &mut TestAppContext) {
//!     let buffer = cx.new(|cx| Buffer::new(cx));
//!     let display_map = cx.new(|cx| DisplayMap::new(buffer.clone(), cx));
//!     let editor = cx.new(|cx| Editor::new(buffer.clone(), display_map.clone(), cx));
//!
//!     let buffer_changed = Rc::new(RefCell::new(0));
//!     let _sub = cx.observe(&buffer, {
//!         let buffer_changed = buffer_changed.clone();
//!         move |_, _, _| *buffer_changed.borrow_mut() += 1
//!     });
//!
//!     buffer.update(cx, |buffer, cx| buffer.edit([(0..0, "fn main() {}")], cx));
//!     cx.run_until_parked();
//!     assert_eq!(*buffer_changed.borrow(), 1);
//!
//!     cx.update_global::<SettingsStore, _>(|store, cx| store.set_tab_size(2, cx));
//!     cx.run_until_parked();
//!     assert_eq!(editor.read_with(cx, |e, _| e.tab_size), 2);
//!
//!     cx.update_window(editor.window_id(), |_, window, cx| {
//!         window.simulate_activation();
//!     });
//!     assert!(!editor.read_with(cx, |e, _| e.cursor_blinking));
//! }
//! ```
//!
//! Five things are load-bearing here and none of them are the point of the test: a `Subscription`
//! the test must keep alive in `_sub`, an `Rc<RefCell<usize>>` invented purely to observe an
//! observer, `cx.run_until_parked()` as a manual settle point, and two unrelated subsystems (global
//! settings, window activation) that both had to route through the same untyped `cx.observe` verb
//! to be testable at all.
//!
//! ## After: what each clause becomes, and why
//!
//! - `cx.observe(&buffer, Self::on_buffer_changed)` — entity-grain, no payload: `d.buffer.any()` in
//!   `Editor::changed` (18 §1), same shape [derived_observe.rs](derived_observe.rs) already pins.
//! - `cx.subscribe(&buffer, Self::on_buffer_event)` — 18 kills `Emitter`/`Output<E>` entirely
//!   ("no `Output<E>` at all, anywhere, for anything", [reach.rs](reach.rs)). The one event
//!   `Editor::on_buffer_event` actually branched on — the language flipping — was never an
//!   occurrence in its own right; it was `text` changing, wearing an enum. It becomes exactly
//!   [derived_observe.rs](derived_observe.rs)'s field-grain case: `&d.buffer.text`, `c.old`/`c.new`
//!   independently projected through `detect_language`, `!=` as the gate.
//! - `cx.observe(&display_map, Self::on_display_map_changed)` — entity-grain: `d.display_map.any()`.
//! - `cx.observe(&blink_manager, |_, _, cx| cx.notify())` — [10-from-cx.md §2.2](../10-from-cx.md)
//!   flags this exact line as **mis-filed**: the blink manager is a *timer*, not a value anyone
//!   changed, so "the cell it needed" is a clock. The honest 07 answer is a motion value (07 §4.2),
//!   not `on_change`/`d.field.any()` on anything — there is no `blink_manager` field left at all.
//! - `cx.observe_global::<SettingsStore>(Self::settings_changed)` — no `TypeId` global. `Settings`
//!   is a shared `Entity<Settings>` field ([migration.md](../migration.md) "globals" row); reacting
//!   is the same field-grain delta read as everything else: `&d.settings.tab_size`.
//! - `cx.observe_window_activation(…)` — window chrome becomes ordinary `View` state
//!   ([migration.md](../migration.md) "App shell" row); there is nothing to subscribe to, so it is
//!   simply not a field of `Editor` at all — cursor blink already stopped needing it once blink
//!   became a motion value gated on focus, not on a manually observed activation flag.
//!
//! What survives from the "before" test: its three assertions, split across four `#[test]` fns
//! below (the buffer-edit case splits into "the display map recomputed" and "the language flipped"
//! — the latter had no assertion in the original at all, because `cx.subscribe`'s payload was
//! consumed silently by `on_buffer_event` with nothing to check it against). What does not survive:
//! `_sub`, the `Rc<RefCell<_>>`, `cx.run_until_parked()` (subsumed by `Win::demo`'s turn barrier,
//! 07 §12), and the six-line `_subscriptions: Vec<Subscription>` field itself — none of it survives
//! migration because none of it was ever the behavior under test.

use gpui::prelude::*;

/// Application-level sugar, not a framework primitive: `on_any!(d.field, self.method())` expands
/// to `if d.field.any() { self.method(); }` — no `.any()` and no capturing closure at the call
/// site, just the effect body written where the eye lands. The design deliberately keeps the
/// entity-grain wire as a plain `if` rather than a hidden framework combinator
/// (derived_observe.rs: "written out as an `if`, not living inside a wire") — this macro does not
/// change that, it only stops `changed` from re-typing `.any() { … }` once per field. A field-grain
/// wire (the `if let Some(c) = &d.field` arms in `Editor::changed`) still needs the full form
/// because it wants `c.old`/`c.new`, not just "did it change."
macro_rules! on_any {
    ($field:expr, $body:expr) => {
        if $field.any() {
            $body;
        }
    };
}

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum Language {
    PlainText,
    Rust,
}

fn detect_language(text: &str) -> Language {
    if text.trim_start().starts_with("fn ") {
        Language::Rust
    } else {
        Language::PlainText
    }
}

#[derive(Delta)] // gives `d.buffer.text` field syntax in `changed` (18 §3)
pub struct Buffer {
    text: Signal<String>,
}

impl Buffer {
    pub fn new() -> Self {
        Self { text: Signal::new(String::new()) }
    }

    /// Derived value as a method, same rationale as derived_observe.rs::Buffer::language.
    pub fn language(&self) -> Language {
        detect_language(&self.text)
    }

    fn edit(&mut self, text: String) {
        self.text.insert_str(0, &text);
    }
}

pub struct DisplayMap {
    // Minimal: enough to be an Entity whose any-change Editor reacts to, matching the real
    // wrap-map recompute that `on_display_map_changed` used to trigger by hand.
    wrapped_lines: Signal<u32>,
}

impl DisplayMap {
    pub fn new() -> Self {
        Self { wrapped_lines: Signal::new(0) }
    }

    fn rewrap(&mut self, lines: u32) {
        *self.wrapped_lines = lines;
    }
}

#[derive(Delta)]
pub struct Settings {
    tab_size: Signal<u32>,
}

impl Settings {
    pub fn new() -> Self {
        Self { tab_size: Signal::new(4) }
    }

    fn set_tab_size(&mut self, size: u32) {
        *self.tab_size = size;
    }
}

pub struct Editor {
    buffer: Entity<Buffer>,
    display_map: Entity<DisplayMap>,
    settings: Entity<Settings>, // was a TypeId global; now a shared field (migration.md)
    tab_size: u32,              // last-applied, committed value — no Subscription, no handler field
    // Note what is NOT here: no `cursor_opacity`/`blink_manager` field of any kind. Blink is a
    // program hung directly off the element in `view` (animation.rs's `pulse(..).over(..).repeat()`
    // idiom), not app state anything observes.
}

impl Editor {
    /// Entities constructed here, not threaded in from `main` — the same shape as
    /// reach.rs::Workspace::new (`buffer`/`project` built inline) and derived_observe.rs's
    /// `Editor::new(Entity::new(Buffer::new()))`. `Settings` would be a field OTHER owners share
    /// too in a real app (migration.md's "globals" row: no `TypeId`, just a shared `Entity`), but
    /// there is exactly one editor here, so it is built alongside everything else.
    pub fn new() -> Self {
        let settings = Entity::new(Settings::new());
        Self {
            tab_size: *settings.tab_size,
            buffer: Entity::new(Buffer::new()),
            display_map: Entity::new(DisplayMap::new()),
            settings,
        }
    }

    fn on_buffer_changed(&mut self) {
        // Formerly Editor::on_buffer_changed's body: recompute soft-wrap boundaries downstream of
        // an edit. Left as a stand-in call; the point is the wire, not the recomputation.
        let lines = self.buffer.text.lines().count() as u32;
        self.display_map.send(DisplayMap::rewrap.with(lines));
    }

    fn on_display_map_changed(&mut self) {
        // Formerly Editor::on_display_map_changed: no payload needed, matches d.display_map.any().
    }

    fn on_language_changed(&mut self, _lang: Language) {
        // Formerly the language-flip arm of Editor::on_buffer_event.
    }

    fn on_tab_size_changed(&mut self, tab_size: u32) {
        self.tab_size = tab_size;
    }
}

impl View for Editor {
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.buffer.text),
            // Blink: a program hung directly off the element (animation.rs), not an observed
            // field — the 10-from-cx.md correction made concrete. No `blink_manager` anywhere.
            text(format!("{:?} · tab {}", self.buffer.language(), self.tab_size))
                .opacity(pulse(1.0, 0.0).over(1.s()).repeat()),
        ))
    }

    fn changed(&mut self, d: Changed<'_, Editor>) {
        on_any!(d.buffer, self.on_buffer_changed());
        on_any!(d.display_map, self.on_display_map_changed());

        if let Some(c) = &d.buffer.text {
            let (old_lang, new_lang) = (detect_language(c.old), detect_language(c.new));
            if new_lang != old_lang {
                self.on_language_changed(new_lang);
            }
        }
        if let Some(c) = &d.settings.tab_size {
            self.on_tab_size_changed(*c.new);
        }
        // No arm for window activation and no arm for blink: neither is a field of Editor anymore.
    }
}

fn main() {
    Application::run(Window::document(Editor::new()).title("Editor Subscriptions"));
}

// ── Tests: the same three assertions the "before" test made, none of the plumbing ─────────────────
#[cfg(test)]
mod tests {
    use super::*;

    fn fixture() -> Win<Editor> {
        Win::demo(Editor::new())
    }

    /// Replaces the `Rc<RefCell<usize>>` counter and its `Subscription`: the observable outcome
    /// (soft-wrap recomputed after an edit) is asserted directly, because `Editor::changed` ran as
    /// part of the SAME turn the edit committed in — there is no separate "did it fire" question.
    #[test]
    fn buffer_edit_recomputes_the_display_map() {
        let editor = fixture();

        editor
            .entity(&editor.root().buffer)
            .send(Buffer::edit.with("fn main() {}\n".to_string()));

        assert_eq!(*editor.root().display_map.wrapped_lines, 1);
    }

    /// Same edit also proves the field-grain language wire: `d.buffer.text`'s `c.old`/`c.new` are
    /// what used to arrive as a `BufferEvent::LanguageChanged` payload through `cx.subscribe`.
    #[test]
    fn buffer_edit_flips_the_detected_language() {
        let editor = fixture();

        editor
            .entity(&editor.root().buffer)
            .send(Buffer::edit.with("fn main() {}\n".to_string()));

        assert!(editor.contains_text("Rust"));
    }

    /// Replaces `cx.update_global::<SettingsStore, _>` + `read_with`: settings are a field, so
    /// mutating them is the same `.send` verb as everything else, reached the same way as `buffer`
    /// above (`editor.entity(&editor.root().settings)`) — a shared field is not a special case.
    #[test]
    fn tab_size_follows_the_shared_settings_entity() {
        let editor = fixture();

        editor.entity(&editor.root().settings).send(Settings::set_tab_size.with(2));

        assert_eq!(editor.root().tab_size, 2);
    }

    /// Replaces `cx.update_window(..).simulate_activation()` + a `cursor_blinking: bool` read.
    /// There is no window-activation field left to assert on: blink is a motion value, and this
    /// test's only honest claim left is that the editor mounts and renders without one.
    #[test]
    fn no_activation_subscription_survives_migration() {
        let editor = fixture();

        assert!(editor.contains_text("tab 4"));
    }
}
