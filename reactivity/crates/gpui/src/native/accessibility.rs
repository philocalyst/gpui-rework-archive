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
}
struct Queued {
    session: u64,
    command: Command,
}
impl Command {
    fn operation(&self) -> (NodeId, Action<'_>) {
        match self {
            Self::Activate(id) => (*id, Action::Activate),
            Self::Focus(id) => (*id, Action::Focus),
            Self::Blur(id) => (*id, Action::Blur),
            Self::SetValue(id, value) => (*id, Action::SetValue(value)),
        }
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
            (accesskit::Action::SetValue, Some(ActionData::Value(value))) => {
                if value.len() > MAX_VALUE_BYTES {
                    self.0.overload();
                    return;
                }
                Command::SetValue(id, value)
            }
            // Unadvertised operations have no effect. Selection/IME and native
            // virtual-item realization need additional runtime authority.
            _ => return,
        };
        match self.0.sender.try_send(Queued { session, command }) {
            Ok(()) => self.0.signal(),
            Err(TrySendError::Full(_)) => self.0.overload(),
            Err(TrySendError::Disconnected(_)) => {}
        }
    }
}

pub(super) struct Bridge {
    adapter: Adapter,
    receiver: Receiver<Queued>,
    ingress: Ingress,
    published: Option<State>,
    needs_full: bool,
    title: String,
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
            needs_full: true,
            // Winit's X11 title() is an empty-string stub, so use the authored
            // opening title rather than querying it back from the platform.
            title,
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
        drain_actions(&self.ingress, &self.receiver, owner)
    }
    pub(super) fn sync<M: View + 'static, L: crate::remote::LaneSet<M>>(
        &mut self,
        owner: &Win<M, L>,
    ) -> Result<(), NativeError> {
        let mut state = owner.accessibility_state()?;
        if !state.valid {
            return Ok(());
        }
        if self.ingress.0.initial.swap(false, Ordering::AcqRel) {
            self.needs_full = true;
        }
        // Pending candidate geometry must not replace the cursor for old P.
        if state.token.is_none() {
            state.token = self.published.and_then(|old| old.token);
        }
        let full = self.needs_full
            || self.published.is_none_or(|old| {
                old.token != state.token || old.epoch != state.epoch || old.size != state.size
            });
        if !full && self.published.is_some_and(|old| old.focus == state.focus) {
            return Ok(());
        }
        let sheet = owner.accessibility_sheet()?;
        let mut updated = false;
        self.adapter.update_if_active(|| {
            let update = if full {
                project(&sheet, state, &self.title)
            } else {
                focus_update(&sheet)
            };
            #[cfg(test)]
            {
                self.conversions += update.nodes.len();
            }
            updated = true;
            update
        });
        if updated {
            self.published = Some(state);
            self.needs_full = false;
        }
        Ok(())
    }
}

fn drain_actions<M: View + 'static, L: crate::remote::LaneSet<M>>(
    ingress: &Ingress,
    receiver: &Receiver<Queued>,
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
        let (id, action) = queued.command.operation();
        *result = Some(if id.0 == 0 || id.0 & 1 != 0 {
            Err(Error::StaleTarget)
        } else {
            owner
                .accessibility_target(id.0 / 2)
                .and_then(|target| owner.perform(target, action))
        });
    }
    ingress.0.signal();
    Ok(results)
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
    if matches!(part.role(), Role::List | Role::ListItem) {
        node.set_clips_children();
    }
    for action in part.actions().iter() {
        node.add_action(match action {
            ActionKind::Activate => accesskit::Action::Click,
            ActionKind::Focus => accesskit::Action::Focus,
            ActionKind::Blur => accesskit::Action::Blur,
            ActionKind::SetValue => accesskit::Action::SetValue,
        });
    }
    node
}

fn focus_update(sheet: &crate::runtime::SemanticSheet<'_>) -> TreeUpdate {
    let mut focus = ROOT;
    sheet.visit(|part| {
        if part.focused() {
            focus = NodeId(part.native_id() * 2);
        }
    });
    TreeUpdate {
        nodes: Vec::new(),
        tree: None,
        tree_id: TreeId::ROOT,
        focus,
    }
}

fn project(sheet: &crate::runtime::SemanticSheet<'_>, state: State, title: &str) -> TreeUpdate {
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
    let mut count = 1;
    sheet.visit(|part| {
        count += 1 + usize::from(part.value().is_some() || renamed_text(part));
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
        let id = NodeId(part.native_id() * 2);
        nodes[parent].1.push_child(id);
        if part.focused() {
            focus = id;
        }
        ancestors.push((part.target(), nodes.len()));
        let mut node = projected_node(part);
        let text = if renamed_text(part) {
            let mut label = Node::new(accesskit::Role::Label);
            if let Some(text) = part.text() {
                label.set_value(text);
            }
            if let Some(bounds) = node.bounds() {
                label.set_bounds(bounds);
            }
            Some(label)
        } else {
            part.value().map(text_run)
        };
        let text = text.map(|text| {
            let text_id = NodeId(id.0 + 1);
            node.push_child(text_id);
            (text_id, text)
        });
        nodes.push((id, node));
        if let Some(text) = text {
            nodes.push(text);
        }
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

fn renamed_text(part: Part<'_>) -> bool {
    part.role() == Role::Text && part.name() != part.text()
}

fn text_run(value: &str) -> Node {
    let mut node = Node::new(accesskit::Role::TextRun);
    node.set_value(value);
    // The editor currently uses scalars, not graphemes. AccessKit additionally
    // requires a CRLF line ending to be one character with two UTF-8 bytes.
    // This supplies text boundaries, never glyph metrics or selection support.
    let mut chars = value.chars();
    node.set_character_lengths(
        std::iter::from_fn(|| {
            let c = chars.next()?;
            Some(if c == '\r' && chars.as_str().starts_with('\n') {
                chars.next();
                2
            } else {
                c.len_utf8() as u8
            })
        })
        .collect::<Vec<_>>(),
    );
    node
}

#[cfg(all(test, feature = "x11", target_os = "linux"))]
mod linux_tests;
#[cfg(test)]
mod tests;
