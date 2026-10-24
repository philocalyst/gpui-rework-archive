//! Controlled checks use the same acknowledged sheet and typed model routes as input.
use gpui::{Action, ActionKind, Error, Role, WindowOptions, prelude::*};

struct Page {
    checked: bool,
    calls: u32,
    noop: bool,
    show: bool,
    replace: bool,
    fail: bool,
    unregistered: Signal<String>,
}
impl Default for Page {
    fn default() -> Self {
        Self {
            checked: false,
            calls: 0,
            noop: false,
            show: true,
            replace: false,
            fail: false,
            unregistered: Signal::new(String::new()),
        }
    }
}
impl Page {
    fn toggle(&mut self) {
        self.calls += 1;
        if !self.noop {
            self.checked = !self.checked;
        }
    }
}
impl View for Page {
    fn view(&self) -> El<'_> {
        column((
            self.show.then(|| {
                let control = if self.replace {
                    button("Remember")
                } else {
                    checkbox("Remember", self.checked)
                };
                control.w(100).h(28).on_click(Self::toggle)
            }),
            checkbox("Read only display", true).w(100).h(28),
            button("Next").w(100).h(28).on_click(|_: &mut Self| {}),
            self.fail.then(|| text_input(&self.unregistered)),
        ))
    }
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn checked(win: &Win<Page>, target: Target) -> bool {
    let mut checked = None;
    win.visit(|part| {
        if part.target() == target {
            checked = part.checked();
        }
    })
    .unwrap();
    checked.unwrap()
}
fn target(win: &Win<Page>) -> Target {
    win.query().name("Remember").one().unwrap()
}
fn recording() -> Win<Page> {
    let mut win = Win::recording(
        Page::default(),
        WindowOptions {
            size: [160, 140],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}

#[test]
fn pointer_space_enter_and_semantic_activation_share_one_controlled_route() {
    let mut win = Win::with_size(Page::default(), 160, 140).unwrap();
    let target = target(&win);
    let mut pointer = PointerSession::default();
    win.pointer_event(&mut pointer, PointerEvent::Move(Point { x: 10., y: 10. }))
        .unwrap();
    win.pointer_event(&mut pointer, PointerEvent::Press)
        .unwrap();
    assert_eq!(win.focused().unwrap(), Some(target));
    assert_eq!(win.root().unwrap().calls, 0);
    win.pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    win.pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().calls, 1);
    assert!(checked(&win, target));
    win.key(Key::Space).unwrap();
    assert!(!checked(&win, target));
    win.key(Key::Enter).unwrap();
    assert!(checked(&win, target));
    win.perform(target, Action::Activate).unwrap();
    assert!(!checked(&win, target));
    assert_eq!(win.root().unwrap().calls, 4);
    win.key(Key::Tab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(win.button("Next")));
    win.key(Key::ReverseTab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(target));
    win.perform(target, Action::Blur).unwrap();
    assert_eq!(win.focused().unwrap(), None);
    win.key(Key::Tab).unwrap();
    assert_eq!(win.focused().unwrap(), Some(target));
    win.update(|m| m.noop = true).unwrap();
    win.key(Key::Space).unwrap();
    assert_eq!(win.root().unwrap().calls, 5);
    assert!(
        !checked(&win, target),
        "activation cannot invent checked state"
    );
}

#[test]
fn checked_state_waits_for_ack_and_preserves_target_focus_and_route_across_cycles() {
    let mut win = recording();
    let target = target(&win);
    win.perform(target, Action::Focus).unwrap();
    for (calls, next) in [(1, true), (2, false), (3, true), (4, false)] {
        win.perform(target, Action::Activate).unwrap();
        assert_eq!(win.root().unwrap().checked, next);
        assert_eq!(checked(&win, target), !next, "old P owns its exact state");
        assert_eq!(win.focused().unwrap(), Some(target));
        ack(&mut win);
        assert_eq!(checked(&win, target), next);
        assert_eq!(win.query().name("Remember").one().unwrap(), target);
        assert_eq!(win.root().unwrap().calls, calls);
        assert_eq!(win.focused().unwrap(), Some(target));
    }
}

#[test]
fn failed_logical_description_keeps_old_checked_p_but_retires_authority() {
    let mut win = recording();
    let original = target(&win);
    win.focus(original).unwrap();
    assert!(matches!(
        win.update(|m| {
            m.checked = true;
            m.fail = true;
        }),
        Err(Error::UnregisteredInput { .. })
    ));
    assert!(!checked(&win, original));
    assert_eq!(win.focused().unwrap(), None);
    assert!(win.perform(original, Action::Activate).is_err());
    assert_eq!(win.root().unwrap().calls, 0);
    win.update(|m| m.fail = false).unwrap();
    assert_eq!(
        win.perform(original, Action::Activate),
        Err(Error::StaleTarget)
    );
    ack(&mut win);
    assert_ne!(target(&win), original);
    assert!(checked(&win, target(&win)));
}

#[test]
fn role_replacement_removal_and_foreign_targets_never_gain_checkbox_authority() {
    let mut win = recording();
    let original = target(&win);
    win.update(|m| m.replace = true).unwrap();
    assert!(
        !checked(&win, original),
        "unacknowledged replacement leaves P intact"
    );
    assert_eq!(
        win.perform(original, Action::Activate),
        Err(Error::StaleTarget)
    );
    ack(&mut win);
    let replacement = target(&win);
    assert_ne!(replacement, original);
    win.update(|m| m.replace = false).unwrap();
    ack(&mut win);
    let current = target(&win);
    assert_ne!(current, original);
    assert_ne!(current, replacement);
    let foreign = recording();
    assert!(win.perform(target(&foreign), Action::Activate).is_err());
    win.update(|m| m.show = false).unwrap();
    assert_eq!(
        win.perform(current, Action::Activate),
        Err(Error::StaleTarget)
    );
    ack(&mut win);
    assert_eq!(win.root().unwrap().calls, 0);
}

#[test]
fn handlerless_state_and_default_or_explicit_names_share_the_ordinary_query_schema() {
    let mut win = Win::with_size(Page::default(), 160, 140).unwrap();
    let display = win.query().name("Read only display").one().unwrap();
    win.visit(|part| {
        if part.target() == display {
            assert_eq!(part.role(), Role::CheckBox);
            assert_eq!(part.checked(), Some(true));
            assert_eq!(part.value(), None);
            assert!(!part.actions().contains(ActionKind::Activate));
            assert!(!part.actions().contains(ActionKind::Focus));
            assert!(!part.actions().contains(ActionKind::Blur));
        }
    })
    .unwrap();
    assert_eq!(win.focus(display), Err(Error::NotInteractive));
    assert_eq!(
        win.perform(display, Action::Activate),
        Err(Error::NotInteractive)
    );
    struct Names;
    impl View for Names {
        fn view(&self) -> El<'_> {
            column((
                checkbox("visible label", false)
                    .name("Declared name")
                    .description("Two states"),
                checkbox("", true),
                text("plain text"),
            ))
        }
    }
    let win = Win::demo(Names);
    let json: serde_json::Value =
        serde_json::from_str(&win.semantics().unwrap().to_json().unwrap()).unwrap();
    let nodes = json["nodes"].as_array().unwrap();
    let named = &nodes[1];
    assert_eq!(named["role"], "CheckBox");
    assert_eq!(named["text"], "visible label");
    assert_eq!(named["name"], "Declared name");
    assert_eq!(named["description"], "Two states");
    assert_eq!(named["checked"], false);
    assert_eq!(nodes[2]["name"], "");
    assert_eq!(nodes[2]["checked"], true);
    assert!(nodes[0].get("checked").is_none());
    assert!(nodes[3].get("checked").is_none());
}

