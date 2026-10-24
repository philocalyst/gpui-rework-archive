//! One serial owner turn, a retained logical description, and an admitted sheet.
//! Layout is private scratch; the canvas stages commands without another output
//! framebuffer. Callbacks carry ordinary Rust borrows; there is no shared mutable owner cell.
#[cfg(test)]
use crate::Source;
use crate::shared_text::SharedText;
use std::{
    collections::{BTreeMap, BTreeSet},
    num::NonZeroU64,
    panic::{AssertUnwindSafe, catch_unwind},
};

use gpui_canvas::{
    Canvas, ColorConfig, DamageRegion, PreparedScene, TextLayout, TextMetrics, TextShaper,
    TextSystem,
};
use gpui_reactivity_core::{
    Affine, CoordinateSpace, NodeId, Point, Rect,
    layout::{
        AvailableSpace, LayoutError, LayoutTree, MeasureInput, MeasureOutput, Size,
        WidthMeasureInput,
    },
};
use serde::Serialize;

use crate::{
    ListError, ListId, Target, View,
    element::{Handler, NodeKind},
    identity::Sites,
    property::{Contribution, Overrides, Property, PropertyError},
    remote::{Delivery, DeliveryError, Inbox, Lane, LaneSet, Stage},
    source::{BindError, FieldId, SourcePath, Sources, TextCodec, TextEditError},
    style::{Color, Flow, Length, Style},
};

const MAX_NODES: usize = 100_000;
// The compact parent sentinel must stay outside the admitted index domain.
const _: () = assert!(MAX_NODES <= u32::MAX as usize);
// Cephal's algorithms recurse even though public description disposal does not.
const MAX_LAYOUT_DEPTH: usize = 128;
const _: () = assert!(MAX_LAYOUT_DEPTH <= u8::MAX as usize);

#[cfg(feature = "accessibility")]
mod accessibility;
mod delivery;
mod editing;
mod frontier;
mod text_geometry;
use editing::EditingIntent;
pub use text_geometry::TextGeometry;
mod identity_index;
mod image;
mod siblings;
use identity_index::IdentityIndex;
mod input;
pub(crate) mod inspector;
mod list;
mod scroll;
mod turn;
use list::{ListRow, ListState, ScrollRequest};
use scroll::{ViewportKey, ViewportState};
mod background;
mod geometry;
mod metadata;
pub(crate) mod paint;
use paint::PatchOutcome;
mod published;
mod query;
mod semantics;
mod styles;
pub use input::{Key, PointerEvent, PointerSession};
use metadata::{Declared, Destination, Metadata, Port, Publish};
pub use metadata::{ListInfo, ListItemInfo};
pub use query::{Part, Query, SemanticSnapshot};
#[cfg(feature = "accessibility")]
pub(crate) use query::{SemanticSheet, SemanticState};
pub use semantics::{Action, ActionKind, Actions};

// Plain preparation carries only coordinate spaces. This second frontier is
// present only when a viewport or logical clip needs inherited clipping state.
#[derive(Clone, Copy)]
struct ClipFrame {
    clip: Rect,
    hit_clip: Rect,
    chain: Option<gpui_canvas::ClipId>,
    membership: u8,
    // In list mode, the nearest ancestor actually emitted into P.
    published: Parent,
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct WindowOptions {
    /// Physical output dimensions in device pixels.
    pub size: [u32; 2],
    pub colors: ColorConfig,
}
impl Default for WindowOptions {
    fn default() -> Self {
        Self {
            size: [640, 480],
            colors: ColorConfig::default(),
        }
    }
}

#[derive(Clone, Debug, PartialEq)]
pub enum Error {
    Closed,
    Poisoned,
    OwnerPanicked,
    PresentationPanicked,
    StaleTarget,
    StaleResource,
    PresentationStale,
    InvalidScale,
    ZeroInboxCapacity,
    NoPreparedScene,
    StalePresentation,
    NotInteractive,
    NotInput,
    InvalidSelection,
    NotHittable,
    MissingElement,
    AmbiguousElement {
        matches: usize,
    },
    UnregisteredInput {
        node: usize,
    },
    UnregisteredControl {
        node: usize,
    },
    DepthLimit {
        node: usize,
    },
    ResourceLimit,
    EpochExhausted,
    Binding(BindError),
    MapStorage {
        size: usize,
        alignment: usize,
    },
    MapInput,
    /// A boolean destination escaped, duplicated, or lost its declared owner.
    BooleanBinding,
    TextEdit(TextEditError),
    Layout(LayoutError),
    Canvas(gpui_canvas::Error),
    Property(PropertyError),
    GeometryProperty {
        node: usize,
        error: PropertyError,
    },
    Serialization(String),
    List(ListError),
    Scroll(crate::ScrollError),
    Question(crate::QuestionFault),
}
impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for Error {}
impl From<crate::QuestionFault> for Error {
    fn from(error: crate::QuestionFault) -> Self {
        Self::Question(error)
    }
}
impl From<BindError> for Error {
    fn from(error: BindError) -> Self {
        Self::Binding(error)
    }
}
impl From<LayoutError> for Error {
    fn from(error: LayoutError) -> Self {
        Self::Layout(error)
    }
}
impl From<gpui_canvas::Error> for Error {
    fn from(error: gpui_canvas::Error) -> Self {
        Self::Canvas(error)
    }
}
impl From<TextEditError> for Error {
    fn from(error: TextEditError) -> Self {
        Self::TextEdit(error)
    }
}
impl From<PropertyError> for Error {
    fn from(error: PropertyError) -> Self {
        Self::Property(error)
    }
}

impl From<crate::ScrollError> for Error {
    fn from(error: crate::ScrollError) -> Self {
        Self::Scroll(error)
    }
}
impl From<ListError> for Error {
    fn from(error: ListError) -> Self {
        Self::List(error)
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize)]
pub struct Counters {
    pub owner_reruns: u64,
    pub descriptions: u64,
    pub source_operations: u64,
    pub source_reads: u64,
    pub destination_compares: u64,
    pub text_promotions: u64,
    pub text_bytes_copied: u64,
    pub layout_runs: u64,
    pub measure_calls: u64,
    pub presentations: u64,
    pub paint_passes: u64,
    pub exact_updates: u64,
    pub coarse_updates: u64,
}

/// Capability for one complete prepared sheet in one window namespace.
/// Only an adapter that submitted/presented this scene should acknowledge it.
/// Private fields and the absence of Deserialize prevent restoration/forgery.
/// ```compile_fail
/// let token = gpui::PresentationToken {
///     window: std::num::NonZeroU64::new(1).unwrap(),
///     sequence: std::num::NonZeroU64::new(1).unwrap(),
/// };
/// ```
/// ```compile_fail
/// let token: gpui::PresentationToken = serde_json::from_str("{}").unwrap();
/// ```
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct PresentationToken {
    window: NonZeroU64,
    sequence: NonZeroU64,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize)]
pub struct Commit {
    pub source_epoch: u64,
    /// Source epoch described by the complete displayed sheet.
    pub presentation_epoch: u64,
    /// False until the first actual presentation acknowledgement, even at S0.
    pub presentation_valid: bool,
    /// Epoch covered by the outstanding complete sheet awaiting acknowledgement.
    pub prepared_epoch: Option<u64>,
    pub changed_nodes: usize,
}

/// Ownership and commit status of a failed typed source assignment.
/// A rejected assignment returns its original payload, even when a projector
/// fault has already poisoned the owner. Once consumed, arbitrary destructor faults
/// cannot promise recovery or rollback; a committed source is never relabeled
/// rejected merely because its presentation failed.
pub enum SetError<T> {
    Rejected { error: Error, value: T },
    Committed { error: Error, commit: Commit },
    OwnerFault { error: Error },
}
impl<T> std::fmt::Debug for SetError<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Rejected { error, .. } => f
                .debug_struct("Rejected")
                .field("error", error)
                .field("value_type", &std::any::type_name::<T>())
                .finish_non_exhaustive(),
            Self::Committed { error, commit } => f
                .debug_struct("Committed")
                .field("error", error)
                .field("commit", commit)
                .finish(),
            Self::OwnerFault { error } => {
                f.debug_struct("OwnerFault").field("error", error).finish()
            }
        }
    }
}
impl<T> std::fmt::Display for SetError<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Rejected { error, .. } => write!(f, "source assignment rejected: {error}"),
            Self::Committed { error, commit } => write!(
                f,
                "source assignment committed at epoch {}; subsequent processing failed: {error}",
                commit.source_epoch
            ),
            Self::OwnerFault { error } => write!(
                f,
                "source assignment consumed its value before an owner fault: {error}"
            ),
        }
    }
}
impl<T> std::error::Error for SetError<T> {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        Some(match self {
            Self::Rejected { error, .. }
            | Self::Committed { error, .. }
            | Self::OwnerFault { error } => error,
        })
    }
}

#[derive(Clone, Debug, PartialEq, Serialize)]
pub struct SnapshotNode {
    pub identity: u64,
    pub parent: Option<usize>,
    pub role: String,
    pub text: Option<String>,
    /// Conservative viewport-clipped window bounds; hit tests use the matrix.
    pub bounds: [f32; 4],
    pub transform: Option<[f32; 6]>,
    pub target: Option<Target>,
}
impl SnapshotNode {
    pub fn rect(&self) -> Rect {
        Rect::new(
            self.bounds[0],
            self.bounds[1],
            self.bounds[2],
            self.bounds[3],
        )
    }
}
#[derive(Clone, Debug, PartialEq, Serialize)]
pub struct Snapshot {
    pub source_epoch: u64,
    pub presentation_epoch: u64,
    pub presentation_valid: bool,
    pub prepared_epoch: Option<u64>,
    /// Size of the acknowledged presentation (empty initially for recording).
    pub size: [u32; 2],
    pub requested_size: [u32; 2],
    /// Device pixels per logical layout unit in the acknowledged sheet.
    pub scale_factor: f32,
    pub requested_scale_factor: f32,
    pub poisoned: bool,
    pub nodes: Vec<SnapshotNode>,
}
impl Snapshot {
    pub fn to_json(&self) -> Result<String, Error> {
        serde_json::to_string(self).map_err(|error| Error::Serialization(error.to_string()))
    }
}

/// One interactive layout per text-bearing site. A first known-width measurement
/// may fill a vacant slot; other measurement widths never replace it. Final
/// placement checks its exact width before retaining C/P geometry. Description
/// moves surviving identities and removed sites drop their glyph buffers.
struct Shaped {
    width: Option<u32>,
    layout: TextLayout,
}
/// A compact preorder index, never an externally actionable identity. The
/// description's MAX_NODES admission bounds every index before retention.
#[derive(Clone, Copy)]
struct Parent(u32);
impl Parent {
    const NONE: Self = Self(u32::MAX);

    fn new(index: Option<usize>) -> Self {
        Self(index.map_or(u32::MAX, |index| {
            assert!(
                index < MAX_NODES,
                "parent belongs to the admitted description"
            );
            index as u32
        }))
    }
    fn index(self) -> Option<usize> {
        (self.0 != u32::MAX).then_some(self.0 as usize)
    }
}
#[cfg(test)]
mod parent_tests {
    use super::*;

    #[test]
    fn nonzero_identity_keeps_old_node_migration_in_place() {
        assert_eq!(size_of::<Node>(), 24);
        assert_eq!(size_of::<Option<Node>>(), size_of::<Node>());
        let nodes = (1..=64)
            .map(|identity| Node {
                identity: NonZeroU64::new(identity).unwrap(),
                links: links::NodeLinks::new(None, 0, None),
                content: Content::new(NodeKind::Div, TextSlot::NONE),
                component_scope: 0,
            })
            .collect::<Vec<_>>();
        let pointer = nodes.as_ptr().cast::<u8>();
        let mut old = None;
        let allocation = allocation_counter::measure(|| {
            old = Some(nodes.into_iter().map(Some).collect::<Vec<_>>());
        });
        let old = old.unwrap();
        assert_eq!(old.as_ptr().cast::<u8>(), pointer);
        assert_eq!(allocation.count_total, 0);
        for (index, node) in old.iter().enumerate() {
            assert_eq!(node.as_ref().unwrap().identity(), index as u64 + 1);
        }
    }

    #[test]
    fn compact_parent_covers_the_admitted_index_domain() {
        assert_eq!(size_of::<Parent>(), 4);
        assert_eq!(Parent::new(None).index(), None);
        for index in 0..MAX_NODES {
            assert_eq!(Parent::new(Some(index)).index(), Some(index));
        }
        println!(
            "Parent={} Map={} Node={} Presented={}",
            size_of::<Parent>(),
            size_of::<geometry::MapBasis>(),
            size_of::<Node>(),
            size_of::<Presented>()
        );
        println!(
            "TextLayout={} Shaped={} OptionShaped={} RuntimeHeader={} TextSite={} OptionTextSite={}",
            size_of::<TextLayout>(),
            size_of::<Shaped>(),
            size_of::<Option<Shaped>>(),
            size_of::<Runtime<()>>(),
            size_of::<TextSite>(),
            size_of::<Option<TextSite>>()
        );
        println!(
            "GEOMETRY_RUNTIME system={} option_system={} prepared={}",
            size_of::<TextSystem>(),
            size_of::<Option<TextSystem>>(),
            size_of::<Prepared>()
        );
    }

    #[test]
    fn content_preserves_every_kind_and_admitted_text_index() {
        assert_eq!(size_of::<Content>(), 4);
        for kind in [
            NodeKind::Div,
            NodeKind::Text,
            NodeKind::Input,
            NodeKind::Button,
            NodeKind::List,
            NodeKind::ListItem,
            NodeKind::Scroll,
            NodeKind::CheckBox(false),
            NodeKind::CheckBox(true),
        ] {
            let empty = Content::new(kind, TextSlot::NONE);
            assert_eq!(empty.kind(), kind);
            assert_eq!(empty.text_slot().0, u32::MAX);
            for index in 0..MAX_NODES {
                let content = Content::new(kind, TextSlot(index as u32));
                assert_eq!(content.kind(), kind);
                assert_eq!(content.text_slot().0, index as u32);
                assert_ne!(content.0, empty.0);
            }
        }
    }

    #[test]
    fn content_preserves_all_image_resources_and_both_sampling_modes() {
        for resource in 0..MAX_NODES as u32 {
            for sampling in [crate::ImageSampling::Linear, crate::ImageSampling::Nearest] {
                let content = Content::image(image::ImageUse { resource, sampling });
                assert_eq!(content.kind(), NodeKind::Image);
                assert_eq!(content.text_slot().0, u32::MAX);
                let image = content.image_use().unwrap();
                assert_eq!(image.resource, resource);
                assert_eq!(image.sampling, sampling);
            }
        }
        assert!(
            Content::new(NodeKind::Image, TextSlot::NONE)
                .image_use()
                .is_none()
        );
    }

