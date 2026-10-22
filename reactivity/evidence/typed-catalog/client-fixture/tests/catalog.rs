use catalog_client_fixture::{LibraryPage, OtherPage};
use gpui::{Affine, Align, Color, Error, Flow, Justify, View, Win};
use gpui::property::{Contribution::{self, Inherit, Set}, PROPERTIES, PropertyErrorKind, PropertyId as Id, PropertyValue as Value, ValueKind};

// One family implementation; an additive unknown family is a read-only row.
fn sample(kind: ValueKind) -> Option<Value> {
    Some(match kind {
        ValueKind::Dimension => Value::Dimension(Some(42.)),
        ValueKind::Number => Value::Number(2.),
        ValueKind::Color => Value::Color(gpui::rgb(0x705030)),
        ValueKind::Flow => Value::Flow(Flow::Row),
        ValueKind::Transform => Value::Transform(Affine::translation(2., 3.)),
        ValueKind::Align => Value::Align(Align::Center),
        ValueKind::Justify => Value::Justify(Justify::Center),
        ValueKind::Flag => Value::Flag(true),
        _ => return None,
    })
}
fn epoch<M: View + 'static>(win: &Win<M>) -> u64 { win.inspect().unwrap().source_epoch }

#[test]
fn external_tool_traverses_every_declared_property_without_a_selector_match() {
    let mut win = Win::demo(LibraryPage::default());
    let target = win.button("Save");
    let mut count = 0;
    for info in PROPERTIES {
        assert!(std::ptr::eq(*info, info.id.info()));
        let Some(value) = sample(info.kind) else { continue; };
        win.set_property_value(target, info.id, Set(value)).unwrap();
        assert_eq!(win.property_value(target, info.id).unwrap(), value);
        assert_eq!(win.property_contribution(target, info.id).unwrap(), Set(value));
        win.set_property_value(target, info.id, Inherit).unwrap();
        assert_eq!(win.property_contribution(target, info.id).unwrap(), Inherit);
        count += 1;
    }
    assert_eq!(count, 13);
    // Number family must dispatch this ID to Geometry, not the Style store.
    win.set_property_value(target, Id::CornerRadius, Set(Value::Number(7.))).unwrap();
    assert_eq!(win.property(target, gpui::property::CORNER_RADIUS).unwrap(), 7.);
}

#[test]
fn invalid_closed_values_are_atomic_before_any_contribution_or_source_change() {
    let mut win = Win::demo(LibraryPage::default());
    let target = win.button("Save");
    let other = win.button("Open");
    for info in PROPERTIES {
        let wrong = if info.kind == ValueKind::Number { Value::Flag(true) } else { Value::Number(1.) };
        let before = (epoch(&win), win.property_value(target, info.id).unwrap(), win.property_contribution(target, info.id).unwrap());
        assert!(matches!(win.set_property_value(target, info.id, Set(wrong)), Err(Error::Property(_))));
        assert_eq!((epoch(&win), win.property_value(target, info.id).unwrap(), win.property_contribution(target, info.id).unwrap()), before);
        assert_eq!(win.property_contribution(other, info.id).unwrap(), Inherit);
    }
    for (id, value, reason) in [
        (Id::Width, Value::Dimension(Some(-1.)), PropertyErrorKind::Negative),
        (Id::Gap, Value::Number(-1.), PropertyErrorKind::Negative),
        (Id::Padding, Value::Number(f32::NAN), PropertyErrorKind::NonFinite),
        (Id::CornerRadius, Value::Number(-1.), PropertyErrorKind::Negative),
        (Id::FontSize, Value::Number(0.), PropertyErrorKind::NonPositive),
        (Id::Height, Value::Dimension(Some(f32::INFINITY)), PropertyErrorKind::NonFinite),
        (Id::Transform, Value::Transform(Affine::translation(f32::NAN, 0.)), PropertyErrorKind::NonFinite),
    ] {
        let before = epoch(&win);
        let Err(Error::Property(error)) = win.set_property_value(target, id, Set(value)) else { panic!("invalid {id:?} accepted") };
        assert_eq!(error.reason, reason);
        assert_eq!(epoch(&win), before);
        assert_eq!(win.property_contribution(target, id).unwrap(), Inherit);
    }
}

#[test]
fn two_libraries_preserve_source_layers_and_caller_selected_behavior() {
    let mut win = Win::demo(LibraryPage::default());
    let save = win.button("Save");
    let open = win.button("Open");
    let original = win.property_value(save, Id::Background).unwrap();
    win.set_property_value(save, Id::Background, Set(original)).unwrap();
    assert_eq!(win.property_contribution(save, Id::Background).unwrap(), Set(original));
    let newer = gpui::rgb(0x803020);
    win.set(LibraryPage::FILL, newer).unwrap();
    assert_eq!(win.property_value(save, Id::Background).unwrap(), original);
    win.set_property_value(save, Id::Background, Inherit).unwrap();
    assert_eq!(win.property_value(save, Id::Background).unwrap(), Value::Color(newer));
    for (target, id, source) in [(save, Id::CornerRadius, LibraryPage::RADIUS), (open, Id::Gap, LibraryPage::GAP)] {
        win.set_property_value(target, id, Set(Value::Number(9.))).unwrap();
        win.set(source, 6.).unwrap();
        assert_eq!(win.property_value(target, id).unwrap(), Value::Number(9.));
        win.set_property_value(target, id, Inherit).unwrap();
        assert_eq!(win.property_value(target, id).unwrap(), Value::Number(6.));
    }
    win.set_property_value(save, Id::Width, Set(Value::Dimension(None))).unwrap();
    assert_eq!(win.property_contribution(save, Id::Width).unwrap(), Set(Value::Dimension(None)));
    win.click(save).unwrap();
    win.click(open).unwrap();
    assert_eq!((win.root().unwrap().saved, win.root().unwrap().filtered), (1, 10));
    let mut other = Win::demo(OtherPage(0));
    let target = other.button("Other");
    other.click(target).unwrap();
    assert_eq!(other.root().unwrap().0, 2);
    let before = epoch(&other);
    assert!(matches!(other.set_property_value(save, Id::Width, Set(Value::Dimension(Some(1.)))), Err(Error::StaleTarget)));
    assert_eq!(epoch(&other), before);
}

#[test]
fn failed_prepare_keeps_logical_values_distinct_from_acknowledged_geometry() {
    let mut win = Win::demo(LibraryPage::default());
    let target = win.button("Save");
    let before = win.inspect().unwrap();
    let matrix = Affine::scale(0., 1.);
    assert!(win.set_property_value(target, Id::Transform, Set(Value::Transform(matrix))).is_err());
    assert_eq!(win.property_value(target, Id::Transform).unwrap(), Value::Transform(matrix));
    assert_eq!(win.property_contribution(target, Id::Transform).unwrap(), Set(Value::Transform(matrix)));
    let after = win.inspect().unwrap();
    assert_eq!(after.presentation_epoch, before.presentation_epoch);
    assert!(after.source_epoch > before.source_epoch);
    assert_eq!(after.nodes.iter().find(|n| n.target == Some(target)).unwrap().transform,
        before.nodes.iter().find(|n| n.target == Some(target)).unwrap().transform);
    win.set_property_value(target, Id::Transform, Inherit).unwrap();
    assert_eq!(win.property_contribution(target, Id::Transform).unwrap(), Inherit);
}
