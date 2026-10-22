//! Native projection is lazy; the acknowledged sheet remains the only GPUI tree.
//! Direct platform handlers transfer bounded owned commands, never UI borrows.
use super::{NativeError, NativeWindow, Wake};
use crate::runtime::SemanticState as State;
use crate::{Action, ActionKind, Error, Part, Role, Target, View, Win};
use accesskit::{ActionData, ActionRequest, Node, NodeId, TreeId, TreeInfo, TreeUpdate};
use accesskit_winit::Adapter;
use std::sync::{
    Arc,
    atomic::{AtomicBool, AtomicU64, Ordering},
    mpsc::{self, Receiver, SyncSender, TryRecvError, TrySendError},
};

mod text;
use text::Cohort;

const ROOT: NodeId = NodeId(0);
const CAPACITY: usize = 64;
const APPLY_BUDGET: usize = 16;
const MAX_VALUE_BYTES: usize = 64 * 1024;
type Applied = [Option<Result<crate::Commit, Error>>; APPLY_BUDGET];

enum Command {
    Activate(NodeId),
    Focus(NodeId),
    Blur(NodeId),
    SetValue(NodeId, Box<str>),
    SetTextSelection(NodeId, Box<accesskit::TextSelection>),
    ReplaceText(NodeId, Box<accesskit::TextReplacement>),
    ReplaceSelectedText(NodeId, Box<str>),
    Scroll(NodeId, crate::ScrollDirection, crate::ScrollUnit),
    ScrollTo(NodeId, crate::ScrollOffset),
    ScrollIntoView(NodeId),
}
struct Queued {
    session: u64,
    publication: u64,
    command: Command,
}
impl Command {
    fn operation<'a>(&'a self, cohort: &Cohort) -> Result<(NodeId, Action<'a>), Error> {
        Ok(match self {
            Self::Activate(id) => (*id, Action::Activate),
            Self::Focus(id) => (*id, Action::Focus),
            Self::Blur(id) => (*id, Action::Blur),
            Self::SetValue(id, value) => (*id, Action::SetValue(value)),
            Self::SetTextSelection(id, selection) => (
                *id,
                Action::SetTextSelection(
                    cohort
                        .selection(*id, **selection)
                        .ok_or(Error::InvalidSelection)?,
                ),
            ),
            Self::ReplaceText(id, replacement) => (
                *id,
                Action::ReplaceText {
                    selection: cohort
                        .selection(*id, replacement.selection)
                        .ok_or(Error::InvalidSelection)?,
                    value: &replacement.value,
                },
            ),
            Self::ReplaceSelectedText(id, value) => (*id, Action::ReplaceSelectedText(value)),
            Self::Scroll(id, direction, unit) => (
                *id,
                Action::Scroll {
                    direction: *direction,
                    unit: *unit,
                },
            ),
            Self::ScrollTo(id, offset) => (*id, Action::ScrollTo(*offset)),
            Self::ScrollIntoView(id) => (*id, Action::ScrollIntoView),
        })
    }
}

