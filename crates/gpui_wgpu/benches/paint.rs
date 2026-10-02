use criterion::{BenchmarkId, Criterion, black_box, criterion_group, criterion_main};
use gpui::{
    Bounds, ContentMask, Corners, DevicePixels, Edges, PlatformHeadlessRenderer, Point, Quad,
    ScaledPixels, Scene, ShaderProgram, ShaderQuad, ShaderShape, Size,
    paint::{PaintRoot, Shader},
    shader::{Paint, backdrop, color, shader as production_shader},
    solid_background,
};
use gpui_ce_wgpu::WgpuHeadlessRenderer;
fn shader() -> Shader {
    PaintRoot::new()
        .shader(|cx| cx.rgba(cx.uv().x(), cx.uv().y(), cx.scalar(0.5), cx.scalar(1.)))
        .unwrap()
}
fn scene(count: usize, paint: Option<&Shader>, unique: bool) -> Scene {
    let mut scene = Scene::default();
    for i in 0..count {
        let b = Bounds {
            origin: Point {
                x: ScaledPixels((i % 32) as f32 * 8.),
                y: ScaledPixels((i / 32) as f32 * 8.),
            },
            size: Size {
                width: ScaledPixels(8.),
                height: ScaledPixels(8.),
            },
        };
        let mask = ContentMask { bounds: b };
        if let Some(paint) = paint {
            scene.insert_primitive(ShaderQuad {
                order: 0,
                bounds: b,
                content_mask: mask,
                shader: ShaderProgram::Legacy(if unique { shader() } else { paint.clone() }),
                opacity: 1.,
                scale_factor: 1.,
                geometry: None,
            });
        } else {
            scene.insert_primitive(Quad {
                bounds: b,
                content_mask: mask,
                background: solid_background(gpui::rgb(0x336699)),
                ..Default::default()
            });
        }
    }
    scene.finish();
    scene
}
fn benchmark(c: &mut Criterion) {
    c.bench_function("paint_graph/cold", |b| b.iter(|| black_box(shader())));
    let root = PaintRoot::new();
    let retained = root.shader(|cx| cx.vec4([0.2, 0.4, 0.6, 1.])).unwrap();
    c.bench_function("paint_graph/rebuild_interned", |b| {
        b.iter(|| {
            let rebuilt = root.shader(|cx| cx.vec4([0.2, 0.4, 0.6, 1.])).unwrap();
            assert_eq!(rebuilt.program_id(), retained.program_id());
            black_box(rebuilt)
        })
    });
    c.bench_function("paint_graph/map", |b| {
        b.iter(|| {
            black_box(
                retained
                    .map(|cx, color| color.scale(cx.scalar(0.5)))
                    .unwrap(),
            )
        })
    });
    let root_without_retained_shader = PaintRoot::new();
    c.bench_function("paint_graph/rebuild_dropped", |b| {
        b.iter(|| {
            black_box(
                root_without_retained_shader
                    .shader(|cx| cx.vec4([0.2, 0.4, 0.6, 1.]))
                    .unwrap(),
            )
        })
    });
    c.bench_function("paint_graph/semantic_distance", |b| {
        b.iter(|| {
            black_box(
                root.shader(|cx| {
                    let outer = cx.circle_field(cx.position(), cx.vec2([20., 20.]), cx.scalar(16.));
                    let hole = cx.circle_field(cx.position(), cx.vec2([28., 20.]), cx.scalar(10.));
                    outer
                        .subtract(hole)
                        .inward_stroke(cx.scalar(2.))
                        .coverage()
                        .mask(cx.vec4([0.2, 0.4, 0.6, 1.]))
                })
                .unwrap(),
            )
        })
    });
    c.bench_function("paint_graph/shared_nodes", |b| {
        b.iter(|| {
            black_box(
                PaintRoot::new()
                    .shader(|cx| {
                        let mut x = cx.uv().x();
                        for _ in 0..32 {
                            x = x.clone() + x;
                        }
                        cx.rgba(x.clone(), x.clone(), x, cx.scalar(1.))
                    })
                    .unwrap(),
            )
        })
    });
    let function = root
        .function::<(f32, [f32; 2]), [f32; 4]>(|cx, (phase, uv)| {
            cx.rgba(
                (uv.x() + phase).sin(),
                cx.scalar(0.2),
                cx.scalar(0.8),
                cx.scalar(1.),
            )
        })
        .unwrap();
    let phase = root.parameter(0.4).unwrap();
    c.bench_function("paint_graph/function_composed", |b| {
        b.iter(|| {
            black_box(
                root.shader(|cx| cx.call(&function, (cx.uniform(phase), cx.uv())))
                    .unwrap(),
            )
        })
    });
    c.bench_function("paint_graph/function_handwritten", |b| {
        b.iter(|| {
            black_box(
                root.shader(|cx| {
                    cx.rgba(
                        (cx.uv().x() + cx.uniform(phase)).sin(),
                        cx.scalar(0.2),
                        cx.scalar(0.8),
                        cx.scalar(1.),
                    )
                })
                .unwrap(),
            )
        })
    });
    let long_function = root
        .function::<f32, f32>(|_, mut x| {
            for _ in 0..1000 {
                x = x.sin();
            }
            x
        })
        .unwrap();
    c.bench_function("paint_graph/repeated_1000_calls_1000_nodes", |b| {
        b.iter(|| {
            black_box(
                root.shader(|cx| {
                    let input = cx.uv().x();
                    let output = cx.call(&long_function, input.clone());
                    for _ in 0..999 {
                        black_box(cx.call(&long_function, input.clone()));
                    }
                    cx.rgba(output.clone(), output.clone(), output, cx.scalar(1.))
                })
                .unwrap(),
            )
        })
    });
    let material_root = PaintRoot::new();
    let root_parameter = material_root.parameter([1.; 4]).unwrap();
    let material_a = material_root
        .shader(|cx| cx.uniform(root_parameter))
        .unwrap();
    let material_b = material_root
        .shader(|cx| cx.vec4([0.2, 0.4, 0.6, 1.]))
        .unwrap();
    c.bench_function("paint_graph/compose_materials", |b| {
        b.iter(|| {
            black_box(
                material_root
                    .shader(|cx| {
                        cx.sample(&material_a)
                            .mix(cx.sample(&material_b), cx.scalar(0.5))
                    })
                    .unwrap(),
            )
        })
    });
    let mut handle = None;
    let parameterized = PaintRoot::new()
        .shader(|cx| {
            let p = cx.parameter([1.; 4]);
            handle = Some(p);
            cx.uniform(p)
        })
        .unwrap();
    c.bench_function("paint_graph/update", |b| {
        b.iter(|| {
            black_box(
                parameterized
                    .with_parameter(handle.unwrap(), black_box([0.2, 0.4, 0.6, 1.]))
                    .unwrap(),
            )
        })
    });
    let canvas_paint = shader();
    let canvas_root = PaintRoot::new();
    c.bench_function("paint_canvas/varying_shape_dimensions", |b| {
        b.iter(|| {
            black_box(
                canvas_root
                    .canvas(|canvas| {
                        for i in 0..64 {
                            let bounds = gpui::Bounds::new(
                                gpui::Point::default(),
                                gpui::size(gpui::px(20. + i as f32), gpui::px(30. + i as f32)),
                            );
                            canvas
                                .rounded_rect(bounds, gpui::px(4. + i as f32 / 8.))
                                .stroke(&canvas_paint, gpui::px(2.));
                        }
                    })
                    .unwrap(),
            )
        })
    });
    let retained_canvas = root
        .canvas(|canvas| {
            for i in 0..64 {
                let bounds = gpui::Bounds::new(
                    gpui::Point::default(),
                    gpui::size(gpui::px(20. + i as f32), gpui::px(30. + i as f32)),
                );
                canvas
                    .rounded_rect(bounds, gpui::px(4.))
                    .stroke(&parameterized, gpui::px(2.));
            }
        })
        .unwrap();
    c.bench_function("paint_canvas/update_64", |b| {
        b.iter(|| {
            black_box(
                retained_canvas
                    .with_parameter(handle.unwrap(), black_box([0.2, 0.4, 0.6, 1.]))
                    .unwrap(),
            )
        })
    });
    let batch_phase = root.parameter(0.).unwrap();
    let batch_offset = root.parameter([0., 0.]).unwrap();
    let batch_tint = root.parameter([0.2, 0.4, 0.6, 1.]).unwrap();
    let batch_material = root
        .shader(|cx| {
            let x = cx.uniform(batch_phase) + cx.uniform(batch_offset).x();
            cx.uniform(batch_tint)
                .scale(x.sin() * cx.scalar(0.1) + cx.scalar(0.9))
        })
        .unwrap();
    let batch_drawing = root
        .canvas(|canvas| {
            for i in 0..64 {
                let bounds = gpui::Bounds::new(
                    gpui::point(gpui::px(i as f32 * 2.), gpui::px(0.)),
                    gpui::size(gpui::px(40.), gpui::px(40.)),
                );
                canvas
                    .rounded_rect(bounds, gpui::px(4.))
                    .fill(&batch_material);
            }
        })
        .unwrap();
    c.bench_function("paint_canvas/batched_64_three_parameters", |b| {
        b.iter(|| {
            black_box(
                batch_drawing
                    .with_parameters(|p| {
                        p.set(batch_phase, 0.5)
                            .set(batch_offset, [1., 2.])
                            .set(batch_tint, [0.7, 0.2, 0.4, 1.]);
                    })
                    .unwrap(),
            )
        })
    });
    c.bench_function("paint_canvas/chained_64_three_parameters", |b| {
        b.iter(|| {
            black_box(
                batch_drawing
                    .with_parameter(batch_phase, 0.5)
                    .unwrap()
                    .with_parameter(batch_offset, [1., 2.])
                    .unwrap()
                    .with_parameter(batch_tint, [0.7, 0.2, 0.4, 1.])
                    .unwrap(),
            )
        })
    });
    let paint = shader();
    let mut group = c.benchmark_group("paint_scene_build");
    for n in [1, 64, 512] {
        for (name, paint) in [("quads", None), ("shared", Some(&paint))] {
            group.bench_with_input(BenchmarkId::new(name, n), &n, |b, &n| {
                b.iter(|| black_box(scene(n, paint, false)))
            });
        }
    }
    group.finish();
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU required");
    eprintln!("GPU adapter: {:?}", renderer.gpu_specs());
    let target = Size {
        width: DevicePixels(256),
        height: DevicePixels(256),
    };
    c.bench_function("paint_render_cold/shared_64_new_device", |b| {
        let cold_scene = scene(64, Some(&paint), false);
        b.iter_batched(
            || WgpuHeadlessRenderer::new().expect("headless GPU required"),
            |mut renderer| renderer.render_scene_and_wait(&cold_scene, target).unwrap(),
            criterion::BatchSize::SmallInput,
        )
    });
    let mut group = c.benchmark_group("paint_render_wait");
    for n in [1, 64, 512] {
        for (name, p, unique) in [
            ("quads", None, false),
            ("shared", Some(&paint), false),
            ("distinct_roots", Some(&paint), true),
        ] {
            let scene = scene(n, p, unique);
            renderer.render_scene_and_wait(&scene, target).unwrap();
            let before = renderer.paint_diagnostics().1;
            renderer.render_scene_and_wait(&scene, target).unwrap();
            assert_eq!(
                before,
                renderer.paint_diagnostics().1,
                "warm renders must reuse pipelines"
            );
            group.bench_with_input(BenchmarkId::new(name, n), &scene, |b, scene| {
                b.iter(|| {
                    renderer
                        .render_scene_and_wait(black_box(scene), target)
                        .unwrap()
                })
            });
        }
    }
    group.finish();
}

