//! Focus and normalized input belong to the ordinary exclusive window runtime.
use super::{Commit, Error, NodeKind, Runtime, Target, View, Win};
use crate::remote::LaneSet;
use crate::{Point, ScrollDelta};
use std::{fmt, num::NonZeroU64};

/// One portable mouse stream. Points are physical window coordinates; wheel
/// displacement is window-logical, with positive values scrolling right/down.
/// Native adapters normalize platform units before entering this same path.
/// Text selection retains a pressed input while the pointer moves within the
/// window, including outside that input. Touch and multiple devices are separate.
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
/// reference. A press retains a window-qualified target; release performs
/// a fresh acknowledged-sheet hit test. Moving a session to another window
/// cannot transfer that press's authority.
pub struct PointerSession {
    // Move admits only finite points. A NaN x represents absence without the
    // padding of Option<Point>, keeping the press's proof inside this header.
    position: Point,
    pressed: Option<Pressed>,
}
#[derive(Clone, Copy)]
struct Pressed {
    target: Target,
    focus_sequence: Option<NonZeroU64>,
}
impl Default for PointerSession {
    fn default() -> Self {
        Self {
            position: Point { x: f32::NAN, y: 0. },
            pressed: None,
        }
    }
}
impl fmt::Debug for PointerSession {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("PointerSession")
            .field("position", &self.position())
            .field("pressed", &self.pressed.map(|pressed| pressed.target))
            .finish()
    }
}
impl PointerSession {
    pub fn position(&self) -> Option<Point> {
        self.position.x.is_finite().then_some(self.position)
    }

    /// Cancel a gesture while keeping the last position. This does not change
    /// keyboard focus or source state. Replace the session with its default
    /// when window movement, resize or suspension invalidates its coordinates.
    pub fn cancel(&mut self) {
        self.pressed = None;
    }
}

