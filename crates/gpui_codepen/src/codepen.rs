use crate::{
    highlight::rust_highlights,
    renderer::{ErrorHandler, InputHandler, InputState, ResizeHandler, scene_view},
    session::{Backend, FailureKind, Reply, Request, Session},
};
use gpui::{
    App, Context, Entity, EventEmitter, SharedString, StyleRefinement, Subscription, Task, Window,
    actions, div, prelude::*, px, rgb,
};
use gpui_ce_elements::editable_text::{
    EditableTextState, StringStorage, TextChanged, TextHighlights, TextLimitExceeded, text_area,
};
use std::{collections::VecDeque, rc::Rc, time::Duration};

actions!(codepen, [Run]);
pub struct CodeChanged(pub String);

/// Controller state for native hosts and browser editor shells. Observe the
/// Codepen entity with GPUI's ordinary `Context::observe` to receive changes.
#[derive(Clone, Debug, serde::Serialize)]
pub struct CodepenStatus {
    pub revision: u64,
    pub running: bool,
    pub has_preview: bool,
    pub diagnostics: String,
    pub failure: Option<FailureKind>,
    pub elapsed_ms: u64,
    pub auto_run: bool,
}

/// A native GPUI editor and preview, backed exclusively by vendored Miri.
pub struct Codepen {
    pub editor: Entity<EditableTextState>,
    pub session: Session,
    editor_view: Entity<CodeEditor>,
    preview: Entity<Preview>,
    source: String,
    line_count: usize,
    auto_run: bool,
    diagnostics_expanded: bool,
    show_preview: bool,
    restart: bool,
    pending: Task<()>,
    animation: Task<()>,
    last_request: web_time::Instant,
    _changes: Vec<Subscription>,
    input_notice: Option<String>,
    displayed_source: Option<String>,
    events: VecDeque<gpui_codepen_guest::InputMessage>,
    viewport: gpui::Size<gpui::Pixels>,
    scale_factor: f32,
    viewport_ready: bool,
    render_options_revision: u64,
    preview_visible: bool,
    subpixel_rendering: bool,
    text_rendering_mode: gpui::TextRenderingMode,
    transparent_window: bool,
    preview_only: bool,
    #[cfg(not(target_family = "wasm"))]
    worker: Worker,
}
impl EventEmitter<CodeChanged> for Codepen {}

