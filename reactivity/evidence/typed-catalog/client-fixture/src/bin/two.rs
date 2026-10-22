use catalog_client_fixture::{LibraryPage, OtherPage, exercise};
fn main() {
    let n = std::hint::black_box(1.);
    let mut a = gpui::Win::demo(LibraryPage::default());
    let target = a.button("Save");
    let first = exercise(&mut a, target, n);
    let mut b = gpui::Win::demo(OtherPage(0));
    let target = b.button("Other");
    println!("{first},{}", exercise(&mut b, target, n));
}
