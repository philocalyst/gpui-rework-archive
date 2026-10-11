use super::animation::{RowMotion, TreeListMotionState, TreeListRowLayout};
use super::{SelectionState, TreeDndState, TreeListState, TreeModel};
use crate::editable_text::{
    EditableTextEvent, EditableTextState, StringStorage, TabBehavior, text_input,
};
use gpui::Refineable;
use gpui::prelude::FluentBuilder;
use gpui::{
    AnyElement, App, AppContext, ElementId, FocusHandle, Focusable, InteractiveElement,
    IntoElement, ListAlignment, ListOffset, ListState, ParentElement, Pixels, RenderOnce,
    SharedString, StatefulInteractiveElement, StyleRefinement, Styled, Window, div, list, px,
};
use handle::defer_selection_observer;
use std::{
    any::Any,
    cell::RefCell,
    collections::HashMap,
    fmt::Debug,
    hash::Hash,
    rc::Rc,
    sync::atomic::{AtomicU64, Ordering},
    time::Duration,
};
use web_time::Instant;

#[path = "handle.rs"]
mod handle;
#[path = "presentation.rs"]
mod presentation;
use presentation::{ExitPaint, StoredPaint, capture_exits, exit_overlay, store_paint};

static NEXT_TREE_IDENTITY: AtomicU64 = AtomicU64::new(1);

/// Data supplied to a custom tree row renderer. The tree widget still owns row
/// identity, selection, focus, accessibility, disclosure and keyboard events;
/// renderers can add arbitrary interactive controls as children.
#[derive(Clone, Debug)]
pub struct TreeRowContext<Id> {
    pub id: Id,
    pub label: SharedString,
    pub depth: usize,
    pub height: Pixels,
    pub expanded: bool,
    pub has_children: bool,
    pub selected: bool,
    pub focused: bool,
    pub editing: bool,
    pub rename_error: Option<SharedString>,
    pub position_in_set: usize,
    pub set_size: usize,
}

/// Construct a virtualized tree list from an indexed tree model and label adapter.
///
/// Use a shared model when event callbacks mutate it, for example
/// `Rc<RefCell<MyModel>>` implementing [`TreeModel`]. A row is rendered only
/// while it is within GPUI's list viewport and overscan range.
pub fn tree_list<Id, M>(
    model: Rc<M>,
    id: impl Into<ElementId>,
    label: impl Fn(&Id) -> SharedString + 'static,
) -> TreeListElement<Id, M>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id> + 'static,
{
    TreeListElement {
        id: id.into(),
        model,
        label: Rc::new(label),
        row_renderer: None,
        initial_expanded: Vec::new(),
        row_height: px(28.),
        row_height_for: None,
        reduced_motion: false,
        on_selection_change: None,
        on_rename: None,
        on_drop: None,
        can_drop: None,
        handle: None,
        style: StyleRefinement::default(),
    }
}

/// Builder for a tree list. Its expansion, selection, keyboard focus and scroll
/// anchor are retained by the element ID across consecutive frames.
#[derive(gpui::IntoElement)]
pub struct TreeListElement<Id: Clone + Eq + Hash + Debug + 'static, M: TreeModel<Id> + 'static> {
    id: ElementId,
    model: Rc<M>,
    label: Rc<dyn Fn(&Id) -> SharedString>,
    row_renderer:
        Option<Rc<dyn Fn(TreeRowContext<Id>, AnyElement, &mut Window, &mut App) -> AnyElement>>,
    initial_expanded: Vec<Id>,
    row_height: Pixels,
    row_height_for: Option<Rc<dyn Fn(&Id) -> Pixels>>,
    reduced_motion: bool,
    on_selection_change: Option<Rc<dyn Fn(Vec<Id>, &mut Window, &mut App)>>,
    on_rename: Option<Rc<dyn Fn(&Id, &str, &mut Window, &mut App) -> Result<(), SharedString>>>,
    on_drop: Option<
        Rc<
            dyn Fn(
                &[Id],
                super::DropPosition<Id>,
                &mut Window,
                &mut App,
            ) -> Result<(), SharedString>,
        >,
    >,
    can_drop: Option<Rc<dyn Fn(&[Id], &super::DropPosition<Id>) -> bool>>,
    handle: Option<TreeListHandle<Id>>,
    style: StyleRefinement,
}

impl<Id, M> TreeListElement<Id, M>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id> + 'static,
{
    /// Set rows that should start expanded. Unknown IDs are ignored.
    pub fn initially_expanded(mut self, ids: impl IntoIterator<Item = Id>) -> Self {
        self.initial_expanded = ids.into_iter().collect();
        self
    }

    /// Set the fixed height of each tree row.
    pub fn row_height(mut self, height: Pixels) -> Self {
        assert!(
            height.as_f32().is_finite() && height.as_f32() > 0.0,
            "tree row height must be finite and positive"
        );
        self.row_height = height;
        self
    }

    /// Supply exact heights for heterogeneous rows without rendering offscreen
    /// delegates. Report `DataChanged` when a row's height changes. Heights must
    /// be finite and positive; `row_height` remains the default density.
    pub fn row_height_for(mut self, height: impl Fn(&Id) -> Pixels + 'static) -> Self {
        self.row_height_for = Some(Rc::new(height));
        self
    }

    /// Skip structural interpolation. The platform's reduced-motion preference
    /// is also respected, independently of this application setting.
    pub fn reduced_motion(mut self, reduced: bool) -> Self {
        self.reduced_motion = reduced;
        self
    }

    /// Customize each row while retaining the tree's row shell. The renderer
    /// receives a label slot that switches to the built-in editor during rename,
    /// plus the live GPUI window/application contexts for interactive children.
    /// A child's listener can call `cx.stop_propagation()` to prevent row select.
    pub fn render_row(
        mut self,
        render: impl Fn(TreeRowContext<Id>, AnyElement, &mut Window, &mut App) -> AnyElement + 'static,
    ) -> Self {
        self.row_renderer = Some(Rc::new(render));
        self
    }

    /// Observe selection after user selection and keyboard navigation.
    pub fn on_selection_change(
        mut self,
        callback: impl Fn(Vec<Id>, &mut Window, &mut App) + 'static,
    ) -> Self {
        self.on_selection_change = Some(Rc::new(callback));
        self
    }

    /// Enable label editing. Return an error message to keep the editor open
    /// and expose the validation error; return `Ok(())` to commit.
    pub fn on_rename(
        mut self,
        callback: impl Fn(&Id, &str, &mut Window, &mut App) -> Result<(), SharedString> + 'static,
    ) -> Self {
        self.on_rename = Some(Rc::new(callback));
        self
    }

    /// Accept a validated drop location. Return an error message to reject the
    /// move and keep its preview available to the caller.
    pub fn on_drop(
        mut self,
        callback: impl Fn(
            &[Id],
            super::DropPosition<Id>,
            &mut Window,
            &mut App,
        ) -> Result<(), SharedString>
        + 'static,
    ) -> Self {
        self.on_drop = Some(Rc::new(callback));
        self
    }

    /// Further validate a resolved drop location before the drop callback runs.
    pub fn can_drop(
        mut self,
        callback: impl Fn(&[Id], &super::DropPosition<Id>) -> bool + 'static,
    ) -> Self {
        self.can_drop = Some(Rc::new(callback));
        self
    }

    /// Attach a reusable handle for querying selection and delivering granular
    /// model changes from outside the tree view.
    pub fn handle(mut self, handle: TreeListHandle<Id>) -> Self {
        self.handle = Some(handle);
        self
    }
}

impl<Id, M> Styled for TreeListElement<Id, M>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id> + 'static,
{
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.style
    }
}

struct TreeViewState<Id> {
    tree: TreeListState<Id>,
    selection: SelectionState<Id>,
    list: ListState,
    focus: FocusHandle,
    editing: Option<Id>,
    rename_error: Option<SharedString>,
    stable_row_ids: HashMap<Id, u64>,
    next_row_id: u64,
    row_height: Pixels,
    row_height_for: Option<Rc<dyn Fn(&Id) -> Pixels>>,
    reduced_motion: bool,
    rename_enabled: bool,
    edit_pointer: Option<gpui::Point<Pixels>>,
    select_name_on_edit: bool,
    paint_cache: HashMap<Id, StoredPaint>,
    exit_rows: HashMap<Id, ExitPaint>,
    capture_scale: Option<f32>,
    last_render_scroll: Option<ListOffset>,
    paint_generation: u64,
    selection_observer: Option<Rc<dyn Fn(Vec<Id>, &mut Window, &mut App)>>,
    motion: TreeListMotionState<Id>,
    motion_epoch: Instant,
    dnd: TreeDndState<Id>,
    tree_identity: u64,
    edit_generation: u64,
    focus_editor: bool,
    edit_subscription: Option<gpui::Subscription>,
    edit_focus: Option<FocusHandle>,
    restore_tree_focus_if_editor_owned: bool,
    editor_focus_registered_generation: Option<u64>,
    model_identity: usize,
    model_revision: u64,
    model_lifetime: Option<Rc<dyn Any>>,
}