#[test]
fn explicit_checkbox_parts_keep_one_semantic_root_and_activation_route() {
    struct Parts(u32);
    impl View for Parts {
        fn view(&self) -> El<'_> {
            checkbox("", false)
                .name("Choice")
                .on_click(|m: &mut Self| m.0 += 1)
                .child((div().size(16).bg(rgb(0xeeeeee)), text("Visible label")))
                .layout(Flex::row())
                .gap(8)
                .p(8)
        }
    }
    let mut win = Win::demo(Parts(0));
    let root = win.role(Role::CheckBox).name("Choice").one().unwrap();
    assert_eq!(
        win.role(Role::Text).text("Visible label").one().is_ok(),
        true
    );
    win.click(root).unwrap();
    assert_eq!(win.root().unwrap().0, 1);
    win.visit(|part| {
        if part.target() == root {
            assert_eq!(part.checked(), Some(false));
        }
    })
    .unwrap();
}

#[test]
fn repeated_component_controls_keep_their_typed_receivers_and_focus() {
    #[derive(Default)]
    struct Switch(bool);
    impl Switch {
        fn toggle(&mut self) {
            self.0 = !self.0;
        }
    }
    impl View for Switch {
        fn view(&self) -> El<'_> {
            checkbox("Choice", self.0).on_click(Self::toggle)
        }
    }
    #[derive(Default)]
    struct Pair {
        left: Switch,
        right: Switch,
    }
    impl Pair {
        const LEFT: Component<Self, Switch> =
            Component::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
        const RIGHT: Component<Self, Switch> =
            Component::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    }
    impl View for Pair {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct_component(Self::LEFT)
                .direct_component(Self::RIGHT)
        }
        fn view(&self) -> El<'_> {
            column((Self::LEFT.view(self), Self::RIGHT.view(self)))
        }
    }
    let mut win = Win::demo(Pair::default());
    let mut targets = Vec::new();
    win.visit(|part| {
        if part.role() == Role::CheckBox {
            targets.push(part.target());
        }
    })
    .unwrap();
    win.focus(targets[0]).unwrap();
    win.key(Key::Space).unwrap();
    assert!(win.root().unwrap().left.0);
    assert!(!win.root().unwrap().right.0);
    assert_eq!(win.focused().unwrap(), Some(targets[0]));
    win.perform(targets[1], Action::Activate).unwrap();
    assert!(win.root().unwrap().left.0);
    assert!(win.root().unwrap().right.0);
    win.key(Key::Space).unwrap();
    assert!(!win.root().unwrap().left.0);
    assert!(win.root().unwrap().right.0);
}