/// Committed text and portable editing keys. Text replaces the current range;
/// backspace removes a selected range or one whole extended grapheme.
/// Visual arrows require an acknowledged current layout; IME is separate.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Key<'a> {
    /// Committed printable text; payloads containing control characters are ignored.
    Text(&'a str),
    Backspace,
    Left {
        extend: bool,
    },
    Right {
        extend: bool,
    },
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
    /// A release may also use P while only its own caret-focus paint awaits ACK;
    /// any intervening source, viewport or presentation change revokes that proof.
    /// The built-in inspector retains strict ACK admission because its epoch
    /// captions can change geometry during an otherwise focus-only publication.
    ///
    /// A move extends a pressed input's selection through current geometry.
    /// Other moves, cancellation and an unpaired release prepare no frame.
    /// Nonfinite positions behave as leaving the window.
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
                if point.x.is_finite() && point.y.is_finite() {
                    session.position = point;
                } else {
                    session.position.x = f32::NAN;
                    session.cancel();
                }
            }
            PointerEvent::Leave => session.position.x = f32::NAN,
            PointerEvent::Wheel(delta) => {
                if let Some(point) = session.position() {
                    return self.scroll_at_2d(point, delta);
                }
            }
            PointerEvent::Press | PointerEvent::Release | PointerEvent::Cancel => {}
        }
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.changed_nodes = 0;
        if matches!(event, PointerEvent::Move(_))
            && !runtime.inspector_picking()
            && let Some(Pressed { target, .. }) = session.pressed
        {
            if let Ok(index) = runtime.resolve_index(target) {
                if runtime.nodes[index].kind() == NodeKind::Input {
                    let result = runtime.select_pointer(target, session.position().unwrap(), true);
                    if matches!(result, Err(Error::StaleTarget)) {
                        session.cancel();
                    }
                    return result;
                }
            } else {
                session.cancel();
            }
        }
        if !matches!(event, PointerEvent::Press)
            && !(matches!(event, PointerEvent::Release) && pressed.is_some())
        {
            return Ok(runtime.commit());
        }
        if let Some(pressed) = pressed.filter(|_| matches!(event, PointerEvent::Release)) {
            runtime.pointer_release_presentation(pressed)?;
        } else {
            runtime.current_presentation()?;
        }
        let picking = runtime.inspector_picking();
        let hit = session.position().and_then(|point| {
            if picking {
                runtime.inspector_pick(point)
            } else {
                runtime
                    .hit(point)
                    .map(|identity| runtime.sites.target(identity))
            }
        });
        if matches!(event, PointerEvent::Press) {
            let previous = runtime.focused;
            if let Some(target) = hit.filter(|_| !picking) {
                if runtime.nodes[runtime.resolve_index(target)?].kind() == NodeKind::Input {
                    let commit =
                        runtime.select_pointer(target, session.position().unwrap(), false)?;
                    session.pressed = Some(Pressed {
                        target,
                        focus_sequence: None,
                    });
                    return Ok(commit);
                }
                runtime.focus(target)?;
            } else {
                runtime.focused = None;
            }
            let commit = runtime.publish_focus_change(previous)?;
            // Press entered through current P. This call changes only focus:
            // no model/route callback or description runs before recording C.
            let focus_sequence = if !runtime.inspector_enabled()
                && runtime.prepared.is_some()
                && runtime.presentation_epoch.checked_add(1) == Some(runtime.source_epoch)
            {
                runtime.latest_token.map(|token| token.sequence)
            } else {
                None
            };
            session.pressed = hit.map(|target| Pressed {
                target,
                focus_sequence,
            });
            return Ok(commit);
        } else if let Some(Pressed { target, .. }) =
            pressed.filter(|pressed| Some(pressed.target) == hit)
        {
            if picking {
                return runtime.inspector_select(target);
            }
            return runtime.activate(target);
        }
        Ok(runtime.commit())
    }

    /// Focus a live logical control without using displayed coordinates. This
    /// remains available to repair text after a failed presentation.
    pub fn focus(&mut self, target: Target) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        let previous = runtime.focused;
        runtime.focus(target)?;
        runtime.publish_focus_change(previous)
    }
    pub fn clear_focus(&mut self) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        let previous = runtime.focused;
        runtime.focused = None;
        runtime.changed_nodes = 0;
        runtime.publish_focus_change(previous)
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
            let prepared = runtime.latest_token;
            let commit = runtime.tab(matches!(key, Key::ReverseTab))?;
            let focused = runtime.focused;
            let identity = focused.and_then(|target| runtime.resolve(target).ok());
            let reveal = identity.is_some_and(|identity| {
                runtime.presented.iter().any(|node| {
                    identity == node.identity
                        && node.actions.contains(super::ActionKind::ScrollIntoView)
                })
            });
            if !reveal {
                return runtime.publish_focus_change(previous);
            }
            drop(runtime);
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
            if revealed.is_ok() {
                let mut runtime = self.runtime_mut()?;
                // Reveal either prepares a full scene with this focus or does
                // nothing; a metadata epoch alone cannot prove caret painting.
                if runtime.latest_token == prepared {
                    return runtime.publish_focus_change(previous);
                }
            }
            return revealed;
        }
        let Some(target) = runtime.focused else {
            return Ok(runtime.commit());
        };
        match key {
            Key::Text(text) if text.chars().any(char::is_control) => Ok(runtime.commit()),
            Key::Text(text) => runtime.replace_input(target, None, text),
            Key::Backspace => runtime.backspace_input(target),
            Key::Left { extend } | Key::Right { extend } => {
                let index = runtime.resolve_index(target)?;
                if runtime.nodes[index].kind() == NodeKind::Input {
                    runtime.move_selection(target, matches!(key, Key::Right { .. }), extend)
                } else {
                    Ok(runtime.commit())
                }
            }
            Key::Enter => runtime.activate(target),
            Key::Space => {
                let index = runtime.resolve_index(target)?;
                if runtime.nodes[index].kind() == NodeKind::Input {
                    runtime.replace_input(target, None, " ")
                } else {
                    runtime.activate(target)
                }
            }
            Key::Tab | Key::ReverseTab => unreachable!(),
        }
    }
}

