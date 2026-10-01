//! CPU-side model and headless frame benchmarks; these do not measure GPU frame rate.
//! Each fixture and its expected output are prepared before that case's Criterion timing starts.
//! Frame timings include headless view render/layout/prepaint/scene work with `NoopTextSystem`,
//! without platform fonts, rasterization, presentation, or a GPU.
//! Batched edits use an O(1) document snapshot clone as setup, while `edit_plus_legacy_as_str`
//! explicitly includes the first flatten of the edited revision.

use criterion::{
    BatchSize, BenchmarkId, Criterion, Throughput, black_box, criterion_group, criterion_main,
};
use gpui::{
    AppContext, Context, Entity, HeadlessAppContext, Hsla, NoopTextSystem, Pixels, SharedString,
    TextStyle, Window, div, hsla, prelude::*, px, size,
};
use gpui_ce_elements::editable_text::{EditableTextState, text_area};
use gpui_ce_elements::rich_text::{
    Affinity, Change, ChangeSet, Document, InlineStyle, RangeSet, RichText, Span,
};
use std::{cell::RefCell, ops::Range, rc::Rc, sync::Arc, time::Duration};

const DOCUMENT_SIZES: [usize; 3] = [1 << 10, 1 << 16, 1 << 20];
const DECORATION_TEXT_BYTES: usize = 1 << 20;
const SPAN_COUNTS: [usize; 2] = [1_024, 16_384];
const SPARSE_QUERY_COUNT: usize = 64;
const LINE_QUERY_COUNT: usize = 16;
const BATCH_EDIT_COUNT: usize = 32;
const LAYOUT_PARAGRAPH_COUNTS: [usize; 2] = [128, 4_097];

fn ascii_text(len: usize) -> String {
    "a".repeat(len)
}

fn unicode_text(len: usize) -> String {
    const LINE: &str = "fn crab() { let animal = \"🦀\"; let cafe = \"café\"; }\n";
    let mut text = String::with_capacity(len);
    while text.len() + LINE.len() <= len {
        text.push_str(LINE);
    }
    text.extend(std::iter::repeat_n('x', len - text.len()));
    text
}

fn byte_utf16_samples(text: &str) -> Vec<(usize, usize)> {
    let targets = (1..=SPARSE_QUERY_COUNT)
        .map(|index| index * text.len() / (SPARSE_QUERY_COUNT + 1))
        .collect::<Vec<_>>();
    let mut samples = Vec::with_capacity(SPARSE_QUERY_COUNT);
    let mut target_index = 0;
    let mut utf16_offset = 0;

    for (byte_offset, character) in text.char_indices() {
        while target_index < targets.len() && byte_offset >= targets[target_index] {
            samples.push((byte_offset, utf16_offset));
            target_index += 1;
        }
        utf16_offset += character.len_utf16();
    }
    while target_index < targets.len() {
        samples.push((text.len(), utf16_offset));
        target_index += 1;
    }

    samples
}

fn line_ranges(text: &str) -> Vec<Range<usize>> {
    let mut lines = Vec::new();
    let mut start = 0;
    for (offset, byte) in text.bytes().enumerate() {
        if byte == b'\n' {
            lines.push(start..offset);
            start = offset + 1;
        }
    }
    lines.push(start..text.len());
    lines
}

fn expected_after_replacements(text: &str, edits: &[Range<usize>], replacement: &str) -> String {
    let mut output = String::with_capacity(text.len() + edits.len() * replacement.len());
    let mut cursor = 0;
    for range in edits {
        output.push_str(&text[cursor..range.start]);
        output.push_str(replacement);
        cursor = range.end;
    }
    output.push_str(&text[cursor..]);
    output
}

fn apply_replacements(document: &mut Document, edits: &[Range<usize>], replacement: &str) {
    let mut transaction = document.transaction();
    for range in edits {
        transaction = transaction.replace(range.clone(), replacement);
    }
    let transaction = transaction
        .build()
        .expect("benchmark replacement batch should be valid");
    document
        .apply(&transaction)
        .expect("benchmark transaction should apply to its source snapshot");
}

