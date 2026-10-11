use std::ops::Deref;
use std::rc::Rc;

use futures::channel::oneshot;

use crate::{
    AnyView, App, AppContext as _, Context, Entity, EventEmitter, FocusHandle, Focusable,
    InteractiveElement, IntoElement, ParentElement, PromptButton, PromptLevel, Render,
    StatefulInteractiveElement, Styled, div, opaque_grey, white,
};

use super::Window;

/// The event emitted when a prompt's option is selected.
/// The usize is the index of the selected option, from the actions
/// passed to the prompt.
pub struct PromptResponse(pub usize);

/// A prompt that can be rendered in the window.
pub trait Prompt: EventEmitter<PromptResponse> + Focusable {}

impl<V: EventEmitter<PromptResponse> + Focusable> Prompt for V {}

/// A handle to a prompt that can be used to interact with it.
pub struct PromptHandle {
    sender: oneshot::Sender<usize>,
}

impl PromptHandle {
    pub(crate) fn new(sender: oneshot::Sender<usize>) -> Self {
        Self { sender }
    }

    /// Construct a new prompt handle from a view of the appropriate types
    pub fn with_view<V: Prompt + Render>(
        self,
        view: Entity<V>,
        window: &mut Window,
        cx: &mut App,
    ) -> RenderablePromptHandle {
        let mut sender = Some(self.sender);
        // A prompt that replaces another one restores the focus from before the first.
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
                        // A response from a replaced prompt must not close its replacement.
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

/// A prompt handle capable of being rendered in a window.
pub struct RenderablePromptHandle {
    pub(crate) view: Box<dyn PromptViewHandle>,
    token: Rc<()>,
    previous_focus: Option<FocusHandle>,
}

/// Use this function in conjunction with [App::set_prompt_builder] to force
/// GPUI to always use the fallback prompt renderer.
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
        focus: cx.focus_handle(),
    });

    handle.with_view(renderer, window, cx)
}

/// The default GPUI fallback for rendering prompts, when the platform doesn't support it.
pub struct FallbackPromptRenderer {
    _level: PromptLevel,
    message: String,
    detail: Option<String>,
    actions: Vec<PromptButton>,
    focus: FocusHandle,
}

impl Render for FallbackPromptRenderer {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let prompt = div()
            .cursor_default()
            .track_focus(&self.focus)
            .w_72()
            .bg(white())
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
    use crate::{TestApp, TestAppWindow};
    use std::cell::RefCell;

    struct Root {
        focus: FocusHandle,
    }

    impl Render for Root {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div().size_full().track_focus(&self.focus)
        }
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

    /// A window whose prompts are `CustomPrompt` views, which are also collected in the returned list.
    fn prompt_window() -> (
        TestApp,
        TestAppWindow<Root>,
        Rc<RefCell<Vec<Entity<CustomPrompt>>>>,
    ) {
        let mut app = TestApp::new();
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
        let window = app.open_window(|window, cx| {
            let focus = cx.focus_handle();
            window.focus(&focus, cx);
            Root { focus }
        });
        (app, window, views)
    }

    fn show_prompt(window: &mut TestAppWindow<Root>) -> oneshot::Receiver<usize> {
        window
            .update(|_, window, cx| window.prompt(PromptLevel::Info, "Message", None, &["OK"], cx))
    }

    #[test]
    fn showing_and_answering_a_prompt_requests_a_draw() {
        let (mut app, mut window, views) = prompt_window();
        window.draw();
        assert!(!window.update(|_, window, _| window.invalidator.is_dirty()));

        // Checked inside the same update: `TestAppWindow::update` runs until parked, which draws.
        let mut response = window.update(|_, window, cx| {
            let response = window.prompt(PromptLevel::Info, "Message", None, &["OK"], cx);
            assert!(window.invalidator.is_dirty());
            response
        });

        window.draw();
        app.update_entity(&views.borrow()[0], |_, cx| cx.emit(PromptResponse(0)));
        assert_eq!(response.try_recv().unwrap(), Some(0));
        window.update(|root, window, _| {
            assert!(!window.has_active_prompt());
            assert!(root.focus.is_focused(window));
        });
    }

    #[test]
    fn superseded_response_cannot_close_new_prompt_or_restore_stale_focus() {
        let (mut app, mut window, views) = prompt_window();
        let mut first = show_prompt(&mut window);
        let mut second = show_prompt(&mut window);
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
