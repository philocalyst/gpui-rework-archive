//! A retained sibling of the application, opt-in at mount. The only tool state
//! is a window-qualified selection and picking mode. UI text uses the ordinary
//! text lane; there is no copied application tree or per-node diagnostic data.
use super::*;
use crate::property::{BACKGROUND, WIDTH};
use crate::{El, button, column, div, rgb, row, text};

#[derive(Default)]
pub(super) struct Inspector {
    selected: Option<Target>,
    picking: bool,
}
#[derive(Clone, Copy)]
pub(crate) enum WindowAction {
    Inspector(InspectorAction),
}
#[derive(Clone, Copy)]
pub(crate) enum InspectorAction {
    Pick,
    Parent,
    WidthGrow,
    WidthAuto,
    WidthInherit,
    BackgroundSet,
    BackgroundInherit,
}
// This fixed tree is an explicit private contract. Offsets are used only after
// discovering the current panel root in this description's logical cohort.
const SELECTED: usize = 3;
const DIMENSIONS: usize = 4;
const WIDTH_VALUE: usize = 5;
const BACKGROUND_VALUE: usize = 10;
const PRESENTED_BOUNDS: usize = 15;
const PRESENTED_TRANSFORM: usize = 16;
const PANEL_NODES: usize = 17;
fn line(value: &'static str) -> El<'static> {
    text(value).w(296).h(36).font_size(12).fg(rgb(0xcbd5e1))
}
fn control(label: &'static str, action: InspectorAction) -> El<'static> {
    button(label)
        .h(28)
        .p(4)
        .font_size(12)
        .bg(rgb(0x334155))
        .fg(rgb(0xf8fafc))
        .on_window(WindowAction::Inspector(action))
}
fn panel(height: f32) -> El<'static> {
    use InspectorAction::*;
    column(
        [
            line("GPUI Inspector"),
            control("Pick element", Pick),
            line("Select an application element"),
            line("Layout: —"),
            line("Width: —"),
            row((
                control("Width +20", WidthGrow),
                control("Auto", WidthAuto),
                control("Inherit width", WidthInherit),
            ))
            .gap(4),
            line("Background: —"),
            row((
                control("Set tint", BackgroundSet),
                control("Inherit tint", BackgroundInherit),
            ))
            .gap(4),
            control("Select parent", Parent),
            line("Presented bounds: —"),
            line("Presented transform: —"),
        ]
        .into_iter(),
    )
    .w(320)
    .h(height)
    .p(12)
    .gap(8)
    .bg(rgb(0x0f172a))
}
impl<M: View + 'static> Runtime<M> {
    pub(super) fn inspector_enabled(&self) -> bool {
        self.metadata
            .as_deref()
            .is_some_and(|m| m.inspector.is_some())
    }
    pub(super) fn inspector_picking(&self) -> bool {
        self.metadata
            .as_deref()
            .and_then(|m| m.inspector.as_deref())
            .is_some_and(|i| i.picking)
    }
    fn inspector_panel(&self) -> Option<usize> {
        self.inspector_enabled()
            .then(|| {
                self.nodes
                    .iter()
                    .enumerate()
                    .skip(2)
                    .find(|(_, n)| n.parent.index() == Some(0))
                    .map(|(i, _)| i)
            })
            .flatten()
    }
    fn inspector_app_index(&self, target: Target) -> Result<usize, Error> {
        let index = self.resolve_index(target)?;
        let panel = self.inspector_panel().ok_or(Error::MissingElement)?;
        if (2..panel).contains(&index) {
            Ok(index)
        } else {
            Err(Error::StaleTarget)
        }
    }
    pub(super) fn inspector_pick(&self, point: Point) -> Option<Target> {
        self.inspector_panel()?;
        // Unlike activation, picking selects the foremost actual shape, even
        // when it has no handler. The same rounded/clip hit kernel admits it.
        for (index, node) in self.presented.iter().enumerate().rev() {
            if !node.hittable || !self.sheet_hit(index, point) {
                continue;
            }
            let target = self.sites.target(node.identity);
            return self.inspector_app_index(target).ok().map(|_| target);
        }
        None
    }
    pub(super) fn refresh_inspector(&mut self, laid_out: bool) -> Result<(), Error> {
        let Some(panel) = self.inspector_panel() else {
            return Ok(());
        };
        debug_assert_eq!(self.nodes.len() - panel, PANEL_NODES);
        let width = self.requested_size[0] as f32 / self.requested_scale_factor;
        let height = self.requested_size[1] as f32 / self.requested_scale_factor;
        // Only the private shell follows viewport size. App-authored dimensions
        // and contributions remain untouched on native resize/DPI changes.
        for (index, width) in [(0, width), (1, (width - 320.0).max(0.0)), (panel, 320.0)] {
            let before = *self.styles.get(index);
            let mut after = before;
            WIDTH.set(&mut after, Some(width))?;
            crate::property::HEIGHT.set(&mut after, Some(height))?;
            if !styles::exact_eq(&before, &after) {
                self.styles.set(index, after, self.nodes.len());
                self.layout_dirty.insert(self.nodes[index].identity());
                self.dirty = true;
            }
        }
        let state = self.metadata.as_ref().unwrap().inspector.as_ref().unwrap();
        let selected = state
            .selected
            .filter(|target| self.inspector_app_index(*target).is_ok());
        let picking = state.picking;
        self.metadata
            .as_mut()
            .unwrap()
            .inspector
            .as_mut()
            .unwrap()
            .selected = selected;
        let mut values = vec![(
            2,
            if picking {
                "Picking: click application".into()
            } else {
                "Pick element".into()
            },
        )];
        if let Some(target) = selected {
            let index = self.inspector_app_index(target)?;
            let style = self.styles.get(index);
            let width = WIDTH.get(style);
            let background = BACKGROUND.get(style);
            let width_presence = self.overrides.get(self.nodes[index].identity(), WIDTH);
            let background_presence = self.overrides.get(self.nodes[index].identity(), BACKGROUND);
            values.push((
                SELECTED,
                format!(
                    "Selected: {:?} #{}",
                    self.nodes[index].kind().role(),
                    self.nodes[index].identity()
                ),
            ));
            values.push((WIDTH_VALUE, format!("Width: {width:?}\n{width_presence:?}")));
            values.push((
                BACKGROUND_VALUE,
                format!(
                    "Background: {:.2?}\n{}",
                    background.channels(),
                    if matches!(background_presence, Contribution::Inherit) {
                        "Inherit"
                    } else {
                        "Set"
                    }
                ),
            ));
            if let Some(node) = self
                .presented
                .iter()
                .find(|n| n.identity == self.nodes[index].identity())
            {
                let b = node.bounds;
                values.push((
                    PRESENTED_BOUNDS,
                    format!(
                        "Displayed bounds @{}\n{:.1}, {:.1}  {:.1} × {:.1}",
                        self.presentation_epoch, b.x, b.y, b.width, b.height
                    ),
                ));
                values.push((
                    PRESENTED_TRANSFORM,
                    match node.transform.get() {
                        Some(m) => format!(
                            "Displayed transform @{}\n{:.1} {:.1} {:.1} {:.1} {:.1} {:.1}",
                            self.presentation_epoch, m.a, m.b, m.c, m.d, m.tx, m.ty
                        ),
                        None => "Displayed transform: unavailable".into(),
                    },
                ));
            } else {
                values.extend([
                    (PRESENTED_BOUNDS, "Not yet displayed".into()),
                    (PRESENTED_TRANSFORM, "Displayed transform: —".into()),
                ]);
            }
            if laid_out {
                let layout = self.layout.layout(self.layout_nodes[index])?;
                values.push((
                    DIMENSIONS,
                    format!(
                        "Layout: {:.1} × {:.1}\nlogical epoch {}",
                        layout.size.width, layout.size.height, self.source_epoch
                    ),
                ));
            }
        } else {
            values.extend([
                (SELECTED, "Select an application element".into()),
                (DIMENSIONS, "Layout: —".into()),
                (WIDTH_VALUE, "Width: —".into()),
                (BACKGROUND_VALUE, "Background: —".into()),
                (PRESENTED_BOUNDS, "Presented bounds: —".into()),
                (PRESENTED_TRANSFORM, "Presented transform: —".into()),
            ]);
        }
        for (offset, value) in values {
            let slot = self.nodes[panel + offset].text_slot();
            let text = slot
                .get_mut(&mut self.texts)
                .expect("fixed inspector text slot");
            if text.value.as_ref() != value {
                text.value = value.into();
                text.shaped = None;
                self.dirty = true;
            }
        }
        Ok(())
    }
}
impl<M: View + 'static, L: LaneSet<M>> RuntimeMut<'_, M, L> {
    pub(super) fn inspector_select(&mut self, target: Target) -> Result<Commit, Error> {
        self.live()?;
        self.inspector_app_index(target)?;
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        let state = self
            .runtime
            .metadata
            .as_mut()
            .unwrap()
            .inspector
            .as_mut()
            .unwrap();
        state.selected = Some(target);
        state.picking = false;
        self.runtime.source_epoch = epoch;
        self.runtime.counters.source_operations += 1;
        self.runtime.changed_nodes = 0;
        self.runtime.dirty = true;
        self.present()
    }
    pub(super) fn window_action(&mut self, action: WindowAction) -> Result<Commit, Error> {
        use InspectorAction::*;
        let WindowAction::Inspector(action) = action;
        self.live()?;
        if !self.inspector_enabled() {
            return Err(Error::MissingElement);
        }
        if matches!(action, Pick) {
            let epoch = self
                .source_epoch
                .checked_add(1)
                .ok_or(Error::EpochExhausted)?;
            self.runtime
                .metadata
                .as_mut()
                .unwrap()
                .inspector
                .as_mut()
                .unwrap()
                .picking = true;
            self.runtime.source_epoch = epoch;
            self.runtime.counters.source_operations += 1;
            self.runtime.changed_nodes = 0;
            return self.present();
        }
        let target = self
            .runtime
            .metadata
            .as_ref()
            .unwrap()
            .inspector
            .as_ref()
            .unwrap()
            .selected
            .ok_or(Error::MissingElement)?;
        let index = self.inspector_app_index(target)?;
        match action {
            Pick => unreachable!(),
            Parent => {
                let parent = self.nodes[index].parent.index().ok_or(Error::StaleTarget)?;
                self.inspector_select(self.sites.target(self.nodes[parent].identity()))
            }
            WidthGrow => {
                let width = WIDTH.get(self.styles.get(index)).unwrap_or(0.0) + 20.0;
                self.set_style_property(target, WIDTH, Contribution::Set(Some(width)))
            }
            WidthAuto => self.set_style_property(target, WIDTH, Contribution::Set(None)),
            WidthInherit => self.set_style_property(target, WIDTH, Contribution::Inherit),
            BackgroundSet => {
                self.set_style_property(target, BACKGROUND, Contribution::Set(rgb(0x0d9488)))
            }
            BackgroundInherit => self.set_style_property(target, BACKGROUND, Contribution::Inherit),
        }
    }
}
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Select a live application site in an inspector configured at mount.
    /// Foreign windows, removed sites and the inspector's own controls reject
    /// before changing selection or admitting a source operation.
    pub fn inspector_select(&mut self, target: Target) -> Result<Commit, Error> {
        self.runtime_mut()?.inspector_select(target)
    }
    pub fn inspector_selected(&self) -> Result<Option<Target>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        Ok(runtime
            .metadata
            .as_deref()
            .and_then(|m| m.inspector.as_deref())
            .and_then(|i| i.selected)
            .filter(|target| runtime.inspector_app_index(*target).is_ok()))
    }
}

