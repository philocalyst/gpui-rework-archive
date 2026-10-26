//! Derived observation — the field-grain, equality-gated effect that reach.rs leaves out.
//!
//! [reach.rs](reach.rs) shows the two ENTITY-GRAIN cases of 07 §6.4, both read off
//! `Workspace::changed`'s delta (18 §1): `d.buffer.any()` fires after ANY committed `&mut` turn
//! dirties the entity; `&d.project.root` reads a plain field change, field syntax. Both are
//! whole-entity coarse. This file shows the case that sits between them and a value wire: react
//! to a *derived field* changing, equality-gated, as an EFFECT — the classic "reconfigure the
//! language server when the buffer's language changes" shape. Typing into the buffer dirties it
//! on every keystroke, but the language flips rarely; the effect must run at language-change
//! frequency, not keystroke frequency.
//!
//! The lesson, pass 18: derived-and-gated observation is not a wiring construct at all — it is
//! ORDINARY RUST in `Editor::changed`'s body, over `c.old`/`c.new` (18 §1/§3). `&d.doc.text`
//! reaches the entity-grain field, field syntax; `detect_language` projects `old` and `new`
//! independently; a plain `if new_lang != old_lang` is the equality gate, written out instead of
//! living inside a wire. `#[reactive]` narrows invocation to exactly this read pattern — the
//! gate-3 symmetry extended from views to reactions (18 §6 gate 5, unchanged from 16 §2) — so
//! removing the attribute changes how many times `changed` is CALLED, never what it DOES: without
//! it, `changed` runs on every `Buffer` commit and the `if` inside still fires the effect only on
//! an actual language change.
//!
//! What this deliberately does NOT contain: no `Subscription` field, no stored handle, no
//! `Watched<T>` wrapper (killed; see 10 §2.7), no `Task` field, and no auto-rerunning reactive
//! effect (07 has none — an effect only ever runs from a handler, and `changed` is that handler).
//! The fire-and-forget rebuild itself uses `self.spawn_latest` (12 §2a) — the same stamped,
//! owner-scoped, latest-wins spawn verb reach.rs's index rebuild uses, not the unnamed
//! `self.spawn` 12 §6 retires.
//!
//! What this replaced: 07's `cx.observe` forced a manual `if new != old` diff at every call site;
//! 15 §2.1 moved the gate into a `when(derived_source, route)` view child, closing gap #3 in
//! 10-from-cx.md but keeping a second, declarative wiring surface next to `view`; 16 §1 deleted
//! that surface, respelling the read as a `.text()` method call on the delta; 18 keeps the
//! deletion and respells the read again, as a FIELD (`d.doc.text`, not `d.doc.text()`) — the gate
//! is still just an `if` in `changed`, and the macro is still the only thing that "discovers" an
//! edge, by static analysis of the handler body rather than by declaration.

use gpui::prelude::*;

#[derive(Clone, PartialEq, Eq)] // PartialEq IS the equality gate the derived wire uses
pub enum Language {
    PlainText,
    Rust,
    Shell,
    Python,
}

#[derive(Delta)] // load-bearing (18 §3): this is what gives `d.doc.text` its `old`/`new`, field syntax
pub struct Buffer {
    text: Signal<String>,
}

impl Buffer {
    pub fn new() -> Self {
        Self {
            text: Signal::new(String::new()),
        }
    }

    /// Derived value as a METHOD (like reach.rs::dirty): reading it in a view records the
    /// dependency through the call. Shares `detect_language` with the wire below, so the view
    /// label and the effect can never disagree about what the language is.
    pub fn language(&self) -> Language {
        detect_language(&self.text)
    }
}

pub struct Editor {
    doc: Entity<Buffer>,
    lang: Language, // last-configured language (committed); no Subscription field, no Task field
}

impl Editor {
    pub fn new(doc: Entity<Buffer>) -> Self {
        // No wire registration here, and no reaction construct anywhere in `view` either (18 §6
        // gate 1): the equality gate lives in `Editor::changed`'s body, below.
        Self {
            doc,
            lang: Language::PlainText,
        }
    }

    /// Called from `Editor::changed` only when the projected language actually changed this
    /// turn — the equality gate lives in the CALLER now, over `c.old`/`c.new` (18 §1). The new
    /// `Language` arrives by value.
    fn reconfigure_lsp(&mut self, lang: Language) {
        self.lang = lang.clone();
        // `self.spawn_latest` (12 §2a): stamped, owner-scoped, latest-wins, revoked on unmount —
        // the same verb reach.rs's index rebuild uses. A rebuild superseded by a newer language
        // change cannot publish; there is no epoch field to check by hand. The future's `()`
        // output is discarded, so the completion handler is trivial.
        self.spawn_latest(Editor::lsp_reconfigured, reconfigure_language_server(lang));
    }

    fn lsp_reconfigured(&mut self, _: ()) {}
}

