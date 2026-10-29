//! Test-only ordered immutable cold extents. No rendering reuse authority.
use super::cold_correspondence::{Wire, decode, encode};
use serde_json::json;
use std::{collections::VecDeque, sync::Arc};
const ROW: usize = 24;
const BLOCK: usize = 32;
const TINY: usize = 8;
const ARC_CONTROL: usize = 2 * size_of::<usize>();
#[derive(Clone, Copy, Debug)]
enum Mode {
    Raw,
    Absolute,
    Relative,
}
impl Mode {
    fn relative(self) -> bool {
        matches!(self, Self::Relative)
    }
}
struct Piece {
    start: u32,
    offset: u8,
    len: u8,
    block: Arc<Vec<u8>>,
}
enum Data {
    Raw(Vec<u8>),
    Pieces(Vec<Piece>),
}
struct Version {
    namespace: u64,
    epoch: u64,
    len: usize,
    relative: bool,
    data: Data,
}
#[derive(Default, Clone, Copy, serde::Serialize)]
struct Work {
    producer_records: usize,
    old_point_decodes: usize,
    old_directory_searches: usize,
    old_directory_comparisons: usize,
    cursor_hits: usize,
    reusable_records: usize,
    new_encoded_records: usize,
    new_encoded_bytes: usize,
    raw_copied_bytes: usize,
    new_chunks: usize,
    new_chunk_control_bytes: usize,
    lease_clones: usize,
    descriptor_bytes_written: usize,
    descriptor_bytes_copied: usize,
    split_slice_descriptors: usize,
    before_compaction_pieces: usize,
    compactions: usize,
    compaction_decodes: usize,
    compaction_encoded_bytes: usize,
    compaction_new_chunks: usize,
    compaction_chunk_control_bytes: usize,
    compaction_directory_searches: usize,
    compaction_directory_comparisons: usize,
    compaction_cursor_hits: usize,
    builder_piece_capacity_peak_bytes: usize,
    scratch_capacity_peak_bytes: usize,
    peak_known_version_storage_bytes: usize,
    accounting_piece_visits: usize,
    accounting_scratch_capacity_peak_bytes: usize,
    verification_decodes: usize,
    version_lease_clones: usize,
    encoder_field_reads: usize,
}
#[derive(Default, serde::Serialize)]
struct Memory {
    bytes: usize,
    versions: usize,
    unique_blocks: usize,
    block_payload_bytes: usize,
    block_control_bytes: usize,
    version_control_bytes: usize,
    directory_capacity_bytes: usize,
    raw_buffer_capacity_bytes: usize,
    piece_visits: usize,
    physical_block_records: usize,
    referenced_block_records: usize,
    unreferenced_block_records: usize,
    accounting_scratch_capacity_bytes: usize,
}
fn memory(roots: &[(&Version, bool)]) -> Memory {
    let mut out = Memory::default();
    let mut chunks: Vec<(usize, usize, u64, usize)> = Vec::new();
    let mut versions: Vec<usize> = Vec::new();
    for &(v, arc) in roots {
        let address = v as *const Version as usize;
        if versions.contains(&address) {
            continue;
        }
        versions.push(address);
        out.versions += 1;
        out.version_control_bytes += size_of::<Version>() + if arc { ARC_CONTROL } else { 0 };
        match &v.data {
            Data::Raw(raw) => out.raw_buffer_capacity_bytes += raw.capacity(),
            Data::Pieces(pieces) => {
                out.directory_capacity_bytes += pieces.capacity() * size_of::<Piece>();
                for p in pieces {
                    out.piece_visits += 1;
                    chunks.push((
                        Arc::as_ptr(&p.block) as usize,
                        p.block.capacity(),
                        ((1u64 << p.len) - 1) << p.offset,
                        usize::from(p.block[1]),
                    ));
                }
            }
        }
    }
    out.accounting_scratch_capacity_bytes = chunks.capacity()
        * size_of::<(usize, usize, u64, usize)>()
        + versions.capacity() * size_of::<usize>();
    chunks.sort_unstable_by_key(|x| x.0);
    chunks.dedup_by(|a, b| {
        if a.0 == b.0 {
            b.2 |= a.2;
            true
        } else {
            false
        }
    });
    out.physical_block_records = chunks.iter().map(|x| x.3).sum();
    out.referenced_block_records = chunks.iter().map(|x| x.2.count_ones() as usize).sum();
    out.unreferenced_block_records = out.physical_block_records - out.referenced_block_records;
    out.unique_blocks = chunks.len();
    out.block_payload_bytes = chunks.iter().map(|x| x.1).sum();
    out.block_control_bytes = chunks.len() * (ARC_CONTROL + size_of::<Vec<u8>>());
    out.bytes = out.block_payload_bytes
        + out.block_control_bytes
        + out.version_control_bytes
        + out.directory_capacity_bytes
        + out.raw_buffer_capacity_bytes;
    out
}
impl Version {
    fn stored(
        &self,
        index: usize,
        cursor: &mut Option<usize>,
        work: &mut Work,
    ) -> (Wire, Option<(usize, u8)>) {
        assert!(index < self.len);
        match &self.data {
            Data::Raw(raw) => (Wire::read(&raw[index * ROW..(index + 1) * ROW]), None),
            Data::Pieces(pieces) => {
                let hit = cursor.filter(|&i| {
                    let p = &pieces[i];
                    index >= p.start as usize && index < p.start as usize + usize::from(p.len)
                });
                let i = if let Some(i) = hit {
                    work.cursor_hits += 1;
                    i
                } else {
                    work.old_directory_searches += 1;
                    let (mut low, mut high) = (0, pieces.len());
                    while low < high {
                        work.old_directory_comparisons += 1;
                        let mid = (low + high) / 2;
                        if pieces[mid].start as usize <= index {
                            low = mid + 1;
                        } else {
                            high = mid;
                        }
                    }
                    low.checked_sub(1).unwrap()
                };
                *cursor = Some(i);
                let p = &pieces[i];
                let offset = usize::from(p.offset) + index - p.start as usize;
                assert!(offset < usize::from(p.offset) + usize::from(p.len));
                (decode(&p.block, offset), Some((i, offset as u8)))
            }
        }
    }
    fn record(&self, index: usize) -> Wire {
        let (wire, _) = self.stored(index, &mut None, &mut Work::default());
        if self.relative && matches!(self.data, Data::Pieces(_)) {
            wire.absolute(index)
        } else {
            wire
        }
    }
}
struct Builder {
    mode: Mode,
    namespace: u64,
    epoch: u64,
    expected: usize,
    len: usize,
    old: Option<Arc<Version>>,
    cursor: Option<usize>,
    raw: Vec<u8>,
    pieces: Vec<Piece>,
    scratch: Vec<Wire>,
    scratch_start: usize,
    work: Work,
}
impl Builder {
    fn new(mode: Mode, namespace: u64, epoch: u64, old: Option<Arc<Version>>) -> Self {
        Self {
            mode,
            namespace,
            epoch,
            expected: 0,
            len: 0,
            old: old.filter(|v| v.namespace == namespace && epoch > v.epoch),
            cursor: None,
            raw: Vec::new(),
            pieces: Vec::new(),
            scratch: Vec::new(),
            scratch_start: 0,
            work: Work::default(),
        }
    }
    fn reserve(&mut self, n: usize) {
        self.expected = n;
        if matches!(self.mode, Mode::Raw) || n <= TINY {
            self.raw.reserve_exact(n * ROW);
        } else {
            self.pieces.reserve_exact(n);
            self.scratch.reserve_exact(BLOCK);
            self.work.builder_piece_capacity_peak_bytes =
                self.pieces.capacity() * size_of::<Piece>();
            self.work.scratch_capacity_peak_bytes = self.scratch.capacity() * size_of::<Wire>();
        }
    }
    fn flush(&mut self) {
        if self.scratch.is_empty() {
            return;
        }
        let bytes = encode(&self.scratch);
        self.work.encoder_field_reads += self.scratch.len() * 12;
        self.work.new_encoded_records += self.scratch.len();
        self.work.new_encoded_bytes += bytes.len();
        self.work.new_chunks += 1;
        self.work.new_chunk_control_bytes += ARC_CONTROL + size_of::<Vec<u8>>();
        self.pieces.push(Piece {
            start: self.scratch_start as u32,
            offset: 0,
            len: self.scratch.len() as u8,
            block: Arc::new(bytes),
        });
        self.work.descriptor_bytes_written += size_of::<Piece>();
        self.scratch.clear();
    }
    fn push(&mut self, index: usize, old_rank: Option<usize>, wire: Wire) {
        assert_eq!(self.len, index);
        self.work.producer_records += 1;
        if matches!(self.mode, Mode::Raw) || self.expected <= TINY {
            wire.write(&mut self.raw);
            self.work.raw_copied_bytes += ROW;
            self.len += 1;
            return;
        }
        let value = if self.mode.relative() {
            wire.relative(index)
        } else {
            wire
        };
        let reuse = if let (Some(old), Some(rank)) = (&self.old, old_rank) {
            self.work.old_point_decodes += 1;
            let (old_value, location) = old.stored(rank, &mut self.cursor, &mut self.work);
            assert_eq!(old_value.0[0], wire.0[0], "surviving identity required");
            if old.relative == self.mode.relative()
                && matches!(old.data, Data::Pieces(_))
                && old_value == value
            {
                location
            } else {
                None
            }
        } else {
            None
        };
        if let Some((piece, offset)) = reuse {
            self.flush();
            let old = self.old.as_ref().unwrap();
            let Data::Pieces(old_pieces) = &old.data else {
                unreachable!()
            };
            let block = &old_pieces[piece].block;
            if let Some(last) = self.pieces.last_mut()
                && Arc::ptr_eq(&last.block, block)
                && usize::from(last.offset) + usize::from(last.len) == usize::from(offset)
            {
                last.len += 1;
                self.work.descriptor_bytes_written += size_of::<u8>();
            } else {
                self.pieces.push(Piece {
                    start: index as u32,
                    offset,
                    len: 1,
                    block: Arc::clone(block),
                });
                self.work.lease_clones += 1;
                self.work.descriptor_bytes_written += size_of::<Piece>();
                if offset != 0 || usize::from(old_pieces[piece].len) != 1 {
                    self.work.split_slice_descriptors += 1;
                }
            }
            self.work.reusable_records += 1;
        } else {
            if self.scratch.is_empty() {
                self.scratch_start = index;
            }
            self.scratch.push(value);
            if self.scratch.len() == BLOCK {
                self.flush();
            }
        }
        self.len += 1;
    }
    fn finish(mut self, old_roots: &[&Version]) -> (Arc<Version>, Work) {
        assert_eq!(self.expected, self.len);
        self.flush();
        let mut version = Version {
            namespace: self.namespace,
            epoch: self.epoch,
            len: self.len,
            relative: self.mode.relative(),
            data: if matches!(self.mode, Mode::Raw) || self.expected <= TINY {
                Data::Raw(std::mem::take(&mut self.raw))
            } else {
                Data::Pieces(std::mem::take(&mut self.pieces))
            },
        };
        let mut roots: Vec<_> = old_roots.iter().map(|v| (*v, true)).collect();
        roots.push((&version, false));
        let m = memory(&roots);
        self.work.peak_known_version_storage_bytes = m.bytes;
        self.work.accounting_piece_visits += m.piece_visits;
        self.work.accounting_scratch_capacity_peak_bytes = m.accounting_scratch_capacity_bytes
            + roots.capacity() * size_of::<(&Version, bool)>()
            + old_roots.len() * size_of::<&Version>();
        drop(roots);
        if let Data::Pieces(pieces) = &version.data {
            self.work.before_compaction_pieces = pieces.len();
            if pieces.len() > 2 * self.len.div_ceil(BLOCK) + 2 {
                self.work.compactions = 1;
                let mut compact = Vec::with_capacity(self.len.div_ceil(BLOCK));
                let mut scratch = Vec::with_capacity(BLOCK);
                let mut cursor = None;
                let mut traversal = Work::default();
                for index in 0..self.len {
                    let (wire, _) = version.stored(index, &mut cursor, &mut traversal);
                    scratch.push(wire);
                    self.work.compaction_decodes += 1;
                    if scratch.len() == BLOCK || index + 1 == self.len {
                        let bytes = encode(&scratch);
                        self.work.encoder_field_reads += scratch.len() * 12;
                        self.work.compaction_chunk_control_bytes +=
                            ARC_CONTROL + size_of::<Vec<u8>>();
                        self.work.compaction_encoded_bytes += bytes.len();
                        self.work.compaction_new_chunks += 1;
                        compact.push(Piece {
                            start: (index + 1 - scratch.len()) as u32,
                            offset: 0,
                            len: scratch.len() as u8,
                            block: Arc::new(bytes),
                        });
                        self.work.descriptor_bytes_written += size_of::<Piece>();
                        scratch.clear();
                    }
                }
                self.work.compaction_directory_searches = traversal.old_directory_searches;
                self.work.compaction_directory_comparisons = traversal.old_directory_comparisons;
                self.work.compaction_cursor_hits = traversal.cursor_hits;
                let new = Version {
                    namespace: self.namespace,
                    epoch: self.epoch,
                    len: self.len,
                    relative: self.mode.relative(),
                    data: Data::Pieces(compact),
                };
                let mut roots: Vec<_> = old_roots.iter().map(|v| (*v, true)).collect();
                roots.push((&version, false));
                roots.push((&new, false));
                let m = memory(&roots);
                self.work.peak_known_version_storage_bytes =
                    self.work.peak_known_version_storage_bytes.max(m.bytes);
                self.work.accounting_piece_visits += m.piece_visits;
                self.work.accounting_scratch_capacity_peak_bytes =
                    self.work.accounting_scratch_capacity_peak_bytes.max(
                        m.accounting_scratch_capacity_bytes
                            + roots.capacity() * size_of::<(&Version, bool)>()
                            + old_roots.len() * size_of::<&Version>(),
                    );
                self.work.scratch_capacity_peak_bytes += scratch.capacity() * size_of::<Wire>();
                drop(roots);
                version = new;
            } else if pieces.len() != pieces.capacity() {
                let Data::Pieces(loose) =
                    std::mem::replace(&mut version.data, Data::Raw(Vec::new()))
                else {
                    unreachable!()
                };
                let mut tight = Vec::with_capacity(loose.len());
                self.work.descriptor_bytes_copied += loose.len() * size_of::<Piece>();
                // Charge both directory allocations during this explicit move.
                self.work.peak_known_version_storage_bytes += tight.capacity() * size_of::<Piece>();
                for piece in loose {
                    tight.push(piece);
                }
                version.data = Data::Pieces(tight);
            }
        }
        (Arc::new(version), self.work)
    }
}
struct State {
    mode: Mode,
    current: Option<Arc<Version>>,
    history: VecDeque<Arc<Version>>,
    pending: Option<Builder>,
    work: Work,
}
impl State {
    fn new(mode: Mode) -> Self {
        Self {
            mode,
            current: None,
            history: VecDeque::new(),
            pending: None,
            work: Work::default(),
        }
    }
    fn begin(&mut self, namespace: u64, epoch: u64) {
        self.pending = Some(Builder::new(
            self.mode,
            namespace,
            epoch,
            self.current.clone(),
        ));
        self.pending.as_mut().unwrap().work.version_lease_clones =
            usize::from(self.current.is_some());
    }
    fn finish(&mut self) {
        let old: Vec<_> = self
            .current
            .iter()
            .chain(&self.history)
            .map(|v| &**v)
            .collect();
        let (version, mut work) = self.pending.take().unwrap().finish(&old);
        let mut roots: Vec<_> = old.iter().map(|v| (*v, true)).collect();
        roots.push((&version, true));
        let m = memory(&roots);
        work.peak_known_version_storage_bytes = work.peak_known_version_storage_bytes.max(m.bytes);
        work.accounting_piece_visits += m.piece_visits;
        work.accounting_scratch_capacity_peak_bytes =
            work.accounting_scratch_capacity_peak_bytes.max(
                m.accounting_scratch_capacity_bytes
                    + roots.capacity() * size_of::<(&Version, bool)>()
                    + old.capacity() * size_of::<&Version>(),
            );
        drop(roots);
        drop(old);
        if let Some(previous) = self.current.replace(version) {
            self.history.push_back(previous);
        }
        while self.history.len() > 2 {
            self.history.pop_front();
        }
        self.work = work;
    }
    fn report(&self) -> serde_json::Value {
        let roots: Vec<_> = self
            .current
            .iter()
            .chain(&self.history)
            .map(|v| (&**v, true))
            .collect();
        let m = memory(&roots);
        let current = self.current.as_ref().unwrap();
        let one = memory(&[(current, true)]);
        let pieces = match &current.data {
            Data::Raw(_) => 0,
            Data::Pieces(p) => p.len(),
        };
        // Pending descriptors can share blocks with retained roots. Only new block
        // allocations are added here; the retained baseline already owns shared ones.
        let mut owned_blocks: Vec<usize> = roots
            .iter()
            .flat_map(|(v, _)| match &v.data {
                Data::Raw(_) => &[][..],
                Data::Pieces(p) => p.as_slice(),
            })
            .map(|p| Arc::as_ptr(&p.block) as usize)
            .collect();
        let pending_heap = self.pending.as_ref().map_or(0, |b| {
            let mut bytes = b.raw.capacity()
                + b.pieces.capacity() * size_of::<Piece>()
                + b.scratch.capacity() * size_of::<Wire>();
            for p in &b.pieces {
                let address = Arc::as_ptr(&p.block) as usize;
                if !owned_blocks.contains(&address) {
                    bytes += p.block.capacity() + ARC_CONTROL + size_of::<Vec<u8>>();
                    owned_blocks.push(address);
                }
            }
            bytes
        });
        let pending_work = self.pending.as_ref().map(|b| b.work);
        json!({"mode":format!("{:?}",self.mode),"status":if self.pending.is_none(){"complete logical store"}else{"incomplete; no reuse authority"},"records":current.len,"source_epoch":current.epoch,"current_pieces":pieces,"retained_old_versions":self.history.len(),"current":one,"all_retained":m,"state_header_bytes":size_of::<State>(),"history_handle_capacity_bytes":self.history.capacity()*size_of::<Arc<Version>>(),"current_and_history_plus_state_bytes":m.bytes+size_of::<State>()+self.history.capacity()*size_of::<Arc<Version>>()+pending_heap,"pending_heap_bytes":pending_heap,"pending_work":pending_work,"post_report_block_scratch_capacity_bytes":owned_blocks.capacity()*size_of::<usize>(),"builder_header_bytes":size_of::<Builder>(),"encoder_base_width_stack_bytes":36,"piece_bytes":size_of::<Piece>(),"arc_control_bytes":ARC_CONTROL,"work":self.work})
    }
}
pub(super) struct Trials {
    states: [State; 3],
}
impl Default for Trials {
    fn default() -> Self {
        Self {
            states: [
                State::new(Mode::Raw),
                State::new(Mode::Absolute),
                State::new(Mode::Relative),
            ],
        }
    }
}
impl Trials {
    pub(super) fn begin(&mut self, namespace: u64, epoch: u64) {
        for s in &mut self.states {
            s.begin(namespace, epoch);
        }
    }
    pub(super) fn reserve(&mut self, n: usize) {
        for s in &mut self.states {
            s.pending.as_mut().unwrap().reserve(n);
        }
    }
    pub(super) fn push(&mut self, index: usize, old: Option<usize>, wire: Wire) {
        for s in &mut self.states {
            s.pending.as_mut().unwrap().push(index, old, wire);
        }
    }
    pub(super) fn finish(&mut self, oracle: &super::cold_correspondence::Trials) {
        for s in &mut self.states {
            s.finish();
            let v = s.current.as_ref().unwrap();
            for i in 0..v.len {
                assert_eq!(v.record(i), oracle.raw_record(i));
                s.work.verification_decodes += 1;
            }
        }
    }
    pub(super) fn report(&self) -> serde_json::Value {
        json!({"scope":"CPU immutable cold versions only; no layout/paint/resource/GPU authority","alternatives":self.states.iter().map(State::report).collect::<Vec<_>>()})
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn record(i: usize, entropy: bool) -> Wire {
        let id = if entropy {
            (i as u64).wrapping_mul(0x9e3779b97f4a7c15).wrapping_add(1)
        } else {
            i as u64 + 1
        };
        let links = if entropy {
            let bound = super::super::MAX_NODES;
            super::super::links::NodeLinks::new(
                if i == 0 {
                    None
                } else {
                    Some(((id >> 24) as usize) % i)
                },
                (((id >> 8) as usize) % bound) as u32,
                Some((id as usize) % bound),
            )
        } else {
            super::super::links::NodeLinks::new(
                (i != 0).then_some(i.saturating_sub(1)),
                (i % 17) as u32,
                Some(i),
            )
        };
        Wire([
            id,
            links.word(),
            if entropy {
                (id >> 32) & u64::from(u32::MAX)
            } else {
                3
            },
            if entropy { id & u64::from(u32::MAX) } else { 0 },
        ])
    }
    fn update(s: &mut State, namespace: u64, epoch: u64, rows: &[(Option<usize>, Wire)]) {
        s.begin(namespace, epoch);
        s.pending.as_mut().unwrap().reserve(rows.len());
        for (i, (old, wire)) in rows.iter().enumerate() {
            s.pending.as_mut().unwrap().push(i, *old, *wire);
        }
        s.finish();
        let v = s.current.as_ref().unwrap();
        for (i, (_, wire)) in rows.iter().enumerate() {
            assert_eq!(v.record(i), *wire);
        }
    }
    #[test]
    fn actual_lease_overhead_and_boundary_storage() {
        let block = allocation_counter::measure(|| {
            let b = Arc::new(Vec::<u8>::new());
            std::hint::black_box(&b);
        });
        assert_eq!(
            block.bytes_total as usize,
            ARC_CONTROL + size_of::<Vec<u8>>()
        );
        let root = allocation_counter::measure(|| {
            let v = Arc::new(Version {
                namespace: 1,
                epoch: 0,
                len: 0,
                relative: false,
                data: Data::Raw(Vec::new()),
            });
            std::hint::black_box(&v);
        });
        assert_eq!(
            root.bytes_total as usize,
            ARC_CONTROL + size_of::<Version>()
        );
        println!(
            "\nORDERED_CONTROLS {}",
            json!({"block_allocation":block.bytes_total,"version_allocation":root.bytes_total,"state_bytes":size_of::<State>(),"trial_bytes":size_of::<Trials>(),"piece_bytes":size_of::<Piece>(),"builder_bytes":size_of::<Builder>()})
        );
        for n in [0, 1, 2, 7, 8, 9, 31, 32, 33, 63, 64, 65, 257] {
            for entropy in [false, true] {
                let rows: Vec<_> = (0..n).map(|i| (None, record(i, entropy))).collect();
                for mode in [Mode::Raw, Mode::Absolute, Mode::Relative] {
                    let mut s = State::new(mode);
                    let allocation = allocation_counter::measure(|| update(&mut s, 7, 0, &rows));
                    let roots: Vec<_> = s
                        .current
                        .iter()
                        .chain(&s.history)
                        .map(|v| (&**v, true))
                        .collect();
                    assert_eq!(
                        allocation.bytes_current as usize,
                        memory(&roots).bytes + s.history.capacity() * size_of::<Arc<Version>>()
                    );
                    drop(roots);
                    if n <= TINY {
                        assert!(matches!(s.current.as_ref().unwrap().data, Data::Raw(_)));
                    }
                    println!(
                        "\nORDERED_STORAGE {}",
                        json!({"n":n,"entropy":entropy,"report":s.report()})
                    );
                }
            }
        }
    }
    #[test]
    fn existing_permutation_and_fragmentation_escape() {
        let original: Vec<_> = (0..32).map(|i| (None, record(i, false))).collect();
        let permutation: Vec<_> = (0..32)
            .map(|i| {
                let old = i * 17 % 32;
                let mut r = record(old, false);
                r.0[1] = super::super::links::NodeLinks::new((i != 0).then_some(0), i as u32, None)
                    .word();
                (Some(old), r)
            })
            .collect();
        for mode in [Mode::Raw, Mode::Absolute, Mode::Relative] {
            let mut s = State::new(mode);
            update(&mut s, 7, 1, &original);
            update(&mut s, 7, 2, &permutation);
            println!("\nORDERED_PERMUTATION {}", s.report());
        }
        // Cold field-domain model of keyed wrappers with one child each. It
        // does not claim to replace the public keyed producer fixture below.
        let pairs = |permuted: bool| {
            let mut rows = vec![(Some(0), Wire([1, 0, 3, 0]))];
            for i in 0..32 {
                let old = if permuted { i * 17 % 32 } else { i };
                rows.push((
                    Some(1 + 2 * old),
                    Wire([
                        2 + 2 * old as u64,
                        super::super::links::NodeLinks::new(Some(0), i as u32, None).word(),
                        3,
                        0,
                    ]),
                ));
                rows.push((
                    Some(2 + 2 * old),
                    Wire([
                        3 + 2 * old as u64,
                        super::super::links::NodeLinks::new(Some(1 + 2 * i), 0, None).word(),
                        3,
                        0,
                    ]),
                ));
            }
            rows
        };
        for mode in [Mode::Raw, Mode::Absolute, Mode::Relative] {
            let mut s = State::new(mode);
            let mut initial = pairs(false);
            for r in &mut initial {
                r.0 = None;
            }
            update(&mut s, 7, 1, &initial);
            update(&mut s, 7, 2, &pairs(true));
            if matches!(mode, Mode::Relative) {
                assert_eq!(s.work.compactions, 1);
                assert_eq!(s.work.compaction_decodes, 65);
                assert!(s.work.reusable_records >= 32);
            }
            println!("\nORDERED_FRAGMENT {}", s.report());
        }
    }
    #[test]
    fn held_older_reader_survives_owner_retirement_and_failed_candidate() {
        for mode in [Mode::Raw, Mode::Absolute, Mode::Relative] {
            let mut s = State::new(mode);
            let mut rows: Vec<_> = (0..64).map(|i| (None, record(i, false))).collect();
            update(&mut s, 7, 1, &rows);
            let held = s.current.as_ref().unwrap().clone();
            let weak = Arc::downgrade(&held);
            for epoch in 2..=5 {
                for (i, r) in rows.iter_mut().enumerate() {
                    r.0 = Some(i);
                }
                rows[7].1.0[2] = epoch;
                update(&mut s, 7, epoch, &rows);
            }
            assert_eq!(s.history.len(), 2);
            assert!(s.history.iter().all(|v| !Arc::ptr_eq(v, &held)));
            for i in 0..64 {
                assert_eq!(held.record(i), record(i, false));
            }
            let current = s.current.as_ref().unwrap().clone();
            s.begin(7, 6);
            s.pending.as_mut().unwrap().reserve(64);
            s.pending
                .as_mut()
                .unwrap()
                .push(0, Some(0), record(0, false));
            assert!(Arc::ptr_eq(s.current.as_ref().unwrap(), &current));
            let mut roots: Vec<_> = s
                .current
                .iter()
                .chain(&s.history)
                .map(|v| (&**v, true))
                .collect();
            roots.push((&held, true));
            println!(
                "\nORDERED_HELD_READER {}",
                json!({"mode":format!("{:?}",mode),"held_plus_owner":memory(&roots),"reader_handle_bytes":size_of::<Arc<Version>>(),"weak_observer_handle_bytes":size_of::<std::sync::Weak<Version>>(),"owner":s.report()})
            );
            drop(roots);
            // Foreign namespace and nonadvancing epochs must not reuse payload.
            update(&mut s, 8, 7, &rows);
            assert_eq!(s.work.reusable_records, 0);
            update(&mut s, 8, 7, &rows);
            assert_eq!(s.work.reusable_records, 0);
            drop(s);
            for i in 0..64 {
                assert_eq!(held.record(i), record(i, false));
            }
            drop(held);
            assert!(weak.upgrade().is_none());
        }
    }
    #[test]
    #[should_panic(expected = "surviving identity required")]
    fn false_identity_extent_reuse_is_rejected() {
        let mut s = State::new(Mode::Absolute);
        let rows: Vec<_> = (0..32).map(|i| (None, record(i, false))).collect();
        update(&mut s, 7, 1, &rows);
        s.begin(7, 2);
        s.pending.as_mut().unwrap().reserve(32);
        s.pending
            .as_mut()
            .unwrap()
            .push(0, Some(0), record(1, false));
    }
}
