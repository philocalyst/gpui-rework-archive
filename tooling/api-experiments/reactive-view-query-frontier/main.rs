use std::{any::Any, cell::RefCell, marker::PhantomData, rc::Rc};

struct App;
struct Context<T>(PhantomData<T>);

struct Entity<T>(Rc<RefCell<T>>);

impl<T> Clone for Entity<T> {
    fn clone(&self) -> Self {
        Self(self.0.clone())
    }
}

impl<T> Entity<T> {
    fn update<R>(&self, _app: &mut App, edit: impl FnOnce(&mut T, &mut Context<T>) -> R) -> R {
        let mut value = self.0.borrow_mut();
        let mut cx = Context(PhantomData);
        edit(&mut value, &mut cx)
    }
}

#[derive(Default)]
struct SearchView {
    query: String,
    edits: usize,
}

// This mirrors a typed Entity target inside a stored, repeatable selector
// callback. The actual GPUI path uses Entity::update(app, ...).
fn select_entity<T: 'static>(
    mut edit: impl for<'a> FnMut(&'a mut T, &'a mut Context<T>) + 'static,
) -> impl FnMut(&mut dyn Any, &mut App) + 'static {
    move |subject, app| {
        if let Some(entity) = subject.downcast_ref::<Entity<T>>() {
            entity.update(app, |model, cx| edit(model, cx));
        }
    }
}

fn main() {
    let mut app = App;
    let mut view = Entity(Rc::new(RefCell::new(SearchView::default())));
    let mut apply = select_entity::<SearchView>(|model, cx| {
        let _ = cx;
        model.query.clear();
        model.edits += 1;
    });

    // Layout can retry, so the callback is intentionally invoked twice.
    apply(&mut view, &mut app);
    apply(&mut view, &mut app);

    let state = view.0.borrow();
    assert_eq!(state.edits, 2);
    assert!(state.query.is_empty());
}
