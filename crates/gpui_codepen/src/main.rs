#![cfg_attr(target_family = "wasm", no_main)]
use gpui::{
    App, Bounds, Context, Entity, KeyBinding, SharedString, Subscription, Window, WindowBounds,
    WindowOptions, actions, div, prelude::*, px, rgb, size,
};
use gpui_ce_codepen::{
    Codepen,
    codepen::{CodeChanged, Run, pill},
    lessons::LESSONS,
};
use gpui_ce_elements::editable_text::actions::{DEFAULT_INPUT_CONTEXT, default_bindings};

actions!(guide, [Quit]);

#[derive(Clone, serde::Serialize, serde::Deserialize)]
struct Drafts {
    version: u32,
    sources: Vec<String>,
}
impl Default for Drafts {
    fn default() -> Self {
        Self {
            version: 2,
            sources: LESSONS.iter().map(|l| l.source.to_owned()).collect(),
        }
    }
}
impl Drafts {
    fn load() -> Self {
        let data = load_drafts();
        data.and_then(|s| serde_json::from_str::<Self>(&s).ok())
            .filter(|d| d.version == 2 && d.sources.len() == LESSONS.len())
            .unwrap_or_default()
    }
    fn save(&self) {
        if let Ok(data) = serde_json::to_string(self) {
            save_drafts(&data);
        }
    }
}
#[cfg(not(target_family = "wasm"))]
fn drafts_path() -> Option<std::path::PathBuf> {
    std::env::var_os("HOME")
        .map(|home| std::path::PathBuf::from(home).join(".local/share/gpui-codepen/drafts-v2.json"))
}
#[cfg(not(target_family = "wasm"))]
fn load_drafts() -> Option<String> {
    drafts_path().and_then(|p| std::fs::read_to_string(p).ok())
}
#[cfg(not(target_family = "wasm"))]
fn save_drafts(data: &str) {
    if let Some(path) = drafts_path() {
        if let Some(parent) = path.parent() {
            let _ = std::fs::create_dir_all(parent);
        }
        let temporary = path.with_extension("json.tmp");
        if std::fs::write(&temporary, data).is_ok() {
            let _ = std::fs::rename(temporary, path);
        }
    }
}
#[cfg(target_family = "wasm")]
fn load_drafts() -> Option<String> {
    web_sys::window()?
        .local_storage()
        .ok()??
        .get_item("gpui-codepen-drafts-v2")
        .ok()?
}
#[cfg(target_family = "wasm")]
fn save_drafts(data: &str) {
    if let Some(storage) = web_sys::window().and_then(|w| w.local_storage().ok().flatten()) {
        let _ = storage.set_item("gpui-codepen-drafts-v2", data);
    }
}

#[cfg(not(target_family = "wasm"))]
struct DraftWriter {
    send: Option<std::sync::mpsc::Sender<Drafts>>,
    thread: Option<std::thread::JoinHandle<()>>,
}
#[cfg(not(target_family = "wasm"))]
impl DraftWriter {
    fn new() -> Self {
        let (send, receive) = std::sync::mpsc::channel::<Drafts>();
        let thread = std::thread::spawn(move || {
            while let Ok(mut drafts) = receive.recv() {
                // Serialize writes and coalesce queued snapshots; an old save
                // can never race a newer save's rename or overwrite its data.
                while let Ok(newer) = receive.try_recv() {
                    drafts = newer;
                }
                drafts.save();
            }
        });
        Self {
            send: Some(send),
            thread: Some(thread),
        }
    }
    fn enqueue(&self, drafts: Drafts) {
        let _ = self.send.as_ref().unwrap().send(drafts);
    }
}
#[cfg(not(target_family = "wasm"))]
impl Drop for DraftWriter {
    fn drop(&mut self) {
        self.send.take();
        if let Some(thread) = self.thread.take() {
            let _ = thread.join();
        }
    }
}

