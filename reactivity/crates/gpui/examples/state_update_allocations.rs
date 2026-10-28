//! Requested allocation costs for the identical state-update model.
use gpui::{WindowOptions, prelude::*};
struct Page {
    label: Signal<String>,
    rows: usize,
}
impl Page {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.label).h(20).font_size(12).fg(rgb(0xe5edf7)),
            column((0..self.rows).map(|r| {
                row((0..25).map(move |c| {
                    text((r * 25 + c).to_string())
                        .w(36)
                        .h(18)
                        .font_size(12)
                        .fg(rgb(0xe5edf7))
                }))
                .gap(2)
            }))
            .gap(2),
        ))
        .w(960)
        .h(720)
        .p(8)
        .gap(6)
        .font_size(12)
        .fg(rgb(0xe5edf7))
        .bg(rgb(0x0e1218))
    }
}

fn ack(win: &mut Win<Page>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn mount(rows: usize, label: String, font: gpui_canvas::FontFace) -> Win<Page> {
    let mut win = Win::recording_with_font(
        Page {
            rows,
            label: Signal::new(label),
        },
        WindowOptions {
            size: [960, 720],
            ..Default::default()
        },
        font,
    )
    .unwrap();
    ack(&mut win);
    win
}

fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    let rows: usize = args[0].parse().unwrap();
    let bytes = std::fs::read(&args[1]).unwrap();
    let font = gpui_canvas::FontFace::new(&bytes).unwrap();
    // Global immutable text data and code are warmed outside the owner ledger.
    drop(mount(rows, "Count: 0".into(), font.clone()));
    let mut win = None;
    let cold = allocation_counter::measure(|| {
        win = Some(mount(rows, "Count: 0".into(), font.clone()));
    });
    let mut total = cold.bytes_current;
    println!("rows,stage,allocations,requested,live_delta,live_total,peak_new");
    println!(
        "{rows},cold,{},{},{},{},{}",
        cold.count_total, cold.bytes_total, cold.bytes_current, total, cold.bytes_max
    );
    for (stage, value) in [
        ("warm", "Count: 1"),
        ("warm2", "Count: 2"),
        ("long", "Count: 123456789"),
        ("short", "Count: 3"),
    ] {
        let cost = allocation_counter::measure(|| {
            let owner = win.as_mut().unwrap();
            owner.set(Page::LABEL, value.into()).unwrap();
            ack(owner);
        });
        total += cost.bytes_current;
        println!(
            "{rows},{stage},{},{},{},{},{}",
            cost.count_total, cost.bytes_total, cost.bytes_current, total, cost.bytes_max
        );
        assert!(win.as_ref().unwrap().contains_text(value).unwrap());
    }
    let cost = allocation_counter::measure(|| drop(win.take()));
    total += cost.bytes_current;
    println!(
        "{rows},drop,{},{},{},{},{}",
        cost.count_total, cost.bytes_total, cost.bytes_current, total, cost.bytes_max
    );
    assert_eq!(total, 0, "all measured window allocations reclaimed");
    eprintln!(
        "font_file_bytes={},shared_immutable_font_is_outside_owner_ledger=true",
        bytes.len()
    );
}
