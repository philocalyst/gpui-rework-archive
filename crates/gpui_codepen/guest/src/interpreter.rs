use crate::{Frame, PROTOCOL_VERSION, PreviewContext, wire};
use gpui::{prelude::*, *};
use std::{sync::Arc, time::Duration};

struct CaptureRenderer {
    atlas: Arc<SceneAtlas>,
}
impl PlatformHeadlessRenderer for CaptureRenderer {
    fn render_scene_to_image(
        &mut self,
        _: &Scene,
        _: Size<DevicePixels>,
    ) -> anyhow::Result<image::RgbaImage> {
        anyhow::bail!("the host GPUI window renders this scene")
    }
    fn render_scene(&mut self, _: &Scene, _: Size<DevicePixels>) -> anyhow::Result<()> {
        Ok(())
    }
    fn sprite_atlas(&self) -> Arc<dyn PlatformAtlas> {
        self.atlas.clone()
    }
}

/// Runs an ordinary GPUI root entity in a persistent interpreter. All entities,
/// event handlers, closures and scene construction remain inside GPUI and Miri.
pub fn run<V: Render + 'static>(build: impl FnOnce(&mut Window, &mut App) -> Entity<V>) {
    #[cfg(miri)]
    unsafe extern "C" {
        fn gpui_codepen_emit(bytes: *const u8, len: usize);
        fn gpui_codepen_receive(bytes: *mut u8, capacity: usize) -> usize;
    }
    #[cfg(not(miri))]
    panic!("this entry point requires the vendored Miri interpreter");
    #[cfg(miri)]
    {
        unsafe extern "C" {
            fn gpui_codepen_profile(phase: usize);
            fn gpui_codepen_reload_revision() -> usize;
        }
        let profile = |phase| unsafe { gpui_codepen_profile(phase) };
        profile(0);
        crate::rpc::begin_session();
        let text = Arc::new(crate::rpc::RemoteTextSystem::new());
        let atlas = Arc::new(SceneAtlas::new());
        let mut app = HeadlessAppContext::with_platform(text.clone(), Arc::new(()), {
            let atlas = atlas.clone();
            move || {
                Some(Box::new(CaptureRenderer {
                    atlas: atlas.clone(),
                }))
            }
        });
        app.set_automatic_drawing(false);
        app.set_randomize_task_order(false);
        profile(1);
        unsafe {
            gpui_codepen_emit(std::ptr::null(), 0);
        }
        let mut window = None;
        let mut build = Some(build);
        let mut buffer = vec![0; 64 * 1024 + 512];
        let mut previous = None;
        let mut last_frame: Option<Frame> = None;
        let mut scene_bytes = Vec::new();
        let mut frame_bytes = Vec::new();
        let mut live_tiles = collections::HashSet::default();
        let mut revision = 0;
        let hot_reload = std::env::var_os("GPUI_CODEPEN_HOT_RELOAD").as_deref() == Some(std::ffi::OsStr::new("1"));
        loop {
            let len = unsafe { gpui_codepen_receive(buffer.as_mut_ptr(), buffer.len()) };
            if len == 0 {
                break;
            }
            profile(2);
            let updated = if hot_reload { unsafe { gpui_codepen_reload_revision() } } else { 0 };
            if updated != revision {
                app.update(|cx| cx.refresh_windows());
                revision = updated;
            }
            let input: PreviewContext =
                wire::decode_value(&buffer[..len]).expect("invalid GPUI input");
            input.validate().expect("invalid GPUI viewport");
            let fresh = window.is_none();
            if text.refresh_font_generation() {
                app.update(|cx| cx.refresh_windows());
            }
            app.set_subpixel_rendering_supported(input.subpixel_rendering);
            app.update(|cx| {
                if cx.text_rendering_mode() != input.text_rendering_mode {
                    cx.set_text_rendering_mode(input.text_rendering_mode);
                }
            });
            let handle = *window.get_or_insert_with(|| {
                app.open_window_with_scale_factor(
                    input.viewport,
                    input.scale_factor,
                    build.take().unwrap(),
                )
                .expect("GPUI window")
            });
            app.update_window(handle.into(), |_, window, cx| {
                let background = if input.transparent_window {
                    WindowBackgroundAppearance::Transparent
                } else {
                    WindowBackgroundAppearance::Opaque
                };
                if window.background_appearance() != background {
                    window.set_background_appearance(background);
                    cx.refresh_windows();
                }
            })
            .expect("GPUI text coverage policy");
            if previous != Some((input.viewport, input.scale_factor)) {
                let (size, scale) = previous.unwrap_or((input.viewport, input.scale_factor));
                if scale != input.scale_factor {
                    app.set_scale_factor(handle.into(), input.scale_factor)
                        .expect("GPUI density");
                }
                if size != input.viewport {
                    app.set_viewport_size(handle.into(), input.viewport)
                        .expect("GPUI resize");
                }
                previous = Some((input.viewport, input.scale_factor));
            }
            profile(3);
            if fresh {
                app.draw_window(handle.into()).expect("GPUI initial frame");
            }
            if !fresh && input.elapsed_ms > 0 {
                app.advance_clock(Duration::from_millis(input.elapsed_ms.min(60_000)));
            }
            if !fresh {
                app.deliver_next_frame(handle.into())
                    .expect("GPUI frame callbacks");
            }
            for event in input.events {
                match event {
                    crate::InputMessage::Event(event) => {
                        app.dispatch_input(handle.into(), event)
                            .expect("GPUI event");
                    }
                    crate::InputMessage::Text(edit) => {
                        app.with_platform_input_handler(handle.into(), |handler| match edit {
                            crate::TextEdit::Replace { range, text } => {
                                handler.replace_text_in_range(range, &text)
                            }
                            crate::TextEdit::Mark {
                                range,
                                text,
                                selection,
                            } => handler.replace_and_mark_text_in_range(range, &text, selection),
                            crate::TextEdit::Unmark => handler.unmark_text(),
                            crate::TextEdit::Select { range } => {
                                handler.set_selected_text_range(range)
                            }
                        })
                        .expect("GPUI text input");
                    }
                }
            }
            profile(4);
            app.run_until_parked();
            let redrawn = app.draw_window_if_dirty(handle.into()).expect("GPUI draw");
            profile(5);
            let scene = if redrawn || last_frame.is_none() {
                live_tiles.clear();
                let scene = app
                    .capture_live_scene(handle.into(), |tile| {
                        live_tiles.insert(tile.texture_id);
                        atlas.resolve(tile)
                    })
                    .expect("GPUI scene capture");
                atlas.retain_frame_tiles(&live_tiles);
                wire::encode_value_into(&scene, &mut scene_bytes).expect("GPUI scene encoding");
                Some(scene)
            } else {
                None
            };
            profile(6);
            let cursor = app.cursor_style(handle.into()).expect("GPUI cursor");
            let text = app
                .with_platform_input_handler(handle.into(), crate::input::capture)
                .expect("GPUI text context");
            let next_frame_ms = app
                .next_frame_delay(handle.into())
                .expect("GPUI frame demand")
                .map(|delay| delay.as_millis().max(1) as u64);
            let unchanged = scene.is_none() && last_frame.as_ref().is_some_and(|frame| {
                frame.viewport == input.viewport
                    && frame.scale_factor == input.scale_factor
                    && frame.cursor == cursor
                    && frame.text == text
                    && frame.next_frame_ms == next_frame_ms
            });
            if let Some(frame) = &mut last_frame {
                if let Some(scene) = scene {
                    frame.scene = scene;
                }
                frame.viewport = input.viewport;
                frame.scale_factor = input.scale_factor;
                frame.cursor = cursor;
                frame.text = text;
                frame.next_frame_ms = next_frame_ms;
            } else {
                last_frame = Some(Frame {
                    version: PROTOCOL_VERSION,
                    viewport: input.viewport,
                    scale_factor: input.scale_factor,
                    scene: scene.expect("initial GPUI scene"),
                    cursor,
                    text,
                    next_frame_ms,
                });
            }
            if !unchanged {
                wire::encode_cached_scene_into(last_frame.as_ref().unwrap(), &scene_bytes, &mut frame_bytes)
                    .expect("GPUI frame encoding");
            }
            profile(7);
            unsafe {
                gpui_codepen_emit(frame_bytes.as_ptr(), frame_bytes.len());
            }
            profile(8);
        }
    }
}
