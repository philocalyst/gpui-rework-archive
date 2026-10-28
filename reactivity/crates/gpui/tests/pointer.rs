//! The public protocol is also the native host's normalized mouse path.
use gpui::{Counters, Error, Role, WindowOptions, prelude::*};

struct Control {
    name: Signal<String>,
    x: f32,
    show: bool,
    broken: bool,
    clicks: u32,
}
impl Default for Control {
    fn default() -> Self {
        Self {
            name: Signal::new("control".into()),
            x: 0.0,
            show: true,
            broken: false,
            clicks: 0,
        }
    }
}
impl Control {
    const NAME: Source<Self, String> =
        Source::new(FieldId::new(1), "name", |m| &m.name, |m| &mut m.name);
    fn click(&mut self) {
        self.clicks += 1;
    }
}
impl View for Control {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::NAME)
    }
    fn view(&self) -> El<'_> {
        div().child(self.show.then(|| {
            div()
                .size(32)
                .name(&self.name)
                .bg(Color::BLACK)
                .transform(if self.broken {
                    Affine::scale(0.0, 1.0)
                } else {
                    Affine::translation(self.x, 0.0)
                })
                .on_click(Self::click)
        }))
    }
}
fn point(x: f32) -> PointerEvent {
    PointerEvent::Move(Point { x, y: 8.0 })
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn demo() -> Win<Control> {
    Win::with_size(Control::default(), 96, 64).unwrap()
}

#[test]
fn press_focuses_and_release_rechecks_the_same_live_hit_once() {
    let mut win = demo();
    let mut mouse = PointerSession::default();
    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    let target = win.hit_target(mouse.position().unwrap()).unwrap().unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    assert_eq!(win.focused().unwrap(), Some(target));
    win.pointer_event(&mut mouse, point(80.0)).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 0);

    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    win.pointer_event(&mut mouse, point(80.0)).unwrap();
    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 1);
    win.reset_counters().unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.counters(), Counters::default());
    win.pointer_event(&mut mouse, point(80.0)).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    assert_eq!(win.focused().unwrap(), None);
}

#[test]
fn session_cannot_transfer_a_press_between_window_namespaces() {
    let (mut a, mut b) = (demo(), demo());
    let mut mouse = PointerSession::default();
    a.pointer_event(&mut mouse, point(8.0)).unwrap();
    a.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    b.pointer_event(&mut mouse, PointerEvent::Release).unwrap();
    a.pointer_event(&mut mouse, PointerEvent::Release).unwrap();
    assert_eq!(a.root().unwrap().clicks, 0);
    assert_eq!(b.root().unwrap().clicks, 0);
}

#[test]
fn pending_geometry_rejects_and_consumes_release_before_later_acknowledgement() {
    let mut win = Win::recording(
        Control::default(),
        WindowOptions {
            size: [96, 64],
            ..Default::default()
        },
    )
    .unwrap();
    let mut mouse = PointerSession::default();
    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    assert_eq!(
        win.pointer_event(&mut mouse, PointerEvent::Press),
        Err(Error::PresentationStale)
    );
    ack(&mut win);
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 0);
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    win.update(|m| m.x = 48.0).unwrap();
    win.pointer_event(&mut mouse, point(56.0)).unwrap();
    assert_eq!(
        win.pointer_event(&mut mouse, PointerEvent::Release),
        Err(Error::PresentationStale)
    );
    ack(&mut win);
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 0);
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 1);
}

#[test]
fn semantic_only_publication_keeps_the_current_gesture_usable() {
    let mut win = demo();
    let mut mouse = PointerSession::default();
    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    win.reset_counters().unwrap();
    let commit = win.set(Control::NAME, "renamed".to_owned()).unwrap();
    assert_eq!(commit.prepared_epoch, None);
    assert_eq!(win.counters().paint_passes, 0);
    assert_eq!(win.counters().layout_runs, 0);
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 1);
}