struct CodeEditor {
    state: Entity<EditableTextState>,
    highlights: TextHighlights,
    _state_changed: Subscription,
}
impl Render for CodeEditor {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div()
            .flex()
            .flex_col()
            .size_full()
            .min_h_0()
            .min_w_0()
            .rounded_xl()
            .overflow_hidden()
            .bg(rgb(0x16221e))
            .child(panel_heading("component.rs", "RUST"))
            .child(
                text_area("codepen-source")
                    .state(self.state.downgrade())
                    .flex_1()
                    .min_h_0()
                    .w_full()
                    .p_5()
                    .font_family("Lilex")
                    .text_size(px(13.))
                    .line_height(px(22.))
                    .text_color(rgb(0xd7e4dc))
                    .shared_highlights(self.highlights.clone())
                    .caret_color(gpui::rgb_to_hsla(rgb(0xb0e5c0)))
                    .caret_blink_interval_500ms()
                    .whitespace_nowrap()
                    .overflow_scroll(),
            )
    }
}
struct Preview {
    frame: Option<std::sync::Arc<gpui_codepen_guest::Frame>>,
    imported_frame: Option<std::sync::Arc<gpui_codepen_guest::Frame>>,
    imported: Option<std::sync::Arc<gpui::ImportedScene>>,
    resources: gpui::SceneResources,
    focus: gpui::FocusHandle,
    input_state: InputState,
    on_input: InputHandler,
    on_resize: ResizeHandler,
    on_error: ErrorHandler,
    failed_frame: Option<std::sync::Arc<gpui_codepen_guest::Frame>>,
}
impl Render for Preview {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        if let Some(frame) = &self.frame {
            if self
                .imported_frame
                .as_ref()
                .is_none_or(|previous| !std::sync::Arc::ptr_eq(previous, frame))
                && self
                    .failed_frame
                    .as_ref()
                    .is_none_or(|failed| !std::sync::Arc::ptr_eq(failed, frame))
            {
                if self.imported_frame.as_ref().is_some_and(|previous| {
                    previous.scale_factor == frame.scale_factor && previous.scene == frame.scene
                }) {
                    // Cursor, IME and timing can change without repainting. The
                    // imported scene already owns the identical atlas leases.
                    self.imported_frame = Some(frame.clone());
                    self.failed_frame = None;
                } else {
                    match window.import_scene_capture(&frame.scene, &mut self.resources) {
                        Ok(scene) => {
                            self.imported = Some(std::sync::Arc::new(scene));
                            self.imported_frame = Some(frame.clone());
                            self.failed_frame = None;
                        }
                        Err(e) => {
                            self.failed_frame = Some(frame.clone());
                            let frame = frame.clone();
                            let error = self.on_error.clone();
                            window.defer(cx, move |window, cx| {
                                error(
                                    frame,
                                    format!("Could not import GPUI scene: {e:#}"),
                                    window,
                                    cx,
                                )
                            });
                        }
                    }
                }
            }
        }
        scene_view(
            self.imported.clone(),
            self.imported_frame.as_ref().map_or(1., |f| f.scale_factor),
            self.focus.clone(),
            self.input_state.clone(),
            self.imported_frame.clone(),
            self.on_input.clone(),
            self.on_resize.clone(),
            self.on_error.clone(),
        )
    }
}
impl Codepen {
    pub fn new(source: impl Into<String>, cx: &mut Context<Self>) -> Self {
        let source = source.into();
        let editor = cx.new(|cx| {
            EditableTextState::new(StringStorage::from(source.clone()), cx)
                .with_max_bytes(gpui_codepen_guest::MAX_SOURCE_BYTES)
        });
        let editor_view = cx.new(|cx| CodeEditor {
            state: editor.clone(),
            highlights: TextHighlights::new(rust_highlights(&source)),
            _state_changed: cx.observe(&editor, |_, _, cx| cx.notify()),
        });
        let weak = cx.weak_entity();
        let resize_weak = cx.weak_entity();
        let error_weak = cx.weak_entity();
        let preview = cx.new(|cx| Preview {
            frame: None,
            imported_frame: None,
            imported: None,
            resources: Default::default(),
            focus: cx.focus_handle(),
            input_state: Default::default(),
            failed_frame: None,
            on_error: Rc::new(move |frame, message, _, cx| {
                let _ = error_weak.update(cx, |this: &mut Self, cx| {
                    if this.session.diagnostics != message
                        && this
                            .session
                            .frame
                            .as_ref()
                            .is_some_and(|current| std::sync::Arc::ptr_eq(current, &frame))
                    {
                        this.invalidate();
                        this.session.diagnostics = message;
                        cx.notify();
                    }
                });
            }),
            on_resize: Rc::new(
                move |size, scale, subpixel, text_mode, transparent, _, cx| {
                    let _ = resize_weak.update(cx, |this: &mut Self, cx| {
                        if size.width < px(1.) || size.height < px(1.) {
                            return;
                        }
                        this.viewport_ready = true;
                        if this.viewport != size
                            || this.scale_factor != scale
                            || this.subpixel_rendering != subpixel
                            || this.text_rendering_mode != text_mode
                            || this.transparent_window != transparent
                        {
                            this.viewport = size;
                            this.scale_factor = scale;
                            this.subpixel_rendering = subpixel;
                            this.text_rendering_mode = text_mode;
                            this.transparent_window = transparent;
                            this.render_options_revision =
                                this.render_options_revision.wrapping_add(1);
                            if !this.session.running
                                && this.displayed_source.as_deref() == Some(this.source.as_str())
                            {
                                this.schedule(None, true, cx);
                            }
                        }
                    });
                },
            ),
            on_input: Rc::new(move |event, _, cx| {
                let _ = weak.update(cx, |this: &mut Self, cx| {
                    if this.displayed_source.as_deref() != Some(this.source.as_str())
                        || !this.session.diagnostics.is_empty()
                    {
                        return;
                    }
                    if this.session.running {
                        if matches!(
                            &event,
                            gpui_codepen_guest::InputMessage::Event(
                                gpui::PlatformInput::MouseMove(_)
                            )
                        ) && this.events.back().is_some_and(|e| {
                            matches!(
                                e,
                                gpui_codepen_guest::InputMessage::Event(
                                    gpui::PlatformInput::MouseMove(_)
                                )
                            )
                        }) {
                            *this.events.back_mut().unwrap() = event;
                        } else if this.events.len() < 128 {
                            this.events.push_back(event);
                        } else {
                            this.input_notice = Some(
                                "Waiting for previous clicks to finish. Try again in a moment."
                                    .into(),
                            );
                            cx.notify();
                        }
                    } else {
                        this.schedule(Some(event), true, cx);
                    }
                });
            }),
        });
        let changes = cx.subscribe(&editor, |this, editor, _: &TextChanged, cx| {
            this.input_notice = None;
            let source = editor.read(cx).as_str().to_owned();
            if source == this.source {
                return;
            }
            // Selection, caret blinking and scrolling never subscribe the parent
            // to editor state. Only a content event updates these cached values.
            this.line_count = source.lines().count();
            this.editor_view.update(cx, |view, cx| {
                view.highlights = TextHighlights::new(rust_highlights(&source));
                cx.notify();
            });
            this.source = source.clone();
            cx.emit(CodeChanged(source));
            this.invalidate();
            if this.auto_run {
                this.schedule(None, false, cx);
            }
            cx.notify();
        });
        let limit = cx.subscribe(&editor, |this, _, event: &TextLimitExceeded, cx| {
            this.input_notice = Some(format!(
                "Edit exceeds {} KiB. The existing source was kept intact.",
                event.0 / 1024
            ));
            cx.notify();
        });
        let line_count = source.lines().count();
        Self {
            editor,
            editor_view,
            preview,
            source,
            line_count,
            session: Session::default(),
            auto_run: true,
            diagnostics_expanded: false,
            show_preview: false,
            restart: false,
            pending: Task::ready(()),
            animation: Task::ready(()),
            last_request: web_time::Instant::now(),
            _changes: vec![changes, limit],
            input_notice: None,
            displayed_source: None,
            events: VecDeque::new(),
            viewport: gpui::size(px(600.), px(500.)),
            scale_factor: 1.,
            viewport_ready: false,
            render_options_revision: 0,
            preview_visible: true,
            subpixel_rendering: false,
            text_rendering_mode: Default::default(),
            transparent_window: false,
            preview_only: false,
            #[cfg(not(target_family = "wasm"))]
            worker: Worker::new(cx.text_system().platform_backend()),
        }
    }
    fn invalidate(&mut self) {
        self.session.generation = self.session.generation.wrapping_add(1);
        self.session.running = false;
        self.events.clear();
        self.pending = Task::ready(());
        self.animation = Task::ready(());
        #[cfg(not(target_family = "wasm"))]
        self.worker.latest.store(
            self.session.generation,
            std::sync::atomic::Ordering::Relaxed,
        );
    }
    pub fn set_source(&mut self, source: &str, cx: &mut Context<Self>) {
        if source.len() > gpui_codepen_guest::MAX_SOURCE_BYTES {
            self.input_notice =
                Some("Source exceeds 64 KiB. The existing source was kept intact.".into());
            cx.notify();
            return;
        }
        self.invalidate();
        self.session.reset();
        self.displayed_source = None;
        self.source = source.to_owned();
        self.restart = true;
        self.input_notice = None;
        self.editor_view.update(cx, |view, cx| {
            view.highlights = TextHighlights::new(rust_highlights(source));
            cx.notify();
        });
        self.line_count = source.lines().count();
        self.preview.update(cx, |view, cx| {
            view.frame = None;
            view.imported_frame = None;
            view.imported = None;
            view.failed_frame = None;
            view.input_state.reset();
            cx.notify();
        });
        self.editor
            .update(cx, |editor, cx| editor.emplace(source, cx));
        self.schedule(None, true, cx);
    }
    pub fn source(&self, _: &App) -> String {
        self.source.clone()
    }
    /// Uses GPUI's existing scene renderer and input routing, leaving editor
    /// controls to the embedding application.
    pub fn preview_only(source: impl Into<String>, cx: &mut Context<Self>) -> Self {
        let mut this = Self::new(source, cx);
        this.preview_only = true;
        this
    }
    pub fn status(&self) -> CodepenStatus {
        CodepenStatus {
            revision: self.session.generation,
            running: self.session.running,
            has_preview: self.session.frame.is_some(),
            diagnostics: self
                .input_notice
                .clone()
                .unwrap_or_else(|| self.session.diagnostics.clone()),
            failure: self.session.failure,
            elapsed_ms: self.session.elapsed_ms,
            auto_run: self.auto_run,
        }
    }
    /// Applies an editor change while keeping the last successful scene visible.
    pub fn edit_source(&mut self, source: &str, cx: &mut Context<Self>) {
        if source == self.source {
            return;
        }
        if source.len() > gpui_codepen_guest::MAX_SOURCE_BYTES {
            self.input_notice =
                Some("Source exceeds 64 KiB. The existing source was kept intact.".into());
            cx.notify();
            return;
        }
        self.input_notice = None;
        self.line_count = source.lines().count();
        self.source = source.to_owned();
        self.editor_view.update(cx, |view, cx| {
            view.highlights = TextHighlights::new(rust_highlights(source));
            cx.notify();
        });
        self.editor
            .update(cx, |editor, cx| editor.emplace(source, cx));
        self.invalidate();
        cx.emit(CodeChanged(source.to_owned()));
        if self.auto_run {
            self.schedule(None, false, cx);
        }
        cx.notify();
    }
    pub fn set_auto_run(&mut self, enabled: bool, cx: &mut Context<Self>) {
        if self.auto_run == enabled {
            return;
        }
        self.auto_run = enabled;
        if enabled {
            self.schedule(None, true, cx);
        } else {
            self.invalidate();
        }
        cx.notify();
    }
    pub fn reset(&mut self, cx: &mut Context<Self>) {
        self.restart = true;
        self.events.clear();
        self.run(cx);
    }
    pub fn run(&mut self, cx: &mut Context<Self>) {
        self.events.clear();
        self.schedule(None, true, cx);
    }
    fn schedule(
        &mut self,
        event: Option<gpui_codepen_guest::InputMessage>,
        immediate: bool,
        cx: &mut Context<Self>,
    ) {
        self.animation = Task::ready(());
        // Invalidate now; allocate the request only after the typing pause.
        self.session.generation = self.session.generation.wrapping_add(1);
        self.session.running = true;
        self.session.diagnostics.clear();
        #[cfg(not(target_family = "wasm"))]
        self.worker.latest.store(
            self.session.generation,
            std::sync::atomic::Ordering::Relaxed,
        );
        self.pending = cx.spawn(async move |this, cx| {
            if !immediate {
                cx.background_executor()
                    .timer(Duration::from_millis(100))
                    .await;
            }
            while this
                .update(cx, |this, _| !this.viewport_ready && this.preview_visible)
                .unwrap_or(false)
            {
                // Construct a visible interpreted root only after the first host
                // paint measures its viewport. Hidden compact previews use the fallback.
                cx.background_executor()
                    .timer(Duration::from_millis(16))
                    .await;
            }
            let Ok((request, render_options_revision)) = this.update(cx, |this, _| {
                let mut request = this
                    .session
                    .request(this.source.clone(), Backend::Miri, event);
                request.input.events.extend(this.events.drain(..));
                request.input.elapsed_ms =
                    this.last_request.elapsed().as_millis().min(60_000) as u64;
                this.last_request = web_time::Instant::now();
                request.input.viewport = this.viewport;
                request.input.scale_factor = this.scale_factor;
                request.input.subpixel_rendering = this.subpixel_rendering;
                request.input.text_rendering_mode = this.text_rendering_mode;
                request.input.transparent_window = this.transparent_window;
                request.restart = std::mem::take(&mut this.restart);
                #[cfg(not(target_family = "wasm"))]
                this.worker
                    .latest
                    .store(request.generation, std::sync::atomic::Ordering::Relaxed);
                (request, this.render_options_revision)
            }) else {
                return;
            };
            let rendered_source = request.source.clone();
            #[cfg(not(target_family = "wasm"))]
            let reply = {
                let Ok(worker) = this.update(cx, |this, _| this.worker.clone()) else {
                    return;
                };
                match worker.submit(request).await {
                    Ok(reply) => reply,
                    Err(_) => return,
                }
            };
            #[cfg(target_family = "wasm")]
            let reply = browser_evaluate(request).await;
            let _ = this.update(cx, |this, cx| {
                if reply.generation == this.session.generation
                    && render_options_revision != this.render_options_revision
                {
                    // The interpreter processed the input, but its render policy
                    // is obsolete. Keep the last displayed scene until a frame
                    // for the current viewport and text policy is ready.
                    this.schedule(None, true, cx);
                    return;
                }
                let succeeded = reply.frame.is_some();
                let accepted = this.session.accept_validated(reply);
                if accepted {
                    this.diagnostics_expanded = !this.session.diagnostics.is_empty();
                    if succeeded && this.session.diagnostics.is_empty() {
                        this.displayed_source = Some(rendered_source);
                        let frame = this.session.frame.clone();
                        this.preview.update(cx, |view, cx| {
                            view.frame = frame;
                            cx.notify();
                        });
                    }
                    if this.session.diagnostics.is_empty() {
                        if let Some(event) = this.events.pop_front() {
                            this.schedule(Some(event), true, cx);
                        } else if let Some(delay) =
                            this.session.frame.as_ref().and_then(|f| f.next_frame_ms)
                        {
                            let generation = this.session.generation;
                            this.animation = cx.spawn(async move |this, cx| {
                                cx.background_executor()
                                    .timer(Duration::from_millis(delay))
                                    .await;
                                let _ = this.update(cx, |this, cx| {
                                    if this.session.generation == generation
                                        && !this.session.running
                                    {
                                        this.schedule(None, true, cx);
                                    }
                                });
                            });
                        }
                    } else {
                        this.events.clear();
                    }
                    cx.notify();
                }
            });
        });
        cx.notify();
    }
}
impl Render for Codepen {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        if !self.viewport_ready {
            self.scale_factor = window.scale_factor();
        }
        if self.preview_only {
            self.preview_visible = true;
            return div()
                .size_full()
                .min_h_0()
                .min_w_0()
                .on_action(cx.listener(|this, _: &Run, _, cx| this.run(cx)))
                .child(
                    self.preview
                        .clone()
                        .cached(StyleRefinement::default().size_full()),
                )
                .into_any_element();
        }
        let compact = window.viewport_size().width < px(760.);
        self.preview_visible = !compact || self.show_preview;
        let status = if self.session.running {
            "Updating…"
        } else if self.session.failure == Some(FailureKind::Unavailable) {
            "Runtime unavailable"
        } else if !self.session.diagnostics.is_empty() {
            if self.session.frame.is_some() {
                "Needs a fix · last good preview retained"
            } else {
                "Needs a fix"
            }
        } else if self.session.frame.is_some() {
            "Live"
        } else {
            "Ready"
        };
        let error = !self.session.diagnostics.is_empty();
        div().relative().size_full().flex().flex_col().min_h_0().gap_3().when(compact, |s| s.gap_2())
            .on_action(cx.listener(|this, _: &Run, _, cx| this.run(cx)))
            .child(div().flex().items_center().justify_between().gap_2()
                .child(div().text_xs().text_color(rgb(0xa8d7b9)).child("Miri · real Rust"))
                .child(div().flex().items_center().gap_2()
                    .child(pill(if self.auto_run { "Auto · on" } else { "Auto · paused" }, self.auto_run)
                        .on_click(cx.listener(|this, _, _, cx| {
                            this.auto_run = !this.auto_run;
                            if this.auto_run { this.schedule(None, true, cx); } else { this.invalidate(); }
                            cx.notify();
                        })))
                    .child(pill("Run", false).on_click(cx.listener(|this, _, _, cx| this.run(cx))))))
            .when(compact, |s| s.child(div().flex().gap_2()
                .child(pill("Code", !self.show_preview).on_click(cx.listener(|this, _, _, cx| { this.show_preview = false; cx.notify(); })))
                .child(pill("Preview", self.show_preview).on_click(cx.listener(|this, _, _, cx| { this.show_preview = true; cx.notify(); })))))
            .child(div().flex().flex_1().min_h_0().min_w_0().gap_3()
                .when(!compact || !self.show_preview, |s| s.child(self.editor_view.clone().cached(StyleRefinement::default().flex_1().min_w_0().min_h_0().h_full())))
                .when(!compact || self.show_preview, |s| s.child(div().flex().flex_col().flex_1().min_w_0().min_h_0().rounded_xl().overflow_hidden().bg(rgb(0xe8ede5))
                    .child(panel_heading("Live preview", "GPUI"))
                    .child(self.preview.clone().cached(StyleRefinement::default().flex_1().min_h_0().w_full()))
                    .child(div().flex().items_center().justify_between().px_3().py_1().border_t_1().border_color(rgb(0xd8dfd5))
                        .text_xs().text_color(rgb(0x637065)).child("GPUI layout · GPUI events")
                        .child(pill("Reset state", false).py_1().on_click(cx.listener(|this, _, _, cx| {
                            this.session.reset(); this.restart = true; this.events.clear(); this.schedule(None, true, cx);
                        })))))))
            .child(div().flex().items_center().justify_between().text_xs().text_color(rgb(0x728477))
                .child(div().text_color(rgb(if error { 0xe1b18b } else { 0xa8d7b9 })).child(status)
                    .when(error, |s| s.cursor_pointer().on_mouse_down(gpui::MouseButton::Left, cx.listener(|this, _, _, cx| {
                        this.diagnostics_expanded = !this.diagnostics_expanded; cx.notify();
                    }))))
                .child(if compact { format!("{} ms · {} lines", self.session.elapsed_ms, self.line_count) }
                    else { format!("{} ms  ·  {} lines  ·  {:.1} / 64 KiB", self.session.elapsed_ms, self.line_count, self.source.len() as f64 / 1024.) }))
            // Diagnostics float above the panes so successful editing keeps
            // the entire available height and errors do not change the viewport.
            .when(self.diagnostics_expanded && error || self.input_notice.is_some(), |s| s.child(
                div().id("diagnostics").absolute().bottom(px(24.)).left_0().w_full().h(px(120.))
                    .flex().flex_col().rounded_lg().p_3().bg(rgb(0x302923)).text_color(rgb(0xe9bea0))
                    .child(div().flex().items_center().justify_between().text_xs().mb_2()
                        .child(if self.session.failure == Some(FailureKind::Unavailable) { "Runtime unavailable" } else { "Rust diagnostics" })
                        .child(pill("Close", false).py_1().on_click(cx.listener(|this, _, _, cx| {
                            this.diagnostics_expanded = false; this.input_notice = None; cx.notify();
                        }))))
                    .child(div().id("diagnostic-message").flex_1().min_h_0().overflow_scroll().font_family("Lilex")
                        .text_size(px(12.)).line_height(px(18.))
                        .child(SharedString::from(self.input_notice.clone().unwrap_or_else(|| self.session.diagnostics.clone()))))))
            .into_any_element()
    }
}
pub fn pill(label: &str, active: bool) -> gpui::Stateful<gpui::Div> {
    div()
        .id(SharedString::from(label.to_owned()))
        .px_3()
        .py_2()
        .rounded_lg()
        .text_xs()
        .cursor_pointer()
        .bg(rgb(if active { 0x3c5646 } else { 0x27352c }))
        .text_color(rgb(if active { 0xdbf1df } else { 0x9daf9f }))
        .hover(|s| s.bg(rgb(0x435b49)))
        .child(SharedString::from(label.to_owned()))
}
fn panel_heading(title: &str, language: &str) -> gpui::Div {
    div()
        .flex()
        .flex_shrink_0()
        .items_center()
        .justify_between()
        .px_5()
        .py_3()
        .bg(rgb(0x202e26))
        .text_xs()
        .text_color(rgb(0xaabbac))
        .child(SharedString::from(title.to_owned()))
        .child(
            div()
                .text_color(rgb(0x728778))
                .child(SharedString::from(language.to_owned())),
        )
}

