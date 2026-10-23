//! Parent stays a raw u32. Ordinal shares its word with the low route bits;
//! Content's unused high bits hold the remaining route bits and presence.
use super::{Content, MAX_NODES, Node};

const INDEX_BITS: u32 = usize::BITS - MAX_NODES.leading_zeros();
const ORDINAL_MASK: u32 = u32::MAX >> (u32::BITS - INDEX_BITS);
const LOW_ROUTE_BITS: u32 = u32::BITS - INDEX_BITS;
const HIGH_ROUTE_BITS: u32 = INDEX_BITS.saturating_sub(LOW_ROUTE_BITS);
const HIGH_ROUTE_SHIFT: u32 = u32::BITS - 1 - HIGH_ROUTE_BITS;
const ROUTE_PRESENT: u32 = 1 << (u32::BITS - 1);
const HIGH_ROUTE_MASK: u32 = (1 << HIGH_ROUTE_BITS) - 1;
pub(super) const CONTENT_VALUE_MASK: u32 = (1 << HIGH_ROUTE_SHIFT) - 1;
const _: () = {
    assert!(MAX_NODES > 0 && INDEX_BITS < u32::BITS && HIGH_ROUTE_BITS < 31);
    #[cfg(target_pointer_width = "64")]
    {
        assert!(size_of::<Node>() == 24);
        assert!(size_of::<Option<Node>>() == 24);
        assert!(size_of::<Option<super::Handler>>() == 16);
        assert!(size_of::<Box<[Option<super::Handler>]>>() == 16);
    }
};
impl Node {
    pub(super) fn ordinal(&self) -> u32 {
        self.ordinal_route & ORDINAL_MASK
    }
    pub(super) fn has_route(&self) -> bool {
        self.content.0 & ROUTE_PRESENT != 0
    }
    #[inline]
    pub(super) fn route(&self) -> Option<usize> {
        self.has_route().then(|| {
            ((self.ordinal_route >> INDEX_BITS)
                | (((self.content.0 >> HIGH_ROUTE_SHIFT) & HIGH_ROUTE_MASK) << LOW_ROUTE_BITS))
                as usize
        })
    }
    #[inline]
    pub(super) fn set_route(&mut self, ordinal: u32, route: Option<usize>) {
        let slot = route.unwrap_or(0);
        assert!((ordinal as usize) < MAX_NODES, "admitted sibling ordinal");
        assert!(slot < MAX_NODES, "admitted route slot");
        self.ordinal_route = ordinal | ((slot as u32) << INDEX_BITS);
        self.content.0 = (self.content.0 & CONTENT_VALUE_MASK)
            | (((slot as u32) >> LOW_ROUTE_BITS) << HIGH_ROUTE_SHIFT)
            | (u32::from(route.is_some()) << (u32::BITS - 1));
    }
    /// Content replacements change kind/text/image without erasing the route.
    #[inline]
    pub(super) fn replace_content(&mut self, content: Content) {
        self.content.0 = (self.content.0 & !CONTENT_VALUE_MASK) | (content.0 & CONTENT_VALUE_MASK);
    }
}

#[cfg(test)]
mod tests {
    use super::super::{NodeKind, Parent, TextSlot};
    use super::*;
    use std::{num::NonZeroU64, panic::AssertUnwindSafe};

    fn fresh_node() -> Node {
        Node {
            identity: NonZeroU64::new(u64::MAX).unwrap(),
            parent: Parent::new(Some(MAX_NODES - 1)),
            ordinal_route: 0,
            content: Content::new(NodeKind::Div, TextSlot::NONE),
            component_scope: u32::MAX,
        }
    }

    #[test]
    fn all_admitted_slots_and_split_boundaries_preserve_parent_identity_and_scope() {
        assert_eq!((INDEX_BITS, LOW_ROUTE_BITS, HIGH_ROUTE_BITS), (17, 15, 2));
        assert_eq!(CONTENT_VALUE_MASK, 0x1fff_ffff);
        let mut node = fresh_node();
        for index in 0..MAX_NODES {
            node.set_route(index as u32, Some(index));
            assert_eq!(node.ordinal(), index as u32);
            assert_eq!(node.route(), Some(index));
            assert!(node.has_route());
            assert_eq!(node.parent.0, MAX_NODES as u32 - 1);
            assert_eq!(node.identity(), u64::MAX);
            assert_eq!(node.component_scope, u32::MAX);
        }
        for route in [
            None,
            Some(0),
            Some(32767),
            Some(32768),
            Some(65535),
            Some(65536),
            Some(98303),
            Some(98304),
            Some(MAX_NODES - 1),
        ] {
            for ordinal in [0, 1, MAX_NODES as u32 - 1] {
                node.set_route(ordinal, route);
                assert_eq!(node.ordinal(), ordinal);
                assert_eq!(node.route(), route);
                assert_eq!(node.has_route(), route.is_some());
                assert_eq!(node.parent.0, MAX_NODES as u32 - 1);
            }
        }
        node.parent = Parent::NONE;
        node.set_route(0, None);
        assert_eq!(node.parent.0, u32::MAX);
        assert_eq!(node.ordinal_route, 0);
        assert_eq!(node.content.0, 0);
    }

