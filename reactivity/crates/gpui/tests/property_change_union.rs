use gpui::{
    Error, PropertyChange,
    prelude::*,
    property::{Contribution, PropertyId, PropertyValue},
};

#[derive(Default)]
struct Page {
    selected: Option<Target>,
    inherit: bool,
}
impl Page {
    fn propose(&self) -> Option<PropertyChange> {
        Some((
            self.selected?,
            PropertyId::Width,
            if self.inherit {
                Contribution::Inherit
            } else {
                Contribution::Set(PropertyValue::Dimension(Some(20.0)))
            },
        ))
    }
    fn replied(&mut self, result: Result<(), &Error>) {
        assert!(result.is_ok());
    }
}
impl View for Page {
    fn view(&self) -> El<'_> {
        row((
            button("Target").w(10).h(8),
            button("Apply").on_click(gpui::property_action(Self::propose, Self::replied)),
        ))
    }
}

fn check(inherit: bool) {
    let mut owner = Win::demo(Page::default());
    let target = owner.button("Target");
    if inherit {
        owner
            .set_property_value(
                target,
                PropertyId::Width,
                Contribution::Set(PropertyValue::Dimension(Some(20.0))),
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
        PropertyValue::Dimension(Some(if inherit { 10.0 } else { 20.0 }))
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
