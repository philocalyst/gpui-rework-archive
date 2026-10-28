//! Public acknowledged text/geometry witnesses for reusable publication storage.
use gpui::*;
struct Page {
    value: Signal<String>,
    other: Signal<String>,
    invalid: bool,
    show: bool,
    reverse: bool,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    const OTHER: Source<Self, String> =
        Source::new(FieldId::new(2), "other", |m| &m.other, |m| &mut m.other);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).direct(Self::OTHER)
    }
    fn view(&self) -> El<'_> {
        let values = if self.reverse {
            [&self.other, &self.value]
        } else {
            [&self.value, &self.other]
        };
        column(
            values
                .into_iter()
                .take(if self.show { 2 } else { 0 })
                .map(|v| text(v).font_size(12).w(160).h(28)),
        )
        .w(192)
        .h(80)
        .bg(Color::WHITE)
        .fg(Color::BLACK)
        .rounded(if self.invalid { f32::NAN } else { 0. })
    }
}
fn window(value: &str, other: &str) -> Win<Page> {
    Win::recording(
        Page {
            value: Signal::new(value.into()),
            other: Signal::new(other.into()),
            invalid: false,
            show: true,
            reverse: false,
        },
        WindowOptions {
            size: [192, 80],
            ..Default::default()
        },
    )
    .unwrap()
}
fn ack(win: &mut Win<Page>) -> PresentationToken {
    let t = win.with_scene(|_, t| t).unwrap();
    win.presented(t).unwrap();
    t
}
fn capture(win: &Win<Page>) -> Vec<(String, usize)> {
    let mut values = Vec::new();
    win.visit(|part| {
        if let Some(text) = part.text() {
            values.push((
                text.to_owned(),
                part.text_geometry().unwrap().layout().text_len(),
            ));
        }
    })
    .unwrap();
    values
}
fn pixels_match_fresh(win: &mut Win<Page>, value: &str, other: &str) {
    let mut full = window(value, other);
    assert!(
        win.with_pixels(|p, _, _| p.to_vec()).unwrap()
            == full.with_pixels(|p, _, _| p.to_vec()).unwrap()
    );
}
#[test]
fn sparse_then_full_candidate_ack_does_not_replay_retired_payload() {
    let mut win = window("0000", "0123456789");
    ack(&mut win);
    for tick in 0..4 {
        let previous = capture(&win);
        win.set(Page::VALUE, "1111".into()).unwrap();
        assert_eq!(capture(&win), previous);
        let value = if tick % 2 == 0 { "2222" } else { "3333" }.to_owned();
        let other = format!("0123456789{tick}");
        win.update(|m| {
            *m.value = value.clone();
            *m.other = other.clone();
        })
        .unwrap();
        pixels_match_fresh(&mut win, &value, &other);
        let token = ack(&mut win);
        assert_eq!(
            capture(&win),
            vec![(value.clone(), value.len()), (other.clone(), other.len())],
            "full supersession replayed a retired sparse payload"
        );
        win.presented(token).unwrap();
        assert_eq!(
            capture(&win),
            vec![(value.clone(), value.len()), (other.clone(), other.len())]
        );
    }
}
#[test]
fn reuse_preserves_failed_newer_older_ack_reorder_and_removal() {
    let mut win = window("0000", "reservoir");
    ack(&mut win);
    for value in ["1111", "222222", "222222", "0000\u{200b}"] {
        win.set(Page::VALUE, value.into()).unwrap();
        pixels_match_fresh(&mut win, value, "reservoir");
        let token = ack(&mut win);
        win.presented(token).unwrap();
        assert_eq!(capture(&win)[0], (value.into(), value.len()));
    }
    win.set(Page::VALUE, "eligible".into()).unwrap();
    let eligible = win.with_scene(|_, t| t).unwrap();
    let before = capture(&win);
    assert!(win.update(|m| m.invalid = true).is_err());
    assert_eq!(capture(&win), before);
    assert_eq!(win.with_scene(|_, t| t).unwrap(), eligible);
    win.presented(eligible).unwrap();
    assert_eq!(capture(&win)[0], ("eligible".into(), 8));
    win.update(|m| {
        m.invalid = false;
        m.reverse = true;
    })
    .unwrap();
    ack(&mut win);
    assert_eq!(
        capture(&win),
        vec![("reservoir".into(), 9), ("eligible".into(), 8)]
    );
    win.set(Page::VALUE, "after reorder".into()).unwrap();
    ack(&mut win);
    assert_eq!(capture(&win)[1], ("after reorder".into(), 13));
    win.update(|m| m.show = false).unwrap();
    ack(&mut win);
    assert!(capture(&win).is_empty());
    win.update(|m| {
        m.show = true;
        *m.value = "remounted".into();
    })
    .unwrap();
    ack(&mut win);
    assert_eq!(capture(&win)[1], ("remounted".into(), 9));
}
