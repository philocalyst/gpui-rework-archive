use gpui::*;
struct Page {
    value: String,
    broken: bool,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        row((
            text(&self.value).w(400),
            div().size(4).bg(Color::BLACK).transform(if self.broken {
                Affine::scale(0., 1.)
            } else {
                Affine::IDENTITY
            }),
        ))
    }
}
fn check_presented(win: &Win<Page>, expected: u8) {
    let mut paragraphs = 0;
    win.visit(|part| {
        if let Some(text) = part.text() {
            paragraphs += 1;
            assert_eq!(text.len(), 32 * 1024);
            assert!(text.bytes().all(|byte| byte == expected));
            let geometry = part.text_geometry().unwrap();
            assert_eq!(geometry.layout().text_len(), 32 * 1024);
            assert!(
                geometry
                    .caret_bounds(TextPosition {
                        offset: TextOffset::new(0).unwrap(),
                        affinity: CaretAffinity::Downstream
                    })
                    .is_some()
            );
        }
    })
    .unwrap();
    assert_eq!(paragraphs, 1);
}
fn main() {
    let font = gpui_canvas::FontFace::bundled().unwrap();
    println!(
        "HEADERS layout={} shaper={} font={} win={}",
        std::mem::size_of::<gpui_canvas::TextLayout>(),
        std::mem::size_of::<gpui_canvas::TextShaper<'_>>(),
        std::mem::size_of::<gpui_canvas::FontFace>(),
        std::mem::size_of::<Win<Page>>()
    );
    for (name, value, width) in [
        ("empty", String::new(), None),
        ("short", "a short label".into(), None),
        (
            "wrapped",
            "office café אבג and العربية ".repeat(24),
            Some(180.),
        ),
        ("ascii32k", "a".repeat(32 * 1024), Some(400.)),
        (
            "one_long_grapheme",
            format!("a{}", "\u{301}".repeat(1024)),
            Some(400.),
        ),
    ] {
        for interactive in [false, true] {
            let mut result = None;
            let cost = allocation_counter::measure(|| {
                let mut shaper = font.shaper();
                result = Some(
                    if interactive {
                        shaper.shape_interactive(&value, 16., width)
                    } else {
                        shaper.shape(&value, 16., width)
                    }
                    .unwrap(),
                );
            });
            let shape = result.unwrap();
            println!(
                "SHAPE case={name} interactive={interactive} glyphs={} metrics={:?} cost={cost:?}",
                shape.glyphs().len(),
                [shape.width, shape.height, shape.baseline].map(f32::to_bits)
            );
        }
    }
    let mut owner = None;
    let first = allocation_counter::measure(|| {
        owner = Some(
            Win::recording(
                Page {
                    value: "a".repeat(32 * 1024),
                    broken: false,
                },
                WindowOptions::default(),
            )
            .unwrap(),
        );
    });
    let mut win = owner.unwrap();
    println!("OWNER case=first_c cost={first:?}");
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    check_presented(&win, b'a');
    let next = allocation_counter::measure(|| {
        win.update(|page| page.value = "b".repeat(32 * 1024))
            .unwrap()
    });
    println!("OWNER case=old_p_new_c cost={next:?}");
    check_presented(&win, b'a');
    let candidate = win.with_scene(|_, token| token).unwrap();
    let failed = allocation_counter::measure(|| {
        assert!(
            win.update(|page| {
                page.value = "c".repeat(32 * 1024);
                page.broken = true;
            })
            .is_err()
        )
    });
    println!("OWNER case=old_p_old_c_failed_l cost={failed:?}");
    check_presented(&win, b'a');
    let ack = allocation_counter::measure(|| win.presented(candidate).unwrap());
    println!("OWNER case=old_c_ack_failed_l cost={ack:?}");
    check_presented(&win, b'b');
}
