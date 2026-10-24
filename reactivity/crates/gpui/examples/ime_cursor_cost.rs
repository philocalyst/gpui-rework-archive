//! Ordinary cursor updates with a long prefix and a tiny Unicode preedit.
//! Run both source variants with the same CPU, loader and feature profile.
use gpui::*;
use std::{hint::black_box, time::Instant};

struct Input(Signal<String>);
impl Input {
    const VALUE: Source<Self, String> = Source::new(
        FieldId::new(1),
        "value",
        |model| &model.0,
        |model| &mut model.0,
    );
}
impl View for Input {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        text_input(&self.0).w(300)
    }
}
fn acknowledge(win: &mut Win<Input>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn position(byte: usize) -> TextPosition {
    TextPosition {
        offset: TextOffset::new(byte).unwrap(),
        affinity: CaretAffinity::Downstream,
    }
}
#[inline(never)]
fn preedit(win: &mut Win<Input>, session: &mut ImeSession, cursor: usize) {
    black_box(
        win.ime_event(
            session,
            ImeEvent::Preedit {
                text: "\u{301}",
                cursor: Some((cursor, cursor)),
            },
        )
        .unwrap(),
    );
}
fn main() {
    for (label, length, unicode) in [
        ("short_ascii", 24, false),
        ("ascii_4k", 4096, false),
        ("ascii_32k", 32767, false),
        ("unicode_32k", 32767, true),
    ] {
        let mut source = "a".repeat(length);
        if unicode {
            source.replace_range(..2, "é");
        }
        let mut win =
            Win::recording(Input(Signal::new(source.clone())), WindowOptions::default()).unwrap();
        acknowledge(&mut win);
        let target = win.input();
        win.focus(target).unwrap();
        let start = length - 8;
        win.select(
            target,
            TextSelection {
                anchor: position(start),
                focus: position(start + 1),
            },
        )
        .unwrap();
        acknowledge(&mut win);
        let epoch = win.snapshot().unwrap().source_epoch;
        let mut session = ImeSession::default();
        win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        preedit(&mut win, &mut session, 0);
        acknowledge(&mut win);
        for index in 0..32 {
            preedit(&mut win, &mut session, (index % 2) * 2);
        }
        let iterations = if length < 4096 { 2000 } else { 100 };
        let mut samples = Vec::new();
        for _ in 0..9 {
            let started = Instant::now();
            for index in 0..iterations {
                preedit(&mut win, &mut session, (index % 2) * 2);
            }
            samples.push(started.elapsed().as_nanos() / iterations as u128);
        }
        acknowledge(&mut win);
        assert_eq!(win.read(Input::VALUE).unwrap(), &source);
        assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
        let mut expected = source.clone();
        expected.replace_range(start..start + 1, "\u{301}");
        let mut found = false;
        win.visit(|part| {
            if part.target() == target {
                assert!(!found);
                found = true;
                assert_eq!(part.value(), Some(expected.as_str()));
                let marked = part.marked_text().unwrap();
                assert_eq!(marked.range, start..start + 2);
                assert_eq!(marked.cursor, Some(start + 2..start + 2));
                assert_eq!(part.selection().unwrap().focus, position(start + 2));
            }
        })
        .unwrap();
        assert!(found);
        println!(
            "IME_CURSOR_COST,{}",
            serde_json::json!({
                "case": label,
                "source_bytes": length,
                "iterations": iterations,
                "samples_ns": samples,
                "model_and_display_validated": true,
                "scope": "ordinary recording call; no native rasterization or scanout",
            })
        );
        win.close();
    }
}
