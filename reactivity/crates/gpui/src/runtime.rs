//! One serial owner turn, a retained logical description, and an admitted sheet.
//! Layout is private scratch; the canvas stages commands without another output
//! framebuffer. Public callbacks never run through an active owner borrow.
use std::{
    cell::{RefCell, RefMut},
    collections::{BTreeMap, BTreeSet},
    panic::{AssertUnwindSafe, catch_unwind},
    rc::Rc,
};

use gpui_canvas::{Canvas, ColorConfig, TextLayout, TextSystem};
use gpui_reactivity_core::{
    Affine, CoordinateSpace, NodeId, Point, Rect,
    layout::{AvailableSpace, LayoutError, LayoutTree, MeasureInput, MeasureOutput, Size},
};
use serde::Serialize;

use crate::{
    Target, View,
    element::{Handler, NodeKind},
    identity::Sites,
    source::{BindError, FieldId, Source, Sources, TextCodec, TextEditError},
    style::{Color, Flow, Style},
};

const MAX_NODES: usize = 100_000;
// Cephal's algorithms recurse even though public description disposal does not.
const MAX_LAYOUT_DEPTH: usize = 128;

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct WindowOptions {
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
    Borrowed,
    Poisoned,
    OwnerPanicked,
    PresentationPanicked,
    StaleTarget,
    PresentationStale,
    NotInteractive,
    NotInput,
    NotHittable,
    MissingElement,
    UnregisteredInput { node: usize },
    DepthLimit { node: usize },
    ResourceLimit,
    EpochExhausted,
    Binding(BindError),
    TextEdit(TextEditError),
    Layout(LayoutError),
    Canvas(gpui_canvas::Error),
    Serialization(String),
}
impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for Error {}
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

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize)]
pub struct Commit {
    pub source_epoch: u64,
    /// Source epoch described by the complete displayed sheet.
    pub presentation_epoch: u64,
    pub changed_nodes: usize,
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
    pub size: [u32; 2],
    pub poisoned: bool,
    pub nodes: Vec<SnapshotNode>,
}
impl Snapshot {
    pub fn to_json(&self) -> Result<String, Error> {
        serde_json::to_string(self).map_err(|error| Error::Serialization(error.to_string()))
    }
}

struct Shaped {
    width: Option<u32>,
    layout: TextLayout,
}
struct Node {
    identity: u64,
    parent: Option<usize>,
    ordinal: u32,
    kind: NodeKind,
    text: Option<Rc<str>>,
    field: Option<FieldId>,
    style: Style,
    handler: Option<Handler>,
    shaped: Option<Shaped>,
}
impl Node {
    fn shape<'n>(
        &'n mut self,
        service: &TextSystem,
        width: Option<f32>,
    ) -> Result<&'n TextLayout, Error> {
        let width = width.map(|value| value.max(f32::MIN_POSITIVE));
        let key = width.map(f32::to_bits);
        if self.shaped.as_ref().is_none_or(|shape| shape.width != key) {
            let layout = service.shape(
                self.text.as_deref().unwrap_or(""),
                self.style.font_size,
                width,
            )?;
            self.shaped = Some(Shaped { width: key, layout });
        }
        Ok(&self.shaped.as_ref().unwrap().layout)
    }
}
struct Fanout {
    codec: TextCodec,
    destinations: Vec<usize>,
}
struct Presented {
    identity: u64,
    parent: Option<usize>,
    kind: NodeKind,
    text: Option<Rc<str>>,
    rect: Rect,
    transform: Option<Affine>,
    bounds: Rect,
    hittable: bool,
}
struct Runtime<M> {
    model: M,
    sources: Sources<M>,
    nodes: Vec<Node>,
    by_identity: BTreeMap<u64, usize>,
    fanout: BTreeMap<FieldId, Fanout>,
    next_identity: u64,
    sites: Sites,
    layout: LayoutTree,
    layout_nodes: Vec<NodeId>,
    layout_dirty: BTreeSet<u64>,
    rebuild_layout: bool,
    topology_changed: bool,
    logical_valid: bool,
    dirty: bool,
    source_epoch: u64,
    presentation_epoch: u64,
    presented: Vec<Presented>,
    canvas: Canvas,
    text: Option<TextSystem>,
    poisoned: bool,
    counters: Counters,
    changed_nodes: usize,
}

