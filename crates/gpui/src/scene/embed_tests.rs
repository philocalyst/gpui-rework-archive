use super::*;
use crate::{SceneAtlas, SceneHsla, TransformationMatrix, rgb, size};
use std::sync::Arc;

fn bounds(x: f32, width: f32) -> Bounds<ScaledPixels> {
    Bounds::new(
        point(ScaledPixels(x), ScaledPixels(0.)),
        size(ScaledPixels(width), ScaledPixels(20.)),
    )
}
fn capture() -> SceneCapture {
    let mut scene = Scene::default();
    let bounds = bounds(0., 20.);
    let mask = ContentMask {
        bounds,
        ..Default::default()
    };
    scene.insert_primitive(Quad {
        bounds,
        content_mask: mask,
        background: rgb(0xff0000).into(),
        ..Default::default()
    });
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds,
        content_mask: mask,
        color: SceneHsla::default(),
        transformation: TransformationMatrix::unit(),
        tile: AtlasTile {
            texture_id: AtlasTextureId {
                kind: AtlasTextureKind::Monochrome,
                index: 100,
            },
            tile_id: TileId(0),
            padding: 0,
            bounds: Bounds::new(
                point(DevicePixels(0), DevicePixels(0)),
                size(DevicePixels(2), DevicePixels(2)),
            ),
        },
    });
    scene.finish();
    SceneCapture::capture(&scene, |_| {
        Ok(CapturedBitmap {
            kind: AtlasTextureKind::Monochrome,
            width: 2,
            height: 2,
            bytes: vec![255; 4],
        })
    })
    .unwrap()
}
#[test]
fn imported_atlas_resources_are_reused_and_released_after_the_last_frame() {
    let capture = capture();
    let atlas = Arc::new(SceneAtlas::new());
    let mut resources = SceneResources::default();
    let first = resources.import(&capture, atlas.clone()).unwrap();
    let tile = first.scene.monochrome_sprites[0].tile;
    let next = resources.import(&capture, atlas.clone()).unwrap();
    assert_eq!(tile, next.scene.monochrome_sprites[0].tile);
    drop(first);
    assert_eq!(atlas.resolve(tile).unwrap().bytes, [255; 4]);
    drop(next);
    assert!(atlas.resolve(tile).is_err());
    let recreated = resources.import(&capture, atlas.clone()).unwrap();
    assert_ne!(tile, recreated.scene.monochrome_sprites[0].tile);
    let another_atlas = Arc::new(SceneAtlas::new());
    let another = resources.import(&capture, another_atlas.clone()).unwrap();
    assert_eq!(
        another_atlas
            .resolve(another.scene.monochrome_sprites[0].tile)
            .unwrap()
            .bytes,
        [255; 4]
    );
}
#[test]
fn composing_a_scene_preserves_logical_size_and_clips_fades_at_embedding_edges() {
    let capture = capture();
    let mut resources = SceneResources::default();
    let imported = resources
        .import(&capture, Arc::new(SceneAtlas::new()))
        .unwrap();
    let mut destination = Scene::default();
    let clip = ContentMask {
        bounds: bounds(35., 10.),
        ..Default::default()
    };
    destination
        .append_imported(
            &imported,
            point(ScaledPixels(30.), ScaledPixels(0.)),
            2.,
            clip,
            0.5,
        )
        .unwrap();
    destination.finish();
    assert_eq!(
        destination.quads[0].bounds,
        Bounds::new(
            point(ScaledPixels(30.), ScaledPixels(0.)),
            size(ScaledPixels(40.), ScaledPixels(40.))
        )
    );
    assert_eq!(destination.quads[0].content_mask.bounds, clip.bounds);
    let sprite = &destination.monochrome_sprites[0];
    assert_eq!(sprite.bounds, imported.scene.monochrome_sprites[0].bounds);
    assert_eq!(sprite.transformation.translation, [30., 0.]);
    assert_eq!(sprite.transformation.rotation_scale, [[2., 0.], [0., 2.]]);
    assert_eq!(sprite.content_mask.bounds, clip.bounds);
    let faded = ContentMask {
        bounds: bounds(0., 100.),
        fade_out: Edges {
            left: ScaledPixels(10.),
            ..Default::default()
        },
    };
    assert_eq!(faded.intersect(&clip).fade_out.left, ScaledPixels(0.));
}
#[test]
fn content_filter_groups_remain_paired_when_composed_with_a_parent_scene() {
    let mut source = Scene::default();
    let bounds = bounds(0., 20.);
    let mask = ContentMask {
        bounds,
        ..Default::default()
    };
    let boundary = FilterBoundary {
        order: 0,
        bounds,
        content_mask: mask,
        corner_radii: Default::default(),
        corner_smoothing: 0.,
        filters: smallvec::smallvec![ScaledFilter::Blur(ScaledPixels(2.))],
        opacity: 1.,
        is_start: true,
    };
    source.insert_primitive(boundary.clone());
    source.insert_primitive(Quad {
        bounds,
        content_mask: mask,
        ..Default::default()
    });
    source.insert_primitive(FilterBoundary {
        is_start: false,
        ..boundary
    });
    source.finish();
    let capture = SceneCapture::capture(&source, |_| unreachable!()).unwrap();
    let imported = SceneResources::default()
        .import(&capture, Arc::new(SceneAtlas::new()))
        .unwrap();
    let mut parent = Scene::default();
    parent.insert_primitive(Quad {
        bounds,
        content_mask: mask,
        ..Default::default()
    });
    parent
        .append_imported(&imported, Point::default(), 1., mask, 1.)
        .unwrap();
    parent.insert_primitive(Quad {
        bounds,
        content_mask: mask,
        ..Default::default()
    });
    parent.finish();
    assert_eq!(parent.render_plan().requirements().isolated_filter_count, 1);
    assert!(matches!(
        parent.render_commands().first(),
        Some(RenderCommand::Batch(PrimitiveBatch::Quads { .. }))
    ));
    assert!(matches!(
        parent.render_commands().last(),
        Some(RenderCommand::Batch(PrimitiveBatch::Quads { .. }))
    ));
}
