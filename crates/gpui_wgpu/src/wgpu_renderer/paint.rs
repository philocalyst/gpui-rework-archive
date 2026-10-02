//! Inline, device-owned pipelines and amortized uniform uploads for composed paints.
use collections::FxHashMap;
use gpui::{Scene, ShaderProgramKey, ShaderShape};
use std::{num::NonZeroU64, ops::Range, sync::OnceLock};

const CACHE_LIMIT: usize = 128;
const DRAW_BYTES: u64 = 128;

struct Program {
    pipeline: wgpu::RenderPipeline,
    layout: wgpu::BindGroupLayout,
    group: Option<wgpu::BindGroup>,
    parameter_bytes: u64,
    backdrop_view: Option<wgpu::TextureView>,
    backdrop_sampler: Option<wgpu::Sampler>,
    uses_backdrop: bool,
    last_used: u64,
}

#[derive(Debug)]
pub(super) enum PaintError {
    InvalidShader(String),
    UniformCapacity,
    InvalidGeometry,
}

pub(super) struct PaintResources {
    programs: FxHashMap<ShaderProgramKey, Program>,
    buffer: wgpu::Buffer,
    capacity: u64,
    offsets: Vec<(u32, u32)>,
    staging: Vec<u8>,
    scissors: Vec<ScissorSet>,
    viewport: [u32; 2],
    frame: u64,
    #[cfg(feature = "test-support")]
    pipeline_compilations: u64,
}

impl PaintResources {
    pub(super) fn new(device: &wgpu::Device) -> Self {
        Self {
            programs: FxHashMap::default(),
            buffer: buffer(device, 256),
            capacity: 256,
            offsets: Vec::new(),
            staging: Vec::new(),
            scissors: Vec::new(),
            viewport: [0; 2],
            frame: 0,
            #[cfg(feature = "test-support")]
            pipeline_compilations: 0,
        }
    }

    #[cfg(feature = "test-support")]
    pub(super) fn diagnostics(&self) -> (usize, u64, u64) {
        (
            self.programs.len(),
            self.pipeline_compilations,
            self.capacity,
        )
    }

    pub(super) fn is_visible(&self, index: usize) -> bool {
        !self.scissors[index].is_empty()
    }

    pub(super) fn scissor_bounds(&self, index: usize) -> Option<[u32; 4]> {
        self.scissors[index].bounds()
    }

    pub(super) fn invalidate(&mut self) {
        self.programs.clear();
    }

    pub(super) fn invalidate_backdrop_views(&mut self) {
        for program in self.programs.values_mut() {
            if program.uses_backdrop {
                program.group = None;
                program.backdrop_view = None;
                program.backdrop_sampler = None;
            }
        }
    }

