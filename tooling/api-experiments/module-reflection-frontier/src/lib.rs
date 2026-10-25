use std::marker::PhantomData;

pub use module_reflection_frontier_macros::reflect;

#[derive(Clone, Copy)]
pub struct Field<T, V> {
    pub name: &'static str,
    get: for<'a> fn(&'a T) -> &'a V,
    set: fn(&mut T, V),
}

impl<T, V> Field<T, V> {
    pub const fn new(
        name: &'static str,
        get: for<'a> fn(&'a T) -> &'a V,
        set: fn(&mut T, V),
    ) -> Self {
        Self { name, get, set }
    }

    pub fn get<'a>(&self, value: &'a T) -> &'a V {
        (self.get)(value)
    }

    pub fn set(&self, value: &mut T, next: V) {
        (self.set)(value, next)
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct MethodRecord {
    pub name: &'static str,
    pub signature: &'static str,
    pub trait_name: Option<&'static str>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct VariantRecord {
    pub name: &'static str,
    pub fields: &'static [&'static str],
}

pub trait Reflect: Sized {
    type Fields;

    fn fields() -> Self::Fields;
    fn field_names() -> &'static [&'static str];
    fn methods() -> &'static [MethodRecord];
    fn variants() -> &'static [VariantRecord] {
        &[]
    }
}

/// A compact runtime hook that an element derive can delegate to.
pub trait ElementSchema: Reflect {
    fn schema() -> Schema {
        Schema {
            type_name: std::any::type_name::<Self>(),
            fields: Self::field_names().to_vec(),
            methods: Self::methods(),
            variants: Self::variants(),
        }
    }
}

#[derive(Debug)]
pub struct Schema {
    pub type_name: &'static str,
    pub fields: Vec<&'static str>,
    pub methods: &'static [MethodRecord],
    pub variants: &'static [VariantRecord],
}

pub struct Marker<T>(PhantomData<T>);
