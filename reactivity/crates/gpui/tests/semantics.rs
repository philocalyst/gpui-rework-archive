//! Assistive actions and ordinary users share one input/publication barrier.
use gpui::{Action, ActionKind, Error, Role, WindowOptions, prelude::*};

#[path = "../examples/support/todos.rs"]
mod todos;

#[test]
fn semantic_actions_drive_the_real_todo_model_and_match_ordinary_input() {
    let mut semantic = Win::demo(todos::Todos::default());
    let mut ordinary = Win::demo(todos::Todos::default());
    let input = semantic.input();
    let add = semantic.button("Add");
    semantic.perform(input, Action::Focus).unwrap();
    semantic
        .perform(input, Action::SetValue("Accessible task"))
        .unwrap();
    semantic.perform(add, Action::Activate).unwrap();
    ordinary
        .type_text(ordinary.input(), "Accessible task")
        .unwrap();
    ordinary.activate(ordinary.button("Add")).unwrap();
    assert_eq!(
        semantic.source_json().unwrap(),
        ordinary.source_json().unwrap()
    );
    assert_eq!(
        semantic.scene_digest().unwrap(),
        ordinary.scene_digest().unwrap()
    );
    assert!(semantic.contains_text("Accessible task").unwrap());
    assert!(semantic.contains_text("1 left").unwrap());
    // Blurring another control must not steal the actual input's focus.
    semantic
        .perform(semantic.button("Done"), Action::Blur)
        .unwrap();
    assert_eq!(semantic.focused().unwrap(), Some(input));
    semantic.perform(input, Action::Blur).unwrap();
    assert_eq!(semantic.focused().unwrap(), None);
    let deleted = semantic.button("Delete");
    semantic.perform(deleted, Action::Activate).unwrap();
    assert_eq!(
        semantic.perform(deleted, Action::Activate),
        Err(Error::StaleTarget)
    );
}

#[derive(Default)]
struct Page {
    value: Signal<String>,
    enabled: bool,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        let action = button("Clear").w(100).h(30);
        column((
            text_input(&self.value)
                .w(100)
                .h(30)
                .on_click(Self::VALUE.update(String::clear)),
            if self.enabled {
                action.on_click(Self::VALUE.update(String::clear))
            } else {
                action
            },
        ))
    }
}

#[test]
fn one_borrowed_sheet_exposes_topology_focus_values_and_advertised_actions() {
    let mut win = Win::demo(Page {
        enabled: true,
        ..Default::default()
    });
    let input = win.input();
    win.perform(input, Action::Focus).unwrap();
    assert_eq!(
        win.perform(input, Action::Activate),
        Err(Error::NotInteractive)
    );
    let mut seen = Vec::new();
    win.visit(|part| {
        seen.push(part.target());
        if let Some(parent) = part.parent() {
            assert!(
                seen.contains(&parent),
                "parents precede children in the same sheet"
            );
        }
        match part.role() {
            Role::TextInput => {
                assert_eq!(part.target(), input);
                assert!(part.focused());
                assert_eq!(
                    part.name(),
                    None,
                    "an input value is not its accessible name"
                );
                assert_eq!(part.value(), Some(""));
                assert!(part.actions().contains(ActionKind::SetValue));
                assert!(!part.actions().contains(ActionKind::Activate));
            }
            Role::Button => {
                assert_eq!(part.name(), Some("Clear"));
                assert_eq!(part.value(), None);
                assert!(part.actions().contains(ActionKind::Activate));
            }
            _ => {}
        }
    })
    .unwrap();
    assert_eq!(seen.len(), 3);
    assert_eq!(
        std::mem::size_of::<gpui::Part<'_>>(),
        2 * std::mem::size_of::<usize>()
    );
    assert_eq!(std::mem::size_of::<gpui::Actions>(), 1);
}

