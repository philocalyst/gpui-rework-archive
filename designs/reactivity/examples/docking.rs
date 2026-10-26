//! Iced `pane_grid` interaction on 06's two algebras — not Iced's one tree.
//!
//! Chrome (sidebar/panel) stays `Workbench`. Editor splits are `EditorGrid`.
//! What we steal from Iced: ratio in 0..1, sash leeway, last-active, maximize.
//!
//! Identity is `Slot<T>` in a `List<T>` (07 §11). There is NO `GroupId`/`ViewportId`/`PanelId`
//! newtype and NO `ComponentMap<Id, T>` — that parallel id-plus-map is exactly what the durable
//! slot deletes. Panes/groups/panels are nested `List`s; every cross-reference (last-active pane,
//! the active tab) is a `Copy` `Slot<T>`, generation-checked and never an index.

use gpui::prelude::*;

struct Workspace {
    chrome: Workbench,   // sidebar / panel docks
    editors: EditorGrid, // editor split geometry
    groups: List<Group>, // tab groups in the editor area
    panels: List<Panel>, // dockable side panels
}

struct Group {
    tabs: List<Viewport>,
    active: Option<Slot<Viewport>>, // last-active tab: a slot, not an index or an id
}

impl Group {
    fn focus(&mut self, tab: Slot<Viewport>) {
        self.active = Some(tab); // revalidated on delivery; a closed tab is `None`, never a panic
    }
}

impl View for Group {
    fn view(&self) -> El<'_> {
        tabs(&self.tabs, Viewport::view)
            .active(self.active)
            .on_select(Group::focus)
    }
}

struct Viewport {
    title: String,
}

impl View for Viewport {
    fn view(&self) -> El<'_> {
        // Styled box, one child (14 §2.1) — `column()` never takes zero args.
        div().p_3().child(text(&self.title))
    }
}

struct Panel {
    title: String,
}

impl View for Panel {
    fn view(&self) -> El<'_> {
        // Styled box, one child (14 §2.1) — `column()` never takes zero args.
        div().p_3().child(text(&self.title))
    }
}

impl Workspace {
    fn chrome_changed(&mut self, _d: ChromeDelta) {}
    fn grid_changed(&mut self, _d: GridDelta) {}
}

impl View for Workspace {
    fn view(&self) -> El<'_> {
        workbench(&self.chrome)
            // A dock is a List + a row fn — the same shape as any virtualized list.
            .dock(Region::Sidebar, dock_stack(&self.panels, Panel::view))
            .center(
                editor_grid(&self.editors)
                    .sash(Sash::default().leeway(4)) // hit = spacing + leeway; visual stays thin
                    .groups(&self.groups, Group::view), // groups by slot; no id lookup
            )
            .on_chrome(Workspace::chrome_changed)
            .on_grid(Workspace::grid_changed)
        // split ratio is 0..1 (restore survives window size); last-active pane is a Slot;
        // maximize is one flag and other ratios keep.
    }
}

fn main() {
    Application::run(
        Window::document(Workspace {
            chrome: Workbench::default(),
            editors: EditorGrid::default(),
            groups: List::new(),
            panels: List::new(),
        })
        .title("Dock")
        .size(960, 640),
    );
}
