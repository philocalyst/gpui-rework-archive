//! Full-rebuild control for the color-only pointer scenario.
use gpui::{
    Application, Color, El, FieldId, ItemKey, ItemSource, ListId, RendererPolicy, Signal, Source,
    Sources, View, Window, button, column, div, rgb, row, text, uniform_list,
};

const LIST: ListId = ListId::new(1);
const OFF: Color = rgb(0xdc141e);
const ON: Color = rgb(0x14be28);

struct Bench {
    count: usize,
    virtualized: bool,
    color: Signal<Color>,
}
impl Bench {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
}
impl ItemSource for Bench {
    fn len(&self) -> usize {
        self.count
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64 + 1)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let index = usize::try_from(key.get().checked_sub(1)?).ok()?;
        (index < self.count).then_some(index)
    }
    fn row(&self, index: usize) -> El<'_> {
        text(format!("row {index}")).font_size(16).h(24)
    }
}
impl View for Bench {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        let header = row((
            div().w(40).h(40).bg(*self.color),
            button("Toggle pixel marker")
                .font_size(16)
                .w(240)
                .h(40)
                // Deliberately coarse: this comparison rebuilds the same view.
                .on_click(|model: &mut Self| {
                    *model.color = if *model.color == OFF { ON } else { OFF };
                }),
            text("marker").font_size(16),
        ))
        .h(48)
        .gap(8);
        let body = if self.virtualized {
            uniform_list(LIST, self, 24).w(784).h(530)
        } else {
            column((0..self.count).map(|index| {
                div()
                    .w(784)
                    .h(24)
                    .child(text(format!("row {index}")).font_size(16))
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
        .and_then(|value| value.parse().ok())
        .unwrap_or(0);
    let virtualized = std::env::var("LUNA_MODE").is_ok_and(|value| value == "virtual");
    let renderer = if std::env::var("LUNA_RENDERER").is_ok_and(|value| value == "auto") {
        RendererPolicy::Auto
    } else {
        RendererPolicy::ReferenceCpu
    };
    let mut window = Window::document(Bench {
        count,
        virtualized,
        color: Signal::new(OFF),
    })
    .title("Luna Benchmark")
    .size(800, 600)
    .renderer(renderer);
    if std::env::var_os("LUNA_STAGES").is_some() {
        window = window.on_presented(|frame| {
            eprintln!(
                "LUNA_PRESENT,{:?},{},{}",
                frame.renderer, frame.source_epoch, frame.presentation_epoch
            );
        });
    }
    Application::run_window(window)
}
