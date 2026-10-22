//! Identical external caller for f019 and compact-style startup controls.
//! Default mode is a functional/allocation guard; capture needs coordinated quiet.
use gpui::{WindowOptions, prelude::*};
use std::{hint::black_box, time::Instant};

#[inline(never)]
fn single_width_probe(width: u32) -> El<'static> {
    div().w(width)
}

#[inline(never)]
fn literal_builder_probe(width: u32, color: Color) -> El<'static> {
    div()
        .w(width)
        .h(20)
        .gap(8)
        .p(4)
        .font_size(16)
        .fg(color)
        .bg(color)
        .transform(Affine::translation(1.0, 2.0))
        .layout(
            Flex::row()
                .align(Align::Center)
                .justify(Justify::Start)
                .wrap(false),
        )
}

#[inline(never)]
fn literal_recipe_probe(width: u32, color: Color) -> El<'static> {
    div()
        .w(width)
        .h(20)
        .p(4)
        .font_size(16)
        .fg(color)
        .bg(color)
        .transform(Affine::translation(1.0, 2.0))
        .layout(
            Flex::row()
                .gap(8)
                .align(Align::Center)
                .justify(Justify::Start)
                .wrap(false),
        )
}

struct LiteralOwner {
    count: usize,
    recipe: bool,
}
impl View for LiteralOwner {
    fn view(&self) -> El<'_> {
        div().size(512).child((0..self.count).map(|i| {
            let width = 16 + (i % 8) as u32;
            let color = Color::rgb(1, 2, 3);
            if self.recipe {
                literal_recipe_probe(width, color)
            } else {
                literal_builder_probe(width, color)
            }
        }))
    }
}

fn digest(bytes: &[u8]) -> u64 {
    bytes.iter().fold(0xcbf29ce484222325, |hash, byte| {
        (hash ^ u64::from(*byte)).wrapping_mul(0x100000001b3)
    })
}

fn guard() {
    let color = Color::rgb(1, 2, 3);
    for (label, build) in [
        ("width", single_width_probe as fn(u32) -> El<'static>),
        (
            "fields",
            (|width| literal_builder_probe(width, Color::rgb(1, 2, 3))) as fn(u32) -> El<'static>,
        ),
        (
            "recipe",
            (|width| literal_recipe_probe(width, Color::rgb(1, 2, 3))) as fn(u32) -> El<'static>,
        ),
    ] {
        let mut element = None;
        let allocation = allocation_counter::measure(|| element = Some(build(black_box(24))));
        assert_eq!(allocation.count_total, 0, "{label}");
        assert_eq!(allocation.bytes_current, 0, "{label}");
        drop(element);
        println!("guard,builder,{label},allocations=0");
    }
    black_box(color);
    for count in [1, 60, 139] {
        let mut direct = Win::with_size(
            LiteralOwner {
                count,
                recipe: false,
            },
            64,
            64,
        )
        .unwrap();
        let mut recipe = Win::with_size(
            LiteralOwner {
                count,
                recipe: true,
            },
            64,
            64,
        )
        .unwrap();
        let a = direct.with_pixels(|pixels, _, _| digest(pixels)).unwrap();
        let b = recipe.with_pixels(|pixels, _, _| digest(pixels)).unwrap();
        assert_eq!(a, b, "direct/recipe complete pixel oracle");
        println!("guard,pixels,{count},digest={a:016x}");
    }
}

fn capture() {
    assert_eq!(
        std::env::var("STYLE_STARTUP_CAPTURE").as_deref(),
        Ok("approved"),
        "coordinate a quiet window first"
    );
    for (label, build) in [
        ("width", single_width_probe as fn(u32) -> El<'static>),
        (
            "fields",
            (|width| literal_builder_probe(width, Color::rgb(1, 2, 3))) as fn(u32) -> El<'static>,
        ),
        (
            "recipe",
            (|width| literal_recipe_probe(width, Color::rgb(1, 2, 3))) as fn(u32) -> El<'static>,
        ),
    ] {
        let rounds = 200_000;
        let start = Instant::now();
        let allocation = allocation_counter::measure(|| {
            for i in 0..rounds {
                drop(black_box(build(black_box(16 + i % 8))));
            }
        });
        let ns = start.elapsed().as_nanos();
        assert_eq!(allocation.count_total, 0);
        println!("cost,builder,{label},{rounds},{ns},0,0,0,0");
    }
    for recipe in [false, true] {
        for (count, rounds) in [(1, 128), (60, 32), (139, 16), (4096, 2)] {
            let mut retained = None;
            let start = Instant::now();
            let allocation = allocation_counter::measure(|| {
                for turn in 0..rounds {
                    retained = Some(
                        Win::recording(
                            LiteralOwner { count, recipe },
                            WindowOptions {
                                size: [64, 64],
                                ..Default::default()
                            },
                        )
                        .unwrap(),
                    );
                    if turn + 1 != rounds {
                        drop(retained.take());
                    }
                }
            });
            let ns = start.elapsed().as_nanos();
            black_box(&retained);
            println!(
                "cost,mount,{}-{count},{rounds},{ns},{},{},{},{}",
                if recipe { "recipe" } else { "fields" },
                allocation.count_total,
                allocation.bytes_total,
                allocation.bytes_current,
                allocation.bytes_max
            );
        }
    }
}

fn cold_mount() {
    assert_eq!(
        std::env::var("STYLE_STARTUP_CAPTURE").as_deref(),
        Ok("approved"),
        "coordinate a quiet window first"
    );
    let count = std::env::var("STYLE_STARTUP_COLD_COUNT")
        .unwrap_or_else(|_| "139".into())
        .parse::<usize>()
        .unwrap();
    assert!([1, 60, 139, 4096].contains(&count));
    let mut owner = None;
    let start = Instant::now();
    let allocation = allocation_counter::measure(|| {
        owner = Some(
            Win::recording(
                LiteralOwner {
                    count,
                    recipe: false,
                },
                WindowOptions {
                    size: [64, 64],
                    ..Default::default()
                },
            )
            .unwrap(),
        );
    });
    let ns = start.elapsed().as_nanos();
    let mut owner = owner.unwrap();
    let token = owner.with_scene(|_, token| token).unwrap();
    owner.presented(token).unwrap();
    let snapshot = owner.inspect().unwrap();
    assert_eq!(snapshot.nodes.len(), count + 1);
    let bytes: Vec<_> = snapshot
        .nodes
        .iter()
        .flat_map(|node| {
            node.bounds
                .into_iter()
                .flat_map(|v| v.to_bits().to_le_bytes())
        })
        .collect();
    println!("guard,cold,{count},digest={:016x}", digest(&bytes));
    println!(
        "cost,cold-mount,fields-{count},1,{ns},{},{},{},{}",
        allocation.count_total,
        allocation.bytes_total,
        allocation.bytes_current,
        allocation.bytes_max
    );
}

fn main() {
    println!(
        "pin,{},{}",
        env!("STYLE_STARTUP_VARIANT"),
        env!("STYLE_STARTUP_SOURCE")
    );
    let capture_requested = std::env::args().nth(1).as_deref() == Some("capture");
    if capture_requested {
        cold_mount();
    }
    guard();
    if capture_requested {
        capture();
    }
}