    pub(super) fn prepare(
        &mut self,
        device: &wgpu::Device,
        queue: &wgpu::Queue,
        globals: &wgpu::BindGroupLayout,
        scene: &Scene,
        viewport: [f32; 2],
        format: wgpu::TextureFormat,
        alpha: wgpu::CompositeAlphaMode,
        backdrop_view: Option<&wgpu::TextureView>,
        backdrop_sampler: &wgpu::Sampler,
    ) -> Result<(), PaintError> {
        self.frame = self.frame.wrapping_add(1);
        self.offsets.clear();
        self.staging.clear();
        self.scissors.clear();
        self.viewport = [viewport[0] as u32, viewport[1] as u32];
        if let Some(backdrop_view) = backdrop_view {
            self.refresh_backdrop_groups(device, backdrop_view, backdrop_sampler);
        }
        let alignment = u64::from(device.limits().min_uniform_buffer_offset_alignment);
        for quad in &scene.shaders {
            let geometry = [
                quad.bounds.origin.x.0,
                quad.bounds.origin.y.0,
                quad.bounds.size.width.0,
                quad.bounds.size.height.0,
                quad.content_mask.bounds.origin.x.0,
                quad.content_mask.bounds.origin.y.0,
                quad.content_mask.bounds.size.width.0,
                quad.content_mask.bounds.size.height.0,
                quad.opacity,
                quad.scale_factor,
            ];
            if geometry.iter().any(|value| !value.is_finite())
                || quad.scale_factor <= 0.
                || !(0. ..=1.).contains(&quad.opacity)
            {
                return Err(PaintError::InvalidGeometry);
            }
            if let Some((_, canonical)) = quad.geometry {
                let canonical = [
                    canonical.bounds.origin.x.0,
                    canonical.bounds.origin.y.0,
                    canonical.bounds.size.width.0,
                    canonical.bounds.size.height.0,
                    canonical.corner_smoothing,
                    canonical.border_dashed_length,
                    canonical.border_dashed_gap,
                    canonical.border_widths.top.0,
                    canonical.border_widths.right.0,
                    canonical.border_widths.bottom.0,
                    canonical.border_widths.left.0,
                    canonical.corner_radii.top_left.0,
                    canonical.corner_radii.top_right.0,
                    canonical.corner_radii.bottom_right.0,
                    canonical.corner_radii.bottom_left.0,
                ];
                if canonical.iter().any(|value| !value.is_finite())
                    || canonical[2] <= 0.
                    || canonical[3] <= 0.
                {
                    return Err(PaintError::InvalidGeometry);
                }
            }
            let raster_bounds = [
                quad.bounds.origin.x.0,
                quad.bounds.origin.y.0,
                quad.bounds.size.width.0,
                quad.bounds.size.height.0,
            ];
            let clip_bounds = [
                quad.content_mask.bounds.origin.x.0,
                quad.content_mask.bounds.origin.y.0,
                quad.content_mask.bounds.size.width.0,
                quad.content_mask.bounds.size.height.0,
            ];
            let scissors = match quad.geometry {
                Some((ShaderShape::Border, geometry)) => border_scissors(
                    raster_bounds,
                    [
                        geometry.bounds.origin.x.0,
                        geometry.bounds.origin.y.0,
                        geometry.bounds.size.width.0,
                        geometry.bounds.size.height.0,
                    ],
                    [
                        geometry.border_widths.top.0,
                        geometry.border_widths.right.0,
                        geometry.border_widths.bottom.0,
                        geometry.border_widths.left.0,
                    ],
                    [
                        geometry.corner_radii.top_left.0,
                        geometry.corner_radii.top_right.0,
                        geometry.corner_radii.bottom_right.0,
                        geometry.corner_radii.bottom_left.0,
                    ],
                    geometry.corner_smoothing,
                    clip_bounds,
                    viewport,
                ),
                _ => ScissorSet::single(scissor(raster_bounds, clip_bounds, viewport)),
            };
            self.scissors.push(scissors);
            if self.scissors.last().is_some_and(ScissorSet::is_empty) {
                self.offsets.push((0, 0));
                continue;
            }
            let parameters = quad.shader.parameter_slots();
            let parameter_bytes = (parameters.len().max(1) as u64) * 16;
            if parameter_bytes > device.limits().max_uniform_buffer_binding_size {
                return Err(PaintError::UniformCapacity);
            }
            let draw_offset = (self.staging.len() as u64).next_multiple_of(alignment);
            let parameter_offset = (draw_offset + DRAW_BYTES).next_multiple_of(alignment);
            let end = parameter_offset
                .checked_add(parameter_bytes)
                .ok_or(PaintError::UniformCapacity)?;
            if end > device.limits().max_buffer_size.min(u64::from(u32::MAX)) {
                return Err(PaintError::UniformCapacity);
            }
            self.staging.resize(end as usize, 0);
            self.offsets
                .push((draw_offset as u32, parameter_offset as u32));
            let bounds = &quad.bounds;
            let clip = &quad.content_mask.bounds;
            let draw_bytes = &mut self.staging[draw_offset as usize..];
            let values = [
                bounds.origin.x.0,
                bounds.origin.y.0,
                bounds.size.width.0,
                bounds.size.height.0,
                clip.origin.x.0,
                clip.origin.y.0,
                clip.origin.x.0 + clip.size.width.0,
                clip.origin.y.0 + clip.size.height.0,
                viewport[0],
                viewport[1],
                quad.opacity,
                quad.scale_factor,
            ];
            write_floats(draw_bytes, &values);
            let (shape, canonical) = quad.geometry.map_or((0, None), |(shape, canonical)| {
                (
                    match shape {
                        ShaderShape::Background => 1,
                        ShaderShape::Border => 2,
                    },
                    Some(canonical),
                )
            });
            let shape_bounds = canonical.map_or([0.; 4], |geometry| {
                [
                    geometry.bounds.origin.x.0,
                    geometry.bounds.origin.y.0,
                    geometry.bounds.size.width.0,
                    geometry.bounds.size.height.0,
                ]
            });
            let corner_radii = canonical.map_or([0.; 4], |geometry| {
                [
                    geometry.corner_radii.top_left.0,
                    geometry.corner_radii.top_right.0,
                    geometry.corner_radii.bottom_right.0,
                    geometry.corner_radii.bottom_left.0,
                ]
            });
            let border_widths = canonical.map_or([0.; 4], |geometry| {
                [
                    geometry.border_widths.top.0,
                    geometry.border_widths.right.0,
                    geometry.border_widths.bottom.0,
                    geometry.border_widths.left.0,
                ]
            });
            let border_parameters = canonical.map_or([0.; 4], |geometry| {
                [
                    geometry.border_dashed_length,
                    geometry.border_dashed_gap,
                    geometry.corner_smoothing,
                    0.,
                ]
            });
            let border_style = canonical.map_or(0, |geometry| geometry.border_style as u32);
            write_u32s(&mut draw_bytes[48..], &[shape, border_style, 0, 0]);
            write_floats(&mut draw_bytes[64..], &shape_bounds);
            write_floats(&mut draw_bytes[80..], &corner_radii);
            write_floats(&mut draw_bytes[96..], &border_widths);
            write_floats(&mut draw_bytes[112..], &border_parameters);
            for (ix, slot) in parameters.iter().enumerate() {
                write_floats(
                    &mut self.staging[parameter_offset as usize + ix * 16..],
                    slot,
                );
            }
        }
        if self.staging.len() as u64 > self.capacity {
            self.capacity = (self.staging.len() as u64)
                .next_power_of_two()
                .min(device.limits().max_buffer_size.min(u64::from(u32::MAX)));
            self.buffer = buffer(device, self.capacity);
            for program in self.programs.values_mut() {
                program.group = Some(bind_group(
                    device,
                    &program.layout,
                    &self.buffer,
                    program.parameter_bytes,
                    program.backdrop_view.as_ref(),
                    program.backdrop_sampler.as_ref(),
                ));
            }
        }
        for (ix, quad) in scene.shaders.iter().enumerate() {
            if self.scissors[ix].is_empty() {
                continue;
            }
            let id = quad.shader.cache_key();
            if let Some(program) = self.programs.get_mut(&id) {
                program.last_used = self.frame;
                continue;
            }
            let parameter_bytes = quad.shader.parameter_slots().len().max(1) as u64 * 16;
            let uses_backdrop = quad.shader.uses_backdrop();
            let program_backdrop_view = if uses_backdrop {
                Some(
                    backdrop_view
                        .ok_or_else(|| {
                            PaintError::InvalidShader(
                                "backdrop paint has no prepared snapshot texture".into(),
                            )
                        })?
                        .clone(),
                )
            } else {
                None
            };
            let program_backdrop_sampler = uses_backdrop.then(|| backdrop_sampler.clone());
            let source = shader_source(
                quad.shader.wgsl(),
                quad.shader.is_premultiplied(),
                uses_backdrop,
                alpha == wgpu::CompositeAlphaMode::PreMultiplied,
            )?;
            validate(&source)?;
            let mut entries = vec![
                uniform_entry(0, DRAW_BYTES),
                uniform_entry(1, parameter_bytes),
            ];
            if uses_backdrop {
                entries.push(texture_entry(2));
                entries.push(sampler_entry(3));
            }
            let layout = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
                label: Some("paint uniforms and backdrop"),
                entries: &entries,
            });
            let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
                label: Some("paint pipeline layout"),
                bind_group_layouts: &[Some(globals), Some(&layout)],
                immediate_size: 0,
            });
            let module = device.create_shader_module(wgpu::ShaderModuleDescriptor {
                label: Some("composed paint"),
                source: wgpu::ShaderSource::Wgsl(source.into()),
            });
            let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
                label: Some("composed paint"),
                layout: Some(&pipeline_layout),
                vertex: wgpu::VertexState {
                    module: &module,
                    entry_point: Some("paint_vertex"),
                    buffers: &[],
                    compilation_options: Default::default(),
                },
                fragment: Some(wgpu::FragmentState {
                    module: &module,
                    entry_point: Some("paint_fragment"),
                    targets: &[Some(wgpu::ColorTargetState {
                        format,
                        blend: Some(super::pipelines::scene_blend_state(alpha)),
                        write_mask: wgpu::ColorWrites::ALL,
                    })],
                    compilation_options: Default::default(),
                }),
                primitive: Default::default(),
                depth_stencil: None,
                multisample: Default::default(),
                multiview_mask: None,
                cache: None,
            });
            let group = bind_group(
                device,
                &layout,
                &self.buffer,
                parameter_bytes,
                program_backdrop_view.as_ref(),
                program_backdrop_sampler.as_ref(),
            );
            #[cfg(feature = "test-support")]
            {
                self.pipeline_compilations += 1;
            }
            self.programs.insert(
                id,
                Program {
                    pipeline,
                    layout,
                    group: Some(group),
                    parameter_bytes,
                    backdrop_view: program_backdrop_view,
                    backdrop_sampler: program_backdrop_sampler,
                    uses_backdrop,
                    last_used: self.frame,
                },
            );
        }
        if self.programs.len() > CACHE_LIMIT {
            // A frame can use more than the cache budget. Collect once so shrinking that
            // working set on the next frame does not repeatedly scan the entire cache.
            let evictions = eviction_candidates(
                self.programs
                    .iter()
                    .map(|(id, program)| (*id, program.last_used)),
                self.programs.len(),
                self.frame,
                CACHE_LIMIT,
            );
            for id in evictions {
                self.programs.remove(&id);
            }
        }
        if !self.staging.is_empty() {
            queue.write_buffer(&self.buffer, 0, &self.staging);
        }
        Ok(())
    }

    pub(super) fn draw(&self, scene: &Scene, range: Range<usize>, pass: &mut wgpu::RenderPass<'_>) {
        for ix in range {
            if self.scissors[ix].is_empty() {
                continue;
            }
            let program = &self.programs[&scene.shaders[ix].shader.cache_key()];
            let (draw, parameters) = self.offsets[ix];
            pass.set_pipeline(&program.pipeline);
            pass.set_bind_group(
                1,
                program
                    .group
                    .as_ref()
                    .expect("paint bind group must be prepared before drawing"),
                &[draw, parameters],
            );
            for &[x, y, width, height] in self.scissors[ix].as_slice() {
                pass.set_scissor_rect(x, y, width, height);
                pass.draw(0..6, 0..1);
            }
        }
        pass.set_scissor_rect(0, 0, self.viewport[0], self.viewport[1]);
    }

    fn refresh_backdrop_groups(
        &mut self,
        device: &wgpu::Device,
        backdrop_view: &wgpu::TextureView,
        backdrop_sampler: &wgpu::Sampler,
    ) {
        for program in self.programs.values_mut() {
            if !program.uses_backdrop || program.group.is_some() {
                continue;
            }
            program.group = Some(bind_group(
                device,
                &program.layout,
                &self.buffer,
                program.parameter_bytes,
                Some(backdrop_view),
                Some(backdrop_sampler),
            ));
            program.backdrop_view = Some(backdrop_view.clone());
            program.backdrop_sampler = Some(backdrop_sampler.clone());
        }
    }
}

