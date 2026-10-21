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

// The existing list-extension pointer pays for annotations only when requested.
// Combined boxes the list payload to keep the common cold enum at 56 bytes.
type Projected<'a> = (
    Box<dyn crate::reader::Projector + 'a>,
    Option<crate::list::RowMap>,
);
pub(crate) enum ElementExtra<'a> {
    Scroll {
        axes: crate::Axis,
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
    pub fn list_mut(&mut self) -> Option<&mut crate::list::ListSpec<'a>> {
        match self {
            Self::List(list) => Some(list),
            Self::Combined { list, .. } => Some(list),
            Self::Semantic(_) | Self::Reader { .. } | Self::Image { .. } | Self::Scroll { .. } => {
                None
            }
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
            Self::Reader { semantic, .. }
            | Self::Image { semantic, .. }
            | Self::Scroll { semantic, .. } => semantic.get_or_insert_with(Default::default),
            Self::Semantic(semantic) | Self::Combined { semantic, .. } => semantic,
            Self::List(_) => unreachable!(),
        }
    }
    pub fn into_parts(
        self,
    ) -> (
        Option<crate::list::ListSpec<'a>>,
        Annotations<'a>,
        Option<Projected<'a>>,
        Option<crate::image::ImageSpec<'a>>,
        Option<crate::Axis>,
    ) {
        match self {
            Self::Scroll { axes, semantic } => (
                None,
                semantic.map(|s| *s).unwrap_or_default(),
                None,
                None,
                Some(axes),
            ),
            Self::Reader {
                projector,
                semantic,
                map,
            } => (
                None,
                semantic.map(|s| *s).unwrap_or_default(),
                Some((projector, map)),
                None,
                None,
            ),
            Self::Image { spec, semantic } => (
                None,
                semantic.map(|s| *s).unwrap_or_default(),
                None,
                Some(spec),
                None,
            ),
            Self::List(list) => (Some(list), Annotations::default(), None, None, None),
            Self::Semantic(semantic) => (None, semantic, None, None, None),
            Self::Combined { list, semantic } => (Some(*list), semantic, None, None, None),
        }
    }
}
