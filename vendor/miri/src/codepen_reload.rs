//! Arena-safe MIR transport for a resident Codepen interpreter.
//!
//! A packet contains compiler-encoded MIR, not native code or Rust pointers.
//! Definition identities use rustc's stable paths, and the receiving compiler
//! interns every type and allocation in its own arena. Each packet has its own
//! shorthand cache; offsets from one edit can never resolve into another edit.
use rustc_data_structures::fx::{FxHashMap, FxIndexSet};
use rustc_hir::def::DefKind;
use rustc_hir::def_id::{CrateNum, DefId, DefIndex, DefPathHash, LocalDefId, LOCAL_CRATE};
use rustc_middle::mir::{self, interpret::{self, AllocDecodingState, AllocId}};
use rustc_middle::ty::{self, Ty, TyCtxt, Interner, codec::{TyDecoder, TyEncoder}};
use rustc_serialize::{Decodable, Decoder, Encodable, Encoder, leb128, opaque::{MemDecoder, MAGIC_END_BYTES}};
use rustc_span::{AttrId, BlobDecoder, BytePos, ByteSymbol, ExpnId, FileName, Span, SpanDecoder, SpanEncoder, Symbol, SyntaxContext, DUMMY_SP};
use rustc_span::{ExpnData, ExpnHash, RelativeBytePos, SourceFileHash, MultiByteChar, NormalizedPos, StableSourceFileId, SourceFileLines, Pos};
use rustc_span::hygiene::{self, HygieneEncodeContext, HygieneDecodeContext, SyntaxContextKey, LocalExpnId};
use rustc_data_structures::sync::FreezeLock;
use std::{cell::RefCell, rc::Rc};
use rustc_middle::middle::codegen_fn_attrs::CodegenFnAttrs;

const FORMAT: &str = "gpui-mir-3;rustc=5c543b0b8c73c7b72bc8284ced4fb22ead15734d";

type CodegenAttrsProvider = for<'tcx> fn(TyCtxt<'tcx>, LocalDefId) -> CodegenFnAttrs;
static CODEGEN_ATTRS: std::sync::OnceLock<CodegenAttrsProvider> = std::sync::OnceLock::new();

/// Keep edited functions callable across revisions. SDK MIR retains its normal
/// optimizations; only functions defined in the editable crate resist inlining
/// into a long-lived caller (including the resident entry function).
pub fn override_queries(_: &rustc_session::Session, providers: &mut rustc_middle::util::Providers) {
    CODEGEN_ATTRS.get_or_init(|| providers.queries.codegen_fn_attrs);
    providers.queries.codegen_fn_attrs = |tcx, def| {
        let mut attrs = CODEGEN_ATTRS.get().unwrap()(tcx, def);
        attrs.inline = rustc_attr_ir::InlineAttr::Never;
        attrs
    };
}
type Source = (FileName, SourceFileHash, Option<SourceFileHash>, u32, u32, Vec<RelativeBytePos>, Vec<MultiByteChar>, Vec<NormalizedPos>, Option<String>);
type Encoded = (Vec<u8>, Vec<u64>, Vec<DefPathHash>, Vec<Source>, Vec<(u32, usize)>, Vec<(ExpnHash, usize, u32)>);

struct PacketEncoder<'tcx, const CROSS_CRATE: bool = false> {
    tcx: TyCtxt<'tcx>,
    bytes: Vec<u8>,
    types: FxHashMap<Ty<'tcx>, usize>,
    predicates: FxHashMap<ty::PredicateKind<'tcx>, usize>,
    allocs: FxIndexSet<AllocId>,
    defs: FxIndexSet<DefPathHash>,
    sources: FxIndexSet<String>,
    source_data: Vec<Source>,
    hygiene: Rc<RefCell<HygieneEncodeContext>>,
    spans: bool,
}

impl<'tcx, const CROSS_CRATE: bool> PacketEncoder<'tcx, CROSS_CRATE> {
    fn new(tcx: TyCtxt<'tcx>, spans: bool) -> Self {
        Self { tcx, bytes: Vec::new(), types: Default::default(), predicates: Default::default(),
            allocs: Default::default(), defs: Default::default(), sources: Default::default(),
            source_data: Vec::new(), hygiene: Default::default(), spans }
    }

