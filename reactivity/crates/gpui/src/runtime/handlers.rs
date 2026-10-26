//! One retained slot per installed route, indexed directly by NodeLinks. The
//! optional owner keeps the vector header out of handler-free runtimes.
use super::Handler;

pub(super) struct Handlers {
    values: Vec<Option<Handler>>,
}
impl Handlers {
    pub(super) fn new(count: usize) -> Option<Box<Self>> {
        (count != 0).then(|| {
            Box::new(Self {
                values: Vec::with_capacity(count),
            })
        })
    }
    // Reuse the cold owner, but exchange its vector in full: old site indices
    // address only the returned retired routes until their normal drop barrier.
    pub(super) fn replace(
        previous: Option<Box<Self>>,
        count: usize,
    ) -> (Option<Box<Self>>, Vec<Option<Handler>>) {
        match previous {
            Some(mut owner) => {
                let retired = std::mem::replace(&mut owner.values, Vec::with_capacity(count));
                ((count != 0).then_some(owner), retired)
            }
            None => (Self::new(count), Vec::new()),
        }
    }
    pub(super) fn push(&mut self, handler: Handler) -> usize {
        let slot = self.values.len();
        self.values.push(Some(handler));
        slot
    }
    pub(super) fn get(&self, slot: usize) -> &Handler {
        self.values[slot].as_ref().expect("installed route")
    }
    pub(super) fn take(&mut self, slot: usize) -> Handler {
        self.values[slot].take().expect("installed route")
    }
    pub(super) fn restore(&mut self, slot: usize, handler: Handler) {
        self.values[slot] = Some(handler);
    }
}

#[cfg(test)]
mod tests {
    use super::super::*;
    use super::Handlers;
    use crate::prelude::*;
    struct Blank;
    impl View for Blank {
        fn view(&self) -> El<'_> {
            div()
        }
    }
    #[test]
    fn retained_header_and_capacity_ledger() {
        println!(
            "HANDLER_LAYOUT node={} optional_node={} runtime={} owner_slot={} table={} handler={} parent={} links={}",
            size_of::<Node>(),
            size_of::<Option<Node>>(),
            size_of::<Runtime<Blank>>(),
            size_of::<Option<Box<Handlers>>>(),
            size_of::<Handlers>(),
            size_of::<Option<Handler>>(),
            size_of::<Parent>(),
            size_of::<links::NodeLinks>()
        );
        for count in [0, 1, 2, 63, 64, 65, 100_000] {
            let table = Handlers::new(count);
            assert_eq!(table.is_some(), count != 0);
            if let Some(table) = table {
                assert_eq!(table.values.capacity(), count);
                println!(
                    "HANDLER_CAPACITY count={count} capacity={} bytes={}",
                    table.values.capacity(),
                    size_of::<Handlers>() + table.values.capacity() * size_of::<Option<Handler>>()
                );
            }
        }
    }
    #[test]
    fn replacement_reuses_only_the_cold_owner_and_releases_empty_capacity() {
        for (before, after) in [(0, 0), (0, 1), (1, 1), (100_000, 1), (1, 0)] {
            let previous = Handlers::new(before);
            let mut replaced = None;
            let allocation = allocation_counter::measure(|| {
                replaced = Some(Handlers::replace(previous, after));
            });
            let (owner, retired) = replaced.unwrap();
            let allocations = if after == 0 {
                0
            } else if before == 0 {
                2
            } else {
                1
            };
            assert_eq!(allocation.count_total, allocations);
            assert_eq!(owner.is_some(), after != 0);
            assert_eq!(
                owner.as_deref().map_or(0, |owner| owner.values.capacity()),
                after
            );
            assert_eq!(retired.capacity(), before);
            println!(
                "HANDLER_REPLACE before={before} after={after} allocations={} requested={}",
                allocation.count_total, allocation.bytes_total
            );
        }
    }
}
