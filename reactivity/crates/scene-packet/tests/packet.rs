use gpui_reactivity_core::{Affine, Rect};
use gpui_scene_packet::{
    Builder, Capacity, Common, Error, Glyph, Limits, Operation, Paint, ResourceKey,
};
use std::{cell::Cell, rc::Rc, sync::Arc};

fn paint() -> Paint {
    Paint {
        transform: Affine::IDENTITY,
        clip: Rect::new(0.0, 0.0, 1024.0, 1024.0),
        color: [0.3, 0.2, 0.1, 0.5],
    }
}
fn glyph(x: f32, key: u128) -> Glyph {
    Glyph {
        rect: Rect::new(x, 10.0, 5.0, 8.0),
        resource: ResourceKey(key),
    }
}

#[test]
fn mixed_painter_order_stable_keys_and_borrowed_resources() {
    let mask = Arc::new(vec![8u8; 40]);
    let mut builder = Builder::new(1024, 1024, Limits::default()).unwrap();
    builder.resource(ResourceKey(1), mask.clone()).unwrap();
    builder
        .rectangle(Rect::new(0.0, 0.0, 10.0, 10.0), paint())
        .unwrap();
    builder
        .glyph_run(paint(), [glyph(1.0, 1), glyph(7.0, 1)])
        .unwrap();
    builder
        .rectangle(Rect::new(50.0, 50.0, 10.0, 10.0), paint())
        .unwrap();
    builder.glyph_run(paint(), [glyph(60.0, 1)]).unwrap();
    let packet = builder.finish();
    assert_eq!(Arc::strong_count(&mask), 2);
    let mut sequence = Vec::new();
    for op in packet.operations() {
        match op {
            Operation::Rectangle(rect) => sequence.push((0, rect.rect.x)),
            Operation::Glyphs(run) => {
                for glyph in run.glyphs() {
                    assert_eq!(glyph.key, ResourceKey(1));
                    assert!(Arc::ptr_eq(glyph.resource, &mask));
                    assert_eq!(glyph.resource.as_slice(), &[8; 40]);
                    sequence.push((1, glyph.rect.x));
                }
            }
        }
    }
    assert_eq!(
        sequence,
        [(0, 0.0), (1, 1.0), (1, 7.0), (0, 50.0), (1, 60.0)]
    );
    assert_eq!(Arc::strong_count(&mask), 2);
    drop(packet);
    assert_eq!(Arc::strong_count(&mask), 1);
}

#[test]
fn different_local_origins_use_exactly_the_same_inverse_and_mask_coordinates() {
    let mut p = paint();
    p.transform = Affine {
        a: 1.25,
        b: 0.25,
        c: -0.5,
        d: 2.0,
        tx: 50.0,
        ty: 17.0,
    };
    let mut builder = Builder::new(1024, 1024, Limits::default()).unwrap();
    builder.resource(ResourceKey(9), [255u8; 40]).unwrap();
    builder
        .glyph_run(p, [glyph(1.0, 9), glyph(40.0, 9), glyph(90.0, 9)])
        .unwrap();
    let packet = builder.finish();
    let Operation::Glyphs(run) = packet.operations().next().unwrap() else {
        panic!()
    };
    for glyph in run.glyphs() {
        // The old scalar path rebuilds this identical inverse for every glyph.
        let old = Common::prepare(p).unwrap();
        assert_eq!(run.common.inverse(), old.inverse());
        let local = (glyph.rect.x as f64 + 2.5, glyph.rect.y as f64 + 4.0);
        let t = p.transform;
        let device = (
            t.a as f64 * local.0 + t.c as f64 * local.1 + t.tx as f64,
            t.b as f64 * local.0 + t.d as f64 * local.1 + t.ty as f64,
        );
        let recovered = run.common.local(device.0, device.1);
        assert_eq!(recovered, old.local(device.0, device.1));
        assert!((recovered.0 - glyph.rect.x as f64 - 2.5).abs() < 1e-12);
        assert!((recovered.1 - glyph.rect.y as f64 - 4.0).abs() < 1e-12);
        let [left, top, right, bottom] = glyph.bounds.0;
        assert!(left as f64 <= device.0 && device.0 < right as f64);
        assert!(top as f64 <= device.1 && device.1 < bottom as f64);
    }
}

#[test]
fn bad_runs_and_panicking_iterators_preserve_the_committed_prefix() {
    let mut builder = Builder::new(1024, 1024, Limits::default()).unwrap();
    builder.resource(ResourceKey(1), ()).unwrap();
    builder.glyph_run(paint(), [glyph(1.0, 1)]).unwrap();
    assert_eq!(
        builder.glyph_run(paint(), [glyph(9.0, 1), glyph(15.0, 2)]),
        Err(Error::MissingResource(ResourceKey(2)))
    );
    let failure = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        builder
            .glyph_run(
                paint(),
                (0..3).map(|n| {
                    assert!(n != 2, "iterator failed");
                    glyph(n as f32, 1)
                }),
            )
            .unwrap();
    }));
    assert!(failure.is_err());
    let packet = builder.finish();
    assert_eq!(packet.operations().len(), 1);
    let Operation::Glyphs(run) = packet.operations().next().unwrap() else {
        panic!()
    };
    assert_eq!(run.glyphs().len(), 1);
    assert_eq!(packet.storage().placements, 28);
}

