//! Focus and normalized input belong to the ordinary exclusive window runtime.
use super::{Commit, Error, NodeKind, Runtime, Target, View, Win};
use crate::remote::LaneSet;
use crate::{Point, ScrollDelta};

/// One portable mouse stream. Points are physical window coordinates; wheel
/// displacement is window-logical, with positive values scrolling right/down.
/// Native adapters normalize platform units before entering this same path.
/// This floor does not model touch, capture, multiple devices or drag gestures.
#[derive(Clone, Copy, Debug, PartialEq)]
pub enum PointerEvent {
    Move(Point),
    Leave,
    Press,
    Release,
    Wheel(ScrollDelta),
    Cancel,
}

/// Caller-owned state for one mouse stream, without an allocation or an owner
/// reference. A press retains only a window-qualified target; release performs
/// a fresh acknowledged-sheet hit test. Moving a session to another window
/// cannot transfer that press's authority.
#[derive(Debug, Default)]
pub struct PointerSession {
    position: Option<Point>,
    pressed: Option<Target>,
}
impl PointerSession {
    pub fn position(&self) -> Option<Point> {
        self.position
    }

    /// Cancel a gesture while keeping the last position. This does not change
    /// keyboard focus or source state. Replace the session with its default
    /// when window movement, resize or suspension invalidates its coordinates.
    pub fn cancel(&mut self) {
        self.pressed = None;
    }
}

/// Committed text and a small portable key floor. Text inserts at the end and
/// backspace removes one Unicode scalar. Selection, IME and shortcuts are not
/// represented by this enum.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Key<'a> {
    /// Committed printable text; payloads containing control characters are ignored.
    Text(&'a str),
    Backspace,
    Tab,
    ReverseTab,
    Enter,
    Space,
}

impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Dispatch the same normalized mouse protocol as the native host. A press
    /// focuses its hit control; only release over that same live target invokes
    /// it. Leave, wheel, explicit cancellation and failed press/release consume
    /// the gesture. A rejected stale release cannot be retried after a new
    /// presentation. A fresh hit on a newer acknowledged sheet may activate
    /// the same surviving target.
    ///
    /// Moving, cancellation and an unpaired release need no hit test. They do
    /// not prepare a frame; the returned commit can still report an already
    /// outstanding frame. Nonfinite positions behave as leaving the window.
    pub fn pointer_event(
        &mut self,
        session: &mut PointerSession,
        event: PointerEvent,
    ) -> Result<Commit, Error> {
        // Consume first, including on a closed/poisoned owner or failed hit.
        // A failed release must never be replayable against a newer sheet.
        let pressed = if matches!(event, PointerEvent::Move(_)) {
            None
        } else {
            session.pressed.take()
        };
        match event {
            PointerEvent::Move(point) => {
                session.position = (point.x.is_finite() && point.y.is_finite()).then_some(point);
                if session.position.is_none() {
                    session.cancel();
                }
            }
            PointerEvent::Leave => session.position = None,
            PointerEvent::Wheel(delta) => {
                if let Some(point) = session.position {
                    return self.scroll_at_2d(point, delta);
                }
            }
            PointerEvent::Press | PointerEvent::Release | PointerEvent::Cancel => {}
        }
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.changed_nodes = 0;
        if !matches!(event, PointerEvent::Press)
            && !(matches!(event, PointerEvent::Release) && pressed.is_some())
        {
            return Ok(runtime.commit());
        }
        runtime.current_presentation()?;
        let hit = session
            .position
            .and_then(|point| runtime.hit(point))
            .map(|identity| runtime.sites.target(identity));
        if matches!(event, PointerEvent::Press) {
            if let Some(target) = hit {
                runtime.focus(target)?;
            } else {
                runtime.focused = None;
            }
            session.pressed = hit;
        } else if let Some(target) = pressed.filter(|target| Some(*target) == hit) {
            return runtime.activate(target);
        }
        Ok(runtime.commit())
    }

    /// Focus a live logical control without using displayed coordinates. This
    /// remains available to repair text after a failed presentation.
    pub fn focus(&mut self, target: Target) -> Result<Commit, Error> {
        self.runtime_mut()?.focus(target)
    }
    pub fn clear_focus(&mut self) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.focused = None;
        runtime.changed_nodes = 0;
        Ok(runtime.commit())
    }
    /// A removed control or quarantined owner has no focus. Reading focus does
    /// not mutate source state, mint an identity, or require a current frame.
    pub fn focused(&self) -> Result<Option<Target>, Error> {
        Ok(self.runtime()?.focused)
    }
    /// Use the same keyboard barrier as the native adapter. Tab requires current
    /// presented geometry; focused editing and activation use logical authority.
    pub fn key(&mut self, key: Key<'_>) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.changed_nodes = 0;
        if matches!(key, Key::Tab | Key::ReverseTab) {
            let previous = runtime.focused;
            let commit = runtime.tab(matches!(key, Key::ReverseTab))?;
            let focused = runtime.focused;
            let identity = focused.and_then(|target| runtime.resolve(target).ok());
            let reveal = identity.is_some_and(|identity| {
                runtime.presented.iter().any(|node| {
                    identity == node.identity
                        && node.actions.contains(super::ActionKind::ScrollIntoView)
                })
            });
            drop(runtime);
            if !reveal {
                return Ok(commit);
            }
            let Some(target) = focused else {
                return Ok(commit);
            };
            // Keyboard traversal reveals retained offscreen controls in the
            // same exclusive owner operation. Explicit focus remains a logical
            // repair capability; accessibility has a separate ScrollIntoView.
            let revealed = self.scroll_into_view(target);
            if revealed.is_err()
                && let Ok(mut runtime) = self.runtime_mut()
            {
                runtime.focused = previous.filter(|target| runtime.resolve(*target).is_ok());
            }
            return revealed;
        }
        let Some(target) = runtime.focused else {
            return Ok(runtime.commit());
        };
        match key {
            Key::Text(text) if text.chars().any(char::is_control) => Ok(runtime.commit()),
            Key::Text(text) => runtime.edit_text(target, |value| value.push_str(text)),
            Key::Backspace => runtime.edit_text(target, |value| {
                value.pop();
            }),
            Key::Enter => runtime.activate(target),
            Key::Space => {
                let index = runtime.resolve_index(target)?;
                if runtime.nodes[index].kind() == NodeKind::Input {
                    runtime.edit_text(target, |value| value.push(' '))
                } else {
                    runtime.activate(target)
                }
            }
            Key::Tab | Key::ReverseTab => unreachable!(),
        }
    }
}