    #[test]
    fn disabled_content_flag_preserves_all_carriers_and_resource_decoding() {
        assert_eq!(size_of::<Node>(), 24);
        assert_eq!(size_of::<Presented>(), 64);
        assert_eq!(size_of::<crate::El<'_>>(), 176);
        assert_eq!(size_of::<crate::element::DraftNode<'_>>(), 152);
        for slot in [TextSlot::NONE, TextSlot(0), TextSlot(MAX_NODES as u32 - 1)] {
            for kind in [
                NodeKind::Input,
                NodeKind::Button,
                NodeKind::CheckBox(false),
                NodeKind::CheckBox(true),
            ] {
                let original = Content::new(kind, slot);
                for own in [false, true] {
                    let disabled = original.with_own_disabled(own).with_disabled(true);
                    assert!(disabled.disabled());
                    assert_eq!(disabled.own_disabled(), own);
                    assert_eq!(disabled.kind(), kind);
                    assert_eq!(disabled.text_slot().0, slot.0);
                    assert_eq!(
                        disabled.with_disabled(false).with_own_disabled(false).0,
                        original.0
                    );
                }
            }
        }
        for resource in [0, MAX_NODES as u32 - 1] {
            for sampling in [crate::ImageSampling::Linear, crate::ImageSampling::Nearest] {
                let content = Content::image(image::ImageUse { resource, sampling })
                    .with_own_disabled(true)
                    .with_disabled(true);
                let image = content.image_use().unwrap();
                assert_eq!(image.resource, resource);
                assert_eq!(image.sampling, sampling);
            }
        }
    }

    #[test]
    fn checkbox_state_preserves_carrier_layouts() {
        macro_rules! carrier {
            ($ty:ty) => {
                println!(
                    "CHECKBOX_CARRIER {} size={} align={}",
                    stringify!($ty),
                    size_of::<$ty>(),
                    std::mem::align_of::<$ty>()
                );
            };
        }
        carrier!(NodeKind);
        carrier!(Option<NodeKind>);
        carrier!(Content);
        carrier!(Node);
        carrier!(Option<Node>);
        carrier!(Presented);
        carrier!(Option<Presented>);
        carrier!(Prepared);
        carrier!(Option<Prepared>);
        carrier!(crate::El<'_>);
        carrier!(Option<crate::El<'_>>);
        carrier!(crate::element::DraftNode<'_>);
        carrier!(Option<crate::element::DraftNode<'_>>);
        carrier!((Option<u64>, u32, NodeKind));
        carrier!((Option<u64>, crate::ItemKey, NodeKind));
        carrier!((Option<u64>, crate::ListId, NodeKind));
        carrier!(Runtime<()>);
        carrier!(crate::Role);
        carrier!(Option<crate::Role>);
        carrier!(crate::Part<'_>);
        carrier!(Actions);
        assert_eq!(size_of::<NodeKind>(), 1);
        assert_eq!(size_of::<Option<NodeKind>>(), 1);
        assert_eq!(size_of::<Content>(), 4);
        assert_eq!(size_of::<Node>(), 24);
        assert_eq!(size_of::<Option<Node>>(), size_of::<Node>());
        assert_eq!(size_of::<Presented>(), 64);
        assert_eq!(size_of::<Prepared>(), 40);
        assert_eq!(size_of::<crate::El<'_>>(), 176);
        assert_eq!(size_of::<crate::element::DraftNode<'_>>(), 152);
        println!(
            "CHECKBOX_WRAPPERS option_el={} option_draft={} option_presented={} option_prepared={} ordinal_key={} keyed_key={} runtime={} role={} option_role={}",
            size_of::<Option<crate::El<'_>>>(),
            size_of::<Option<crate::element::DraftNode<'_>>>(),
            size_of::<Option<Presented>>(),
            size_of::<Option<Prepared>>(),
            size_of::<(Option<u64>, u32, NodeKind)>(),
            size_of::<(Option<u64>, crate::ItemKey, NodeKind)>(),
            size_of::<Runtime<()>>(),
            size_of::<crate::Role>(),
            size_of::<Option<crate::Role>>()
        );
        println!(
            "CHECKBOX_LAYOUT kind={} option_kind={} content={} node={} option_node={} presented={} prepared={} el={} draft={}",
            size_of::<NodeKind>(),
            size_of::<Option<NodeKind>>(),
            size_of::<Content>(),
            size_of::<Node>(),
            size_of::<Option<Node>>(),
            size_of::<Presented>(),
            size_of::<Prepared>(),
            size_of::<crate::El<'_>>(),
            size_of::<crate::element::DraftNode<'_>>()
        );
    }

    #[test]
    #[should_panic(expected = "text belongs to the admitted description")]
    fn content_rejects_the_first_unadmitted_text_index() {
        Content::new(NodeKind::Text, TextSlot(MAX_NODES as u32));
    }
}
/// Text values, their source binding and their width cache share one owned
/// dense lane. Option permits moving an entry during description without a
/// placeholder allocation. Every live slot is Some outside reconciliation.
struct TextSite {
    value: SharedText,
    field: Option<FieldId>,
    shaped: Option<Shaped>,
}
/// Internal dense-lane offset, bounded by the admitted node count. Containers
/// carry only NONE, with no inline text, source binding or layout cache.
#[derive(Clone, Copy)]
struct TextSlot(u32);
impl TextSlot {
    const NONE: Self = Self(u32::MAX);

    #[inline]
    fn get(self, texts: &[Option<TextSite>]) -> Option<&TextSite> {
        (self.0 != u32::MAX).then(|| texts[self.0 as usize].as_ref().unwrap())
    }
    #[inline]
    fn get_mut(self, texts: &mut [Option<TextSite>]) -> Option<&mut TextSite> {
        (self.0 != u32::MAX).then(|| texts[self.0 as usize].as_mut().unwrap())
    }
    fn take(self, texts: &mut [Option<TextSite>]) -> Option<TextSite> {
        if self.0 == u32::MAX {
            None
        } else {
            texts[self.0 as usize].take()
        }
    }
}
/// A closed kind and an optional admitted text-lane index fit in one word.
/// Zero in the upper bits means no text; the lower four bits encode the kind
/// including the checkbox state. No Rust enum representation is reinterpreted.
#[derive(Clone, Copy)]
struct Content(u32);
const _: () = assert!(MAX_NODES * 2 <= (1 << (Content::BITS - 3 - 4)));
impl Content {
    const BITS: u32 = 25;
    const DISABLED: u32 = 1 << 22;
    const OWN_DISABLED: u32 = 1 << 23;
    const INVALID: u32 = 1 << 24;
    const FLAGS: u32 = Self::DISABLED | Self::OWN_DISABLED | Self::INVALID;
    fn invalid(self) -> bool {
        self.0 & Self::INVALID != 0
    }
    fn with_invalid(self, invalid: bool) -> Self {
        Self((self.0 & !Self::INVALID) | (u32::from(invalid) * Self::INVALID))
    }
    fn with_own_disabled(self, disabled: bool) -> Self {
        Self((self.0 & !Self::OWN_DISABLED) | (u32::from(disabled) * Self::OWN_DISABLED))
    }
    fn own_disabled(self) -> bool {
        self.0 & Self::OWN_DISABLED != 0
    }
    fn with_checked(self, checked: bool) -> Self {
        assert!(matches!(self.kind(), NodeKind::CheckBox(_)));
        Self((self.0 & !15) | 8 | u32::from(checked))
    }
    fn with_disabled(self, disabled: bool) -> Self {
        Self((self.0 & !Self::DISABLED) | (u32::from(disabled) * Self::DISABLED))
    }
    fn disabled(self) -> bool {
        self.0 & Self::DISABLED != 0
    }
    #[inline]
    fn new(kind: NodeKind, text: TextSlot) -> Self {
        let kind = match kind {
            NodeKind::Div => 0,
            NodeKind::Text => 1,
            NodeKind::Input => 2,
            NodeKind::Button => 3,
            NodeKind::List => 4,
            NodeKind::ListItem => 5,
            NodeKind::Image => 6,
            NodeKind::Scroll => 7,
            NodeKind::CheckBox(checked) => 8 + u32::from(checked),
        };
        let text = if text.0 == u32::MAX {
            0
        } else {
            assert!(
                (text.0 as usize) < MAX_NODES,
                "text belongs to the admitted description"
            );
            text.0 + 1
        };
        Self((text << 4) | kind)
    }
    #[inline]
    fn kind(self) -> NodeKind {
        match self.0 & 15 {
            0 => NodeKind::Div,
            1 => NodeKind::Text,
            2 => NodeKind::Input,
            3 => NodeKind::Button,
            4 => NodeKind::List,
            5 => NodeKind::ListItem,
            6 => NodeKind::Image,
            7 => NodeKind::Scroll,
            8 => NodeKind::CheckBox(false),
            9 => NodeKind::CheckBox(true),
            _ => unreachable!("explicitly encoded kind"),
        }
    }
    #[inline]
    fn text_slot(self) -> TextSlot {
        if self.kind() == NodeKind::Image {
            return TextSlot::NONE;
        }
        let text = (self.0 & !Self::FLAGS) >> 4;
        TextSlot(if text == 0 { u32::MAX } else { text - 1 })
    }
    fn image(image: image::ImageUse) -> Self {
        assert!((image.resource as usize) < MAX_NODES);
        let value = image.resource * 2 + u32::from(image.sampling == crate::ImageSampling::Nearest);
        Self(((value + 1) << 4) | 6)
    }
    fn image_use(self) -> Option<image::ImageUse> {
        let value = (self.0 & !Self::FLAGS) >> 4;
        if self.kind() != NodeKind::Image || value == 0 {
            return None;
        }
        let value = value - 1;
        Some(image::ImageUse {
            resource: value / 2,
            sampling: if value & 1 == 0 {
                crate::ImageSampling::Linear
            } else {
                crate::ImageSampling::Nearest
            },
        })
    }
}
mod handlers;
mod links;
struct Node {
    identity: NonZeroU64,
    links: links::NodeLinks,
    content: Content,
    component_scope: u32,
}
#[cfg(test)]
mod hit_tests;
#[cfg(test)]
mod style_ledger;
impl Node {
    fn parent(&self) -> Parent {
        self.links.parent()
    }
    fn ordinal(&self) -> u32 {
        self.links.ordinal()
    }
    fn handler_slot(&self) -> Option<usize> {
        self.links.handler()
    }
    fn has_handler(&self) -> bool {
        !self.content.disabled() && self.handler_slot().is_some()
    }
    fn focusable(&self) -> bool {
        !self.content.disabled()
            && (matches!(self.kind(), NodeKind::Input | NodeKind::Button) || self.has_handler())
    }
    #[inline]
    fn identity(&self) -> u64 {
        self.identity.get()
    }
    #[inline]
    fn kind(&self) -> NodeKind {
        self.content.kind()
    }
    #[inline]
    fn text_slot(&self) -> TextSlot {
        self.content.text_slot()
    }
}
impl TextSite {
    fn measure_for(
        &mut self,
        service: &mut TextShaper<'_>,
        font_size: f32,
        input: WidthMeasureInput,
    ) -> Result<TextMetrics, Error> {
        let width = input
            .known_dimensions
            .width
            .or(match input.available_width {
                AvailableSpace::Definite(width) => Some(width),
                AvailableSpace::MinContent => Some(f32::MIN_POSITIVE),
                AvailableSpace::MaxContent => None,
            });
        let width = width.map(|value| value.max(f32::MIN_POSITIVE));
        if self.shaped.is_none() && input.known_dimensions.width.is_some() {
            self.shape_for(service, font_size, width)?;
        }
        if let Some(shape) = &self.shaped
            && shape.width == width.map(f32::to_bits)
            && shape.layout.font_size() == font_size
        {
            return Ok(TextMetrics {
                width: shape.layout.width,
                height: shape.layout.height,
                baseline: shape.layout.baseline,
            });
        }
        Ok(service.measure(&self.value, font_size, width)?)
    }
    fn shape_for<'n>(
        &'n mut self,
        service: &mut TextShaper<'_>,
        font_size: f32,
        width: Option<f32>,
    ) -> Result<&'n TextLayout, Error> {
        let width = width.map(|value| value.max(f32::MIN_POSITIVE));
        let key = width.map(f32::to_bits);
        if self
            .shaped
            .as_ref()
            .is_none_or(|shape| shape.width != key || shape.layout.font_size() != font_size)
        {
            let layout = service.shape_interactive(&self.value, font_size, width)?;
            self.shaped = Some(Shaped { width: key, layout });
        }
        Ok(&self.shaped.as_ref().unwrap().layout)
    }
}
struct MappedRecord {
    destination: Destination,
    recipe: crate::style_port::Recipe,
    // Zero or one checked source-slot code; uses the record's former padding.
    color: u32,
}
struct MappedFanout {
    codec: TextCodec,
    destinations: Vec<Destination>,
    records: Vec<MappedRecord>,
    // Retained scratch admits every output before the first sink write.
    values: Vec<crate::property::PropertyValue>,
    direct_color: u32,
}
enum ColorPatch {
    Full,
    Candidate(Option<styles::ColorChange>),
}
impl MappedFanout {
    // Every comparison and inspector base must see the OLD bank. Publish only
    // after all sinks compare, including masked peers sharing the direct slot.
    #[inline(never)]
    fn publish_colors(
        &self,
        styles: &mut styles::Styles,
        direct: Option<crate::style_port::Scalar>,
        eligible: bool,
    ) -> ColorPatch {
        let mut patch = if eligible
            && self.records.iter().all(|record| record.color != 0)
            && self.destinations.iter().all(|destination| {
                matches!(
                    destination.property(),
                    Some(
                        crate::property::PropertyId::Foreground
                            | crate::property::PropertyId::Background
                    )
                )
            }) {
            ColorPatch::Candidate(None)
        } else {
            ColorPatch::Full
        };
        let mut publish = |slot, color| {
            if let Some(change) = styles.update_color(slot, color)
                && let ColorPatch::Candidate(candidate) = &mut patch
                && change.users != 0
                && change.previous.working().map(f32::to_bits)
                    != change.value.working().map(f32::to_bits)
                && (change.canvas.is_some()
                    || change.previous.working()[3].to_bits()
                        != change.value.working()[3].to_bits())
            {
                if candidate.is_some() {
                    patch = ColorPatch::Full;
                } else {
                    *candidate = Some(change);
                }
            }
        };
        for (record, value) in self.records.iter().zip(&self.values) {
            if let Some(slot) = styles::ColorSlot::from_source_code(record.color) {
                let crate::property::PropertyValue::Color(color) = *value else {
                    unreachable!("color slot has color property")
                };
                publish(slot, color);
            }
        }
        if let Some(slot) = styles::ColorSlot::from_source_code(self.direct_color) {
            let Some(crate::style_port::Scalar::Value(crate::property::PropertyValue::Color(
                color,
            ))) = direct
            else {
                unreachable!("direct color frozen and admitted")
            };
            publish(slot, color);
        }
        patch
    }
}
struct BooleanRecipe {
    recipe: crate::style_port::Recipe,
    value: bool,
}
struct BooleanOutput {
    destination: Destination,
    group: u32,
    colors: [u32; 2],
}
struct BooleanFanout {
    base: Fanout,
    groups: Vec<BooleanRecipe>,
    outputs: Vec<BooleanOutput>,
}
enum Fanout {
    General {
        codec: TextCodec,
        destinations: Vec<Destination>,
    },
    Color(styles::ColorSlot),
    Mapped(Box<MappedFanout>),
    Boolean(Box<BooleanFanout>),
}
impl Fanout {
    fn new(codec: TextCodec) -> Self {
        Self::General {
            codec,
            destinations: Vec::new(),
        }
    }
    fn codec(&self) -> TextCodec {
        match self {
            Self::General { codec, .. } => *codec,
            Self::Color(_) => TextCodec::for_style::<Color>(),
            Self::Mapped(mapped) => mapped.codec,
            Self::Boolean(group) => group.base.codec(),
        }
    }
    fn destinations(&self) -> &[Destination] {
        match self {
            Self::General { destinations, .. } => destinations,
            Self::Color(_) => &[],
            Self::Mapped(mapped) => &mapped.destinations,
            Self::Boolean(group) => group.base.destinations(),
        }
    }
    fn destinations_mut(&mut self) -> &mut Vec<Destination> {
        match self {
            Self::General { destinations, .. } => destinations,
            Self::Color(_) => unreachable!("color fanout installed after description"),
            Self::Mapped(mapped) => &mut mapped.destinations,
            Self::Boolean(group) => group.base.destinations_mut(),
        }
    }
    fn plain_mut(&mut self) -> &mut Self {
        if let Self::Boolean(group) = self {
            &mut group.base
        } else {
            self
        }
    }
    fn plain(&self) -> &Self {
        if let Self::Boolean(group) = self {
            &group.base
        } else {
            self
        }
    }
    fn boolean(
        &mut self,
        draft: crate::style_port::BooleanDraft<'_>,
        colors: &mut styles::ColorDiscovery,
    ) -> Result<(), Error> {
        let recipe = draft.recipe.lower(|color| colors.literal_code(color))?;
        if !matches!(self, Self::Boolean(_)) {
            let base = std::mem::replace(self, Self::new(TextCodec::for_style::<bool>()));
            *self = Self::Boolean(Box::new(BooleanFanout {
                base,
                groups: Vec::new(),
                outputs: Vec::new(),
            }));
        }
        let Self::Boolean(fanout) = self else {
            unreachable!()
        };
        let index = u32::try_from(fanout.groups.len()).map_err(|_| Error::ResourceLimit)?;
        fanout.groups.push(BooleanRecipe {
            recipe,
            value: draft.value,
        });
        for member in draft.members {
            let palette = if let Some(palette) = member.colors {
                for color in palette {
                    crate::property::FOREGROUND.validate(&color)?;
                }
                palette.map(|color| colors.literal_code(color))
            } else {
                [0, 0]
            };
            fanout.outputs.push(BooleanOutput {
                destination: Destination::sink(member.node as usize, member.sink),
                group: index,
                colors: palette,
            });
        }
        Ok(())
    }
    #[inline(never)]
    fn map(
        &mut self,
        draft: crate::style_port::MapDraft<'_>,
        colors: &mut styles::ColorDiscovery,
    ) -> Result<(), Error> {
        if let Self::Boolean(group) = self {
            return group.base.map(draft, colors);
        }
        let value = draft.value;
        let recipe = draft
            .operand
            .recipe
            .lower(|color| colors.literal_code(color))?;
        if let Self::General {
            codec,
            destinations,
        } = self
        {
            *self = Self::Mapped(Box::new(MappedFanout {
                codec: *codec,
                destinations: std::mem::take(destinations),
                records: Vec::new(),
                values: Vec::new(),
                direct_color: 0,
            }));
        }
        let Self::Mapped(mapped) = self else {
            unreachable!()
        };
        mapped.records.push(MappedRecord {
            destination: Destination::sink(draft.node as usize, draft.sink),
            recipe,
            color: 0,
        });
        mapped.values.push(value);
        Ok(())
    }
    // Shared erased admission keeps model-specific owner turns small. All
    // outputs are frozen and admitted here before any destination can mutate.
    #[inline(never)]
    fn freeze<'a>(
        &mut self,
        source: &'a dyn std::any::Any,
        field: FieldId,
        styles: &styles::Styles,
    ) -> Result<crate::source::Frozen<'a>, Error> {
        if let Self::Boolean(fanout) = self {
            let frozen = fanout.base.freeze(source, field, styles)?;
            // Freeze each declared computation once, before any destination is
            // compared or changed. Palette endpoints were admitted at mount.
            for group in &mut fanout.groups {
                let _ = group.recipe.call(source);
                let Some(crate::style_port::Scalar::Value(crate::property::PropertyValue::Flag(
                    value,
                ))) = group.recipe.call(source)
                else {
                    return Err(Error::MapInput);
                };
                group.value = value;
            }
            return Ok(frozen);
        }
        let mut needs = crate::source::Needs {
            text: false,
            style: false,
        };
        for destination in self.destinations() {
            if destination.target_sink().is_some() {
                needs.style = true;
            } else {
                needs.text = true;
            }
        }
        let frozen = if needs.text || needs.style {
            self.codec().freeze(source, field, needs)?
        } else {
            crate::source::Frozen {
                text: None,
                style: None,
            }
        };
        if let Fanout::Mapped(mapped) = self {
            for (record, value) in mapped.records.iter().zip(&mut mapped.values) {
                *value = record
                    .destination
                    .target_sink()
                    .expect("mapped sink")
                    .admit(
                        styles.resolve_scalar(
                            record
                                .recipe
                                .call(source)
                                .ok_or(BindError::TypeMismatch(field))?,
                        ),
                    )?;
            }
        }
        // A numeric source may feed width, font size AND text. Reject every bad
        // sink before the first logical destination or inspector base is edited.
        for destination in self.destinations() {
            if let Some(sink) = destination.target_sink() {
                sink.admit(frozen.style.expect("scalar codec requested"))?;
            }
        }
        Ok(frozen)
    }
    #[inline(never)]
    fn finish_description(
        &mut self,
        field: FieldId,
        drafts: &[crate::element::DraftNode<'_>],
        colors: &mut styles::ColorDiscovery,
    ) -> bool {
        if let Self::Boolean(group) = self {
            group.base.finish_description(field, drafts, colors);
            group
                .outputs
                .sort_unstable_by_key(|output| output.destination.packed());
            group.groups.shrink_to_fit();
            group.outputs.shrink_to_fit();
            return true;
        }
        self.destinations_mut()
            .sort_unstable_by_key(|destination| destination.packed());
        let Self::Mapped(mapped) = self else {
            return false;
        };
        let mut register = |destination: Destination, code: &mut u32| {
            if let Some(
                id @ (crate::property::PropertyId::Foreground
                | crate::property::PropertyId::Background),
            ) = destination.property()
            {
                let slot = styles::ColorSlot::from_source_code(*code).unwrap_or_else(|| {
                    let style = drafts[destination.node()].style;
                    colors.mapped(
                        field,
                        if id == crate::property::PropertyId::Foreground {
                            style.fg
                        } else {
                            style.bg
                        },
                    )
                });
                *code = slot.source_code();
                colors.mapped_port(destination, slot);
            }
        };
        for record in &mut mapped.records {
            register(record.destination, &mut record.color);
        }
        // Identity Color ports share one slot; mapped outputs each own one.
        for &destination in &mapped.destinations {
            register(destination, &mut mapped.direct_color);
        }
        // Scratch values are overwritten in this sorted record order
        // on every patch before the iterator can publish them.
        mapped
            .records
            .sort_unstable_by_key(|record| record.destination.packed());
        mapped.records.shrink_to_fit();
        mapped.values.shrink_to_fit();
        true
    }
    fn all_destinations(
        &self,
    ) -> impl Iterator<Item = (Destination, Option<crate::style_port::Scalar>, u32)> + '_ {
        let base = self.plain();
        let (mut records, mut values, direct_color) = match base {
            Self::Mapped(mapped) => (
                mapped.records.as_slice(),
                mapped.values.as_slice(),
                mapped.direct_color,
            ),
            _ => (&[][..], &[][..], 0),
        };
        let mut direct = base.destinations();
        let (groups, mut outputs) = match self {
            Self::Boolean(group) => (group.groups.as_slice(), group.outputs.as_slice()),
            _ => (&[][..], &[][..]),
        };
        std::iter::from_fn(move || {
            let d = direct
                .first()
                .map(|destination| destination.packed())
                .unwrap_or(u32::MAX);
            let m = records
                .first()
                .map(|record| record.destination.packed())
                .unwrap_or(u32::MAX);
            let c = outputs
                .first()
                .map(|output| output.destination.packed())
                .unwrap_or(u32::MAX);
            if d == u32::MAX && m == u32::MAX && c == u32::MAX {
                return None;
            }
            if d < m && d < c {
                let (&destination, rest) = direct.split_first()?;
                direct = rest;
                Some((destination, None, direct_color))
            } else if m < c {
                let (record, rest) = records.split_first()?;
                let (value, remaining) = values.split_first()?;
                records = rest;
                values = remaining;
                Some((
                    record.destination,
                    Some(crate::style_port::Scalar::Value(*value)),
                    record.color,
                ))
            } else {
                let (output, rest) = outputs.split_first()?;
                outputs = rest;
                let value = groups[output.group as usize].value;
                let scalar = if output.destination.control().is_some()
                    || output
                        .destination
                        .property()
                        .is_some_and(|id| id.value_kind() == crate::property::ValueKind::Flag)
                {
                    crate::style_port::Scalar::Value(crate::property::PropertyValue::Flag(value))
                } else {
                    crate::style_port::Scalar::ColorSlot(output.colors[usize::from(value)])
                };
                Some((output.destination, Some(scalar), 0))
            }
        })
    }

    #[cfg(test)]
    fn destination_bytes(&self) -> usize {
        match self {
            Self::General { destinations, .. } => {
                destinations.capacity() * size_of::<Destination>()
            }
            Self::Color(_) => 0,
            Self::Boolean(group) => {
                size_of::<BooleanFanout>()
                    + group.base.destination_bytes()
                    + group.groups.capacity() * size_of::<BooleanRecipe>()
                    + group.outputs.capacity() * size_of::<BooleanOutput>()
            }
            Self::Mapped(mapped) => {
                mapped.destinations.capacity() * size_of::<Destination>()
                    + size_of::<MappedFanout>()
                    + mapped.records.capacity() * size_of::<MappedRecord>()
                    + mapped.values.capacity() * size_of::<crate::property::PropertyValue>()
            }
        }
    }
}
/// A presented parent uses 17 bits; the remaining 15 store a conservative
/// run of impossible hits ending at this row. Neither part changes identity.
#[derive(Clone, Copy)]
struct PresentedLink(u32);
impl PresentedLink {
    const PARENT_BITS: u32 = 17;
    const PARENT_MASK: u32 = (1 << Self::PARENT_BITS) - 1;
    const MAX_SKIP: usize = (u32::MAX >> Self::PARENT_BITS) as usize;
    fn new(parent: Parent, impossible: bool, previous: Option<Self>) -> Self {
        let run = if impossible {
            previous
                .map_or(1, |link| link.skip() + 1)
                .min(Self::MAX_SKIP)
        } else {
            0
        };
        Self((parent.0 & Self::PARENT_MASK) | ((run as u32) << Self::PARENT_BITS))
    }
    fn index(self) -> Option<usize> {
        let parent = self.0 & Self::PARENT_MASK;
        (parent != Self::PARENT_MASK).then_some(parent as usize)
    }
    fn skip(self) -> usize {
        (self.0 >> Self::PARENT_BITS) as usize
    }
}
const _: () = assert!(MAX_NODES < (1 << PresentedLink::PARENT_BITS));
struct Presented {
    identity: u64,
    parent: PresentedLink,
    kind: NodeKind,
    text: Option<SharedText>,
    placement: geometry::Placement,
    basis: geometry::MapBasis,
    bounds: Rect,
    hittable: bool,
    state: u8,
    actions: Actions,
}
impl Presented {
    fn disabled(&self) -> bool {
        self.state & 1 != 0
    }
    fn invalid(&self) -> bool {
        self.state & 2 != 0
    }
    fn local_rect(&self) -> Rect {
        self.placement.local_rect()
    }
    fn transform(&self, bases: geometry::Bases<'_>) -> Option<Affine> {
        bases.transform(self.basis, self.placement)
    }
}
impl<M> Runtime<M> {
    fn presented_hit_sheet(&self) -> query::HitSheet<'_> {
        query::HitSheet {
            nodes: &self.presented,
            geometry: self.presented_geometry(),
            size: self.presentation_size,
            has_viewports: self
                .metadata
                .as_ref()
                .is_some_and(|m| !m.presented.viewports.is_empty()),
        }
    }
    // This proof requires a full C and its own frozen columns, never KEEP/P.
    fn candidate_hit_sheet(&self) -> Option<query::HitSheet<'_>> {
        let prepared = self.prepared.as_ref().filter(|c| !c.keeps_rows())?;
        let metadata = self.metadata.as_ref()?;
        let sheet = metadata.candidate.as_ref()?;
        let geometry = match metadata.geometry.as_deref() {
            Some(geometry) => geometry.candidate_view()?,
            None => geometry::GeometryView::empty(),
        };
        Some(query::HitSheet {
            nodes: &prepared.nodes,
            geometry,
            size: prepared.dimensions(),
            has_viewports: !sheet.viewports.is_empty(),
        })
    }
    fn presented_geometry(&self) -> geometry::GeometryView<'_> {
        self.metadata
            .as_ref()
            .and_then(|m| m.geometry.as_deref())
            .map_or_else(geometry::GeometryView::empty, geometry::Geometry::view)
    }
}

struct Prepared {
    // Successful Canvas admission bounds each axis to 16,384. Packing the
    // extents leaves room for damage without growing this 64-bit header.
    size: [u16; 2],
    scale_factor: f32,
    nodes: Vec<Presented>,
    damage: DamageRegion,
}

/// Surface-local transitions, advanced only after successful native presents.
/// Three rectangles cover buffer ages through four without retaining frames or
/// allocating a queue. Older or undefined buffers require a complete redraw.
#[cfg(any(feature = "native-core", test))]
#[derive(Default)]
pub(crate) struct SurfaceDamage {
    recent: [DamageRegion; 3],
    known: u8,
}
#[cfg(any(feature = "native-core", test))]
impl SurfaceDamage {
    pub(crate) fn since(&self, age: u8) -> Option<DamageRegion> {
        let count = age.checked_sub(1)?;
        (age <= self.known).then(|| {
            self.recent[..usize::from(count)]
                .iter()
                .copied()
                .fold(DamageRegion::default(), DamageRegion::union)
        })
    }

    pub(crate) fn presented(&mut self, damage: DamageRegion) {
        self.recent = [damage, self.recent[0], self.recent[1]];
        self.known = (self.known + 1).min(4);
    }
}
struct Runtime<M> {
    model: M,
    sources: Sources<M>,
    nodes: Vec<Node>,
    handlers: Option<Box<handlers::Handlers>>,
    styles: styles::Styles,
    texts: Vec<Option<TextSite>>,
    images: Option<Box<image::SceneResources>>,
    by_identity: IdentityIndex,
    fanout: BTreeMap<FieldId, Fanout>,
    next_identity: u64,
    focused: Option<Target>,
    sites: Sites,
    overrides: Overrides,
    metadata: Option<Box<Metadata>>,
    viewports: BTreeMap<ViewportKey, ViewportState>,
    list_rows: BTreeMap<u64, ListRow>,
    layout: LayoutTree,
    layout_nodes: Vec<NodeId>,
    layout_dirty: BTreeSet<u64>,
    rebuild_layout: bool,
    layout_depth: u8,
    topology_changed: bool,
    logical_valid: bool,
    dirty: bool,
    source_epoch: u64,
    presentation_epoch: u64,
    #[cfg(feature = "accessibility")]
    presented_sequence: Option<NonZeroU64>,
    #[cfg(feature = "accessibility")]
    accessibility: Option<Box<accessibility::Observer>>,
    presentation_valid: bool,
    presentation_size: [u32; 2],
    requested_size: [u32; 2],
    requested_scale_factor: f32,
    presentation_scale_factor: f32,
    automatic_presentation: bool,
    next_presentation: NonZeroU64,
    prepared: Option<Prepared>,
    latest_token: Option<PresentationToken>,
    complete_epoch: u64,
    presented: Vec<Presented>,
    canvas: Canvas,
    text: Option<Box<text_geometry::TextResources>>,
    poisoned: bool,
    counters: Counters,
    changed_nodes: usize,
}

/// An exclusively owned serial window runtime. Every input adapter uses these
/// same operations. Mutation requires `&mut Win`; queries borrow `&Win`.
///
/// ```compile_fail
/// use gpui::{El, View, Win, text};
/// struct Page;
/// impl View for Page { fn view(&self) -> El<'_> { text("page") } }
/// let mut win = Win::demo(Page);
/// win.with_model(|_| win.update(|_| {}).unwrap()).unwrap();
/// ```
///
/// ```compile_fail
/// use gpui::{El, View, Win, text};
/// struct Page;
/// impl View for Page { fn view(&self) -> El<'_> { text("page") } }
/// let mut win = Win::demo(Page);
/// win.with_scene(|_, _| win.close()).unwrap();
/// ```
pub struct Win<M: View + 'static, L: LaneSet<M> = ()> {
    // Declaration order closes every receiver before the model is dropped.
    lanes: L,
    inner: Option<Box<Runtime<M>>>,
}
// A private exclusive borrow ties owner faults to receiver cleanup before a
// public operation returns. No model/reference-counted state is shared. The
// empty chain's constant erases this cleanup path from ordinary windows.
struct RuntimeMut<'a, M: View + 'static, L: LaneSet<M>> {
    runtime: &'a mut Runtime<M>,
    lanes: &'a mut L,
}
impl<M: View + 'static, L: LaneSet<M>> std::ops::Deref for RuntimeMut<'_, M, L> {
    type Target = Runtime<M>;
    fn deref(&self) -> &Self::Target {
        self.runtime
    }
}
impl<M: View + 'static, L: LaneSet<M>> std::ops::DerefMut for RuntimeMut<'_, M, L> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        self.runtime
    }
}
impl<M: View + 'static, L: LaneSet<M>> Drop for RuntimeMut<'_, M, L> {
    fn drop(&mut self) {
        if !L::EMPTY && (self.runtime.poisoned || self.runtime.source_epoch == u64::MAX) {
            self.lanes.close();
        }
    }
}
impl<M: View + 'static> Win<M> {
    pub fn with_questions<Q: LaneSet<M>>(
        model: M,
        questions: crate::Questions<M, Q>,
        options: WindowOptions,
    ) -> Result<Win<M, crate::reader::QuestionSet<Q, ()>>, Error> {
        Win::mount_lanes(model, questions.bind(()), options, true, 1.0, false)
    }
    pub fn recording_questions<Q: LaneSet<M>>(
        model: M,
        questions: crate::Questions<M, Q>,
        options: WindowOptions,
    ) -> Result<Win<M, crate::reader::QuestionSet<Q, ()>>, Error> {
        Win::mount_lanes(model, questions.bind(()), options, false, 1.0, false)
    }
    /// Mount the real application beside its opt-in retained inspector controls.
    pub fn with_inspector(model: M, options: WindowOptions) -> Result<Self, Error> {
        Self::mount_lanes(model, (), options, true, 1.0, true)
    }
    pub fn recording_with_inspector(model: M, options: WindowOptions) -> Result<Self, Error> {
        Self::mount_lanes(model, (), options, false, 1.0, true)
    }
    pub fn new(model: M) -> Result<Self, Error> {
        Self::with_options(model, WindowOptions::default())
    }
    pub fn demo(model: M) -> Self {
        Self::new(model).expect("demo window failed to mount")
    }
    pub fn with_size(model: M, width: u32, height: u32) -> Result<Self, Error> {
        Self::with_options(
            model,
            WindowOptions {
                size: [width, height],
                ..WindowOptions::default()
            },
        )
    }
    pub fn with_options(model: M, options: WindowOptions) -> Result<Self, Error> {
        Self::with_options_scaled(model, options, 1.0)
    }
    /// Headless physical viewport with logical layout and device-resolution text.
    pub fn with_options_scaled(
        model: M,
        options: WindowOptions,
        scale_factor: f32,
    ) -> Result<Self, Error> {
        Self::mount(model, options, true, scale_factor)
    }
    /// Native/backend path: command recording, no CPU framebuffer. Initial S0
    /// has no presented authority until the adapter acknowledges its token.
    pub fn recording(model: M, options: WindowOptions) -> Result<Self, Error> {
        Self::recording_scaled(model, options, 1.0)
    }
    /// Command-only native viewport. Size is physical pixels; component styles,
    /// shaping and layout remain logical units, transformed once at the root.
    pub fn recording_scaled(
        model: M,
        options: WindowOptions,
        scale_factor: f32,
    ) -> Result<Self, Error> {
        Self::mount(model, options, false, scale_factor)
    }
    fn mount(
        model: M,
        options: WindowOptions,
        automatic_presentation: bool,
        scale_factor: f32,
    ) -> Result<Self, Error> {
        Self::mount_lanes(
            model,
            (),
            options,
            automatic_presentation,
            scale_factor,
            false,
        )
    }
}
impl<M: View + 'static> Win<M> {
    pub fn from_json(input: &str) -> Result<Self, Error>
    where
        M: serde::de::DeserializeOwned,
    {
        let model =
            serde_json::from_str(input).map_err(|error| Error::Serialization(error.to_string()))?;
        Self::new(model)
    }
}
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    fn mount_lanes(
        model: M,
        lanes: L,
        options: WindowOptions,
        automatic_presentation: bool,
        scale_factor: f32,
        inspector: bool,
    ) -> Result<Self, Error> {
        // Until the full Win exists, this ordinary field-ordered value closes
        // every receiver before model destruction on ANY preparation failure.
        struct PendingMount<M, L> {
            lanes: L,
            model: M,
        }
        let pending = PendingMount { lanes, model };
        validate_scale(options.size, scale_factor)?;
        let sources =
            catch_unwind(AssertUnwindSafe(M::sources)).map_err(|_| Error::OwnerPanicked)?;
        let canvas = Canvas::recording(options.size[0], options.size[1], options.colors)?;
        // These constructors run while PendingMount still owns the model and
        // receiver order, including checked process-namespace exhaustion.
        let sites = Sites::new();
        let layout = LayoutTree::new();
        let runtime = Runtime {
            model: pending.model,
            sources,
            nodes: Vec::new(),
            handlers: None,
            styles: styles::Styles::default(),
            texts: Vec::new(),
            images: None,
            by_identity: IdentityIndex::default(),
            fanout: BTreeMap::new(),
            next_identity: 1,
            focused: None,
            sites,
            overrides: Overrides::default(),
            metadata: inspector.then(|| {
                Box::new(Metadata {
                    inspector: Some(Box::default()),
                    ..Metadata::default()
                })
            }),
            viewports: BTreeMap::new(),
            list_rows: BTreeMap::new(),
            layout,
            layout_nodes: Vec::new(),
            layout_dirty: BTreeSet::new(),
            rebuild_layout: true,
            layout_depth: 0,
            topology_changed: true,
            logical_valid: false,
            dirty: true,
            source_epoch: 0,
            presentation_epoch: 0,
            #[cfg(feature = "accessibility")]
            presented_sequence: None,
            #[cfg(feature = "accessibility")]
            accessibility: None,
            presentation_valid: false,
            presentation_size: [0, 0],
            requested_size: options.size,
            requested_scale_factor: scale_factor,
            presentation_scale_factor: 1.0,
            automatic_presentation,
            next_presentation: NonZeroU64::new(1).unwrap(),
            prepared: None,
            latest_token: None,
            complete_epoch: 0,
            presented: Vec::new(),
            canvas,
            text: None,
            poisoned: false,
            counters: Counters::default(),
            changed_nodes: 0,
        };
        let mut window = Self {
            lanes: pending.lanes,
            inner: Some(Box::new(runtime)),
        };
        let mut runtime = window.runtime_mut()?;
        runtime.describe(true)?;
        runtime.present()?;
        if runtime.lanes.start_questions() {
            runtime.describe(false)?;
            runtime.present()?;
        }
        drop(runtime);
        Ok(window)
    }
    #[cfg(feature = "native-core")]
    pub(crate) fn recording_lanes(
        model: M,
        lanes: L,
        options: WindowOptions,
        scale_factor: f32,
        inspector: bool,
    ) -> Result<Self, Error> {
        Self::mount_lanes(model, lanes, options, false, scale_factor, inspector)
    }
    fn runtime_mut(&mut self) -> Result<RuntimeMut<'_, M, L>, Error> {
        Ok(RuntimeMut {
            runtime: self.inner.as_deref_mut().ok_or(Error::Closed)?,
            lanes: &mut self.lanes,
        })
    }
    fn runtime(&self) -> Result<&Runtime<M>, Error> {
        self.inner.as_deref().ok_or(Error::Closed)
    }
    /// Revoke this owned window and release its model and retained resources.
    pub fn close(&mut self) {
        self.lanes.close();
        self.inner.take();
    }
    pub fn is_closed(&self) -> bool {
        self.inner.is_none()
    }

    /// Arbitrary model edits conservatively refresh snapshots and structure.
    pub fn update(&mut self, edit: impl FnOnce(&mut M)) -> Result<Commit, Error> {
        self.runtime_mut()?.operation(None, |model, _| {
            edit(model);
            Ok(())
        })
    }
    /// Borrow the current logical value through its mounted declaration/path.
    /// This does not require a presentation ACK or expose an old P snapshot.
    pub fn read<T: 'static>(&self, source: impl SourcePath<M, T>) -> Result<&T, Error> {
        let runtime = self.runtime()?;
        Ok(source.resolve(&runtime.model, &runtime.sources)?.1)
    }
    pub fn set<T: 'static>(
        &mut self,
        source: impl SourcePath<M, T>,
        value: T,
    ) -> Result<Commit, SetError<T>> {
        let mut runtime = match self.runtime_mut() {
            Ok(runtime) => runtime,
            Err(error) => return Err(SetError::Rejected { error, value }),
        };
        let mut value = Some(value);
        let previous_epoch = runtime.source_epoch;
        let result = (|| {
            runtime.live()?;
            let field = match catch_unwind(AssertUnwindSafe(|| {
                source
                    .resolve(&runtime.model, &runtime.sources)
                    .map(|(field, _)| field)
            })) {
                Ok(result) => result?,
                Err(_) => {
                    runtime.poison();
                    return Err(Error::OwnerPanicked);
                }
            };
            runtime.operation(Some(field), |model, _| {
                source.modify(model, |old| {
                    // Projector agreement and mutable-value admission have
                    // succeeded. This is the only ownership-transfer point.
                    *old = value.take().expect("source assignment runs once");
                })?;
                Ok(())
            })
        })();
        match result {
            Ok(commit) => Ok(commit),
            Err(error) => Err(if let Some(value) = value {
                SetError::Rejected { error, value }
            } else if runtime.source_epoch != previous_epoch {
                SetError::Committed {
                    error,
                    commit: runtime.commit(),
                }
            } else {
                SetError::OwnerFault { error }
            }),
        }
    }
    /// Position-free semantic activation validates the current logical target.
    pub fn activate(&mut self, target: Target) -> Result<Commit, Error> {
        self.runtime_mut()?.activate(target)
    }

    /// Borrow the latest complete command sheet and its acknowledgement token.
    /// The current token remains valid for OS exposure/surface recovery redraws.
    /// Callback mutation of this window is rejected as Borrowed. Reading commands
    /// neither allocates a CPU framebuffer nor acknowledges presentation.
    pub fn with_scene<R>(
        &self,
        read: impl FnOnce(PreparedScene<'_>, PresentationToken) -> R,
    ) -> Result<R, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let token = runtime.latest_token.ok_or(Error::NoPreparedScene)?;
        Ok(read(runtime.canvas.prepared_scene(), token))
    }
    /// Acknowledge only after the backend's actual submit/present succeeded.
    /// An older coherent candidate remains eligible if a newer preparation failed.
    pub fn presented(&mut self, token: PresentationToken) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.acknowledge(token)
    }
    /// Revoke coordinate authority when a backend loses/detaches its surface.
    /// Commands, diagnostic geometry and current token stay available for redraw;
    /// only a subsequent actual presentation acknowledgement restores authority.
    pub fn presentation_lost(&mut self) -> Result<(), Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.presentation_valid = false;
        Ok(())
    }
    /// Change physical viewport constraints without changing source epoch or
    /// target namespace. Equal size is an idle operation; invalid size is rejected.
    pub fn resize(&mut self, size: [u32; 2]) -> Result<Commit, Error> {
        let scale = self.runtime()?.requested_scale_factor;
        self.resize_scaled(size, scale)
    }
    /// Change physical size or device density. Equal size AND density is idle.
    /// Scale must be finite, positive, and produce finite f32 logical constraints.
    pub fn resize_scaled(&mut self, size: [u32; 2], scale_factor: f32) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        if size == runtime.requested_size && scale_factor == runtime.requested_scale_factor {
            return Ok(runtime.commit());
        }
        Canvas::recording(size[0], size[1], runtime.canvas.color_config())?;
        validate_scale(size, scale_factor)?;
        runtime.requested_size = size;
        runtime.requested_scale_factor = scale_factor;
        runtime.dirty = true;
        runtime.changed_nodes = 0;
        if let Some(node) = runtime.nodes.first() {
            let identity = node.identity();
            runtime.layout_dirty.insert(identity);
        }
        if !runtime.logical_valid || runtime.has_lists() {
            runtime.describe(false)?;
        }
        runtime.present()
    }
    /// The same acknowledged-sheet hit kernel used by click_at and click.
    pub fn hit_target(&self, point: Point) -> Result<Option<Target>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        runtime.current_presentation()?;
        Ok(runtime
            .hit(point)
            .map(|identity| runtime.sites.target(identity)))
    }

    /// Click a live target through acknowledged geometry and the ordinary hit path.
    pub fn click(&mut self, target: Target) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        runtime.current_presentation()?;
        let node = runtime
            .presented
            .iter()
            .find(|node| node.identity == identity)
            .ok_or(Error::StaleTarget)?;
        let point = node
            .transform(runtime.presented_geometry().bases())
            .and_then(|map| {
                map.apply(Point {
                    x: node.placement.size[0] * 0.5,
                    y: node.placement.size[1] * 0.5,
                })
            })
            .filter(|point| node.bounds.contains(*point))
            .or_else(|| {
                (!node.bounds.is_empty()).then_some(Point {
                    x: node.bounds.x + node.bounds.width * 0.5,
                    y: node.bounds.y + node.bounds.height * 0.5,
                })
            })
            .ok_or(Error::NotHittable)?;
        let hit = runtime.hit(point).ok_or(Error::NotHittable)?;
        if hit != identity {
            return Err(Error::NotHittable);
        }
        if runtime.nodes[runtime.resolve_index(target)?].kind() == NodeKind::Input {
            return runtime.select_pointer(target, point, false);
        }
        let previous = runtime.focused;
        runtime.focus(target)?;
        runtime.activate_focused(target, previous)
    }
    pub fn click_at(&mut self, point: Point) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.current_presentation()?;
        if runtime.inspector_picking() {
            let target = runtime.inspector_pick(point).ok_or(Error::NotHittable)?;
            return runtime.inspector_select(target);
        }
        let Some(identity) = runtime.hit(point) else {
            let previous = runtime.focused;
            runtime.focused = None;
            runtime.changed_nodes = 0;
            runtime.publish_focus_change(previous)?;
            return Err(Error::NotHittable);
        };
        let target = runtime.sites.target(identity);
        if runtime.nodes[runtime.resolve_index(target)?].kind() == NodeKind::Input {
            return runtime.select_pointer(target, point, false);
        }
        let previous = runtime.focused;
        runtime.focus(target)?;
        runtime.activate_focused(target, previous)
    }
    /// Insert committed text into the input's current logical selection.
    /// An input without an active selection starts at its document end.
    pub fn type_text(&mut self, target: Target, text: &str) -> Result<Commit, Error> {
        self.runtime_mut()?.replace_input(target, None, text)
    }
    pub fn backspace(&mut self, target: Target) -> Result<Commit, Error> {
        self.runtime_mut()?.backspace_input(target)
    }
    /// Retry a pending presentation, or do zero description/layout/paint work.
    pub fn settle(&mut self) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.changed_nodes = 0;
        if !runtime.logical_valid {
            runtime.describe(false)?;
        }
        runtime.present()
    }
    pub fn with_model<R>(&self, read: impl FnOnce(&M) -> R) -> Result<R, Error> {
        Ok(read(self.root()?))
    }
    /// Ordinary typed source-state borrow. An edit or close while this reference
    /// is live is a compile error, without a runtime borrow guard.
    pub fn root(&self) -> Result<&M, Error> {
        Ok(&self.runtime()?.model)
    }
    pub fn counters(&self) -> Counters {
        self.runtime()
            .expect("window is closed or in an owner turn")
            .counters
    }
    pub fn reset_counters(&mut self) -> Result<(), Error> {
        self.runtime_mut()?.counters = Counters::default();
        Ok(())
    }
    pub fn snapshot(&self) -> Result<Snapshot, Error> {
        self.snapshot_with_targets(false)
    }
    /// Inspect the acknowledged sheet, including targets for current
    /// noninteractive sites. Targets are derived without an address table.
    pub fn inspect(&self) -> Result<Snapshot, Error> {
        self.snapshot_with_targets(true)
    }
    fn snapshot_with_targets(&self, all_targets: bool) -> Result<Snapshot, Error> {
        let runtime = self.runtime()?;
        let mut nodes = Vec::with_capacity(runtime.presented.len());
        let geometry = runtime.presented_geometry();
        for index in 0..runtime.presented.len() {
            let node = &runtime.presented[index];
            let identity = node.identity;
            // A destructor panic may interrupt destructive reconciliation.
            // The old sheet remains diagnostic; current addresses do not.
            let target = if runtime.logical_valid
                && !runtime.poisoned
                && let Some(index) = runtime.by_identity.get(identity)
                && (all_targets
                    || runtime.nodes[index].has_handler()
                    || runtime.nodes[index].kind() == NodeKind::Input)
            {
                Some(runtime.sites.target(identity))
            } else {
                None
            };
            let snapshot = SnapshotNode {
                identity,
                parent: node.parent.index(),
                role: format!("{:?}", node.kind.role()),
                text: node.text.as_deref().map(str::to_owned),
                bounds: [
                    node.bounds.x,
                    node.bounds.y,
                    node.bounds.width,
                    node.bounds.height,
                ],
                transform: node
                    .transform(geometry.bases())
                    .map(|map| [map.a, map.b, map.c, map.d, map.tx, map.ty]),
                target,
            };
            nodes.push(snapshot);
        }
        Ok(Snapshot {
            source_epoch: runtime.source_epoch,
            presentation_epoch: runtime.presentation_epoch,
            presentation_valid: runtime.presentation_valid,
            prepared_epoch: runtime.prepared_epoch(),
            size: runtime.presentation_size,
            requested_size: runtime.requested_size,
            scale_factor: runtime.presentation_scale_factor,
            requested_scale_factor: runtime.requested_scale_factor,
            poisoned: runtime.poisoned,
            nodes,
        })
    }
    /// Current logical property; the complete displayed sheet may lag after a
    /// presentation error. Inspect its epoch before using displayed geometry.
    pub fn property<T, D: crate::property::PropertyDomain>(
        &self,
        target: Target,
        property: Property<T, D>,
    ) -> Result<T, Error> {
        D::dispatch(
            property,
            (self, target),
            |(win, target), property| win.style_property(target, property),
            |(win, target), property| win.geometry_property(target, property),
            |(win, target), property| win.paint_property(target, property),
        )
    }
    pub fn contribution<T, D: crate::property::PropertyDomain>(
        &self,
        target: Target,
        property: Property<T, D>,
    ) -> Result<Contribution<T>, Error> {
        D::dispatch(
            property,
            (self, target),
            |(win, target), property| win.style_contribution(target, property),
            |(win, target), property| win.geometry_contribution(target, property),
            |(win, target), property| win.paint_contribution(target, property),
        )
    }
    pub fn set_property<T: PartialEq, D: crate::property::PropertyDomain>(
        &mut self,
        target: Target,
        property: Property<T, D>,
        contribution: Contribution<T>,
    ) -> Result<Commit, Error> {
        self.runtime_mut()?
            .set_property(target, property, contribution)
    }
    /// Read current logical state through the closed catalog. Displayed geometry
    /// remains qualified by its separately acknowledged presentation epoch.
    pub fn property_value(
        &self,
        target: Target,
        id: crate::property::PropertyId,
    ) -> Result<crate::property::PropertyValue, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let index = runtime.resolve_index(target)?;
        runtime.property_value_at(index, id)
    }
    /// Contribution presence is distinct from equality with a lower/default value.
    pub fn property_contribution(
        &self,
        target: Target,
        id: crate::property::PropertyId,
    ) -> Result<Contribution<crate::property::PropertyValue>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        Ok(runtime.property_contribution_at(identity, id))
    }
    /// Validated catalog contribution. The ID owns destination, validation,
    /// exact authoring equality and impact; mismatched values reject atomically.
    pub fn set_property_value(
        &mut self,
        target: Target,
        id: crate::property::PropertyId,
        contribution: Contribution<crate::property::PropertyValue>,
    ) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        let (index, epoch) = runtime.property_edit_target(target)?;
        runtime.set_property_value_at(index, epoch, id, contribution)
    }
    fn style_property<T>(&self, target: Target, property: Property<T>) -> Result<T, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let index = runtime.resolve_index(target)?;
        Ok(runtime.styles.with(index, |style| property.get(style)))
    }
    fn style_contribution<T>(
        &self,
        target: Target,
        property: Property<T>,
    ) -> Result<Contribution<T>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        Ok(runtime.overrides.get(identity, property))
    }
    pub fn try_button(&self, label: &str) -> Result<Target, Error> {
        self.find(NodeKind::Button, Some(label))
    }
    pub fn find_button(&self, label: &str) -> Result<Target, Error> {
        self.try_button(label)
    }
    pub fn button(&self, label: &str) -> Target {
        self.try_button(label)
            .expect("button was not found in the presented sheet")
    }
    pub fn try_input(&self) -> Result<Target, Error> {
        self.find(NodeKind::Input, None)
    }
    pub fn find_input(&self) -> Result<Target, Error> {
        self.try_input()
    }
    pub fn find_text(&self, text: &str) -> Result<Target, Error> {
        self.find(NodeKind::Text, Some(text))
    }
    pub fn input(&self) -> Target {
        self.try_input()
            .expect("input was not found in the presented sheet")
    }
    fn find(&self, kind: NodeKind, label: Option<&str>) -> Result<Target, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        if !runtime.logical_valid {
            return Err(Error::PresentationStale);
        }
        let identity = runtime
            .presented
            .iter()
            .find(|node| {
                node.kind == kind
                    && label.is_none_or(|text| node.text.as_deref() == Some(text))
                    && runtime.by_identity.contains(node.identity)
            })
            .map(|node| node.identity)
            .ok_or(Error::MissingElement)?;
        Ok(runtime.sites.target(identity))
    }
    /// CPU diagnostic rendering of the latest coherent commands. The first call
    /// after mount/resize allocates the optional image. It never acknowledges
    /// native presentation. Optional image allocation failures return Canvas errors.
    pub fn with_pixels<R>(&mut self, read: impl FnOnce(&[u8], u32, u32) -> R) -> Result<R, Error> {
        let mut runtime = self.runtime_mut()?;
        let (width, height) = (runtime.canvas.width(), runtime.canvas.height());
        Ok(read(runtime.canvas.try_pixels()?, width, height))
    }
    /// Render the latest complete sheet directly into a native software surface.
    /// Words are 0x00RRGGBB; no internal CPU image or extra frame copy is created.
    /// The host must acknowledge the returned token only after its buffer present
    /// succeeds. Rendering here alone cannot restore coordinate authority.
    pub fn render_bgrx(&mut self, destination: &mut [u32]) -> Result<PresentationToken, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        let token = runtime.latest_token.ok_or(Error::NoPreparedScene)?;
        runtime.canvas.render_bgrx(destination)?;
        Ok(token)
    }
    /// Native-only repair from certified intervening surface transitions.
    /// None means unknown contents and requires a complete redraw. Returns the
    /// current P-to-C transition for history only after successful presentation.
    #[cfg(any(feature = "native-core", test))]
    pub(crate) fn render_preserved_bgrx(
        &mut self,
        destination: &mut [u32],
        intervening: Option<DamageRegion>,
    ) -> Result<(PresentationToken, DamageRegion), Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        let token = runtime.latest_token.ok_or(Error::NoPreparedScene)?;
        let damage = runtime
            .prepared
            .as_ref()
            .map_or(DamageRegion::default(), |p| p.damage);
        if let Some(intervening) = intervening.filter(|_| !runtime.automatic_presentation) {
            runtime
                .canvas
                .render_bgrx_region(destination, intervening.union(damage))?;
        } else {
            runtime.canvas.render_bgrx(destination)?;
        }
        Ok((token, damage))
    }
    pub fn scene_digest(&mut self) -> Result<u64, Error> {
        self.with_pixels(|pixels, _, _| {
            pixels.iter().fold(0xcbf29ce484222325, |hash, byte| {
                (hash ^ *byte as u64).wrapping_mul(0x100000001b3)
            })
        })
    }
    pub fn source_json(&self) -> Result<String, Error>
    where
        M: Serialize,
    {
        let runtime = self.runtime()?;
        serde_json::to_string(&runtime.model)
            .map_err(|error| Error::Serialization(error.to_string()))
    }
}

