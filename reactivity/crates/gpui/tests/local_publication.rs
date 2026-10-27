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
            vec![list, label]
        } else {
            vec![label, list]
        };
        column(items)
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
fn ack(win: &mut Win<Page>) {
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
}
fn pixels(win: &mut Win<Page>) -> Vec<u8> {
    win.with_pixels(|p, _, _| p.to_vec()).unwrap()
}
type TextSnapshot = (String, Rect, Vec<(usize, usize, Rect)>);
fn text_state(win: &Win<Page>) -> Vec<TextSnapshot> {
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
                assert_eq!(win.list_item(list, ItemKey::new(3)).unwrap(), item);
                let mut full = window(value, after, clipped);
                assert_eq!(pixels(&mut win), pixels(&mut full));
                ack(&mut win);
                ack(&mut full);
                assert_eq!(text_state(&win), text_state(&full));
                assert_eq!(win.query().name("changing").one().unwrap(), target);
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
