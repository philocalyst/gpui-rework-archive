use gpui::{
    Error, PropertyChange, PropertyState, TextSelection, WindowOptions,
    prelude::*,
    property::{Contribution, PropertyId, PropertyValue},
    property_action, property_selection,
};
#[path = "../examples/support/property_workbench.rs"]
mod workbench;
use workbench::Companion;
fn select_application(win: &mut Win<Companion>) -> Target {
    let inspect = win.query().name("Inspect application").one().unwrap();
    win.activate(inspect).unwrap();
    let target = win.button("Library button");
    win.activate(target).unwrap();
    assert_eq!(win.root().unwrap().editor.selected.unwrap().0, target);
    target
}
fn draft(win: &mut Win<Companion>, value: &str) {
    let input = win.find_input().unwrap();
    let end = win.root().unwrap().editor.draft.len();
    win.replace(input, TextSelection::from_bytes(0, end).unwrap(), value)
        .unwrap();
}
#[test]
fn explicit_selection_surface_keeps_normal_library_behavior_independent() {
    let mut win = Win::with_size(Companion::default(), 800, 400).unwrap();
    let target = win.button("Library button");
    win.activate(target).unwrap();
    assert_eq!(win.root().unwrap().application.presses, 3);
    assert_eq!(win.root().unwrap().editor.selected, None);
    assert_eq!(select_application(&mut win), target);
    assert_eq!(win.root().unwrap().application.presses, 3);
    assert_eq!(&**win.root().unwrap().editor.draft, "120");
    let inspect = win.query().name("Inspect application").one().unwrap();
    win.activate(inspect).unwrap();
    win.activate(target).unwrap();
    assert_eq!(win.root().unwrap().application.presses, 6);
}
#[test]
fn inherit_and_refresh_read_canonical_state_after_a_masked_source_change() {
    let mut win = Win::with_size(Companion::default(), 800, 400).unwrap();
    let target = select_application(&mut win);
    draft(&mut win, "193.25");
    win.activate(win.button("Apply")).unwrap();
    win.update(|model| *model.application.width = 170.).unwrap();
    assert_eq!(
        win.property(target, gpui::property::WIDTH).unwrap(),
        gpui::Length::Points(193.25)
    );
    assert_eq!(&**win.root().unwrap().editor.draft, "193.25");
    win.activate(win.button("Inherit")).unwrap();
    assert_eq!(
        win.property(target, gpui::property::WIDTH).unwrap(),
        gpui::Length::Points(170.)
    );
    assert_eq!(&**win.root().unwrap().editor.draft, "170");
    assert_eq!(
        win.contribution(target, gpui::property::WIDTH).unwrap(),
        Contribution::Inherit
    );
    win.update(|model| *model.application.width = 211.75)
        .unwrap();
    assert_eq!(&**win.root().unwrap().editor.draft, "170");
    win.activate(win.button("Refresh selection")).unwrap();
    assert_eq!(&**win.root().unwrap().editor.draft, "211.75");
}
#[test]
fn stale_refresh_is_rejected_and_explicit_reselection_recovers() {
    let mut win = Win::with_size(Companion::default(), 800, 400).unwrap();
    let old = select_application(&mut win);
    win.update(|model| model.show_application = false).unwrap();
    win.activate(win.button("Refresh selection")).unwrap();
    assert!(win.root().unwrap().editor.status.contains("StaleTarget"));
    assert_eq!(win.root().unwrap().editor.selected.unwrap().0, old);
    win.update(|model| model.show_application = true).unwrap();
    let current = win.button("Library button");
    assert_ne!(current, old);
    win.activate(current).unwrap();
    assert_eq!(win.root().unwrap().editor.selected.unwrap().0, current);
    assert!(win.root().unwrap().editor.status.is_empty());
}

