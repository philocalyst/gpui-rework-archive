use gpui::{
    Action, ActionKind, Affine, Component, El, Error, FieldId, Key, Role, Signal, Source, Sources,
    View, Win, WindowOptions,
    property::{CORNER_RADIUS, Contribution, FOREGROUND, PropertyId, PropertyValue, WIDTH},
};
use gpui_component::{Button, Checkbox, Input, Theme, recipe::Recipe};
#[path = "../examples/support/party.rs"]
mod party;

fn acknowledge<M: View + 'static>(window: &mut Win<M>) {
    let token = window.with_scene(|_, token| token).unwrap();
    window.presented(token).unwrap();
}
#[test]
fn party_uses_real_controls_and_application_overrides_exactly_once() {
    let mut window = Win::with_size(party::Party::default(), 760, 680).unwrap();
    let lanterns = window
        .role(Role::CheckBox)
        .name("Light the lanterns")
        .one()
        .unwrap();
    window.perform(lanterns, Action::Activate).unwrap();
    assert!(*window.root().unwrap().preparation.lanterns);
    assert_eq!(window.root().unwrap().preparation.requested, 1);
    assert_eq!(
        window
            .role(Role::CheckBox)
            .name("Light the lanterns")
            .one()
            .unwrap(),
        lanterns
    );
    let finish = window.button("Finish invitation");
    window.click(finish).unwrap();
    assert_eq!(window.root().unwrap().default_calls, 0);
    assert_eq!(window.root().unwrap().finish_calls, 1);
    assert!(window.root().unwrap().finished);
    assert!(matches!(
        window.activate(finish),
        Err(Error::NotInteractive)
    ));
}

struct Controlled {
    checked: Signal<bool>,
    calls: usize,
    disabled: bool,
    theme: Theme,
}
impl Controlled {
    const CHECKED: Source<Self, bool> = Source::new(
        FieldId::new(1),
        "checked",
        |m| &m.checked,
        |m| &mut m.checked,
    );
}
impl View for Controlled {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::CHECKED)
    }
    fn view(&self) -> El<'_> {
        Checkbox::new("Controlled", *self.checked, &self.theme)
            .toggle(Self::CHECKED)
            .on_change(|m: &mut Self, requested| {
                assert!(requested);
                m.calls += 1;
            })
            .disabled(self.disabled)
            .parts(|parts| parts.indicator(|e: El<'_>| e.rounded(0.0)))
            .build()
    }
}
#[test]
fn controlled_requests_do_not_silently_change_owner_and_keyboard_matches_pointer() {
    let mut window = Win::demo(Controlled {
        checked: Signal::new(false),
        calls: 0,
        disabled: false,
        theme: Theme::default(),
    });
    let target = window.role(Role::CheckBox).one().unwrap();
    window.click(target).unwrap();
    window.key(Key::Space).unwrap();
    window.key(Key::Enter).unwrap();
    assert_eq!(window.root().unwrap().calls, 3);
    assert!(!*window.root().unwrap().checked);
    window.update(|m| m.disabled = true).unwrap();
    assert!(window.focused().unwrap().is_none());
    assert!(matches!(
        window.activate(target),
        Err(Error::NotInteractive)
    ));
    assert_eq!(window.update(|_| {}).unwrap().changed_nodes, 0);
    window
        .visit(|part| {
            if part.target() == target {
                assert!(part.disabled());
                assert_eq!(part.actions().iter().count(), 0);
                assert_eq!(part.checked(), Some(false));
            }
        })
        .unwrap();
    window.update(|m| m.disabled = false).unwrap();
    window.click(target).unwrap();
    assert_eq!(window.root().unwrap().calls, 4);
}

