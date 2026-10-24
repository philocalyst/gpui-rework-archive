//! Differential evidence against the immutable Main sixteen-site shader.
use super::*;
use gpui_canvas::{Affine, Canvas, Color, ColorConfig, OutputProfile, PaintColor, Rect, SlotEdit};

const ORACLE: &str = include_str!(concat!(
    env!("CARGO_MANIFEST_DIR"),
    "/../../evidence/certified-solid/main-integration/ui.wgsl"
));

struct Harness {
    renderer: Renderer,
    oracle: wgpu::RenderPipeline,
}
impl Harness {
    async fn new(format: wgpu::TextureFormat) -> Self {
        let mut desc = wgpu::InstanceDescriptor::new_without_display_handle();
        desc.backends = wgpu::Backends::VULKAN;
        let instance = wgpu::Instance::new(desc);
        let adapter = instance
            .request_adapter(&wgpu::RequestAdapterOptions {
                force_fallback_adapter: true,
                ..Default::default()
            })
            .await
            .unwrap();
        eprintln!("constant_samples adapter: {:?}", adapter.get_info());
        let renderer = Renderer::request(&adapter, format).await.unwrap();
        let context = &renderer.context;
        let module = context
            .device
            .create_shader_module(wgpu::ShaderModuleDescriptor {
                label: Some("immutable Main16 oracle"),
                source: wgpu::ShaderSource::Wgsl(Cow::Borrowed(ORACLE)),
            });
        let oracle = context
            .device
            .create_render_pipeline(&wgpu::RenderPipelineDescriptor {
                label: Some("immutable Main16 oracle"),
                layout: None,
                vertex: wgpu::VertexState {
                    module: &module,
                    entry_point: Some("vertex"),
                    compilation_options: Default::default(),
                    buffers: &[],
                },
                primitive: Default::default(),
                depth_stencil: None,
                multisample: Default::default(),
                fragment: Some(wgpu::FragmentState {
                    module: &module,
                    entry_point: Some("fragment"),
                    compilation_options: Default::default(),
                    targets: &[Some(wgpu::ColorTargetState {
                        format,
                        blend: None,
                        write_mask: wgpu::ColorWrites::ALL,
                    })],
                }),
                multiview_mask: None,
                cache: None,
            });
        Self { renderer, oracle }
    }
    fn target(&self, width: u32, height: u32) -> wgpu::Texture {
        self.renderer
            .device()
            .create_texture(&wgpu::TextureDescriptor {
                label: None,
                size: wgpu::Extent3d {
                    width,
                    height,
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format: self.renderer.format(),
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
                view_formats: &[],
            })
    }
    fn read(&self, texture: &wgpu::Texture) -> Vec<u8> {
        let width = texture.width();
        let height = texture.height();
        let bytes = self.renderer.format().block_copy_size(None).unwrap();
        let stride = (width * bytes).next_multiple_of(256);
        let device = self.renderer.device();
        let buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: None,
            size: u64::from(stride * height),
            usage: wgpu::BufferUsages::MAP_READ | wgpu::BufferUsages::COPY_DST,
            mapped_at_creation: false,
        });
        let mut encoder = device.create_command_encoder(&Default::default());
        encoder.copy_texture_to_buffer(
            wgpu::TexelCopyTextureInfo {
                texture,
                mip_level: 0,
                origin: wgpu::Origin3d::ZERO,
                aspect: wgpu::TextureAspect::All,
            },
            wgpu::TexelCopyBufferInfo {
                buffer: &buffer,
                layout: wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some(stride),
                    rows_per_image: Some(height),
                },
            },
            wgpu::Extent3d {
                width,
                height,
                depth_or_array_layers: 1,
            },
        );
        self.renderer.queue().submit([encoder.finish()]);
        let (send, receive) = std::sync::mpsc::channel();
        buffer.map_async(wgpu::MapMode::Read, .., move |r| send.send(r).unwrap());
        device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
        receive.recv().unwrap().unwrap();
        let mapped = buffer.get_mapped_range(..).unwrap();
        mapped
            .chunks_exact(stride as usize)
            .flat_map(|row| row[..(width * bytes) as usize].iter().copied())
            .collect()
    }
    fn submit_oracle(&mut self, texture: &wgpu::Texture) -> Vec<u8> {
        let context = &mut self.renderer.context;
        let state = &self.renderer.state;
        // The oracle knows only untagged CSR ends and the old uniform sentinel.
        let ranges: Vec<_> = state
            .ranges
            .iter()
            .map(|r| [r[0], r[1] & !CONSTANT_SAMPLES])
            .collect();
        context
            .queue
            .write_buffer(&state.tiles.handle, 0, bytemuck::cast_slice(&ranges));
        let bindings = context
            .device
            .create_bind_group(&wgpu::BindGroupDescriptor {
                label: Some("Main16 oracle bindings"),
                layout: &self.oracle.get_bind_group_layout(0),
                entries: &[
                    wgpu::BindGroupEntry {
                        binding: 0,
                        resource: state.globals.handle.as_entire_binding(),
                    },
                    wgpu::BindGroupEntry {
                        binding: 1,
                        resource: state.draws.binding(&state.records),
                    },
                    wgpu::BindGroupEntry {
                        binding: 2,
                        resource: state.tiles.binding(&state.ranges),
                    },
                    wgpu::BindGroupEntry {
                        binding: 3,
                        resource: state.indices.binding(&state.references),
                    },
                    wgpu::BindGroupEntry {
                        binding: 4,
                        resource: wgpu::BindingResource::TextureView(&state.atlas.view),
                    },
                    wgpu::BindGroupEntry {
                        binding: 5,
                        resource: state.corrections.binding(&state.residuals),
                    },
                ],
            });
        std::mem::swap(&mut context.pipeline, &mut self.oracle);
        context.submit(&texture.create_view(&Default::default()), &bindings);
        std::mem::swap(&mut context.pipeline, &mut self.oracle);
        context
            .queue
            .write_buffer(&state.tiles.handle, 0, bytemuck::cast_slice(&state.ranges));
        self.read(texture)
    }
    fn compare(&mut self, canvas: &Canvas) -> Vec<u8> {
        let target = self.target(canvas.width(), canvas.height());
        self.renderer
            .render(
                canvas.prepared_scene(),
                &target.create_view(&Default::default()),
            )
            .unwrap();
        let actual = self.read(&target);
        let reference = self.submit_oracle(&target);
        let mismatches: Vec<_> = actual
            .iter()
            .zip(&reference)
            .enumerate()
            .filter(|(_, (a, b))| a != b)
            .take(12)
            .collect();
        assert!(
            mismatches.is_empty(),
            "Main16 mismatch: {mismatches:?}; stats {:?}",
            self.renderer.stats()
        );
        actual
    }
    fn certified(&self) -> usize {
        self.renderer
            .state
            .ranges
            .iter()
            .filter(|r| r[1] & CONSTANT_SAMPLES != 0)
            .count()
    }
}

