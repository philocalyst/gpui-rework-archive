extern crate self as gpui;
pub use module_shape_audit::reflection;

use module_shape_audit::reflection::{Describe, TypeKind};

#[module_shape_audit::reflect]
mod probe {
    use std::fmt::Debug;

    pub trait Parent { fn parent(&self); }
    pub trait Child: Parent { type Item; fn item(&self) -> &Self::Item; fn sized_only(&self) where Self: Sized; }
    pub trait Exempt { fn generic<T>(&self, _: T) where Self: Sized; async fn task(&self) where Self: Sized; }
    pub trait InheritedParent { type ParentValue; }
    pub trait InheritedChild: InheritedParent { fn child(&self); fn value(&self) -> &Self::ParentValue; }
    pub trait DiamondRoot { type Leaf; }
    pub trait DiamondLeft: DiamondRoot {}
    pub trait DiamondRight: DiamondRoot {}
    pub trait Diamond: DiamondLeft + DiamondRight {}
    pub trait Factory { fn make(&self) -> impl Copy; }
    pub trait GatExempt { type Item<T> where Self: Sized; fn helper(&self) where Self: Sized; }
    pub trait External: Iterator<Item = u8> {}
    pub trait CfgAssociated {
        #[cfg(any())] type Disabled;
        #[cfg(not(any()))] type Enabled;
    }
    #[cfg(any())] pub trait DisabledTrait {}
    pub struct Leaf(pub u32);
    pub struct Conditional { #[cfg(unix)] pub unix: u8, #[cfg(not(unix))] pub other: u8 }
    impl Conditional { #[cfg(unix)] pub fn branch(&self) -> u8 { self.unix } #[cfg(not(unix))] pub fn branch(&self) -> u8 { self.other } }
    pub struct Generic<T> { pub value: T }
    impl<U: Clone> Generic<U> { pub fn clone_value(&self) -> U { self.value.clone() } }
    impl<V: Copy> Generic<V> { pub fn copy_value(&self) -> V { self.value } }
    impl Generic<u8> { pub fn only_u8(&self) -> u8 { self.value } }
    impl Generic<String> { pub fn only_string(&self) -> usize { self.value.len() } }
    pub enum Event<T> { Unit, Tuple(T), Named { nested: Option<Vec<Leaf>>, item: T } }
    pub struct Private { field: u32, pub(super) semi: u16 }
    impl Private { fn value(&self) -> u32 { self.field } }
    impl Parent for Private { fn parent(&self) {} }
    impl Exempt for Private { fn generic<T>(&self, _: T) {} async fn task(&self) {} }
    impl Child for Private {
        type Item = u32;
        fn item(&self) -> &Self::Item { &self.field }
        fn sized_only(&self) {}
    }
    pub struct Inherited;
    impl InheritedParent for Inherited { type ParentValue = u8; }
    impl InheritedChild for Inherited { fn child(&self) {} fn value(&self) -> &Self::ParentValue { &0 } }
    pub struct DiamondValue;
    impl DiamondRoot for DiamondValue { type Leaf = u16; }
    impl DiamondLeft for DiamondValue {}
    impl DiamondRight for DiamondValue {}
    impl Diamond for DiamondValue {}
    pub struct Maker;
    impl Factory for Maker { fn make(&self) -> impl Copy { 1u8 } }
    impl GatExempt for Maker { type Item<T> = T; fn helper(&self) {} }
    pub struct Iter;
    impl Iterator for Iter { type Item = u8; fn next(&mut self) -> Option<u8> { None } }
    impl External for Iter {}
    impl CfgAssociated for Maker {
        #[cfg(any())] type Disabled = u8;
        #[cfg(not(any()))] type Enabled = u16;
    }
    #[cfg(any())] impl DisabledTrait for Maker {}
    #[cfg(unix)] pub trait CfgRole { fn run(&self); }
    #[cfg(unix)] impl CfgRole for Maker { fn run(&self) {} }
    #[cfg_attr(unix, doc = "An ordinary trait attribute that should stay on the trait.")]
    pub trait DocRole { fn run(&self); }
    impl DocRole for Maker { fn run(&self) {} }
    pub struct Recursive { pub children: Vec<Option<Box<Recursive>>> }
    pub trait DebugRole: Debug { fn show(&self); }
    pub struct Debugger;
    impl Debug for Debugger { fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result { f.write_str("d") } }
    impl DebugRole for Debugger { fn show(&self) {} }
    pub struct WithAssociated;
    impl WithAssociated { const LIMIT: u16 = 5; pub fn constant(&self) -> u16 { Self::LIMIT } }
    pub trait Assoc { type Out; fn get(&self) -> Self::Out; }
    impl Assoc for WithAssociated { type Out = u16; fn get(&self) -> Self::Out { 1 } }
    impl WithAssociated { pub fn qualified(&self) -> <Self as Assoc>::Out { 2 } }
}

#[test]
fn tuples_generics_and_recursive_shapes_build() {
    assert_eq!(probe::Leaf::type_shape().kind(), TypeKind::Struct);
    #[cfg(unix)] assert_eq!(probe::Conditional::methods().branch.call(&probe::Conditional { unix: 9 }), 9);
    #[cfg(not(unix))] assert_eq!(probe::Conditional::methods().branch.call(&probe::Conditional { other: 9 }), 9);
    assert_eq!(probe::Event::<u8>::type_shape().kind(), TypeKind::Enum);
    assert_eq!(probe::Event::<u8>::type_shape().fields().count(), 3);
    let recursive_field = probe::Recursive::type_shape().fields().next().unwrap();
    assert!(recursive_field.ty.is_sequence());
    let nested_option = probe::Event::<u8>::type_shape().fields().find(|field| field.name == "nested").unwrap().ty;
    assert!(nested_option.is_sequence());
    assert!(nested_option.is_enum());
    assert_eq!(probe::Generic::<u8>::methods().only_u8.call(&probe::Generic { value: 1 }), 1);
    assert_eq!(probe::Generic::<String>::methods().only_string.call(&probe::Generic { value: "abc".into() }), 3);
    assert_eq!(probe::Generic::<String>::methods().clone_value.call(&probe::Generic { value: "cloned".into() }), "cloned");
    assert_eq!(probe::Generic::<u8>::methods().copy_value.call(&probe::Generic { value: 4 }), 4);
}

#[test]
fn local_supertrait_and_associated_type_roles_register() {
    let role = probe::Private::type_shape();
    assert!(role.has_role::<dyn probe::Child<Item = u32>>());
    assert!(role.has_role::<dyn probe::Exempt>());
    assert!(probe::Inherited::type_shape().has_role::<dyn probe::InheritedChild<ParentValue = u8>>());
    assert!(probe::DiamondValue::type_shape().has_role::<dyn probe::Diamond<Leaf = u16>>());
    // RPITIT is not object-safe, so it must not create an invalid generated cast.
    assert_eq!(probe::Maker::type_shape().kind(), TypeKind::Struct);
    assert!(probe::Maker::type_shape().has_role::<dyn probe::GatExempt>());
    assert_eq!(probe::Iter::type_shape().kind(), TypeKind::Struct);
    #[cfg(unix)] assert!(probe::Maker::type_shape().has_role::<dyn probe::CfgRole>());
    assert!(probe::Maker::type_shape().has_role::<dyn probe::DocRole>());
    // External trait ancestry with unknown object bindings omits only the optional role.
    assert_eq!(probe::Debugger::type_shape().kind(), TypeKind::Struct);
    assert!(probe::WithAssociated::type_shape().has_role::<dyn probe::Assoc<Out = u16>>());
    let value = probe::WithAssociated;
    assert_eq!(probe::WithAssociated::methods().qualified.call(&value), 2);
    assert_eq!(probe::WithAssociated::methods().constant.call(&value), 5);
}
