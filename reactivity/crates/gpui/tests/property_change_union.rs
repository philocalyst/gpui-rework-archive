use gpui::{
    Error, PropertyChange,
    prelude::*,
    property::{Contribution, PropertyId, PropertyValue},
};

#[derive(Default)]
struct Page {
    selected: Option<Target>,
    inherit: bool,
    reply: Reply,
    finished: bool,
    property: Option<(PropertyId, PropertyValue)>,
    no_proposal: bool,
    stale_proposal: bool,
    unregistered: Signal<String>,
}
#[derive(Clone, Copy, Default)]
enum Reply {
    #[default]
    None,
    TargetText,
    PeerText,
    Remove,
    Replace,
    BadView,
}
impl Page {
    fn propose(&self) -> Option<PropertyChange> {
        if self.no_proposal {
            return None;
        }
        let (id, value) = self.property.unwrap_or((
            PropertyId::Width,
            PropertyValue::Dimension(gpui::Length::Points(20.0)),
        ));
        Some((
            self.selected?,
            id,
            if self.inherit {
                Contribution::Inherit
            } else {
                Contribution::Set(value)
            },
        ))
    }
    fn replied(&mut self, result: Result<gpui::PropertyState, &Error>) {
        assert_eq!(
            result.is_err(),
            self.stale_proposal
                || matches!(
                    self.property,
                    Some((PropertyId::Width, PropertyValue::Number(_)))
                )
        );
        if !matches!(self.reply, Reply::None) {
            self.finished = true;
        }
    }
}
impl View for Page {
    fn view(&self) -> El<'_> {
        let target = match (self.finished, self.reply) {
            (true, Reply::Remove) => None,
            (true, Reply::Replace) => Some(div().w(10).h(8)),
            _ => Some(
                button(
                    if self.finished && matches!(self.reply, Reply::TargetText) {
                        "Target changed"
                    } else {
                        "Target"
                    },
                )
                .w(10)
                .h(8)
                .rounded(3.0),
            ),
        };
        row((
            target,
            button("Apply").on_click(gpui::property_action(Self::propose, Self::replied)),
            label(if self.finished && matches!(self.reply, Reply::PeerText) {
                "Peer changed"
            } else {
                "Peer"
            }),
            (self.finished && matches!(self.reply, Reply::BadView))
                .then(|| text_input(&self.unregistered)),
        ))
    }
}

fn mounted(page: Page) -> (Win<Page>, Target) {
    let mut owner = Win::demo(page);
    let target = owner.button("Target");
    owner.update(|page| page.selected = Some(target)).unwrap();
    (owner, target)
}

