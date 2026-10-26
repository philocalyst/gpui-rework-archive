//! Inbox — the full wiring surface in one app (07 §6, 13, 14, 15, 18).
//!
//! This sketch exists to exercise every relationship mechanism together, the way a real app
//! mixes them:
//!
//!   - `View::changed` as the ONE reaction surface (18, superseding 16 §1's `.fired()`
//!     iterators and every prior `when(…)` view child): the turn's composed delta mirrors
//!     `Inbox`'s fields, read with FIELD syntax — `&d.store.unread`/`&d.store.health` recurse
//!     into `MailStore`'s own `#[derive(Delta)]` delta (15 §3), and `d.composer.sent.take()` /
//!     `d.composer.discarded.take()` consume a child's `Handoff<T>` occurrences (18 §2).
//!     Conditionals, guards, and equality gates are ordinary Rust over `c.old`/`c.new` in the
//!     handler body — no `Option`-child edges, no derived wires for effects (18 §1 table);
//!   - `Handoff<T>` as a linear, journaled give/take source (18 §2): a child gives once
//!     (`self.sent.give(mail)`), the parent takes once in its own `changed`
//!     (`d.composer.sent.take()`) — taking IS the acknowledgement. No `Output<E>`, no `.emit`,
//!     no `.fired()`, no embed function, no compile-checked required-output parameter: a
//!     component is a plain field child again, and its "output" is read the same way any other
//!     state change is read;
//!   - `Target<K>` for focus, labeling, tests, and typed-space placement (`.below(target)`);
//!   - plain-serde journaling over all of it — no ids, no skips, restore = re-derivation (13 §1)
//!     — and a `Handoff` in flight survives the SAME round trip: give, checkpoint, crash,
//!     restore, take (18 §2 point 1, §6 gate 3);
//!   - all three children rungs (implicit `&list`, `each(f)`, iterator) in one view (14 §2);
//!   - the async ladder: `List::follow` for latest-wins search, an `.action(…)` for the send
//!     mutation (12 §2, §6); a boundary owning first readiness (07 §7.2);
//!   - nullary `div()` as the box primitive; flow containers born with children (14 §2.1).
//!
//! Syntax sketch against 07 + passes 11–16, 18 (17's `Out`/catcher machinery was never applied
//! to this corpus and is superseded before adoption — see 18 §0); not expected to compile
//! against current GPUI.

use gpui::prelude::*;

// ════════════════════════════════════════════════════════════════════════════════════════════
// The store: an independently-owned entity other views observe. `#[derive(Delta)]` (15 §3.1) is
// the store's entire "subscription API" now — observers reach `&d.store.unread`/`&d.store.health`
// (field syntax, 18 §3) straight off `Inbox::changed`'s delta, no edge to declare at all; there
// is no separate typed-event contract either (`Emitter`/`StoreEvent` are gone — see
// `Inbox::changed` below).
// ════════════════════════════════════════════════════════════════════════════════════════════

/// Sync health as a plain signal field, not a typed event: it participates in `MailStoreDelta`
/// like any other field, so a failure is just another `if let Some(c) = &d.store.health` in the
/// SAME `Inbox::changed` that already handles `unread` — the "smallest consistent shape" the doc
/// asks for (15 §3), rather than a second parallel channel (a typed event, or a second delta
/// read) for one boolean fact.
#[derive(Clone, PartialEq, Serialize, Deserialize)]
enum SyncHealth {
    Ok,
    Failed { detail: String },
}

#[derive(Delta, Serialize, Deserialize)]
struct MailStore {
    unread: Signal<u32>,
    account: Signal<String>,
    health: Signal<SyncHealth>,
}
// generates (structdiff-shaped, 15 §3.1):
// struct MailStoreDelta {
//     unread:  Option<Change<u32>>,
//     account: Option<Change<String>>,
//     health:  Option<Change<SyncHealth>>,
// }

impl MailStore {
    fn mark_read(&mut self, thread: ThreadId) {
        *self.unread = self.unread.saturating_sub(1);
        let _ = thread;
    }

    /// Demo/test stimulus: a new message arrived. In a real backend this is wherever the sync
    /// engine lands new mail; here it just bumps `unread`, which is enough to drive both arms of
    /// `Inbox::changed` below (the delta-guarded chime and the badge's equality gate).
    fn receive(&mut self) {
        *self.unread += 1;
    }