    fn finish(mut self) -> Encoded {
        let mut offsets = Vec::new();
        let mut next = 0;
        while next < self.allocs.len() {
            let id = self.allocs[next];
            offsets.push(self.bytes.len() as u64);
            let tcx = self.tcx;
            interpret::specialized_encode_alloc_id(&mut self, tcx, id);
            next += 1;
        }
        let mut contexts = Vec::new();
        let mut expansions = Vec::new();
        HygieneEncodeContext::encode(&Rc::clone(&self.hygiene), &mut self,
            |e, id, data| { contexts.push((id, e.bytes.len())); data.encode(e); },
            |e, id, data, hash| {
                let offset = e.bytes.len();
                if let Some(data) = data { data.encode(e); }
                expansions.push((hash, offset, id.local_id.as_u32()));
            });
        self.bytes.extend_from_slice(MAGIC_END_BYTES);
        (self.bytes, offsets, self.defs.into_iter().collect(),
            self.source_data, contexts, expansions)
    }
}

macro_rules! encode_ints {
    ($($method:ident($ty:ty, $write:ident);)*) => {$(
        fn $method(&mut self, value: $ty) {
            let mut buffer = [0; leb128::max_leb128_len::<$ty>()];
            let len = leb128::$write(&mut buffer, value);
            self.bytes.extend_from_slice(&buffer[..len]);
        }
    )*};
}
impl<const CROSS_CRATE: bool> Encoder for PacketEncoder<'_, CROSS_CRATE> {
    encode_ints! {
        emit_usize(usize, write_usize_leb128); emit_u128(u128, write_u128_leb128);
        emit_u64(u64, write_u64_leb128); emit_u32(u32, write_u32_leb128);
        emit_isize(isize, write_isize_leb128); emit_i128(i128, write_i128_leb128);
        emit_i64(i64, write_i64_leb128); emit_i32(i32, write_i32_leb128);
    }
    fn emit_u8(&mut self, value: u8) { self.bytes.push(value); }
    // MemDecoder uses fixed-width little endian for 16-bit integers.
    fn emit_u16(&mut self, value: u16) { self.bytes.extend_from_slice(&value.to_le_bytes()); }
    fn emit_i16(&mut self, value: i16) { self.bytes.extend_from_slice(&value.to_le_bytes()); }
    fn emit_raw_bytes(&mut self, value: &[u8]) { self.bytes.extend_from_slice(value); }
}
impl<const CROSS_CRATE: bool> SpanEncoder for PacketEncoder<'_, CROSS_CRATE> {
    fn encode_span(&mut self, span: Span) {
        let sm = self.tcx.sess.source_map();
        if !self.spans { self.emit_bool(false); return; }
        span.ctxt().encode(self);
        if span.is_dummy() { self.emit_bool(false); return; }
        let file = sm.lookup_source_file(span.lo());
        if !file.contains(span.hi()) { self.emit_bool(false); return; }
        self.emit_bool(true);
        let (index, new) = self.sources.insert_full(file.name.prefer_local_unconditionally().to_string());
        if new {
            self.source_data.push((file.name.clone(), file.src_hash, file.checksum_hash,
                file.normalized_source_len.to_u32(), file.unnormalized_source_len,
                file.lines().to_vec(), file.multibyte_chars.clone(), file.normalized_pos.clone(),
                file.src.as_ref().map(|text| text.to_string())));
        }
        self.emit_usize(index);
        self.emit_u32((span.lo() - file.start_pos).0);
        self.emit_u32((span.hi() - file.start_pos).0);
    }
    fn encode_symbol(&mut self, value: Symbol) { self.emit_str(value.as_str()); }
    fn encode_byte_symbol(&mut self, value: ByteSymbol) { self.emit_byte_str(value.as_byte_str()); }
    fn encode_expn_id(&mut self, id: ExpnId) {
        if self.spans {
            self.hygiene.borrow_mut().schedule_expn_data_for_encoding(id);
            id.expn_hash().encode(self);
        }
    }
    fn encode_syntax_context(&mut self, context: SyntaxContext) {
        if self.spans {
            let index = self.hygiene.borrow_mut().get_syntax_ctxt_encoding_index(context);
            index.encode(self);
        }
    }
    fn encode_crate_num(&mut self, value: CrateNum) { self.tcx.stable_crate_id(value).encode(self); }
    fn encode_def_index(&mut self, _: DefIndex) { panic!("MIR packet contains an unqualified DefIndex"); }
    fn encode_def_id(&mut self, value: DefId) {
        let hash = self.tcx.def_path_hash(value);
        self.defs.insert(hash);
        hash.encode(self);
    }
}
impl<'tcx, const CROSS_CRATE: bool> TyEncoder<'tcx> for PacketEncoder<'tcx, CROSS_CRATE> {
    const CLEAR_CROSS_CRATE: bool = CROSS_CRATE;
    fn position(&self) -> usize { self.bytes.len() }
    fn type_shorthands(&mut self) -> &mut FxHashMap<Ty<'tcx>, usize> { &mut self.types }
    fn predicate_shorthands(&mut self) -> &mut FxHashMap<ty::PredicateKind<'tcx>, usize> { &mut self.predicates }
    fn encode_alloc_id(&mut self, id: &AllocId) { let (index, _) = self.allocs.insert_full(*id); self.emit_u32(index.try_into().unwrap()); }
}

