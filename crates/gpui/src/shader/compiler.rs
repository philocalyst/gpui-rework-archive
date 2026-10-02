use std::{
    collections::{HashMap, HashSet},
    sync::{
        Arc, Mutex, OnceLock,
        atomic::{AtomicU64, Ordering},
    },
};

use naga::{valid::Capabilities, valid::ValidationFlags};
use wgsl_rs::ir::{
    self, BinOp, Block, Expr, Field as IrField, FnArg, FnAttrs, FnPath, Item, ItemFn, ItemStruct,
    ItemUniform, Lit, Module, ReturnType, ReturnTypeAnnotation, ScalarType, Stmt, Type as IrType,
};

use super::{
    expr::{BinaryOp, Builtin, Input, Kind, Node, Type, UnaryOp},
    paint::Paint,
};

const MAX_NODES: usize = 4096;
pub(super) const MAX_DEPTH: usize = 256;
const MAX_EXPANDED_CONTEXTS: usize = 16_384;
pub(super) const MAX_UNIFORMS: usize = 256;
const MAX_WGSL_BYTES: usize = 256 * 1024;
const MAX_CACHE_ENTRIES: usize = 128;
const MAX_CACHE_BYTES: usize = 4 * 1024 * 1024;

static NEXT_PROGRAM_ID: AtomicU64 = AtomicU64::new(1);

/// A compile-time diagnostic produced by [`Paint::compile`](super::paint::Paint::compile).
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum ShaderError {
    /// A reachable uniform or constant contains NaN or infinity.
    NonFiniteValue,
    /// A paint contains more than the bounded number of unique expression nodes.
    TooManyNodes,
    /// A paint expression exceeds the bounded expression depth.
    TooDeep,
    /// A shared paint expands beyond the bounded number of mapped evaluations.
    TooManyExpandedContexts,
    /// A paint requires more uniform values than the compiler supports.
    TooManyUniforms,
    /// Generated WGSL exceeds the compiler's source-size limit.
    SourceTooLarge,
    /// The generated shader did not pass WGSL parsing or validation.
    InvalidShader(String),
}

impl std::fmt::Display for ShaderError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::NonFiniteValue => f.write_str("shader values must be finite"),
            Self::TooManyNodes => write!(f, "shader exceeds the {MAX_NODES}-node limit"),
            Self::TooDeep => write!(f, "shader exceeds the {MAX_DEPTH}-level depth limit"),
            Self::TooManyExpandedContexts => write!(
                f,
                "shader exceeds the {MAX_EXPANDED_CONTEXTS}-evaluation mapped-context limit"
            ),
            Self::TooManyUniforms => {
                write!(f, "shader exceeds the {MAX_UNIFORMS}-uniform-value limit")
            }
            Self::SourceTooLarge => write!(
                f,
                "generated shader exceeds the {MAX_WGSL_BYTES}-byte source limit"
            ),
            Self::InvalidShader(message) => write!(f, "invalid generated shader: {message}"),
        }
    }
}

impl std::error::Error for ShaderError {}

/// Immutable, validated WGSL and packed uniform values for a [`Paint`].
#[derive(Clone)]
pub struct CompiledPaint {
    program: Arc<Program>,
    parameter_slots: Arc<[[f32; 4]]>,
}

impl std::fmt::Debug for CompiledPaint {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("CompiledPaint")
            .field("program_id", &self.program.id)
            .field("node_count", &self.program.node_count)
            .field("parameter_slots", &self.parameter_slots.len())
            .field("requires_derivatives", &self.program.requires_derivatives)
            .field("uses_backdrop", &self.program.uses_backdrop)
            .finish()
    }
}

impl PartialEq for CompiledPaint {
    fn eq(&self, other: &Self) -> bool {
        self.program.id == other.program.id && self.parameter_slots == other.parameter_slots
    }
}

impl CompiledPaint {
    /// Stable identity for this canonical recipe while it is present in the bounded cache.
    pub fn program_id(&self) -> u64 {
        self.program.id
    }

    /// WGSL declarations and the callable `gpui_paint_fragment` function.
    ///
    /// Backdrop paints call the renderer-provided `gpui_sample_backdrop(vec2<f32>)`
    /// helper. The renderer supplies its texture resource and component-to-target mapping.
    pub fn wgsl(&self) -> &str {
        &self.program.wgsl
    }

    /// Parameter values packed into 16-byte `vec4<f32>` uniform slots.
    pub fn parameter_slots(&self) -> &[[f32; 4]] {
        &self.parameter_slots
    }

    /// Number of unique reachable recipe nodes, excluding mapped evaluations.
    pub fn node_count(&self) -> usize {
        self.program.node_count
    }

    /// Whether the paint uses screen-space derivative builtins.
    pub fn requires_derivatives(&self) -> bool {
        self.program.requires_derivatives
    }

    /// Whether the paint samples the renderer-owned scene backdrop.
    pub fn uses_backdrop(&self) -> bool {
        self.program.uses_backdrop
    }
}

pub(super) fn paint_eq(left: &Paint, right: &Paint) -> bool {
    let (Ok(left), Ok(right)) = (prepare(left, false), prepare(right, false)) else {
        return false;
    };
    left.key == right.key && uniform_values_equal(&left.values, &right.values)
}

