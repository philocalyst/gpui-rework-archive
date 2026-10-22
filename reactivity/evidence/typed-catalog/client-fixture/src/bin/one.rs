use catalog_client_fixture::{LibraryPage, exercise};
fn main() {
    let n = std::hint::black_box(1.);
    let mut win = gpui::Win::demo(LibraryPage::default());
    let target = win.button("Save");
    println!("{}", exercise(&mut win, target, n));
}