impl<M: View + 'static> Runtime<M> {
    fn live(&self) -> Result<(), Error> {
        if self.poisoned {
            Err(Error::Poisoned)
        } else {
            Ok(())
        }
    }
    fn resolve(&self, target: Target) -> Result<u64, Error> {
        let identity = self.sites.resolve(target).ok_or(Error::StaleTarget)?;
        self.resolve_identity(identity)?;
        Ok(identity)
    }
    /// Return the lookup already required for target admission. The index stays
    /// inside the current owner borrow; it cannot outlive a description rebuild.
    fn resolve_index(&self, target: Target) -> Result<usize, Error> {
        let identity = self.sites.resolve(target).ok_or(Error::StaleTarget)?;
        self.resolve_identity(identity)
    }
    // Namespace has been checked by the two Target wrappers. Identity-only
    // callers keep that known value instead of loading it again from Node.
    fn resolve_identity(&self, identity: u64) -> Result<usize, Error> {
        if !self.logical_valid {
            return Err(Error::StaleTarget);
        }
        let index = self.by_identity.get(identity).ok_or(Error::StaleTarget)?;
        if self.has_lists()
            && self.in_list(index)
            && !self
                .prepared
                .as_ref()
                .map_or(self.presented.as_slice(), |p| p.rows(&self.presented))
                .iter()
                .any(|node| node.identity == identity)
        {
            return Err(Error::StaleTarget);
        }
        Ok(index)
    }
    fn current_presentation(&self) -> Result<(), Error> {
        if self.logical_valid
            && !self.dirty
            && self.presentation_valid
            && self.prepared.is_none()
            && self.source_epoch == self.presentation_epoch
            && self.requested_size == self.presentation_size
            && self.requested_scale_factor == self.presentation_scale_factor
        {
            Ok(())
        } else {
            Err(Error::PresentationStale)
        }
    }
    fn poison(&mut self) {
        if let Some(metadata) = &mut self.metadata {
            metadata.editing = None;
        }
        self.focused = None;
        self.poisoned = true;
        self.logical_valid = false;
        self.prepared = None;
        self.latest_token = None;
    }
    fn describe_inner(
        &mut self,
        mount: bool,
        scroll: &[ScrollRequest],
        readers: &dyn crate::reader::ReaderValues,
        mut property_changed: Option<NonZeroU64>,
    ) -> Result<(), Error> {
        let reuse_identities = self.logical_valid;
        self.counters.descriptions += 1;
        if !mount {
            self.counters.owner_reruns += 1;
        }
        let mut seen = BTreeSet::new();
        let crate::element::Description {
            nodes: mut drafts,
            viewports: viewport_drafts,
            annotations: annotation_drafts,
            focus_indicators: focus_drafts,
            images: image_drafts,
            geometry: geometry_drafts,
            backgrounds: background_drafts,
            style_ports,
            mapped_ports,
            boolean_groups,
        } = inspector::description(
            &self.model,
            self.metadata
                .as_deref()
                .and_then(|m| m.inspector.as_deref()),
            self.requested_size,
            self.requested_scale_factor,
        )
        .flatten_lists(MAX_NODES, readers, |id, style, source, row_height| {
            if !seen.insert(id) {
                return Err(ListError::DuplicateList(id));
            }
            let previous = self
                .viewports
                .get(&ViewportKey::List(id))
                .and_then(ViewportState::list)
                .map(|state| (state.identity, state));
            let style = previous.map_or(style, |(identity, _)| {
                self.overrides.resolve(identity, style)
            });
            let previous = previous.map(|(_, state)| state);
            list::plan(
                previous,
                style,
                source,
                row_height,
                scroll
                    .iter()
                    .find(|request| request.id == id)
                    .map(|request| request.position),
            )
        })?;
        let mut scroll_drafts = Vec::new();
        let list_drafts: Vec<_> = viewport_drafts
            .into_iter()
            .filter_map(|draft| match draft {
                crate::list::ViewportDraft::List(list) => Some(list),
                crate::list::ViewportDraft::Scroll(scroll) => {
                    scroll_drafts.push(scroll);
                    None
                }
            })
            .collect();
        let list_indices: BTreeMap<_, _> = list_drafts
            .iter()
            .map(|list| (list.index, list.id))
            .collect();
        let row_indices: BTreeMap<_, _> = list_drafts
            .iter()
            .flat_map(|list| list.rows.iter().map(move |row| (row.index, (list.id, row))))
            .collect();
        if drafts.len() > MAX_NODES {
            return Err(Error::ResourceLimit);
        }
        self.next_identity
            .checked_add(drafts.len() as u64)
            .ok_or(Error::EpochExhausted)?;
        let (image_resources, image_nodes) = image::describe(image_drafts)?;
        let mut depth = 0usize;
        let mut layout_depth = 0u8;
        let mut handler_count = 0;
        let mut fields = Vec::with_capacity(drafts.len());
        let mut new_counts = vec![0u32; drafts.len() + 1];
        let mut fanout: BTreeMap<FieldId, Fanout> = BTreeMap::new();
        for index in 0..drafts.len() {
            let node = &drafts[index];
            new_counts[node.parent.map_or(0, |parent| parent as usize + 1)] += 1;
            // Flattening admits preorder. Descending visits the next child;
            // a completed branch is unwound through its existing parent links.
            // Each edge is unwound once, without a node-indexed depth column.
            if index != 0 {
                if node.parent == Some((index - 1) as u32) {
                    depth += 1;
                } else {
                    let mut preceding = index - 1;
                    while drafts[preceding].parent != node.parent {
                        preceding = drafts[preceding].parent.unwrap() as usize;
                        depth -= 1;
                    }
                }
            }
            if depth > MAX_LAYOUT_DEPTH {
                return Err(Error::DepthLimit { node: index });
            }
            layout_depth = layout_depth.max(depth as u8);
            drafts[index].components.admit(&self.model, &self.sources)?;
            let node = &drafts[index];
            if let Some(handler) = &node.on_click {
                handler_count += 1;
                handler.admit(&self.model, &self.sources)?;
            }
            let field = match node.text.as_ref().and_then(|text| text.signal()) {
                Some(signal) => self.sources.resolve(&self.model, signal)?,
                None => None,
            };
            if node.kind == NodeKind::Input && field.is_none() {
                return Err(Error::UnregisteredInput { node: index });
            }
            if let Some(field) = field {
                let codec = node
                    .text
                    .as_ref()
                    .and_then(|text| text.codec())
                    .ok_or(Error::Binding(BindError::TypeMismatch(field)))?;
                fanout
                    .entry(field)
                    .or_insert_with(|| Fanout::new(codec))
                    .destinations_mut()
                    .push(Destination::new(index, Port::Visual));
            }
            fields.push(field);
        }
        for &(node, geometry) in &geometry_drafts {
            crate::property::CORNER_RADIUS
                .validate(&geometry.corner_radius)
                .map_err(|error| Error::GeometryProperty { node, error })?;
        }
        let mut color_discovery = styles::ColorDiscovery::default();
        for group in boolean_groups {
            let field = self.sources.resolve(&self.model, group.signal)?;
            if let Some(field) = field {
                fanout
                    .entry(field)
                    .or_insert_with(|| Fanout::new(TextCodec::for_style::<bool>()))
                    .boolean(group, &mut color_discovery)?;
            } else if let Some(member) = group
                .members
                .iter()
                .find(|member| member.sink.property().is_none())
            {
                return Err(Error::UnregisteredControl {
                    node: member.node as usize,
                });
            }
        }
        for draft in mapped_ports {
            let field = self.sources.resolve(&self.model, draft.operand.signal)?;
            if field.is_none() && draft.sink.property().is_none() {
                return Err(Error::UnregisteredControl {
                    node: draft.node as usize,
                });
            }
            if let Some(field) = field {
                fanout
                    .entry(field)
                    .or_insert_with(|| Fanout::new(TextCodec::for_style::<f64>()))
                    .map(draft, &mut color_discovery)?;
            }
        }
        for draft in style_ports {
            let field = self.sources.resolve(&self.model, draft.signal)?;
            if field.is_none() && draft.sink.property().is_none() {
                return Err(Error::UnregisteredControl {
                    node: draft.node as usize,
                });
            }
            if let Some(field) = field {
                use crate::property::PropertyId;
                if !matches!(
                    fanout.get(&field),
                    Some(Fanout::Mapped(_) | Fanout::Boolean(_))
                ) && matches!(
                    draft.sink.property(),
                    Some(PropertyId::Foreground | PropertyId::Background)
                ) {
                    let foreground = draft.sink.property() == Some(PropertyId::Foreground);
                    let style = drafts[draft.node as usize].style;
                    color_discovery.register(field, if foreground { style.fg } else { style.bg });
                }
                let entry = fanout
                    .entry(field)
                    .or_insert_with(|| Fanout::new(draft.signal.codec()));
                match entry.plain_mut() {
                    Fanout::Mapped(mapped) => mapped.codec = draft.signal.codec(),
                    Fanout::General { codec, .. } => *codec = draft.signal.codec(),
                    _ => unreachable!("description has not frozen color fanouts"),
                }
                entry
                    .destinations_mut()
                    .push(Destination::sink(draft.node as usize, draft.sink));
            }
        }
        let mut annotation_fields = Vec::with_capacity(annotation_drafts.len());
        for annotation in &annotation_drafts {
            let mut slots = [None; 2];
            for (slot, text) in [
                annotation.text.name.as_ref(),
                annotation.text.description.as_ref(),
            ]
            .into_iter()
            .enumerate()
            {
                if let Some(text) = text
                    && let Some(signal) = text.signal()
                    && let Some(field) = self.sources.resolve(&self.model, signal)?
                {
                    let codec = text
                        .codec()
                        .ok_or(Error::Binding(BindError::TypeMismatch(field)))?;
                    let entry = fanout.entry(field).or_insert_with(|| Fanout::new(codec));
                    match entry.plain_mut() {
                        Fanout::Mapped(mapped) => mapped.codec = codec,
                        Fanout::General { codec: current, .. } => *current = codec,
                        _ => unreachable!("description has not frozen color fanouts"),
                    }
                    entry.destinations_mut().push(Destination::new(
                        annotation.node as usize,
                        if slot == 0 {
                            Port::Name
                        } else {
                            Port::Description
                        },
                    ));
                    slots[slot] = Some(field);
                }
            }
            annotation_fields.push(slots);
        }
        for (&field, ports) in &mut fanout {
            // Equal outputs do not identify recipes or preserve old Canvas slots.
            self.dirty |= ports.finish_description(field, &drafts, &mut color_discovery);
        }
        // Promotion is lazy and shared by all changed ports of a registered
        // field in this description. Unchanged retained operands keep their Arc.
        let mut promotions: BTreeMap<FieldId, SharedText> = BTreeMap::new();
        color_discovery.capture(&fanout);
        for (field, slot) in color_discovery.fields() {
            let entry = fanout.get_mut(&field).expect("registered color fanout");
            debug_assert!(entry.destinations().iter().all(|d| matches!(
                d.property(),
                Some(
                    crate::property::PropertyId::Foreground
                        | crate::property::PropertyId::Background
                )
            )));
            *entry = Fanout::Color(slot);
        }
        let (handlers, old_handlers) =
            handlers::Handlers::replace(self.handlers.take(), handler_count);
        let old_styles = std::mem::take(&mut self.styles);
        let siblings = siblings::Siblings::new(&self.nodes);
        let mut old = std::mem::take(&mut self.nodes)
            .into_iter()
            .map(Some)
            .collect::<Vec<_>>();
        // Match the old Node vector's callback-drop position during unwind.
        let mut old_handlers = old_handlers;
        let mut keyed_rows = BTreeMap::new();
        let mut keyed_lists = BTreeMap::new();
        let old_list_ids: BTreeMap<_, _> = self
            .viewports
            .iter()
            .filter_map(|(&key, state)| match (key, state) {
                (ViewportKey::List(id), ViewportState::List(state)) => Some((state.identity, id)),
                _ => None,
            })
            .collect();
        for (index, node) in old.iter().enumerate() {
            let node = node.as_ref().unwrap();
            let parent = node
                .parent()
                .index()
                .map(|parent| old[parent].as_ref().unwrap().identity());
            if let Some(row) = self
                .list_rows
                .get(&node.identity())
                .filter(|row| row.visible)
            {
                keyed_rows.insert((parent, row.key, node.kind().site_kind()), index);
            }
            if let Some(&id) = old_list_ids.get(&node.identity()) {
                keyed_lists.insert((parent, id, node.kind().site_kind()), index);
            }
        }
        let old_ids = old
            .iter()
            .map(|node| node.as_ref().unwrap().identity())
            .collect::<Vec<_>>();
        let mut styles = styles::Builder::with_colors(drafts.len(), color_discovery);
        // New captures must drop before remaining old captures on unwind,
        // just as they did when these Node vectors owned routes directly.
        let mut handlers = handlers;
        let mut nodes: Vec<Node> = Vec::with_capacity(drafts.len());
        // Retain no holes or visited-site history. Moving TextSite transfers
        // its text lease and glyph Vec header without cloning either.
        let mut texts =
            Vec::with_capacity(drafts.iter().filter(|draft| draft.text.is_some()).count());
        let mut changed = 0;
        let mut background_cursor = background_drafts.iter().peekable();
        for (index, draft) in drafts.into_iter().enumerate() {
            let parent = draft.parent.map(|parent| parent as usize);
            let disabled =
                draft.disabled || parent.is_some_and(|parent| nodes[parent].content.disabled());
            // Only a boundary can change ownership. Reminting that root also
            // prevents descendant reuse: every match includes parent identity.
            let component_scope = draft.components.scope().unwrap_or(0);
            let ordinal_slot = parent.map_or(0, |parent| parent + 1);
            let ordinal = if index == 0 || parent == Some(index - 1) {
                0
            } else {
                // The preceding subtree ends at the previous sibling. Its
                // retained ordinal gives this sibling's ordinal directly.
                let mut sibling = index - 1;
                while nodes[sibling].parent().index() != parent {
                    sibling = nodes[sibling].parent().index().unwrap();
                }
                nodes[sibling].ordinal() + 1
            };
            let parent_identity = parent.map(|parent| nodes[parent].identity());
            let old_siblings = match parent_identity {
                Some(identity) => self.by_identity.get(identity).map_or(&[][..], |parent| {
                    siblings.children(Parent::new(Some(parent)))
                }),
                None => siblings.children(Parent::new(None)),
            };
            // A shape change invalidates the entire unkeyed run. Equal kinds
            // at shifted ordinals must not silently retarget an old capability.
            let run_survives =
                reuse_identities && old_siblings.len() == new_counts[ordinal_slot] as usize;
            let previous_index = if let Some((_, row)) = row_indices.get(&index) {
                reuse_identities
                    .then(|| keyed_rows.get(&(parent_identity, row.key, draft.kind.site_kind())))
                    .flatten()
                    .copied()
            } else if let Some(&id) = list_indices.get(&index) {
                reuse_identities
                    .then(|| keyed_lists.get(&(parent_identity, id, draft.kind.site_kind())))
                    .flatten()
                    .copied()
            } else {
                run_survives
                    .then(|| old_siblings.get(ordinal as usize))
                    .flatten()
                    .map(|&index| index as usize)
                    .filter(|&index| {
                        old[index]
                            .as_ref()
                            .is_some_and(|node| node.kind().site_kind() == draft.kind.site_kind())
                    })
            };
            let previous = previous_index
                .and_then(|old_index| old[old_index].take())
                .filter(|node| {
                    let retained = node.component_scope == component_scope;
                    if !retained && let Some(slot) = node.handler_slot() {
                        // The former inline route dropped with the rejected
                        // Node here, before any replacement-site processing.
                        drop(old_handlers[slot].take().expect("installed route"));
                    }
                    retained
                });
            let previous_handler = previous.as_ref().and_then(Node::handler_slot);
            let previous_style = if previous.is_some() {
                old_styles.get(previous_index.unwrap())
            } else {
                draft.style
            };
            if previous.is_some()
                && old_styles.binding_fields(previous_index.unwrap())
                    != styles.binding_fields(index)
            {
                // Equal current colors do not make two source relationships
                // interchangeable. Rebind the complete scene before slot edits.
                self.dirty = true;
            }
            let mut node_changed = previous.is_none();
            let next_background = if background_cursor
                .peek()
                .is_some_and(|entry| entry.0 == index)
            {
                Some(background_cursor.next().unwrap().1.key())
            } else {
                None
            };
            let previous_background = self
                .images
                .as_deref()
                .and_then(|r| r.backgrounds.as_deref())
                .and_then(|b| {
                    previous
                        .as_ref()
                        .and_then(|node| b.declared.get(&node.identity()))
                })
                .copied();
            if next_background != previous_background {
                node_changed = true;
                self.dirty = true;
            }

            let mut node = if let Some(node) = previous {
                node
            } else {
                let identity = self.next_identity;
                self.next_identity += 1;
                self.layout_dirty.insert(identity);
                Node {
                    // IDs start at one, never roll back, and admission above
                    // reserves the entire checked nonzero interval.
                    identity: NonZeroU64::new(identity).expect("admitted node identity"),
                    links: links::NodeLinks::new(parent, ordinal, None),
                    content: Content::new(draft.kind, TextSlot::NONE),
                    component_scope,
                }
            };
            let mut site = node.text_slot().take(&mut self.texts);
            let previous_image = node.content.image_use().map(|image| {
                (
                    self.images.as_ref().unwrap().get(image).key(),
                    image.sampling,
                )
            });
            let next_image = image_nodes.get(&index).copied();
            let next_key = next_image.map(|image| {
                (
                    image_resources[image.resource as usize].key(),
                    image.sampling,
                )
            });
            if previous_image != next_key {
                self.layout_dirty.insert(node.identity());
                self.dirty = true;
                node_changed = true;
            }
            if node.kind() != draft.kind
                || node.content.disabled() != disabled
                || node.content.invalid() != draft.invalid
            {
                // State belongs to the next presentation, not the mount identity.
                self.dirty = true;
                node_changed = true;
            }
            let text = draft.text.as_ref().map(|text| text.borrowed_value());
            #[cfg(feature = "accessibility")]
            if node.kind() == NodeKind::Input
                && site
                    .as_ref()
                    .is_some_and(|site| site.field != fields[index])
                && let Some(observer) = &mut self.accessibility
            {
                observer.input_rebound(
                    self.source_epoch,
                    self.complete_epoch,
                    self.next_presentation,
                );
            }
            self.counters.destination_compares += 1;
            if site.as_ref().map(|site| site.value.as_ref()) != text.as_deref() {
                self.rebuild_layout |= site.is_some() != text.is_some();
                site = text.as_deref().map(|text| {
                    let value = if let Some(value) =
                        fields[index].and_then(|field| promotions.get(&field))
                    {
                        value.clone()
                    } else {
                        self.counters.text_promotions += 1;
                        self.counters.text_bytes_copied += text.len() as u64;
                        let value: SharedText = SharedText::from(text);
                        if let Some(field) = fields[index] {
                            promotions.insert(field, value.clone());
                        }
                        value
                    };
                    TextSite {
                        value,
                        field: fields[index],
                        shaped: None,
                    }
                });
                self.layout_dirty.insert(node.identity());
                self.dirty = true;
                node_changed = true;
            }
            let style = self.overrides.resolve(node.identity(), draft.style);
            if !styles::exact_eq(&previous_style, &style) {
                self.dirty = true;
                node_changed = true;
            }
            if layout_changed(previous_style, style) {
                self.layout_dirty.insert(node.identity());
            }
            if previous_style.font_size != style.font_size
                && let Some(site) = &mut site
            {
                site.shaped = None;
            }
            if node.has_handler() != (!disabled && draft.on_click.is_some()) {
                // Eligibility is part of the published hit sheet even when
                // this transparent site's pixels and layout remain equal.
                self.dirty = true;
                node_changed = true;
            }
            let mask = u8::from(matches!(
                self.overrides
                    .get(node.identity(), crate::property::FOREGROUND),
                Contribution::Set(_)
            )) | (u8::from(matches!(
                self.overrides
                    .contribution(node.identity(), crate::property::PropertyId::Background),
                Contribution::Set(_)
            )) << 1);
            styles.declaration(index, draft.style, style, mask);
            // Drop the consumed old route at the same replacement barrier as
            // the former inline field. Removed sites drop with old_handlers.
            if let Some(slot) = previous_handler {
                old_handlers[slot].take().expect("installed route");
            }
            let handler = draft
                .on_click
                .map(|handler| handlers.as_deref_mut().unwrap().push(handler));
            node.links = links::NodeLinks::new(parent, ordinal, handler);
            let text_slot = if let Some(mut site) = site {
                site.field = fields[index];
                let slot = TextSlot(texts.len() as u32);
                texts.push(Some(site));
                slot
            } else {
                TextSlot::NONE
            };
            node.content = if let Some(image) = next_image {
                Content::image(image)
            } else {
                Content::new(draft.kind, text_slot)
            }
            .with_invalid(draft.invalid)
            .with_own_disabled(draft.disabled)
            .with_disabled(disabled);
            if property_changed == Some(node.identity) {
                node_changed = true;
                property_changed = None;
            }
            changed += usize::from(node_changed);
            nodes.push(node);
        }
        image::reconcile(&mut self.images, image_resources);
        changed += old.iter().filter(|node| node.is_some()).count();
        // A previous site can be consumed before its component scope rejects
        // reuse. The still-old identity index locates its original slot: Some
        // was counted as retired above, while None needs the edited old site.
        if let Some(identity) = property_changed {
            changed += usize::from(old[self.by_identity.required(identity.get())].is_none());
        }
        let topology = old_ids.len() != nodes.len()
            || old_ids
                .iter()
                .zip(&nodes)
                .any(|(old, new)| *old != new.identity());
        self.topology_changed |= topology;
        self.dirty |= topology;
        let mut viewports = BTreeMap::new();
        let mut list_rows = BTreeMap::new();
        for draft in list_drafts {
            let identity = nodes[draft.index].identity();
            let changed = self
                .viewports
                .get(&ViewportKey::List(draft.id))
                .and_then(ViewportState::list)
                .is_none_or(|old| old.viewport != draft.plan.viewport);
            self.dirty |= changed;
            for row in draft.rows {
                let identity = nodes[row.index].identity();
                if self
                    .list_rows
                    .get(&identity)
                    .is_none_or(|old| old.y != row.y || old.height != row.height)
                {
                    self.layout_dirty.insert(identity);
                    self.dirty = true;
                }
                list_rows.insert(
                    identity,
                    ListRow {
                        list: draft.id,
                        key: row.key,
                        index: row.item_index,
                        y: row.y,
                        height: row.height,
                        visible: true,
                    },
                );
            }
            viewports.insert(
                ViewportKey::List(draft.id),
                ViewportState::List(ListState {
                    identity,
                    viewport: draft.plan.viewport,
                    anchor: draft.plan.anchor,
                }),
            );
        }
        for draft in scroll_drafts {
            let identity = nodes[draft.index].identity();
            let offset = self
                .viewports
                .get(&ViewportKey::Scroll(identity))
                .and_then(ViewportState::scroll)
                .map_or(crate::ScrollOffset::default(), |state| state.offset);
            if self
                .viewports
                .get(&ViewportKey::Scroll(identity))
                .and_then(ViewportState::scroll)
                .is_none_or(|state| state.axes != draft.axes)
            {
                self.dirty = true;
            }
            viewports.insert(
                ViewportKey::Scroll(identity),
                ViewportState::Scroll(scroll::ScrollState {
                    axes: draft.axes,
                    offset,
                }),
            );
        }
        if !annotation_drafts.is_empty()
            || !focus_drafts.is_empty()
            || !viewports.is_empty()
            || self.metadata.is_some()
        {
            let metadata = self
                .metadata
                .get_or_insert_with(|| Box::new(Metadata::default()));
            let mut base = Vec::with_capacity(
                annotation_drafts
                    .iter()
                    .filter(|a| a.text.name.is_some() || a.text.description.is_some())
                    .count(),
            );
            let focus_changed = metadata.focus_indicators.len() != focus_drafts.len()
                || focus_drafts.iter().any(|&(node, color)| {
                    metadata.focus_indicator(nodes[node].identity()) != Some(color)
                });
            self.dirty |= focus_changed;
            metadata.focus_indicators.clear();
            metadata.focus_indicators.extend(
                focus_drafts
                    .into_iter()
                    .map(|(node, color)| (nodes[node].identity(), color)),
            );
            for (annotation, fields) in annotation_drafts.into_iter().zip(annotation_fields) {
                let identity = nodes[annotation.node as usize].identity();
                let previous = metadata.base(identity);
                let mut values = [None, None];
                for (slot, text) in [annotation.text.name, annotation.text.description]
                    .into_iter()
                    .enumerate()
                {
                    if let Some(text) = text {
                        let value = text.borrowed_value();
                        let old = previous.and_then(|previous| {
                            if slot == 0 {
                                previous.name.as_ref()
                            } else {
                                previous.description.as_ref()
                            }
                        });
                        self.counters.destination_compares += 1;
                        values[slot] =
                            Some(if old.is_some_and(|old| old.as_ref() == value.as_ref()) {
                                old.unwrap().clone()
                            } else {
                                if let Some(field) = fields[slot] {
                                    if let Some(value) = promotions.get(&field) {
                                        value.clone()
                                    } else {
                                        self.counters.text_promotions += 1;
                                        self.counters.text_bytes_copied += value.len() as u64;
                                        let value: SharedText = SharedText::from(value.as_ref());
                                        promotions.insert(field, value.clone());
                                        value
                                    }
                                } else {
                                    self.counters.text_promotions += 1;
                                    self.counters.text_bytes_copied += value.len() as u64;
                                    SharedText::from(value.as_ref())
                                }
                            });
                    }
                }
                let [name, description] = values;
                if name.is_some() || description.is_some() {
                    base.push(Declared {
                        identity,
                        name,
                        description,
                    });
                }
            }
            metadata
                .focus_indicators
                .sort_unstable_by_key(|entry| entry.0);
            base.sort_unstable_by_key(|entry| entry.identity);
            metadata.base = base;
        }
        let by_identity = IdentityIndex::from_ids(nodes.iter().map(Node::identity));
        // Enter the material bank only for declared paint or an existing cold
        // override/resource arm. Plain descriptions never take its stack frame.
        if !background_drafts.is_empty()
            || self
                .images
                .as_ref()
                .is_some_and(|resources| resources.backgrounds.is_some())
        {
            self.dirty |=
                background::reconcile(&mut self.images, &nodes, &by_identity, background_drafts)?;
        }
        self.reconcile_geometry(&nodes, geometry_drafts);
        self.viewports = viewports;
        self.list_rows = list_rows;
        self.nodes = nodes;
        self.handlers = handlers;
        self.layout_depth = layout_depth;
        self.styles = styles.finish();
        // A replacement source bank has no authority over the preceding
        // Canvas slots, even if every effective value and binding is equal.
        // Rebuild the complete commands before admitting another slot patch.
        self.dirty |= matches!(self.styles, styles::Styles::Colors(_));
        self.texts = texts;
        self.fanout = fanout;
        self.by_identity = by_identity;
        self.overrides
            .retain(|identity| self.by_identity.contains(identity));
        if let Some(metadata) = &mut self.metadata {
            metadata
                .overrides
                .retain(|identity, _| self.by_identity.contains(*identity));
            if let Some(geometry) = metadata.geometry.as_mut() {
                geometry.retain(|identity| self.by_identity.contains(identity));
                if geometry.unused() {
                    metadata.geometry = None;
                }
            }
        }
        self.logical_valid = true;
        self.prune_focus();
        self.changed_nodes = changed;
        Ok(())
    }
    fn patch(&mut self, field: FieldId) -> Result<PatchOutcome, Error> {
        if let Some(Fanout::Color(slot)) = self.fanout.get(&field) {
            let slot = *slot;
            self.counters.source_reads += 1;
            let frozen = self.sources.freeze(
                &self.model,
                field,
                TextCodec::for_style::<Color>(),
                crate::source::Needs {
                    text: false,
                    style: true,
                },
            )?;
            let crate::property::PropertyValue::Color(color) = frozen
                .style
                .expect("color source frozen")
                .admit(crate::property::PropertyId::Foreground)?
            else {
                return Err(Error::Binding(BindError::TypeMismatch(field)));
            };
            let eligible =
                !self.dirty && self.complete_epoch.checked_add(1) == Some(self.source_epoch);
            let change = self.styles.update_color(slot, color);
            self.changed_nodes = change.as_ref().map_or(0, |change| change.users as usize);
            if eligible && self.finish_color_slot(change.as_ref())? {
                return Ok(PatchOutcome::Complete);
            }
            self.dirty |= self.changed_nodes != 0;
            return Ok(PatchOutcome::Visual);
        }
        let eligible = !self.dirty && self.complete_epoch.checked_add(1) == Some(self.source_epoch);
        let Some(fanout) = self.fanout.get_mut(&field) else {
            return Ok(PatchOutcome::Visual);
        };
        self.counters.source_reads += 1;
        let frozen = fanout.freeze(
            self.sources.signal(&self.model, field)?.as_any(),
            field,
            &self.styles,
        )?;
        let mut promoted: Option<SharedText> = None;
        let mut semantic = false;
        let mut visual_changed = false;
        let mut disabled_changed = false;
        let mut last_changed = None;
        for (destination, mapped_value, color) in fanout.all_destinations() {
            let selected = match mapped_value {
                Some(crate::style_port::Scalar::ColorSlot(code)) => Some(code),
                _ => None,
            };
            let mapped_value = mapped_value.map(|scalar| self.styles.resolve_scalar(scalar));
            self.counters.destination_compares += 1;
            let index = destination.node();
            let node = &self.nodes[index];
            let identity = node.identity();
            let changed = if let Some(control) = destination.control() {
                let crate::property::PropertyValue::Flag(value) = control.admit(
                    mapped_value.unwrap_or_else(|| frozen.style.expect("admitted bool source")),
                )?
                else {
                    unreachable!("admitted bool sink")
                };
                let before = node.content;
                let after = if control == crate::style_port::Sink::CHECKED {
                    before.with_checked(value)
                } else if control == crate::style_port::Sink::INVALID {
                    before.with_invalid(value)
                } else {
                    before.with_own_disabled(value)
                };
                let changed = before.0 != after.0;
                if changed {
                    self.nodes[index].content = after;
                    self.dirty = true;
                    visual_changed = true;
                    disabled_changed |= control == crate::style_port::Sink::DISABLED;
                }
                changed
            } else if let Some(id) = destination.property() {
                let value = match mapped_value {
                    Some(value) => value.admit(id)?,
                    None => frozen.style.expect("style codec requested").admit(id)?,
                };
                let changed = match id.info().destination {
                    crate::property::PropertyDestination::Style
                    | crate::property::PropertyDestination::Paint => {
                        let before = self.styles.get(index);
                        let after = self.overrides.update_base(identity, before, id, value)?;
                        let changed = !styles::exact_eq(&before, &after);
                        if let Some(code) = selected {
                            self.styles.select_color(
                                index,
                                id,
                                code,
                                matches!(
                                    self.overrides.contribution(identity, id),
                                    Contribution::Set(_)
                                ),
                                self.nodes.len(),
                            );
                        }
                        if changed {
                            if id.info().impact == crate::property::Impact::Layout {
                                self.layout_dirty.insert(identity);
                            }
                            if id == crate::property::PropertyId::FontSize
                                && let Some(text) = node.text_slot().get_mut(&mut self.texts)
                            {
                                text.shaped = None;
                            }
                            if color == 0 && selected.is_none() {
                                self.styles.set(index, after, self.nodes.len());
                            }
                        }
                        changed
                    }
                    crate::property::PropertyDestination::Geometry => {
                        geometry::patch(&mut self.metadata, identity, id, value)?
                    }
                };
                if changed {
                    self.dirty = true;
                    visual_changed = true;
                }
                changed
            } else {
                let value = frozen.text.as_deref().expect("text codec requested");
                let old = match destination.port() {
                    Port::Visual => node
                        .text_slot()
                        .get(&self.texts)
                        .map(|text| text.value.as_ref()),
                    Port::Name | Port::Description => {
                        semantic = true;
                        let base = self
                            .metadata
                            .as_ref()
                            .and_then(|metadata| metadata.base(identity))
                            .expect("annotation destination has a logical column");
                        if destination.port() == Port::Name {
                            base.name.as_deref()
                        } else {
                            base.description.as_deref()
                        }
                    }
                    Port::Style => unreachable!("style destination decoded above"),
                };
                let changed = old != Some(value);
                if changed {
                    if promoted.is_none() {
                        promoted = Some(SharedText::from(value));
                        self.counters.text_promotions += 1;
                        self.counters.text_bytes_copied += value.len() as u64;
                    }
                    match destination.port() {
                        Port::Visual => {
                            let text = node
                                .text_slot()
                                .get_mut(&mut self.texts)
                                .expect("visual fanout has text");
                            text.value = promoted.as_ref().unwrap().clone();
                            text.shaped = None;
                            self.layout_dirty.insert(identity);
                            self.dirty = true;
                            visual_changed = true;
                        }
                        Port::Name | Port::Description => {
                            let base = self
                                .metadata
                                .as_mut()
                                .and_then(|metadata| metadata.base_mut(identity))
                                .expect("annotation destination has a logical column");
                            if destination.port() == Port::Name {
                                base.name = promoted.clone();
                            } else {
                                base.description = promoted.clone();
                            }
                        }
                        Port::Style => unreachable!(),
                    }
                }
                changed
            };
            if changed && last_changed != Some(index) {
                self.changed_nodes += 1;
                last_changed = Some(index);
            }
        }
        let compound = matches!(fanout, Fanout::Boolean(_));
        if let Fanout::Mapped(mapped) = fanout.plain_mut()
            && let ColorPatch::Candidate(change) =
                mapped.publish_colors(&mut self.styles, frozen.style, eligible && !compound)
        {
            // Only color relationships changed; preserve complete geometry
            // through the existing alpha-checked transaction and ACK path.
            self.dirty = false;
            if self.finish_color_slot(change.as_ref())? {
                return Ok(PatchOutcome::Complete);
            }
            self.dirty = visual_changed;
        }
        if disabled_changed {
            for index in 0..self.nodes.len() {
                let node = &self.nodes[index];
                let disabled = node.content.own_disabled()
                    || node
                        .parent()
                        .index()
                        .is_some_and(|parent| self.nodes[parent].content.disabled());
                self.nodes[index].content = node.content.with_disabled(disabled);
            }
            self.prune_focus();
        }
        Ok(if semantic && !visual_changed {
            PatchOutcome::Metadata
        } else {
            PatchOutcome::Visual
        })
    }
    fn commit(&self) -> Commit {
        Commit {
            source_epoch: self.source_epoch,
            presentation_epoch: self.presentation_epoch,
            presentation_valid: self.presentation_valid,
            prepared_epoch: self.prepared_epoch(),
            changed_nodes: self.changed_nodes,
        }
    }
    fn prepared_epoch(&self) -> Option<u64> {
        (self.latest_token.is_some() && (!self.presentation_valid || self.prepared.is_some()))
            .then_some(self.complete_epoch)
    }
    fn present(&mut self) -> Result<Commit, Error> {
        self.reconcile_editing(EditingIntent::None)?;
        self.refresh_inspector(false)?;
        if !self.dirty {
            if self.source_epoch > 0
                && self
                    .metadata
                    .as_deref()
                    .is_some_and(Metadata::has_semantics)
            {
                return Ok(self.publish_metadata(Publish::All));
            }
            // Equal logical output extends the complete scene's coverage, even
            // during surface loss. It cannot advance displayed coverage past an
            // outstanding visual candidate or restore a lost surface's authority.
            self.complete_epoch = self.source_epoch;
            if self.prepared.is_none() && self.presentation_valid {
                self.presentation_epoch = self.source_epoch;
            }
            return Ok(self.commit());
        }
        match catch_unwind(AssertUnwindSafe(|| self.present_inner())) {
            Ok(Ok(())) => Ok(self.commit()),
            Ok(Err(error)) => {
                self.rebuild_layout = true;
                Err(error)
            }
            Err(_) => {
                self.rebuild_layout = true;
                if let Some(text) = &mut self.text {
                    text.system = None;
                }
                self.texts
                    .iter_mut()
                    .flatten()
                    .for_each(|text| text.shaped = None);
                Err(Error::PresentationPanicked)
            }
        }
    }
    fn acknowledge(&mut self, token: PresentationToken) -> Result<Commit, Error> {
        if self.latest_token != Some(token) {
            return Err(Error::StalePresentation);
        }
        let prepared = self.prepared.take();
        let newly_presented = prepared.is_some() || !self.presentation_valid;
        if let Some(prepared) = prepared {
            self.presentation_size = prepared.dimensions();
            if !prepared.keeps_rows() {
                self.presented = prepared.nodes;
                if let Some(text) = &mut self.text {
                    text.acknowledge();
                }
                if let Some(frozen) = self.metadata.as_mut().and_then(|m| m.editing.as_mut()) {
                    frozen.presented = frozen.candidate;
                }
            }
            self.presentation_scale_factor = prepared.scale_factor;
        }
        if let Some(metadata) = &mut self.metadata
            && let Some(sheet) = metadata.candidate.take()
        {
            metadata.presented = sheet;
        }
        if let Some(metadata) = &mut self.metadata
            && let Some(geometry) = &mut metadata.geometry
        {
            geometry.acknowledge();
            if geometry.unused() {
                metadata.geometry = None;
            }
        }
        if let Some(metadata) = &mut self.metadata
            && metadata
                .editing
                .as_ref()
                .is_some_and(|frozen| frozen.unused())
        {
            metadata.editing = None;
        }
        if self.metadata.as_deref().is_some_and(Metadata::unused) {
            self.metadata = None;
        }
        if self
            .text
            .as_deref()
            .is_some_and(text_geometry::TextResources::unused)
        {
            self.text = None;
        }
        // Virtual rows can leave P solely because an ordinary ancestor moved.
        // Revalidate focus after the actual sheet swap, before native focus is
        // observed. Ordinary offscreen descendants remain in P and keep focus.
        self.prune_focus();
        // No-op edits may extend complete coverage, but failed preparations do
        // not. Re-acknowledging after loss therefore never covers a failed S.
        self.presentation_epoch = self.complete_epoch;
        #[cfg(feature = "accessibility")]
        {
            self.presented_sequence = Some(token.sequence);
            let stamp = self.semantic_stamp();
            if let Some(observer) = &mut self.accessibility {
                observer.acknowledge(stamp);
            }
        }
        self.presentation_valid = true;
        self.counters.presentations += u64::from(newly_presented);
        Ok(self.commit())
    }
    fn present_inner(&mut self) -> Result<(), Error> {
        let list_mode = !self.viewports.is_empty();
        let clip_mode = self
            .metadata
            .as_ref()
            .and_then(|m| m.geometry.as_ref())
            .is_some_and(|geometry| geometry.has_logical_clips());
        if list_mode || clip_mode {
            self.present_clipped(list_mode, clip_mode)
        } else {
            self.present_walk(false, false, None)
        }
    }
    // Keep the optional inline clip frontier out of the common walk's frame.
    #[inline(never)]
    fn present_clipped(&mut self, list_mode: bool, clip_mode: bool) -> Result<(), Error> {
        let seed = ClipFrame {
            clip: Rect::default(),
            hit_clip: Rect::default(),
            chain: None,
            membership: 0,
            published: Parent::NONE,
        };
        let mut clips = frontier::Frontier::new(seed, usize::from(self.layout_depth));
        self.present_walk(list_mode, clip_mode, Some(&mut clips))
    }
    #[inline(never)]
    fn present_walk(
        &mut self,
        list_mode: bool,
        clip_mode: bool,
        mut clips: Option<&mut frontier::Frontier<ClipFrame>>,
    ) -> Result<(), Error> {
        let sequence = self.next_presentation;
        let next_sequence = sequence.checked_add(1).ok_or(Error::EpochExhausted)?;
        let token = PresentationToken {
            window: self.sites.namespace(),
            sequence,
        };
        let size = self.requested_size;
        let scale_factor = self.requested_scale_factor;
        // A failed resize must retain the old coherent candidate's commands.
        let mut replacement = if size != [self.canvas.width(), self.canvas.height()] {
            Some(Canvas::recording(
                size[0],
                size[1],
                self.canvas.color_config(),
            )?)
        } else {
            None
        };
        let prepared_size = [
            u16::try_from(size[0]).map_err(|_| gpui_canvas::Error::InvalidDimensions)?,
            u16::try_from(size[1]).map_err(|_| gpui_canvas::Error::InvalidDimensions)?,
        ];
        if !self.texts.is_empty() {
            let text = self.text.get_or_insert_with(Default::default);
            if text.system.is_none() {
                text.system = Some(TextSystem::bundled()?);
            }
        }
        // One immutable parser for every measurement and final line layout in
        // this pass. A single face lease lets the raster cache remain mutable;
        // neither a string nor a glyph increments its reference count.
        let font = self
            .text
            .as_ref()
            .and_then(|text| text.system.as_ref())
            .map(|text| text.font_face().clone());
        let mut text_geometry = Vec::new();
        let mut shaper = font.as_ref().map(|font| font.shaper());
        let active_selection = self.active_selection();
        let selection_snapshot = self.selection_snapshot();
        if self.rebuild_layout || self.topology_changed || self.layout.is_poisoned() {
            self.layout = LayoutTree::new();
            self.layout_nodes.clear();
            for (index, node) in self.nodes.iter().enumerate() {
                let parent = node
                    .parent()
                    .index()
                    .map(|parent| self.layout_nodes[parent]);
                let id = self.layout.insert(
                    parent,
                    gpui_reactivity_core::NodeKind::Element,
                    list::row_style(
                        node.kind(),
                        &self.styles.get(index),
                        node.parent()
                            .index()
                            .map(|index| self.styles.get(index).flow),
                        self.list_rows.get(&node.identity()),
                    ),
                )?;
                if node.text_slot().0 != u32::MAX || node.kind() == NodeKind::Image {
                    self.layout.set_measure(id, Some(measure_marker))?;
                }
                self.layout_nodes.push(id);
            }
            // A fresh arena only appends, in declaration order, with one
            // generation. Keep complete capabilities sorted for measurement
            // routing without rebuilding a map on every layout pass.
            debug_assert!(self.layout_nodes.is_sorted());
        } else {
            // Auto-sized viewports depend on their immediate parent's flow. A
            // retained parent change must refresh the child's grow/basis too,
            // including inspector contributions applied before description.
            for (&key, state) in &self.viewports {
                let identity = state.identity(key);
                let index = self.by_identity.required(identity);
                if self.nodes[index].parent().index().is_some_and(|parent| {
                    self.layout_dirty.contains(&self.nodes[parent].identity())
                }) {
                    self.layout_dirty.insert(identity);
                }
            }
            for identity in &self.layout_dirty {
                let index = self.by_identity.required(*identity);
                let id = self.layout_nodes[index];
                self.layout.set_style(
                    id,
                    list::row_style(
                        self.nodes[index].kind(),
                        &self.styles.get(index),
                        self.nodes[index]
                            .parent()
                            .index()
                            .map(|parent| self.styles.get(parent).flow),
                        self.list_rows.get(identity),
                    ),
                )?;
                self.layout.mark_dirty(id)?;
            }
        }
        let before = self.layout.stats();
        let layout_nodes = &self.layout_nodes;
        let mut failure = None;
        let nodes = &self.nodes;
        let styles = &self.styles;
        let texts = &mut self.texts;
        let images = &self.images;
        let service = &mut shaper;
        let mut measure = |id: NodeId, input: WidthMeasureInput| {
            let index = layout_nodes
                .binary_search(&id)
                .expect("measurement names a node in the current layout arena");
            let node = &nodes[index];
            if let Some(image) = node.content.image_use() {
                return image::measure(images.as_ref().unwrap().get(image), input);
            }
            let service = service
                .as_mut()
                .expect("measured text has an initialized service");
            match node.text_slot().get_mut(texts).unwrap().measure_for(
                service,
                styles.get(index).font_size,
                input,
            ) {
                Ok(shape) => MeasureOutput {
                    size: Size {
                        width: input.known_dimensions.width.unwrap_or(shape.width),
                        height: input.known_dimensions.height.unwrap_or(shape.height),
                    },
                    baselines: cephal::tree::Baselines::from_first(Some(shape.baseline)),
                },
                Err(error) => {
                    failure = Some(error);
                    MeasureOutput::from_size(Size {
                        width: 0.0,
                        height: 0.0,
                    })
                }
            }
        };
        self.layout.compute_with_width_measure(
            self.layout_nodes[0],
            Size {
                width: AvailableSpace::Definite(size[0] as f32 / scale_factor),
                height: AvailableSpace::Definite(size[1] as f32 / scale_factor),
            },
            &mut measure,
        )?;
        let after = self.layout.stats();
        self.counters.layout_runs += after.computes - before.computes;
        self.counters.measure_calls += after.measure_calls - before.measure_calls;
        if let Some(error) = failure {
            return Err(error);
        }
        self.refresh_inspector(true)?;
        let viewport = Rect::new(0.0, 0.0, size[0] as f32, size[1] as f32);
        let mut presented: Vec<Presented> = Vec::with_capacity(self.nodes.len());
        let mut geometry_records = Vec::new();
        let mut spaces = frontier::Frontier::new(
            CoordinateSpace::new(Affine::scale(scale_factor, scale_factor)),
            usize::from(self.layout_depth),
        );
        let root_clip = ClipFrame {
            clip: viewport,
            hit_clip: viewport,
            chain: None,
            membership: 0,
            published: Parent::NONE,
        };
        if let Some(clips) = &mut clips {
            clips.set_root(root_clip);
        }
        let mut ancestor = Parent::NONE;
        let mut published = published::Published::new(if list_mode { self.nodes.len() } else { 0 });
        let mut visible_rows = BTreeSet::new();
        let mut metadata_sheet = self.metadata_sheet();
        let viewport_geometry = if list_mode {
            scroll::geometry(self)?
        } else {
            scroll::ViewportBuild::default()
        };
        #[cfg(feature = "accessibility")]
        let base_stamp = self.semantic_stamp();
        let inspector_display = self.inspector_display();
        #[cfg(feature = "accessibility")]
        let previous_geometry = self
            .metadata
            .as_ref()
            .and_then(|m| m.geometry.as_deref())
            .map_or_else(geometry::GeometryView::empty, geometry::Geometry::view);
        #[cfg(feature = "accessibility")]
        let mut observation = self
            .accessibility
            .as_mut()
            .map(|observer| observer.begin(base_stamp, size));
        self.styles.reset_canvas_slots();
        let inspector_boundary = inspector_display
            .as_ref()
            .map_or(usize::MAX, |captions| captions.panel);
        let mut scene = replacement.as_mut().unwrap_or(&mut self.canvas).stage();
        scene.clear(Color::WHITE);
        self.counters.paint_passes += 1;
        for index in 0..self.nodes.len() {
            if index == inspector_boundary {
                inspector_display.as_ref().unwrap().refresh(
                    &presented,
                    geometry::Bases::new(&geometry_records),
                    &mut self.texts,
                    &mut self.layout,
                    &self.layout_nodes,
                )?;
            }
            let layout = self.layout.layout(self.layout_nodes[index])?;
            while ancestor.index() != self.nodes[index].parent().index() {
                spaces.pop();
                if let Some(clips) = &mut clips {
                    clips.pop();
                }
                ancestor = self.nodes[ancestor.index().unwrap()].parent();
            }
            let inherited = clips.as_deref().map_or(root_clip, frontier::Frontier::top);
            let has_children = self
                .nodes
                .get(index + 1)
                .is_some_and(|child| child.parent().index() == Some(index));
            let style = self.styles.get(index);
            let parent_is_viewport = self.nodes[index].parent().index().is_some_and(|parent| {
                matches!(self.nodes[parent].kind(), NodeKind::List | NodeKind::Scroll)
            });
            let parent_identity = self.nodes[index]
                .parent()
                .index()
                .map(|parent| self.nodes[parent].identity());
            let geometry_style = self
                .metadata
                .as_ref()
                .and_then(|m| m.geometry.as_ref())
                .map_or_else(Default::default, |g| g.get(self.nodes[index].identity()));
            let radius = geometry_style.corner_radius;
            let node = &mut self.nodes[index];
            let parent = node.parent().index().map_or(
                CoordinateSpace::new(Affine::scale(scale_factor, scale_factor)),
                |_| {
                    let base = spaces.top();
                    if let Some(offset) = viewport_geometry.offset(parent_identity.unwrap()) {
                        base.translated(-offset.x, -offset.y)
                    } else {
                        base
                    }
                },
            );
            let space = parent
                .compose(Affine::translation(layout.location.x, layout.location.y))
                .compose(style.transform);
            let [a, b, c, d, tx, ty] = space.coefficients().map(|value| value as f32);
            let candidate = Affine { a, b, c, d, tx, ty };
            let transform =
                (space.is_invertible() && candidate.is_finite() && candidate.is_invertible())
                    .then_some(candidate);
            let rect = Rect::new(0.0, 0.0, layout.size.width, layout.size.height);
            let (mut clip, mut hit_clip, in_list) = if list_mode || clip_mode {
                (
                    inherited.clip,
                    inherited.hit_clip,
                    node.kind() == NodeKind::ListItem || inherited.membership & 1 != 0,
                )
            } else {
                (viewport, viewport, false)
            };
            let in_scroll = node.kind() == NodeKind::Scroll || inherited.membership & 2 != 0;
            if matches!(
                node.kind(),
                NodeKind::List | NodeKind::ListItem | NodeKind::Scroll
            ) {
                (clip, hit_clip) = list::viewport_clip(clip, hit_clip, transform, rect, size)
                    .map_err(|error| {
                        if node.kind() == NodeKind::Scroll
                            && matches!(error, Error::List(ListError::UnsupportedTransform))
                        {
                            Error::Scroll(crate::ScrollError::UnsupportedTransform)
                        } else {
                            error
                        }
                    })?;
            }
            let raw_bounds = transform
                .and_then(|map| CoordinateSpace::new(map).bounds(rect))
                .unwrap_or_default();
            let mut chain = if clip_mode { inherited.chain } else { None };
            let viewport_node = matches!(
                node.kind(),
                NodeKind::List | NodeKind::ListItem | NodeKind::Scroll
            );
            if geometry_style.clip_children || (chain.is_some() && viewport_node) {
                let transform =
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?;
                if chain.is_none() && clip != viewport {
                    chain = Some(scene.create_clip(
                        None,
                        gpui_canvas::ClipShape::Rect(clip),
                        Affine::IDENTITY,
                    )?);
                }
                let shape = if geometry_style.clip_children {
                    gpui_canvas::ClipShape::RoundedRect { rect, radius }
                } else {
                    gpui_canvas::ClipShape::Rect(rect)
                };
                chain = Some(scene.create_clip(chain, shape, transform)?);
            }
            if geometry_style.clip_children {
                hit_clip = hit_clip.intersection(raw_bounds);
            }
            let bounds = if in_list || in_scroll || node.kind() == NodeKind::List || chain.is_some()
            {
                list::clipped_bounds(raw_bounds, hit_clip)
            } else {
                raw_bounds.intersection(viewport)
            };
            let published_parent = if list_mode {
                inherited.published
            } else {
                node.parent()
            };
            let omitted = in_list
                && bounds.is_empty()
                && (!has_children || hit_clip.is_empty())
                && (!in_scroll || hit_clip.is_empty());
            if has_children {
                spaces.push(space);
                if let Some(clips) = &mut clips {
                    clips.push(ClipFrame {
                        clip,
                        hit_clip,
                        chain,
                        published: if omitted {
                            published_parent
                        } else {
                            Parent::new(Some(presented.len()))
                        },
                        membership: if list_mode {
                            u8::from(in_list) | (u8::from(in_scroll) << 1)
                        } else {
                            0
                        },
                    });
                }
                ancestor = Parent::new(Some(index));
            }
            let paint = (!in_scroll && chain.is_none()) || !bounds.is_empty();
            let clip = chain.map_or(gpui_canvas::Clip::Rect(clip), gpui_canvas::Clip::Chain);
            let gradient = self
                .images
                .as_deref()
                .and_then(|r| r.backgrounds.as_deref())
                .and_then(|b| {
                    b.gradient(
                        node.identity(),
                        matches!(
                            self.overrides.contribution(
                                node.identity(),
                                crate::property::PropertyId::Background,
                            ),
                            Contribution::Set(_)
                        ),
                    )
                });
            if paint && let Some(gradient) = gradient {
                scene.fill_gradient(
                    gradient,
                    rect,
                    radius,
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    clip,
                )?;
            } else if paint && style.bg.alpha() > 0.0 {
                let transform =
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?;
                if let Some((value, cache)) = self.styles.shared_paint(index, false) {
                    scene.fill_rounded_rect_shared(rect, radius, transform, clip, value, cache)?;
                } else {
                    scene.fill_rounded_rect(rect, radius, transform, clip, style.bg)?;
                }
            } else if paint && (node.has_handler() || node.kind() == NodeKind::Input) {
                // An invisible input region still obeys the renderer's exact
                // numerical admission domain before becoming a hit target.
                scene.fill_rounded_rect(
                    rect,
                    radius,
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    clip,
                    Color::TRANSPARENT,
                )?;
            }
            let geometry = if let Some(text) = node.text_slot().get_mut(&mut self.texts) {
                let fg = style.fg;
                let service = self
                    .text
                    .as_mut()
                    .and_then(|text| text.system.as_mut())
                    .expect("text initialized before layout");
                let selection = active_selection
                    .filter(|(identity, _)| *identity == node.identity())
                    .map(|(_, selection)| selection);
                let shape = text.shape_for(
                    shaper.as_mut().expect("text initialized before layout"),
                    style.font_size,
                    Some(layout.content_box_width()),
                )?;
                let origin = Point {
                    x: layout.padding.left,
                    y: layout.padding.top,
                };
                let geometry = (
                    origin,
                    shape
                        .retain_geometry()
                        .expect("interactive layout has geometry"),
                );
                if paint {
                    let transform =
                        transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?;
                    if let Some(selection) = selection {
                        let mut failure = None;
                        if !shape.selection_rects(selection, |bounds, _| {
                            if failure.is_none() {
                                failure = scene
                                    .fill_rect(
                                        Rect::new(
                                            origin.x + bounds.x,
                                            origin.y + bounds.y,
                                            bounds.width,
                                            bounds.height,
                                        ),
                                        transform,
                                        clip,
                                        Color::rgba(70, 130, 240, 96),
                                    )
                                    .err();
                            }
                        }) {
                            return Err(Error::InvalidSelection);
                        }
                        if let Some(error) = failure {
                            return Err(error.into());
                        }
                    }
                    if let Some((value, cache)) = self.styles.shared_paint(index, true) {
                        scene.draw_text_scaled_shared(
                            service,
                            shape,
                            origin,
                            transform,
                            clip,
                            value,
                            cache,
                            scale_factor,
                        )?;
                    } else {
                        scene.draw_text_scaled(
                            service,
                            shape,
                            origin,
                            transform,
                            clip,
                            fg,
                            scale_factor,
                        )?;
                    }
                    if let Some(selection) = selection
                        && selection.anchor.offset == selection.focus.offset
                        && self.focused.and_then(|target| self.sites.resolve(target))
                            == Some(node.identity())
                    {
                        let bounds = shape
                            .caret_bounds(selection.focus)
                            .ok_or(Error::InvalidSelection)?;
                        let rect = Rect::new(
                            origin.x + bounds.x,
                            origin.y + bounds.y,
                            bounds.width,
                            bounds.height,
                        );
                        if let Some((value, cache)) = self.styles.shared_paint(index, true) {
                            scene.fill_rounded_rect_shared(
                                rect, 0., transform, clip, value, cache,
                            )?;
                        } else {
                            scene.fill_rect(rect, transform, clip, fg)?;
                        }
                    }
                }
                Some(geometry)
            } else {
                None
            };
            if paint
                && self.focused.and_then(|target| self.sites.resolve(target))
                    == Some(node.identity())
                && let Some(color) = self
                    .metadata
                    .as_deref()
                    .and_then(|m| m.focus_indicator(node.identity()))
            {
                let inset = radius.max(2.0).min(rect.width * 0.25);
                let width = (rect.width - inset * 2.0).max(0.0);
                let height = 2.0_f32.min(rect.height);
                scene.fill_rect(
                    Rect::new(rect.x + inset, rect.y + rect.height - height, width, height),
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    clip,
                    color,
                )?;
            }
            if paint && let Some(image) = node.content.image_use() {
                let resource = self.images.as_ref().unwrap().get(image);
                scene.draw_image_with(
                    resource,
                    Rect::new(
                        layout.content_box_x(),
                        layout.content_box_y(),
                        layout.content_box_width(),
                        layout.content_box_height(),
                    ),
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    clip,
                    gpui_canvas::ImageOptions {
                        sampling: image.sampling,
                        corner_radius: radius,
                    },
                )?;
            }
            if omitted {
                published.record(index, presented.len(), false);
                continue;
            }
            if node.kind() == NodeKind::ListItem {
                visible_rows.insert(node.identity());
            }
            if list_mode {
                published.record(index, presented.len(), true);
            }
            // Empty bounds can never pass sheet_hit, including wheel routing.
            // Keep the existing byte as the common-path candidate test; loading
            // and decoding the parent word is needed only to skip a cold run.
            let hittable = !bounds.is_empty()
                && (node.text_slot().0 != u32::MAX
                    || style.bg.alpha() > 0.0
                    || gradient.is_some_and(|g| g.view().has_visible_stop())
                    || node.has_handler()
                    || matches!(node.kind(), NodeKind::Input | NodeKind::Image));
            let link = PresentedLink::new(
                published_parent,
                !hittable,
                presented.last().map(|node: &Presented| node.parent),
            );
            if let Some((origin, map)) = geometry {
                text_geometry.push(text_geometry::Entry {
                    row: presented.len() as u32,
                    origin,
                    map,
                });
            }
            let basis = geometry::MapBasis::record(
                transform,
                published_parent.index().map(|index| presented[index].basis),
                &mut geometry_records,
            );
            presented.push(Presented {
                identity: node.identity(),
                parent: link,
                kind: node.kind(),
                text: node
                    .text_slot()
                    .get(&self.texts)
                    .map(|text| text.value.clone()),
                placement: geometry::Placement::new([rect.width, rect.height], transform),
                basis,
                bounds,
                hittable,
                state: u8::from(node.content.disabled()) | (u8::from(node.content.invalid()) << 1),
                actions: if node.content.disabled() {
                    Actions::default()
                } else {
                    Actions::for_node(node.kind(), node.has_handler())
                        .scroll_into_view(inherited.membership != 0 || parent_is_viewport)
                },
            });
            #[cfg(feature = "accessibility")]
            if let Some(observation) = &mut observation {
                let index = presented.len() - 1;
                observation.compare(
                    index,
                    accessibility::ComparedRows {
                        previous: self.presented.get(index).map(|row| accessibility::RowView {
                            row,
                            bases: previous_geometry.bases(),
                            shape: previous_geometry.style(row.identity),
                        }),
                        next: accessibility::RowView {
                            row: &presented[index],
                            bases: geometry::Bases::new(&geometry_records),
                            shape: geometry_style,
                        },
                    },
                    (self.metadata.as_deref(), selection_snapshot),
                    (
                        self.text.as_ref().and_then(|text| text.entry(index)),
                        text_geometry
                            .last()
                            .filter(|entry| entry.row as usize == index),
                    ),
                    viewport_geometry.info(
                        node.identity(),
                        [f64::from(rect.width), f64::from(rect.height)],
                    ),
                    self.list_rows.get(&node.identity()),
                );
            }
            if let Some(sheet) = &mut metadata_sheet
                && let Some(metadata) = &self.metadata
            {
                sheet.capture(
                    metadata,
                    node.identity(),
                    self.list_rows.get(&node.identity()),
                );
            }
        }
        // Everything fallible has finished. This transfers commands; native
        // recording retains no CPU image, while same-size headless updates reuse
        // the selected output allocation. No model borrow is published.
        if let Some(sheet) = &mut metadata_sheet {
            sheet.sort();
        }
        #[cfg(feature = "accessibility")]
        if let Some(observation) = observation {
            observation.finish(
                accessibility::Stamp {
                    sequence: Some(sequence),
                    epoch: self.source_epoch,
                    size,
                },
                self.presented.len(),
                presented.len(),
            );
        }
        let logical_indices = &self.by_identity;
        let geometry_sheet = self
            .metadata
            .as_ref()
            .and_then(|m| m.geometry.as_ref())
            .map(|geometry| {
                geometry.freeze(std::mem::take(&mut geometry_records), |identity| {
                    !list_mode
                        || logical_indices
                            .get(identity)
                            .and_then(|index| published.get(index))
                            .and_then(|index| presented.get(index))
                            .is_some_and(|node| node.identity == identity)
                })
            })
            .or_else(|| (!geometry_records.is_empty()).then_some(geometry_records));
        let damage = if self.automatic_presentation {
            // Automatic headless acknowledgement retains no external surface
            // to repair. Do not compare commands for an unused capability.
            scene.commit();
            DamageRegion::default()
        } else {
            scene.commit_with_damage().union(
                self.prepared
                    .as_ref()
                    .map_or(DamageRegion::default(), |prepared| prepared.damage),
            )
        };
        for (&key, state) in &mut self.viewports {
            if let (ViewportKey::Scroll(identity), ViewportState::Scroll(state)) = (key, state)
                && let Some(offset) = viewport_geometry.offset(identity)
            {
                state.offset = offset;
            }
        }
        for (&identity, row) in &mut self.list_rows {
            row.visible = visible_rows.contains(&identity);
        }
        if let Some(canvas) = replacement {
            self.canvas = canvas;
        }
        if let Some(mut sheet) = metadata_sheet
            && let Some(metadata) = &mut self.metadata
        {
            // Reuse the geometry allocation as the immutable P column. Virtual
            // row clipping can omit a declared viewport; emission rank and the
            // final identity match certify membership in this candidate.
            sheet.viewports = viewport_geometry.freeze(|identity| {
                let index = self.by_identity.required(identity);
                published
                    .get(index)
                    .filter(|&index| presented[index].identity == identity)
            });
            metadata.candidate = Some(sheet);
        }
        if let Some(column) = geometry_sheet {
            self.metadata
                .get_or_insert_with(Default::default)
                .geometry
                .get_or_insert_with(Default::default)
                .prepare(column);
        }
        self.styles.clear_slot_transition();
        if let Some(editing) = self.metadata.as_mut().and_then(|m| m.editing.as_mut()) {
            editing.candidate = selection_snapshot;
        }
        if let Some(text) = &mut self.text {
            text.candidate = Some(text_geometry);
        }
        self.prepared = Some(Prepared {
            size: prepared_size,
            scale_factor,
            nodes: presented,
            damage,
        });
        // Virtual coordinate/target admission already consults this completed
        // candidate. Keep interaction focus at the same revocation boundary.
        self.prune_focus();
        self.latest_token = Some(token);
        self.complete_epoch = self.source_epoch;
        self.next_presentation = next_sequence;
        if self.texts.is_empty()
            && let Some(text) = &mut self.text
        {
            text.system = None;
        }
        self.dirty = false;
        self.rebuild_layout = false;
        self.topology_changed = false;
        self.layout_dirty.clear();
        if self.automatic_presentation {
            self.acknowledge(token)?;
        }
        Ok(())
    }
    // Keep the P hit boundary out of ordinary callers; its borrowed view is local.
    #[inline(never)]
    fn hit(&self, point: Point) -> Option<u64> {
        self.hit_in_sheet(self.presented_hit_sheet(), point)
    }
    #[inline(always)]
    fn hit_in_sheet(&self, sheet: query::HitSheet<'_>, point: Point) -> Option<u64> {
        if !sheet.contains_window(point) {
            return None;
        }
        let mut cursor = Some(sheet.hit(point)?);
        while let Some(index) = cursor {
            let node = &sheet.nodes[index];
            if let Some(logical) = self.by_identity.get(node.identity)
                && !self.nodes[logical].content.disabled()
                && (self.nodes[logical].has_handler() || node.kind == NodeKind::Input)
            {
                return Some(node.identity);
            }
            cursor = node.parent.index();
        }
        None
    }
}

