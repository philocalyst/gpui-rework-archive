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
pub(crate) struct ExtraParts<'a> {
    pub list: Option<crate::list::ListSpec<'a>>,
    pub annotations: Annotations<'a>,
    pub projection: Option<Projected<'a>>,
    pub image: Option<crate::image::ImageSpec<'a>>,
    pub axes: Option<crate::Axis>,
    pub geometry: Option<crate::property::GeometryStyle>,
    pub bindings: Vec<crate::style_port::Binding<'a>>,
}
#[derive(Default)]
pub(crate) struct Decorations<'a> {
    base: Option<Box<LeafExtra<'a>>>,
    bindings: Vec<crate::style_port::Binding<'a>>,
    semantic: Option<Box<Annotations<'a>>>,
    geometry: crate::property::GeometryStyle,
    axes: Option<crate::Axis>,
}
enum LeafExtra<'a> {
    Image(crate::image::ImageSpec<'a>),
    Reader(Projected<'a>),
    List(crate::list::ListSpec<'a>),
}
pub(crate) enum ElementExtra<'a> {
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
    fn decorations(&mut self) -> &mut Decorations<'a> {
        if !matches!(self, Self::Decorations(_)) {
            let previous = std::mem::replace(self, Self::Semantic(Annotations::default()));
            let mut decorations = Decorations::default();
            let (base, semantic) = match previous {
                Self::Image { spec, semantic } => {
                    decorations.geometry = spec.geometry;
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
                Self::Decorations(_) => unreachable!(),
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
        matches!(self, Self::Decorations(d) if d.base.is_none() && d.bindings.is_empty()
            && d.semantic.is_none() && d.geometry.corner_radius.to_bits() == 0 && d.axes.is_none())
    }
    pub fn bind(
        &mut self,
        property: crate::property::PropertyId,
        signal: &'a dyn crate::style_port::StyleSignal,
    ) {
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
    pub fn unbind(&mut self, property: crate::property::PropertyId) {
        if let Self::Decorations(d) = self {
            d.bindings.retain(|binding| binding.property != property);
            if d.bindings.is_empty() {
                d.bindings = Vec::new();
            }
        }
    }
    pub fn set_geometry(&mut self, value: crate::property::GeometryStyle) {
        match self {
            Self::Image { spec, .. } => spec.geometry = value,
            _ => self.decorations().geometry = value,
        }
    }
    pub fn make_scroll(&mut self, axes: crate::Axis) -> Result<(), crate::ScrollError> {
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
            Self::List(_) => unreachable!(),
        }
    }
    pub fn into_parts(self) -> ExtraParts<'a> {
        match self {
            Self::Decorations(d) => {
                let mut parts = ExtraParts {
                    annotations: d.semantic.map(|s| *s).unwrap_or_default(),
                    axes: d.axes,
                    geometry: Some(d.geometry),
                    bindings: d.bindings,
                    ..Default::default()
                };
                match d.base.map(|base| *base) {
                    Some(LeafExtra::List(list)) => parts.list = Some(list),
                    Some(LeafExtra::Reader(projector)) => parts.projection = Some(projector),
                    Some(LeafExtra::Image(mut spec)) => {
                        spec.geometry = d.geometry;
                        parts.image = Some(spec);
                    }
                    None => {}
                }
                parts
            }
            Self::Reader {
                projector,
                semantic,
                map,
            } => ExtraParts {
                projection: Some((projector, map)),
                annotations: semantic.map(|s| *s).unwrap_or_default(),
                ..Default::default()
            },
            Self::Image { spec, semantic } => ExtraParts {
                image: Some(spec),
                geometry: Some(spec.geometry),
                annotations: semantic.map(|s| *s).unwrap_or_default(),
                ..Default::default()
            },
            Self::List(list) => ExtraParts {
                list: Some(list),
                ..Default::default()
            },
            Self::Semantic(annotations) => ExtraParts {
                annotations,
                ..Default::default()
            },
            Self::Combined { list, semantic } => ExtraParts {
                list: Some(*list),
                annotations: semantic,
                ..Default::default()
            },
        }
    }
}

#[cfg(test)]
mod decoration_tests {
    use super::*;
    use crate::{Affine, Axis, Color, El, Signal, div};
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