struct PacketDecoder<'a, 'tcx, const CROSS_CRATE: bool = false> {
    origin: CrateNum,
    tcx: TyCtxt<'tcx>,
    bytes: MemDecoder<'a>,
    types: FxHashMap<usize, Ty<'tcx>>,
    allocs: &'a AllocDecodingState,
    sources: Vec<BytePos>,
    hygiene: &'a HygieneDecodeContext,
    contexts: FxHashMap<u32, usize>,
    expansions: FxHashMap<ExpnHash, (usize, u32)>,
    decoded_expansions: FxHashMap<ExpnHash, ExpnId>,
}
macro_rules! decode_ints {
    ($($method:ident -> $ty:ty;)*) => {$(fn $method(&mut self) -> $ty { self.bytes.$method() })*};
}
impl<const CROSS_CRATE: bool> Decoder for PacketDecoder<'_, '_, CROSS_CRATE> {
    decode_ints! {
        read_usize -> usize; read_u128 -> u128; read_u64 -> u64; read_u32 -> u32; read_u16 -> u16; read_u8 -> u8;
        read_isize -> isize; read_i128 -> i128; read_i64 -> i64; read_i32 -> i32; read_i16 -> i16;
    }
    fn read_raw_bytes(&mut self, len: usize) -> &[u8] { self.bytes.read_raw_bytes(len) }
    fn peek_byte(&self) -> u8 { self.bytes.peek_byte() }
    fn position(&self) -> usize { self.bytes.position() }
}
impl<const CROSS_CRATE: bool> BlobDecoder for PacketDecoder<'_, '_, CROSS_CRATE> {
    fn decode_symbol(&mut self) -> Symbol { Symbol::intern(self.read_str()) }
    fn decode_byte_symbol(&mut self) -> ByteSymbol { ByteSymbol::intern(self.read_byte_str()) }
    fn decode_def_index(&mut self) -> DefIndex { panic!("MIR packet contains an unqualified DefIndex"); }
}
impl<const CROSS_CRATE: bool> SpanDecoder for PacketDecoder<'_, '_, CROSS_CRATE> {
    fn decode_span(&mut self) -> Span {
        let context = SyntaxContext::decode(self);
        if !self.read_bool() { return DUMMY_SP; }
        let source = self.read_usize();
        let start = self.sources[source];
        let lo = start + BytePos(self.read_u32());
        let hi = start + BytePos(self.read_u32());
        Span::new(lo, hi, context, None)
    }
    fn decode_expn_id(&mut self) -> ExpnId {
        let hash = ExpnHash::decode(self);
        if hash.is_root() { return ExpnId::root(); }
        if let Some(&id) = self.decoded_expansions.get(&hash) { return id; }
        let (offset, index) = self.expansions[&hash];
        let krate = self.tcx.stable_crate_id_to_crate_num(hash.stable_crate_id());
        let id = if krate == self.origin {
            let data: ExpnData = self.with_position(offset, Decodable::decode);
            // A fresh expansion owns this revision's source spans. Reusing the
            // old hash's expansion would silently return the old caller line.
            self.tcx.with_stable_hashing_context(|hcx| LocalExpnId::fresh(data, hcx).to_expn_id())
        } else { self.tcx.expn_hash_to_expn_id(krate, index.into(), hash) };
        self.decoded_expansions.insert(hash, id);
        id
    }
    fn decode_syntax_context(&mut self) -> SyntaxContext {
        hygiene::decode_syntax_context(self, self.hygiene, |d, index| {
            let offset = d.contexts[&index];
            d.with_position(offset, SyntaxContextKey::decode)
        })
    }
    fn decode_crate_num(&mut self) -> CrateNum {
        let id = Decodable::decode(self);
        self.tcx.stable_crate_id_to_crate_num(id)
    }
    fn decode_def_id(&mut self) -> DefId {
        let hash = Decodable::decode(self);
        self.tcx.def_path_hash_to_def_id(hash).expect("preflighted MIR definition disappeared")
    }
    fn decode_attr_id(&mut self) -> AttrId { self.tcx.sess.psess.attr_id_generator.mk_attr_id() }
}
impl<'tcx, const CROSS_CRATE: bool> ty::InternerDecoder for PacketDecoder<'_, 'tcx, CROSS_CRATE> {
    type Interner = TyCtxt<'tcx>;
    fn interner(&self) -> TyCtxt<'tcx> { self.tcx }
}
impl<'tcx, const CROSS_CRATE: bool> TyDecoder<'tcx> for PacketDecoder<'_, 'tcx, CROSS_CRATE> {
    const CLEAR_CROSS_CRATE: bool = CROSS_CRATE;
    fn cached_ty_for_shorthand<F>(&mut self, position: usize, f: F) -> Ty<'tcx>
        where F: FnOnce(&mut Self) -> Ty<'tcx>
    {
        if let Some(ty) = self.types.get(&position) { return *ty; }
        let ty = f(self);
        self.types.insert(position, ty);
        ty
    }
    fn with_position<F, R>(&mut self, position: usize, f: F) -> R where F: FnOnce(&mut Self) -> R {
        let replacement = self.bytes.split_at(position);
        let old = std::mem::replace(&mut self.bytes, replacement);
        let result = f(self);
        self.bytes = old;
        result
    }
    fn decode_alloc_id(&mut self) -> AllocId { self.allocs.new_decoding_session().decode_alloc_id(self) }
}