    #[test]
    fn invalid_indices_reject_before_mutating_either_word() {
        let mut node = fresh_node();
        node.set_route(91, Some(MAX_NODES - 1));
        let before = (node.ordinal_route, node.content.0);
        for slot in [MAX_NODES, usize::MAX] {
            assert!(
                std::panic::catch_unwind(AssertUnwindSafe(|| node.set_route(0, Some(slot))))
                    .is_err()
            );
            assert_eq!((node.ordinal_route, node.content.0), before);
        }
        for ordinal in [MAX_NODES as u32, u32::MAX] {
            assert!(
                std::panic::catch_unwind(AssertUnwindSafe(|| node.set_route(ordinal, None)))
                    .is_err()
            );
            assert_eq!((node.ordinal_route, node.content.0), before);
        }
    }

    #[test]
    fn content_replacements_preserve_routes_and_all_payload_decoders_ignore_route_bits() {
        let mut node = fresh_node();
        for route in [None, Some(0), Some(32768), Some(65536), Some(MAX_NODES - 1)] {
            node.set_route(18, route);
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
                for text in [TextSlot::NONE, TextSlot(0), TextSlot(MAX_NODES as u32 - 1)] {
                    node.replace_content(Content::new(kind, text));
                    assert_eq!(node.kind(), kind);
                    assert_eq!(node.text_slot().0, text.0);
                    assert!(node.content.image_use().is_none());
                    assert_eq!(node.route(), route);
                    assert_eq!(node.ordinal(), 18);
                }
            }
            for resource in [0, MAX_NODES as u32 - 1] {
                for sampling in [crate::ImageSampling::Linear, crate::ImageSampling::Nearest] {
                    node.replace_content(Content::image(super::super::image::ImageUse {
                        resource,
                        sampling,
                    }));
                    assert_eq!(node.kind(), NodeKind::Image);
                    assert_eq!(node.text_slot().0, u32::MAX);
                    let image = node.content.image_use().unwrap();
                    assert_eq!(image.resource, resource);
                    assert_eq!(image.sampling, sampling);
                    assert_eq!(node.route(), route);
                    assert_eq!(node.ordinal(), 18);
                }
            }
            // Even routed replacement content cannot overwrite this node's slot.
            let mut other = fresh_node();
            other.set_route(7, Some(3));
            node.replace_content(other.content);
            assert_eq!(node.route(), route);
        }
    }

    #[test]
    fn real_owner_assigns_compact_slots_and_temporary_takes_preserve_both_words() {
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
                node.route().map(|slot| {
                    (
                        index,
                        slot,
                        node.parent.0,
                        node.ordinal_route,
                        node.content.0,
                    )
                })
            })
            .collect::<Vec<_>>();
        assert_eq!(
            rows.iter()
                .map(|&(index, slot, _, _, _)| (index, slot))
                .collect::<Vec<_>>(),
            [(1, 0), (3, 1), (5, 2)]
        );
        for &(index, slot, parent, ordinal_route, content) in rows.iter().rev() {
            let handler = runtime.handlers[slot].take().unwrap();
            let node = &runtime.nodes[index];
            assert!(node.has_route());
            assert_eq!(node.route(), Some(slot));
            assert_eq!(
                (node.parent.0, node.ordinal_route, node.content.0),
                (parent, ordinal_route, content)
            );
            runtime.handlers[slot] = Some(handler);
        }
    }

    #[test]
    #[ignore = "structural spike: exercise every route address in a max-admission owner"]
    fn max_admitted_owner_dispatches_routes_across_both_high_bits() {
        use crate::{WindowOptions, prelude::*};
        struct Page {
            seen: Signal<usize>,
        }
        impl Page {
            const SEEN: Source<Self, usize> =
                Source::new(FieldId::new(1), "seen", |m| &m.seen, |m| &mut m.seen);
            fn site<'a>(index: usize, site: El<'a>) -> El<'a> {
                site.on_click(Self::SEEN.update(move |seen| *seen = index))
            }
        }
        impl View for Page {
            fn sources() -> Sources<Self> {
                Sources::new().direct(Self::SEEN)
            }
            fn view(&self) -> El<'_> {
                Self::site(
                    0,
                    column((1..MAX_NODES).map(|index| Self::site(index, div().w(8).h(1)))),
                )
            }
        }
        let mut win = Win::recording(
            Page {
                seen: Signal::new(usize::MAX),
            },
            WindowOptions {
                size: [32, 32],
                ..Default::default()
            },
        )
        .unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        let snapshot = win.snapshot().unwrap();
        assert_eq!(snapshot.nodes.len(), MAX_NODES);
        let targets = snapshot
            .nodes
            .iter()
            .map(|node| node.target.unwrap())
            .collect::<Vec<_>>();
        drop(snapshot);
        let before = win.counters();
        for index in [0, 32767, 32768, 65535, 65536, 98303, 98304, MAX_NODES - 1] {
            win.activate(targets[index]).unwrap();
            assert_eq!(*win.root().unwrap().seen, index);
        }
        assert_eq!(win.counters().owner_reruns, before.owner_reruns);
        assert_eq!(win.counters().exact_updates - before.exact_updates, 8);
        let runtime = win.runtime_mut().unwrap();
        assert_eq!(runtime.handlers.len(), MAX_NODES);
        for (index, node) in runtime.nodes.iter().enumerate() {
            assert_eq!(node.route(), Some(index));
            assert!(runtime.handlers[index].is_some());
        }
    }
}
