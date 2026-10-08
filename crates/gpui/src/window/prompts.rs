use std::ops::Deref;
use std::rc::Rc;

use futures::channel::oneshot;

use crate::{
    AnyView, App, AppContext as _, Context, Entity, EventEmitter, FocusHandle, Focusable,
    InteractiveElement, IntoElement, ParentElement, PromptButton, PromptLevel, Render, Role,
    StatefulInteractiveElement, Styled, black, div, opaque_grey, rgb, white,
};

use super::Window;
use crate::util::FluentBuilder;

/// Completes an in-window prompt with a zero-based answer index.
///
/// Emit this from a view attached through [`PromptHandle::with_view`]. The
/// first response resolves [`Window::prompt`]'s receiver. If this prompt is
/// still displayed, it also removes the view and restores its previous focus
/// target. The index is forwarded unchanged;
/// the view must choose a valid index from the supplied answer list.
pub struct PromptResponse(pub usize);

/// A focusable view that can report a [`PromptResponse`].
///
/// Implement [`Focusable`] and [`EventEmitter<PromptResponse>`] to obtain the
/// blanket implementation. A prompt builder also needs [`Render`] to attach
/// the view with [`PromptHandle::with_view`]. This marker supplies no buttons,
/// keyboard handling, accessibility description, or dismissal policy.
pub trait Prompt: EventEmitter<PromptResponse> + Focusable {}

impl<V: EventEmitter<PromptResponse> + Focusable> Prompt for V {}

/// The one-shot response channel supplied to a custom prompt builder.
///
/// Consume it with [`Self::with_view`] to connect the prompt's view to the
/// waiting caller. Dropping it without attaching a view cancels the receiver.
pub struct PromptHandle {
    sender: oneshot::Sender<usize>,
}

impl PromptHandle {
    pub(crate) fn new(sender: oneshot::Sender<usize>) -> Self {
        Self { sender }
    }

    /// Connects `view` to the response channel and gives it GPUI focus.
    ///
    /// The returned handle retains the view for [`Window::prompt`] to render
    /// above the root. The first [`PromptResponse`] removes it and restores
    /// the focus handle selected before attachment. Later responses have no
    /// effect. Focus restoration does not activate the native window.
    ///
    /// [`Window::prompt`] requests the draw that installs the view's input
    /// handlers. If a later prompt replaces this one, an eventual response
    /// from this view can still resolve its receiver, but cannot remove the
    /// newer prompt or change its focus.
    pub fn with_view<V: Prompt + Render>(
        self,
        view: Entity<V>,
        window: &mut Window,
        cx: &mut App,
    ) -> RenderablePromptHandle {
        let mut sender = Some(self.sender);
        let previous_focus = window.prompt.as_ref().map_or_else(
            || window.focused(cx),
            |prompt| prompt.previous_focus.clone(),
        );
        let restore_focus = previous_focus.clone();
        let token = Rc::new(());
        let response_token = token.clone();
        let window_handle = window.window_handle();
        cx.subscribe(&view, move |_: Entity<V>, e: &PromptResponse, cx| {
            if let Some(sender) = sender.take() {
                sender.send(e.0).ok();
                window_handle
                    .update(cx, |_, window, cx| {
                        if !window
                            .prompt
                            .as_ref()
                            .is_some_and(|prompt| Rc::ptr_eq(&prompt.token, &response_token))
                        {
                            return;
                        }
                        window.prompt.take();
                        if let Some(previous_focus) = &restore_focus {
                            window.focus(previous_focus, cx);
                        } else {
                            window.blur(cx);
                        }
                        window.refresh();
                    })
                    .ok();
            }
        })
        .detach();

        window.focus(&view.focus_handle(cx), cx);

        RenderablePromptHandle {
            view: Box::new(view),
            token,
            previous_focus,
        }
    }
}

/// An attached prompt view retained by [`Window::prompt`].
///
/// Construct this through [`PromptHandle::with_view`] in an
/// [`App::set_prompt_builder`] callback. It owns the view until a response
/// removes it, a later in-window prompt replaces it, or the window closes.
pub struct RenderablePromptHandle {
    pub(crate) view: Box<dyn PromptViewHandle>,
    token: Rc<()>,
    previous_focus: Option<FocusHandle>,
}

