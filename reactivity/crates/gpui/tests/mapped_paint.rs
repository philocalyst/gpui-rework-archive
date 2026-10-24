//! Mapped author colors use the same complete-scene paint authority as direct colors.
use gpui::{Error, LaneSet, WindowOptions, prelude::*, property::BACKGROUND};

struct Panel {
    value: Signal<u32>,
    alpha: bool,
    two: bool,
}
impl Panel {
    const VALUE: Source<Self, u32> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            div()
                .name("paint")
                .size(4)
                .bg(self.value.map_with(self.alpha, |value, alpha| {
                    if alpha {
                        if *value == 0 {
                            Color::TRANSPARENT
                        } else {
                            Color::BLACK
                        }
                    } else if *value & 1 == 0 {
                        Color::BLACK
                    } else {
                        Color::WHITE
                    }
                })),
            self.two.then(|| {
                div().name("peer").size(4).bg(self.value.map(|value| {
                    if *value & 1 == 0 {
                        Color::WHITE
                    } else {
                        Color::BLACK
                    }
                }))
            }),
            column((0..10_000).map(|_| div().size(1))),
        ))
    }
}
fn ack<M: View + 'static, L: LaneSet<M>>(win: &mut Win<M, L>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn window(alpha: bool, two: bool) -> Win<Panel> {
    Win::recording(
        Panel {
            value: Signal::new(0),
            alpha,
            two,
        },
        WindowOptions {
            size: [32, 32],
            ..Default::default()
        },
    )
    .unwrap()
}
fn first_pixel(win: &mut Win<Panel>) -> [u8; 4] {
    win.with_pixels(|pixels, _, _| pixels[..4].try_into().unwrap())
        .unwrap()
}

#[test]
fn one_mapped_color_keeps_ten_thousand_rows_without_allocating_a_replacement_scene() {
    let mut win = window(false, false);
    ack(&mut win);
    let target = win.query().name("paint").one().unwrap();
    let bounds = win.bounds(target).unwrap();
    let initial = first_pixel(&mut win);
    for value in 1..=4 {
        let previous = win.with_scene(|_, token| token).unwrap();
        win.reset_counters().unwrap();
        let cost = allocation_counter::measure(|| {
            win.set(Panel::VALUE, value).unwrap();
        });
        eprintln!(
            "mapped_complete_paint,value={value},allocations={},requested={},retained={}",
            cost.count_total, cost.bytes_total, cost.bytes_current
        );
        assert_eq!(
            cost.count_total, 0,
            "a color turn must preserve complete geometry"
        );
        let counters = win.counters();
        assert_eq!(counters.owner_reruns, 0);
        assert_eq!(counters.layout_runs, 0);
        assert_eq!(counters.paint_passes, 0);
        assert_eq!(counters.destination_compares, 1);
        let next = win.with_scene(|_, token| token).unwrap();
        assert_ne!(next, previous);
        assert_eq!(win.bounds(target).unwrap(), bounds);
        assert_eq!(
            win.hit_target(Point { x: 1.0, y: 1.0 }),
            Err(Error::PresentationStale)
        );
        let color = if value & 1 == 0 {
            Color::BLACK
        } else {
            Color::WHITE
        };
        assert_eq!(
            win.property(target, BACKGROUND).unwrap().solid().unwrap(),
            color
        );
        assert_eq!(first_pixel(&mut win) == initial, value & 1 == 0);
        ack(&mut win);
        assert_eq!(win.bounds(target).unwrap(), bounds);
    }
}

#[test]
fn alpha_changes_and_two_changed_slots_preserve_complete_pixels() {
    for (alpha, two) in [(true, false), (false, true)] {
        let mut win = window(alpha, two);
        ack(&mut win);
        let before = first_pixel(&mut win);
        win.reset_counters().unwrap();
        win.set(Panel::VALUE, 1).unwrap();
        assert!(
            win.counters().paint_passes > 0,
            "topology or multiple slots need full preparation"
        );
        assert_ne!(first_pixel(&mut win), before);
        ack(&mut win);
        if two {
            let target = win.query().name("peer").one().unwrap();
            assert_eq!(
                win.property(target, BACKGROUND).unwrap().solid().unwrap(),
                Color::BLACK
            );
        }
    }
}

#[test]
fn mounted_inspector_refreshes_the_mapped_color_after_a_complete_paint_turn() {
    let mut win = Win::with_inspector(
        Panel {
            value: Signal::new(0),
            alpha: false,
            two: false,
        },
        WindowOptions {
            size: [640, 240],
            ..Default::default()
        },
    )
    .unwrap();
    let target = win.query().name("paint").one().unwrap();
    win.inspector_select(target).unwrap();
    let caption = |color| {
        format!(
            "background: {:?}\nInherit",
            gpui::property::PropertyValue::Brush(gpui::Brush::Solid(color))
        )
    };
    assert!(win.contains_text(&caption(Color::BLACK)).unwrap());
    win.set(Panel::VALUE, 1).unwrap();
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        Color::WHITE
    );
    assert!(win.contains_text(&caption(Color::WHITE)).unwrap());
    assert!(!win.contains_text(&caption(Color::BLACK)).unwrap());
}
