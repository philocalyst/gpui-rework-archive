//! Analytic background materials. Run with --cpu --proof for a two-frame native ACK
//! proof; ordinary use keeps the window open and exposes typed inspection.
use gpui::{
    Extend, Gradient, GradientGeometry as Geometry, GradientStop as Stop, Interpolation, Point,
    prelude::*,
};
#[cfg(feature = "native-core")]
#[path = "support/renderer.rs"]
mod renderer;
struct Gallery {
    paints: Vec<Gradient>,
}
impl Gallery {
    fn new(phase: bool) -> Self {
        let stops = [
            Stop::new(-0.2, Color::linear_srgb(3., -0.1, 0.3, 0.).unwrap()),
            Stop::new(0.4, if phase { rgb(0xf59e0b) } else { rgb(0x22d3ee) }),
            Stop::new(0.4, rgb(0x4f46e5)),
            Stop::new(1.2, Color::linear_display_p3(0.2, 0.8, 2., 0.8).unwrap()),
        ];
        let geometries = [
            Geometry::Linear {
                start: Point { x: 0., y: 0. },
                end: Point { x: 0.8, y: 0.5 },
            },
            Geometry::Radial {
                center: Point { x: 0.4, y: 0.6 },
                radii: [0.3, 0.55],
            },
            Geometry::Conic {
                center: Point { x: 0.5, y: 0.5 },
                start_turn: -0.125,
            },
        ];
        Self {
            paints: geometries
                .into_iter()
                .flat_map(|geometry| {
                    [Extend::Pad, Extend::Repeat, Extend::Reflect]
                        .into_iter()
                        .map(move |extend| {
                            Gradient::new(geometry, &stops, extend, Interpolation::LinearSrgb)
                                .unwrap()
                        })
                })
                .collect(),
        }
    }
}
impl View for Gallery {
    fn view(&self) -> El<'_> {
        column((
            text("Analytic gradients · premultiplied linear sRGB").text_lg(),
            column(
                self.paints
                    .chunks(3)
                    .enumerate()
                    .map(|(row, paints)| row_view(row, paints)),
            )
            .gap(10),
        ))
        .p(16)
        .gap(12)
        .bg(rgb(0x101827))
    }
}
fn row_view(row_index: usize, paints: &[Gradient]) -> El<'_> {
    row(paints.iter().enumerate().map(move |(column, paint)| {
        div()
            .w(150)
            .h(96)
            .rounded(14.)
            .bg(paint)
            .name(format!("gradient-{row_index}-{column}"))
    }))
    .gap(10)
}
#[cfg(feature = "native-core")]
fn main() -> Result<(), gpui::NativeError> {
    let proof = std::env::args().any(|arg| arg == "--proof");
    let (remote, inbox) = Remote::bounded(1);
    let mut first = None;
    let window=renderer::configure(gpui::Window::document(Gallery::new(false)).size(520,390).title("GPUI analytic gradients"))
        .with_inbox(inbox,|model:&mut Gallery,phase:bool|*model=Gallery::new(phase))
        .on_presented(move |frame|{
            if !proof{return}
            match first {
                None=>{first=Some(frame.source_epoch);remote.try_send(true).unwrap();}
                Some(epoch) if frame.source_epoch>epoch=>{
                    eprintln!("GRADIENT_NATIVE_ACK,source_epoch={},presentation_epoch={},renderer={:?},gradient_count=9,owner_rebuild=true",frame.source_epoch,frame.presentation_epoch,frame.renderer);
                    std::process::exit(0);
                }
                _=>{}
            }
        });
    gpui::Application::run_window(window)
}
#[cfg(not(feature = "native-core"))]
fn main() -> Result<(), gpui::Error> {
    let mut window = Win::with_size(Gallery::new(false), 520, 390)?;
    let before = window.scene_digest()?;
    window.update(|model| *model = Gallery::new(true))?;
    assert_ne!(before, window.scene_digest()?);
    println!("GRADIENT_HEADLESS_UPDATE,nine_backgrounds,changed=true");
    Ok(())
}