/// Builds GPUI's in-window prompt instead of a native platform dialog.
///
/// Install with `cx.set_prompt_builder(gpui::fallback_prompt_renderer)` to
/// use it on every platform. Without that override, [`Window::prompt`] uses
/// it only when the platform supplies no native prompt. See
/// [`FallbackPromptRenderer`] for appearance and keyboard behavior.
pub fn fallback_prompt_renderer(
    level: PromptLevel,
    message: &str,
    detail: Option<&str>,
    actions: &[PromptButton],
    handle: PromptHandle,
    window: &mut Window,
    cx: &mut App,
) -> RenderablePromptHandle {
    let renderer = cx.new(|cx| FallbackPromptRenderer {
        _level: level,
        message: message.to_string(),
        detail: detail.map(ToString::to_string),
        actions: actions.to_vec(),
        button_focus: actions
            .iter()
            .map(|_| cx.focus_handle().tab_stop(true))
            .collect(),
        focus: cx.focus_handle(),
    });

    handle.with_view(renderer, window, cx)
}

/// The built-in in-window prompt view.
///
/// It displays a message, optional detail, and answers in their supplied
/// order. Tab and Shift-Tab cycle through the answers; Enter or Space
/// activates a focused answer. Escape chooses the first [`PromptButton::Cancel`],
/// when one exists. Enter while the prompt container has focus chooses the
/// first [`PromptButton::Ok`], or the first answer if none is marked `Ok`.
///
/// Its fixed light palette and layout do not adapt to an application's theme;
/// the severity level currently does not change its appearance. Install a
/// builder with [`App::set_prompt_builder`] for application styling or more
/// elaborate dialog behavior. Application key bindings can consume a key
/// before this view's raw key listener receives it.
pub struct FallbackPromptRenderer {
    _level: PromptLevel,
    message: String,
    detail: Option<String>,
    actions: Vec<PromptButton>,
    button_focus: Vec<FocusHandle>,
    focus: FocusHandle,
}

impl Render for FallbackPromptRenderer {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let prompt = div()
            .id("prompt")
            .role(Role::Dialog)
            .aria_label(self.message.clone())
            .when_some(self.detail.clone(), |prompt, detail| {
                prompt.aria_description(detail)
            })
            .cursor_default()
            .track_focus(&self.focus)
            .on_key_down(
                cx.listener(|this, event: &crate::KeyDownEvent, window, cx| {
                    let stroke = &event.keystroke;
                    if stroke.modifiers.control
                        || stroke.modifiers.alt
                        || stroke.modifiers.platform
                        || stroke.modifiers.function
                    {
                        return;
                    }
                    match stroke.key.as_str() {
                        "tab" => {
                            let current = this
                                .button_focus
                                .iter()
                                .position(|focus| focus.is_focused(window));
                            let count = this.button_focus.len();
                            if count > 0 {
                                let next = if stroke.modifiers.shift {
                                    current.map_or(count - 1, |index| (index + count - 1) % count)
                                } else {
                                    current.map_or(0, |index| (index + 1) % count)
                                };
                                window.focus(&this.button_focus[next], cx);
                            }
                            cx.stop_propagation();
                        }
                        "escape" if !stroke.modifiers.shift => {
                            if let Some(index) =
                                this.actions.iter().position(PromptButton::is_cancel)
                            {
                                cx.emit(PromptResponse(index));
                                cx.stop_propagation();
                            }
                        }
                        "enter" if !stroke.modifiers.shift && this.focus.is_focused(window) => {
                            if !this.actions.is_empty() {
                                let index = this
                                    .actions
                                    .iter()
                                    .position(|answer| matches!(answer, PromptButton::Ok(_)))
                                    .unwrap_or(0);
                                cx.emit(PromptResponse(index));
                                cx.stop_propagation();
                            }
                        }
                        _ => {}
                    }
                }),
            )
            .w_72()
            .bg(white())
            .text_color(black())
            .rounded_lg()
            .overflow_hidden()
            .p_3()
            .child(
                div()
                    .w_full()
                    .flex()
                    .flex_row()
                    .justify_around()
                    .child(div().overflow_hidden().child(self.message.clone())),
            )
            .children(self.detail.clone().map(|detail| {
                div()
                    .w_full()
                    .flex()
                    .flex_row()
                    .justify_around()
                    .text_sm()
                    .mb_2()
                    .child(div().child(detail))
            }))
            .children(self.actions.iter().enumerate().map(|(ix, action)| {
                div()
                    .flex()
                    .flex_row()
                    .justify_around()
                    .border_1()
                    .border_color(opaque_grey(0.2, 0.5))
                    .mt_1()
                    .rounded_xs()
                    .cursor_pointer()
                    .text_sm()
                    .child(action.label().clone())
                    .id(ix)
                    .role(Role::Button)
                    .aria_label(action.label().clone())
                    .track_focus(&self.button_focus[ix])
                    .focus_visible(|style| style.ring_2().ring_color(rgb(0x3478c8)))
                    .on_click(cx.listener(move |_, _, _, cx| {
                        cx.emit(PromptResponse(ix));
                        cx.stop_propagation();
                    }))
            }));