#[cfg(not(target_family = "wasm"))]
#[derive(Clone)]
struct Worker {
    mailbox: std::sync::Arc<Mailbox>,
    latest: std::sync::Arc<std::sync::atomic::AtomicU64>,
    thread: std::sync::Arc<std::sync::Mutex<Option<std::thread::JoinHandle<()>>>>,
}
#[cfg(not(target_family = "wasm"))]
#[derive(Default)]
struct Mailbox {
    state: std::sync::Mutex<MailboxState>,
    ready: std::sync::Condvar,
}
#[cfg(not(target_family = "wasm"))]
#[derive(Default)]
struct MailboxState {
    pending: Option<(Request, futures::channel::oneshot::Sender<Reply>)>,
    closed: bool,
}
#[cfg(not(target_family = "wasm"))]
impl Worker {
    fn new(text_system: std::sync::Arc<dyn gpui::PlatformTextSystem>) -> Self {
        use std::sync::{
            Arc,
            atomic::{AtomicU64, Ordering},
        };
        let mailbox = Arc::new(Mailbox::default());
        let incoming = mailbox.clone();
        let latest = Arc::new(AtomicU64::new(0));
        let generation = latest.clone();
        let thread = std::thread::spawn(move || {
            let factory = Arc::new(move || Ok(text_system.clone()));
            let mut runtime = crate::runtime::Runtime::with_text_system_factory(factory);
            loop {
                let (request, response) = {
                    let mut state = incoming.state.lock().unwrap();
                    while state.pending.is_none() && !state.closed {
                        state = incoming.ready.wait(state).unwrap();
                    }
                    if state.closed {
                        break;
                    }
                    state.pending.take().unwrap()
                };
                if generation.load(Ordering::Relaxed) != request.generation {
                    continue;
                }
                let reply = match &mut runtime {
                    Ok(runtime) => runtime.evaluate(request, &generation),
                    Err(error) => Reply {
                        generation: request.generation,
                        frame: None,
                        diagnostics: format!("{error:#}"),
                        failure: Some(FailureKind::Unavailable),
                        elapsed_ms: 0,
                    },
                };
                let _ = response.send(reply);
            }
        });
        Self {
            mailbox,
            latest,
            thread: Arc::new(std::sync::Mutex::new(Some(thread))),
        }
    }
    fn submit(&self, request: Request) -> futures::channel::oneshot::Receiver<Reply> {
        let (sender, receiver) = futures::channel::oneshot::channel();
        let mut state = self.mailbox.state.lock().unwrap();
        if !state.closed {
            // Replace a queued stale edit rather than retain arbitrary copies.
            state.pending = Some((request, sender));
            self.mailbox.ready.notify_one();
        }
        receiver
    }
    fn close(&self) {
        self.latest
            .store(u64::MAX, std::sync::atomic::Ordering::Relaxed);
        let mut state = self.mailbox.state.lock().unwrap();
        state.closed = true;
        state.pending = None;
        self.mailbox.ready.notify_one();
        drop(state);
        if let Some(thread) = self.thread.lock().unwrap().take() {
            // Closing a component must not wait for compiler teardown on UI.
            std::thread::spawn(move || {
                let _ = thread.join();
            });
        }
    }
}
impl Drop for Codepen {
    fn drop(&mut self) {
        #[cfg(not(target_family = "wasm"))]
        self.worker.close();
        #[cfg(all(target_family = "wasm", feature = "browser-miri"))]
        crate::browser_runtime::release(&self.session.id);
    }
}