impl<M: View + 'static> Runtime<M> {
    fn focusable(&self, identity: u64) -> bool {
        self.by_identity
            .get(identity)
            .is_some_and(|index| self.nodes[index].focusable())
    }
    pub(super) fn focus(&mut self, target: Target) -> Result<Commit, Error> {
        self.live()?;
        let index = self.resolve_index(target)?;
        if !self.nodes[index].focusable() {
            return Err(Error::NotInteractive);
        }
        self.focused = Some(target);
        self.changed_nodes = 0;
        Ok(self.commit())
    }
    pub(super) fn prune_focus(&mut self) {
        if self.focused.is_some_and(|target| {
            self.resolve_index(target)
                .ok()
                .is_none_or(|index| !self.nodes[index].focusable())
        }) {
            self.focused = None;
        }
    }
    fn tab(&mut self, reverse: bool) -> Result<Commit, Error> {
        self.current_presentation()?;
        let current = self.focused.and_then(|target| self.resolve(target).ok());
        // Iterate the acknowledged sheet directly; no alternate focus registry
        // or allocation is needed, including when wrapping at either end.
        let mut first = None;
        let mut last = None;
        let mut before = None;
        let mut after = None;
        let mut passed = false;
        for node in &self.presented {
            if !self.focusable(node.identity) {
                continue;
            }
            first.get_or_insert(node.identity);
            last = Some(node.identity);
            if Some(node.identity) == current {
                passed = true;
            } else if !passed {
                before = Some(node.identity);
            } else if after.is_none() {
                after = Some(node.identity);
            }
        }
        let identity = if reverse {
            if current.is_some() {
                before.or(last)
            } else {
                last
            }
        } else if current.is_some() {
            after.or(first)
        } else {
            first
        };
        self.focused = identity.map(|identity| self.sites.target(identity));
        Ok(self.commit())
    }
}