#[test]
fn ahead_of_frame_source_cannot_rewrite_advertised_value_or_actions() {
    let mut win = Win::recording(
        Page {
            enabled: true,
            ..Default::default()
        },
        WindowOptions::default(),
    )
    .unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let button = win.button("Clear");
    win.update(|m| m.enabled = false).unwrap();
    let mut advertised = false;
    win.visit(|part| {
        if part.target() == button {
            advertised = part.actions().contains(ActionKind::Activate);
        }
    })
    .unwrap();
    assert!(
        advertised,
        "old complete sheet still advertises its original action"
    );
    assert_eq!(
        win.perform(button, Action::Activate),
        Err(Error::NotInteractive)
    );
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win.visit(|part| {
        if part.target() == button {
            assert!(!part.actions().contains(ActionKind::Activate));
        }
    })
    .unwrap();
    let input = win.input();
    win.perform(input, Action::Focus).unwrap();
    assert!(matches!(
        win.perform(input, Action::SetValue("漢")),
        Err(Error::Canvas(_))
    ));
    win.visit(|part| {
        if part.target() == input {
            assert_eq!(part.value(), Some(""));
            assert!(part.focused());
        }
    })
    .unwrap();
    win.perform(input, Action::SetValue("repaired")).unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win.visit(|part| {
        if part.target() == input {
            assert_eq!(part.value(), Some("repaired"));
        }
    })
    .unwrap();
}

#[test]
fn full_geometry_and_visible_bounds_come_from_the_same_retained_shape() {
    let mut win = Win::with_size(Page::default(), 160, 100).unwrap();
    let input = win.input();
    win.set_property(
        input,
        gpui::property::TRANSFORM,
        gpui::property::Contribution::Set(Affine::translation(-40., 0.)),
    )
    .unwrap();
    let visible = win.bounds(input).unwrap();
    win.visit(|part| {
        if part.target() == input {
            assert_eq!(part.bounds(), visible);
            assert_eq!(part.local_bounds(), Rect::new(0., 0., 100., 30.));
            assert_eq!(part.transform(), Some(Affine::translation(-40., 0.)));
            let full = part.unclipped_bounds().unwrap();
            assert!(full.x <= -40. && full.width >= 100.);
            assert_eq!(visible.x, 0.);
            assert!(full.width > visible.width);
        }
    })
    .unwrap();
}

#[test]
fn semantic_actions_reject_foreign_closed_and_unpresented_authority() {
    let mut win = Win::demo(Page::default());
    let foreign = Win::demo(Page::default()).input();
    assert_eq!(win.perform(foreign, Action::Focus), Err(Error::StaleTarget));
    let input = win.input();
    win.presentation_lost().unwrap();
    assert_eq!(
        win.perform(input, Action::Focus),
        Err(Error::PresentationStale)
    );
    win.settle().unwrap();
    assert_eq!(
        win.update(|_| panic!("owner fault")),
        Err(Error::OwnerPanicked)
    );
    assert_eq!(
        win.perform(input, Action::SetValue("quarantined")),
        Err(Error::Poisoned)
    );
    win.close();
    assert_eq!(
        win.perform(input, Action::SetValue("closed")),
        Err(Error::Closed)
    );
}

#[test]
fn semantic_activation_reads_allocate_nothing_and_do_no_render_work() {
    let mut win = Win::demo(Page {
        enabled: true,
        ..Default::default()
    });
    let input = win.input();
    win.reset_counters().unwrap();
    let allocations = allocation_counter::measure(|| {
        for _ in 0..1000 {
            let mut nodes = 0;
            win.visit(|part| {
                nodes += 1;
                let _ = (
                    part.target(),
                    part.parent(),
                    part.name(),
                    part.value(),
                    part.bounds(),
                    part.unclipped_bounds(),
                    part.transform(),
                );
                assert_eq!(
                    part.focused(),
                    part.target() == input && win.focused().unwrap() == Some(input)
                );
                assert!(part.actions().iter().count() <= 4);
            })
            .unwrap();
            assert_eq!(nodes, 3);
        }
    });
    assert_eq!(allocations.count_total, 0);
    assert_eq!(win.counters(), gpui::Counters::default());
}