/// Rebuilds the same shader structure with changing instance values, matching
/// an ordinary GPUI component render that reconstructs its paint each frame.
fn production_recipe(phase: f32) -> Paint {
    production_shader(|pixel| {
        let uv = pixel.uv();
        let band = ((uv.x() * 8.0 + phase).sin() * 0.5 + 0.5).smoothstep(0.2, 0.8);
        let rim = (uv.y() - 0.5).abs().smoothstep(0.03, 0.4);
        let front = color([0.8, 0.3, 0.1, 0.7]).mix(color([0.2, 0.4, 1.0, 0.8]), band);
        let back = color([0.08, 0.1, 0.2, 1.0]);
        front.mask(rim).over(back).mix(front.opacity(0.7), 0.25)
    })
}

fn production_scene(count: usize, paint: &Paint, shape: ShaderShape, interleaved: bool) -> Scene {
    let mut scene = Scene::default();
    for i in 0..count {
        let bounds = Bounds {
            origin: Point {
                x: ScaledPixels((i % 8) as f32 * 32.),
                y: ScaledPixels((i / 8) as f32 * 32.),
            },
            size: Size {
                width: ScaledPixels(32.),
                height: ScaledPixels(32.),
            },
        };
        let content_mask = ContentMask { bounds };
        if interleaved && i > 0 {
            scene.insert_primitive(Quad {
                bounds: Bounds {
                    origin: bounds.origin,
                    size: Size {
                        width: ScaledPixels(1.),
                        height: ScaledPixels(1.),
                    },
                },
                content_mask,
                background: solid_background(gpui::rgb(0x223344)),
                ..Default::default()
            });
        }
        let geometry = Quad {
            bounds,
            content_mask,
            background: solid_background(gpui::transparent_black()),
            border_color: gpui::transparent_black().into(),
            border_widths: if shape == ShaderShape::Border {
                Edges::all(ScaledPixels(2.))
            } else {
                Edges::default()
            },
            corner_radii: Corners::all(ScaledPixels(4.)),
            corner_smoothing: 0.6,
            ..Default::default()
        };
        scene.insert_primitive(ShaderQuad {
            order: 0,
            bounds,
            content_mask,
            shader: ShaderProgram::Paint(paint.compile().expect("production paint compile")),
            opacity: 1.,
            scale_factor: 1.,
            geometry: Some((shape, geometry)),
        });
    }
    scene.finish();
    scene
}

