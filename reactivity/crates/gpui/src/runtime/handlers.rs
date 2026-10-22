//! Cold route owners. A retained column has no spare capacity; only the builder
//! grows, in admitted node order. A property exchange temporarily owns one
//! handler on the stack without removing its site or changing route eligibility.
use super::{Handler, Node};

struct RouteSite {
    node: u32,
    handler: Option<Handler>,
}

enum Column<D, S> {
    Dense(D),
    Sparse(S),
}

pub(super) struct HandlerSites(Column<Box<[Option<Handler>]>, Box<[RouteSite]>>);
pub(super) struct Builder(Column<Vec<Option<Handler>>, Vec<RouteSite>>);

impl Default for HandlerSites {
    fn default() -> Self {
        Self(Column::Sparse(Box::default()))
    }
}

// These bounds price the policy and reserve the sentinel used while reconciling.
const _: () = {
    assert!(super::MAX_NODES < u32::MAX as usize);
    assert!(size_of::<super::Content>() == 4);
    #[cfg(target_pointer_width = "64")]
    {
        assert!(size_of::<Node>() == 24);
        assert!(size_of::<Option<Handler>>() == 16);
        assert!(size_of::<RouteSite>() == 24);
        assert!(size_of::<HandlerSites>() == 24);
    }
};

impl HandlerSites {
    pub(super) fn get(&self, node: usize) -> Option<&Handler> {
        match &self.0 {
            Column::Dense(slots) => slots[node].as_ref(),
            Column::Sparse(sites) => sites
                .binary_search_by_key(&(node as u32), |site| site.node)
                .ok()
                .and_then(|index| sites[index].handler.as_ref()),
        }
    }
    pub(super) fn get_mut(&mut self, node: usize) -> &mut Option<Handler> {
        match &mut self.0 {
            Column::Dense(slots) => &mut slots[node],
            Column::Sparse(sites) => {
                let index = sites
                    .binary_search_by_key(&(node as u32), |site| site.node)
                    .expect("installed route site");
                &mut sites[index].handler
            }
        }
    }
    // Called only after Siblings has read every old ordinal. Every consumed
    // row resets its ordinal before publication; retired rows are never reused.
    pub(super) fn index_old(&self, nodes: &mut [Node]) {
        match &self.0 {
            Column::Dense(slots) => {
                debug_assert_eq!(slots.len(), nodes.len());
                for (index, node) in nodes.iter_mut().enumerate() {
                    node.ordinal = index as u32;
                }
            }
            Column::Sparse(sites) => {
                for node in nodes.iter_mut() {
                    node.ordinal = u32::MAX;
                }
                for (index, site) in sites.iter().enumerate() {
                    nodes[site.node as usize].ordinal = index as u32;
                }
            }
        }
    }
    pub(super) fn take_slot(&mut self, slot: u32) -> Option<Handler> {
        if slot == u32::MAX {
            return None;
        }
        match &mut self.0 {
            Column::Dense(slots) => slots[slot as usize].take(),
            Column::Sparse(sites) => sites[slot as usize].handler.take(),
        }
    }
}
impl Builder {
    pub(super) fn new(nodes: usize, routes: usize) -> Self {
        // Final boxed slices contain exactly these element counts. Their
        // headers have equal size, so ties favor direct dense lookup. Vec's
        // temporary actual capacity is charged separately in the phase ledger.
        if routes * size_of::<RouteSite>() < nodes * size_of::<Option<Handler>>() {
            Self(Column::Sparse(Vec::with_capacity(routes)))
        } else {
            Self(Column::Dense(Vec::with_capacity(nodes)))
        }
    }
    pub(super) fn push(&mut self, node: usize, handler: Option<Handler>) {
        match &mut self.0 {
            Column::Dense(slots) => {
                debug_assert_eq!(slots.len(), node);
                slots.push(handler);
            }
            Column::Sparse(sites) => {
                if handler.is_some() {
                    debug_assert!(sites.last().is_none_or(|site| site.node < node as u32));
                    sites.push(RouteSite {
                        node: node as u32,
                        handler,
                    });
                }
            }
        }
    }
    pub(super) fn finish(self) -> HandlerSites {
        HandlerSites(match self.0 {
            Column::Dense(slots) => Column::Dense(slots.into_boxed_slice()),
            Column::Sparse(sites) => Column::Sparse(sites.into_boxed_slice()),
        })
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
                assert_eq!(
                    matches!(sites.0, Column::Sparse(_)),
                    routes * 24 < nodes * 16
                );
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
        for (nodes, routes) in [(1, 1), (100, 1), (100, 66), (100, 67), (100, 100)] {
            let builder = Builder::new(nodes, routes);
            let (capacity, expected) = match &builder.0 {
                Column::Dense(slots) => (slots.capacity(), nodes),
                Column::Sparse(sites) => (sites.capacity(), routes),
            };
            assert_eq!(capacity, expected);
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
