//! Typeahead — 07 §5 combobox + §6.2 named output, journal-cleaned by 14 §4, + 12 §2b's
//! derived-list search.
//!
//! Hide vs unmount is two semantics, not two macros: `popup(hits).open(&self.open)` keeps hits
//! mounted (scroll + a11y); `self.open.then(|| dialog())` unmounts. Both take `IntoVisibility`
//! (12 §8's rename of `IntoPresence`, kept distinct from `PresenceSession`'s collaboration
//! "presence"), so `open: bool` and `open: Signal<bool>` share the view line.
//!
//! What this replaced: the original hand-rolled a `epoch: u32` field, bumped it, captured
//! `(remote, epoch)`, spawned `tokio::spawn`, and rejected stale results with `if epoch !=
//! self.epoch { return; }` — six pieces of bookkeeping to say "latest wins" (12 §2). `hits` is a
//! `List` with durable slots and an active-selection field, so it could not spell
//! `query.try_map_async(search)` directly; `List::follow` bridges exactly that gap: it reconciles
//! each admitted result into the list by key, existing rows keep their slots (selection, focus,
//! edit state survive a refresh), and staleness/cancellation ride the reader's stamps. `Typeahead`
//! loses `changed`'s search call, `results`, and the epoch field entirely — what remains is pure
//! selection logic. There is no `Task` field and no framework executor. Handlers read/write
//! through `Deref`/`DerefMut`: `*self.field` reads, `*self.field = v` writes-and-publishes;
//! autoderef reaches in-place `T` methods (`self.draft.clear()`). Views return the concrete
//! `El<'_>` (14 §1.2 — views are branched on by definition), borrowing the signals/list for one
//! frame.
//!
//! `picked: Handoff<SuggestionId>` is a linear give/take source (18 §2), not an endpoint:
//! `Typeahead::new()` takes no routes at all, and there is no embed function to bind one through
//! — `choose()` gives, and the host's `Search::changed` takes `d.typeahead.picked` in its own
//! turn (18 §1). A `Handoff` is journaled STATE, unlike `Target`'s `PhantomData`-style unit
//! serialization: a value given but not yet taken survives a checkpoint/restore round trip (18
//! §2 point 1) — see inbox.rs's `a_handoff_survives_a_journal_round_trip_before_being_taken` for
//! that guarantee exercised end to end. `Typeahead` does not derive serde here, but nothing about
//! this field would stop it if it did.

use gpui::prelude::*;

pub struct Typeahead {
    query: Signal<String>,
    open: Signal<bool>,
    hits: List<Suggestion>,
    active: Selected<Suggestion>,        // = Signal<Option<Slot<Suggestion>>> (11 §9)
    picked: Handoff<SuggestionId>,       // linear give/take source (18 §2) — the host takes
                                          // `d.typeahead.picked` in its own `changed`, no binding
                                          // anywhere, no route stored here
}

pub struct Suggestion {
    id: SuggestionId,
    label: String,
}

pub enum SearchError {
    Network { detail: String },
    EmptyQuery,
}

impl std::fmt::Display for SearchError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            SearchError::Network { detail } => write!(f, "{detail}"),
            SearchError::EmptyQuery => write!(f, "Type to search"),
        }
    }
}

impl Typeahead {
    // No routes taken here (14 §4, 18 §5): the constructor got simpler as a direct side effect
    // of the field law closing, and stays simple now that there is no embed to bind through
    // either — `picked` is read by whoever holds this component as a field, in ITS `changed`.
    pub fn new() -> Self {
        let query = Signal::new(String::new());
        let hits = List::new();

        // The derived-list bridge (12 §2b): each admitted, debounced search result reconciles
        // into `hits` by suggestion id. Latest-wins, cancellation, and staleness all ride the
        // reader's request stamps — nothing here names an epoch.
        hits.follow(query.debounce(150.ms()).try_map_async(backend::search), |s| s.id);

        Self {
            query,
            open: Signal::new(false),
            hits,
            active: Signal::new(None),
            picked: Handoff::new(), // linear give/take source, journaled STATE (18 §2)
        }
    }