fn uniform_values_equal(left: &[Option<[f32; 4]>], right: &[Option<[f32; 4]>]) -> bool {
    left.len() == right.len()
        && left
            .iter()
            .zip(right)
            .all(|(left, right)| match (left, right) {
                (None, None) => true,
                (Some(left), Some(right)) => left
                    .iter()
                    .zip(right)
                    .all(|(left, right)| left.to_bits() == right.to_bits()),
                _ => false,
            })
}

struct Program {
    id: u64,
    wgsl: String,
    node_count: usize,
    requires_derivatives: bool,
    uses_backdrop: bool,
    parameter_locations: Vec<Option<UniformLocation>>,
    parameter_slots: usize,
}

#[derive(Clone, Copy, Debug)]
struct UniformLocation {
    slot: usize,
    lane: usize,
    ty: Type,
}

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
struct ProgramKey {
    nodes: Vec<NodeCode>,
}

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
struct NodeCode {
    ty: Type,
    kind: CodeKind,
}

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
enum CodeKind {
    Uniform,
    Constant([u32; 4]),
    Input(Input),
    Compose2(usize, usize),
    Compose3([usize; 3]),
    Compose4([usize; 4]),
    Swizzle(usize, &'static str),
    Unary(UnaryOp, usize),
    Binary(BinaryOp, usize, usize),
    Builtin1(Builtin, usize),
    Builtin2(Builtin, usize, usize),
    Builtin3(Builtin, usize, usize, usize),
    Select(usize, usize, usize),
    Rgba([usize; 4]),
    Mix([usize; 3]),
    Over(usize, usize),
    Opacity(usize, usize),
    Mask(usize, usize),
    MapUv(usize, usize),
    Backdrop(usize),
}

struct Prepared {
    key: ProgramKey,
    ids: HashMap<usize, usize>,
    values: Vec<Option<[f32; 4]>>,
    node_count: usize,
    requires_derivatives: bool,
    uses_backdrop: bool,
}

struct CanonicalBuilder {
    ids: HashMap<usize, usize>,
    deepest_depths: Vec<usize>,
    codes: Vec<Option<NodeCode>>,
    values: Vec<Option<[f32; 4]>>,
    requires_derivatives: bool,
    uses_backdrop: bool,
    check_finite: bool,
}

impl CanonicalBuilder {
    fn visit(&mut self, node: &Arc<Node>, depth: usize) -> Result<usize, ShaderError> {
        if depth > MAX_DEPTH {
            return Err(ShaderError::TooDeep);
        }
        let pointer = Arc::as_ptr(node) as usize;
        if let Some(id) = self.ids.get(&pointer).copied() {
            if self.deepest_depths[id] >= depth {
                return Ok(id);
            }
            self.deepest_depths[id] = depth;
            let mut children = Vec::with_capacity(4);
            visit_children(&node.kind, |child| children.push(child.clone()));
            for child in children {
                self.visit(&child, depth + 1)?;
            }
            return Ok(id);
        }
        if self.ids.len() >= MAX_NODES {
            return Err(ShaderError::TooManyNodes);
        }
        let id = self.ids.len();
        self.ids.insert(pointer, id);
        self.deepest_depths.push(depth);
        self.codes.push(None);
        self.values.push(None);

        if self.check_finite {
            if let Kind::Uniform(bits) | Kind::Constant(bits) = &node.kind {
                if bits[..node.ty.components()]
                    .iter()
                    .any(|bits| !f32::from_bits(*bits).is_finite())
                {
                    return Err(ShaderError::NonFiniteValue);
                }
            }
        }

        let kind = match &node.kind {
            Kind::Uniform(bits) => {
                self.values[id] = Some(bits.map(f32::from_bits));
                CodeKind::Uniform
            }
            Kind::Constant(bits) => CodeKind::Constant(*bits),
            Kind::Input(input) => CodeKind::Input(*input),
            Kind::Compose2(a, b) => {
                CodeKind::Compose2(self.visit(a, depth + 1)?, self.visit(b, depth + 1)?)
            }
            Kind::Compose3(a, b, c) => CodeKind::Compose3([
                self.visit(a, depth + 1)?,
                self.visit(b, depth + 1)?,
                self.visit(c, depth + 1)?,
            ]),
            Kind::Compose4(a, b, c, d) => CodeKind::Compose4([
                self.visit(a, depth + 1)?,
                self.visit(b, depth + 1)?,
                self.visit(c, depth + 1)?,
                self.visit(d, depth + 1)?,
            ]),
            Kind::Swizzle(value, component) => {
                CodeKind::Swizzle(self.visit(value, depth + 1)?, component)
            }
            Kind::Unary(op, value) => CodeKind::Unary(*op, self.visit(value, depth + 1)?),
            Kind::Binary(op, a, b) => {
                CodeKind::Binary(*op, self.visit(a, depth + 1)?, self.visit(b, depth + 1)?)
            }
            Kind::Builtin1(builtin, a) => {
                self.requires_derivatives |=
                    matches!(builtin, Builtin::Dpdx | Builtin::Dpdy | Builtin::Fwidth);
                CodeKind::Builtin1(*builtin, self.visit(a, depth + 1)?)
            }
            Kind::Builtin2(builtin, a, b) => CodeKind::Builtin2(
                *builtin,
                self.visit(a, depth + 1)?,
                self.visit(b, depth + 1)?,
            ),
            Kind::Builtin3(builtin, a, b, c) => CodeKind::Builtin3(
                *builtin,
                self.visit(a, depth + 1)?,
                self.visit(b, depth + 1)?,
                self.visit(c, depth + 1)?,
            ),
            Kind::Select(condition, when_false, when_true) => CodeKind::Select(
                self.visit(condition, depth + 1)?,
                self.visit(when_false, depth + 1)?,
                self.visit(when_true, depth + 1)?,
            ),
            Kind::Rgba(r, g, b, a) => CodeKind::Rgba([
                self.visit(r, depth + 1)?,
                self.visit(g, depth + 1)?,
                self.visit(b, depth + 1)?,
                self.visit(a, depth + 1)?,
            ]),
            Kind::Mix(front, back, amount) => CodeKind::Mix([
                self.visit(front, depth + 1)?,
                self.visit(back, depth + 1)?,
                self.visit(amount, depth + 1)?,
            ]),
            Kind::Over(front, back) => {
                CodeKind::Over(self.visit(front, depth + 1)?, self.visit(back, depth + 1)?)
            }
            Kind::Opacity(paint, amount) => CodeKind::Opacity(
                self.visit(paint, depth + 1)?,
                self.visit(amount, depth + 1)?,
            ),
            Kind::Mask(paint, amount) => CodeKind::Mask(
                self.visit(paint, depth + 1)?,
                self.visit(amount, depth + 1)?,
            ),
            Kind::MapUv(paint, uv) => {
                CodeKind::MapUv(self.visit(paint, depth + 1)?, self.visit(uv, depth + 1)?)
            }
            Kind::Backdrop(uv) => {
                self.uses_backdrop = true;
                CodeKind::Backdrop(self.visit(uv, depth + 1)?)
            }
        };
        self.codes[id] = Some(NodeCode { ty: node.ty, kind });
        Ok(id)
    }
}

fn prepare(root: &Paint, check_finite: bool) -> Result<Prepared, ShaderError> {
    let mut builder = CanonicalBuilder {
        ids: HashMap::new(),
        deepest_depths: Vec::new(),
        codes: Vec::new(),
        values: Vec::new(),
        requires_derivatives: false,
        uses_backdrop: false,
        check_finite,
    };
    builder.visit(root.node(), 0)?;
    let root_id = builder.ids[&(Arc::as_ptr(root.node()) as usize)];
    debug_assert_eq!(root_id, 0);
    let node_count = builder.values.len();
    let codes: Vec<_> = builder
        .codes
        .into_iter()
        .collect::<Option<_>>()
        .ok_or_else(|| ShaderError::InvalidShader("incomplete canonical expression".into()))?;
    Ok(Prepared {
        key: ProgramKey { nodes: codes },
        ids: builder.ids,
        values: builder.values,
        node_count,
        requires_derivatives: builder.requires_derivatives,
        uses_backdrop: builder.uses_backdrop,
    })
}

fn preflight_contexts(root: &Arc<Node>, ids: &HashMap<usize, usize>) -> Result<(), ShaderError> {
    let mut stack = vec![(root.clone(), 0usize, 0usize)];
    let mut seen = HashSet::new();
    let mut domains = HashMap::<(usize, usize), usize>::new();
    let mut next_domain = 1usize;
    while let Some((node, domain, depth)) = stack.pop() {
        if depth > MAX_DEPTH {
            return Err(ShaderError::TooDeep);
        }
        let pointer = Arc::as_ptr(&node) as usize;
        let id = ids[&pointer];
        if !seen.insert((id, domain)) {
            continue;
        }
        if seen.len() > MAX_EXPANDED_CONTEXTS {
            return Err(ShaderError::TooManyExpandedContexts);
        }
        match &node.kind {
            Kind::MapUv(paint, uv) => {
                stack.push((uv.clone(), domain, depth + 1));
                let mapped_domain = if let Some(mapped_domain) = domains.get(&(domain, id)) {
                    *mapped_domain
                } else {
                    let mapped_domain = next_domain;
                    next_domain += 1;
                    domains.insert((domain, id), mapped_domain);
                    mapped_domain
                };
                stack.push((paint.clone(), mapped_domain, depth + 1));
            }
            kind => visit_children(kind, |child| {
                stack.push((child.clone(), domain, depth + 1));
            }),
        }
    }
    Ok(())
}

fn visit_children(kind: &Kind, mut visit: impl FnMut(&Arc<Node>)) {
    match kind {
        Kind::Uniform(_) | Kind::Constant(_) | Kind::Input(_) => {}
        Kind::Compose2(a, b)
        | Kind::Binary(_, a, b)
        | Kind::Builtin2(_, a, b)
        | Kind::Over(a, b)
        | Kind::Opacity(a, b)
        | Kind::Mask(a, b) => {
            visit(a);
            visit(b);
        }
        Kind::Compose3(a, b, c) | Kind::Builtin3(_, a, b, c) => {
            visit(a);
            visit(b);
            visit(c);
        }
        Kind::Compose4(a, b, c, d) => {
            visit(a);
            visit(b);
            visit(c);
            visit(d);
        }
        Kind::Swizzle(value, _)
        | Kind::Unary(_, value)
        | Kind::Builtin1(_, value)
        | Kind::Backdrop(value) => visit(value),
        Kind::Select(condition, when_false, when_true) => {
            visit(condition);
            visit(when_false);
            visit(when_true);
        }
        Kind::Rgba(r, g, b, a) => {
            visit(r);
            visit(g);
            visit(b);
            visit(a);
        }
        Kind::Mix(front, back, amount) => {
            visit(front);
            visit(back);
            visit(amount);
        }
        Kind::MapUv(paint, uv) => {
            visit(paint);
            visit(uv);
        }
    }
}

fn make_parameter_layout(
    canonical: &Prepared,
) -> Result<(Vec<Option<UniformLocation>>, usize), ShaderError> {
    let uniform_count = canonical
        .values
        .iter()
        .filter(|value| value.is_some())
        .count();
    if uniform_count > MAX_UNIFORMS {
        return Err(ShaderError::TooManyUniforms);
    }

    let mut locations = vec![None; canonical.key.nodes.len()];
    let mut slot_count = 0;
    let mut active_slot = None;
    let mut lane = 4usize;
    for (node_id, value) in canonical.values.iter().enumerate() {
        if value.is_none() {
            continue;
        }
        let ty = canonical.key.nodes[node_id].ty;
        let components = ty.components();
        let (slot, first_lane) = if components == 4 {
            let slot = slot_count;
            slot_count += 1;
            (slot, 0)
        } else {
            if active_slot.is_none() || lane + components > 4 {
                active_slot = Some(slot_count);
                slot_count += 1;
                lane = 0;
            }
            let slot = active_slot.ok_or_else(|| {
                ShaderError::InvalidShader("missing scalar parameter slot".into())
            })?;
            let first_lane = lane;
            lane += components;
            (slot, first_lane)
        };
        locations[node_id] = Some(UniformLocation {
            slot,
            lane: first_lane,
            ty,
        });
    }
    Ok((locations, slot_count))
}

fn pack_parameter_values(
    values: &[Option<[f32; 4]>],
    locations: &[Option<UniformLocation>],
    slot_count: usize,
) -> Arc<[[f32; 4]]> {
    let mut slots = vec![[0.0; 4]; slot_count];
    for (id, value) in values.iter().enumerate() {
        let (Some(value), Some(location)) = (value, locations[id]) else {
            continue;
        };
        for component in 0..location.ty.components() {
            slots[location.slot][location.lane + component] = value[component];
        }
    }
    slots.into()
}

#[derive(Default)]
struct ProgramCache {
    tick: u64,
    bytes: usize,
    entries: HashMap<ProgramKey, CacheEntry>,
}

struct CacheEntry {
    program: Arc<Program>,
    last_used: u64,
    bytes: usize,
}

fn program_cache() -> &'static Mutex<ProgramCache> {
    static CACHE: OnceLock<Mutex<ProgramCache>> = OnceLock::new();
    CACHE.get_or_init(|| Mutex::new(ProgramCache::default()))
}

