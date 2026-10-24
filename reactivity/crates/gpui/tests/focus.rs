//! Inputs use the ordinary exclusive production owner, including application ports.
use gpui::{Error, Key, Role, WindowOptions, prelude::*};

#[path = "../examples/support/todos.rs"]
mod todos;

#[test]
fn todos_keyboard_navigation_edits_unicode_and_activates_real_actions() {
    let mut win = Win::demo(todos::Todos::default());
    let input = win.role(Role::TextInput).one().unwrap();
    let add = win.role(Role::Button).text("Add").one().unwrap();
    win.reset_counters().unwrap();
    assert_eq!(win.focused().unwrap(), None);
    let focus = win.key(Key::Tab).unwrap();
    assert_eq!(focus.source_epoch, 0);
    assert_eq!(win.focused().unwrap(), Some(input));
    assert_eq!(win.counters(), gpui::Counters::default());
    win.key(Key::Text("\t")).unwrap();
    assert_eq!(win.counters(), gpui::Counters::default());
    win.key(Key::Text("Café!")).unwrap();
    win.key(Key::Backspace).unwrap();
    win.key(Key::Space).unwrap();
    win.key(Key::Text("task")).unwrap();
    assert!(win.contains_text("Café task").unwrap());
    win.key(Key::Tab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(add));
    win.key(Key::Enter).unwrap();
    assert!(win.contains_text("1 left").unwrap());
    assert!(win.role(Role::Text).text("Café task").count().unwrap() == 1);
    win.key(Key::ReverseTab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(input));
    win.key(Key::ReverseTab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(win.button("Done")));
    win.key(Key::Tab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(input));
    win.clear_focus().unwrap();
    assert_eq!(win.focused().unwrap(), None);
}

#[derive(Default)]
struct Controls {
    value: Signal<String>,
    count: u32,
    show: bool,
    handler: bool,
}
impl Controls {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    fn increment(&mut self) {
        self.count += 1;
    }
    fn panic(&mut self) {
        panic!("owner fault");
    }
}
impl View for Controls {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        let action = text("handler").w(60).h(25);
        column((
            text_input(&self.value).w(120).h(25),
            button("increment").on_click(Self::increment),
            button("fault").on_click(Self::panic),
            if self.handler {
                action.on_click(Self::increment)
            } else {
                action
            },
            self.show
                .then(|| button("optional").on_click(Self::increment)),
        ))
    }
}

#[test]
fn focus_changes_are_idle_and_invalid_targets_do_not_replace_focus() {
    let mut win = Win::demo(Controls::default());
    let foreign = Win::demo(Controls::default()).button("increment");
    let input = win.input();
    win.focus(input).unwrap();
    win.reset_counters().unwrap();
    assert_eq!(win.focus(foreign), Err(Error::StaleTarget));
    let plain = win.find_text("handler").unwrap();
    assert_eq!(win.focus(plain), Err(Error::NotInteractive));
    assert_eq!(win.focused().unwrap(), Some(input));
    win.clear_focus().unwrap();
    win.key(Key::Text("ignored")).unwrap();
    assert_eq!(win.counters(), gpui::Counters::default());
    assert_eq!(win.root().unwrap().value.as_str(), "");
}

#[test]
fn focus_revokes_on_removal_ineligibility_fault_and_close() {
    let mut win = Win::demo(Controls {
        show: true,
        handler: true,
        ..Default::default()
    });
    let optional = win.button("optional");
    win.focus(optional).unwrap();
    win.update(|m| m.show = false).unwrap();
    assert_eq!(win.focused().unwrap(), None);
    assert_eq!(win.focus(optional), Err(Error::StaleTarget));
    let handler = win.find_text("handler").unwrap();
    win.focus(handler).unwrap();
    win.update(|m| m.handler = false).unwrap();
    assert_eq!(win.focused().unwrap(), None);
    win.focus(win.button("fault")).unwrap();
    assert_eq!(win.key(Key::Enter), Err(Error::OwnerPanicked));
    assert_eq!(win.focused().unwrap(), None);
    assert_eq!(win.key(Key::Tab), Err(Error::Poisoned));
    win.close();
    assert_eq!(win.focused(), Err(Error::Closed));
}

#[test]
fn tab_waits_for_acknowledged_sheet_and_position_free_editing_repairs_failed_text() {
    let mut win = Win::recording(Controls::default(), WindowOptions::default()).unwrap();
    assert_eq!(win.key(Key::Tab), Err(Error::PresentationStale));
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win.key(Key::Tab).unwrap();
    let input = win.input();
    win.key(Key::Text("a")).unwrap();
    assert_eq!(win.key(Key::Tab), Err(Error::PresentationStale));
    assert_eq!(win.focused().unwrap(), Some(input));
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let old = win.snapshot().unwrap();
    assert!(matches!(win.key(Key::Text("漢")), Err(Error::Canvas(_))));
    assert_eq!(win.focused().unwrap(), Some(input));
    assert_eq!(win.key(Key::Tab), Err(Error::PresentationStale));
    assert_eq!(
        win.snapshot().unwrap().presentation_epoch,
        old.presentation_epoch
    );
    win.key(Key::Backspace).unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "a");
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win.key(Key::Tab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(win.button("increment")));
}