/// Keep every program needed by the current frame, then retain the most recently used
/// inactive programs up to the budget. The id makes equally old entries deterministic.
fn eviction_candidates(
    programs: impl Iterator<Item = (ShaderProgramKey, u64)>,
    count: usize,
    frame: u64,
    limit: usize,
) -> Vec<ShaderProgramKey> {
    let mut inactive: Vec<_> = programs
        .filter(|(_, last_used)| *last_used != frame)
        .collect();
    inactive.sort_unstable_by_key(|(id, last_used)| (*last_used, cache_order(*id)));
    inactive.truncate(count.saturating_sub(limit));
    inactive.into_iter().map(|(id, _)| id).collect()
}

/// Integer scissoring limits fragment work; the shader retains exact fractional clipping.
fn scissor(bounds: [f32; 4], clip: [f32; 4], viewport: [f32; 2]) -> Option<[u32; 4]> {
    if bounds[2] <= 0. || bounds[3] <= 0. || clip[2] <= 0. || clip[3] <= 0. {
        return None;
    }
    let left = bounds[0].max(clip[0]).max(0.);
    let top = bounds[1].max(clip[1]).max(0.);
    let right = (bounds[0] + bounds[2])
        .min(clip[0] + clip[2])
        .min(viewport[0]);
    let bottom = (bounds[1] + bounds[3])
        .min(clip[1] + clip[3])
        .min(viewport[1]);
    if right <= left || bottom <= top {
        return None;
    }
    let x = left.floor() as u32;
    let y = top.floor() as u32;
    Some([x, y, right.ceil() as u32 - x, bottom.ceil() as u32 - y])
}

