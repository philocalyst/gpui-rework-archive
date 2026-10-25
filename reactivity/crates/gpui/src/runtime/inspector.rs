//! A retained sibling of the application, opt-in at mount. The only tool state
//! is a window-qualified selection and picking mode. UI text uses the ordinary
//! text lane; there is no copied application tree or per-node diagnostic data.
use super::*;
use crate::property::{PROPERTIES, PropertyId, PropertyValue, ValueKind, WIDTH};
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

pub(super) struct Inspector {
    selected: Option<Target>,
    property: PropertyId,
    component: u8,
    picking: bool,
    rejected: Option<Rejection>,
}
impl Default for Inspector {
    fn default() -> Self {
        Self {
            selected: None,
            property: PropertyId::Width,
            component: 0,
            picking: false,
            rejected: None,
        }
    }
}
#[derive(Clone, Copy)]
pub(crate) enum WindowAction {
    Inspector(InspectorAction),
}
#[derive(Clone, Copy)]
pub(crate) enum InspectorAction {
    Pick,
    Parent,
    Choose(PropertyId),
    Edit(PropertyId, EditorOp),
}
#[derive(Clone, Copy)]
pub(crate) enum EditorOp {
    Component,
    Decrease,
    Increase,
    Auto,
    Inherit,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Rejection {
    Property(crate::property::PropertyErrorKind),
    InvalidColor,
    ColorOutOfRange,
}
// This fixed tree is an explicit private contract. Offsets are used only after
// discovering the current panel root in this description's logical cohort.
const CATALOG: usize = 5;
const EDITOR: usize = CATALOG + PROPERTIES.len();
const PANEL_NODES: usize = EDITOR + 10;
#[derive(Clone, Copy, Debug)]
enum Caption {
    Pick,
    Selection,
    Layout,
    Editor,
    Component,
    Bounds,
    Transform,
}
impl Caption {
    const ALL: [Self; 7] = [
        Self::Pick,
        Self::Selection,
        Self::Layout,
        Self::Editor,
        Self::Component,
        Self::Bounds,
        Self::Transform,
    ];
    const fn offset(self) -> usize {
        match self {
            Self::Pick => 2,
            Self::Selection => 3,
            Self::Layout => 4,
            Self::Editor => EDITOR,
            Self::Component => EDITOR + 1,
            Self::Bounds => EDITOR + 8,
            Self::Transform => EDITOR + 9,
        }
    }
    const fn initial(self) -> &'static str {
        match self {
            Self::Pick => "Pick element",
            Self::Selection => "Select an application element",
            Self::Layout => "Layout: —",
            Self::Editor => "Logical value: —",
            Self::Component => "Component",
            Self::Bounds => "Presented bounds: —",
            Self::Transform => "Presented transform: —",
        }
    }
    const fn kind(self) -> NodeKind {
        match self {
            Self::Pick | Self::Component => NodeKind::Button,
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
        .name(label)
        .h(28)
        .p(4)
        .font_size(12)
        .bg(rgb(0x334155))
        .fg(rgb(0xf8fafc))
        .on_window(WindowAction::Inspector(action))
}
fn panel(height: f32, property: PropertyId) -> El<'static> {
    use InspectorAction::*;
    column(
        [
            line("GPUI Inspector"),
            control(Caption::Pick.initial(), Pick),
            caption(Caption::Selection),
            caption(Caption::Layout),
        ]
        .into_iter()
        .chain(
            PROPERTIES
                .iter()
                .map(|info| control(info.name, Choose(info.id))),
        )
        .chain([
            caption(Caption::Editor),
            control(
                Caption::Component.initial(),
                Edit(property, EditorOp::Component),
            ),
            row((
                control("Decrease", Edit(property, EditorOp::Decrease)),
                control("Increase", Edit(property, EditorOp::Increase)),
                control("Auto", Edit(property, EditorOp::Auto)),
                control("Inherit", Edit(property, EditorOp::Inherit)),
            ))
            .gap(4),
            control("Select parent", Parent),
            caption(Caption::Bounds),
            caption(Caption::Transform),
        ]),
    )
    .w(320)
    .h(height)
    .p(12)
    .gap(8)
    .bg(rgb(0x0f172a))
    .scroll(crate::Axis::Y)
    .name("GPUI Inspector")
}
fn components(kind: ValueKind) -> u8 {
    match kind {
        ValueKind::Transform => 6,
        ValueKind::Color | ValueKind::Brush => 4,
        _ => 1,
    }
}
fn component_name(value: PropertyValue, component: u8) -> &'static str {
    let value = match value {
        PropertyValue::Brush(crate::Brush::Solid(c)) => PropertyValue::Color(c),
        value => value,
    };
    match value {
        PropertyValue::Transform(_) => ["a", "b", "c", "d", "tx", "ty"][component as usize],
        PropertyValue::Color(color) if color.space() == crate::ColorSpace::Oklch => {
            ["L", "C", "h", "alpha"][component as usize]
        }
        PropertyValue::Color(_) => ["R", "G", "B", "alpha"][component as usize],
        _ => "value",
    }
}
struct EditorValue(
    PropertyValue,
    u8,
    Option<(&'static str, usize, crate::Extend)>,
);
impl fmt::Display for EditorValue {
    fn fmt(&self, output: &mut fmt::Formatter<'_>) -> fmt::Result {
        let value = match self.0 {
            PropertyValue::Brush(crate::Brush::Solid(c)) => PropertyValue::Color(c),
            value => value,
        };
        match value {
            PropertyValue::Brush(crate::Brush::Gradient(_)) => {
                let (kind, stops, extend) = self.2.expect("admitted gradient summary");
                write!(
                    output,
                    "{kind}, {stops} stops, {extend:?}, LinearSrgb (read only)"
                )
            }
            PropertyValue::Color(color) => write!(
                output,
                "{:?} {}={:?}",
                color.space(),
                component_name(self.0, self.1),
                color.channels()[self.1 as usize]
            ),
            PropertyValue::Transform(value) => write!(
                output,
                "{}={:?}",
                component_name(self.0, self.1),
                [value.a, value.b, value.c, value.d, value.tx, value.ty][self.1 as usize]
            ),
            value => write!(output, "{value:?}"),
        }
    }
}
fn cycle<T: Copy + Eq>(current: T, values: &[T], direction: f32) -> T {
    values
        .iter()
        .position(|value| *value == current)
        .map_or(current, |index| {
            values[(index + if direction > 0. { 1 } else { values.len() - 1 }) % values.len()]
        })
}
// These are explicit step/cycle controls, not arbitrary numeric/text entry.
// The declaration and Color constructors remain the only range validators.
fn adjust(value: PropertyValue, component: u8, direction: f32) -> Result<PropertyValue, Error> {
    use crate::{Align, ColorSpace, Flow, Justify};
    use PropertyValue::*;
    if let PropertyValue::Brush(brush) = value {
        return match brush {
            crate::Brush::Solid(color) => {
                match adjust(PropertyValue::Color(color), component, direction)? {
                    PropertyValue::Color(color) => {
                        Ok(PropertyValue::Brush(crate::Brush::Solid(color)))
                    }
                    _ => unreachable!(),
                }
            }
            crate::Brush::Gradient(_) => Ok(value), // immutable resource summary; only Inherit edits it
        };
    }
    Ok(match value {
        Brush(_) => unreachable!(),
        Dimension(value) => Dimension(Some(value.unwrap_or(0.) + direction)),
        Number(value) => Number(value + direction),
        Flag(_) => Flag(direction > 0.),
        Flow(value) => Flow(cycle(value, &[Flow::Row, Flow::Column], direction)),
        Align(value) => Align(cycle(
            value,
            &[
                Align::Start,
                Align::End,
                Align::Center,
                Align::Stretch,
                Align::Baseline,
            ],
            direction,
        )),
        Justify(value) => Justify(cycle(
            value,
            &[
                Justify::Start,
                Justify::End,
                Justify::Center,
                Justify::SpaceBetween,
                Justify::SpaceAround,
                Justify::SpaceEvenly,
            ],
            direction,
        )),
        Transform(value) => {
            let mut values = [value.a, value.b, value.c, value.d, value.tx, value.ty];
            values[component as usize] += direction;
            let [a, b, c, d, tx, ty] = values;
            Transform(Affine { a, b, c, d, tx, ty })
        }
        Color(value) => {
            let mut values = value.channels();
            let step = if value.space() == ColorSpace::Oklch && component == 2 {
                15.
            } else {
                0.05
            };
            values[component as usize] += direction * step;
            let [a, b, c, alpha] = values;
            Color(match value.space() {
                ColorSpace::Srgb => crate::Color::srgb(a, b, c, alpha),
                ColorSpace::LinearSrgb => crate::Color::linear_srgb(a, b, c, alpha),
                ColorSpace::DisplayP3 => crate::Color::display_p3(a, b, c, alpha),
                ColorSpace::LinearDisplayP3 => crate::Color::linear_display_p3(a, b, c, alpha),
                ColorSpace::Oklch => crate::Color::oklch(a, b, c, alpha),
            }?)
        }
    })
}
impl<M: View + 'static> Runtime<M> {
    fn inspector(&self) -> Option<&Inspector> {
        self.metadata
            .as_deref()
            .and_then(|m| m.inspector.as_deref())
    }
    fn inspector_mut(&mut self) -> &mut Inspector {
        self.metadata
            .as_deref_mut()
            .and_then(|m| m.inspector.as_deref_mut())
            .expect("enabled inspector")
    }
    pub(super) fn inspector_enabled(&self) -> bool {
        self.inspector().is_some()
    }
    pub(super) fn inspector_picking(&self) -> bool {
        self.inspector().is_some_and(|i| i.picking)
    }
    fn inspector_panel(&self) -> Option<usize> {
        if !self.inspector_enabled() {
            return None;
        }
        // The fixed panel is the final sibling in every description. Derive
        // its root from that contract without walking the application's tree.
        let panel = self.nodes.len().checked_sub(PANEL_NODES)?;
        debug_assert_eq!(self.nodes[panel].parent().index(), Some(0));
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
    #[inline(never)]
    pub(super) fn inspector_pick(&self, point: Point) -> Option<Target> {
        self.inspector_pick_in_sheet(self.presented_hit_sheet(), point)
    }
    pub(super) fn inspector_pick_in_sheet(
        &self,
        sheet: query::HitSheet<'_>,
        point: Point,
    ) -> Option<Target> {
        self.inspector_panel()?;
        // Picking selects the foremost actual shape, even without a handler.
        let node = &sheet.nodes[sheet.hit(point)?];
        let target = self.sites.target(node.identity);
        self.inspector_app_index(target).ok().map(|_| target)
    }
    pub(super) fn inspector_display(&self) -> Option<DisplayCaptions> {
        let panel = self.inspector_panel()?;
        let target = self.inspector()?.selected?;
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
        let state = self.inspector().unwrap();
        let selected = state
            .selected
            .filter(|target| self.inspector_app_index(*target).is_ok());
        let picking = state.picking;
        let property = state.property;
        let component = state.component;
        let rejected = state.rejected;
        self.inspector_mut().selected = selected;
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
            let identity = self.nodes[index].identity();
            self.refresh_caption(
                panel,
                Caption::Selection,
                format_args!(
                    "Selected: {:?} #{}",
                    self.nodes[index].kind().role(),
                    self.nodes[index].identity()
                ),
            )?;
            for (row, info) in PROPERTIES.iter().enumerate() {
                let value = self.property_value_at(index, info.id)?;
                let presence = self.property_contribution_at(identity, info.id);
                self.refresh_text(
                    panel + CATALOG + row,
                    format_args!(
                        "{}{}: {value:?}\n{}",
                        if info.id == property { "> " } else { "" },
                        info.name,
                        if matches!(presence, Contribution::Inherit) {
                            "Inherit"
                        } else {
                            "Set"
                        }
                    ),
                )?;
            }
            let value = self.property_value_at(index, property)?;
            let gradient_summary = if let PropertyValue::Brush(crate::Brush::Gradient(key)) = value
            {
                self.backgrounds()
                    .and_then(|b| b.resources.get(&key))
                    .map(|gradient| {
                        let view = gradient.view();
                        let kind = match view.geometry() {
                            crate::GradientGeometry::Linear { .. } => "Linear",
                            crate::GradientGeometry::Radial { .. } => "Radial",
                            crate::GradientGeometry::Conic { .. } => "Conic",
                        };
                        (kind, view.stop_count(), view.extend())
                    })
            } else {
                None
            };
            if let Some(reason) = rejected {
                self.refresh_caption(
                    panel,
                    Caption::Editor,
                    format_args!("Last edit rejected: {reason:?}"),
                )?;
            } else {
                self.refresh_caption(
                    panel,
                    Caption::Editor,
                    format_args!(
                        "Logical {}:\n{}",
                        property.info().name,
                        EditorValue(value, component, gradient_summary)
                    ),
                )?;
            }
            self.refresh_caption(
                panel,
                Caption::Component,
                format_args!("Component: {}", component_name(value, component)),
            )?;
            if laid_out {
                let size = self.layout.layout(self.layout_nodes.required(index))?.size;
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
            for (row, info) in PROPERTIES.iter().enumerate() {
                self.refresh_text(panel + CATALOG + row, format_args!("{}", info.name))?;
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
        self.refresh_text(index, value)
    }
    fn refresh_text(&mut self, index: usize, value: fmt::Arguments<'_>) -> Result<(), Error> {
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
            if let Some(node) = self.layout_nodes.get(index)
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
        bases: geometry::Bases<'_>,
        texts: &mut [Option<TextSite>],
        layout: &mut LayoutTree,
        layout_nodes: &LayoutNodes,
    ) -> Result<(), Error> {
        let values = if let Some(node) = candidate.iter().find(|n| n.identity == self.identity) {
            let b = node.bounds;
            [
                format!(
                    "Displayed bounds @{}\n{:.1}, {:.1}  {:.1} × {:.1}",
                    self.epoch, b.x, b.y, b.width, b.height
                ),
                match node.transform(bases) {
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
                layout.mark_dirty(layout_nodes.required(self.panel + field.offset()))?;
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
        let state = self.inspector_mut();
        state.selected = Some(target);
        state.picking = false;
        state.rejected = None;
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
        let state = self.inspector().unwrap();
        let old = (state.property, state.component, state.picking);
        if matches!(action, Edit(id, _) if id != state.property) {
            return Err(Error::StaleTarget);
        }
        let control = match action {
            Pick => Some((state.property, state.component, true)),
            Choose(id) => Some((id, 0, state.picking)),
            Edit(id, EditorOp::Component) => Some((
                id,
                (state.component + 1) % components(id.info().kind),
                state.picking,
            )),
            _ => None,
        };
        if let Some(next) = control {
            if next == old && state.rejected.is_none() {
                return Ok(self.commit());
            }
            let epoch = self
                .source_epoch
                .checked_add(1)
                .ok_or(Error::EpochExhausted)?;
            let state = self.inspector_mut();
            (state.property, state.component, state.picking) = next;
            state.rejected = None;
            if next.0 != old.0 {
                let panel = self.inspector_panel().unwrap();
                for (offset, op) in [
                    (1, EditorOp::Component),
                    (3, EditorOp::Decrease),
                    (4, EditorOp::Increase),
                    (5, EditorOp::Auto),
                    (6, EditorOp::Inherit),
                ] {
                    let slot = self.nodes[panel + EDITOR + offset]
                        .handler_slot()
                        .expect("editor route");
                    self.runtime.handlers.as_deref_mut().unwrap().restore(
                        slot,
                        crate::element::Handler::window(WindowAction::Inspector(Edit(next.0, op))),
                    );
                }
            }
            self.runtime.source_epoch = epoch;
            self.runtime.counters.source_operations += 1;
            self.runtime.changed_nodes = 0;
            self.runtime.dirty = true;
            return self.present();
        }
        let Some(target) = self.inspector().unwrap().selected else {
            return Ok(self.commit());
        };
        let index = match self.inspector_app_index(target) {
            Ok(index) => index,
            Err(Error::StaleTarget) => return Ok(self.commit()),
            Err(error) => return Err(error),
        };
        match action {
            Pick | Choose(_) => unreachable!(),
            Parent => {
                let parent = self.nodes[index]
                    .parent()
                    .index()
                    .ok_or(Error::StaleTarget)?;
                let target = self.sites.target(self.nodes[parent].identity());
                if self.inspector_app_index(target).is_err() {
                    return Ok(self.commit());
                }
                self.inspector_select(target)
            }
            Edit(id, op) => {
                let value = self.property_value_at(index, id)?;
                if matches!(value, PropertyValue::Brush(crate::Brush::Gradient(_)))
                    && !matches!(op, EditorOp::Inherit)
                {
                    return Ok(self.commit());
                }
                let contribution = match op {
                    EditorOp::Inherit => Contribution::Inherit,
                    EditorOp::Auto => Contribution::Set(PropertyValue::Dimension(None)),
                    EditorOp::Decrease | EditorOp::Increase => {
                        let value = match adjust(
                            value,
                            old.1,
                            if matches!(op, EditorOp::Increase) {
                                1.
                            } else {
                                -1.
                            },
                        ) {
                            Ok(value) => value,
                            Err(Error::Canvas(gpui_canvas::Error::InvalidColor)) => {
                                return self.reject_editor(Rejection::InvalidColor);
                            }
                            Err(Error::Canvas(gpui_canvas::Error::ColorOutOfRange)) => {
                                return self.reject_editor(Rejection::ColorOutOfRange);
                            }
                            Err(error) => return Err(error),
                        };
                        Contribution::Set(value)
                    }
                    EditorOp::Component => unreachable!(),
                };
                if let Contribution::Set(value) = contribution
                    && let Err(error) = id.validate_erased(value)
                {
                    return self.reject_editor(Rejection::Property(error.reason));
                }
                let epoch = self
                    .source_epoch
                    .checked_add(1)
                    .ok_or(Error::EpochExhausted)?;
                self.inspector_mut().rejected = None;
                self.set_property_value_at(index, epoch, id, contribution)
            }
        }
    }
    fn reject_editor(&mut self, reason: Rejection) -> Result<Commit, Error> {
        let state = self.inspector_mut();
        if state.rejected == Some(reason) {
            return Ok(self.commit());
        }
        state.rejected = Some(reason);
        self.changed_nodes = 0;
        self.dirty = true;
        // Feedback is a same-S interaction frame. The canonical writer was not
        // admitted: no property/contribution/source epoch changes on rejection.
        self.present()
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
            .inspector()
            .and_then(|i| i.selected)
            .filter(|target| runtime.inspector_app_index(*target).is_ok()))
    }
}

pub(super) fn description<'a, M: View>(
    model: &'a M,
    inspector: Option<&Inspector>,
    size: [u32; 2],
    scale: f32,
) -> El<'a> {
    let app = model.view();
    let Some(inspector) = inspector else {
        return app;
    };
    let width = size[0] as f32 / scale;
    let height = size[1] as f32 / scale;
    // Installed at initial mount; tool changes retain the application path.
    row((
        div().w((width - 320.0).max(0.0)).h(height).child(app),
        panel(height, inspector.property),
    ))
    .w(width)
    .h(height)
}

#[cfg(test)]
mod tests {
    use super::*;
    // Frozen old direct-loop oracle: no window-extent gate or compressed skip.
    fn legacy_pick<M: View + 'static>(
        runtime: &Runtime<M>,
        sheet: &query::HitSheet<'_>,
        point: Point,
    ) -> Option<Target> {
        runtime.inspector_panel()?;
        for (index, node) in sheet.nodes.iter().enumerate().rev() {
            if !node.hittable
                || !query::contains_point(
                    sheet.nodes,
                    sheet.geometry,
                    sheet.has_viewports,
                    index,
                    point,
                )
            {
                continue;
            }
            let target = runtime.sites.target(node.identity);
            return runtime.inspector_app_index(target).ok().map(|_| target);
        }
        None
    }
    #[test]
    fn outward_bounds_preserve_strict_picking_but_do_not_admit_pending_focus_outside_window() {
        use crate::{Axis, prelude::*};
        struct Outside(Signal<String>);
        impl View for Outside {
            fn sources() -> Sources<Self> {
                Sources::new().direct(Source::new(
                    FieldId::new(1),
                    "input",
                    |m| &m.0,
                    |m| &mut m.0,
                ))
            }
            fn view(&self) -> El<'_> {
                column((
                    text_input(&self.0).w(240).h(32),
                    column((div().size(100).bg(Color::BLACK).name("outward child"),))
                        .size(100)
                        .scroll(Axis::Y)
                        .transform(Affine {
                            a: 10.,
                            b: 0.,
                            c: 0.,
                            d: 1.,
                            tx: 0.1,
                            ty: 0.,
                        }),
                ))
            }
        }
        let mut win = Win::recording_with_inspector(
            Outside(Signal::new("search".into())),
            WindowOptions {
                size: [720, 900],
                ..Default::default()
            },
        )
        .unwrap();
        let ack = |win: &mut Win<Outside>| {
            let token = win.with_scene(|_, t| t).unwrap();
            win.presented(token).unwrap();
        };
        ack(&mut win);
        win.activate(win.button("Pick element")).unwrap();
        ack(&mut win);
        win.click(win.input()).unwrap();
        ack(&mut win);
        let target = win.query().name("outward child").one().unwrap();
        let point = Point { x: 720., y: 52. };
        {
            let runtime = win.runtime().unwrap();
            let sheet = runtime.presented_hit_sheet();
            assert!(!sheet.contains_window(point));
            assert_eq!(legacy_pick(runtime, &sheet, point), Some(target));
            assert_eq!(runtime.inspector_pick(point), Some(target));
            assert_eq!(runtime.hit(point), None);
            let row = sheet
                .nodes
                .iter()
                .find(|row| row.identity == runtime.sites.resolve(target).unwrap())
                .unwrap();
            println!(
                "OUTWARD_PICK x_bits={} width_bits={} endpoint64={} point_x={}",
                row.bounds.x.to_bits(),
                row.bounds.width.to_bits(),
                f64::from(row.bounds.x) + f64::from(row.bounds.width),
                point.x
            );
        }
        let mut mouse = PointerSession::default();
        win.pointer_event(&mut mouse, PointerEvent::Move(point))
            .unwrap();
        let focus = win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
        assert_eq!(focus.source_epoch, focus.presentation_epoch + 1);
        assert_eq!(
            win.pointer_event(&mut mouse, PointerEvent::Release),
            Err(Error::PresentationStale)
        );
        assert_eq!(win.inspector_selected().unwrap(), None);
        ack(&mut win);
        // A new strict gesture preserves the preexisting portable picking policy.
        win.pointer_event(&mut mouse, PointerEvent::Press).unwrap();
        win.pointer_event(&mut mouse, PointerEvent::Release)
            .unwrap();
        assert_eq!(win.inspector_selected().unwrap(), Some(target));
    }

    #[test]
    fn picking_skip_matches_old_loop_for_compacted_p_and_c_with_outside_points() {
        use crate::{ItemKey, ItemSource, prelude::*, uniform_list};
        struct Rows;
        const LIST: ListId = ListId::new(1);
        impl ItemSource for Rows {
            fn len(&self) -> usize {
                100
            }
            fn key(&self, index: usize) -> ItemKey {
                ItemKey::new(index as u64)
            }
            fn index_of(&self, key: ItemKey) -> Option<usize> {
                (key.get() < 100).then_some(key.get() as usize)
            }
            fn row(&self, _: usize) -> El<'_> {
                column((
                    div().size(0),
                    div().h(0).child(div().size(20).bg(Color::BLACK)),
                ))
            }
        }
        impl View for Rows {
            fn view(&self) -> El<'_> {
                column((div().h(8), uniform_list(LIST, self, 32).size(64)))
            }
        }
        let mut win = Win::recording_with_inspector(
            Rows,
            WindowOptions {
                size: [720, 128],
                ..Default::default()
            },
        )
        .unwrap();
        for delta in [0., 0.25, 31., 64., -48.5] {
            if delta != 0. {
                let list = win.list(LIST).unwrap();
                win.scroll(list, delta).unwrap();
            }
            {
                let runtime = win.runtime().unwrap();
                assert!(runtime.prepared.as_ref().unwrap().nodes.len() < runtime.nodes.len());
                for y in (-1..130).step_by(4) {
                    for x in [-1., 0., 0.5, 31., 63.9, 64., 719.9, 720., 721.] {
                        let point = Point { x, y: y as f32 };
                        let sheet = runtime.candidate_hit_sheet().unwrap();
                        let expected = legacy_pick(runtime, &sheet, point);
                        assert_eq!(
                            runtime.inspector_pick_in_sheet(sheet, point),
                            expected,
                            "C {point:?}"
                        );
                    }
                }
            }
            let token = win.with_scene(|_, token| token).unwrap();
            win.presented(token).unwrap();
            let runtime = win.runtime().unwrap();
            for y in (-1..130).step_by(4) {
                for x in [-1., 0., 0.5, 31., 63.9, 64., 719.9, 720., 721.] {
                    let point = Point { x, y: y as f32 };
                    assert_eq!(
                        runtime.inspector_pick(point),
                        legacy_pick(runtime, &runtime.presented_hit_sheet(), point),
                        "P {point:?}"
                    );
                }
            }
        }
    }

    #[test]
    fn every_typed_caption_matches_its_constructed_panel_slot() {
        let nodes = panel(560.0, PropertyId::Width).flatten();
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
        eprintln!(
            "catalog_headers,El={},Style={},Presented={},Admission={},InspectorAction={}",
            size_of::<El<'_>>(),
            size_of::<Style>(),
            size_of::<Presented>(),
            size_of::<crate::element::Admission>(),
            size_of::<InspectorAction>()
        );
        let mut tool = tool;
        tool.resize([800, 560]).unwrap();
        let idle = allocation_counter::measure(|| {
            for _ in 0..100 {
                tool.resize([800, 560]).unwrap();
            }
        });
        eprintln!(
            "catalog_warm_inspector_idle,allocations={},total_bytes={},retained={}",
            idle.count_total, idle.bytes_total, idle.bytes_current
        );
    }
}
