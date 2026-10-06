//! Opt-in real-window lifecycle checks used by native CI and the test CLI.

use gpui::{
    App, AsyncApp, Context, FocusHandle, Render, Size, Subscription, Window, WindowHandle,
    WindowOptions, div, prelude::*, px, rgb, size,
};
pub use gpui::{
    WindowCheckEvent, WindowCheckReport, WindowCheckStatus, WindowFrameReport, WindowResizeReport,
};
use std::time::{Duration, Instant};

const POLL: Duration = Duration::from_millis(16);
const TIMEOUT: Duration = Duration::from_secs(5);

struct ProbeWindow {
    focus: FocusHandle,
    _bounds_subscription: Subscription,
    resize_events: usize,
    last_size: Size<gpui::Pixels>,
    render_count: usize,
    revision: usize,
}

impl ProbeWindow {
    fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
        let focus = cx.focus_handle();
        window.focus(&focus, cx);
        let bounds_subscription = cx.observe_window_bounds(window, |view, window, _| {
            view.resize_events += 1;
            view.last_size = window.viewport_size();
        });
        Self {
            focus,
            _bounds_subscription: bounds_subscription,
            resize_events: 0,
            last_size: window.viewport_size(),
            render_count: 0,
            revision: 0,
        }
    }
}

impl Render for ProbeWindow {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        self.render_count += 1;
        div()
            .id("native-window-probe")
            .size_full()
            .track_focus(&self.focus)
            .tab_stop(true)
            .bg(rgb(0x1e293b))
            .text_color(rgb(0xffffff))
            .p_4()
            .child(format!(
                "Native lifecycle probe · revision {}",
                self.revision
            ))
    }
}

/// A completed condition carries its value; `None` means the event loop needs another turn.
async fn wait_for<T>(
    cx: &mut AsyncApp,
    report: &mut WindowCheckReport,
    name: &str,
    mut condition: impl FnMut(&mut AsyncApp) -> Result<Option<T>, String>,
) -> Result<T, String> {
    let started = Instant::now();
    let mut polls = 0;
    loop {
        polls += 1;
        if let Some(value) = condition(cx).map_err(|error| format!("{name}: {error}"))? {
            report.events.push(WindowCheckEvent {
                name: name.into(),
                polls,
                elapsed_ms: started.elapsed().as_millis(),
            });
            return Ok(value);
        }
        if started.elapsed() >= TIMEOUT {
            return Err(format!("{name} did not complete within {TIMEOUT:?}"));
        }
        cx.background_executor().timer(POLL).await;
    }
}

async fn check_visibility(
    cx: &mut AsyncApp,
    report: &mut WindowCheckReport,
    name: &str,
    window: &WindowHandle<ProbeWindow>,
    expected: bool,
) -> Result<bool, String> {
    wait_for(cx, report, name, |cx| {
        let actual = window
            .update(cx, |_, window, _| window.is_visible())
            .map_err(|error| error.to_string())?;
        Ok(match actual {
            Some(value) if value == expected => Some(true),
            None => Some(false), // The backend explicitly does not expose this capability.
            _ => None,
        })
    })
    .await
}

