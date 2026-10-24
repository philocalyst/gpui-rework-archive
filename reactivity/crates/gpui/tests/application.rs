use gpui::{Application, ColorConfig, Error, OutputProfile, WindowOptions, prelude::*};
use std::sync::{
    Arc,
    atomic::{AtomicUsize, Ordering},
};
struct Counter {
    count: Signal<u32>,
    dropped: Arc<AtomicUsize>,
}
impl View for Counter {
    fn view(&self) -> El<'_> {
        column((
            text(&self.count),
            button("Increment").on_click(|m: &mut Self| *m.count += 1),
        ))
    }
}
impl Drop for Counter {
    fn drop(&mut self) {
        self.dropped.fetch_add(1, Ordering::Relaxed);
    }
}
struct Label;
impl View for Label {
    fn view(&self) -> El<'_> {
        text("Another model type")
    }
}
fn counter(dropped: &Arc<AtomicUsize>) -> Counter {
    Counter {
        count: Signal::new(0),
        dropped: Arc::clone(dropped),
    }
}
#[test]
fn typed_windows_use_exclusive_production_owners_and_the_same_input_barrier() {
    let dropped = Arc::new(AtomicUsize::new(0));
    let app = Application::demo().options(WindowOptions {
        size: [320, 200],
        ..Default::default()
    });
    let mut first = app.open(counter(&dropped)).unwrap();
    let mut second = app.open(counter(&dropped)).unwrap();
    let label = app.open(Label).unwrap();
    first.click(first.button("Increment")).unwrap();
    assert_eq!(first.with_model(|m| *m.count).unwrap(), 1);
    assert_eq!(second.with_model(|m| *m.count).unwrap(), 0);
    assert_eq!(
        second.click(first.button("Increment")),
        Err(Error::StaleTarget)
    );
    assert!(label.contains_text("Another model type").unwrap());
    assert_eq!(label.snapshot().unwrap().size, [320, 200]);
    first.close();
    assert!(first.is_closed());
    assert_eq!(first.snapshot(), Err(Error::Closed));
    assert_eq!(dropped.load(Ordering::Relaxed), 1);
    assert!(second.snapshot().is_ok());
    second.close();
    second.close();
    assert_eq!(dropped.load(Ordering::Relaxed), 2);
}
#[test]
fn callback_panics_quarantine_the_owner_and_explicit_close_releases_it_once() {
    let dropped = Arc::new(AtomicUsize::new(0));
    let mut win = Win::demo(counter(&dropped));
    assert_eq!(
        win.update(|_| panic!("callback fault")),
        Err(Error::OwnerPanicked)
    );
    assert_eq!(win.update(|_| {}), Err(Error::Poisoned));
    win.close();
    assert_eq!(dropped.load(Ordering::Relaxed), 1);
    assert_eq!(win.settle(), Err(Error::Closed));
}

#[test]
fn reactive_hdr_colors_use_the_ordinary_application_and_property_interface() {
    struct Surface(Signal<Color>);
    const COLOR: Source<Surface, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.0, |m| &mut m.0);
    impl View for Surface {
        fn sources() -> Sources<Self> {
            Sources::new().direct(COLOR)
        }
        fn view(&self) -> El<'_> {
            column((
                div()
                    .size(16)
                    .bg(Color::linear_srgb(-1.0, 0.0, 0.0, 1.0).unwrap()),
                div()
                    .name("surface")
                    .size(16)
                    .bg(&self.0)
                    .transform(Affine::translation(0.0, -16.0)),
            ))
            .w(16)
            .h(32)
        }
    }
    let app = Application::demo().options(WindowOptions {
        size: [16, 16],
        colors: ColorConfig::linear_hdr(OutputProfile::Srgb, 203.0).unwrap(),
    });
    let color = |red| Color::linear_srgb(red, 0.0, 0.0, 1.0).unwrap();
    let mut window = app.open(Surface(Signal::new(color(1.0)))).unwrap();
    let surface = window.query().name("surface").one().unwrap();
    window.update(|_| {}).unwrap();
    window.reset_counters().unwrap();
    for red in [-0.0, -f32::from_bits(1), 1.0, -0.0] {
        window.set(COLOR, color(red)).unwrap();
        assert_eq!(
            window
                .property(surface, gpui::property::BACKGROUND)
                .unwrap()
                .solid()
                .unwrap(),
            color(red)
        );
        let actual = window.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        let mut fresh = app.open(Surface(Signal::new(color(red)))).unwrap();
        assert_eq!(
            actual,
            fresh.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap()
        );
        let expected_red = if red == 1.0 { 0x3c00 } else { 0x8000 };
        assert_eq!(
            u16::from_le_bytes(actual[..2].try_into().unwrap()),
            expected_red
        );
    }
    assert_eq!(window.counters().paint_passes, 0);
    assert_eq!(window.counters().owner_reruns, 0);
}
