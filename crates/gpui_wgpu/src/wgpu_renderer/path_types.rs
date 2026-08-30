use crate::shaders::interface::BufferData;
use gpui::{Background, Bounds, Path, ScaledPixels};

#[derive(Clone, Debug)]
#[repr(C)]
pub(super) struct PathSprite {
    pub(super) bounds: Bounds<ScaledPixels>,
}

#[derive(Clone, Debug)]
#[repr(C)]
pub(super) struct PathRasterizationVertex {
    pub(super) xy_position: gpui::Point<ScaledPixels>,
    pub(super) curve_position: gpui::Point<f32>,
    pub(super) color: Background,
    pub(super) bounds: Bounds<ScaledPixels>,
}

unsafe impl BufferData for PathSprite {
    const WGSL_TYPE: &'static str = "PathSprite";
}
unsafe impl BufferData for PathRasterizationVertex {
    const WGSL_TYPE: &'static str = "PathRasterizationVertex";
}

pub(super) const STORAGE_ABI: &[crate::shaders::interface::StorageAbi] = &[
    crate::shaders::interface::storage_abi::<PathSprite>(),
    crate::shaders::interface::storage_abi::<PathRasterizationVertex>(),
];

pub(super) fn rasterization_vertex_count(paths: &[Path<ScaledPixels>]) -> usize {
    paths.iter().map(|path| path.vertices.len()).sum()
}

pub(super) fn rasterization_vertices(
    paths: &[Path<ScaledPixels>],
) -> Vec<PathRasterizationVertex> {
    paths
        .iter()
        .flat_map(|path| {
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
        .collect()
}

pub(super) fn sprites(paths: &[Path<ScaledPixels>]) -> Vec<PathSprite> {
    let Some(first_path) = paths.first() else {
        return Vec::new();
    };
    if paths.last().is_some_and(|path| path.order == first_path.order) {
        return paths
            .iter()
            .map(|path| PathSprite {
                bounds: path.clipped_bounds(),
            })
            .collect();
    }

    let bounds = paths
        .iter()
        .skip(1)
        .fold(first_path.clipped_bounds(), |bounds, path| {
            bounds.union(&path.clipped_bounds())
        });
    vec![PathSprite { bounds }]
}

pub(super) fn sprite_count(paths: &[Path<ScaledPixels>]) -> usize {
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
