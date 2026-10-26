//! Application entry points use the same exclusive window owner as production.
use crate::{Error, View, Win, WindowOptions};

pub struct Application;
impl Application {
    pub fn demo() -> DemoApplication {
        DemoApplication::default()
    }
}
/// A headless opening policy. Each returned window owns its model and runtime;
/// mutation requires its ordinary exclusive borrow, with no test dispatcher.
#[derive(Default)]
pub struct DemoApplication {
    options: WindowOptions,
}
impl DemoApplication {
    pub fn options(mut self, options: WindowOptions) -> Self {
        self.options = options;
        self
    }
    pub fn open<V: View + 'static>(&self, root: V) -> Result<Win<V>, Error> {
        self.open_with_options(root, self.options)
    }
    pub fn open_with_options<V: View + 'static>(
        &self,
        root: V,
        options: WindowOptions,
    ) -> Result<Win<V>, Error> {
        Win::with_options(root, options)
    }
}