struct Shared {
    sender: SyncSender<Queued>,
    wake: Option<Wake>,
    closed: AtomicBool,
    overflow: AtomicBool,
    // Even = inactive, odd = active. This changes only across adapter lifecycle,
    // never on a new presentation; old live position-free targets remain valid.
    session: AtomicU64,
    initial: AtomicBool,
    publication: AtomicU64,
}
impl Shared {
    fn set_active(&self, active: bool) {
        if self
            .session
            .fetch_update(Ordering::AcqRel, Ordering::Acquire, |session| {
                if (session & 1 != 0) == active {
                    Some(session)
                } else {
                    session.checked_add(1)
                }
            })
            .is_err()
        {
            self.overload();
        }
    }
    fn signal(&self) {
        if let Some(wake) = &self.wake {
            wake.signal();
        }
    }
    fn overload(&self) {
        self.overflow.store(true, Ordering::Release);
        self.signal();
    }
}
#[derive(Clone)]
struct Ingress(Arc<Shared>);
impl Ingress {
    fn channel(wake: Option<Wake>) -> (Self, Receiver<Queued>) {
        let (sender, receiver) = mpsc::sync_channel(CAPACITY);
        (
            Self(Arc::new(Shared {
                sender,
                wake,
                closed: AtomicBool::new(false),
                overflow: AtomicBool::new(false),
                session: AtomicU64::new(0),
                initial: AtomicBool::new(false),
                publication: AtomicU64::new(0),
            })),
            receiver,
        )
    }
}
impl accesskit::ActivationHandler for Ingress {
    fn request_initial_tree(&mut self) -> Option<TreeUpdate> {
        if !self.0.closed.load(Ordering::Acquire) {
            self.0.set_active(true);
            self.0.initial.store(true, Ordering::Release);
            self.0.signal();
        }
        // The adapter supplies its own placeholder. Complete P follows on the
        // next owner turn, including activation while no redraw is requested.
        None
    }
}
impl accesskit::DeactivationHandler for Ingress {
    fn deactivate_accessibility(&mut self) {
        self.0.set_active(false);
        self.0.signal();
    }
}
impl accesskit::ActionHandler for Ingress {
    fn do_action(&mut self, request: ActionRequest) {
        let session = self.0.session.load(Ordering::Acquire);
        if self.0.closed.load(Ordering::Acquire)
            || session & 1 == 0
            || request.target_tree != TreeId::ROOT
        {
            return;
        }
        let id = request.target_node;
        let command = match (request.action, request.data) {
            (accesskit::Action::Click, None) => Command::Activate(id),
            (accesskit::Action::Focus, None) => Command::Focus(id),
            (accesskit::Action::Blur, None) => Command::Blur(id),
            (
                action @ (accesskit::Action::SetValue | accesskit::Action::ReplaceSelectedText),
                Some(ActionData::Value(value)),
            ) => {
                if value.len() > MAX_VALUE_BYTES {
                    self.0.overload();
                    return;
                }
                if action == accesskit::Action::SetValue {
                    Command::SetValue(id, value)
                } else {
                    Command::ReplaceSelectedText(id, value)
                }
            }
            (
                accesskit::Action::SetTextSelection,
                Some(ActionData::SetTextSelection(selection)),
            ) => Command::SetTextSelection(id, Box::new(selection)),
            (
                accesskit::Action::ReplaceSelectedText,
                Some(ActionData::ReplaceText(replacement)),
            ) => {
                if replacement.value.len() > MAX_VALUE_BYTES {
                    self.0.overload();
                    return;
                }
                Command::ReplaceText(id, replacement)
            }
            (accesskit::Action::ScrollIntoView, None | Some(ActionData::ScrollHint(_))) => {
                Command::ScrollIntoView(id)
            }
            (accesskit::Action::SetScrollOffset, Some(ActionData::SetScrollOffset(point))) => {
                if !point.x.is_finite() || !point.y.is_finite() {
                    return;
                }
                Command::ScrollTo(
                    id,
                    crate::ScrollOffset {
                        x: point.x,
                        y: point.y,
                    },
                )
            }
            (
                action @ (accesskit::Action::ScrollUp
                | accesskit::Action::ScrollDown
                | accesskit::Action::ScrollLeft
                | accesskit::Action::ScrollRight),
                data,
            ) => {
                let unit = match data {
                    None | Some(ActionData::ScrollUnit(accesskit::ScrollUnit::Page)) => {
                        crate::ScrollUnit::Page
                    }
                    Some(ActionData::ScrollUnit(accesskit::ScrollUnit::Item)) => {
                        crate::ScrollUnit::Item
                    }
                    _ => return,
                };
                let direction = match action {
                    accesskit::Action::ScrollUp => crate::ScrollDirection::Up,
                    accesskit::Action::ScrollDown => crate::ScrollDirection::Down,
                    accesskit::Action::ScrollLeft => crate::ScrollDirection::Left,
                    accesskit::Action::ScrollRight => crate::ScrollDirection::Right,
                    _ => unreachable!(),
                };
                Command::Scroll(id, direction, unit)
            }
            // Unadvertised operations have no effect. Selection/IME and native
            // virtual-item realization need additional runtime authority.
            _ => return,
        };
        match self.0.sender.try_send(Queued {
            session,
            publication: self.0.publication.load(Ordering::Acquire),
            command,
        }) {
            Ok(()) => self.0.signal(),
            Err(TrySendError::Full(_)) => self.0.overload(),
            Err(TrySendError::Disconnected(_)) => {}
        }
    }
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum Refresh {
    Sparse,
    Immediate,
    // P was publishable but its source actions were not qualified. Preserve
    // no-work idle; the next actual stamp transition must rediscover authority,
    // even when its exact semantic frontier is empty after same-byte repair.
    AfterTransition,
}
impl Refresh {
    fn published(qualified: bool) -> Self {
        if qualified {
            Self::Sparse
        } else {
            Self::AfterTransition
        }
    }
}
pub(super) struct Bridge {
    adapter: Adapter,
    receiver: Receiver<Queued>,
    ingress: Ingress,
    published: Option<State>,
    refresh: Refresh,
    title: String,
    cohort: Cohort,
    #[cfg(test)]
    conversions: usize,
}
impl Drop for Bridge {
    fn drop(&mut self) {
        // Late callbacks see revocation before adapter/receiver/owner teardown.
        self.ingress.0.closed.store(true, Ordering::Release);
    }
}
impl Bridge {
    pub(super) fn new(
        event_loop: &super::ActiveEventLoop,
        window: &NativeWindow,
        wake: Wake,
        title: String,
    ) -> Self {
        let (ingress, receiver) = Ingress::channel(Some(wake));
        let adapter = Adapter::with_direct_handlers(
            event_loop,
            window,
            ingress.clone(),
            ingress.clone(),
            ingress.clone(),
        );
        Self {
            adapter,
            receiver,
            ingress,
            published: None,
            refresh: Refresh::Immediate,
            // Winit's X11 title() is an empty-string stub, so use the authored
            // opening title rather than querying it back from the platform.
            title,
            cohort: Cohort::default(),
            #[cfg(test)]
            conversions: 0,
        }
    }
    pub(super) fn process_event(&mut self, window: &NativeWindow, event: &super::WindowEvent) {
        self.adapter.process_event(window, event);
    }
    pub(super) fn drain<M: View + 'static, L: crate::remote::LaneSet<M>>(
        &mut self,
        owner: &mut Win<M, L>,
    ) -> Result<Applied, NativeError> {
        drain_actions(&self.ingress, &self.receiver, &self.cohort, owner)
    }
    pub(super) fn sync<M: View + 'static, L: crate::remote::LaneSet<M>>(
        &mut self,
        owner: &mut Win<M, L>,
    ) -> Result<(), NativeError> {
        let active = self.ingress.0.session.load(Ordering::Acquire) & 1 != 0;
        owner.accessibility_observe(active)?;
        if !active {
            self.cohort.clear();
            self.refresh = Refresh::Immediate;
            return Ok(());
        }
        let state = owner.accessibility_state()?;
        if !state.valid {
            return Ok(());
        }
        if self.ingress.0.initial.swap(false, Ordering::AcqRel) {
            self.refresh = Refresh::Immediate;
        }
        let full = self.refresh == Refresh::Immediate
            || self.published.is_none_or(|old| {
                old.token != state.token || old.epoch != state.epoch || old.size != state.size
            });
        if !full && self.published.is_some_and(|old| old.focus == state.focus) {
            return Ok(());
        }
        let delta = (full && self.refresh == Refresh::Sparse)
            .then(|| {
                self.published
                    .and_then(|old| owner.accessibility_delta(old, state))
            })
            .flatten();
        let relink = if let Some(indices) = delta {
            self.cohort.update_delta(owner, indices)?
        } else {
            if full {
                self.cohort.refresh(owner)?;
            }
            text::Relink::default()
        };
        let qualified = if delta.is_some() {
            relink.qualified
        } else if full {
            self.cohort.qualified()
        } else {
            self.refresh == Refresh::Sparse
        };
        let sheet = owner.accessibility_sheet()?;
        let mut updated = false;
        self.adapter.update_if_active(|| {
            let update = if let Some(indices) = delta.filter(|_| !relink.root) {
                project_sparse(&sheet, indices, &relink.parents, &self.cohort)
            } else if full {
                project(&sheet, state, &self.title, &self.cohort)
            } else {
                focus_update(&sheet, &self.cohort)
            };
            #[cfg(test)]
            {
                self.conversions += update.nodes.len();
            }
            updated = true;
            update
        });
        if updated {
            if self
                .ingress
                .0
                .publication
                .fetch_update(Ordering::AcqRel, Ordering::Acquire, |n| n.checked_add(1))
                .is_err()
            {
                self.ingress.0.overload();
                return Err(NativeError::AccessibilityOverloaded);
            }
            self.published = Some(state);
            self.refresh = Refresh::published(qualified);
        }
        Ok(())
    }
}