fn bench_documents(c: &mut Criterion) {
    let mut group = c.benchmark_group("rich_text/documents");

    for size in DOCUMENT_SIZES {
        let source = ascii_text(size);
        let base = Document::new(source.clone());
        assert_eq!(base.len_bytes(), size);
        assert_eq!(base.len_utf16(), size);

        group.bench_with_input(
            BenchmarkId::new("cheap_clone", size),
            &base,
            |b, document| b.iter(|| black_box(document.clone())),
        );

        let single_edit = [size / 2..size / 2 + 1];
        let expected_single = expected_after_replacements(&source, &single_edit, "b");
        let mut checked_single = base.clone();
        apply_replacements(&mut checked_single, &single_edit, "b");
        assert_eq!(checked_single.as_str(), expected_single);
        drop(checked_single);
        drop(expected_single);

        group.bench_with_input(BenchmarkId::new("edit_only", size), &base, |b, document| {
            b.iter_batched(
                || document.clone(),
                |mut edited| {
                    apply_replacements(&mut edited, &single_edit, "b");
                    black_box(edited)
                },
                BatchSize::SmallInput,
            );
        });

        group.bench_with_input(
            BenchmarkId::new("edit_plus_legacy_as_str", size),
            &base,
            |b, document| {
                b.iter_batched(
                    || document.clone(),
                    |mut edited| {
                        apply_replacements(&mut edited, &single_edit, "b");
                        let flattened = black_box(edited.as_str());
                        black_box(flattened.len());
                        black_box(edited)
                    },
                    BatchSize::SmallInput,
                );
            },
        );

        let batch_edits = (0..BATCH_EDIT_COUNT)
            .map(|index| {
                let position = (index + 1) * size / (BATCH_EDIT_COUNT + 1);
                position..position + 1
            })
            .collect::<Vec<_>>();
        let expected_batch = expected_after_replacements(&source, &batch_edits, "b");
        let mut checked_batch = base.clone();
        apply_replacements(&mut checked_batch, &batch_edits, "b");
        assert_eq!(checked_batch.as_str(), expected_batch);
        eprintln!(
            "rich_text storage: bytes={size}, base_chunks={}, after_32_edit_chunks={}, original_snapshot_retained=true",
            base.chunk_count(),
            checked_batch.chunk_count(),
        );
        drop(checked_batch);
        drop(expected_batch);

        group.bench_with_input(
            BenchmarkId::new("32_spaced_edits", size),
            &base,
            |b, document| {
                b.iter_batched(
                    || document.clone(),
                    |mut edited| {
                        apply_replacements(&mut edited, &batch_edits, "b");
                        black_box(edited)
                    },
                    BatchSize::SmallInput,
                );
            },
        );
    }

    group.finish();
}

