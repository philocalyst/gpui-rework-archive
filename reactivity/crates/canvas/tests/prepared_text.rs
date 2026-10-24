use gpui_canvas::{Error, FontFace, TextLayout, TextMetrics};

fn bits(metrics: TextMetrics) -> [u32; 3] {
    [
        metrics.width.to_bits(),
        metrics.height.to_bits(),
        metrics.baseline.to_bits(),
    ]
}
fn layout_bits(layout: &TextLayout) -> ([u32; 3], Vec<(u16, u32, u32, u32)>, String) {
    (
        [
            layout.width.to_bits(),
            layout.height.to_bits(),
            layout.baseline.to_bits(),
        ],
        layout
            .glyphs()
            .map(|g| (g.id, g.cluster, g.x.to_bits(), g.baseline.to_bits()))
            .collect(),
        format!("{:?}", layout.geometry()),
    )
}

#[test]
fn prepared_rebreak_matches_independent_builder_metrics_and_complete_geometry() {
    let face = FontFace::bundled().unwrap();
    let mut reused = face.shaper();
    let mut oracle = face.shaper();
    for source in [
        "",
        "Task 0001",
        "   preserved trailing spaces   ",
        "office ffi affinity",
        "unbreakableword",
        "e\u{301} café",
        "العربية مرحبا",
        "אבג abc (12) العربية!",
        "a\r\nb\rc\nd\u{85}e\u{2029}f\u{2028}g",
        "\r\n",
        "x\n\n",
        "\n\r\nאבג\n\nالعربية\r\n\nabc\n\n",
        "\u{85}\u{2029}\r\n\n",
    ] {
        for size in [1., 12., 16., 31.25, 512.] {
            let (mut prepared, initial) = reused
                .prepare(source, size, Some(f32::MIN_POSITIVE))
                .unwrap();
            assert_eq!(
                bits(initial),
                bits(
                    oracle
                        .measure(source, size, Some(f32::MIN_POSITIVE))
                        .unwrap()
                )
            );
            assert_eq!(prepared.text(), source);
            let atom = oracle.measure("a", size, None).unwrap().width;
            let widths = [
                Some(f32::MIN_POSITIVE),
                None,
                Some(atom.next_down()),
                Some(atom),
                Some(atom.next_up()),
                Some(40.),
                Some(120.),
            ];
            for width in widths {
                assert_eq!(
                    bits(reused.measure_prepared(&mut prepared, width).unwrap()),
                    bits(oracle.measure(source, size, width).unwrap()),
                    "{source:?} {size} {width:?}"
                );
                let got = reused.shape_prepared(&mut prepared, width).unwrap();
                let expected = oracle.shape_interactive(source, size, width).unwrap();
                assert_eq!(
                    layout_bits(&got),
                    layout_bits(&expected),
                    "{source:?} {size} {width:?}"
                );
            }
            reused.recycle_prepared(prepared);
        }
    }
}

#[test]
fn handoff_is_source_borrowed_and_font_qualified_across_shapers() {
    let face = FontFace::bundled().unwrap();
    let other = FontFace::new(include_bytes!("../assets/NotoSans-default.ttf").to_vec()).unwrap();
    let source = String::from("office אבג العربية");
    let mut owner = face.shaper();
    let (mut prepared, _) = owner.prepare(&source, 16., None).unwrap();
    drop(owner);
    let mut foreign = other.shaper();
    assert_eq!(
        foreign.measure_prepared(&mut prepared, Some(40.)),
        Err(Error::ForeignLayout)
    );
    assert!(matches!(
        foreign.shape_prepared(&mut prepared, Some(40.)),
        Err(Error::ForeignLayout)
    ));
    let mut same_face = face.shaper();
    let got = same_face.shape_prepared(&mut prepared, Some(40.)).unwrap();
    let expected = same_face
        .shape_interactive(&source, 16., Some(40.))
        .unwrap();
    assert_eq!(layout_bits(&got), layout_bits(&expected));
    assert_eq!(
        same_face.measure_prepared(&mut prepared, Some(0.)),
        Err(Error::InvalidWidth)
    );
    assert!(same_face.measure_prepared(&mut prepared, Some(40.)).is_ok());
    assert!(matches!(
        same_face.prepare("\t", 16., None),
        Err(Error::UnsupportedControl('\t'))
    ));
    assert!(matches!(
        same_face.prepare("a", 0., None),
        Err(Error::InvalidFontSize)
    ));
}

#[test]
fn rejected_first_paragraph_never_reserves_remaining_layout_headers() {
    let face = FontFace::bundled().unwrap();
    let mut shaper = face.shaper();
    for length in [1, 1024, 32 * 1024] {
        let source = format!("\t{}", "\n".repeat(length - 1));
        drop(shaper.shape("warm", 12., None).unwrap());
        let mut result = None;
        let cost =
            allocation_counter::measure(|| result = Some(shaper.prepare(&source, 12., None)));
        assert!(matches!(result, Some(Err(Error::UnsupportedControl('\t')))));
        assert_eq!(
            cost.count_total, 0,
            "reject before allocating paragraph headers: {length}"
        );
        assert_eq!(cost.bytes_total, 0);
    }
}

#[test]
fn empty_paragraph_capture_retention_is_independent_of_separator_count() {
    let face = FontFace::bundled().unwrap();
    let mut retained = None;
    for length in [1, 1024, 32 * 1024] {
        let source = "\n".repeat(length);
        let mut shaper = face.shaper();
        drop(shaper.shape("warm", 12., None).unwrap());
        let mut prepared = None;
        let cost = allocation_counter::measure(|| {
            prepared = Some(shaper.prepare(&source, 12., None).unwrap());
        });
        assert_eq!(
            *retained.get_or_insert(cost.bytes_current),
            cost.bytes_current
        );
        let (mut prepared, measured) = prepared.unwrap();
        let mut oracle = face.shaper();
        assert_eq!(
            bits(measured),
            bits(oracle.measure(&source, 12., None).unwrap())
        );
        for width in [Some(f32::MIN_POSITIVE), Some(40.), None] {
            assert_eq!(
                layout_bits(&shaper.shape_prepared(&mut prepared, width).unwrap()),
                layout_bits(&oracle.shape_interactive(&source, 12., width).unwrap())
            );
        }
    }
}
