//! Deterministic input sequences and state assertions for this lesson.
use super::*;

pub(super) fn lesson_scenario() -> anyhow::Result<gpui_test::Scenario<InteractionLesson>> {
    gpui_test::Scenario::new(
        "interaction-lesson",
        "Pointer, hover, focus, and drag/drop",
        size(px(780.), px(700.)),
        |window, cx: &mut App| cx.new(|cx| InteractionLesson::new(window, cx)),
    )?
    .checkpoint_with(
        "initial",
        "Root focus before keyboard navigation",
        Duration::ZERO,
        |cx, view, window| {
            let focused = cx.update_window(window.into(), |_, window, app| {
                view.read(app).root_focused(window)
            })?;
            anyhow::ensure!(focused, "root did not receive initial focus");
            Ok(())
        },
    )?
    .checkpoint_with(
        "clicked",
        "Click count and selected state",
        Duration::from_millis(100),
        |cx, view, window| {
            gpui_test::dispatch_click_on(cx, window.into(), "click-button")?;
            gpui_test::dispatch_click_on(cx, window.into(), "selected-row")?;
            view.read_with(cx, |view, _| {
                anyhow::ensure!(view.clicks == 1, "click count did not update");
                anyhow::ensure!(view.selected, "selection did not toggle");
                Ok(())
            })
        },
    )?
    .checkpoint_with(
        "hover-enter",
        "Real pointer hover updates target state",
        Duration::from_millis(150),
        |cx, view, window| {
            let bounds = cx
                .debug_bounds(window.into(), "hover-target")?
                .ok_or_else(|| anyhow::anyhow!("hover selector is missing"))?;
            gpui_test::dispatch_input(
                cx,
                window.into(),
                PlatformInput::MouseMove(MouseMoveEvent {
                    position: bounds.center(),
                    pressed_button: None,
                    modifiers: gpui::Modifiers::default(),
                }),
            )?;
            view.read_with(cx, |view, _| {
                anyhow::ensure!(view.hovered, "hover state did not update");
                Ok(())
            })
        },
    )?
    .checkpoint_with(
        "mouse-down",
        "Mouse down sets the pressed state",
        Duration::from_millis(175),
        |cx, view, window| {
            let bounds = cx
                .debug_bounds(window.into(), "mouse-target")?
                .ok_or_else(|| anyhow::anyhow!("mouse selector is missing"))?;
            gpui_test::dispatch_input(
                cx,
                window.into(),
                PlatformInput::MouseDown(gpui::MouseDownEvent {
                    button: MouseButton::Left,
                    position: bounds.center(),
                    modifiers: gpui::Modifiers::default(),
                    click_count: 1,
                    first_mouse: false,
                }),
            )?;
            anyhow::ensure!(
                view.read_with(cx, |view, _| view.mouse_pressed),
                "mouse press was not recorded"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "mouse-up",
        "Mouse up clears the pressed state",
        Duration::from_millis(180),
        |cx, view, window| {
            let bounds = cx
                .debug_bounds(window.into(), "mouse-target")?
                .ok_or_else(|| anyhow::anyhow!("mouse selector is missing"))?;
            gpui_test::dispatch_input(
                cx,
                window.into(),
                PlatformInput::MouseUp(gpui::MouseUpEvent {
                    button: MouseButton::Left,
                    position: bounds.center(),
                    modifiers: gpui::Modifiers::default(),
                    click_count: 1,
                }),
            )?;
            anyhow::ensure!(
                !view.read_with(cx, |view, _| view.mouse_pressed),
                "mouse press remained active"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "tab-first",
        "Tab focuses the first control",
        Duration::from_millis(200),
        |cx, view, window| {
            send_key(cx, window.into(), "tab")?;
            let focused = cx.update_window(window.into(), |_, window, app| {
                view.read(app).focused_tab_stop(window)
            })?;
            anyhow::ensure!(focused == Some(0), "focus after Tab: {focused:?}");
            Ok(())
        },
    )?
    .checkpoint_with(
        "tab-second",
        "Tab advances to the second control",
        Duration::from_millis(250),
        |cx, view, window| {
            send_key(cx, window.into(), "tab")?;
            let focused = cx.update_window(window.into(), |_, window, app| {
                view.read(app).focused_tab_stop(window)
            })?;
            anyhow::ensure!(focused == Some(1), "focus after second Tab: {focused:?}");
            Ok(())
        },
    )?
    .checkpoint_with(
        "tab-reverse",
        "Shift+Tab returns to the first control",
        Duration::from_millis(300),
        |cx, view, window| {
            send_key(cx, window.into(), "shift-tab")?;
            let focused = cx.update_window(window.into(), |_, window, app| {
                view.read(app).focused_tab_stop(window)
            })?;
            anyhow::ensure!(focused == Some(0), "focus after Shift+Tab: {focused:?}");
            Ok(())
        },
    )?
    .checkpoint_with(
        "tab-wrap",
        "Shift+Tab wraps to the final tab stop",
        Duration::from_millis(350),
        |cx, view, window| {
            send_key(cx, window.into(), "shift-tab")?;
            let (focused, root_focused) = cx.update_window(window.into(), |_, window, app| {
                let view = view.read(app);
                (view.focused_tab_stop(window), view.root_focused(window))
            })?;
            anyhow::ensure!(
                focused == Some(1),
                "focus after Shift+Tab wrap: {focused:?}"
            );
            anyhow::ensure!(!root_focused, "the non-tab-stop root acquired focus");
            Ok(())
        },
    )?
    .checkpoint_with(
        "drag-drop",
        "A real drag creates a preview and delivers the typed payload",
        Duration::from_millis(400),
        |cx, view, window| {
            let start = cx
                .debug_bounds(window.into(), "drag-item-0")?
                .ok_or_else(|| anyhow::anyhow!("drag source is missing"))?
                .center();
            let end = cx
                .debug_bounds(window.into(), "drop-target")?
                .ok_or_else(|| anyhow::anyhow!("drop target is missing"))?
                .center();
            gpui_test::dispatch_input(
                cx,
                window.into(),
                PlatformInput::MouseDown(gpui::MouseDownEvent {
                    button: MouseButton::Left,
                    position: start,
                    modifiers: gpui::Modifiers::default(),
                    click_count: 1,
                    first_mouse: false,
                }),
            )?;
            gpui_test::dispatch_input(
                cx,
                window.into(),
                PlatformInput::MouseMove(MouseMoveEvent {
                    position: end,
                    pressed_button: Some(MouseButton::Left),
                    modifiers: gpui::Modifiers::default(),
                }),
            )?;
            cx.draw_window(window.into())?;
            anyhow::ensure!(
                cx.debug_bounds(window.into(), "drag-preview")?.is_some(),
                "drag preview did not appear"
            );
            gpui_test::dispatch_input(
                cx,
                window.into(),
                PlatformInput::MouseUp(gpui::MouseUpEvent {
                    button: MouseButton::Left,
                    position: end,
                    modifiers: gpui::Modifiers::default(),
                    click_count: 1,
                }),
            )?;
            cx.draw_window(window.into())?;
            anyhow::ensure!(
                view.read_with(cx, |view, _| view
                    .dropped
                    .is_some_and(|item| item.index == 0)),
                "drop did not deliver item 1"
            );
            anyhow::ensure!(
                cx.debug_bounds(window.into(), "drag-preview")?.is_none(),
                "drag preview remained after drop"
            );
            Ok(())
        },
    )
}

fn send_key(
    cx: &mut gpui::HeadlessAppContext,
    window: gpui::AnyWindowHandle,
    key: &str,
) -> anyhow::Result<()> {
    gpui_test::dispatch_input(
        cx,
        window,
        PlatformInput::KeyDown(KeyDownEvent {
            keystroke: Keystroke::parse(key)?,
            is_held: false,
            prefer_character_input: false,
        }),
    )?;
    Ok(())
}
