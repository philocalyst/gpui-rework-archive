//! GPU-free, hermetic snapshot tests for the canonical scene archive.
//!
//! Scenes are built purely in CPU code — no window, GPU, or font state — and lowered with
//! [`gpui::SceneArchive::from_scene`]; each case snapshots the quantized canonical JSON plus the
//! scene's `requires_offscreen_rendering` flag. A passing snapshot therefore pins the whole scene
//! contract: primitive presence, draw orders, layer nesting, filter targets, path/surface
//! surrogates, and the deduplicated, sorted resource list.
//!
//! The sample builders mirror the ones used by the in-crate `scene::snapshot` unit tests, adapted
//! to the public API an integration test can reach. Regenerate snapshots with
//! `INSTA_UPDATE=always cargo test -p gpui-ce --test scene_snapshots`, then review with
//! `cargo insta review --accept`.

use smallvec::smallvec;

use gpui::{
    AtlasTextureId, AtlasTextureKind, AtlasTile, BackdropFilter, Bounds, ContentMask, Corners,
    DevicePixels, FilterBoundary, MonochromeSprite, PaintSurface, Path, PolychromeSprite, Quad,
    ScaledFilter, ScaledPixels, Scene, SceneArchive, SceneHsla, ShaderBool, Size, SubpixelSprite,
    SurfaceSource, TileId, TransformationMatrix, Underline, hsla, point, px, solid_background,
};

fn sp(value: f32) -> ScaledPixels {
    ScaledPixels(value)
}

fn bounds_at(x: f32, y: f32) -> Bounds<ScaledPixels> {
    Bounds {
        origin: point(sp(x), sp(y)),
        size: Size {
            width: sp(100.0),
            height: sp(100.0),
        },
    }
}

fn bounds_sized(x: f32, y: f32, width: f32, height: f32) -> Bounds<ScaledPixels> {
    Bounds {
        origin: point(sp(x), sp(y)),
        size: Size {
            width: sp(width),
            height: sp(height),
        },
    }
}

fn mask_at(x: f32, y: f32) -> ContentMask<ScaledPixels> {
    ContentMask {
        bounds: bounds_at(x, y),
    }
}

fn quad_at(x: f32, y: f32) -> Quad {
    Quad {
        bounds: bounds_at(x, y),
        content_mask: mask_at(x, y),
        ..Default::default()
    }
}

fn colored_quad_at(x: f32, y: f32, color: gpui::Hsla) -> Quad {
    Quad {
        background: solid_background(color),
        ..quad_at(x, y)
    }
}

fn quad_sized(x: f32, y: f32, width: f32, height: f32) -> Quad {
    Quad {
        bounds: bounds_sized(x, y, width, height),
        content_mask: ContentMask {
            bounds: bounds_sized(x, y, width, height),
        },
        ..Default::default()
    }
}

fn shadow_at(x: f32, y: f32) -> gpui::Shadow {
    gpui::Shadow {
        order: 0,
        blur_radius: sp(4.0),
        bounds: bounds_at(x, y),
        corner_radii: Corners::default(),
        content_mask: mask_at(x, y),
        color: SceneHsla::from(hsla(0.0, 0.0, 0.0, 0.4)),
        element_bounds: bounds_at(x, y),
        element_corner_radii: Corners::default(),
        inset: ShaderBool::Disabled,
        padding: 0,
    }
}

fn underline_at(x: f32, y: f32) -> Underline {
    Underline {
        order: 0,
        padding: 0,
        bounds: bounds_at(x, y),
        content_mask: mask_at(x, y),
        color: SceneHsla::from(hsla(0.6, 0.8, 0.5, 1.0)),
        thickness: sp(1.0),
        wavy: ShaderBool::Disabled,
    }
}

fn tile(kind: AtlasTextureKind, index: u32, tile_id: u32) -> AtlasTile {
    AtlasTile {
        texture_id: AtlasTextureId { index, kind },
        tile_id: TileId(tile_id),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(16),
                height: DevicePixels(16),
            },
        },
    }
}

