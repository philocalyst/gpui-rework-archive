//! One serial owner turn, a retained logical description, and an admitted sheet.
//! Layout is private scratch; the canvas stages commands without another output
//! framebuffer. Callbacks carry ordinary Rust borrows; there is no shared mutable owner cell.
use crate::shared_text::SharedText;
use std::{
    collections::{BTreeMap, BTreeSet},
    num::NonZeroU64,
    panic::{AssertUnwindSafe, catch_unwind},
};

use gpui_canvas::{
    Canvas, ColorConfig, DamageRegion, PreparedScene, TextLayout, TextShaper, TextSystem,
};
use gpui_reactivity_core::{
    Affine, CoordinateSpace, NodeId, Point, Rect,
    layout::{AvailableSpace, LayoutError, LayoutTree, MeasureInput, MeasureOutput, Size},
};
use serde::Serialize;

use crate::{
    ListError, ListId, Target, View,
    element::{Handler, NodeKind},
    identity::Sites,
    property::{Contribution, Overrides, Property, PropertyError},
    remote::{Delivery, DeliveryError, Inbox, Lane, LaneSet, Stage},
    source::{BindError, FieldId, Source, Sources, TextCodec, TextEditError},
    style::{Color, Flow, Style},
};

const MAX_NODES: usize = 100_000;
// The compact parent sentinel must stay outside the admitted index domain.
const _: () = assert!(MAX_NODES <= u32::MAX as usize);
// Cephal's algorithms recurse even though public description disposal does not.
const MAX_LAYOUT_DEPTH: usize = 128;

#[cfg(feature = "accessibility")]
mod accessibility;
mod delivery;
mod image;
mod input;
mod list;
mod scroll;
mod turn;
use list::{ListRow, ListState, ScrollRequest};
use scroll::{ViewportKey, ViewportState};
mod geometry;
mod metadata;
pub(crate) mod paint;
use paint::PatchOutcome;
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
    PresentationStale,
    InvalidScale,
    NoPreparedScene,
    StalePresentation,
    NotInteractive,
    NotInput,
    NotHittable,
    MissingElement,
    AmbiguousElement { matches: usize },
    UnregisteredInput { node: usize },
    DepthLimit { node: usize },
    ResourceLimit,
    EpochExhausted,
    Binding(BindError),
    TextEdit(TextEditError),
    Layout(LayoutError),
    Canvas(gpui_canvas::Error),
    Property(PropertyError),
    GeometryProperty { node: usize, error: PropertyError },
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

/// One current-width layout per text-bearing site, owned by the runtime's dense
/// lane. A description moves cache entries with surviving identities; removed
/// sites drop their glyph buffers when the preceding lane is dropped.
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
/// Finite admitted maps cannot contain NaN, so one NaN coefficient represents
/// an absent map without the extra discriminant of `Option<Affine>`. This is
/// plain float storage: no invalid Rust values or unchecked reads are involved.
#[derive(Clone, Copy)]
struct PresentedTransform(Affine);
impl PresentedTransform {
    fn new(transform: Option<Affine>) -> Self {
        debug_assert!(transform.is_none_or(|map| map.is_finite() && map.is_invertible()));
        Self(transform.unwrap_or(Affine {
            a: f32::NAN,
            ..Affine::IDENTITY
        }))
    }
    fn get(self) -> Option<Affine> {
        (!self.0.a.is_nan()).then_some(self.0)
    }
}
#[cfg(test)]
mod parent_tests {
    use super::*;

