//! Three bounded description addresses share the former parent/ordinal word.
//! Low to high: parent+1 (zero is none), ordinal, route-slot+1 (zero is none).
//! Mount identities and component owner scopes retain their full separate words.
use super::{MAX_NODES, Parent};

#[derive(Clone, Copy)]
pub(super) struct Topology(u64);
const _: () = {
    assert!(MAX_NODES > 0 && Topology::BITS * 3 <= u64::BITS);
    assert!(size_of::<Topology>() == 8);
    #[cfg(target_pointer_width = "64")]
    {
        assert!(size_of::<super::Node>() == 24);
        assert!(size_of::<Option<super::Node>>() == 24);
        assert!(size_of::<Option<super::Handler>>() == 16);
        assert!(size_of::<Box<[Option<super::Handler>]>>() == 16);
    }
};
impl Topology {
    const BITS: u32 = usize::BITS - MAX_NODES.leading_zeros();
    const MASK: u64 = u64::MAX >> (u64::BITS - Self::BITS);
    const ROUTE_SHIFT: u32 = Self::BITS * 2;

    pub(super) fn new(parent: Option<usize>, ordinal: u32, route: Option<usize>) -> Self {
        assert!((ordinal as usize) < MAX_NODES, "admitted sibling ordinal");
        let encode = |index: Option<usize>| {
            index.map_or(0, |index| {
                assert!(index < MAX_NODES, "admitted topology index");
                index as u64 + 1
            })
        };
        Self(
            encode(parent)
                | (u64::from(ordinal) << Self::BITS)
                | (encode(route) << Self::ROUTE_SHIFT),
        )
    }
    pub(super) fn parent(self) -> Parent {
        Parent(((self.0 & Self::MASK) as u32).wrapping_sub(1))
    }
    pub(super) fn ordinal(self) -> u32 {
        ((self.0 >> Self::BITS) & Self::MASK) as u32
    }
    pub(super) fn route(self) -> Option<usize> {
        let route = self.0 >> Self::ROUTE_SHIFT;
        (route != 0).then(|| route as usize - 1)
    }
    pub(super) fn has_route(self) -> bool {
        self.0 >> Self::ROUTE_SHIFT != 0
    }
}

#[cfg(test)]
mod tests {
    use super::super::{Content, Node, NodeKind, TextSlot};
    use super::*;
    use std::num::NonZeroU64;

    #[test]
    fn bounded_fields_round_trip_without_touching_full_width_identity_or_scope() {
        assert_eq!(Topology::BITS, 17);
        for parent in [None, Some(0), Some(MAX_NODES - 1)] {
            for ordinal in [0, 1, MAX_NODES as u32 - 1] {
                for route in [None, Some(0), Some(MAX_NODES - 1)] {
                    let topology = Topology::new(parent, ordinal, route);
                    assert_eq!(topology.parent().index(), parent);
                    assert_eq!(topology.ordinal(), ordinal);
                    assert_eq!(topology.route(), route);
                    assert_eq!(topology.has_route(), route.is_some());
                    assert_eq!(topology.0 >> (3 * Topology::BITS), 0);
                    for scope in [0, 1, u32::MAX] {
                        let node = Node {
                            identity: NonZeroU64::new(u64::MAX).unwrap(),
                            topology,
                            content: Content::new(NodeKind::CheckBox(true), TextSlot::NONE),
                            component_scope: scope,
                        };
                        assert_eq!(node.identity(), u64::MAX);
                        assert_eq!(node.component_scope, scope);
                        assert_eq!(node.kind(), NodeKind::CheckBox(true));
                        assert_eq!(node.parent().index(), parent);
                        assert_eq!(node.ordinal(), ordinal);
                        assert_eq!(node.route(), route);
                    }
                }
            }
        }
        for index in 0..MAX_NODES {
            let topology = Topology::new(Some(index), index as u32, Some(index));
            assert_eq!(topology.parent().index(), Some(index));
            assert_eq!(topology.ordinal(), index as u32);
            assert_eq!(topology.route(), Some(index));
        }
    }

    #[test]
    fn first_unadmitted_indices_and_ordinals_reject_before_packing() {
        use std::panic::catch_unwind;
        for index in [MAX_NODES, usize::MAX] {
            assert!(catch_unwind(|| Topology::new(Some(index), 0, None)).is_err());
            assert!(catch_unwind(|| Topology::new(None, 0, Some(index))).is_err());
        }
        for ordinal in [MAX_NODES as u32, u32::MAX] {
            assert!(catch_unwind(|| Topology::new(None, ordinal, None)).is_err());
        }
    }

    #[test]
    fn real_owner_assigns_compact_slots_and_temporary_takes_preserve_topology() {
        use crate::prelude::*;
        struct Page;
        impl View for Page {
            fn view(&self) -> El<'_> {
                column((0..6).map(|index| {
                    let site = div().size(1);
                    if index % 2 == 0 {
                        site.on_click(|_: &mut Self| {})
                    } else {
                        site
                    }
                }))
            }
        }
        let mut win = Win::demo(Page);
        let mut runtime = win.runtime_mut().unwrap();
        assert_eq!(runtime.handlers.len(), 3);
        let rows = runtime
            .nodes
            .iter()
            .enumerate()
            .filter_map(|(index, node)| {
                node.route()
                    .map(|slot| (index, slot, node.parent().index(), node.ordinal()))
            })
            .collect::<Vec<_>>();
        assert_eq!(
            rows.iter()
                .map(|&(index, slot, _, _)| (index, slot))
                .collect::<Vec<_>>(),
            [(1, 0), (3, 1), (5, 2)]
        );
        for &(index, slot, parent, ordinal) in rows.iter().rev() {
            let handler = runtime.handlers[slot].take().unwrap();
            let node = &runtime.nodes[index];
            assert!(node.has_route());
            assert_eq!(node.route(), Some(slot));
            assert_eq!(node.parent().index(), parent);
            assert_eq!(node.ordinal(), ordinal);
            runtime.handlers[slot] = Some(handler);
        }
    }
}