struct Page {
    width: Signal<f32>,
    selected: Option<Target>,
    last: Option<PropertyState>,
    mutate_reply: bool,
}
impl Default for Page {
    fn default() -> Self {
        Self {
            width: Signal::new(120.),
            selected: None,
            last: None,
            mutate_reply: false,
        }
    }
}
impl Page {
    const WIDTH: Source<Self, f32> =
        Source::new(FieldId::new(1), "width", |m| &m.width, |m| &mut m.width);
    fn inspect(&self, target: Target) -> Option<(Target, PropertyId)> {
        Some((target, PropertyId::Width))
    }
    fn reply(&mut self, state: Result<PropertyState, &Error>) {
        let state = state.unwrap();
        self.selected = Some(state.target);
        self.last = Some(state);
        if self.mutate_reply {
            *self.width = 170.;
        }
    }
    fn inherit(&self) -> Option<PropertyChange> {
        Some((self.selected?, PropertyId::Width, Contribution::Inherit))
    }
    fn fail(&self) -> Option<PropertyChange> {
        Some((
            self.selected?,
            PropertyId::Transform,
            Contribution::Set(PropertyValue::Transform(Affine::scale(0., 1.))),
        ))
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::WIDTH)
    }
    fn view(&self) -> El<'_> {
        row((
            button("Subject")
                .w(&self.width)
                .h(32)
                .on_click(property_selection(Self::inspect, Self::reply)),
            button("Inherit").on_click(property_action(Self::inherit, Self::reply)),
            button("Fail").on_click(property_action(Self::fail, Self::reply)),
            text(if self.last.is_some() {
                "Selected"
            } else {
                "No selection"
            }),
        ))
    }
}
#[test]
fn owned_result_precedes_mutable_reply_source_edits() {
    let mut win = Win::with_size(Page::default(), 800, 400).unwrap();
    let target = win.button("Subject");
    win.activate(target).unwrap();
    let initial = win.root().unwrap().last.unwrap();
    assert_eq!(initial.target, target);
    assert_eq!(initial.id, PropertyId::Width);
    assert_eq!(
        initial.value,
        PropertyValue::Dimension(gpui::Length::Points(120.))
    );
    assert_eq!(initial.contribution, Contribution::Inherit);
    win.set_property(
        target,
        gpui::property::WIDTH,
        Contribution::Set(gpui::Length::Points(193.25)),
    )
    .unwrap();
    win.update(|model| model.mutate_reply = true).unwrap();
    win.activate(win.button("Inherit")).unwrap();
    assert_eq!(win.root().unwrap().last.unwrap(), initial);
    assert_eq!(
        win.property(target, gpui::property::WIDTH).unwrap(),
        gpui::Length::Points(170.)
    );
}
#[test]
fn selection_is_logical_before_ack_and_stale_ack_does_not_replace_p() {
    let mut win = Win::recording(
        Page::default(),
        WindowOptions {
            size: [800, 400],
            ..Default::default()
        },
    )
    .unwrap();
    let first = win.with_scene(|_, token| token).unwrap();
    win.presented(first).unwrap();
    let target = win.button("Subject");
    let old = win.bounds(target).unwrap();
    win.activate(target).unwrap();
    let pending = win.with_scene(|_, token| token).unwrap();
    assert_eq!(win.bounds(target).unwrap(), old);
    assert_eq!(win.root().unwrap().last.unwrap().target, target);
    assert_ne!(pending, first);
    assert_eq!(win.presented(first), Err(Error::StalePresentation));
    win.presented(pending).unwrap();
    assert_eq!(win.bounds(target).unwrap(), old);
}
#[test]
fn canonical_edit_result_survives_failed_prepare_until_repair_ack() {
    let mut win = Win::recording(
        Page::default(),
        WindowOptions {
            size: [800, 400],
            ..Default::default()
        },
    )
    .unwrap();
    let first = win.with_scene(|_, token| token).unwrap();
    win.presented(first).unwrap();
    let target = win.button("Subject");
    let old = win.bounds(target).unwrap();
    win.activate(target).unwrap();
    let pending = win.with_scene(|_, token| token).unwrap();
    assert!(matches!(
        win.activate(win.button("Fail")),
        Err(Error::Canvas(_))
    ));
    let accepted = win.root().unwrap().last.unwrap();
    assert_eq!(
        accepted.value,
        PropertyValue::Transform(Affine::scale(0., 1.))
    );
    assert_eq!(accepted.contribution, Contribution::Set(accepted.value));
    assert_eq!(win.with_scene(|_, token| token).unwrap(), pending);
    assert_eq!(win.bounds(target).unwrap(), old);
    win.set_property(target, gpui::property::TRANSFORM, Contribution::Inherit)
        .unwrap();
    let repaired = win.with_scene(|_, token| token).unwrap();
    assert_ne!(repaired, pending);
    assert_eq!(win.presented(pending), Err(Error::StalePresentation));
    win.presented(repaired).unwrap();
    assert_eq!(win.bounds(target).unwrap(), old);
}
#[test]
fn foreign_and_empty_selection_requests_do_not_fabricate_property_edits() {
    #[derive(Default)]
    struct Select {
        destination: Option<Target>,
        empty: bool,
        replies: usize,
        state: Option<PropertyState>,
        error: String,
    }
    impl Select {
        fn propose(&self, own: Target) -> Option<(Target, PropertyId)> {
            (!self.empty).then_some((self.destination.unwrap_or(own), PropertyId::Width))
        }
        fn reply(&mut self, result: Result<PropertyState, &Error>) {
            self.replies += 1;
            match result {
                Ok(state) => self.state = Some(state),
                Err(error) => self.error = error.to_string(),
            }
        }
    }
    impl View for Select {
        fn view(&self) -> El<'_> {
            button("Select")
                .w(80)
                .h(32)
                .on_click(property_selection(Self::propose, Self::reply))
        }
    }
    let foreign = Win::new(Select::default()).unwrap().button("Select");
    let mut win = Win::new(Select::default()).unwrap();
    let target = win.button("Select");
    let selected = win.activate(target).unwrap();
    assert_eq!(selected.changed_nodes, 0);
    assert_eq!(win.root().unwrap().state.unwrap().target, target);
    win.update(|model| model.destination = Some(foreign))
        .unwrap();
    let rejected = win.activate(target).unwrap();
    assert_eq!(rejected.changed_nodes, 0);
    assert_eq!(win.root().unwrap().replies, 2);
    assert!(win.root().unwrap().error.contains("StaleTarget"));
    win.update(|model| model.empty = true).unwrap();
    let before = win.inspect().unwrap().source_epoch;
    win.reset_counters().unwrap();
    let empty = win.activate(target).unwrap();
    assert_eq!(empty.changed_nodes, 0);
    assert_eq!(empty.source_epoch, before);
    assert_eq!(win.counters().source_operations, 0);
    assert_eq!(win.root().unwrap().replies, 2);
}
#[test]
fn selection_reply_checks_the_same_contained_mutable_owner() {
    use std::sync::atomic::{AtomicBool, Ordering};
    static WRONG: AtomicBool = AtomicBool::new(false);
    struct Child {
        replies: usize,
    }
    impl Child {
        fn propose(&self, target: Target) -> Option<(Target, PropertyId)> {
            WRONG.store(true, Ordering::SeqCst);
            Some((target, PropertyId::Width))
        }
        fn reply(&mut self, _: Result<PropertyState, &Error>) {
            self.replies += 1;
        }
    }
    impl View for Child {
        fn view(&self) -> El<'_> {
            button("Select").on_click(property_selection(Self::propose, Self::reply))
        }
    }
    struct Parent {
        left: Child,
        right: Child,
    }
    impl Parent {
        const CHILD: Component<Self, Child> = Component::new(
            FieldId::new(1),
            "child",
            |m| &m.left,
            |m| {
                if WRONG.load(Ordering::SeqCst) {
                    &mut m.right
                } else {
                    &mut m.left
                }
            },
        );
    }
    impl View for Parent {
        fn sources() -> Sources<Self> {
            Sources::new().component(Self::CHILD)
        }
        fn view(&self) -> El<'_> {
            Self::CHILD.view(self)
        }
    }
    WRONG.store(false, Ordering::SeqCst);
    let mut win = Win::new(Parent {
        left: Child { replies: 0 },
        right: Child { replies: 0 },
    })
    .unwrap();
    let target = win.button("Select");
    assert!(matches!(win.activate(target), Err(Error::Binding(_))));
    assert_eq!(win.root().unwrap().left.replies, 0);
    assert_eq!(win.root().unwrap().right.replies, 0);
    assert!(win.inspect().unwrap().poisoned);
    assert_eq!(win.activate(target), Err(Error::Poisoned));
    WRONG.store(false, Ordering::SeqCst);
}
#[test]
fn every_closed_catalog_family_returns_canonical_value_and_equal_presence() {
    struct Catalog {
        id: PropertyId,
        target: Option<Target>,
        contribution: Option<Contribution<PropertyValue>>,
        state: Option<PropertyState>,
    }
    impl Catalog {
        fn inspect(&self, target: Target) -> Option<(Target, PropertyId)> {
            Some((target, self.id))
        }
        fn edit(&self) -> Option<PropertyChange> {
            Some((self.target?, self.id, self.contribution?))
        }
        fn reply(&mut self, result: Result<PropertyState, &Error>) {
            let state = result.unwrap();
            self.target = Some(state.target);
            self.state = Some(state);
        }
    }
    impl View for Catalog {
        fn view(&self) -> El<'_> {
            row((
                button("Subject")
                    .w(80)
                    .h(32)
                    .on_click(property_selection(Self::inspect, Self::reply)),
                button("Apply").on_click(property_action(Self::edit, Self::reply)),
            ))
        }
    }
    for info in gpui::property::PROPERTIES {
        let mut win = Win::with_size(
            Catalog {
                id: info.id,
                target: None,
                contribution: None,
                state: None,
            },
            400,
            200,
        )
        .unwrap();
        let target = win.button("Subject");
        win.activate(target).unwrap();
        let inherited = win.root().unwrap().state.unwrap();
        assert_eq!(inherited.contribution, Contribution::Inherit);
        assert_eq!(
            inherited.value,
            win.property_value(target, info.id).unwrap()
        );
        win.update(|model| model.contribution = Some(Contribution::Set(inherited.value)))
            .unwrap();
        assert_eq!(win.activate(win.button("Apply")).unwrap().changed_nodes, 0);
        let equal = win.root().unwrap().state.unwrap();
        assert_eq!(equal.value, inherited.value);
        assert_eq!(equal.contribution, Contribution::Set(inherited.value));
        let changed = match inherited.value {
            PropertyValue::Dimension(_) => PropertyValue::Dimension(gpui::Length::Points(100.)),
            PropertyValue::Number(value) => PropertyValue::Number(value + 1.),
            PropertyValue::Color(_) => {
                PropertyValue::Color(Color::oklch(0.7, 0.1, 40., 0.8).unwrap())
            }
            PropertyValue::Brush(_) => PropertyValue::Brush(gpui::Brush::Solid(
                Color::oklch(0.7, 0.1, 40., 0.8).unwrap(),
            )),
            PropertyValue::Flow(_) => PropertyValue::Flow(Flow::Column),
            PropertyValue::Transform(_) => PropertyValue::Transform(Affine {
                b: 0.125,
                tx: 2.,
                ..Affine::IDENTITY
            }),
            PropertyValue::Align(_) => PropertyValue::Align(Align::Center),
            PropertyValue::Justify(_) => PropertyValue::Justify(Justify::Center),
            PropertyValue::Flag(value) => PropertyValue::Flag(!value),
            _ => panic!("catalog family requires a new case"),
        };
        win.update(|model| model.contribution = Some(Contribution::Set(changed)))
            .unwrap();
        win.activate(win.button("Apply")).unwrap();
        let state = win.root().unwrap().state.unwrap();
        assert_eq!(state.value, changed, "{}", info.name);
        assert_eq!(state.contribution, Contribution::Set(changed));
        assert_eq!(state.value, win.property_value(target, info.id).unwrap());
        win.update(|model| model.contribution = Some(Contribution::Inherit))
            .unwrap();
        win.activate(win.button("Apply")).unwrap();
        assert_eq!(win.root().unwrap().state.unwrap(), inherited);
        assert_eq!(win.activate(win.button("Apply")).unwrap().changed_nodes, 0);
        assert_eq!(win.root().unwrap().state.unwrap(), inherited);
    }
}
#[cfg(feature = "native-core")]
#[test]
fn public_consumer_headers_remain_explicit() {
    println!(
        "PROPERTY_PUBLIC_HEADERS Win={} OptionWin={} Window={} OptionWindow={} Companion={} ValueEntry={}",
        size_of::<Win<Companion>>(),
        size_of::<Option<Win<Companion>>>(),
        size_of::<gpui::Window<Companion>>(),
        size_of::<Option<gpui::Window<Companion>>>(),
        size_of::<Companion>(),
        size_of::<workbench::value_entry::ValueEntry>()
    );
    assert_eq!(size_of::<Win<Companion>>(), 8);
    assert_eq!(size_of::<Option<Win<Companion>>>(), 16);
    // The optional initial font resource adds one cold builder word.
    assert_eq!(size_of::<gpui::Window<Companion>>(), 216);
    assert_eq!(size_of::<Option<gpui::Window<Companion>>>(), 216);
    assert_eq!(size_of::<Companion>(), 136);
    assert_eq!(size_of::<workbench::value_entry::ValueEntry>(), 104);
}

