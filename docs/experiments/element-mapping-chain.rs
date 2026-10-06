use gpui::{
    Bounds, ContentMask, Quad, ScaledPixels, Scene, Size, SpaceKind, TransformationMatrix, point,
};
use std::{hint::black_box, time::Instant};

fn transform(i: usize) -> TransformationMatrix {
    let angle = (i + 1) as f32 * 0.003;
    let (s, c) = angle.sin_cos();
    TransformationMatrix {
        rotation_scale: [[c, -s], [s, c]],
        translation: [1.0 + i as f32 * 0.001, -0.5],
    }
}

fn nest(scene: &mut Scene, depth: usize, draws: usize, clip_every: usize) {
    if depth == 0 {
        let quad = Quad {
            bounds: Bounds::new(
                point(ScaledPixels(0.), ScaledPixels(0.)),
                Size::new(ScaledPixels(10.), ScaledPixels(10.)),
            ),
            content_mask: ContentMask {
                bounds: Bounds::new(
                    point(ScaledPixels(-100000.), ScaledPixels(-100000.)),
                    Size::new(ScaledPixels(200000.), ScaledPixels(200000.)),
                ),
                ..Default::default()
            },
            ..Quad::default()
        };
        for _ in 0..draws {
            scene.insert_primitive(quad);
        }
    } else {
        scene.with_transform(transform(depth), |scene| {
            if clip_every > 0 && depth % clip_every == 0 {
                let clip = ContentMask {
                    bounds: Bounds::new(
                        point(ScaledPixels(-100000.), ScaledPixels(-100000.)),
                        Size::new(ScaledPixels(200000.), ScaledPixels(200000.)),
                    ),
                    ..Default::default()
                };
                scene.with_clip(clip, |scene| nest(scene, depth - 1, draws, clip_every));
            } else {
                nest(scene, depth - 1, draws, clip_every);
            }
        });
    }
}

fn visits_and_clip_checksum(spaces: &[gpui::RenderSpace], mut id: u32) -> (usize, usize, u64) {
    let (mut count, mut clips, mut checksum) = (0, 0, 0u64);
    while id != 0 {
        count += 1;
        let space = spaces[id as usize];
        match space.kind {
            SpaceKind::Collapsed => return (count, clips, 0),
            SpaceKind::Mapping => {}
            SpaceKind::Clip => {
                clips += 1;
                checksum = checksum
                    .wrapping_add(space.inverse.rotation_scale[0][0].to_bits() as u64)
                    .wrapping_add(space.clip.size.width.0.to_bits() as u64);
            }
        }
        id = space.parent;
    }
    (count, clips, checksum)
}

fn summarize(label: &str, ops: usize, mut times: Vec<f64>) {
    times.sort_by(f64::total_cmp);
    let n = times.len();
    println!(
        "{label:62} median={:.2} ns/op p10={:.2} p90={:.2}",
        times[n / 2] / ops as f64,
        times[n / 10] / ops as f64,
        times[n * 9 / 10] / ops as f64
    );
}

fn paired(label: &str, ops: usize, mut a: impl FnMut() -> u64, mut b: impl FnMut() -> u64) {
    for i in 0..6 {
        if i % 2 == 0 {
            black_box(a());
            black_box(b());
        } else {
            black_box(b());
            black_box(a());
        }
    }
    let (mut at, mut bt) = (Vec::new(), Vec::new());
    for i in 0..30 {
        let (first, second) = if i % 2 == 0 {
            (&mut at, &mut bt)
        } else {
            (&mut bt, &mut at)
        };
        let t = Instant::now();
        if i % 2 == 0 {
            black_box(a());
        } else {
            black_box(b());
        }
        first.push(t.elapsed().as_nanos() as f64);
        let t = Instant::now();
        if i % 2 == 0 {
            black_box(b());
        } else {
            black_box(a());
        }
        second.push(t.elapsed().as_nanos() as f64);
    }
    summarize(&format!("{label} legacy every-space parent chain"), ops, at);
    summarize(&format!("{label} clip-scope parent chain"), ops, bt);
}

fn benchmark(depth: usize, clip_every: usize, draws: usize) {
    let mut scene = Scene::default();
    nest(&mut scene, depth, draws, clip_every);
    scene.finish();
    let ids = scene
        .quads
        .iter()
        .map(|quad| quad.content_mask.space)
        .collect::<Vec<_>>();
    assert_eq!(ids.len(), draws);
    assert!(ids.iter().all(|id| *id == ids[0]));
    let start = ids[0];
    let spaces = scene.render_spaces();
    let expected_clips = if clip_every == 0 {
        0
    } else {
        depth / clip_every
    };
    assert_eq!(spaces.len(), depth + expected_clips + 1);
    assert_eq!(spaces[start as usize].kind, SpaceKind::Mapping);
    let (compressed_visits, compressed_clips, compressed_checksum) =
        visits_and_clip_checksum(spaces, start);
    assert_eq!(compressed_visits, expected_clips + 1);
    assert_eq!(compressed_clips, expected_clips);

    // Model the former parent rule by linking the actual production RenderSpace
    // records in creation order. That order is nesting order for this single path.
    let mut legacy = spaces.to_vec();
    for (id, space) in legacy.iter_mut().enumerate().skip(1) {
        space.parent = (id - 1) as u32;
    }
    let (legacy_visits, legacy_clips, legacy_checksum) = visits_and_clip_checksum(&legacy, start);
    assert_eq!(legacy_visits, depth + expected_clips);
    assert_eq!(legacy_clips, expected_clips);
    assert_eq!(legacy_checksum, compressed_checksum);
    let clip_ids = |spaces: &[gpui::RenderSpace]| {
        let mut ids = Vec::new();
        let mut id = start;
        while id != 0 {
            let record = spaces[id as usize];
            if record.kind == SpaceKind::Clip {
                ids.push(id);
            }
            id = record.parent;
        }
        ids
    };
    assert_eq!(
        clip_ids(&legacy),
        clip_ids(spaces),
        "clip order must survive compression"
    );

    println!(
        "depth={depth:3} clip_every={clip_every:3} draws={draws:5} records={} visits/primitive legacy={} compressed={} clip_visits={} clip_signature_equal=true",
        spaces.len(),
        legacy_visits,
        compressed_visits,
        compressed_clips
    );

    let current = || {
        let mut total = 0u64;
        for id in &ids {
            let (visited, clip_count, checksum) =
                visits_and_clip_checksum(black_box(spaces), black_box(*id));
            black_box(visited);
            total = total.wrapping_add(clip_count as u64).wrapping_add(checksum);
        }
        black_box(total)
    };
    let baseline = || {
        let mut total = 0u64;
        for id in &ids {
            let (visited, clip_count, checksum) =
                visits_and_clip_checksum(black_box(&legacy), black_box(*id));
            black_box(visited);
            total = total.wrapping_add(clip_count as u64).wrapping_add(checksum);
        }
        black_box(total)
    };
    assert_eq!(current(), baseline());
    paired(
        &format!("parent walk depth={depth} clip_every={clip_every} draws={draws}"),
        draws,
        baseline,
        current,
    );
}

pub fn run() {
    println!(
        "Production Scene parent-chain walk; mapping-only and mixed clips; exact visit and clip-signature assertions before timing"
    );
    for depth in [1, 8, 64, 256] {
        benchmark(depth, 0, 10_000);
    }
    for depth in [64, 256] {
        benchmark(depth, 8, 10_000);
    }
}
