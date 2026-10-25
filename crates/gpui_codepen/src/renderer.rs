//! Paint the interpreter's actual GPUI scene through the containing GPUI window.
use gpui::*;
use std::{
    cell::{Cell, RefCell},
    collections::HashSet,
    rc::Rc,
    sync::Arc,
};

#[derive(Clone, Default)]
pub(crate) struct InputState {
    pressed: Rc<Cell<bool>>,
    hovered: Rc<Cell<bool>>,
    touches: Rc<RefCell<HashSet<TouchId>>>,
    file_drop: Rc<Cell<bool>>,
}
impl InputState {
    pub fn reset(&self) {
        self.pressed.set(false);
        self.hovered.set(false);
        self.touches.borrow_mut().clear();
        self.file_drop.set(false);
    }
}
pub type InputHandler = Rc<dyn Fn(gpui_codepen_guest::InputMessage, &mut Window, &mut App)>;
pub type ResizeHandler =
    Rc<dyn Fn(Size<Pixels>, f32, bool, TextRenderingMode, bool, &mut Window, &mut App)>;
pub(crate) type ErrorHandler =
    Rc<dyn Fn(Arc<gpui_codepen_guest::Frame>, String, &mut Window, &mut App)>;

pub(crate) fn scene_view(
    scene: Option<Arc<ImportedScene>>,
    scale: f32,
    focus: FocusHandle,
    state: InputState,
    frame: Option<Arc<gpui_codepen_guest::Frame>>,
    input: InputHandler,
    resize: ResizeHandler,
    error: ErrorHandler,
) -> impl IntoElement {
    let InputState {
        pressed,
        hovered,
        touches,
        file_drop,
    } = state;
    let down_focus = focus.clone();
    let down_input = input.clone();
    let up_focus = focus.clone();
    let up_input = input.clone();
    let modifiers_focus = focus.clone();
    let modifiers_input = input.clone();
    div()
        .id("gpui-interpreter-scene")
        .size_full()
        .track_focus(&focus)
        // Keyboard listeners belong to the node carrying the focus handle.
        // The canvas is a child dispatch node, outside that focused path.
        .on_key_down(move |event, window, cx| {
            if down_focus.is_focused(window) {
                down_input(event.clone().to_platform_input().into(), window, cx);
                if event.keystroke.key_char.is_none()
                    || event.keystroke.modifiers.control
                    || event.keystroke.modifiers.platform
                { cx.stop_propagation(); }
            }
        })
        .on_key_up(move |event, window, cx| {
            if up_focus.is_focused(window) {
                up_input(event.clone().to_platform_input().into(), window, cx);
                cx.stop_propagation();
            }
        })
        .on_modifiers_changed(move |event, window, cx| {
            if modifiers_focus.is_focused(window) {
                modifiers_input(event.clone().to_platform_input().into(), window, cx);
            }
        })
        .child(
            canvas(
                move |bounds, window, cx| {
                    let hitbox = window.insert_hitbox(bounds, HitboxBehavior::Normal);
                    let density = window.scale_factor();
                    let subpixel = window.is_subpixel_rendering_supported();
                    let text_mode = cx.text_rendering_mode();
                    let transparent = window.background_appearance().is_transparent();
                    window.defer(cx, move |window, cx| {
                        resize(
                            bounds.size,
                            density,
                            subpixel,
                            text_mode,
                            transparent,
                            window,
                            cx,
                        )
                    });
                    hitbox
                },
                move |bounds, hitbox, window, cx| {
                    if let Some(scene) = scene {
                        if let Err(e) = window.paint_scene(&scene, bounds, scale) {
                            if let Some(frame) = frame.clone() {
                                let error = error.clone();
                                window.defer(cx, move |window, cx| {
                                    error(
                                        frame,
                                        format!("Could not paint GPUI scene: {e:#}"),
                                        window,
                                        cx,
                                    )
                                });
                            }
                        }
                    }
                    if let Some(frame) = frame {
                        window.set_cursor_style(frame.cursor, &hitbox);
                        if frame.text.is_some() {
                            window.handle_input(
                                &focus,
                                crate::text_input::TextProxy {
                                    frame,
                                    origin: bounds.origin,
                                    input: input.clone(),
                                },
                                cx,
                            );
                        }
                    }
                    macro_rules! mouse {
                        ($event:ty) => {{
                            let input = input.clone();
                            let hitbox = hitbox.clone();
                            let pressed = pressed.clone();
                            let focus = focus.clone();
                            let hovered = hovered.clone();
                            window.on_mouse_event(move |event: &$event, phase, window, cx| {
                                if phase != DispatchPhase::Bubble {
                                    return;
                                }
                                let inside = hitbox.is_hovered(window);
                                let mut event = event.clone().to_platform_input();
                                let leaving = matches!(&event, PlatformInput::MouseMove(_))
                                    && hovered.replace(inside);
                                if inside || pressed.get() || leaving {
                                    match &event {
                                        PlatformInput::MouseDown(_) => {
                                            pressed.set(true);
                                            focus.focus(window, cx);
                                        }
                                        PlatformInput::MouseUp(_) => pressed.set(false),
                                        _ => {}
                                    }
                                    translate(&mut event, bounds.origin);
                                    input(event.into(), window, cx);
                                    cx.stop_propagation();
                                }
                            });
                        }};
                    }
                    mouse!(MouseDownEvent);
                    mouse!(MouseUpEvent);
                    mouse!(MouseMoveEvent);
                    mouse!(ScrollWheelEvent);
                    mouse!(MousePressureEvent);
                    mouse!(PinchEvent);
                    mouse!(TouchDragEvent);
                    mouse!(LongPressEvent);
                    let drop_input = input.clone();
                    let drop_hitbox = hitbox.clone();
                    window.on_file_drop_event(move |event, phase, window, cx| {
                        if phase != DispatchPhase::Bubble {
                            return;
                        }
                        let inside = drop_hitbox.is_hovered(window);
                        let owned = file_drop.get();
                        if inside || owned {
                            file_drop.set(
                                inside
                                    && !matches!(
                                        event,
                                        FileDropEvent::Exited
                                            | FileDropEvent::Ended
                                            | FileDropEvent::Submit { .. }
                                    ),
                            );
                            let mut event = if owned && !inside {
                                PlatformInput::FileDrop(FileDropEvent::Exited)
                            } else {
                                event.clone().to_platform_input()
                            };
                            translate(&mut event, bounds.origin);
                            drop_input(event.into(), window, cx);
                            cx.stop_propagation();
                        }
                    });
                    let handler = input.clone();
                    let touch_hitbox = hitbox.clone();
                    let touch_focus = focus.clone();
                    window.on_touch_event(move |event, phase, window, cx| {
                        if phase != DispatchPhase::Bubble {
                            return;
                        }
                        if event.phase == TouchPhase::Started && touch_hitbox.is_hovered(window) {
                            touches.borrow_mut().insert(event.id);
                            touch_focus.focus(window, cx);
                        }
                        if touches.borrow().contains(&event.id) {
                            if matches!(event.phase, TouchPhase::Ended | TouchPhase::Cancelled) {
                                touches.borrow_mut().remove(&event.id);
                            }
                            let mut event = event.clone().to_platform_input();
                            translate(&mut event, bounds.origin);
                            handler(event.into(), window, cx);
                            cx.stop_propagation();
                        }
                    });
                    let handler = input.clone();
                    window.on_mouse_event(move |event: &MouseExitEvent, phase, window, cx| {
                        if phase == DispatchPhase::Bubble {
                            let mut event = event.clone().to_platform_input();
                            translate(&mut event, bounds.origin);
                            hovered.set(false);
                            if event_mouse_button(&event).is_none() {
                                pressed.set(false);
                            }
                            handler(event.into(), window, cx);
                        }
                    });
                },
            )
            .size_full(),
        )
}
fn translate(input: &mut PlatformInput, origin: Point<Pixels>) {
    match input {
        PlatformInput::MouseDown(e) => e.position -= origin,
        PlatformInput::MouseUp(e) => e.position -= origin,
        PlatformInput::MouseMove(e) => e.position -= origin,
        PlatformInput::MousePressure(e) => e.position -= origin,
        PlatformInput::MouseExited(e) => e.position -= origin,
        PlatformInput::ScrollWheel(e) => e.position -= origin,
        PlatformInput::Pinch(e) => e.position -= origin,
        PlatformInput::Touch(e) => {
            e.position -= origin;
            if let Some(p) = &mut e.predicted_position {
                *p -= origin;
            }
        }
        PlatformInput::LongPress(e) => {
            e.position -= origin;
            e.start_position -= origin;
        }
        PlatformInput::TouchDrag(e) => {
            e.position -= origin;
            e.start_position -= origin;
        }
        PlatformInput::FileDrop(e) => match e {
            FileDropEvent::Entered { position, .. }
            | FileDropEvent::Pending { position, .. }
            | FileDropEvent::Submit { position, .. } => *position -= origin,
            FileDropEvent::Exited | FileDropEvent::Ended => {}
        },
        _ => {}
    }
}

