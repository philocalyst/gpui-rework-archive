use gpui::{LaneSet, Remote, WindowOptions, prelude::*};
struct Page {
    values: [Signal<String>; 4],
    auto: bool,
}
impl Page {
    const F: [Source<Self, String>; 4] = [
        Source::new(FieldId::new(1), "a", |m| &m.values[0], |m| &mut m.values[0]),
        Source::new(FieldId::new(2), "b", |m| &m.values[1], |m| &mut m.values[1]),
        Source::new(FieldId::new(3), "c", |m| &m.values[2], |m| &mut m.values[2]),
        Source::new(FieldId::new(4), "d", |m| &m.values[3], |m| &mut m.values[3]),
    ];
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::F[0])
            .direct(Self::F[1])
            .direct(Self::F[2])
            .direct(Self::F[3])
    }
    fn view(&self) -> El<'_> {
        if self.auto {
            return row(self.values.iter().map(text))
                .w(192)
                .h(112)
                .bg(Color::WHITE);
        }
        column(self.values.iter().map(|v| text(v).w(180).h(24)))
            .w(192)
            .h(112)
            .bg(Color::WHITE)
    }
}
fn ack<L: LaneSet<Page>>(win: &mut Win<Page, L>) {
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
}
fn fresh(values: [&str; 4]) -> Win<Page> {
    let mut win = Win::recording(
        Page {
            values: values.map(|v| Signal::new(v.to_owned())),
            auto: false,
        },
        WindowOptions {
            size: [192, 112],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
fn open() -> (Win<Page, impl LaneSet<Page>>, [Remote<String>; 4]) {
    let win = fresh(["11", "22", "33", "44"]);
    let (a, ai) = Remote::bounded(4);
    let (b, bi) = Remote::bounded(4);
    let (c, ci) = Remote::bounded(4);
    let (d, di) = Remote::bounded(4);
    (
        win.with_inbox_for(ai, Page::F[0], |v, n| *v = n)
            .unwrap()
            .with_inbox_for(bi, Page::F[1], |v, n| *v = n)
            .unwrap()
            .with_inbox_for(ci, Page::F[2], |v, n| *v = n)
            .unwrap()
            .with_inbox_for(di, Page::F[3], |v, n| *v = n)
            .unwrap(),
        [a, b, c, d],
    )
}
type Geometry = Vec<(String, Vec<(usize, usize, gpui::Rect)>)>;
fn geometry<L: LaneSet<Page>>(win: &Win<Page, L>) -> Geometry {
    let mut result = Vec::new();
    win.visit(|part| {
        if let Some(value) = part.text() {
            let g = part.text_geometry().unwrap();
            result.push((
                value.to_owned(),
                g.layout()
                    .graphemes()
                    .map(|u| {
                        let r = u.text_range();
                        (r.start.byte(), r.end.byte(), g.bounds(u.bounds()).unwrap())
                    })
                    .collect(),
            ));
        }
    })
    .unwrap();
    result
}
fn oracle<L: LaneSet<Page>>(win: &mut Win<Page, L>, values: [&str; 4]) {
    let mut full = fresh(values);
    assert_eq!(geometry(win), geometry(&full));
    assert_eq!(
        win.with_pixels(|p, _, _| p.to_vec()).unwrap(),
        full.with_pixels(|p, _, _| p.to_vec()).unwrap()
    );
}
#[test]
fn two_and_four_row_batches_publish_exact_values_pixels_and_interaction_geometry() {
    for count in [2, 4] {
        let (mut win, remotes) = open();
        let before = geometry(&win);
        let values = if count == 2 {
            ["22", "11", "33", "44"]
        } else {
            ["44", "33", "22", "11"]
        };
        for (r, v) in remotes.iter().zip(values).take(count) {
            r.try_send(v.into()).unwrap();
        }
        win.deliver_ready(8).unwrap();
        assert_eq!(
            geometry(&win),
            before,
            "unacknowledged text geometry belongs to the preceding scene"
        );
        ack(&mut win);
        oracle(&mut win, values);
        let fallback = ["a longer label", "new glyph z", "", "4"];
        for (r, v) in remotes.iter().zip(fallback) {
            r.try_send(v.into()).unwrap();
        }
        win.deliver_ready(8).unwrap();
        ack(&mut win);
        oracle(&mut win, fallback);
    }
}
#[test]
fn older_sparse_batch_can_ack_after_a_newer_batch_fails_to_prepare() {
    let (mut win, remotes) = open();
    remotes[0].try_send("22".into()).unwrap();
    remotes[1].try_send("11".into()).unwrap();
    win.deliver_ready(8).unwrap();
    let eligible = win.with_scene(|_, t| t).unwrap();
    remotes[0].try_send("漢".into()).unwrap();
    remotes[1].try_send("bad".into()).unwrap();
    assert_eq!(
        win.deliver_ready(8).unwrap_err().delivery.unwrap().applied,
        2
    );
    win.presented(eligible).unwrap();
    oracle(&mut win, ["22", "11", "33", "44"]);
    remotes[0].try_send("33".into()).unwrap();
    remotes[1].try_send("44".into()).unwrap();
    win.deliver_ready(8).unwrap();
    ack(&mut win);
    oracle(&mut win, ["33", "44", "33", "44"]);
}

#[test]
fn batched_intrinsic_size_changes_move_unchanged_following_content() {
    let make = |values: [&str; 4]| {
        let mut win = Win::recording(
            Page {
                values: values.map(|v| Signal::new(v.into())),
                auto: true,
            },
            WindowOptions {
                size: [192, 112],
                ..Default::default()
            },
        )
        .unwrap();
        ack(&mut win);
        win
    };
    let win = make(["ii", "ii", "iii", "WWW"]);
    let (a, ai) = Remote::bounded(2);
    let (b, bi) = Remote::bounded(2);
    let mut win = win
        .with_inbox_for(ai, Page::F[0], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(bi, Page::F[1], |v, n| *v = n)
        .unwrap();
    for value in ["WW", "ii", "Wi"] {
        a.try_send(value.into()).unwrap();
        b.try_send(value.into()).unwrap();
        win.deliver_ready(4).unwrap();
        ack(&mut win);
        let mut full = make([value, value, "iii", "WWW"]);
        assert_eq!(geometry(&win), geometry(&full));
        assert_eq!(
            win.with_pixels(|p, _, _| p.to_vec()).unwrap(),
            full.with_pixels(|p, _, _| p.to_vec()).unwrap()
        );
    }
}
