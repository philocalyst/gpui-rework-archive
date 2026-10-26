//! One retained Unicode document through ordinary inputs, ports and native AT.
use gpui::{Application, Window, prelude::*};
#[path = "support/renderer.rs"]
mod renderer;
struct Document {
    value: Signal<String>,
}
impl Default for Document {
    fn default() -> Self {
        Self {
            value: Signal::new("Hello Ελληνικά Привет नमस्ते\r\nabc العربية אבג 123".into()),
        }
    }
}
impl Document {
    const VALUE: Source<Self, String> = Source::new(
        FieldId::new(1),
        "value",
        |model| &model.value,
        |model| &mut model.value,
    );
}
impl View for Document {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text("Unicode paragraphs and mixed directions").font_size(20),
            text_input(&self.value)
                .name("Document")
                .w(580)
                .h(110)
                .bg(Color::rgb(245, 245, 245)),
            text(&self.value).w(580),
            button("Clear").on_click(Self::VALUE.update(String::clear)),
        ))
        .w(620)
        .p(16)
        .gap(12)
        .bg(Color::WHITE)
    }
}
fn main() -> Result<(), gpui::NativeError> {
    Application::run_window(renderer::configure(Window::document(Document::default())))
}