/// A scope-owned serial window runtime. Every input adapter uses these same
/// operations. `demo` is the convenient headless constructor, with real pixels.
pub struct Win<M: View + 'static> {
    inner: RefCell<Runtime<M>>,
}

impl<M: View + 'static> Win<M> {
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
        let sources =
            catch_unwind(AssertUnwindSafe(M::sources)).map_err(|_| Error::OwnerPanicked)?;
        let mut runtime = Runtime {
            model,
            sources,
            nodes: Vec::new(),
            by_identity: BTreeMap::new(),
            fanout: BTreeMap::new(),
            next_identity: 1,
            sites: Sites::new(),
            layout: LayoutTree::new(),
            layout_nodes: Vec::new(),
            layout_dirty: BTreeSet::new(),
            rebuild_layout: true,
            topology_changed: true,
            logical_valid: false,
            dirty: true,
            source_epoch: 0,
            presentation_epoch: 0,
            presented: Vec::new(),
            canvas: Canvas::with_color_config(options.size[0], options.size[1], options.colors)?,
            text: None,
            poisoned: false,
            counters: Counters::default(),
            changed_nodes: 0,
        };
        runtime.describe(true)?;
        runtime.present()?;
        Ok(Self {
            inner: RefCell::new(runtime),
        })
    }
    fn borrow(&self) -> Result<RefMut<'_, Runtime<M>>, Error> {
        self.inner.try_borrow_mut().map_err(|_| Error::Borrowed)
    }

    /// Arbitrary model edits conservatively refresh snapshots and structure.
    pub fn update(&self, edit: impl FnOnce(&mut M)) -> Result<Commit, Error> {
        self.borrow()?.operation(None, |model, _| {
            edit(model);
            Ok(())
        })
    }
    pub fn set<T: 'static>(&self, source: Source<M, T>, value: T) -> Result<Commit, Error> {
        let mut runtime = self.borrow()?;
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
            source.modify(model, |old| *old = value)?;
            Ok(())
        })
    }
    /// Position-free semantic activation validates the current logical target.
    pub fn activate(&self, target: Target) -> Result<Commit, Error> {
        self.borrow()?.activate(target)
    }

    /// Test input still goes through admitted geometry and the ordinary hit path.
    pub fn click(&self, target: Target) -> Result<Commit, Error> {
        let mut runtime = self.borrow()?;
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
            .and_then(|map| {
                map.apply(Point {
                    x: node.rect.width * 0.5,
                    y: node.rect.height * 0.5,
                })
            })
            .ok_or(Error::NotHittable)?;
        let hit = runtime.hit(point).ok_or(Error::NotHittable)?;
        if hit != identity {
            return Err(Error::NotHittable);
        }
        runtime.activate(target)
    }
    pub fn click_at(&self, point: Point) -> Result<Commit, Error> {
        let mut runtime = self.borrow()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let identity = runtime.hit(point).ok_or(Error::NotHittable)?;
        let target = runtime.sites.target(identity);
        runtime.activate(target)
    }
    /// The editing floor inserts at the end; full selection/IME is a host/text
    /// layer. Character boundaries are preserved by the backspace operation.
    pub fn type_text(&self, target: Target, text: &str) -> Result<Commit, Error> {
        self.borrow()?
            .edit_text(target, |value| value.push_str(text))
    }
    pub fn backspace(&self, target: Target) -> Result<Commit, Error> {
        self.borrow()?.edit_text(target, |value| {
            value.pop();
        })
    }
    /// Retry a pending presentation, or do zero description/layout/paint work.
    pub fn settle(&self) -> Result<Commit, Error> {
        let mut runtime = self.borrow()?;
        runtime.live()?;
        runtime.changed_nodes = 0;
        if !runtime.logical_valid {
            runtime.describe(false)?;
        }
        runtime.present()
    }
    pub fn with_model<R>(&self, read: impl FnOnce(&M) -> R) -> Result<R, Error> {
        let runtime = self.inner.try_borrow().map_err(|_| Error::Borrowed)?;
        Ok(read(&runtime.model))
    }
    pub fn counters(&self) -> Counters {
        self.inner
            .try_borrow()
            .expect("window is in an owner turn")
            .counters
    }
    pub fn reset_counters(&self) -> Result<(), Error> {
        self.borrow()?.counters = Counters::default();
        Ok(())
    }
    pub fn snapshot(&self) -> Result<Snapshot, Error> {
        let mut runtime = self.borrow()?;
        let mut nodes = Vec::with_capacity(runtime.presented.len());
        for index in 0..runtime.presented.len() {
            let node = &runtime.presented[index];
            let actionable = runtime.by_identity.get(&node.identity).is_some_and(|&i| {
                runtime.nodes[i].handler.is_some() || runtime.nodes[i].kind == NodeKind::Input
            });
            let identity = node.identity;
            let mut snapshot = SnapshotNode {
                identity,
                parent: node.parent,
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
                    .map(|map| [map.a, map.b, map.c, map.d, map.tx, map.ty]),
                target: None,
            };
            if actionable && runtime.logical_valid && !runtime.poisoned {
                snapshot.target = Some(runtime.sites.target(identity));
            }
            nodes.push(snapshot);
        }
        Ok(Snapshot {
            source_epoch: runtime.source_epoch,
            presentation_epoch: runtime.presentation_epoch,
            size: [runtime.canvas.width(), runtime.canvas.height()],
            poisoned: runtime.poisoned,
            nodes,
        })
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
        let mut runtime = self.borrow()?;
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
    pub fn with_pixels<R>(&self, read: impl FnOnce(&[u8], u32, u32) -> R) -> Result<R, Error> {
        let mut runtime = self.borrow()?;
        let (width, height) = (runtime.canvas.width(), runtime.canvas.height());
        Ok(read(runtime.canvas.pixels(), width, height))
    }
    pub fn scene_digest(&self) -> Result<u64, Error> {
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
        let runtime = self.inner.try_borrow().map_err(|_| Error::Borrowed)?;
        serde_json::to_string(&runtime.model)
            .map_err(|error| Error::Serialization(error.to_string()))
    }
    pub fn from_json(input: &str) -> Result<Self, Error>
    where
        M: serde::de::DeserializeOwned,
    {
        let model =
            serde_json::from_str(input).map_err(|error| Error::Serialization(error.to_string()))?;
        Self::new(model)
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
            .filter(|identity| self.logical_valid && self.by_identity.contains_key(identity))
            .ok_or(Error::StaleTarget)
    }
    fn current_presentation(&self) -> Result<(), Error> {
        if self.logical_valid && self.source_epoch == self.presentation_epoch {
            Ok(())
        } else {
            Err(Error::PresentationStale)
        }
    }
    fn poison(&mut self) {
        self.poisoned = true;
        self.logical_valid = false;
        self.sites.revoke();
    }
    fn operation(
        &mut self,
        exact: Option<FieldId>,
        edit: impl FnOnce(&mut M, &Sources<M>) -> Result<(), Error>,
    ) -> Result<Commit, Error> {
        self.live()?;
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        match catch_unwind(AssertUnwindSafe(|| edit(&mut self.model, &self.sources))) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        }
        self.source_epoch = epoch;
        self.counters.source_operations += 1;
        self.changed_nodes = 0;
        self.after_source(exact)
    }
    fn after_source(&mut self, exact: Option<FieldId>) -> Result<Commit, Error> {
        let exact = match exact {
            Some(field) if self.logical_valid && !self.sources.invalidates_owner(field)? => {
                Some(field)
            }
            _ => None,
        };
        let result = match exact {
            Some(field) => {
                self.counters.exact_updates += 1;
                match catch_unwind(AssertUnwindSafe(|| self.patch(field))) {
                    Ok(result) => result,
                    Err(_) => {
                        self.poison();
                        Err(Error::OwnerPanicked)
                    }
                }
            }
            None => {
                self.counters.coarse_updates += 1;
                self.describe(false)
            }
        };
        if let Err(error) = result {
            self.logical_valid = false;
            self.sites.revoke();
            return Err(error);
        }
        self.present()
    }
    fn activate(&mut self, target: Target) -> Result<Commit, Error> {
        self.live()?;
        let identity = self.resolve(target)?;
        let index = self.by_identity[&identity];
        if self.nodes[index].kind == NodeKind::Input {
            self.changed_nodes = 0;
            return Ok(self.commit());
        }
        let handler = self.nodes[index]
            .handler
            .as_ref()
            .ok_or(Error::NotInteractive)?;
        let exact = match catch_unwind(AssertUnwindSafe(|| {
            handler.validate(&self.model, &self.sources)
        })) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        match catch_unwind(AssertUnwindSafe(|| handler.invoke(&mut self.model))) {
            Ok(true) => {}
            Ok(false) => return Err(BindError::ReceiverMismatch.into()),
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        }
        self.source_epoch = epoch;
        self.counters.source_operations += 1;
        self.changed_nodes = 0;
        self.after_source(exact)
    }
    fn edit_text(
        &mut self,
        target: Target,
        edit: impl FnOnce(&mut String),
    ) -> Result<Commit, Error> {
        self.live()?;
        let identity = self.resolve(target)?;
        let node = &self.nodes[self.by_identity[&identity]];
        if node.kind != NodeKind::Input {
            return Err(Error::NotInput);
        }
        let field = node.field.ok_or(Error::UnregisteredInput {
            node: self.by_identity[&identity],
        })?;
        let codec = self.fanout[&field].codec;
        let mut input = match catch_unwind(AssertUnwindSafe(|| {
            self.sources
                .read_text(&self.model, field, codec)
                .map(|text| text.into_owned())
        })) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        edit(&mut input);
        self.operation(Some(field), move |model, sources| {
            sources.write_text(model, field, input, codec)?;
            Ok(())
        })
    }
    fn describe(&mut self, mount: bool) -> Result<(), Error> {
        match catch_unwind(AssertUnwindSafe(|| self.describe_inner(mount))) {
            Ok(Ok(())) => Ok(()),
            Ok(Err(error)) => {
                self.logical_valid = false;
                self.sites.revoke();
                Err(error)
            }
            Err(_) => {
                self.poison();
                Err(Error::OwnerPanicked)
            }
        }
    }
    fn describe_inner(&mut self, mount: bool) -> Result<(), Error> {
        self.sources.validate(&mut self.model)?;
        self.counters.descriptions += 1;
        if !mount {
            self.counters.owner_reruns += 1;
        }
        let drafts = self.model.view().flatten();
        if drafts.len() > MAX_NODES {
            return Err(Error::ResourceLimit);
        }
        self.next_identity
            .checked_add(drafts.len() as u64)
            .ok_or(Error::EpochExhausted)?;
        let mut depths = Vec::with_capacity(drafts.len());
        let mut fields = Vec::with_capacity(drafts.len());
        let mut new_counts = vec![0usize; drafts.len() + 1];
        let mut fanout: BTreeMap<FieldId, Fanout> = BTreeMap::new();
        for (index, node) in drafts.iter().enumerate() {
            new_counts[node.parent.map_or(0, |parent| parent as usize + 1)] += 1;
            let depth = node.parent.map_or(0, |parent| depths[parent as usize] + 1);
            if depth > MAX_LAYOUT_DEPTH {
                return Err(Error::DepthLimit { node: index });
            }
            depths.push(depth);
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
                    .push(index);
            }
            fields.push(field);
        }
        let mut old = std::mem::take(&mut self.nodes)
            .into_iter()
            .map(Some)
            .collect::<Vec<_>>();
        let mut sites = BTreeMap::new();
        let mut old_counts: BTreeMap<Option<u64>, usize> = BTreeMap::new();
        for (index, node) in old.iter().enumerate() {
            let node = node.as_ref().unwrap();
            let parent = node
                .parent
                .map(|parent| old[parent].as_ref().unwrap().identity);
            *old_counts.entry(parent).or_default() += 1;
            sites.insert((parent, node.ordinal, node.kind), index);
        }
        let old_ids = old
            .iter()
            .map(|node| node.as_ref().unwrap().identity)
            .collect::<Vec<_>>();
        let mut nodes: Vec<Node> = Vec::with_capacity(drafts.len());
        let mut ordinals = vec![0u32; drafts.len() + 1];
        let mut changed = 0;
        for (index, draft) in drafts.into_iter().enumerate() {
            let parent = draft.parent.map(|parent| parent as usize);
            let ordinal_slot = parent.map_or(0, |parent| parent + 1);
            let ordinal = ordinals[ordinal_slot];
            ordinals[ordinal_slot] += 1;
            let parent_identity = parent.map(|parent| nodes[parent].identity);
            // A shape change invalidates the entire unkeyed run. Equal kinds
            // at shifted ordinals must not silently retarget an old capability.
            let run_survives =
                old_counts.get(&parent_identity).copied().unwrap_or(0) == new_counts[ordinal_slot];
            let previous = run_survives
                .then(|| sites.get(&(parent_identity, ordinal, draft.kind)))
                .flatten()
                .and_then(|&old_index| old[old_index].take());
            let mut node_changed = previous.is_none();
            let mut node = if let Some(node) = previous {
                node
            } else {
                let identity = self.next_identity;
                self.next_identity += 1;
                self.layout_dirty.insert(identity);
                Node {
                    identity,
                    parent,
                    ordinal,
                    kind: draft.kind,
                    text: None,
                    field: None,
                    style: draft.style,
                    handler: None,
                    shaped: None,
                }
            };
            let text = draft.text.as_ref().map(|text| text.borrowed_value());
            self.counters.destination_compares += 1;
            if node.text.as_deref() != text.as_deref() {
                node.text = text.as_deref().map(|text| {
                    self.counters.text_promotions += 1;
                    self.counters.text_bytes_copied += text.len() as u64;
                    Rc::from(text)
                });
                node.shaped = None;
                self.layout_dirty.insert(node.identity);
                self.dirty = true;
                node_changed = true;
            }
            if node.style != draft.style {
                self.dirty = true;
                node_changed = true;
            }
            if layout_changed(node.style, draft.style) {
                self.layout_dirty.insert(node.identity);
            }
            if node.style.font_size != draft.style.font_size {
                node.shaped = None;
            }
            if node.handler.is_some() != draft.on_click.is_some() {
                // Eligibility is part of the published hit sheet even when
                // this transparent site's pixels and layout remain equal.
                self.dirty = true;
                node_changed = true;
            }
            node.parent = parent;
            node.ordinal = ordinal;
            node.style = draft.style;
            node.field = fields[index];
            node.handler = draft.on_click;
            changed += usize::from(node_changed);
            nodes.push(node);
        }
        changed += old.iter().filter(|node| node.is_some()).count();
        let topology = old_ids.len() != nodes.len()
            || old_ids
                .iter()
                .zip(&nodes)
                .any(|(old, new)| *old != new.identity);
        self.topology_changed |= topology;
        self.dirty |= topology;
        self.nodes = nodes;
        self.fanout = fanout;
        self.by_identity = self
            .nodes
            .iter()
            .enumerate()
            .map(|(i, node)| (node.identity, i))
            .collect();
        self.sites.retain(&self.by_identity);
        self.logical_valid = true;
        self.changed_nodes = changed;
        Ok(())
    }
    fn patch(&mut self, field: FieldId) -> Result<(), Error> {
        let Some(fanout) = self.fanout.get(&field) else {
            return Ok(());
        };
        self.counters.source_reads += 1;
        let value = self.sources.read_text(&self.model, field, fanout.codec)?;
        let mut promoted: Option<Rc<str>> = None;
        for &index in &fanout.destinations {
            self.counters.destination_compares += 1;
            let node = &mut self.nodes[index];
            if node.text.as_deref() != Some(value.as_ref()) {
                if promoted.is_none() {
                    promoted = Some(Rc::from(value.as_ref()));
                    self.counters.text_promotions += 1;
                    self.counters.text_bytes_copied += value.len() as u64;
                }
                node.text = promoted.clone();
                node.shaped = None;
                self.layout_dirty.insert(node.identity);
                self.dirty = true;
                self.changed_nodes += 1;
            }
        }
        Ok(())
    }
    fn commit(&self) -> Commit {
        Commit {
            source_epoch: self.source_epoch,
            presentation_epoch: self.presentation_epoch,
            changed_nodes: self.changed_nodes,
        }
    }
    fn present(&mut self) -> Result<Commit, Error> {
        if !self.dirty {
            self.presentation_epoch = self.source_epoch;
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
                for node in &mut self.nodes {
                    node.shaped = None;
                }
                Err(Error::PresentationPanicked)
            }
        }
    }
    fn present_inner(&mut self) -> Result<(), Error> {
        if self.text.is_none() && self.nodes.iter().any(|node| node.text.is_some()) {
            self.text = Some(TextSystem::bundled()?);
        }
        if self.rebuild_layout || self.topology_changed || self.layout.is_poisoned() {
            self.layout = LayoutTree::new();
            self.layout_nodes.clear();
            for node in &self.nodes {
                let parent = node.parent.map(|parent| self.layout_nodes[parent]);
                let id = self.layout.insert(
                    parent,
                    gpui_reactivity_core::NodeKind::Element,
                    layout_style(node.style),
                )?;
                if node.text.is_some() {
                    self.layout.set_measure(id, Some(measure_marker))?;
                }
                self.layout_nodes.push(id);
            }
        } else {
            for identity in &self.layout_dirty {
                let index = self.by_identity[identity];
                let id = self.layout_nodes[index];
                self.layout
                    .set_style(id, layout_style(self.nodes[index].style))?;
                self.layout.mark_dirty(id)?;
            }
        }
        let before = self.layout.stats();
        let lookup = self
            .layout_nodes
            .iter()
            .enumerate()
            .map(|(index, id)| (*id, index))
            .collect::<BTreeMap<_, _>>();
        let mut failure = None;
        let nodes = &mut self.nodes;
        let service = &self.text;
        let mut measure = |id: NodeId, input: MeasureInput| {
            let width = input
                .known_dimensions
                .width
                .or(match input.available_space.width {
                    AvailableSpace::Definite(width) => Some(width),
                    AvailableSpace::MinContent => Some(f32::MIN_POSITIVE),
                    AvailableSpace::MaxContent => None,
                });
            let service = service
                .as_ref()
                .expect("measured text has an initialized service");
            match nodes[lookup[&id]].shape(service, width) {
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
                width: AvailableSpace::Definite(self.canvas.width() as f32),
                height: AvailableSpace::Definite(self.canvas.height() as f32),
            },
            &mut measure,
        )?;
        let after = self.layout.stats();
        self.counters.layout_runs += after.computes - before.computes;
        self.counters.measure_calls += after.measure_calls - before.measure_calls;
        if let Some(error) = failure {
            return Err(error);
        }
        let viewport = Rect::new(
            0.0,
            0.0,
            self.canvas.width() as f32,
            self.canvas.height() as f32,
        );
        let mut presented: Vec<Presented> = Vec::with_capacity(self.nodes.len());
        let mut spaces: Vec<CoordinateSpace> = Vec::with_capacity(self.nodes.len());
        let mut scene = self.canvas.stage();
        scene.clear(Color::WHITE);
        self.counters.paint_passes += 1;
        for index in 0..self.nodes.len() {
            let layout = self.layout.layout(self.layout_nodes[index])?;
            let node = &mut self.nodes[index];
            let parent = node
                .parent
                .map_or(CoordinateSpace::new(Affine::IDENTITY), |parent| {
                    spaces[parent]
                });
            let space = parent
                .compose(Affine::translation(layout.location.x, layout.location.y))
                .compose(node.style.transform);
            spaces.push(space);
            let [a, b, c, d, tx, ty] = space.coefficients().map(|value| value as f32);
            let candidate = Affine { a, b, c, d, tx, ty };
            let transform =
                (space.is_invertible() && candidate.is_finite() && candidate.is_invertible())
                    .then_some(candidate);
            let rect = Rect::new(0.0, 0.0, layout.size.width, layout.size.height);
            let bounds = transform
                .and_then(|map| CoordinateSpace::new(map).bounds(rect))
                .unwrap_or_default()
                .intersection(viewport);
            if node.style.bg.alpha() > 0.0 {
                scene.fill_rect(
                    rect,
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    viewport,
                    node.style.bg,
                )?;
            } else if node.handler.is_some() || node.kind == NodeKind::Input {
                // An invisible input region still obeys the renderer's exact
                // numerical admission domain before becoming a hit target.
                scene.fill_rect(
                    rect,
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    viewport,
                    Color::TRANSPARENT,
                )?;
            }
            if node.text.is_some() {
                let fg = node.style.fg;
                let service = self.text.as_mut().expect("text initialized before layout");
                let shape = node.shape(service, Some(layout.content_box_width()))?;
                scene.draw_text(
                    service,
                    shape,
                    Point {
                        x: layout.padding.left,
                        y: layout.padding.top,
                    },
                    transform.ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    viewport,
                    fg,
                )?;
            }
            presented.push(Presented {
                identity: node.identity,
                parent: node.parent,
                kind: node.kind,
                text: node.text.clone(),
                rect,
                transform,
                bounds,
                hittable: node.text.is_some()
                    || node.style.bg.alpha() > 0.0
                    || node.handler.is_some()
                    || node.kind == NodeKind::Input,
            });
        }
        // Everything fallible has finished. This transfers commands, retaining
        // the one existing RGBA8 output allocation; no model borrow is published.
        scene.commit();
        self.presented = presented;
        if self.nodes.iter().all(|node| node.text.is_none()) {
            self.text = None;
        }
        self.presentation_epoch = self.source_epoch;
        self.dirty = false;
        self.rebuild_layout = false;
        self.topology_changed = false;
        self.layout_dirty.clear();
        self.counters.presentations += 1;
        Ok(())
    }
    fn hit(&self, point: Point) -> Option<u64> {
        if !Rect::new(
            0.0,
            0.0,
            self.canvas.width() as f32,
            self.canvas.height() as f32,
        )
        .contains(point)
        {
            return None;
        }
        for (index, node) in self.presented.iter().enumerate().rev() {
            if node.hittable
                && node
                    .transform
                    .is_some_and(|map| CoordinateSpace::new(map).hit(node.rect, point))
            {
                let mut cursor = Some(index);
                while let Some(index) = cursor {
                    let node = &self.presented[index];
                    if let Some(&logical) = self.by_identity.get(&node.identity)
                        && (self.nodes[logical].handler.is_some() || node.kind == NodeKind::Input)
                    {
                        return Some(node.identity);
                    }
                    cursor = node.parent;
                }
                return None;
            }
        }
        None
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
}
fn layout_style(style: Style) -> cephal::Style {
    use cephal::style::{Dimension, Display, FlexDirection, LengthPercentage};
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
        ..cephal::Style::DEFAULT
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{div, text};

    #[test]
    fn rectangle_windows_do_not_initialize_font_services() {
        struct Rectangle;
        impl View for Rectangle {
            fn view(&self) -> crate::El<'_> {
                div().size(8).bg(Color::BLACK)
            }
        }
        let win = Win::with_size(Rectangle, 8, 8).unwrap();
        assert!(win.inner.borrow().text.is_none());
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
        let win = Win::with_size(Name("unchanged".into()), 160, 40).unwrap();
        let pointer = Rc::as_ptr(win.inner.borrow().nodes[0].text.as_ref().unwrap());
        win.reset_counters().unwrap();
        win.update(|m| m.0 = m.0.clone()).unwrap();
        assert!(std::ptr::eq(
            pointer,
            Rc::as_ptr(win.inner.borrow().nodes[0].text.as_ref().unwrap())
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
        let win = Win::with_size(
            Content {
                text: true,
                broken: false,
            },
            80,
            40,
        )
        .unwrap();
        assert!(win.inner.borrow().text.is_some());
        assert!(
            win.update(|m| {
                m.text = false;
                m.broken = true;
            })
            .is_err()
        );
        assert!(
            win.inner.borrow().text.is_some(),
            "the failed candidate did not replace the text sheet"
        );
        win.update(|m| m.broken = false).unwrap();
        assert!(win.inner.borrow().text.is_none());
        win.update(|m| m.text = true).unwrap();
        assert!(win.inner.borrow().text.is_some());
    }
}
