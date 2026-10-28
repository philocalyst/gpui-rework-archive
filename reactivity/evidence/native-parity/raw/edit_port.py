from pathlib import Path
p=Path('/home/user/gpui-native-parity-lab/reactivity/crates/gpui/examples/zgx_native_lab.rs')
s=p.read_text().replace('    work: Workload,\n    stream:', '    scroll_offset: f32,\n    rows: std::ops::Range<usize>,\n    stream:',1).replace('    received: u64,\n','',1)
a=s.index('    fn new() -> Self {');b=s.index('    fn control(',a)
s=s[:a]+'''    fn new(work: &Workload) -> Self {
        Self {
            stream: Signal::new(work.visible_text()),
            scroll_offset: work.scroll_offset,
            rows: work.row_range(),
            items: Vec::new(),
            done: 0,
        }
    }
'''+s[b:]
a=s.index('impl Drop for Lab {');b=s.index('// An ordinary',a)
s=s[:a]+'''// This state belongs to the UI callback. The producer only sends a tick:
// string generation and publication remain one UI-thread operation.
struct Driver {
    work: Workload,
    received: u64,
    delivered: std::sync::mpsc::Sender<()>,
}
impl Driver {
    fn advance(&mut self, finished: bool) -> bool {
        if finished {
            eprintln!("WORKLOAD_FINISHED admitted_ticks={}", self.received);
            return false;
        }
        self.work.tick();
        self.received += 1;
        true
    }
    fn stream(&mut self, value: &mut String, finished: bool) {
        if self.advance(finished) {
            *value = self.work.visible_text();
            let _ = self.delivered.send(());
        }
    }
    fn owner(&mut self, model: &mut Lab, finished: bool) {
        if self.advance(finished) {
            if matches!(self.work.mode, Mode::Stream | Mode::Both) {
                *model.stream = self.work.visible_text();
            }
            model.scroll_offset = self.work.scroll_offset;
            model.rows = self.work.row_range();
            let _ = self.delivered.send(());
        }
    }
}
impl Drop for Driver {
    fn drop(&mut self) {
        eprintln!(
            "workload_ticks={} admitted_ticks={} mounted_rows={}",
            self.work.frames,
            self.received,
            self.work.row_range().len()
        );
    }
}
'''+s[b:]
s=s.replace('self.work.row_range().map(|index|','self.rows.clone().map(|index|').replace('self.work.scroll_offset,','self.scroll_offset,')
s=s.replace('    let model = Lab::new();','    let work = Workload::from_env();\n    let model = Lab::new(&work);')
s=s.replace('    let seconds = model.work.seconds;\n    let mode = model.work.mode;','    let seconds = work.seconds;\n    let mode = work.mode;')
a=s.index('        .with_inbox(inbox, move |model, finished|');b=s.index('        .on_presentation_error',a)
s=s[:a]+s[b:]
s=s.replace('    let result = Application::run_window(window);','''    let mut driver = Driver { work, received: 0, delivered: delivered_send };
    // The optional coarse route is an equivalent-work qualification control.
    let exact = mode == Mode::Stream
        && std::env::var("GPUI_LAB_INGRESS").as_deref() != Ok("owner");
    eprintln!("source_ingress={}", if exact { "exact" } else { "owner" });
    let result = if exact {
        Application::run_window(window.with_inbox_for(inbox, Lab::STREAM, move |value, finished| {
            driver.stream(value, finished);
        }))
    } else {
        Application::run_window(window.with_inbox(inbox, move |model, finished| {
            driver.owner(model, finished);
        }))
    };''')
p.write_text(s)
