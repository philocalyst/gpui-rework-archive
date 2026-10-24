//! Equal-geometry snapshot/direct model comparison; includes all binding storage.
use gpui::{El, FieldId, Signal, SignalMap, Source, Sources, View, Win};
use gpui_component::{Button, Checkbox, Input, Theme};
struct Form<const DIRECT: bool> {
    checked: Signal<bool>,
    disabled: Signal<bool>,
    title: Signal<String>,
    theme: Theme,
}
impl<const DIRECT: bool> Default for Form<DIRECT> {
    fn default() -> Self {
        Self {
            checked: Signal::new(false),
            disabled: Signal::new(false),
            title: Signal::new("Draft".into()),
            theme: Theme::halloween(),
        }
    }
}
impl<const DIRECT: bool> Form<DIRECT> {
    const CHECKED: Source<Self, bool> = Source::new(
        FieldId::new(1),
        "checked",
        |m| &m.checked,
        |m| &mut m.checked,
    );
    const DISABLED: Source<Self, bool> = Source::new(
        FieldId::new(2),
        "disabled",
        |m| &m.disabled,
        |m| &mut m.disabled,
    );
    const TITLE: Source<Self, String> =
        Source::new(FieldId::new(3), "title", |m| &m.title, |m| &mut m.title);
}
impl<const DIRECT: bool> View for Form<DIRECT> {
    fn sources() -> Sources<Self> {
        if DIRECT {
            Sources::new()
                .direct(Self::CHECKED)
                .direct(Self::DISABLED)
                .direct(Self::TITLE)
        } else {
            Sources::new()
                .field(Self::CHECKED)
                .field(Self::DISABLED)
                .field(Self::TITLE)
        }
    }
    fn view(&self) -> El<'_> {
        let checkbox = if DIRECT {
            Checkbox::new("Treats", &self.checked, &self.theme).disabled(&self.disabled)
        } else {
            Checkbox::new("Treats", *self.checked, &self.theme).disabled(*self.disabled)
        };
        let input = Input::new(&self.title, "Title", &self.theme);
        let input = if DIRECT {
            input
                .invalid(self.title.map(|s| s.len() < 3))
                .disabled(&self.disabled)
        } else {
            input.invalid(self.title.len() < 3).disabled(*self.disabled)
        };
        let command = Button::new("Finish", &self.theme);
        let command = if DIRECT {
            command.disabled(&self.disabled)
        } else {
            command.disabled(*self.disabled)
        };
        gpui::column((
            checkbox.toggle(Self::CHECKED).build(),
            input.build(),
            command.on_click(|_: &mut Self| {}).build(),
        ))
        .w(300)
    }
}
fn measure<const DIRECT: bool>() -> (Vec<u8>, Vec<u8>) {
    drop(Win::with_size(Form::<DIRECT>::default(), 320, 220).unwrap());
    let model = Form::<DIRECT>::default();
    let mut description = None;
    let described = allocation_counter::measure(|| description = Some(model.view()));
    drop(description);
    let mut window = None;
    let retained =
        allocation_counter::measure(|| window = Some(Win::with_size(model, 320, 220).unwrap()));
    let mut window = window.unwrap();
    let initial = window.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    window.reset_counters().unwrap();
    let updates = allocation_counter::measure(|| {
        for index in 0..100 {
            window.set(Form::<DIRECT>::CHECKED, index % 2 == 0).unwrap();
        }
    });
    println!(
        "direct={DIRECT},description_allocations={},description_requested={},description_retained={},mount_allocations={},mount_requested={},mount_retained={},update_allocations={},update_requested={},update_retained={},owner_reruns={},descriptions={},source_reads={},destination_compares={}",
        described.count_total,
        described.bytes_total,
        described.bytes_current,
        retained.count_total,
        retained.bytes_total,
        retained.bytes_current,
        updates.count_total,
        updates.bytes_total,
        updates.bytes_current,
        window.counters().owner_reruns,
        window.counters().descriptions,
        window.counters().source_reads,
        window.counters().destination_compares
    );
}
fn main() {
    let snapshot = measure::<false>();
    let direct = measure::<true>();
    assert_eq!(
        snapshot, direct,
        "both forms execute the same initial/final raster workload"
    );
    println!(
        "initial_and_final_pixels_equal=true,bytes_each={}",
        snapshot.0.len()
    );
}
