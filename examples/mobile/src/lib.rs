//! Shared Rust entry points and acceptance view used by the iOS and Android hosts.
use gpui::{
    App, Context, Render, ScrollHandle, Window, WindowHandle, WindowOptions, div, prelude::*,
};
use gpui_elements::editable_text::text_input;

/// Small interactive view used to validate host input, accessibility, and redraw.
pub struct MobileExample {
    count: usize,
    scroll_handle: ScrollHandle,
    last_viewport_geometry: Option<(gpui::Size<gpui::Pixels>, gpui::Pixels)>,
}

impl Render for MobileExample {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let count_text = format!("Count: {}", self.count);
        let lifecycle_text = if window.is_window_active() {
            "Lifecycle: active"
        } else {
            "Lifecycle: inactive"
        };
        let insets = window.insets();
        let ime_bottom = f32::from(insets.ime.bottom).round() as i32;
        let effective_bottom = insets.effective().bottom;
        let viewport_geometry = (window.viewport_size(), effective_bottom);
        if self.last_viewport_geometry != Some(viewport_geometry)
            && insets.ime.bottom > gpui::px(0.)
        {
            // The editor is the sixth direct child of the tracked scroll view.
            // A one-shot request on viewport changes keeps it above the keyboard
            // without fighting a user's later scrolling.
            self.scroll_handle.scroll_to_item(5);
        }
        self.last_viewport_geometry = Some(viewport_geometry);
        div()
            .size_full()
            // GPUI defaults to black text; NativeActivity surfaces start black.
            // Paint an explicit light canvas so the acceptance sample is visible.
            .bg(gpui::rgb(0xffffff))
            .flex()
            .flex_col()
            .child(
                div()
                    .id("acceptance.scroll")
                    .flex_1()
                    .min_h_0()
                    .flex()
                    .flex_col()
                    .items_center()
                    .overflow_y_scroll()
                    .track_scroll(&self.scroll_handle)
                    .gap_4()
                    .p_4()
                    .pb(gpui::px(16.))
                    .child(
                        div()
                            .id("acceptance.heading")
                            .role(accesskit::Role::Heading)
                            .aria_label("GPUI mobile acceptance")
                            .child("GPUI mobile acceptance"),
                    )
                    .child(
                        div()
                            .id("acceptance.lifecycle")
                            .role(accesskit::Role::Label)
                            .aria_label(lifecycle_text)
                            .child(lifecycle_text),
                    )
                    .child(
                        div()
                            .id("acceptance.keyboard-inset")
                            .role(accesskit::Role::Label)
                            .aria_label(format!("Keyboard inset: {ime_bottom} px"))
                            .child(format!("Keyboard inset: {ime_bottom} px")),
                    )
                    .child(
                        div()
                            .id("counter.status")
                            .role(accesskit::Role::Status)
                            .aria_label(count_text.clone())
                            .child(count_text),
                    )
                    .child(
                        div()
                            .id("counter.increment")
                            .role(accesskit::Role::Button)
                            .aria_label("Increment")
                            .on_click(cx.listener(|this, _event, _window, cx| {
                                this.count += 1;
                                cx.notify();
                            }))
                            .child("Increment"),
                    )
                    .child(
                        text_input("acceptance.editor")
                            .aria_label("Editor")
                            .placeholder("Editor")
                            .placeholder_color(gpui::rgb(0x666666))
                            .w_64()
                            .border_1()
                            .border_color(gpui::rgb(0x888888))
                            .p_2(),
                    )
                    .children((0..12).map(|index| div().child(format!("Scroll item {index}"))))
                    .child(
                        div()
                            .id("acceptance.scroll-end")
                            .role(accesskit::Role::Label)
                            .aria_label("Scroll end")
                            .child("Scroll end"),
                    ),
            )
            // Reserve the effective system/IME inset as layout space, so the
            // scroll viewport itself ends above the keyboard.
            .child(div().h(effective_bottom).flex_shrink_0())
    }
}

pub fn open_main_window(cx: &mut App) -> anyhow::Result<WindowHandle<MobileExample>> {
    cx.open_window(WindowOptions::default(), |_window, cx| {
        cx.new(|_| MobileExample {
            count: 0,
            scroll_handle: ScrollHandle::new(),
            last_viewport_geometry: None,
        })
    })
}

/// Run the shared example through the selected GPUI CE platform.
pub fn run() {
    gpui_platform::application().run(|cx| {
        open_main_window(cx).expect("failed to open mobile example window");
        cx.activate(true);
    });
}

#[cfg(target_os = "android")]
#[unsafe(no_mangle)]
pub fn android_main(app: android_activity::AndroidApp) {
    gpui_mobile::android::jni::run_native_activity(app, |cx| {
        if let Err(error) = open_main_window(cx) {
            log::error!("failed to open mobile example window: {error:#}");
        }
    });
}
