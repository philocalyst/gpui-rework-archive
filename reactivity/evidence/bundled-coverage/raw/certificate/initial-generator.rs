//! Regenerate the immutable bundled-font coverage certificate.
//! Run with the output path: `cargo run -p gpui_canvas --example coverage_table -- assets/font-coverage.bin`.
use std::{env, fs};
use ttf_parser::Face;

fn main() {
    let bytes = [
        include_bytes!("../assets/NotoSans.ttf").as_slice(),
        include_bytes!("../assets/arabic/NotoSansArabic-Regular.ttf").as_slice(),
        include_bytes!("../assets/hebrew/NotoSansHebrew-Regular.ttf").as_slice(),
    ];
    let faces = bytes.map(|bytes| Face::parse(bytes, 0).expect("bundled font"));
    let mut records = Vec::new();
    let mut previous = 0;
    for scalar in 0..=0x10ffff {
        let mask = char::from_u32(scalar).map_or(0, |character| {
            faces.iter().enumerate().fold(0, |mask, (index, face)| {
                mask | (u32::from(face.glyph_index(character).is_some_and(|id| id.0 != 0)) << index)
            })
        });
        if scalar != 0 && mask != previous {
            records.push((previous << 21) | (scalar - 1));
        }
        previous = mask;
    }
    records.push((previous << 21) | 0x10ffff);
    let packed: Vec<_> = records.iter().flat_map(|record| record.to_le_bytes()[..3].to_vec()).collect();
    let path = env::args_os().nth(1).expect("output file");
    fs::write(path, &packed).expect("write coverage certificate");
    println!("records={} bytes={}", records.len(), packed.len());
}
