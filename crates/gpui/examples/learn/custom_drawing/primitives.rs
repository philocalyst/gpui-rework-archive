//! Canvas shapes and cached vector geometry.
use super::*;

pub(super) fn basic_shapes_canvas(colors: &Colors) -> impl IntoElement {
    let fills = [rgb(0xd32f2f), rgb(0x388e3c), colors.selected];

    canvas(
        move |_bounds, _window, _cx| {},
        move |bounds, _prepaint_state, window, _cx| {
            for (index, color) in fills.into_iter().enumerate() {
                window.paint_quad(fill(
                    Bounds::new(
                        bounds.origin + point(px(10. + index as f32 * 70.), px(10.)),
                        size(px(60.), px(40.)),
                    ),
                    color,
                ));
            }
        },
    )
    .size_full()
}

// Close the star polygon so GPUI can fill the resulting path.
fn create_star(center: Point<Pixels>, outer_radius: f32, inner_radius: f32) -> Path<Pixels> {
    let mut builder = PathBuilder::fill();
    let points = 5;

    for i in 0..points * 2 {
        let angle =
            std::f32::consts::PI / 2.0 - (i as f32) * std::f32::consts::PI / (points as f32);
        let radius = if i % 2 == 0 {
            outer_radius
        } else {
            inner_radius
        };

        let x = center.x + px(angle.cos() * radius);
        let y = center.y - px(angle.sin() * radius);

        if i == 0 {
            builder.move_to(point(x, y));
        } else {
            builder.line_to(point(x, y));
        }
    }

    builder.close();
    builder.build().unwrap()
}

fn create_triangle(p1: Point<Pixels>, p2: Point<Pixels>, p3: Point<Pixels>) -> Path<Pixels> {
    let mut builder = PathBuilder::fill();
    builder.move_to(p1);
    builder.line_to(p2);
    builder.line_to(p3);
    builder.close();
    builder.build().unwrap()
}

pub(super) fn custom_paths_canvas(colors: &Colors) -> impl IntoElement {
    let warning = rgb(0xf9a825);
    let accent = colors.selected;

    canvas(
        move |_bounds, _window, _cx| {},
        move |bounds, _, window, _cx| {
            let center_y = bounds.origin.y + bounds.size.height / 2.0;

            let star_center = point(bounds.origin.x + px(50.), center_y);
            let star = create_star(star_center, 30., 15.);
            window.paint_path(star, warning);

            let tri_base_x = bounds.origin.x + px(120.);
            let triangle = create_triangle(
                point(tri_base_x + px(30.), center_y - px(25.)),
                point(tri_base_x, center_y + px(25.)),
                point(tri_base_x + px(60.), center_y + px(25.)),
            );
            window.paint_path(triangle, rgb(0x8b5cf6)); // Purple

            let arrow_x = bounds.origin.x + px(200.);
            let mut arrow_builder = PathBuilder::fill();
            arrow_builder.move_to(point(arrow_x, center_y));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y - px(20.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y - px(10.)));
            arrow_builder.line_to(point(arrow_x + px(50.), center_y - px(10.)));
            arrow_builder.line_to(point(arrow_x + px(50.), center_y + px(10.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y + px(10.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y + px(20.)));
            arrow_builder.close();
            let arrow = arrow_builder.build().unwrap();
            window.paint_path(arrow, accent);
        },
    )
    .size_full()
}
