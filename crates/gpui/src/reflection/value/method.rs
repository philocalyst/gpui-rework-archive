//! Typed native method handles.
use super::{Value, ValueMut};
use std::any::Any;

/// A typed read-only native method handle.
pub struct Method<Root, Args, Output> {
    name: &'static str,
    call: fn(&Root, Args) -> Output,
}
impl<Root, Args, Output> Copy for Method<Root, Args, Output> {}
impl<Root, Args, Output> Clone for Method<Root, Args, Output> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<Root, Args, Output> Method<Root, Args, Output> {
    /// Creates a method handle from a native typed function.
    pub const fn new(name: &'static str, call: fn(&Root, Args) -> Output) -> Self {
        Self { name, call }
    }
    /// The method name.
    pub fn name(&self) -> &'static str {
        self.name
    }
    /// Calls the method on a typed receiver.
    pub fn call(&self, root: &Root, args: Args) -> Output {
        (self.call)(root, args)
    }
    /// Calls the method on an exact typed erased value.
    pub fn call_on(&self, value: Value<'_>, args: Args) -> Option<Output>
    where
        Root: Any,
    {
        Some((self.call)(value.downcast_ref::<Root>()?, args))
    }
}

/// A typed mutable native method handle.
pub struct MethodMut<Root, Args, Output> {
    name: &'static str,
    call: fn(&mut Root, Args) -> Output,
}
impl<Root, Args, Output> Copy for MethodMut<Root, Args, Output> {}
impl<Root, Args, Output> Clone for MethodMut<Root, Args, Output> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<Root, Args, Output> MethodMut<Root, Args, Output> {
    /// Creates a mutable method handle from a native typed function.
    pub const fn new(name: &'static str, call: fn(&mut Root, Args) -> Output) -> Self {
        Self { name, call }
    }
    /// The method name.
    pub fn name(&self) -> &'static str {
        self.name
    }
    /// Calls the method on a typed receiver.
    pub fn call(&self, root: &mut Root, args: Args) -> Output {
        (self.call)(root, args)
    }
    /// Calls the method on an exact typed mutable erased value.
    pub fn call_on(&self, value: &mut ValueMut<'_>, args: Args) -> Option<Output>
    where
        Root: Any,
    {
        Some((self.call)(value.downcast_mut::<Root>()?, args))
    }
}
