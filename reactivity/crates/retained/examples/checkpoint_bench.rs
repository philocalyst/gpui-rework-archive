//! CPU cold-checkpoint microbenchmark, not a hot rendering/upload benchmark.
use gpui_retained::{FormatIdentity, Independent, Limits, MAX_TILE_BYTES, Surface};
use std::{hint::black_box, time::Instant};

const WIDTH: usize = 256;
const HEIGHT: usize = 256;
const ITERATIONS: usize = 100;
const LIMITS: Limits = Limits {
    max_pixels: WIDTH * HEIGHT,
    max_encoded_bytes: WIDTH * HEIGHT * 5,
};

fn elapsed_per_tile(mut operation: impl FnMut(), tiles: usize) -> f64 {
    let start = Instant::now();
    for _ in 0..ITERATIONS {
        operation();
    }
    start.elapsed().as_nanos() as f64 / (ITERATIONS * tiles) as f64
}

fn main() {
    let surface = Surface {
        width: WIDTH as u32,
        height: HEIGHT as u32,
        format: FormatIdentity(*b"opaque-rgba8-v01"),
    };
    println!(
        "class,raw_bytes,checkpoint_resident,delta_with_base,encode_ns_tile,decode_ns_tile,delta_encode_ns_tile,raw_clone_ns_tile,raw_tile_read_ns_tile,encode_allocations,encode_peak_bytes,modes_raw_solid_palette_copy"
    );
    for class in ["flat", "panels", "gradient", "noise"] {
        let mut image = vec![0; WIDTH * HEIGHT * 4];
        let mut random = 1u32;
        for y in 0..HEIGHT {
            for x in 0..WIDTH {
                let pixel = match class {
                    "flat" => [24, 24, 24, 255],
                    "panels" => {
                        if x % 16 < 2 || y % 16 < 2 {
                            [12, 33, 61, 255]
                        } else {
                            [210, 220, 240, 180]
                        }
                    }
                    "gradient" => [x as u8, y as u8, (x + y) as u8, 0],
                    _ => {
                        random ^= random << 13;
                        random ^= random >> 17;
                        random ^= random << 5;
                        random.to_le_bytes()
                    }
                };
                image[(y * WIDTH + x) * 4..(y * WIDTH + x + 1) * 4].copy_from_slice(&pixel);
            }
        }
        let mut base = None;
        let allocations = allocation_counter::measure(|| {
            base = Some(Independent::encode(surface, &image, LIMITS).unwrap())
        });
        let base = base.unwrap();
        let mut changed = image.clone();
        changed[(HEIGHT / 2 * WIDTH + WIDTH / 2) * 4] ^= 1;
        let delta = base.delta(surface, &changed, LIMITS).unwrap();
        let tiles = base.tile_count();
        let encode_ns = elapsed_per_tile(
            || {
                black_box(Independent::encode(surface, black_box(&image), LIMITS).unwrap());
            },
            tiles,
        );
        let delta_ns = elapsed_per_tile(
            || {
                black_box(base.delta(surface, black_box(&changed), LIMITS).unwrap());
            },
            tiles,
        );
        let mut tile = [0; MAX_TILE_BYTES];
        let decode_ns = elapsed_per_tile(
            || {
                for index in (0..tiles).rev() {
                    base.decode_tile(index, &mut tile).unwrap();
                    black_box(&tile);
                }
            },
            tiles,
        );
        let raw_clone_ns = elapsed_per_tile(
            || {
                black_box(black_box(&image).to_vec().into_boxed_slice());
            },
            tiles,
        );
        let raw_read_ns = elapsed_per_tile(
            || {
                for index in (0..tiles).rev() {
                    let x = index % (WIDTH / 16) * 16;
                    let y = index / (WIDTH / 16) * 16;
                    for row in 0..16 {
                        let start = ((y + row) * WIDTH + x) * 4;
                        tile[row * 64..(row + 1) * 64].copy_from_slice(&image[start..start + 64]);
                    }
                    black_box(&tile);
                }
            },
            tiles,
        );
        let modes = base.modes();
        println!(
            "{class},{},{},{},{encode_ns:.1},{decode_ns:.1},{delta_ns:.1},{raw_clone_ns:.1},{raw_read_ns:.1},{},{},{}-{}-{}-{}",
            image.len(),
            base.storage().total_resident_bytes,
            delta.storage().total_resident_bytes,
            allocations.count_total,
            allocations.bytes_max,
            modes.raw,
            modes.solid,
            modes.palette_runs,
            modes.copied
        );
    }
}