struct Guide {
    codepen: Entity<Codepen>,
    selected: usize,
    drafts: Drafts,
    _changes: Subscription,
    save_task: gpui::Task<()>,
    #[cfg(not(target_family = "wasm"))]
    writer: DraftWriter,
}
impl Guide {
    fn new(cx: &mut Context<Self>) -> Self {
        let drafts = Drafts::load();
        let codepen = cx.new(|cx| Codepen::new(drafts.sources[0].clone(), cx));
        let changes = cx.subscribe(&codepen, |this, _, event: &CodeChanged, cx| {
            this.drafts.sources[this.selected] = event.0.clone();
            this.save_task = cx.spawn(async |this, cx| {
                cx.background_executor()
                    .timer(std::time::Duration::from_millis(750))
                    .await;
                let _ = this.update(cx, |this, _| {
                    #[cfg(not(target_family = "wasm"))]
                    this.writer.enqueue(this.drafts.clone());
                    #[cfg(target_family = "wasm")]
                    this.drafts.save();
                });
            });
        });
        codepen.update(cx, |pen, cx| pen.run(cx));
        Self {
            codepen,
            selected: 0,
            drafts,
            _changes: changes,
            save_task: gpui::Task::ready(()),
            #[cfg(not(target_family = "wasm"))]
            writer: DraftWriter::new(),
        }
    }
    fn select(&mut self, index: usize, cx: &mut Context<Self>) {
        self.drafts.sources[self.selected] = self.codepen.read(cx).source(cx);
        self.selected = index;
        self.codepen.update(cx, |pen, cx| {
            pen.set_source(&self.drafts.sources[index], cx)
        });
        cx.notify();
    }
}
impl Drop for Guide {
    fn drop(&mut self) {
        #[cfg(not(target_family = "wasm"))]
        self.writer.enqueue(self.drafts.clone());
        #[cfg(target_family = "wasm")]
        self.drafts.save();
    }
}
impl Render for Guide {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let selected = self.selected;
        let lesson = &LESSONS[selected];
        let compact = window.viewport_size().width < px(1000.);
        let small = window.viewport_size().width < px(760.);
        let short = window.viewport_size().height < px(800.);
        div().flex().flex_col().size_full().bg(rgb(0x1a281f)).text_color(rgb(0xdce9db)).font_family("IBM Plex Sans").whitespace_normal()
            .child(div().h(px(76.)).flex().items_center().justify_between().px_6().border_b_1().border_color(rgb(0x344137))
                .when(short, |s| s.h(px(60.)))
                .flex_shrink_0().when(small, |s| s.h(px(56.)).px_4())
                .child(div().flex().items_center().gap_3()
                    .child(div().size(px(34.)).rounded_lg().bg(rgb(0xb9deac)).flex().items_center().justify_center().text_color(rgb(0x24472e)).font_weight(gpui::FontWeight::BOLD).child("g"))
                    .child(div().flex().flex_col().gap_1().child(div().text_lg().font_weight(gpui::FontWeight::SEMIBOLD).child("GPUI / The living guide"))
                        .when(!small, |s| s.child(div().text_xs().text_color(rgb(0x8ba18b)).child("Learn by changing the thing you’re looking at.")))))
                .when(!compact, |s| s.child(div().text_xs().text_color(rgb(0x9bb29a)).child("RUST → GPUI INTERFACE"))))
            .when(compact, |s| s.child(div().id("lesson-navigation").flex().flex_shrink_0().gap_2().px_4().py_2().overflow_x_scroll()
                .children(["01 Styling", "02 Layout", "03 Rust", "04 State", "05 Compose"].iter().enumerate().map(|(index, title)| {
                    pill(title, index == selected).flex_shrink_0().on_click(cx.listener(move |this, _, _, cx| this.select(index, cx)))
                }))))
            .child(div().flex().flex_1().min_h_0()
                .when(!compact, |s| s.child(div().w(px(205.)).flex_shrink_0().flex().flex_col().p_5().gap_2().border_r_1().border_color(rgb(0x344137))
                    .child(div().text_xs().text_color(rgb(0x82977f)).mb_3().child("YOUR FIRST COMPONENTS"))
                    .children(LESSONS.iter().enumerate().map(|(index, lesson)| {
                        div().id(("lesson", index)).rounded_lg().p_3().flex().flex_col().gap_1().cursor_pointer()
                            .bg(rgb(if selected == index { 0x334b36 } else { 0x1a281f }))
                            .hover(|s| s.bg(rgb(0x2d3e2e)))
                            .child(div().text_sm().child(lesson.title))
                            .child(div().text_xs().text_color(rgb(0x8ea58a)).child(lesson.subtitle))
                            .on_click(cx.listener(move |this, _, _, cx| this.select(index, cx)))
                    }))
                    .child(div().flex_1())
                    .child(div().w_full().min_w_0().p_3().rounded_lg().bg(rgb(0x223426)).text_xs().text_color(rgb(0x99b393)).line_height(px(18.))
                        .child("Your edits are saved locally. Experiment freely; restore a lesson whenever you like."))))
                .child(div().flex().flex_col().flex_1().min_w_0().min_h_0().p_6().gap_4()
                    .when(short, |s| s.py_4().gap_3())
                    .when(compact, |s| s.p_4().gap_3())
                    .child(div().flex().items_start().justify_between().gap_4()
                        .flex_shrink_0()
                        .child(div().flex().flex_col().gap_2().flex_1().min_w_0()
                            .child(div().text_2xl().when(small, |s| s.text_lg()).font_weight(gpui::FontWeight::SEMIBOLD).child(lesson.subtitle))
                            .child(div().text_sm().text_color(rgb(0xa5bba0)).line_height(px(21.)).when(small, |s| s.text_xs().line_height(px(18.))).child(lesson.description)))
                        .child(pill("Restore lesson", false).on_click(cx.listener(|this, _, _, cx| {
                            this.drafts.sources[this.selected] = LESSONS[this.selected].source.to_owned();
                            this.codepen.update(cx, |pen, cx| pen.set_source(LESSONS[this.selected].source, cx));
                        }))))
                    .when(!small, |s| s.child(div().flex_shrink_0().rounded_lg().px_4().py_3().when(short, |s| s.py_2()).bg(rgb(0x2c402d)).text_sm().text_color(rgb(0xbcd4b1)).child(lesson.challenge)))
                    .child(div().flex_1().min_h_0().child(self.codepen.clone()))))
            .child(div().px_6().py_3().flex().justify_between().text_xs().text_color(rgb(0x81987d)).border_t_1().border_color(rgb(0x344137))
                .when(short, |s| s.py_2())
                .flex_shrink_0().when(compact, |s| s.px_4().py_2())
                .child(if compact { "Real Rust · saved locally" } else { "A workbench for real Rust.  /  Local developer code." })
                .child(SharedString::from(format!("Lesson {} of {}", selected + 1, LESSONS.len()))))
    }
}