impl<Id: Clone + Eq + Hash + Debug + 'static> TreeViewState<Id> {
    fn new(cx: &mut gpui::Context<Self>) -> Self {
        Self {
            tree: TreeListState::new(),
            selection: SelectionState::new(),
            list: ListState::new(0, ListAlignment::Top, px(100.)),
            focus: cx.focus_handle(),
            editing: None,
            rename_error: None,
            stable_row_ids: HashMap::new(),
            next_row_id: 0,
            row_height: px(28.),
            row_height_for: None,
            reduced_motion: false,
            rename_enabled: false,
            edit_pointer: None,
            select_name_on_edit: false,
            paint_cache: HashMap::new(),
            exit_rows: HashMap::new(),
            capture_scale: None,
            last_render_scroll: None,
            paint_generation: 0,
            selection_observer: None,
            motion: TreeListMotionState::default(),
            motion_epoch: cx.background_executor().now(),
            dnd: TreeDndState::default(),
            tree_identity: NEXT_TREE_IDENTITY.fetch_add(1, Ordering::Relaxed),
            edit_generation: 0,
            focus_editor: false,
            edit_subscription: None,
            edit_focus: None,
            restore_tree_focus_if_editor_owned: false,
            editor_focus_registered_generation: None,
            model_identity: 0,
            model_revision: 0,
            model_lifetime: None,
        }
    }
}

impl<Id> TreeViewState<Id> {
    fn motion_time(&self, now: Instant) -> Duration {
        now.duration_since(self.motion_epoch)
    }
}

impl<Id: 'static> Focusable for TreeViewState<Id> {
    fn focus_handle(&self, _: &App) -> FocusHandle {
        self.focus.clone()
    }
}

/// A handle to tree state that remains usable by the owning view. Attach it
/// with [`TreeListElement::handle`], then call `refresh` after changing the
/// backing model. Structural changes are spliced into GPUI's list state to
/// preserve the current scroll anchor.
#[derive(Clone)]
pub struct TreeListHandle<Id> {
    state: Rc<RefCell<Option<gpui::WeakEntity<TreeViewState<Id>>>>>,
}

impl<Id> Default for TreeListHandle<Id> {
    fn default() -> Self {
        Self {
            state: Rc::new(RefCell::new(None)),
        }
    }
}

impl<Id: Clone + Eq + Hash + Debug + 'static> TreeListHandle<Id> {
    /// Apply a granular structural/content change after the model mutation.
    pub fn refresh<M: TreeModel<Id>>(
        &self,
        model: &M,
        change: super::TreeChange<Id>,
        cx: &mut App,
    ) {
        let model_identity = model as *const M as *const () as usize;
        let state = self.state.borrow().clone();
        if let Some(state) = state {
            let before = state
                .read_with(cx, |state, _| state.selection.selected_ordered().to_vec())
                .ok();
            let _ = state.update(cx, |state, cx| {
                assert_eq!(state.model_identity, model_identity, "TreeListHandle::refresh must receive the same model instance used by this tree_list");
                if let super::TreeChange::DataChanged { id } = &change {
                    if let Some(index) = state.tree.visible_index(id) {
                        state.list.set_item_height(index, height_for(state, id));
                        state.list.remeasure_items(index..index + 1);
                        cx.notify();
                    }
                    return;
                }
                state.model_revision = state.model_revision.wrapping_add(1);
                state.dnd.clear();
                let old_scroll = state.list.logical_scroll_top();
                let old_anchor = state.tree.visible_row(old_scroll.item_ix).map(|row| row.id.clone());
                let old_focus_index = state.selection.focused().and_then(|id| state.tree.visible_index(id));
                let change_for_selection = change.clone();
                if matches!(change_for_selection, super::TreeChange::Reset) {
                    // Reset means the caller replaced the logical contents. Clear
                    // identity-associated UI state even if IDs were reused.
                    state.tree = TreeListState::new();
                    state.selection.clear();
                    state.stable_row_ids.clear();
                    state.paint_cache.clear();
                    state.exit_rows.clear();
                    state.restore_tree_focus_if_editor_owned |= state.editing.is_some();
                    state.editing = None;
                    state.rename_error = None;
                    state.edit_subscription = None;
                    state.focus_editor = false;
                    state.editor_focus_registered_generation = None;
                    state.dnd.clear();
                    state.motion.capture_layout(&[]);
                    state.edit_generation = state.edit_generation.checked_add(1).expect("tree edit generation exhausted");
                    state.tree.visible_rows(model);
                    let _ = state.tree.take_projection_changes();
                    reset_list_geometry(state);
                } else {
                    if state.editing.as_ref().is_some_and(|id| !model.contains(id)) {
                        state.restore_tree_focus_if_editor_owned = true;
                        state.editing = None;
                        state.rename_error = None;
                        state.edit_subscription = None;
                        state.focus_editor = false;
                        state.editor_focus_registered_generation = None;
                        state.dnd.clear();
                        state.edit_generation = state.edit_generation.checked_add(1).expect("tree edit generation exhausted");
                    }
                    state.tree.refresh(model, change);
                    state.selection.refresh(model, &change_for_selection);
                    state.stable_row_ids.retain(|id, _| model.contains(id));
                    repair_hidden_focus(state, model);
                    apply_pending_splices(state, cx.background_executor().now(), cx.reduce_motion());
                    if state.selection.focused().is_none() && state.tree.visible_len() > 0 {
                        let index = old_focus_index.unwrap_or(0).min(state.tree.visible_len() - 1);
                        if let Some(id) = state.tree.visible_row(index).map(|row| row.id.clone()) {
                            state.selection.set_focused(Some(id));
                        }
                    }
                }
                if !matches!(change_for_selection, super::TreeChange::Reset) {
                    if let Some(anchor) = old_anchor {
                        // The list's projection splice already relocates its
                        // anchor if this row was removed. Reapply only when the
                        // stable row itself survived; never reuse a stale index.
                        if let Some(index) = state.tree.visible_index(&anchor) {
                            state.list.scroll_to(ListOffset { item_ix: index, offset_in_item: old_scroll.offset_in_item });
                        }
                    }
                }
                cx.notify();
            });
            let after = state
                .read_with(cx, |state, _| state.selection.selected_ordered().to_vec())
                .ok();
            if before != after {
                defer_selection_observer(Some(state), cx);
            }
        }
    }

    /// Return selected IDs in selection-add order, including hidden selections.
    pub fn selected_ids(&self, cx: &App) -> Vec<Id> {
        self.state
            .borrow()
            .as_ref()
            .and_then(|state| {
                state
                    .read_with(cx, |state, _| state.selection.selected_ordered().to_vec())
                    .ok()
            })
            .unwrap_or_default()
    }
}

impl<Id, M> RenderOnce for TreeListElement<Id, M>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id> + 'static,
{
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        let root_style = self.style.clone();
        let model = self.model.clone();
        let initial_expanded = self.initial_expanded.clone();
        let state = window.use_keyed_state(self.id.clone(), cx, |_, cx| {
            let mut state = TreeViewState::new(cx);
            state.row_height = self.row_height;
            state.row_height_for = self.row_height_for.clone();
            state.reduced_motion = self.reduced_motion;
            state.model_identity = Rc::as_ptr(&model) as *const () as usize;
            state.model_lifetime = Some(model.clone());
            state
                .tree
                .set_expanded_ids(model.as_ref(), initial_expanded.clone());
            state.tree.visible_rows(model.as_ref());
            let _ = state.tree.take_projection_changes();
            reset_list_geometry(&state);
            state
        });