fn drain_actions<M: View + 'static, L: crate::remote::LaneSet<M>>(
    ingress: &Ingress,
    receiver: &Receiver<Queued>,
    cohort: &Cohort,
    owner: &mut Win<M, L>,
) -> Result<Applied, NativeError> {
    if ingress.0.overflow.load(Ordering::Acquire) {
        ingress.0.closed.store(true, Ordering::Release);
        return Err(NativeError::AccessibilityOverloaded);
    }
    let mut results = std::array::from_fn(|_| None);
    for result in &mut results {
        let queued = match receiver.try_recv() {
            Ok(command) => command,
            Err(TryRecvError::Empty | TryRecvError::Disconnected) => return Ok(results),
        };
        if queued.session != ingress.0.session.load(Ordering::Acquire) {
            continue;
        }
        *result = Some((|| {
            let (id, action) = queued.command.operation(cohort)?;
            if id.0 >= (1 << 63)
                && queued.publication != ingress.0.publication.load(Ordering::Acquire)
            {
                return Err(Error::StaleTarget);
            }
            let target = cohort.target(owner, id)?;
            let action = local_scroll_action(owner, target, action)?;
            owner.perform(target, action)
        })());
    }
    ingress.0.signal();
    Ok(results)
}

// AccessKit nodes have flat window-physical bounds and no transform. Offset
// properties and native offset actions therefore use signed physical
// displacements; translation cancels. The public Win ports stay local logical.
fn scroll_basis(part: Part<'_>) -> Option<[f64; 2]> {
    let map = part.transform()?;
    (map.b == 0.0 && map.c == 0.0 && map.a != 0.0 && map.d != 0.0)
        .then_some([f64::from(map.a), f64::from(map.d)])
}
fn local_scroll_action<'a, M: View + 'static, L: crate::remote::LaneSet<M>>(
    owner: &Win<M, L>,
    target: Target,
    action: Action<'a>,
) -> Result<Action<'a>, Error> {
    if !matches!(action, Action::Scroll { .. } | Action::ScrollTo(_)) {
        return Ok(action);
    }
    let map = owner.accessibility_viewport_transform(target)?;
    // Admission rejects non-diagonal viewports before P publication.
    let [x, y] = [f64::from(map.a), f64::from(map.d)];
    Ok(match action {
        Action::ScrollTo(offset) => Action::ScrollTo(crate::ScrollOffset {
            x: offset.x / x,
            y: offset.y / y,
        }),
        Action::Scroll { direction, unit } => Action::Scroll {
            direction: match direction {
                crate::ScrollDirection::Up if y < 0.0 => crate::ScrollDirection::Down,
                crate::ScrollDirection::Down if y < 0.0 => crate::ScrollDirection::Up,
                crate::ScrollDirection::Left if x < 0.0 => crate::ScrollDirection::Right,
                crate::ScrollDirection::Right if x < 0.0 => crate::ScrollDirection::Left,
                direction => direction,
            },
            unit,
        },
        _ => unreachable!("scroll-only conversion"),
    })
}