pub(super) fn compile(paint: &Paint) -> Result<CompiledPaint, ShaderError> {
    let prepared = prepare(paint, true)?;
    let cached = {
        let mut cache = program_cache()
            .lock()
            .unwrap_or_else(std::sync::PoisonError::into_inner);
        cache.tick = cache.tick.wrapping_add(1);
        let tick = cache.tick;
        cache.entries.get_mut(&prepared.key).map(|entry| {
            entry.last_used = tick;
            entry.program.clone()
        })
    };

    let program = if let Some(program) = cached {
        update_stats(|stats| stats.program_cache_hits += 1);
        program
    } else {
        update_stats(|stats| stats.program_cache_misses += 1);
        preflight_contexts(paint.node(), &prepared.ids)?;
        let program = build_program(paint, &prepared)?;
        let bytes = estimate_program_bytes(&prepared.key, &program);
        if bytes <= MAX_CACHE_BYTES {
            let mut cache = program_cache()
                .lock()
                .unwrap_or_else(std::sync::PoisonError::into_inner);
            cache.tick = cache.tick.wrapping_add(1);
            let tick = cache.tick;
            if let Some(entry) = cache.entries.get_mut(&prepared.key) {
                entry.last_used = tick;
                update_stats(|stats| stats.program_cache_hits += 1);
                entry.program.clone()
            } else {
                while cache.entries.len() >= MAX_CACHE_ENTRIES
                    || cache.bytes.saturating_add(bytes) > MAX_CACHE_BYTES
                {
                    let Some(oldest_key) = cache
                        .entries
                        .iter()
                        .min_by_key(|(_, entry)| entry.last_used)
                        .map(|(key, _)| key.clone())
                    else {
                        break;
                    };
                    if let Some(oldest) = cache.entries.remove(&oldest_key) {
                        cache.bytes = cache.bytes.saturating_sub(oldest.bytes);
                    }
                }
                cache.bytes += bytes;
                cache.entries.insert(
                    prepared.key.clone(),
                    CacheEntry {
                        program: program.clone(),
                        last_used: tick,
                        bytes,
                    },
                );
                program
            }
        } else {
            program
        }
    };

    let parameter_slots = pack_parameter_values(
        &prepared.values,
        &program.parameter_locations,
        program.parameter_slots,
    );
    update_stats(|stats| stats.packed_parameter_bytes += (parameter_slots.len() * 16) as u64);
    Ok(CompiledPaint {
        program,
        parameter_slots,
    })
}

