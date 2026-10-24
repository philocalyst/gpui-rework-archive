//! Closed text metadata selectors. Names, descriptions and edited values are
//! separate ports; metadata does not participate in glyph shaping or layout.
use crate::source::Text;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SemanticText {
    Name,
    Description,
}
impl SemanticText {
    pub const fn name(self) -> &'static str {
        match self {
            Self::Name => "name",
            Self::Description => "description",
        }
    }
}
pub const NAME: SemanticText = SemanticText::Name;
pub const DESCRIPTION: SemanticText = SemanticText::Description;

#[derive(Default)]
pub(crate) struct Annotations<'a> {
    pub name: Option<Text<'a>>,
    pub description: Option<Text<'a>>,
}
impl Annotations<'_> {
    pub(crate) fn is_empty(&self) -> bool {
        self.name.is_none() && self.description.is_none()
    }
}
pub(crate) struct AnnotationDraft<'a> {
    pub node: u32,
    pub text: Annotations<'a>,
}

// One normalized decoration payload composes styles, local geometry, scrolling
// and semantics. Its optional base is CLOSED: it can never contain decorations,
// so alternating builders neither recurse on drop nor grow wrapper chains.
type Projected<'a> = (
    Box<dyn crate::reader::Projector + 'a>,
    Option<crate::list::RowMap>,
);
#[derive(Default)]
pub(crate) struct ControlAppearance {
    pub disabled: bool,
    pub focus_indicator: Option<crate::Color>,
}
#[derive(Default)]
pub(crate) struct ExtraParts<'a> {
    pub control: ControlAppearance,
    pub list: Option<crate::list::ListSpec<'a>>,
    pub annotations: Annotations<'a>,
    pub projection: Option<Projected<'a>>,
    pub image: Option<crate::image::ImageSpec<'a>>,
    pub axes: Option<crate::Axis>,
    pub geometry: Option<crate::property::GeometryStyle>,
    pub bindings: Vec<crate::style_port::Binding<'a>>,
    pub mapped: Vec<crate::style_port::MapBinding<'a>>,
    pub background: Option<&'a gpui_canvas::Gradient>,
}
#[derive(Default)]
pub(crate) struct Decorations<'a> {
    base: Option<Box<LeafExtra<'a>>>,
    bindings: Vec<crate::style_port::Binding<'a>>,
    semantic: Option<Box<Annotations<'a>>>,
    corner_radius: f32,
    clip_children: bool,
    axes: Option<crate::Axis>,
}
enum LeafExtra<'a> {
    Image(crate::image::ImageSpec<'a>),
    Reader(Projected<'a>),
    List(crate::list::ListSpec<'a>),
}
pub(crate) enum ElementExtra<'a> {
    // A semantic control reuses the existing extra's 56-byte envelope. Literal
    // geometry and focus have no additional box; optional bindings remain cold.
    Control {
        appearance: ControlAppearance,
        semantic: Option<Box<Annotations<'a>>>,
        geometry: crate::property::GeometryStyle,
        base: Option<Box<ElementExtra<'a>>>,
    },
    // Only mapped nodes pay for this payload; one normalized optional base.
    Mapped {
        bindings: Vec<crate::style_port::MapBinding<'a>>,
        background: Option<&'a gpui_canvas::Gradient>,
        base: Option<Box<ElementExtra<'a>>>,
    },
    Decorations(Decorations<'a>),
    Image {
        spec: crate::image::ImageSpec<'a>,
        semantic: Option<Box<Annotations<'a>>>,
    },
    Reader {
        projector: Box<dyn crate::reader::Projector + 'a>,
        semantic: Option<Box<Annotations<'a>>>,
        map: Option<crate::list::RowMap>,
    },
    List(crate::list::ListSpec<'a>),
    Semantic(Annotations<'a>),
    Combined {
        list: Box<crate::list::ListSpec<'a>>,
        semantic: Annotations<'a>,
    },
}
impl<'a> ElementExtra<'a> {
    pub fn focus_indicator(&mut self, color: crate::Color) {
        self.control_mut().focus_indicator = Some(color);
    }
    pub fn set_disabled(&mut self, disabled: bool) {
        if disabled {
            self.control_mut().disabled = true;
        } else if let Self::Control { appearance, .. } = self {
            appearance.disabled = false;
        }
    }
    fn control_mut(&mut self) -> &mut ControlAppearance {
        if !matches!(self, Self::Control { .. }) {
            let previous = std::mem::replace(self, Self::Semantic(Default::default()));
            let parts = previous.into_parts();
            assert!(
                parts.image.is_none()
                    && parts.projection.is_none()
                    && parts.list.is_none()
                    && parts.axes.is_none(),
                "semantic control appearance cannot contain a deep system"
            );
            let mut base = (!parts.bindings.is_empty()).then(|| {
                Box::new(Self::Decorations(Decorations {
                    bindings: parts.bindings,
                    ..Default::default()
                }))
            });
            if !parts.mapped.is_empty() || parts.background.is_some() {
                base = Some(Box::new(Self::Mapped {
                    bindings: parts.mapped,
                    background: parts.background,
                    base,
                }));
            }
            *self = Self::Control {
                appearance: parts.control,
                geometry: parts.geometry.unwrap_or_default(),
                semantic: (!parts.annotations.is_empty()).then(|| Box::new(parts.annotations)),
                base,
            };
        }
        let Self::Control { appearance, .. } = self else {
            unreachable!()
        };
        appearance
    }
    fn control_base(&mut self) -> &mut Self {
        let Self::Control { base, .. } = self else {
            unreachable!()
        };
        base.get_or_insert_with(|| Box::new(Self::Decorations(Default::default())))
    }

    fn decorations(&mut self) -> &mut Decorations<'a> {
        if matches!(self, Self::Control { .. }) {
            return self.control_base().decorations();
        }
        if let Self::Mapped { base, .. } = self {
            return base
                .get_or_insert_with(|| Box::new(Self::Decorations(Default::default())))
                .decorations();
        }
        if !matches!(self, Self::Decorations(_)) {
            let previous = std::mem::replace(self, Self::Semantic(Annotations::default()));
            let mut decorations = Decorations::default();
            let (base, semantic) = match previous {
                Self::Image { spec, semantic } => {
                    decorations.corner_radius = spec.corner_radius;
                    decorations.clip_children = spec.clip_children;
                    (Some(LeafExtra::Image(spec)), semantic)
                }
                Self::Reader {
                    projector,
                    semantic,
                    map,
                } => (Some(LeafExtra::Reader((projector, map))), semantic),
                Self::List(list) => (Some(LeafExtra::List(list)), None),
                Self::Combined { list, semantic } => {
                    (Some(LeafExtra::List(*list)), Some(Box::new(semantic)))
                }
                Self::Semantic(semantic) => {
                    (None, (!semantic.is_empty()).then(|| Box::new(semantic)))
                }
                Self::Decorations(_) | Self::Mapped { .. } | Self::Control { .. } => unreachable!(),
            };
            decorations.base = base.map(Box::new);
            decorations.semantic = semantic;
            *self = Self::Decorations(decorations);
        }
        let Self::Decorations(decorations) = self else {
            unreachable!()
        };
        decorations
    }
    pub fn empty(&self) -> bool {
        if let Self::Control {
            appearance,
            semantic,
            geometry,
            base,
        } = self
        {
            return !appearance.disabled
                && appearance.focus_indicator.is_none()
                && semantic.is_none()
                && geometry.corner_radius.to_bits() == 0
                && !geometry.clip_children
                && base.as_deref().is_none_or(Self::empty);
        }
        if let Self::Mapped {
            bindings,
            base,
            background,
        } = self
        {
            return bindings.is_empty()
                && background.is_none()
                && base.as_deref().is_none_or(Self::empty);
        }
        matches!(self, Self::Decorations(d) if d.base.is_none() && d.bindings.is_empty()
            && d.semantic.is_none() && d.corner_radius.to_bits() == 0 && !d.clip_children && d.axes.is_none())
    }
    pub fn bind(
        &mut self,
        property: crate::property::PropertyId,
        signal: &'a dyn crate::style_port::StyleSignal,
    ) {
        if matches!(self, Self::Control { .. }) {
            self.control_base().bind(property, signal);
            return;
        }
        if let Self::Mapped {
            bindings,
            base: Some(base),
            ..
        } = self
            && !bindings.iter().any(|binding| binding.property == property)
        {
            base.bind(property, signal);
            return;
        }
        if let Self::Decorations(d) = self
            && let Some(binding) = d
                .bindings
                .iter_mut()
                .find(|binding| binding.property == property)
        {
            binding.signal = signal;
            return;
        }
        self.unbind(property);
        if let Self::Mapped {
            bindings,
            base,
            background,
        } = self
            && bindings.is_empty()
            && background.is_none()
        {
            *self = base
                .take()
                .map(|base| *base)
                .unwrap_or_else(|| Self::Decorations(Default::default()));
        }
        let bindings = &mut self.decorations().bindings;
        if let Some(binding) = bindings
            .iter_mut()
            .find(|binding| binding.property == property)
        {
            binding.signal = signal;
        } else {
            if bindings.len() == bindings.capacity() {
                bindings.reserve_exact(bindings.capacity().max(1));
            }
            bindings.push(crate::style_port::Binding { property, signal });
        }
    }
    pub fn bind_map(
        &mut self,
        property: crate::property::PropertyId,
        operand: crate::style_port::MapOperand<'a>,
    ) {
        if matches!(self, Self::Control { .. }) {
            self.control_base().bind_map(property, operand);
            return;
        }
        if let Self::Mapped { bindings, .. } = self
            && let Some(binding) = bindings
                .iter_mut()
                .find(|binding| binding.property == property)
        {
            binding.operand = operand;
            return;
        }
        self.unbind(property);
        if !matches!(self, Self::Mapped { .. }) {
            let previous = std::mem::replace(self, Self::Semantic(Annotations::default()));
            let base = if matches!(&previous, Self::Semantic(s) if s.is_empty()) || previous.empty()
            {
                None
            } else {
                Some(Box::new(previous))
            };
            *self = Self::Mapped {
                bindings: Vec::new(),
                background: None,
                base,
            };
        }
        let Self::Mapped { bindings, .. } = self else {
            unreachable!()
        };
        // Exact growth avoids a minimum-four allocation for one cold binding.
        if bindings.len() == bindings.capacity() {
            bindings.reserve_exact(bindings.capacity().max(1));
        }
        bindings.push(crate::style_port::MapBinding { property, operand });
    }
    pub fn unbind(&mut self, property: crate::property::PropertyId) {
        if let Self::Control { base, .. } = self {
            if let Some(base) = base {
                base.unbind(property);
            }
            return;
        }
        if let Self::Mapped {
            bindings,
            base,
            background,
        } = self
        {
            if property == crate::property::PropertyId::Background {
                *background = None;
            }
            bindings.retain(|binding| binding.property != property);
            if bindings.is_empty() {
                *bindings = Vec::new();
            }
            if let Some(base) = base {
                base.unbind(property);
            }
            return;
        }
        if let Self::Decorations(d) = self {
            d.bindings.retain(|binding| binding.property != property);
            if d.bindings.is_empty() {
                d.bindings = Vec::new();
            }
        }
    }
    pub fn clear_background(&mut self) {
        if let Self::Control { base, .. } = self {
            if let Some(base) = base {
                base.clear_background();
            }
            return;
        }
        if let Self::Mapped { background, .. } = self {
            *background = None;
        }
    }
    pub fn set_background(&mut self, gradient: &'a gpui_canvas::Gradient) {
        if matches!(self, Self::Control { .. }) {
            self.control_base().set_background(gradient);
            return;
        }
        self.unbind(crate::property::PropertyId::Background);
        if !matches!(self, Self::Mapped { .. }) {
            let previous = std::mem::replace(self, Self::Semantic(Annotations::default()));
            let base = (!previous.empty()
                && !matches!(&previous,Self::Semantic(s) if s.is_empty()))
            .then(|| Box::new(previous));
            *self = Self::Mapped {
                bindings: Vec::new(),
                background: None,
                base,
            };
        }
        let Self::Mapped { background, .. } = self else {
            unreachable!()
        };
        *background = Some(gradient);
    }
    pub fn set_radius(&mut self, value: f32) {
        match self {
            Self::Control { geometry, .. } => geometry.corner_radius = value,
            Self::Image { spec, .. } => spec.corner_radius = value,
            _ => self.decorations().corner_radius = value,
        }
    }
    pub fn clip_children(&mut self, value: bool) {
        match self {
            Self::Control { geometry, .. } => geometry.clip_children = value,
            Self::Image { spec, .. } => spec.clip_children = value,
            _ => self.decorations().clip_children = value,
        }
    }
    pub fn make_scroll(&mut self, axes: crate::Axis) -> Result<(), crate::ScrollError> {
        if let Self::Mapped { base, .. } = self {
            return base
                .get_or_insert_with(|| Box::new(Self::Semantic(Annotations::default())))
                .make_scroll(axes);
        }
        if !matches!(
            self,
            Self::Semantic(_) | Self::Decorations(Decorations { base: None, .. })
        ) {
            return Err(crate::ScrollError::UnsupportedElement);
        }
        self.decorations().axes = Some(axes);
        Ok(())
    }
    pub fn image_mut(&mut self) -> Option<&mut crate::image::ImageSpec<'a>> {
        match self {
            Self::Mapped { base, .. } => base.as_deref_mut()?.image_mut(),
            Self::Image { spec, .. } => Some(spec),
            Self::Decorations(d) => match d.base.as_deref_mut()? {
                LeafExtra::Image(spec) => Some(spec),
                _ => None,
            },
            _ => None,
        }
    }
    pub fn projection_mut(
        &mut self,
    ) -> Option<(
        &mut Box<dyn crate::reader::Projector + 'a>,
        &mut Option<crate::list::RowMap>,
    )> {
        match self {
            Self::Mapped { base, .. } => base.as_deref_mut()?.projection_mut(),
            Self::Reader { projector, map, .. } => Some((projector, map)),
            Self::Decorations(d) => match d.base.as_deref_mut()? {
                LeafExtra::Reader((projector, map)) => Some((projector, map)),
                _ => None,
            },
            _ => None,
        }
    }
    pub fn list_mut(&mut self) -> Option<&mut crate::list::ListSpec<'a>> {
        match self {
            Self::Mapped { base, .. } => base.as_deref_mut()?.list_mut(),
            Self::List(list) => Some(list),
            Self::Combined { list, .. } => Some(list),
            Self::Decorations(d) => match d.base.as_deref_mut()? {
                LeafExtra::List(list) => Some(list),
                _ => None,
            },
            _ => None,
        }
    }
    pub fn annotations_mut(&mut self) -> &mut Annotations<'a> {
        if let Self::Control { semantic, .. } = self {
            return semantic.get_or_insert_with(Default::default);
        }
        if let Self::Mapped { base, .. } = self {
            return base
                .get_or_insert_with(|| Box::new(Self::Semantic(Annotations::default())))
                .annotations_mut();
        }
        if matches!(self, Self::List(_)) {
            let previous = std::mem::replace(self, Self::Semantic(Annotations::default()));
            if let Self::List(list) = previous {
                *self = Self::Combined {
                    list: Box::new(list),
                    semantic: Annotations::default(),
                };
            }
        }
        match self {
            Self::Decorations(d) => d.semantic.get_or_insert_with(Default::default),
            Self::Reader { semantic, .. } | Self::Image { semantic, .. } => {
                semantic.get_or_insert_with(Default::default)
            }
            Self::Semantic(semantic) | Self::Combined { semantic, .. } => semantic,
            Self::List(_) | Self::Mapped { .. } | Self::Control { .. } => unreachable!(),
        }
    }
    pub fn into_parts(mut self) -> ExtraParts<'a> {
        let mut parts = ExtraParts::default();
        loop {
            match self {
                Self::Control {
                    appearance,
                    semantic,
                    geometry,
                    base,
                } => {
                    parts.control = appearance;
                    parts.geometry = Some(geometry);
                    parts.annotations = semantic.map(|s| *s).unwrap_or_default();
                    if let Some(base) = base {
                        self = *base;
                        continue;
                    }
                }
                Self::Mapped {
                    bindings,
                    base,
                    background,
                } => {
                    parts.mapped = bindings;
                    parts.background = background;
                    if let Some(base) = base {
                        self = *base;
                        continue;
                    }
                }
                Self::Decorations(d) => {
                    let geometry = crate::property::GeometryStyle {
                        corner_radius: d.corner_radius,
                        clip_children: d.clip_children,
                    };
                    if let Some(semantic) = d.semantic {
                        parts.annotations = *semantic;
                    }
                    parts.axes = d.axes;
                    parts.geometry.get_or_insert(geometry);
                    parts.bindings = d.bindings;
                    match d.base.map(|base| *base) {
                        Some(LeafExtra::List(list)) => parts.list = Some(list),
                        Some(LeafExtra::Reader(projector)) => parts.projection = Some(projector),
                        Some(LeafExtra::Image(mut spec)) => {
                            spec.set_geometry(geometry);
                            parts.image = Some(spec);
                        }
                        None => {}
                    }
                }
                Self::Reader {
                    projector,
                    semantic,
                    map,
                } => {
                    parts.projection = Some((projector, map));
                    parts.annotations = semantic.map(|s| *s).unwrap_or_default();
                }
                Self::Image { spec, semantic } => {
                    parts.image = Some(spec);
                    parts.geometry = Some(spec.geometry());
                    parts.annotations = semantic.map(|s| *s).unwrap_or_default();
                }
                Self::List(list) => parts.list = Some(list),
                Self::Semantic(annotations) => parts.annotations = annotations,
                Self::Combined { list, semantic } => {
                    parts.list = Some(*list);
                    parts.annotations = semantic;
                }
            }
            break;
        }
        parts
    }
}

