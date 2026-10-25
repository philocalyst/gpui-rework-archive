//! Text-sized controls must preserve the content width they measured.
use gpui::prelude::*;

#[path = "../examples/support/todos.rs"]
mod original_todo;

fn acknowledge<M: View + 'static>(win: &mut Win<M>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}

#[test]
fn unmodified_main_todo_add_remains_one_line() {
    let mut win = Win::recording(
        original_todo::Todos::default(),
        gpui::WindowOptions {
            size: [360, 640],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    let mut found = false;
    win.visit(|part| {
        if part.text() == Some("Add") {
            found = true;
            assert_eq!(
                part.text_geometry().unwrap().layout().lines().count(),
                1,
                "unmodified main example wrapped Add: {:?}",
                part.local_bounds()
            );
        }
    })
    .unwrap();
    assert!(found);
}

struct Caption {
    label: &'static str,
    font: f32,
    padding: f32,
    width: Option<f32>,
}
impl View for Caption {
    fn view(&self) -> El<'_> {
        let caption = button(self.label).font_size(self.font).p(self.padding);
        let caption = match self.width {
            Some(width) => caption.w(width),
            None => caption,
        };
        row((caption,)).layout(Flex::row().align(Align::Center))
    }
}

#[test]
fn intrinsic_fractional_captions_preserve_single_line_across_padding_and_dpi() {
    // Keep the font lease alive across windows; this is a behavior test, not a
    // repeated cold-font initialization benchmark.
    let _font = gpui_canvas::FontFace::bundled().unwrap();
    for label in ["Add", "office café אבג", "العربية  "] {
        for font in [13.25, 16., 19.75] {
            for padding in [0.125, 10., 512.25] {
                for scale in [1., 1.25, 2.] {
                    let mut win = Win::recording_scaled(
                        Caption {
                            label,
                            font,
                            padding,
                            width: None,
                        },
                        gpui::WindowOptions {
                            size: [4096, 4096],
                            ..Default::default()
                        },
                        scale,
                    )
                    .unwrap();
                    acknowledge(&mut win);
                    let mut found = false;
                    win.visit(|part| {
                        if part.text() == Some(label) {
                            found = true;
                            let lines = part.text_geometry().unwrap().layout().lines().count();
                            assert_eq!(
                                lines,
                                1,
                                "{label:?} font={font} padding={padding} scale={scale} local={:?}",
                                part.local_bounds()
                            );
                        }
                    })
                    .unwrap();
                    assert!(found);
                }
            }
        }
    }
}

#[test]
fn explicit_ulp_adjacent_widths_keep_real_wrapping_constraints() {
    let face = gpui_canvas::FontFace::bundled().unwrap();
    let mut shaper = face.shaper();
    let natural = shaper.shape_interactive("Add", 16., None).unwrap().width;
    for width in [natural.next_down(), natural, natural.next_up()] {
        let expected = shaper.shape_interactive("Add", 16., Some(width)).unwrap();
        let expected = expected.retain_geometry().unwrap().lines().count();
        let mut win = Win::recording(
            Caption {
                label: "Add",
                font: 16.,
                padding: 0.,
                width: Some(width),
            },
            gpui::WindowOptions {
                size: [360, 640],
                ..Default::default()
            },
        )
        .unwrap();
        acknowledge(&mut win);
        let mut found = false;
        win.visit(|part| {
            if part.text() == Some("Add") {
                found = true;
                assert_eq!(part.local_bounds().width.to_bits(), width.to_bits());
                assert_eq!(
                    part.text_geometry().unwrap().layout().lines().count(),
                    expected
                );
            }
        })
        .unwrap();
        assert!(found);
    }
}
