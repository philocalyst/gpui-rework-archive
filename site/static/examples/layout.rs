use gpui::{IntoElement, container_query, div, prelude::*, px};

fn responsive_workbench() -> impl IntoElement {
    container_query(|size, _window, _cx| {
        let narrow = size.width < px(340.);
        let spacious = size.width >= px(560.);
        let gap = (((size.width.as_f32() - 220.).max(0.) / 18.) + 8.).clamp(8., 28.);

        div()
            .flex()
            .when(narrow, |layout| layout.flex_col())
            .when(!narrow, |layout| layout.flex_row())
            .gap(px(gap))
            .child(
                div()
                    .flex_1()
                    .child("Workbench")
                    .child("Flexible space follows the available width."),
            )
            .child(
                div()
                    .flex_1()
                    .when(spacious, |panel| panel.p_8())
                    .child("Inspector")
                    .child("The narrow state stacks both regions."),
            )
    })
}