fn build_program(paint: &Paint, prepared: &Prepared) -> Result<Arc<Program>, ShaderError> {
    let (locations, slot_count) = make_parameter_layout(prepared)?;
    let mut lowerer = Lowerer::new(&prepared.ids, &locations);
    let module = lowerer.lower(paint.node(), slot_count)?;
    update_stats(|stats| stats.ir_lowerings += 1);
    let wgsl = module.wgsl_source();
    update_stats(|stats| stats.wgsl_emissions += 1);
    if wgsl.len() > MAX_WGSL_BYTES {
        return Err(ShaderError::SourceTooLarge);
    }
    validate_wgsl(&wgsl, prepared.uses_backdrop)?;
    update_stats(|stats| stats.validations += 1);
    Ok(Arc::new(Program {
        id: NEXT_PROGRAM_ID.fetch_add(1, Ordering::Relaxed),
        wgsl,
        node_count: prepared.node_count,
        requires_derivatives: prepared.requires_derivatives,
        uses_backdrop: prepared.uses_backdrop,
        parameter_locations: locations,
        parameter_slots: slot_count,
    }))
}

fn estimate_program_bytes(key: &ProgramKey, program: &Program) -> usize {
    // Conservative storage estimate for owned buffers plus per-entry hash/map
    // bookkeeping. This is a cache budget, not an allocator-exact measurement.
    128 + std::mem::size_of::<Program>()
        + std::mem::size_of::<CacheEntry>()
        + std::mem::size_of::<ProgramKey>()
        + key.nodes.capacity() * std::mem::size_of::<NodeCode>()
        + program.wgsl.capacity()
        + program.parameter_locations.capacity() * std::mem::size_of::<Option<UniformLocation>>()
}

