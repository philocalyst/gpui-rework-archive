//! Full-raster image controls: exact output digest and allocator ledger.
use gpui_canvas::{
    Affine, AlphaMode, Canvas, Color, ColorConfig, Image, ImageProfile, ImageSampling, Rect,
};
use std::{hint::black_box, time::Instant};
fn scene(case: &str) -> Canvas {
    let mut canvas = Canvas::recording(384, 256, ColorConfig::default()).unwrap();
    canvas.clear(Color::WHITE);
    let clip = Rect::new(0., 0., 384., 256.);
    if case == "flat" {
        canvas
            .fill_rect(clip, Affine::IDENTITY, clip, Color::rgb(32, 80, 160))
            .unwrap();
        return canvas;
    }
    let make = |variant: usize| {
        if case.starts_with("hdr") {
            return Image::linear_srgb(
                128,
                128,
                AlphaMode::Premultiplied,
                (0..128 * 128)
                    .map(|i| {
                        let a = [0., 0.25, 0.5, 1.][i % 4];
                        [2.5 * a, -0.125 * a, (i % 128) as f32 / 128. * a, a]
                    })
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
            )
            .unwrap();
        }
        let bytes = (0..128 * 128)
            .flat_map(|i| {
                let a = [0, 63, 127, 255][i % 4];
                let rgb = [
                    (i * 31 + variant * 17) as u8,
                    (i / 128 * 13) as u8,
                    (i % 128 * 29) as u8,
                ];
                let rgb = if case.starts_with("premul") {
                    rgb.map(|v| v.min(a))
                } else {
                    rgb
                };
                [rgb[0], rgb[1], rgb[2], a]
            })
            .collect::<Vec<_>>()
            .into_boxed_slice();
        Image::rgba8(
            128,
            128,
            if case.starts_with("p3") {
                ImageProfile::DisplayP3
            } else {
                ImageProfile::Srgb
            },
            if case.starts_with("premul") {
                AlphaMode::Premultiplied
            } else {
                AlphaMode::Straight
            },
            bytes,
        )
        .unwrap()
    };
    let shared = (case != "unique48").then(|| make(0));
    let count = if matches!(
        case,
        "shared48" | "unique48" | "p3-48" | "premul-48" | "hdr-48"
    ) {
        48
    } else {
        1
    };
    for i in 0..count {
        let unique;
        let image = if let Some(image) = &shared {
            image
        } else {
            unique = make(i);
            &unique
        };
        let rect = if count == 48 {
            Rect::new((i % 8 * 48) as f32, (i / 8 * 40) as f32, 48., 40.)
        } else if case == "tiny" {
            Rect::new(17.125, 29.375, 1.25, 1.75)
        } else {
            Rect::new(0.125, 0.375, 256., 250.)
        };
        let map = match case {
            "shear" => Affine {
                a: 0.9,
                b: 0.125,
                c: 0.2,
                d: 0.8,
                tx: 3.125,
                ty: 5.375,
            },
            "reflected" => Affine {
                a: -1.,
                d: -0.75,
                tx: 300.125,
                ty: 240.375,
                ..Affine::IDENTITY
            },
            _ => Affine::IDENTITY,
        };
        canvas
            .draw_image(
                image,
                rect,
                map,
                clip,
                if case == "nearest" {
                    ImageSampling::Nearest
                } else {
                    ImageSampling::Linear
                },
            )
            .unwrap();
    }
    canvas
}
fn main() {
    let case = std::env::args().nth(1).expect("case");
    assert!(matches!(
        case.as_str(),
        "flat"
            | "one"
            | "shared48"
            | "unique48"
            | "p3"
            | "premul"
            | "hdr"
            | "nearest"
            | "shear"
            | "reflected"
            | "tiny"
            | "p3-48"
            | "premul-48"
            | "hdr-48"
    ));
    let mut canvas = None;
    let storage = allocation_counter::measure(|| canvas = Some(scene(&case)));
    let mut canvas = canvas.unwrap();
    let mut output = vec![0; 384 * 256];
    let mut expected = Vec::new();
    for frame in 0..9 {
        let start = Instant::now();
        let allocation = allocation_counter::measure(|| canvas.render_bgrx(&mut output).unwrap());
        let us = start.elapsed().as_secs_f64() * 1e6;
        if frame == 0 {
            expected.clone_from(&output);
        }
        assert_eq!(output, expected);
        black_box(&output);
        let digest = output
            .iter()
            .fold(0u64, |v, &p| v.wrapping_mul(31).wrapping_add(p as u64));
        let stats = canvas.stats();
        println!(
            "{case},{frame},{us:.3},{},{},{},{},{},{},{digest}",
            allocation.count_total,
            allocation.bytes_total,
            storage.bytes_current,
            storage.bytes_max,
            stats.sample_tests,
            stats.boundary_pixels
        );
    }
}