#[test]
fn duplicate_keys_return_payload_and_all_admission_limits_are_checked() {
    let drops = Rc::new(Cell::new(0));
    #[derive(Debug)]
    struct Lease(Rc<Cell<usize>>);
    impl Drop for Lease {
        fn drop(&mut self) {
            self.0.set(self.0.get() + 1);
        }
    }
    let mut builder = Builder::new(
        100,
        100,
        Limits {
            operations: 1,
            glyphs: 1,
            resources: 1,
        },
    )
    .unwrap();
    builder
        .resource(ResourceKey(1), Lease(drops.clone()))
        .unwrap();
    let rejected = builder
        .resource(ResourceKey(1), Lease(drops.clone()))
        .unwrap_err();
    assert_eq!(rejected.0, Error::DuplicateResource(ResourceKey(1)));
    assert_eq!(drops.get(), 0);
    drop(rejected);
    assert_eq!(drops.get(), 1);
    assert_eq!(
        builder.reserve(Capacity {
            glyphs: 2,
            ..Capacity::default()
        }),
        Err(Error::Limit)
    );
    assert_eq!(
        builder.glyph_run(paint(), [glyph(1.0, 1), glyph(7.0, 1)]),
        Err(Error::Limit)
    );
    builder.glyph_run(paint(), [glyph(1.0, 1)]).unwrap();
    assert_eq!(
        builder.rectangle(Rect::new(0.0, 0.0, 2.0, 2.0), paint()),
        Err(Error::Limit)
    );
    let mut invalid = paint();
    invalid.transform = Affine::scale(0.0, 1.0);
    assert_eq!(builder.glyph_run(invalid, []), Err(Error::Geometry));
    drop(builder);
    assert_eq!(drops.get(), 2);
}

#[test]
fn iteration_allocates_and_clones_nothing_and_ledger_matches_retained_allocations() {
    let mask = Arc::new([0u8; 40]);
    let mut packet = None;
    let allocation = allocation_counter::measure(|| {
        let mut builder = Builder::new(1024, 1024, Limits::default()).unwrap();
        builder
            .reserve(Capacity {
                runs: 48,
                glyphs: 480,
                resources: 1,
                ..Capacity::default()
            })
            .unwrap();
        builder.resource(ResourceKey(1), mask.clone()).unwrap();
        for _ in 0..48 {
            builder
                .glyph_run(paint(), (0..10).map(|n| glyph(n as f32 * 6.0, 1)))
                .unwrap();
        }
        packet = Some(builder.finish());
    });
    let packet = packet.unwrap();
    assert_eq!(
        allocation.bytes_current as usize + packet.storage().object,
        packet.storage().total()
    );
    let iter = allocation_counter::measure(|| {
        for op in packet.operations() {
            if let Operation::Glyphs(run) = op {
                for glyph in run.glyphs() {
                    std::hint::black_box(glyph.resource);
                }
            }
        }
    });
    assert_eq!(iter.count_total, 0);
    assert_eq!(Arc::strong_count(&mask), 2);
}

#[test]
fn unused_leases_are_released_and_keys_survive_resource_index_remapping() {
    let one = Arc::new([1u8; 40]);
    let two = Arc::new([2u8; 40]);
    let unused = Arc::new([3u8; 40]);
    for reverse in [false, true] {
        let mut builder = Builder::new(1024, 1024, Limits::default()).unwrap();
        for key in if reverse { [2, 0, 1] } else { [1, 0, 2] } {
            builder
                .resource(
                    ResourceKey(key),
                    match key {
                        1 => one.clone(),
                        2 => two.clone(),
                        _ => unused.clone(),
                    },
                )
                .unwrap();
        }
        builder
            .glyph_run(paint(), [glyph(1.0, 1), glyph(7.0, 2)])
            .unwrap();
        let packet = builder.finish();
        assert_eq!(packet.resources().len(), 2);
        assert_eq!(Arc::strong_count(&unused), 1);
        let Operation::Glyphs(run) = packet.operations().next().unwrap() else {
            panic!()
        };
        let mut glyphs = run.glyphs();
        let first = glyphs.next().unwrap();
        let second = glyphs.next().unwrap();
        assert_eq!((first.key, second.key), (ResourceKey(1), ResourceKey(2)));
        assert!(Arc::ptr_eq(first.resource, &one));
        assert!(Arc::ptr_eq(second.resource, &two));
    }
}
