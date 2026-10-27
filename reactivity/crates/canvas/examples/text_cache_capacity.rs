//! Retained allocation ledger; scoped planning is the independent output oracle.
use gpui_canvas::{FontFace, TextCache, TextLayout};
fn fingerprint(layout: &TextLayout) -> (Vec<(u16, u32, u32, u32)>, [u32; 3]) {
    (
        layout
            .glyphs()
            .map(|g| (g.id, g.cluster, g.x.to_bits(), g.baseline.to_bits()))
            .collect(),
        [layout.width, layout.height, layout.baseline].map(f32::to_bits),
    )
}
fn main() {
    let primary = FontFace::bundled().unwrap();
    let foreign = FontFace::new(include_bytes!("../assets/NotoSans-default.ttf")).unwrap();
    let long = "office AVATAR 123456789 ".repeat(1400);
    assert!(long.len() > 30_000 && long.len() <= 32768);
    let mixed = "a\u{301} שלום مرحبا office\r\n".repeat(64);
    let stages = [
        ("cold", &primary, "Count: 10"),
        ("long", &primary, long.as_str()),
        ("short", &primary, "Count: 11"),
        ("mixed", &primary, mixed.as_str()),
        ("invalid", &primary, "bad\0"),
        ("foreign", &foreign, "Count: 12"),
        ("return", &primary, "Count: 13"),
    ];
    // Warm shared immutable fallback owners before both accounting regimes.
    for (_, font, source) in stages {
        let _ = font.shaper().shape_interactive(source, 16., Some(400.));
    }
    println!("variant,stage,allocations,requested,live_delta,live_total,peak_new");
    for cached in [false, true] {
        let mut cache = TextCache::default();
        let mut total = 0;
        for (_, font, source) in stages {
            // Oracle and owned result fingerprint are fully dropped before measuring.
            let expected = font
                .shaper()
                .shape_interactive(source, 16., Some(400.))
                .map(|l| fingerprint(&l));
            let check = if cached {
                font.shaper_reusing(&mut cache)
                    .shape_interactive(source, 16., Some(400.))
            } else {
                font.shaper().shape_interactive(source, 16., Some(400.))
            };
            assert_eq!(check.map(|l| fingerprint(&l)), expected);
        }
        cache.clear();
        for (stage, font, source) in stages {
            let cost = allocation_counter::measure(|| {
                let result = if cached {
                    font.shaper_reusing(&mut cache)
                        .shape_interactive(source, 16., Some(400.))
                } else {
                    font.shaper().shape_interactive(source, 16., Some(400.))
                };
                assert_eq!(result.is_err(), stage == "invalid");
                std::hint::black_box(&result);
            });
            total += cost.bytes_current;
            println!(
                "{cached},{stage},{},{},{},{},{}",
                cost.count_total, cost.bytes_total, cost.bytes_current, total, cost.bytes_max
            );
        }
        let cost = allocation_counter::measure(|| cache.clear());
        total += cost.bytes_current;
        println!(
            "{cached},clear,{},{},{},{},{}",
            cost.count_total, cost.bytes_total, cost.bytes_current, total, cost.bytes_max
        );
        assert_eq!(total, 0, "all retained planner allocations reclaimed");
    }
}
