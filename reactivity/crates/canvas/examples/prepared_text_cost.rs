//! Full 10k output-retaining Canvas control; no raster or OS timing claim.
use gpui_canvas::{FontFace, TextLayout, TextMetrics};
use std::{hint::black_box, time::Instant};
fn mix(hash: &mut u64, value: u32) {
    *hash = (*hash ^ u64::from(value)).wrapping_mul(1099511628211);
}
fn metrics(hash: &mut u64, m: TextMetrics) {
    for value in [m.width, m.height, m.baseline] {
        mix(hash, value.to_bits());
    }
}
fn digest(layouts: &[TextLayout], mut hash: u64) -> u64 {
    for layout in layouts {
        metrics(
            &mut hash,
            TextMetrics {
                width: layout.width,
                height: layout.height,
                baseline: layout.baseline,
            },
        );
        for g in layout.glyphs() {
            for value in [
                u32::from(g.id),
                g.cluster,
                g.x.to_bits(),
                g.baseline.to_bits(),
            ] {
                mix(&mut hash, value);
            }
        }
    }
    hash
}
fn main() {
    let face = FontFace::bundled().unwrap();
    for case in ["unique", "repeated", "unicode"] {
        let inputs: Vec<String> = (0..10_000)
            .map(|i| match case {
                "unique" => format!("Task {:04}", i + 1),
                "repeated" => "Complete".to_owned(),
                _ => format!("Task {:04} office אבג العربية e\u{301}\r\nnext", i + 1),
            })
            .collect();
        let mut expected = None;
        for prepared in [false, true] {
            let mut layouts = Vec::new();
            let mut hash = 14695981039346656037;
            let mut shapes = 0;
            let started = Instant::now();
            let cost = allocation_counter::measure(|| {
                let mut shaper = face.shaper();
                let mut pending = Vec::with_capacity(3);
                for batch in inputs.chunks(3) {
                    if prepared {
                        for text in batch {
                            let (mut p, initial) = shaper.prepare(text, 16., None).unwrap();
                            metrics(&mut hash, initial);
                            metrics(
                                &mut hash,
                                shaper
                                    .measure_prepared(&mut p, Some(f32::MIN_POSITIVE))
                                    .unwrap(),
                            );
                            pending.push(p);
                        }
                        for mut p in pending.drain(..) {
                            layouts.push(shaper.shape_prepared(&mut p, Some(120.)).unwrap());
                            shaper.recycle_prepared(p);
                        }
                    } else {
                        for text in batch {
                            metrics(&mut hash, shaper.measure(text, 16., None).unwrap());
                            metrics(
                                &mut hash,
                                shaper.measure(text, 16., Some(f32::MIN_POSITIVE)).unwrap(),
                            );
                        }
                        for text in batch {
                            layouts.push(shaper.shape_interactive(text, 16., Some(120.)).unwrap());
                        }
                    }
                }
                shapes = shaper.paragraph_shapes();
            });
            let elapsed = started.elapsed().as_nanos();
            let hash = black_box(digest(&layouts, hash));
            if let Some(expected) = expected {
                assert_eq!(hash, expected);
            } else {
                expected = Some(hash);
            }
            println!(
                "PREPARED_TEXT_COST case={case} prepared={prepared} rows={} ns={elapsed} allocations={} requested={} retained={} peak={} shapes={shapes} digest={hash}",
                inputs.len(),
                cost.count_total,
                cost.bytes_total,
                cost.bytes_current,
                cost.bytes_max
            );
        }
    }
}
