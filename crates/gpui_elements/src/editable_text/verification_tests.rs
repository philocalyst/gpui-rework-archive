//! Independent integration checks at the editing/layout boundary.
use super::{EditableTextState, text_area};
use crate::rich_text::{Affinity, Document, InlineStyle, RangeSet, RichText, Span};
use gpui::{
    AnyWindowHandle, Entity, HeadlessAppContext, Hsla, NoopTextSystem, Pixels, SharedString,
    Window, WrappedLine, div, hsla, prelude::*, px, size,
};
use std::sync::Arc;

struct VerificationView {
    state: Entity<EditableTextState>,
    width: Pixels,
    font_size: Pixels,
    family: SharedString,
    foreground: Hsla,
    decoration: Option<Hsla>,
    accepts_input: bool,
}

impl Render for VerificationView {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        // A new payload Arc on every render represents recomputed syntax/search decorations.
        let decorations = self
            .decoration
            .map(|color| {
                RangeSet::new([Span::new(
                    6..10,
                    Affinity::Before,
                    Affinity::After,
                    InlineStyle::default().color(color),
                )])
            })
            .unwrap_or_default();
        div().size_full().child(
            text_area("verification-editor")
                .state(self.state.downgrade())
                .w(self.width)
                .h(px(120.))
                .overflow_y_scroll()
                .font_family(self.family.clone())
                .text_size(self.font_size)
                .line_height(px(20.))
                .text_color(self.foreground)
                .decorations(decorations)
                .accepts_input(self.accepts_input),
        )
    }
}

fn draw(app: &mut HeadlessAppContext, window: AnyWindowHandle) {
    app.update_window(window, |_, window, cx| window.draw(cx).clear(cx))
        .unwrap();
}

fn first_line(app: &mut HeadlessAppContext, state: &Entity<EditableTextState>) -> Arc<WrappedLine> {
    app.update(|cx| {
        state.read(cx).layout_data.lines[0]
            .wrapped_line
            .clone()
            .unwrap()
    })
}