#[test]
fn a_fresh_hit_on_a_new_acknowledged_sheet_can_activate_the_surviving_target() {
    let mut win = Win::recording(
        Control::default(),
        WindowOptions {
            size: [96, 64],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let mut mouse = PointerSession::default();
    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    let target = win.focused().unwrap().unwrap();
    win.update(|m| m.x = 48.0).unwrap();
    ack(&mut win);
    win.pointer_event(&mut mouse, point(56.0)).unwrap();
    assert_eq!(
        win.hit_target(mouse.position().unwrap()).unwrap(),
        Some(target)
    );
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 1);
}

#[test]
fn failed_prepare_or_removed_target_never_replays_a_press() {
    let mut win = demo();
    let mut mouse = PointerSession::default();
    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    assert!(win.update(|m| m.broken = true).is_err());
    assert_eq!(
        win.pointer_event(&mut mouse, PointerEvent::Release),
        Err(Error::PresentationStale)
    );
    win.update(|m| m.broken = false).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 0);

    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    let old = win.focused().unwrap().unwrap();
    win.update(|m| m.show = false).unwrap();
    win.update(|m| m.show = true).unwrap();
    assert_ne!(
        win.hit_target(mouse.position().unwrap()).unwrap(),
        Some(old)
    );
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().clicks, 0);
}

#[test]
fn leave_nonfinite_cancel_and_wheel_consume_a_gesture_without_blurring() {
    for event in [
        PointerEvent::Leave,
        PointerEvent::Cancel,
        point(f32::NAN),
        point(f32::INFINITY),
        PointerEvent::Wheel(ScrollDelta { x: 0.0, y: 1.0 }),
    ] {
        let mut win = demo();
        let mut mouse = PointerSession::default();
        win.pointer_event(&mut mouse, point(8.0)).unwrap();
        win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
        let focused = win.focused().unwrap();
        let result = win.pointer_event(&mut mouse, event);
        assert!(result.is_ok() || result == Err(Error::NotHittable));
        assert_eq!(win.focused().unwrap(), focused);
        win.pointer_event(&mut mouse, point(8.0)).unwrap();
        win.pointer_event(&mut mouse, PointerEvent::Release)
            .unwrap();
        assert_eq!(win.root().unwrap().clicks, 0);
    }
}

#[test]
fn wheel_uses_the_ordinary_two_axis_scroll_router() {
    struct Pane;
    impl View for Pane {
        fn view(&self) -> El<'_> {
            div().size(32).scroll(Axis::BOTH).child(div().size(128))
        }
    }
    let mut win = Win::with_size(Pane, 32, 32).unwrap();
    let mut mouse = PointerSession::default();
    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    win.pointer_event(
        &mut mouse,
        PointerEvent::Wheel(ScrollDelta { x: 7.0, y: 11.0 }),
    )
    .unwrap();
    let pane = win.role(Role::ScrollView).one().unwrap();
    assert_eq!(
        win.viewport(pane).unwrap().offset,
        ScrollOffset { x: 7.0, y: 11.0 }
    );
    assert_eq!(win.counters().coarse_updates, 0);
}

#[test]
fn repeated_input_clicks_allocate_nothing_after_selection_activation() {
    struct Input(Signal<String>);
    impl View for Input {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Source::new(
                FieldId::new(1),
                "value",
                |m| &m.0,
                |m| &mut m.0,
            ))
        }
        fn view(&self) -> El<'_> {
            text_input(&self.0).w(80).h(32)
        }
    }
    let mut win = Win::with_size(Input(Signal::new(String::new())), 96, 64).unwrap();
    let mut mouse = PointerSession::default();
    // The first click activates the one cold selection and publishes its caret.
    win.pointer_event(&mut mouse, point(8.0)).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    win.reset_counters().unwrap();
    let allocations = allocation_counter::measure(|| {
        for _ in 0..1_000 {
            win.pointer_event(&mut mouse, point(8.0)).unwrap();
            win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
            win.pointer_event(&mut mouse, PointerEvent::Release)
                .unwrap();
        }
    });
    assert_eq!(allocations.count_total, 0);
    assert_eq!(win.counters(), Counters::default());
    assert_eq!(win.focused().unwrap(), Some(win.input()));
    if cfg!(target_pointer_width = "64") {
        assert_eq!(std::mem::size_of::<PointerSession>(), 32);
    }
    win.close();
    assert_eq!(
        win.pointer_event(&mut mouse, PointerEvent::Press),
        Err(Error::Closed)
    );
}