fn bench_document_queries(c: &mut Criterion) {
    let mut conversions = c.benchmark_group("rich_text/utf16_queries");
    conversions.throughput(Throughput::Elements(SPARSE_QUERY_COUNT as u64));

    for size in DOCUMENT_SIZES {
        let source = unicode_text(size);
        let document = Document::new(source.clone());
        let conversion_samples = byte_utf16_samples(&source);
        for &(byte_offset, utf16_offset) in &conversion_samples {
            assert_eq!(document.byte_to_utf16(byte_offset), utf16_offset);
            assert_eq!(document.utf16_to_byte(utf16_offset), byte_offset);
        }

        conversions.bench_with_input(
            BenchmarkId::new("byte_to_utf16_64_mixed_unicode", size),
            &document,
            |b, document| {
                b.iter(|| {
                    let sum = conversion_samples
                        .iter()
                        .map(|(byte, _)| document.byte_to_utf16(black_box(*byte)))
                        .sum::<usize>();
                    black_box(sum)
                });
            },
        );
        conversions.bench_with_input(
            BenchmarkId::new("utf16_to_byte_64_mixed_unicode", size),
            &document,
            |b, document| {
                b.iter(|| {
                    let sum = conversion_samples
                        .iter()
                        .map(|(_, utf16)| document.utf16_to_byte(black_box(*utf16)))
                        .sum::<usize>();
                    black_box(sum)
                });
            },
        );
    }
    conversions.finish();

    let mut lines = c.benchmark_group("rich_text/line_queries");
    lines.throughput(Throughput::Elements(LINE_QUERY_COUNT as u64));
    for size in DOCUMENT_SIZES {
        let source = unicode_text(size);
        let document = Document::new(source.clone());
        let expected_lines = line_ranges(&source);
        assert_eq!(document.line_count(), expected_lines.len());
        for (line, range) in expected_lines.iter().enumerate() {
            assert_eq!(document.line_range(line), Some(range.clone()));
        }
        let line_indices = (0..LINE_QUERY_COUNT)
            .map(|index| index * (expected_lines.len() - 1) / (LINE_QUERY_COUNT - 1))
            .collect::<Vec<_>>();
        drop(expected_lines);

        lines.bench_with_input(
            BenchmarkId::new("line_range_16", size),
            &document,
            |b, document| {
                b.iter(|| {
                    let total_bytes = line_indices
                        .iter()
                        .map(|&line| document.line_range(black_box(line)).unwrap().len())
                        .sum::<usize>();
                    black_box(total_bytes)
                });
            },
        );
    }

    lines.finish();
}

fn lowering_style(index: usize) -> InlineStyle {
    match index % 5 {
        0 => InlineStyle::default().bold(),
        1 => InlineStyle::default().italic(),
        2 => InlineStyle::default().underlined(),
        3 => InlineStyle::default().struck_through(),
        _ => InlineStyle::default().color(hsla((index % 360) as f32 / 360.0, 0.75, 0.5, 1.0)),
    }
}

fn rich_text_with_overlapping_styles(text: &str, style_count: usize) -> RichText {
    assert!(style_count > 0);
    let overlay_count = style_count - 1;
    let mut builder = RichText::new();
    builder.push_styled(InlineStyle::default().bold(), |builder| {
        if overlay_count == 0 {
            builder.push_text(text);
            return;
        }
        for index in 0..overlay_count {
            let start = index * text.len() / overlay_count;
            let end = (index + 1) * text.len() / overlay_count;
            builder.push_span(&text[start..end], lowering_style(index));
        }
    });
    builder.finish()
}

fn bench_rich_text_lowering(c: &mut Criterion) {
    const OVERLAPPING_STYLE_COUNT: usize = 1_000;
    let middle = ascii_text(1 << 16);
    let rich = rich_text_with_overlapping_styles(&middle, OVERLAPPING_STYLE_COUNT);
    let base_style = TextStyle::default();
    assert_eq!(rich.ranges().len(), OVERLAPPING_STYLE_COUNT);

    let expected_bytes = rich.as_str().len();
    let expected_runs = rich.text_runs(&base_style);
    assert_eq!(
        expected_runs.iter().map(|run| run.len).sum::<usize>(),
        expected_bytes
    );
    assert!(expected_runs.len() > 1);
    drop(expected_runs);
    drop(middle);

    c.bench_function("rich_text/lower_1000_overlapping_styles", |b| {
        b.iter(|| black_box(rich.text_runs(black_box(&base_style))));
    });
}

