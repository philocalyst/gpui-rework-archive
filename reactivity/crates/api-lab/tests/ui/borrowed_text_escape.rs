use reactivity_api_lab::{El, text};

fn escape() -> El<'static> {
    let local = String::from("cannot escape");
    text(&local)
}

fn main() {
    let _ = escape();
}
