//! Borrowed fixed-height lists. Only viewport-intersecting rows are described.
use crate::{El, IntoLength};
use std::ops::Range;

/// Exact application data identity, independent of an actionable `Target`.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct ItemKey(u64);
impl ItemKey {
    pub const fn new(value: u64) -> Self {
        Self(value)
    }
    pub const fn get(self) -> u64 {
        self.0
    }
}
/// Unique among the lists mounted in one window's description, including
/// contained components. It also names the key domain: replacing a source with
/// unrelated items that reuse keys requires a new ListId.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct ListId(u64);
impl ListId {
    pub const fn new(value: u64) -> Self {
        Self(value)
    }
    pub const fn get(self) -> u64 {
        self.0
    }
}

/// A coherent borrowed snapshot. Methods must be pure for the duration of a
/// description. `index_of` must agree with `key`; keys must be unique. The
/// runtime checks that agreement for every realized key and requested anchor.
/// No source reference or row description is retained after the owner turn.
pub trait ItemSource {
    fn len(&self) -> usize;
    fn is_empty(&self) -> bool {
        self.len() == 0
    }
    fn key(&self, index: usize) -> ItemKey;
    fn index_of(&self, key: ItemKey) -> Option<usize>;
    fn row(&self, index: usize) -> El<'_>;
}

#[derive(Clone, Debug, PartialEq)]
pub struct ListViewport {
    pub len: usize,
    pub offset: f64,
    pub extent: f64,
    pub row_height: f64,
    pub viewport_height: f64,
    /// Slots intersecting the explicit logical list viewport. Ancestor/window
    /// clipping may suppress their semantics; `list_item` checks that visibility.
    pub visible_range: Range<usize>,
    /// No prefetch: this equals the list-local visible range, before window clipping.
    pub realized_range: Range<usize>,
    pub realized_rows: usize,
}

#[derive(Clone, Debug, PartialEq)]
pub enum ListError {
    MissingViewport,
    InvalidMetrics,
    InvalidDelta,
    ResourceLimit,
    DuplicateList(ListId),
    DuplicateKey(ItemKey),
    InvalidIndex(ItemKey),
    MissingKey(ItemKey),
    IndexOutOfRange,
    NotList,
    UnsupportedStyle,
    UnsupportedTransform,
    ChangedSource,
}
impl std::fmt::Display for ListError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for ListError {}

/// A finite viewport height must be supplied with `.h(...)`. Width participates
/// in ordinary parent layout. Rows use local, rebased coordinates; total extent
/// is metadata, never a giant spacer. Viewports require axis-aligned transforms;
/// rotation and shear are unsupported. Reflections and descendant transforms
/// are supported. Raster clips lower to the current canvas's 4×4 sample profile;
/// input geometry remains independent of that lowering.
///
/// Admission limits are one billion items, total extent at most 2^40 logical
/// units, row heights from 1/64 to below one million units, and at most 4096
/// realized rows. Padding/gap on the viewport are unsupported; put chrome in a
/// surrounding ordinary element. Row heights use the same f32 author precision
/// as ordinary lengths; extent and scroll arithmetic use f64. Pointer hits test
/// original ancestor geometry, never the sample-specific raster clip.
pub fn uniform_list<'a>(
    id: ListId,
    source: &'a impl ItemSource,
    row_height: impl IntoLength,
) -> El<'a> {
    El::uniform_list(id, source, row_height.into_length())
}

pub(crate) type RowMap = Box<dyn for<'b> Fn(&mut El<'b>)>;
pub(crate) struct ListSpec<'a> {
    pub id: ListId,
    pub source: &'a dyn ItemSource,
    pub row_height: f64,
    pub map: Option<RowMap>,
}
pub(crate) struct ListPlan {
    pub viewport: ListViewport,
    pub keys: Vec<ItemKey>,
    pub anchor: Option<(ItemKey, f64)>,
}
pub(crate) struct ListDraft {
    pub index: usize,
    pub id: ListId,
    pub plan: ListPlan,
    pub rows: Vec<RowDraft>,
}
pub(crate) struct RowDraft {
    pub index: usize,
    pub key: ItemKey,
    pub y: f32,
    pub height: f32,
}
