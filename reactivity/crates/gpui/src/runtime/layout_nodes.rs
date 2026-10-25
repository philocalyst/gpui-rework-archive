//! Fresh-prefix compression is an implementation choice, not a topology rule.
//! Edited trees retain complete capabilities and a checked inverse routing map.
use super::*;

pub(super) enum LayoutNodes {
    Fresh(NodeIdRange),
    Edited(Box<Edited>),
}
pub(super) struct Edited {
    ordered: Vec<NodeId>,
    reverse: Vec<(NodeId, usize)>,
}
impl Default for LayoutNodes {
    fn default() -> Self {
        Self::Fresh(NodeIdRange::default())
    }
}
impl LayoutNodes {
    pub fn len(&self) -> usize {
        match self {
            Self::Fresh(range) => range.len(),
            Self::Edited(map) => map.ordered.len(),
        }
    }
    pub fn clear(&mut self) {
        *self = Self::default();
    }
    pub fn get(&self, index: usize) -> Option<NodeId> {
        match self {
            Self::Fresh(range) => range.get(index),
            Self::Edited(map) => map.ordered.get(index).copied(),
        }
    }
    pub fn required(&self, index: usize) -> NodeId {
        self.get(index).expect("admitted logical layout row")
    }
    pub fn index_of(&self, id: NodeId) -> Option<usize> {
        match self {
            Self::Fresh(range) => range.index_of(id),
            Self::Edited(map) => map.reverse.binary_search_by_key(&id, |(id, _)| *id)
                .ok().map(|index| map.reverse[index].1),
        }
    }
    pub fn push(&mut self, id: NodeId) -> Result<(), gpui_reactivity_core::TreeError> {
        match self {
            Self::Fresh(range) => range.push(id),
            Self::Edited(_) => Err(gpui_reactivity_core::TreeError::InvalidNode),
        }
    }
    fn edited(ordered: Vec<NodeId>) -> Result<Self, LayoutError> {
        // Keep full namespace/generation/slot capabilities, but allocate one
        // contiguous inverse rather than one tree node per small fanout. This
        // is built once per topology turn; measurements only binary-search it.
        let mut reverse: Vec<_> = ordered.iter().copied().enumerate()
            .map(|(index, id)| (id, index)).collect();
        reverse.sort_unstable_by_key(|(id, _)| *id);
        if reverse.windows(2).any(|pair| pair[0].0 == pair[1].0) {
            return Err(gpui_reactivity_core::TreeError::InvalidNode.into());
        }
        Ok(Self::Edited(Box::new(Edited { ordered, reverse })))
    }
}

pub(super) struct EditPlan {
    pub nodes: Vec<Option<NodeId>>,
    pub retired: Vec<NodeId>,
}
impl EditPlan {
    pub fn prefix(previous: &LayoutNodes, prefix: usize, capacity: usize) -> Self {
        let mut nodes = Vec::with_capacity(capacity);
        nodes.extend((0..prefix).map(|index| Some(previous.required(index))));
        Self { nodes, retired: Vec::new() }
    }
}

