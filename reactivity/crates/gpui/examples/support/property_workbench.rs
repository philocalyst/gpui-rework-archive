use gpui::prelude::*;
use gpui::{PropertyState, property::PropertyId, property_selection};
#[path = "value_entry.rs"]
pub mod value_entry;
use value_entry::ValueEntry;

// A representative library accepts typed appearance and caller behavior. The
// contained tool is a separate library; neither owns another runtime/schema.
pub struct LibraryButton {
    pub width: Signal<f32>,
    pub presses: u32,
    pub behavior: fn(&mut Self),
}
impl View for LibraryButton {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Source::new(
            FieldId::new(1),
            "width",
            |m: &Self| &m.width,
            |m| &mut m.width,
        ))
    }
    fn view(&self) -> El<'_> {
        button("Library button")
            .w(&self.width)
            .h(32)
            .bg(rgb(0x123456))
            .on_click(self.behavior)
    }
}
pub struct Companion {
    pub application: LibraryButton,
    pub editor: ValueEntry,
    pub show_application: bool,
    pub show_editor: bool,
    pub inspecting: bool,
}
impl Default for Companion {
    fn default() -> Self {
        Self {
            application: LibraryButton {
                width: Signal::new(120.),
                presses: 0,
                behavior: |m| m.presses += 3,
            },
            editor: ValueEntry::default(),
            show_application: true,
            show_editor: true,
            inspecting: false,
        }
    }
}
impl Companion {
    fn toggle_inspection(&mut self) {
        self.inspecting = !self.inspecting;
    }
    fn select_application(&self, target: Target) -> Option<(Target, PropertyId)> {
        Some((target, PropertyId::Width))
    }
    fn selected(&mut self, state: Result<PropertyState, &gpui::Error>) {
        self.editor.selected_logically(state);
    }
    const APP: Component<Self, LibraryButton> = Component::new(
        FieldId::new(1),
        "application",
        |m| &m.application,
        |m| &mut m.application,
    );
    const EDITOR: Component<Self, ValueEntry> =
        Component::new(FieldId::new(2), "editor", |m| &m.editor, |m| &mut m.editor);
}
impl View for Companion {
    fn sources() -> Sources<Self> {
        Sources::new().component(Self::APP).component(Self::EDITOR)
    }
    fn view(&self) -> El<'_> {
        row((
            if self.show_application {
                let application = Self::APP.view(self);
                if self.inspecting {
                    // This opt-in mode deliberately replaces the root action;
                    // ordinary mode retains the library's caller behavior.
                    application
                        .on_click(property_selection(Self::select_application, Self::selected))
                } else {
                    application
                }
            } else {
                div()
            },
            if self.show_editor {
                Self::EDITOR.view(self)
            } else {
                div()
            },
            checkbox("Inspect application", self.inspecting)
                .name("Inspect application")
                .on_click(Self::toggle_inspection),
        ))
        .gap(12)
    }
}
