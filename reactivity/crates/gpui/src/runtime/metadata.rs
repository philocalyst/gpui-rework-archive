//! Sparse logical annotations and immutable publication columns. Ordinary nodes
//! carry no metadata pointer, string, vector, or extra tag.
use super::*;
use crate::{ItemKey, SemanticText};

// Packed destinations reserve two low bits for the port independently of the
// compact parent's larger domain. Keep future node-cap changes checked too.
const _: () = assert!(MAX_NODES <= (u32::MAX >> 2) as usize + 1);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(super) enum Port {
    Visual = 0,
    Name = 1,
    Description = 2,
}
/// MAX_NODES is 100,000; two low port bits leave ample checked index space.
#[derive(Clone, Copy)]
pub(super) struct Destination(u32);
impl Destination {
    pub fn new(node: usize, port: Port) -> Self {
        assert!(node < MAX_NODES);
        Self((u32::try_from(node).expect("bounded node index") << 2) | port as u32)
    }
    pub fn packed(self) -> u32 {
        self.0
    }
    pub fn node(self) -> usize {
        (self.0 >> 2) as usize
    }
    pub fn port(self) -> Port {
        match self.0 & 3 {
            0 => Port::Visual,
            1 => Port::Name,
            2 => Port::Description,
            _ => unreachable!("private packed port"),
        }
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ListInfo {
    pub id: ListId,
    pub count: u32,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ListItemInfo {
    pub list: Target,
    pub key: ItemKey,
    /// Zero-based source index, independent of keys and scroll geometry.
    pub index: u32,
    pub count: u32,
}

#[derive(Default)]
pub(super) struct Declared {
    pub identity: u64,
    pub name: Option<SharedText>,
    pub description: Option<SharedText>,
}
#[derive(Clone, Default, PartialEq)]
pub(super) struct Names {
    pub identity: u64,
    pub name: Option<SharedText>,
    pub description: Option<SharedText>,
    // Explicit Set(None) suppresses the visual text fallback too.
    pub explicit_name: bool,
}
#[derive(Clone, Default)]
pub(super) struct Sheet {
    pub names: Vec<TextSlot>,
    pub descriptions: Vec<TextSlot>,
    pub lists: Vec<(u64, ListInfo)>,
    pub rows: Vec<Row>,
}
#[derive(Clone)]
pub(super) struct Row {
    pub identity: u64,
    pub key: ItemKey,
    pub index: u32,
}
#[derive(Clone)]
pub(super) struct TextSlot {
    pub identity: u64,
    // The name column's entry presence distinguishes a fallback from Set(None).
    pub value: Option<SharedText>,
}
fn slot(column: &[TextSlot], identity: u64) -> Option<&TextSlot> {
    column
        .binary_search_by_key(&identity, |entry| entry.identity)
        .ok()
        .map(|i| &column[i])
}
fn set_slot(column: &mut Vec<TextSlot>, identity: u64, value: Option<Option<SharedText>>) {
    match (
        column.binary_search_by_key(&identity, |entry| entry.identity),
        value,
    ) {
        (Ok(i), Some(value)) => column[i].value = value,
        (Ok(i), None) => {
            column.remove(i);
        }
        (Err(i), Some(value)) => column.insert(i, TextSlot { identity, value }),
        (Err(_), None) => {}
    }
}
impl Sheet {
    pub fn name(&self, identity: u64) -> Option<&TextSlot> {
        slot(&self.names, identity)
    }
    pub fn description(&self, identity: u64) -> Option<&TextSlot> {
        slot(&self.descriptions, identity)
    }
    pub fn list(&self, identity: u64) -> Option<ListInfo> {
        self.lists
            .binary_search_by_key(&identity, |entry| entry.0)
            .ok()
            .map(|i| self.lists[i].1)
    }
    pub fn row(&self, identity: u64) -> Option<&Row> {
        self.rows
            .binary_search_by_key(&identity, |entry| entry.identity)
            .ok()
            .map(|i| &self.rows[i])
    }
    fn set_names(&mut self, value: Names) {
        set_slot(
            &mut self.names,
            value.identity,
            value.explicit_name.then_some(value.name),
        );
        set_slot(
            &mut self.descriptions,
            value.identity,
            value.description.map(Some),
        );
    }
    pub fn capture(
        &mut self,
        metadata: &Metadata,
        identity: u64,
        list: Option<ListInfo>,
        row: Option<&ListRow>,
    ) {
        let names = metadata.effective(identity);
        if names.explicit_name {
            self.names.push(TextSlot {
                identity,
                value: names.name,
            });
        }
        if let Some(description) = names.description {
            self.descriptions.push(TextSlot {
                identity,
                value: Some(description),
            });
        }
        if let Some(info) = list {
            self.lists.push((identity, info));
        }
        if let Some(row) = row {
            self.rows.push(Row {
                identity,
                key: row.key,
                index: row.index,
            });
        }
    }
    pub fn sort(&mut self) {
        self.names.sort_unstable_by_key(|entry| entry.identity);
        self.descriptions
            .sort_unstable_by_key(|entry| entry.identity);
        self.lists.sort_unstable_by_key(|entry| entry.0);
        self.rows.sort_unstable_by_key(|entry| entry.identity);
    }
    fn is_empty(&self) -> bool {
        self.names.is_empty()
            && self.descriptions.is_empty()
            && self.lists.is_empty()
            && self.rows.is_empty()
    }
}
#[derive(Default)]
pub(super) struct Metadata {
    pub base: Vec<Declared>,
    pub overrides: BTreeMap<u64, [Contribution<Option<SharedText>>; 2]>,
    pub presented: Sheet,
    pub candidate: Option<Sheet>,
    pub geometry: Option<Box<super::geometry::Geometry>>,
}
impl Metadata {
    pub fn base(&self, identity: u64) -> Option<&Declared> {
        self.base
            .binary_search_by_key(&identity, |entry| entry.identity)
            .ok()
            .map(|i| &self.base[i])
    }
    pub fn base_mut(&mut self, identity: u64) -> Option<&mut Declared> {
        self.base
            .binary_search_by_key(&identity, |entry| entry.identity)
            .ok()
            .map(|i| &mut self.base[i])
    }
    pub fn unused(&self) -> bool {
        self.geometry.is_none()
            && self.base.is_empty()
            && self.overrides.is_empty()
            && self.candidate.is_none()
            && self.presented.is_empty()
    }
    pub(super) fn effective_refs(
        &self,
        identity: u64,
    ) -> (Option<Option<&SharedText>>, Option<&SharedText>) {
        let base = self.base(identity);
        let mut name = base.and_then(|base| base.name.as_ref()).map(Some);
        let mut description = base.and_then(|base| base.description.as_ref());
        if let Some(values) = self.overrides.get(&identity) {
            if let Contribution::Set(value) = &values[0] {
                name = Some(value.as_ref());
            }
            if let Contribution::Set(value) = &values[1] {
                description = value.as_ref();
            }
        }
        (name, description)
    }
    pub fn effective(&self, identity: u64) -> Names {
        let (name, description) = self.effective_refs(identity);
        Names {
            identity,
            name: name.flatten().cloned(),
            description: description.cloned(),
            explicit_name: name.is_some(),
        }
    }
}

#[derive(Clone, Copy)]
pub(super) enum Publish {
    Field(FieldId),
    Identity(u64),
    All,
}

impl<M: View + 'static> Runtime<M> {
    pub(super) fn metadata_sheet(&self) -> Option<Sheet> {
        self.metadata.as_ref().map(|metadata| {
            let mut names = metadata
                .base
                .iter()
                .filter(|entry| entry.name.is_some())
                .count();
            let mut descriptions = metadata
                .base
                .iter()
                .filter(|entry| entry.description.is_some())
                .count();
            for values in metadata.overrides.values() {
                names += usize::from(matches!(values[0], Contribution::Set(_)));
                descriptions += usize::from(matches!(values[1], Contribution::Set(Some(_))));
            }
            Sheet {
                names: Vec::with_capacity(names.min(self.nodes.len())),
                descriptions: Vec::with_capacity(descriptions.min(self.nodes.len())),
                lists: Vec::with_capacity(self.lists.len()),
                rows: Vec::with_capacity(self.list_rows.len()),
            }
        })
    }
    pub(super) fn list_metadata(&self) -> BTreeMap<u64, ListInfo> {
        self.lists
            .iter()
            .map(|(&id, list)| {
                (
                    list.identity,
                    ListInfo {
                        id,
                        count: list.viewport.len as u32,
                    },
                )
            })
            .collect()
    }
    pub(super) fn freeze_metadata(&self, nodes: &[Presented]) -> Option<Sheet> {
        let mut sheet = self.metadata_sheet()?;
        let metadata = self.metadata.as_ref()?;
        let lists = self.list_metadata();
        for node in nodes {
            sheet.capture(
                metadata,
                node.identity,
                lists.get(&node.identity).copied(),
                self.list_rows.get(&node.identity),
            );
        }
        sheet.sort();
        Some(sheet)
    }
    pub(super) fn publish_metadata(&mut self, publish: Publish) -> Commit {
        // A newer failed visual preparation cannot be repaired by relabelling
        // an older complete candidate. In particular do not retry the failed
        // glyph/layout path for an otherwise independent name edit.
        if self.dirty || self.complete_epoch != self.source_epoch - 1 {
            return self.commit();
        }
        let candidate = self.prepared.is_some() || !self.presentation_valid;
        let frozen = matches!(publish, Publish::All)
            .then(|| {
                let nodes = self
                    .prepared
                    .as_ref()
                    .map_or(self.presented.as_slice(), |p| &p.nodes);
                self.freeze_metadata(nodes)
            })
            .flatten();
        #[cfg(feature = "accessibility")]
        let base_stamp = self.semantic_stamp();
        #[cfg(feature = "accessibility")]
        let mut observation = self.accessibility.as_mut().and_then(|observer| {
            if candidate {
                observer.invalidate();
                None
            } else {
                Some(observer.begin(base_stamp, self.presentation_size))
            }
        });
        #[cfg(feature = "accessibility")]
        if let Some(observation) = &mut observation {
            match publish {
                Publish::All => observation.full(),
                Publish::Identity(identity) => {
                    // Logical indices are hints only: clipped list entries can
                    // shift P. Verify identity before using the cheap path.
                    let part = self
                        .by_identity
                        .get(&identity)
                        .and_then(|&index| {
                            self.presented
                                .get(index)
                                .filter(|node| node.identity == identity)
                                .map(|node| (index, node))
                        })
                        .or_else(|| {
                            self.presented
                                .iter()
                                .enumerate()
                                .find(|(_, node)| node.identity == identity)
                        });
                    if let Some((index, node)) = part
                        && let Some(metadata) = self.metadata.as_deref()
                    {
                        observation.metadata(
                            index,
                            node,
                            &metadata.presented,
                            metadata.effective_refs(identity),
                        );
                    }
                }
                Publish::Field(field) => {
                    if let Some(metadata) = self.metadata.as_deref()
                        && let Some(fanout) = self.fanout.get(&field)
                    {
                        for destination in &fanout.destinations {
                            if destination.port() == Port::Visual {
                                continue;
                            }
                            let index = destination.node();
                            let identity = self.nodes[index].identity();
                            let Some(node) = self
                                .presented
                                .get(index)
                                .filter(|node| node.identity == identity)
                            else {
                                // A mismatched hint cannot identify P. Avoid a
                                // map or one scan per destination: full native
                                // publication is the bounded conservative path.
                                observation.full();
                                break;
                            };
                            observation.metadata(
                                index,
                                node,
                                &metadata.presented,
                                metadata.effective_refs(identity),
                            );
                        }
                    }
                }
            }
        }
        {
            let nodes = self
                .prepared
                .as_ref()
                .map_or(self.presented.as_slice(), |p| &p.nodes);
            if matches!(publish, Publish::All) {
                if let Some(sheet) = frozen
                    && let Some(metadata) = &mut self.metadata
                {
                    if candidate {
                        metadata.candidate = Some(sheet);
                    } else {
                        metadata.presented = sheet;
                    }
                }
            } else if let Some(metadata) = &mut self.metadata {
                if candidate && metadata.candidate.is_none() {
                    metadata.candidate = Some(metadata.presented.clone());
                }
                let patch = |metadata: &mut Metadata, identity, inspector: bool| {
                    // Existing ports already have a sparse published entry.
                    // An inspector may introduce the first annotation on a site;
                    // only that cold operation scans the presented topology.
                    let sheet = if candidate {
                        metadata.candidate.as_ref().unwrap()
                    } else {
                        &metadata.presented
                    };
                    if sheet.name(identity).is_none() && sheet.description(identity).is_none() {
                        // Field ports already existed when the sheet was frozen.
                        // No entry means clipped or suppressed by an override.
                        // Only an inspector can introduce a first new column.
                        if !inspector || !nodes.iter().any(|node| node.identity == identity) {
                            return;
                        }
                    }
                    let value = metadata.effective(identity);
                    let sheet = if candidate {
                        metadata.candidate.as_mut().unwrap()
                    } else {
                        &mut metadata.presented
                    };
                    sheet.set_names(value);
                };
                match publish {
                    Publish::Identity(identity) => patch(metadata, identity, true),
                    Publish::Field(field) => {
                        if let Some(fanout) = self.fanout.get(&field) {
                            for destination in &fanout.destinations {
                                if destination.port() != Port::Visual {
                                    patch(
                                        metadata,
                                        self.nodes[destination.node()].identity(),
                                        false,
                                    );
                                }
                            }
                        }
                    }
                    Publish::All => unreachable!(),
                }
            }
        }
        if self.metadata.as_deref().is_some_and(Metadata::unused) {
            self.metadata = None;
        }
        #[cfg(feature = "accessibility")]
        if let Some(observation) = observation {
            observation.finish(
                super::accessibility::Stamp {
                    sequence: self.presented_sequence,
                    epoch: self.source_epoch,
                    size: self.presentation_size,
                },
                self.presented.len(),
                self.presented.len(),
            );
        }
        self.complete_epoch = self.source_epoch;
        if !candidate {
            self.presentation_epoch = self.source_epoch;
        }
        #[cfg(feature = "accessibility")]
        if !candidate {
            let stamp = self.semantic_stamp();
            if let Some(observer) = &mut self.accessibility {
                observer.acknowledge(stamp);
            }
        }
        self.commit()
    }
}
impl SemanticText {
    pub(super) const fn slot(self) -> usize {
        match self {
            Self::Name => 0,
            Self::Description => 1,
        }
    }
}
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Current logical metadata (which can be newer than Part's frozen sheet).
    /// Name inheritance falls back to visual text except for editable inputs.
    pub fn semantic_text(
        &self,
        target: Target,
        property: SemanticText,
    ) -> Result<Option<&str>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        let metadata = runtime.metadata.as_deref();
        if let Some(Contribution::Set(value)) = metadata
            .and_then(|m| m.overrides.get(&identity))
            .map(|values| &values[property.slot()])
        {
            return Ok(value.as_deref());
        }
        let base = metadata.and_then(|m| m.base(identity));
        match property {
            SemanticText::Description => Ok(base.and_then(|base| base.description.as_deref())),
            SemanticText::Name => {
                if let Some(base) = base.filter(|base| base.name.is_some()) {
                    return Ok(base.name.as_deref());
                }
                let node = &runtime.nodes[runtime.by_identity[&identity]];
                Ok((node.kind() != NodeKind::Input)
                    .then(|| {
                        node.text_slot()
                            .get(&runtime.texts)
                            .map(|text| text.value.as_ref())
                    })
                    .flatten())
            }
        }
    }
    pub fn semantic_contribution(
        &self,
        target: Target,
        property: SemanticText,
    ) -> Result<Contribution<Option<&str>>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        Ok(
            match runtime
                .metadata
                .as_deref()
                .and_then(|m| m.overrides.get(&identity))
                .map(|values| &values[property.slot()])
            {
                Some(Contribution::Set(value)) => Contribution::Set(value.as_deref()),
                _ => Contribution::Inherit,
            },
        )
    }
    /// A checked inspector contribution. Set(None) explicitly removes a name;
    /// Inherit reveals the latest declared operand. Rejections return the same
    /// owned payload. This changes neither layout nor glyph/paint commands.
    pub fn set_semantic(
        &mut self,
        target: Target,
        property: SemanticText,
        contribution: Contribution<Option<String>>,
    ) -> Result<Commit, SetError<Contribution<Option<String>>>> {
        let runtime = match self.runtime_mut() {
            Ok(runtime) => runtime,
            Err(error) => {
                return Err(SetError::Rejected {
                    error,
                    value: contribution,
                });
            }
        };
        let mut runtime = runtime;
        let admission = (|| {
            runtime.live()?;
            let identity = runtime.resolve(target)?;
            let epoch = runtime
                .source_epoch
                .checked_add(1)
                .ok_or(Error::EpochExhausted)?;
            Ok((identity, epoch))
        })();
        let (identity, epoch) = match admission {
            Ok(value) => value,
            Err(error) => {
                return Err(SetError::Rejected {
                    error,
                    value: contribution,
                });
            }
        };
        let metadata = runtime
            .metadata
            .get_or_insert_with(|| Box::new(Metadata::default()));
        let value = match contribution {
            Contribution::Inherit => Contribution::Inherit,
            Contribution::Set(value) => Contribution::Set(value.map(SharedText::from)),
        };
        let values = metadata.overrides.entry(identity).or_default();
        let changed = values[property.slot()] != value;
        values[property.slot()] = value;
        if values
            .iter()
            .all(|value| matches!(value, Contribution::Inherit))
        {
            metadata.overrides.remove(&identity);
        }
        runtime.source_epoch = epoch;
        runtime.counters.source_operations += 1;
        runtime.changed_nodes = usize::from(changed);
        Ok(runtime.publish_metadata(Publish::Identity(identity)))
    }
}
