//! Borrowed UTF-8 is promoted once and immutable snapshots never alias edits.
use gpui::{Error, WindowOptions, prelude::*};
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
        text(&self.value)
            .name(&self.value)
            .description(&self.value)
            .w(180)
            .h(24)
    }
}
fn contents(win: &Win<Document>) -> (String, String, String) {
    let mut result = None;
    win.visit(|part| {
        result = Some((
            part.text().unwrap().into(),
            part.name().unwrap().into(),
            part.description().unwrap().into(),
        ))
    })
    .unwrap();
    result.unwrap()
}
fn token(win: &Win<Document>) -> gpui::PresentationToken {
    win.with_scene(|_, token| token).unwrap()
}
#[test]
fn exact_sources_share_promotions_through_empty_short_long_and_unicode_pending_frames() {
    for original in [
        "".to_owned(),
        "a".repeat(3),
        "a".repeat(8),
        "a".repeat(23),
        "a".repeat(24),
        "a".repeat(25),
        "a".repeat(256),
        "Café naïve".into(),
    ] {
        let mut win = Win::recording(
            Document {
                value: Signal::new(original.clone()),
            },
            WindowOptions {
                size: [200, 80],
                ..Default::default()
            },
        )
        .unwrap();
        let old = token(&win);
        win.presented(old).unwrap();
        win.reset_counters().unwrap();
        win.set(Document::VALUE, original.clone()).unwrap();
        assert_eq!(win.counters().text_promotions, 0);
        assert_eq!(win.counters().paint_passes, 0);
        let next = format!("{original}z");
        win.reset_counters().unwrap();
        win.set(Document::VALUE, next.clone()).unwrap();
        let counts = win.counters();
        assert_eq!(counts.source_reads, 1);
        assert_eq!(counts.destination_compares, 3);
        assert_eq!(counts.text_promotions, 1);
        assert_eq!(counts.text_bytes_copied, next.len() as u64);
        assert_eq!(
            contents(&win),
            (original.clone(), original.clone(), original)
        );
        let pending = token(&win);
        assert_ne!(pending, old);
        assert_eq!(win.presented(old), Err(Error::StalePresentation));
        win.presented(pending).unwrap();
        assert_eq!(contents(&win), (next.clone(), next.clone(), next));
    }
}
#[test]
fn a_failed_unicode_visual_candidate_cannot_rewrite_old_names_and_value() {
    let mut win = Win::recording(
        Document {
            value: Signal::new("Before".into()),
        },
        WindowOptions {
            size: [200, 80],
            ..Default::default()
        },
    )
    .unwrap();
    let old = token(&win);
    win.presented(old).unwrap();
    assert!(matches!(
        win.set(Document::VALUE, "\u{05d0}".into()),
        Err(gpui::SetError::Committed {
            error: Error::Canvas(_),
            ..
        })
    ));
    assert_eq!(token(&win), old);
    assert_eq!(
        contents(&win),
        ("Before".into(), "Before".into(), "Before".into())
    );
    win.set(Document::VALUE, "Café".into()).unwrap();
    win.presented(token(&win)).unwrap();
    assert_eq!(
        contents(&win),
        ("Café".into(), "Café".into(), "Café".into())
    );
}
