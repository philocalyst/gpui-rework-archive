//! Shared immutable subtrees with instance-local targets and typed field overlays.
//! This is a structural experiment, not a renderer or reactive runtime.
#![forbid(unsafe_code)]

mod topology;
pub use topology::{Children, Topology};
mod property;
pub use property::{OverrideLedger, Overrides, Property, Representation, Strategy};

use std::sync::{
    Arc,
    atomic::{AtomicU64, Ordering},
};
static NEXT_SCENE: AtomicU64 = AtomicU64::new(1);

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Error {
    Topology,
    Node,
    Instance,
    WrongTemplate,
    Region,
    Attached,
    Cycle,
    Duplicate,
    Capacity,
    Defaults,
}

pub struct Template {
    topology: Topology,
    regions: Box<[u32]>,
}
impl Template {
    pub fn new(parents: &[Option<u32>], regions: &[u32]) -> Result<Arc<Self>, Error> {
        let topology = Topology::new(parents)?;
        let mut regions = regions.to_vec();
        regions.sort_unstable();
        if regions.windows(2).any(|w| w[0] == w[1])
            || regions
                .last()
                .is_some_and(|&n| n as usize >= topology.len())
        {
            return Err(Error::Region);
        }
        Ok(Arc::new(Self {
            topology,
            regions: regions.into_boxed_slice(),
        }))
    }
    pub fn topology(&self) -> &Topology {
        &self.topology
    }
    pub fn payload_bytes(&self) -> usize {
        std::mem::size_of::<Self>()
            + self.topology.bit_bytes()
            + self.topology.index_bytes()
            + self.regions.len() * 4
    }
}

/// Append-only within one scene. Dropped descriptor slots are never reused.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub struct InstanceId {
    scene: u64,
    index: u32,
}
#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub struct Target {
    instance: InstanceId,
    node: u32,
}
impl Target {
    pub fn instance(self) -> InstanceId {
        self.instance
    }
    pub fn node(self) -> u32 {
        self.node
    }
}
struct Run {
    region: Target,
    children: Vec<InstanceId>,
}

/// One 8-byte Option<Arc<Template>> descriptor per historical mount on x86_64.
/// Dynamic regions are sparse runs of whole instances. Their attachment graph is
/// separate from static topology, acyclic, and gives each instance at most one owner.
pub struct Scene {
    id: u64,
    instances: Vec<Option<Arc<Template>>>,
    runs: Vec<Run>,
}
impl Default for Scene {
    fn default() -> Self {
        Self::new()
    }
}
impl Scene {
    pub fn new() -> Self {
        Self::with_capacity(0)
    }
    pub fn with_capacity(capacity: usize) -> Self {
        let id = NEXT_SCENE
            .try_update(Ordering::Relaxed, Ordering::Relaxed, |n| n.checked_add(1))
            .expect("scene identities exhausted");
        Self {
            id,
            instances: Vec::with_capacity(capacity),
            runs: Vec::new(),
        }
    }
    pub fn mount(&mut self, template: Arc<Template>) -> Result<InstanceId, Error> {
        let index = u32::try_from(self.instances.len()).map_err(|_| Error::Capacity)?;
        self.instances.push(Some(template));
        Ok(InstanceId {
            scene: self.id,
            index,
        })
    }
    pub fn contains(&self, id: InstanceId) -> bool {
        self.template(id).is_ok()
    }
    pub fn template(&self, id: InstanceId) -> Result<&Arc<Template>, Error> {
        if id.scene != self.id {
            return Err(Error::Instance);
        }
        self.instances
            .get(id.index as usize)
            .and_then(Option::as_ref)
            .ok_or(Error::Instance)
    }
    pub fn target(&self, instance: InstanceId, node: u32) -> Result<Target, Error> {
        if node as usize >= self.template(instance)?.topology.len() {
            return Err(Error::Node);
        }
        Ok(Target { instance, node })
    }
    pub fn validate(&self, target: Target) -> Result<&Arc<Template>, Error> {
        let template = self.template(target.instance)?;
        if target.node as usize >= template.topology.len() {
            return Err(Error::Node);
        }
        Ok(template)
    }
    /// Unmount only this instance. Its dynamic children survive as detached roots;
    /// incoming attachment is removed. Typed fields reclaim dead patches explicitly
    /// through Overrides::retain_live; no erased value registry exists.
    pub fn unmount(&mut self, id: InstanceId) -> Result<(), Error> {
        self.template(id)?;
        self.runs.retain(|r| r.region.instance != id);
        for run in &mut self.runs {
            run.children.retain(|&child| child != id);
        }
        self.runs.retain(|r| !r.children.is_empty());
        self.instances[id.index as usize] = None;
        Ok(())
    }
    pub fn set_region(&mut self, region: Target, children: Vec<InstanceId>) -> Result<(), Error> {
        let template = self.validate(region)?;
        if template.regions.binary_search(&region.node).is_err() {
            return Err(Error::Region);
        }
        for (i, &child) in children.iter().enumerate() {
            self.template(child)?;
            if children[..i].contains(&child) {
                return Err(Error::Duplicate);
            }
            if self.owner(child).is_some_and(|owner| owner != region) {
                return Err(Error::Attached);
            }
            let mut ancestor = Some(region.instance);
            while let Some(id) = ancestor {
                if id == child {
                    return Err(Error::Cycle);
                }
                ancestor = self.owner(id).map(|r| r.instance);
            }
        }
        match self.runs.binary_search_by_key(&region, |r| r.region) {
            Ok(index) if children.is_empty() => {
                self.runs.remove(index);
            }
            Ok(index) => self.runs[index].children = children,
            Err(index) if !children.is_empty() => self.runs.insert(index, Run { region, children }),
            Err(_) => {}
        }
        Ok(())
    }
    pub fn region(&self, region: Target) -> Result<&[InstanceId], Error> {
        let template = self.validate(region)?;
        if template.regions.binary_search(&region.node).is_err() {
            return Err(Error::Region);
        }
        Ok(self
            .runs
            .binary_search_by_key(&region, |r| r.region)
            .map_or(&[], |i| self.runs[i].children.as_slice()))
    }
    pub fn descriptor_bytes(&self) -> usize {
        self.instances.capacity() * std::mem::size_of::<Option<Arc<Template>>>()
    }
    pub fn payload_bytes(&self) -> usize {
        std::mem::size_of::<Self>()
            + self.descriptor_bytes()
            + self.runs.capacity() * std::mem::size_of::<Run>()
            + self
                .runs
                .iter()
                .map(|r| r.children.capacity() * std::mem::size_of::<InstanceId>())
                .sum::<usize>()
    }
    fn owner(&self, id: InstanceId) -> Option<Target> {
        self.runs
            .iter()
            .find(|run| run.children.contains(&id))
            .map(|run| run.region)
    }
}
