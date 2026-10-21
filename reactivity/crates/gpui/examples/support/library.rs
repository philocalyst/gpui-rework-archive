//! Bounded library rows over the same app-owned catalogue in native and tests.
use gpui::prelude::*;
use gpui::{ItemKey, ItemSource, ListId, uniform_list};

#[path = "catalogue.rs"]
pub mod catalogue;
use catalogue::{Catalogue, TrackId};

pub const LIBRARY: ListId = ListId::new(1);
pub const ROW_HEIGHT: f64 = 32.0;

pub struct Library {
    pub list_id: ListId,
    pub catalogue: Catalogue,
    pub selected: Option<TrackId>,
    pub play_requests: u64,
    pub viewport_height: f32,
}

impl Library {
    pub fn new(count: usize) -> Self {
        Self::with_id(count, LIBRARY)
    }

    /// V1 list IDs are window-unique; contained libraries supply distinct IDs.
    pub fn with_id(count: usize, list_id: ListId) -> Self {
        Self {
            list_id,
            catalogue: Catalogue::new(count),
            selected: None,
            play_requests: 0,
            viewport_height: 400.0,
        }
    }

    fn reverse(&mut self) {
        self.catalogue.reverse();
    }

    fn prepend(&mut self) {
        self.catalogue.prepend();
    }

    fn play(&mut self, id: TrackId) {
        if self.catalogue.index_of(id).is_some() {
            self.selected = Some(id);
            self.play_requests += 1;
        }
    }
}

impl ItemSource for Library {
    fn len(&self) -> usize {
        self.catalogue.len()
    }

    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(self.catalogue.id(index).0)
    }

    fn index_of(&self, key: ItemKey) -> Option<usize> {
        self.catalogue.index_of(TrackId(key.get()))
    }

    fn row(&self, index: usize) -> El<'_> {
        let id = self.catalogue.id(index);
        row((
            button("Play")
                .name(format!("Play {}", self.catalogue.title(id)))
                .w(64)
                .h(32)
                .bg(rgb(0xdbeafe))
                .on_click(move |library: &mut Self| library.play(id)),
            text(self.catalogue.title(id)).w(480).p(6),
        ))
        .h(32)
        .bg(if self.selected == Some(id) {
            rgb(0xfef3c7)
        } else if index.is_multiple_of(2) {
            rgb(0xf1f5f9)
        } else {
            Color::WHITE
        })
    }
}

impl View for Library {
    fn view(&self) -> El<'_> {
        column((
            text(format!(
                "Library — {} indexed recordings",
                self.catalogue.len()
            ))
            .font_size(24),
            text("Scroll to realize rows; reverse and prepend preserve item keys."),
            row((
                button("Reverse order").p(8).on_click(Self::reverse),
                button("Prepend recording").p(8).on_click(Self::prepend),
            ))
            .gap(12),
            uniform_list(self.list_id, self, ROW_HEIGHT)
                .name("Library recordings")
                .h(self.viewport_height)
                .w(700),
            text(match self.selected {
                Some(id) => format!(
                    "Selected recording {}; play requests {}",
                    id.0, self.play_requests
                ),
                None => "No recording selected".to_owned(),
            }),
        ))
        .gap(8)
        .p(12)
    }
}