fn bench_editable_state_dispatch(c: &mut Criterion) {
    const TEXT_BYTES: usize = 1 << 20;
    const MAPPED_STYLE_COUNT: usize = 1_000;
    let source = ascii_text(TEXT_BYTES);
    let edit = TEXT_BYTES / 2..TEXT_BYTES / 2 + 1;
    let plain = RichText::from(source.clone());
    let marked = rich_text_with_overlapping_styles(&source, MAPPED_STYLE_COUNT);
    assert_eq!(marked.as_str(), source);
    assert_eq!(marked.ranges().len(), MAPPED_STYLE_COUNT);

    let headless = Rc::new(RefCell::new(HeadlessAppContext::new(Arc::new(
        NoopTextSystem::new(),
    ))));
    let mut group = c.benchmark_group("rich_text/editable_state_dispatch");

    for (case_name, rich_text, expected_style_count) in [
        ("no_marks", plain, 0),
        ("map_1000_styles", marked, MAPPED_STYLE_COUNT),
    ] {
        let mut app = headless.borrow_mut();
        let checked_state =
            app.update(|cx| cx.new(|cx| EditableTextState::from_rich_text(rich_text.clone(), cx)));
        let expected = expected_after_replacements(&source, std::slice::from_ref(&edit), "b");
        checked_state.update(&mut *app, |state, cx| {
            let transaction = state
                .transaction()
                .replace(edit.clone(), "b")
                .build()
                .expect("editable state transaction should validate");
            state
                .dispatch(&transaction, cx)
                .expect("editable state transaction should dispatch");
            assert_eq!(state.as_str(), expected);
            assert_eq!(state.inline_styles().len(), expected_style_count);
            assert_eq!(state.revision(), 1);
            assert!(state.history().is_some());
        });
        drop(checked_state);
        drop(expected);
        drop(app);

        let setup_app = headless.clone();
        let measured_app = headless.clone();
        let fixture = rich_text.clone();
        group.bench_function(format!("{case_name}_1MiB_no_render"), |b| {
            b.iter_batched_ref(
                || {
                    let mut app = setup_app.borrow_mut();
                    app.update(|cx| {
                        cx.new(|cx| EditableTextState::from_rich_text(fixture.clone(), cx))
                    })
                },
                |state| {
                    let mut app = measured_app.borrow_mut();
                    state.update(&mut *app, |state, cx| {
                        let transaction = state
                            .transaction()
                            .replace(edit.clone(), "b")
                            .build()
                            .expect("editable state transaction should validate");
                        state
                            .dispatch(&transaction, cx)
                            .expect("editable state transaction should dispatch");
                        black_box((
                            state.len_bytes(),
                            state.inline_styles().len(),
                            state.revision(),
                            state.history().is_some(),
                        ))
                    })
                },
                BatchSize::PerIteration,
            );
        });
    }

    group.finish();
}

struct LayoutBenchView {
    state: Entity<EditableTextState>,
    width: Pixels,
    foreground: Hsla,
    attach_editor: bool,
    render_count: usize,
}

impl Render for LayoutBenchView {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        self.render_count += 1;
        let mut root = div().size_full();
        if self.attach_editor {
            root = root.child(
                text_area("rich-text-layout-bench")
                    .state(self.state.downgrade())
                    .w(self.width)
                    .h(px(540.))
                    .overflow_y_scroll()
                    .text_size(px(16.))
                    .line_height(px(20.))
                    .text_color(self.foreground),
            );
        }
        root
    }
}

struct LayoutFixture {
    state: Entity<EditableTextState>,
    view: Entity<LayoutBenchView>,
    window: gpui::WindowHandle<LayoutBenchView>,
    source: String,
    paragraph_count: usize,
    edit_at: usize,
    last_paragraph: Range<usize>,
    initial_empty_render_count: usize,
    // Keep the App last so its external entity handles are released before App teardown.
    app: HeadlessAppContext,
}

fn layout_text(paragraph_count: usize) -> String {
    (0..paragraph_count)
        .map(|index| {
            format!(
                "paragraph-{index:04}: a sample line with enough words to wrap at narrow widths"
            )
        })
        .collect::<Vec<_>>()
        .join("\n")
}