    fn fail_sync(&mut self, detail: String) {
        *self.health = SyncHealth::Failed { detail };
    }
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// A reusable component whose "API" is its own state (18 §1). Note what is NOT here (14 §4, 18
// §5): no constructor route, no embed function, no `Output<E>`. `sent` and `discarded` are both
// consume-once occurrences — a value-carrying send and a plain discard — so both are
// `Handoff<T>` cells (18 §2): a linear give/take source, journaled like any other field, so the
// whole struct still derives serde with zero attributes. CONTRAST: 18 §1's OTHER idiom is a
// resting lifecycle enum (`Stage { Editing, Sent(OutgoingMail), Discarded }` in a `Signal`),
// which is the right shape when the state should persist until something else changes it (the
// doc's own worked example). Here both occurrences are consumed exactly once by the same parent
// in the same turn, so a `Handoff` per occurrence is the smaller, more precise fit — flagged as
// a deliberate choice, not the only legal one.
// ════════════════════════════════════════════════════════════════════════════════════════════

struct OutgoingMail {
    to: String,
    subject: String,
    body: String,
}

struct Discarded;

#[derive(Serialize, Deserialize)]
pub struct Composer {
    to: Signal<String>,
    subject: Signal<String>,
    body: Signal<String>,
    /// Linear give/take sources (18 §2), not endpoints: `sent` carries the composed mail across
    /// the give; `discarded` carries nothing (a plain occurrence, still a `Handoff` rather than
    /// a bool signal because it is consume-once, not resting state). Nobody "binds" either one —
    /// the host reads `d.composer.sent.take()` / `d.composer.discarded.take()` in its own
    /// `changed` (`Inbox::changed` below).
    pub sent: Handoff<OutgoingMail>,
    pub discarded: Handoff<Discarded>,
    /// Parts as public targets (07 §11): the host can focus/label/place against them.
    pub first_field: Target<TextInput>,
}

impl Composer {
    fn new() -> Self {
        Self {
            to: Signal::new(String::new()),
            subject: Signal::new(String::new()),
            body: Signal::new(String::new()),
            sent: Handoff::new(),
            discarded: Handoff::new(),
            first_field: Target::new(),
        }
    }

    fn send(&mut self) {
        if self.to.is_empty() {
            self.first_field.claim_focus(); // queued verb; applied after commit (12 §7f)
            return;
        }
        // Gives into the handoff — durable, journaled, FIFO if given more than once before the
        // parent takes (18 §2 points 1 and 3). Taking, not giving, is the acknowledgement.
        self.sent.give(OutgoingMail {
            to: self.to.clone(),
            subject: self.subject.clone(),
            body: self.body.clone(),
        });
    }

    fn discard(&mut self) {
        self.body.clear(); // autoderef through DerefMut publishes
        self.discarded.give(Discarded);
    }
}

impl View for Composer {
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.to).target(self.first_field).focus_default(),
            text_input(&self.subject),
            textarea(&self.body).rows(6),
            row((
                button("Send").on_click(Composer::send),
                button("Discard").on_click(Composer::discard),
            ))
            .gap(8),
        ))
        .gap(8)
        .on_key(Key::Enter.primary(), Composer::send)
    }
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// The host. Embeds die (18 §5): `&self.composer` is a child again, a plain field, mounted
// directly in `view` with no wrapping function and no binding call anywhere. Fields obey 14 §4's
// closed law: data, sources, `Handoff<T>` cells, and `Target<K>` — nothing else. Every
// relationship lives in `changed` (18 §1) — never in `view` — so the serde derive is
// attribute-free and restore is mechanical: deserialize rebuilds this tree, including any
// `Handoff` still holding an untaken value (18 §2 point 1); `changed` needs no re-arming because
// it is a provided trait method, not a stored edge.
// ════════════════════════════════════════════════════════════════════════════════════════════

#[derive(Serialize, Deserialize)]
struct Thread {
    id: ThreadId,           // domain data (a server id) — not a GPUI identity
    from: String,
    subject: String,
    snippet: String,
    unread: bool,
}

#[derive(Serialize, Deserialize)]
struct Inbox {
    store: Entity<MailStore>,
    threads: List<Thread>,
    selected: Selected<Thread>,        // Signal<Option<Slot<Thread>>>; journal remaps the slot
    query: Signal<String>,
    muted: Signal<bool>,               // gates the chime arm inside `changed` — an ordinary `if`
    composing: Signal<bool>,
    composer: Composer,                // plain field child (18 §1/§5) — no embed, no binding
    search_box: Target<TextInput>,
    thread_list: Target<ListView>,
}

