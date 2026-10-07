//! Native window options, placement, visibility, and prompting in one small control room.

#[path = "../../shared/prelude.rs"]
mod example_prelude;

use std::time::Duration;

use gpui::{
    App, Bounds, Context, PromptLevel, Render, Window, WindowBounds, WindowKind, WindowOptions,
    div, prelude::*, px, rgb, size,
};

#[derive(Clone)]
struct WindowPreset {
    title: &'static str,
    kind: WindowKind,
    titlebar: bool,
    movable: bool,
    resizable: bool,
    visible: bool,
}

const PRESETS: [WindowPreset; 6] = [
    WindowPreset {
        title: "Normal",
        kind: WindowKind::Normal,
        titlebar: true,
        movable: true,
        resizable: true,
        visible: true,
    },
    WindowPreset {
        title: "Popup",
        kind: WindowKind::PopUp,
        titlebar: true,
        movable: true,
        resizable: false,
        visible: true,
    },
    WindowPreset {
        title: "Custom chrome",
        kind: WindowKind::Normal,
        titlebar: false,
        movable: true,
        resizable: true,
        visible: true,
    },
    WindowPreset {
        title: "Fixed size",
        kind: WindowKind::Normal,
        titlebar: true,
        movable: true,
        resizable: false,
        visible: true,
    },
    WindowPreset {
        title: "Immovable",
        kind: WindowKind::Normal,
        titlebar: true,
        movable: false,
        resizable: true,
        visible: true,
    },
    WindowPreset {
        title: "Initially hidden",
        kind: WindowKind::Normal,
        titlebar: true,
        movable: true,
        resizable: true,
        visible: false,
    },
];

struct WindowSample {
    label: String,
}

impl Render for WindowSample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_3()
            .bg(rgb(0x26364d))
            .text_color(rgb(0xffffff))
            .child(self.label.clone())
            .child("Close this sample window to return here.")
            .child(
                div()
                    .id("close-sample")
                    .px_3()
                    .py_2()
                    .rounded_md()
                    .bg(rgb(0x3857a6))
                    .cursor_pointer()
                    .child("Close")
                    .on_click(|_, window, _| window.remove_window()),
            )
    }
}

struct WindowsLesson {
    restores: usize,
    status: &'static str,
}

impl WindowsLesson {
    fn open_preset(preset: WindowPreset, cx: &mut App) {
        let bounds = Bounds::centered(None, size(px(360.), px(220.)), cx);
        let mut options = WindowOptions::new()
            .window_bounds(Some(WindowBounds::Windowed(bounds)))
            .kind(preset.kind)
            .is_movable(preset.movable)
            .is_resizable(preset.resizable)
            .show(preset.visible);
        if !preset.titlebar {
            options = options.titlebar(None);
        }
        let label = preset.title;
        let handle = cx
            .open_window(options, move |_, cx| {
                cx.new(|_| WindowSample {
                    label: label.into(),
                })
            })
            .expect("open sample window");
        if !preset.visible {
            cx.spawn(async move |cx| {
                cx.background_executor()
                    .timer(Duration::from_millis(250))
                    .await;
                handle
                    .update(cx, |_, window, _| window.set_visible(true))
                    .ok();
            })
            .detach();
        }
    }

    fn open_display_positions(cx: &mut App) {
        let size = size(px(280.), px(100.));
        let margin = px(48.);
        for display in cx.displays() {
            let screen = display.bounds();
            let left = screen.origin.x;
            let top = screen.origin.y;
            let right = left + screen.size.width;
            let bottom = top + screen.size.height;
            let positions = [
                ("upper-left", gpui::point(left + margin, top + margin)),
                (
                    "upper-right",
                    gpui::point(right - size.width - margin, top + margin),
                ),
                (
                    "lower-left",
                    gpui::point(left + margin, bottom - size.height - margin),
                ),
                (
                    "lower-right",
                    gpui::point(right - size.width - margin, bottom - size.height - margin),
                ),
            ];
            for (name, origin) in positions {
                let bounds = Bounds { origin, size };
                let label = format!("{:?} · {}", display.id(), name);
                cx.open_window(
                    WindowOptions::new()
                        .window_bounds(Some(WindowBounds::Windowed(bounds)))
                        .display_id(Some(display.id())),
                    move |_, cx| cx.new(|_| WindowSample { label }),
                )
                .expect("open positioned sample");
            }
        }
    }

