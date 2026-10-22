use gpui_canvas::{Color, ColorSpace, OutputProfile};
use std::{hint::black_box, time::Instant};

fn operation(index: usize) -> u32 {
    let lightness = [0.001, 0.1, 0.5, 0.9, 0.999_999_94][index % 5];
    let hue = [0.0, 30.0, 89.999_99, 90.0, 180.0, 264.2, 264.207_82, 270.0, 359.999_97][index % 9];
    let common = Color::oklch(black_box(lightness), 0.01, black_box(hue), 1.0).unwrap()
        .convert(ColorSpace::LinearSrgb).unwrap().channels()[0].to_bits();
    #[cfg(feature = "primitive")]
    {
        let profile = if index & 1 == 0 { OutputProfile::Srgb } else { OutputProfile::DisplayP3 };
        let cap = profile.max_chroma(black_box(lightness), black_box(hue)).unwrap();
        let fitted = Color::oklch(lightness, 1.0, hue, -0.0).unwrap().fit_chroma(profile).unwrap();
        common ^ cap.to_bits().rotate_left(5) ^ fitted.channels()[1].to_bits()
    }
    #[cfg(not(feature = "primitive"))]
    common
}
fn main() {
    let iterations = std::env::args().nth(1).unwrap_or_else(|| "1000".into()).parse::<usize>().unwrap();
    let mut hash = 0_u64;
    let start = Instant::now();
    let allocation = allocation_counter::measure(|| {
        for i in 0..iterations {
            hash = hash.rotate_left(7) ^ black_box(operation(black_box(i))) as u64;
        }
    });
    let ns = start.elapsed().as_nanos();
    println!("iterations,ns,hash,requested,retained,peak,calls,color_bytes,profile_bytes,error_bytes");
    println!("{iterations},{ns},{hash},{},{},{},{},{},{},{}", allocation.bytes_total,
        allocation.bytes_current, allocation.bytes_max, allocation.count_total,
        size_of::<Color>(), size_of::<OutputProfile>(), size_of::<gpui_canvas::Error>());
}
