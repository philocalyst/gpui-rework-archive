use std::any::Any;

pub use frontier_reflect_macros::reflect_module;

pub enum Value<'a> {
    Borrowed(&'a mut dyn Any),
    F32(f32),
    U32(u32),
    Bool(bool),
    Unit,
}

pub struct Field {
    pub name: &'static str,
    pub type_name: &'static str,
    pub get: for<'a> fn(&'a mut dyn Any) -> Option<Value<'a>>,
    pub set: fn(&mut dyn Any, Value<'_>) -> bool,
}

impl Field {
    pub fn get<'a>(&self, target: &'a mut dyn Any) -> Option<Value<'a>> {
        (self.get)(target)
    }

    pub fn set(&self, target: &mut dyn Any, value: Value<'_>) -> bool {
        (self.set)(target, value)
    }
}

pub struct Method {
    pub name: &'static str,
    pub call: fn(&mut dyn Any) -> bool,
}

impl Method {
    pub fn call(&self, target: &mut dyn Any) -> bool {
        (self.call)(target)
    }
}

pub struct Type {
    pub name: &'static str,
    pub fields: &'static [Field],
    pub methods: &'static [Method],
}

pub trait Describe: Any {
    fn type_view() -> &'static Type;
}

pub struct View<'a, T: Describe> {
    value: &'a mut T,
    ty: &'static Type,
}

impl<'a, T: Describe> View<'a, T> {
    pub fn new(value: &'a mut T) -> Self {
        Self { value, ty: T::type_view() }
    }

    pub fn ty(&self) -> &'static Type { self.ty }

    pub fn get(&mut self, name: &str) -> Option<Value<'_>> {
        self.ty.fields.iter().find(|f| f.name == name)?.get(self.value)
    }

    pub fn set(&mut self, name: &str, value: Value<'_>) -> bool {
        self.ty.fields.iter().find(|f| f.name == name).is_some_and(|f| f.set(self.value, value))
    }

    pub fn call(&mut self, name: &str) -> bool {
        self.ty.methods.iter().find(|m| m.name == name).is_some_and(|m| m.call(self.value))
    }
}

pub fn view<T: Describe>(value: &mut T) -> View<'_, T> {
    View::new(value)
}