fn layout_fixture(paragraph_count: usize) -> LayoutFixture {
    let source = layout_text(paragraph_count);
    let last_paragraph = line_ranges(&source)
        .pop()
        .expect("layout fixture always has at least one paragraph");
    let target_paragraph = paragraph_count / 2;
    let edit_at = source
        .split_inclusive('\n')
        .take(target_paragraph)
        .map(str::len)
        .sum::<usize>()
        + "paragraph-0000: ".len();
    assert_eq!(source.as_bytes()[edit_at], b'a');

    let mut app = HeadlessAppContext::new(Arc::new(NoopTextSystem::new()));
    let state = app.update(|cx| {
        cx.new(|cx| EditableTextState::from_rich_text(RichText::from(source.clone()), cx))
    });
    let mut view_entity = None;
    let view_state = state.clone();
    let window = app
        .open_window(size(px(800.), px(600.)), |_, cx| {
            let view = cx.new(|_| LayoutBenchView {
                state: view_state,
                width: px(640.),
                foreground: hsla(0., 0., 0.1, 1.),
                attach_editor: false,
                render_count: 0,
            });
            view_entity = Some(view.clone());
            view
        })
        .expect("headless layout benchmark window should open");

    let view = view_entity.expect("window root should be created");
    let initial_empty_render_count = app.update(|cx| view.read(cx).render_count);

    // `open_window` draws before returning, so render an empty shell. Attach the populated editor
    // without notifying; the following explicit refresh/draw performs its first document layout.
    app.update(|cx| {
        view.update(cx, |view, _cx| view.attach_editor = true);
    });
    let configured_render_count = app.update(|cx| view.read(cx).render_count);
    assert_eq!(configured_render_count, initial_empty_render_count);

    let mut fixture = LayoutFixture {
        state,
        view,
        window,
        source,
        paragraph_count,
        edit_at,
        last_paragraph,
        initial_empty_render_count,
        app,
    };
    assert_cold_layout_pending(&mut fixture);
    fixture
}

fn draw_layout_frame(fixture: &mut LayoutFixture) {
    fixture
        .app
        .update_window(fixture.window.into(), |_, window, cx| {
            window.refresh();
            window.draw(cx).clear(cx);
        })
        .expect("headless layout benchmark frame should draw");
}

fn replace_layout_character(fixture: &mut LayoutFixture, replacement: &'static str) {
    let state_entity = fixture.state.clone();
    let window_handle = fixture.window.into();
    let edit_at = fixture.edit_at;
    fixture
        .app
        .update_window(window_handle, |_, window, cx| {
            state_entity.update(cx, |state, cx| {
                let transaction = state
                    .transaction()
                    .replace(edit_at..edit_at + 1, replacement)
                    .build()
                    .expect("localized layout edit should validate");
                state
                    .dispatch(&transaction, cx)
                    .expect("localized layout edit should dispatch");
            });
            window.refresh();
            window.draw(cx).clear(cx);
        })
        .expect("localized edit and frame should complete");
}

fn render_count(fixture: &mut LayoutFixture) -> usize {
    let view = fixture.view.clone();
    fixture.app.update(|cx| view.read(cx).render_count)
}

fn assert_cold_layout_pending(fixture: &mut LayoutFixture) {
    let state = fixture.state.clone();
    let view = fixture.view.clone();
    let last_paragraph = fixture.last_paragraph.clone();
    let initial_empty_render_count = fixture.initial_empty_render_count;
    fixture.app.update(|cx| {
        // This counter includes empty-shell renders; unchanged here proves the editor stayed
        // detached after the initial window frame.
        assert_eq!(view.read(cx).render_count, initial_empty_render_count);
        assert!(
            state.read(cx).bounds_for_range(last_paragraph).is_none(),
            "full document must have no layout bounds before its first editor draw"
        );
    });
}

