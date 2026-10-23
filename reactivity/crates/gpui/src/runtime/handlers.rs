//! Fixed cold route owners with a separate compact sparse key column. Empty
//! keys select dense slots; empty slots mean no routes. Property exchange keeps
//! the key while its handler is temporarily owned on the stack.
use super::{Handler, Node};

#[derive(Default)]
pub(super) struct HandlerSites {
    handlers: Box<[Option<Handler>]>,
    sites: Box<[u32]>,
}
pub(super) struct Builder {
    handlers: Vec<Option<Handler>>,
    sites: Vec<u32>,
    dense: bool,
}
const _: () = {
    #[cfg(target_pointer_width = "64")]
    {
        assert!(size_of::<Node>() == 24);
        assert!(size_of::<Option<Handler>>() == 16);
        assert!(size_of::<HandlerSites>() == 32);
    }
};
impl HandlerSites {
    fn slot(&self, node: usize) -> Option<usize> {
        if self.sites.is_empty() {
            Some(node)
        } else {
            self.sites.binary_search(&(node as u32)).ok()
        }
    }
    pub(super) fn get(&self, node: usize) -> Option<&Handler> {
        self.handlers.get(self.slot(node)?).and_then(Option::as_ref)
    }
    pub(super) fn get_mut(&mut self, node: usize) -> &mut Option<Handler> {
        let slot = self.slot(node).expect("installed route site");
        &mut self.handlers[slot]
    }
    // Only sparse routed rows borrow their old ordinal as a route slot.
    // Siblings already read it; every reused row resets it before publication.
    pub(super) fn index_old(&self, nodes: &mut [Node]) {
        for (slot, &node) in self.sites.iter().enumerate() {
            nodes[node as usize].ordinal = slot as u32;
        }
    }
    pub(super) fn take_old(&mut self, index: usize, node: &Node) -> Option<Handler> {
        if !node.content.has_route() {
            return None;
        }
        let slot = if self.sites.is_empty() {
            index
        } else {
            node.ordinal as usize
        };
        self.handlers[slot].take()
    }
}
impl Builder {
    pub(super) fn new(nodes: usize, routes: usize) -> Self {
        let dense = routes * (size_of::<Option<Handler>>() + size_of::<u32>())
            >= nodes * size_of::<Option<Handler>>();
        Self {
            handlers: Vec::with_capacity(if dense { nodes } else { routes }),
            sites: Vec::with_capacity(if dense { 0 } else { routes }),
            dense,
        }
    }
    pub(super) fn push(&mut self, node: usize, handler: Option<Handler>) {
        if self.dense {
            debug_assert_eq!(self.handlers.len(), node);
            self.handlers.push(handler);
        } else if handler.is_some() {
            debug_assert!(self.sites.last().is_none_or(|last| *last < node as u32));
            self.handlers.push(handler);
            self.sites.push(node as u32);
        }
    }
    pub(super) fn finish(self) -> HandlerSites {
        HandlerSites {
            handlers: self.handlers.into_boxed_slice(),
            sites: self.sites.into_boxed_slice(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn route() -> Handler {
        Handler::window(super::super::inspector::WindowAction::Inspector(
            super::super::inspector::InspectorAction::Pick,
        ))
    }
    fn build(nodes: usize, routes: usize) -> HandlerSites {
        let mut builder = Builder::new(nodes, routes);
        assert_eq!(builder.dense, routes * 20 >= nodes * 16);
        assert_eq!(
            builder.handlers.capacity(),
            if builder.dense { nodes } else { routes }
        );
        assert_eq!(
            builder.sites.capacity(),
            if builder.dense { 0 } else { routes }
        );
        for node in 0..nodes {
            builder.push(node, (node < routes).then(route));
        }
        builder.finish()
    }
    #[test]
    fn fixed_columns_choose_exact_request_threshold_and_preserve_taken_sites() {
        for nodes in 0..=64 {
            for routes in 0..=nodes {
                let mut sites = build(nodes, routes);
                for node in 0..nodes {
                    assert_eq!(sites.get(node).is_some(), node < routes);
                    if node < routes {
                        let handler = sites.get_mut(node).take().unwrap();
                        assert!(sites.get(node).is_none());
                        *sites.get_mut(node) = Some(handler);
                        assert!(sites.get(node).is_some());
                    }
                }
            }
        }
    }
    #[test]
    fn empty_columns_allocate_nothing_and_temporary_capacities_are_exact_here() {
        let allocation = allocation_counter::measure(|| {
            drop(HandlerSites::default());
            drop(build(0, 0));
            drop(build(100, 0));
        });
        assert_eq!(allocation.count_total, 0);
    }
    #[test]
    fn old_indexing_touches_only_sparse_routes_and_takes_dense_by_row() {
        use super::super::{Content, NodeKind, Parent, TextSlot};
        use std::num::NonZeroU64;
        for pattern in 0..4 {
            let routed = |node| match pattern {
                0 => false,
                1 => true,
                2 => [1, 5, 11].contains(&node),
                _ => node != 6,
            };
            let mut builder = Builder::new(12, (0..12).filter(|&node| routed(node)).count());
            let mut nodes = (0..12)
                .map(|index| {
                    builder.push(index, routed(index).then(route));
                    Node {
                        identity: NonZeroU64::new(index as u64 + 1).unwrap(),
                        parent: Parent::new(index.checked_sub(1)),
                        ordinal: 0,
                        content: Content::new(NodeKind::Div, TextSlot::NONE)
                            .with_route(routed(index)),
                        component_scope: 0,
                    }
                })
                .collect::<Vec<_>>();
            let mut sites = builder.finish();
            sites.index_old(&mut nodes);
            let mut sparse_slot = 0;
            for (index, node) in nodes.iter().enumerate() {
                let expected = if routed(index) && !sites.sites.is_empty() {
                    let slot = sparse_slot;
                    sparse_slot += 1;
                    slot
                } else {
                    0
                };
                assert_eq!(node.ordinal, expected);
            }
            for index in (0..12).rev() {
                assert_eq!(
                    sites.take_old(index, &nodes[index]).is_some(),
                    routed(index)
                );
                // Temporary ownership never changes logical eligibility.
                assert_eq!(nodes[index].content.has_route(), routed(index));
                assert!(sites.take_old(index, &nodes[index]).is_none());
            }
        }
    }

    #[test]
    fn route_presence_masks_every_bounded_content_payload() {
        use super::super::{Content, MAX_NODES, NodeKind, TextSlot, image::ImageUse};
        for index in [0, 1, MAX_NODES as u32 - 1] {
            for kind in [
                NodeKind::Div,
                NodeKind::Text,
                NodeKind::Input,
                NodeKind::Button,
                NodeKind::List,
                NodeKind::ListItem,
                NodeKind::Scroll,
                NodeKind::CheckBox(false),
                NodeKind::CheckBox(true),
            ] {
                for text in [TextSlot::NONE, TextSlot(index)] {
                    let base = Content::new(kind, text);
                    let routed = base.with_route(true);
                    assert!(routed.has_route());
                    assert_eq!(routed.kind(), kind);
                    assert_eq!(routed.text_slot().0, text.0);
                    assert_eq!(routed.with_route(false).0, base.0);
                    assert!(routed.image_use().is_none());
                }
            }
            for sampling in [crate::ImageSampling::Linear, crate::ImageSampling::Nearest] {
                let base = Content::image(ImageUse {
                    resource: index,
                    sampling,
                });
                let routed = base.with_route(true);
                let image = routed.image_use().unwrap();
                assert_eq!(image.resource, index);
                assert_eq!(image.sampling, sampling);
                assert_eq!(routed.text_slot().0, TextSlot::NONE.0);
                assert_eq!(routed.with_route(false).0, base.0);
            }
        }
    }
}
