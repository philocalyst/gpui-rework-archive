//! Matched requested-Rust-allocation control; no timing measurement.
use gpui::{
    Error, PropertyChange, PropertyState,
    prelude::*,
    property::{Contribution, PropertyId, PropertyValue},
    property_action,
};
struct Model {
    property: bool,
    target: Option<Target>,
    replies: usize,
}
impl Model {
    fn ordinary(&mut self) {
        self.replies += 1;
    }
    fn proposal(&self) -> Option<PropertyChange> {
        Some((
            self.target?,
            PropertyId::Width,
            Contribution::Set(PropertyValue::Dimension(Some(80.))),
        ))
    }
    fn replied(&mut self, result: Result<PropertyState, &Error>) {
        assert!(result.is_ok());
        self.replies += 1;
    }
}
impl View for Model {
    fn view(&self) -> El<'_> {
        row((
            button("Subject").w(80).h(32),
            if self.property {
                button("Action").on_click(property_action(Self::proposal, Self::replied))
            } else {
                button("Action").on_click(Self::ordinary)
            },
        ))
    }
}
fn model(property: bool) -> Model {
    Model {
        property,
        target: None,
        replies: 0,
    }
}
#[test]
fn ordinary_and_property_requests_have_matched_allocation_controls() {
    drop(Win::with_size(model(false), 240, 120).unwrap());
    for property in [false, true] {
        let mut owner = None;
        let mount = allocation_counter::measure(|| {
            owner = Some(Win::with_size(model(property), 240, 120).unwrap())
        });
        let mut owner = owner.unwrap();
        let target = owner.button("Subject");
        owner.update(|model| model.target = Some(target)).unwrap();
        let action = owner.button("Action");
        owner.reset_counters().unwrap();
        let applied = allocation_counter::measure(|| {
            for _ in 0..3 {
                assert_eq!(owner.activate(action).unwrap().changed_nodes, 0);
            }
        });
        assert_eq!(owner.root().unwrap().replies, 3);
        assert_eq!(owner.counters().source_operations, 3);
        assert_eq!(
            owner.property_value(target, PropertyId::Width).unwrap(),
            PropertyValue::Dimension(Some(80.))
        );
        let idle = allocation_counter::measure(|| {
            for _ in 0..100 {
                owner.resize([240, 120]).unwrap();
            }
        });
        assert_eq!(idle.count_total, 0);
        println!(
            "OUTLINE_ALLOC property={property} mount_count={} mount_requested={} mount_retained={} mount_peak={} actions_count={} actions_requested={} actions_retained={} actions_peak={} idle_count={}",
            mount.count_total,
            mount.bytes_total,
            mount.bytes_current,
            mount.bytes_max,
            applied.count_total,
            applied.bytes_total,
            applied.bytes_current,
            applied.bytes_max,
            idle.count_total
        );
    }
}