impl View for Editor {
    fn view(&self) -> El<'_> {
        column((
            // A value WIRE into the buffer's cell — no subscription, patches with no describe of
            // Editor or Buffer. This is the "want a value, not an effect" path (07 §6.4).
            text_input(&self.doc.text),
            // A derived value read straight in describe: recorded as a dependency through the
            // call, equality-gated the same way, so this label re-describes only when the
            // language flips.
            text(format!("{:?}", self.doc.language())),
        ))
    }

    /// FIELD-GRAIN, EQUALITY-GATED EFFECT — the pedagogical contrast this file exists to draw,
    /// respelled for 18 §1's table (row 2), field syntax throughout (18 §3): `&d.doc.text`
    /// reaches through `Entity<Buffer>` into `Buffer`'s own `#[derive(Delta)]` delta (15 §3),
    /// delivering `old`/`new` `String`s. `detect_language` projects both independently, and
    /// `new_lang != old_lang` IS the equality gate — written out as an `if`, not living inside a
    /// wire. A keystroke that leaves the language alone costs one comparison and zero calls to
    /// `reconfigure_lsp`.
    ///
    /// FLOOR contrast: if `Buffer` did NOT derive `Delta`, `d.doc` would degrade to a
    /// changed/unchanged marker (18 §1) — the shape is identical, just reading `d.doc.language()`
    /// (a peek via `Deref`) instead of `c.old`/`c.new` off the delta. Either way the gate is
    /// handler-body Rust; there is no wire left to push it into.
    fn changed(&mut self, d: Changed<'_, Editor>) {
        if let Some(c) = &d.doc.text {
            let (old_lang, new_lang) = (detect_language(c.old), detect_language(c.new));
            if new_lang != old_lang {
                self.reconfigure_lsp(new_lang);
            }
        }
    }
}

fn main() {
    Application::run(Window::document(Editor::new(Entity::new(Buffer::new()))).title("Derived Observe"));
}

// ── The guarantee this example exists to pin ────────────────────────────────────────────────────
//
// GATE-3 SYMMETRY, EXTENDED TO REACTIONS (18 §6 gate 5, unchanged from 16 §2): `changed` is a
// provided trait method, not a stored edge — nothing to mount, arm, or tear down, so the old
// "describe → mount binding" story `when` needed (park-at-construction, arm-at-mount, weak-cycle
// teardown) simply doesn't apply anymore. What DOES carry over from views is the macro's role.
// With no `#[reactive]`, the kernel invokes `Editor::changed` post-publish whenever ANY
// field-source of `Editor` publishes — here, every `Buffer` commit — coarse and cheap (one delta
// match, one comparison, one `if`). With `#[reactive]`, the statically visible delta access
// (`d.doc.text`, field syntax — 18 §3) is cut into an exact invocation edge, so `changed` runs
// ONLY when `Buffer.text` itself published. Removing the attribute changes how many times
// `changed` is CALLED; it changes nothing about what it DOES — `reconfigure_lsp` still fires
// exactly on a language flip either way, because the equality gate lives in the `if`, not in the
// invocation frequency.
//
// TURN ORDERING (why `reconfigure_lsp` sees committed state and runs at most once per turn):
//   1. A `&mut` turn on `Buffer` mutates `text` and PUBLISHES at commit.
//   2. Post-publish, the kernel assembles the turn's delta (15 §3) and invokes `changed` once,
//      FIFO with other queued deliveries, never reentrantly (18 §6 gate 5) — `c.old`/`c.new` are
//      the committed values on both sides of the write, so `detect_language` sees a consistent pair.
//   3. Coalescing: many keystrokes in one turn ⇒ one delta, one `changed` call; if the gate says
//      the language is unchanged, `reconfigure_lsp` runs ZERO times that turn.
//   4. Then describe / paint — `view` reads `self.doc.language()` fresh, so the label and the
//      effect can never disagree about what the language is.
//
// What this replaced: `Subscription`/`Watched<T>`/`Task` fields (07/10), then a `when` child
// declared in `view` (15 §2.1, closing gap #3 in 10-from-cx.md) — each pass moved the wiring
// surface without removing it. 16 removes it: the "wire" was always just a handler with a read
// pattern, and `changed` is that handler.

// ── Illustrative stubs (not the point of the example) ───────────────────────────────────────────
fn detect_language(text: &str) -> Language {
    let first_line = text.lines().next().unwrap_or("");
    if first_line.starts_with("#!") {
        if first_line.contains("bash") || first_line.contains("sh") {
            return Language::Shell;
        }
        if first_line.contains("python") {
            return Language::Python;
        }
    }
    if first_line.starts_with("//") && first_line.contains("rust") {
        return Language::Rust;
    }
    Language::PlainText
}

async fn reconfigure_language_server(_lang: Language) {
    // spawn / restart / hand off to the matching LSP; awaits are fine, this is off the UI turn
}
