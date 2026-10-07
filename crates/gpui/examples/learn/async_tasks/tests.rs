//! Cancellation must prevent a late result from overwriting the current state.
use super::*;
use gpui::TestAppContext;

#[gpui::test]
fn cancelled_work_cannot_complete_and_can_be_restarted(cx: &mut TestAppContext) {
    let view = cx.new(|_| AsyncTaskExample::new());
    cx.update_entity(&view, |view, cx| view.start(cx));
    cx.run_until_parked();
    cx.update_entity(&view, |view, cx| view.cancel(cx));
    cx.dispatcher.advance_clock(Duration::from_secs(1));
    cx.run_until_parked();
    cx.read_entity(&view, |view, _| {
        assert_eq!(view.state, TaskState::Cancelled)
    });

    cx.update_entity(&view, |view, cx| view.start(cx));
    cx.run_until_parked();
    cx.dispatcher.advance_clock(Duration::from_secs(1));
    cx.run_until_parked();
    cx.read_entity(&view, |view, _| {
        assert_eq!(view.state, TaskState::Completed(42))
    });
}