#[test]
fn uploaded_endpoints_require_exact_integer_lowered_geometry() {
    for correction in [0, SLOT_COLOR, LOWERED_SOLID, LOWERED_SOLID | SLOT_COLOR] {
        let eligible = correction & LOWERED_SOLID != 0;
        assert_eq!(
            constant_samples(correction, Rect::new(0., 1., 8., 7.), 16, 16),
            eligible
        );
        for edge in [
            8_f32.next_down(),
            8_f32.next_up(),
            8.25,
            8.5,
            8.75,
            f32::INFINITY,
            f32::NAN,
        ] {
            assert!(!constant_samples(
                correction,
                Rect::new(0., 0., edge, 8.),
                16,
                16
            ));
        }
        assert!(!constant_samples(
            correction,
            Rect::new(-1., 0., 8., 8.),
            16,
            16
        ));
        assert!(!constant_samples(
            correction,
            Rect::new(0., 0., 17., 8.),
            16,
            16
        ));
    }
}

#[test]
fn constant_sample_histories_match_immutable_main16_bits() {
    pollster::block_on(async {
        let mut cases = 0;
        for hdr in [false, true] {
            let mut h = Harness::new(if hdr {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            })
            .await;
            for profile in [OutputProfile::Srgb, OutputProfile::DisplayP3] {
                let config = if hdr {
                    ColorConfig::linear_hdr(profile, 203.).unwrap()
                } else {
                    ColorConfig {
                        profile,
                        ..Default::default()
                    }
                };
                for banked in [false, true] {
                    for grouped in [false, true] {
                        h.renderer.set_grouped_records(grouped);
                        for paint in [
                            Color::linear_srgb(-0., 0., 2., 0.75).unwrap(),
                            Color::linear_srgb(-1e-40, 1e-40, -0.5, 0.75).unwrap(),
                            Color::linear_srgb(-0., -1e-40, 2., 1.).unwrap(),
                            Color::linear_srgb(-4., 16., 0.125, 0.5).unwrap(),
                            Color::linear_display_p3(4., -0.5, 2., 0.25).unwrap(),
                        ] {
                            for edge in [
                                8_f32.next_down(),
                                8.,
                                8_f32.next_up(),
                                8.125_f32.next_down(),
                                8.125,
                                8.125_f32.next_up(),
                                8.25,
                            ] {
                                let mut canvas = Canvas::recording(35, 19, config).unwrap();
                                canvas.clear(
                                    Color::linear_srgb(
                                        -0.,
                                        -1e-40,
                                        0.25,
                                        if hdr { 0.5 } else { 1. },
                                    )
                                    .unwrap(),
                                );
                                let clip = Rect::new(0., 0., 35., 19.);
                                let slot = banked
                                    .then(|| canvas.paint_slot(PaintColor::new(paint)).unwrap());
                                for (rect, transform, clip) in [
                                    (Rect::new(1., 1., edge, 16.), Affine::IDENTITY, clip),
                                    (
                                        Rect::new(0., 0., 12., 12.),
                                        Affine {
                                            a: -1.,
                                            d: -1.,
                                            tx: 31.,
                                            ty: 17.,
                                            ..Affine::IDENTITY
                                        },
                                        Rect::new(20., 5., 10., 11.),
                                    ),
                                    (Rect::new(16., 0., 19., 19.), Affine::IDENTITY, clip),
                                ] {
                                    if let Some(slot) = slot {
                                        canvas.fill_rect_slot(rect, transform, clip, slot).unwrap();
                                    } else {
                                        canvas.fill_rect(rect, transform, clip, paint).unwrap();
                                    }
                                }
                                let actual = h.compare(&canvas);
                                assert_eq!(h.certified() > 0, !hdr);
                                let fast = h.renderer.stats();
                                h.renderer.set_tile_proofs(false);
                                assert_eq!(
                                    actual,
                                    h.compare(&canvas),
                                    "opaque cutoff changed bits"
                                );
                                assert_eq!(h.certified(), 0);
                                if hdr {
                                    assert_eq!(
                                        fast.sample_draw_evaluations,
                                        h.renderer.stats().sample_draw_evaluations
                                    );
                                } else {
                                    assert!(
                                        fast.sample_draw_evaluations
                                            < h.renderer.stats().sample_draw_evaluations
                                    );
                                }
                                h.renderer.set_tile_proofs(true);
                                cases += 1;
                            }
                        }
                    }
                }
            }
        }
        eprintln!("constant_samples immutable Main16 corpus: {cases} scenes, exact target bytes");
    });
}