fn assert_one_editor_draw(fixture: &mut LayoutFixture, previous_render_count: usize) {
    let state = fixture.state.clone();
    let view = fixture.view.clone();
    let last_paragraph = fixture.last_paragraph.clone();
    fixture.app.update(|cx| {
        assert_eq!(view.read(cx).render_count, previous_render_count + 1);
        assert!(
            state.read(cx).bounds_for_range(last_paragraph).is_some(),
            "editor draw should lay out the final paragraph"
        );
    });
}

fn assert_layout_fixture(fixture: &mut LayoutFixture, expected_text: &str, revision: u64) {
    let state_entity = fixture.state.clone();
    let paragraph_count = fixture.paragraph_count;
    let last_paragraph = fixture.last_paragraph.clone();
    fixture.app.update(|cx| {
        let state = state_entity.read(cx);
        assert_eq!(state.as_str(), expected_text);
        assert_eq!(state.revision(), revision);
        assert_eq!(state.as_str().lines().count(), paragraph_count);
        assert_eq!(state.len_bytes(), expected_text.len());
        assert!(
            state.bounds_for_range(last_paragraph).is_some(),
            "the final paragraph should have layout bounds after drawing"
        );
    });
}

fn paragraph_bounds_y(fixture: &mut LayoutFixture, range: Range<usize>) -> Pixels {
    let state_entity = fixture.state.clone();
    fixture.app.update(|cx| {
        state_entity
            .read(cx)
            .bounds_for_range(range)
            .expect("paragraph should have layout bounds")
            .origin
            .y
    })
}

fn update_layout_view(fixture: &mut LayoutFixture, width: Pixels, foreground: Hsla) {
    let view_entity = fixture.view.clone();
    let window_handle = fixture.window.into();
    fixture
        .app
        .update_window(window_handle, |_, window, cx| {
            view_entity.update(cx, |view, cx| {
                view.width = width;
                view.foreground = foreground;
                cx.notify();
            });
            window.refresh();
            window.draw(cx).clear(cx);
        })
        .expect("layout-key invalidation and frame should complete");
}

