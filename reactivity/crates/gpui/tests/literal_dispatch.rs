//! Explicitly erased operands keep the same public binding/admission contract.
use gpui::{
    Error, IntoProp, PropInput, SetError, WindowOptions,
    prelude::*,
    property::{BACKGROUND, Contribution, FONT_SIZE, HEIGHT, PropertyErrorKind, WIDTH},
};

struct Panel {
    number: Signal<u64>,
    color: Signal<Color>,
    literal: bool,
}
impl Panel {
    const NUMBER: Source<Self, u64> =
        Source::new(FieldId::new(1), "number", |m| &m.number, |m| &mut m.number);
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(2), "color", |m| &m.color, |m| &mut m.color);
    fn new() -> Self {
        Self {
            number: Signal::new(24),
            color: Signal::new(Color::BLACK),
            literal: false,
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::NUMBER).direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        let size: PropInput<'_, f64> = if self.literal {
            24_u64.into_prop()
        } else {
            (&self.number).into_prop()
        };
        let color: PropInput<'_, Color> = if self.literal {
            Color::WHITE.into_prop()
        } else {
            (&self.color).into_prop()
        };
        div()
            .name("panel")
            .size(size)
            .font_size(size)
            .bg(color)
            .child(text(&self.number))
    }
}
fn ack(win: &mut Win<Panel>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}

#[test]
fn erased_size_keeps_two_sinks_latest_inspector_base_and_literal_edge_removal() {
    let mut win = Win::with_size(Panel::new(), 120, 80).unwrap();
    let target = win.query().name("panel").one().unwrap();
    win.set_property(target, WIDTH, Contribution::Set(gpui::Length::Points(40.0)))
        .unwrap();
    win.reset_counters().unwrap();
    win.set(Panel::NUMBER, 32).unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(40.0)
    );
    assert_eq!(
        win.property(target, HEIGHT).unwrap(),
        gpui::Length::Points(32.0)
    );
    assert_eq!(win.property(target, FONT_SIZE).unwrap(), 32.0);
    assert!(win.find_text("32").is_ok());
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().destination_compares, 4);
    assert_eq!(win.counters().owner_reruns, 0);
    win.set_property(target, WIDTH, Contribution::Inherit)
        .unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(32.0)
    );

    win.update(|m| m.literal = true).unwrap();
    win.reset_counters().unwrap();
    win.set(Panel::NUMBER, 48).unwrap();
    win.set(Panel::COLOR, Color::BLACK).unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(24.0)
    );
    assert_eq!(
        win.property(target, HEIGHT).unwrap(),
        gpui::Length::Points(24.0)
    );
    assert_eq!(win.property(target, FONT_SIZE).unwrap(), 24.0);
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        Color::WHITE
    );
    assert!(win.find_text("48").is_ok());
    assert_eq!(
        win.counters().destination_compares,
        1,
        "only text remains bound"
    );
}

#[test]
fn erased_numeric_failure_preserves_every_sink_and_the_pending_cohort() {
    let mut win = Win::recording(
        Panel::new(),
        WindowOptions {
            size: [120, 80],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let old = win.snapshot().unwrap();
    win.set(Panel::NUMBER, 28).unwrap();
    let candidate = win.with_scene(|_, token| token).unwrap();
    let digest = win.scene_digest().unwrap();
    assert!(matches!(win.set(Panel::NUMBER, 0),
        Err(SetError::Committed { error: Error::Property(error), .. })
            if error.property == FONT_SIZE.id() && error.reason == PropertyErrorKind::NonPositive));
    assert_eq!(*win.root().unwrap().number, 0);
    assert_eq!(win.with_scene(|_, token| token).unwrap(), candidate);
    assert_eq!(win.scene_digest().unwrap(), digest);
    assert_eq!(win.snapshot().unwrap().nodes, old.nodes);
    win.presented(candidate).unwrap();
    // Frozen diagnostics can inspect the acknowledged older cohort; minting a
    // current interaction target still rejects the newer invalid logical state.
    assert!(
        win.snapshot()
            .unwrap()
            .nodes
            .iter()
            .any(|node| node.text.as_deref() == Some("28"))
    );
    win.set(Panel::NUMBER, 36).unwrap();
    ack(&mut win);
    assert!(win.find_text("36").is_ok());
}