struct Styled {
    tint: Signal<gpui::Color>,
    theme: Theme,
}
impl Styled {
    const TINT: Source<Self, gpui::Color> =
        Source::new(FieldId::new(1), "tint", |m| &m.tint, |m| &mut m.tint);
}
impl View for Styled {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::TINT)
    }
    fn view(&self) -> El<'_> {
        fn geometry(e: El<'_>) -> El<'_> {
            e.w(160).rounded(8.0)
        }
        Button::new("Styled", &self.theme)
            .style(geometry.then(|e| e.w(200).fg(&self.tint)))
            .build()
    }
}
#[test]
fn recipe_and_inspector_contributions_keep_presence_and_latest_lower_source() {
    let theme = Theme::default();
    let mut window = Win::demo(Styled {
        tint: Signal::new(theme.accent()),
        theme,
    });
    let target = window.button("Styled");
    assert_eq!(
        window.property(target, WIDTH).unwrap(),
        gpui::Length::Points(200.0)
    );
    assert_eq!(window.property(target, CORNER_RADIUS).unwrap(), 8.0);
    let explicit = FOREGROUND.default_value();
    window
        .set_property(target, FOREGROUND, Contribution::Set(explicit))
        .unwrap();
    assert_eq!(
        window.contribution(target, FOREGROUND).unwrap(),
        Contribution::Set(explicit)
    );
    let latest = window.root().unwrap().theme.danger();
    window
        .set(Styled::TINT, latest)
        .unwrap_or_else(|_| panic!("valid source"));
    assert_eq!(window.property(target, FOREGROUND).unwrap(), explicit);
    window
        .set_property(target, FOREGROUND, Contribution::Inherit)
        .unwrap();
    assert_eq!(window.property(target, FOREGROUND).unwrap(), latest);
    assert_eq!(
        window.contribution(target, FOREGROUND).unwrap(),
        Contribution::Inherit
    );
    assert!(
        window
            .set_property_value(
                target,
                PropertyId::Width,
                Contribution::Set(PropertyValue::Color(latest))
            )
            .is_err()
    );
    assert!(
        window
            .set_property(
                target,
                WIDTH,
                Contribution::Set(gpui::Length::Points(f32::NAN))
            )
            .is_err()
    );
    assert_eq!(
        window.property(target, WIDTH).unwrap(),
        gpui::Length::Points(200.0)
    );
}

struct Editable {
    value: Signal<String>,
    disabled: bool,
    bad: bool,
    theme: Theme,
}
impl Editable {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Editable {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        Input::new(&self.value, "Invitation", &self.theme)
            .disabled(self.disabled)
            .parts(|parts| {
                parts.control(|e: El<'_>| {
                    e.w(240).transform(if self.bad {
                        Affine {
                            a: 0.0,
                            d: 0.0,
                            ..Affine::IDENTITY
                        }
                    } else {
                        Affine::IDENTITY
                    })
                })
            })
            .build()
    }
}
#[test]
fn disabled_input_revokes_focus_and_old_presentation_cannot_edit() {
    let mut window = Win::recording(
        Editable {
            value: Signal::new("draft".into()),
            disabled: false,
            bad: false,
            theme: Theme::default(),
        },
        WindowOptions::default(),
    )
    .unwrap();
    acknowledge(&mut window);
    let target = window
        .role(Role::TextInput)
        .name("Invitation")
        .one()
        .unwrap();
    window.focus(target).unwrap();
    acknowledge(&mut window);
    window.update(|m| m.disabled = true).unwrap();
    assert_eq!(window.focused().unwrap(), None);
    let mut displayed_disabled = None;
    window
        .visit(|part| {
            if part.target() == target {
                displayed_disabled = Some(part.disabled());
            }
        })
        .unwrap();
    assert_eq!(displayed_disabled, Some(false));
    assert!(matches!(
        window.type_text(target, "x"),
        Err(Error::NotInteractive)
    ));
    assert!(matches!(
        window.perform(target, Action::SetValue("x")),
        Err(Error::NotInteractive)
    ));
    acknowledge(&mut window);
    window
        .visit(|part| {
            if part.target() == target {
                assert!(part.disabled());
                assert!(!part.actions().contains(ActionKind::SetValue));
            }
        })
        .unwrap();
    assert_eq!(window.read(Editable::VALUE).unwrap(), "draft");
    window.update(|m| m.disabled = false).unwrap();
    acknowledge(&mut window);
    window.type_text(target, "!").unwrap();
    assert_eq!(window.read(Editable::VALUE).unwrap(), "draft!");
}

struct Owner {
    child: Controlled,
    shown: bool,
}
impl Owner {
    const CHILD: Component<Self, Controlled> =
        Component::new(FieldId::new(1), "child", |m| &m.child, |m| &mut m.child);
}
impl View for Owner {
    fn sources() -> Sources<Self> {
        Sources::new().direct_component(Self::CHILD)
    }
    fn view(&self) -> El<'_> {
        gpui::column(self.shown.then(|| Self::CHILD.view(self)))
    }
}
#[test]
fn contained_control_projection_and_identity_retire_on_removal() {
    let mut window = Win::demo(Owner {
        child: Controlled {
            checked: Signal::new(false),
            calls: 0,
            disabled: false,
            theme: Theme::default(),
        },
        shown: true,
    });
    let target = window.role(Role::CheckBox).one().unwrap();
    window.activate(target).unwrap();
    assert_eq!(window.root().unwrap().child.calls, 1);
    window
        .set(Owner::CHILD.source(&Controlled::CHECKED), true)
        .unwrap_or_else(|_| panic!("valid projected source"));
    assert!(
        *window
            .read(Owner::CHILD.source(&Controlled::CHECKED))
            .unwrap()
    );
    window.update(|m| m.shown = false).unwrap();
    assert!(matches!(window.activate(target), Err(Error::StaleTarget)));
    window.update(|m| m.shown = true).unwrap();
    let replacement = window.role(Role::CheckBox).one().unwrap();
    assert_ne!(target, replacement);
}

