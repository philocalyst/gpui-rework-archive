#[path = "support/party.rs"]
mod party;
use gpui::{El, Length, PropInput, Signal, Style, View, Win};
use gpui_component::{Button, Checkbox, Input, Theme};
fn main() {
    let theme = Theme::halloween();
    let button = allocation_counter::measure(|| {
        drop(Button::new("Send", &theme).build());
    });
    let model = party::Party::default();
    let mut description = None;
    let described = allocation_counter::measure(|| {
        description = Some(model.view());
    });
    println!(
        "button allocations={} bytes={}",
        button.count_total, button.bytes_total
    );
    println!(
        "party_description allocations={} bytes={} retained={}",
        described.count_total, described.bytes_total, described.bytes_current
    );
    drop(description);
    drop(Win::demo(party::Party::default()));
    let mut window = None;
    let retained = allocation_counter::measure(|| {
        window = Some(Win::demo(party::Party::default()));
    });
    println!(
        "party_window allocations={} bytes={} retained={}",
        retained.count_total, retained.bytes_total, retained.bytes_current
    );
    let window = window.as_ref().unwrap();
    println!("runtime_counters={:?}", window.counters());
    println!(
        "headers El={} Button={} Checkbox={} Input={} Theme={}",
        size_of::<El<'_>>(),
        size_of::<Button<'_>>(),
        size_of::<Checkbox<'_>>(),
        size_of::<Input<'_>>(),
        size_of::<Theme>()
    );
    println!(
        "dimension_headers Length={} OptionLength={} PropInputLength={} PropInputNumber={} Style={} SignalLength={} SignalNumber={}",
        size_of::<Length>(),
        size_of::<Option<Length>>(),
        size_of::<PropInput<'_, Length>>(),
        size_of::<PropInput<'_, f64>>(),
        size_of::<Style>(),
        size_of::<Signal<Length>>(),
        size_of::<Signal<f64>>()
    );
}