    fn hide_temporarily(&mut self, window: &mut Window, cx: &mut Context<Self>) {
        let handle = window.window_handle();
        window.set_visible(false);
        cx.spawn(async move |this, cx| {
            cx.background_executor().timer(Duration::from_secs(2)).await;
            this.update(cx, |this, cx| {
                this.restores += 1;
                this.status = "The hidden window returned.";
                cx.notify();
            })
            .ok();
            handle
                .update(cx, |_, window, _| window.set_visible(true))
                .ok();
        })
        .detach();
    }
}

impl Render for WindowsLesson {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .flex_col()
            .gap_4()
            .p_6()
            .bg(rgb(0x111827))
            .text_color(rgb(0xf3f4f6))
            .child(
                div()
                    .text_xl()
                    .font_weight(gpui::FontWeight::BOLD)
                    .child("Windows"),
            )
            .child(
                "Open small samples to compare native options. Behavior varies by window manager.",
            )
            .child(
                div()
                    .flex()
                    .flex_wrap()
                    .gap_2()
                    .children(PRESETS.iter().cloned().map(|preset| {
                        action_button(
                            preset.title,
                            cx.listener(move |_, _, _, cx| {
                                Self::open_preset(preset.clone(), cx);
                            }),
                        )
                    }))
                    .child(action_button(
                        "Four corners per display",
                        cx.listener(|_, _, _, cx| Self::open_display_positions(cx)),
                    ))
                    .child(action_button(
                        "Prompt",
                        cx.listener(|_, _, window, cx| {
                            let answer = window.prompt(
                                PromptLevel::Info,
                                "Close this sample?",
                                None,
                                &["Close", "Cancel"],
                                cx,
                            );
                            cx.spawn(async move |_, _| {
                                let _ = answer.await;
                            })
                            .detach();
                        }),
                    ))
                    .child(action_button(
                        "Hide and restore",
                        cx.listener(|this, _, window, cx| this.hide_temporarily(window, cx)),
                    )),
            )
            .child(format!("Restores: {} · {}", self.restores, self.status))
    }
}

fn action_button(
    label: &'static str,
    callback: impl Fn(&gpui::ClickEvent, &mut Window, &mut App) + 'static,
) -> gpui::Stateful<gpui::Div> {
    div()
        .id(label)
        .px_3()
        .py_2()
        .rounded_md()
        .bg(rgb(0x334155))
        .cursor_pointer()
        .hover(|style| style.bg(rgb(0x475569)))
        .on_click(move |event, window, cx| callback(event, window, cx))
        .child(label)
}

fn main() {
    let smoke = std::env::args().any(|arg| arg == "--smoke");
    gpui_platform::application().run(move |cx: &mut App| {
        let options = example_prelude::centered_window(620., 420., cx);
        let view = cx.new(|_| WindowsLesson {
            restores: 0,
            status: "No native operation yet.",
        });
        let window = cx
            .open_window(options, move |_, _| view)
            .expect("open windows lesson");
        if smoke {
            cx.spawn(async move |cx| {
                for visible in [false, true, false, true] {
                    cx.background_executor()
                        .timer(Duration::from_millis(250))
                        .await;
                    window
                        .update(cx, |_, window, _| window.set_visible(visible))
                        .ok();
                }
                cx.background_executor()
                    .timer(Duration::from_millis(100))
                    .await;
                cx.update(|cx| cx.quit());
            })
            .detach();
        }
        example_prelude::init_example(cx, "Windows");
    });
}
