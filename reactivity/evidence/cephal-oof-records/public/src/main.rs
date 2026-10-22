use gpui::{ItemKey, ItemSource, ListId, Role, Win, WindowOptions, prelude::*, uniform_list};
const LIST: ListId = ListId::new(73);
struct Rows {
    labels: Vec<String>,
    narrow: bool,
}
fn row(index: usize, label: &str, narrow: bool) -> El<'_> {
    let selected = narrow && index == 500;
    text(label)
        .w(if selected { 180 } else { 200 })
        .h(32)
        .bg(if selected {
            Color::rgb(180, 210, 240)
        } else {
            Color::WHITE
        })
}
impl ItemSource for Rows {
    fn len(&self) -> usize {
        self.labels.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let i = usize::try_from(key.get()).ok()?;
        (i < self.labels.len()).then_some(i)
    }
    fn row(&self, index: usize) -> El<'_> {
        row(index, &self.labels[index], self.narrow)
    }
}
impl View for Rows {
    fn view(&self) -> El<'_> {
        uniform_list(LIST, self, 32).w(200).h(400).bg(Color::WHITE)
    }
}
struct Eager {
    labels: Vec<(usize, String)>,
    narrow: bool,
}
impl View for Eager {
    fn view(&self) -> El<'_> {
        column(
            self.labels
                .iter()
                .map(|(index, label)| row(*index, label, self.narrow)),
        )
        .w(200)
        .h(400)
        .bg(Color::WHITE)
    }
}
fn options() -> WindowOptions {
    WindowOptions {
        size: [200, 400],
        ..Default::default()
    }
}
fn check(win: &mut Win<Rows>, stage: &str, actual: &mut [u32]) {
    let token = win.render_bgrx(actual).unwrap();
    win.presented(token).unwrap();
    let state = win.list_state(win.list(LIST).unwrap()).unwrap();
    assert_eq!(state.realized_rows, 13);
    assert_eq!(win.role(Role::ListItem).count().unwrap(), 13);
    let source = win.root().unwrap();
    let reference = Eager {
        labels: state
            .visible_range
            .clone()
            .map(|index| (index, source.labels[index].clone()))
            .collect(),
        narrow: source.narrow,
    };
    let mut cold = Win::recording(reference, options()).unwrap();
    let mut expected = vec![0; 200 * 400];
    cold.render_bgrx(&mut expected).unwrap();
    assert_eq!(actual, expected, "eager pixel oracle at {stage}");
    if let Ok(prefix) = std::env::var("GPUI_OOF_PIXELS") {
        use std::io::Write;
        let mut file = std::io::BufWriter::new(
            std::fs::File::create(format!("{prefix}.{stage}.bgrx")).unwrap(),
        );
        for pixel in actual {
            file.write_all(&pixel.to_le_bytes()).unwrap();
        }
        file.flush().unwrap();
    }
}
fn phase<T>(win: &mut Win<Rows>, name: &str, operation: impl FnOnce(&mut Win<Rows>) -> T) {
    let before = win.counters();
    let allocation = allocation_counter::measure(|| {
        operation(win);
    });
    let after = win.counters();
    println!(
        "{name},{},{},{},{},{},{},{}",
        allocation.bytes_current,
        allocation.bytes_total,
        allocation.bytes_max,
        allocation.count_total,
        after.measure_calls - before.measure_calls,
        after.layout_runs - before.layout_runs,
        after.source_operations - before.source_operations
    );
}
fn main() {
    let model = Rows {
        labels: (0..1000).map(|index| format!("Row {index} café")).collect(),
        narrow: false,
    };
    let mut win = None;
    let allocation =
        allocation_counter::measure(|| win = Some(Win::recording(model, options()).unwrap()));
    let mut win = win.unwrap();
    println!("stage,retained,total,peak,calls,measured,layouts,sources");
    println!(
        "mount,{},{},{},{},{},{},{}",
        allocation.bytes_current,
        allocation.bytes_total,
        allocation.bytes_max,
        allocation.count_total,
        win.counters().measure_calls,
        win.counters().layout_runs,
        win.counters().source_operations
    );
    let mut pixels = vec![0; 200 * 400];
    check(&mut win, "mount", &mut pixels);
    phase(&mut win, "scroll", |win| {
        win.scroll_to_index(win.list(LIST).unwrap(), 490).unwrap()
    });
    check(&mut win, "scroll", &mut pixels);
    phase(&mut win, "text", |win| {
        win.update(|rows| rows.labels[500].push_str(" Ω café"))
            .unwrap()
    });
    check(&mut win, "text", &mut pixels);
    phase(&mut win, "style", |win| {
        win.update(|rows| rows.narrow = true).unwrap()
    });
    check(&mut win, "style", &mut pixels);
    phase(&mut win, "return", |win| {
        win.scroll_to_index(win.list(LIST).unwrap(), 0).unwrap()
    });
    check(&mut win, "return", &mut pixels);
}