#[test]
fn certificate_resets_only_after_cutoff_and_clears_after_overlay_retry() {
    pollster::block_on(async {
        let mut h = Harness::new(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let config = ColorConfig::default();
        let mut canvas = Canvas::recording(16, 16, config).unwrap();
        canvas.clear(Color::WHITE);
        let clip = Rect::new(0., 0., 16., 16.);
        canvas
            .fill_rect(
                Rect::new(0., 0., 8.25, 16.),
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
        h.compare(&canvas);
        assert_eq!(h.certified(), 0);
        for color in [Color::rgb(12, 34, 56), Color::rgb(56, 34, 12)] {
            canvas
                .fill_rect(Rect::new(-1., -1., 18., 18.), Affine::IDENTITY, clip, color)
                .unwrap();
        }
        canvas
            .fill_rect(
                Rect::new(2., 2., 8., 8.),
                Affine::IDENTITY,
                clip,
                Color::rgba(97, 43, 17, 127),
            )
            .unwrap();
        let expected = h.compare(&canvas);
        assert_eq!(
            h.certified(),
            1,
            "hidden fractional predecessor must not poison certificate"
        );
        assert_eq!(h.renderer.state.cursors[0], 3);
        assert_eq!(h.renderer.state.references.len(), 2);
        let target = h.target(16, 16);
        let view = target.create_view(&Default::default());
        h.renderer.redraw(&view).unwrap().unwrap();
        assert_eq!(h.read(&target), expected);
        let mut bad = canvas.prepared_scene();
        bad.clear[0] = f32::NAN;
        assert!(h.renderer.render(bad, &view).is_err());
        assert!(h.renderer.redraw(&view).unwrap().is_none());
        assert_eq!(expected, h.compare(&canvas));
        canvas
            .fill_rect(
                Rect::new(0., 0., 8.25, 16.),
                Affine::IDENTITY,
                clip,
                Color::rgba(255, 0, 0, 128),
            )
            .unwrap();
        h.compare(&canvas);
        assert_eq!(
            h.certified(),
            0,
            "a later fractional overlay must revoke the certificate"
        );
        assert_eq!(h.renderer.state.cursors[0], CONSTANT_SAMPLES | 3);
        // Deliberately emulate failing to clear after the overlay. The exact
        // Main16 oracle must detect the semantic failure, not just the flag.
        let correct = h.submit_oracle(&target);
        h.renderer.state.ranges[0][1] |= CONSTANT_SAMPLES;
        h.renderer.queue().write_buffer(
            &h.renderer.state.tiles.handle,
            0,
            bytemuck::cast_slice(&h.renderer.state.ranges),
        );
        h.renderer.redraw(&view).unwrap().unwrap();
        assert_ne!(
            h.read(&target),
            correct,
            "negative control must change pixels"
        );
    });
}

#[test]
fn geometry_certificate_survives_current_banked_paints_and_rejects_alpha_edits() {
    pollster::block_on(async {
        let mut h = Harness::new(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut canvas = Canvas::recording(
            16,
            16,
            ColorConfig {
                profile: OutputProfile::DisplayP3,
                ..Default::default()
            },
        )
        .unwrap();
        canvas.clear(Color::WHITE);
        let clip = Rect::new(0., 0., 16., 16.);
        let slot = canvas
            .paint_slot(PaintColor::new(
                Color::linear_srgb(1., 0., 2., 0.75).unwrap(),
            ))
            .unwrap();
        canvas
            .fill_rect_slot(Rect::new(1., 1., 14., 14.), Affine::IDENTITY, clip, slot)
            .unwrap();
        h.compare(&canvas);
        assert_eq!(h.certified(), 1);
        let target = h.target(16, 16);
        let view = target.create_view(&Default::default());
        for paint in [
            Color::linear_srgb(-0., -1e-40, -2., 0.75).unwrap(),
            Color::linear_display_p3(4., -1., 0., 0.75).unwrap(),
        ] {
            let edits = [SlotEdit::new(slot, PaintColor::new(paint))];
            canvas.prepare_slots(&edits).unwrap().commit();
            h.renderer.prepare_slots(&edits, &view).unwrap().commit();
            assert_eq!(h.certified(), 1);
            assert_eq!(h.read(&target), h.submit_oracle(&target));
            let patched = h.read(&target);
            assert_eq!(patched, h.compare(&canvas));
        }
        let edits = [SlotEdit::new(slot, PaintColor::new(Color::WHITE))];
        assert!(matches!(
            h.renderer.prepare_slots(&edits, &view),
            Err(SlotError::AlphaChanged { .. })
        ));
    });
}

#[test]
fn unsupported_geometry_and_output_domains_keep_sixteen_histories() {
    pollster::block_on(async {
        let mut h = Harness::new(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let clip = Rect::new(0., 0., 16., 16.);
        let mut canvas = Canvas::recording(16, 16, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        canvas
            .fill_rect(
                Rect::new(1., 1., 10., 10.),
                Affine::IDENTITY,
                clip,
                Color::rgba(31, 79, 143, 127),
            )
            .unwrap();
        h.compare(&canvas);
        assert_eq!(h.renderer.stats().sample_evaluations, 256);
        assert_eq!(h.renderer.stats().sample_draw_evaluations, 256);
        // Same geometry and paints; changing only output mapping declines.
        let mut scene = canvas.prepared_scene();
        scene.color_config.mapping = SdrMapping::ReinhardPerChannel { exposure: 1e10 };
        let target = h.target(16, 16);
        h.renderer
            .render(scene, &target.create_view(&Default::default()))
            .unwrap();
        assert_eq!(h.certified(), 0);
        assert_eq!(h.renderer.stats().sample_draw_evaluations, 4096);
        assert_eq!(h.read(&target), h.submit_oracle(&target));
        canvas
            .fill_rounded_rect(
                Rect::new(1., 1., 10., 10.),
                2.,
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
        h.compare(&canvas);
        assert_eq!(h.certified(), 0);
        canvas.clear(Color::WHITE);
        let mut fonts = gpui_canvas::TextSystem::bundled().unwrap();
        let run = fonts.shape("x", 10., None).unwrap();
        canvas
            .draw_text(
                &mut fonts,
                &run,
                gpui_canvas::Point { x: 1., y: 1. },
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
        h.compare(&canvas);
        assert_eq!(h.certified(), 0);
        canvas.clear(Color::WHITE);
        canvas
            .fill_rect(
                Rect::new(1., 1., 10., 10.),
                Affine {
                    c: 0.125,
                    ..Affine::IDENTITY
                },
                clip,
                Color::BLACK,
            )
            .unwrap();
        h.compare(&canvas);
        assert_eq!(h.certified(), 0);
    });
}