async fn run_lifecycle(cx: &mut AsyncApp, report: &mut WindowCheckReport) -> Result<(), String> {
    cx.update(|cx| cx.activate(true));
    let first = cx
        .open_window(
            WindowOptions::new().show(false).focus(false),
            |window, cx| cx.new(|cx| ProbeWindow::new(window, cx)),
        )
        .map_err(|error| format!("failed to open first native window: {error}"))?;
    let second = cx
        .open_window(
            WindowOptions::new().show(false).focus(false),
            |window, cx| cx.new(|cx| ProbeWindow::new(window, cx)),
        )
        .map_err(|error| format!("failed to open second native window: {error}"))?;

    let first_visible =
        check_visibility(cx, report, "first_initially_hidden", &first, false).await?;
    let second_visible =
        check_visibility(cx, report, "second_initially_hidden", &second, false).await?;
    report
        .capabilities
        .insert("native_visibility".into(), first_visible && second_visible);

    first
        .update(cx, |_, window, _| {
            window.set_visible(true);
            window.set_visible(true);
        })
        .map_err(|error| format!("failed to show first window: {error}"))?;
    check_visibility(cx, report, "first_shown", &first, true).await?;
    activate_window(cx, report, "first_activated", first).await?;

    let renders_before = first
        .read_with(cx, |view, _| view.render_count)
        .map_err(|error| format!("failed to read render count: {error}"))?;
    first
        .update(cx, |view, _, cx| {
            view.revision += 1;
            cx.notify();
        })
        .map_err(|error| format!("failed to invalidate native view: {error}"))?;
    wait_for(cx, report, "redraw_callback", |cx| {
        let renders = first
            .read_with(cx, |view, _| view.render_count)
            .map_err(|error| error.to_string())?;
        Ok((renders > renders_before).then_some(()))
    })
    .await?;

    let focused = first
        .update(cx, |view, window, app| {
            view.focus.focus(window, app);
            view.focus.is_focused(window)
        })
        .map_err(|error| format!("failed to update first window focus: {error}"))?;
    if !focused {
        return Err("GPUI focus handle did not become focused".into());
    }
    report.capabilities.insert("focus_handle".into(), true);

    let (render_count, primitives, capture) = first
        .update(cx, |view, window, _| {
            (
                view.render_count,
                window.rendered_primitive_counts(),
                window.render_to_image(),
            )
        })
        .map_err(|error| format!("failed to inspect native frame: {error}"))?;
    if render_count == 0 || primitives.0 == 0 || primitives.1 + primitives.2 == 0 {
        return Err(format!(
            "native frame was empty (renders={render_count}, primitives={primitives:?})"
        ));
    }
    if let Ok(image) = capture {
        let background = *image.get_pixel(0, 0);
        let painted_pixels = image.pixels().filter(|pixel| **pixel != background).count();
        if painted_pixels == 0 {
            return Err("native frame capture contained no painted pixels".into());
        }
        report.frame = Some(WindowFrameReport {
            render_count,
            quads: primitives.0,
            monochrome_sprites: primitives.1,
            subpixel_sprites: primitives.2,
            polychrome_sprites: primitives.3,
            capture_width: image.width(),
            capture_height: image.height(),
            painted_pixels,
        });
        report
            .capabilities
            .insert("native_render_capture".into(), true);
    } else {
        #[cfg(any(target_os = "macos", target_os = "windows"))]
        return Err("native renderer did not provide a frame capture".into());
        #[cfg(not(any(target_os = "macos", target_os = "windows")))]
        report
            .capabilities
            .insert("native_render_capture".into(), false);
    }

    let before_resize = first
        .read_with(cx, |view, _| view.resize_events)
        .map_err(|error| format!("failed to read resize count: {error}"))?;
    first
        .update(cx, |_, window, _| window.resize(size(px(440.), px(300.))))
        .map_err(|error| format!("failed to request native resize: {error}"))?;
    let actual_size = wait_for(cx, report, "resize_callback", |cx| {
        let (events, actual_size) = first
            .read_with(cx, |view, _| (view.resize_events, view.last_size))
            .map_err(|error| error.to_string())?;
        let matches_request = (actual_size.width - px(440.)).abs() < px(0.5)
            && (actual_size.height - px(300.)).abs() < px(0.5);
        Ok((events > before_resize && matches_request).then_some(actual_size))
    })
    .await?;
    let callback_count = first
        .read_with(cx, |view, _| view.resize_events)
        .map_err(|error| format!("failed to read resize count: {error}"))?;
    report.resize = Some(WindowResizeReport {
        callback_count,
        width: actual_size.width.as_f32(),
        height: actual_size.height.as_f32(),
    });
    report.capabilities.insert("resize_callback".into(), true);

    first
        .update(cx, |_, window, _| {
            window.set_visible(false);
            window.set_visible(false);
        })
        .map_err(|error| format!("failed to hide first window: {error}"))?;
    check_visibility(cx, report, "first_hidden", &first, false).await?;
    first
        .update(cx, |_, window, _| {
            window.set_visible(true);
            window.set_visible(true);
        })
        .map_err(|error| format!("failed to restore first window: {error}"))?;
    check_visibility(cx, report, "first_restored", &first, true).await?;

    second
        .update(cx, |_, window, _| {
            window.set_visible(true);
            window.set_visible(true);
        })
        .map_err(|error| format!("failed to show second window: {error}"))?;
    check_visibility(cx, report, "second_shown", &second, true).await?;
    activate_window(cx, report, "second_activated", second).await?;
    wait_for(cx, report, "focus_transferred", |cx| {
        let first_active = first
            .update(cx, |_, window, _| window.is_window_active())
            .map_err(|error| error.to_string())?;
        Ok((!first_active).then_some(()))
    })
    .await?;
    report.capabilities.insert("native_activation".into(), true);

    for (name, window) in [("first_closed", first), ("second_closed", second)] {
        window
            .update(cx, |_, window, _| window.remove_window())
            .map_err(|error| format!("{name}: {error}"))?;
        wait_for(cx, report, name, |cx| {
            Ok(window.read_with(cx, |_, _| ()).is_err().then_some(()))
        })
        .await?;
    }
    report.capabilities.insert("two_window_close".into(), true);
    Ok(())
}

async fn activate_window(
    cx: &mut AsyncApp,
    report: &mut WindowCheckReport,
    name: &str,
    handle: WindowHandle<ProbeWindow>,
) -> Result<(), String> {
    handle
        .update(cx, |_, window, _| window.activate())
        .map_err(|error| format!("{name}: {error}"))?;
    wait_for(cx, report, name, |cx| {
        let active = handle
            .update(cx, |_, window, _| window.is_window_active())
            .map_err(|error| error.to_string())?;
        Ok(active.then_some(()))
    })
    .await
}

/// Runs real native checks on the calling main thread and delivers their report before quitting.
/// Some native event loops terminate the process on quit, so consume or save results in the callback.
pub fn run_window_checks(on_complete: impl FnOnce(WindowCheckReport) + 'static) {
    crate::application().run(move |cx: &mut App| {
        cx.spawn(async move |cx| {
            let mut report = WindowCheckReport {
                schema_version: 1,
                platform: std::env::consts::OS.into(),
                capabilities: [
                    ("native_visibility".into(), false),
                    ("native_activation".into(), false),
                    ("focus_handle".into(), false),
                    ("native_render_capture".into(), false),
                    ("resize_callback".into(), false),
                    ("two_window_close".into(), false),
                ]
                .into(),
                ..Default::default()
            };
            if let Err(error) = run_lifecycle(cx, &mut report).await {
                report.errors.push(error);
            }
            report.status = if report.errors.is_empty() {
                WindowCheckStatus::Passed
            } else {
                WindowCheckStatus::Failed
            };
            on_complete(report);
            cx.update(|cx| cx.quit());
        })
        .detach();
    });
}
