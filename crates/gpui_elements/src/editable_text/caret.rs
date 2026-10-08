//! Focus-aware caret visibility and blink scheduling for editable text.
//!
//! Blinking is opt-in: a zero interval keeps the caret visible without scheduling timers.

#[cfg(test)]
use gpui::{AppContext, TestAppContext};

use gpui::{Context, Entity, EventEmitter, Subscription};
use smallvec::SmallVec;
use std::time::Duration;

/// Default interval for caret blinking (500ms).
pub const BLINK_INTERVAL_500MS: Duration = Duration::from_millis(500);

/// Event used to restart a subscribed [`Caret`]'s blink cycle after user activity.
pub enum CaretNotify {
    /// Make a focused caret visible for one full interval, then resume blinking.
    PauseBlinking,
}

/// Controls insertion-caret visibility and blinking for editable text.
///
/// Text layout owns the caret's position and geometry. This entity only tracks focus and timing;
/// it is hidden while unfocused. Blinking is disabled by default, so use one of the interval
/// builders to opt in. The editable element creates and subscribes its caret automatically;
/// configure it with [`caret_blink_interval`](super::EditableTextElement::caret_blink_interval).
/// A custom field can subscribe its own caret to [`CaretNotify`] events.
#[derive(Default)]
pub struct Caret {
    /// The frequency at which the caret blinks
    interval: Duration,
    generation: usize,
    /// Whether the caret is presently visible in this frame
    visible: bool,
    /// Whether the caret's EditableText element is currently focused.
    /// Caret is only eligible to be blinking if currently focused.
    has_focus: bool,
    #[allow(dead_code)]
    subscriptions: SmallVec<[Subscription; 2]>,
}

impl Caret {
    /// Returns the duration between visibility changes; zero means no blinking.
    pub fn blink_interval(&self) -> Duration {
        self.interval
    }

    /// Sets the duration between visibility changes; zero disables blinking.
    ///
    /// This changes the interval without starting a timer or notifying the entity. A focused
    /// caret starts or restarts its cycle on the next [`CaretNotify::PauseBlinking`] event or
    /// focus change. Configure a new caret before its first prepaint when possible.
    pub fn set_blink_interval(&mut self, interval: Duration) {
        self.interval = interval;
    }

    /// Sets the duration between visibility changes and returns the caret.
    pub fn with_blink_interval(mut self, interval: Duration) -> Self {
        self.set_blink_interval(interval);
        self
    }

    /// Sets the common 500 ms blink interval.
    ///
    /// [`Caret::default`] does not blink; this method opts into the interval in
    /// [`BLINK_INTERVAL_500MS`].
    pub fn with_blink_interval_500ms(self) -> Self {
        self.with_blink_interval(BLINK_INTERVAL_500MS)
    }

    /// Listens for [`CaretNotify`] events on an entity, usually an [`EditableTextState`](super::EditableTextState).
    ///
    /// Retains the subscription in this caret entity. The editable-text state emits
    /// `PauseBlinking` after caret movement and text input; this keeps the caret visible for a full
    /// interval after activity.
    pub fn subscribe_to<E>(&mut self, emitter: &Entity<E>, cx: &mut Context<Self>)
    where
        E: EventEmitter<CaretNotify>,
    {
        let handle = cx.subscribe(emitter, |state, _emitter, event, cx| match event {
            CaretNotify::PauseBlinking => {
                if state.interval.is_zero() || !state.has_focus {
                    return;
                }

                // Leave the caret visible for one complete interval after user activity.
                state.visible = true;
                state.restart_blink_ticker(cx);
                cx.notify();
            }
        });
        self.subscriptions.push(handle);
    }

    /// Processes updates during prepaint and returns whether the caret is currently visible.
    pub(super) fn update_focus(&mut self, is_focused: bool, cx: &mut Context<Self>) -> bool {
        if self.has_focus != is_focused {
            self.has_focus = is_focused;
            self.visible = is_focused;

            if is_focused && !self.interval.is_zero() {
                self.restart_blink_ticker(cx);
            } else {
                self.generation = self.generation.wrapping_add(1);
            }

            cx.notify();
        }

        is_focused && (self.interval.is_zero() || self.visible)
    }

    fn restart_blink_ticker(&mut self, cx: &mut Context<Self>) {
        let generation = self.generation.wrapping_add(1);
        self.generation = generation;

        let interval = self.interval;
        cx.spawn(async move |this, cx| {
            cx.background_executor().timer(interval).await;

            let Some(this) = this.upgrade() else { return };
            this.update(cx, |this, cx| {
                if this.generation != generation || !this.has_focus || this.interval.is_zero() {
                    return;
                }

                this.visible = !this.visible;
                cx.notify();
                this.restart_blink_ticker(cx);
            });
        })
        .detach();
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    struct CaretEventEmitter;
    impl EventEmitter<CaretNotify> for CaretEventEmitter {}

    #[gpui::test]
    fn visibility_tracks_focus_activity_and_blur(cx: &mut TestAppContext) {
        let interval = Duration::from_millis(10);
        let emitter = cx.new(|_| CaretEventEmitter);
        let caret = cx.new(|cx| {
            let mut caret = Caret::default().with_blink_interval(interval);
            caret.subscribe_to(&emitter, cx);
            caret
        });

        caret.update(cx, |caret, cx| assert!(caret.update_focus(true, cx)));

        cx.run_until_parked();

        cx.executor().advance_clock(interval);
        cx.run_until_parked();
        assert!(!cx.read(|cx| caret.read(cx).visible));

        emitter.update(cx, |_, cx| cx.emit(CaretNotify::PauseBlinking));

        cx.run_until_parked();
        assert!(cx.read(|cx| caret.read(cx).visible));

        cx.executor().advance_clock(interval);
        cx.run_until_parked();
        assert!(!cx.read(|cx| caret.read(cx).visible));

        caret.update(cx, |caret, cx| assert!(!caret.update_focus(false, cx)));

        cx.executor().advance_clock(interval);
        cx.run_until_parked();
        assert!(!cx.read(|cx| caret.read(cx).visible));
    }
}
