//! Submission allocation/capacity evidence; this is not a latency benchmark.
use gpui_canvas::{Affine, Canvas, Clip, ClipShape, Color, Point, Rect, TextLayout, TextSystem};

#[derive(Clone, Copy, Debug)]
enum Mode {
    Plain,
    Axis,
    Rounded,
}
fn submit(
    canvas: &mut Canvas,
    text: &mut TextSystem,
    layout: &TextLayout,
    labels: usize,
    mode: Mode,
    phase: usize,
) {
    canvas.clear(Color::WHITE);
    let viewport = Rect::new(0., 0., 512., 512.);
    let clip = match mode {
        Mode::Plain => Clip::Rect(viewport),
        Mode::Axis | Mode::Rounded => canvas
            .create_clip(
                None,
                if matches!(mode, Mode::Axis) {
                    ClipShape::Rect(viewport)
                } else {
                    ClipShape::RoundedRect {
                        rect: viewport,
                        radius: 24.,
                    }
                },
                Affine::IDENTITY,
            )
            .unwrap()
            .into(),
    };
    for label in 0..labels {
        canvas
            .draw_text(
                text,
                layout,
                Point {
                    x: (label % 5) as f32 * 100. + 2.,
                    y: (label / 5) as f32 * 28. + 2.,
                },
                Affine::translation(phase as f32 * 0.125, 0.),
                clip,
                if phase.is_multiple_of(2) {
                    Color::BLACK
                } else {
                    Color::rgb(31, 61, 97)
                },
            )
            .unwrap();
    }
}
fn main() {
    println!(
        "CLIP_PUBLIC_HEADERS canvas={} candidate={} handle={} optional_handle={} clip_argument={}",
        size_of::<Canvas>(),
        size_of::<gpui_canvas::CanvasScene<'_>>(),
        size_of::<gpui_canvas::ClipId>(),
        size_of::<Option<gpui_canvas::ClipId>>(),
        size_of::<Clip>()
    );
    for nodes in [1, 2, 4, 8, 16, 64] {
        let mut canvas = Canvas::recording(128, 128, Default::default()).unwrap();
        let count = allocation_counter::measure(|| {
            for _ in 0..nodes {
                canvas
                    .create_clip(
                        None,
                        ClipShape::RoundedRect {
                            rect: Rect::new(0., 0., 128., 128.),
                            radius: 24.,
                        },
                        Affine::IDENTITY,
                    )
                    .unwrap();
            }
        });
        println!(
            "CLIP_COLD nodes={nodes} allocations={} requested={} storage={:?}",
            count.count_total,
            count.bytes_total,
            canvas.prepared_scene().storage()
        );
    }
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("retained text", 9., None).unwrap();
    for labels in [1, 32, 48, 64] {
        for mode in [Mode::Plain, Mode::Axis, Mode::Rounded] {
            let mut canvas = Canvas::recording(512, 512, Default::default()).unwrap();
            for phase in 0..4 {
                submit(&mut canvas, &mut text, &layout, labels, mode, phase);
            }
            let count = allocation_counter::measure(|| {
                submit(&mut canvas, &mut text, &layout, labels, mode, 4)
            });
            let storage = canvas.prepared_scene().storage();
            println!(
                "CLIP_WARM_REBUILD labels={labels} mode={mode:?} allocations={} requested={} storage={storage:?}",
                count.count_total, count.bytes_total
            );
            let expected = if matches!(mode, Mode::Plain) { 0 } else { 3 };
            assert_eq!(
                count.count_total, expected,
                "one shared arena, no per-label clip allocation"
            );
        }
    }
}