        if let Some(handle) = &self.handle {
            let next = state.downgrade();
            let mut attached = handle.state.borrow_mut();
            if let Some(existing) = attached.as_ref().and_then(gpui::WeakEntity::upgrade) {
                assert_eq!(
                    existing.entity_id(),
                    state.entity_id(),
                    "a TreeListHandle can be attached to only one live tree_list; use a separate handle per widget",
                );
            }
            *attached = Some(next);
        }
        let model_identity = Rc::as_ptr(&model) as *const () as usize;
        let capture_scale = window.scale_factor();
        let _count = state.update(cx, |state, _cx| {
            let motion_now = state.motion_time(_cx.background_executor().now());
            let scroll = state.list.logical_scroll_top();
            if state
                .capture_scale
                .is_some_and(|scale| scale != capture_scale)
                || state.last_render_scroll.is_some_and(|previous| {
                    previous.item_ix != scroll.item_ix
                        || previous.offset_in_item != scroll.offset_in_item
                })
            {
                state.paint_cache.clear();
                state.exit_rows.clear();
                state.motion.capture_layout(&[]);
            }
            state.capture_scale = Some(capture_scale);
            state.last_render_scroll = Some(scroll);
            let geometry_changed = state.row_height_for.is_some() != self.row_height_for.is_some();
            state.row_height_for = self.row_height_for.clone();
            state.reduced_motion = self.reduced_motion || _cx.reduce_motion();
            state.rename_enabled = self.on_rename.is_some();
            state.selection_observer = self.on_selection_change.clone();
            state.paint_generation = state.paint_generation.wrapping_add(1);
            state.motion.begin_frame();
            state.motion.tick(motion_now);
            state.exit_rows.retain(|id, exit| {
                state.tree.visible_index(id).is_none()
                    && motion_now.saturating_sub(exit.started_at)
                        < super::animation::DEFAULT_TREE_MOTION_DURATION
            });
            if state.reduced_motion || _cx.reduce_motion() {
                state.exit_rows.clear();
                state.motion.capture_layout(&[]);
            }
            if state.row_height != self.row_height || geometry_changed {
                let scroll = state.list.logical_scroll_top();
                state.row_height = self.row_height;
                state.motion.capture_layout(&[]);
                reset_list_geometry(state);
                restore_editor_focus_registration(state);
                if state.tree.visible_len() > 0 {
                    state.list.scroll_to(ListOffset {
                        item_ix: scroll.item_ix.min(state.tree.visible_len() - 1),
                        offset_in_item: scroll.offset_in_item,
                    });
                }
            }
            if state.model_identity != model_identity {
                state.model_identity = model_identity;
                state.model_revision = state.model_revision.wrapping_add(1);
                state.model_lifetime = Some(model.clone());
                state.tree = TreeListState::new();
                state.selection = SelectionState::new();
                state.stable_row_ids.clear();
                state.paint_cache.clear();
                state.exit_rows.clear();
                state.restore_tree_focus_if_editor_owned |= state.editing.is_some();
                state.editing = None;
                state.rename_error = None;
                state.edit_subscription = None;
                state.editor_focus_registered_generation = None;
                state.dnd.clear();
                state.motion.capture_layout(&[]);
                state
                    .tree
                    .set_expanded_ids(model.as_ref(), initial_expanded.clone());
                state.tree.visible_rows(model.as_ref());
                let _ = state.tree.take_projection_changes();
                reset_list_geometry(state);
            }
            state.tree.visible_rows(model.as_ref());
            let count = state.tree.visible_len();
            if state.list.item_count() != count {
                reset_list_geometry(state);
            }
            count
        });

        let (restore_tree_focus, edit_focus) = state.update(cx, |state, _| {
            let restore = state.restore_tree_focus_if_editor_owned;
            state.restore_tree_focus_if_editor_owned = false;
            (restore, state.edit_focus.clone())
        });
        if restore_tree_focus
            && edit_focus
                .as_ref()
                .is_some_and(|focus| focus.is_focused(window))
        {
            let tree_focus = state.read(cx).focus.clone();
            window.focus(&tree_focus, cx);
        }