/// A logical shader quad emits at most four disjoint border bands. Keeping the
/// small list inline avoids one heap allocation per shader quad per frame.
#[derive(Clone, Copy, Default)]
struct ScissorSet {
    rects: [[u32; 4]; 4],
    len: usize,
}

impl ScissorSet {
    fn single(rect: Option<[u32; 4]>) -> Self {
        let mut result = Self::default();
        if let Some(rect) = rect {
            result.push(rect);
        }
        result
    }

    fn push(&mut self, rect: [u32; 4]) {
        debug_assert!(self.len < self.rects.len());
        self.rects[self.len] = rect;
        self.len += 1;
    }

    fn is_empty(&self) -> bool {
        self.len == 0
    }

    fn as_slice(&self) -> &[[u32; 4]] {
        &self.rects[..self.len]
    }

    fn bounds(&self) -> Option<[u32; 4]> {
        let mut rects = self.as_slice().iter();
        let first = *rects.next()?;
        let [mut left, mut top, width, height] = first;
        let mut right = left + width;
        let mut bottom = top + height;
        for &[x, y, width, height] in rects {
            left = left.min(x);
            top = top.min(y);
            right = right.max(x + width);
            bottom = bottom.max(y + height);
        }
        Some([left, top, right - left, bottom - top])
    }
}

