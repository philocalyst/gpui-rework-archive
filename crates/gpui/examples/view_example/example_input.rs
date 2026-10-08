//! A one-row frame around an editor.
//!
//! `Input::new` retains an internal editor under the buffer entity's identity.
//! `Input::editor` uses an existing editor, letting the caller also inspect its
//! caret. Both forms share the same border, focus handling, and key actions.
//! Different buffers have different identity scopes. Mounting the same buffer
//! twice in one scope needs an additional identity, and independent selections
//! need separate editor entities. The frame clips long text; it does not scroll
//! or validate pasted content.

use gpui::{
    App, BoxShadow, CursorStyle, Entity, EntityId, Hsla, IntoElement, Pixels, Role, SharedString,
    StyleRefinement, Window, div, hsla, point, prelude::*, px, white,
};

use crate::example_editor::{Editor, standard_actions};

enum Source {
    Value(Entity<String>),
    Editor(Entity<Editor>),
}

#[derive(IntoElement)]
pub struct Input {
    source: Source,
    label: SharedString,
    width: Option<Pixels>,
    color: Option<Hsla>,
}

impl Input {
    /// Retain an editor for this buffer while the input remains mounted.
    ///
    /// `label` names the field for assistive technology; use its visible form label.
    pub fn new(value: Entity<String>, label: impl Into<SharedString>) -> Self {
        Self {
            source: Source::Value(value),
            label: label.into(),
            width: None,
            color: None,
        }
    }

    /// Display an editor retained by the caller, including its current selection.
    ///
    /// `label` names this field independently of the buffer's contents.
    pub fn editor(editor: Entity<Editor>, label: impl Into<SharedString>) -> Self {
        Self {
            source: Source::Editor(editor),
            label: label.into(),
            width: None,
            color: None,
        }
    }

    /// Set the outer width in logical pixels; the default is 300 px.
    pub fn width(mut self, width: Pixels) -> Self {
        self.width = Some(width);
        self
    }

    /// Set the inherited text color without changing the border or focus ring.
    pub fn color(mut self, color: Hsla) -> Self {
        self.color = Some(color);
        self
    }
}

impl gpui::View for Input {
    fn entity_id(&self) -> Option<EntityId> {
        Some(match &self.source {
            Source::Value(value) => value.entity_id(),
            Source::Editor(editor) => editor.entity_id(),
        })
    }

    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        // View::entity_id scopes this hook under the source entity.
        let editor = match self.source {
            Source::Value(value) => {
                window.use_state(cx, move |window, cx| Editor::over(value, window, cx))
            }
            Source::Editor(editor) => editor,
        };

        let focus_handle = editor.read(cx).focus_handle.clone();
        let is_focused = focus_handle.is_focused(window);
        let text_color = self.color.unwrap_or(hsla(0., 0., 0.1, 1.));
        let box_width = self.width.unwrap_or(px(300.));

        let border = if is_focused {
            hsla(220. / 360., 0.8, 0.5, 1.)
        } else {
            hsla(0., 0., 0.75, 1.)
        };

        div()
            .id("input")
            .role(Role::TextInput)
            .aria_label(self.label)
            .aria_value(editor.read(cx).value.read(cx).clone())
            .key_context("TextInput")
            .track_focus(&focus_handle)
            .cursor(CursorStyle::IBeam)
            .map(standard_actions(editor.clone()))
            .w(box_width)
            .h(px(36.))
            .px(px(8.))
            .bg(white())
            .border_1()
            .border_color(border)
            .when(is_focused, |this| {
                this.shadow(vec![BoxShadow {
                    color: hsla(220. / 360., 0.8, 0.5, 0.3).into(),
                    offset: point(px(0.), px(0.)),
                    blur_radius: px(4.),
                    spread_radius: px(1.),
                    inset: false,
                }])
            })
            .rounded(px(4.))
            .overflow_hidden()
            .flex()
            .items_center()
            .line_height(px(20.))
            .text_size(px(14.))
            .text_color(text_color)
            .child(editor.cached(StyleRefinement::default().size_full()))
    }
}
