//! Actual producer event mapping. Diagnostic metadata grants no rendering authority.
use super::*;
use serde_json::json;
type PacketKeys<'a> = (PresentationToken, [u64; 2], &'a [[u64; 2]]);
#[derive(Clone, Copy, serde::Serialize)]
struct Row {
    identity: u64,
    start: u32,
    end: u32,
    subtree_end: u32,
    node_end: u32,
}
pub(super) struct Dependency {
    pub parent: u32,
    pub parent_space: [f64; 6],
    pub transform: Option<Affine>,
    pub inherited: gpui_canvas::Clip,
    pub used: gpui_canvas::Clip,
    pub support: DamageRegion,
}
#[derive(Default, Clone, Copy, serde::Serialize)]
struct Work {
    rows: usize,
    cursor_reads: usize,
    support_draw_visits: usize,
    stack_pushes: usize,
    stack_pops: usize,
    stack_capacity_bytes: usize,
    row_bytes_written: usize,
    dependency_bytes_written: usize,
    command_key_bytes_written: usize,
}
struct Mapping {
    token: PresentationToken,
    source_epoch: u64,
    rows: Vec<Row>,
    command_keys: Vec<[u64; 2]>,
    dependencies: Vec<Dependency>,
    work: Work,
}
pub(super) struct Builder {
    mapping: Mapping,
    stack: Vec<usize>,
}
impl Builder {
    pub(super) fn new(token: PresentationToken, source_epoch: u64, n: usize, depth: usize) -> Self {
        Self {
            mapping: Mapping {
                token,
                source_epoch,
                rows: Vec::with_capacity(n),
                command_keys: Vec::new(),
                dependencies: Vec::with_capacity(n),
                work: Work::default(),
            },
            stack: Vec::with_capacity(depth),
        }
    }
    fn close(&mut self, node_end: usize, command_end: usize) {
        let i = self.stack.pop().unwrap();
        let row = &mut self.mapping.rows[i];
        row.node_end = node_end as u32;
        row.subtree_end = command_end as u32;
        self.mapping.work.stack_pops += 1;
        self.mapping.work.row_bytes_written += 8;
    }
    pub(super) fn push(
        &mut self,
        identity: u64,
        range: std::ops::Range<usize>,
        dependency: Dependency,
    ) {
        let index = self.mapping.rows.len();
        let parent = (dependency.parent != u32::MAX).then_some(dependency.parent as usize);
        while self.stack.last().copied() != parent {
            self.close(index, range.start);
        }
        assert_eq!(
            self.mapping.rows.last().map_or(0, |r| r.end as usize),
            range.start
        );
        // Typed keys are emitted here, at the actual command event. Consumers
        // borrow this exact-version stream without JSON/snapshot reconstruction.
        self.mapping
            .command_keys
            .extend((0..range.len()).map(|local| [identity, local as u64]));
        self.mapping.work.command_key_bytes_written += range.len() * size_of::<[u64; 2]>();
        self.mapping.work.rows += 1;
        self.mapping.work.cursor_reads += 2;
        self.mapping.work.support_draw_visits += range.len();
        self.mapping.work.row_bytes_written += size_of::<Row>();
        self.mapping.work.dependency_bytes_written += size_of::<Dependency>();
        self.mapping.rows.push(Row {
            identity,
            start: range.start as u32,
            end: range.end as u32,
            node_end: 0,
            subtree_end: 0,
        });
        self.mapping.dependencies.push(dependency);
        self.stack.push(index);
        self.mapping.work.stack_pushes += 1;
        self.mapping.work.stack_capacity_bytes = self
            .mapping
            .work
            .stack_capacity_bytes
            .max(self.stack.capacity() * size_of::<usize>());
    }
    fn finish(mut self) -> Mapping {
        let n = self.mapping.rows.len();
        let end = self.mapping.rows.last().map_or(0, |r| r.end as usize);
        while !self.stack.is_empty() {
            self.close(n, end);
        }
        self.mapping
    }
}
impl Mapping {
    fn heap(&self) -> usize {
        self.command_keys.capacity() * size_of::<[u64; 2]>()
            + self.rows.capacity() * size_of::<Row>()
            + self.dependencies.capacity() * size_of::<Dependency>()
    }
    fn report(&self) -> serde_json::Value {
        let deps:Vec<_>=self.dependencies.iter().map(|d|json!({"parent":(d.parent!=u32::MAX).then_some(d.parent),"parent_space":d.parent_space,"transform":d.transform.map(|a|[a.a,a.b,a.c,a.d,a.tx,a.ty]),"inherited_clip":format!("{:?}",d.inherited),"used_clip":format!("{:?}",d.used),"support":d.support.bounds()})).collect();
        json!({"token":format!("{:?}",self.token),"source_epoch":self.source_epoch,"rows":self.rows,"dependencies":deps,"work":self.work,"row_bytes":size_of::<Row>(),"dependency_bytes":size_of::<Dependency>(),"row_capacity_bytes":self.rows.capacity()*size_of::<Row>(),"dependency_capacity_bytes":self.dependencies.capacity()*size_of::<Dependency>(),"command_key_capacity_bytes":self.command_keys.capacity()*size_of::<[u64;2]>(),"heap_bytes":self.heap()})
    }
}
#[derive(Default)]
pub(super) struct Store {
    current: Option<Mapping>,
    previous: Option<Mapping>,
}
impl Store {
    fn command_keys<M>(&self, r: &Runtime<M>) -> Option<PacketKeys<'_>> {
        let m = self.current.as_ref()?;
        (Some(m.token) == r.latest_token
            && m.source_epoch == r.source_epoch
            && m.source_epoch == r.complete_epoch
            && r.logical_valid)
            .then_some((
                m.token,
                [m.token.window.get(), m.token.sequence.get()],
                m.command_keys.as_slice(),
            ))
    }

    pub(super) fn install(&mut self, b: Builder) {
        self.previous = self.current.replace(b.finish());
    }
    pub(super) fn report<M>(&self, r: &Runtime<M>) -> serde_json::Value {
        // Current identity lookup shares the existing index; old metadata is
        // deliberately not made into another identity registry.
        let matches = self.current.as_ref().is_some_and(|m| {
            Some(m.token) == r.latest_token
                && m.source_epoch == r.complete_epoch
                && m.source_epoch == r.source_epoch
                && r.logical_valid
        });
        if matches {
            let m = self.current.as_ref().unwrap();
            for row in &m.rows {
                let i = r.by_identity.get(row.identity).unwrap();
                assert_eq!(m.rows[i].identity, row.identity);
                assert_eq!(r.nodes[i].identity(), row.identity);
            }
        }
        json!({"scope":"test producer mapping only; old metadata owns no scene/resource/GPU lease","current_lookup_matches_live_version":matches,"lookup_verification_visits":if matches{self.current.as_ref().unwrap().rows.len()}else{0},"store_header_bytes":size_of::<Self>(),"retained_heap_bytes":self.current.iter().chain(&self.previous).map(Mapping::heap).sum::<usize>(),"current":self.current.as_ref().map(Mapping::report),"previous":self.previous.as_ref().map(Mapping::report)})
    }
}

impl<M: View + 'static> Win<M> {
    pub(crate) fn packet_keys(&self) -> PacketKeys<'_> {
        let r = self.runtime().unwrap();
        r.semantic_emission
            .command_keys(r)
            .expect("exact completed live emission version")
    }
}