fn projected_node(part: Part<'_>) -> Node {
    let role = match part.role() {
        Role::Generic if part.actions().contains(ActionKind::Activate) => accesskit::Role::Button,
        Role::Generic if part.name().is_some() || part.description().is_some() => {
            accesskit::Role::Group
        }
        Role::Generic => accesskit::Role::GenericContainer,
        Role::Text if renamed_text(part) => accesskit::Role::Group,
        Role::Text => accesskit::Role::Label,
        Role::TextInput => accesskit::Role::TextInput,
        Role::Button => accesskit::Role::Button,
        Role::List => accesskit::Role::List,
        Role::ListItem => accesskit::Role::ListItem,
        Role::Image => accesskit::Role::Image,
        Role::ScrollView => accesskit::Role::ScrollView,
    };
    let mut node = Node::new(role);
    if role == accesskit::Role::Label {
        // Native Label names come from value; an overridden name needs the
        // separate Group + Label child below to preserve actual text content.
        if let Some(value) = part.text() {
            node.set_value(value);
        }
    } else if let Some(name) = part.name() {
        node.set_label(name);
    }
    if let Some(value) = part.value() {
        node.set_value(value);
    }
    if let Some(description) = part.description() {
        node.set_description(description);
    }
    if let Some(list) = part.list() {
        node.set_size_of_set(
            usize::try_from(list.count).expect("u32 fits usize on native platforms"),
        );
    }
    if let Some(item) = part.list_item() {
        // AccessKit uses ZERO-based indices and puts size_of_set on the
        // container. Its native adapters translate to platform conventions.
        node.set_position_in_set(
            usize::try_from(item.index).expect("u32 fits usize on native platforms"),
        );
    }
    if let Some(bounds) = part.unclipped_bounds() {
        node.set_bounds(accesskit::Rect {
            x0: f64::from(bounds.x),
            y0: f64::from(bounds.y),
            x1: f64::from(bounds.x) + f64::from(bounds.width),
            y1: f64::from(bounds.y) + f64::from(bounds.height),
        });
    }
    if matches!(part.role(), Role::List | Role::ListItem | Role::ScrollView) {
        node.set_clips_children();
    }
    if let (Some(viewport), Some([x, y])) = (part.viewport(), scroll_basis(part)) {
        node.set_scroll_x(viewport.offset.x * x);
        node.set_scroll_y(viewport.offset.y * y);
        let xr = [viewport.min.x * x, viewport.max.x * x];
        let yr = [viewport.min.y * y, viewport.max.y * y];
        node.set_scroll_x_min(xr[0].min(xr[1]));
        node.set_scroll_x_max(xr[0].max(xr[1]));
        node.set_scroll_y_min(yr[0].min(yr[1]));
        node.set_scroll_y_max(yr[0].max(yr[1]));
        node.add_action(accesskit::Action::SetScrollOffset);
        if viewport.axes.x() {
            node.add_action(accesskit::Action::ScrollLeft);
            node.add_action(accesskit::Action::ScrollRight);
        }
        if viewport.axes.y() {
            node.add_action(accesskit::Action::ScrollUp);
            node.add_action(accesskit::Action::ScrollDown);
        }
    }
    for action in part.actions().iter() {
        node.add_action(match action {
            ActionKind::Scroll => continue,
            ActionKind::ScrollIntoView => accesskit::Action::ScrollIntoView,
            ActionKind::Activate => accesskit::Action::Click,
            ActionKind::Focus => accesskit::Action::Focus,
            ActionKind::Blur => accesskit::Action::Blur,
            ActionKind::SetValue => accesskit::Action::SetValue,
            // Native range actions require a source-qualified TextRun cohort;
            // they are enabled by that projection, never by a bare action bit.
            ActionKind::SetTextSelection | ActionKind::ReplaceSelectedText => continue,
        });
    }
    node
}

