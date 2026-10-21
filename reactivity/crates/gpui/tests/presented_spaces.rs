use gpui::property::{Contribution, TRANSFORM};
use gpui::{Affine, Color, Error, Point, PresentationToken, Target, WindowOptions, prelude::*};

struct Panels {
    count: usize,
    diverse: bool,
    broken: bool,
    shift: f32,
    clicks: usize,
}
impl Panels {
    fn click(&mut self) {
        self.clicks += 1;
    }
}
impl View for Panels {
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            div()
                .size(2)
                .bg(Color::BLACK)
                .on_click(Self::click)
                .transform(if self.broken && index == 0 {
                    Affine::scale(0.0, 1.0)
                } else {
                    Affine {
                        a: if self.diverse {
                            1.0 + index as f32 / 128.0
                        } else {
                            1.0
                        },
                        b: 0.0,
                        c: 0.0,
                        d: 1.0,
                        tx: self.shift,
                        ty: 0.0,
                    }
                })
        }))
    }
}
fn token(window: &Win<Panels>) -> PresentationToken {
    window.with_scene(|_, token| token).unwrap()
}
fn geometry(window: &Win<Panels>) -> Vec<(Target, [u32; 6], [u32; 4])> {
    let mut result = Vec::new();
    window
        .visit(|part| {
            let map = part.transform().unwrap();
            let rect = part.local_bounds();
            result.push((
                part.target(),
                [map.a, map.b, map.c, map.d, map.tx, map.ty].map(f32::to_bits),
                [rect.x, rect.y, rect.width, rect.height].map(f32::to_bits),
            ));
        })
        .unwrap();
    result
}
#[test]
fn old_and_pending_geometry_survive_palette_dense_changes_failed_resize_and_removal() {
    let mut window = Win::recording(
        Panels {
            count: 128,
            diverse: false,
            broken: false,
            shift: 0.0,
            clicks: 0,
        },
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    window.presented(token(&window)).unwrap();
    let initial = geometry(&window);
    let target = initial[1].0;
    assert_eq!(
        window.hit_target(Point { x: 1.0, y: 1.0 }).unwrap(),
        Some(target)
    );
    window
        .update(|model| {
            model.diverse = true;
            model.shift = 8.0;
        })
        .unwrap();
    let dense = token(&window);
    assert_eq!(geometry(&window), initial);
    assert_eq!(
        window.hit_target(Point { x: 1.0, y: 1.0 }),
        Err(Error::PresentationStale)
    );
    assert!(matches!(
        window.update(|model| model.broken = true),
        Err(Error::Canvas(_))
    ));
    assert!(matches!(
        window.resize_scaled([80, 80], 1.25),
        Err(Error::Canvas(_))
    ));
    assert_eq!(token(&window), dense);
    assert_eq!(geometry(&window), initial);
    window.presented(dense).unwrap();
    let frozen_dense = geometry(&window);
    assert_ne!(frozen_dense, initial);
    assert_eq!(f32::from_bits(frozen_dense[1].1[4]), 8.0);
    window
        .update(|model| {
            model.broken = false;
            model.diverse = false;
            model.shift = 4.0;
        })
        .unwrap();
    assert_eq!(geometry(&window), frozen_dense);
    window.presented(token(&window)).unwrap();
    assert_eq!(window.snapshot().unwrap().size, [80, 80]);
    assert_eq!(window.snapshot().unwrap().scale_factor, 1.25);
    assert_eq!(f32::from_bits(geometry(&window)[1].1[4]), 5.0);
    window.click(target).unwrap();
    assert_eq!(window.root().unwrap().clicks, 1);
    window.update(|model| model.count = 1).unwrap();
    assert_eq!(window.activate(target), Err(Error::StaleTarget));
}

#[test]
fn reflected_and_absent_maps_use_the_same_semantic_and_hit_geometry() {
    struct Scene;
    impl View for Scene {
        fn view(&self) -> El<'_> {
            div().size(32).child((
                div()
                    .size(8)
                    .bg(Color::BLACK)
                    .transform(Affine {
                        a: -1.0,
                        b: 0.0,
                        c: 0.0,
                        d: 1.0,
                        tx: 16.0,
                        ty: 0.0,
                    })
                    .on_click(|_: &mut Scene| {}),
                div().size(8).transform(Affine::scale(0.0, 0.0)),
            ))
        }
    }
    let mut window = Win::with_size(Scene, 32, 32).unwrap();
    let mut parts = Vec::new();
    window
        .visit(|part| {
            parts.push((
                part.target(),
                part.transform(),
                part.local_bounds(),
                part.bounds(),
            ))
        })
        .unwrap();
    assert!(parts[2].1.is_none());
    assert!(parts[2].3.is_empty());
    let reflected = parts[1];
    assert_eq!(reflected.1.unwrap().a.to_bits(), (-1.0_f32).to_bits());
    assert_eq!(
        window.hit_target(Point { x: 12.0, y: 4.0 }).unwrap(),
        Some(reflected.0)
    );
    window
        .set_property(
            reflected.0,
            TRANSFORM,
            Contribution::Set(Affine::translation(20.0, 0.0)),
        )
        .unwrap();
    assert_eq!(
        window.hit_target(Point { x: 24.0, y: 4.0 }).unwrap(),
        Some(reflected.0)
    );
}