#[test]
fn visible_focus_changes_pixels_and_disabled_plain_builders_keep_headers() {
    struct Page(Theme);
    impl View for Page {
        fn view(&self) -> El<'_> {
            Button::new("Focus", &self.0)
                .on_click(|_: &mut Self| {})
                .build()
        }
    }
    let mut window = Win::demo(Page(Theme::halloween()));
    let before = window.scene_digest().unwrap();
    let target = window.button("Focus");
    window.key(Key::Tab).unwrap();
    assert_eq!(window.focused().unwrap(), Some(target));
    assert_ne!(window.scene_digest().unwrap(), before);
    window.clear_focus().unwrap();
    assert_eq!(window.scene_digest().unwrap(), before);
    println!(
        "PORT_HEADERS El={} Checkbox={} Input={} Button={} Theme={}",
        std::mem::size_of::<El<'_>>(),
        std::mem::size_of::<Checkbox<'_>>(),
        std::mem::size_of::<Input<'_>>(),
        std::mem::size_of::<Button<'_>>(),
        std::mem::size_of::<Theme>()
    );
    assert_eq!(std::mem::size_of::<El<'_>>(), 176);
    let cost = allocation_counter::measure(|| {
        drop(gpui::div().disabled(false));
    });
    assert_eq!(cost.count_total, 0);
}

#[test]
fn failed_newer_candidate_cannot_restore_disabled_interaction_through_older_ack() {
    let mut window = Win::recording(
        Editable {
            value: Signal::new("draft".into()),
            disabled: false,
            bad: false,
            theme: Theme::default(),
        },
        WindowOptions::default(),
    )
    .unwrap();
    acknowledge(&mut window);
    let target = window.role(Role::TextInput).one().unwrap();
    window
        .update(|m| *m.value = "eligible older candidate".into())
        .unwrap();
    let older = window.with_scene(|_, token| token).unwrap();
    let failed = window.update(|m| {
        m.disabled = true;
        m.bad = true;
    });
    assert!(failed.is_err());
    window.presented(older).unwrap();
    window
        .visit(|part| {
            if part.target() == target {
                assert!(!part.disabled());
            }
        })
        .unwrap();
    assert!(matches!(
        window.type_text(target, "forbidden"),
        Err(Error::NotInteractive)
    ));
    assert!(window.focused().unwrap().is_none());
    assert_eq!(
        window.root().unwrap().value.as_str(),
        "eligible older candidate"
    );
}

#[test]
fn disabled_compound_parts_cannot_install_an_independent_action() {
    struct Page {
        disabled: bool,
        calls: usize,
        theme: Theme,
    }
    impl View for Page {
        fn view(&self) -> El<'_> {
            Checkbox::new("Part action", false, &self.theme)
                .disabled(self.disabled)
                .parts(|parts| parts.label(|e| e.on_click(|m: &mut Self| m.calls += 1)))
                .build()
        }
    }
    let mut window = Win::demo(Page {
        disabled: true,
        calls: 0,
        theme: Theme::default(),
    });
    let part = window.role(Role::Text).text("Part action").one().unwrap();
    assert!(matches!(window.activate(part), Err(Error::NotInteractive)));
    assert!(matches!(window.focus(part), Err(Error::NotInteractive)));
    window
        .visit(|p| {
            if p.target() == part {
                assert!(p.disabled());
                assert_eq!(p.actions().iter().count(), 0);
            }
        })
        .unwrap();
    window.update(|m| m.disabled = false).unwrap();
    window.activate(part).unwrap();
    assert_eq!(window.root().unwrap().calls, 1);
}

#[test]
fn focus_and_geometry_share_the_existing_control_extra_allocation() {
    let theme = Theme::default();
    let cost = allocation_counter::measure(|| {
        drop(Button::new("Stock", &theme).build());
    });
    assert_eq!(cost.count_total, 1);
    assert_eq!(cost.bytes_total, 56);
}

