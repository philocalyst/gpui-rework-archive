//! Retained scroll state belongs to a mounted viewport, not its source model.

/// The local axes a viewport may scroll. Both axes are clipped in every mode.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Axis(u8);
impl Axis {
    pub const X: Self = Self(1);
    pub const Y: Self = Self(2);
    pub const BOTH: Self = Self(3);
    pub(crate) const fn x(self) -> bool {
        self.0 & 1 != 0
    }
    pub(crate) const fn y(self) -> bool {
        self.0 & 2 != 0
    }
}
impl serde::Serialize for Axis {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        serializer.serialize_str(match *self {
            Self::X => "X",
            Self::Y => "Y",
            Self::BOTH => "Both",
            _ => unreachable!("only declared axes are constructible"),
        })
    }
}

/// A displacement in logical units. `scroll_by` uses viewport-local axes;
/// point-routed scrolling uses the window's logical axes.
#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct ScrollDelta {
    pub x: f64,
    pub y: f64,
}

/// Local content coordinates at a viewport's origin. Negative overflow can
/// produce negative offsets. Scrolling moves content opposite the offset.
#[derive(Clone, Copy, Debug, Default, PartialEq, serde::Serialize)]
pub struct ScrollOffset {
    pub x: f64,
    pub y: f64,
}

/// Immutable metadata from an acknowledged presentation. It never describes
/// an unacknowledged candidate or newer, failed layout.
#[derive(Clone, Copy, Debug, PartialEq, serde::Serialize)]
pub struct ScrollViewport {
    pub axes: Axis,
    pub offset: ScrollOffset,
    pub min: ScrollOffset,
    pub max: ScrollOffset,
    pub size: [f64; 2],
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum ScrollError {
    NotViewport,
    InvalidDelta,
    InvalidOffset,
    ResourceLimit,
    UnsupportedElement,
    UnsupportedTransform,
}
impl std::fmt::Display for ScrollError {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(formatter, "{self:?}")
    }
}
impl std::error::Error for ScrollError {}

pub(crate) struct ScrollDraft {
    pub index: usize,
    pub axes: Axis,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ScrollDirection {
    Up,
    Down,
    Left,
    Right,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ScrollUnit {
    Item,
    Page,
}
