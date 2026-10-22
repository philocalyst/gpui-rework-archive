//! A retained sibling of the application, opt-in at mount. The only tool state
//! is a window-qualified selection and picking mode. UI text uses the ordinary
//! text lane; there is no copied application tree or per-node diagnostic data.
use super::*;
use crate::property::{BACKGROUND, WIDTH};
use crate::{El, button, column, div, rgb, row, text};
use std::fmt;

// Compare formatted fragments directly with the existing UTF-8 lease. Changed
// captions allocate once for formatting; idle refreshes need no scratch string.
struct CaptionText<'a>(&'a str);
impl fmt::Write for CaptionText<'_> {
    fn write_str(&mut self, part: &str) -> fmt::Result {
        self.0 = self.0.strip_prefix(part).ok_or(fmt::Error)?;
        Ok(())
    }
}
fn replace_caption(text: &mut TextSite, value: fmt::Arguments<'_>) -> bool {
    let mut remaining = CaptionText(&text.value);
    if fmt::write(&mut remaining, value).is_ok() && remaining.0.is_empty() {
        return false;
    }
    text.value = fmt::format(value).into();
    text.shaped = None;
    true
}

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
const PANEL_NODES: usize = 17;
#[derive(Clone, Copy, Debug)]
enum Caption {
    Pick,
    Selection,
    Layout,
    Width,
    Background,
    Bounds,
    Transform,
}
impl Caption {
    const ALL: [Self; 7] = [
        Self::Pick,
        Self::Selection,
        Self::Layout,
        Self::Width,
        Self::Background,
        Self::Bounds,
        Self::Transform,
    ];
    const fn offset(self) -> usize {
        match self {
            Self::Pick => 2,
            Self::Selection => 3,
            Self::Layout => 4,
            Self::Width => 5,
            Self::Background => 10,
            Self::Bounds => 15,
            Self::Transform => 16,
        }
    }
    const fn initial(self) -> &'static str {
        match self {
            Self::Pick => "Pick element",
            Self::Selection => "Select an application element",
            Self::Layout => "Layout: —",
            Self::Width => "Width: —",
            Self::Background => "Background: —",
            Self::Bounds => "Presented bounds: —",
            Self::Transform => "Presented transform: —",
        }
    }
    const fn kind(self) -> NodeKind {
        match self {
            Self::Pick => NodeKind::Button,
            _ => NodeKind::Text,
        }
    }
}
const _: () = {
    let mut i = 0;
    while i < Caption::ALL.len() {
        assert!(Caption::ALL[i].offset() < PANEL_NODES);
        let mut j = 0;
        while j < i {
            assert!(Caption::ALL[i].offset() != Caption::ALL[j].offset());
            j += 1;
        }
        i += 1;
    }
};
fn caption(field: Caption) -> El<'static> {
    line(field.initial())
}
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
            control(Caption::Pick.initial(), Pick),
            caption(Caption::Selection),
            caption(Caption::Layout),
            caption(Caption::Width),
            row((
                control("Width +20", WidthGrow),
                control("Auto", WidthAuto),
                control("Inherit width", WidthInherit),
            ))
            .gap(4),
            caption(Caption::Background),
            row((
                control("Set tint", BackgroundSet),
                control("Inherit tint", BackgroundInherit),
            ))
            .gap(4),
            control("Select parent", Parent),
            caption(Caption::Bounds),
            caption(Caption::Transform),
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
        if !self.inspector_enabled() {
            return None;
        }
        // The fixed panel is the final sibling in every description. Derive
        // its root from that contract without walking the application's tree.
        let panel = self.nodes.len().checked_sub(PANEL_NODES)?;
        debug_assert_eq!(self.nodes[panel].parent.index(), Some(0));
        Some(panel)
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
    pub(super) fn inspector_display(&self) -> Option<DisplayCaptions> {
        let panel = self.inspector_panel()?;
        let target = self.metadata.as_ref()?.inspector.as_ref()?.selected?;
        let selected = self.inspector_app_index(target).ok()?;
        Some(DisplayCaptions {
            panel,
            identity: self.nodes[selected].identity(),
            epoch: self.source_epoch,
            slots: [
                self.nodes[panel + Caption::Bounds.offset()].text_slot(),
                self.nodes[panel + Caption::Transform.offset()].text_slot(),
            ],
        })
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
            let before = self.styles.get(index);
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
        self.refresh_caption(
            panel,
            Caption::Pick,
            format_args!(
                "{}",
                if picking {
                    "Picking: click application"
                } else {
                    Caption::Pick.initial()
                }
            ),
        )?;
        if let Some(target) = selected {
            let index = self.inspector_app_index(target)?;
            let (width, background) = self
                .styles
                .with(index, |style| (WIDTH.get(style), BACKGROUND.get(style)));
            let width_presence = self.overrides.get(self.nodes[index].identity(), WIDTH);
            let background_presence = self.overrides.get(self.nodes[index].identity(), BACKGROUND);
            self.refresh_caption(
                panel,
                Caption::Selection,
                format_args!(
                    "Selected: {:?} #{}",
                    self.nodes[index].kind().role(),
                    self.nodes[index].identity()
                ),
            )?;
            self.refresh_caption(
                panel,
                Caption::Width,
                format_args!("Width: {width:?}\n{width_presence:?}"),
            )?;
            self.refresh_caption(
                panel,
                Caption::Background,
                format_args!(
                    "Background: {:.2?}\n{}",
                    background.channels(),
                    if matches!(background_presence, Contribution::Inherit) {
                        "Inherit"
                    } else {
                        "Set"
                    }
                ),
            )?;
            if laid_out {
                let size = self.layout.layout(self.layout_nodes[index])?.size;
                let epoch = self.source_epoch;
                self.refresh_caption(
                    panel,
                    Caption::Layout,
                    format_args!(
                        "Layout: {:.1} × {:.1}\nlogical epoch {}",
                        size.width, size.height, epoch
                    ),
                )?;
            }
        } else {
            for field in Caption::ALL {
                if !matches!(field, Caption::Pick) {
                    self.refresh_caption(panel, field, format_args!("{}", field.initial()))?;
                }
            }
        }
        Ok(())
    }
    fn refresh_caption(
        &mut self,
        panel: usize,
        field: Caption,
        value: fmt::Arguments<'_>,
    ) -> Result<(), Error> {
        let index = panel + field.offset();
        debug_assert_eq!(self.nodes[index].kind(), field.kind());
        let slot = self.nodes[index].text_slot();
        let text = slot
            .get_mut(&mut self.texts)
            .expect("fixed inspector text slot");
        if replace_caption(text, value) {
            self.dirty = true;
            // Fixed caption boxes still have content-size measurement answers.
            // Late captions leave this invalidation pending for the next pass.
            // Before a topology rebuild this may name the old layout cohort;
            // that whole tree will be replaced. Afterward it names the new one.
            if let Some(&node) = self.layout_nodes.get(index)
                && !self.layout.is_poisoned()
            {
                self.layout.mark_dirty(node)?;
            }
        }
        Ok(())
    }
}
// Preparation-local projection of two existing UI text slots. App rows precede
// the panel, so their actual candidate geometry is complete at this boundary.
// This neither retains another sheet nor borrows the previous presentation.
pub(super) struct DisplayCaptions {
    pub panel: usize,
    identity: u64,
    epoch: u64,
    slots: [TextSlot; 2],
}
impl DisplayCaptions {
    pub fn refresh(
        &self,
        candidate: &[Presented],
        texts: &mut [Option<TextSite>],
        layout: &mut LayoutTree,
        layout_nodes: &[NodeId],
    ) -> Result<(), Error> {
        let values = if let Some(node) = candidate.iter().find(|n| n.identity == self.identity) {
            let b = node.bounds;
            [
                format!(
                    "Displayed bounds @{}\n{:.1}, {:.1}  {:.1} × {:.1}",
                    self.epoch, b.x, b.y, b.width, b.height
                ),
                match node.transform.get() {
                    Some(m) => format!(
                        "Displayed transform @{}\n{:.1} {:.1} {:.1} {:.1} {:.1} {:.1}",
                        self.epoch, m.a, m.b, m.c, m.d, m.tx, m.ty
                    ),
                    None => format!("Displayed transform @{}: unavailable", self.epoch),
                },
            ]
        } else {
            [
                format!("Not displayed @{}", self.epoch),
                format!("Displayed transform @{}: —", self.epoch),
            ]
        };
        for ((slot, value), field) in self
            .slots
            .into_iter()
            .zip(values)
            .zip([Caption::Bounds, Caption::Transform])
        {
            let text = slot.get_mut(texts).expect("checked inspector caption");
            if text.value.as_ref() != value {
                text.value = value.into();
                text.shaped = None;
                layout.mark_dirty(layout_nodes[self.panel + field.offset()])?;
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
        self.runtime.changed_nodes = 0;
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
        let Some(target) = self
            .runtime
            .metadata
            .as_ref()
            .unwrap()
            .inspector
            .as_ref()
            .unwrap()
            .selected
        else {
            return Ok(self.commit());
        };
        let index = match self.inspector_app_index(target) {
            Ok(index) => index,
            Err(Error::StaleTarget) => return Ok(self.commit()),
            Err(error) => return Err(error),
        };
        match action {
            Pick => unreachable!(),
            Parent => {
                let parent = self.nodes[index].parent.index().ok_or(Error::StaleTarget)?;
                let target = self.sites.target(self.nodes[parent].identity());
                if self.inspector_app_index(target).is_err() {
                    return Ok(self.commit());
                }
                self.inspector_select(target)
            }
            WidthGrow => {
                let width = self
                    .styles
                    .with(index, |style| WIDTH.get(style))
                    .unwrap_or(0.0)
                    + 20.0;
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
    fn every_typed_caption_matches_its_constructed_panel_slot() {
        let nodes = panel(560.0).flatten();
        assert_eq!(nodes.len(), PANEL_NODES);
        for field in Caption::ALL {
            let node = &nodes[field.offset()];
            if matches!(field, Caption::Bounds | Caption::Transform) {
                assert_eq!(WIDTH.get(&node.style), Some(296.0));
                assert_eq!(crate::property::HEIGHT.get(&node.style), Some(36.0));
            }
            assert_eq!(node.kind, field.kind(), "{field:?}");
            assert_eq!(
                node.text.as_ref().unwrap().borrowed_value(),
                field.initial(),
                "{field:?}"
            );
        }
    }
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
        eprintln!("catalog_headers,El={},Style={},Presented={},Admission={},InspectorAction={}",
            size_of::<El<'_>>(), size_of::<Style>(), size_of::<Presented>(),
            size_of::<crate::element::Admission>(), size_of::<InspectorAction>());
        let mut tool = tool;
        tool.resize([800, 560]).unwrap();
        let idle = allocation_counter::measure(|| {
            for _ in 0..100 {
                tool.resize([800, 560]).unwrap();
            }
        });
        eprintln!("catalog_warm_inspector_idle,allocations={},total_bytes={},retained={}",
            idle.count_total, idle.bytes_total, idle.bytes_current);
    }
}