fn focus_update(sheet: &crate::runtime::SemanticSheet<'_>, cohort: &Cohort) -> TreeUpdate {
    let mut focus = ROOT;
    sheet.visit(|part| {
        if part.focused() {
            focus = cohort.id(part);
        }
    });
    TreeUpdate {
        nodes: Vec::new(),
        tree: None,
        tree_id: TreeId::ROOT,
        focus,
    }
}

fn project(
    sheet: &crate::runtime::SemanticSheet<'_>,
    state: State,
    title: &str,
    cohort: &Cohort,
) -> TreeUpdate {
    let mut root = Node::new(accesskit::Role::Window);
    root.set_label(title);
    root.set_clips_children();
    root.set_bounds(accesskit::Rect {
        x0: 0.0,
        y0: 0.0,
        x1: f64::from(state.size[0]),
        y1: f64::from(state.size[1]),
    });
    // Count from the SAME immutable sheet before allocating native node output.
    // This extra read pass avoids geometric Vec overreserve and copies, including
    // a lone input/renamed-label child at the end of a large ordinary tree.
    let mut count = 1 + sheet.len();
    sheet.visit(|part| {
        count += cohort.text_count(part);
    });
    let mut nodes = Vec::with_capacity(count);
    nodes.push((ROOT, root));
    // Only a transient ancestor stack. AccessKit retains its required tree;
    // GPUI retains no second node cache, child lists, ID map, or diff mirror.
    let mut ancestors: Vec<(Target, usize)> = Vec::new();
    let mut focus = ROOT;
    sheet.visit(|part| {
        while ancestors.last().map(|&(target, _)| target) != part.parent() {
            ancestors.pop();
        }
        let parent = ancestors.last().map_or(0, |&(_, index)| index);
        let id = cohort.id(part);
        nodes[parent].1.push_child(id);
        if part.focused() {
            focus = id;
        }
        let mut node = projected_node(part);
        cohort.append(part, &mut node, &mut nodes);
        ancestors.push((part.target(), nodes.len()));
        nodes.push((id, node));
    });
    let mut tree = TreeInfo::new(ROOT);
    tree.toolkit_name = Some("GPUI".into());
    tree.toolkit_version = Some(env!("CARGO_PKG_VERSION").into());
    TreeUpdate {
        nodes,
        tree: Some(tree),
        tree_id: TreeId::ROOT,
        focus,
    }
}