impl Inbox {
    fn new(store: Entity<MailStore>) -> Self {
        let inbox = Self {
            store,
            threads: List::new(),
            selected: Signal::new(None),
            query: Signal::new(String::new()),
            muted: Signal::new(false),
            composing: Signal::new(false),
            composer: Composer::new(),
            search_box: Target::new(),
            thread_list: Target::new(),
        };
        // The async ladder, rung 1 territory (12 §2b): the list FOLLOWS a derived reader.
        // Latest-wins, debounce, stale rejection all ride the reader's stamps; matching ids
        // keep their slots, so selection and row focus survive a refresh.
        inbox
            .threads
            .follow(inbox.query.debounce(200.ms()).try_map_async(search_threads), |t| t.id);
        inbox
    }

    // ── Handlers ────────────────────────────────────────────────────────────────────────────

    fn chime(&mut self) {
        // NOTE: illustrative stub — plays the new-mail sound.
    }

    /// Called from `Inbox::changed` once it takes `d.composer.sent` (18 §2) — taking the
    /// handoff IS the acknowledgement, so this body never has to signal back to `Composer`.
    fn mail_sent(&mut self, mail: OutgoingMail) {
        // Rung 2 (07 §7.8): a user-triggered mutation is an action with explicit policy —
        // not a latest-wins read. Completion routes are methods, like everything else.
        self.action(send_mail(mail))
            .queue(Queue::Reliable)
            .then(Inbox::send_confirmed)
            .catch(Inbox::send_failed);
        *self.composing = false;
        self.search_box.claim_focus();
    }

    fn send_confirmed(&mut self, _receipt: Receipt) {}

    fn send_failed(&mut self, error: SendError) {
        *self.composing = true; // reopen with the draft intact — Composer state never left
        self.announce(Assertive, error);
    }

    fn open_thread(&mut self, slot: Slot<Thread>) {
        *self.selected = self.threads.contains(slot).then_some(slot);
        if let Some(thread) = self.threads.get(slot) {
            self.store.send(MailStore::mark_read.with(thread.id));
        }
    }

    fn toggle_mute(&mut self) {
        *self.muted = !*self.muted;
    }

    fn compose(&mut self) {
        *self.composing = true;
        self.composer.first_field.claim_focus();
    }
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// The view and the reaction. `view` is 100% presentation — all three children rungs, placement,
// targets, a boundary, zero wrappers, and zero reaction constructs (18 §6 gate 1). `changed` is
// the sibling method that reacts: the subscription set is `Inbox`'s field set, so there is
// nothing to declare — the turn's composed delta mirrors the struct, and the handler decides
// "how" with ordinary Rust over `c.old`/`c.new` in field syntax (18 §3). Nothing here is
// registration-by-side-effect, and nothing is a field.
// ════════════════════════════════════════════════════════════════════════════════════════════

impl View for Inbox {
    fn view(&self) -> El<'_> {
        let sidebar = column((
            row((
                text_input(&self.query)
                    .target(self.search_box)
                    .focus_default()
                    .placeholder("Search mail"),
                compose_button(),
            ))
            .gap(8),
            // Rung 1 of the children ladder (14 §2): rows are views → implicit, delta-wired.
            virtual_list(&self.threads)
                .target(self.thread_list)
                .scroll(Axis::Y)
                .on_select(Inbox::open_thread),
            // Rung 2: an ALTERNATE projection of the same rows — `each` earns its keep only
            // when you are choosing the view, not restating it.
            row(self.threads.each(Thread::unread_dot)).gap(4),
        ))
        .gap(12)
        .w(320);

        let reading_pane = boundary().loading(thread_skeleton).child(
            self.selected
                .map(|slot| self.threads.get(slot))
                .flatten()
                .map(Thread::view), // Option<El> is a normal child; None = empty pane
        );

        column((
            row((
                sidebar,
                div().w(1).bg(theme.border), // nullary div: the box primitive (14 §2.1)
                reading_pane,
            ))
            .gap(16),
            // Placement algebra (13 §3.3): the composer floats over everything, box-space;
            // the mute hint anchors to a TARGET — typed-space placement, no layout gymnastics.
            // `Composer` mounts as a plain field child (18 §5) — no embed, no output binding at
            // this call site at all; `Inbox::changed` below takes `d.composer.sent`/`.discarded`
            // instead.
            dialog(&self.composer)
                .open(&self.composing)
                .trap_focus()
                .align(Align::Center),
            self.muted
                .then(|| mute_hint().below(self.thread_list)),
        ))
        .on_key(Key::N.primary(), Inbox::compose)
        .on_key(Key::M.primary(), Inbox::toggle_mute)
    }

