use gpui_reactivity_core::{
    Affine, Geometry, NodeId, NodeKind, Point, Rect, SpatialTree, Tree, inspect,
};

fn main() {
    let mut tree = SpatialTree::new(800, 600).unwrap();
    let camera = tree.insert(None, NodeKind::Element).unwrap();
    let embedded = tree.insert(Some(camera), NodeKind::NestedGpui).unwrap();
    tree.set_geometry(
        camera,
        Some(Geometry {
            transform: Affine::translation(100.0, 50.0),
            ..Geometry::default()
        }),
    )
    .unwrap();
    tree.set_geometry(
        embedded,
        Some(Geometry {
            bounds: Rect::new(0.0, 0.0, 80.0, 40.0),
            ..Geometry::default()
        }),
    )
    .unwrap();
    assert_eq!(tree.hit_test(Point { x: 110.0, y: 60.0 }), Some(embedded));
    tree.clear_damage();
    tree.set_geometry(
        camera,
        Some(Geometry {
            transform: Affine::translation(200.0, 100.0),
            ..Geometry::default()
        }),
    )
    .unwrap();
    assert_eq!(tree.hit_test(Point { x: 210.0, y: 110.0 }), Some(embedded));
    println!(
        "nodes={} geometry={} damaged_tiles={} allocated_payload={}",
        inspect::nodes(tree.tree()).count(),
        tree.geometry_count(),
        tree.damage().tile_count(),
        tree.allocated_bytes()
    );
    println!(
        "NodeId={} topology_slot={} geometry_record={} tree_header={} spatial_header={}",
        std::mem::size_of::<NodeId>(),
        Tree::entry_bytes(),
        SpatialTree::geometry_record_bytes(),
        std::mem::size_of::<Tree>(),
        std::mem::size_of::<SpatialTree>()
    );
}