#[cfg(all(target_family = "wasm", feature = "browser-miri"))]
async fn browser_evaluate(request: Request) -> Reply {
    crate::browser_runtime::evaluate(request).await
}

#[cfg(all(target_family = "wasm", not(feature = "browser-miri")))]
async fn browser_evaluate(request: Request) -> Reply {
    use wasm_bindgen::{JsCast, JsValue};
    use wasm_bindgen_futures::JsFuture;
    let generation = request.generation;
    let result = async {
        struct AbortOnDrop {
            controller: web_sys::AbortController,
            cancel: String,
            completed: bool,
        }
        impl Drop for AbortOnDrop {
            fn drop(&mut self) {
                self.controller.abort();
                if !self.completed {
                    if let Some(window) = web_sys::window() {
                        let parts = js_sys::Array::new();
                        parts.push(&JsValue::from_str(&self.cancel));
                        let options = web_sys::BlobPropertyBag::new();
                        options.set_type("application/json");
                        if let Ok(body) =
                            web_sys::Blob::new_with_str_sequence_and_options(&parts, &options)
                        {
                            let _ = window
                                .navigator()
                                .send_beacon_with_opt_blob("/api/cancel", Some(&body));
                        }
                    }
                }
            }
        }
        let mut abort = AbortOnDrop {
            controller: web_sys::AbortController::new()?,
            cancel: serde_json::json!({"session_id": request.session_id, "generation": generation})
                .to_string(),
            completed: false,
        };
        let init = web_sys::RequestInit::new();
        init.set_method("POST");
        init.set_signal(Some(&abort.controller.signal()));
        init.set_body(&JsValue::from_str(
            &serde_json::to_string(&request).map_err(|e| JsValue::from_str(&e.to_string()))?,
        ));
        let req = web_sys::Request::new_with_str_and_init("/api/render", &init)?;
        req.headers().set("Content-Type", "application/json")?;
        req.headers()
            .set("Accept", crate::transport::CONTENT_TYPE)?;
        let window = web_sys::window().ok_or_else(|| JsValue::from_str("No browser window"))?;
        let response: web_sys::Response = JsFuture::from(window.fetch_with_request(&req))
            .await?
            .dyn_into()?;
        if !response.ok() {
            let text = JsFuture::from(response.text()?)
                .await?
                .as_string()
                .unwrap_or_default();
            abort.completed = true;
            return Err(JsValue::from_str(&text));
        }
        let buffer = JsFuture::from(response.array_buffer()?).await?;
        abort.completed = true;
        crate::transport::decode(&js_sys::Uint8Array::new(&buffer).to_vec())
            .map_err(|e| JsValue::from_str(&e))
    }
    .await;
    result.unwrap_or_else(|e| Reply {
        generation,
        frame: None,
        diagnostics: format!(
            "Rust compiler service unavailable. Start gpui-codepen-server and trunk serve. {e:?}"
        ),
        failure: Some(FailureKind::Unavailable),
        elapsed_ms: 0,
    })
}

#[cfg(all(test, not(target_family = "wasm")))]
mod tests {
    use super::*;
    #[test]
    fn newer_queued_edit_releases_older_source_and_reply() {
        let worker = Worker {
            mailbox: Default::default(),
            latest: Default::default(),
            thread: Default::default(),
        };
        let mut session = Session::default();
        let first = worker.submit(session.request("old".into(), Backend::Miri, None));
        let second = worker.submit(session.request("new".into(), Backend::Miri, None));
        assert!(futures::executor::block_on(first).is_err());
        worker.close();
        assert!(futures::executor::block_on(second).is_err());
    }
}
