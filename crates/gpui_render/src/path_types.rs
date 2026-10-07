//! Host-side ABI for path primitives, shared by every renderer backend.
//!
//! Layouts must match the WGSL in `shaders::paths`; stride assertions here and the
//! Naga layout checks in `build.rs` enforce that.

use crate::shaders::interface::{BufferData, StorageAbi, storage_abi};
use gpui::{Background, Bounds, Path, ScaledPixels};

#[derive(Clone, Debug)]
#[repr(C)]
pub struct PathSprite {
    /// Bounds used to place the path sprite in the atlas or scene.
    pub bounds: Bounds<ScaledPixels>,
}

#[derive(Clone, Debug)]
#[repr(C)]
pub struct PathRasterizationVertex {
    /// Position of the vertex in scene coordinates.
    pub xy_position: gpui::Point<ScaledPixels>,
    /// Quadratic-curve coordinates consumed by the path shader.
    pub curve_position: gpui::Point<f32>,
    /// Fill paint for the path.
    pub color: Background,
    /// Clipped path bounds used for coverage evaluation.
    pub bounds: Bounds<ScaledPixels>,
}

unsafe impl BufferData for PathSprite {
    const WGSL_TYPE: &'static str = "PathSprite";
}
unsafe impl BufferData for PathRasterizationVertex {
    const WGSL_TYPE: &'static str = "PathRasterizationVertex";
}

/// Storage layouts for the path records, in upload order.
pub const STORAGE_ABI: &[StorageAbi] = &[
    storage_abi::<PathSprite>(),
    storage_abi::<PathRasterizationVertex>(),
];

/// Counts the vertices emitted by [`rasterization_vertices`].
pub fn rasterization_vertex_count(paths: &[Path<ScaledPixels>]) -> usize {
    paths.iter().map(|path| path.vertices.len()).sum()
}

/// Flattens paths into the vertex records expected by the path rasterization shader.
pub fn rasterization_vertices(
    paths: &[Path<ScaledPixels>],
) -> impl Iterator<Item = PathRasterizationVertex> + '_ {
    paths.iter().flat_map(|path| {
        let bounds = path.clipped_bounds();
        path.vertices
            .iter()
            .map(move |vertex| PathRasterizationVertex {
                xy_position: vertex.xy_position,
                curve_position: vertex.st_position,
                color: path.color,
                bounds,
            })
    })
}

/// Produces one sprite per path, or one combined sprite when path order changes.
pub fn sprites(paths: &[Path<ScaledPixels>]) -> PathSprites<'_> {
    let combined = paths.first().and_then(|first| {
        (paths.last().is_some_and(|path| path.order != first.order)).then(|| {
            paths
                .iter()
                .skip(1)
                .fold(first.clipped_bounds(), |bounds, path| {
                    bounds.union(&path.clipped_bounds())
                })
        })
    });
    PathSprites {
        paths: combined.is_none().then_some(paths.iter()),
        combined,
    }
}

/// Iterator over the sprite bounds emitted for a path batch.
pub struct PathSprites<'a> {
    paths: Option<std::slice::Iter<'a, Path<ScaledPixels>>>,
    combined: Option<Bounds<ScaledPixels>>,
}

impl Iterator for PathSprites<'_> {
    type Item = PathSprite;

    fn next(&mut self) -> Option<Self::Item> {
        if let Some(bounds) = self.combined.take() {
            return Some(PathSprite { bounds });
        }
        self.paths.as_mut()?.next().map(|path| PathSprite {
            bounds: path.clipped_bounds(),
        })
    }
}

/// Returns the number of sprites produced by [`sprites`].
pub fn sprite_count(paths: &[Path<ScaledPixels>]) -> usize {
    if paths.is_empty() {
        0
    } else if paths
        .last()
        .is_some_and(|path| path.order == paths[0].order)
    {
        paths.len()
    } else {
        1
    }
}

const _: () = {
    assert!(std::mem::size_of::<PathSprite>() == 16);
    assert!(std::mem::size_of::<PathRasterizationVertex>() == 104);
};
