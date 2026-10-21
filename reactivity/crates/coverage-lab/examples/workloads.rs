use gpui_reactivity_coverage_lab::{
    Affine, Color, Operation, Plan, Point, Primitive, Shape, Space, render_direct,
};
use std::{hint::black_box, mem::size_of, time::Instant};
fn primitive(shape: Shape, t: Affine) -> Primitive {
    Primitive::new(shape, Space::new(t)).unwrap()
}
fn paint(r: f64, g: f64, b: f64, a: f64) -> Color {
    Color::new(r * a, g * a, b * a, a).unwrap()
}
fn draw(shape: Shape, t: Affine, color: Color) -> Operation {
    Operation::SourceOver {
        primitive: primitive(shape, t),
        color,
    }
}
fn scene(name: &str) -> (u32, u32, Vec<Operation>) {
    let mut ops = Vec::new();
    match name {
        "flat_fill" => {
            ops.push(draw(
                Shape::Box {
                    half_width: 1000.0,
                    half_height: 1000.0,
                },
                Affine::translation(256.0, 256.0),
                paint(0.2, 0.4, 0.7, 1.0),
            ));
            (512, 512, ops)
        }
        "sheared_circles" => {
            for y in 0..4 {
                for x in 0..4 {
                    ops.push(draw(
                        Shape::Circle { radius: 24.0 },
                        Affine {
                            a: 1.3,
                            b: 0.2,
                            c: 0.6,
                            d: 0.7,
                            tx: 32.25 + x as f64 * 64.0,
                            ty: 32.5 + y as f64 * 64.0,
                        },
                        paint(0.7, 0.3, 0.1, 0.75),
                    ));
                }
            }
            (256, 256, ops)
        }
        "opaque_overlaps" | "translucent_overlaps" => {
            let alpha = if name == "opaque_overlaps" { 1.0 } else { 0.25 };
            for i in 0..64 {
                ops.push(draw(
                    Shape::Box {
                        half_width: 1000.0,
                        half_height: 1000.0,
                    },
                    Affine::translation(128.0, 128.0),
                    paint((i % 3) as f64 / 3.0, 0.2, 0.4, alpha),
                ));
            }
            (256, 256, ops)
        }
        "textlike_stems" => {
            for y in 0..8 {
                for x in 0..16 {
                    ops.push(draw(
                        Shape::Box {
                            half_width: 0.4,
                            half_height: 3.5,
                        },
                        Affine::translation(3.25 + x as f64 * 8.0, 6.125 + y as f64 * 16.0),
                        paint(0.1, 0.2, 0.3, 1.0),
                    ));
                }
            }
            (128, 128, ops)
        }
        "boundary_dense" => {
            for i in 0..64 {
                ops.push(draw(
                    Shape::Circle { radius: 1.5 },
                    Affine::translation(2.0 + (i % 3) as f64 / 16.0, 2.0),
                    paint(0.2, 0.4, 0.8, 0.125),
                ));
            }
            (4, 4, ops)
        }
        _ => unreachable!(),
    }
}
fn median(values: &mut [u128]) -> u128 {
    values.sort_unstable();
    values[values.len() / 2]
}
fn main() {
    let repeats = if std::env::args().any(|a| a == "--quick") {
        1
    } else {
        3
    };
    let samples = [Point { x: 0.5, y: 0.5 }];
    println!(
        "workload,mode,width,height,draws,tile,build_ns,render_ns,total_ns,outside_tiles,inside_tiles,boundary_tiles,occluded_tile_draws,retained_operations,classifier_calls,distance_evaluations,boundary_point_tests,scene_payload_bytes,plan_temp_bytes,output_bytes"
    );
    for name in [
        "flat_fill",
        "sheared_circles",
        "opaque_overlaps",
        "translucent_overlaps",
        "textlike_stems",
        "boundary_dense",
    ] {
        let (width, height, ops) = scene(name);
        let scene_bytes = size_of::<Vec<Operation>>() + ops.capacity() * size_of::<Operation>();
        let output_bytes = width as usize * height as usize * size_of::<Color>();
        let (reference, direct_stats) = render_direct(&ops, width, height, &samples).unwrap();
        let mut direct_times = Vec::new();
        for _ in 0..repeats {
            let start = Instant::now();
            let (image, _) = render_direct(&ops, width, height, &samples).unwrap();
            direct_times.push(start.elapsed().as_nanos());
            assert_eq!(image, reference);
            black_box(image);
        }
        let direct_ns = median(&mut direct_times);
        println!(
            "{name},direct,{width},{height},{},0,0,{direct_ns},{direct_ns},0,0,0,0,0,0,{},{},{scene_bytes},0,{output_bytes}",
            ops.len(),
            direct_stats.distance_evaluations,
            direct_stats.boundary_point_tests
        );
        for tile in [4, 16, 32] {
            for mode in ["flat", "hierarchy", "unculled_hierarchy"] {
                let mut builds = Vec::new();
                let mut renders = Vec::new();
                let mut totals = Vec::new();
                let mut stats = None;
                let mut bytes = 0;
                for _ in 0..repeats {
                    let start = Instant::now();
                    let plan = if mode == "unculled_hierarchy" {
                        Plan::build_unculled(&ops, width, height, tile, true)
                    } else {
                        Plan::build(&ops, width, height, tile, mode == "hierarchy")
                    }
                    .unwrap();
                    let build_ns = start.elapsed().as_nanos();
                    let render_start = Instant::now();
                    let (image, measured) = plan.render(&samples).unwrap();
                    let render_ns = render_start.elapsed().as_nanos();
                    builds.push(build_ns);
                    renders.push(render_ns);
                    totals.push(build_ns + render_ns);
                    bytes = plan.temporary_bytes();
                    stats = Some(measured);
                    assert_eq!(image, reference);
                    black_box(image);
                }
                let s = stats.unwrap();
                let build = median(&mut builds);
                let render = median(&mut renders);
                let total = median(&mut totals);
                println!(
                    "{name},{mode},{width},{height},{},{tile},{build},{render},{total},{},{},{},{},{},{},{},{},{scene_bytes},{bytes},{output_bytes}",
                    ops.len(),
                    s.outside_tiles,
                    s.inside_tiles,
                    s.boundary_tiles,
                    s.occluded_tile_draws,
                    s.retained_tile_operations,
                    s.classifier_calls,
                    s.distance_evaluations,
                    s.boundary_point_tests
                );
            }
        }
    }
    eprintln!(
        "layout Color={} Operation={} Primitive={} Space={}; repeats={repeats}; center point coverage, not area AA",
        size_of::<Color>(),
        size_of::<Operation>(),
        size_of::<Primitive>(),
        size_of::<Space>()
    );
}