pub(super) fn description<M: View>(model: &M, enabled: bool, size: [u32; 2], scale: f32) -> El<'_> {
    let app = model.view();
    if !enabled {
        return app;
    }
    let width = size[0] as f32 / scale;
    let height = size[1] as f32 / scale;
    // Installed at initial mount; tool changes retain the application path.
    row((
        div().w((width - 320.0).max(0.0)).h(height).child(app),
        panel(height),
    ))
    .w(width)
    .h(height)
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn plain_window_has_no_tool_allocation_and_inspector_uses_only_cold_storage() {
        struct Empty;
        impl View for Empty {
            fn view(&self) -> El<'_> {
                div()
            }
        }
        let mut plain = None;
        let plain_cost =
            allocation_counter::measure(|| plain = Some(Win::with_size(Empty, 800, 560).unwrap()));
        let plain = plain.unwrap();
        assert!(plain.runtime().unwrap().metadata.is_none());
        let mut tool = None;
        let tool_cost = allocation_counter::measure(|| {
            tool = Some(
                Win::with_inspector(
                    Empty,
                    WindowOptions {
                        size: [800, 560],
                        ..Default::default()
                    },
                )
                .unwrap(),
            )
        });
        let tool = tool.unwrap();
        eprintln!(
            "inspector_blank_headless_retained,plain_bytes={},plain_allocs={},tool_bytes={},tool_allocs={},delta_bytes={} (includes font/text/layout/paint resources)",
            plain_cost.bytes_current,
            plain_cost.count_current,
            tool_cost.bytes_current,
            tool_cost.count_current,
            tool_cost.bytes_current as i64 - plain_cost.bytes_current as i64
        );
        let runtime = tool.runtime().unwrap();
        assert_eq!(runtime.nodes.len(), 1 + 2 + PANEL_NODES);
        assert_eq!(size_of::<crate::element::Handler>(), 16);
        assert_eq!(size_of::<Inspector>(), 24);
        assert_eq!(size_of::<Option<Box<Inspector>>>(), 8);
        eprintln!(
            "inspector_bytes,Node={},Runtime={},Metadata={},Inspector={},Handler={},WindowAction={},tool_nodes={},texts_capacity={}",
            size_of::<Node>(),
            size_of::<Runtime<Empty>>(),
            size_of::<Metadata>(),
            size_of::<Inspector>(),
            size_of::<crate::element::Handler>(),
            size_of::<WindowAction>(),
            PANEL_NODES,
            runtime.texts.capacity()
        );
    }
}
