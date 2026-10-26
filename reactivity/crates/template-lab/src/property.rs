use crate::{Error, InstanceId, Scene, Target, Template};
use std::sync::Arc;

/// One schema-defined property kind, independently typed and shared once.
/// Different Property<T> objects remain distinct fields even when T is equal.
pub struct Property<T> {
    template: Arc<Template>,
    defaults: Box<[T]>,
}
impl<T> Property<T> {
    pub fn new(template: Arc<Template>, defaults: Vec<T>) -> Result<Arc<Self>, Error> {
        if defaults.len() != template.topology().len() {
            return Err(Error::Defaults);
        }
        Ok(Arc::new(Self {
            template,
            defaults: defaults.into_boxed_slice(),
        }))
    }
    pub fn payload_bytes(&self) -> usize {
        std::mem::size_of::<Self>() + self.defaults.len() * std::mem::size_of::<T>()
    }
    fn validate(&self, scene: &Scene, target: Target) -> Result<(), Error> {
        if !Arc::ptr_eq(scene.validate(target)?, &self.template) {
            return Err(Error::WrongTemplate);
        }
        Ok(())
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Representation {
    Shared,
    Sparse(usize),
    Dense(usize),
}
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Strategy {
    Sparse,
    Dense,
    Adaptive,
}
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct OverrideLedger {
    pub header: usize,
    pub instance_descriptors: usize,
    pub sparse_values: usize,
    pub dense_headers: usize,
    pub dense_values: usize,
    pub presence_bits: usize,
}
impl OverrideLedger {
    pub fn total(self) -> usize {
        self.header
            + self.instance_descriptors
            + self.sparse_values
            + self.dense_headers
            + self.dense_values
            + self.presence_bits
    }
}
struct Entry<T> {
    node: u32,
    value: T,
}
struct Dense<T> {
    values: Vec<T>,
    present: Vec<u64>,
    count: usize,
}
enum Storage<T> {
    Sparse(Vec<Entry<T>>),
    Dense(Box<Dense<T>>),
}
struct InstancePatch<T> {
    instance: InstanceId,
    storage: Storage<T>,
}

/// Typed instance overlays. No entry, value clone or field descriptor is created
/// for an instance that still uses defaults. Sparse values are ordinal-sorted;
/// adaptive promotion occurs when sparse live-entry payload exceeds a complete
/// dense field plus its presence bitmap/header. Capacity is reported separately.
/// Dense fields do not demote until emptied; choose Sparse to avoid that policy.
pub struct Overrides<T> {
    property: Arc<Property<T>>,
    patches: Vec<InstancePatch<T>>,
    strategy: Strategy,
}
impl<T: Clone + PartialEq> Overrides<T> {
    pub fn new(property: Arc<Property<T>>) -> Self {
        Self::with_strategy(property, Strategy::Adaptive)
    }
    pub fn with_strategy(property: Arc<Property<T>>, strategy: Strategy) -> Self {
        Self {
            property,
            patches: Vec::new(),
            strategy,
        }
    }
    pub fn get(&self, scene: &Scene, target: Target) -> Result<&T, Error> {
        self.property.validate(scene, target)?;
        let default = &self.property.defaults[target.node as usize];
        Ok(self
            .patches
            .binary_search_by_key(&target.instance, |p| p.instance)
            .ok()
            .and_then(|i| self.patches[i].storage.get(target.node))
            .unwrap_or(default))
    }
    pub fn set(&mut self, scene: &Scene, target: Target, value: T) -> Result<bool, Error> {
        self.property.validate(scene, target)?;
        if *self.get(scene, target)? == value {
            return Ok(false);
        }
        let default = &self.property.defaults[target.node as usize];
        let at_default = value == *default;
        let index = match self
            .patches
            .binary_search_by_key(&target.instance, |p| p.instance)
        {
            Ok(index) => index,
            Err(index) => {
                let storage = if self.strategy == Strategy::Dense {
                    Storage::Dense(Box::new(Dense::new(&self.property.defaults)))
                } else {
                    Storage::Sparse(Vec::new())
                };
                self.patches.insert(
                    index,
                    InstancePatch {
                        instance: target.instance,
                        storage,
                    },
                );
                index
            }
        };
        let storage = &mut self.patches[index].storage;
        match storage {
            Storage::Sparse(entries) => {
                match entries.binary_search_by_key(&target.node, |e| e.node) {
                    Ok(index) if at_default => {
                        entries.remove(index);
                    }
                    Ok(index) => entries[index].value = value,
                    Err(index) => entries.insert(
                        index,
                        Entry {
                            node: target.node,
                            value,
                        },
                    ),
                }
            }
            Storage::Dense(dense) => {
                let node = target.node as usize;
                let bit = 1u64 << (node % 64);
                let was_present = dense.present[node / 64] & bit != 0;
                dense.values[node] = value;
                if at_default {
                    dense.present[node / 64] &= !bit;
                    if was_present {
                        dense.count -= 1;
                    }
                } else {
                    dense.present[node / 64] |= bit;
                    if !was_present {
                        dense.count += 1;
                    }
                }
            }
        }
        if storage.count() == 0 {
            self.patches.remove(index);
            return Ok(true);
        }
        if self.strategy == Strategy::Adaptive
            && let Storage::Sparse(entries) = storage
        {
            let nodes = self.property.defaults.len();
            let dense_bytes = std::mem::size_of::<Dense<T>>()
                + nodes * std::mem::size_of::<T>()
                + nodes.div_ceil(64) * 8;
            if entries.len() * std::mem::size_of::<Entry<T>>() >= dense_bytes {
                let mut dense = Dense::new(&self.property.defaults);
                for entry in entries.drain(..) {
                    dense.values[entry.node as usize] = entry.value;
                    dense.present[entry.node as usize / 64] |= 1u64 << (entry.node % 64);
                    dense.count += 1;
                }
                *storage = Storage::Dense(Box::new(dense));
            }
        }
        Ok(true)
    }
    pub fn representation(&self, instance: InstanceId) -> Representation {
        self.patches
            .binary_search_by_key(&instance, |p| p.instance)
            .map_or(Representation::Shared, |i| match &self.patches[i].storage {
                Storage::Sparse(v) => Representation::Sparse(v.len()),
                Storage::Dense(v) => Representation::Dense(v.count),
            })
    }
    /// Reclaims patches for dead instances in this scene, preserving other scenes. Scene mount
    /// descriptors are append-only and remain as tombstones until Scene drops.
    pub fn retain_live(&mut self, scene: &Scene) {
        self.patches
            .retain(|p| p.instance.scene != scene.id || scene.contains(p.instance));
    }
    pub fn clear_instance(&mut self, instance: InstanceId) -> bool {
        if let Ok(index) = self.patches.binary_search_by_key(&instance, |p| p.instance) {
            self.patches.remove(index);
            true
        } else {
            false
        }
    }
    /// Full field iteration performs one instance lookup and no target allocation.
    pub fn values(
        &self,
        scene: &Scene,
        instance: InstanceId,
    ) -> Result<impl Iterator<Item = &T>, Error> {
        let target = scene.target(instance, 0)?;
        self.property.validate(scene, target)?;
        let storage = self
            .patches
            .binary_search_by_key(&instance, |p| p.instance)
            .ok()
            .map(|i| &self.patches[i].storage);
        let mut sparse_index = 0;
        Ok(self
            .property
            .defaults
            .iter()
            .enumerate()
            .map(move |(node, default)| match storage {
                Some(Storage::Sparse(entries)) => {
                    if entries
                        .get(sparse_index)
                        .is_some_and(|e| e.node as usize == node)
                    {
                        let value = &entries[sparse_index].value;
                        sparse_index += 1;
                        value
                    } else {
                        default
                    }
                }
                Some(Storage::Dense(dense))
                    if dense.present[node / 64] & (1u64 << (node % 64)) != 0 =>
                {
                    &dense.values[node]
                }
                _ => default,
            }))
    }
    /// Exact container payload/capacity, excluding Arc control blocks, allocator
    /// headers and any heap storage owned internally by user-defined T.
    pub fn payload_bytes(&self) -> usize {
        self.ledger().total()
    }
    pub fn ledger(&self) -> OverrideLedger {
        let mut ledger = OverrideLedger {
            header: std::mem::size_of::<Self>(),
            instance_descriptors: self.patches.capacity() * std::mem::size_of::<InstancePatch<T>>(),
            ..OverrideLedger::default()
        };
        for patch in &self.patches {
            match &patch.storage {
                Storage::Sparse(entries) => {
                    ledger.sparse_values += entries.capacity() * std::mem::size_of::<Entry<T>>()
                }
                Storage::Dense(dense) => {
                    ledger.dense_headers += std::mem::size_of::<Dense<T>>();
                    ledger.dense_values += dense.values.capacity() * std::mem::size_of::<T>();
                    ledger.presence_bits += dense.present.capacity() * 8;
                }
            }
        }
        ledger
    }
}
impl<T> Storage<T> {
    fn count(&self) -> usize {
        match self {
            Self::Sparse(entries) => entries.len(),
            Self::Dense(dense) => dense.count,
        }
    }
    fn get(&self, node: u32) -> Option<&T> {
        match self {
            Self::Sparse(entries) => entries
                .binary_search_by_key(&node, |e| e.node)
                .ok()
                .map(|i| &entries[i].value),
            Self::Dense(dense) => ((dense.present[node as usize / 64] & (1u64 << (node % 64)))
                != 0)
                .then(|| &dense.values[node as usize]),
        }
    }
}
impl<T: Clone> Dense<T> {
    fn new(defaults: &[T]) -> Self {
        Self {
            values: defaults.to_vec(),
            present: vec![0; defaults.len().div_ceil(64)],
            count: 0,
        }
    }
}