fn check(inherit: bool) {
    let mut owner = Win::demo(Page::default());
    let target = owner.button("Target");
    if inherit {
        owner
            .set_property_value(
                target,
                PropertyId::Width,
                Contribution::Set(PropertyValue::Dimension(gpui::Length::Points(20.0))),
            )
            .unwrap();
    }
    owner
        .update(|page| {
            page.selected = Some(target);
            page.inherit = inherit;
        })
        .unwrap();
    let before = owner.inspect().unwrap().source_epoch;
    owner.reset_counters().unwrap();
    let commit = owner.activate(owner.button("Apply")).unwrap();
    assert_eq!(
        owner.property_value(target, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(gpui::Length::Points(if inherit { 10.0 } else { 20.0 }))
    );
    assert_eq!(commit.source_epoch, before + 1);
    assert_eq!(owner.counters().source_operations, 1);
    assert_eq!(owner.counters().paint_passes, 1);
    assert_eq!(commit.changed_nodes, 1);
}

#[test]
fn set_with_no_model_reply_counts_the_property_destination() {
    check(false);
}

#[test]
fn inherit_with_no_model_reply_counts_the_property_destination() {
    check(true);
}

#[test]
fn overlapping_target_change_counts_once_and_a_peer_change_counts_twice() {
    for (reply, expected) in [(Reply::TargetText, 1), (Reply::PeerText, 2)] {
        let (mut owner, target) = mounted(Page {
            reply,
            ..Default::default()
        });
        let commit = owner.activate(owner.button("Apply")).unwrap();
        assert_eq!(commit.changed_nodes, expected);
        assert_eq!(
            owner.property_value(target, PropertyId::Width).unwrap(),
            PropertyValue::Dimension(gpui::Length::Points(20.0))
        );
    }
}

#[test]
fn retirement_and_kind_replacement_count_the_old_property_target_once() {
    // Removing one of three siblings replaces the unkeyed run: three retired
    // nodes plus two new nodes. Replacing only its kind retires/adds one site.
    for (reply, expected) in [(Reply::Remove, 5), (Reply::Replace, 2)] {
        let (mut owner, old) = mounted(Page {
            reply,
            ..Default::default()
        });
        let commit = owner.activate(owner.button("Apply")).unwrap();
        assert_eq!(commit.changed_nodes, expected);
        assert!(matches!(
            owner.property_value(old, PropertyId::Width),
            Err(Error::StaleTarget)
        ));
    }
}

#[test]
fn radius_and_general_map_set_and_inherit_count_their_destination() {
    for (id, value) in [
        (PropertyId::CornerRadius, PropertyValue::Number(7.0)),
        (
            PropertyId::Transform,
            PropertyValue::Transform(Affine {
                b: 0.125,
                c: 0.25,
                ..Affine::IDENTITY
            }),
        ),
    ] {
        let (mut owner, target) = mounted(Page {
            property: Some((id, value)),
            ..Default::default()
        });
        let base = owner.property_value(target, id).unwrap();
        assert_eq!(
            owner.activate(owner.button("Apply")).unwrap().changed_nodes,
            1
        );
        assert_eq!(owner.property_value(target, id).unwrap(), value);
        owner.update(|page| page.inherit = true).unwrap();
        assert_eq!(
            owner.activate(owner.button("Apply")).unwrap().changed_nodes,
            1
        );
        assert_eq!(owner.property_value(target, id).unwrap(), base);
    }
}

#[test]
fn rejected_equal_and_empty_requests_do_not_reuse_a_prior_change_marker() {
    let (mut owner, target) = mounted(Page::default());
    assert_eq!(
        owner.activate(owner.button("Apply")).unwrap().changed_nodes,
        1
    );
    // Equal Set retains contribution presence but edits no effective destination.
    assert_eq!(
        owner.activate(owner.button("Apply")).unwrap().changed_nodes,
        0
    );
    owner
        .update(|page| page.property = Some((PropertyId::Width, PropertyValue::Number(2.0))))
        .unwrap();
    assert_eq!(
        owner.activate(owner.button("Apply")).unwrap().changed_nodes,
        0
    );
    assert_eq!(
        owner.property_value(target, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(gpui::Length::Points(20.0))
    );
    owner.update(|page| page.no_proposal = true).unwrap();
    let before = owner.inspect().unwrap().source_epoch;
    owner.reset_counters().unwrap();
    let commit = owner.activate(owner.button("Apply")).unwrap();
    assert_eq!(commit.source_epoch, before);
    assert_eq!(commit.changed_nodes, 0);
    assert_eq!(owner.counters().source_operations, 0);
    assert_eq!(owner.counters().paint_passes, 0);
}

#[test]
fn a_foreign_proposal_does_not_reuse_a_previous_property_change() {
    let (mut owner, _) = mounted(Page::default());
    assert_eq!(
        owner.activate(owner.button("Apply")).unwrap().changed_nodes,
        1
    );
    let foreign = Win::demo(Page::default()).button("Target");
    owner
        .update(|page| {
            page.selected = Some(foreign);
            page.stale_proposal = true;
        })
        .unwrap();
    owner.reset_counters().unwrap();
    let commit = owner.activate(owner.button("Apply")).unwrap();
    assert_eq!(commit.changed_nodes, 0);
    assert_eq!(owner.counters().source_operations, 1);
    assert_eq!(owner.counters().paint_passes, 0);
}

#[test]
fn failed_prepare_keeps_logical_edit_and_repair_has_a_fresh_marker() {
    let (mut owner, target) = mounted(Page {
        property: Some((
            PropertyId::Transform,
            PropertyValue::Transform(Affine::scale(0.0, 1.0)),
        )),
        ..Default::default()
    });
    let before = owner.inspect().unwrap();
    assert!(matches!(
        owner.activate(owner.button("Apply")),
        Err(Error::Canvas(_))
    ));
    assert_eq!(
        owner.inspect().unwrap().presentation_epoch,
        before.presentation_epoch
    );
    assert_eq!(
        owner.property_value(target, PropertyId::Transform).unwrap(),
        PropertyValue::Transform(Affine::scale(0.0, 1.0))
    );
    assert!(owner.update(|page| page.inherit = true).is_err());
    let commit = owner.activate(owner.button("Apply")).unwrap();
    assert_eq!(commit.changed_nodes, 1);
    assert_eq!(
        owner.property_value(target, PropertyId::Transform).unwrap(),
        PropertyValue::Transform(Affine::IDENTITY)
    );
}

#[test]
fn failed_description_retires_the_old_target_and_discards_its_marker() {
    let (mut owner, target) = mounted(Page {
        reply: Reply::BadView,
        ..Default::default()
    });
    let before = owner.inspect().unwrap();
    assert!(matches!(
        owner.activate(owner.button("Apply")),
        Err(Error::UnregisteredInput { .. })
    ));
    assert_eq!(
        owner.inspect().unwrap().presentation_epoch,
        before.presentation_epoch
    );
    owner.update(|page| page.finished = false).unwrap();
    let fresh = owner.button("Target");
    assert_ne!(fresh, target);
    assert_eq!(
        owner.property_value(fresh, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(gpui::Length::Points(10.0))
    );
    assert_eq!(owner.activate(target), Err(Error::StaleTarget));
}

#[test]
fn changed_component_scope_counts_consumed_old_target_and_fresh_replacement() {
    struct Child;
    impl View for Child {
        fn view(&self) -> El<'_> {
            button("Target").w(10).h(8)
        }
    }
    struct Parent {
        first: Child,
        second: Child,
        selected: Option<Target>,
        switched: bool,
    }
    impl Parent {
        const FIRST: Component<Self, Child> =
            Component::new(FieldId::new(1), "first", |p| &p.first, |p| &mut p.first);
        const SECOND: Component<Self, Child> =
            Component::new(FieldId::new(2), "second", |p| &p.second, |p| &mut p.second);
        fn propose(&self) -> Option<PropertyChange> {
            Some((
                self.selected?,
                PropertyId::Width,
                Contribution::Set(PropertyValue::Dimension(gpui::Length::Points(20.0))),
            ))
        }
        fn replied(&mut self, result: Result<gpui::PropertyState, &Error>) {
            assert!(result.is_ok());
            self.switched = true;
        }
    }
    impl View for Parent {
        fn sources() -> Sources<Self> {
            Sources::new()
                .component(Self::FIRST)
                .component(Self::SECOND)
        }
        fn view(&self) -> El<'_> {
            row((
                if self.switched {
                    Self::SECOND.view(self)
                } else {
                    Self::FIRST.view(self)
                },
                button("Apply").on_click(gpui::property_action(Self::propose, Self::replied)),
            ))
        }
    }
    let mut owner = Win::demo(Parent {
        first: Child,
        second: Child,
        selected: None,
        switched: false,
    });
    let old = owner.button("Target");
    owner.update(|page| page.selected = Some(old)).unwrap();
    let commit = owner.activate(owner.button("Apply")).unwrap();
    assert_eq!(commit.changed_nodes, 2);
    let fresh = owner.button("Target");
    assert_ne!(old, fresh);
    assert_eq!(
        owner.property_value(fresh, PropertyId::Width).unwrap(),
        PropertyValue::Dimension(gpui::Length::Points(10.0))
    );
    assert_eq!(owner.activate(old), Err(Error::StaleTarget));
}

#[test]
fn direct_property_setter_keeps_its_destination_through_list_realization() {
    struct Rows;
    impl ItemSource for Rows {
        fn len(&self) -> usize {
            100
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() < 100).then_some(key.get() as usize)
        }
        fn row(&self, _: usize) -> El<'_> {
            div().w(64).h(16)
        }
    }
    struct Lists(Rows);
    impl View for Lists {
        fn view(&self) -> El<'_> {
            row((
                button("Target").w(10).h(8),
                uniform_list(ListId::new(1), &self.0, 16).w(64).h(32),
            ))
        }
    }
    let mut owner = Win::with_size(Lists(Rows), 128, 128).unwrap();
    let target = owner.button("Target");
    for contribution in [
        Contribution::Set(PropertyValue::Dimension(gpui::Length::Points(20.0))),
        Contribution::Inherit,
    ] {
        let commit = owner
            .set_property_value(target, PropertyId::Width, contribution)
            .unwrap();
        assert_eq!(commit.changed_nodes, 1);
    }
}