        div()
            .occlude()
            .size_full()
            .child(
                div()
                    .size_full()
                    .bg(opaque_grey(0.5, 0.6))
                    .absolute()
                    .top_0()
                    .left_0(),
            )
            .child(
                div()
                    .size_full()
                    .absolute()
                    .top_0()
                    .left_0()
                    .flex()
                    .flex_col()
                    .justify_around()
                    .child(
                        div()
                            .w_full()
                            .flex()
                            .flex_row()
                            .justify_around()
                            .child(prompt),
                    ),
            )
    }
}

impl EventEmitter<PromptResponse> for FallbackPromptRenderer {}

impl Focusable for FallbackPromptRenderer {
    fn focus_handle(&self, _: &crate::App) -> FocusHandle {
        self.focus.clone()
    }
}

pub(crate) trait PromptViewHandle {
    fn any_view(&self) -> AnyView;
}

impl<V: Prompt + Render> PromptViewHandle for Entity<V> {
    fn any_view(&self) -> AnyView {
        self.clone().into()
    }
}

pub(crate) enum PromptBuilder {
    Default,
    Custom(
        Box<
            dyn Fn(
                PromptLevel,
                &str,
                Option<&str>,
                &[PromptButton],
                PromptHandle,
                &mut Window,
                &mut App,
            ) -> RenderablePromptHandle,
        >,
    ),
}

impl Deref for PromptBuilder {
    type Target = dyn Fn(
        PromptLevel,
        &str,
        Option<&str>,
        &[PromptButton],
        PromptHandle,
        &mut Window,
        &mut App,
    ) -> RenderablePromptHandle;

