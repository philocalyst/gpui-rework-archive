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
pub type ResizeHandler = Rc<dyn Fn(Size<Pixels>, f32, &mut Window, &mut App)>;

pub(crate) fn scene_view(
    scene: Option<Arc<ImportedScene>>,
    scale: f32,
    focus: FocusHandle,
    state: InputState,
    frame: Option<Arc<gpui_codepen_guest::Frame>>,
    input: InputHandler,
    resize: ResizeHandler,
) -> impl IntoElement {
    let InputState {
        pressed,
        hovered,
        touches,
        file_drop,
    } = state;
    div()
        .id("gpui-interpreter-scene")
        .size_full()
        .track_focus(&focus)
        .child(
            canvas(
                move |bounds, window, cx| {
                    let hitbox = window.insert_hitbox(bounds, HitboxBehavior::Normal);
                    let density = window.scale_factor();
                    window.defer(cx, move |window, cx| {
                        resize(bounds.size, density, window, cx)
                    });
                    hitbox
                },
                move |bounds, hitbox, window, cx| {
                    if let Some(scene) = scene {
                        if let Err(e) = window.paint_scene(&scene, bounds, scale) {
                            log::error!("could not compose GPUI scene: {e}");
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
                    let key_input = input.clone();
                    let key_focus = focus.clone();
                    window.on_key_event(move |event: &KeyDownEvent, phase, window, cx| {
                        if phase == DispatchPhase::Bubble && key_focus.is_focused(window) {
                            key_input(event.clone().to_platform_input().into(), window, cx);
                            // Native committed text and IME composition arrive separately
                            // through the installed PlatformInputHandler.
                            if event.keystroke.key_char.is_none()
                                || event.keystroke.modifiers.control
                                || event.keystroke.modifiers.platform
                            {
                                cx.stop_propagation();
                            }
                        }
                    });
                    let key_input = input.clone();
                    let key_focus = focus.clone();
                    window.on_key_event(move |event: &KeyUpEvent, phase, window, cx| {
                        if phase == DispatchPhase::Bubble && key_focus.is_focused(window) {
                            key_input(event.clone().to_platform_input().into(), window, cx);
                            cx.stop_propagation();
                        }
                    });
                    let handler = input.clone();
                    window.on_modifiers_changed(move |event, window, cx| {
                        if focus.is_focused(window) {
                            handler(event.clone().to_platform_input().into(), window, cx);
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
