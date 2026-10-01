//! Independent differential checks for composition at byte and chunk boundaries.
use gpui_ce_elements::rich_text::{
    Affinity, Change, ChangeSet, Document, InlineStyle, RangeSet, RichText, Selection, Span,
};

#[test]
fn every_valid_pair_of_small_unicode_edits_agrees_with_string_and_inverse() {
    let source = "a😀bé";
    let positions: Vec<_> = source
        .char_indices()
        .map(|(i, _)| i)
        .chain([source.len()])
        .collect();
    let mut accepted = 0;
    for &start_a in &positions {
        for &end_a in positions.iter().filter(|&&end| end >= start_a) {
            for &start_b in &positions {
                for &end_b in positions.iter().filter(|&&end| end >= start_b) {
                    for insert_a in ["", "Q", "界"] {
                        for insert_b in ["", "R", "🦀"] {
                            let original = Document::new(source);
                            let Ok(changes) = ChangeSet::for_document(
                                &original,
                                [
                                    Change::new(start_b..end_b, insert_b),
                                    Change::new(start_a..end_a, insert_a),
                                ],
                            ) else {
                                continue;
                            };
                            let expected = changes.apply_to(source).unwrap();
                            let mut actual = original.clone();
                            actual.apply_changes(&changes).unwrap();
                            assert_eq!(actual.as_str(), expected, "{:?}", changes.changes());
                            assert_eq!(actual.len_utf16(), expected.encode_utf16().count());
                            let inverse = changes.invert(&actual).unwrap();
                            actual.apply_changes(&inverse).unwrap();
                            assert_eq!(actual.as_str(), source, "{:?}", changes.changes());
                            for &position in &positions {
                                for affinity in [Affinity::Before, Affinity::After] {
                                    let mapped = changes.map_position(position, affinity).unwrap();
                                    assert!(expected.is_char_boundary(mapped));
                                }
                            }
                            accepted += 1;
                        }
                    }
                }
            }
        }
    }
    eprintln!("Unicode pair fixture: {accepted} valid edit compositions checked");
    assert!(accepted > 500, "only {accepted} compositions checked");
}

#[test]
fn indexed_ranges_match_linear_half_open_queries() {
    let mut spans = Vec::new();
    for start in 0..24 {
        for end in start..24 {
            spans.push(Span::new(
                start..end,
                Affinity::Before,
                Affinity::After,
                (start, end),
            ));
        }
    }
    spans.reverse();
    let ranges = RangeSet::new(spans);
    for start in 0..=25 {
        for end in start..=25 {
            let mut expected: Vec<_> = ranges
                .iter()
                .filter(|span| {
                    let range = &span.range;
                    if start == end {
                        if range.is_empty() {
                            range.start == start
                        } else {
                            range.start <= start && start < range.end
                        }
                    } else if range.is_empty() {
                        start <= range.start && range.start < end
                    } else {
                        range.start < end && start < range.end
                    }
                })
                .map(|span| *span.value())
                .collect();
            expected.sort_unstable();
            let actual: Vec<_> = ranges.query(start..end).map(|span| *span.value()).collect();
            assert_eq!(actual, expected, "query {start}..{end}");
        }
    }
}

#[test]
fn touching_insertions_replacements_and_deletions_round_trip_as_one_batch() {
    let original = Document::new("a😀bé");
    for prefix in ["", "α"] {
        for left in ["", "界", "a😀"] {
            for right in ["", "🦀", "bé"] {
                for suffix in ["", "ω"] {
                    let edits = [
                        Change::new(8..8, suffix),
                        Change::new(5..8, right),
                        Change::new(0..5, left),
                        Change::new(0..0, prefix),
                    ];
                    let changes = ChangeSet::for_document(&original, edits).unwrap();
                    let mut after = original.clone();
                    after.apply_changes(&changes).unwrap();
                    assert_eq!(after.as_str(), format!("{prefix}{left}{right}{suffix}"));
                    let inverse = changes.invert(&after).unwrap();
                    after.apply_changes(&inverse).unwrap();
                    assert_eq!(after.as_str(), original.as_str());
                }
            }
        }
    }
}