    #[test]
    fn nonzero_identity_keeps_old_node_migration_in_place() {
        assert_eq!(size_of::<Node>(), 40);
        assert_eq!(size_of::<Option<Node>>(), size_of::<Node>());
        let nodes = (1..=64)
            .map(|identity| Node {
                identity: NonZeroU64::new(identity).unwrap(),
                parent: Parent::NONE,
                ordinal: 0,
                content: Content::new(NodeKind::Div, TextSlot::NONE),
                component_scope: 0,
                handler: None,
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
            size_of::<PresentedTransform>(),
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
    #[should_panic(expected = "text belongs to the admitted description")]
    fn content_rejects_the_first_unadmitted_text_index() {
        Content::new(NodeKind::Text, TextSlot(MAX_NODES as u32));
    }

    #[test]
    fn compact_map_preserves_finite_admitted_coefficients() {
        assert_eq!(size_of::<PresentedTransform>(), size_of::<Affine>());
        assert_eq!(PresentedTransform::new(None).get(), None);
        for map in [
            Affine::IDENTITY,
            Affine {
                a: -0.0,
                b: 1.0,
                c: -1.0,
                d: 0.0,
                tx: -0.0,
                ty: 0.0,
            },
            Affine::scale(-2.0, 0.25),
            Affine::translation(f32::MAX, -f32::MAX),
        ] {
            let actual = PresentedTransform::new(Some(map)).get().unwrap();
            assert_eq!(
                [actual.a, actual.b, actual.c, actual.d, actual.tx, actual.ty].map(f32::to_bits),
                [map.a, map.b, map.c, map.d, map.tx, map.ty].map(f32::to_bits),
            );
        }
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
/// Zero in the upper bits means no text; the lower three bits hold one of the
/// eight explicitly encoded kinds. No Rust enum representation is reinterpreted.
#[derive(Clone, Copy)]
struct Content(u32);
const _: () = assert!(MAX_NODES <= (u32::MAX >> 3) as usize);
impl Content {
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
        Self((text << 3) | kind)
    }
    #[inline]
    fn kind(self) -> NodeKind {
        match self.0 & 7 {
            0 => NodeKind::Div,
            1 => NodeKind::Text,
            2 => NodeKind::Input,
            3 => NodeKind::Button,
            4 => NodeKind::List,
            5 => NodeKind::ListItem,
            6 => NodeKind::Image,
            7 => NodeKind::Scroll,
            _ => unreachable!("three-bit kind"),
        }
    }
    #[inline]
    fn text_slot(self) -> TextSlot {
        if self.kind() == NodeKind::Image {
            return TextSlot::NONE;
        }
        let text = self.0 >> 3;
        TextSlot(if text == 0 { u32::MAX } else { text - 1 })
    }
    fn image(image: image::ImageUse) -> Self {
        assert!((image.resource as usize) < MAX_NODES);
        let value = image.resource * 2 + u32::from(image.sampling == crate::ImageSampling::Nearest);
        Self(((value + 1) << 3) | 6)
    }
    fn image_use(self) -> Option<image::ImageUse> {
        let value = self.0 >> 3;
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
struct Node {
    identity: NonZeroU64,
    parent: Parent,
    ordinal: u32,
    content: Content,
    component_scope: u32,
    handler: Option<Handler>,
}
#[cfg(test)]
mod hit_tests;
#[cfg(test)]
mod style_ledger;
impl Node {
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
    fn shape<'n>(
        &'n mut self,
        service: &mut TextShaper<'_>,
        font_size: f32,
        width: Option<f32>,
    ) -> Result<&'n TextLayout, Error> {
        let width = width.map(|value| value.max(f32::MIN_POSITIVE));
        let key = width.map(f32::to_bits);
        if self.shaped.as_ref().is_none_or(|shape| shape.width != key) {
            let layout = service.shape(&self.value, font_size, width)?;
            self.shaped = Some(Shaped { width: key, layout });
        }
        Ok(&self.shaped.as_ref().unwrap().layout)
    }
}
struct Fanout {
    codec: TextCodec,
    destinations: Vec<Destination>,
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
    rect: Rect,
    transform: PresentedTransform,
    bounds: Rect,
    hittable: bool,
    actions: Actions,
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
#[cfg(any(feature = "native", test))]
#[derive(Default)]
pub(crate) struct SurfaceDamage {
    recent: [DamageRegion; 3],
    known: u8,
}
#[cfg(any(feature = "native", test))]
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
    styles: styles::Styles,
    texts: Vec<Option<TextSite>>,
    images: Option<Box<image::Images>>,
    by_identity: BTreeMap<u64, usize>,
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
    text: Option<TextSystem>,
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
        Win::mount_lanes(model, questions.bind(()), options, true, 1.0)
    }
    pub fn recording_questions<Q: LaneSet<M>>(
        model: M,
        questions: crate::Questions<M, Q>,
        options: WindowOptions,
    ) -> Result<Win<M, crate::reader::QuestionSet<Q, ()>>, Error> {
        Win::mount_lanes(model, questions.bind(()), options, false, 1.0)
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
        Self::mount_lanes(model, (), options, automatic_presentation, scale_factor)
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
        let canvas = if automatic_presentation {
            Canvas::with_color_config(options.size[0], options.size[1], options.colors)?
        } else {
            Canvas::recording(options.size[0], options.size[1], options.colors)?
        };
        // These constructors run while PendingMount still owns the model and
        // receiver order, including checked process-namespace exhaustion.
        let sites = Sites::new();
        let layout = LayoutTree::new();
        let runtime = Runtime {
            model: pending.model,
            sources,
            nodes: Vec::new(),
            styles: styles::Styles::default(),
            texts: Vec::new(),
            images: None,
            by_identity: BTreeMap::new(),
            fanout: BTreeMap::new(),
            next_identity: 1,
            focused: None,
            sites,
            overrides: Overrides::default(),
            metadata: None,
            viewports: BTreeMap::new(),
            list_rows: BTreeMap::new(),
            layout,
            layout_nodes: Vec::new(),
            layout_dirty: BTreeSet::new(),
            rebuild_layout: true,
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
    #[cfg(feature = "native")]
    pub(crate) fn recording_lanes(
        model: M,
        lanes: L,
        options: WindowOptions,
        scale_factor: f32,
    ) -> Result<Self, Error> {
        Self::mount_lanes(model, lanes, options, false, scale_factor)
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
    pub fn set<T: 'static>(
        &mut self,
        source: Source<M, T>,
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
            match catch_unwind(AssertUnwindSafe(|| {
                source.validate_registered(&runtime.model, &runtime.sources)
            })) {
                Ok(result) => result?,
                Err(_) => {
                    runtime.poison();
                    return Err(Error::OwnerPanicked);
                }
            }
            runtime.operation(Some(source.id()), |model, _| {
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

    /// Test input still goes through admitted geometry and the ordinary hit path.
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
            .transform
            .get()
            .and_then(|map| {
                map.apply(Point {
                    x: node.rect.width * 0.5,
                    y: node.rect.height * 0.5,
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
        runtime.focus(target)?;
        runtime.activate(target)
    }
    pub fn click_at(&mut self, point: Point) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let Some(identity) = runtime.hit(point) else {
            runtime.focused = None;
            runtime.changed_nodes = 0;
            return Err(Error::NotHittable);
        };
        let target = runtime.sites.target(identity);
        runtime.focus(target)?;
        runtime.activate(target)
    }
    /// The editing floor inserts at the end; full selection/IME is a host/text
    /// layer. Character boundaries are preserved by the backspace operation.
    pub fn type_text(&mut self, target: Target, text: &str) -> Result<Commit, Error> {
        self.runtime_mut()?
            .edit_text(target, |value| value.push_str(text))
    }
    pub fn backspace(&mut self, target: Target) -> Result<Commit, Error> {
        self.runtime_mut()?.edit_text(target, |value| {
            value.pop();
        })
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
        for index in 0..runtime.presented.len() {
            let node = &runtime.presented[index];
            let identity = node.identity;
            // A destructor panic may interrupt destructive reconciliation.
            // The old sheet remains diagnostic; current addresses do not.
            let target = if runtime.logical_valid
                && !runtime.poisoned
                && let Some(&index) = runtime.by_identity.get(&identity)
                && (all_targets
                    || runtime.nodes[index].handler.is_some()
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
                    .transform
                    .get()
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
        )
    }
    pub fn set_property<T: PartialEq, D: crate::property::PropertyDomain>(
        &mut self,
        target: Target,
        property: Property<T, D>,
        contribution: Contribution<T>,
    ) -> Result<Commit, Error> {
        D::dispatch(
            property,
            (self, target, contribution),
            |(win, target, contribution), property| {
                win.set_style_property(target, property, contribution)
            },
            |(win, target, contribution), property| {
                win.set_geometry_property(target, property, contribution)
            },
        )
    }
    fn style_property<T>(&self, target: Target, property: Property<T>) -> Result<T, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        Ok(property.get(runtime.styles.get(runtime.by_identity[&identity])))
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
    /// A typed inspector contribution. Validation precedes editing; inheritance
    /// removes the contribution and reveals the latest component declaration.
    fn set_style_property<T: PartialEq>(
        &mut self,
        target: Target,
        property: Property<T>,
        contribution: Contribution<T>,
    ) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        let epoch = runtime
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        let index = runtime.by_identity[&identity];
        let before = *runtime.styles.get(index);
        let after = runtime
            .overrides
            .set(identity, before, property, contribution)?;
        runtime.source_epoch = epoch;
        runtime.counters.source_operations += 1;
        runtime.changed_nodes = usize::from(!styles::exact_eq(&before, &after));
        if !styles::exact_eq(&before, &after) {
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
        if runtime.has_lists() {
            runtime.describe(false)?;
        }
        runtime.present()
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
                    && runtime.by_identity.contains_key(&node.identity)
            })
            .map(|node| node.identity)
            .ok_or(Error::MissingElement)?;
        Ok(runtime.sites.target(identity))
    }
    /// CPU diagnostic rendering of the latest coherent commands. In recording
    /// mode this explicitly allocates the optional image, but never acknowledges
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
    #[cfg(any(feature = "native", test))]
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
        self.sites
            .resolve(target)
            .filter(|identity| {
                self.logical_valid
                    && self.by_identity.get(identity).is_some_and(|&index| {
                        !self.has_lists()
                            || !self.in_list(index)
                            || self
                                .prepared
                                .as_ref()
                                .map_or(self.presented.as_slice(), |p| p.rows(&self.presented))
                                .iter()
                                .any(|node| node.identity == *identity)
                    })
            })
            .ok_or(Error::StaleTarget)
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
    ) -> Result<(), Error> {
        let reuse_identities = self.logical_valid;
        self.counters.descriptions += 1;
        if !mount {
            self.counters.owner_reruns += 1;
        }
        let mut seen = BTreeSet::new();
        let crate::element::Description {
            nodes: drafts,
            viewports: viewport_drafts,
            annotations: annotation_drafts,
            images: image_drafts,
            geometry: geometry_drafts,
            style_ports,
        } = self.model.view().flatten_lists(
            MAX_NODES,
            readers,
            |id, style, source, row_height| {
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
            },
        )?;
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
        let mut depths = Vec::with_capacity(drafts.len());
        let mut fields = Vec::with_capacity(drafts.len());
        let mut component_scopes = Vec::with_capacity(drafts.len());
        let mut new_counts = vec![0usize; drafts.len() + 1];
        let mut fanout: BTreeMap<FieldId, Fanout> = BTreeMap::new();
        for (index, node) in drafts.iter().enumerate() {
            new_counts[node.parent.map_or(0, |parent| parent as usize + 1)] += 1;
            let depth = node.parent.map_or(0, |parent| depths[parent as usize] + 1);
            if depth > MAX_LAYOUT_DEPTH {
                return Err(Error::DepthLimit { node: index });
            }
            depths.push(depth);
            let mut component_scope = node
                .parent
                .map_or(0, |parent| component_scopes[parent as usize]);
            for boundary in node.components.iter() {
                let check = boundary
                    .check
                    .as_ref()
                    .expect("boundary check is installed");
                check.validate(&self.model, &self.sources)?;
                // Owning model ancestry is independent of visual parentage.
                component_scope = check.owner_scope(&self.model, &self.sources)?;
            }
            component_scopes.push(component_scope);
            if let Some(handler) = &node.on_click {
                handler.validate(&self.model, &self.sources)?;
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
                    .or_insert_with(|| Fanout {
                        codec,
                        destinations: Vec::new(),
                    })
                    .destinations
                    .push(Destination::new(index, Port::Visual));
            }
            fields.push(field);
        }
        for &(node, geometry) in &geometry_drafts {
            crate::property::CORNER_RADIUS
                .validate(&geometry.corner_radius)
                .map_err(|error| Error::GeometryProperty { node, error })?;
        }
        for draft in style_ports {
            if let Some(field) = self.sources.resolve(&self.model, draft.signal)? {
                fanout
                    .entry(field)
                    .or_insert_with(|| Fanout {
                        codec: draft.signal.codec(),
                        destinations: Vec::new(),
                    })
                    .destinations
                    .push(Destination::style(draft.node as usize, draft.property));
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
                    fanout
                        .entry(field)
                        .or_insert_with(|| Fanout {
                            codec,
                            destinations: Vec::new(),
                        })
                        .destinations
                        .push(Destination::new(
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
        // Promotion is lazy and shared by all changed ports of a registered
        // field in this description. Unchanged retained operands keep their Arc.
        let mut promotions: BTreeMap<FieldId, SharedText> = BTreeMap::new();
        for fanout in fanout.values_mut() {
            fanout
                .destinations
                .sort_unstable_by_key(|destination| destination.packed());
        }
        let old_styles = std::mem::take(&mut self.styles);
        let mut old = std::mem::take(&mut self.nodes)
            .into_iter()
            .map(Some)
            .collect::<Vec<_>>();
        let mut sites = BTreeMap::new();
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
        let mut old_counts: BTreeMap<Option<u64>, usize> = BTreeMap::new();
        for (index, node) in old.iter().enumerate() {
            let node = node.as_ref().unwrap();
            let parent = node
                .parent
                .index()
                .map(|parent| old[parent].as_ref().unwrap().identity());
            *old_counts.entry(parent).or_default() += 1;
            sites.insert((parent, node.ordinal, node.kind()), index);
            if let Some(row) = self
                .list_rows
                .get(&node.identity())
                .filter(|row| row.visible)
            {
                keyed_rows.insert((parent, row.key, node.kind()), index);
            }
            if let Some(&id) = old_list_ids.get(&node.identity()) {
                keyed_lists.insert((parent, id, node.kind()), index);
            }
        }
        let old_ids = old
            .iter()
            .map(|node| node.as_ref().unwrap().identity())
            .collect::<Vec<_>>();
        let mut styles = styles::Builder::new(drafts.len());
        let mut nodes: Vec<Node> = Vec::with_capacity(drafts.len());
        // Retain no holes or visited-site history. Moving TextSite transfers
        // its text lease and glyph Vec header without cloning either.
        let mut texts =
            Vec::with_capacity(drafts.iter().filter(|draft| draft.text.is_some()).count());
        let mut ordinals = vec![0u32; drafts.len() + 1];
        let mut changed = 0;
        for (index, draft) in drafts.into_iter().enumerate() {
            let parent = draft.parent.map(|parent| parent as usize);
            let ordinal_slot = parent.map_or(0, |parent| parent + 1);
            let ordinal = ordinals[ordinal_slot];
            ordinals[ordinal_slot] += 1;
            let parent_identity = parent.map(|parent| nodes[parent].identity());
            // A shape change invalidates the entire unkeyed run. Equal kinds
            // at shifted ordinals must not silently retarget an old capability.
            let run_survives = reuse_identities
                && old_counts.get(&parent_identity).copied().unwrap_or(0)
                    == new_counts[ordinal_slot];
            let previous_index = if let Some((_, row)) = row_indices.get(&index) {
                reuse_identities
                    .then(|| keyed_rows.get(&(parent_identity, row.key, draft.kind)))
                    .flatten()
            } else if let Some(&id) = list_indices.get(&index) {
                reuse_identities
                    .then(|| keyed_lists.get(&(parent_identity, id, draft.kind)))
                    .flatten()
            } else {
                run_survives
                    .then(|| sites.get(&(parent_identity, ordinal, draft.kind)))
                    .flatten()
            };
            let previous = previous_index
                .and_then(|&old_index| old[old_index].take())
                .filter(|node| node.component_scope == component_scopes[index]);
            let previous_style = if previous.is_some() {
                *old_styles.get(*previous_index.unwrap())
            } else {
                draft.style
            };
            let mut node_changed = previous.is_none();
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
                    parent: Parent::new(parent),
                    ordinal,
                    content: Content::new(draft.kind, TextSlot::NONE),
                    component_scope: component_scopes[index],
                    handler: None,
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
            let text = draft.text.as_ref().map(|text| text.borrowed_value());
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
            if node.handler.is_some() != draft.on_click.is_some() {
                // Eligibility is part of the published hit sheet even when
                // this transparent site's pixels and layout remain equal.
                self.dirty = true;
                node_changed = true;
            }
            node.parent = Parent::new(parent);
            node.ordinal = ordinal;
            styles.push(&style);
            node.handler = draft.on_click;
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
                Content::new(node.kind(), text_slot)
            };
            changed += usize::from(node_changed);
            nodes.push(node);
        }
        image::reconcile(&mut self.images, image_resources);
        changed += old.iter().filter(|node| node.is_some()).count();
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
        if !annotation_drafts.is_empty() || !viewports.is_empty() || self.metadata.is_some() {
            let metadata = self
                .metadata
                .get_or_insert_with(|| Box::new(Metadata::default()));
            let mut base = Vec::with_capacity(
                annotation_drafts
                    .iter()
                    .filter(|a| a.text.name.is_some() || a.text.description.is_some())
                    .count(),
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
            base.sort_unstable_by_key(|entry| entry.identity);
            metadata.base = base;
        }
        self.reconcile_geometry(&nodes, geometry_drafts);
        self.viewports = viewports;
        self.list_rows = list_rows;
        self.nodes = nodes;
        self.styles = styles.finish();
        self.texts = texts;
        self.fanout = fanout;
        self.by_identity = self
            .nodes
            .iter()
            .enumerate()
            .map(|(i, node)| (node.identity(), i))
            .collect();
        self.overrides
            .retain(|identity| self.by_identity.contains_key(&identity));
        if let Some(metadata) = &mut self.metadata {
            metadata
                .overrides
                .retain(|identity, _| self.by_identity.contains_key(identity));
            if let Some(geometry) = metadata.geometry.as_mut() {
                geometry.retain(|identity| self.by_identity.contains_key(&identity));
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
        let mut paint_edits = self.paint_begin(field);
        let mut paint_eligible = paint_edits.is_some();
        let Some(fanout) = self.fanout.get(&field) else {
            return Ok(PatchOutcome::Visual);
        };
        let mut needs = crate::source::Needs {
            text: false,
            style: false,
        };
        for destination in &fanout.destinations {
            if destination.port() == Port::Style {
                needs.style = true;
            } else {
                needs.text = true;
            }
        }
        self.counters.source_reads += 1;
        let frozen = self
            .sources
            .freeze(&self.model, field, fanout.codec, needs)?;
        // A numeric source may feed width, font size AND text. Reject every bad
        // sink before the first logical destination or inspector base is edited.
        for destination in &fanout.destinations {
            if let Some(id) = destination.property() {
                frozen.style.expect("style codec requested").admit(id)?;
            }
        }
        let mut promoted: Option<SharedText> = None;
        let mut semantic = false;
        let mut visual_changed = false;
        let mut last_changed = None;
        for (offset, &destination) in fanout.destinations.iter().enumerate() {
            self.counters.destination_compares += 1;
            let index = destination.node();
            let node = &self.nodes[index];
            let identity = node.identity();
            let changed = if let Some(id) = destination.property() {
                let value = frozen.style.expect("style codec requested").admit(id)?;
                let changed = match id.info().destination {
                    crate::property::PropertyDestination::Style => {
                        let before = *self.styles.get(index);
                        let after = self.overrides.update_base(identity, before, id, value)?;
                        let changed = !styles::exact_eq(&before, &after);
                        if changed {
                            if let Some(plan) = &mut paint_edits {
                                let before_color = if id == crate::property::PropertyId::Background
                                {
                                    before.bg
                                } else {
                                    before.fg
                                };
                                let color = if id == crate::property::PropertyId::Background {
                                    after.bg
                                } else {
                                    after.fg
                                };
                                paint_eligible &=
                                    before_color.alpha().to_bits() == color.alpha().to_bits();
                                let cursor = self
                                    .metadata
                                    .as_ref()
                                    .unwrap()
                                    .paint
                                    .as_ref()
                                    .unwrap()
                                    .index(plan, offset)
                                    .unwrap();
                                if let Some(index) = self.canvas.paint_index(cursor) {
                                    plan.edits.push(gpui_canvas::PaintEdit::new(index, color));
                                }
                            }
                            if id.info().impact == crate::property::Impact::Layout {
                                self.layout_dirty.insert(identity);
                            }
                            if id == crate::property::PropertyId::FontSize
                                && let Some(text) = node.text_slot().get_mut(&mut self.texts)
                            {
                                text.shaped = None;
                            }
                            self.styles.set(index, after, self.nodes.len());
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
        if let Some(edits) = paint_edits
            && self.paint_finish(edits, paint_eligible, visual_changed)?
        {
            return Ok(PatchOutcome::Complete);
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
                self.text = None;
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
        image::acknowledge(&mut self.images, token.sequence);
        let prepared = self.prepared.take();
        let newly_presented = prepared.is_some() || !self.presentation_valid;
        if let Some(prepared) = prepared {
            self.presentation_size = prepared.dimensions();
            if !prepared.keeps_rows() {
                self.presented = prepared.nodes;
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
        if self.metadata.as_deref().is_some_and(Metadata::unused) {
            self.metadata = None;
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
            Some(if self.automatic_presentation {
                Canvas::with_color_config(size[0], size[1], self.canvas.color_config())?
            } else {
                Canvas::recording(size[0], size[1], self.canvas.color_config())?
            })
        } else {
            None
        };
        let prepared_size = [
            u16::try_from(size[0]).map_err(|_| gpui_canvas::Error::InvalidDimensions)?,
            u16::try_from(size[1]).map_err(|_| gpui_canvas::Error::InvalidDimensions)?,
        ];
        if self.text.is_none() && !self.texts.is_empty() {
            self.text = Some(TextSystem::bundled()?);
        }
        // One immutable parser for every measurement and final line layout in
        // this pass. A single face lease lets the raster cache remain mutable;
        // neither a string nor a glyph increments its reference count.
        let font = self.text.as_ref().map(|text| text.font_face().clone());
        let mut shaper = font.as_ref().map(|font| font.shaper());
        if self.rebuild_layout || self.topology_changed || self.layout.is_poisoned() {
            self.layout = LayoutTree::new();
            self.layout_nodes.clear();
            for (index, node) in self.nodes.iter().enumerate() {
                let parent = node.parent.index().map(|parent| self.layout_nodes[parent]);
                let id = self.layout.insert(
                    parent,
                    gpui_reactivity_core::NodeKind::Element,
                    list::row_style(
                        node.kind(),
                        self.styles.get(index),
                        node.parent.index().map(|index| self.styles.get(index).flow),
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
                let index = self.by_identity[&identity];
                if self.nodes[index].parent.index().is_some_and(|parent| {
                    self.layout_dirty.contains(&self.nodes[parent].identity())
                }) {
                    self.layout_dirty.insert(identity);
                }
            }
            for identity in &self.layout_dirty {
                let index = self.by_identity[identity];
                let id = self.layout_nodes[index];
                self.layout.set_style(
                    id,
                    list::row_style(
                        self.nodes[index].kind(),
                        self.styles.get(index),
                        self.nodes[index]
                            .parent
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
        let mut measure = |id: NodeId, input: MeasureInput| {
            let width = input
                .known_dimensions
                .width
                .or(match input.available_space.width {
                    AvailableSpace::Definite(width) => Some(width),
                    AvailableSpace::MinContent => Some(f32::MIN_POSITIVE),
                    AvailableSpace::MaxContent => None,
                });
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
            match node.text_slot().get_mut(texts).unwrap().shape(
                service,
                styles.get(index).font_size,
                width,
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
        self.layout.compute_with(
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
        let viewport = Rect::new(0.0, 0.0, size[0] as f32, size[1] as f32);
        let mut presented: Vec<Presented> = Vec::with_capacity(self.nodes.len());
        let mut spaces: Vec<CoordinateSpace> = Vec::with_capacity(self.nodes.len());
        let list_mode = !self.viewports.is_empty();
        let list_capacity = if list_mode { self.nodes.len() } else { 0 };
        let mut clips: Vec<Rect> = Vec::with_capacity(list_capacity);
        let mut hit_clips: Vec<Rect> = Vec::with_capacity(list_capacity);
        let mut clip_membership: Vec<u8> = Vec::with_capacity(list_capacity);
        let mut published: Vec<Parent> = Vec::with_capacity(list_capacity);
        let mut visible_rows = BTreeSet::new();
        let mut metadata_sheet = self.metadata_sheet();
        let image_leases = self
            .images
            .as_ref()
            .map(|images| images.candidate())
            .transpose()?;
        let viewport_geometry = if list_mode {
            scroll::geometry(self, &mut spaces, &mut published)?
        } else {
            scroll::ViewportBuild::default()
        };
        #[cfg(feature = "accessibility")]
        let base_stamp = self.semantic_stamp();
        #[cfg(feature = "accessibility")]
        let mut observation = self
            .accessibility
            .as_mut()
            .map(|observer| observer.begin(base_stamp, size));
        let mut paint_bindings = paint::Build::new(&self.fanout);
        let mut scene = replacement.as_mut().unwrap_or(&mut self.canvas).stage();
        scene.clear(Color::WHITE);
        self.counters.paint_passes += 1;
        for index in 0..self.nodes.len() {
            let layout = self.layout.layout(self.layout_nodes[index])?;
            let has_children = self
                .nodes
                .get(index + 1)
                .is_some_and(|child| child.parent.index() == Some(index));
            let style = self.styles.get(index);
            let parent_is_viewport = self.nodes[index].parent.index().is_some_and(|parent| {
                matches!(self.nodes[parent].kind(), NodeKind::List | NodeKind::Scroll)
            });
            let parent_identity = self.nodes[index]
                .parent
                .index()
                .map(|parent| self.nodes[parent].identity());
            let radius = self
                .metadata
                .as_ref()
                .and_then(|m| m.geometry.as_ref())
                .map_or(0.0, |g| g.get(self.nodes[index].identity()).corner_radius);
            let node = &mut self.nodes[index];
            let parent = node.parent.index().map_or(
                CoordinateSpace::new(Affine::scale(scale_factor, scale_factor)),
                |parent| {
                    let base = spaces[parent];
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
            spaces.push(space);
            let [a, b, c, d, tx, ty] = space.coefficients().map(|value| value as f32);
            let candidate = Affine { a, b, c, d, tx, ty };
            let transform =
                (space.is_invertible() && candidate.is_finite() && candidate.is_invertible())
                    .then_some(candidate);
            let rect = Rect::new(0.0, 0.0, layout.size.width, layout.size.height);
            let (mut clip, mut hit_clip, in_list) = if list_mode {
                (
                    node.parent.index().map_or(viewport, |parent| clips[parent]),
                    node.parent
                        .index()
                        .map_or(viewport, |parent| hit_clips[parent]),
                    node.kind() == NodeKind::ListItem
                        || node
                            .parent
                            .index()
                            .is_some_and(|parent| clip_membership[parent] & 1 != 0),
                )
            } else {
                (viewport, viewport, false)
            };
            let in_scroll = node.kind() == NodeKind::Scroll
                || node.parent.index().is_some_and(|parent| {
                    clip_membership
                        .get(parent)
                        .is_some_and(|flags| flags & 2 != 0)
                });
            if list_mode {
                clip_membership.push(u8::from(in_list) | (u8::from(in_scroll) << 1));
            }
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
            if list_mode {
                clips.push(clip);
                hit_clips.push(hit_clip);
            }
            let raw_bounds = transform
                .and_then(|map| CoordinateSpace::new(map).bounds(rect))
                .unwrap_or_default();
            let bounds = if in_list || in_scroll || node.kind() == NodeKind::List {
                list::clipped_bounds(raw_bounds, hit_clip)
            } else {
                raw_bounds.intersection(viewport)
            };
            let paint = !in_scroll || !bounds.is_empty();
            let bg_cursor = scene.paint_cursor();
            if paint && style.bg.alpha() > 0.0 {
                scene.fill_rounded_rect(
                    rect,
                    radius,
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    clip,
                    style.bg,
                )?;
            } else if paint && (node.handler.is_some() || node.kind() == NodeKind::Input) {
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
            let bg_index = scene.paint_index(bg_cursor);
            let fg_cursor = scene.paint_cursor();
            if paint && let Some(text) = node.text_slot().get_mut(&mut self.texts) {
                let fg = style.fg;
                let service = self.text.as_mut().expect("text initialized before layout");
                let shape = text.shape(
                    shaper.as_mut().expect("text initialized before layout"),
                    style.font_size,
                    Some(layout.content_box_width()),
                )?;
                scene.draw_text_scaled(
                    service,
                    shape,
                    Point {
                        x: layout.padding.left,
                        y: layout.padding.top,
                    },
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    clip,
                    fg,
                    scale_factor,
                )?;
            }
            if let Some(bindings) = &mut paint_bindings {
                bindings.capture(index, bg_index, scene.paint_index(fg_cursor));
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
            let published_parent = if list_mode {
                node.parent
                    .index()
                    .map_or(Parent::NONE, |parent| published[parent])
            } else {
                node.parent
            };
            if in_list
                && bounds.is_empty()
                && (!has_children || hit_clip.is_empty())
                && (!in_scroll || hit_clip.is_empty())
            {
                published.push(published_parent);
                continue;
            }
            if node.kind() == NodeKind::ListItem {
                visible_rows.insert(node.identity());
            }
            if list_mode {
                published.push(Parent::new(Some(presented.len())));
            }
            // Empty bounds can never pass sheet_hit, including wheel routing.
            // Keep the existing byte as the common-path candidate test; loading
            // and decoding the parent word is needed only to skip a cold run.
            let hittable = !bounds.is_empty()
                && (node.text_slot().0 != u32::MAX
                    || style.bg.alpha() > 0.0
                    || node.handler.is_some()
                    || matches!(node.kind(), NodeKind::Input | NodeKind::Image));
            let link = PresentedLink::new(
                published_parent,
                !hittable,
                presented.last().map(|node: &Presented| node.parent),
            );
            presented.push(Presented {
                identity: node.identity(),
                parent: link,
                kind: node.kind(),
                text: node
                    .text_slot()
                    .get(&self.texts)
                    .map(|text| text.value.clone()),
                rect,
                transform: PresentedTransform::new(transform),
                bounds,
                hittable,
                actions: Actions::for_node(node.kind(), node.handler.is_some()).scroll_into_view(
                    node.parent.index().is_some_and(|parent| {
                        clip_membership.get(parent).is_some_and(|flags| *flags != 0)
                    }) || parent_is_viewport,
                ),
            });
            #[cfg(feature = "accessibility")]
            if let Some(observation) = &mut observation {
                let index = presented.len() - 1;
                observation.compare(
                    index,
                    self.presented.get(index),
                    &presented[index],
                    self.metadata.as_deref(),
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
                geometry.freeze(|identity| {
                    !list_mode
                        || logical_indices
                            .get(&identity)
                            .and_then(|&index| published.get(index))
                            .and_then(|entry| entry.index())
                            .and_then(|index| presented.get(index))
                            .is_some_and(|node| node.identity == identity)
                })
            });
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
            // row clipping can omit a declared viewport; the existing logical
            // to published scratch proves exact admitted identity without a map.
            sheet.viewports = viewport_geometry.freeze(|identity| {
                let index = self.by_identity[&identity];
                published[index]
                    .index()
                    .filter(|&index| presented[index].identity == identity)
            });
            metadata.candidate = Some(sheet);
        }
        if let Some(column) = geometry_sheet {
            self.metadata
                .as_mut()
                .unwrap()
                .geometry
                .as_mut()
                .unwrap()
                .prepare(column);
        }
        if let Some(leases) = image_leases {
            self.images.as_mut().unwrap().prepare(sequence, leases);
        }
        if let Some(bindings) = paint_bindings {
            self.metadata
                .get_or_insert_with(|| Box::new(Metadata::default()))
                .paint = Some(bindings.finish());
        } else if let Some(metadata) = &mut self.metadata {
            metadata.paint = None;
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
        if self.texts.is_empty() {
            self.text = None;
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
    fn hit(&self, point: Point) -> Option<u64> {
        if !Rect::new(
            0.0,
            0.0,
            self.presentation_size[0] as f32,
            self.presentation_size[1] as f32,
        )
        .contains(point)
        {
            return None;
        }
        let mut rows = self.presented.iter().enumerate().rev();
        while let Some((index, node)) = rows.next() {
            if !node.hittable {
                let skip = node.parent.skip();
                // This row is consumed. nth discards the rest of the run in
                // constant time without indexing the visible-path traversal.
                if skip > 1 {
                    rows.nth(skip - 2);
                }
                continue;
            }
            if self.sheet_hit(index, point) {
                let mut cursor = Some(index);
                while let Some(index) = cursor {
                    let node = &self.presented[index];
                    if let Some(&logical) = self.by_identity.get(&node.identity)
                        && (self.nodes[logical].handler.is_some() || node.kind == NodeKind::Input)
                    {
                        return Some(node.identity);
                    }
                    cursor = node.parent.index();
                }
                return None;
            }
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
    cephal::Style {
        display: Display::Flex,
        size: Size {
            width: style.width.map_or(Dimension::AUTO, Dimension::length),
            height: style.height.map_or(Dimension::AUTO, Dimension::length),
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{div, text};

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
        let glyphs = first.shaped.as_ref().unwrap().layout.glyphs().as_ptr();
        win.reset_counters().unwrap();
        win.update(|_| {}).unwrap();
        let first = win.runtime().unwrap().texts[0].as_ref().unwrap();
        assert!(std::ptr::eq(value, SharedText::as_ptr(&first.value)));
        assert_eq!(
            glyphs,
            first.shaped.as_ref().unwrap().layout.glyphs().as_ptr()
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
    fn text_width_cache_preserves_keys_and_replaces_only_after_success() {
        let system = TextSystem::bundled().unwrap();
        let mut shaper = system.font_face().shaper();
        let mut site = TextSite {
            value: SharedText::from("alpha beta gamma"),
            field: None,
            shaped: None,
        };
        let wide = site.shape(&mut shaper, 16.0, Some(140.0)).unwrap().height;
        let narrow = site.shape(&mut shaper, 16.0, Some(40.0)).unwrap().height;
        assert!(narrow > wide);
        let pointer = site.shaped.as_ref().unwrap().layout.glyphs().as_ptr();
        site.shape(&mut shaper, 16.0, Some(40.0)).unwrap();
        assert_eq!(
            pointer,
            site.shaped.as_ref().unwrap().layout.glyphs().as_ptr()
        );
        assert_eq!(site.shaped.as_ref().unwrap().width, Some(40.0f32.to_bits()));
        site.shape(&mut shaper, 16.0, None).unwrap();
        assert_eq!(site.shaped.as_ref().unwrap().width, None);
        site.shape(&mut shaper, 16.0, Some(-0.0)).unwrap();
        assert_eq!(
            site.shaped.as_ref().unwrap().width,
            Some(f32::MIN_POSITIVE.to_bits())
        );
        site.value = SharedText::from("漢");
        site.shaped = None;
        assert!(site.shape(&mut shaper, 16.0, Some(40.0)).is_err());
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
        assert_eq!(size_of::<Node>(), 40);
        assert_eq!(size_of::<Prepared>(), 40);
        assert_eq!(size_of::<Presented>(), 80);
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
                .map(|fanout| fanout.destinations.capacity() * size_of::<Destination>())
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
                Contribution::Set(Some(30.0)),
            )
            .unwrap();
            let before = win.runtime().unwrap().styles.get(index).to_owned();
            assert!(win.set(Panel::NUMBER, 0.0).is_err());
            let runtime = win.runtime().unwrap();
            assert!(styles::exact_eq(runtime.styles.get(index), &before));
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
            assert_eq!(lower.width, Some(24.0));
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
                    .map(|fanout| fanout.destinations.capacity() * size_of::<Destination>())
                    .sum::<usize>()
            );
            assert_eq!(
                runtime
                    .fanout
                    .values()
                    .map(|fanout| fanout.destinations.len())
                    .sum::<usize>(),
                ports
            );
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
        assert_eq!(size_of::<Node>(), 40);
        assert_eq!(size_of::<Presented>(), 80);
        assert_eq!(size_of::<crate::El<'_>>(), 176);
        assert_eq!(size_of::<crate::element::DraftNode<'_>>(), 152);
        assert_eq!(size_of::<Style>(), 88);
        assert_eq!(size_of::<Fanout>(), 32);
        assert_eq!(size_of::<Destination>(), 4);
    }
}
