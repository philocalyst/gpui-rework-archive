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

// Exceptional description payloads stay in the existing 56-byte cold enum.
// Scroll's local geometry fits beside its axis byte without another box.
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
}
pub(crate) enum ElementExtra<'a> {
    Scroll {
        axes: crate::Axis,
        style: crate::property::GeometryStyle,
        semantic: Option<Box<Annotations<'a>>>,
    },
    Geometry {
        style: crate::property::GeometryStyle,
        inner: Option<Box<ElementExtra<'a>>>,
        semantic: Option<Box<Annotations<'a>>>,
    },
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
    pub fn base_mut(&mut self) -> &mut Self {
        match self {
            Self::Geometry {
                inner: Some(inner), ..
            } => inner.base_mut(),
            _ => self,
        }
    }
    pub fn set_geometry(&mut self, value: crate::property::GeometryStyle) {
        match self {
            Self::Image { spec, .. } => spec.geometry = value,
            Self::Geometry { style, .. } | Self::Scroll { style, .. } => *style = value,
            _ => {
                let previous = std::mem::replace(
                    self,
                    Self::Geometry {
                        style: value,
                        inner: None,
                        semantic: None,
                    },
                );
                if let Self::Semantic(annotations) = previous {
                    if let Self::Geometry { semantic, .. } = self {
                        *semantic = Some(Box::new(annotations));
                    }
                } else if let Self::Geometry { inner, .. } = self {
                    *inner = Some(Box::new(previous));
                }
            }
        }
    }
    pub fn make_scroll(&mut self, axes: crate::Axis) -> Result<(), crate::ScrollError> {
        if !matches!(
            self,
            Self::Semantic(_) | Self::Scroll { .. } | Self::Geometry { inner: None, .. }
        ) {
            return Err(crate::ScrollError::UnsupportedElement);
        }
        // Reuse the existing extension allocation in either builder order.
        let previous = std::mem::replace(
            self,
            Self::Scroll {
                axes,
                style: Default::default(),
                semantic: None,
            },
        );
        let (style, annotations) = match previous {
            Self::Semantic(annotations) => (Default::default(), Some(Box::new(annotations))),
            Self::Scroll {
                style, semantic, ..
            }
            | Self::Geometry {
                style, semantic, ..
            } => (style, semantic),
            _ => unreachable!("admitted scroll payload"),
        };
        if let Self::Scroll {
            style: current,
            semantic,
            ..
        } = self
        {
            *current = style;
            *semantic = annotations;
        }
        Ok(())
    }
    pub fn list_mut(&mut self) -> Option<&mut crate::list::ListSpec<'a>> {
        match self {
            Self::Geometry { inner, .. } => inner.as_deref_mut().and_then(Self::list_mut),
            Self::List(list) => Some(list),
            Self::Combined { list, .. } => Some(list),
            Self::Semantic(_) | Self::Reader { .. } | Self::Image { .. } | Self::Scroll { .. } => {
                None
            }
        }
    }
    pub fn annotations_mut(&mut self) -> &mut Annotations<'a> {
        if let Self::Geometry {
            inner, semantic, ..
        } = self
        {
            return if let Some(inner) = inner {
                inner.annotations_mut()
            } else {
                semantic.get_or_insert_with(Default::default)
            };
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
            Self::Reader { semantic, .. }
            | Self::Image { semantic, .. }
            | Self::Scroll { semantic, .. } => semantic.get_or_insert_with(Default::default),
            Self::Semantic(semantic) | Self::Combined { semantic, .. } => semantic,
            Self::List(_) | Self::Geometry { .. } => unreachable!(),
        }
    }
    pub fn into_parts(self) -> ExtraParts<'a> {
        match self {
            Self::Geometry {
                style,
                inner,
                semantic,
            } => {
                let mut parts = inner.map(|inner| inner.into_parts()).unwrap_or_default();
                if let Some(semantic) = semantic {
                    parts.annotations = *semantic;
                }
                parts.geometry = Some(style);
                parts
            }
            Self::Scroll {
                axes,
                style,
                semantic,
            } => ExtraParts {
                axes: Some(axes),
                geometry: Some(style),
                annotations: semantic.map(|s| *s).unwrap_or_default(),
                ..Default::default()
            },
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