        let state_weak = state.downgrade();
        let model_rows = model.clone();
        let label = self.label.clone();
        let custom_renderer = self.row_renderer.clone();
        let on_rename = self.on_rename.clone();
        let on_selection_change = self.on_selection_change.clone();
        let on_drop = self.on_drop.clone();
        let on_drop_for_rows = on_drop.clone();
        let can_drop = self.can_drop.clone();
        let list_state = state.read(cx).list.clone();
        let row_geometry = list_state.geometry();
        let id = self.id.clone();
        let row_height = self.row_height;
        let preview_marker = state.read(cx).dnd.preview.as_ref().and_then(|preview| {
            let tree = &state.read(cx).tree;
            match &preview.target {
                super::DropTarget::Before(id) => Some((id.clone(), true, false, false)),
                super::DropTarget::Inside(id) => Some((id.clone(), false, true, false)),
                super::DropTarget::After(id) => last_visible_descendant(tree, model.as_ref(), id)
                    .map(|id| (id, false, false, true)),
                super::DropTarget::RootEnd => tree
                    .visible_len()
                    .checked_sub(1)
                    .and_then(|index| tree.visible_row(index))
                    .map(|row| (row.id.clone(), false, false, true)),
            }
        });
        let row_list = list(list_state.clone(), move |index, window, cx| {
            let row = state_weak
                .read_with(cx, |state, _| state.tree.visible_row(index).cloned())
                .ok()
                .flatten();
            let Some(row) = row else {
                return div().into_any_element();
            };
            let row_height = row_geometry.item_height(index).unwrap_or(row_height);
            let row_y = row_geometry.item_offset(index).as_f32();
            let text = (label)(&row.id);
            let (expanded, selected, focused, editing, has_children, sibling_count) = state_weak
                .read_with(cx, |state, _| {
                    (
                        state.tree.is_expanded(&row.id),
                        state.selection.is_selected(&row.id),
                        state.selection.focused() == Some(&row.id),
                        state.editing.as_ref() == Some(&row.id),
                        model_rows.is_branch(&row.id),
                        row.parent.as_ref().map_or_else(
                            || model_rows.roots_len(),
                            |parent| model_rows.child_count(parent),
                        ),
                    )
                })
                .unwrap_or_default();
            let context = TreeRowContext {
                id: row.id.clone(),
                label: text.clone(),
                depth: row.depth,
                height: row_height,
                expanded,
                has_children,
                selected,
                focused,
                editing,
                rename_error: state_weak
                    .read_with(cx, |state, _| {
                        (state.editing.as_ref() == Some(&row.id))
                            .then(|| state.rename_error.clone())
                            .flatten()
                    })
                    .ok()
                    .flatten(),
                position_in_set: row.index_in_parent + 1,
                set_size: sibling_count,
            };

            let stable_token = state_weak
                .update(cx, |state, _| {
                    if let Some(token) = state.stable_row_ids.get(&row.id) {
                        *token
                    } else {
                        state.next_row_id = state
                            .next_row_id
                            .checked_add(1)
                            .expect("tree row token exhausted");
                        let token = state.next_row_id;
                        state.stable_row_ids.insert(row.id.clone(), token);
                        token
                    }
                })
                .unwrap_or(index as u64);
            let label_content = if editing && let Some(rename) = on_rename.clone() {
                let edit_generation = state_weak
                    .read_with(cx, |state, _| state.edit_generation)
                    .unwrap_or(0);
                let edit_id =
                    ElementId::Name(format!("{}-edit-{stable_token}-{edit_generation}", id).into());
                let initial_text = text.clone();
                let edit_state =
                    EditableTextState::use_keyed_init(edit_id.clone(), window, cx, move |_, _| {
                        StringStorage::from(initial_text.to_string())
                    });
                let should_subscribe = state_weak
                    .read_with(cx, |state, _| state.edit_subscription.is_none())
                    .unwrap_or(false);
                if should_subscribe {
                    let weak_tree = state_weak.clone();
                    let node = row.id.clone();
                    let subscribed_generation = edit_generation;
                    let subscription =
                        cx.subscribe(&edit_state, move |_, event: &EditableTextEvent, cx| {
                            let still_current = weak_tree
                                .read_with(cx, |state, _| {
                                    state.edit_generation == subscribed_generation
                                        && state.editing.as_ref() == Some(&node)
                                })
                                .unwrap_or(false);
                            if !still_current {
                                return;
                            }
                            let (value, cancel, restore_tree_focus) = match event {
                                EditableTextEvent::Submit(value) => {
                                    (Some(value.clone()), false, true)
                                }
                                EditableTextEvent::Blur(value) => {
                                    (Some(value.clone()), false, false)
                                }
                                EditableTextEvent::Cancel(_) => (None, true, true),
                            };
                            if cancel {
                                let _ = weak_tree.update_in(cx, |state, window, cx| {
                                    clear_editor_focus_registration(state);
                                    state.editing = None;
                                    state.rename_error = None;
                                    state.edit_subscription = None;
                                    window.focus(&state.focus, cx);
                                    cx.notify();
                                });
                            } else if let Some(value) = value {
                                let result = weak_tree.upgrade().map(|entity| {
                                    cx.with_window(entity.entity_id(), |window, app| {
                                        rename(&node, &value, window, app)
                                    })
                                });
                                let result = result.flatten().unwrap_or_else(|| {
                                    Err("The tree view is no longer available".into())
                                });
                                let accepted = result.is_ok();
                                let applied = weak_tree.update(cx, |state, cx| {
                                    if state.edit_generation != subscribed_generation
                                        || state.editing.as_ref() != Some(&node)
                                    {
                                        return false;
                                    }
                                    match result {
                                        Ok(()) => {
                                            clear_editor_focus_registration(state);
                                            state.editing = None;
                                            state.rename_error = None;
                                            state.edit_subscription = None;
                                            cx.notify();
                                        }
                                        Err(error) => {
                                            state.rename_error = Some(error);
                                            state.focus_editor = true;
                                            cx.notify();
                                        }
                                    }
                                    true
                                });
                                if accepted
                                    && applied.is_ok_and(|applied| applied)
                                    && restore_tree_focus
                                {
                                    let _ = weak_tree.update_in(cx, |state, window, cx| {
                                        if state.edit_generation == subscribed_generation
                                            && state.editing.is_none()
                                        {
                                            window.focus(&state.focus, cx)
                                        }
                                    });
                                }
                            }
                        });
                    let _ = state_weak
                        .update(cx, |state, _| state.edit_subscription = Some(subscription));
                }
                let focus_editor = state_weak
                    .update(cx, |state, _| {
                        if state.focus_editor && state.editing.as_ref() == Some(&row.id) {
                            state.focus_editor = false;
                            true
                        } else {
                            false
                        }
                    })
                    .unwrap_or(false);
                let editor_focus = edit_state.focus_handle(cx);
                if focus_editor {
                    let (pointer, select_name) = state_weak
                        .update(cx, |state, _| {
                            (
                                state.edit_pointer.take(),
                                std::mem::take(&mut state.select_name_on_edit),
                            )
                        })
                        .unwrap_or((None, false));
                    edit_state.update(cx, |editor, cx| {
                        if let Some(pointer) = pointer {
                            editor.place_caret_at_window_position(pointer, cx);
                        } else if select_name {
                            editor.select_document(cx);
                        }
                    });
                    window.focus(&editor_focus, cx);
                }
                let register_focus = state_weak
                    .update(cx, |state, _| {
                        state.edit_focus = Some(editor_focus.clone());
                        state.editor_focus_registered_generation != Some(edit_generation)
                    })
                    .unwrap_or(false);
                if register_focus {
                    let weak_tree = state_weak.clone();
                    let editor_node = row.id.clone();
                    let editor_focus = editor_focus.clone();
                    window.defer(cx, move |_, cx| {
                        let _ = weak_tree.update(cx, |state, cx| {
                            if state.edit_generation == edit_generation
                                && state.editing.as_ref() == Some(&editor_node)
                            {
                                if let Some(index) = state.tree.visible_index(&editor_node) {
                                    let scroll = state.list.logical_scroll_top();
                                    state
                                        .list
                                        .splice_focusable(index..index + 1, [Some(editor_focus)]);
                                    state.list.remeasure_items(index..index + 1);
                                    state.list.scroll_to(scroll);
                                    state.editor_focus_registered_generation =
                                        Some(edit_generation);
                                    cx.notify();
                                }
                            }
                        });
                    });
                }
                let error = state_weak
                    .read_with(cx, |state, _| state.rename_error.clone())
                    .ok()
                    .flatten();
                let input = text_input(edit_id)
                    .state(edit_state.downgrade())
                    .multiline(false)
                    .tab_behavior(TabBehavior::Focus)
                    .flex_1()
                    .min_w_0()
                    .h_full()
                    .into_any_element();
                div()
                    .id(ElementId::Name(
                        format!("{}-edit-shell-{stable_token}-{edit_generation}", id).into(),
                    ))
                    .on_click(|_, _, cx| cx.stop_propagation())
                    .flex()
                    .items_center()
                    .gap_1()
                    .w_full()
                    .h_full()
                    .child(input)
                    .when(error.is_some(), |element| {
                        element.border_1().border_color(gpui::rgb(0xe5534b))
                    })
                    .when_some(error, |element, error| {
                        element.child(div().text_color(gpui::rgb(0xe5534b)).text_xs().child(error))
                    })
                    .into_any_element()
            } else {
                text.clone().into_any_element()
            };
            let contents = if let Some(renderer) = &custom_renderer {
                renderer(context, label_content, window, cx)
            } else {
                label_content
            };
            let motion_now = cx.background_executor().now();
            let (motion, animating) = state_weak
                .update(cx, |state, _| {
                    let now = state.motion_time(motion_now);
                    state.motion.record_layout(TreeListRowLayout {
                        id: row.id.clone(),
                        y: row_y,
                        height: row_height.as_f32(),
                    });
                    let motion = state.motion.row_motion(&row.id, now);
                    let animating = motion_blocks_input(motion);
                    (motion, animating)
                })
                .unwrap_or((RowMotion::default(), false));
            if animating {
                window.request_animation_frame();
            }
            let row_id = format!("{}-row-{stable_token}", id);
            let select_weak = state_weak.clone();
            let select_callback = on_selection_change.clone();
            let selected_id = row.id.clone();
            let edit_id = row.id.clone();
            let rename_enabled = on_rename.is_some();
            let mut row_element = div()
                .id(row_id.clone())
                .role(gpui::accesskit::Role::TreeItem)
                .aria_label(text)
                .aria_selected(selected)
                .when(has_children, |element| element.aria_expanded(expanded))
                .aria_level(row.depth + 1)
                .aria_position_in_set(row.index_in_parent + 1)
                .aria_size_of_set(sibling_count)
                .when(focused, |element| element.aria_active_descendant())
                .h(row_height)
                .pl(px((row.depth as f32) * 16.))
                .flex()
                .items_center()
                .gap_1()
                .when(selected, |this| this.bg(gpui::hsla(0.6, 0.5, 0.35, 0.35)))
                .when(focused, |this| this.border_1().border_color(gpui::white()))
                .on_click(move |event, window, cx| {
                    let selection_update = select_weak
                        .update(cx, |state, cx| {
                            let now = state.motion_time(cx.background_executor().now());
                            if motion_blocks_input(state.motion.row_motion(&selected_id, now)) {
                                return None;
                            }
                            let modifiers = event.modifiers();
                            if modifiers.shift {
                                let target_index =
                                    state.tree.visible_index(&selected_id).unwrap_or(0);
                                select_visible_range(
                                    state,
                                    selected_id.clone(),
                                    target_index,
                                    modifiers.secondary() || modifiers.control,
                                );
                            } else if modifiers.secondary() || modifiers.control {
                                state.selection.toggle(selected_id.clone());
                            } else {
                                state.selection.select_only(selected_id.clone());
                            }
                            if event.click_count() >= 2 && rename_enabled {
                                clear_editor_focus_registration(state);
                                state.edit_generation = state
                                    .edit_generation
                                    .checked_add(1)
                                    .expect("tree edit generation exhausted");
                                state.edit_subscription = None;
                                state.rename_error = None;
                                state.editing = Some(edit_id.clone());
                                state.edit_pointer = Some(event.position());
                                state.select_name_on_edit = false;
                                state.focus_editor = true;
                            }
                            let focus_tree = (state.editing.as_ref() != Some(&selected_id))
                                .then(|| state.focus.clone());
                            let selected = state.selection.selected_ordered().to_vec();
                            cx.notify();
                            Some((selected, focus_tree))
                        })
                        .ok()
                        .flatten();
                    if let Some((selected, focus_tree)) = selection_update {
                        // Move focus after releasing the tree-state update. This
                        // can synchronously emit EditableText::Blur, whose
                        // subscriber must be free to update this same state.
                        if let Some(focus) = focus_tree {
                            window.focus(&focus, cx);
                        }
                        if let Some(callback) = &select_callback {
                            callback(selected, window, cx);
                        }
                    }
                });

            if on_drop_for_rows.is_some() && !animating {
                let drag_id = row.id.clone();
                let drag_model = model_rows.clone();
                let drag_source = state_weak.clone();
                let model_identity = Rc::as_ptr(&model_rows) as *const () as usize;
                row_element = row_element.on_drag_alt(move |offset, cursor_style, _, cx| {
                    let payload = drag_source
                        .update(cx, |state, cx| {
                            let payload = super::TreeDragPayload {
                                tree_identity: state.tree_identity,
                                model_identity,
                                model_revision: state.model_revision,
                                roots: super::drag_roots_in_preorder(
                                    drag_model.as_ref(),
                                    state.selection.selected_ordered(),
                                    &drag_id,
                                ),
                            };
                            state.dnd.begin(payload.clone());
                            cx.notify();
                            payload
                        })
                        .unwrap_or(super::TreeDragPayload {
                            tree_identity: 0,
                            model_identity,
                            model_revision: 0,
                            roots: vec![drag_id.clone()],
                        });
                    gpui::AnyDrag::new(payload, cx.new(|_| gpui::EmptyView))
                        .offset(offset)
                        .cursor_style(cursor_style)
                });
            }

            let preview = preview_marker
                .as_ref()
                .filter(|(id, _, _, _)| id == &row.id)
                .map(|(_, before, inside, after)| (*before, *inside, *after));
            if let Some((before, inside, after)) = preview {
                row_element = row_element
                    .when(before, |this| {
                        this.border_t_2().border_color(gpui::rgb(0x4da3ff))
                    })
                    .when(inside, |this| this.bg(gpui::hsla(0.58, 0.7, 0.5, 0.28)))
                    .when(after, |this| {
                        this.border_b_2().border_color(gpui::rgb(0x4da3ff))
                    });
            }

            if has_children {
                let toggle_weak = state_weak.clone();
                let toggle_id = row.id.clone();
                let toggle_model = model_rows.clone();
                row_element = row_element.child(
                    div()
                        .id(format!("{row_id}-disclosure"))
                        .w_4()
                        .h_full()
                        .flex()
                        .items_center()
                        .justify_center()
                        .child(if expanded { "▾" } else { "▸" })
                        .on_click(move |_, _, cx| {
                            toggle_weak
                                .update(cx, |state, cx| {
                                    let now = state.motion_time(cx.background_executor().now());
                                    if motion_blocks_input(state.motion.row_motion(&toggle_id, now))
                                    {
                                        return;
                                    }
                                    if state
                                        .tree
                                        .toggle_expanded(toggle_model.as_ref(), toggle_id.clone())
                                    {
                                        if !state.tree.is_expanded(&toggle_id) {
                                            repair_hidden_focus(state, toggle_model.as_ref());
                                        }
                                        apply_pending_splices(
                                            state,
                                            cx.background_executor().now(),
                                            cx.reduce_motion(),
                                        );
                                        cx.notify();
                                    }
                                })
                                .ok();
                            cx.stop_propagation();
                        }),
                );
            } else {
                row_element = row_element.child(div().w_4().h_full());
            }
            let visual = row_element
                .child(contents)
                .h(row_height * motion.height_scale)
                .mt(px(motion.translate_y))
                .mb(px(-motion.translate_y))
                .overflow_hidden()
                .opacity(motion.opacity);
            let capture_state = state_weak.clone();
            let capture_id = row.id.clone();
            let scale = window.scale_factor();
            let capture = crate::paint_snapshot::PaintSnapshotElement::new(visual).on_capture(
                move |snapshot, bounds, cx| {
                    let _ = capture_state.update(cx, |state, _| {
                        let logical_bounds = gpui::Bounds::new(
                            gpui::point(
                                px(bounds.origin.x.0 / scale),
                                px(bounds.origin.y.0 / scale),
                            ),
                            gpui::size(
                                px(bounds.size.width.0 / scale),
                                px(bounds.size.height.0 / scale),
                            ),
                        );
                        store_paint(state, capture_id.clone(), snapshot, logical_bounds);
                    });
                },
            );
            div()
                .relative()
                .h(row_height)
                // The default visible overflow lets a moved row paint across
                // neighboring slots; the list viewport clips the full
                // transition. The inner row clips inserted content as it
                // reveals. While displaced, click and drag handlers are
                // inactive so its moving hitbox cannot target another
                // canonical row; they return when the visual reaches its slot.
                .child(capture)
                .when(animating, |element| {
                    element.child(div().absolute().inset_0().block_mouse_except_scroll())
                })
                .into_any_element()
        })
        .w_full()
        .flex_1()
        .min_h_0();

