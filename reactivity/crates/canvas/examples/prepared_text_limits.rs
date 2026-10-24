//! Diagnostic public-domain control; full 32KiB input limit remains unchanged.
use gpui_canvas::{Error, FontFace, TextMetrics};
fn bits(result: &Result<TextMetrics, Error>) -> Result<[u32; 3], Error> {
    result
        .as_ref()
        .map(|m| [m.width.to_bits(), m.height.to_bits(), m.baseline.to_bits()])
        .map_err(Clone::clone)
}
fn main() {
    let face = FontFace::bundled().unwrap();
    for len in [1, 1024, 32 * 1024] {
        for reject in [false, true] {
            let source = if reject {
                format!("\t{}", "\n".repeat(len - 1))
            } else {
                "\n".repeat(len)
            };
            let mut oracle = face.shaper();
            let expected = oracle.measure(&source, 12., None);
            for prepare in [false, true] {
                let mut shaper = face.shaper();
                drop(shaper.shape("warm", 12., None).unwrap());
                let mut held = None;
                let mut result = None;
                let cost = allocation_counter::measure(|| {
                    result = Some(if prepare {
                        shaper.prepare(&source, 12., None).map(|(p, m)| {
                            held = Some(p);
                            m
                        })
                    } else {
                        shaper.measure(&source, 12., None)
                    });
                });
                assert_eq!(bits(result.as_ref().unwrap()), bits(&expected));
                println!(
                    "PREPARED_LIMIT len={len} reject={reject} prepare={prepare} allocations={} requested={} retained={} peak={} result={:?}",
                    cost.count_total,
                    cost.bytes_total,
                    cost.bytes_current,
                    cost.bytes_max,
                    bits(result.as_ref().unwrap())
                );
                drop(held);
            }
        }
    }
}