#[derive(Clone, Copy, Debug, Default)]
struct ThreadStats {
    program_cache_hits: u64,
    program_cache_misses: u64,
    ir_lowerings: u64,
    wgsl_emissions: u64,
    validations: u64,
    packed_parameter_bytes: u64,
}

#[cfg(any(test, feature = "test-support"))]
/// Per-thread counters for shader compilation and parameter packing.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct ShaderCacheStats {
    /// Number of source-shape cache hits on this thread.
    pub program_cache_hits: u64,
    /// Number of source-shape cache misses on this thread.
    pub program_cache_misses: u64,
    /// Number of `wgsl-rs` IR modules lowered on this thread.
    pub ir_lowerings: u64,
    /// Number of WGSL source emissions on this thread.
    pub wgsl_emissions: u64,
    /// Number of Naga validations on this thread.
    pub validations: u64,
    /// Total parameter bytes packed on this thread.
    pub packed_parameter_bytes: u64,
}

#[cfg(any(test, feature = "test-support"))]
thread_local! {
    static THREAD_STATS: std::cell::Cell<ThreadStats> = const {
        std::cell::Cell::new(ThreadStats {
            program_cache_hits: 0,
            program_cache_misses: 0,
            ir_lowerings: 0,
            wgsl_emissions: 0,
            validations: 0,
            packed_parameter_bytes: 0,
        })
    };
}

#[cfg(any(test, feature = "test-support"))]
/// Return shader compilation cache counters for the current thread.
pub fn shader_cache_stats() -> ShaderCacheStats {
    let stats = THREAD_STATS.get();
    ShaderCacheStats {
        program_cache_hits: stats.program_cache_hits,
        program_cache_misses: stats.program_cache_misses,
        ir_lowerings: stats.ir_lowerings,
        wgsl_emissions: stats.wgsl_emissions,
        validations: stats.validations,
        packed_parameter_bytes: stats.packed_parameter_bytes,
    }
}

#[cfg(any(test, feature = "test-support"))]
/// Reset shader compilation cache counters for the current thread.
pub fn reset_shader_cache_stats() {
    THREAD_STATS.set(ThreadStats::default());
}

#[cfg(any(test, feature = "test-support"))]
fn update_stats(update: impl FnOnce(&mut ThreadStats)) {
    THREAD_STATS.set({
        let mut stats = THREAD_STATS.get();
        update(&mut stats);
        stats
    });
}

#[cfg(not(any(test, feature = "test-support")))]
fn update_stats(_: impl FnOnce(&mut ThreadStats)) {}

struct Domain {
    id: usize,
    uv: Expr,
}

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
struct ExpressionKey {
    node: usize,
    domain: usize,
}

struct Lowerer<'a> {
    ids: &'a HashMap<usize, usize>,
    parameter_locations: &'a [Option<UniformLocation>],
    statements: Vec<Stmt>,
    expression_cache: HashMap<ExpressionKey, Expr>,
    domain_cache: HashMap<(usize, usize), (usize, Expr)>,
    next_domain: usize,
    next_local: usize,
}

impl<'a> Lowerer<'a> {
    fn new(
        ids: &'a HashMap<usize, usize>,
        parameter_locations: &'a [Option<UniformLocation>],
    ) -> Self {
        Self {
            ids,
            parameter_locations,
            statements: Vec::new(),
            expression_cache: HashMap::new(),
            domain_cache: HashMap::new(),
            next_domain: 1,
            next_local: 0,
        }
    }