        let keyboard_weak = state.downgrade();
        let keyboard_model = model.clone();
        let keyboard_select = self.on_selection_change.clone();
        let on_rename = self.on_rename.clone();
        let keyboard = move |event: &gpui::KeyDownEvent, window: &mut Window, cx: &mut App| {
            let key = event.keystroke.key.as_str();
            let modifiers = event.keystroke.modifiers;
            let selection_changed = keyboard_weak
                .update(cx, |state, cx| {
                    if state.editing.is_some() {
                        return None;
                    }
                    let focused = state.selection.focused().cloned();
                    let focus_index = focused.as_ref().and_then(|id| state.tree.visible_index(id));
                    let geometry = state.list.geometry();
                    let page_height = state
                        .list
                        .viewport_bounds()
                        .size
                        .height
                        .max(state.row_height);
                    let target_index = match key {
                        "up" => focus_index.map(|i| i.saturating_sub(1)).or_else(|| {
                            (!state.tree.visible_rows_cached().is_empty())
                                .then_some(state.tree.visible_len() - 1)
                        }),
                        "down" => focus_index
                            .map(|i| (i + 1).min(state.tree.visible_len().saturating_sub(1)))
                            .or_else(|| {
                                (!state.tree.visible_rows_cached().is_empty()).then_some(0)
                            }),
                        "pageup" => focus_index.map(|i| {
                            geometry
                                .offset_for_pixel(
                                    (geometry.item_offset(i) - page_height).max(px(0.)),
                                )
                                .item_ix
                        }),
                        "pagedown" => focus_index.map(|i| {
                            geometry
                                .offset_for_pixel(geometry.item_offset(i) + page_height)
                                .item_ix
                                .min(state.tree.visible_len().saturating_sub(1))
                        }),
                        "home" => (!state.tree.visible_rows_cached().is_empty()).then_some(0),
                        "end" => state.tree.visible_len().checked_sub(1),
                        _ => None,
                    };
                    if let Some(index) = target_index {
                        let Some(target) = state.tree.visible_row(index).map(|row| row.id.clone())
                        else {
                            return None;
                        };
                        if modifiers.shift {
                            select_visible_range(
                                state,
                                target.clone(),
                                index,
                                modifiers.secondary() || modifiers.control,
                            );
                        } else if !modifiers.secondary() && !modifiers.control {
                            state.selection.select_only(target.clone());
                        } else {
                            state.selection.set_focused(Some(target.clone()));
                        }
                        if let Some(index) = state.tree.visible_index(&target) {
                            state.list.scroll_to_reveal_item(index);
                        }
                        cx.notify();
                        return if modifiers.shift || (!modifiers.secondary() && !modifiers.control)
                        {
                            Some(state.selection.selected_ordered().to_vec())
                        } else {
                            None
                        };
                    }
                    if key == "escape" {
                        state.dnd.clear();
                        cx.notify();
                        return None;
                    }
                    if key == "a" && (modifiers.secondary() || modifiers.control) {
                        for index in 0..state.tree.visible_len() {
                            if let Some(id) =
                                state.tree.visible_row(index).map(|row| row.id.clone())
                            {
                                state.selection.set_selected(id, true);
                            }
                        }
                        if state.selection.focused().is_none() {
                            if let Some(id) = state.tree.visible_row(0).map(|row| row.id.clone()) {
                                state.selection.set_focused(Some(id));
                            }
                        }
                        cx.notify();
                        return Some(state.selection.selected_ordered().to_vec());
                    }
                    let Some(focused) = focused else {
                        return None;
                    };
                    match key {
                        "right" => {
                            if state.tree.is_expanded(&focused) {
                                if let Some(next) = state
                                    .tree
                                    .visible_index(&focused)
                                    .and_then(|i| state.tree.visible_row(i + 1))
                                    .filter(|row| row.parent.as_ref() == Some(&focused))
                                    .map(|row| row.id.clone())
                                {
                                    state.selection.select_only(next.clone());
                                    if let Some(index) = state.tree.visible_index(&next) {
                                        state.list.scroll_to_reveal_item(index);
                                    }
                                }
                            } else if keyboard_model.is_branch(&focused) {
                                state.tree.set_expanded(
                                    keyboard_model.as_ref(),
                                    focused.clone(),
                                    true,
                                );
                                apply_pending_splices(
                                    state,
                                    cx.background_executor().now(),
                                    cx.reduce_motion(),
                                );
                            }
                            cx.notify();
                            (focused != *state.selection.focused().unwrap_or(&focused))
                                .then(|| state.selection.selected_ordered().to_vec())
                        }
                        "left" => {
                            if state.tree.is_expanded(&focused) {
                                state.tree.set_expanded(
                                    keyboard_model.as_ref(),
                                    focused.clone(),
                                    false,
                                );
                                apply_pending_splices(
                                    state,
                                    cx.background_executor().now(),
                                    cx.reduce_motion(),
                                );
                                state.selection.set_focused(Some(focused.clone()));
                            } else if let Some(parent) = keyboard_model.parent(&focused) {
                                state.selection.select_only(parent.clone());
                                if let Some(index) = state.tree.visible_index(&parent) {
                                    state.list.scroll_to_reveal_item(index);
                                }
                            }
                            cx.notify();
                            (focused != *state.selection.focused().unwrap_or(&focused))
                                .then(|| state.selection.selected_ordered().to_vec())
                        }
                        "space" => {
                            state.selection.toggle(focused);
                            cx.notify();
                            Some(state.selection.selected_ordered().to_vec())
                        }
                        "f2" => {
                            if on_rename.is_some() {
                                clear_editor_focus_registration(state);
                                state.edit_generation = state
                                    .edit_generation
                                    .checked_add(1)
                                    .expect("tree edit generation exhausted");
                                state.edit_subscription = None;
                                state.rename_error = None;
                                state.editing = Some(focused);
                                state.edit_pointer = None;
                                state.select_name_on_edit = true;
                                state.focus_editor = true;
                                cx.notify();
                            }
                            None
                        }
                        _ => None,
                    }
                })
                .ok()
                .flatten();
            if let (Some(callback), Some(selected)) = (&keyboard_select, selection_changed) {
                callback(selected, window, cx);
            }
        };