fn runtime_body(tcx: TyCtxt<'_>, def: LocalDefId) -> bool {
    matches!(tcx.def_kind(def), DefKind::Fn | DefKind::AssocFn | DefKind::Closure | DefKind::SyntheticCoroutineBody)
        && tcx.is_mir_available(def)
}

fn definitions(tcx: TyCtxt<'_>) -> Vec<LocalDefId> {
    loop {
        // MIR construction can synthesize coroutine bodies and opaque types.
        // Discover them before recording the manifest's complete definition set.
        let _ = tcx.mir_keys(());
        let defs: Vec<_> = tcx.iter_local_def_id().collect();
        for &def in &defs {
            if runtime_body(tcx, def) { let _ = tcx.optimized_mir(def); }
        }
        if tcx.iter_local_def_id().count() == defs.len() { return defs; }
    }
}

/// Binding ordinals are lexical identities within their stable HIR owner.
/// They distinguish shadowed same-name bindings without depending on the HIR
/// node numbers assigned to expressions in an edited function body.
fn binding_identity<'tcx>(tcx: TyCtxt<'tcx>, binding: rustc_hir::HirId) -> (DefPathHash, usize) {
    use rustc_hir::intravisit::{self, Visitor};
    struct Bindings<'tcx> { tcx: TyCtxt<'tcx>, ids: Vec<rustc_hir::HirId> }
    impl<'v> Visitor<'v> for Bindings<'v> {
        type NestedFilter = rustc_middle::hir::nested_filter::OnlyBodies;
        fn maybe_tcx(&mut self) -> Self::MaybeTyCtxt { self.tcx }
        fn visit_pat(&mut self, pat: &'v rustc_hir::Pat<'v>) {
            if let rustc_hir::PatKind::Binding(_, id, _, _) = pat.kind {
                if !self.ids.contains(&id) { self.ids.push(id); }
            }
            intravisit::walk_pat(self, pat);
        }
    }
    let mut bindings = Bindings { tcx, ids: Vec::new() };
    bindings.visit_body(tcx.hir_body_owned_by(binding.owner.def_id));
    (tcx.def_path_hash(binding.owner.def_id.to_def_id()),
        bindings.ids.iter().position(|&id| id == binding).expect("captured binding belongs to its HIR owner"))
}

