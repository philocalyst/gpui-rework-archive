//! Compound input publishes one coherent candidate, including caret visibility.
use gpui::{Action, BindError, Error, Key, TextSelection, prelude::*};

struct Page {
    value: Signal<String>,
    unregistered: Signal<String>,
    count: Signal<u32>,
    other: Signal<u32>,
    name: Signal<String>,
    color: Signal<Color>,
    broken: bool,
}
impl Default for Page {
    fn default() -> Self {
        Self {
            value: Signal::new("abc".into()),
            unregistered: Signal::new("bad".into()),
            count: Signal::new(0),
            other: Signal::new(0),
            name: Signal::new("label".into()),
            color: Signal::new(Color::BLACK),
            broken: false,
        }
    }
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    const COUNT: Source<Self, u32> =
        Source::new(FieldId::new(2), "count", |m| &m.count, |m| &mut m.count);
    const NAME: Source<Self, String> =
        Source::new(FieldId::new(3), "name", |m| &m.name, |m| &mut m.name);
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(4), "color", |m| &m.color, |m| &mut m.color);
    const WRONG: Source<Self, u32> =
        Source::new(FieldId::new(2), "count", |m| &m.count, |m| &mut m.other);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::VALUE)
            .direct(Self::COUNT)
            .direct(Self::NAME)
            .direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        column(
            [
                text_input(if self.broken {
                    &self.unregistered
                } else {
                    &self.value
                })
                .w(150)
                .h(30),
                text(&self.count).name(&self.name),
                div().size(20).bg(&self.color),
                button("visual").on_click(Self::COUNT.update(|v| *v += 1)),
                button("complete").on_click(Self::COUNT.update(|_| {})),
                button("metadata").on_click(Self::NAME.update(|v| v.push('!'))),
                button("paint bank").on_click(Self::COLOR.update(|v| *v = Color::rgb(220, 30, 40))),
                button("reject").on_click(Self::WRONG.update(|v| *v += 1)),
                button("inert"),
                button("failed P").on_click(Self::VALUE.update(|v| v.push('漢'))),
                button("failed logical").on_click(|m: &mut Self| m.broken = true),
                button("panic").on_click(|_: &mut Self| panic!("owner fault")),
            ]
            .into_iter(),
        )
        .scroll(Axis::Y)
        .h(430)
    }
}
fn range(anchor: usize, focus: usize) -> TextSelection {
    TextSelection::from_bytes(anchor, focus).unwrap()
}
fn focused() -> Win<Page> {
    let mut win = Win::demo(Page::default());
    let input = win.input();
    win.select(input, range(1, 1)).unwrap();
    win.focus(input).unwrap();
    win.reset_counters().unwrap();
    win
}

#[test]
fn compound_visual_complete_metadata_and_bank_actions_publish_one_caret_frame() {
    for label in ["visual", "complete", "metadata", "paint bank"] {
        for at_point in [false, true] {
            let mut win = focused();
            let target = win.button(label);
            if at_point {
                let bounds = win.bounds(target).unwrap();
                win.click_at(Point {
                    x: bounds.x + bounds.width * 0.5,
                    y: bounds.y + bounds.height * 0.5,
                })
                .unwrap();
            } else {
                win.click(target).unwrap();
            }
            assert_eq!(win.focused().unwrap(), Some(target));
            assert_eq!(
                win.counters().presentations,
                1,
                "{label}: includes bank-only candidates"
            );
            assert_eq!(win.counters().source_operations, 1, "{label}");
            assert_eq!(win.counters().paint_passes, 1, "{label}");
        }
    }
}

#[test]
fn absence_of_a_caret_effect_preserves_complete_metadata_and_bank_fast_paths() {
    let mut win = focused();
    let input = win.input();
    win.select(input, range(0, 2)).unwrap();
    for label in ["complete", "metadata"] {
        let token = win.with_scene(|_, token| token).unwrap();
        win.reset_counters().unwrap();
        win.click(win.button(label)).unwrap();
        assert_eq!(win.with_scene(|_, token| token).unwrap(), token);
        assert_eq!(win.counters().paint_passes, 0);
        assert_eq!(win.counters().presentations, 0);
    }
    win.reset_counters().unwrap();
    win.click(win.button("paint bank")).unwrap();
    assert_eq!(win.counters().paint_passes, 0);
    assert_eq!(win.counters().presentations, 1);
}

#[test]
fn rejected_compound_actions_restore_focus_without_publication() {
    for label in ["reject", "inert"] {
        let mut win = focused();
        let previous = win.focused().unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        let epoch = win.snapshot().unwrap().source_epoch;
        let result = win.click(win.button(label));
        if label == "reject" {
            assert!(matches!(
                result,
                Err(Error::Binding(BindError::ProjectionMismatch(_)))
            ));
        } else {
            assert_eq!(result, Err(Error::NotHittable));
        }
        assert_eq!(win.focused().unwrap(), previous);
        assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
        assert_eq!(win.with_scene(|_, token| token).unwrap(), token);
        assert_eq!(win.counters().paint_passes, 0);
        assert_eq!(win.counters().presentations, 0);
    }
}

#[test]
fn committed_failed_preparation_keeps_new_focus_and_logical_failure_clears_it() {
    let mut win = focused();
    let input = win.input();
    let button = win.button("failed P");
    let token = win.with_scene(|_, token| token).unwrap();
    assert!(matches!(win.click(button), Err(Error::Canvas(_))));
    assert_eq!(win.focused().unwrap(), Some(button));
    assert_eq!(win.root().unwrap().value.as_str(), "abc漢");
    assert_eq!(win.with_scene(|_, token| token).unwrap(), token);
    win.backspace(input).unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "abc");

    let mut win = focused();
    let button = win.button("failed logical");
    assert!(matches!(
        win.click(button),
        Err(Error::UnregisteredInput { .. })
    ));
    assert_eq!(win.focused().unwrap(), None);
    win.update(|m| m.broken = false).unwrap();
    assert_eq!(win.selection(win.input()).unwrap(), range(3, 3));

    let mut win = focused();
    assert_eq!(win.click(win.button("panic")), Err(Error::OwnerPanicked));
    assert_eq!(win.focused().unwrap(), None);
}

#[test]
fn tab_with_an_idle_reveal_still_publishes_caret_visibility() {
    let mut win = focused();
    let input = win.input();
    let token = win.with_scene(|_, token| token).unwrap();
    win.perform(win.button("visual"), Action::ScrollIntoView)
        .unwrap();
    assert_eq!(win.with_scene(|_, token| token).unwrap(), token);
    assert_eq!(win.counters().presentations, 0);
    win.key(Key::Tab).unwrap();
    assert_ne!(win.focused().unwrap(), Some(input));
    assert_eq!(win.counters().paint_passes, 1);
    assert_eq!(win.counters().presentations, 1);
    win.key(Key::ReverseTab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(input));
    assert_eq!(win.counters().paint_passes, 2);
    assert_eq!(win.counters().presentations, 2);
}

#[test]
fn tab_reveal_that_scrolls_includes_caret_blur_in_its_one_candidate() {
    let mut win = focused();
    let viewport = win.role(gpui::Role::ScrollView).one().unwrap();
    win.set_property(
        viewport,
        gpui::property::HEIGHT,
        gpui::property::Contribution::Set(Some(40.)),
    )
    .unwrap();
    win.reset_counters().unwrap();
    win.key(Key::Tab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(win.button("visual")));
    assert!(win.viewport(viewport).unwrap().offset.y > 0.);
    assert_eq!(win.counters().presentations, 1);
    assert_eq!(win.counters().paint_passes, 1);
}
