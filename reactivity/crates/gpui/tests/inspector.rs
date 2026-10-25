use gpui::{
    Error,
    prelude::*,
    property::{BACKGROUND, Contribution, HEIGHT, TRANSFORM, WIDTH},
};

struct Panel {
    width: u32,
}
impl View for Panel {
    fn view(&self) -> El<'_> {
        div().w(self.width).h(20).bg(rgb(0x123456))
    }
}

#[test]
fn typed_inspection_preserves_presence_and_reveals_updated_component_defaults() {
    let mut window = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    assert!(window.snapshot().unwrap().nodes[0].target.is_none());
    let panel = window.inspect().unwrap().nodes[0].target.unwrap();
    assert_eq!(window.property(panel, WIDTH).unwrap(), Some(20.0));
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Inherit
    );
    window
        .set_property(panel, WIDTH, Contribution::Set(None))
        .unwrap();
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Set(None)
    );
    window.update(|model| model.width = 64).unwrap();
    assert_eq!(window.property(panel, WIDTH).unwrap(), None);
    window
        .set_property(panel, WIDTH, Contribution::Inherit)
        .unwrap();
    assert_eq!(window.property(panel, WIDTH).unwrap(), Some(64.0));
    assert_eq!(window.property(panel, HEIGHT).unwrap(), Some(20.0));
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Inherit
    );
}

#[test]
fn paint_and_transform_edits_skip_owner_and_layout_but_publish_real_output() {
    let mut window = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    let panel = window.inspect().unwrap().nodes[0].target.unwrap();
    let original = window.scene_digest().unwrap();
    window.reset_counters().unwrap();
    window
        .set_property(panel, BACKGROUND, Contribution::Set(rgb(0xef1200)))
        .unwrap();
    assert_ne!(window.scene_digest().unwrap(), original);
    window
        .set_property(
            panel,
            TRANSFORM,
            Contribution::Set(Affine::translation(30.0, 0.0)),
        )
        .unwrap();
    let snapshot = window.snapshot().unwrap();
    assert!((snapshot.nodes[0].bounds[0] - 30.0).abs() < 1e-4);
    assert!(snapshot.nodes[0].bounds[0] <= 30.0, "bounds round outward");
    assert_eq!(window.counters().owner_reruns, 0);
    assert_eq!(window.counters().layout_runs, 0);
    assert_eq!(window.counters().presentations, 2);
}

#[test]
fn invalid_and_foreign_inspector_edits_fail_before_source_admission() {
    let mut window = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    let panel = window.inspect().unwrap().nodes[0].target.unwrap();
    for property in [WIDTH, HEIGHT] {
        for invalid in [f32::NAN, f32::INFINITY, f32::NEG_INFINITY, -1.0] {
            assert!(matches!(
                window.set_property(panel, property, Contribution::Set(Some(invalid))),
                Err(Error::Property(_))
            ));
            assert_eq!(
                window.contribution(panel, property).unwrap(),
                Contribution::Inherit
            );
        }
    }
    assert_eq!(window.snapshot().unwrap().source_epoch, 0);
    assert_eq!(window.property(panel, WIDTH).unwrap(), Some(20.0));
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Inherit
    );
    let mut other = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    assert_eq!(
        other.set_property(panel, WIDTH, Contribution::Set(Some(10.0))),
        Err(Error::StaleTarget)
    );
    assert_eq!(other.snapshot().unwrap().source_epoch, 0);
}

#[test]
fn dimension_builders_reject_invalid_values_at_the_authoring_boundary() {
    for invalid in [f64::NAN, f64::INFINITY, f64::NEG_INFINITY, f64::MAX, -1.0] {
        assert!(std::panic::catch_unwind(|| div().w(invalid)).is_err());
        assert!(std::panic::catch_unwind(|| div().h(invalid)).is_err());
        assert!(std::panic::catch_unwind(|| div().size(invalid)).is_err());
    }
}