fn validate_scale(size: [u32; 2], scale_factor: f32) -> Result<(), Error> {
    if !scale_factor.is_finite()
        || scale_factor <= 0.0
        || size
            .into_iter()
            .any(|side| !(side as f32 / scale_factor).is_finite())
    {
        Err(Error::InvalidScale)
    } else {
        Ok(())
    }
}

fn measure_marker(_: MeasureInput) -> MeasureOutput {
    panic!("measured content requires its borrowed service")
}
fn layout_changed(a: Style, b: Style) -> bool {
    a.width != b.width
        || a.height != b.height
        || a.gap != b.gap
        || a.padding != b.padding
        || a.font_size != b.font_size
        || a.flow != b.flow
        || a.align != b.align
        || a.justify != b.justify
        || a.wrap != b.wrap
}
fn layout_style(style: &Style) -> cephal::Style {
    use cephal::style::{
        AlignItems, Dimension, Display, FlexDirection, FlexWrap, JustifyContent, LengthPercentage,
    };
    fn dimension(length: Length) -> Dimension {
        match length {
            Length::Auto => Dimension::AUTO,
            Length::Points(value) => Dimension::length(value),
            Length::Percent(value) => Dimension::percent(value / 100.0),
        }
    }
    cephal::Style {
        display: Display::Flex,
        size: Size {
            width: dimension(style.width),
            height: dimension(style.height),
        },
        padding: cephal::Rect::splat(LengthPercentage::length(style.padding)),
        gap: Size {
            width: LengthPercentage::length(style.gap),
            height: LengthPercentage::length(style.gap),
        },
        flex_direction: match style.flow {
            Flow::Row => FlexDirection::Row,
            Flow::Column => FlexDirection::Column,
        },
        flex_shrink: 0.0,
        align_items: Some(match style.align {
            crate::Align::Start => AlignItems::FLEX_START,
            crate::Align::End => AlignItems::FLEX_END,
            crate::Align::Center => AlignItems::CENTER,
            crate::Align::Stretch => AlignItems::STRETCH,
            crate::Align::Baseline => AlignItems::BASELINE,
        }),
        justify_content: Some(match style.justify {
            crate::Justify::Start => JustifyContent::FLEX_START,
            crate::Justify::End => JustifyContent::FLEX_END,
            crate::Justify::Center => JustifyContent::CENTER,
            crate::Justify::SpaceBetween => JustifyContent::SPACE_BETWEEN,
            crate::Justify::SpaceAround => JustifyContent::SPACE_AROUND,
            crate::Justify::SpaceEvenly => JustifyContent::SPACE_EVENLY,
        }),
        flex_wrap: if style.wrap {
            FlexWrap::Wrap
        } else {
            FlexWrap::NoWrap
        },
        ..cephal::Style::DEFAULT
    }
}

