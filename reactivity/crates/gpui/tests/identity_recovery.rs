use gpui::{Error, prelude::*};

#[derive(Default)]
struct Page {
    invalid: bool,
    unregistered: Signal<String>,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        column((
            button("Held").on_click(|_: &mut Self| {}),
            self.invalid.then(|| text_input(&self.unregistered)),
        ))
    }
}
#[test]
fn checked_description_failure_permanently_retires_pre_failure_target_stamps() {
    let mut win = Win::demo(Page::default());
    let held = win.button("Held");
    assert!(matches!(
        win.update(|page| page.invalid = true),
        Err(Error::UnregisteredInput { .. })
    ));
    win.update(|page| page.invalid = false).unwrap();
    assert_ne!(win.button("Held"), held);
    assert_eq!(win.click(held), Err(Error::StaleTarget));
}