/// Restrict border fragments to four disjoint bands while preserving one logical quad draw.
/// Band extents include each rounded corner's prepared reach and the widest border's diagonal
/// reach. If bands would intersect, keep the single full scissor so coverage and capture ordering
/// remain straightforward.
fn border_scissors(
    raster_bounds: [f32; 4],
    geometry_bounds: [f32; 4],
    border_widths: [f32; 4],
    corner_radii: [f32; 4],
    corner_smoothing: f32,
    clip_bounds: [f32; 4],
    viewport: [f32; 2],
) -> ScissorSet {
    let Some(full) = scissor(raster_bounds, clip_bounds, viewport) else {
        return ScissorSet::default();
    };
    if raster_bounds
        .iter()
        .zip(geometry_bounds)
        .any(|(raster, geometry)| (raster - geometry).abs() > 0.001)
    {
        return ScissorSet::single(Some(full));
    }
    let maximum_border = border_widths.into_iter().fold(0.0_f32, f32::max);
    if maximum_border <= 0. {
        return ScissorSet::default();
    }

    let corner_reach =
        corner_radii.map(|radius| radius.max(0.0) * (1.0 + corner_smoothing.clamp(0.0, 1.0)));
    let border_reach = maximum_border * std::f32::consts::SQRT_2 + 1.0;
    let top_band = corner_reach[0].max(corner_reach[1]) + border_reach;
    let right_band = corner_reach[1].max(corner_reach[2]) + border_reach;
    let bottom_band = corner_reach[2].max(corner_reach[3]) + border_reach;
    let left_band = corner_reach[3].max(corner_reach[0]) + border_reach;

    let [x, y, width, height] = full;
    let right = x + width;
    let bottom = y + height;
    let top_end = (geometry_bounds[1] + top_band).ceil() as u32;
    let bottom_start = (geometry_bounds[1] + geometry_bounds[3] - bottom_band).floor() as u32;
    let left_end = (geometry_bounds[0] + left_band).ceil() as u32;
    let right_start = (geometry_bounds[0] + geometry_bounds[2] - right_band).floor() as u32;
    let top_end = top_end.clamp(y, bottom);
    let bottom_start = bottom_start.clamp(y, bottom);
    let left_end = left_end.clamp(x, right);
    let right_start = right_start.clamp(x, right);
    if top_end >= bottom_start || left_end >= right_start {
        return ScissorSet::single(Some(full));
    }

    let mut scissors = ScissorSet::default();
    if top_end > y {
        scissors.push([x, y, width, top_end - y]);
    }
    if bottom > bottom_start {
        scissors.push([x, bottom_start, width, bottom - bottom_start]);
    }
    let middle_height = bottom_start - top_end;
    if middle_height > 0 {
        if left_end > x {
            scissors.push([x, top_end, left_end - x, middle_height]);
        }
        if right > right_start {
            scissors.push([right_start, top_end, right - right_start, middle_height]);
        }
    }
    if scissors.is_empty() {
        ScissorSet::single(Some(full))
    } else {
        scissors
    }
}

