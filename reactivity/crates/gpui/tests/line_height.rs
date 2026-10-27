use gpui::{
    ImeEvent, ImeSession, TextSelection, WindowOptions,
    prelude::*,
    property::{Contribution, LINE_HEIGHT},
};

struct Page {
    value: Signal<String>,
    pitch: Signal<f64>,
    editing: bool,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    const PITCH: Source<Self, f64> =
        Source::new(FieldId::new(2), "pitch", |m| &m.pitch, |m| &mut m.pitch);
    fn new(pitch: f64, editing: bool) -> Self {
        Self {
            value: Signal::new("one\ntwo\nthree".into()),
            pitch: Signal::new(pitch),
            editing,
        }
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).direct(Self::PITCH)
    }
    fn view(&self) -> El<'_> {
        column((
            if self.editing {
                text_input(&self.value)
            } else {
                text(&self.value)
            }
            .w(180)
            .h(160)
            .font_size(14)
            .line_height(&self.pitch)
            .name("paragraph"),
            text("unchanged").font_size(14),
        ))
        .w(200)
        .h(220)
        .bg(rgb(0xffffff))
    }
}
fn ack(win: &mut Win<Page>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn window(pitch: f64, editing: bool) -> Win<Page> {
    let mut win = Win::recording(
        Page::new(pitch, editing),
        WindowOptions {
            size: [200, 220],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
fn pixels(win: &mut Win<Page>) -> Vec<u8> {
    win.with_pixels(|p, _, _| p.to_vec()).unwrap()
}
fn lines(win: &Win<Page>) -> Vec<(gpui::Rect, f32)> {
    let mut result = Vec::new();
    win.visit(|part| {
        if part.name() == Some("paragraph") {
            result = part
                .text_geometry()
                .unwrap()
                .layout()
                .lines()
                .map(|l| (l.bounds(), l.baseline()))
                .collect();
        }
    })
    .unwrap();
    result
}

#[test]
fn source_and_override_line_pitch_match_fresh_pixels_and_acknowledged_geometry() {
    let mut win = window(20., false);
    let target = win.query().name("paragraph").one().unwrap();
    for pitch in [28., 12., 31.5, 20.] {
        let old = lines(&win);
        win.set(Page::PITCH, pitch).unwrap();
        assert_eq!(lines(&win), old, "pending geometry remains at P");
        let mut fresh = window(pitch, false);
        assert_eq!(pixels(&mut win), pixels(&mut fresh));
        ack(&mut win);
        assert_eq!(lines(&win), lines(&fresh));
        assert_eq!(
            win.property(target, LINE_HEIGHT).unwrap(),
            Some(pitch as f32)
        );
    }
    win.set_property(target, LINE_HEIGHT, Contribution::Set(None))
        .unwrap();
    ack(&mut win);
    let normal = pixels(&mut win);
    win.set(Page::PITCH, 40.).unwrap();
    ack(&mut win);
    assert_eq!(win.property(target, LINE_HEIGHT).unwrap(), None);
    assert_eq!(
        pixels(&mut win),
        normal,
        "explicit normal masks source pitch"
    );
    win.set_property(target, LINE_HEIGHT, Contribution::Inherit)
        .unwrap();
    ack(&mut win);
    let mut fresh = window(40., false);
    assert_eq!(pixels(&mut win), pixels(&mut fresh));
    assert_eq!(lines(&win), lines(&fresh));
    // Force a full owner description after the exact source path.
    win.update(|_| {}).unwrap();
    ack(&mut win);
    assert_eq!(pixels(&mut win), pixels(&mut fresh));
}

#[test]
fn sparse_text_and_ime_use_the_same_explicit_pitch() {
    let mut win = window(28., false);
    win.set(Page::VALUE, "two\none\nthree".into()).unwrap();
    let mut model = Page::new(28., false);
    *model.value = "two\none\nthree".into();
    let mut fresh = Win::recording(
        model,
        WindowOptions {
            size: [200, 220],
            ..Default::default()
        },
    )
    .unwrap();
    assert_eq!(pixels(&mut win), pixels(&mut fresh));
    ack(&mut win);
    ack(&mut fresh);
    assert_eq!(lines(&win), lines(&fresh));

    let mut input = window(20., true);
    let target = input.query().name("paragraph").one().unwrap();
    input.focus(target).unwrap();
    ack(&mut input);
    input
        .select(target, TextSelection::caret(4).unwrap())
        .unwrap();
    ack(&mut input);
    let mut session = ImeSession::default();
    input.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    let before = input.ime_cursor_area(&session).unwrap().unwrap();
    input.set(Page::PITCH, 40.).unwrap();
    ack(&mut input);
    let after = input.ime_cursor_area(&session).unwrap().unwrap();
    assert!(after.y > before.y);
    input
        .ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "X",
                cursor: Some((1, 1)),
            },
        )
        .unwrap();
    ack(&mut input);
    let geometry = lines(&input);
    assert_eq!(geometry[1].1, geometry[0].1 + 40.);
    input
        .ime_event(&mut session, ImeEvent::Commit("X"))
        .unwrap();
    ack(&mut input);
    assert_eq!(
        input.read(Page::VALUE).unwrap().as_str(),
        "one\nXtwo\nthree"
    );
    assert_eq!(lines(&input), geometry);
}

#[test]
fn schema_rejects_invalid_pitch_and_keeps_normal_distinct_from_inherit() {
    let mut style = gpui::Style::default();
    assert_eq!(LINE_HEIGHT.get(&style), None);
    for bad in [0., -0., -1., f32::NAN, f32::INFINITY] {
        assert!(LINE_HEIGHT.set(&mut style, Some(bad)).is_err());
        assert_eq!(LINE_HEIGHT.get(&style), None);
    }
    LINE_HEIGHT.set(&mut style, Some(20.)).unwrap();
    assert_eq!(LINE_HEIGHT.get(&style), Some(20.));
    LINE_HEIGHT.set(&mut style, None).unwrap();
    assert_eq!(LINE_HEIGHT.get(&style), None);
    eprintln!("style_bytes={}", std::mem::size_of::<gpui::Style>());
}
