//! Ordinary retained content: deliberately no virtual item source.
use gpui::prelude::*;
pub struct Panes {
    pub selected: Option<usize>,
}
impl View for Panes {
    fn view(&self) -> El<'_> {
        column((
            text("Retained detail pane").font_size(20).h(24),
            column((0..32).map(|index| {
                button(format!("Record {index}"))
                    .w(160)
                    .h(32)
                    .bg(if index % 2 == 0 {
                        Color::rgb(220, 230, 245)
                    } else {
                        Color::rgb(245, 230, 220)
                    })
                    .on_click(move |owner: &mut Self| owner.selected = Some(index))
            }))
            .scroll(Axis::BOTH)
            .w(96)
            .h(96)
            .name("Records"),
            text(format!("Selected {:?}", self.selected)),
        ))
    }
}