fn buffer(device: &wgpu::Device, size: u64) -> wgpu::Buffer {
    device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("paint uniform arena"),
        size,
        usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    })
}
fn uniform_entry(binding: u32, size: u64) -> wgpu::BindGroupLayoutEntry {
    wgpu::BindGroupLayoutEntry {
        binding,
        visibility: wgpu::ShaderStages::VERTEX_FRAGMENT,
        ty: wgpu::BindingType::Buffer {
            ty: wgpu::BufferBindingType::Uniform,
            has_dynamic_offset: true,
            min_binding_size: NonZeroU64::new(size),
        },
        count: None,
    }
}
fn texture_entry(binding: u32) -> wgpu::BindGroupLayoutEntry {
    wgpu::BindGroupLayoutEntry {
        binding,
        visibility: wgpu::ShaderStages::FRAGMENT,
        ty: wgpu::BindingType::Texture {
            sample_type: wgpu::TextureSampleType::Float { filterable: true },
            view_dimension: wgpu::TextureViewDimension::D2,
            multisampled: false,
        },
        count: None,
    }
}
fn sampler_entry(binding: u32) -> wgpu::BindGroupLayoutEntry {
    wgpu::BindGroupLayoutEntry {
        binding,
        visibility: wgpu::ShaderStages::FRAGMENT,
        ty: wgpu::BindingType::Sampler(wgpu::SamplerBindingType::Filtering),
        count: None,
    }
}
fn bind_group(
    device: &wgpu::Device,
    layout: &wgpu::BindGroupLayout,
    buffer: &wgpu::Buffer,
    parameter_bytes: u64,
    backdrop_view: Option<&wgpu::TextureView>,
    backdrop_sampler: Option<&wgpu::Sampler>,
) -> wgpu::BindGroup {
    let mut entries = vec![
        wgpu::BindGroupEntry {
            binding: 0,
            resource: wgpu::BindingResource::Buffer(wgpu::BufferBinding {
                buffer,
                offset: 0,
                size: NonZeroU64::new(DRAW_BYTES),
            }),
        },
        wgpu::BindGroupEntry {
            binding: 1,
            resource: wgpu::BindingResource::Buffer(wgpu::BufferBinding {
                buffer,
                offset: 0,
                size: NonZeroU64::new(parameter_bytes),
            }),
        },
    ];
    if let (Some(view), Some(sampler)) = (backdrop_view, backdrop_sampler) {
        entries.push(wgpu::BindGroupEntry {
            binding: 2,
            resource: wgpu::BindingResource::TextureView(view),
        });
        entries.push(wgpu::BindGroupEntry {
            binding: 3,
            resource: wgpu::BindingResource::Sampler(sampler),
        });
    }
    device.create_bind_group(&wgpu::BindGroupDescriptor {
        label: Some("paint uniforms and backdrop"),
        layout,
        entries: &entries,
    })
}
fn write_floats(destination: &mut [u8], values: &[f32]) {
    for (bytes, value) in destination.chunks_exact_mut(4).zip(values) {
        bytes.copy_from_slice(&value.to_le_bytes());
    }
}
fn write_u32s(destination: &mut [u8], values: &[u32]) {
    for (bytes, value) in destination.chunks_exact_mut(4).zip(values) {
        bytes.copy_from_slice(&value.to_le_bytes());
    }
}
fn cache_order(key: ShaderProgramKey) -> (u8, u64) {
    match key {
        ShaderProgramKey::Legacy(id) => (0, id),
        ShaderProgramKey::Paint(id) => (1, id),
    }
}
fn validate(source: &str) -> Result<(), PaintError> {
    let module = naga::front::wgsl::parse_str(source)
        .map_err(|e| PaintError::InvalidShader(e.emit_to_string(source)))?;
    naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::empty(),
    )
    .validate(&module)
    .map_err(|e| PaintError::InvalidShader(format!("{e:?}")))?;
    Ok(())
}
fn shader_source(
    graph: &str,
    shader_premultiplied: bool,
    uses_backdrop: bool,
    target_premultiplied: bool,
) -> Result<String, PaintError> {
    let generated_quads = canonical_quad_helpers()?;
    let backdrop = if uses_backdrop {
        r#"
@group(1) @binding(2) var gpui_backdrop_texture: texture_2d<f32>;
@group(1) @binding(3) var gpui_backdrop_sampler: sampler;
fn gpui_sample_backdrop(uv: vec2<f32>) -> vec4<f32> {
    var domain = paint_draw.raster_bounds;
    if paint_draw.shape_flags.x != 0u {
        domain = paint_draw.shape_bounds;
    }
    let point = domain.xy + uv * domain.zw;
    let sample_uv = clamp(point / paint_draw.viewport_opacity_scale.xy, vec2<f32>(0.0), vec2<f32>(1.0));
    return textureSample(gpui_backdrop_texture, gpui_backdrop_sampler, sample_uv);
}
"#
    } else {
        ""
    };
    let shader_premultiplied = u32::from(shader_premultiplied);
    let target_premultiplied = u32::from(target_premultiplied);
    Ok(format!(
        r#"
{generated_quads}
{graph}
struct PaintDraw {{
    raster_bounds: vec4<f32>,
    clip: vec4<f32>,
    viewport_opacity_scale: vec4<f32>,
    shape_flags: vec4<u32>,
    shape_bounds: vec4<f32>,
    shape_corner_radii: vec4<f32>,
    shape_border_widths: vec4<f32>,
    shape_border_parameters: vec4<f32>,
}};
@group(1) @binding(0) var<uniform> paint_draw: PaintDraw;
{backdrop}
fn paint_shape_quad() -> Quad {{
    let transparent = Hsla(0.0, 0.0, 0.0, 0.0);
    let empty_stop = LinearColorStop(transparent, 0.0);
    let empty_background = Background(
        BackgroundTag_Solid,
        ColorSpace_Srgb,
        transparent,
        0.0,
        array<LinearColorStop, 2>(empty_stop, empty_stop),
        0u,
    );
    return Quad(
        0u,
        paint_draw.shape_flags.y,
        paint_draw.shape_border_parameters.x,
        paint_draw.shape_border_parameters.y,
        Bounds(paint_draw.shape_bounds.xy, paint_draw.shape_bounds.zw),
        Bounds(paint_draw.shape_bounds.xy, paint_draw.shape_bounds.zw),
        empty_background,
        empty_background,
        Corners(
            paint_draw.shape_corner_radii.x,
            paint_draw.shape_corner_radii.y,
            paint_draw.shape_corner_radii.z,
            paint_draw.shape_corner_radii.w,
        ),
        Edges(
            paint_draw.shape_border_widths.x,
            paint_draw.shape_border_widths.y,
            paint_draw.shape_border_widths.z,
            paint_draw.shape_border_widths.w,
        ),
        paint_draw.shape_border_parameters.z,
        0u,
    );
}}
struct PaintVertex {{
    @builtin(position) position: vec4<f32>,
    @location(0) @interpolate(flat) horizontal_reaches: vec4<f32>,
    @location(1) @interpolate(flat) vertical_reaches: vec4<f32>,
    @location(2) @interpolate(flat) smoothing_factors: vec4<f32>,
    @location(3) @interpolate(flat) superellipse_power: f32,
    @location(4) @interpolate(flat) corner_lengths: vec4<f32>,
}};
@vertex fn paint_vertex(@builtin(vertex_index) index: u32) -> PaintVertex {{
    let corners = array<vec2<f32>, 6>(vec2<f32>(0.0,0.0), vec2<f32>(1.0,0.0), vec2<f32>(0.0,1.0), vec2<f32>(0.0,1.0), vec2<f32>(1.0,0.0), vec2<f32>(1.0,1.0));
    let point = paint_draw.raster_bounds.xy + corners[index] * paint_draw.raster_bounds.zw;
    let ndc = point / paint_draw.viewport_opacity_scale.xy * 2.0 - 1.0;
    let quad = paint_shape_quad();
    let allow_superellipse = quad.border_style == BorderStyle_Solid
        && quad.border_widths.top == 0.0
        && quad.border_widths.right == 0.0
        && quad.border_widths.bottom == 0.0
        && quad.border_widths.left == 0.0;
    let prepared = prepare_corners(quad.bounds.size, quad.corner_radii, quad.corner_smoothing, allow_superellipse);
    let corner_lengths = smoothed_corner_lengths(quad, prepared);
    return PaintVertex(
        vec4<f32>(ndc.x, -ndc.y, 0.0, 1.0),
        prepared.horizontal_reaches,
        prepared.vertical_reaches,
        prepared.smoothing_factors,
        prepared.superellipse_power,
        corner_lengths,
    );
}}
@fragment fn paint_fragment(vertex: PaintVertex) -> @location(0) vec4<f32> {{
    let point = vertex.position.xy;
    var domain = paint_draw.raster_bounds;
    if paint_draw.shape_flags.x != 0u {{
        domain = paint_draw.shape_bounds;
    }}
    let size = domain.zw / paint_draw.viewport_opacity_scale.w;
    let local_uv = (point - domain.xy) / domain.zw;
    let raw = gpui_paint_fragment(local_uv, local_uv * size, size);
    let prepared = PreparedCorners(
        vertex.horizontal_reaches,
        vertex.vertical_reaches,
        vertex.smoothing_factors,
        vertex.superellipse_power,
    );
    let coverage = shader_shape_coverage(
        paint_shape_quad(),
        point,
        paint_draw.shape_flags.x,
        prepared,
        vertex.corner_lengths,
    );
    if any(point < paint_draw.clip.xy) || any(point > paint_draw.clip.zw) {{ discard; }}

    var straight_rgb = raw.rgb;
    if {shader_premultiplied}u != 0u {{
        if raw.a > 0.0 {{
            straight_rgb = raw.rgb / raw.a;
        }} else {{
            straight_rgb = vec3<f32>(0.0);
        }}
    }}
    let alpha = clamp(raw.a, 0.0, 1.0) * paint_draw.viewport_opacity_scale.z * coverage;
    if {target_premultiplied}u != 0u {{
        return vec4<f32>(straight_rgb * alpha, alpha);
    }}
    return vec4<f32>(straight_rgb, alpha);
}}
"#
    ))
}