impl<M: View + 'static> Runtime<M> {
    /// Apply one description-admitted plan to private layout scratch. The old P
    /// and eligible C own their immutable rows/scenes independently. Clear the
    /// routing map before any edit so a failed/panicked partial application can
    /// only take the existing full-rebuild fallback, never route a stale handle.
    pub(super) fn apply_layout_edits(&mut self, mut plan: EditPlan) -> Result<(), Error> {
        self.layout_nodes.clear();
        if plan.nodes.len() != self.nodes.len() {
            return Err(LayoutError::Tree(gpui_reactivity_core::TreeError::InvalidNode).into());
        }
        for index in 0..plan.nodes.len() {
            let Some(id) = plan.nodes[index] else { continue };
            let parent = self.nodes[index].parent().index().and_then(|parent| plan.nodes[parent]);
            let old_parent = self.layout.tree().parent(id).map_err(LayoutError::from)?;
            if old_parent != parent {
                // Extract survivors before retiring any old ancestor. A new
                // parent with no handle yet is attached in the later order pass.
                self.layout.reparent(id, None)?;
            }
        }
        for id in plan.retired {
            if self.layout.tree().contains(id) {
                self.layout.remove(id)?;
            }
        }
        for index in 0..plan.nodes.len() {
            if plan.nodes[index].is_some() { continue }
            let node = &self.nodes[index];
            let parent = match node.parent().index() {
                Some(parent) => Some(plan.nodes[parent].ok_or(
                    LayoutError::Tree(gpui_reactivity_core::TreeError::InvalidNode),
                )?),
                None => None,
            };
            let id = self.layout.insert(
                parent,
                gpui_reactivity_core::NodeKind::Element,
                list::row_style(
                    node.kind(), &self.styles.get(index),
                    node.parent().index().map(|parent| self.styles.get(parent).flow),
                    self.list_rows.get(&node.identity()),
                ),
            )?;
            if node.text_slot().0 != u32::MAX || node.kind() == NodeKind::Image {
                self.layout.set_measure(id, Some(measure_marker))?;
            }
            plan.nodes[index] = Some(id);
        }
        // Reverse preorder needs only the open ancestor frontier: once a
        // parent's own row is reached, no later row can name it as parent.
        // Store one following sibling per open depth, not one bucket per row.
        let mut following: Vec<(Option<usize>, NodeId)> = Vec::new();
        for index in (0..plan.nodes.len()).rev() {
            let id = plan.nodes[index].expect("every admitted row now has a handle");
            let parent_index = self.nodes[index].parent().index();
            let parent = parent_index.map(|parent| plan.nodes[parent].unwrap());
            if following.last().is_some_and(|(parent, _)| *parent == Some(index)) {
                following.pop();
            }
            let before = match following.last_mut() {
                Some((parent, next)) if *parent == parent_index => {
                    let before = *next;
                    *next = id;
                    Some(before)
                }
                _ => {
                    following.push((parent_index, id));
                    None
                }
            };
            let current_parent = self.layout.tree().parent(id).map_err(LayoutError::from)?;
            let current_next = self.layout.tree().next_sibling(id).map_err(LayoutError::from)?;
            if current_parent != parent || current_next != before {
                self.layout.reparent_before(id, parent, before)?;
            }
        }
        let ordered = plan.nodes.into_iter().map(|id| id.unwrap()).collect();
        self.layout_nodes = LayoutNodes::edited(ordered)?;
        self.layout_dirty.retain(|identity| self.by_identity.contains(*identity));
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{El, ItemKey, ItemSource, button, column, div, row, text, uniform_list};

    const LIST: ListId = ListId::new(1);
    #[derive(Clone)]
    struct Page {
        popup: bool,
        broken: bool,
        row_width: f32,
        rows: Vec<(u64, String)>,
    }
    impl Page {
        fn new() -> Self {
            Self { popup: false, broken: false, row_width: 80., rows: (1..=4).map(|id| (id, format!("row {id}"))).collect() }
        }
    }
    impl ItemSource for Page {
        fn len(&self) -> usize { self.rows.len() }
        fn key(&self, index: usize) -> ItemKey { ItemKey::new(self.rows[index].0) }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            self.rows.iter().position(|entry| entry.0 == key.get())
        }
        fn row(&self, index: usize) -> El<'_> {
            row((text(self.rows[index].1.as_str()).w(self.row_width), div().size(4))).h(12)
        }
    }
    impl View for Page {
        fn view(&self) -> El<'_> {
            let mut children = vec![div().name("ordinary").size(8)];
            if self.popup {
                children.push(button("popup").name("popup").w(70).h(10).transform(
                    if self.broken { Affine::scale(0., 1.) } else { Affine::IDENTITY },
                ));
            }
            children.push(uniform_list(LIST, self, 12).w(120).h(72));
            column(children)
        }
    }
    fn window() -> Win<Page> {
        let mut win = Win::recording(Page::new(), WindowOptions { size: [160, 120], ..Default::default() }).unwrap();
        acknowledge(&mut win);
        win
    }
    fn token(win: &Win<Page>) -> PresentationToken { win.with_scene(|_, token| token).unwrap() }
    fn acknowledge(win: &mut Win<Page>) { win.presented(token(win)).unwrap(); }
    fn layout_id(win: &Win<Page>, target: Target) -> NodeId {
        let runtime = win.runtime().unwrap();
        let identity = runtime.resolve(target).unwrap();
        runtime.layout_nodes.required(runtime.by_identity.required(identity))
    }
    fn row_target(win: &Win<Page>, key: u64) -> Target {
        win.list_item(win.list(LIST).unwrap(), ItemKey::new(key)).unwrap()
    }
    fn acknowledged_rows(win: &Win<Page>) -> Vec<SnapshotNode> {
        let mut nodes = win.snapshot().unwrap().nodes;
        for node in &mut nodes { node.target = None; }
        nodes
    }
    fn assert_layout_adjacency<M: View + 'static>(win: &Win<M>) {
        let runtime = win.runtime().unwrap();
        // Include the root forest and leaf buckets, not only parents that
        // happen to receive a moved child. Distinct nested parents must never
        // share a following-sibling anchor.
        for parent in std::iter::once(None).chain((0..runtime.nodes.len()).map(Some)) {
            let expected: Vec<_> = runtime.nodes.iter().enumerate()
                .filter(|(_, node)| node.parent().index() == parent)
                .map(|(index, _)| runtime.layout_nodes.required(index)).collect();
            let handle = parent.map(|index| runtime.layout_nodes.required(index));
            let actual: Vec<_> = runtime.layout.tree().children(handle).unwrap().collect();
            assert_eq!(actual, expected, "exact children for logical parent {parent:?}");
        }
    }
    fn assert_cold(win: &mut Win<Page>) {
        assert_layout_adjacency(win);
        let mut cold = Win::with_size(win.root().unwrap().clone(), 160, 120).unwrap();
        let normalize = |win: &Win<Page>| {
            let mut nodes = acknowledged_rows(win);
            // Fresh construction has fresh logical identities. Authority is
            // tested separately; exact geometry/order/text are the cold oracle.
            for node in &mut nodes { node.identity = 0; }
            nodes
        };
        assert_eq!(normalize(win), normalize(&cold));
        let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        cold.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }

    #[test]
    fn middle_popup_preserves_keyed_layout_handles_without_reviving_unkeyed_targets() {
        let mut win = window();
        let pane = win.list(LIST).unwrap();
        let row = row_target(&win, 2);
        let pane_layout = layout_id(&win, pane);
        let row_layout = layout_id(&win, row);
        let ordinary = win.query().name("ordinary").one().unwrap();
        let previous = acknowledged_rows(&win);
        let computes = win.runtime().unwrap().layout.stats().computes;
        win.update(|model| model.popup = true).unwrap();
        assert_eq!(acknowledged_rows(&win), previous);
        assert_eq!(layout_id(&win, pane), pane_layout);
        assert_eq!(layout_id(&win, row), row_layout);
        assert_eq!(win.runtime().unwrap().layout.stats().computes, computes + 1);
        assert!(win.runtime().unwrap().resolve(ordinary).is_err());
        acknowledge(&mut win);
        assert_cold(&mut win);
        let popup = win.query().name("popup").one().unwrap();
        // Text slots shifted when popup text was inserted. Invalidate actual
        // content with equal style so an incorrect inverse map cannot hide
        // behind a warm cached geometry answer.
        win.update(|model| model.rows[2].1 = "changed exact content".into()).unwrap();
        acknowledge(&mut win);
        assert_cold(&mut win);
        win.update(|model| model.popup = false).unwrap();
        assert_eq!(layout_id(&win, pane), pane_layout);
        assert_eq!(layout_id(&win, row), row_layout);
        assert!(win.runtime().unwrap().resolve(popup).is_err());
        acknowledge(&mut win);
        assert_cold(&mut win);
    }

    #[test]
    fn failed_newer_topology_candidate_preserves_old_complete_ack_and_full_repair() {
        let mut win = window();
        win.update(|model| model.popup = true).unwrap();
        let eligible = token(&win);
        assert!(win.update(|model| model.broken = true).is_err());
        assert_eq!(token(&win), eligible);
        let older = win.presented(eligible).unwrap();
        assert!(older.presentation_epoch < older.source_epoch);
        assert!(win.runtime().unwrap().rebuild_layout);
        win.update(|model| model.broken = false).unwrap();
        acknowledge(&mut win);
        assert_cold(&mut win);
        assert!(!win.runtime().unwrap().rebuild_layout);
    }

    #[test]
    fn inspector_caption_invalidations_follow_the_current_map_after_middle_insertion() {
        fn inspected() -> Win<Page> {
            let mut win = Win::recording_with_inspector(
                Page::new(),
                WindowOptions { size: [720, 640], ..Default::default() },
            ).unwrap();
            acknowledge(&mut win);
            let selected = win.query().text("row 2").one().unwrap();
            win.inspector_select(selected).unwrap();
            acknowledge(&mut win);
            win
        }
        fn layouts(win: &Win<Page>) -> Vec<gpui_reactivity_core::layout::Layout> {
            let runtime = win.runtime().unwrap();
            (0..runtime.nodes.len()).map(|index| {
                runtime.layout.layout(runtime.layout_nodes.required(index)).unwrap()
            }).collect()
        }

        // Identical logical histories keep inspector identities and printed
        // epochs comparable. Only the oracle discards all layout caches.
        let mut retained = inspected();
        let mut rebuilt = inspected();
        let selected = retained.inspector_selected().unwrap().unwrap();
        let old_handle = layout_id(&retained, selected);
        let old_oracle_handle = layout_id(&rebuilt, rebuilt.inspector_selected().unwrap().unwrap());
        let old_rows = acknowledged_rows(&retained);
        rebuilt.runtime_mut().unwrap().runtime.rebuild_layout = true;
        for win in [&mut retained, &mut rebuilt] {
            win.update(|model| {
                model.popup = true;
                model.row_width = 72.;
            }).unwrap();
        }
        assert_eq!(acknowledged_rows(&retained), old_rows);
        assert_eq!(layout_id(&retained, selected), old_handle);
        assert_ne!(layout_id(&rebuilt, rebuilt.inspector_selected().unwrap().unwrap()), old_oracle_handle);
        assert_eq!(layouts(&retained), layouts(&rebuilt));
        acknowledge(&mut retained);
        acknowledge(&mut rebuilt);
        assert_eq!(acknowledged_rows(&retained), acknowledged_rows(&rebuilt));
        assert!(acknowledged_rows(&retained).iter().any(|row| {
            row.text.as_deref().is_some_and(|text| text.starts_with("> width:") && text.contains("72.0"))
        }));
        let pixels = retained.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        rebuilt.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
        // A subsequent changed constraint also consumes late layout/bounds
        // caption dirties without routing through the predecessor preorder.
        rebuilt.runtime_mut().unwrap().runtime.rebuild_layout = true;
        for win in [&mut retained, &mut rebuilt] {
            win.update(|model| model.row_width = 64.).unwrap();
        }
        assert_eq!(layouts(&retained), layouts(&rebuilt));
        acknowledge(&mut retained);
        acknowledge(&mut rebuilt);
        assert_eq!(acknowledged_rows(&retained), acknowledged_rows(&rebuilt));
        let pixels = retained.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        rebuilt.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }

    #[test]
    fn virtual_membership_and_keyed_reorder_preserve_only_actual_survivors() {
        let mut model = Page::new();
        model.rows = (1..=32).map(|id| (id, format!("row {id}"))).collect();
        let mut retained = Win::recording(
            model.clone(), WindowOptions { size: [160, 120], ..Default::default() },
        ).unwrap();
        let mut rebuilt = Win::recording(
            model, WindowOptions { size: [160, 120], ..Default::default() },
        ).unwrap();
        acknowledge(&mut retained);
        acknowledge(&mut rebuilt);
        let pane = retained.list(LIST).unwrap();
        let pane_handle = layout_id(&retained, pane);
        let old_first = row_target(&retained, 1);
        let old_first_handle = layout_id(&retained, old_first);
        let overlap = row_target(&retained, 4);
        let overlap_handle = layout_id(&retained, overlap);

        fn assert_pair(retained: &mut Win<Page>, rebuilt: &mut Win<Page>) {
            assert_layout_adjacency(retained);
            assert_layout_adjacency(rebuilt);
            {
                let actual = retained.runtime().unwrap();
                let expected = rebuilt.runtime().unwrap();
                assert_eq!(actual.nodes.len(), expected.nodes.len());
                for index in 0..actual.nodes.len() {
                    assert_eq!(actual.nodes[index].identity(), expected.nodes[index].identity());
                    assert_eq!(
                        actual.layout.layout(actual.layout_nodes.required(index)).unwrap(),
                        expected.layout.layout(expected.layout_nodes.required(index)).unwrap(),
                    );
                }
            }
            acknowledge(retained);
            acknowledge(rebuilt);
            assert_eq!(acknowledged_rows(retained), acknowledged_rows(rebuilt));
            assert_eq!(
                retained.list_state(retained.list(LIST).unwrap()).unwrap(),
                rebuilt.list_state(rebuilt.list(LIST).unwrap()).unwrap(),
            );
            let pixels = retained.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
            rebuilt.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
        }

        rebuilt.runtime_mut().unwrap().runtime.rebuild_layout = true;
        for win in [&mut retained, &mut rebuilt] {
            let list = win.list(LIST).unwrap();
            win.scroll_to_index(list, 2).unwrap();
        }
        assert_eq!(layout_id(&retained, pane), pane_handle);
        assert_eq!(layout_id(&retained, overlap), overlap_handle);
        assert!(retained.runtime().unwrap().resolve(old_first).is_err());
        assert_pair(&mut retained, &mut rebuilt);
        assert!(retained.list_item(pane, ItemKey::new(1)).is_err());
        let sixth = row_target(&retained, 6);
        let sixth_handle = layout_id(&retained, sixth);

        // Keep the scroll anchor fixed, but reorder two genuine surviving
        // keyed rows. Their descendants keep identities and measurement routes.
        rebuilt.runtime_mut().unwrap().runtime.rebuild_layout = true;
        for win in [&mut retained, &mut rebuilt] {
            win.update(|model| model.rows.swap(3, 5)).unwrap();
        }
        assert_eq!(layout_id(&retained, overlap), overlap_handle);
        assert_eq!(layout_id(&retained, sixth), sixth_handle);
        assert_pair(&mut retained, &mut rebuilt);

        rebuilt.runtime_mut().unwrap().runtime.rebuild_layout = true;
        for win in [&mut retained, &mut rebuilt] {
            let list = win.list(LIST).unwrap();
            win.scroll_to_index(list, 0).unwrap();
        }
        assert_pair(&mut retained, &mut rebuilt);
        assert_eq!(layout_id(&retained, pane), pane_handle);
        let new_first = row_target(&retained, 1);
        assert_ne!(new_first, old_first);
        assert_ne!(layout_id(&retained, new_first), old_first_handle);
        assert!(retained.runtime().unwrap().resolve(old_first).is_err());
    }

    #[test]
    fn dropped_turn_then_inspector_selection_resolves_clean_caption_ids_after_topology() {
        fn unselected() -> Win<Page> {
            let mut win = Win::recording_with_inspector(
                Page::new(),
                WindowOptions { size: [720, 640], ..Default::default() },
            ).unwrap();
            acknowledge(&mut win);
            assert_eq!(win.inspector_selected().unwrap(), None);
            win
        }
        let mut retained = unselected();
        let mut rebuilt = unselected();
        let selected = retained.query().text("row 2").one().unwrap();
        let oracle_selected = rebuilt.query().text("row 2").one().unwrap();
        let old_handle = layout_id(&retained, selected);
        let old_token = token(&retained);
        let old_rows = acknowledged_rows(&retained);
        for win in [&mut retained, &mut rebuilt] {
            let mut turn = win.edit_turn().unwrap();
            turn.update(|model| {
                model.popup = true;
                model.row_width = 72.;
            }).unwrap();
            // Deliberately retain only the accepted logical prefix. No C was
            // prepared, and unselected captions still contain initial labels.
            drop(turn);
            let runtime = win.runtime().unwrap();
            assert!(runtime.layout_edits.is_some());
            assert!(runtime.topology_changed);
            assert!(runtime.layout_nodes.len() < runtime.nodes.len());
            let width_caption = runtime.nodes.iter().find(|node| {
                node.text_slot().get(&runtime.texts)
                    .is_some_and(|site| site.value.as_ref() == "width")
            }).expect("unchanged initial inspector width label");
            assert!(!runtime.layout_dirty.contains(&width_caption.identity()));
        }
        assert_eq!(token(&retained), old_token);
        assert_eq!(acknowledged_rows(&retained), old_rows);
        rebuilt.runtime_mut().unwrap().runtime.rebuild_layout = true;
        // This public operation is allowed on a surviving logical target; it
        // does not require current P. New captions were not dirtied by describe.
        retained.inspector_select(selected).unwrap();
        rebuilt.inspector_select(oracle_selected).unwrap();
        assert_eq!(layout_id(&retained, selected), old_handle);
        {
            let actual = retained.runtime().unwrap();
            let expected = rebuilt.runtime().unwrap();
            assert_eq!(actual.nodes.len(), expected.nodes.len());
            for index in 0..actual.nodes.len() {
                assert_eq!(actual.nodes[index].identity(), expected.nodes[index].identity());
                assert_eq!(
                    actual.layout.layout(actual.layout_nodes.required(index)).unwrap(),
                    expected.layout.layout(expected.layout_nodes.required(index)).unwrap(),
                );
            }
        }
        assert_eq!(acknowledged_rows(&retained), old_rows);
        acknowledge(&mut retained);
        acknowledge(&mut rebuilt);
        assert_eq!(acknowledged_rows(&retained), acknowledged_rows(&rebuilt));
        let pixels = retained.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        rebuilt.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }

    #[test]
    fn second_unprepared_description_discards_plan_and_rebuilds_from_final_logical_state() {
        let mut win = window();
        let row = row_target(&win, 2);
        let old_handle = layout_id(&win, row);
        // Keep a genuinely eligible unacknowledged C, distinct from old P.
        win.update(|model| model.row_width = 76.).unwrap();
        let eligible = token(&win);
        let previous = acknowledged_rows(&win);
        let (descriptions, computes) = {
            let rt = win.runtime().unwrap();
            (rt.counters.descriptions, rt.layout.stats().computes)
        };
        {
            let mut turn = win.edit_turn().unwrap();
            turn.update(|model| model.popup = true).unwrap();
            drop(turn);
        }
        {
            let rt = win.runtime().unwrap();
            assert!(rt.layout_edits.is_some());
            assert!(rt.topology_changed);
            assert!(rt.layout.tree().contains(old_handle), "preparation has not edited old scratch");
        }
        {
            let mut turn = win.edit_turn().unwrap();
            turn.update(|model| {
                model.rows.rotate_left(1);
                model.rows[0].1 = "final description only".into();
                model.row_width = 68.;
            }).unwrap();
            drop(turn);
        }
        {
            let rt = win.runtime().unwrap();
            assert!(rt.layout_edits.is_none(), "never replay a predecessor topology plan");
            assert!(rt.topology_changed);
            assert_eq!(rt.counters.descriptions, descriptions + 2);
            assert_eq!(rt.layout.stats().computes, computes);
        }
        assert_eq!(token(&win), eligible);
        assert_eq!(acknowledged_rows(&win), previous);
        let ack = win.presented(eligible).unwrap();
        assert!(ack.presentation_epoch < ack.source_epoch);
        win.settle().unwrap();
        // Full reconstruction uses a new arena authority, not a partially
        // replayed stale plan or the earlier eligible candidate's layout.
        assert_ne!(layout_id(&win, row), old_handle);
        assert!(win.runtime().unwrap().layout_edits.is_none());
        acknowledge(&mut win);
        assert_cold(&mut win);

    #[test]
    fn repeated_popup_and_nested_keyed_reorders_keep_exact_parent_buckets() {
        let mut win = window();
        let pane = win.list(LIST).unwrap();
        let pane_handle = layout_id(&win, pane);
        let handles: Vec<_> = (1..=4).map(|key| {
            let target = row_target(&win, key);
            (target, layout_id(&win, target))
        }).collect();
        for step in 0..8 {
            win.update(|model| {
                model.popup = step % 2 == 0;
                model.rows.rotate_left(1);
            }).unwrap();
            assert_eq!(layout_id(&win, pane), pane_handle);
            for &(target, handle) in &handles {
                assert_eq!(layout_id(&win, target), handle);
            }
            assert_layout_adjacency(&win);
            acknowledge(&mut win);
            assert_cold(&mut win);
        }
    }

    #[test]
    fn deep_comb_reorder_restores_each_active_ancestor_sibling_frontier() {
        #[derive(Clone)]
        struct Comb(Page);
        impl ItemSource for Comb {
            fn len(&self) -> usize { self.0.len() }
            fn key(&self, index: usize) -> ItemKey { self.0.key(index) }
            fn index_of(&self, key: ItemKey) -> Option<usize> { self.0.index_of(key) }
            fn row(&self, index: usize) -> El<'_> {
                let mut branch = text(self.0.rows[index].1.as_str()).w(50);
                for _ in 0..12 {
                    // Reverse preorder encounters this right sibling before
                    // descending the left branch, keeping all depths live.
                    branch = column((branch, div().size(1)));
                }
                branch
            }
        }
        impl View for Comb {
            fn view(&self) -> El<'_> { uniform_list(LIST, self, 12).w(120).h(72) }
        }
        let mut win = Win::recording(
            Comb(Page::new()), WindowOptions { size: [160, 120], ..Default::default() },
        ).unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        for _ in 0..4 {
            win.update(|model| model.0.rows.rotate_left(1)).unwrap();
            assert_layout_adjacency(&win);
            let token = win.with_scene(|_, token| token).unwrap();
            win.presented(token).unwrap();
            let mut cold = Win::with_size(win.root().unwrap().clone(), 160, 120).unwrap();
            let normalize = |win: &Win<Comb>| {
                let mut nodes = win.snapshot().unwrap().nodes;
                for node in &mut nodes { node.identity = 0; node.target = None; }
                nodes
            };
            assert_eq!(normalize(&win), normalize(&cold));
            let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
            cold.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
        }
    }

    #[test]
    fn retained_auto_width_list_refreshes_parent_flow_during_popup_topology_edit() {
        #[derive(Clone)]
        struct FlowPage { page: Page, horizontal: bool }
        impl View for FlowPage {
            fn view(&self) -> El<'_> {
                let mut children = vec![div().size(8)];
                if self.page.popup { children.push(button("popup").size(10)); }
                children.push(uniform_list(LIST, &self.page, 12).h(72));
                column(children).w(140).h(100).flow(
                    if self.horizontal { Flow::Row } else { Flow::Column },
                )
            }
        }
        let model = FlowPage { page: Page::new(), horizontal: false };
        let options = WindowOptions { size: [160, 120], ..Default::default() };
        let mut retained = Win::recording(model.clone(), options).unwrap();
        let mut rebuilt = Win::recording(model, options).unwrap();
        for win in [&mut retained, &mut rebuilt] {
            let token = win.with_scene(|_, token| token).unwrap();
            win.presented(token).unwrap();
        }
        let pane = retained.list(LIST).unwrap();
        let id = {
            let rt = retained.runtime().unwrap();
            rt.layout_nodes.required(rt.by_identity.required(rt.resolve(pane).unwrap()))
        };
        for horizontal in [true, false, true, false] {
            rebuilt.runtime_mut().unwrap().runtime.rebuild_layout = true;
            for win in [&mut retained, &mut rebuilt] {
                win.update(|model| {
                    model.horizontal = horizontal;
                    model.page.popup = horizontal;
                }).unwrap();
            }
            let actual = retained.runtime().unwrap();
            let expected = rebuilt.runtime().unwrap();
            let index = actual.by_identity.required(actual.resolve(pane).unwrap());
            assert_eq!(actual.layout_nodes.required(index), id);
            let oracle = expected.layout_nodes.required(index);
            // Equal style or cached geometry is not enough: this exact solver
            // input must change despite the list's unchanged declaration.
            let style = actual.layout.style(id).unwrap();
            assert_eq!(style, expected.layout.style(oracle).unwrap());
            assert_eq!(style.flex_grow, if horizontal { 1.0 } else { 0.0 });
            assert_layout_adjacency(&retained);
            for win in [&mut retained, &mut rebuilt] {
                let token = win.with_scene(|_, token| token).unwrap();
                win.presented(token).unwrap();
            }
            let mut actual = retained.snapshot().unwrap();
            let mut expected = rebuilt.snapshot().unwrap();
            for node in actual.nodes.iter_mut().chain(expected.nodes.iter_mut()) {
                node.target = None;
            }
            assert_eq!(actual, expected);
            let pixels = retained.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
            rebuilt.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
        }
    }

    #[test]
    fn retained_scope_rejection_retires_consumed_same_kind_layout_handle() {
        #[derive(Clone)]
        struct Child;
        impl View for Child {
            fn view(&self) -> El<'_> { button("scoped").w(40).h(12) }
        }
        #[derive(Clone)]
        struct ScopePage { first: Child, second: Child, switched: bool }
        impl ScopePage {
            const FIRST: crate::Component<Self, Child> = crate::Component::new(
                crate::FieldId::new(1), "first", |p| &p.first, |p| &mut p.first,
            );
            const SECOND: crate::Component<Self, Child> = crate::Component::new(
                crate::FieldId::new(2), "second", |p| &p.second, |p| &mut p.second,
            );
        }
        impl ItemSource for ScopePage {
            fn len(&self) -> usize { 3 }
            fn key(&self, index: usize) -> ItemKey { ItemKey::new(index as u64 + 1) }
            fn index_of(&self, key: ItemKey) -> Option<usize> {
                (1..=3).contains(&key.get()).then(|| key.get() as usize - 1)
            }
            fn row(&self, _index: usize) -> El<'_> { text("retained row").h(12) }
        }
        impl View for ScopePage {
            fn sources() -> crate::Sources<Self> {
                crate::Sources::new().component(Self::FIRST).component(Self::SECOND)
            }
            fn view(&self) -> El<'_> {
                column((
                    if self.switched { Self::SECOND.view(self) } else { Self::FIRST.view(self) },
                    uniform_list(LIST, self, 12).w(120).h(48),
                ))
            }
        }
        fn acknowledge_scope(win: &mut Win<ScopePage>) {
            let token = win.with_scene(|_, token| token).unwrap();
            win.presented(token).unwrap();
        }
        fn layouts_scope(win: &Win<ScopePage>) -> Vec<gpui_reactivity_core::layout::Layout> {
            let runtime = win.runtime().unwrap();
            (0..runtime.nodes.len()).map(|index| {
                runtime.layout.layout(runtime.layout_nodes.required(index)).unwrap()
            }).collect()
        }
        let model = ScopePage { first: Child, second: Child, switched: false };
        let options = WindowOptions { size: [160, 120], ..Default::default() };
        let mut retained = Win::recording(model.clone(), options).unwrap();
        let mut rebuilt = Win::recording(model, WindowOptions {
            size: [160, 120], ..Default::default()
        }).unwrap();
        acknowledge_scope(&mut retained);
        acknowledge_scope(&mut rebuilt);
        let old_target = retained.query().text("scoped").one().unwrap();
        let old_handle = {
            let runtime = retained.runtime().unwrap();
            runtime.layout_nodes.required(runtime.by_identity.required(runtime.resolve(old_target).unwrap()))
        };
        let pane = retained.list(LIST).unwrap();
        let pane_handle = {
            let runtime = retained.runtime().unwrap();
            runtime.layout_nodes.required(runtime.by_identity.required(runtime.resolve(pane).unwrap()))
        };
        rebuilt.runtime_mut().unwrap().runtime.rebuild_layout = true;
        for win in [&mut retained, &mut rebuilt] { win.update(|model| model.switched = true).unwrap(); }
        {
            let runtime = retained.runtime().unwrap();
            assert!(runtime.resolve(old_target).is_err());
            assert!(!runtime.layout.tree().contains(old_handle));
            assert_eq!(runtime.layout.tree().len(), runtime.nodes.len());
            assert_eq!(runtime.layout_nodes.required(runtime.by_identity.required(runtime.resolve(pane).unwrap())), pane_handle);
            for parent in std::iter::once(None).chain((0..runtime.nodes.len()).map(Some)) {
                let expected: Vec<_> = runtime.nodes.iter().enumerate()
                    .filter(|(_, node)| node.parent().index() == parent)
                    .map(|(index, _)| runtime.layout_nodes.required(index)).collect();
                let actual: Vec<_> = runtime.layout.tree().children(
                    parent.map(|index| runtime.layout_nodes.required(index)),
                ).unwrap().collect();
                assert_eq!(actual, expected);
            }
        }
        assert_eq!(layouts_scope(&retained), layouts_scope(&rebuilt));
        acknowledge_scope(&mut retained);
        acknowledge_scope(&mut rebuilt);
        {
            let runtime = retained.runtime().unwrap();
            let new_target = retained.query().text("scoped").one().unwrap();
            assert_ne!(new_target, old_target);
            let new_handle = runtime.layout_nodes.required(runtime.by_identity.required(runtime.resolve(new_target).unwrap()));
            assert_ne!(new_handle, old_handle);
        }
        let mut actual = retained.snapshot().unwrap().nodes;
        let mut expected = rebuilt.snapshot().unwrap().nodes;
        for node in actual.iter_mut().chain(expected.iter_mut()) { node.target = None; }
        assert_eq!(actual, expected);
        let pixels = retained.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        rebuilt.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }

    #[test]
    fn tail_removal_changes_topology_even_when_every_remaining_identity_keeps_its_ordinal() {
        #[derive(Clone)]
        struct Tail(Page);
        impl View for Tail {
            fn view(&self) -> El<'_> {
                let mut children = vec![uniform_list(LIST, &self.0, 12).w(120).h(72)];
                if self.0.popup { children.push(button("tail").size(10)); }
                column(children)
            }
        }
        let mut model = Page::new();
        model.popup = true;
        let mut win = Win::recording(
            Tail(model), WindowOptions { size: [160, 120], ..Default::default() },
        ).unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        let tail = win.query().text("tail").one().unwrap();
        let (old, removed) = {
            let rt = win.runtime().unwrap();
            (
                rt.nodes.iter().map(Node::identity).collect::<Vec<_>>(),
                rt.layout_nodes.required(rt.by_identity.required(rt.resolve(tail).unwrap())),
            )
        };
        win.update(|model| model.0.popup = false).unwrap();
        let rt = win.runtime().unwrap();
        let current: Vec<_> = rt.nodes.iter().map(Node::identity).collect();
        assert!(current.len() < old.len());
        assert_eq!(current, old[..current.len()]);
        assert!(!rt.layout.tree().contains(removed));
        assert_eq!(rt.layout.tree().len(), rt.nodes.len());
        assert_layout_adjacency(&win);
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        let mut cold = Win::with_size(win.root().unwrap().clone(), 160, 120).unwrap();
        let normalize = |win: &Win<Tail>| {
            let mut nodes = win.snapshot().unwrap().nodes;
            for node in &mut nodes { node.identity = 0; node.target = None; }
            nodes
        };
        assert_eq!(normalize(&win), normalize(&cold));
        let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        cold.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }

    #[test]
    fn retained_topology_storage_ledger_prices_headers_and_whole_popup_turns() {
        eprintln!(
            "RETAINED_TOPOLOGY_HEADERS runtime={} map={} edited={} plan={} node_id={}",
            size_of::<Runtime<()>>(), size_of::<LayoutNodes>(),
            size_of::<Edited>(), size_of::<EditPlan>(), size_of::<NodeId>(),
        );
        let mut win = window();
        for popup in [true, false, true, false] {
            let cost = allocation_counter::measure(|| {
                win.update(|model| model.popup = popup).unwrap();
            });
            let runtime = win.runtime().unwrap();
            let (ordered_capacity, inverse_entries, inverse_capacity) = match &runtime.layout_nodes {
                LayoutNodes::Fresh(_) => (0, 0, 0),
                LayoutNodes::Edited(map) => (
                    map.ordered.capacity(), map.reverse.len(), map.reverse.capacity(),
                ),
            };
            eprintln!(
                "RETAINED_TOPOLOGY_POPUP open={popup} allocations={} requested={} retained={} peak={} ordered_capacity={ordered_capacity} inverse_entries={inverse_entries} inverse_capacity={inverse_capacity} inverse_entry_bytes={}",
                cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max,
                size_of::<(NodeId, usize)>(),
            );
            // Allocation measurements cover the whole public update, not
            // guessed BTreeMap node sizes or production-allocator CPU timing.
            acknowledge(&mut win);
        }
    }

    #[test]
    fn mixed_generation_inverse_mapping_rejects_stale_and_foreign_capabilities() {
        let mut tree = LayoutTree::new();
        let removed = tree.insert(None, gpui_reactivity_core::NodeKind::Element, cephal::Style::DEFAULT).unwrap();
        let survivor = tree.insert(None, gpui_reactivity_core::NodeKind::Element, cephal::Style::DEFAULT).unwrap();
        tree.remove(removed).unwrap();
        let replacement = tree.insert(None, gpui_reactivity_core::NodeKind::Element, cephal::Style::DEFAULT).unwrap();
        let mut other = LayoutTree::new();
        let foreign = other.insert(None, gpui_reactivity_core::NodeKind::Element, cephal::Style::DEFAULT).unwrap();
        let mapping = LayoutNodes::edited(vec![survivor, replacement]).unwrap();
        assert_eq!(mapping.index_of(survivor), Some(0));
        assert_eq!(mapping.index_of(replacement), Some(1));
        assert_eq!(mapping.index_of(removed), None);
        assert_eq!(mapping.index_of(foreign), None);
        assert!(LayoutNodes::edited(vec![survivor, survivor]).is_err());
        let mut ids = vec![survivor, replacement];
        for _ in 0..65 {
            ids.push(tree.insert(None, gpui_reactivity_core::NodeKind::Element, cephal::Style::DEFAULT).unwrap());
        }
        // Logical order is deliberately unrelated to capability order, across
        // multiple search partitions and mixed recycled-slot generations.
        ids.reverse();
        ids.rotate_left(17);
        let mapping = LayoutNodes::edited(ids.clone()).unwrap();
        for (index, id) in ids.into_iter().enumerate() {
            assert_eq!(mapping.get(index), Some(id));
            assert_eq!(mapping.index_of(id), Some(index));
        }
        assert_eq!(mapping.index_of(removed), None);
        assert_eq!(mapping.index_of(foreign), None);
    }
}
