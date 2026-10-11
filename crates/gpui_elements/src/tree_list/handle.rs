//! Imperative tree operations for application controls, inspectors, and search.

use super::*;

impl<Id: Clone + Eq + Hash + Debug + 'static> TreeListHandle<Id> {
    /// Currently focused stable identity, including a hidden item until focus repair.
    pub fn focused_id(&self, cx: &App) -> Option<Id> {
        self.state
            .borrow()
            .as_ref()?
            .read_with(cx, |state, _| state.selection.focused().cloned())
            .ok()
            .flatten()
    }

    /// Expanded identities, including expansion remembered inside collapsed branches.
    pub fn expanded_ids(&self, cx: &App) -> Vec<Id> {
        self.state
            .borrow()
            .as_ref()
            .and_then(|state| {
                state
                    .read_with(cx, |state, _| {
                        state.tree.expanded_ids().iter().cloned().collect()
                    })
                    .ok()
            })
            .unwrap_or_default()
    }

    /// Expand/collapse a branch while preserving hidden selection and scroll anchoring.
    pub fn set_expanded<M: TreeModel<Id>>(
        &self,
        model: &M,
        id: Id,
        expanded: bool,
        cx: &mut App,
    ) -> bool {
        self.mutate_model(model, cx, |state, cx| {
            if !model.is_branch(&id) {
                return false;
            }
            let changed = state.tree.set_expanded(model, id, expanded);
            if changed {
                repair_hidden_focus(state, model);
                apply_pending_splices(state, cx.background_executor().now(), cx.reduce_motion());
                cx.notify();
            }
            changed
        })
    }

    /// Expand the ancestor chain and scroll an item into view without selecting it.
    /// Returns false for missing identities or malformed parent cycles.
    pub fn reveal<M: TreeModel<Id>>(&self, model: &M, id: Id, cx: &mut App) -> bool {
        self.mutate_model(model, cx, |state, cx| reveal(state, model, &id, cx))
    }

    /// Reveal and focus an item; existing selection is preserved.
    pub fn focus_item<M: TreeModel<Id>>(&self, model: &M, id: Id, cx: &mut App) -> bool {
        let focused = self.mutate_model(model, cx, |state, cx| {
            if !reveal(state, model, &id, cx) {
                return false;
            }
            state.selection.set_focused(Some(id));
            cx.notify();
            true
        });
        if focused {
            self.defer_focus(cx);
        }
        focused
    }

    /// Replace selection with existing model identities in caller order.
    /// Hidden identities remain selected; use `reveal` to bring them into view.
    /// The selection observer also receives programmatic changes.
    pub fn select_ids<M: TreeModel<Id>>(
        &self,
        model: &M,
        ids: impl IntoIterator<Item = Id>,
        cx: &mut App,
    ) {
        let ids: Vec<_> = ids.into_iter().filter(|id| model.contains(id)).collect();
        self.mutate_model(model, cx, |state, cx| {
            state.selection.clear_selection();
            for id in ids {
                state.selection.set_selected(id, true);
            }
            let first = state.selection.selected_ordered().first().cloned();
            state.selection.set_anchor(first.clone());
            state.selection.set_focused(first);
            repair_hidden_focus(state, model);
            cx.notify();
            true
        });
        defer_selection_observer(self.state.borrow().clone(), cx);
    }

    /// Start the built-in rename field for a visible item when renaming is enabled.
    /// Call `reveal` first when the item lives under a collapsed branch.
    pub fn start_rename(&self, id: Id, cx: &mut App) -> bool {
        let weak = self.state.borrow().clone();
        weak.as_ref()
            .and_then(|weak| {
                weak.update(cx, |state, cx| {
                    if !state.rename_enabled || state.tree.visible_index(&id).is_none() {
                        return false;
                    }
                    if state.editing.as_ref() == Some(&id) {
                        return true;
                    }
                    state.edit_generation = state
                        .edit_generation
                        .checked_add(1)
                        .expect("tree edit generation exhausted");
                    clear_editor_focus_registration(state);
                    state.edit_subscription = None;
                    state.rename_error = None;
                    state.selection.set_focused(Some(id.clone()));
                    state.editing = Some(id.clone());
                    state.edit_pointer = None;
                    state.select_name_on_edit = true;
                    state.focus_editor = true;
                    state.list.scroll_to_reveal_item(
                        state.tree.visible_index(&id).expect("visible item checked"),
                    );
                    cx.notify();
                    true
                })
                .ok()
            })
            .unwrap_or(false)
    }

    fn mutate_model<M: TreeModel<Id>>(
        &self,
        model: &M,
        cx: &mut App,
        mutate: impl FnOnce(&mut TreeViewState<Id>, &mut gpui::Context<TreeViewState<Id>>) -> bool,
    ) -> bool {
        let identity = model as *const M as *const () as usize;
        self.state
            .borrow()
            .as_ref()
            .and_then(|weak| {
                weak.update(cx, |state, cx| {
                    assert_eq!(
                        state.model_identity, identity,
                        "tree handle operations must use the attached model instance"
                    );
                    mutate(state, cx)
                })
                .ok()
            })
            .unwrap_or(false)
    }

    fn defer_focus(&self, cx: &mut App) {
        let weak = self.state.borrow().clone();
        cx.defer(move |cx| {
            let Some(weak) = weak else {
                return;
            };
            let focus = weak.read_with(cx, |state, _| state.focus.clone()).ok();
            if let Some(focus) = focus {
                cx.with_window(
                    weak.upgrade().expect("live weak read").entity_id(),
                    |window, cx| window.focus(&focus, cx),
                );
            }
        });
    }
}

fn reveal<Id: Clone + Eq + Hash + Debug + 'static, M: TreeModel<Id>>(
    state: &mut TreeViewState<Id>,
    model: &M,
    id: &Id,
    cx: &mut gpui::Context<TreeViewState<Id>>,
) -> bool {
    if !model.contains(id) {
        return false;
    }
    let mut ancestors = Vec::new();
    let mut visited = std::collections::HashSet::from([id.clone()]);
    let mut cursor = model.parent(id);
    while let Some(parent) = cursor {
        if !model.contains(&parent) || !visited.insert(parent.clone()) {
            return false;
        }
        cursor = model.parent(&parent);
        ancestors.push(parent);
    }
    for ancestor in ancestors.into_iter().rev() {
        state.tree.set_expanded(model, ancestor, true);
    }
    apply_pending_splices(state, cx.background_executor().now(), cx.reduce_motion());
    if let Some(index) = state.tree.visible_index(id) {
        state.list.scroll_to_reveal_item(index);
        cx.notify();
        true
    } else {
        false
    }
}

pub(super) fn defer_selection_observer<Id: Clone + Eq + Hash + Debug + 'static>(
    weak: Option<gpui::WeakEntity<TreeViewState<Id>>>,
    cx: &mut App,
) {
    let Some(weak) = weak else {
        return;
    };
    cx.defer(move |cx| {
        let notification = weak
            .read_with(cx, |state, _| {
                state
                    .selection_observer
                    .clone()
                    .map(|observer| (observer, state.selection.selected_ordered().to_vec()))
            })
            .ok()
            .flatten();
        if let Some((observer, selected)) = notification {
            cx.with_window(
                weak.upgrade().expect("live weak read").entity_id(),
                |window, cx| observer(selected, window, cx),
            );
        }
    });
}
