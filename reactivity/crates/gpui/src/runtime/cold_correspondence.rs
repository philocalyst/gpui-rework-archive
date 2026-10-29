//! Test-only complete cold-field encodings emitted by live reconciliation.
//! Correspondence proves identity/position only. It never authorizes GPU reuse.
use serde_json::json;
const ROW: usize = 24;
const BLOCK: usize = 32;
const TINY: usize = 8;
const NONE: u32 = u32::MAX;
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(super) struct Wire(pub [u64; 4]);
impl Wire {
    fn write(self, out: &mut Vec<u8>) {
        out.extend_from_slice(&self.0[0].to_le_bytes());
        out.extend_from_slice(&self.0[1].to_le_bytes());
        for v in &self.0[2..] {
            out.extend_from_slice(&u32::try_from(*v).unwrap().to_le_bytes());
        }
    }
    fn read(raw: &[u8]) -> Self {
        Self([
            u64::from_le_bytes(raw[0..8].try_into().unwrap()),
            u64::from_le_bytes(raw[8..16].try_into().unwrap()),
            u32::from_le_bytes(raw[16..20].try_into().unwrap()) as u64,
            u32::from_le_bytes(raw[20..24].try_into().unwrap()) as u64,
        ])
    }
    fn relative(mut self, index: usize) -> Self {
        self.0[1] = super::links::NodeLinks::relative_word(self.0[1], index);
        self
    }
    fn absolute(mut self, index: usize) -> Self {
        self.0[1] = super::links::NodeLinks::absolute_word(self.0[1], index);
        self
    }
}
fn encode(rows: &[Wire]) -> Vec<u8> {
    let mut bases = [0; 4];
    let mut widths = [0; 4];
    for c in 0..4 {
        bases[c] = rows.iter().map(|r| r.0[c]).min().unwrap();
        let max = rows.iter().map(|r| r.0[c] - bases[c]).max().unwrap();
        widths[c] = (64 - max.leading_zeros()) as u8;
    }
    let bits = rows.len() * widths.iter().map(|&x| x as usize).sum::<usize>();
    let packed_len = 38 + bits.div_ceil(8);
    if packed_len >= 2 + ROW * rows.len() {
        let mut raw = Vec::with_capacity(2 + ROW * rows.len());
        raw.extend_from_slice(&[0, rows.len() as u8]);
        for r in rows {
            r.write(&mut raw);
        }
        return raw;
    }
    let mut packed = Vec::with_capacity(packed_len);
    packed.extend_from_slice(&[1, rows.len() as u8]);
    for base in bases {
        packed.extend_from_slice(&base.to_le_bytes());
    }
    packed.extend_from_slice(&widths);
    packed.resize(packed_len, 0);
    let mut bit = 0;
    for c in 0..4 {
        for row in rows {
            let v = row.0[c] - bases[c];
            for b in 0..usize::from(widths[c]) {
                packed[38 + bit / 8] |= (((v >> b) & 1) as u8) << (bit % 8);
                bit += 1;
            }
        }
    }
    packed
}