    fn lower(&mut self, root: &Arc<Node>, slot_count: usize) -> Result<Module, ShaderError> {
        let root_value = self.lower_node(
            root,
            &Domain {
                id: 0,
                uv: ident("uv"),
            },
        )?;
        self.statements.push(Stmt::Expr {
            expr: root_value,
            has_semi: false,
        });

        let mut items = Vec::new();
        if slot_count > 0 {
            items.push(Item::Struct(ItemStruct {
                type_params: vec![],
                const_params: vec![],
                name: "GpuiPaintParameters".to_string(),
                fields: vec![IrField {
                    inter_stage_io: vec![],
                    name: "values".to_string(),
                    ty: IrType::Array {
                        elem: Box::new(vec4_type()),
                        len: u32_literal(slot_count),
                    },
                    attrs: vec![],
                }],
                attrs: vec![],
            }));
            items.push(Item::Uniform(ItemUniform {
                group: 1,
                binding: 1,
                name: "gpui_paint_parameters".to_string(),
                ty: IrType::Struct {
                    name: "GpuiPaintParameters".to_string(),
                    type_args: vec![],
                },
                attrs: vec![],
            }));
        }
        items.push(Item::Fn(ItemFn {
            type_params: vec![],
            const_params: vec![],
            fn_attrs: FnAttrs::None,
            name: "gpui_paint_fragment".into(),
            inputs: vec![
                fn_arg("uv", vec2_type()),
                fn_arg("position", vec2_type()),
                fn_arg("size", vec2_type()),
            ],
            return_type: ReturnType::Type {
                annotation: ReturnTypeAnnotation::None,
                ty: vec4_type(),
            },
            block: Block {
                stmts: std::mem::take(&mut self.statements),
            },
            attrs: vec![],
        }));
        Ok(Module {
            name: "gpui_paint_program",
            items,
            attrs: vec![],
        })
    }