/// This is intentionally stricter than an ABI signature alone: every definition,
/// generic contract, closure capture layout, impl mapping and compile-time MIR
/// must remain compatible with the resident compiler's already cached queries.
fn contract(tcx: TyCtxt<'_>) -> Vec<u8> {
    let debug_path = std::env::var_os("GPUI_CODEPEN_CONTRACT_MAP");
    let mut sections = Vec::new();
    let mut e = PacketEncoder::<false>::new(tcx, false);
    tcx.sess.target.llvm_target.encode(&mut e);
    tcx.sess.target.data_layout.to_string().encode(&mut e);
    tcx.sess.opts.dep_tracking_hash(true).encode(&mut e);
    tcx.stable_crate_id(LOCAL_CRATE).encode(&mut e);
    let mut dependencies: Vec<_> = tcx.crates(()).iter().map(|&krate|
        (tcx.stable_crate_id(krate), tcx.crate_hash(krate))).collect();
    dependencies.sort_by_key(|&(id, _)| id);
    dependencies.encode(&mut e);
    let defs = definitions(tcx);
    defs.len().encode(&mut e);
    if debug_path.is_some() { sections.push(format!("0\t{}\tcompiler and dependencies", e.bytes.len())); }
    for def in defs {
        let start = e.bytes.len();
        let kind = tcx.def_kind(def);
        tcx.def_path_hash(def.to_def_id()).encode(&mut e);
        format!("{kind:?}").encode(&mut e);
        match kind {
            DefKind::Fn | DefKind::AssocFn | DefKind::Closure | DefKind::Struct | DefKind::Union |
            DefKind::Enum | DefKind::TyAlias | DefKind::AssocTy | DefKind::OpaqueTy |
            DefKind::Const | DefKind::AssocConst | DefKind::Static { .. } | DefKind::Field | DefKind::Ctor(..) | DefKind::Impl { .. } => {
                tcx.type_of(def).instantiate_identity().skip_normalization().encode(&mut e);
            }
            _ => {}
        }
        match kind {
            DefKind::Fn | DefKind::AssocFn | DefKind::Closure | DefKind::Struct | DefKind::Union |
            DefKind::Enum | DefKind::TyAlias | DefKind::AssocTy | DefKind::OpaqueTy |
            DefKind::Const | DefKind::AssocConst | DefKind::Trait | DefKind::Impl { .. } => {
                let generics = tcx.generics_of(def);
                generics.parent.encode(&mut e);
                generics.parent_count.encode(&mut e);
                generics.own_params.encode(&mut e);
                // Rustc's TyEncodable includes this reverse FxHashMap. Its
                // iteration order differs on 32-bit WASM and 64-bit native
                // hosts, even when all generic identities/layouts match.
                let mut indices: Vec<_> = generics.param_def_id_to_index.iter()
                    .map(|(&def, &index)| (tcx.def_path_hash(def), index)).collect();
                indices.sort();
                indices.encode(&mut e);
                generics.has_self.encode(&mut e);
                generics.has_late_bound_regions.encode(&mut e);
                tcx.clauses_of(def).encode(&mut e);
            }
            _ => {}
        }
        if matches!(kind, DefKind::Fn | DefKind::AssocFn | DefKind::Ctor(_, rustc_hir::def::CtorKind::Fn)) {
            tcx.fn_sig(def).instantiate_identity().skip_normalization().encode(&mut e);
            tcx.codegen_fn_attrs(def).encode(&mut e);
            if matches!(kind, DefKind::Fn | DefKind::AssocFn) { tcx.constness(def).encode(&mut e); }
        }
        if matches!(kind, DefKind::Struct | DefKind::Union | DefKind::Enum) {
            let adt = tcx.adt_def(def);
            adt.encode(&mut e);
            adt.has_dtor(tcx).encode(&mut e);
            if adt.is_enum() {
                for (_, value) in adt.discriminants(tcx) { value.val.encode(&mut e); }
            }
        }
        if matches!(kind, DefKind::AssocFn | DefKind::AssocTy | DefKind::AssocConst) {
            tcx.associated_item(def).defaultness(tcx).encode(&mut e);
        }
        if kind == DefKind::Closure {
            tcx.codegen_fn_attrs(def).encode(&mut e);
            tcx.closure_user_provided_sig(def).encode(&mut e);
            let captures = tcx.closure_captures(def);
            captures.len().encode(&mut e);
            for capture in captures {
                binding_identity(tcx, capture.get_root_variable()).encode(&mut e);
                capture.var_ident.name.encode(&mut e);
                capture.place.base_ty.encode(&mut e);
                capture.place.projections.encode(&mut e);
                capture.info.capture_kind.encode(&mut e);
                capture.mutability.encode(&mut e);
            }
        }
        if runtime_body(tcx, def) && tcx.coroutine_kind(def).is_some() {
            tcx.mir_coroutine_witnesses(def).encode(&mut e);
            let witness = tcx.coroutine_hidden_types(def.to_def_id()).skip_binder();
            witness.bound_vars().encode(&mut e);
            witness.skip_binder().types.encode(&mut e);
            witness.skip_binder().assumptions.encode(&mut e);
        }
        if kind == DefKind::SyntheticCoroutineBody {
            tcx.codegen_fn_attrs(def).encode(&mut e);
        }
        if matches!(kind, DefKind::Impl { .. }) {
            let trait_ref = tcx.impl_opt_trait_ref(def);
            trait_ref.encode(&mut e);
            if trait_ref.is_some() {
                tcx.impl_polarity(def).encode(&mut e);
                tcx.impl_is_default(def.to_def_id()).encode(&mut e);
            }
        }
        if kind == DefKind::Trait {
            tcx.trait_def(def).encode(&mut e);
            let graph = tcx.specialization_graph_of(def).expect("analyzed specialization graph");
            let parents = graph.parent.items().map(|(&child, &parent)|
                (tcx.def_path_hash(child), tcx.def_path_hash(parent))).into_sorted_stable_ord();
            parents.encode(&mut e);
        }
        if matches!(kind, DefKind::Impl { .. } | DefKind::Trait) {
            let items: Vec<_> = tcx.associated_items(def).in_definition_order().map(|item| item.def_id).collect();
            items.encode(&mut e);
        }
        if tcx.is_mir_available(def) {
            if runtime_body(tcx, def) {
                tcx.promoted_mir(def).encode(&mut e);
                if kind == DefKind::SyntheticCoroutineBody || tcx.coroutine_kind(def).is_some() || tcx.is_const_fn(def.to_def_id()) {
                    tcx.optimized_mir(def).encode(&mut e);
                }
            } else {
                tcx.instance_mir(ty::InstanceKind::Item(def.to_def_id())).encode(&mut e);
            }
        }
        if debug_path.is_some() {
            sections.push(format!("{start}\t{}\t{kind:?} {}", e.bytes.len(), tcx.def_path_str(def)));
        }
    }
    let start = e.bytes.len();
    let bytes = e.finish().0;
    if let Some(path) = debug_path {
        sections.push(format!("{start}\t{}\tallocations and sentinel", bytes.len()));
        std::fs::write(path, sections.join("\n")).expect("MIR contract diagnostic map");
    }
    bytes
}

