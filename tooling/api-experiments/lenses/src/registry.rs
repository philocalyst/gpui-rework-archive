//! A macro-free erased registry of typed capability adapters.
//!
//! Unlike the direct-target lens experiment in the parent module, a registry
//! schema lets a query ask for a fixed trait object across several concrete
//! element types. Adapter downcasts and projection are fully safe.
use std::{
    any::{Any, TypeId},
    collections::HashMap,
    marker::PhantomData,
    sync::Arc,
};

/// A key-specific projection from an element to a borrowed capability.
pub trait RegistryLens<Element: 'static, Target: ?Sized + 'static> {
    fn project<'a>(element: &'a mut Element) -> &'a mut Target;
}

/// Typed handle for querying a trait object from a registered erased element.
pub struct RegistryCapability<Target: ?Sized + 'static, Key: 'static>(
    PhantomData<(*const Target, fn() -> Key)>,
);

impl<Target: ?Sized + 'static, Key: 'static> Copy for RegistryCapability<Target, Key> {}
impl<Target: ?Sized + 'static, Key: 'static> Clone for RegistryCapability<Target, Key> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<Target: ?Sized + 'static, Key: 'static> RegistryCapability<Target, Key> {
    pub const fn new() -> Self {
        Self(PhantomData)
    }
}

type ErasedProject<Target> = for<'a> fn(&'a mut dyn Any) -> &'a mut Target;

/// Per-capability adapter. Its function pointer is monomorphized for one
/// `(Element, Target, Key)` registration and downcasts before projecting.
struct Adapter<Target: ?Sized + 'static> {
    project: ErasedProject<Target>,
}

fn project<Element, Target, Key>(erased: &mut dyn Any) -> &mut Target
where
    Element: 'static,
    Target: ?Sized + 'static,
    Key: RegistryLens<Element, Target>,
{
    Key::project(
        erased
            .downcast_mut::<Element>()
            .expect("schema adapter used with its registered element type"),
    )
}

pub struct SchemaBuilder<E: 'static> {
    entries: HashMap<TypeId, Box<dyn Any + Send + Sync>>,
    element: PhantomData<fn() -> E>,
}

impl<E: 'static> SchemaBuilder<E> {
    pub fn new() -> Self {
        Self {
            entries: HashMap::new(),
            element: PhantomData,
        }
    }

    pub fn register<Target, Key>(&mut self, _: RegistryCapability<Target, Key>)
    where
        Target: ?Sized + 'static,
        Key: RegistryLens<E, Target> + 'static,
    {
        let key = TypeId::of::<RegistryCapability<Target, Key>>();
        let adapter: Box<dyn Any + Send + Sync> = Box::new(Adapter::<Target> {
            project: project::<E, Target, Key>,
        });
        assert!(
            self.entries.insert(key, adapter).is_none(),
            "duplicate capability key"
        );
    }

    pub fn build(self) -> Schema<E> {
        Schema {
            entries: self.entries,
            element: PhantomData,
        }
    }
}

/// Immutable capability table for one concrete element type. Store it in a
/// `LazyLock` or `OnceLock` to reuse the same schema for every element.
pub struct Schema<E: 'static> {
    entries: HashMap<TypeId, Box<dyn Any + Send + Sync>>,
    element: PhantomData<fn() -> E>,
}