impl<M: View + 'static> Runtime<M> {
    fn pointer_release_presentation(&self, pressed: Pressed) -> Result<(), Error> {
        self.current_presentation().or_else(|error| {
            // Only this press's successful focus paint may still be pending.
            // Epoch rejects even no-op source edits; token rejects resize/DPI
            // ABA and re-preparation at the same source epoch. Hit geometry and
            // metadata remain in P; activation still resolves and admits the target.
            if self.logical_valid
                && !self.dirty
                && self.presentation_valid
                && self.prepared.is_some()
                && self.requested_size == self.presentation_size
                && self.requested_scale_factor == self.presentation_scale_factor
                && self.presentation_epoch.checked_add(1) == Some(self.source_epoch)
                && self.complete_epoch == self.source_epoch
                && pressed.focus_sequence.is_some()
                && self.latest_token.map(|token| token.sequence) == pressed.focus_sequence
                && self.sites.resolve(pressed.target).is_some()
            {
                Ok(())
            } else {
                Err(error)
            }
        })
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

#[cfg(test)]
mod focus_release_tests {
    use super::*;
    use crate::{WindowOptions, prelude::*};

    struct Page {
        value: Signal<String>,
        calls: usize,
    }
    impl View for Page {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Source::new(
                FieldId::new(1),
                "value",
                |m| &m.value,
                |m| &mut m.value,
            ))
        }
        fn view(&self) -> El<'_> {
            column((
                text_input(&self.value).w(240).h(32),
                checkbox("check", false)
                    .w(240)
                    .h(40)
                    .on_click(|m: &mut Self| m.calls += 1),
            ))
        }
    }
    fn ack(win: &mut Win<Page>) {
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
    }
    fn page() -> Win<Page> {
        let mut win = Win::recording(
            Page {
                value: Signal::new("search".into()),
                calls: 0,
            },
            WindowOptions {
                size: [720, 900],
                ..Default::default()
            },
        )
        .unwrap();
        ack(&mut win);
        win.click(win.input()).unwrap();
        ack(&mut win);
        win
    }

    #[test]
    fn failed_focus_preparation_and_epoch_exhaustion_leave_no_pressed_authority() {
        for exhausted_source in [false, true] {
            let mut win = page();
            let (old_epoch, next) = {
                let mut runtime = win.runtime_mut().unwrap();
                let saved = (runtime.source_epoch, runtime.next_presentation);
                if exhausted_source {
                    runtime.source_epoch = u64::MAX;
                    runtime.presentation_epoch = u64::MAX;
                    runtime.complete_epoch = u64::MAX;
                } else {
                    runtime.next_presentation = NonZeroU64::new(u64::MAX).unwrap();
                }
                saved
            };
            let mut pointer = PointerSession::default();
            win.pointer_event(&mut pointer, PointerEvent::Move(Point { x: 12., y: 52. }))
                .unwrap();
            assert_eq!(
                win.pointer_event(&mut pointer, PointerEvent::Press),
                Err(Error::EpochExhausted)
            );
            assert!(pointer.pressed.is_none());
            {
                let mut runtime = win.runtime_mut().unwrap();
                runtime.next_presentation = next;
                if exhausted_source {
                    runtime.source_epoch = old_epoch;
                    runtime.presentation_epoch = old_epoch;
                    runtime.complete_epoch = old_epoch;
                }
            }
            win.update(|_| {}).unwrap();
            ack(&mut win);
            win.pointer_event(&mut pointer, PointerEvent::Release)
                .unwrap();
            assert_eq!(win.root().unwrap().calls, 0);
        }
    }

    #[test]
    fn private_press_proof_uses_the_existing_session_header() {
        println!(
            "POINTER_LAYOUT point={} option_point={} target={} pressed={} option_pressed={} session={} session_align={} runtime={} win={}",
            size_of::<Point>(),
            size_of::<Option<Point>>(),
            size_of::<Target>(),
            size_of::<Pressed>(),
            size_of::<Option<Pressed>>(),
            size_of::<PointerSession>(),
            align_of::<PointerSession>(),
            size_of::<Runtime<Page>>(),
            size_of::<Win<Page>>(),
        );
        if cfg!(target_pointer_width = "64") {
            assert_eq!(size_of::<Pressed>(), 24);
            assert_eq!(size_of::<Option<Pressed>>(), 24);
            assert_eq!(size_of::<PointerSession>(), 32);
            assert_eq!(align_of::<PointerSession>(), 8);
        }
    }
}
