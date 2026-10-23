use gpui::{Application, NativeError, RendererPolicy, Window, prelude::*};
struct Example {
    search: Signal<String>,
    checked: bool,
    changes: usize,
}
impl View for Example {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Source::new(
            FieldId::new(1),
            "search",
            |m| &m.search,
            |m| &mut m.search,
        ))
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.search).name("Search").w(240).h(32),
            checkbox("Toggle details", self.checked)
                .name("Toggle details")
                .w(240)
                .h(40)
                .on_click(|m: &mut Self| {
                    m.checked = !m.checked;
                    m.changes += 1;
                }),
            div()
                .w(240)
                .h(80)
                .bg(rgb(0x334155))
                .rounded(20.)
                .transform(Affine {
                    a: 1.,
                    b: 0.1,
                    c: 0.2,
                    d: 1.,
                    tx: 0.,
                    ty: 0.,
                })
                .name("Inspected shape"),
            text(format!("Changes: {}", self.changes)),
        ))
        .p(16)
        .gap(12)
    }
}
fn main() -> Result<(), NativeError> {
    let renderer = if std::env::args().nth(1).as_deref() == Some("--gpu") {
        RendererPolicy::Gpu
    } else {
        RendererPolicy::ReferenceCpu
    };
    Application::run_window(
        Window::document(Example {
            search: Signal::new("search".into()),
            checked: false,
            changes: 0,
        })
        .title("GPUI Inspector Pointer Qualification")
        .size(720, 900)
        .inspector()
        .renderer(renderer)
        .on_presented(|frame| {
            println!(
                "INSPECTOR_FRAME,{:?},{},{}",
                frame.renderer, frame.source_epoch, frame.presentation_epoch
            )
        }),
    )
}
