use std::{cell::RefCell, rc::Rc};

struct Context<T>(std::marker::PhantomData<T>);
struct Entity<T>(Rc<RefCell<T>>);

impl<T> Entity<T> {
    fn update<R>(&self, edit: impl FnOnce(&mut T, &mut Context<T>) -> R) -> R {
        let mut value = self.0.borrow_mut();
        let mut cx = Context(std::marker::PhantomData);
        edit(&mut value, &mut cx)
    }
}

fn main() {
    let entity = Entity(Rc::new(RefCell::new(String::from("model"))));
    let mut escaped: Option<&mut String> = None;

    // A stored selector callback must be valid for every model-borrow lifetime.
    let mut selector = |model: &mut String, _cx: &mut Context<String>| {
        escaped = Some(model);
    };
    entity.update(|model, cx| selector(model, cx));
}
