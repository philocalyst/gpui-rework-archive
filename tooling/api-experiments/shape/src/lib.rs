#[doc(hidden)]
pub use inventory as __inventory;
pub use shape_api_macros::Shape;
use std::{
    any::{Any, TypeId},
    collections::HashMap,
    sync::{LazyLock, Mutex},
};

#[derive(Debug)]
pub struct FieldInfo {
    pub name: &'static str,
    pub type_name: &'static str,
}
#[derive(Debug)]
pub struct CapabilityInfo {
    pub type_id: TypeId,
    pub name: &'static str,
}
#[derive(Debug)]
pub struct ShapeInfo {
    pub type_name: &'static str,
    pub fields: Vec<FieldInfo>,
    pub capabilities: Vec<CapabilityInfo>,
}
pub trait Shape: 'static {
    fn shape() -> &'static ShapeInfo;
}
static SHAPES: LazyLock<Mutex<HashMap<TypeId, &'static ShapeInfo>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));
pub fn metadata_for<T: 'static>(build: impl FnOnce() -> ShapeInfo) -> &'static ShapeInfo {
    let mut shapes = SHAPES.lock().unwrap();
    *shapes
        .entry(TypeId::of::<T>())
        .or_insert_with(|| Box::leak(Box::new(build())))
}

pub trait Capability: 'static {
    const NAME: &'static str;
    fn info() -> CapabilityInfo {
        CapabilityInfo {
            type_id: TypeId::of::<Self>(),
            name: Self::NAME,
        }
    }
}
pub mod capabilities {
    use super::Capability;
    pub struct Styled;
    impl Capability for Styled {
        const NAME: &'static str = "Styled";
    }
    pub struct Parent;
    impl Capability for Parent {
        const NAME: &'static str = "Parent";
    }
    pub struct Draggable;
    impl Capability for Draggable {
        const NAME: &'static str = "Draggable";
    }
    pub struct ReadOnly;
    impl Capability for ReadOnly {
        const NAME: &'static str = "ReadOnly";
    }
}

pub trait Implements<C: Capability> {}
pub trait Requirement {
    fn accepts(info: &ShapeInfo) -> bool;
}
impl<C: Capability> Requirement for C {
    fn accepts(info: &ShapeInfo) -> bool {
        info.capabilities
            .iter()
            .any(|cap| cap.type_id == TypeId::of::<C>())
    }
}
pub struct All<L, R>(std::marker::PhantomData<(L, R)>);
impl<L: Requirement, R: Requirement> Requirement for All<L, R> {
    fn accepts(info: &ShapeInfo) -> bool {
        L::accepts(info) && R::accepts(info)
    }
}
#[derive(Clone, Copy)]
pub struct Select<R = ()> {
    pub descendants: bool,
    _requirement: std::marker::PhantomData<R>,
}
impl Select<()> {
    pub fn this() -> Self {
        Self {
            descendants: false,
            _requirement: std::marker::PhantomData,
        }
    }
    pub fn descendants() -> Self {
        Self {
            descendants: true,
            _requirement: std::marker::PhantomData,
        }
    }
}
impl<R> Select<R> {
    pub fn with<C: Capability>(self) -> Select<C> {
        Select {
            descendants: self.descendants,
            _requirement: std::marker::PhantomData,
        }
    }
    pub fn and<C: Capability>(self) -> Select<All<R, C>> {
        Select {
            descendants: self.descendants,
            _requirement: std::marker::PhantomData,
        }
    }
}
impl<R: Requirement> Select<R> {
    pub fn matches<T: Shape>(&self) -> bool {
        R::accepts(T::shape())
    }
}
impl Select<()> {
    pub fn matches<T: Shape>(&self) -> bool {
        let _ = T::shape();
        true
    }
}

#[allow(dead_code)]
fn _erasure_anchor(_: &dyn Any) {}

pub mod traits {
    pub trait Styled {}
    pub trait Parent {}
}

/// Link-time registration for non-generic concrete shapes.
pub struct ShapeRegistration {
    pub type_id: fn() -> TypeId,
    pub shape: fn() -> &'static ShapeInfo,
}
inventory::collect!(ShapeRegistration);
pub fn linked_shape_for<T: 'static>() -> Option<&'static ShapeInfo> {
    inventory::iter::<ShapeRegistration>
        .into_iter()
        .find(|r| (r.type_id)() == TypeId::of::<T>())
        .map(|r| (r.shape)())
}