fn event_mouse_button(event: &PlatformInput) -> Option<MouseButton> {
    match event {
        PlatformInput::MouseExited(event) => event.pressed_button,
        _ => None,
    }
}

#[cfg(all(test, not(target_family = "wasm")))]
mod tests {
    use super::*;

    struct HostPreview {
        focus: FocusHandle,
        other: FocusHandle,
        events: Rc<RefCell<Vec<gpui_codepen_guest::InputMessage>>>,
        state: InputState,
    }
    impl Render for HostPreview {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            let events = self.events.clone();
            div().size_full().flex()
                .child(div().w(px(180.)).h_full().child(scene_view(None, 1., self.focus.clone(), self.state.clone(), None,
                    Rc::new(move |event, _, _| events.borrow_mut().push(event)),
                    Rc::new(|_, _, _, _, _, _, _| {}), Rc::new(|_, _, _, _| {}))))
                .child(div().id("other-target").track_focus(&self.other).w(px(20.)).h_full())
        }
    }

    #[::core::prelude::v1::test]
    fn clicking_the_scene_routes_keys_and_releasing_focus_stops_them() {
        let events = Rc::new(RefCell::new(Vec::new()));
        let text = gpui_codepen_guest::rpc::TextService::portable_factory()().unwrap();
        let mut app = HeadlessAppContext::new(text);
        let root_events = events.clone();
        let handle = app.open_window(size(px(200.), px(100.)), |_, cx| {
            cx.new(|cx| HostPreview { focus: cx.focus_handle(), other: cx.focus_handle(),
                events: root_events, state: InputState::default() })
        }).unwrap();
        app.draw_window(handle.into()).unwrap();
        for input in [
            PlatformInput::MouseMove(MouseMoveEvent { position: point(px(20.), px(20.)), ..Default::default() }),
            PlatformInput::MouseDown(MouseDownEvent { position: point(px(20.), px(20.)), ..Default::default() }),
            PlatformInput::MouseUp(MouseUpEvent { position: point(px(20.), px(20.)), ..Default::default() }),
        ] { app.dispatch_input(handle.into(), input).unwrap(); }
        app.draw_window(handle.into()).unwrap();
        let focused = app.update_window(handle.into(), |root, window, cx| {
            root.downcast::<HostPreview>().unwrap().read(cx).focus.is_focused(window)
        }).unwrap();
        assert!(focused, "Clicking the embedded scene must focus its host handle; delivered: {:?}", events.borrow());
        let mut keystroke = Keystroke::parse("space").unwrap();
        keystroke.key_char = Some(" ".into());
        let key = PlatformInput::KeyDown(KeyDownEvent { keystroke: keystroke.clone(), is_held: false, prefer_character_input: false });
        let up = PlatformInput::KeyUp(KeyUpEvent { keystroke });
        let modifiers = PlatformInput::ModifiersChanged(ModifiersChangedEvent {
            modifiers: Modifiers { shift: true, ..Default::default() }, ..Default::default()
        });
        events.borrow_mut().clear();
        app.dispatch_input(handle.into(), key.clone()).unwrap();
        app.dispatch_input(handle.into(), up.clone()).unwrap();
        app.dispatch_input(handle.into(), modifiers.clone()).unwrap();
        assert!(matches!(events.borrow().as_slice(), [
            gpui_codepen_guest::InputMessage::Event(PlatformInput::KeyDown(_)),
            gpui_codepen_guest::InputMessage::Event(PlatformInput::KeyUp(_)),
            gpui_codepen_guest::InputMessage::Event(PlatformInput::ModifiersChanged(_)),
        ]),
            "A clicked preview must forward Space through the host's focused dispatch path");
        app.update_window(handle.into(), |root, window, cx| {
            root.downcast::<HostPreview>().unwrap().update(cx, |view, cx| window.focus(&view.other, cx));
        }).unwrap();
        app.draw_window(handle.into()).unwrap();
        events.borrow_mut().clear();
        app.dispatch_input(handle.into(), key).unwrap();
        app.dispatch_input(handle.into(), up).unwrap();
        app.dispatch_input(handle.into(), modifiers).unwrap();
        assert!(events.borrow().is_empty(), "The preview must not steal keys from another focused target");
    }
}