#[test]
fn cold_value_editor_roundtrips_percent_units_and_rejects_invalid_authored_values() {
    let mut win = Win::with_size(Companion::default(), 800, 400).unwrap();
    let target = select_application(&mut win);
    draft(&mut win, "125%");
    win.activate(win.button("Apply")).unwrap();
    assert_eq!(
        win.property(target, gpui::property::WIDTH).unwrap(),
        Length::Percent(125.0)
    );
    assert_eq!(&**win.root().unwrap().editor.draft, "125%");
    for invalid in ["-1%", "NaN%", "inf%"] {
        draft(&mut win, invalid);
        win.activate(win.button("Apply")).unwrap();
        assert_eq!(
            win.property(target, gpui::property::WIDTH).unwrap(),
            Length::Percent(125.0)
        );
        assert!(win.root().unwrap().editor.status.starts_with("Rejected:"));
    }
    draft(&mut win, "auto");
    win.activate(win.button("Apply")).unwrap();
    assert_eq!(
        win.contribution(target, gpui::property::WIDTH).unwrap(),
        Contribution::Set(Length::Auto)
    );
    win.activate(win.button("Inherit")).unwrap();
    assert_eq!(
        win.property(target, gpui::property::WIDTH).unwrap(),
        Length::Points(120.0)
    );
}
