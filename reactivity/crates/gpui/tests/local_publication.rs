use gpui::{prelude::*, *};

const LIST: ListId = ListId::new(73);
struct Page {
    label: Signal<String>,
    offset: Signal<f64>,
    after: bool,
    clipped: bool,
}
impl Page {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
    const OFFSET: Source<Self, f64> =
        Source::new(FieldId::new(2), "offset", |m| &m.offset, |m| &mut m.offset);
}
impl ItemSource for Page {
    fn len(&self) -> usize {
        100_000
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64 + 1)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get().checked_sub(1)?)
            .ok()
            .filter(|i| *i < self.len())
    }
    fn row(&self, index: usize) -> El<'_> {
        text(format!("row {index:06}")).w(180).h(24)
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL).direct(Self::OFFSET)
    }
    fn view(&self) -> El<'_> {
        let label = text(&self.label).w(180).h(24).name("changing");
        let list = uniform_list(LIST, self, 24)
            .overscan(2)
            .scroll_offset(&self.offset)
            .w(180)
            .h(72);
        let items = if self.after {
            column((list, label))
        } else {
            column((label, list))
        };
        items
            .child(text("Count: 0123456789").w(180).h(24))
            .w(192)
            .h(144)
            .clipped(self.clipped)
            .transform(Affine::translation(3., 2.))
    }
}
fn window(label: &str, after: bool, clipped: bool) -> Win<Page> {
    Win::recording(
        Page {
            label: Signal::new(label.into()),
            offset: Signal::new(48.),
            after,
            clipped,
        },
        WindowOptions {
            size: [210, 160],
            ..Default::default()
        },
    )
    .unwrap()
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
}
fn pixels<M: View + 'static>(win: &mut Win<M>) -> Vec<u8> {
    win.with_pixels(|p, _, _| p.to_vec()).unwrap()
}
type TextSnapshot = (String, Rect, Vec<(usize, usize, Rect)>);
fn text_state<M: View + 'static>(win: &Win<M>) -> Vec<TextSnapshot> {
    let mut result = Vec::new();
    win.visit(|part| {
        if let Some(value) = part.text() {
            let geometry = part.text_geometry().unwrap();
            result.push((
                value.into(),
                part.bounds(),
                geometry
                    .layout()
                    .graphemes()
                    .map(|g| {
                        let range = g.text_range();
                        (
                            range.start.byte(),
                            range.end.byte(),
                            geometry.bounds(g.bounds()).unwrap(),
                        )
                    })
                    .collect(),
            ));
        }
    })
    .unwrap();
    result
}

#[test]
fn exact_text_keeps_list_identity_and_old_geometry_until_ack() {
    for after in [false, true] {
        for clipped in [false, true] {
            let mut win = window("Count: 10", after, clipped);
            ack(&mut win);
            let target = win.query().name("changing").one().unwrap();
            let list = win.list(LIST).unwrap();
            let item = win.list_item(list, ItemKey::new(3)).unwrap();
            for value in ["Count: 11", "Count: 12", "Count: 10"] {
                let before = text_state(&win);
                win.set(Page::LABEL, value.into()).unwrap();
                assert_eq!(text_state(&win), before, "P changed before ACK");
                let mut retained = false;
                win.visit(|part| retained |= part.target() == item).unwrap();
                assert!(retained, "old P lost its list item before ACK");
                let mut full = window(value, after, clipped);
                assert_eq!(pixels(&mut win), pixels(&mut full));
                ack(&mut win);
                ack(&mut full);
                assert_eq!(text_state(&win), text_state(&full));
                assert_eq!(win.query().name("changing").one().unwrap(), target);
                assert_eq!(win.list_item(list, ItemKey::new(3)).unwrap(), item);
            }
        }
    }
}

#[test]
fn coalesced_new_glyphs_resize_and_list_retirement_keep_complete_outputs() {
    let mut win = window("Count: 10", true, false);
    ack(&mut win);
    let old = text_state(&win);
    for value in ["Count: 11", "Count: 12", "new Ω text with more glyphs"] {
        win.set(Page::LABEL, value.into()).unwrap();
        assert_eq!(text_state(&win), old);
        let mut full = window(value, true, false);
        assert_eq!(pixels(&mut win), pixels(&mut full));
    }
    ack(&mut win);
    let list = win.list(LIST).unwrap();
    let retired = win.list_item(list, ItemKey::new(3)).unwrap();
    win.set(Page::OFFSET, 4800.).unwrap();
    ack(&mut win);
    assert!(win.bounds(retired).is_err());
    win.resize([220, 170]).unwrap();
    ack(&mut win);
    win.set(Page::LABEL, "Count: 13".into()).unwrap();
    let mut full = window("Count: 13", true, false);
    full.set(Page::OFFSET, 4800.).unwrap();
    full.resize([220, 170]).unwrap();
    assert_eq!(pixels(&mut win), pixels(&mut full));
    ack(&mut win);
    ack(&mut full);
    assert_eq!(text_state(&win), text_state(&full));
}

struct Decorated {
    label: Signal<String>,
    cover: Image,
    rounded: bool,
    scrolled: bool,
    broken: bool,
}
impl Decorated {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
}
impl View for Decorated {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL)
    }
    fn view(&self) -> El<'_> {
        let label = text(&self.label).w(180).h(24).name("changing");
        let label = if self.scrolled {
            div()
                .child(label)
                .scroll(Axis::X)
                .w(120)
                .h(24)
                .name("scroll")
        } else {
            label
        };
        column((
            label,
            text("Count: 0123456789").w(180).h(24),
            image(&self.cover).size(12),
            div()
                .size(1)
                .rounded(if self.broken { f32::NAN } else { 0. }),
        ))
        .w(192)
        .h(90)
        .rounded(if self.rounded { 8. } else { 0. })
        .clipped(self.rounded)
        .transform(Affine::translation(3., 2.))
    }
}
fn decorated(value: &str, rounded: bool, scrolled: bool) -> Win<Decorated> {
    Win::recording(
        Decorated {
            label: Signal::new(value.into()),
            rounded,
            scrolled,
            broken: false,
            cover: Image::rgba8(
                1,
                1,
                ImageProfile::Srgb,
                AlphaMode::Straight,
                vec![20, 90, 180, 127].into_boxed_slice(),
            )
            .unwrap(),
        },
        WindowOptions {
            size: [210, 110],
            ..Default::default()
        },
    )
    .unwrap()
}
#[test]
fn image_clip_and_scroller_preserve_older_candidate_after_newer_failure() {
    for rounded in [false, true] {
        for scrolled in [false, true] {
            let mut win = decorated("Count: 10", rounded, scrolled);
            ack(&mut win);
            let before = text_state(&win);
            win.set(Decorated::LABEL, "Count: 11".into()).unwrap();
            let eligible = win.with_scene(|_, token| token).unwrap();
            let candidate_pixels = pixels(&mut win);
            assert_eq!(text_state(&win), before);
            assert!(
                win.update(|m| {
                    *m.label = "Count: 12".into();
                    m.broken = true;
                })
                .is_err()
            );
            assert_eq!(text_state(&win), before);
            assert_eq!(pixels(&mut win), candidate_pixels);
            win.presented(eligible).unwrap();
            let mut full = decorated("Count: 11", rounded, scrolled);
            assert_eq!(pixels(&mut win), pixels(&mut full));
            ack(&mut full);
            assert_eq!(text_state(&win), text_state(&full));
            assert_eq!(
                win.with_scene(|scene, _| scene.images().count()).unwrap(),
                1
            );
        }
    }
}
