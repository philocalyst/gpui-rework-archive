//! Semantic actions use the ordinary input/source barrier. Their advertised
//! availability is frozen with the acknowledged sheet, not read from ahead-of-
//! frame model state. No separate mutable accessibility tree is retained.
use super::{Commit, Error, NodeKind, View, Win};
use crate::{Target, remote::LaneSet};

#[derive(Clone, Copy, Debug, PartialEq, Eq, serde::Serialize)]
pub enum ActionKind {
    Activate = 1,
    Focus = 2,
    Blur = 4,
    SetValue = 8,
    Scroll = 16,
    ScrollIntoView = 32,
    SetTextSelection = 64,
    ReplaceSelectedText = 128,
}

/// Owned routing identity and borrowed data; no platform callback can retain a
/// borrow of the model. A platform bridge must move an owned message to the UI
/// owner before invoking this operation.
#[derive(Clone, Copy, Debug, PartialEq)]
pub enum Action<'a> {
    Activate,
    Focus,
    Blur,
    SetValue(&'a str),
    /// UTF-8 grapheme endpoints in the current input source.
    SetTextSelection(gpui_canvas::TextSelection),
    ReplaceSelectedText(&'a str),
    /// One explicit current-source range edit, using the ordinary replace path.
    ReplaceText {
        selection: gpui_canvas::TextSelection,
        value: &'a str,
    },
    Scroll {
        direction: crate::ScrollDirection,
        unit: crate::ScrollUnit,
    },
    ScrollTo(crate::ScrollOffset),
    ScrollIntoView,
}
impl Action<'_> {
    pub const fn kind(self) -> ActionKind {
        match self {
            Self::Activate => ActionKind::Activate,
            Self::Focus => ActionKind::Focus,
            Self::Blur => ActionKind::Blur,
            Self::SetValue(_) => ActionKind::SetValue,
            Self::SetTextSelection(_) => ActionKind::SetTextSelection,
            Self::ReplaceSelectedText(_) | Self::ReplaceText { .. } => {
                ActionKind::ReplaceSelectedText
            }
            Self::Scroll { .. } | Self::ScrollTo(_) => ActionKind::Scroll,
            Self::ScrollIntoView => ActionKind::ScrollIntoView,
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
            ActionKind::Scroll,
            ActionKind::ScrollIntoView,
            ActionKind::SetTextSelection,
            ActionKind::ReplaceSelectedText,
        ]
        .into_iter()
        .filter(move |&kind| self.contains(kind))
    }
    pub(super) fn scroll_into_view(mut self, enabled: bool) -> Self {
        if enabled {
            self.0 |= ActionKind::ScrollIntoView as u8;
        }
        self
    }
    pub(super) fn for_node(kind: NodeKind, handler: bool) -> Self {
        let focus = matches!(kind, NodeKind::Input | NodeKind::Button) || handler;
        let activation = u8::from(handler && kind != NodeKind::Input) * ActionKind::Activate as u8;
        let navigation = u8::from(focus) * (ActionKind::Focus as u8 | ActionKind::Blur as u8);
        let value = u8::from(kind == NodeKind::Input)
            * (ActionKind::SetValue as u8
                | ActionKind::SetTextSelection as u8
                | ActionKind::ReplaceSelectedText as u8);
        Self(
            activation
                | navigation
                | value
                | (u8::from(matches!(kind, NodeKind::List | NodeKind::Scroll))
                    * ActionKind::Scroll as u8),
        )
    }
}

impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Perform an advertised semantic action through the production input path.
    /// Position-free edits can repair a failed presentation while the preceding
    /// sheet remains valid. Removed, foreign and quarantined targets cannot act.
    pub fn perform(&mut self, target: Target, action: Action<'_>) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
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
            Action::Scroll { direction, unit } => {
                runtime.current_presentation()?;
                let viewport = runtime
                    .metadata
                    .as_ref()
                    .and_then(|metadata| metadata.presented.viewport(identity, &runtime.presented))
                    .ok_or(crate::ScrollError::NotViewport)?;
                let (axis, sign, enabled) = match direction {
                    crate::ScrollDirection::Left => (0, -1.0, viewport.axes.x()),
                    crate::ScrollDirection::Right => (0, 1.0, viewport.axes.x()),
                    crate::ScrollDirection::Up => (1, -1.0, viewport.axes.y()),
                    crate::ScrollDirection::Down => (1, 1.0, viewport.axes.y()),
                };
                if !enabled {
                    return Err(Error::NotInteractive);
                }
                let step = match unit {
                    crate::ScrollUnit::Page => viewport.size[axis],
                    crate::ScrollUnit::Item if axis == 1 => runtime
                        .metadata
                        .as_ref()
                        .and_then(|metadata| metadata.presented.list(identity))
                        .and_then(|list| {
                            runtime
                                .list_by_id(list.id)
                                .map(|(_, state)| state.viewport.row_height)
                        })
                        .unwrap_or(32.0),
                    crate::ScrollUnit::Item => 32.0,
                };
                let mut delta = [0.0; 2];
                delta[axis] = sign * step;
                drop(runtime);
                self.scroll_by(
                    target,
                    crate::ScrollDelta {
                        x: delta[0],
                        y: delta[1],
                    },
                )
            }
            Action::ScrollTo(offset) => {
                drop(runtime);
                self.scroll_to(target, offset)
            }
            Action::ScrollIntoView => {
                drop(runtime);
                self.scroll_into_view(target)
            }
            Action::Activate => runtime.activate(target),
            Action::Focus => {
                drop(runtime);
                self.focus(target)
            }
            Action::Blur => {
                if runtime.focused == Some(target) {
                    drop(runtime);
                    return self.clear_focus();
                }
                runtime.changed_nodes = 0;
                Ok(runtime.commit())
            }
            Action::SetValue(value) => runtime.set_input_value(target, value),
            Action::SetTextSelection(selection) => {
                runtime.current_presentation()?;
                runtime.select_input(target, selection)
            }
            Action::ReplaceSelectedText(value) => {
                runtime.current_presentation()?;
                runtime.replace_input(target, None, value)
            }
            Action::ReplaceText { selection, value } => {
                runtime.current_presentation()?;
                runtime.replace_input(target, Some(selection), value)
            }
        }
    }
}