impl<M> Runtime<M> {
    fn property_value_at(
        &self,
        index: usize,
        id: crate::property::PropertyId,
    ) -> Result<crate::property::PropertyValue, Error> {
        Ok(match id.info().destination {
            crate::property::PropertyDestination::Style => {
                self.styles.with(index, |style| id.value(style))?
            }
            crate::property::PropertyDestination::Paint => {
                crate::property::PropertyValue::Brush(self.background(index))
            }
            crate::property::PropertyDestination::Geometry => id.value(
                &self
                    .metadata
                    .as_ref()
                    .and_then(|m| m.geometry.as_ref())
                    .map_or_else(Default::default, |g| g.get(self.nodes[index].identity())),
            )?,
        })
    }
    fn property_contribution_at(
        &self,
        identity: u64,
        id: crate::property::PropertyId,
    ) -> Contribution<crate::property::PropertyValue> {
        match id.info().destination {
            crate::property::PropertyDestination::Style => {
                self.overrides.contribution(identity, id)
            }
            crate::property::PropertyDestination::Paint => self.background_contribution(identity),
            crate::property::PropertyDestination::Geometry => self
                .metadata
                .as_ref()
                .and_then(|m| m.geometry.as_ref())
                .map_or(Contribution::Inherit, |g| g.contribution(identity, id)),
        }
    }
}
impl<M: View + 'static, L: LaneSet<M>> RuntimeMut<'_, M, L> {
    fn property_edit_target(&self, target: Target) -> Result<(usize, u64), Error> {
        self.live()?;
        let index = self.resolve_index(target)?;
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        Ok((index, epoch))
    }
    fn set_property<T: PartialEq, D: crate::property::PropertyDomain>(
        &mut self,
        target: Target,
        property: Property<T, D>,
        contribution: Contribution<T>,
    ) -> Result<Commit, Error> {
        let (index, epoch) = self.property_edit_target(target)?;
        let contribution = match contribution {
            Contribution::Inherit => Contribution::Inherit,
            Contribution::Set(value) => Contribution::Set(property.erase(value)?),
        };
        self.set_property_value_at(index, epoch, property.id(), contribution)
    }
    fn set_property_value_at(
        &mut self,
        index: usize,
        epoch: u64,
        id: crate::property::PropertyId,
        contribution: Contribution<crate::property::PropertyValue>,
    ) -> Result<Commit, Error> {
        let changed = self.apply_property_value_at(index, id, contribution)?;
        self.source_epoch = epoch;
        self.counters.source_operations += 1;
        if id.info().destination == crate::property::PropertyDestination::Style && self.has_lists()
        {
            self.describe_with_changed(false, &[], changed)?;
        }
        self.present()
    }
    // Shared logical mutation, without source admission or presentation. A
    // property action combines this with its ordinary owner result method
    // before the one source reconciliation/preparation barrier.
    fn apply_property_value_at(
        &mut self,
        index: usize,
        id: crate::property::PropertyId,
        contribution: Contribution<crate::property::PropertyValue>,
    ) -> Result<Option<NonZeroU64>, Error> {
        use crate::property::PropertyDestination;
        if let Contribution::Set(value) = contribution {
            id.validate_erased(value)?;
        }
        let changed = match id.info().destination {
            PropertyDestination::Style => self.set_style_value(index, id, contribution)?,
            PropertyDestination::Geometry => self.set_geometry_value(index, id, contribution)?,
            PropertyDestination::Paint => self.set_background_value(index, contribution)?,
        };
        Ok(changed.then_some(self.nodes[index].identity))
    }
    fn set_style_value(
        &mut self,
        index: usize,
        id: crate::property::PropertyId,
        contribution: Contribution<crate::property::PropertyValue>,
    ) -> Result<bool, Error> {
        let runtime = self;
        let identity = runtime.nodes[index].identity();
        let before = runtime.styles.get(index);
        if let Some(colors) = runtime.styles.declared_colors(index) {
            runtime.overrides.refresh_color_base(identity, colors);
        }
        let explicit = matches!(&contribution, Contribution::Set(_));
        let after = runtime
            .overrides
            .set_value(identity, before, id, contribution)?;
        let count = runtime.nodes.len();
        let relationship_changed = runtime
            .styles
            .color_contribution(index, id, after, explicit, count);
        // Equal Set/Inherit still changes which immutable C paint row this
        // node follows. Rebind C before a later shared-source write can occur.
        runtime.dirty |= relationship_changed;
        let changed = !styles::exact_eq(&before, &after);
        runtime.changed_nodes = usize::from(changed);
        if changed {
            if layout_changed(before, after) {
                runtime.layout_dirty.insert(identity);
            }
            if before.font_size != after.font_size {
                let slot = runtime.nodes[index].text_slot();
                if let Some(text) = slot.get_mut(&mut runtime.texts) {
                    text.shaped = None;
                }
            }
            let count = runtime.nodes.len();
            runtime.styles.set(index, after, count);
            runtime.dirty = true;
        }
        Ok(changed)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{div, text};

    #[test]
    fn headless_acknowledgement_defers_pixels_and_diagnostics_follow_edits_and_resize() {
        struct Block(Color);
        impl View for Block {
            fn view(&self) -> crate::El<'_> {
                div().size(32).bg(self.0)
            }
        }
        let mut win = Win::with_size(Block(Color::rgb(255, 0, 0)), 8, 8).unwrap();
        assert!(win.snapshot().unwrap().presentation_valid);
        assert_eq!(win.runtime().unwrap().canvas.output_bytes(), 0);
        assert_eq!(win.runtime().unwrap().canvas.stats().render_count, 0);
        let before = win.snapshot().unwrap().presentation_epoch;
        win.with_pixels(|pixels, width, height| {
            assert_eq!([width, height], [8, 8]);
            assert_eq!(pixels.len(), 8 * 8 * 4);
            assert!(
                pixels
                    .as_chunks::<4>()
                    .0
                    .iter()
                    .all(|p| *p == [255, 0, 0, 255])
            );
        })
        .unwrap();
        assert_eq!(win.snapshot().unwrap().presentation_epoch, before);

        win.update(|block| block.0 = Color::rgb(0, 0, 255)).unwrap();
        let snapshot = win.snapshot().unwrap();
        assert_eq!(snapshot.source_epoch, snapshot.presentation_epoch);
        assert_eq!(win.runtime().unwrap().canvas.stats().render_count, 1);
        win.with_pixels(|pixels, _, _| {
            assert!(
                pixels
                    .as_chunks::<4>()
                    .0
                    .iter()
                    .all(|p| *p == [0, 0, 255, 255])
            );
        })
        .unwrap();
        win.resize([16, 8]).unwrap();
        assert!(win.snapshot().unwrap().presentation_valid);
        assert_eq!(win.runtime().unwrap().canvas.output_bytes(), 0);
        assert_eq!(win.runtime().unwrap().canvas.stats().render_count, 0);
        win.with_pixels(|pixels, width, height| {
            assert_eq!([width, height], [16, 8]);
            assert_eq!(pixels.len(), 16 * 8 * 4);
            assert!(
                pixels
                    .as_chunks::<4>()
                    .0
                    .iter()
                    .all(|p| *p == [0, 0, 255, 255])
            );
        })
        .unwrap();
    }