#[test]
fn click_focus_uses_geometry_while_explicit_focus_and_activation_are_position_free() {
    let mut win = Win::demo(Controls::default());
    let input = win.input();
    win.click(input).unwrap();
    assert_eq!(win.focused().unwrap(), Some(input));
    assert_eq!(
        win.click_at(Point { x: -1.0, y: -1.0 }),
        Err(Error::NotHittable)
    );
    assert_eq!(win.focused().unwrap(), None);
    let button = win.button("increment");
    win.set_property(
        button,
        gpui::property::WIDTH,
        gpui::property::Contribution::Set(gpui::Length::Points(0.0)),
    )
    .unwrap();
    assert_eq!(win.click(button), Err(Error::NotHittable));
    win.focus(button).unwrap();
    win.key(Key::Space).unwrap();
    assert_eq!(win.root().unwrap().count, 1);
    // Targeted activation does not steal keyboard focus from another control.
    win.focus(input).unwrap();
    win.activate(button).unwrap();
    assert_eq!(win.focused().unwrap(), Some(input));
}

#[derive(Default)]
struct Child {
    name: Signal<String>,
    count: Signal<u32>,
}
impl Child {
    const NAME: Source<Self, String> =
        Source::new(FieldId::new(1), "name", |m| &m.name, |m| &mut m.name);
    const COUNT: Source<Self, u32> =
        Source::new(FieldId::new(2), "count", |m| &m.count, |m| &mut m.count);
}
impl View for Child {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::NAME).direct(Self::COUNT)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.name).w(80).h(24),
            button("+1").on_click(Self::COUNT.update(|n| *n += 1)),
        ))
    }
}
#[derive(Default)]
struct Pair {
    left: Child,
    right: Child,
}
impl Pair {
    const LEFT: Component<Self, Child> =
        Component::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const RIGHT: Component<Self, Child> =
        Component::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
}
impl View for Pair {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct_component(Self::LEFT)
            .direct_component(Self::RIGHT)
    }
    fn view(&self) -> El<'_> {
        row((Self::LEFT.view(self), Self::RIGHT.view(self)))
    }
}
#[test]
fn reusable_components_share_keyboard_barriers_and_keep_independent_state() {
    let mut win = Win::demo(Pair::default());
    win.reset_counters().unwrap();
    win.key(Key::Tab).unwrap();
    win.key(Key::Text("left")).unwrap();
    win.key(Key::Tab).unwrap();
    win.key(Key::Enter).unwrap();
    win.key(Key::Tab).unwrap();
    win.key(Key::Text("right")).unwrap();
    win.key(Key::Tab).unwrap();
    win.key(Key::Space).unwrap();
    assert_eq!(win.root().unwrap().left.name.as_str(), "left");
    assert_eq!(win.root().unwrap().right.name.as_str(), "right");
    assert_eq!(*win.root().unwrap().left.count, 1);
    assert_eq!(*win.root().unwrap().right.count, 1);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().exact_updates, 4);
}

#[derive(Default)]
struct BadRoute {
    left: Signal<u32>,
    right: Signal<u32>,
}
impl BadRoute {
    const LEFT: Source<Self, u32> =
        Source::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const WRONG: Source<Self, u32> =
        Source::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.right);
}
impl View for BadRoute {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LEFT)
    }
    fn view(&self) -> El<'_> {
        button("bad writer").on_click(Self::WRONG.update(|n| *n += 1))
    }
}
#[test]
fn keyboard_checked_route_rejection_keeps_owner_and_focus_without_advancing_source() {
    let mut win = Win::demo(BadRoute::default());
    let button = win.button("bad writer");
    win.focus(button).unwrap();
    assert!(matches!(
        win.key(Key::Enter),
        Err(Error::Binding(gpui::BindError::ProjectionMismatch(_)))
    ));
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
    assert!(!win.snapshot().unwrap().poisoned);
    assert_eq!(win.focused().unwrap(), Some(button));
    assert_eq!(
        (*win.root().unwrap().left, *win.root().unwrap().right),
        (0, 0)
    );
    win.set(BadRoute::LEFT, 3).unwrap();
    assert_eq!(*win.root().unwrap().left, 3);
}

#[derive(Default)]
struct LogicalFailure {
    valid: Signal<String>,
    unregistered: Signal<String>,
    fail: bool,
}
impl LogicalFailure {
    const VALID: Source<Self, String> =
        Source::new(FieldId::new(1), "valid", |m| &m.valid, |m| &mut m.valid);
}
impl View for LogicalFailure {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALID)
    }
    fn view(&self) -> El<'_> {
        text_input(if self.fail {
            &self.unregistered
        } else {
            &self.valid
        })
        .w(80)
        .h(24)
    }
}
#[test]
fn logical_description_failure_revokes_focus_and_recovery_does_not_revive_the_old_target() {
    let mut win = Win::demo(LogicalFailure::default());
    let original = win.input();
    win.focus(original).unwrap();
    assert!(matches!(
        win.update(|m| m.fail = true),
        Err(Error::UnregisteredInput { .. })
    ));
    assert_eq!(win.focused().unwrap(), None);
    win.update(|m| m.fail = false).unwrap();
    assert_ne!(win.input(), original);
    assert_eq!(win.focus(original), Err(Error::StaleTarget));
    win.key(Key::Tab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(win.input()));
}

#[test]
fn focus_navigation_has_no_allocations_or_render_work() {
    let mut win = Win::demo(Controls::default());
    let input = win.input();
    win.reset_counters().unwrap();
    let measured = allocation_counter::measure(|| {
        for _ in 0..1000 {
            win.focus(input).unwrap();
            win.key(Key::Tab).unwrap();
            win.key(Key::ReverseTab).unwrap();
            assert_eq!(win.focused().unwrap(), Some(input));
            win.clear_focus().unwrap();
        }
    });
    assert_eq!(measured.count_total, 0);
    assert_eq!(win.counters(), gpui::Counters::default());
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}
