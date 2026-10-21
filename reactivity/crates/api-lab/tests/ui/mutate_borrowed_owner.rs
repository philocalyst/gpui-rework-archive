use reactivity_api_lab::{El, View, column, text};

struct Owner(String);
impl View for Owner {
    fn view(&self) -> El<'_> {
        text(&self.0)
    }
}

fn main() {
    let mut owner = Owner("borrowed".into());
    let draft = owner.view();
    owner.0.push('!');
    let _ = column(draft);
}
