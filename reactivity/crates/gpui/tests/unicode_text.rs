//! Unicode is exercised through the same retained owner/ports as ordinary text.
use gpui::prelude::*;

struct Document {
    value: Signal<String>,
}
impl Document {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Document {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((text(&self.value), text_input(&self.value)))
            .w(300)
            .gap(8)
    }
}
fn make(value: &str) -> Win<Document> {
    Win::with_size(
        Document {
            value: Signal::new(value.into()),
        },
        320,
        240,
    )
    .unwrap()
}
fn pixels(win: &mut Win<Document>) -> Vec<u8> {
    win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap()
}
#[test]
fn mixed_bidi_and_crlf_ports_match_a_fresh_owner_after_exact_edit() {
    let mut retained = make("");
    let input = retained.input();
    let source = "Hello Ελληνικά नमस्ते\r\nالعربية אבג 123\r\n";
    retained.reset_counters().unwrap();
    retained.type_text(input, source).unwrap();
    assert_eq!(
        retained
            .with_model(|model| model.value.as_str().to_owned())
            .unwrap(),
        source
    );
    assert_eq!(retained.counters().owner_reruns, 0);
    assert_eq!(retained.role(gpui::Role::TextInput).one().unwrap(), input);
    let mut fresh = make(source);
    assert_eq!(pixels(&mut retained), pixels(&mut fresh));
    let mut found = false;
    retained
        .visit(|part| found |= part.value() == Some(source))
        .unwrap();
    assert!(found);
}
#[test]
fn absent_font_coverage_preserves_old_pixels_and_recovers_without_retargeting() {
    let mut win = make("Ready");
    let input = win.input();
    let old = pixels(&mut win);
    assert!(win.set(Document::VALUE, "漢".into()).is_err());
    assert_eq!(
        win.with_model(|model| model.value.as_str().to_owned())
            .unwrap(),
        "漢"
    );
    assert_eq!(pixels(&mut win), old);
    win.set(Document::VALUE, "Ελληνικά\r\nעברית".into())
        .unwrap();
    assert_eq!(win.input(), input);
    let mut fresh = make("Ελληνικά\r\nעברית");
    assert_eq!(pixels(&mut win), pixels(&mut fresh));
}
