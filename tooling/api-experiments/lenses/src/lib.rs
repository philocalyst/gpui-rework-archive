//! Macro-free borrowed capabilities for erased, known element types.
//!
//! A capability is a typed downcast followed by a user-authored projection. The
//! projection's output lifetime is tied to the erased receiver borrow, so it can
//! return a normal borrowed trait object without storing a trait-object pointer.
use std::{any::Any, marker::PhantomData};

pub mod registry;

/// Projects a concrete target to a borrowed view. `View` may be a trait object
/// with fixed associated types, or any other borrow derived from `Target`.
pub trait Lens<Target: 'static> {
    type View<'a>
    where
        Target: 'a,
        Self: 'a;

    fn project(target: &mut Target) -> Self::View<'_>;
}

/// A statically typed capability query for a concrete target and lens.
pub struct Capability<Target, Key>(PhantomData<fn() -> (Target, Key)>);

impl<Target, Key> Copy for Capability<Target, Key> {}
impl<Target, Key> Clone for Capability<Target, Key> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<Target: 'static, Key: Lens<Target>> Capability<Target, Key> {
    pub const fn new() -> Self {
        Self(PhantomData)
    }

    /// Returns a view only when the erased value is exactly `Target`.
    pub fn get<'a>(&self, erased: &'a mut dyn Any) -> Option<Key::View<'a>> {
        erased.downcast_mut::<Target>().map(Key::project)
    }

    /// Runs a closure with a borrowed view. The view cannot outlive this call.
    pub fn with<R>(
        &self,
        erased: &mut dyn Any,
        f: impl for<'a> FnOnce(Key::View<'a>) -> R,
    ) -> Option<R> {
        self.get(erased).map(f)
    }
}

/// A minimal stand-in for GPUI's erased element receiver in consumer examples.
pub struct ErasedElement(Box<dyn Any>);

impl ErasedElement {
    pub fn new<T: 'static>(value: T) -> Self {
        Self(Box::new(value))
    }
    pub fn capability<Target: 'static, Key: Lens<Target>>(
        &mut self,
        capability: Capability<Target, Key>,
    ) -> Option<Key::View<'_>> {
        capability.get(self.0.as_mut())
    }
    pub fn downcast_mut<T: 'static>(&mut self) -> Option<&mut T> {
        self.0.downcast_mut()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    trait Draggable {
        fn payload(&mut self) -> &mut String;
    }
    trait HasOutput {
        type Output;
        fn output(&self) -> &Self::Output;
    }
    trait GenericService {
        fn invoke<Input>(&self, input: Input);
    }

    struct Card {
        payload: String,
    }
    impl Draggable for Card {
        fn payload(&mut self) -> &mut String {
            &mut self.payload
        }
    }
    impl HasOutput for Card {
        type Output = String;
        fn output(&self) -> &String {
            &self.payload
        }
    }
    impl GenericService for Card {
        fn invoke<Input>(&self, _: Input) {}
    }

    struct Drag;
    impl Lens<Card> for Drag {
        type View<'a> = &'a mut dyn Draggable;
        fn project(target: &mut Card) -> Self::View<'_> {
            target
        }
    }
    struct TextOutput;
    impl Lens<Card> for TextOutput {
        type View<'a> = &'a dyn HasOutput<Output = String>;
        fn project(target: &mut Card) -> Self::View<'_> {
            target
        }
    }
    struct GenericServiceMembership;
    impl Lens<Card> for GenericServiceMembership
    where
        Card: GenericService,
    {
        type View<'a> = ();
        fn project(_: &mut Card) {
            let _ = <Card as GenericService>::invoke::<()>;
        }
    }

    #[test]
    fn queries_dyn_trait_and_associated_type_bound_from_erased_element() {
        let mut element = ErasedElement::new(Card {
            payload: "drag".into(),
        });
        element
            .capability(Capability::<Card, Drag>::new())
            .unwrap()
            .payload()
            .push_str("ged");
        let text = element
            .capability(Capability::<Card, TextOutput>::new())
            .unwrap();
        assert_eq!(text.output(), "dragged");
        assert!(
            element
                .capability(Capability::<Card, GenericServiceMembership>::new())
                .is_some()
        );
        let mut wrong_type = ErasedElement::new(String::new());
        assert!(
            wrong_type
                .capability(Capability::<Card, Drag>::new())
                .is_none()
        );
    }

    #[test]
    fn concrete_generic_targets_can_be_registered_without_macros() {
        struct Wrapper<T>(T);
        trait Value {
            fn value(&self) -> &str;
        }
        impl Value for Wrapper<String> {
            fn value(&self) -> &str {
                &self.0
            }
        }
        struct ValueLens;
        impl Lens<Wrapper<String>> for ValueLens {
            type View<'a> = &'a dyn Value;
            fn project(target: &mut Wrapper<String>) -> Self::View<'_> {
                target
            }
        }
        let mut erased = ErasedElement::new(Wrapper("generic".to_owned()));
        assert_eq!(
            erased
                .capability(Capability::<Wrapper<String>, ValueLens>::new())
                .unwrap()
                .value(),
            "generic"
        );
    }

    #[test]
    fn ordinary_receiver_remains_mutably_borrowed() {
        let mut erased = ErasedElement::new(Card {
            payload: "x".into(),
        });
        erased
            .capability(Capability::<Card, Drag>::new())
            .unwrap()
            .payload()
            .push('y');
        assert_eq!(erased.downcast_mut::<Card>().unwrap().payload, "xy");
    }
}

/// Borrowed views may not escape the receiver borrow.
/// ```compile_fail
/// use gpui_lens_experiment::{Capability, ErasedElement, Lens};
/// trait Name { fn name(&self) -> &str; }
/// struct Item(String); impl Name for Item { fn name(&self) -> &str { &self.0 } }
/// struct NameLens;
/// impl Lens<Item> for NameLens {
///     type View<'a> = &'a dyn Name;
///     fn project(item: &mut Item) -> Self::View<'_> { item }
/// }
/// let mut erased = ErasedElement::new(Item("x".into()));
/// let view = erased.capability(Capability::<Item, NameLens>::new()).unwrap();
/// drop(erased);
/// println!("{}", view.name());
/// ```
pub struct BorrowCheckExample;