/// Assemble, prune, and emit the canonical quad geometry helpers once for all paint pipelines.
/// wgsl-rs performs import and source-id deduplication; Naga's module IR then removes built-in
/// entry points and relocates their unused storage resource without source-text rewriting.
fn canonical_quad_helpers() -> Result<&'static str, PaintError> {
    static SOURCE: OnceLock<Result<String, String>> = OnceLock::new();
    SOURCE
        .get_or_init(|| {
            let source = gpui_render::shaders::quad::WGSL_SOURCE
                .wgsl_source()
                .map_err(|error| format!("could not assemble canonical quad WGSL: {error:?}"))?;
            let mut module = naga::front::wgsl::parse_str(&source)
                .map_err(|error| error.emit_to_string(&source))?;
            module.entry_points.clear();
            let mut found_quad_storage = false;
            for (_, variable) in module.global_variables.iter_mut() {
                if variable.name.as_deref() == Some("QUADS") {
                    variable.binding = Some(naga::ResourceBinding {
                        group: 2,
                        binding: 0,
                    });
                    found_quad_storage = true;
                }
            }
            if !found_quad_storage {
                return Err("canonical quad module has no QUADS storage declaration".into());
            }
            let info = naga::valid::Validator::new(
                naga::valid::ValidationFlags::all(),
                naga::valid::Capabilities::empty(),
            )
            .validate(&module)
            .map_err(|error| format!("pruned canonical quad WGSL is invalid: {error}"))?;
            naga::back::wgsl::write_string(&module, &info, naga::back::wgsl::WriterFlags::empty())
                .map_err(|error| format!("could not emit canonical quad helpers: {error}"))
        })
        .as_ref()
        .map(String::as_str)
        .map_err(|error| PaintError::InvalidShader(error.clone()))
}

