enum AbsoluteContexts {
    Empty,
    Single(NodeId, AbsoluteContext),
    Many(BTreeMap<NodeId, AbsoluteContext>),
}

impl AbsoluteContexts {
    fn len(&self) -> usize {
        match self {
            Self::Empty => 0,
            Self::Single(..) => 1,
            Self::Many(records) => records.len(),
        }
    }
    fn is_empty(&self) -> bool {
        self.len() == 0
    }
    fn get(&self, node: &NodeId) -> Option<&AbsoluteContext> {
        match self {
            Self::Single(key, record) if key == node => Some(record),
            Self::Many(records) => records.get(node),
            _ => None,
        }
    }
    fn insert(&mut self, node: NodeId, record: AbsoluteContext) {
        match self {
            Self::Empty => *self = Self::Single(node, record),
            Self::Single(key, previous) if *key == node => *previous = record,
            Self::Single(..) => {
                let Self::Single(key, previous) = std::mem::replace(self, Self::Empty) else {
                    unreachable!()
                };
                let mut records = BTreeMap::new();
                records.insert(key, previous);
                records.insert(node, record);
                *self = Self::Many(records);
            }
            Self::Many(records) => {
                records.insert(node, record);
            }
        }
    }
    fn remove(&mut self, node: &NodeId) -> Option<AbsoluteContext> {
        match self {
            Self::Single(key, _) if key == node => {
                let Self::Single(_, record) = std::mem::replace(self, Self::Empty) else {
                    unreachable!()
                };
                Some(record)
            }
            Self::Many(records) => records.remove(node),
            _ => None,
        }
    }
    #[cfg(test)]
    fn iter(&self) -> impl Iterator<Item = (&NodeId, &AbsoluteContext)> {
        let single = match self {
            Self::Single(key, record) => Some((key, record)),
            _ => None,
        };
        let many = match self {
            Self::Many(records) => Some(records),
            _ => None,
        };
        single
            .into_iter()
            .chain(many.into_iter().flat_map(BTreeMap::iter))
    }
}