#[test]
fn layout_reuses_unchanged_paragraphs_and_invalidates_actual_shape_inputs() {
    let mut app = HeadlessAppContext::new(Arc::new(NoopTextSystem::new()));
    let rich = RichText::new()
        .span("alpha", InlineStyle::default().bold())
        .text(" beta gamma delta epsilon\nsecond paragraph")
        .finish();
    let state = app.update(|cx| cx.new(|cx| EditableTextState::from_rich_text(rich, cx)));
    let mut view = None;
    let window = app
        .open_window(size(px(320.), px(120.)), |_, cx| {
            let entity = cx.new(|_| VerificationView {
                state: state.clone(),
                width: px(160.),
                font_size: px(16.),
                family: ".ZedSans".into(),
                foreground: hsla(0., 0., 0.2, 1.),
                decoration: Some(hsla(0.1, 0.8, 0.4, 1.)),
                accepts_input: true,
            });
            view = Some(entity.clone());
            entity
        })
        .unwrap();
    let view = view.unwrap();
    draw(&mut app, window.into());
    let original = first_line(&mut app, &state);
    app.update(|cx| state.update(cx, |state, cx| state.move_to(3, cx)));
    draw(&mut app, window.into());
    assert!(
        Arc::ptr_eq(&original, &first_line(&mut app, &state)),
        "selection-only frame reshaped text"
    );

    // Advance the text revision, rebuild equal decoration payloads, and change another paragraph.
    app.update(|cx| {
        state.update(cx, |state, cx| {
            let end = state.len_bytes();
            let transaction = state
                .transaction()
                .replace(end - 1..end, "!")
                .build()
                .unwrap();
            state.dispatch(&transaction, cx).unwrap();
        })
    });
    draw(&mut app, window.into());
    assert!(
        Arc::ptr_eq(&original, &first_line(&mut app, &state)),
        "equal fresh-Arc style values missed paragraph cache"
    );

    app.update(|cx| {
        view.update(cx, |view, cx| {
            view.width = px(72.);
            cx.notify();
        })
    });
    draw(&mut app, window.into());
    let narrow = first_line(&mut app, &state);
    assert!(
        !Arc::ptr_eq(&original, &narrow),
        "width change reused old wrap layout"
    );
    assert!(narrow.wrap_boundaries().len() > original.wrap_boundaries().len());
    app.update(|cx| {
        view.update(cx, |view, cx| {
            view.foreground = hsla(0.6, 1., 0.4, 1.);
            cx.notify();
        })
    });
    draw(&mut app, window.into());
    let recolored = first_line(&mut app, &state);
    assert!(
        !Arc::ptr_eq(&narrow, &recolored),
        "inherited theme color reused old decorated line"
    );
    assert_eq!(
        app.update(|cx| state
            .read(cx)
            .layout_data
            .state
            .cache_key
            .as_ref()
            .unwrap()
            .text_color),
        hsla(0.6, 1., 0.4, 1.)
    );
    app.update(|cx| {
        view.update(cx, |view, cx| {
            view.font_size = px(24.);
            view.family = ".ZedMono".into();
            cx.notify();
        })
    });
    draw(&mut app, window.into());
    let font_changed = first_line(&mut app, &state);
    assert!(
        !Arc::ptr_eq(&recolored, &font_changed),
        "font change reused old paragraph"
    );
    app.update(|cx| {
        view.update(cx, |view, cx| {
            view.decoration = Some(hsla(0.8, 1., 0.4, 1.));
            cx.notify();
        })
    });
    draw(&mut app, window.into());
    let decorated = first_line(&mut app, &state);
    assert!(
        !Arc::ptr_eq(&font_changed, &decorated),
        "transient style change reused old paragraph"
    );
    app.update(|cx| {
        view.update(cx, |view, cx| {
            view.accepts_input = false;
            cx.notify();
        })
    });
    draw(&mut app, window.into());
    assert!(Arc::ptr_eq(&decorated, &first_line(&mut app, &state)));
    assert!(
        !app.update(|cx| state.read(cx).layout_data.accepts_input),
        "cache hit skipped read-only gate update"
    );
}

#[test]
fn editing_a_document_larger_than_the_old_cache_limit_reuses_every_untouched_line() {
    const PARAGRAPHS: usize = 4_200;
    let mut text = String::new();
    for line in 0..PARAGRAPHS {
        text.push_str(&format!("paragraph {line:04}\n"));
    }
    let mut app = HeadlessAppContext::new(Arc::new(NoopTextSystem::new()));
    let state = app.update(|cx| cx.new(|cx| EditableTextState::new(Document::new(text), cx)));
    let window = app
        .open_window(size(px(320.), px(120.)), |_, cx| {
            cx.new(|_| VerificationView {
                state: state.clone(),
                width: px(320.),
                font_size: px(16.),
                family: ".ZedSans".into(),
                foreground: hsla(0., 0., 0.2, 1.),
                decoration: None,
                accepts_input: true,
            })
        })
        .unwrap();
    draw(&mut app, window.into());
    let before = app.update(|cx| state.read(cx).layout_data.lines.clone());
    let target = PARAGRAPHS / 2;
    app.update(|cx| {
        state.update(cx, |state, cx| {
            let range = state.document_snapshot().line_range(target).unwrap();
            let transaction = state
                .transaction()
                .replace(range.start..range.start + 1, "P")
                .build()
                .unwrap();
            state.dispatch(&transaction, cx).unwrap();
        })
    });
    draw(&mut app, window.into());
    let after = app.update(|cx| state.read(cx).layout_data.lines.clone());
    assert_eq!(before.len(), PARAGRAPHS + 1);
    assert_eq!(before.len(), after.len());
    let reused = before
        .iter()
        .zip(after.iter())
        .enumerate()
        .filter(|(index, (left, right))| {
            *index != target
                && Arc::ptr_eq(
                    left.wrapped_line.as_ref().unwrap(),
                    right.wrapped_line.as_ref().unwrap(),
                )
        })
        .count();
    assert_eq!(
        reused, PARAGRAPHS,
        "full-document scan evicted unchanged active paragraphs"
    );
    assert!(!Arc::ptr_eq(
        before[target].wrapped_line.as_ref().unwrap(),
        after[target].wrapped_line.as_ref().unwrap()
    ));
    eprintln!(
        "active paragraph fixture: {} lines, {reused} unchanged Arc layouts reused",
        after.len()
    );
}