fn run() {
    gpui_platform::application().run(|cx: &mut App| {
        use std::borrow::Cow;
        let fonts = vec![
            Cow::Borrowed(
                include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf")
                    .as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBold.ttf")
                    .as_slice(),
            ),
            Cow::Borrowed(
                include_bytes!("../assets/fonts/lilex/Lilex-Regular.ttf").as_slice(),
            ),
        ];
        cx.text_system().add_fonts(fonts).expect("guide fonts");
        cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
        cx.bind_keys([
            KeyBinding::new("cmd-enter", Run, None),
            KeyBinding::new("ctrl-enter", Run, None),
            KeyBinding::new("cmd-q", Quit, None),
        ]);
        cx.on_action(|_: &Quit, cx| cx.quit());
        let bounds = Bounds::centered(None, size(px(1380.), px(900.)), cx);
        cx.open_window(
            WindowOptions::new()
                .window_bounds(Some(WindowBounds::Windowed(bounds)))
                .window_min_size(Some(size(px(1040.), px(740.)))),
            |window, cx| {
                window.set_window_title("GPUI · The living guide");
                cx.new(Guide::new)
            },
        )
        .expect("guide window");
        cx.activate(true);
    });
}
#[cfg(not(target_family = "wasm"))]
fn main() {
    run();
}
#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    run();
}
