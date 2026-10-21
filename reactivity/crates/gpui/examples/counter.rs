//! The ordinary runtime/input/layout/font/raster path, without a native adapter.
use gpui::prelude::*;
#[cfg(feature = "native")]
#[path = "support/renderer.rs"]
mod renderer;

struct Counter {
    count: Signal<u32>,
}
impl Counter {
    const COUNT: Source<Self, u32> =
        Source::new(FieldId::new(1), "count", |m| &m.count, |m| &mut m.count);
}
impl View for Counter {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COUNT)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.count).text_lg(),
            button("Increment")
                .p(8)
                .bg(rgb(0xdbeafe))
                .on_click(Self::COUNT.update(|count| *count += 1)),
        ))
        .p(12)
        .gap(8)
    }
}
#[cfg(feature = "native")]
fn main() -> Result<(), gpui::NativeError> {
    gpui::Application::run_window(renderer::configure(
        gpui::Window::document(Counter {
            count: Signal::new(0),
        })
        .title("GPUI — Counter")
        .size(360, 240),
    ))
}
#[cfg(not(feature = "native"))]
fn main() -> Result<(), gpui::Error> {
    let mut win = Win::with_size(
        Counter {
            count: Signal::new(0),
        },
        240,
        120,
    )?;
    win.click(win.button("Increment"))?;
    println!("{}", win.snapshot()?.to_json()?);
    println!(
        "pixel digest: {:016x}; counters: {:?}",
        win.scene_digest()?,
        win.counters()
    );
    Ok(())
}