        let drag_tree_identity = state.read(cx).tree_identity;
        let drag_model_identity = Rc::as_ptr(&model) as *const () as usize;
        let drag_model_revision = state.read(cx).model_revision;
        let drop_weak = state.downgrade();
        let drop_model = model.clone();
        let drop_list = list_state;
        let drop_can_drop = can_drop.clone();
        let drop_can_drop_for_listener = can_drop.clone();
        let drag_move = move |event: &gpui::DragMoveEvent<super::TreeDragPayload<Id>>,
                              _window: &mut Window,
                              cx: &mut App| {
            let payload = event.drag(cx).clone();
            if !payload.belongs_to(drag_tree_identity, drag_model_identity, drag_model_revision) {
                let _ = drop_weak.update(cx, |state, cx| {
                    if state.dnd.payload.as_ref() == Some(&payload) {
                        state.dnd.clear();
                        cx.notify();
                    }
                });
                return;
            }
            let pointer_y = event.event.position.y.as_f32();
            let viewport = drop_list.viewport_bounds();
            let timer_state = drop_weak.clone();
            let timer_model = drop_model.clone();
            let timer_list = drop_list.clone();
            let timer_validate = drop_can_drop.clone();
            let _ = drop_weak.update(cx, |state, cx| {
                if state.model_revision != drag_model_revision {
                    state.dnd.clear();
                    cx.notify();
                    return;
                }
                state.dnd.pointer_y = Some(pointer_y);
                state.dnd.viewport_top = viewport.top().as_f32();
                state.dnd.viewport_height = viewport.size.height.as_f32();
                let target = drop_target_at_y(state, drop_model.as_ref(), pointer_y);
                let preview = target.clone().and_then(|target| {
                    super::validated_preview(drop_model.as_ref(), &payload, target)
                });
                let preview = preview.filter(|preview| {
                    drop_can_drop
                        .as_ref()
                        .is_none_or(|validate| validate(&payload.roots, &preview.position))
                });
                let error = (target.is_some() && preview.is_none())
                    .then(|| SharedString::from("These rows cannot be dropped here"));
                if state.dnd.error != error {
                    state.dnd.error = error;
                    cx.notify();
                }
                let hover = preview.as_ref().and_then(|preview| match &preview.target {
                    super::DropTarget::Inside(id)
                        if drop_model.child_count(id) > 0 && !state.tree.is_expanded(id) =>
                    {
                        Some(id.clone())
                    }
                    _ => None,
                });
                if state.dnd.hover_target != hover {
                    state.dnd.hover_target = hover;
                    state.dnd.hover_started_at = state
                        .dnd
                        .hover_target
                        .as_ref()
                        .map(|_| cx.background_executor().now());
                }
                if state.dnd.preview != preview {
                    state.dnd.preview = preview;
                    cx.notify();
                }
            });
            schedule_dnd_timer(
                timer_state,
                timer_model,
                timer_list,
                drag_tree_identity,
                drag_model_identity,
                drag_model_revision,
                timer_validate,
                cx,
            );
        };
        let drop_listener = gpui::DropListener::<super::TreeDragPayload<Id>>::default()
            .can_drop_within({
                let drop_weak = state.downgrade();
                let drop_can_drop = drop_can_drop_for_listener;
                move |payload, _, cx| {
                    if !payload.belongs_to(
                        drag_tree_identity,
                        drag_model_identity,
                        drag_model_revision,
                    ) {
                        return false;
                    }
                    let active = drop_weak
                        .read_with(cx, |state, _| {
                            (
                                state.model_revision,
                                state.dnd.payload.clone(),
                                state.dnd.preview.clone(),
                            )
                        })
                        .ok();
                    active.is_some_and(|(revision, active_payload, preview)| {
                        revision == drag_model_revision
                            && active_payload.as_ref() == Some(payload)
                            && preview.is_some_and(|preview| {
                                drop_can_drop.as_ref().is_none_or(|validate| {
                                    validate(&payload.roots, &preview.position)
                                })
                            })
                    })
                }
            })
            .on_drop({
                let drop_weak = state.downgrade();
                let drop_model = model.clone();
                let on_drop = on_drop.clone();
                let can_drop = can_drop.clone();
                move |payload, event, window, cx| {
                    let pointer_y = event.position.y.as_f32();
                    let drop = drop_weak
                        .update(cx, |state, _| {
                            if state.model_revision != drag_model_revision
                                || !payload.belongs_to(
                                    drag_tree_identity,
                                    drag_model_identity,
                                    state.model_revision,
                                )
                            {
                                return None;
                            }
                            let target = drop_target_at_y(state, drop_model.as_ref(), pointer_y)?;
                            let preview =
                                super::validated_preview(drop_model.as_ref(), payload, target)?;
                            let roots =
                                super::reduce_drag_roots(drop_model.as_ref(), &payload.roots);
                            Some((roots, preview.position))
                        })
                        .ok()
                        .flatten();
                    let accepted = drop.filter(|(roots, position)| {
                        can_drop
                            .as_ref()
                            .is_none_or(|validate| validate(roots, position))
                    });
                    if let Some((roots, position)) = accepted {
                        if let Some(callback) = &on_drop {
                            match callback(&roots, position, window, cx) {
                                Ok(()) => {
                                    let _ = drop_weak.update(cx, |state, cx| {
                                        state.dnd.clear();
                                        cx.notify();
                                    });
                                }
                                Err(error) => {
                                    let _ = drop_weak.update(cx, |state, cx| {
                                        state.dnd.clear();
                                        state.dnd.error = Some(error);
                                        cx.notify();
                                    });
                                }
                            }
                        } else {
                            let _ = drop_weak.update(cx, |state, cx| {
                                state.dnd.clear();
                                cx.notify();
                            });
                        }
                    } else {
                        let _ = drop_weak.update(cx, |state, cx| {
                            state.dnd.clear();
                            state.dnd.error = Some("This location cannot accept those rows".into());
                            cx.notify();
                        });
                    }
                }
            });
        let exit_state = state.downgrade();
        let release_state = state.downgrade();
        let dnd_error = state.read(cx).dnd.error.clone();
        let mut root = div()
            .id(self.id)
            .role(gpui::accesskit::Role::Tree)
            .aria_label("Tree list")
            .track_focus(&state.read(cx).focus)
            .on_key_down(keyboard)
            .on_drag_move(drag_move)
            .on_drop_alt(drop_listener)
            .relative()
            .overflow_hidden()
            .flex()
            .flex_col()
            .on_mouse_up(gpui::MouseButton::Left, move |_, _, cx| {
                let _ = release_state.update(cx, |state, cx| {
                    if state.dnd.payload.is_some() {
                        state.dnd.finish();
                        cx.notify();
                    }
                });
            })
            .on_mouse_exit(move |_, _, cx| {
                let _ = exit_state.update(cx, |state, cx| {
                    state.dnd.clear();
                    cx.notify();
                });
            })
            .w_full()
            .h_full()
            .flex_1()
            .min_h_0()
            .child(row_list)
            .child(exit_overlay(state.downgrade()))
            .when_some(dnd_error, |this, error| {
                this.child(
                    div()
                        .text_color(gpui::rgb(0xd34a4a))
                        .px_2()
                        .py_1()
                        .child(error),
                )
            });
        root.style().refine(&root_style);
        root
    }
}

