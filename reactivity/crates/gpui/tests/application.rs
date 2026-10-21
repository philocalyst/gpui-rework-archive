use gpui::{Application, Error, WindowOptions, prelude::*};
use std::sync::{
    Arc,
    atomic::{AtomicUsize, Ordering},
};
struct Counter {
    count: Signal<u32>,
    dropped: Arc<AtomicUsize>,
}
impl View for Counter {
    fn view(&self) -> El<'_> {
        column((
            text(&self.count),
            button("Increment").on_click(|m: &mut Self| *m.count += 1),
        ))
    }
}
impl Drop for Counter {
    fn drop(&mut self) {
        self.dropped.fetch_add(1, Ordering::Relaxed);
    }
}
struct Label;
impl View for Label {
    fn view(&self) -> El<'_> {
        text("Another model type")
    }
}
fn counter(dropped: &Arc<AtomicUsize>) -> Counter {
    Counter {
        count: Signal::new(0),
        dropped: Arc::clone(dropped),
    }
}
#[test]
fn typed_windows_use_exclusive_production_owners_and_the_same_input_barrier() {
    let dropped = Arc::new(AtomicUsize::new(0));
    let app = Application::demo().options(WindowOptions {
        size: [320, 200],
        ..Default::default()
    });
    let mut first = app.open(counter(&dropped)).unwrap();
    let mut second = app.open(counter(&dropped)).unwrap();
    let label = app.open(Label).unwrap();
    first.click(first.button("Increment")).unwrap();
    assert_eq!(first.with_model(|m| *m.count).unwrap(), 1);
    assert_eq!(second.with_model(|m| *m.count).unwrap(), 0);
    assert_eq!(
        second.click(first.button("Increment")),
        Err(Error::StaleTarget)
    );
    assert!(label.contains_text("Another model type").unwrap());
    assert_eq!(label.snapshot().unwrap().size, [320, 200]);
    first.close();
    assert!(first.is_closed());
    assert_eq!(first.snapshot(), Err(Error::Closed));
    assert_eq!(dropped.load(Ordering::Relaxed), 1);
    assert!(second.snapshot().is_ok());
    second.close();
    second.close();
    assert_eq!(dropped.load(Ordering::Relaxed), 2);
}
#[test]
fn callback_panics_quarantine_the_owner_and_explicit_close_releases_it_once() {
    let dropped = Arc::new(AtomicUsize::new(0));
    let mut win = Win::demo(counter(&dropped));
    assert_eq!(
        win.update(|_| panic!("callback fault")),
        Err(Error::OwnerPanicked)
    );
    assert_eq!(win.update(|_| {}), Err(Error::Poisoned));
    win.close();
    assert_eq!(dropped.load(Ordering::Relaxed), 1);
    assert_eq!(win.settle(), Err(Error::Closed));
}