impl<E: 'static> Schema<E> {
    pub fn builder() -> SchemaBuilder<E> {
        SchemaBuilder::new()
    }

    fn has<Target: ?Sized + 'static, Key: 'static>(
        &self,
        _: RegistryCapability<Target, Key>,
    ) -> bool {
        self.entries
            .contains_key(&TypeId::of::<RegistryCapability<Target, Key>>())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::LazyLock;

    trait Draggable {
        fn payload(&mut self) -> &mut String;
    }
    trait Labelled {
        type Label;
        fn label(&self) -> &Self::Label;
    }
    struct Payload(String);
    impl Draggable for Payload {
        fn payload(&mut self) -> &mut String {
            &mut self.0
        }
    }
    struct Card {
        primary: Payload,
        secondary: Payload,
        label: String,
    }
    struct Pill(String);
    impl Labelled for Card {
        type Label = String;
        fn label(&self) -> &String {
            &self.label
        }
    }
    impl Draggable for Pill {
        fn payload(&mut self) -> &mut String {
            &mut self.0
        }
    }

    struct Drag;
    struct PrimaryDrag;
    struct SecondaryDrag;
    struct Label;
    impl RegistryLens<Card, dyn Draggable> for PrimaryDrag {
        fn project<'a>(card: &'a mut Card) -> &'a mut (dyn Draggable + 'static) {
            &mut card.primary
        }
    }
    impl RegistryLens<Card, dyn Draggable> for SecondaryDrag {
        fn project<'a>(card: &'a mut Card) -> &'a mut (dyn Draggable + 'static) {
            &mut card.secondary
        }
    }
    impl RegistryLens<Pill, dyn Draggable> for Drag {
        fn project<'a>(pill: &'a mut Pill) -> &'a mut (dyn Draggable + 'static) {
            pill
        }
    }
    impl RegistryLens<Card, dyn Labelled<Label = String>> for Label {
        fn project<'a>(card: &'a mut Card) -> &'a mut (dyn Labelled<Label = String> + 'static) {
            card
        }
    }

    type CardSchema = Schema<Card>;
    type PillSchema = Schema<Pill>;
    static CARD_SCHEMA: LazyLock<Arc<CardSchema>> = LazyLock::new(|| {
        let mut builder = Schema::builder();
        builder.register(RegistryCapability::<dyn Draggable, PrimaryDrag>::new());
        builder.register(RegistryCapability::<dyn Draggable, SecondaryDrag>::new());
        builder.register(RegistryCapability::<dyn Labelled<Label = String>, Label>::new());
        Arc::new(builder.build())
    });
    static PILL_SCHEMA: LazyLock<Arc<PillSchema>> = LazyLock::new(|| {
        let mut builder = Schema::builder();
        builder.register(RegistryCapability::<dyn Draggable, Drag>::new());
        Arc::new(builder.build())
    });

    #[test]
    fn erased_handle_queries_multiple_concrete_types_and_fixed_associated_types() {
        let mut card = RegisteredElement::new(
            Card {
                primary: Payload("card".into()),
                secondary: Payload("other".into()),
                label: "document".into(),
            },
            CARD_SCHEMA.clone(),
        );
        let mut pill = RegisteredElement::new(Pill("pill".into()), PILL_SCHEMA.clone());
        let drag_card = RegistryCapability::<dyn Draggable, PrimaryDrag>::new();
        let drag_pill = RegistryCapability::<dyn Draggable, Drag>::new();
        assert!(card.has(drag_card));
        assert!(pill.has(drag_pill));
        assert!(!pill.has(drag_card));

        card.get(drag_card).unwrap().payload().push_str("!");
        pill.get(drag_pill).unwrap().payload().push_str("!");
        let label = card
            .get(RegistryCapability::<dyn Labelled<Label = String>, Label>::new())
            .unwrap();
        assert_eq!(label.label(), "document");
    }

    #[test]
    fn same_trait_keys_can_be_borrowed_interleaved_without_aliasing() {
        let mut card = RegisteredElement::new(
            Card {
                primary: Payload("a".into()),
                secondary: Payload("b".into()),
                label: "".into(),
            },
            CARD_SCHEMA.clone(),
        );
        let first = RegistryCapability::<dyn Draggable, PrimaryDrag>::new();
        let second = RegistryCapability::<dyn Draggable, SecondaryDrag>::new();
        card.get(first).unwrap().payload().push('1');
        card.get(second).unwrap().payload().push('2');
        card.get(first).unwrap().payload().push('3');
        let card = card.value.downcast_ref::<Card>().unwrap();
        assert_eq!(card.primary.0, "a13");
        assert_eq!(card.secondary.0, "b2");
    }
}

/// A runtime element and its memoized concrete schema.
pub struct RegisteredElement {
    value: Box<dyn Any>,
    schema: Arc<dyn ErasedSchema>,
}

trait ErasedSchema: Send + Sync {
    fn contains(&self, key: TypeId) -> bool;
    fn adapter(&self, key: TypeId) -> Option<&(dyn Any + Send + Sync)>;
}

impl<E: 'static> ErasedSchema for Schema<E> {
    fn contains(&self, key: TypeId) -> bool {
        self.entries.contains_key(&key)
    }
    fn adapter(&self, key: TypeId) -> Option<&(dyn Any + Send + Sync)> {
        self.entries.get(&key).map(Box::as_ref)
    }
}

impl RegisteredElement {
    pub fn new<E: 'static>(value: E, schema: Arc<Schema<E>>) -> Self {
        Self {
            value: Box::new(value),
            schema,
        }
    }

    /// Checks a capability without taking a mutable borrow of the value.
    pub fn has<Target: ?Sized + 'static, Key: 'static>(
        &self,
        capability: RegistryCapability<Target, Key>,
    ) -> bool {
        let _ = capability;
        self.schema
            .contains(TypeId::of::<RegistryCapability<Target, Key>>())
    }

    /// Lends one capability view for the duration of the receiver borrow.
    ///
    /// A second mutable capability cannot be obtained until the first view is no longer used:
    ///
    /// ```compile_fail
    /// use gpui_lens_experiment::registry::{RegisteredElement, RegistryCapability, RegistryLens, Schema};
    /// trait Draw { fn draw(&mut self); }
    /// struct Item; impl Draw for Item { fn draw(&mut self) {} }
    /// struct DrawKey;
    /// impl RegistryLens<Item, dyn Draw> for DrawKey {
    ///     fn project<'a>(item: &'a mut Item) -> &'a mut (dyn Draw + 'static) { item }
    /// }
    /// let handle = RegistryCapability::<dyn Draw, DrawKey>::new();
    /// let mut builder = Schema::<Item>::builder(); builder.register(handle);
    /// let mut element = RegisteredElement::new(Item, std::sync::Arc::new(builder.build()));
    /// let first = element.get(handle).unwrap();
    /// let second = element.get(handle).unwrap();
    /// first.draw(); second.draw();
    /// ```
    pub fn get<Target: ?Sized + 'static, Key: 'static>(
        &mut self,
        capability: RegistryCapability<Target, Key>,
    ) -> Option<&mut Target> {
        let _ = capability;
        let key = TypeId::of::<RegistryCapability<Target, Key>>();
        let adapter = self
            .schema
            .adapter(key)?
            .downcast_ref::<Adapter<Target>>()?;
        Some((adapter.project)(self.value.as_mut()))
    }
}

// Make Schema's typed helper usefully callable in docs/tests without exposing
// its internal registration map. The schema itself is shared through Arc.
impl<E: 'static> Schema<E> {
    pub fn is_registered<Target: ?Sized + 'static, Key: 'static>(
        &self,
        capability: RegistryCapability<Target, Key>,
    ) -> bool {
        self.has(capability)
    }
}