    #[test]
    fn native_recording_and_scene_acknowledgements_never_allocate_cpu_pixels() {
        struct Rectangle;
        impl View for Rectangle {
            fn view(&self) -> crate::El<'_> {
                div().size(8).bg(Color::BLACK)
            }
        }
        let mut win = Win::recording(
            Rectangle,
            WindowOptions {
                size: [32, 24],
                ..Default::default()
            },
        )
        .unwrap();
        assert_eq!(win.runtime().unwrap().canvas.output_bytes(), 0);
        assert_eq!(win.runtime().unwrap().canvas.stats().render_count, 0);
        let token = win
            .with_scene(|scene, token| {
                assert_eq!(scene.draws().count(), 1);
                token
            })
            .unwrap();
        win.presented(token).unwrap();
        win.resize([40, 30]).unwrap();
        assert_eq!(win.runtime().unwrap().canvas.output_bytes(), 0);
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        assert_eq!(win.runtime().unwrap().canvas.output_bytes(), 0);
        assert_eq!(win.runtime().unwrap().canvas.stats().render_count, 0);
        assert!(win.runtime().unwrap().text.is_none());
    }
    #[test]
    fn software_surface_rendering_keeps_the_native_runtime_free_of_cpu_image_storage() {
        struct Rectangle;
        impl View for Rectangle {
            fn view(&self) -> crate::El<'_> {
                div().size(8).bg(Color::BLACK)
            }
        }
        let mut win = Win::recording(
            Rectangle,
            WindowOptions {
                size: [8, 8],
                ..Default::default()
            },
        )
        .unwrap();
        let mut destination = vec![0xffffffff; 64];
        let token = win.render_bgrx(&mut destination).unwrap();
        assert!(destination.iter().all(|word| *word == 0));
        assert_eq!(win.runtime().unwrap().canvas.output_bytes(), 0);
        assert_eq!(win.runtime().unwrap().canvas.stats().render_count, 1);
        assert!(!win.snapshot().unwrap().presentation_valid);
        win.presented(token).unwrap();
        assert!(win.snapshot().unwrap().presentation_valid);
    }

    #[test]
    fn preserved_surface_repairs_coalesced_candidates_and_keeps_failed_edits_out() {
        struct Patch {
            x: f32,
            color: Color,
            broken: bool,
        }
        impl View for Patch {
            fn view(&self) -> crate::El<'_> {
                div()
                    .w(80)
                    .h(48)
                    .bg(Color::WHITE)
                    .child(div().size(8).bg(self.color).transform(if self.broken {
                        Affine::scale(f32::MAX, f32::MAX)
                    } else {
                        Affine::translation(self.x, 3.0)
                    }))
            }
        }
        let mut win = Win::recording(
            Patch {
                x: 2.0,
                color: Color::BLACK,
                broken: false,
            },
            WindowOptions {
                size: [80, 48],
                ..Default::default()
            },
        )
        .unwrap();
        let mut output = vec![0xdeadbeef; 80 * 48];
        let initial = win.render_preserved_bgrx(&mut output, None).unwrap().0;
        win.presented(initial).unwrap();
        win.update(|model| model.x = 20.0).unwrap();
        // A second successful C supersedes the first before either is shown.
        win.update(|model| {
            model.x = 40.0;
            model.color = Color::rgb(220, 20, 30);
        })
        .unwrap();
        let coherent = win.with_scene(|_, token| token).unwrap();
        assert!(win.update(|model| model.broken = true).is_err());
        assert_eq!(win.with_scene(|_, token| token).unwrap(), coherent);
        let mut expected = vec![0; output.len()];
        win.render_bgrx(&mut expected).unwrap();
        let full_work = win.runtime().unwrap().canvas.stats().full_rect_tiles;
        assert_eq!(
            win.render_preserved_bgrx(&mut output, Some(DamageRegion::default()))
                .unwrap()
                .0,
            coherent
        );
        assert_eq!(output, expected);
        assert!(win.runtime().unwrap().canvas.stats().full_rect_tiles < full_work);
        assert_eq!(win.runtime().unwrap().canvas.output_bytes(), 0);
        let commit = win.presented(coherent).unwrap();
        assert!(commit.source_epoch > commit.presentation_epoch);
        // Re-exposing a preserved image needs submission but no rerasterization.
        let renders = win.runtime().unwrap().canvas.stats().render_count;
        win.render_preserved_bgrx(&mut output, Some(DamageRegion::default()))
            .unwrap();
        assert_eq!(win.runtime().unwrap().canvas.stats().render_count, renders);
        // Undefined and older images are never trusted without age history.
        for age in [0, 2, 255] {
            output.fill(0xdeadbeef);
            win.render_preserved_bgrx(&mut output, SurfaceDamage::default().since(age))
                .unwrap();
            assert_eq!(output, expected);
        }
        win.update(|model| {
            model.broken = false;
            model.x = 8.0;
        })
        .unwrap();
        win.render_bgrx(&mut expected).unwrap();
        win.render_preserved_bgrx(&mut output, Some(DamageRegion::default()))
            .unwrap();
        assert_eq!(output, expected);
    }

    #[test]
    fn surface_damage_repairs_aged_buffers_and_falls_back_when_history_expires() {
        struct Patch(f32);
        impl View for Patch {
            fn view(&self) -> crate::El<'_> {
                div().size(80).bg(Color::WHITE).child(
                    div()
                        .size(6)
                        .bg(Color::BLACK)
                        .transform(Affine::translation(self.0, 2.0)),
                )
            }
        }
        assert_eq!(std::mem::size_of::<SurfaceDamage>(), 26);
        let mut win = Win::recording(
            Patch(0.0),
            WindowOptions {
                size: [80, 80],
                ..Default::default()
            },
        )
        .unwrap();
        // Five independent swapchain images exercise both retained history and
        // expired ages. Their pixels exist only in this reference oracle.
        let mut buffers = (0..5)
            .map(|_| (vec![0xdeadbeef; 80 * 80], None))
            .collect::<Vec<_>>();
        let mut history = SurfaceDamage::default();
        let mut expected = vec![0; 80 * 80];
        let mut repaired_old = false;
        let mut expired = false;
        for frame in 0u8..64 {
            win.update(|model| model.0 = f32::from(frame % 60)).unwrap();
            if frame.is_multiple_of(7) {
                // A never-presented C must contribute its old support too.
                win.update(|model| model.0 += 7.0).unwrap();
            }
            if frame == 23 {
                win.presentation_lost().unwrap();
            }
            win.render_bgrx(&mut expected).unwrap();
            let index = (usize::from(frame) * 7 + usize::from(frame / 9)) % 5;
            let (buffer, last_frame) = &mut buffers[index];
            let age = last_frame.map_or(0, |last| frame - last);
            let intervening = history.since(age);
            repaired_old |= age > 1 && intervening.is_some();
            expired |= age > 4 && intervening.is_none();
            let (token, damage) = win.render_preserved_bgrx(buffer, intervening).unwrap();
            assert_eq!(*buffer, expected, "frame {frame}, buffer age {age}");
            win.presented(token).unwrap();
            history.presented(damage);
            *last_frame = Some(frame);
        }
        assert!(repaired_old && expired);
        // A new surface/size starts a new history; past deltas grant no trust.
        history = SurfaceDamage::default();
        assert!(history.since(0).is_none());
        assert!(history.since(2).is_none());
        assert!(history.since(255).is_none());
        assert!(history.since(1).is_none());
        assert_eq!(win.runtime().unwrap().canvas.output_bytes(), 0);
    }

    #[test]
    fn rectangle_windows_do_not_initialize_font_services() {
        struct Rectangle;
        impl View for Rectangle {
            fn view(&self) -> crate::El<'_> {
                div().size(8).bg(Color::BLACK)
            }
        }
        let win = Win::with_size(Rectangle, 8, 8).unwrap();
        assert!(win.runtime().unwrap().text.is_none());
        assert_eq!(win.counters().measure_calls, 0);
    }

    #[test]
    fn an_unchanged_borrowed_string_keeps_its_retained_allocation() {
        struct Name(String);
        impl View for Name {
            fn view(&self) -> crate::El<'_> {
                text(&self.0)
            }
        }
        let mut win = Win::with_size(Name("unchanged".into()), 160, 40).unwrap();
        let pointer = SharedText::as_ptr(
            win.runtime().unwrap().texts[0]
                .as_ref()
                .map(|text| &text.value)
                .unwrap(),
        );
        win.reset_counters().unwrap();
        win.update(|m| m.0 = m.0.clone()).unwrap();
        assert!(std::ptr::eq(
            pointer,
            SharedText::as_ptr(
                win.runtime().unwrap().texts[0]
                    .as_ref()
                    .map(|text| &text.value)
                    .unwrap()
            )
        ));
        assert_eq!(win.counters().text_promotions, 0);
        assert_eq!(win.counters().layout_runs, 0);
        assert_eq!(win.counters().paint_passes, 0);
    }

    #[test]
    fn the_last_text_service_is_released_after_a_text_free_sheet_commits() {
        struct Content {
            text: bool,
            broken: bool,
        }
        impl View for Content {
            fn view(&self) -> crate::El<'_> {
                if self.text {
                    text("present")
                } else {
                    div().size(8).bg(Color::BLACK).transform(if self.broken {
                        Affine::scale(0.0, 1.0)
                    } else {
                        Affine::IDENTITY
                    })
                }
            }
        }
        let mut win = Win::with_size(
            Content {
                text: true,
                broken: false,
            },
            80,
            40,
        )
        .unwrap();
        assert!(win.runtime().unwrap().text.is_some());
        assert!(
            win.update(|m| {
                m.text = false;
                m.broken = true;
            })
            .is_err()
        );
        assert!(
            win.runtime().unwrap().text.is_some(),
            "the failed candidate did not replace the text sheet"
        );
        win.update(|m| m.broken = false).unwrap();
        assert!(win.runtime().unwrap().text.is_none());
        win.update(|m| m.text = true).unwrap();
        assert!(win.runtime().unwrap().text.is_some());
    }
    #[test]
    fn text_lane_moves_one_cache_per_site_and_releases_removed_capacity() {
        struct Page {
            count: usize,
            every: usize,
        }
        impl View for Page {
            fn view(&self) -> crate::El<'_> {
                crate::column((0..self.count).map(|index| {
                    if self.every != 0 && index % self.every == 0 {
                        text("stable").w(80).h(1)
                    } else {
                        div().w(80).h(1)
                    }
                }))
            }
        }
        let mut win = Win::with_size(
            Page {
                count: 32,
                every: 2,
            },
            100,
            40,
        )
        .unwrap();
        let runtime = win.runtime().unwrap();
        let first = runtime.texts[0].as_ref().unwrap();
        let value = SharedText::as_ptr(&first.value);
        let glyphs = first
            .shaped
            .as_ref()
            .unwrap()
            .layout
            .glyphs()
            .collect::<Vec<_>>();
        win.reset_counters().unwrap();
        win.update(|_| {}).unwrap();
        let first = win.runtime().unwrap().texts[0].as_ref().unwrap();
        assert!(std::ptr::eq(value, SharedText::as_ptr(&first.value)));
        assert_eq!(
            glyphs,
            first
                .shaped
                .as_ref()
                .unwrap()
                .layout
                .glyphs()
                .collect::<Vec<_>>()
        );
        assert_eq!(win.counters().paint_passes, 0);
        assert_eq!(win.counters().measure_calls, 0);
        for (count, every) in [(128, 1), (64, 8), (0, 0), (32, 2), (128, 0)] {
            win.update(|m| {
                m.count = count;
                m.every = every;
            })
            .unwrap();
            let runtime = win.runtime().unwrap();
            let expected = if every == 0 { 0 } else { count.div_ceil(every) };
            assert_eq!(runtime.texts.len(), expected);
            assert_eq!(runtime.texts.capacity(), expected);
            assert!(runtime.texts.iter().all(Option::is_some));
            let mut slots: Vec<_> = runtime
                .nodes
                .iter()
                .filter_map(|node| (node.text_slot().0 != u32::MAX).then_some(node.text_slot().0))
                .collect();
            slots.sort_unstable();
            assert_eq!(slots, (0..expected as u32).collect::<Vec<_>>());
            assert_eq!(runtime.text.is_none(), expected == 0);
        }
    }

    #[test]
    fn first_known_width_measurement_fills_only_a_vacant_layout_slot() {
        let system = TextSystem::bundled().unwrap();
        let mut shaper = system.font_face().shaper();
        let mut site = TextSite {
            value: SharedText::from("office אבג\nnext"),
            field: None,
            shaped: None,
        };
        let input = |available_width| WidthMeasureInput {
            known_dimensions: Size::NONE,
            available_width,
        };
        for width in [
            AvailableSpace::MaxContent,
            AvailableSpace::MinContent,
            AvailableSpace::Definite(80.),
        ] {
            site.measure_for(&mut shaper, 16., input(width)).unwrap();
            assert!(
                site.shaped.is_none(),
                "an available constraint cannot fill the slot"
            );
        }
        site.measure_for(
            &mut shaper,
            16.,
            WidthMeasureInput {
                known_dimensions: Size {
                    width: Some(80.),
                    height: None,
                },
                available_width: AvailableSpace::MaxContent,
            },
        )
        .unwrap();
        let first = site
            .shaped
            .as_ref()
            .unwrap()
            .layout
            .glyphs()
            .collect::<Vec<_>>();
        let geometry = site
            .shaped
            .as_ref()
            .unwrap()
            .layout
            .retain_geometry()
            .unwrap();
        for other in [
            input(AvailableSpace::MaxContent),
            input(AvailableSpace::MinContent),
            input(AvailableSpace::Definite(40.)),
            WidthMeasureInput {
                known_dimensions: Size {
                    width: Some(40.),
                    height: None,
                },
                available_width: AvailableSpace::MaxContent,
            },
        ] {
            site.measure_for(&mut shaper, 16., other).unwrap();
            assert_eq!(
                site.shaped
                    .as_ref()
                    .unwrap()
                    .layout
                    .glyphs()
                    .collect::<Vec<_>>(),
                first
            );
        }
        let cost = allocation_counter::measure(|| {
            site.measure_for(&mut shaper, 16., input(AvailableSpace::Definite(80.)))
                .unwrap();
            site.shape_for(&mut shaper, 16., Some(80.)).unwrap();
        });
        assert_eq!(cost.count_total, 0);
        // The first known width is provisional. Final placement must still
        // check its own width, while the old geometry lease remains usable.
        site.shape_for(&mut shaper, 16., Some(40.)).unwrap();
        assert_eq!(site.shaped.as_ref().unwrap().width, Some(40.0f32.to_bits()));
        assert!(
            geometry
                .caret_bounds(gpui_canvas::TextPosition {
                    offset: gpui_canvas::TextOffset::new(0).unwrap(),
                    affinity: gpui_canvas::CaretAffinity::Downstream,
                })
                .is_some()
        );
    }

    #[test]
    fn measurements_preserve_the_last_successful_canonical_text_geometry() {
        let system = TextSystem::bundled().unwrap();
        let mut shaper = system.font_face().shaper();
        let mut site = TextSite {
            value: SharedText::from("office אבג\nnext"),
            field: None,
            shaped: None,
        };
        let geometry = site
            .shape_for(&mut shaper, 16., Some(80.))
            .unwrap()
            .retain_geometry()
            .unwrap();
        let glyphs = site
            .shaped
            .as_ref()
            .unwrap()
            .layout
            .glyphs()
            .collect::<Vec<_>>();
        for (size, width) in [(16., None), (16., Some(1.)), (24., Some(80.))] {
            site.measure_for(
                &mut shaper,
                size,
                WidthMeasureInput {
                    known_dimensions: Size::NONE,
                    available_width: width
                        .map_or(AvailableSpace::MaxContent, AvailableSpace::Definite),
                },
            )
            .unwrap();
            let shape = site.shaped.as_ref().unwrap();
            assert_eq!(shape.width, Some(80.0f32.to_bits()));
            assert_eq!(shape.layout.glyphs().collect::<Vec<_>>(), glyphs);
            assert!(std::sync::Arc::ptr_eq(
                &geometry,
                &shape.layout.retain_geometry().unwrap()
            ));
        }
        assert!(
            site.measure_for(
                &mut shaper,
                0.,
                WidthMeasureInput {
                    known_dimensions: Size::NONE,
                    available_width: AvailableSpace::Definite(80.),
                }
            )
            .is_err()
        );
        assert_eq!(
            site.shaped
                .as_ref()
                .unwrap()
                .layout
                .glyphs()
                .collect::<Vec<_>>(),
            glyphs
        );
        let cost = allocation_counter::measure(|| {
            site.measure_for(
                &mut shaper,
                16.,
                WidthMeasureInput {
                    known_dimensions: Size::NONE,
                    available_width: AvailableSpace::Definite(80.),
                },
            )
            .unwrap();
        });
        assert_eq!(
            cost.count_total, 0,
            "exact published operands borrow metrics"
        );
        println!(
            "TEXT_SITE_HEADERS site={} shaped={}",
            size_of::<TextSite>(),
            size_of::<Shaped>()
        );
    }

    #[test]
    fn text_width_cache_preserves_keys_and_replaces_only_after_success() {
        let system = TextSystem::bundled().unwrap();
        let mut shaper = system.font_face().shaper();
        let mut site = TextSite {
            value: SharedText::from("alpha beta gamma"),
            field: None,
            shaped: None,
        };
        let wide = site
            .shape_for(&mut shaper, 16.0, Some(140.0))
            .unwrap()
            .height;
        let narrow = site
            .shape_for(&mut shaper, 16.0, Some(40.0))
            .unwrap()
            .height;
        assert!(narrow > wide);
        let cached = allocation_counter::measure(|| {
            site.shape_for(&mut shaper, 16.0, Some(40.0)).unwrap();
        });
        assert_eq!(
            cached.count_total, 0,
            "same-width cache must not reshape or clone"
        );
        assert_eq!(site.shaped.as_ref().unwrap().width, Some(40.0f32.to_bits()));
        site.shape_for(&mut shaper, 16.0, None).unwrap();
        assert_eq!(site.shaped.as_ref().unwrap().width, None);
        site.shape_for(&mut shaper, 16.0, Some(-0.0)).unwrap();
        assert_eq!(
            site.shaped.as_ref().unwrap().width,
            Some(f32::MIN_POSITIVE.to_bits())
        );
        site.value = SharedText::from("漢");
        site.shaped = None;
        assert!(site.shape_for(&mut shaper, 16.0, Some(40.0)).is_err());
        assert!(site.shaped.is_none());
    }
}