fn drop_target_at_y<Id: Clone + Eq + Hash + Debug + 'static, M: TreeModel<Id>>(
    state: &TreeViewState<Id>,
    model: &M,
    pointer_y: f32,
) -> Option<super::DropTarget<Id>> {
    if !pointer_y.is_finite() {
        return None;
    }
    let count = state.tree.visible_len();
    if count == 0 {
        return Some(super::DropTarget::RootEnd);
    }
    let viewport = state.list.viewport_bounds();
    let first = state.list.logical_scroll_top().item_ix.saturating_sub(1);
    let geometry = state.list.geometry();
    let scroll = state.list.logical_scroll_top();
    let bottom =
        geometry.item_offset(scroll.item_ix) + scroll.offset_in_item + viewport.size.height;
    let end = geometry
        .offset_for_pixel(bottom)
        .item_ix
        .saturating_add(2)
        .min(count);
    let mut first_bounds = None;
    let mut last_bounds = None;
    for index in first..end {
        let Some(bounds) = state.list.bounds_for_item(index) else {
            continue;
        };
        first_bounds.get_or_insert(bounds);
        last_bounds = Some((index, bounds));
        if pointer_y >= bounds.top().as_f32() && pointer_y < bounds.bottom().as_f32() {
            let id = &state.tree.visible_row(index)?.id;
            let target = super::target_for_row(
                id.clone(),
                pointer_y,
                bounds.top().as_f32(),
                bounds.bottom().as_f32(),
            );
            return match target {
                Some(super::DropTarget::Inside(id)) if !model.is_branch(&id) => Some(
                    if pointer_y < (bounds.top().as_f32() + bounds.bottom().as_f32()) / 2. {
                        super::DropTarget::Before(id)
                    } else {
                        super::DropTarget::After(id)
                    },
                ),
                target => target,
            };
        }
    }
    if let Some((last_index, bounds)) = last_bounds {
        if pointer_y >= bounds.bottom().as_f32() && last_index + 1 == count {
            return Some(super::DropTarget::RootEnd);
        }
    }
    if let Some(bounds) = first_bounds {
        if pointer_y < bounds.top().as_f32() {
            if let Some(row) = state.tree.visible_row(first) {
                return Some(super::DropTarget::Before(row.id.clone()));
            }
        }
    }
    None
}

fn schedule_dnd_timer<Id, M>(
    state_weak: gpui::WeakEntity<TreeViewState<Id>>,
    model: Rc<M>,
    list: ListState,
    tree_identity: u64,
    model_identity: usize,
    model_revision: u64,
    can_drop: Option<Rc<dyn Fn(&[Id], &super::DropPosition<Id>) -> bool>>,
    cx: &mut App,
) where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id> + 'static,
{
    let _ = state_weak.update(cx, |state, cx| {
        if state.model_revision != model_revision
            || state.dnd.payload.as_ref().is_none_or(|payload| {
                !payload.belongs_to(tree_identity, model_identity, model_revision)
            })
        {
            state.dnd.clear();
            return;
        }
        if state.dnd.timer_scheduled {
            return;
        }
        let Some(pointer_y) = state.dnd.pointer_y else {
            return;
        };
        let velocity = super::autoscroll_velocity_for_pointer(
            pointer_y,
            state.dnd.viewport_top,
            state.dnd.viewport_height,
        );
        if velocity == 0.0 && state.dnd.hover_target.is_none() {
            return;
        }
        let generation = state.dnd.session_generation;
        state.dnd.timer_scheduled = true;
        let model = model.clone();
        let list = list.clone();
        let can_drop = can_drop.clone();
        cx.spawn(async move |weak, cx| {
            loop {
                cx.background_executor()
                    .timer(Duration::from_millis(50))
                    .await;
                let Some(entity) = weak.upgrade() else {
                    break;
                };
                let keep_running = entity.update(cx, |state, cx| {
                    if state.dnd.session_generation != generation
                        || state.model_revision != model_revision
                        || state.dnd.payload.as_ref().is_none_or(|payload| {
                            !payload.belongs_to(tree_identity, model_identity, model_revision)
                        })
                    {
                        state.dnd.finish_timer(generation);
                        return false;
                    }
                    let now = cx.background_executor().now();
                    let Some(pointer_y) = state.dnd.pointer_y else {
                        state.dnd.finish_timer(generation);
                        return false;
                    };
                    let viewport = list.viewport_bounds();
                    state.dnd.viewport_top = viewport.top().as_f32();
                    state.dnd.viewport_height = viewport.size.height.as_f32();
                    let velocity = super::autoscroll_velocity_for_pointer(
                        pointer_y,
                        state.dnd.viewport_top,
                        state.dnd.viewport_height,
                    );
                    let old_offset = list.logical_scroll_top();
                    list.scroll_by(px(velocity * 0.05));
                    let next_offset = list.logical_scroll_top();
                    let scrolled = next_offset.item_ix != old_offset.item_ix
                        || next_offset.offset_in_item != old_offset.offset_in_item;

                    let mut changed = scrolled;
                    let dwell = state.dnd.hover_target.clone().filter(|target| {
                        state.dnd.hover_started_at.is_some_and(|started| {
                            now.duration_since(started) >= Duration::from_millis(600)
                        }) && !state.tree.is_expanded(target)
                    });
                    if let Some(target) = dwell {
                        if state.tree.set_expanded(model.as_ref(), target, true) {
                            apply_pending_splices(state, now, cx.reduce_motion());
                            state.dnd.hover_target = None;
                            state.dnd.hover_started_at = None;
                            changed = true;
                        }
                    }

                    let target = drop_target_at_y(state, model.as_ref(), pointer_y);
                    let payload = state
                        .dnd
                        .payload
                        .as_ref()
                        .expect("active drag checked above");
                    let preview = target
                        .clone()
                        .and_then(|target| {
                            super::validated_preview(model.as_ref(), payload, target)
                        })
                        .filter(|preview| {
                            can_drop
                                .as_ref()
                                .is_none_or(|validate| validate(&payload.roots, &preview.position))
                        });
                    let error = (target.is_some() && preview.is_none())
                        .then(|| SharedString::from("These rows cannot be dropped here"));
                    if state.dnd.error != error {
                        state.dnd.error = error;
                        changed = true;
                    }
                    let hover = preview.as_ref().and_then(|preview| match &preview.target {
                        super::DropTarget::Inside(id)
                            if model.child_count(id) > 0 && !state.tree.is_expanded(id) =>
                        {
                            Some(id.clone())
                        }
                        _ => None,
                    });
                    if hover != state.dnd.hover_target {
                        state.dnd.hover_target = hover;
                        state.dnd.hover_started_at = state.dnd.hover_target.as_ref().map(|_| now);
                        changed = true;
                    }
                    if preview != state.dnd.preview {
                        state.dnd.preview = preview;
                        changed = true;
                    }
                    if changed {
                        cx.notify();
                    }

                    let can_scroll = scrolled;
                    let pending_dwell = state.dnd.hover_target.is_some();
                    let keep_running = can_scroll || pending_dwell;
                    if !keep_running {
                        state.dnd.finish_timer(generation);
                    }
                    keep_running
                });
                if !keep_running {
                    break;
                }
            }
        })
        .detach();
    });
}

fn height_for<Id: Clone + Eq + Hash + Debug + 'static>(
    state: &TreeViewState<Id>,
    id: &Id,
) -> Pixels {
    let height = state
        .row_height_for
        .as_ref()
        .map_or(state.row_height, |height| height(id));
    assert!(
        height.as_f32().is_finite() && height.as_f32() > 0.,
        "tree row heights must be finite and positive"
    );
    height
}

