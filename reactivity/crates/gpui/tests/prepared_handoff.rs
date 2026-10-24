//! Public overflow/fallback and presentation authority against fresh Canvas shapes.
use gpui::{prelude::*, *};

struct Page {
    labels: Vec<String>,
    fail: bool,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        column((
            row(self
                .labels
                .iter()
                .map(|label| button(label.as_str()).p(0).font_size(16.))),
            div().size(4).bg(Color::BLACK).transform(if self.fail {
                Affine::scale(0., 1.)
            } else {
                Affine::IDENTITY
            }),
        ))
    }
}
fn capture(win: &Win<Page>) -> Vec<(String, String)> {
    let face = gpui_canvas::FontFace::bundled().unwrap();
    let mut oracle = face.shaper();
    let mut rows = Vec::new();
    win.visit(|part| {
        if let Some(source) = part.text() {
            let geometry = part.text_geometry().unwrap();
            assert_eq!(geometry.origin(), Point::default());
            let expected = oracle
                .shape_interactive(
                    source,
                    16.,
                    Some(part.local_bounds().width.max(f32::MIN_POSITIVE)),
                )
                .unwrap();
            let actual = format!("{:?}", geometry.layout());
            assert_eq!(
                actual,
                format!("{:?}", expected.geometry().unwrap()),
                "{source:?}"
            );
            rows.push((source.to_owned(), actual));
        }
    })
    .unwrap();
    rows
}
#[test]
fn intrinsic_overflow_large_and_multi_paragraph_fallback_keep_old_p_and_eligible_c() {
    let mut labels: Vec<_> = (0..32).map(|i| format!("Task {i:04} office")).collect();
    labels.push("large unbreakable ".repeat(40));
    labels.push("אבג abc العربية\r\nnext\u{2029}last".into());
    let mut win = Win::recording(
        Page {
            labels,
            fail: false,
        },
        WindowOptions {
            size: [1024, 256],
            ..Default::default()
        },
    )
    .unwrap();
    let p0_token = win.with_scene(|_, token| token).unwrap();
    win.presented(p0_token).unwrap();
    let p0 = capture(&win);
    assert_eq!(
        p0.len(),
        34,
        "canonical geometry includes every clipped sibling"
    );
    win.update(|page| page.labels[0] = "changed office אבג".into())
        .unwrap();
    let c1 = win.with_scene(|_, token| token).unwrap();
    assert_eq!(capture(&win), p0);
    assert!(
        win.update(|page| {
            page.labels[1] = "failed newer العربية".into();
            page.fail = true;
        })
        .is_err()
    );
    assert_eq!(capture(&win), p0);
    assert!(win.presented(p0_token).is_err());
    win.presented(c1).unwrap();
    let p1 = capture(&win);
    assert_eq!(p1[0].0, "changed office אבג");
    assert_eq!(p1[1], p0[1]);
    win.update(|page| page.fail = false).unwrap();
    assert_eq!(capture(&win), p1);
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let p2 = capture(&win);
    assert_eq!(p2[1].0, "failed newer العربية");
}