fn mono_sprite() -> MonochromeSprite {
    MonochromeSprite {
        order: 0,
        padding: 0,
        bounds: bounds_at(0.0, 0.0),
        content_mask: mask_at(0.0, 0.0),
        color: SceneHsla::from(hsla(0.0, 0.0, 0.0, 1.0)),
        tile: tile(AtlasTextureKind::Monochrome, 2, 3),
        transformation: TransformationMatrix::unit(),
    }
}

fn subpixel_sprite() -> SubpixelSprite {
    SubpixelSprite {
        order: 0,
        padding: 0,
        bounds: bounds_at(0.0, 0.0),
        content_mask: mask_at(0.0, 0.0),
        color: SceneHsla::from(hsla(0.0, 0.0, 0.0, 1.0)),
        tile: tile(AtlasTextureKind::Subpixel, 3, 4),
        transformation: TransformationMatrix::unit(),
    }
}

fn poly_sprite() -> PolychromeSprite {
    PolychromeSprite {
        order: 0,
        padding: 0,
        grayscale: ShaderBool::Disabled,
        opacity: 0.75,
        bounds: bounds_at(0.0, 0.0),
        content_mask: mask_at(0.0, 0.0),
        corner_radii: Corners::default(),
        tile: tile(AtlasTextureKind::Polychrome, 4, 5),
    }
}

fn path() -> Path<ScaledPixels> {
    let mut path = Path::new(point(px(0.0), px(0.0)));
    path.line_to(point(px(10.0), px(0.0)));
    path.line_to(point(px(10.0), px(10.0)));
    let mut path = path.scale(2.0);
    path.content_mask = mask_at(0.0, 0.0);
    path.color = solid_background(hsla(0.6, 0.8, 0.5, 1.0));
    path
}

fn backdrop_filter() -> BackdropFilter {
    BackdropFilter {
        bounds: bounds_at(0.0, 0.0),
        content_mask: mask_at(0.0, 0.0),
        corner_radii: Corners::default(),
        filters: smallvec![ScaledFilter::Blur(sp(8.0))],
        ..Default::default()
    }
}

fn boundary(is_start: bool) -> FilterBoundary {
    FilterBoundary {
        order: 0,
        bounds: bounds_at(0.0, 0.0),
        content_mask: mask_at(0.0, 0.0),
        corner_radii: Corners::default(),
        filters: smallvec![ScaledFilter::Blur(sp(8.0))],
        opacity: 1.0,
        is_start,
    }
}

fn surface() -> PaintSurface {
    PaintSurface {
        order: 0,
        bounds: bounds_at(0.0, 0.0),
        content_mask: mask_at(0.0, 0.0),
        source: SurfaceSource::Unsupported(Size {
            width: DevicePixels(320),
            height: DevicePixels(180),
        }),
    }
}

fn empty_scene() -> Scene {
    let mut scene = Scene::default();
    scene.finish();
    scene
}

fn single_quad() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(colored_quad_at(10.25, 20.5, hsla(0.55, 0.8, 0.55, 1.0)));
    scene.finish();
    scene
}

/// Non-overlapping quads (here a 4x4 grid) reuse draw order 0, so the archive's canonical sort
/// must order them purely by content — independent of the (deliberately jumbled) insertion order.
/// Kept small so the snapshot stays reviewable; the property scales to a full 512-cell grid.
fn quad_grid_sort() -> Scene {
    let mut scene = Scene::default();
    for row in (0..4).rev() {
        for column in (0..4).rev() {
            let x = column as f32 * 128.0 + if column % 2 == 0 { 0.5 } else { 0.0 };
            let y = row as f32 * 128.0;
            scene.insert_primitive(quad_sized(x, y, 120.0, 120.0));
        }
    }
    scene.finish();
    scene
}