    fn lower_node(&mut self, node: &Arc<Node>, domain: &Domain) -> Result<Expr, ShaderError> {
        let pointer = Arc::as_ptr(node) as usize;
        let node_id = self.ids[&pointer];
        let key = ExpressionKey {
            node: node_id,
            domain: domain.id,
        };
        if let Some(cached) = self.expression_cache.get(&key) {
            return Ok(cached.clone());
        }

        let expression = match &node.kind {
            Kind::Uniform(_) => self.uniform_expr(node_id, node.ty)?,
            Kind::Constant(values) => constant_expr(node.ty, *values),
            Kind::Input(Input::Uv) => domain.uv.clone(),
            Kind::Input(Input::Position) if domain.id == 0 => ident("position"),
            Kind::Input(Input::Position) => {
                let size = ident("size");
                self.local(Type::Vec2, binary(domain.uv.clone(), BinaryOp::Mul, size))
            }
            Kind::Input(Input::Size) => ident("size"),
            Kind::Compose2(a, b) => {
                let a = self.lower_node(a, domain)?;
                let b = self.lower_node(b, domain)?;
                self.local(node.ty, call("vec2f", vec![a, b]))
            }
            Kind::Compose3(a, b, c) => {
                let a = self.lower_node(a, domain)?;
                let b = self.lower_node(b, domain)?;
                let c = self.lower_node(c, domain)?;
                self.local(node.ty, call("vec3f", vec![a, b, c]))
            }
            Kind::Compose4(a, b, c, d) => {
                let a = self.lower_node(a, domain)?;
                let b = self.lower_node(b, domain)?;
                let c = self.lower_node(c, domain)?;
                let d = self.lower_node(d, domain)?;
                self.local(node.ty, call("vec4f", vec![a, b, c, d]))
            }
            Kind::Swizzle(value, swizzle) => {
                let value = self.lower_node(value, domain)?;
                self.local(
                    node.ty,
                    Expr::Swizzle {
                        lhs: Box::new(value),
                        swizzle: (*swizzle).to_string(),
                        params: None,
                    },
                )
            }
            Kind::Unary(op, value) => {
                let value = self.lower_node(value, domain)?;
                let op = match op {
                    UnaryOp::Neg => ir::UnOp::Neg,
                    UnaryOp::Not => ir::UnOp::Not,
                };
                self.local(
                    node.ty,
                    Expr::Unary {
                        op,
                        expr: Box::new(value),
                    },
                )
            }
            Kind::Binary(op, left, right) => {
                let left = self.lower_node(left, domain)?;
                let right = self.lower_node(right, domain)?;
                self.local(node.ty, binary(left, *op, right))
            }
            Kind::Builtin1(builtin, value) => {
                let value = self.lower_node(value, domain)?;
                self.local(node.ty, call(builtin_name(*builtin), vec![value]))
            }
            Kind::Builtin2(builtin, left, right) => {
                let left = self.lower_node(left, domain)?;
                let right = self.lower_node(right, domain)?;
                self.local(node.ty, call(builtin_name(*builtin), vec![left, right]))
            }
            Kind::Builtin3(builtin, a, b, c) => {
                let a = self.lower_node(a, domain)?;
                let b = self.lower_node(b, domain)?;
                let c = self.lower_node(c, domain)?;
                self.local(node.ty, call(builtin_name(*builtin), vec![a, b, c]))
            }
            Kind::Select(condition, when_false, when_true) => {
                let condition = self.lower_node(condition, domain)?;
                let when_false = self.lower_node(when_false, domain)?;
                let when_true = self.lower_node(when_true, domain)?;
                self.local(
                    node.ty,
                    call("select", vec![when_false, when_true, condition]),
                )
            }
            Kind::Rgba(red, green, blue, alpha) => {
                let red = self.lower_node(red, domain)?;
                let green = self.lower_node(green, domain)?;
                let blue = self.lower_node(blue, domain)?;
                let alpha = self.lower_node(alpha, domain)?;
                self.local(
                    Type::Vec4,
                    call(
                        "vec4f",
                        vec![
                            binary(red, BinaryOp::Mul, alpha.clone()),
                            binary(green, BinaryOp::Mul, alpha.clone()),
                            binary(blue, BinaryOp::Mul, alpha.clone()),
                            alpha,
                        ],
                    ),
                )
            }
            Kind::Mix(front, back, amount) => {
                let front = self.lower_node(front, domain)?;
                let back = self.lower_node(back, domain)?;
                let amount = self.lower_node(amount, domain)?;
                let inverse = self.local(
                    Type::F32,
                    binary(f32_literal(1.0), BinaryOp::Sub, amount.clone()),
                );
                let front = self.local(Type::Vec4, binary(front, BinaryOp::Mul, inverse));
                let back = self.local(Type::Vec4, binary(back, BinaryOp::Mul, amount));
                self.local(Type::Vec4, binary(front, BinaryOp::Add, back))
            }
            Kind::Over(front, back) => {
                let front = self.lower_node(front, domain)?;
                let back = self.lower_node(back, domain)?;
                let alpha = swizzle(front.clone(), "w");
                let keep_back =
                    self.local(Type::F32, binary(f32_literal(1.0), BinaryOp::Sub, alpha));
                let faded_back = self.local(Type::Vec4, binary(back, BinaryOp::Mul, keep_back));
                self.local(Type::Vec4, binary(front, BinaryOp::Add, faded_back))
            }
            Kind::Opacity(paint, amount) | Kind::Mask(paint, amount) => {
                let paint = self.lower_node(paint, domain)?;
                let amount = self.lower_node(amount, domain)?;
                let amount = self.local(
                    Type::F32,
                    call("clamp", vec![amount, f32_literal(0.0), f32_literal(1.0)]),
                );
                self.local(Type::Vec4, binary(paint, BinaryOp::Mul, amount))
            }
            Kind::MapUv(paint, mapped_uv) => {
                let key = (domain.id, node_id);
                let (mapped_domain_id, mapped_uv) =
                    if let Some(existing) = self.domain_cache.get(&key) {
                        existing.clone()
                    } else {
                        let mapped = self.lower_node(mapped_uv, domain)?;
                        let mapped = self.local(Type::Vec2, mapped);
                        let mapped_domain_id = self.next_domain;
                        self.next_domain += 1;
                        self.domain_cache
                            .insert(key, (mapped_domain_id, mapped.clone()));
                        (mapped_domain_id, mapped)
                    };
                let mapped_domain = Domain {
                    id: mapped_domain_id,
                    uv: mapped_uv,
                };
                self.lower_node(paint, &mapped_domain)?
            }
            Kind::Backdrop(uv) => {
                let uv = self.lower_node(uv, domain)?;
                self.local(Type::Vec4, call("gpui_sample_backdrop", vec![uv]))
            }
        };

        self.expression_cache.insert(key, expression.clone());
        Ok(expression)
    }

    fn uniform_expr(&self, id: usize, ty: Type) -> Result<Expr, ShaderError> {
        let location = self
            .parameter_locations
            .get(id)
            .and_then(|location| *location)
            .ok_or(ShaderError::InvalidShader(
                "uniform has no parameter location".to_string(),
            ))?;
        let indexed = Expr::ArrayIndexing {
            lhs: Box::new(field(ident("gpui_paint_parameters"), "values")),
            index: Box::new(u32_literal(location.slot)),
        };
        if ty == Type::Bool {
            let value = field(indexed, component(location.lane));
            return Ok(binary(value, BinaryOp::Ne, f32_literal(0.0)));
        }
        if ty == Type::F32 {
            Ok(field(indexed, component(location.lane)))
        } else {
            let swizzle = match location.lane {
                0 => "xyzw",
                1 => "yzw",
                2 => "zw",
                3 => "w",
                _ => return Err(ShaderError::InvalidShader("invalid packed lane".into())),
            };
            let swizzle = &swizzle[..ty.components()];
            Ok(Expr::Swizzle {
                lhs: Box::new(indexed),
                swizzle: swizzle.to_string(),
                params: None,
            })
        }
    }

    fn local(&mut self, ty: Type, init: Expr) -> Expr {
        let name = format!("gpui_shader_v{}", self.next_local);
        self.next_local += 1;
        self.statements.push(Stmt::Local(ir::Local {
            mutable: false,
            name: name.clone(),
            ty: Some(ir_type(ty)),
            init: Some(init),
        }));
        ident(&name)
    }
}

