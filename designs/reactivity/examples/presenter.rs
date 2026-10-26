//! Presenter — the signal-dense tier, end to end.
//!
//! This example uses the one optional `#[reactive]` macro because two projections contain several
//! related signal/list branches. The bodies remain ordinary Rust. It also demonstrates shared
//! typed ownership, regular method guards, structural journal persistence, two windows through
//! `Application::open`, and tests through `Application::demo`.
//!
//! Persistence is plain serde (13 §1.2), not a `History` trait with a scope type: `Deck` derives
//! `Serialize`/`Deserialize`, the application names one journal (`Application::new().journal(…)`),
//! and restoring is calling the SAME constructor (`open_presenter`) again against a checkpoint —
//! "cold start, restore, and reconnect are one code path." There is no restore-UI code anywhere
//! in this file; the typed `current: Selected<Slide>` slot simply comes back, remapped by the
//! journal.

use gpui::prelude::*;

struct Slide {
    body: RichText,
    notes: String,
}

impl View for Slide {
    fn view(&self) -> El<'_> {
        // Styled box, one child (14 §2.1) — `column()` never takes zero args.
        div().p(48).gap(24).child(rich(&self.body))
    }
}

/// Branched over below (both `Canvas::view` and `PresenterScreen::view` join it against
/// `Slide::view()` in a `match`), so it keeps a named, nameable `El<'static>` rather than the
/// leaf `impl Element` spelling — `El`'s lifetime is covariant, so this unifies with the `El<'_>`
/// arm with no `el(…)` join (14 §1.2).
fn end_card() -> El<'static> {
    div()
        .size_full()
        .center()
        .text_color(0x94a3b8)
        .text_3xl()
        .child(text("End of deck"))
}

#[derive(Serialize, Deserialize)]
struct Deck {
    slides: List<Slide>,
    // A slot is identity, not an index. Both the signal publication and list edit are journaled;
    // `Selected<T>` (11 §9) is the alias for `Signal<Option<Slot<T>>>`.
    current: Selected<Slide>,
    blackout: Signal<bool>,
}

impl Deck {
    fn next(&mut self) {
        *self.current = self.slides.next_slot(*self.current);
    }

    fn previous(&mut self) {
        *self.current = self.slides.previous_slot(*self.current);
    }

    fn first(&mut self) {
        *self.current = self.slides.first_slot();
    }

    fn last(&mut self) {
        *self.current = self.slides.last_slot();
    }

    // The guard belongs to the function. `B` is not conditionally registered.
    fn blackout(&mut self, event: KeyEvent) -> KeyEvent {
        if self.current.is_none() {
            return event.propagate();
        }

        *self.blackout = !*self.blackout;
        event.consume()
    }

    fn current_slide(&self) -> Option<&Slide> {
        self.slides.get((*self.current)?)
    }

    fn next_slide(&self) -> Option<&Slide> {
        self.slides.get(self.slides.next_slot(*self.current)?)
    }

    fn notes(&self) -> &str {
        self.current_slide()
            .map_or("—", |slide| slide.notes.as_str())
    }

    fn progress(&self) -> String {
        let position = (*self.current)
            .and_then(|slot| self.slides.index_of(slot))
            .map_or(0, |index| index + 1);
        format!("{position} / {}", self.slides.len())
    }
}

/// Full-bleed audience projection.
struct Canvas {
    deck: Entity<Deck>,
}

impl View for Canvas {
    #[reactive]
    fn view(&self) -> El<'_> {
        let current = match self.deck.current_slide() {
            Some(slide) => slide.view(),
            None => end_card(),
        };

        column((
            current,
            // This is already a direct property port. It does not need a macro-generated region.
            // Hiding instead of branching keeps the current slide mounted during blackout.
            div().absolute().inset_0().bg(Color::Black).open(&self.deck.blackout),
        ))
        .bg(Color::Black)
        .on_key(Key::Right, Deck::next)
        .on_key(Key::Space, Deck::next)
        .on_key(Key::Left, Deck::previous)
        .on_key(Key::Home, Deck::first)
        .on_key(Key::End, Deck::last)
        .on_key(Key::B, Deck::blackout)
    }
}

/// Same entity, independently scheduled presenter projection.
struct PresenterScreen {
    deck: Entity<Deck>,
}