#[test]
fn native_inspector_composition_keeps_the_same_application_input_authority() {
    let mut window = Win::with_inspector(
        party::Party::default(),
        WindowOptions {
            size: [940, 680],
            ..Default::default()
        },
    )
    .unwrap();
    let lanterns = window
        .role(Role::CheckBox)
        .name("Light the lanterns")
        .one()
        .unwrap();
    window.click(lanterns).unwrap();
    assert!(*window.root().unwrap().preparation.lanterns);
    assert_eq!(window.root().unwrap().preparation.requested, 1);
    window.key(Key::Space).unwrap();
    assert!(!*window.root().unwrap().preparation.lanterns);
    window.key(Key::Enter).unwrap();
    assert!(*window.root().unwrap().preparation.lanterns);
    let finish = window.button("Finish invitation");
    window.click(finish).unwrap();
    assert!(window.root().unwrap().finished);
}

#[test]
fn party_default_toggle_and_title_edits_refresh_checked_validation_and_parent_policy() {
    let mut window = Win::with_size(party::Party::default(), 760, 680).unwrap();
    let lanterns = window
        .role(Role::CheckBox)
        .name("Light the lanterns")
        .one()
        .unwrap();
    let treats = window
        .role(Role::CheckBox)
        .name("Set out the treats")
        .one()
        .unwrap();
    window.activate(lanterns).unwrap();
    let finish = window.button("Finish invitation");
    let assert_presented = |window: &Win<party::Party>, checked, disabled| {
        let mut choice = None;
        let mut command = None;
        window
            .visit(|part| {
                if part.target() == treats {
                    choice = part.checked();
                }
                if part.target() == finish {
                    command = Some(part.disabled());
                }
            })
            .unwrap();
        assert_eq!(choice, Some(checked));
        assert_eq!(command, Some(disabled));
    };
    assert_presented(&window, true, false);
    // This is the reusable default Source update route, without the custom
    // lantern callback's coarse model edit to hide missing dependencies.
    window.activate(treats).unwrap();
    assert!(!*window.root().unwrap().preparation.treats);
    assert_presented(&window, false, true);
    assert!(matches!(
        window.activate(finish),
        Err(Error::NotInteractive)
    ));
    window.activate(treats).unwrap();
    assert_presented(&window, true, false);
    let input = window
        .role(Role::TextInput)
        .name("Gathering name")
        .one()
        .unwrap();
    let len = window.root().unwrap().title.len();
    window
        .replace(input, gpui::TextSelection::from_bytes(0, len).unwrap(), "x")
        .unwrap();
    assert!(
        window
            .contains_text("Use at least three characters")
            .unwrap()
    );
    assert_presented(&window, true, true);
    window
        .replace(
            input,
            gpui::TextSelection::from_bytes(0, 1).unwrap(),
            "Midnight",
        )
        .unwrap();
    assert!(
        !window
            .contains_text("Use at least three characters")
            .unwrap()
    );
    assert_presented(&window, true, false);
    assert!(window.counters().owner_reruns > 0);
}

#[test]
fn actual_preparation_binds_directly_while_parent_ready_branch_keeps_its_dependency() {
    let mut preparation =
        Win::with_size(party::Preparation::new(Theme::halloween()), 400, 200).unwrap();
    let treats = preparation
        .role(Role::CheckBox)
        .name("Set out the treats")
        .one()
        .unwrap();
    preparation.reset_counters().unwrap();
    preparation.set(party::Preparation::TREATS, false).unwrap();
    let mut checked = None;
    preparation
        .visit(|part| {
            if part.target() == treats {
                checked = part.checked();
            }
        })
        .unwrap();
    assert_eq!(checked, Some(false));
    assert_eq!(preparation.counters().owner_reruns, 0);
    assert_eq!(preparation.counters().descriptions, 0);

    let mut parent = Win::with_size(party::Party::default(), 520, 542).unwrap();
    parent
        .set(
            party::Party::PREPARATION.source(party::Preparation::LANTERNS),
            true,
        )
        .unwrap();
    parent.reset_counters().unwrap();
    parent
        .set(
            party::Party::PREPARATION.source(party::Preparation::TREATS),
            false,
        )
        .unwrap();
    assert!(!parent.root().unwrap().ready());
    assert!(
        parent.counters().owner_reruns > 0,
        "ready() is an ordinary parent Rust branch"
    );
    let finish = parent.button("Finish invitation");
    assert!(matches!(
        parent.activate(finish),
        Err(Error::NotInteractive)
    ));
}
