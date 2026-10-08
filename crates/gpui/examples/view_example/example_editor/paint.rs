//! One shaped document supplies glyphs, selection rectangles, and IME geometry.
use super::*;

impl gpui::Render for Editor {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Editor>) -> impl IntoElement {
        EditorText {
            editor: cx.entity(),
        }
    }
}

struct EditorText {
    editor: Entity<Editor>,
}

struct EditorTextPrepaint {
    text: Arc<ShapedText>,
    placeholder: Option<ShapedText>,
    selection: Vec<PaintQuad>,
    cursor: Option<PaintQuad>,
}

impl IntoElement for EditorText {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Element for EditorText {
    type RequestLayoutState = ();
    type PrepaintState = EditorTextPrepaint;

    fn id(&self) -> Option<gpui::ElementId> {
        None
    }

    fn source_location(&self) -> Option<&'static core::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _id: Option<&gpui::GlobalElementId>,
        _inspector_id: Option<&gpui::InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let content = self.editor.read(cx).value.read(cx);
        let mut style = gpui::Style::default();
        style.size.width = relative(1.).into();
        style.size.height = (window.line_height() * content.split('\n').count() as f32).into();
        (window.request_layout(style, [], cx), ())
    }

    fn prepaint(
        &mut self,
        _id: Option<&gpui::GlobalElementId>,
        _inspector_id: Option<&gpui::InspectorElementId>,
        bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState {
        let editor = self.editor.read(cx);
        let content = editor.value.read(cx);
        let style = window.text_style();
        let font_size = style.font_size.to_pixels(window.rem_size());
        let line_height = window.line_height();
        let focused = editor.focus_handle.is_focused(window);

        // Run lengths are consecutive UTF-8 byte lengths. Underlining does not
        // change the buffer, so every geometry query still addresses that buffer.
        let mut runs = Vec::new();
        if let Some(marked) = &editor.marked_range {
            if marked.start > 0 {
                runs.push(style.to_run(marked.start));
            }
            let mut run = style.to_run(marked.len());
            run.underline = Some(gpui::UnderlineStyle {
                thickness: px(1.),
                color: None,
                wavy: false,
            });
            runs.push(run);
            if marked.end < content.len() {
                runs.push(style.to_run(content.len() - marked.end));
            }
        } else {
            runs.push(style.to_run(content.len()));
        }
        let text = Arc::new(
            window
                .text_system()
                .shape_text(SharedString::new(content), font_size, &runs, None, None)
                .expect("editor text layout"),
        );

        let placeholder = content.is_empty().then(|| {
            let source = SharedString::new_static("Type here…");
            let mut run = style.to_run(source.len());
            run.color = hsla(0., 0., 0.5, 0.5);
            window
                .text_system()
                .shape_text(source, font_size, &[run], None, None)
                .expect("placeholder text layout")
        });
        let selection = if focused {
            text.selection_bounds(editor.selection(), line_height)
                .into_iter()
                .map(|mut rect| {
                    rect.origin += bounds.origin;
                    fill(rect, hsla(220. / 360., 0.8, 0.5, 0.25))
                })
                .collect()
        } else {
            Vec::new()
        };
        let cursor = if focused && editor.cursor_visible {
            let position = text
                .visual_position_for_byte_index(editor.cursor, line_height)
                .unwrap_or_default();
            Some(fill(
                Bounds::new(bounds.origin + position, size(px(1.5), line_height)),
                style.color,
            ))
        } else {
            None
        };
        EditorTextPrepaint {
            text,
            placeholder,
            selection,
            cursor,
        }
    }

    fn paint(
        &mut self,
        _id: Option<&gpui::GlobalElementId>,
        _inspector_id: Option<&gpui::InspectorElementId>,
        bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        let line_height = window.line_height();
        self.editor.update(cx, |editor, _| {
            editor.painted = Some(PaintedText {
                text: prepaint.text.clone(),
                origin: bounds.origin,
                line_height,
            });
        });
        let focus_handle = self.editor.read(cx).focus_handle.clone();
        window.handle_input(
            &focus_handle,
            ElementInputHandler::new(bounds, self.editor.clone()),
            cx,
        );

        for quad in prepaint.selection.drain(..) {
            window.paint_quad(quad);
        }
        let text = prepaint.placeholder.as_ref().unwrap_or(&prepaint.text);
        text.paint_background(
            bounds.origin,
            line_height,
            gpui::TextAlign::Left,
            None,
            window,
            cx,
        )
        .expect("editor text background");
        text.paint(
            bounds.origin,
            line_height,
            gpui::TextAlign::Left,
            None,
            window,
            cx,
        )
        .expect("editor text paint");
        if let Some(cursor) = prepaint.cursor.take() {
            window.paint_quad(cursor);
        }
    }
}