impl View for PresenterScreen {
    #[reactive]
    fn view(&self) -> El<'_> {
        let now = match self.deck.current_slide() {
            Some(slide) => slide.view(),
            None => end_card(),
        };

        let next = match self.deck.next_slide() {
            Some(slide) => slide.view(),
            None => end_card(),
        };

        // Two children arranged in two fractional columns is genuinely a grid, not a styled box —
        // `grid((…))` is the flow container that takes them in the constructor (14 §2.1 decision
        // 6: flow containers are unary; `div()` alone stays nullary). The `Grid::columns(…)`
        // recipe stays its own typed builder either way (13 §3's layout-family split, kept by
        // 14 §1.2 point 5); what changed is only which constructor honestly owns these children.
        grid((
            column((text("Now").text_sm().text_color(Fg::Muted), now)).gap(12),
            column((
                text("Next").text_sm().text_color(Fg::Muted),
                next,
                text(self.deck.notes()),
                text(self.deck.progress()),
            ))
            .gap(12),
        ))
        .layout(Grid::columns((Fraction(2), Fraction(1))).gap(16))
        .p(16)
    }
}

fn open_presenter(
    mut app: Application,
    deck: Deck,
) -> (Application, Entity<Deck>, Win<Canvas>, Win<PresenterScreen>) {
    // `Entity<T>` is a typed facade. The application owns the non-generic allocation/scheduler.
    let deck = app.entity(deck);

    let audience = app.open(
        Window::document(Canvas { deck: deck.share() })
            .title("Audience")
            .titlebar(Titlebar::Hidden)
            .corners(WindowCorners::Square),
    );
    let presenter = app.open(
        Window::utility(PresenterScreen { deck: deck.share() })
            .title("Presenter")
            .size(960, 600),
    );

    (app, deck, audience, presenter)
}

fn main() {
    let (app, _, _, _) = open_presenter(
        Application::new().journal("presenter"),
        load_deck("talk.slides"),
    );
    app.run();
}

#[cfg(test)]
mod tests {
    use super::*;

    fn fixture() -> Deck {
        Deck {
            slides: List::from([
                Slide {
                    body: rich_text("One"),
                    notes: "first note".into(),
                },
                Slide {
                    body: rich_text("Two"),
                    notes: "second note".into(),
                },
                Slide {
                    body: rich_text("Three"),
                    notes: "third note".into(),
                },
            ]),
            current: Signal::new(None),
            blackout: Signal::new(false),
        }
    }

    #[test]
    fn both_windows_observe_one_typed_entity() {
        let (_app, deck, mut audience, presenter) =
            open_presenter(Application::demo().journal("presenter"), fixture());

        audience.key(Key::Home);
        audience.key(Key::Right);

        assert_eq!(deck.progress(), "2 / 3");
        assert!(audience.contains_text("Two"));
        assert!(presenter.contains_text("second note"));
        assert!(presenter.contains_text("Three"));
    }

    #[test]
    fn blackout_uses_rust_control_flow_and_preserves_the_slide() {
        let (_app, deck, mut audience, presenter) =
            open_presenter(Application::demo().journal("presenter"), fixture());

        let before_first_slide = audience.key(Key::B);
        assert!(before_first_slide.propagated());
        assert!(!*deck.blackout);

        audience.key(Key::Home);
        let while_presenting = audience.key(Key::B);

        assert!(while_presenting.consumed());
        assert!(*deck.blackout);
        assert!(audience.contains_mounted_text("One"));
        assert!(audience.is_visually_black());
        assert!(!presenter.is_visually_black());
    }

    #[test]
    fn journal_restores_the_typed_slot_without_restore_ui_code() {
        let (app, _deck, mut audience, _presenter) =
            open_presenter(Application::demo().journal("presenter"), fixture());
        audience.key(Key::End);
        let journal = app.journal_checkpoint();

        // Restart: the SAME constructor (`open_presenter`), the SAME fixture — cold start and
        // restore are one code path (13 §1.2). `.restore(journal)` remaps the journaled `current`
        // slot onto the freshly constructed slide list; there is no restore-UI code to write.
        let (_restarted, restored, restarted_audience, _presenter) =
            open_presenter(Application::demo().restore(journal), fixture());

        assert_eq!(restored.progress(), "3 / 3");
        assert!(restarted_audience.contains_text("Three"));
    }
}