/// Shuffled insertion of overlapping and detached primitives: overlapping clusters claim distinct
/// orders while detached ones share low orders, and the archive must emit a `(order, kind)`-sorted
/// stream that ignores insertion order.
fn mixed_batches() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(underline_at(200.0, 0.0));
    scene.insert_primitive(colored_quad_at(0.0, 0.0, hsla(0.1, 0.6, 0.5, 1.0)));
    scene.insert_primitive(shadow_at(0.0, 0.0));
    scene.insert_primitive(underline_at(0.0, 0.0));
    scene.insert_primitive(quad_at(400.0, 0.0));
    scene.finish();
    scene
}

fn nested_layers() -> Scene {
    let mut scene = Scene::default();
    scene.push_layer(bounds_at(0.0, 0.0));
    scene.insert_primitive(colored_quad_at(0.0, 0.0, hsla(0.3, 0.7, 0.5, 1.0)));
    scene.push_layer(bounds_at(10.0, 10.0));
    scene.insert_primitive(shadow_at(10.0, 10.0));
    scene.pop_layer();
    scene.insert_primitive(underline_at(0.0, 200.0));
    scene.pop_layer();
    scene.insert_primitive(quad_at(400.0, 400.0));
    scene.finish();
    scene
}

fn backdrop_filter_scene() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(quad_at(0.0, 0.0));
    scene.insert_primitive(backdrop_filter());
    scene.finish();
    scene
}

/// Two nested content-filter groups: the plan must assign each an isolated offscreen target.
fn content_filter_scene() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(boundary(true));
    scene.insert_primitive(colored_quad_at(0.0, 0.0, hsla(0.8, 0.6, 0.5, 1.0)));
    scene.insert_primitive(boundary(true));
    scene.insert_primitive(quad_at(10.0, 10.0));
    scene.insert_primitive(boundary(false));
    scene.insert_primitive(boundary(false));
    scene.finish();
    scene
}

fn path_scene() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(path());
    scene.insert_primitive(quad_at(0.0, 200.0));
    scene.finish();
    scene
}

fn surface_scene() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(surface());
    scene.finish();
    scene
}

fn sprites_scene() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(mono_sprite());
    scene.insert_primitive(subpixel_sprite());
    scene.insert_primitive(poly_sprite());
    scene.finish();
    scene
}

struct SceneCase {
    name: &'static str,
    build: fn() -> Scene,
    requires_offscreen: bool,
}

fn scene_cases() -> Vec<SceneCase> {
    vec![
        SceneCase {
            name: "empty_scene",
            build: empty_scene,
            requires_offscreen: false,
        },
        SceneCase {
            name: "single_quad",
            build: single_quad,
            requires_offscreen: false,
        },
        SceneCase {
            name: "quad_grid_sort",
            build: quad_grid_sort,
            requires_offscreen: false,
        },
        SceneCase {
            name: "mixed_quad_underline_batches",
            build: mixed_batches,
            requires_offscreen: false,
        },
        SceneCase {
            name: "nested_layers",
            build: nested_layers,
            requires_offscreen: false,
        },
        SceneCase {
            name: "backdrop_filter_offscreen",
            build: backdrop_filter_scene,
            requires_offscreen: true,
        },
        SceneCase {
            name: "content_filter_begin_end",
            build: content_filter_scene,
            requires_offscreen: true,
        },
        SceneCase {
            name: "path_surrogate",
            build: path_scene,
            requires_offscreen: false,
        },
        SceneCase {
            name: "surface_size_surrogate",
            build: surface_scene,
            requires_offscreen: false,
        },
        SceneCase {
            name: "sprite_pipelines",
            build: sprites_scene,
            requires_offscreen: false,
        },
    ]
}

#[test]
fn scene_archives_match_snapshots() {
    for case in scene_cases() {
        let scene = (case.build)();
        assert_eq!(
            scene.requires_offscreen_rendering(),
            case.requires_offscreen,
            "{}: offscreen-rendering requirement changed",
            case.name
        );
        let archive = SceneArchive::from_scene(&scene);
        insta::assert_snapshot!(case.name, archive.to_canonical_json());
    }
}