fn bench_headless_layout_frames(c: &mut Criterion) {
    let mut group = c.benchmark_group("rich_text/headless_frames_noop_text_system");

    for paragraph_count in LAYOUT_PARAGRAPH_COUNTS {
        // The first window frame has no editor attached; verify the full document has no bounds
        // before timing its first explicit editor draw, then require exactly one view render.
        let mut checked_cold = layout_fixture(paragraph_count);
        assert_cold_layout_pending(&mut checked_cold);
        let cold_source = checked_cold.source.clone();
        let render_count_before = render_count(&mut checked_cold);
        draw_layout_frame(&mut checked_cold);
        assert_one_editor_draw(&mut checked_cold, render_count_before);
        assert_layout_fixture(&mut checked_cold, &cold_source, 0);
        group.bench_function(
            format!("cold_document_layout_draw_{paragraph_count}_paragraphs"),
            |b| {
                b.iter_batched_ref(
                    || layout_fixture(paragraph_count),
                    |fixture| {
                        draw_layout_frame(fixture);
                        black_box((fixture.paragraph_count, fixture.source.len()));
                    },
                    BatchSize::PerIteration,
                );
            },
        );

        // A second draw warms the full-document cache before repeated unchanged frame timings.
        let mut warm = layout_fixture(paragraph_count);
        assert_cold_layout_pending(&mut warm);
        let render_count_before = render_count(&mut warm);
        draw_layout_frame(&mut warm);
        assert_one_editor_draw(&mut warm, render_count_before);
        let render_count_before = render_count(&mut warm);
        draw_layout_frame(&mut warm);
        assert_one_editor_draw(&mut warm, render_count_before);
        let warm_source = warm.source.clone();
        assert_layout_fixture(&mut warm, &warm_source, 0);
        group.bench_function(
            format!("warm_unchanged_redraw_{paragraph_count}_paragraphs"),
            |b| {
                b.iter(|| {
                    draw_layout_frame(&mut warm);
                    black_box((warm.paragraph_count, warm.source.len()));
                });
            },
        );

        // Include transaction construction, dispatch/history bookkeeping, and the subsequent draw.
        let mut checked_edit = layout_fixture(paragraph_count);
        assert_cold_layout_pending(&mut checked_edit);
        draw_layout_frame(&mut checked_edit);
        draw_layout_frame(&mut checked_edit);
        let mut expected_after_edit = checked_edit.source.clone();
        expected_after_edit.replace_range(checked_edit.edit_at..checked_edit.edit_at + 1, "b");
        let render_count_before = render_count(&mut checked_edit);
        replace_layout_character(&mut checked_edit, "b");
        assert_one_editor_draw(&mut checked_edit, render_count_before);
        assert_layout_fixture(&mut checked_edit, &expected_after_edit, 1);
        group.bench_function(
            format!("localized_edit_plus_draw_{paragraph_count}_paragraphs"),
            |b| {
                b.iter_batched_ref(
                    || {
                        let mut fixture = layout_fixture(paragraph_count);
                        draw_layout_frame(&mut fixture);
                        draw_layout_frame(&mut fixture);
                        fixture
                    },
                    |fixture| {
                        replace_layout_character(fixture, "b");
                        black_box((fixture.paragraph_count, fixture.source.len()));
                    },
                    BatchSize::PerIteration,
                );
            },
        );
    }

    // Width and text-style changes are independent layout-key invalidations. Repeatedly toggle
    // each input on a warmed 128-paragraph editor so the measured draw must rebuild its paragraphs.
    let mut width_fixture = layout_fixture(LAYOUT_PARAGRAPH_COUNTS[0]);
    assert_cold_layout_pending(&mut width_fixture);
    draw_layout_frame(&mut width_fixture);
    draw_layout_frame(&mut width_fixture);
    let last_paragraph = width_fixture.last_paragraph.clone();
    let wide_last_y = paragraph_bounds_y(&mut width_fixture, last_paragraph.clone());
    let render_count_before = render_count(&mut width_fixture);
    update_layout_view(&mut width_fixture, px(320.), hsla(0., 0., 0.1, 1.));
    assert_one_editor_draw(&mut width_fixture, render_count_before);
    let width_source = width_fixture.source.clone();
    assert_layout_fixture(&mut width_fixture, &width_source, 0);
    let narrow_last_y = paragraph_bounds_y(&mut width_fixture, last_paragraph);
    assert_ne!(
        wide_last_y, narrow_last_y,
        "narrow width should add wrapped rows"
    );
    let render_count_before = render_count(&mut width_fixture);
    update_layout_view(&mut width_fixture, px(640.), hsla(0., 0., 0.1, 1.));
    assert_one_editor_draw(&mut width_fixture, render_count_before);
    let mut narrow = false;
    group.bench_function("width_invalidation_128_paragraphs", |b| {
        b.iter(|| {
            narrow = !narrow;
            update_layout_view(
                &mut width_fixture,
                if narrow { px(320.) } else { px(640.) },
                hsla(0., 0., 0.1, 1.),
            );
            black_box(width_fixture.source.len());
        });
    });

    let mut style_fixture = layout_fixture(LAYOUT_PARAGRAPH_COUNTS[0]);
    assert_cold_layout_pending(&mut style_fixture);
    draw_layout_frame(&mut style_fixture);
    draw_layout_frame(&mut style_fixture);
    let dark = hsla(0., 0., 0.1, 1.);
    let blue = hsla(0.58, 0.7, 0.35, 1.);
    let render_count_before = render_count(&mut style_fixture);
    update_layout_view(&mut style_fixture, px(640.), blue);
    assert_one_editor_draw(&mut style_fixture, render_count_before);
    let style_source = style_fixture.source.clone();
    assert_layout_fixture(&mut style_fixture, &style_source, 0);
    let render_count_before = render_count(&mut style_fixture);
    update_layout_view(&mut style_fixture, px(640.), dark);
    assert_one_editor_draw(&mut style_fixture, render_count_before);
    let mut blue_foreground = false;
    group.bench_function("text_style_invalidation_128_paragraphs", |b| {
        b.iter(|| {
            blue_foreground = !blue_foreground;
            update_layout_view(
                &mut style_fixture,
                px(640.),
                if blue_foreground { blue } else { dark },
            );
            black_box(style_fixture.source.len());
        });
    });

    group.finish();
}