fn decode(bytes: &[u8], index: usize) -> Wire {
    assert!(index < usize::from(bytes[1]));
    if bytes[0] == 0 {
        return Wire::read(&bytes[2 + ROW * index..2 + ROW * (index + 1)]);
    }
    assert_eq!(bytes[0], 1);
    let mut row = [0; 4];
    let mut start = 0;
    for c in 0..4 {
        let base = u64::from_le_bytes(bytes[2 + c * 8..10 + c * 8].try_into().unwrap());
        let width = usize::from(bytes[34 + c]);
        let mut delta = 0;
        for b in 0..width {
            let bit = start + index * width + b;
            delta |= u64::from((bytes[38 + bit / 8] >> (bit % 8)) & 1) << b;
        }
        row[c] = base.checked_add(delta).unwrap();
        start += usize::from(bytes[1]) * width;
    }
    Wire(row)
}
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
enum Store {
    Raw(Vec<u8>),
    Blocks {
        len: usize,
        relative: bool,
        blocks: Vec<Vec<u8>>,
    },
}
impl Default for Store {
    fn default() -> Self {
        Self::Raw(Vec::new())
    }
}
impl Store {
    fn len(&self) -> usize {
        match self {
            Self::Raw(v) => v.len() / ROW,
            Self::Blocks { len, .. } => *len,
        }
    }
    fn record(&self, index: usize) -> Wire {
        assert!(index < self.len());
        match self {
            Self::Raw(v) => Wire::read(&v[index * ROW..(index + 1) * ROW]),
            Self::Blocks {
                relative, blocks, ..
            } => {
                let row = decode(&blocks[index / BLOCK], index % BLOCK);
                if *relative { row.absolute(index) } else { row }
            }
        }
    }
    fn payload(&self) -> usize {
        match self {
            Self::Raw(v) => v.len(),
            Self::Blocks { blocks, .. } => blocks.iter().map(Vec::len).sum(),
        }
    }
    fn directory(&self) -> usize {
        match self {
            Self::Raw(_) => 0,
            Self::Blocks { blocks, .. } => blocks.capacity() * size_of::<Vec<u8>>(),
        }
    }
    fn retained(&self) -> usize {
        size_of::<Self>()
            + self.directory()
            + match self {
                Self::Raw(v) => v.capacity(),
                Self::Blocks { blocks, .. } => blocks.iter().map(Vec::capacity).sum(),
            }
    }
    fn rewrite(&self, old: &Self) -> usize {
        match (self, old) {
            (Self::Raw(a), Self::Raw(b)) => {
                if a == b {
                    0
                } else {
                    a.len()
                }
            }
            (Self::Blocks { blocks: a, .. }, Self::Blocks { blocks: b, .. }) => a
                .iter()
                .enumerate()
                .filter(|(i, x)| b.get(*i) != Some(*x))
                .map(|(_, x)| x.len())
                .sum(),
            _ => self.payload(),
        }
    }
}
struct Builder {
    mode: Mode,
    len: usize,
    raw: Vec<u8>,
    blocks: Vec<Vec<u8>>,
    scratch: Vec<Wire>,
    scratch_peak: usize,
    changed: usize,
    old_decodes: usize,
    validation_decodes: usize,
}
impl Builder {
    fn new(mode: Mode) -> Self {
        Self {
            mode,
            len: 0,
            raw: Vec::new(),
            blocks: Vec::new(),
            scratch: Vec::new(),
            scratch_peak: 0,
            changed: 0,
            old_decodes: 0,
            validation_decodes: 0,
        }
    }
    fn reserve(&mut self, count: usize) {
        if matches!(self.mode, Mode::Raw) {
            self.raw.reserve_exact(count * ROW);
        } else {
            self.scratch.reserve_exact(count.min(BLOCK));
            self.scratch_peak = self.scratch.capacity() * size_of::<Wire>();
            if count > TINY {
                self.blocks.reserve_exact(count.div_ceil(BLOCK));
            }
        }
    }
    fn push(&mut self, wire: Wire, old_rank: Option<usize>, old: &Store) {
        let value = if self.mode.relative() {
            wire.relative(self.len)
        } else {
            wire
        };
        if let Some(i) = old_rank {
            let old_wire = old.record(i);
            assert_eq!(
                wire.0[0], old_wire.0[0],
                "correspondence identity must survive reconciliation"
            );
            self.old_decodes += 1;
            let old_value = if self.mode.relative() {
                old_wire.relative(i)
            } else {
                old_wire
            };
            self.changed += usize::from(value != old_value);
        } else {
            self.changed += 1;
        }
        if matches!(self.mode, Mode::Raw) {
            wire.write(&mut self.raw);
        } else {
            self.scratch.push(value);
            self.scratch_peak = self
                .scratch_peak
                .max(self.scratch.capacity() * size_of::<Wire>());
            if self.scratch.len() == BLOCK {
                self.flush();
            }
        }
        self.len += 1;
    }
    fn flush(&mut self) {
        if self.scratch.is_empty() {
            return;
        }
        let encoded = encode(&self.scratch);
        for (i, row) in self.scratch.iter().enumerate() {
            assert_eq!(decode(&encoded, i), *row);
            self.validation_decodes += 1;
        }
        self.blocks.push(encoded);
        self.scratch.clear();
    }
    fn finish(mut self, old: &Store) -> (Store, serde_json::Value) {
        let store = if matches!(self.mode, Mode::Raw) {
            Store::Raw(std::mem::take(&mut self.raw))
        } else if self.len <= TINY {
            let mut raw = Vec::with_capacity(self.len * ROW);
            for (i, r) in self.scratch.iter().copied().enumerate() {
                (if self.mode.relative() {
                    r.absolute(i)
                } else {
                    r
                })
                .write(&mut raw);
            }
            self.validation_decodes += self.len;
            Store::Raw(raw)
        } else {
            self.flush();
            Store::Blocks {
                len: self.len,
                relative: self.mode.relative(),
                blocks: std::mem::take(&mut self.blocks),
            }
        };
        let stats = json!({"mode":format!("{:?}",self.mode),"records":self.len,"changed_records":self.changed,"old_point_decodes":self.old_decodes,"validation_decodes":self.validation_decodes,"encoded_payload_bytes":store.payload(),"store_header_bytes":size_of::<Store>(),"directory_capacity_bytes":store.directory(),"retained_bytes":store.retained(),"old_retained_bytes":old.retained(),"known_old_new_plus_builder_scratch_peak_bytes":old.retained()+store.retained()+size_of::<Builder>()+self.scratch_peak,"builder_header_bytes":size_of::<Builder>(),"encoder_base_width_stack_bytes":size_of::<[u64;4]>()+size_of::<[u8;4]>(),"encoder_field_reads":self.len*if matches!(self.mode,Mode::Raw)||self.len<=TINY {4}else{12},"bounded_scratch_capacity_peak_bytes":self.scratch_peak,"encoded_bytes_produced":store.payload(),"ordinal_block_rewrite_payload_bytes":store.rewrite(old),"new_directory_bytes_written":store.directory(),"raw_tiny":matches!(&store,Store::Raw(_))});
        (store, stats)
    }
}
#[derive(Debug, Clone, Copy, serde::Serialize)]
#[repr(C)]
struct Run {
    old_start: u32,
    new_start: u32,
    len: u32,
}
#[derive(Clone, Copy, Default)]
struct Stamp {
    namespace: u64,
    epoch: u64,
}
impl Stamp {
    fn matches(self, other: Self) -> bool {
        self.namespace == other.namespace && self.epoch == other.epoch
    }
}
#[derive(Default)]
pub(super) struct Trials {
    stores: [Store; 3],
    pending: Option<[Builder; 3]>,
    runs: Vec<Run>,
    base: Stamp,
    next: Stamp,
    report: serde_json::Value,
}
impl Trials {
    pub(super) fn begin(&mut self, namespace: u64, epoch: u64) {
        self.pending = Some([
            Builder::new(Mode::Raw),
            Builder::new(Mode::Absolute),
            Builder::new(Mode::Relative),
        ]);
        self.runs.clear();
        self.next = Stamp { namespace, epoch };
    }
    pub(super) fn reserve(&mut self, count: usize) {
        for builder in self.pending.as_mut().unwrap() {
            builder.reserve(count);
        }
    }
    pub(super) fn push(&mut self, index: usize, old_rank: Option<usize>, wire: Wire) {
        let old_rank = old_rank.filter(|_| self.base.namespace == self.next.namespace);
        let start = old_rank.map_or(NONE, |i| u32::try_from(i).unwrap());
        if let Some(last) = self.runs.last_mut()
            && ((start == NONE && last.old_start == NONE)
                || (start != NONE
                    && last.old_start != NONE
                    && last.old_start.checked_add(last.len) == Some(start)))
        {
            last.len += 1;
        } else {
            self.runs.push(Run {
                old_start: start,
                new_start: u32::try_from(index).unwrap(),
                len: 1,
            });
        }
        for (builder, old) in self.pending.as_mut().unwrap().iter_mut().zip(&self.stores) {
            assert_eq!(builder.len, index);
            builder.push(wire, old_rank, old);
        }
    }
    pub(super) fn finish(&mut self) {
        let builders = self.pending.take().unwrap();
        let old_bytes: usize = self.stores.iter().map(Store::retained).sum();
        let mut reports = Vec::new();
        for (builder, old) in builders.into_iter().zip(&mut self.stores) {
            let (new, report) = builder.finish(old);
            *old = new;
            reports.push(report);
        }
        let len = self.stores[0].len();
        for i in 0..len {
            let raw = self.stores[0].record(i);
            assert_eq!(raw, self.stores[1].record(i));
            assert_eq!(raw, self.stores[2].record(i));
        }
        self.report = json!({"scope":"test-only shadow cold stores; no layout/paint/resource/GPU authority","from_namespace":self.base.namespace,"from_source_epoch":self.base.epoch,"to_namespace":self.next.namespace,"to_source_epoch":self.next.epoch,"runs":self.runs,"run_count":self.runs.len(),"run_header_bytes":size_of::<Vec<Run>>(),"run_capacity_bytes":self.runs.capacity()*size_of::<Run>(),"run_payload_bytes":self.runs.len()*size_of::<Run>(),"raw_canonical_literal_bytes":self.runs.iter().filter(|r|r.old_start==NONE).map(|r|r.len as usize*ROW).sum::<usize>(),"alternatives":reports,"combined_control_store_retained_bytes":self.stores.iter().map(Store::retained).sum::<usize>(),"old_combined_control_store_retained_bytes":old_bytes,"trial_header_bytes":size_of::<Self>(),"combined_store_run_trial_retained_excluding_diagnostic_json_bytes":size_of::<Self>()+self.stores.iter().map(|s|s.retained()-size_of::<Store>()).sum::<usize>()+self.runs.capacity()*size_of::<Run>(),"additional_whole_decoder_verification_records":len*3,"producer_records":len});
        self.base = self.next;
    }
    pub(super) fn report(&self) -> serde_json::Value {
        self.report.clone()
    }
    fn accepts(&self, base: Stamp) -> bool {
        self.base.matches(base)
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
        let links = super::super::links::NodeLinks::new(
            (i != 0).then_some(i.saturating_sub(1)),
            (i % 17) as u32,
            Some(i),
        );
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
    #[test]
    fn complete_fields_and_boundaries_roundtrip() {
        for n in [0, 1, 2, 7, 8, 9, 31, 32, 33, 63, 64, 65, 257] {
            for entropy in [false, true] {
                let mut t = Trials::default();
                t.begin(7, 0);
                for i in 0..n {
                    t.push(i, None, record(i, entropy));
                }
                t.finish();
                for s in &t.stores {
                    assert_eq!(s.len(), n);
                    for i in 0..n {
                        assert_eq!(s.record(i), record(i, entropy));
                    }
                }
                if n <= TINY {
                    assert!(t.stores.iter().all(|s| matches!(s, Store::Raw(_))));
                }
            }
        }
    }
    #[test]
    fn max_width_columns_and_raw_escape_are_exact() {
        let rows = [
            Wire([0, 0, 0, 0]),
            Wire([u64::MAX, u64::MAX, u64::from(u32::MAX), u64::from(u32::MAX)]),
        ];
        let bytes = encode(&rows);
        for (i, row) in rows.iter().enumerate() {
            assert_eq!(decode(&bytes, i), *row);
        }
        assert_eq!(bytes[0], 0);
    }
    #[test]
    fn fragmented_correspondence_preserves_only_identity_and_position() {
        let mut t = Trials::default();
        t.begin(7, 1);
        t.reserve(32);
        for i in 0..32 {
            t.push(i, None, record(i, false));
        }
        t.finish();
        let previous = t.base;
        assert!(t.accepts(previous));
        assert!(!t.accepts(Stamp {
            namespace: 8,
            ..previous
        }));
        assert!(!t.accepts(Stamp {
            epoch: 0,
            ..previous
        }));
        t.begin(7, 2);
        t.reserve(32);
        for i in 0..32 {
            let old = (i * 17) % 32;
            let mut r = record(old, false);
            r.0[1] =
                super::super::links::NodeLinks::new((i != 0).then_some(0), i as u32, None).word();
            t.push(i, Some(old), r);
        }
        t.finish();
        assert_eq!(t.runs.len(), 32);
        assert!(!t.accepts(previous));
        assert_eq!(size_of::<Run>(), 12);
    }
    #[test]
    #[should_panic(expected = "correspondence identity must survive reconciliation")]
    fn false_identity_correspondence_is_rejected() {
        let mut t = Trials::default();
        t.begin(7, 1);
        t.push(0, None, record(0, false));
        t.finish();
        t.begin(7, 2);
        t.push(0, Some(0), record(1, false));
    }
}