#[test]
fn unicode_ime_stages_form_one_undo_and_respect_read_only() {
    use super::actions::{EditableTextActionHandler, Undo};
    use crate::rich_text::Selection;
    use gpui::EntityInputHandler;

    let mut app = HeadlessAppContext::new(Arc::new(NoopTextSystem::new()));
    let rich = RichText::new()
        .text("a")
        .span("😀", InlineStyle::default().bold())
        .text("b")
        .finish();
    let initial_styles = rich.ranges().clone();
    let state = app.update(|cx| cx.new(|cx| EditableTextState::from_rich_text(rich, cx)));
    let mut view = None;
    let window = app
        .open_window(size(px(320.), px(120.)), |_, cx| {
            let entity = cx.new(|_| VerificationView {
                state: state.clone(),
                width: px(320.),
                font_size: px(16.),
                family: ".ZedSans".into(),
                foreground: hsla(0., 0., 0.2, 1.),
                decoration: None,
                accepts_input: true,
            });
            view = Some(entity.clone());
            entity
        })
        .unwrap();
    let view = view.unwrap();
    draw(&mut app, window.into());
    app.update(|cx| {
        state.update(cx, |state, cx| {
            state.move_to(1, cx);
            state.select_to(5, cx);
        })
    });
    app.update_window(window.into(), |_, window, cx| {
        state.update(cx, |state, cx| {
            state.replace_and_mark_text_in_range(Some(1..3), "に", Some(1..1), window, cx);
            assert_eq!(state.as_str(), "aにb");
            assert_eq!(state.marked_text_range(window, cx), Some(1..2));
            state.replace_and_mark_text_in_range(None, "日本", Some(1..1), window, cx);
            assert_eq!(state.as_str(), "a日本b");
            assert_eq!(state.marked_text_range(window, cx), Some(1..3));
            assert_eq!(
                state.selected_text_range(false, window, cx).unwrap().range,
                2..2
            );
            assert_eq!(state.selection(), Selection::new(4, 4));
            state.replace_text_in_range(None, "日本語", window, cx);
            state.unmark_text(window, cx);
            assert_eq!(state.as_str(), "a日本語b");
            assert_eq!(state.marked_text_range(window, cx), None);
            assert_eq!(state.inline_styles()[0].range, 1..10);
            state.undo(&Undo, window, cx);
            assert_eq!(
                state.as_str(),
                "a😀b",
                "composition should undo as one edit"
            );
            assert_eq!(state.selection(), Selection::new(1, 5));
            assert_eq!(state.inline_styles(), &initial_styles);
        })
    })
    .unwrap();
    app.update(|cx| {
        view.update(cx, |view, cx| {
            view.accepts_input = false;
            cx.notify();
        })
    });
    draw(&mut app, window.into());
    app.update_window(window.into(), |_, window, cx| {
        state.update(cx, |state, cx| {
            let revision = state.revision();
            state.replace_and_mark_text_in_range(Some(1..3), "拒否", Some(1..1), window, cx);
            state.replace_text_in_range(Some(1..3), "拒否", window, cx);
            assert_eq!(state.as_str(), "a😀b");
            assert_eq!(state.revision(), revision);
            assert_eq!(state.selection(), Selection::new(1, 5));
            assert_eq!(state.inline_styles(), &initial_styles);
            assert_eq!(state.marked_text_range(window, cx), None);
        })
    })
    .unwrap();
}
