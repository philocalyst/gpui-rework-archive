use gpui::{
    Error, TextSelection, WindowOptions,
    prelude::*,
    property::{Contribution, PropertyId, PropertyValue},
};
#[path = "../examples/support/property_workbench.rs"]
mod property_workbench;
use property_workbench::Companion;

fn mounted() -> Win<Companion> {
    Win::with_size(Companion::default(), 800, 400).unwrap()
}

#[test]
fn contained_editor_allocation_ledger() {
    let mut owner = None;
    let mount = allocation_counter::measure(|| owner = Some(mounted()));
    let mut owner = owner.unwrap();
    let idle = allocation_counter::measure(|| {
        for _ in 0..100 {
            owner.resize(800, 400).unwrap();
        }
    });
    assert_eq!(idle.count_total, 0);
    let target = owner.button("Library button");
    select(&mut owner, target, PropertyId::Width);
    draft(&mut owner, "193.25");
    let action = allocation_counter::measure(|| {
        owner.click(owner.button("Apply")).unwrap();
    });
    assert_eq!(
        owner.property_value(target, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(Some(193.25))
    );
    println!(
        "contained_editor_cost,Win={},Companion={},ValueEntry={},mount_count={},mount_requested={},mount_retained={},idle_count={},action_count={},action_requested={},action_retained={}",
        size_of_val(&owner),
        size_of::<Companion>(),
        size_of_val(&owner.root().unwrap().editor),
        mount.count_total,
        mount.bytes_total,
        mount.bytes_current,
        idle.count_total,
        action.count_total,
        action.bytes_total,
        action.bytes_current
    );
}
fn select(win: &mut Win<Companion>, target: Target, id: PropertyId) {
    let value = win.property_value(target, id).unwrap();
    win.update(|m| m.editor.select(target, id, value)).unwrap();
}
fn draft(win: &mut Win<Companion>, source: &str) {
    let target = win.find_input().unwrap();
    let end = win.root().unwrap().editor.draft.len();
    win.replace(target, TextSelection::from_bytes(0, end).unwrap(), source)
        .unwrap();
}
#[test]
fn actual_contained_apply_rejects_and_recovers_without_losing_the_route() {
    let mut win = mounted();
    let target = win.button("Library button");
    select(&mut win, target, PropertyId::Width);
    let apply = win.button("Apply");
    draft(&mut win, "193.25");
    win.reset_counters().unwrap();
    win.click(apply).unwrap();
    assert_eq!(win.counters().paint_passes, 1);
    assert_eq!(
        win.property_value(target, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(Some(193.25))
    );
    for invalid in ["NaN", "-1"] {
        draft(&mut win, invalid);
        win.click(apply).unwrap();
        assert!(win.root().unwrap().editor.status.starts_with("Rejected:"));
        assert_eq!(
            win.property_value(target, PropertyId::Width).unwrap(),
            PropertyValue::Dimension(Some(193.25))
        );
    }
    draft(&mut win, "bad syntax");
    let before = win.inspect().unwrap().source_epoch;
    let status = win.root().unwrap().editor.status.clone();
    win.reset_counters().unwrap();
    win.click(apply).unwrap();
    assert_eq!(win.inspect().unwrap().source_epoch, before);
    assert_eq!(win.counters().paint_passes, 0);
    assert_eq!(win.root().unwrap().editor.status, status);
    assert_eq!(&**win.root().unwrap().editor.draft, "bad syntax");
    draft(&mut win, "211.75");
    win.click(apply).unwrap();
    assert_eq!(
        win.property_value(target, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(Some(211.75))
    );
    win.update(|m| *m.application.width = 260.).unwrap();
    win.click(win.button("Inherit")).unwrap();
    assert_eq!(
        win.property_value(target, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(Some(260.))
    );
    win.click(target).unwrap();
    assert_eq!(win.root().unwrap().application.presses, 3);
}
#[test]
fn proposed_foreign_and_stale_targets_report_but_original_stale_event_rejects() {
    let mut win = mounted();
    let other = mounted();
    let foreign = other.button("Library button");
    win.update(|m| {
        m.editor.select(
            foreign,
            PropertyId::Width,
            PropertyValue::Dimension(Some(120.)),
        )
    })
    .unwrap();
    let apply = win.button("Apply");
    draft(&mut win, "180");
    win.click(apply).unwrap();
    assert!(win.root().unwrap().editor.status.contains("StaleTarget"));
    let target = win.button("Library button");
    select(&mut win, target, PropertyId::Width);
    win.update(|m| m.show_application = false).unwrap();
    win.click(apply).unwrap();
    assert!(win.root().unwrap().editor.status.contains("StaleTarget"));
    win.update(|m| m.show_editor = false).unwrap();
    assert!(matches!(win.click(apply), Err(Error::StaleTarget)));
    win.close();
    assert!(matches!(win.click(apply), Err(Error::Closed)));
    assert_eq!(
        other.property_value(foreign, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(Some(120.))
    );
}

#[test]
fn one_editor_family_routes_geometry_color_and_six_affine_components() {
    let mut win = mounted();
    let target = win.button("Library button");
    for (id, source, expected) in [
        (
            PropertyId::CornerRadius,
            "7.125",
            PropertyValue::Number(7.125),
        ),
        (
            PropertyId::Transform,
            "1, 0.25, -0.125, 1, 3.5, 2.25",
            PropertyValue::Transform(Affine {
                a: 1.,
                b: 0.25,
                c: -0.125,
                d: 1.,
                tx: 3.5,
                ty: 2.25,
            }),
        ),
        (
            PropertyId::Background,
            "0.125, 0.25, 0.75, 0.625",
            PropertyValue::Color(Color::srgb(0.125, 0.25, 0.75, 0.625).unwrap()),
        ),
    ] {
        select(&mut win, target, id);
        draft(&mut win, source);
        win.click(win.button("Apply")).unwrap();
        assert_eq!(win.property_value(target, id).unwrap(), expected);
    }
    win.update(|m| {
        m.editor.select(
            target,
            PropertyId::CornerRadius,
            PropertyValue::Dimension(Some(1.)),
        )
    })
    .unwrap();
    draft(&mut win, "10");
    win.click(win.button("Apply")).unwrap();
    assert!(win.root().unwrap().editor.status.contains("WrongKind"));
    assert_eq!(
        win.property_value(target, PropertyId::CornerRadius)
            .unwrap(),
        PropertyValue::Number(7.125)
    );
}
#[test]
fn logical_acceptance_is_distinct_from_acknowledged_presentation() {
    let mut win = Win::recording(Companion::default(), WindowOptions::default()).unwrap();
    let initial = win.with_scene(|_, token| token).unwrap();
    win.presented(initial).unwrap();
    let target = win.button("Library button");
    let value = win.property_value(target, PropertyId::Width).unwrap();
    win.update(|m| {
        m.editor.select(target, PropertyId::Width, value);
        *m.editor.draft = "177.125".into();
    })
    .unwrap();
    let old = win.inspect().unwrap().presentation_epoch;
    let commit = win.activate(win.button("Apply")).unwrap();
    assert!(commit.prepared_epoch.is_some());
    assert_eq!(win.inspect().unwrap().presentation_epoch, old);
    assert_eq!(
        win.root().unwrap().editor.status,
        "Logical contribution accepted"
    );
    assert_eq!(
        win.property_contribution(target, PropertyId::Width)
            .unwrap(),
        Contribution::Set(PropertyValue::Dimension(Some(177.125)))
    );
}

#[test]
fn accepted_contribution_survives_failed_preparation_then_repairs() {
    let mut win = mounted();
    let target = win.button("Library button");
    select(&mut win, target, PropertyId::Transform);
    draft(&mut win, "0, 0, 0, 1, 0, 0");
    let apply = win.button("Apply");
    let old = win.inspect().unwrap().presentation_epoch;
    assert!(matches!(win.click(apply), Err(Error::Canvas(_))));
    assert_eq!(win.inspect().unwrap().presentation_epoch, old);
    assert_eq!(
        win.root().unwrap().editor.status,
        "Logical contribution accepted"
    );
    assert_eq!(
        win.property_value(target, PropertyId::Transform).unwrap(),
        PropertyValue::Transform(Affine::scale(0., 1.))
    );
    // A position-free source edit commits even while the bad logical transform
    // still prevents preparation. The next ordinary Apply repairs that value.
    assert!(matches!(
        win.update(|m| *m.editor.draft = "1, 0, 0, 1, 2, 0".into()),
        Err(Error::Canvas(_))
    ));
    win.activate(apply).unwrap();
    assert_eq!(
        win.property_value(target, PropertyId::Transform).unwrap(),
        PropertyValue::Transform(Affine::translation(2., 0.))
    );
    assert!(win.inspect().unwrap().presentation_epoch > old);
}

#[test]
fn request_and_reply_panics_restore_the_owned_route_until_close() {
    use std::sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    };
    struct Probe(Arc<AtomicUsize>);
    impl Drop for Probe {
        fn drop(&mut self) {
            self.0.fetch_add(1, Ordering::SeqCst);
        }
    }
    struct Owner {
        target: Option<Target>,
        request_panics: bool,
        drops: Arc<AtomicUsize>,
    }
    impl View for Owner {
        fn view(&self) -> El<'_> {
            let probe = Probe(self.drops.clone());
            row((
                button("Subject"),
                button("Apply").on_click(gpui::property_action(
                    move |m: &Self| {
                        let _ = &probe;
                        assert!(!m.request_panics, "request panic");
                        Some((
                            m.target.unwrap(),
                            PropertyId::Width,
                            Contribution::Set(PropertyValue::Dimension(Some(80.))),
                        ))
                    },
                    |_: &mut Self, _| panic!("reply panic"),
                )),
            ))
        }
    }
    for request_panics in [true, false] {
        let drops = Arc::new(AtomicUsize::new(0));
        let mut win = Win::new(Owner {
            target: None,
            request_panics,
            drops: drops.clone(),
        })
        .unwrap();
        let target = win.button("Subject");
        win.update(|m| m.target = Some(target)).unwrap();
        let apply = win.button("Apply");
        let before = drops.load(Ordering::SeqCst);
        assert!(matches!(win.click(apply), Err(Error::OwnerPanicked)));
        assert_eq!(drops.load(Ordering::SeqCst), before);
        assert!(matches!(win.click(apply), Err(Error::Poisoned)));
        win.close();
        assert_eq!(drops.load(Ordering::SeqCst), before + 1);
    }
}

#[test]
fn post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l() {
    use std::sync::atomic::{AtomicBool, Ordering};
    static BAD_WRITE: AtomicBool = AtomicBool::new(false);
    struct Child {
        target: Option<Target>,
        replies: u32,
    }
    impl Child {
        fn proposal(&self) -> Option<gpui::PropertyChange> {
            self.target.map(|target| {
                (
                    target,
                    PropertyId::Width,
                    Contribution::Set(PropertyValue::Dimension(Some(180.))),
                )
            })
        }
        fn reply(&mut self, _: Result<(), &Error>) {
            self.replies += 1;
        }
    }
    impl View for Child {
        fn view(&self) -> El<'_> {
            button("Apply").on_click(gpui::property_action(Self::proposal, Self::reply))
        }
    }
    struct Parent {
        correct: Child,
        wrong: Child,
    }
    impl Parent {
        const CHILD: Component<Self, Child> = Component::new(
            FieldId::new(1),
            "child",
            |m| &m.correct,
            |m| {
                if BAD_WRITE.load(Ordering::SeqCst) {
                    &mut m.wrong
                } else {
                    &mut m.correct
                }
            },
        );
    }
    impl View for Parent {
        fn sources() -> Sources<Self> {
            Sources::new().component(Self::CHILD)
        }
        fn view(&self) -> El<'_> {
            row((button("Subject").w(120), Self::CHILD.view(self)))
        }
    }
    let mut win = Win::new(Parent {
        correct: Child {
            target: None,
            replies: 0,
        },
        wrong: Child {
            target: None,
            replies: 0,
        },
    })
    .unwrap();
    let subject = win.button("Subject");
    win.update(|m| m.correct.target = Some(subject)).unwrap();
    let apply = win.button("Apply");
    let before = win.counters().source_operations;
    // Simulate a contract-violating writer that changes after mount without an
    // owner operation. Shared admission still selects the registered child.
    BAD_WRITE.store(true, Ordering::SeqCst);
    let result = win.activate(apply);
    BAD_WRITE.store(false, Ordering::SeqCst);
    assert!(matches!(
        result,
        Err(Error::Binding(
            gpui::BindError::ComponentProjectionMismatch(_)
        ))
    ));
    assert_eq!(win.counters().source_operations, before + 1);
    assert_eq!(win.root().unwrap().correct.replies, 0);
    assert_eq!(win.root().unwrap().wrong.replies, 0);
    assert!(matches!(
        win.property_value(subject, PropertyId::Width),
        Err(Error::Poisoned)
    ));
    assert!(matches!(win.with_scene(|_, _| ()), Err(Error::Poisoned)));
    assert!(matches!(win.activate(apply), Err(Error::Poisoned)));
    win.close();
}
