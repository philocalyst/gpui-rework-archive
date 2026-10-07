use gpui::{
    AnyElement, App, Div, SharedString, StyleRefinement, Window, div, prelude::*, px, rgba,
};
use gpui_codepen_guest::{Node, Style};
use std::rc::Rc;

pub type ClickHandler = Rc<dyn Fn(String, &mut Window, &mut App)>;
/// Reconstruct native GPUI elements. The guest has no paint or layout engine:
/// its geometry, text shaping, hover hitboxes, and clicks are all real GPUI.
pub fn render_node(node: &Node, on_click: ClickHandler) -> AnyElement {
    walk(node, &mut 0, &on_click)
}
fn walk(
    node: &Node,
    next_id: &mut usize,
    on_click: &ClickHandler,
) -> AnyElement {
    match node {
        Node::Text { text } => div()
            .block()
            .min_w_0()
            .whitespace_normal()
            .child(SharedString::from(text.clone()))
            .into_any_element(),
        Node::Div {
            id,
            style,
            hover,
            click,
            children,
        } => {
            let generated = *next_id;
            *next_id += 1;
            let id = match id {
                Some(id) => gpui::ElementId::from(SharedString::from(id.clone())),
                None => gpui::ElementId::from(("codepen-generated", generated)),
            };
            let mut element = apply_style(div(), style).id(id);
            if let Some(hover) = hover {
                let style = hover.clone();
                element = element.hover(move |s| apply_style(s, &style));
            }
            if let Some(event) = click {
                let event = event.clone();
                let handler = on_click.clone();
                element = element.cursor_pointer().on_click(move |_, w, cx| {
                    cx.stop_propagation();
                    handler(event.clone(), w, cx);
                });
            }
            for child in children {
                element = element.child(walk(child, next_id, on_click));
            }
            element.into_any_element()
        }

    }
}

fn apply_style<T: Styled>(mut element: T, style: &Style) -> T {
    if style.flex {
        element = element.flex();
    }
    if style.column {
        element = element.flex_col();
    }
    if style.wrap {
        element = element.flex_wrap();
    }
    if style.grow {
        element = element.flex_grow(1.);
    }
    if style.full_width {
        element = element.w_full();
    }
    if style.full_height {
        element = element.h_full();
    }
    if style.center {
        element = element.items_center();
    }
    if style.justify_center {
        element = element.justify_center();
    }
    if style.justify_between {
        element = element.justify_between();
    }
    if style.bold {
        element = element.font_weight(gpui::FontWeight::BOLD);
    }
    if style.shadow {
        element = element.shadow_lg();
    }
    if style.clip {
        element = element.overflow_hidden();
    }
    if let Some(v) = style.width {
        element = element.w(px(v));
    }
    if let Some(v) = style.height {
        element = element.h(px(v));
    }
    if let Some(v) = style.padding {
        element = element.p(px(v));
    }
    if let Some(v) = style.gap {
        element = element.gap(px(v));
    }
    if let Some(v) = style.radius {
        element = element.rounded(px(v));
    }
    if let Some(v) = style.border {
        element = element.border(px(v));
    }
    if let Some(v) = style.background {
        element = element.bg(rgba(v));
    }
    if let Some(v) = style.color {
        element = element.text_color(rgba(v));
    }
    if let Some(v) = style.border_color {
        element = element.border_color(rgba(v));
    }
    if let Some(v) = style.font_size {
        element = element.text_size(px(v));
    }
    if let Some(v) = style.opacity {
        element = element.opacity(v);
    }
    element
}

// Compile-time checks keep the native adapter aligned with GPUI's two style
// surfaces, including hover refinements.
const _: fn(Div, &Style) -> Div = apply_style::<Div>;
const _: fn(StyleRefinement, &Style) -> StyleRefinement = apply_style::<StyleRefinement>;