/// Serialize executable function bodies after ordinary Rust analysis succeeds.
pub fn export(tcx: TyCtxt<'_>) -> Vec<u8> {
    // rlib packets cross the same metadata boundary as their bundled starter.
    // Bin packets keep local diagnostic data, matching rustc's on-disk cache.
    if tcx.crate_types().contains(&rustc_structures::CrateType::Executable) {
        export_impl::<false>(tcx)
    } else { export_impl::<true>(tcx) }
}
fn export_impl<const CROSS_CRATE: bool>(tcx: TyCtxt<'_>) -> Vec<u8> {
    let mut e = PacketEncoder::<CROSS_CRATE>::new(tcx, true);
    let defs: Vec<_> = definitions(tcx).into_iter().filter(|&def| runtime_body(tcx, def)).collect();
    defs.len().encode(&mut e);
    for def in defs {
        def.to_def_id().encode(&mut e);
        tcx.optimized_mir(def).encode(&mut e);
    }
    let (bodies, offsets, defs, sources, contexts, expansions) = e.finish();
    let mut envelope = PacketEncoder::<false>::new(tcx, false);
    FORMAT.encode(&mut envelope);
    CROSS_CRATE.encode(&mut envelope);
    tcx.stable_crate_id(LOCAL_CRATE).encode(&mut envelope);
    std::env::var("GPUI_CODEPEN_BASELINE_HASH").ok().encode(&mut envelope);
    let keys: Vec<_> = definitions(tcx).into_iter().filter(|&def| runtime_body(tcx, def)).map(|def| tcx.def_path_hash(def.to_def_id())).collect();
    keys.encode(&mut envelope);
    contract(tcx).encode(&mut envelope);
    offsets.encode(&mut envelope);
    defs.encode(&mut envelope);
    sources.encode(&mut envelope);
    contexts.encode(&mut envelope);
    expansions.encode(&mut envelope);
    bodies.encode(&mut envelope);
    envelope.finish().0
}