    /// The one reaction surface (18 §1): the composed delta mirrors `Inbox`'s fields, read with
    /// FIELD syntax throughout (18 §3). Independent concerns are independent `if`s, not one
    /// match forced over unrelated fields.
    fn changed(&mut self, d: Changed<'_, Inbox>) {
        if let Some(c) = &d.store.unread {
            // The muted conditional moved IN from the deleted `Option`-child edge — ordinary
            // Rust over the delta, not a torn-down/re-armed wire.
            if c.new > c.old && !*self.muted {
                self.chime();
            }
            // Replaces the separate derived `when(self.store.unread.map(badge_level), …)` edge:
            // the equality gate is now inline over old/new, unconditional on `muted` — badge and
            // chime are independent arms, not coupled by a shared edge.
            if badge_level(c.new) != badge_level(c.old) {
                self.set_dock_badge(badge_level(c.new));
            }
        }
        if let Some(c) = &d.store.health {
            if let SyncHealth::Failed { detail } = &c.new {
                self.announce(Polite, detail.clone());
            }
        }
        // A child's Handoff, taken here (18 §2): `Composer::send` gave `sent` with the composed
        // mail; taking it IS the acknowledgement, no ack signal travels the other way. Folds in
        // what `mail_sent` used to receive as a directly-routed argument.
        if let Some(mail) = d.composer.sent.take() {
            self.mail_sent(mail);
        }
        // `discarded` carries no payload, but it is still a Handoff, not a bool: consume-once,
        // not resting state (18 §1 vs §2). `.take().is_some()` is the "did it happen" read for a
        // data-free occurrence, the Handoff-shaped analogue of the deleted `Output<E>.fired()`.
        if d.composer.discarded.take().is_some() {
            *self.composing = false;
            self.search_box.claim_focus();
        }
    }
}

impl View for Thread {
    fn view(&self) -> El<'_> {
        column((
            text(&self.from).text_sm().semibold(),
            text(&self.subject),
            text(&self.snippet).text_sm().text_muted(),
        ))
        .gap(4)
        .p(12)
    }
}

impl Thread {
    fn unread_dot(&self) -> El<'_> {
        div()
            .size(8)
            .rounded_full()
            .bg(if self.unread { theme.accent } else { theme.border })
    }
}

// Leaf helpers hide their plumbing: `impl Element`, no lifetime, no El<'static> (14 §1.2).

fn compose_button() -> impl Element {
    button("Compose").on_click(Inbox::compose)
}

fn mute_hint() -> impl Element {
    // Rung 3 of the children ladder: plain data maps as an ordinary iterator.
    row(["Muted", "⌘M to unmute"].iter().map(|s| text(*s).text_xs().text_muted())).gap(6)
}

fn thread_skeleton() -> impl Element {
    column((skeleton_line(0.4), skeleton_line(0.9), skeleton_line(0.8))).gap(8).p(12)
}

fn badge_level(unread: &u32) -> BadgeLevel {
    match unread {
        0 => BadgeLevel::None,
        1..=9 => BadgeLevel::Count(*unread),
        _ => BadgeLevel::Many,
    }
}

