//! Actual retained dev tools beside an ordinary application. Click Pick element,
//! then a card; use Width +20 / Auto / Inherit and Set tint / Inherit tint.
use gpui::{Application, NativeError, Window, prelude::*};
#[path = "support/renderer.rs"]
mod renderer;
struct Example {
    count: u32,
}
impl View for Example {
    fn view(&self) -> El<'_> {
        column((
            text("Inspect this application")
                .font_size(24)
                .fg(rgb(0xe2e8f0)),
            text("Pick a card, then edit its live style.").fg(rgb(0x94a3b8)),
            column((
                text("First card").fg(rgb(0xf8fafc)),
                text("A noninteractive shape")
                    .font_size(12)
                    .fg(rgb(0xcbd5e1)),
            ))
            .w(260)
            .h(110)
            .p(16)
            .gap(8)
            .rounded(12.0)
            .bg(rgb(0x334155)),
            column((
                text("Second card").fg(rgb(0xf8fafc)),
                text("Independent typed contributions")
                    .font_size(12)
                    .fg(rgb(0xcbd5e1)),
            ))
            .w(280)
            .h(100)
            .p(16)
            .gap(8)
            .rounded(12.0)
            .bg(rgb(0x1e3a5f)),
            button(format!("Application counter: {}", self.count))
                .p(12)
                .bg(rgb(0x475569))
                .fg(rgb(0xf8fafc))
                .on_click(|m: &mut Self| m.count += 1),
        ))
        .p(24)
        .gap(16)
        .bg(rgb(0x1e293b))
    }
}
fn main() -> Result<(), NativeError> {
    Application::run_window(renderer::configure(
        Window::document(Example { count: 0 })
            .title("GPUI Inspector")
            .size(1000, 640)
            .inspector()
            .on_presented(|frame| {
                println!(
                    "inspector-presented {:?} {} {}",
                    frame.renderer, frame.source_epoch, frame.presentation_epoch
                )
            }),
    ))
}
