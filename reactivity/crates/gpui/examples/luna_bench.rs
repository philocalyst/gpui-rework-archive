//! Native Xvfb fixture for cross-framework startup and input-to-present runs.
use gpui::{
    Application, El, ItemKey, ItemSource, ListId, RendererPolicy, View, Window, button, column,
    div, rgb, row, text, uniform_list,
};

const LIST: ListId = ListId::new(1);

struct Bench {
    count: usize,
    virtualized: bool,
    on: bool,
}
impl ItemSource for Bench {
    fn len(&self) -> usize {
        self.count
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64 + 1)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let i = usize::try_from(key.get().checked_sub(1)?).ok()?;
        (i < self.count).then_some(i)
    }
    fn row(&self, index: usize) -> El<'_> {
        text(format!("row {index}")).font_size(16).h(24)
    }
}
impl View for Bench {
    fn view(&self) -> El<'_> {
        let marker = if self.on {
            rgb(0x14be28)
        } else {
            rgb(0xdc141e)
        };
        let header = row((
            div().w(40).h(40).bg(marker),
            button("Toggle pixel marker")
                .font_size(16)
                .w(240)
                .h(40)
                .on_click(|m: &mut Self| m.on = !m.on),
            text("marker").font_size(16),
        ))
        .h(48)
        .gap(8);
        let body = if self.virtualized {
            uniform_list(LIST, self, 24).w(784).h(530)
        } else {
            column((0..self.count).map(|i| {
                div()
                    .w(784)
                    .h(24)
                    .child(text(format!("row {i}")).font_size(16))
            }))
            .w(784)
            .h(530)
        };
        column((header, body)).w(800).h(600).p(8).gap(6)
    }
}

fn main() -> Result<(), gpui::NativeError> {
    let count = std::env::var("LUNA_ROWS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(0);
    let virtualized = std::env::var("LUNA_MODE").is_ok_and(|s| s == "virtual");
    let renderer = if std::env::var("LUNA_RENDERER").is_ok_and(|s| s == "auto") {
        RendererPolicy::Auto
    } else {
        RendererPolicy::ReferenceCpu
    };
    let started = std::time::Instant::now();
    let mut window = Window::document(Bench {
        count,
        virtualized,
        on: false,
    })
    .title("Luna Benchmark")
    .size(800, 600)
    .renderer(renderer);
    if std::env::var_os("LUNA_STAGES").is_some() {
        window = window.on_presented(move |frame| {
            eprintln!(
                "LUNA_PRESENT,{:?},{},{},{}",
                frame.renderer,
                frame.source_epoch,
                frame.presentation_epoch,
                started.elapsed().as_micros()
            );
        });
    }
    Application::run_window(window)
}