pub struct Overlay<'tcx> {
    contract: Vec<u8>,
    pub revision: u64,
    bytes_installed: usize,
    expected: FxIndexSet<DefId>,
    pub krate: CrateNum,
    pub bodies: FxHashMap<DefId, &'tcx mir::Body<'tcx>>,
}
impl<'tcx> Overlay<'tcx> {
    pub fn new(tcx: TyCtxt<'tcx>) -> Self {
        Self { contract: contract(tcx), revision: 0, bytes_installed: 0,
            expected: definitions(tcx).into_iter().filter(|&def| runtime_body(tcx, def)).map(|def| def.to_def_id()).collect(),
            krate: LOCAL_CRATE, bodies: Default::default() }
    }

    /// Decode only after compatibility and every referenced definition have
    /// passed preflight. Publishing the complete map is a single transaction.
    pub fn apply(&mut self, tcx: TyCtxt<'tcx>, packet: &[u8]) -> Result<(), String> {
        // rustc arenas retain active-frame bodies. Bound the retained generations
        // until body ownership can be reclaimed independently of the TyCtxt.
        if self.revision >= 256 || self.bytes_installed.saturating_add(packet.len()) > 128 * 1024 * 1024 {
            return Err("Resident MIR revision budget exhausted".into());
        }
        let mut header = MemDecoder::new(packet, 0).map_err(|_| "Invalid MIR packet")?;
        if String::decode(&mut header) != FORMAT { return Err("MIR packet version differs".into()); }
        let cross_crate = bool::decode(&mut header);
        let origin: rustc_span::def_id::StableCrateId = Decodable::decode(&mut header);
        let _: Option<String> = Decodable::decode(&mut header);
        let keys: Vec<DefPathHash> = Decodable::decode(&mut header);
        let expected: FxIndexSet<_> = keys.iter().filter_map(|&hash| tcx.def_path_hash_to_def_id(hash)).collect();
        if origin != tcx.stable_crate_id(self.krate) || expected != self.expected || keys.len() != expected.len() {
            return Err("MIR function identity set changed".into());
        }
        let contract = Vec::<u8>::decode(&mut header);
        if contract != self.contract {
            let first = contract.iter().zip(&self.contract).position(|(new, old)| new != old)
                .unwrap_or(contract.len().min(self.contract.len()));
            return Err(format!("Rust type or compile-time contract changed at byte {first} ({} -> {} bytes)",
                self.contract.len(), contract.len()));
        }
        if cross_crate { self.decode::<true>(tcx, packet.len(), &mut header) }
        else { self.decode::<false>(tcx, packet.len(), &mut header) }
    }