#[test]
fn native_indexes_match_flat_unicode_text_through_chunk_seams_and_edits() {
    let mut flat = "é😀\n界\r\n".repeat(1000);
    let mut document = Document::new(flat.clone());
    for step in 0..20 {
        let start = document.clamp_byte_offset((step * 337 + 2047).min(flat.len()));
        let end = document.clamp_byte_offset((start + 11).min(flat.len()));
        let insert = if step % 2 == 0 { "🦀\n" } else { "e\u{301}" };
        let changes =
            ChangeSet::for_document(&document, [Change::new(start..end, insert)]).unwrap();
        document.apply_changes(&changes).unwrap();
        flat.replace_range(start..end, insert);
        assert_eq!(document.as_str(), flat);
        let mut line_start = 0;
        for (line, text) in flat.split('\n').enumerate() {
            assert_eq!(
                document.line_range(line),
                Some(line_start..line_start + text.len())
            );
            line_start += text.len() + 1;
        }
        let mut utf16 = 0;
        let mut line = 0;
        for (byte, ch) in flat.char_indices() {
            assert_eq!(document.byte_to_utf16(byte), utf16);
            assert_eq!(document.utf16_to_byte(utf16), byte);
            assert_eq!(
                gpui_ce_elements::editable_text::UnicodeTextStorage::utf_offset_8to16(
                    &document, byte
                ),
                utf16
            );
            assert_eq!(
                gpui_ce_elements::editable_text::UnicodeTextStorage::utf_offset_16to8(
                    &document, utf16
                ),
                byte
            );
            assert_eq!(document.line_index(byte), line);
            utf16 += ch.len_utf16();
            line += usize::from(ch == '\n');
        }
        assert_eq!(document.len_utf16(), utf16);
        assert_eq!(document.line_index(flat.len()), line);
    }
}

#[test]
fn snapshots_share_untouched_chunks_and_one_flattened_view_per_revision() {
    let original = Document::new("a".repeat(1 << 20));
    let snapshot = original.clone();
    assert!(original.same_snapshot(&snapshot));
    assert_eq!(original.as_str().as_ptr(), snapshot.as_str().as_ptr());
    let old_chunks: std::collections::HashSet<_> = original
        .chunks()
        .map(|chunk| (chunk.as_ptr() as usize, chunk.len()))
        .collect();
    let changes =
        ChangeSet::for_document(&original, [Change::new(524_288..524_289, "🦀")]).unwrap();
    let mut edited = original.clone();
    edited.apply_changes(&changes).unwrap();
    let shared_chunks = edited
        .chunks()
        .filter(|chunk| old_chunks.contains(&(chunk.as_ptr() as usize, chunk.len())))
        .count();
    eprintln!(
        "retention fixture: original {} chunks, edited {} chunks, shared {shared_chunks}, source {} bytes, result {} bytes",
        old_chunks.len(),
        edited.chunk_count(),
        original.len_bytes(),
        edited.len_bytes()
    );
    assert!(shared_chunks * 100 > old_chunks.len() * 95);
    assert_eq!(snapshot.len_bytes(), 1 << 20);
    assert_eq!(snapshot.slice(524_288..524_289), "a");
    assert_eq!(edited.slice(524_288..524_292), "🦀");
    assert_ne!(edited.as_str().as_ptr(), original.as_str().as_ptr());
    assert_eq!(edited.as_str().as_ptr(), edited.clone().as_str().as_ptr());
}

