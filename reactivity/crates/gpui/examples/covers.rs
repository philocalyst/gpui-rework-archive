//! Caller-provided immutable pixels through the ordinary native graphics port.
use gpui::{AlphaMode, Application, ImageProfile, Window, prelude::*};
#[path = "support/renderer.rs"]
mod renderer;
struct Gallery {
    covers: [Image; 3],
    selected: usize,
}
impl Gallery {
    fn new() -> Self {
        let covers = std::array::from_fn(|variant| {
            let pixels = (0..128 * 128)
                .flat_map(|i| {
                    let (x, y) = (i % 128, i / 128);
                    let wave = ((x ^ y) * 2) as u8;
                    match variant {
                        0 => [wave, (x * 2) as u8, (y * 2) as u8, 255],
                        1 => [(y * 2) as u8, wave, 160, 255],
                        _ => [96, (x * 2) as u8, wave, 255],
                    }
                })
                .collect::<Vec<_>>()
                .into_boxed_slice();
            Image::rgba8(128, 128, ImageProfile::Srgb, AlphaMode::Straight, pixels).unwrap()
        });
        Self {
            covers,
            selected: 0,
        }
    }
    fn next(&mut self) {
        self.selected = (self.selected + 1) % self.covers.len();
    }
}
impl View for Gallery {
    fn view(&self) -> El<'_> {
        column((
            text("Immutable cover art").font_size(24),
            image(&self.covers[self.selected])
                .w(256)
                .h(256)
                .rounded(16.0)
                .name("Selected cover art"),
            row((
                image(&self.covers[0])
                    .w(64)
                    .h(64)
                    .rounded_md()
                    .name("First cover"),
                image(&self.covers[1])
                    .w(64)
                    .h(64)
                    .rounded_md()
                    .name("Second cover"),
                image(&self.covers[2])
                    .w(64)
                    .h(64)
                    .rounded_md()
                    .name("Third cover"),
            ))
            .gap(12),
            button("Next cover").on_click(Self::next),
            text("RGBA8 leases stay packed. Decoding and I/O remain outside View."),
        ))
        .gap(12)
        .p(16)
        .bg(Color::WHITE)
    }
}
fn main() -> Result<(), gpui::NativeError> {
    Application::run_window(renderer::configure(
        Window::document(Gallery::new()).size(620, 480),
    ))
}