    fn decode<const CROSS_CRATE: bool>(&mut self, tcx: TyCtxt<'tcx>, packet_len: usize, header: &mut MemDecoder<'_>) -> Result<(), String> {
        let offsets: Vec<u64> = Decodable::decode(header);
        let defs: Vec<DefPathHash> = Decodable::decode(header);
        if defs.iter().any(|&hash| tcx.def_path_hash_to_def_id(hash).is_none()) { return Err("Rust definition changed".into()); }
        let sources: Vec<Source> = Decodable::decode(header);
        let contexts: Vec<(u32, usize)> = Decodable::decode(header);
        let expansions: Vec<(ExpnHash, usize, u32)> = Decodable::decode(header);
        let bodies: Vec<u8> = Decodable::decode(header);
        let allocs = AllocDecodingState::new(offsets);
        let sources = sources.into_iter().enumerate().map(|(index, (name, hash, checksum, len, raw_len, lines, multibyte, normalized, text))| {
            let identity = StableSourceFileId::from_filename_for_export(
                &FileName::Custom(format!("codepen revision {} source {index}", tcx.sess.source_map().files().len())),
                tcx.stable_crate_id(self.krate));
            let file = tcx.sess.source_map().new_imported_source_file(name, hash, checksum, identity,
                len, raw_len, self.krate, FreezeLock::new(SourceFileLines::Lines(lines)), multibyte, normalized, 0);
            if let Some(text) = text { file.add_external_src(|| Some(text)); }
            file.start_pos
        }).collect();
        let hygiene = HygieneDecodeContext::default();
        let mut d = PacketDecoder::<CROSS_CRATE> { tcx, origin: self.krate, bytes: MemDecoder::new(&bodies, 0).map_err(|_| "Invalid MIR bodies")?,
            types: Default::default(), allocs: &allocs, sources, hygiene: &hygiene,
            contexts: contexts.into_iter().collect(), expansions: expansions.into_iter().map(|(hash, offset, index)| (hash, (offset, index))).collect(),
            decoded_expansions: Default::default() };
        let mut replacement = FxHashMap::default();
        if d.read_usize() != self.expected.len() { return Err("Incomplete MIR function set".into()); }
        for _ in 0..self.expected.len() {
            let def: DefId = Decodable::decode(&mut d);
            if !self.expected.contains(&def) || replacement.contains_key(&def) {
                return Err("Unexpected or duplicate MIR function".into());
            }
            let body = mir::Body::decode(&mut d);
            let original = tcx.optimized_mir(def);
            if body.source.def_id() != def || body.arg_count != original.arg_count
                || body.spread_arg != original.spread_arg
                || body.local_decls.iter().take(body.arg_count + 1).map(|local| local.ty)
                    .ne(original.local_decls.iter().take(original.arg_count + 1).map(|local| local.ty))
            { return Err("Compiled MIR function ABI differs".into()); }
            // An active function's old stack locals and instruction pointer
            // belong to its old body. Keep that body until its invocation ends.
            // Future calls use the replacement, so live frames are never edited.
            replacement.insert(def, &*tcx.arena.alloc(body));
        }
        self.bodies = replacement;
        self.revision += 1;
        self.bytes_installed += packet_len;
        Ok(())
    }
}

pub fn install<'tcx>(ecx: &mut crate::MiriInterpCx<'tcx>, packet: &[u8]) -> Result<(), String> {
    let tcx = *ecx.tcx;
    let overlay = ecx.machine.codepen_overlay.get_or_insert_with(|| Overlay::new(tcx));
    overlay.apply(tcx, packet)
}

/// Establish identity from an immutable packet shipped beside the exact rmeta
/// that the resident compiler loaded. Future edits must match its contract.
pub fn install_baseline<'tcx>(ecx: &mut crate::MiriInterpCx<'tcx>, packet: &[u8]) -> Result<(), String> {
    if ecx.machine.codepen_overlay.is_some() { return Err("MIR baseline already installed".into()); }
    let tcx = *ecx.tcx;
    let mut header = MemDecoder::new(packet, 0).map_err(|_| "Invalid MIR baseline")?;
    if String::decode(&mut header) != FORMAT || !bool::decode(&mut header) { return Err("Invalid starter MIR format".into()); }
    let origin: rustc_span::def_id::StableCrateId = Decodable::decode(&mut header);
    let root_hash: Option<String> = Decodable::decode(&mut header);
    let krate = tcx.crates(()).iter().copied().find(|&krate| tcx.stable_crate_id(krate) == origin).ok_or("Starter metadata is not loaded")?;
    if Some(tcx.crate_hash(krate).to_string()) != root_hash { return Err("Starter MIR and metadata differ".into()); }
    let keys: Vec<DefPathHash> = Decodable::decode(&mut header);
    let expected: FxIndexSet<_> = keys.iter().filter_map(|&hash| tcx.def_path_hash_to_def_id(hash)).collect();
    if keys.len() != expected.len() || expected.iter().any(|def| def.krate != krate) { return Err("Invalid starter function identities".into()); }
    let contract = Decodable::decode(&mut header);
    let mut overlay = Overlay { contract, revision: 0, bytes_installed: 0, expected, krate, bodies: Default::default() };
    overlay.apply(tcx, packet)?;
    ecx.machine.codepen_overlay = Some(overlay);
    Ok(())
}