fn projected_text(part: Part<'_>, node: &Node) -> Option<Node> {
    if renamed_text(part) {
        let mut label = Node::new(accesskit::Role::Label);
        if let Some(text) = part.text() {
            label.set_value(text);
        }
        if let Some(bounds) = node.bounds() {
            label.set_bounds(bounds);
        }
        Some(label)
    } else {
        None
    }
}

fn project_sparse(
    sheet: &crate::runtime::SemanticSheet<'_>,
    indices: &[u32],
    parents: &[u32],
    cohort: &Cohort,
) -> TreeUpdate {
    // Both frontiers are sorted/unique. Parents only relink changed native IDs;
    // do not duplicate an existing replacement or clone unchanged input leases.
    let selected = indices
        .iter()
        .chain(
            parents
                .iter()
                .filter(|&&index| indices.binary_search(&index).is_err()),
        )
        .copied();
    let count = selected
        .clone()
        .map(|index| {
            let part = sheet
                .part_at(index as usize)
                .expect("exact transition P index");
            1 + cohort.text_count(part)
        })
        .sum();
    let mut update = focus_update(sheet, cohort);
    update.nodes = Vec::with_capacity(count);
    for index in selected {
        let part = sheet
            .part_at(index as usize)
            .expect("exact transition P index");
        let id = cohort.id(part);
        let mut node = projected_node(part);
        cohort.append(part, &mut node, &mut update.nodes);
        for child in sheet.children(index as usize) {
            node.push_child(cohort.id(child));
        }
        update.nodes.push((id, node));
    }
    update
}

fn renamed_text(part: Part<'_>) -> bool {
    part.role() == Role::Text && part.name() != part.text()
}

#[cfg(all(test, feature = "x11", target_os = "linux"))]
mod linux_tests;
#[cfg(test)]
mod tests;

#[cfg(test)]
mod selection_tests;
#[cfg(test)]
mod transitions;