#[cfg(test)]
mod decoration_tests {
    use super::*;
    use crate::{Affine, Axis, Color, El, Signal, div};
    #[test]
    fn mapped_33_description_bill_preserves_literal_and_direct_floors() {
        use crate::SignalMap;
        let source = Signal::new(0_u32);
        let color = Signal::new(Color::BLACK);
        for mode in 0..3 {
            let mut nodes = Vec::with_capacity(33);
            let cost = allocation_counter::measure(|| {
                for index in 0..33 {
                    nodes.push(match mode {
                        0 => div().bg(Color::BLACK),
                        1 => div().bg(&color),
                        _ => div().bg(source.map_with(index, |value, index| {
                            if *value == index {
                                Color::WHITE
                            } else {
                                Color::BLACK
                            }
                        })),
                    });
                }
            });
            eprintln!(
                "description_33,mode={mode},requests={},requested={},retained={},peak={}",
                cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max
            );
            assert_eq!(cost.count_total, if mode == 0 { 0 } else { 66 });
            assert_eq!(
                cost.bytes_current,
                match mode {
                    0 => 0,
                    1 => 33 * 80,
                    _ => 33 * 104,
                }
            );
            drop(nodes);
        }
    }
    #[test]
    fn mapped_builders_normalize_one_wrapper_and_release_overwritten_recipes() {
        use crate::SignalMap;
        let number = Signal::new(12_u32);
        let color = Signal::new(Color::BLACK);
        let mut element = None;
        let mixed = allocation_counter::measure(|| {
            let mut el = div();
            for _ in 0..1000 {
                el = el
                    .bg(number.map(|_| Color::WHITE))
                    .w(&number)
                    .rounded(2.0)
                    .name("mapped")
                    .scroll(Axis::Y);
            }
            element = Some(el);
        });
        assert_eq!(mixed.count_total, 5);
        eprintln!(
            "mapped_mixed_description,requests={},requested={},retained={},peak={}",
            mixed.count_total, mixed.bytes_total, mixed.bytes_current, mixed.bytes_max
        );
        drop(element);
        let mut element = None;
        let direct = allocation_counter::measure(|| {
            element = Some(div().bg(number.map(|_| Color::WHITE)).bg(&color));
        });
        assert_eq!(
            direct.bytes_current, 80,
            "obsolete mapper releases its vector and uses ordinary direct storage"
        );
        drop(element);
        let mut element = None;
        let literal = allocation_counter::measure(|| {
            element = Some(div().bg(number.map(|_| Color::WHITE)).bg(Color::BLACK));
        });
        assert_eq!(literal.bytes_current, 0);
        drop(element);
    }
    #[test]
    fn cold_headers_and_alternating_builders_have_one_nonrecursive_decoration() {
        assert_eq!(size_of::<ElementExtra<'_>>(), 56);
        assert_eq!(size_of::<Decorations<'_>>(), 48);
        assert_eq!(size_of::<LeafExtra<'_>>(), 56);
        assert_eq!(size_of::<crate::style_port::Binding<'_>>(), 24);
        assert_eq!(size_of::<crate::style_port::Draft<'_>>(), 24);
        let a = Signal::new(Color::BLACK);
        let b = Signal::new(Color::WHITE);
        let mut element = None;
        let count = allocation_counter::measure(|| {
            let mut el = div();
            for _ in 0..1_000 {
                el = el.bg(&a).rounded(6.0).bg(&b).scroll(Axis::Y).name("pane");
            }
            element = Some(el);
        });
        assert_eq!(count.count_total, 3);
        assert_eq!(count.bytes_total, 128);
        eprintln!(
            "style_decorations,alternating,requests={},requested={},retained={},peak={}",
            count.count_total, count.bytes_total, count.bytes_current, count.bytes_max
        );
        drop(element);
    }
    #[test]
    #[allow(clippy::needless_borrows_for_generic_args)] // exercises copied literals
    fn binding_accumulator_costs_are_cold_and_literal_overwrites_release_it() {
        let n = Signal::new(12_f64);
        let color = Signal::new(Color::BLACK);
        let transform = Signal::new(Affine::IDENTITY);
        for ports in [0, 1, 2, 8] {
            let mut element = None;
            let count = allocation_counter::measure(|| {
                let el = match ports {
                    0 => div().w(12).h(&12).gap(12).bg(Color::BLACK),
                    1 => div().w(&n),
                    2 => div().size(&n),
                    8 => div()
                        .size(&n)
                        .gap(&n)
                        .p(&n)
                        .font_size(&n)
                        .fg(&color)
                        .bg(&color)
                        .transform(&transform),
                    _ => unreachable!(),
                };
                element = Some(el);
            });
            eprintln!(
                "style_decorations,ports={ports},requests={},requested={},retained={},peak={}",
                count.count_total, count.bytes_total, count.bytes_current, count.bytes_max
            );
            assert_eq!(
                count.bytes_current,
                match ports {
                    0 => 0,
                    1 => 80,
                    2 => 104,
                    8 => 248,
                    _ => unreachable!(),
                }
            );
            drop(element);
        }
        let mut element: Option<El<'_>> = None;
        let count =
            allocation_counter::measure(|| element = Some(div().bg(&color).bg(Color::WHITE)));
        assert_eq!(
            count.bytes_current, 0,
            "obsolete signal binding and extension are released"
        );
        drop(element);
    }
}