fn reset_list_geometry<Id: Clone + Eq + Hash + Debug + 'static>(state: &TreeViewState<Id>) {
    if state.row_height_for.is_some() {
        state.list.reset_with_item_heights(
            state
                .tree
                .visible_rows_cached()
                .iter()
                .map(|row| height_for(state, &row.id)),
        );
    } else {
        state
            .list
            .reset_with_uniform_height(state.tree.visible_len(), state.row_height);
    }
}

fn apply_pending_splices<Id: Clone + Eq + Hash + Debug + 'static>(
    state: &mut TreeViewState<Id>,
    now: Instant,
    reduced_motion: bool,
) {
    let changes = state.tree.take_projection_changes();
    if changes.is_empty() {
        return;
    }
    let reduced_motion = reduced_motion || state.reduced_motion;
    let scroll = state.list.logical_scroll_top();
    let old_scroll_pixels = state.list.item_offset(scroll.item_ix) + scroll.offset_in_item;
    let mut anchored_index = scroll.item_ix;
    let mut affected: Vec<std::ops::Range<usize>> = Vec::new();
    for change in &changes {
        let map_start = |index: usize| {
            if index >= change.old_range.end {
                index - change.old_range.len() + change.inserted_count
            } else if index >= change.old_range.start {
                change.old_range.start
            } else {
                index
            }
        };
        for range in &mut affected {
            let end = if range.end <= change.old_range.start {
                range.end
            } else if range.end >= change.old_range.end {
                range.end - change.old_range.len() + change.inserted_count
            } else {
                change.old_range.start + change.inserted_count
            };
            range.start = map_start(range.start);
            range.end = end.max(range.start);
        }
        anchored_index = map_start(anchored_index);
        state
            .list
            .splice(change.old_range.clone(), change.inserted_count);
        affected.push(change.old_range.start..change.old_range.start + change.inserted_count);
    }
    if state.list.item_count() != state.tree.visible_len() {
        reset_list_geometry(state);
    } else if state.row_height_for.is_some() {
        for range in affected {
            for index in range {
                if let Some(row) = state.tree.visible_row(index) {
                    state
                        .list
                        .set_item_height(index, height_for(state, &row.id));
                }
            }
        }
    }
    let final_count = state.tree.visible_len();
    if final_count > 0 {
        state.list.scroll_to(ListOffset {
            item_ix: anchored_index.min(final_count - 1),
            offset_in_item: scroll.offset_in_item,
        });
    }
    let new_scroll = state.list.logical_scroll_top();
    let new_scroll_pixels = state.list.item_offset(new_scroll.item_ix) + new_scroll.offset_in_item;
    state
        .motion
        .translate_layout((new_scroll_pixels - old_scroll_pixels).as_f32());
    state.last_render_scroll = Some(new_scroll);
    cancel_hidden_editor(state);
    capture_exits(state, now, reduced_motion);
    let first = state.list.logical_scroll_top().item_ix.saturating_sub(4);
    let geometry = state.list.geometry();
    let viewport_height = state.list.viewport_bounds().size.height;
    let start_y = geometry.item_offset(first);
    let mut next = Vec::new();
    for index in first..final_count {
        if next.len() >= super::animation::MAX_MOTION_ROWS {
            break;
        }
        let y = geometry.item_offset(index);
        if y - start_y > viewport_height + px(160.) && next.len() > 12 {
            break;
        }
        if let Some(row) = state.tree.visible_row(index) {
            next.push(TreeListRowLayout {
                id: row.id.clone(),
                y: y.as_f32(),
                height: height_for(state, &row.id).as_f32(),
            });
        }
    }
    state
        .motion
        .begin_transition(&next, state.motion_time(now), reduced_motion);
    restore_editor_focus_registration(state);
}

// A splice or geometry reset can remove the focused item's list registration
// while its identity survives elsewhere in the projection. Restore it before
// layout: an offscreen editor cannot register itself by rendering.
fn restore_editor_focus_registration<Id: Clone + Eq + Hash + Debug + 'static>(
    state: &mut TreeViewState<Id>,
) {
    if state.editor_focus_registered_generation == Some(state.edit_generation) {
        if let Some((index, focus)) = state
            .editing
            .as_ref()
            .and_then(|id| state.tree.visible_index(id))
            .zip(state.edit_focus.clone())
        {
            let scroll = state.list.logical_scroll_top();
            state.list.splice_focusable(index..index + 1, [Some(focus)]);
            state.list.remeasure_items(index..index + 1);
            state.list.scroll_to(scroll);
        }
    }
}

fn motion_blocks_input(motion: RowMotion) -> bool {
    motion.translate_y.abs() > 0.01 || motion.opacity < 0.999 || motion.height_scale < 0.999
}

fn clear_editor_focus_registration<Id: Clone + Eq + Hash + Debug + 'static>(
    state: &mut TreeViewState<Id>,
) {
    if state.editor_focus_registered_generation.take().is_some() {
        if let Some(index) = state
            .editing
            .as_ref()
            .and_then(|id| state.tree.visible_index(id))
        {
            let scroll = state.list.logical_scroll_top();
            state.list.splice_focusable(index..index + 1, [None]);
            state.list.remeasure_items(index..index + 1);
            state.list.scroll_to(scroll);
        }
    }
}

fn select_visible_range<Id: Clone + Eq + Hash + Debug + 'static>(
    state: &mut TreeViewState<Id>,
    target: Id,
    target_index: usize,
    additive: bool,
) {
    let anchor = state
        .selection
        .anchor()
        .cloned()
        .unwrap_or_else(|| target.clone());
    let anchor_index = state.tree.visible_index(&anchor);
    if !additive {
        let old_selected = state.selection.selected_ordered().to_vec();
        for id in old_selected {
            if state.tree.visible_index(&id).is_some() {
                state.selection.set_selected(id, false);
            }
        }
        if anchor_index.is_none() {
            state.selection.set_selected(anchor.clone(), true);
        }
    }
    let start = anchor_index.unwrap_or(target_index).min(target_index);
    let end = anchor_index.unwrap_or(target_index).max(target_index);
    for index in start..=end {
        if let Some(id) = state.tree.visible_row(index).map(|row| row.id.clone()) {
            state.selection.set_selected(id, true);
        }
    }
    state.selection.set_focused(Some(target));
    if state.selection.anchor().is_none() {
        state.selection.set_anchor(Some(anchor));
    }
}

fn repair_hidden_focus<Id: Clone + Eq + Hash + Debug + 'static, M: TreeModel<Id>>(
    state: &mut TreeViewState<Id>,
    model: &M,
) {
    let Some(focused) = state.selection.focused().cloned() else {
        return;
    };
    if state.tree.visible_index(&focused).is_some() {
        return;
    }

    let mut parent = model.parent(&focused);
    let mut visited = std::collections::HashSet::new();
    while let Some(id) = parent {
        if !visited.insert(id.clone()) {
            break;
        }
        if state.tree.visible_index(&id).is_some() {
            state.selection.set_focused(Some(id));
            return;
        }
        parent = model.parent(&id);
    }
}

fn cancel_hidden_editor<Id: Clone + Eq + Hash + Debug + 'static>(state: &mut TreeViewState<Id>) {
    if state
        .editing
        .as_ref()
        .is_some_and(|id| state.tree.visible_index(id).is_none())
    {
        state.edit_generation = state
            .edit_generation
            .checked_add(1)
            .expect("tree edit generation exhausted");
        state.editing = None;
        state.edit_subscription = None;
        state.rename_error = None;
        state.edit_pointer = None;
        state.focus_editor = false;
        state.editor_focus_registered_generation = None;
        state.restore_tree_focus_if_editor_owned = true;
    }
}

fn last_visible_descendant<Id: Clone + Eq + Hash + Debug + 'static, M: TreeModel<Id>>(
    tree: &TreeListState<Id>,
    model: &M,
    id: &Id,
) -> Option<Id> {
    let mut cursor = id.clone();
    let mut visited = std::collections::HashSet::new();
    while visited.insert(cursor.clone()) {
        let row = tree.visible_row(tree.visible_index(&cursor)?)?;
        let next = row.parent.as_ref().map_or_else(
            || model.root_at(row.index_in_parent + 1),
            |parent| model.child_at(parent, row.index_in_parent + 1),
        );
        if let Some(next) = next {
            let index = tree.visible_index(&next)?.checked_sub(1)?;
            return tree.visible_row(index).map(|row| row.id.clone());
        }
        if let Some(parent) = &row.parent {
            cursor = parent.clone();
        } else {
            return tree
                .visible_len()
                .checked_sub(1)
                .and_then(|index| tree.visible_row(index))
                .map(|row| row.id.clone());
        }
    }
    None
}
