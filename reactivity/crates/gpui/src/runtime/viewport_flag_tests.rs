//! Independent parent-walk oracle; production uses no such second scan.
use super::*;
use crate::{El, ItemKey, ItemSource, column, div, text, uniform_list};

struct Page { location: u8 }
impl ItemSource for Page {
    fn len(&self) -> usize { 8 }
    fn key(&self, index: usize) -> ItemKey { ItemKey::new(index as u64 + 1) }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        (1..=8).contains(&key.get()).then(|| key.get() as usize - 1)
    }
    fn row(&self, _index: usize) -> El<'_> { column((text("row"), div().size(1))).h(12) }
}
impl View for Page {
    fn view(&self) -> El<'_> {
        let mut left = vec![div().size(2)];
        let mut right = vec![div().size(3)];
        match self.location {
            1 => left.push(uniform_list(ListId::new(1), self, 12).w(120).h(48)),
            2 => right.push(uniform_list(ListId::new(1), self, 12).w(120).h(48)),
            3 => left.push(column((
                uniform_list(ListId::new(1), self, 12).w(120).h(48), div().size(2),
            )).scroll(crate::Axis::Y).w(120).h(48)),
            _ => (),
        }
        column((column(left), column(right)))
    }
}
fn is_viewport(node: &Node) -> bool {
    matches!(node.kind(), NodeKind::List | NodeKind::ListItem | NodeKind::Scroll)
}
fn verify(win: &Win<Page>) {
    let rt = win.runtime().unwrap();
    for index in 0..rt.nodes.len() {
        let mut ancestor = Some(index);
        let mut expected_ancestor = false;
        while let Some(current) = ancestor {
            expected_ancestor |= is_viewport(&rt.nodes[current]);
            ancestor = rt.nodes[current].parent().index();
        }
        let mut expected_subtree = false;
        for (candidate, node) in rt.nodes.iter().enumerate() {
            if !is_viewport(node) { continue }
            let mut ancestor = Some(candidate);
            while let Some(current) = ancestor {
                if current == index { expected_subtree = true; break }
                ancestor = rt.nodes[current].parent().index();
            }
        }
        assert_eq!(rt.nodes[index].links.viewport_ancestor(), expected_ancestor,
            "exact ancestor membership at {index}, location={}", rt.model.location);
        assert_eq!(rt.nodes[index].links.viewport_subtree(), expected_subtree,
            "exact subtree membership at {index}, location={}", rt.model.location);
    }
}
#[test]
fn viewport_bits_recompute_without_sibling_leaks_across_remove_move_and_remount() {
    let mut win = Win::recording(Page { location: 1 }, WindowOptions {
        size: [180, 140], ..Default::default()
    }).unwrap();
    verify(&win);
    for location in [2, 0, 3, 1, 0, 2, 3] {
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        win.update(|model| model.location = location).unwrap();
        verify(&win);
    }
}