#[cfg(test)]
mod semantic_storage_ledger {
    use super::*;
    use crate::Signal;
    use std::mem::size_of;
    struct Empty;
    impl View for Empty {
        fn view(&self) -> crate::El<'_> {
            crate::div()
        }
    }
    impl crate::ItemSource for Empty {
        fn len(&self) -> usize {
            0
        }
        fn key(&self, _: usize) -> crate::ItemKey {
            unreachable!()
        }
        fn index_of(&self, _: crate::ItemKey) -> Option<usize> {
            None
        }
        fn row(&self, _: usize) -> crate::El<'_> {
            unreachable!()
        }
    }
    struct Owner {
        child: Empty,
    }
    impl Owner {
        const CHILD: crate::Component<Self, Empty> =
            crate::Component::new(FieldId::new(1), "child", |m| &m.child, |m| &mut m.child);
    }
    fn allocation(label: &str, build: impl FnOnce() -> crate::El<'static>) -> (u64, u64) {
        let mut element = None;
        let measured = allocation_counter::measure(|| element = Some(build()));
        println!(
            "element,{label},allocations={},bytes={}",
            measured.count_total, measured.bytes_total
        );
        drop(element);
        (measured.count_total, measured.bytes_total)
    }
    #[test]
    fn sparse_metadata_storage_and_cold_allocation_ledger() {
        let mut destinations = Vec::with_capacity(4);
        destinations.push(Destination::new(0, Port::Name));
        println!(
            "Node={} Presented={} El={} Draft={} Text={} ListRow={} Fanout={} Dest={} destination_capacity={} destination_capacity_bytes={} Metadata={} Declared={} TextSlot={} Sheet={} Row={} ListInfo={}",
            size_of::<Node>(),
            size_of::<Presented>(),
            size_of::<crate::El<'_>>(),
            size_of::<crate::element::DraftNode<'_>>(),
            size_of::<crate::source::Text<'_>>(),
            size_of::<ListRow>(),
            size_of::<Fanout>(),
            size_of::<Destination>(),
            destinations.capacity(),
            destinations.capacity() * size_of::<Destination>(),
            size_of::<Metadata>(),
            size_of::<Declared>(),
            size_of::<metadata::TextSlot>(),
            size_of::<metadata::Sheet>(),
            size_of::<metadata::Row>(),
            size_of::<ListInfo>()
        );
        println!(
            "Extra={} Annotations={} ListSpec={} AnnotationDraft={}",
            size_of::<crate::semantic::ElementExtra<'_>>(),
            size_of::<crate::semantic::Annotations<'_>>(),
            size_of::<crate::list::ListSpec<'_>>(),
            size_of::<crate::semantic::AnnotationDraft<'_>>()
        );
        // Parent/transform packing and the source namespace niche are shared
        // baseline improvements; semantic columns add no hot-node fields.
        assert_eq!(size_of::<Node>(), 24);
        assert_eq!(size_of::<Prepared>(), 40);
        assert_eq!(size_of::<Presented>(), 64);
        assert_eq!(size_of::<crate::El<'_>>(), 176);
        assert_eq!(size_of::<ListRow>(), 32);
        assert_eq!(size_of::<metadata::Row>(), 24);
        assert_eq!(size_of::<Destination>(), 4);
        assert_eq!(allocation("absent", crate::div), (0, 0));
        assert_eq!(
            allocation("semantic", || crate::div()
                .name("label")
                .description("description")),
            (1, 56)
        );
        static EMPTY: Empty = Empty;
        assert_eq!(
            allocation("list", || crate::uniform_list(ListId::new(1), &EMPTY, 24)),
            (1, 56)
        );
        assert_eq!(
            allocation("combined", || crate::uniform_list(
                ListId::new(1),
                &EMPTY,
                24
            )
            .name("label")),
            (2, 104)
        );
        // Component boundaries retain the prior independent cold extension.
        let owner = Owner { child: Empty };
        for named in [false, true] {
            let mut element = None;
            let counted = allocation_counter::measure(|| {
                let child = Owner::CHILD.view(&owner);
                element = Some(if named { child.name("child") } else { child });
            });
            println!(
                "element,component_named={named},allocations={},bytes={}",
                counted.count_total, counted.bytes_total
            );
            drop(element);
        }
        let win = Win::with_size(Empty, 4, 4).unwrap();
        assert!(win.runtime().unwrap().metadata.is_none());
    }
    #[test]
    #[ignore = "manual dense storage evidence; includes 30,003 layout nodes"]
    fn dense_annotation_capacity_evidence() {
        struct Dense {
            count: usize,
            ports: u8,
            label: Signal<String>,
        }
        impl Dense {
            const LABEL: Source<Self, String> =
                Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
        }
        impl View for Dense {
            fn sources() -> Sources<Self> {
                Sources::new().direct(Self::LABEL)
            }
            fn view(&self) -> crate::El<'_> {
                crate::column((0..self.count).map(|_| {
                    let site = crate::div().size(1);
                    match self.ports {
                        0 => site,
                        1 => site.name(&self.label),
                        _ => site.name(&self.label).description(&self.label),
                    }
                }))
            }
        }
        // Cephal caches scratch vectors in dependency TLS. Warm that independent
        // pool before measuring new owned-window allocations, consistently for
        // all three cases; this is not an OS RSS/total-process measurement.
        drop(
            Win::recording(
                Dense {
                    count: 10_000,
                    ports: 0,
                    label: Signal::new("shared".into()),
                },
                WindowOptions {
                    size: [4, 4],
                    ..Default::default()
                },
            )
            .unwrap(),
        );
        for ports in 0..=2 {
            let model = Dense {
                count: 10_000,
                ports,
                label: Signal::new("shared".into()),
            };
            let mut held = None;
            let allocation = allocation_counter::measure(|| {
                let mut win = Win::recording(
                    model,
                    WindowOptions {
                        size: [4, 4],
                        ..Default::default()
                    },
                )
                .unwrap();
                let token = win.with_scene(|_, token| token).unwrap();
                win.presented(token).unwrap();
                held = Some(win);
            });
            let runtime = held.as_ref().unwrap().runtime().unwrap();
            let (base, names, descriptions) =
                runtime.metadata.as_deref().map_or((0, 0, 0), |metadata| {
                    (
                        metadata.base.capacity() * size_of::<Declared>(),
                        metadata.presented.names.capacity() * size_of::<metadata::TextSlot>(),
                        metadata.presented.descriptions.capacity()
                            * size_of::<metadata::TextSlot>(),
                    )
                });
            let destinations = runtime
                .fanout
                .values()
                .map(|fanout| fanout.destination_bytes())
                .sum::<usize>();
            println!(
                "dense,ports={ports},nodes={},allocations={},retained={},peak={},base_capacity_bytes={base},name_capacity_bytes={names},description_capacity_bytes={descriptions},fanout_capacity_bytes={destinations},promotions={}",
                runtime.nodes.len(),
                allocation.count_total,
                allocation.bytes_current,
                allocation.bytes_max,
                runtime.counters.text_promotions
            );
            assert_eq!(runtime.metadata.is_none(), ports == 0);
            if ports > 0 {
                assert_eq!(runtime.counters.text_promotions, 1);
            }
        }
    }
    #[test]
    fn shared_ports_retain_one_payload_and_do_not_create_text_service() {
        struct Page(Signal<String>);
        impl Page {
            const LABEL: Source<Self, String> =
                Source::new(FieldId::new(1), "label", |m| &m.0, |m| &mut m.0);
        }
        impl View for Page {
            fn sources() -> Sources<Self> {
                Sources::new().direct(Self::LABEL)
            }
            fn view(&self) -> crate::El<'_> {
                crate::div().name(&self.0).description(&self.0)
            }
        }
        let mut win = Win::with_size(Page(Signal::new("label".into())), 4, 4).unwrap();
        win.set(Page::LABEL, "changed".into()).unwrap();
        let runtime = win.runtime().unwrap();
        let metadata = runtime.metadata.as_ref().unwrap();
        let base = &metadata.base[0];
        let published = &metadata.presented.names[0];
        assert!(std::ptr::eq(
            SharedText::as_ptr(base.name.as_ref().unwrap()),
            SharedText::as_ptr(base.description.as_ref().unwrap())
        ));
        assert!(std::ptr::eq(
            SharedText::as_ptr(base.name.as_ref().unwrap()),
            SharedText::as_ptr(published.value.as_ref().unwrap())
        ));
        assert!(
            runtime.text.is_none(),
            "semantic strings never initialize the shaper/rasterizer"
        );
    }
}

