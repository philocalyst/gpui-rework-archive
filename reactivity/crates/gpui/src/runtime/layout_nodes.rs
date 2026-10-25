//! Fresh-prefix compression is an implementation choice, not a topology rule.
//! Edited trees retain complete capabilities and a checked inverse routing map.
use super::*;

pub(super) enum LayoutNodes {
    Fresh(NodeIdRange),
    Edited(Box<Edited>),
}
pub(super) struct Edited {
    ordered: Vec<NodeId>,
    reverse: BTreeMap<NodeId, usize>,
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
            Self::Edited(map) => map.reverse.get(&id).copied(),
        }
    }
    pub fn push(&mut self, id: NodeId) -> Result<(), gpui_reactivity_core::TreeError> {
        match self {
            Self::Fresh(range) => range.push(id),
            Self::Edited(_) => Err(gpui_reactivity_core::TreeError::InvalidNode),
        }
    }
    fn edited(ordered: Vec<NodeId>) -> Result<Self, LayoutError> {
        let mut reverse = BTreeMap::new();
        for (index, id) in ordered.iter().copied().enumerate() {
            if reverse.insert(id, index).is_some() {
                return Err(gpui_reactivity_core::TreeError::InvalidNode.into());
            }
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
        let mut following = BTreeMap::new();
        for index in (0..plan.nodes.len()).rev() {
            let id = plan.nodes[index].expect("every admitted row now has a handle");
            let parent_index = self.nodes[index].parent().index();
            let parent = parent_index.map(|parent| plan.nodes[parent].unwrap());
            let before = following.get(&parent_index).copied();
            let current_parent = self.layout.tree().parent(id).map_err(LayoutError::from)?;
            let current_next = self.layout.tree().next_sibling(id).map_err(LayoutError::from)?;
            if current_parent != parent || current_next != before {
                self.layout.reparent_before(id, parent, before)?;
            }
            following.insert(parent_index, id);
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
        rows: Vec<(u64, String)>,
    }
    impl Page {
        fn new() -> Self {
            Self { popup: false, broken: false, rows: (1..=4).map(|id| (id, format!("row {id}"))).collect() }
        }
    }
    impl ItemSource for Page {
        fn len(&self) -> usize { self.rows.len() }
        fn key(&self, index: usize) -> ItemKey { ItemKey::new(self.rows[index].0) }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            self.rows.iter().position(|entry| entry.0 == key.get())
        }
        fn row(&self, index: usize) -> El<'_> {
            row((text(self.rows[index].1.as_str()).w(80), div().size(4))).h(12)
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
    fn assert_cold(win: &mut Win<Page>) {
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
    }
}
