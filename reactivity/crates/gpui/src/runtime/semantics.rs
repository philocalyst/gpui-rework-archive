//! Semantic actions use the ordinary input/source barrier. Their advertised
//! availability is frozen with the acknowledged sheet, not read from ahead-of-
//! frame model state. No separate mutable accessibility tree is retained.
use super::{Commit, Error, NodeKind, View, Win};
use crate::Target;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ActionKind {
    Activate = 1,
    Focus = 2,
    Blur = 4,
    SetValue = 8,
}

/// Owned routing identity and borrowed data; no platform callback can retain a
/// borrow of the model. A platform bridge must move an owned message to the UI
/// owner before invoking this operation.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Action<'a> {
    Activate,
    Focus,
    Blur,
    SetValue(&'a str),
}
impl Action<'_> {
    pub const fn kind(self) -> ActionKind {
        match self {
            Self::Activate => ActionKind::Activate,
            Self::Focus => ActionKind::Focus,
            Self::Blur => ActionKind::Blur,
            Self::SetValue(_) => ActionKind::SetValue,
        }
    }
}

/// The actions advertised by one complete presentation. One byte, with no
/// heap allocation or independently maintained handler registry.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Actions(u8);
impl Actions {
    pub const fn contains(self, kind: ActionKind) -> bool {
        self.0 & kind as u8 != 0
    }
    pub fn iter(self) -> impl Iterator<Item = ActionKind> {
        [
            ActionKind::Activate,
            ActionKind::Focus,
            ActionKind::Blur,
            ActionKind::SetValue,
        ]
        .into_iter()
        .filter(move |&kind| self.contains(kind))
    }
    pub(super) fn for_node(kind: NodeKind, handler: bool) -> Self {
        let focus = matches!(kind, NodeKind::Input | NodeKind::Button) || handler;
        let activation = u8::from(handler && kind != NodeKind::Input) * ActionKind::Activate as u8;
        let navigation = u8::from(focus) * (ActionKind::Focus as u8 | ActionKind::Blur as u8);
        let value = u8::from(kind == NodeKind::Input) * ActionKind::SetValue as u8;
        Self(activation | navigation | value)
    }
}

impl<M: View + 'static> Win<M> {
    /// Perform an advertised semantic action through the production input path.
    /// Position-free edits can repair a failed presentation while the preceding
    /// sheet remains valid. Removed, foreign and quarantined targets cannot act.
    pub fn perform(&mut self, target: Target, action: Action<'_>) -> Result<Commit, Error> {
        let runtime = self.runtime_mut()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        if !runtime.presentation_valid {
            return Err(Error::PresentationStale);
        }
        let node = runtime
            .presented
            .iter()
            .find(|node| node.identity == identity)
            .ok_or(Error::StaleTarget)?;
        if !node.actions.contains(action.kind()) {
            return Err(Error::NotInteractive);
        }
        match action {
            Action::Activate => runtime.activate(target),
            Action::Focus => runtime.focus(target),
            Action::Blur => {
                if runtime.focused == Some(target) {
                    runtime.focused = None;
                }
                runtime.changed_nodes = 0;
                Ok(runtime.commit())
            }
            Action::SetValue(value) => runtime.edit_text(target, |text| {
                text.clear();
                text.push_str(value);
            }),
        }
    }
}