impl std::fmt::Display for PaintError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::InvalidShader(message) => write!(f, "invalid composed paint shader: {message}"),
            Self::InvalidGeometry => {
                f.write_str("paint bounds, clipping, opacity, or scale are invalid")
            }
            Self::UniformCapacity => f.write_str("paint uniforms exceed device limits"),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    const GRAPH: &str = "struct GpuiPaintParameters { values: array<vec4<f32>, 1> }; @group(1) @binding(1) var<uniform> gpui_paint_parameters: GpuiPaintParameters; fn gpui_paint_fragment(uv: vec2<f32>, position: vec2<f32>, size: vec2<f32>) -> vec4<f32> { return gpui_paint_parameters.values[0]; }";
    #[test]
    fn validates_complete_pipeline_for_both_alpha_modes() {
        for premultiplied in [false, true] {
            let source = shader_source(GRAPH, false, false, premultiplied).unwrap();
            assert!(validate(&source).is_ok());
        }
    }
    #[test]
    fn derivatives_are_evaluated_before_nonuniform_clipping() {
        let graph = GRAPH.replace(
            "return gpui_paint_parameters.values[0];",
            "return vec4<f32>(fwidth(uv.x));",
        );
        let source = shader_source(&graph, false, false, true).unwrap();
        assert!(validate(&source).is_ok());
    }
    #[test]
    fn cache_eviction_preserves_active_programs_and_removes_oldest_first() {
        let programs = [
            (ShaderProgramKey::Legacy(4), 3),
            (ShaderProgramKey::Legacy(3), 1),
            (ShaderProgramKey::Paint(2), 1),
            (ShaderProgramKey::Legacy(1), 5),
            (ShaderProgramKey::Paint(0), 5),
        ];
        assert_eq!(
            eviction_candidates(programs.into_iter(), 5, 5, 3),
            vec![ShaderProgramKey::Legacy(3), ShaderProgramKey::Paint(2)]
        );
        // The active working set can exceed the budget and must remain drawable.
        assert_eq!(
            eviction_candidates(programs.into_iter(), 5, 5, 1),
            vec![
                ShaderProgramKey::Legacy(3),
                ShaderProgramKey::Paint(2),
                ShaderProgramKey::Legacy(4)
            ]
        );
    }

    #[test]
    fn scissors_round_outward_and_intersect_all_bounds() {
        assert_eq!(
            scissor([-2., -2., 10., 10.], [1.25, 2.75, 20., 20.], [6., 7.]),
            Some([1, 2, 5, 5])
        );
        assert_eq!(
            scissor([0., 0., 0., 1.], [0., 0., 10., 10.], [10., 10.]),
            None
        );
        assert_eq!(
            scissor([20., 0., 1., 1.], [0., 0., 10., 10.], [10., 10.]),
            None
        );
    }

    #[test]
    fn rounded_border_scissors_keep_corner_reaches_and_skip_the_interior() {
        let scissors = border_scissors(
            [0., 0., 120., 100.],
            [0., 0., 120., 100.],
            [2.; 4],
            [8., 10., 7., 6.],
            0.75,
            [0., 0., 128., 128.],
            [128., 128.],
        );
        assert_eq!(scissors.len, 4);
        let contains = |x: u32, y: u32| {
            scissors.as_slice().iter().any(|rect| {
                let [left, top, width, height] = *rect;
                x >= left && x < left + width && y >= top && y < top + height
            })
        };
        assert!(
            contains(3, 3),
            "the rounded corner reach must be rasterized"
        );
        assert!(
            !contains(60, 50),
            "the border interior should be scissored out"
        );
        for first in 0..scissors.len {
            for second in first + 1..scissors.len {
                let [ax, ay, aw, ah] = scissors.rects[first];
                let [bx, by, bw, bh] = scissors.rects[second];
                assert!(
                    ax + aw <= bx || bx + bw <= ax || ay + ah <= by || by + bh <= ay,
                    "border scissor bands must not overlap"
                );
            }
        }

        let intersecting = border_scissors(
            [0., 0., 120., 100.],
            [0., 0., 120., 100.],
            [2.; 4],
            [60.; 4],
            0.75,
            [0., 0., 128., 128.],
            [128., 128.],
        );
        assert_eq!(
            intersecting.len, 1,
            "intersecting bands fall back to full coverage"
        );
        assert!(contains_rect(intersecting.as_slice(), 60, 50));
    }

    fn contains_rect(rects: &[[u32; 4]], x: u32, y: u32) -> bool {
        rects.iter().any(|rect| {
            let [left, top, width, height] = *rect;
            x >= left && x < left + width && y >= top && y < top + height
        })
    }
    #[test]
    fn invalid_composition_is_an_error_before_gpu_creation() {
        assert!(matches!(
            validate(&shader_source("broken", false, false, false).unwrap()),
            Err(PaintError::InvalidShader(_))
        ));
    }
}