    fn changed(&mut self, _q: String) {
        *self.open = true; // star = publish; true→true cuts off at the port
        // NOTE: the original reset `active` to the first hit once a search landed. `List::follow`
        // preserves slots across a refresh rather than replacing them wholesale, and 11/12/13
        // don't state a verb for "re-derive a selection from a followed list's current shape" —
        // smallest option left as an open question rather than invented here. Arrow keys still
        // move `active` onto whatever is present.
    }

    fn key(&mut self, ev: KeyEvent) {
        match ev.key {
            Key::Down => *self.active = self.hits.next_slot(*self.active),
            Key::Up => *self.active = self.hits.prev_slot(*self.active),
            Key::Enter => {
                if let Some(s) = *self.active {
                    self.choose(s);
                }
            }
            Key::Escape => *self.open = false,
            _ => {}
        }
    }

    fn choose(&mut self, slot: Slot<Suggestion>) {
        *self.open = false;
        let Some(hit) = self.hits.get(slot) else { return };
        self.picked.give(hit.id); // durable, journaled; the host takes it in its own `changed`
    }

    /// Renamed from `row_el`/param `row`: the old spelling shadowed the `row(…)` container
    /// constructor with a same-named parameter (12 §8). `suggestion` names what it is.
    fn hit(suggestion: &Suggestion) -> impl Element + '_ {
        row((text(&suggestion.label),)).on_click(Typeahead::choose)
    }
}

impl View for Typeahead {
    fn view(&self) -> El<'_> {
        anchor()
            .child(
                text_input(&self.query)
                    .on_change(Typeahead::changed)
                    .on_key(Typeahead::key)
                    .active_descendant(&self.active),
            )
            .child(
                // Property, not control flow: hits stay mounted while closed.
                // self.open.then(|| popup(...)) would remount — wrong for a combobox.
                popup(&self.hits, Typeahead::hit).open(&self.open),
            )
    }
}

/// A confirm sheet *should* unmount. Same `open` field type, different combinator:
/// `then` is std `bool::then` at the floor and a region on `Signal<bool>` when live.
struct Composer {
    open: Signal<bool>,
    draft: Signal<String>,
}

impl View for Composer {
    fn view(&self) -> El<'_> {
        column((
            button("New").on_click(Composer::begin),
            self.open.then(|| {
                dialog()
                    .on_close(Composer::dismiss)
                    .child(text_input(&self.draft))
                    .child(button("Send").on_click(Composer::send))
            }),
        ))
    }
}

impl Composer {
    fn begin(&mut self) {
        *self.open = true;
    }
    fn dismiss(&mut self) {
        *self.open = false;
    }
    fn send(&mut self) {
        *self.open = false;
        self.draft.clear(); // autoderef through DerefMut publishes — no `.as_mut()`
    }
}

/// Floor: `open: bool`. `self.open.then(|| …)` is identical after promotion to `Signal<bool>`.
/// `if self.open { panel() }` is also legal here and will fail the moment `open` is a Signal.
struct Settings {
    open: bool,
}

impl View for Settings {
    fn view(&self) -> El<'_> {
        self.open.then(|| panel().child(text("Advanced")))
    }
}

/// A minimal host so `Typeahead::picked` has somewhere to be taken.
struct Search {
    typeahead: Typeahead,
    chosen: Signal<Option<SuggestionId>>,
}

impl Search {
    fn new() -> Self {
        Self {
            typeahead: Typeahead::new(), // no route argument (14 §4, 18 §5) — plain field child
            chosen: Signal::new(None),
        }
    }
}

impl View for Search {
    fn view(&self) -> El<'_> {
        // Plain field child (18 §5) — no embed, no output binding at the mount site at all.
        // Styled box, one child (14 §2.1) — `column()` never takes zero args.
        div().gap(12).p(24).child(&self.typeahead)
    }

    /// The recursive delta reaches straight into the child: `d.typeahead.picked` is this turn's
    /// `Option<Given<SuggestionId>>` off `Typeahead`'s own field set (18 §1/§2) — no route, no
    /// embed parameter, no forwarding method to keep in sync with `Typeahead`'s API surface.
    fn changed(&mut self, d: Changed<'_, Search>) {
        if let Some(id) = d.typeahead.picked.take() {
            *self.chosen = Some(id);
        }
    }
}

fn main() {
    Application::run(Window::document(Search::new()).title("Typeahead"));
}