fn main() {
    Application::new()
        .runtime(AsyncDriver::tokio(tokio::runtime::Handle::current()))
        .journal("inbox") // restores this tree if present; every source producer re-derives (18 §2)
        .open(Window::document(Inbox::new(Entity::new(MailStore::connect()))).title("Inbox"))
        .run();
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// Tests: the wiring semantics, asserted.
// ════════════════════════════════════════════════════════════════════════════════════════════

#[cfg(test)]
mod tests {
    use super::*;

    fn fixture() -> Win<Inbox> {
        Win::demo(Inbox::new(Entity::new(MailStore::fake_with_unread(3))))
    }

    /// Renamed from `required_output_routes_to_the_host_and_focus_returns` (16): there is no
    /// route to route anymore — the UI drives a give, and `Inbox::changed` takes it in the SAME
    /// mechanism as every other reaction (18 §1/§2). The observable outcome is unchanged; how it
    /// gets there is not.
    #[test]
    fn the_sent_handoff_is_taken_in_changed_and_focus_returns() {
        let inbox = fixture();

        inbox.key(Key::N.primary()); // open composer; claim lands after the dialog commits
        assert!(inbox.focused(inbox.root().composer.first_field));

        inbox.type_text(inbox.root().composer.first_field, "ada@example.com");
        inbox.key(Key::Enter.primary()); // Composer::send gives into `sent`

        // `Inbox::changed` took `d.composer.sent` and ran `mail_sent`: composer closed, reliable
        // action queued, focus claimed back to search — all host policy, none of it composer
        // code, and none of it a routed callback.
        assert!(!*inbox.root().composing);
        assert_eq!(inbox.pending_actions(Queue::Reliable), 1);
        assert!(inbox.focused(inbox.root().search_box));
    }

    /// A handoff is linear (18 §6 gate 2): the second take in the same turn is `None`, not a
    /// second delivery. Replaces 16's `unwired_required_output_is_a_located_mount_error`, which
    /// tested a compile-time requiredness that no longer exists — a `Handoff` is read, not
    /// required, and nothing stops a caller from ignoring one.
    ///
    /// NOTE: what this test does NOT (and cannot, at this level) show is 18 §2 point 2's other
    /// half — an untaken handoff still full at TURN END is a located inspector diagnostic naming
    /// giver and non-taker. That is a property of the kernel's end-of-turn admission, not of
    /// `Composer`/`Inbox`'s own code, so it has no assertion here; it is asserted directly on the
    /// diagnostic surface wherever that surface's own tests live.
    #[test]
    fn a_handoff_takes_at_most_once() {
        let mut composer = Composer::new();
        *composer.to = "ada@example.com".into();
        composer.send();

        assert!(composer.sent.take().is_some());
        assert!(composer.sent.take().is_none());
    }

    /// The crash-safe delivery fixture no event system can pass (18 §2 point 1, §6 gate 3): give,
    /// checkpoint, restore, take — the value survives with nothing "listening" in between. Run
    /// against a bare `Composer` (no `Inbox` parent to take it in the same turn) so the window
    /// between give and take is actually observable here rather than closed within one commit.
    #[test]
    fn a_handoff_survives_a_journal_round_trip_before_being_taken() {
        let composer = Win::demo(Composer::new());
        composer.type_text(composer.root().first_field, "ada@example.com");
        composer.key(Key::Enter.primary()); // gives into `sent`; nothing here takes it

        let journal = composer.app().journal_checkpoint(); // value still in flight, unread
        let restored = Win::demo_restored(journal);

        let mail = restored.root().sent.take().expect("the handoff survived the round trip");
        assert_eq!(mail.to, "ada@example.com");
    }

    #[test]
    fn the_mute_guard_moved_into_the_handler() {
        let inbox = fixture();

        inbox.entity(&inbox.root().store).send(MailStore::receive);
        assert_eq!(inbox.dock_badge(), BadgeLevel::Count(4)); // badge arm: unconditional
        assert_eq!(inbox.chime_count(), 1); // chime arm: not muted, so it ran

        inbox.key(Key::M.primary()); // muted = true — `changed` still runs every turn (there is
        // no edge to tear down, 18 §6 gate 5, unchanged from 16 §2); the `!*self.muted` guard
        // inside it just no-ops. With #[reactive] absent this changes invocation counters only,
        // never behavior.
        inbox.entity(&inbox.root().store).send(MailStore::receive);
        assert_eq!(inbox.dock_badge(), BadgeLevel::Count(5)); // badge arm is independent of mute
        assert_eq!(inbox.chime_count(), 1); // chime arm: guard suppressed it

        inbox.key(Key::M.primary()); // unmuted again
        inbox.entity(&inbox.root().store).send(MailStore::receive);
        assert_eq!(inbox.dock_badge(), BadgeLevel::Count(6));
        assert_eq!(inbox.chime_count(), 2); // chime arm: guard passes again
    }

    #[test]
    fn the_whole_tree_journals_with_zero_attributes() {
        let inbox = fixture();
        inbox.type_text(inbox.root().search_box, "invoices");
        inbox.key(Key::N.primary());
        inbox.type_text(inbox.root().composer.first_field, "draft@example.com");
        let journal = inbox.app().journal_checkpoint();

        let restored = Win::demo_restored(journal);
        // Data and sources came back — including the composer draft mid-flight.
        assert_eq!(*restored.root().query, "invoices");
        assert_eq!(*restored.root().composer.to, "draft@example.com");
        assert!(restored.focused(restored.root().composer.first_field));
        // `Target`s re-mint fresh (PhantomData-style); a `Handoff` does NOT — see
        // `a_handoff_survives_a_journal_round_trip_before_being_taken` above for that half of the
        // restore story (18 §2 point 1). `changed` needs no re-arming at all — it is a provided
        // trait method invoked by the kernel for any `View`, not a stored edge. Restore =
        // re-derivation now means there is no wire count to check, only behavior: a store commit
        // reaches `Inbox::changed` immediately post-restore.
        restored.entity(&restored.root().store).send(MailStore::receive);
        assert_eq!(restored.dock_badge(), BadgeLevel::Count(4));
    }
}
