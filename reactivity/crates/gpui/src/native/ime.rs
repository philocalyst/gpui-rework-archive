//! Native lifecycle transport; source authority stays in the ordinary IME API.
use super::*;
use crate::{ImeEvent, ImeSession, runtime::ime::ImeTarget};
use winit::{
    dpi::{PhysicalPosition, PhysicalSize},
    event::Ime,
};

#[derive(Default, PartialEq, Eq)]
enum Phase {
    #[default]
    Requested,
    Enabled,
    // An observed Enabled stream must end before another field is admitted.
    Disabling,
}
#[derive(Default)]
pub(super) struct Bridge {
    session: ImeSession,
    binding: Option<ImeTarget>,
    phase: Phase,
}
impl Bridge {
    pub fn unused(&self) -> bool {
        self.binding.is_none() && self.phase != Phase::Disabling
    }
    pub fn sync<V: View + 'static, L: LaneSet<V>>(
        &mut self,
        owner: &mut Win<V, L>,
        window: &NativeWindow,
    ) -> Result<Option<Commit>, Error> {
        let desired = owner.ime_target();
        if self.phase == Phase::Disabling {
            // Keep only the next requested binding. No old event can enable it.
            self.binding = desired;
            return Ok(None);
        }
        let revoked = self.phase == Phase::Enabled && !owner.ime_session_live(&self.session);
        if self.binding == desired && !revoked {
            return Ok(None);
        }
        let was_enabled = self.phase == Phase::Enabled;
        let had_request = self.binding.is_some();
        self.binding = desired;
        let commit = if self.session.is_enabled() {
            Some(owner.ime_event(&mut self.session, ImeEvent::Cancel)?)
        } else {
            None
        };
        if had_request || was_enabled {
            window.set_ime_allowed(false);
        }
        if was_enabled {
            // Winit promises Disabled closes an observed IME stream. Retain the
            // gate even if focus returns to the same field before it arrives.
            self.phase = Phase::Disabling;
        } else {
            // macOS/Windows need not emit Disabled for a mere allowed request
            // that never became Enabled. Their setters and callbacks are FIFO
            // on the native UI thread; restart the request without awaiting an
            // event those platforms are not required to produce.
            self.phase = Phase::Requested;
            if desired.is_some() {
                window.set_ime_allowed(true);
            }
        }
        Ok(commit)
    }
    pub fn event<V: View + 'static, L: LaneSet<V>>(
        &mut self,
        owner: &mut Win<V, L>,
        event: &Ime,
    ) -> Option<Result<Commit, Error>> {
        if self.phase == Phase::Disabling {
            if matches!(event, Ime::Disabled) {
                self.phase = Phase::Requested;
                // sync must issue a fresh allowed request, even when the same
                // source regained focus while the old stream was closing.
                self.binding = None;
            }
            return None;
        }
        if self.binding.is_none() || self.binding != owner.ime_target() {
            return None;
        }
        match event {
            Ime::Enabled if self.phase == Phase::Requested => {
                let result = owner.ime_event(&mut self.session, ImeEvent::Enabled);
                if result.is_ok() {
                    self.phase = Phase::Enabled;
                }
                Some(result)
            }
            Ime::Preedit(text, cursor) if self.phase == Phase::Enabled => Some(owner.ime_event(
                &mut self.session,
                ImeEvent::Preedit {
                    text,
                    cursor: *cursor,
                },
            )),
            Ime::Commit(text) if self.phase == Phase::Enabled => {
                let result = owner.ime_event(&mut self.session, ImeEvent::Commit(text));
                // An admitted commit advances S once. Only its still-live core
                // capability can carry the native stream into that new epoch.
                if result.is_ok() && owner.ime_session_live(&self.session) {
                    self.binding = owner.ime_target();
                }
                Some(result)
            }
            Ime::Disabled => {
                self.phase = Phase::Requested;
                Some(owner.ime_event(&mut self.session, ImeEvent::Disabled))
            }
            _ => None,
        }
    }
    #[cfg(all(
        test,
        target_os = "linux",
        any(feature = "x11", feature = "x11-minimal")
    ))]
    pub(super) fn has_acknowledged_cursor<V: View + 'static, L: LaneSet<V>>(
        &self,
        owner: &Win<V, L>,
    ) -> bool {
        owner
            .ime_cursor_area(&self.session)
            .is_ok_and(|area| area.is_some())
    }
    pub fn update_cursor<V: View + 'static, L: LaneSet<V>>(
        &self,
        owner: &Win<V, L>,
        window: &NativeWindow,
    ) {
        if self.phase != Phase::Enabled {
            return;
        }
        if let Ok(Some(area)) = owner.ime_cursor_area(&self.session) {
            // The runtime has already applied the acknowledged transform, clip
            // and DPR. Passing Physical types prevents a second DPI conversion.
            window.set_ime_cursor_area(
                PhysicalPosition::new(f64::from(area.x), f64::from(area.y)),
                PhysicalSize::new(f64::from(area.width), f64::from(area.height)),
            );
        }
    }
}