#[test]
fn editor_dispatch_is_atomic_for_invalid_styles_and_rejects_stale_or_foreign_batches() {
    use gpui::AppContext;
    use gpui_ce_elements::editable_text::EditableTextState;
    use std::sync::Arc;

    let mut app = gpui::HeadlessAppContext::new(Arc::new(gpui::NoopTextSystem::new()));
    let state =
        app.update(|cx| cx.new(|cx| EditableTextState::from_rich_text(RichText::from("a😀b"), cx)));
    let foreign =
        app.update(|cx| cx.new(|cx| EditableTextState::from_rich_text(RichText::from("a😀b"), cx)));
    let stale = app.update(|cx| {
        state
            .read(cx)
            .transaction()
            .replace(0..1, "!")
            .build()
            .unwrap()
    });
    let foreign_batch = app.update(|cx| {
        foreign
            .read(cx)
            .transaction()
            .replace(0..1, "!")
            .build()
            .unwrap()
    });

    app.update(|cx| {
        state.update(cx, |state, cx| {
            let transaction = state
                .transaction()
                .replace(1..5, "界")
                .selection(Selection::new(4, 1))
                .build()
                .unwrap();
            let invalid = RangeSet::new([Span::new(
                2..4,
                Affinity::Before,
                Affinity::After,
                InlineStyle::default().bold(),
            )]);
            assert!(
                state
                    .dispatch_with_styles(&transaction, invalid, cx)
                    .is_err()
            );
            assert_eq!(state.as_str(), "a😀b");
            assert_eq!(state.revision(), 0);
            assert_eq!(state.selection(), Selection::new(0, 0));
            assert!(state.inline_styles().is_empty());
            let styles = RangeSet::new([Span::new(
                1..4,
                Affinity::Before,
                Affinity::After,
                InlineStyle::default().bold(),
            )]);
            state
                .dispatch_with_styles(&transaction, styles, cx)
                .unwrap();
            assert_eq!(state.as_str(), "a界b");
            assert_eq!(state.selection(), Selection::new(4, 1));
            assert_eq!(state.inline_styles()[0].range, 1..4);
            let read_snapshot = state.rich_text_snapshot();
            assert_eq!(read_snapshot.as_str(), "a界b");
            assert_eq!(read_snapshot.ranges(), state.inline_styles());
            assert!(std::ptr::eq(
                read_snapshot.ranges()[0].value(),
                state.inline_styles()[0].value()
            ));
            let read_runs = read_snapshot.text_runs(&gpui::TextStyle::default());
            assert_eq!(
                read_runs.iter().map(|run| run.len).collect::<Vec<_>>(),
                [1, 3, 1]
            );
            assert_eq!(read_runs[1].font.weight, gpui::FontWeight::BOLD);
            assert_eq!(read_runs[0].font.weight, gpui::FontWeight::NORMAL);
            assert!(state.dispatch(&stale, cx).is_err());
            assert!(state.dispatch(&foreign_batch, cx).is_err());
            assert_eq!(state.as_str(), "a界b");
            assert_eq!(state.revision(), 1);
        })
    });
}

#[test]
fn multiline_paste_keeps_the_new_caret_in_the_scroll_viewport() {
    use gpui::{
        AppContext, Context, Entity, IntoElement, ParentElement, Render,
        StatefulInteractiveElement, Styled, Window, div, px, size,
    };
    use gpui_ce_elements::editable_text::{EditableTextState, text_area};
    use std::sync::Arc;

    struct View(Entity<EditableTextState>);
    impl Render for View {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div().size_full().child(
                text_area("scrolling-editor")
                    .state(self.0.downgrade())
                    .size_full()
                    .overflow_y_scroll()
                    .text_size(px(16.))
                    .line_height(px(20.)),
            )
        }
    }
    for (viewport_height, inserted_lines) in [(120., 30), (113., 5)] {
        let mut app = gpui::HeadlessAppContext::new(Arc::new(gpui::NoopTextSystem::new()));
        let state = app
            .update(|cx| cx.new(|cx| EditableTextState::from_rich_text(RichText::from("one"), cx)));
        let window = app
            .open_window(size(px(320.), px(viewport_height)), |_, cx| {
                cx.new(|_| View(state.clone()))
            })
            .unwrap();
        app.update_window(window.into(), |_, window, cx| {
            window.draw(cx).clear(cx);
        })
        .unwrap();
        let paste = "\nnext".repeat(inserted_lines);
        let end = 3 + paste.len();
        app.update(|cx| {
            state.update(cx, |state, cx| {
                let transaction = state
                    .transaction()
                    .replace(3..3, paste)
                    .selection(Selection::new(end, end))
                    .build()
                    .unwrap();
                state.dispatch(&transaction, cx).unwrap();
            })
        });
        for _ in 0..3 {
            app.update_window(window.into(), |_, window, cx| {
                window.draw(cx).clear(cx);
            })
            .unwrap();
        }
        let caret = app.update(|cx| state.read(cx).bounds_for_range(end..end).unwrap());
        assert!(
            caret.origin.y >= px(0.) && caret.origin.y + caret.size.height <= px(viewport_height),
            "caret outside viewport: {caret:?}"
        );
    }
}