#[cfg(test)]
mod style_port_tests {
    use super::*;
    use crate::Signal;
    struct Panel {
        number: Signal<f64>,
        color: Signal<Color>,
        text_first: bool,
    }
    impl Panel {
        const NUMBER: crate::Source<Self, f64> =
            crate::Source::new(FieldId::new(1), "number", |m| &m.number, |m| &mut m.number);
        const COLOR: crate::Source<Self, Color> =
            crate::Source::new(FieldId::new(2), "color", |m| &m.color, |m| &mut m.color);
    }
    impl View for Panel {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::NUMBER).direct(Self::COLOR)
        }
        fn view(&self) -> crate::El<'_> {
            let style = crate::div()
                .w(&self.number)
                .font_size(&self.number)
                .bg(&self.color);
            if self.text_first {
                crate::column((crate::text(&self.number), style))
            } else {
                style.child(crate::text(&self.number))
            }
        }
    }
    #[test]
    fn invalid_shared_scalar_cannot_patch_text_style_or_masked_base_in_either_order() {
        for text_first in [false, true] {
            let mut win = Win::with_size(
                Panel {
                    number: Signal::new(24.0),
                    color: Signal::new(Color::BLACK),
                    text_first,
                },
                80,
                80,
            )
            .unwrap();
            let index = usize::from(text_first) * 2;
            let target = {
                let runtime = win.runtime().unwrap();
                runtime.sites.target(runtime.nodes[index].identity())
            };
            win.set_property(
                target,
                crate::property::WIDTH,
                Contribution::Set(crate::Length::Points(30.0)),
            )
            .unwrap();
            let before = win.runtime().unwrap().styles.get(index).to_owned();
            assert!(win.set(Panel::NUMBER, 0.0).is_err());
            let runtime = win.runtime().unwrap();
            assert!(styles::exact_eq(&runtime.styles.get(index), &before));
            assert!(
                runtime
                    .texts
                    .iter()
                    .flatten()
                    .all(|text| text.value.as_ref() == "24")
            );
            assert!(!runtime.logical_valid);
            // Removing a mask uses the lower base directly. It must still be24,
            // not the valid width0 from the rejected mixed-sink publication.
            let mut runtime = win.runtime_mut().unwrap();
            let identity = runtime.nodes[index].identity();
            let lower = runtime
                .overrides
                .set(
                    identity,
                    before,
                    crate::property::WIDTH,
                    Contribution::Inherit,
                )
                .unwrap();
            assert_eq!(lower.width, Length::Points(24.0));
        }
    }
    #[test]
    fn fresh_cold_binding_owner_ledger() {
        struct Bound {
            ports: usize,
            number: Signal<f64>,
            color: Signal<Color>,
            transform: Signal<Affine>,
        }
        impl Bound {
            const NUMBER: crate::Source<Self, f64> =
                crate::Source::new(FieldId::new(1), "number", |m| &m.number, |m| &mut m.number);
            const COLOR: crate::Source<Self, Color> =
                crate::Source::new(FieldId::new(2), "color", |m| &m.color, |m| &mut m.color);
            const TRANSFORM: crate::Source<Self, Affine> = crate::Source::new(
                FieldId::new(3),
                "transform",
                |m| &m.transform,
                |m| &mut m.transform,
            );
        }
        impl View for Bound {
            fn sources() -> Sources<Self> {
                Sources::new()
                    .direct(Self::NUMBER)
                    .direct(Self::COLOR)
                    .direct(Self::TRANSFORM)
            }
            fn view(&self) -> crate::El<'_> {
                let mut el = crate::div()
                    .size(12)
                    .p(12)
                    .gap(12)
                    .font_size(12)
                    .fg(Color::BLACK)
                    .bg(Color::BLACK);
                if self.ports >= 1 {
                    el = el.w(&self.number);
                }
                if self.ports >= 2 {
                    el = el.h(&self.number);
                }
                if self.ports >= 8 {
                    el = el
                        .p(&self.number)
                        .gap(&self.number)
                        .font_size(&self.number)
                        .fg(&self.color)
                        .bg(&self.color)
                        .transform(&self.transform);
                }
                el
            }
        }
        for ports in [0, 1, 2, 8] {
            let mut win = None;
            let count = allocation_counter::measure(|| {
                win = Some(
                    Win::recording(
                        Bound {
                            ports,
                            number: Signal::new(12.0),
                            color: Signal::new(Color::BLACK),
                            transform: Signal::new(Affine::IDENTITY),
                        },
                        WindowOptions {
                            size: [32, 32],
                            ..Default::default()
                        },
                    )
                    .unwrap(),
                );
            });
            let runtime = win.as_ref().unwrap().runtime().unwrap();
            eprintln!(
                "style_owner,ports={ports},requests={},requested={},retained={},peak={},fanouts={},destination_capacity_bytes={}",
                count.count_total,
                count.bytes_total,
                count.bytes_current,
                count.bytes_max,
                runtime.fanout.len(),
                runtime
                    .fanout
                    .values()
                    .map(|fanout| fanout.destination_bytes())
                    .sum::<usize>()
            );
            assert_eq!(
                runtime
                    .fanout
                    .values()
                    .map(|fanout| fanout.destinations().len())
                    .sum::<usize>(),
                if ports == 8 { 6 } else { ports }
            );
            if ports == 8 {
                assert!(runtime.styles.binding_fields(0).iter().all(Option::is_some));
                assert_eq!(
                    runtime
                        .fanout
                        .values()
                        .filter(|f| matches!(f, Fanout::Color(_)))
                        .count(),
                    1
                );
            }
            drop(win);
        }
        struct Plain;
        impl View for Plain {
            fn view(&self) -> crate::El<'_> {
                crate::div()
            }
        }
        let mut win = None;
        let count = allocation_counter::measure(|| {
            win = Some(Win::recording(Plain, WindowOptions::default()).unwrap())
        });
        eprintln!(
            "style_plain_owner,requests={},requested={},retained={},peak={}",
            count.count_total, count.bytes_total, count.bytes_current, count.bytes_max
        );
        drop(win);
    }

    #[test]
    fn ordinary_headers_and_literal_owner_allocation_floor_remain_unchanged() {
        eprintln!(
            "style_headers,Style={},El={},Draft={},Node={},P={},Runtime={},Fanout={},Destination={},Flex={}",
            size_of::<Style>(),
            size_of::<crate::El<'_>>(),
            size_of::<crate::element::DraftNode<'_>>(),
            size_of::<Node>(),
            size_of::<Presented>(),
            size_of::<Runtime<()>>(),
            size_of::<Fanout>(),
            size_of::<Destination>(),
            size_of::<crate::Flex>()
        );
        assert_eq!(size_of::<Node>(), 24);
        assert_eq!(size_of::<Presented>(), 64);
        assert_eq!(size_of::<crate::El<'_>>(), 176);
        assert_eq!(size_of::<crate::element::DraftNode<'_>>(), 152);
        assert_eq!(size_of::<Style>(), 88);
        assert_eq!(size_of::<Fanout>(), 32);
        assert_eq!(size_of::<Destination>(), 4);
    }
}

#[cfg(test)]
mod basis_layout_probe;

#[cfg(test)]
mod basis_lifecycle_tests;

#[cfg(test)]
mod mapped_qualification {
    use super::*;
    use crate::{Signal, SignalMap};
    #[derive(Clone, Copy)]
    struct Frame {
        count: u32,
        invalid: bool,
    }
    struct Panel(Signal<Frame>);
    const FRAME: crate::Source<Panel, Frame> =
        crate::Source::new(FieldId::new(1), "frame", |m| &m.0, |m| &mut m.0);
    impl View for Panel {
        fn sources() -> Sources<Self> {
            Sources::new().direct(FRAME)
        }
        fn view(&self) -> crate::El<'_> {
            crate::column((0..33).map(|index| {
                let node = crate::div().size(2);
                if index == 32 {
                    node.transform(self.0.map(|frame| {
                        if frame.invalid {
                            Affine {
                                tx: f32::NAN,
                                ..Affine::IDENTITY
                            }
                        } else {
                            Affine::IDENTITY
                        }
                    }))
                } else {
                    node.bg(self.0.map_with(index, |frame, index| {
                        if frame.count & (1 << index) == 0 {
                            Color::BLACK
                        } else {
                            Color::WHITE
                        }
                    }))
                }
            }))
        }
    }
    #[test]
    fn mixed_mapped_and_direct_colors_do_not_accumulate_unique_historical_values() {
        struct Colors {
            mapped: Signal<u32>,
            direct: Signal<Color>,
        }
        const MAPPED: crate::Source<Colors, u32> =
            crate::Source::new(FieldId::new(1), "mapped", |m| &m.mapped, |m| &mut m.mapped);
        const DIRECT: crate::Source<Colors, Color> =
            crate::Source::new(FieldId::new(2), "direct", |m| &m.direct, |m| &mut m.direct);
        impl View for Colors {
            fn sources() -> Sources<Self> {
                Sources::new().direct(MAPPED).direct(DIRECT)
            }
            fn view(&self) -> crate::El<'_> {
                crate::row((
                    crate::div().bg(self.mapped.map(|value| crate::rgb(*value))),
                    crate::div().bg(&self.direct),
                ))
            }
        }
        let mut win = Win::with_size(
            Colors {
                mapped: Signal::new(0),
                direct: Signal::new(Color::BLACK),
            },
            100,
            100,
        )
        .unwrap();
        let mut runtime = win.runtime_mut().unwrap();
        *runtime.model.mapped = 1;
        runtime.patch(MAPPED.id()).unwrap();
        let cost = allocation_counter::measure(|| {
            for value in 2..4096 {
                *runtime.model.mapped = value;
                runtime.patch(MAPPED.id()).unwrap();
            }
        });
        eprintln!(
            "mixed_mapped_colors_4094_updates,requests={},requested={},retained={},peak={}",
            cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max
        );
        assert_eq!(runtime.styles.get(1).bg, crate::rgb(4095));
        assert_eq!(runtime.styles.get(2).bg, Color::BLACK);
        assert_eq!(
            cost.count_total, 0,
            "a mapped color must not retain a history of unique outputs in an unrelated source bank"
        );
        *runtime.model.direct = Color::WHITE;
        runtime.patch(DIRECT.id()).unwrap();
        assert_eq!(runtime.styles.get(1).bg, crate::rgb(4095));
        assert_eq!(runtime.styles.get(2).bg, Color::WHITE);
    }
    #[test]
    fn ten_thousand_direct_color_rows_keep_their_shared_lane_with_one_mapped_color() {
        struct Large {
            direct: Signal<Color>,
            number: Signal<u32>,
            mapped: bool,
        }
        const DIRECT: crate::Source<Large, Color> =
            crate::Source::new(FieldId::new(1), "direct", |m| &m.direct, |m| &mut m.direct);
        const NUMBER: crate::Source<Large, u32> =
            crate::Source::new(FieldId::new(2), "number", |m| &m.number, |m| &mut m.number);
        impl View for Large {
            fn sources() -> Sources<Self> {
                Sources::new().direct(DIRECT).direct(NUMBER)
            }
            fn view(&self) -> crate::El<'_> {
                crate::column(
                    self.mapped
                        .then(|| {
                            crate::div()
                                .size(1)
                                .bg(self.number.map(|value| crate::rgb(*value)))
                        })
                        .into_iter()
                        .chain((0..10_000).map(|_| crate::div().size(1).bg(&self.direct))),
                )
            }
        }
        for mapped in [false, true] {
            let mut win = None;
            let cold = allocation_counter::measure(|| {
                win = Some(
                    Win::with_size(
                        Large {
                            direct: Signal::new(Color::BLACK),
                            number: Signal::new(0),
                            mapped,
                        },
                        100,
                        100,
                    )
                    .unwrap(),
                );
            });
            let mut win = win.unwrap();
            let runtime = win.runtime().unwrap();
            let colors = match &runtime.styles {
                styles::Styles::Colors(colors) => colors.bytes(),
                _ => panic!("ordinary direct Color keeps its shared source lane"),
            };
            eprintln!(
                "large_color_owner,mapped={mapped},rows=10000,nodes={},requests={},requested={},retained={},peak={},style_lane_bytes={},fanout_bytes={}",
                runtime.nodes.len(),
                cold.count_total,
                cold.bytes_total,
                cold.bytes_current,
                cold.bytes_max,
                colors,
                runtime
                    .fanout
                    .values()
                    .map(Fanout::destination_bytes)
                    .sum::<usize>()
            );
            win.reset_counters().unwrap();
            let direct = allocation_counter::measure(|| {
                win.set(DIRECT, Color::WHITE).unwrap();
            });
            let counters = win.counters();
            eprintln!(
                "large_direct_tick,mapped={mapped},requests={},requested={},retained={},peak={},source_reads={},destination_compares={},owner_reruns={},paint_passes={}",
                direct.count_total,
                direct.bytes_total,
                direct.bytes_current,
                direct.bytes_max,
                counters.source_reads,
                counters.destination_compares,
                counters.owner_reruns,
                counters.paint_passes
            );
            assert_eq!(counters.source_reads, 1);
            assert_eq!(counters.destination_compares, 0);
            assert_eq!(counters.owner_reruns, 0);
            if mapped {
                win.reset_counters().unwrap();
                let changed = allocation_counter::measure(|| {
                    win.set(NUMBER, 1).unwrap();
                });
                let counters = win.counters();
                eprintln!(
                    "large_mapped_tick,requests={},requested={},retained={},peak={},source_reads={},destination_compares={},owner_reruns={},paint_passes={}",
                    changed.count_total,
                    changed.bytes_total,
                    changed.bytes_current,
                    changed.bytes_max,
                    counters.source_reads,
                    counters.destination_compares,
                    counters.owner_reruns,
                    counters.paint_passes
                );
                assert_eq!(counters.source_reads, 1);
                assert_eq!(counters.destination_compares, 1);
                assert_eq!(counters.owner_reruns, 0);
                let mut runtime = win.runtime_mut().unwrap();
                let cost = allocation_counter::measure(|| {
                    for value in 2..4096 {
                        *runtime.model.number = value;
                        runtime.patch(NUMBER.id()).unwrap();
                    }
                });
                eprintln!(
                    "large_mapped_warm_4094_patches,requests={},requested={},retained={},peak={}",
                    cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max
                );
                assert_eq!(cost.count_total, 0);
            }
        }
    }
    #[test]
    fn late_invalid_transform_cannot_mutate_earlier_paint_sinks_or_masked_bases() {
        let mut win = Win::with_size(
            Panel(Signal::new(Frame {
                count: 0,
                invalid: false,
            })),
            100,
            100,
        )
        .unwrap();
        let target = win.inspect().unwrap().nodes[1].target.unwrap();
        win.set_property(
            target,
            crate::property::BACKGROUND,
            crate::property::Contribution::Set(crate::Brush::Solid(Color::WHITE)),
        )
        .unwrap();
        let before = win.runtime().unwrap().styles.get(1);
        assert!(
            win.set(
                FRAME,
                Frame {
                    count: u32::MAX,
                    invalid: true
                }
            )
            .is_err()
        );
        let runtime = win.runtime().unwrap();
        assert!(styles::exact_eq(&runtime.styles.get(1), &before));
        for index in 2..33 {
            assert_eq!(runtime.styles.get(index).bg, Color::BLACK);
        }
        let mut runtime = win.runtime_mut().unwrap();
        let identity = runtime.nodes[1].identity();
        let lower = runtime
            .overrides
            .set_value(
                identity,
                before,
                crate::property::PropertyId::Background,
                crate::property::Contribution::Inherit,
            )
            .unwrap();
        assert_eq!(lower.bg, Color::BLACK);
    }
    #[test]
    fn mapped_layout_and_cold_owner_bill_and_zero_allocation_warm_patch() {
        let mut win = None;
        let cold = allocation_counter::measure(|| {
            win = Some(
                Win::with_size(
                    Panel(Signal::new(Frame {
                        count: 0,
                        invalid: false,
                    })),
                    100,
                    100,
                )
                .unwrap(),
            );
        });
        let mut win = win.unwrap();
        let runtime = win.runtime().unwrap();
        let fanout = &runtime.fanout[&FRAME.id()];
        eprintln!(
            "mapped_headers,Destination={},Binding={},Draft={},ElementExtra={},Decorations={},Fanout={},Recipe={},MappedRecord={},MappedFanout={},PropertyValue={},MapBinding={},MapDraft={},MappedOperand={},PropInputColor={}",
            size_of::<Destination>(),
            size_of::<crate::style_port::Binding<'_>>(),
            size_of::<crate::style_port::Draft<'_>>(),
            size_of::<crate::semantic::ElementExtra<'_>>(),
            size_of::<crate::semantic::Decorations<'_>>(),
            size_of::<Fanout>(),
            size_of::<crate::style_port::Recipe>(),
            size_of::<MappedRecord>(),
            size_of::<MappedFanout>(),
            size_of::<crate::property::PropertyValue>(),
            size_of::<crate::style_port::MapBinding<'_>>(),
            size_of::<crate::style_port::MapDraft<'_>>(),
            size_of::<crate::style_port::MapOperand<'_>>(),
            size_of::<crate::PropInput<'_, Color>>()
        );
        eprintln!(
            "mapped_color_headers,SourceColor={},Record={},Bound={}",
            styles::color_headers()[0],
            styles::color_headers()[1],
            styles::color_headers()[2]
        );
        eprintln!(
            "mapped_public_operands,Color={},Affine={},number={}",
            size_of::<crate::PropInput<'_, Color>>(),
            size_of::<crate::PropInput<'_, Affine>>(),
            size_of::<crate::PropInput<'_, f64>>()
        );
        eprintln!(
            "mapped_owner,33,requests={},requested={},retained={},peak={},fanout_bytes={}",
            cold.count_total,
            cold.bytes_total,
            cold.bytes_current,
            cold.bytes_max,
            fanout.destination_bytes()
        );
        assert_eq!(size_of::<Destination>(), 4);
        assert_eq!(size_of::<crate::style_port::Binding<'_>>(), 24);
        assert_eq!(size_of::<crate::semantic::ElementExtra<'_>>(), 56);
        assert_eq!(size_of::<Fanout>(), 32);
        assert_eq!(
            fanout.destination_bytes(),
            size_of::<MappedFanout>()
                + 33 * (size_of::<MappedRecord>() + size_of::<crate::property::PropertyValue>())
        );
        let mut runtime = win.runtime_mut().unwrap();
        *runtime.model.0 = Frame {
            count: 0xa55a_f00f,
            invalid: false,
        };
        let first = allocation_counter::measure(|| {
            runtime.patch(FRAME.id()).unwrap();
        });
        eprintln!(
            "mapped_first_patch,requests={},requested={},retained={},peak={}",
            first.count_total, first.bytes_total, first.bytes_current, first.bytes_max
        );
        *runtime.model.0 = Frame {
            count: 0x5aa5_0ff0,
            invalid: false,
        };
        let cost = allocation_counter::measure(|| {
            runtime.patch(FRAME.id()).unwrap();
        });
        eprintln!(
            "mapped_warm_patch,requests={},requested={},retained={},peak={}",
            cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max
        );
        assert_eq!(cost.count_total, 0);
    }
}
#[cfg(test)]
mod ordinary_background_allocation_audit {
    use super::*;
    #[test]
    fn ordinary_background_allocation_first_warm_equal_clear() {
        use crate::property::{PropertyId, PropertyValue};
        struct Plain;
        impl View for Plain {
            fn view(&self) -> crate::El<'_> {
                crate::div().size(16).bg(Color::BLACK).name("plain")
            }
        }
        let mut win = Win::with_size(Plain, 16, 16).unwrap();
        let target = win.query().name("plain").one().unwrap();
        assert!(win.runtime().unwrap().images.is_none());
        for (phase, contribution) in [
            (
                "first",
                Contribution::Set(PropertyValue::Color(Color::WHITE)),
            ),
            (
                "warm",
                Contribution::Set(PropertyValue::Color(Color::BLACK)),
            ),
            (
                "equal",
                Contribution::Set(PropertyValue::Color(Color::BLACK)),
            ),
            ("inherit", Contribution::Inherit),
        ] {
            let cost = allocation_counter::measure(|| {
                win.set_property_value(target, PropertyId::Background, contribution)
                    .unwrap();
            });
            let runtime = win.runtime().unwrap();
            assert!(
                runtime.images.is_none(),
                "a solid contribution has no resource authority"
            );
            let style_capacity = match &runtime.styles {
                styles::Styles::Dense(values) => values.capacity() * size_of::<Style>(),
                _ => 0,
            };
            eprintln!(
                "ordinary_background_audit,phase={phase},allocs={},requested={},retained_delta={},peak_delta={},images_present={},style_dense_bytes={style_capacity},contribution={:?}",
                cost.count_total,
                cost.bytes_total,
                cost.bytes_current,
                cost.bytes_max,
                runtime.images.is_some(),
                runtime.property_contribution_at(
                    runtime.resolve(target).unwrap(),
                    PropertyId::Background
                )
            );
        }
    }
}

#[cfg(test)]
mod boolean_layout_probe {
    use super::*;
    #[test]
    fn print_boolean_runtime_headers() {
        macro_rules! show { ($($ty:ty),+ $(,)?) => { $( println!("BOOLEAN_RUNTIME_HEADER {} size={} align={}", stringify!($ty), size_of::<$ty>(), align_of::<$ty>()); )+ }; }
        show!(
            Content,
            Node,
            Presented,
            Fanout,
            MappedFanout,
            BooleanRecipe,
            BooleanOutput,
            BooleanFanout
        );
    }
}
