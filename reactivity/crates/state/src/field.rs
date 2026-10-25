/// A macro-free, typed field descriptor for tooling and explicit overrides.
///
/// Access uses ordinary shared/exclusive borrows, with no offsets, raw pointers,
/// erased values, runtime lookup, or stored subscription. `I` is caller-supplied
/// metadata, such as a port impact declared by the UI layer. This descriptor
/// does not schedule that impact or automatically enumerate a model's fields.
pub struct TypedField<M, T, I = ()> {
    name: &'static str,
    read: fn(&M) -> &T,
    write: fn(&mut M) -> &mut T,
    impact: I,
}

impl<M, T, I> TypedField<M, T, I> {
    pub const fn new(
        name: &'static str,
        read: fn(&M) -> &T,
        write: fn(&mut M) -> &mut T,
        impact: I,
    ) -> Self {
        Self {
            name,
            read,
            write,
            impact,
        }
    }

    pub fn name(&self) -> &'static str {
        self.name
    }
    pub fn impact(&self) -> &I {
        &self.impact
    }
    pub fn get<'a>(&self, model: &'a M) -> &'a T {
        (self.read)(model)
    }
    pub fn get_mut<'a>(&self, model: &'a mut M) -> &'a mut T {
        (self.write)(model)
    }
}

// Deriving would unnecessarily require M and T themselves to implement Copy.
impl<M, T, I: Copy> Copy for TypedField<M, T, I> {}

impl<M, T, I: Clone> Clone for TypedField<M, T, I> {
    fn clone(&self) -> Self {
        Self {
            name: self.name,
            read: self.read,
            write: self.write,
            impact: self.impact.clone(),
        }
    }
}