#[test]
fn coherent_checked_candidate_survives_newer_failed_preparation() {
    struct Deferred {
        checked: bool,
        broken: bool,
    }
    impl View for Deferred {
        fn view(&self) -> El<'_> {
            checkbox("Deferred", self.checked)
                .size(40)
                .bg(Color::BLACK)
                .transform(if self.broken {
                    Affine::scale(0., 1.)
                } else {
                    Affine::IDENTITY
                })
        }
    }
    let mut win = Win::recording(
        Deferred {
            checked: false,
            broken: false,
        },
        WindowOptions {
            size: [100, 100],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let target = win.role(Role::CheckBox).one().unwrap();
    let published = |win: &Win<Deferred>| {
        let mut value = None;
        win.visit(|part| {
            assert_eq!(part.target(), target);
            value = part.checked();
        })
        .unwrap();
        value.unwrap()
    };
    win.update(|m| m.checked = true).unwrap();
    let coherent = win.with_scene(|_, token| token).unwrap();
    assert!(!published(&win));
    assert!(matches!(
        win.update(|m| {
            m.checked = false;
            m.broken = true;
        }),
        Err(Error::Canvas(_))
    ));
    assert!(!published(&win));
    assert_eq!(win.with_scene(|_, token| token).unwrap(), coherent);
    win.presented(coherent).unwrap();
    assert!(
        published(&win),
        "ACK publishes that candidate's value, not the newer model"
    );
    win.update(|m| m.broken = false).unwrap();
    assert!(published(&win));
    ack(&mut win);
    assert!(!published(&win));
}

#[test]
fn a_literal_checkbox_and_method_route_add_no_constructor_allocation() {
    let cost = allocation_counter::measure(|| {
        let control = checkbox("Keep", false).on_click(Page::toggle);
        let _ = std::hint::black_box(control);
    });
    assert_eq!(cost.count_total, 0);
    assert_eq!(cost.bytes_total, 0);
}