    fn deref(&self) -> &Self::Target {
        match self {
            Self::Default => &fallback_prompt_renderer,
            Self::Custom(f) => f.as_ref(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{KeyUpEvent, Keystroke, TestApp, TestAppWindow};
    use std::cell::RefCell;

    struct Root {
        focus: FocusHandle,
    }

    impl Render for Root {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div().size_full().track_focus(&self.focus)
        }
    }

    fn fallback_window() -> (TestApp, TestAppWindow<Root>) {
        let mut app = TestApp::new();
        app.update(|cx| cx.set_prompt_builder(fallback_prompt_renderer));
        let window = app.open_window(|window, cx| {
            let focus = cx.focus_handle();
            window.focus(&focus, cx);
            Root { focus }
        });
        (app, window)
    }

    fn choose_with_key(window: &mut TestAppWindow<Root>, key: &str) {
        window.simulate_keystroke(key);
        window.simulate_event(KeyUpEvent {
            keystroke: Keystroke::parse(key).unwrap(),
        });
    }

    #[test]
    fn fallback_answers_are_named_and_keyboard_activation_restores_focus() {
        for key in ["enter", "space"] {
            let (_app, mut window) = fallback_window();
            window.draw();
            let mut response = window.update(|_, window, cx| {
                window.set_a11y_forced(true);
                let response = window.prompt(
                    PromptLevel::Warning,
                    "Save changes?",
                    None,
                    &[
                        PromptButton::ok("Save"),
                        PromptButton::cancel("Keep editing"),
                    ],
                    cx,
                );
                assert!(
                    window.invalidator.is_dirty(),
                    "showing a prompt must request a draw"
                );
                response
            });
            window.draw();
            window.update(|_, window, _| {
                let labels: Vec<_> = window
                    .a11y_tree()
                    .unwrap()
                    .nodes
                    .iter()
                    .filter(|(_, node)| node.role() == Role::Button)
                    .filter_map(|(_, node)| node.label())
                    .collect();
                assert_eq!(labels, ["Save", "Keep editing"]);
            });

            window.simulate_keystroke("tab");
            window.draw();
            let first = window.update(|_, window, cx| window.focused(cx).unwrap());
            window.simulate_keystroke("shift-tab");
            window.draw();
            assert!(window.update(|_, window, cx| window.focused(cx).unwrap() != first));
            window.simulate_keystroke("tab");
            window.draw();
            assert!(window.update(|_, window, _| first.is_focused(window)));
            choose_with_key(&mut window, key);
            assert_eq!(response.try_recv().unwrap(), Some(0));
            window.update(|root, window, _| {
                assert!(!window.has_active_prompt());
                assert!(root.focus.is_focused(window));
            });
        }
    }

    #[test]
    fn fallback_container_enter_uses_ok_role_and_escape_uses_cancel_role() {
        for (key, expected) in [("enter", 2), ("escape", 1)] {
            let (_app, mut window) = fallback_window();
            let mut response = window.update(|_, window, cx| {
                window.prompt(
                    PromptLevel::Info,
                    "Continue?",
                    None,
                    &[
                        PromptButton::new("Other"),
                        PromptButton::cancel("Back"),
                        PromptButton::ok("Continue"),
                    ],
                    cx,
                )
            });
            window.draw();
            choose_with_key(&mut window, key);
            assert_eq!(response.try_recv().unwrap(), Some(expected));
        }
    }

    #[test]
    fn fallback_without_answers_ignores_activation_without_panicking() {
        let (_app, mut window) = fallback_window();
        let mut response = window.update(|_, window, cx| {
            window.prompt(
                PromptLevel::Info,
                "No answers",
                None,
                &[] as &[PromptButton],
                cx,
            )
        });
        window.draw();
        for key in ["tab", "shift-tab", "enter", "escape"] {
            choose_with_key(&mut window, key);
        }
        assert_eq!(response.try_recv().unwrap(), None);
        assert!(window.update(|_, window, _| window.has_active_prompt()));
    }

    struct CustomPrompt {
        focus: FocusHandle,
    }

    impl Render for CustomPrompt {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div().track_focus(&self.focus)
        }
    }
    impl Focusable for CustomPrompt {
        fn focus_handle(&self, _: &App) -> FocusHandle {
            self.focus.clone()
        }
    }
    impl EventEmitter<PromptResponse> for CustomPrompt {}

    #[test]
    fn superseded_response_cannot_close_new_prompt_or_restore_stale_focus() {
        let (mut app, mut window) = fallback_window();
        let views = Rc::new(RefCell::new(Vec::new()));
        app.update({
            let views = views.clone();
            move |cx| {
                cx.set_prompt_builder(move |_, _, _, _, handle, window, cx| {
                    let view = cx.new(|cx| CustomPrompt {
                        focus: cx.focus_handle(),
                    });
                    views.borrow_mut().push(view.clone());
                    handle.with_view(view, window, cx)
                })
            }
        });
        let mut first = window
            .update(|_, window, cx| window.prompt(PromptLevel::Info, "First", None, &["OK"], cx));
        let mut second = window
            .update(|_, window, cx| window.prompt(PromptLevel::Info, "Second", None, &["OK"], cx));
        let first_view = views.borrow()[0].clone();
        let second_view = views.borrow()[1].clone();
        app.update_entity(&first_view, |_, cx| cx.emit(PromptResponse(0)));
        assert_eq!(first.try_recv().unwrap(), Some(0));
        assert_eq!(second.try_recv().unwrap(), None);
        window.update(|_, window, cx| {
            assert!(window.has_active_prompt());
            assert!(second_view.read(cx).focus.is_focused(window));
        });
        app.update_entity(&second_view, |_, cx| cx.emit(PromptResponse(0)));
        assert_eq!(second.try_recv().unwrap(), Some(0));
        window.update(|root, window, _| {
            assert!(!window.has_active_prompt());
            assert!(root.focus.is_focused(window));
        });
    }
}