#[test]
fn read_snapshots_and_text_events_survive_text_and_format_undo_redo() {
    use gpui::{AppContext, Context, Entity, IntoElement, Render, Styled, Window, px, size};
    use gpui_ce_elements::editable_text::actions::{EditableTextActionHandler, Redo, Undo};
    use gpui_ce_elements::editable_text::{EditableTextState, TextChanged, text_area};
    use std::{cell::Cell, rc::Rc, sync::Arc};

    struct View(Entity<EditableTextState>);
    impl Render for View {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            text_area("event-editor")
                .state(self.0.downgrade())
                .size_full()
        }
    }
    let mut app = gpui::HeadlessAppContext::new(Arc::new(gpui::NoopTextSystem::new()));
    let state =
        app.update(|cx| cx.new(|cx| EditableTextState::from_rich_text(RichText::from("a😀b"), cx)));
    let count = Rc::new(Cell::new(0));
    app.update(|cx| {
        let count = count.clone();
        cx.subscribe(&state, move |_, _: &TextChanged, _| {
            count.set(count.get() + 1)
        })
        .detach();
    });
    let window = app
        .open_window(size(px(320.), px(120.)), |_, cx| {
            cx.new(|_| View(state.clone()))
        })
        .unwrap();
    app.update_window(window.into(), |_, window, cx| window.draw(cx).clear(cx))
        .unwrap();
    app.update(|cx| {
        state.update(cx, |state, cx| {
            let transaction = state
                .transaction()
                .replace(1..5, "界")
                .selection(Selection::new(1, 4))
                .build()
                .unwrap();
            state.dispatch(&transaction, cx).unwrap();
        })
    });
    assert_eq!(count.get(), 1);
    app.update(|cx| {
        state.update(cx, |state, cx| {
            state.format_selection(InlineStyle::default().bold(), cx)
        })
    });
    assert_eq!(count.get(), 1, "formatting changes presentation, not text");
    let read = app.update(|cx| state.read(cx).rich_text_snapshot());
    assert_eq!(read.as_str(), "a界b");
    assert_eq!(read.ranges().len(), 1);
    for (redo, expected_text, expected_marks, expected_events) in [
        (false, "a界b", 0, 1),
        (false, "a😀b", 0, 2),
        (true, "a界b", 0, 3),
        (true, "a界b", 1, 3),
    ] {
        app.update_window(window.into(), |_, window, cx| {
            state.update(cx, |state, cx| {
                if redo {
                    state.redo(&Redo, window, cx);
                } else {
                    state.undo(&Undo, window, cx);
                }
            })
        })
        .unwrap();
        assert_eq!(count.get(), expected_events);
        let read = app.update(|cx| state.read(cx).rich_text_snapshot());
        assert_eq!(read.as_str(), expected_text);
        assert_eq!(read.ranges().len(), expected_marks);
    }
}