fn ir_type(ty: Type) -> IrType {
    match ty {
        Type::F32 => IrType::Scalar(ScalarType::F32),
        Type::Bool => IrType::Scalar(ScalarType::Bool),
        Type::Vec2 => IrType::Vector {
            elements: 2,
            scalar_ty: Some(ScalarType::F32),
        },
        Type::Vec3 => IrType::Vector {
            elements: 3,
            scalar_ty: Some(ScalarType::F32),
        },
        Type::Vec4 => IrType::Vector {
            elements: 4,
            scalar_ty: Some(ScalarType::F32),
        },
    }
}

fn vec2_type() -> IrType {
    ir_type(Type::Vec2)
}

fn vec4_type() -> IrType {
    ir_type(Type::Vec4)
}

fn fn_arg(name: &str, ty: IrType) -> FnArg {
    FnArg {
        inter_stage_io: vec![],
        name: name.to_string(),
        ty,
        attrs: vec![],
    }
}

fn ident(name: &str) -> Expr {
    Expr::Ident(name.to_string())
}

fn field(base: Expr, name: &str) -> Expr {
    Expr::FieldAccess {
        base: Box::new(base),
        field: name.to_string(),
    }
}

fn swizzle(base: Expr, name: &str) -> Expr {
    Expr::Swizzle {
        lhs: Box::new(base),
        swizzle: name.to_string(),
        params: None,
    }
}

fn component(lane: usize) -> &'static str {
    match lane {
        0 => "x",
        1 => "y",
        2 => "z",
        3 => "w",
        _ => unreachable!("packed vec4 lane must be in 0..4"),
    }
}

fn call(name: &str, params: Vec<Expr>) -> Expr {
    Expr::FnCall {
        path: FnPath::Ident(name.to_string()),
        type_args: vec![],
        params,
    }
}

fn bin_op(op: BinaryOp) -> BinOp {
    match op {
        BinaryOp::Add => BinOp::Add,
        BinaryOp::Sub => BinOp::Sub,
        BinaryOp::Mul => BinOp::Mul,
        BinaryOp::Div => BinOp::Div,
        BinaryOp::Eq => BinOp::Eq,
        BinaryOp::Ne => BinOp::Ne,
        BinaryOp::Lt => BinOp::Lt,
        BinaryOp::Le => BinOp::Le,
        BinaryOp::Gt => BinOp::Gt,
        BinaryOp::Ge => BinOp::Ge,
        BinaryOp::And => BinOp::And,
        BinaryOp::Or => BinOp::Or,
    }
}

fn grouped(expression: Expr) -> Expr {
    if matches!(expression, Expr::Binary { .. }) {
        Expr::Paren(Box::new(expression))
    } else {
        expression
    }
}

fn binary(left: Expr, op: BinaryOp, right: Expr) -> Expr {
    Expr::Binary {
        lhs: Box::new(grouped(left)),
        op: bin_op(op),
        rhs: Box::new(grouped(right)),
    }
}

fn f32_literal(value: f32) -> Expr {
    let mut text = value.to_string();
    if !text.contains('.') && !text.contains('e') && !text.contains('E') {
        text.push_str(".0");
    }
    Expr::Lit(Lit::Float { text })
}

fn u32_literal(value: usize) -> Expr {
    Expr::Lit(Lit::Int {
        digits: value.to_string(),
        suffix: "u32".to_string(),
    })
}

fn constant_expr(ty: Type, bits: [u32; 4]) -> Expr {
    let values = bits.map(f32::from_bits);
    match ty {
        Type::Bool => Expr::Lit(Lit::Bool(values[0] != 0.0)),
        Type::F32 => f32_literal(values[0]),
        Type::Vec2 => call(
            "vec2f",
            values[..2].iter().copied().map(f32_literal).collect(),
        ),
        Type::Vec3 => call(
            "vec3f",
            values[..3].iter().copied().map(f32_literal).collect(),
        ),
        Type::Vec4 => call("vec4f", values.iter().copied().map(f32_literal).collect()),
    }
}

fn builtin_name(builtin: Builtin) -> &'static str {
    match builtin {
        Builtin::Sin => "sin",
        Builtin::Cos => "cos",
        Builtin::Abs => "abs",
        Builtin::Fract => "fract",
        Builtin::Floor => "floor",
        Builtin::Sqrt => "sqrt",
        Builtin::Pow => "pow",
        Builtin::Exp => "exp",
        Builtin::Min => "min",
        Builtin::Max => "max",
        Builtin::Clamp => "clamp",
        Builtin::Smoothstep => "smoothstep",
        Builtin::Dot => "dot",
        Builtin::Length => "length",
        Builtin::Normalize => "normalize",
        Builtin::Dpdx => "dpdx",
        Builtin::Dpdy => "dpdy",
        Builtin::Fwidth => "fwidth",
    }
}

fn validate_wgsl(source: &str, uses_backdrop: bool) -> Result<(), ShaderError> {
    let validation_source = if uses_backdrop {
        format!(
            "{source}\nfn gpui_sample_backdrop(uv: vec2<f32>) -> vec4<f32> {{ return vec4f(0.0); }}"
        )
    } else {
        source.to_string()
    };
    let module = naga::front::wgsl::parse_str(&validation_source)
        .map_err(|error| ShaderError::InvalidShader(error.emit_to_string(&validation_source)))?;
    naga::valid::Validator::new(ValidationFlags::all(), Capabilities::empty())
        .validate(&module)
        .map_err(|error| ShaderError::InvalidShader(error.to_string()))?;
    Ok(())
}
