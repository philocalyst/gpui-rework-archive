//! Explicit event-loop resource context admission, not a default budget policy.
use gpui::{div, El, Error, View, Win, WindowOptions};
use gpui_reactivity_core::resource::{ResourceContext, ResourceError, ResourceLimits};
struct Page { width: f32 }
impl View for Page { fn view(&self) -> El<'_> { div().w(self.width).h(12) } }
fn context() -> ResourceContext {
    // This gate tests context identity admission, not shaped-payload budget
    // enforcement (typed text adoption has its separate gates). Limits are deliberately
    // explicit fixture policy, not a production per-window memory default.
    ResourceContext::new(ResourceLimits { retained_payload_bytes: 1024, physical_roots: 8, resource_records: 8, backings_per_resource: 2 }).unwrap()
}
#[test]
fn scoped_window_rejects_unaccounted_and_foreign_admission_before_callback() {
    let mut resources = context();
    let mut win = Win::recording_with_resources(Page { width: 12. }, WindowOptions::default(), &mut resources).unwrap();
    let original = win.with_change_scene(|frame, token| (frame.stamp(), token)).unwrap();
    let mut called = false;
    assert!(matches!(win.update(|_| called = true), Err(Error::Resource(ResourceError::Unaccounted))));
    assert!(!called);
    let mut foreign = context();
    assert!(matches!(win.edit_turn_with_resources(&mut foreign), Err(Error::Resource(ResourceError::ForeignOwner))));
    assert_eq!(win.with_change_scene(|frame, token| (frame.stamp(), token)).unwrap(), original);
    // ACK has no resource admission: it acknowledges only the existing C.
    win.presented(original.1).unwrap();
    let mut turn = win.edit_turn_with_resources(&mut resources).unwrap();
    turn.update(|page| page.width = 24.).unwrap();
    turn.finish().unwrap();
    let next = win.with_change_scene(|frame, token| (frame.stamp(), token)).unwrap();
    assert!(next.0.to.sequence > original.0.to.sequence);
    assert!(next.0.source_epoch > original.0.source_epoch);
}

#[test]
fn missing_context_does_not_change_focus_selection_or_pointer_session() {
    use gpui::prelude::*;
    struct InputPage { value: Signal<String> }
    impl InputPage {
        const VALUE: Source<Self, String> = Source::new(FieldId::new(77), "value", |m| &m.value, |m| &mut m.value);
    }
    impl View for InputPage {
        fn sources() -> Sources<Self> { Sources::new().field(Self::VALUE) }
        fn view(&self) -> El<'_> { text_input(&self.value).w(80).h(24) }
    }
    let mut resources = context();
    let mut win = Win::recording_with_resources(InputPage { value: Signal::new(String::from("hello")) }, WindowOptions::default(), &mut resources).unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let target = win.input();
    let selection = win.selection(target).unwrap();
    let focus = win.focused().unwrap();
    assert!(matches!(win.focus(target), Err(Error::Resource(ResourceError::Unaccounted))));
    assert!(matches!(win.select(target, selection), Err(Error::Resource(ResourceError::Unaccounted))));
    assert_eq!(win.focused().unwrap(), focus);
    assert_eq!(win.selection(target).unwrap(), selection);
    let mut pointer = gpui::PointerSession::default();
    let before = pointer.position();
    assert!(matches!(win.pointer_event(&mut pointer, gpui::PointerEvent::Move(Point { x: 2., y: 3. })), Err(Error::Resource(ResourceError::Unaccounted))));
    assert_eq!(pointer.position(), before);
    assert_eq!(win.with_scene(|_, token| token).unwrap(), token);
}
