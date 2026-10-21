//! Ordinary downstream constructors, copies, equality and containing layouts.
use gpui_reactivity_core::{
    Affine, CoordinateSpace, Geometry, MappedBounds, NodeId, NodeKind, Rect, SpatialTree,
};

#[inline(never)]
fn make(transform: Affine) -> CoordinateSpace {
    CoordinateSpace::new(transform)
}
#[inline(never)]
fn compose(space: CoordinateSpace, child: Affine) -> CoordinateSpace {
    space.compose(child)
}
#[inline(never)]
fn same(left: CoordinateSpace, right: CoordinateSpace) -> bool {
    left == right
}
#[inline(never)]
fn copy(space: CoordinateSpace) -> CoordinateSpace {
    space
}
#[inline(never)]
fn bounds(space: CoordinateSpace, rect: Rect) -> MappedBounds {
    space.mapped_bounds(rect)
}

fn main() {
    let mode = std::env::args().nth(1).unwrap_or_else(|| "make".into());
    let repeats: usize = std::env::args()
        .nth(2)
        .map(|arg| arg.parse().unwrap())
        .unwrap_or(0);
    let transform = std::hint::black_box(Affine::translation(2.0, -3.0));
    let direct = copy(std::hint::black_box(make(transform)));
    let composed = compose(
        std::hint::black_box(direct),
        std::hint::black_box(Affine::IDENTITY),
    );
    assert!(same(
        std::hint::black_box(direct),
        std::hint::black_box(composed)
    ));
    println!(
        "layouts,{},{},{},{}",
        std::mem::size_of::<CoordinateSpace>(),
        std::mem::size_of::<Option<CoordinateSpace>>(),
        std::mem::size_of::<(NodeId, CoordinateSpace)>(),
        SpatialTree::geometry_record_bytes()
    );
    println!(
        "equal,{:?},{:?}",
        bounds(direct, Rect::new(0.0, 0.0, 7.0, 9.0)),
        bounds(composed, Rect::new(0.0, 0.0, 7.0, 9.0))
    );
    let mut tree = SpatialTree::new(256, 256).unwrap();
    let root = tree.insert(None, NodeKind::Element).unwrap();
    for index in 0..64 {
        let node = tree.insert(Some(root), NodeKind::Element).unwrap();
        tree.set_geometry(
            node,
            Some(Geometry {
                bounds: Rect::new(0.0, 0.0, 7.25, 3.125),
                transform: Affine::translation(index as f32, index as f32 * 0.5),
                clip: None,
            }),
        )
        .unwrap();
    }
    let payload = tree.allocated_bytes();
    println!("spatial_payload,{payload}");
    if repeats > 0 {
        use std::hint::black_box;
        let start = std::time::Instant::now();
        match mode.as_str() {
            "make" => {
                for _ in 0..repeats {
                    black_box(make(black_box(transform)));
                }
            }
            "compose_direct" => {
                for _ in 0..repeats {
                    black_box(compose(black_box(direct), black_box(Affine::IDENTITY)));
                }
            }
            "compose_composed" => {
                for _ in 0..repeats {
                    black_box(compose(black_box(composed), black_box(Affine::IDENTITY)));
                }
            }
            "same" => {
                for _ in 0..repeats {
                    black_box(same(black_box(direct), black_box(composed)));
                }
            }
            "copy" => {
                for _ in 0..repeats {
                    black_box(copy(black_box(direct)));
                }
            }
            _ => panic!("unknown mode"),
        }
        println!(
            "cost,{mode},{repeats},{},{payload}",
            start.elapsed().as_nanos()
        );
    }
}