fn decoration_ranges(len: usize, count: usize) -> RangeSet<usize> {
    let step = len / (count + 1);
    RangeSet::new((0..count).map(|index| {
        let start = (index + 1) * step;
        Span::new(start..start + 8, Affinity::Before, Affinity::After, index)
    }))
}

fn sparse_queries(len: usize, count: usize) -> Vec<std::ops::Range<usize>> {
    let step = len / (count + 1);
    (0..SPARSE_QUERY_COUNT)
        .map(|index| {
            let span_index = (index * 73) % count;
            let start = (span_index + 1) * step;
            let position = if index % 2 == 0 {
                start + 4 // inside a span
            } else {
                start + 32 // in the gap between spans
            };
            position..position + 1
        })
        .collect()
}

fn bench_decorations(c: &mut Criterion) {
    let text = SharedString::from(ascii_text(DECORATION_TEXT_BYTES));
    let change = ChangeSet::new(
        text.clone(),
        [Change::new(
            DECORATION_TEXT_BYTES / 2..DECORATION_TEXT_BYTES / 2,
            "x",
        )],
    )
    .expect("the insertion is valid for the ASCII fixture");
    let mut group = c.benchmark_group("rich_text/decorations");

    for count in SPAN_COUNTS {
        let ranges = decoration_ranges(DECORATION_TEXT_BYTES, count);
        ranges
            .validate(text.as_ref())
            .expect("decoration spans should fit the ASCII fixture");
        let mapped = ranges
            .map_through(&change)
            .expect("decoration endpoints should map through an insertion");
        assert_eq!(mapped.len(), count);
        let insertion = DECORATION_TEXT_BYTES / 2;
        for (before, after) in ranges.iter().zip(mapped.iter()) {
            let expected_start = if before.range.start > insertion {
                before.range.start + 1
            } else {
                before.range.start
            };
            let expected_end = if before.range.end >= insertion {
                before.range.end + 1
            } else {
                before.range.end
            };
            assert_eq!(after.range, expected_start..expected_end);
        }
        drop(mapped);

        group.bench_with_input(BenchmarkId::new("map_through", count), &count, |b, _| {
            b.iter(|| black_box(ranges.map_through(black_box(&change)).unwrap()));
        });

        let queries = sparse_queries(DECORATION_TEXT_BYTES, count);
        let expected_hits = queries
            .iter()
            .map(|query| ranges.overlapping(query.clone()).count())
            .sum::<usize>();
        assert_eq!(expected_hits, SPARSE_QUERY_COUNT / 2);

        group.bench_with_input(
            BenchmarkId::new("sparse_queries_64", count),
            &count,
            |b, _| {
                b.iter(|| {
                    let hits = queries
                        .iter()
                        .map(|query| ranges.overlapping(black_box(query.clone())).count())
                        .sum::<usize>();
                    black_box(hits)
                });
            },
        );
    }

    group.finish();
}

criterion_group! {
    name = benches;
    config = Criterion::default()
        .sample_size(20)
        .warm_up_time(Duration::from_secs(1))
        .measurement_time(Duration::from_secs(3));
    targets = bench_documents, bench_document_queries, bench_decorations, bench_rich_text_lowering, bench_editable_state_dispatch, bench_headless_layout_frames
}
criterion_main!(benches);
