//! Direct typed dimensions, color and Flex fields through the ordinary ports.
use gpui::prelude::*;
#[cfg(feature = "native-core")]
#[path = "support/renderer.rs"]
mod renderer;
struct Panel {
    width: Signal<u32>,
    surface: Signal<Color>,
    wrap: Signal<bool>,
}
impl Panel {
    const WIDTH: Source<Self, u32> =
        Source::new(FieldId::new(1), "width", |m| &m.width, |m| &mut m.width);
    const SURFACE: Source<Self, Color> = Source::new(
        FieldId::new(2),
        "surface",
        |m| &m.surface,
        |m| &mut m.surface,
    );
    const WRAP: Source<Self, bool> =
        Source::new(FieldId::new(3), "wrap", |m| &m.wrap, |m| &mut m.wrap);
    fn new() -> Self {
        Self {
            width: Signal::new(220),
            surface: Signal::new(rgb(0xdbeafe)),
            wrap: Signal::new(false),
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::WIDTH)
            .direct(Self::SURFACE)
            .direct(Self::WRAP)
    }
    fn view(&self) -> El<'_> {
        column((
            text("Direct reactive styles").text_lg(),
            div()
                .name("preview")
                .w(&self.width)
                .h(96)
                .bg(&self.surface)
                .rounded(12.0)
                .layout(Flex::row().gap(8).align(Align::Center).wrap(&self.wrap))
                .child((text("Width:"), text(&self.width), text("pixels"))),
            button("Resize").on_click(
                Self::WIDTH.update(|width| *width = if *width == 220 { 300 } else { 220 }),
            ),
            button("Recolor").on_click(Self::SURFACE.update(|color| {
                *color = if *color == rgb(0xdbeafe) {
                    rgb(0xfef3c7)
                } else {
                    rgb(0xdbeafe)
                }
            })),
            button("Toggle wrap").on_click(Self::WRAP.update(|wrap| *wrap = !*wrap)),
        ))
        .gap(12)
        .p(16)
    }
}
#[cfg(feature = "native-core")]
fn main() -> Result<(), gpui::NativeError> {
    gpui::Application::run_window(renderer::configure(
        gpui::Window::document(Panel::new())
            .title("GPUI — Reactive styles")
            .size(420, 300),
    ))
}
#[cfg(not(feature = "native-core"))]
fn main() -> Result<(), gpui::Error> {
    let mut win = Win::with_size(Panel::new(), 420, 300)?;
    let preview = win.query().name("preview").one()?;
    win.reset_counters()?;
    win.click(win.button("Resize"))?;
    win.click(win.button("Recolor"))?;
    assert_eq!(win.property(preview, gpui::property::WIDTH)?, Some(300.0));
    assert_eq!(win.counters().owner_reruns, 0);
    println!("{}", win.semantics()?.to_json()?);
    println!(
        "pixel digest: {:016x}; counters: {:?}",
        win.scene_digest()?,
        win.counters()
    );
    Ok(())
}
