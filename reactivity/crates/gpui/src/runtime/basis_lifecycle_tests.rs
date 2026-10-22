//! Ordinary consumer API checks for the acknowledged geometry owner boundary.
use super::*;
use crate::Signal;

struct Panel {
    map: Affine,
    radius: f32,
    broken: bool,
    color: Signal<Color>,
}
impl Panel {
    const COLOR: Source<Self, Color> = Source::new(
        FieldId::new(1),
        "color",
        |model| &model.color,
        |model| &mut model.color,
    );
    fn new(map: Affine) -> Self {
        Self {
            map,
            radius: 3.0,
            broken: false,
            color: Signal::new(Color::BLACK),
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> crate::El<'_> {
        crate::div()
            .size(16)
            .rounded(self.radius)
            .bg(&self.color)
            .transform(if self.broken {
                Affine::scale(f32::MAX, f32::MAX)
            } else {
                self.map
            })
    }
}
fn bits(map: Affine) -> [u32; 6] {
    [map.a, map.b, map.c, map.d, map.tx, map.ty].map(f32::to_bits)
}
fn expected(map: Affine, scale: f32) -> [u32; 6] {
    // The existing public core algebra is the reference, independent of the codec.
    let space = CoordinateSpace::new(Affine::scale(scale, scale))
        .compose(Affine::translation(0.0, 0.0))
        .compose(map);
    space
        .coefficients()
        .map(|coefficient| (coefficient as f32).to_bits())
}
#[derive(Debug, PartialEq)]
struct Projection {
    target: Target,
    map: [u32; 6],
    local: [u32; 4],
    bounds: [u32; 4],
    radius: u32,
    hit: bool,
}
fn projection(win: &Win<Panel>) -> Projection {
    let mut output = Vec::new();
    win.visit(|part| {
        let local = part.local_bounds();
        let bounds = part.bounds();
        output.push(Projection {
            target: part.target(),
            map: bits(part.transform().unwrap()),
            local: [local.x, local.y, local.width, local.height].map(f32::to_bits),
            bounds: [bounds.x, bounds.y, bounds.width, bounds.height].map(f32::to_bits),
            radius: part.corner_radius().to_bits(),
            hit: part.contains_point(Point {
                x: bounds.x + bounds.width * 0.5,
                y: bounds.y + bounds.height * 0.5,
            }),
        });
    })
    .unwrap();
    assert_eq!(output.len(), 1);
    output.pop().unwrap()
}
fn ack(win: &mut Win<Panel>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
#[test]
fn candidate_scale_failed_lowering_and_empty_ack_keep_geometry_epoch_coherent() {
    let first = Affine {
        a: 1.25,
        b: 0.125,
        tx: 4.0,
        ty: 6.0,
        ..Affine::IDENTITY
    };
    let second = Affine {
        a: 1.5,
        c: 0.25,
        tx: 8.0,
        ty: 2.0,
        ..Affine::IDENTITY
    };
    let mut win = Win::recording(
        Panel::new(first),
        WindowOptions {
            size: [128, 128],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let old = projection(&win);
    assert_eq!(old.map, expected(first, 1.0));
    assert!(old.hit);
    win.update(|model| {
        model.map = second;
        model.radius = 7.0;
    })
    .unwrap();
    let stale = win.with_scene(|_, token| token).unwrap();
    assert_eq!(projection(&win), old);
    win.resize_scaled([128, 128], 2.0).unwrap();
    let coherent = win.with_scene(|_, token| token).unwrap();
    assert_ne!(coherent, stale);
    assert_eq!(win.presented(stale), Err(Error::StalePresentation));
    assert_eq!(projection(&win), old);
    assert!(win.update(|model| model.broken = true).is_err());
    assert_eq!(win.with_scene(|_, token| token).unwrap(), coherent);
    assert_eq!(projection(&win), old);
    win.presented(coherent).unwrap();
    let current = projection(&win);
    assert_eq!(current.target, old.target);
    assert_eq!(current.map, expected(second, 2.0));
    assert_eq!(current.radius, 7.0f32.to_bits());
    assert_eq!(current.local, [0, 0, 16.0f32.to_bits(), 16.0f32.to_bits()]);
    win.update(|model| {
        model.broken = false;
        model.map = Affine::IDENTITY;
        model.radius = 0.0;
    })
    .unwrap();
    assert_eq!(projection(&win), current);
    let runtime = win.runtime().unwrap();
    assert!(
        runtime
            .metadata
            .as_ref()
            .unwrap()
            .geometry
            .as_ref()
            .unwrap()
            .record_storage()
            .0
            > 0
    );
    ack(&mut win);
    assert_eq!(projection(&win).map, expected(Affine::IDENTITY, 2.0));
    assert_eq!(projection(&win).radius, 0);
    assert!(
        win.runtime()
            .unwrap()
            .metadata
            .as_ref()
            .is_none_or(|metadata| metadata.geometry.is_none())
    );
}
#[test]
fn typed_paint_keep_preserves_custom_basis_and_radius_storage() {
    let map = Affine {
        a: 1.25,
        b: 0.125,
        tx: 4.0,
        ..Affine::IDENTITY
    };
    let mut win = Win::recording(
        Panel::new(map),
        WindowOptions {
            size: [128, 128],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let old = projection(&win);
    let storage = win
        .runtime()
        .unwrap()
        .metadata
        .as_ref()
        .unwrap()
        .geometry
        .as_ref()
        .unwrap()
        .record_storage();
    win.set(Panel::COLOR, Color::rgb(90, 20, 40)).unwrap();
    assert!(
        win.runtime()
            .unwrap()
            .prepared
            .as_ref()
            .unwrap()
            .keeps_rows()
    );
    assert_eq!(projection(&win), old);
    ack(&mut win);
    assert_eq!(projection(&win), old);
    assert_eq!(
        win.runtime()
            .unwrap()
            .metadata
            .as_ref()
            .unwrap()
            .geometry
            .as_ref()
            .unwrap()
            .record_storage(),
        storage
    );
}