fn production_benchmark(c: &mut Criterion) {
    let retained = production_recipe(0.1);
    let retained_compiled = retained.compile().expect("warm production program");
    let mut phase = 0.0f32;
    c.bench_function("paint_production_cpu/construct_drop", |b| {
        b.iter(|| {
            phase += 0.001;
            black_box(production_recipe(black_box(phase)))
        })
    });
    c.bench_function("paint_production_cpu/fresh_rebuild_warm_compile", |b| {
        b.iter(|| {
            phase += 0.001;
            let paint = production_recipe(black_box(phase));
            let compiled = paint.compile().expect("warm production compile");
            assert_eq!(compiled.program_id(), retained_compiled.program_id());
            black_box(compiled)
        })
    });
    c.bench_function("paint_production_cpu/retained_compile", |b| {
        b.iter(|| black_box(retained.compile().expect("retained paint compile")))
    });
    c.bench_function("paint_production_cpu/retained_clone", |b| {
        b.iter(|| black_box(retained.clone()))
    });

    let pure = production_recipe(0.1);
    let border = color(gpui::rgb(0x48b8d0));
    let glass = production_shader(|pixel| {
        backdrop()
            .sample(pixel.uv())
            .mix(color(gpui::rgb(0xe0faff)), 0.2)
    });
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU required");
    let target = Size {
        width: DevicePixels(256),
        height: DevicePixels(256),
    };
    let mut wait_group = c.benchmark_group("paint_production_gpu_submit_wait");
    for count in [1, 64] {
        for (name, paint, shape) in [
            ("pure_background", &pure, ShaderShape::Background),
            ("pure_border", &border, ShaderShape::Border),
            ("backdrop_background", &glass, ShaderShape::Background),
        ] {
            let scene = production_scene(count, paint, shape, false);
            renderer
                .render_scene_and_wait(&scene, target)
                .expect("warm GPU scene");
            let pipelines = renderer.paint_diagnostics().1;
            renderer
                .render_scene_and_wait(&scene, target)
                .expect("warm GPU scene");
            assert_eq!(renderer.paint_diagnostics().1, pipelines);
            wait_group.bench_with_input(BenchmarkId::new(name, count), &scene, |b, scene| {
                b.iter(|| {
                    renderer
                        .render_scene_and_wait(black_box(scene), target)
                        .unwrap()
                })
            });
        }
    }
    // Every quad between glass paints forces a full snapshot refresh. At the
    // larger viewport, these copies expose bandwidth beyond render-pass cost.
    for (label, target, interleaved) in [
        ("backdrop_interleaved_256", target, true),
        (
            "backdrop_contiguous_1024",
            Size {
                width: DevicePixels(1024),
                height: DevicePixels(1024),
            },
            false,
        ),
        (
            "backdrop_interleaved_1024",
            Size {
                width: DevicePixels(1024),
                height: DevicePixels(1024),
            },
            true,
        ),
    ] {
        let scene = production_scene(64, &glass, ShaderShape::Background, interleaved);
        renderer
            .render_scene_and_wait(&scene, target)
            .expect("warm GPU scene");
        let pipelines = renderer.paint_diagnostics().1;
        wait_group.bench_with_input(BenchmarkId::new(label, 64), &scene, |b, scene| {
            b.iter(|| {
                renderer
                    .render_scene_and_wait(black_box(scene), target)
                    .unwrap()
            })
        });
        assert_eq!(renderer.paint_diagnostics().1, pipelines);
    }
    wait_group.finish();

    let mut readback_group = c.benchmark_group("paint_production_gpu_readback_wait");
    for count in [1, 64] {
        for (name, paint, shape) in [
            ("pure_background", &pure, ShaderShape::Background),
            ("pure_border", &border, ShaderShape::Border),
            ("backdrop_background", &glass, ShaderShape::Background),
        ] {
            let scene = production_scene(count, paint, shape, false);
            renderer
                .render_scene_to_image(&scene, target)
                .expect("warm readback scene");
            readback_group.bench_with_input(BenchmarkId::new(name, count), &scene, |b, scene| {
                b.iter(|| {
                    black_box(
                        renderer
                            .render_scene_to_image(black_box(scene), target)
                            .unwrap(),
                    )
                })
            });
        }
    }
    readback_group.finish();
}

criterion_group!(benches, benchmark, production_benchmark);
criterion_main!(benches);
