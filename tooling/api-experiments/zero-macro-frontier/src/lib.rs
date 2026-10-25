//! std-only experiments for exposing ordinary Rust trait impls across erasure.
//!
//! Rust can preserve a known trait impl through an explicitly typed projection,
//! but it has no runtime inventory of arbitrary trait impls. The APIs here make
//! that registration boundary visible and compare where its data should live.

use std::{
    any::{Any, TypeId},
    collections::HashMap,
    marker::PhantomData,
    sync::{Arc, OnceLock, RwLock},
};

/// A query is an ordinary higher-ranked closure over a borrowed trait object.
type Query<Q> = Box<dyn for<'a> FnMut(&'a mut Q) + 'static>;

/// The erased callback slot installed by a fluent exposure declaration.
trait Slot: Send + Sync {
    fn key(&self) -> TypeId;
    fn invoke(&self, target: &mut dyn Any, callback: &mut dyn Any) -> bool;
}

struct TypedSlot<T, Q: ?Sized + 'static> {
    project: for<'a> fn(&'a mut T) -> &'a mut Q,
    _marker: PhantomData<fn() -> Q>,
}

impl<T: 'static, Q: ?Sized + 'static> Slot for TypedSlot<T, Q> {
    fn key(&self) -> TypeId {
        TypeId::of::<Q>()
    }

    fn invoke(&self, target: &mut dyn Any, callback: &mut dyn Any) -> bool {
        let (Some(target), Some(callback)) = (
            target.downcast_mut::<T>(),
            callback.downcast_mut::<Query<Q>>(),
        ) else {
            return false;
        };
        callback((self.project)(target));
        true
    }
}

/// Per-value schema: every erased value owns an `Arc` containing its slots.
///
/// This is the most literal `.expose(...)` builder. Its projection is statically
/// checked and can return the original implementor as its ordinary trait object.
pub struct Decorated<T: 'static> {
    value: Box<dyn Any>,
    slots: Arc<[Box<dyn Slot>]>,
    _type: PhantomData<fn() -> T>,
}

pub struct Decorator<T: 'static> {
    value: T,
    slots: Vec<Box<dyn Slot>>,
}

impl<T: 'static> Decorator<T> {
    pub fn new(value: T) -> Self {
        Self {
            value,
            slots: Vec::new(),
        }
    }

    /// Expose a known trait through a typed projection, with no wrapper trait or
    /// per-type macro. The function pointer is monomorphized for `T`.
    pub fn expose<Q: ?Sized + 'static>(
        mut self,
        project: for<'a> fn(&'a mut T) -> &'a mut Q,
    ) -> Self {
        self.slots.push(Box::new(TypedSlot::<T, Q> {
            project,
            _marker: PhantomData,
        }));
        self
    }

    pub fn erase(self) -> Decorated<T> {
        Decorated {
            value: Box::new(self.value),
            slots: self.slots.into(),
            _type: PhantomData,
        }
    }
}

impl<T: 'static> Decorated<T> {
    /// Dispatches only to slots explicitly declared by this value's builder.
    pub fn select<Q: ?Sized + 'static>(
        &mut self,
        mut f: impl for<'a> FnMut(&'a mut Q) + 'static,
    ) -> usize {
        let mut callback: Query<Q> = Box::new(move |value| f(value));
        let callback_any: &mut dyn Any = &mut callback;
        let key = TypeId::of::<Q>();
        let mut matches = 0;
        for slot in self.slots.iter().filter(|slot| slot.key() == key) {
            matches += usize::from(slot.invoke(self.value.as_mut(), callback_any));
        }
        matches
    }

    pub fn downcast_mut<U: 'static>(&mut self) -> Option<&mut U> {
        self.value.downcast_mut()
    }
}

/// Schema table shared by all values of an exact concrete type.
///
/// This models registration once per type and per-element payload only. A real
/// selector would bind these descriptors once before visiting many elements.
#[derive(Default)]
struct Registry {
    slots: HashMap<TypeId, Arc<HashMap<TypeId, Arc<dyn Slot>>>>,
}

fn registry() -> &'static RwLock<Registry> {
    static REGISTRY: OnceLock<RwLock<Registry>> = OnceLock::new();
    REGISTRY.get_or_init(|| RwLock::new(Registry::default()))
}

/// A value erased after schema registration. No per-value slot vector is kept.
pub struct Registered<T: 'static> {
    value: Box<dyn Any>,
    schema: Arc<HashMap<TypeId, Arc<dyn Slot>>>,
    _type: PhantomData<fn() -> T>,
}

/// Reusable, caller-owned registration factory. It avoids per-element schema
/// baggage and the global first-wins policy modeled by `Schema<T>` below.
pub struct Factory<T: 'static> {
    schema: Arc<HashMap<TypeId, Arc<dyn Slot>>>,
    _type: PhantomData<fn() -> T>,
}

impl<T: 'static> Factory<T> {
    pub fn new(configure: impl FnOnce(&mut Registration<T>)) -> Self {
        let mut registration = Registration {
            slots: HashMap::new(),
            _type: PhantomData,
        };
        configure(&mut registration);
        Self {
            schema: Arc::new(registration.slots),
            _type: PhantomData,
        }
    }

    pub fn wrap(&self, value: T) -> Registered<T> {
        Registered {
            value: Box::new(value),
            schema: Arc::clone(&self.schema),
            _type: PhantomData,
        }
    }

    pub fn bind<Q: ?Sized + 'static>(&self) -> Bound<T, Q> {
        Bound {
            slot: self.schema.get(&TypeId::of::<Q>()).cloned(),
            schema: Arc::clone(&self.schema),
            _marker: PhantomData,
        }
    }
}

/// Type-level registration factory. The associated `register` calls are
/// performed once when `register` is first requested for `T`.
pub struct Schema<T: 'static>(PhantomData<fn() -> T>);

impl<T: 'static> Schema<T> {
    pub fn register(value: T, configure: impl FnOnce(&mut Registration<T>)) -> Registered<T> {
        let type_id = TypeId::of::<T>();
        let mut table = registry().write().unwrap();
        if !table.slots.contains_key(&type_id) {
            let mut registration = Registration {
                slots: HashMap::new(),
                _type: PhantomData,
            };
            configure(&mut registration);
            table.slots.insert(type_id, Arc::new(registration.slots));
        }
        let schema = Arc::clone(table.slots.get(&type_id).unwrap());
        drop(table);
        Registered {
            value: Box::new(value),
            schema,
            _type: PhantomData,
        }
    }
}

pub struct Registration<T: 'static> {
    slots: HashMap<TypeId, Arc<dyn Slot>>,
    _type: PhantomData<fn() -> T>,
}

impl<T: 'static> Registration<T> {
    pub fn expose<Q: ?Sized + 'static>(&mut self, project: for<'a> fn(&'a mut T) -> &'a mut Q) {
        self.slots.insert(
            TypeId::of::<Q>(),
            Arc::new(TypedSlot::<T, Q> {
                project,
                _marker: PhantomData,
            }),
        );
    }
}

impl<T: 'static> Registered<T> {
    pub fn bind<Q: ?Sized + 'static>(&self) -> Bound<T, Q> {
        Bound {
            slot: self.schema.get(&TypeId::of::<Q>()).cloned(),
            schema: Arc::clone(&self.schema),
            _marker: PhantomData,
        }
    }

    pub fn select<Q: ?Sized + 'static>(
        &mut self,
        mut f: impl for<'a> FnMut(&'a mut Q) + 'static,
    ) -> bool {
        let mut callback: Query<Q> = Box::new(move |value| f(value));
        let slot = self.schema.get(&TypeId::of::<Q>()).cloned();
        slot.is_some_and(|slot| slot.invoke(self.value.as_mut(), &mut callback))
    }

    pub fn downcast_mut<U: 'static>(&mut self) -> Option<&mut U> {
        self.value.downcast_mut()
    }
}

/// Selector binding resolves the capability once and can be reused for every
/// value carrying the same schema. It removes hashing and global registry work
/// from the per-node path.
pub struct Bound<T: 'static, Q: ?Sized + 'static> {
    slot: Option<Arc<dyn Slot>>,
    schema: Arc<HashMap<TypeId, Arc<dyn Slot>>>,
    _marker: PhantomData<fn(&mut T) -> &mut Q>,
}

impl<T: 'static, Q: ?Sized + 'static> Bound<T, Q> {
    pub fn select(
        &self,
        element: &mut Registered<T>,
        mut f: impl for<'a> FnMut(&'a mut Q) + 'static,
    ) -> bool {
        if !Arc::ptr_eq(&self.schema, &element.schema) {
            return false;
        }
        let Some(slot) = &self.slot else {
            return false;
        };
        let mut callback: Query<Q> = Box::new(move |value| f(value));
        slot.invoke(element.value.as_mut(), &mut callback)
    }
}

/// Runtime type information does not supply `T: Q`. This type-level helper
/// works only when its caller already knows and states the bound.
pub fn known_bound<T: ?Sized>(_: &T)
where
    T: Any,
{
}

#[cfg(test)]
mod tests {
    use super::*;

    trait Editable {
        fn append(&mut self, suffix: &str);
        fn text(&self) -> &str;
    }

    trait Labeled {
        fn label(&self) -> &str;
    }

    struct Card {
        text: String,
        label: String,
        unrelated: u32,
    }
    impl Editable for Card {
        fn append(&mut self, suffix: &str) {
            self.text.push_str(suffix);
        }
        fn text(&self) -> &str {
            &self.text
        }
    }
    impl Labeled for Card {
        fn label(&self) -> &str {
            &self.label
        }
    }

    fn editable(value: &mut Card) -> &mut (dyn Editable + 'static) {
        value
    }
    fn labeled(value: &mut Card) -> &mut (dyn Labeled + 'static) {
        value
    }

    struct RegisteredCard(Card);
    impl Editable for RegisteredCard {
        fn append(&mut self, suffix: &str) {
            self.0.append(suffix);
        }
        fn text(&self) -> &str {
            self.0.text()
        }
    }
    impl Labeled for RegisteredCard {
        fn label(&self) -> &str {
            self.0.label()
        }
    }
    fn registered_editable(value: &mut RegisteredCard) -> &mut (dyn Editable + 'static) {
        value
    }
    fn registered_labeled(value: &mut RegisteredCard) -> &mut (dyn Labeled + 'static) {
        value
    }

    struct MissingCard(Card);
    impl Editable for MissingCard {
        fn append(&mut self, suffix: &str) {
            self.0.append(suffix);
        }
        fn text(&self) -> &str {
            self.0.text()
        }
    }
    impl Labeled for MissingCard {
        fn label(&self) -> &str {
            self.0.label()
        }
    }
    fn missing_editable(value: &mut MissingCard) -> &mut (dyn Editable + 'static) {
        value
    }

    #[test]
    fn fluent_per_value_exposure_preserves_mutation_and_unknown_impls() {
        let mut card = Decorator::new(Card {
            text: "hi".into(),
            label: "title".into(),
            unrelated: 4,
        })
        .expose(editable)
        .expose(labeled)
        .erase();

        assert_eq!(card.select::<dyn Editable>(|value| value.append("!")), 1);
        let seen = std::sync::Arc::new(std::sync::Mutex::new(String::new()));
        let observed = std::sync::Arc::clone(&seen);
        assert_eq!(
            card.select::<dyn Labeled>(move |value| observed
                .lock()
                .unwrap()
                .push_str(value.label())),
            1
        );
        assert_eq!(*seen.lock().unwrap(), "title");
        let value = card.downcast_mut::<Card>().unwrap();
        assert_eq!(value.text(), "hi!");
        assert_eq!(value.unrelated, 4);
    }

    #[test]
    fn inline_projection_infers_the_trait_object_without_a_handle() {
        let mut card = Decorator::new(Card {
            text: String::new(),
            label: String::new(),
            unrelated: 0,
        })
        .expose(|value| value as &mut (dyn Editable + 'static))
        .erase();
        assert_eq!(
            card.select::<dyn Editable>(|value| value.append("inline")),
            1
        );
        assert_eq!(card.downcast_mut::<Card>().unwrap().text, "inline");
    }

    #[test]
    fn caller_owned_factories_can_define_distinct_schemas_for_the_same_type() {
        let edit_factory = Factory::<Card>::new(|schema| schema.expose(editable));
        let title_factory = Factory::<Card>::new(|schema| schema.expose(labeled));
        let mut editable_card = edit_factory.wrap(Card {
            text: String::new(),
            label: "editable".into(),
            unrelated: 0,
        });
        let mut titled_card = title_factory.wrap(Card {
            text: String::new(),
            label: "title".into(),
            unrelated: 0,
        });
        let edit = edit_factory.bind::<dyn Editable>();
        let title = title_factory.bind::<dyn Labeled>();
        assert!(edit.select(&mut editable_card, |value| value.append("ok")));
        let seen = std::sync::Arc::new(std::sync::Mutex::new(String::new()));
        let observed = std::sync::Arc::clone(&seen);
        assert!(title.select(&mut titled_card, move |value| {
            observed.lock().unwrap().push_str(value.label())
        }));
        assert_eq!(editable_card.downcast_mut::<Card>().unwrap().text, "ok");
        assert_eq!(*seen.lock().unwrap(), "title");
        assert!(!edit.select(&mut titled_card, |_| panic!("wrong factory")));
    }

    #[test]
    fn shared_schema_registration_runs_once_for_a_type() {
        let registrations = std::sync::atomic::AtomicUsize::new(0);
        let make = |text: &str, label: &str| {
            RegisteredCard(Card {
                text: text.into(),
                label: label.into(),
                unrelated: 0,
            })
        };
        let mut first = Schema::register(make("a", "x"), |schema| {
            registrations.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
            schema.expose(registered_editable);
            schema.expose(registered_labeled);
        });
        let mut second = Schema::register(make("b", "y"), |_| {
            registrations.fetch_add(100, std::sync::atomic::Ordering::SeqCst);
        });
        assert!(first.select::<dyn Editable>(|value| value.append("1")));
        assert!(second.select::<dyn Editable>(|value| value.append("2")));
        assert_eq!(first.downcast_mut::<RegisteredCard>().unwrap().0.text, "a1");
        assert_eq!(
            second.downcast_mut::<RegisteredCard>().unwrap().0.text,
            "b2"
        );
        assert_eq!(registrations.load(std::sync::atomic::Ordering::SeqCst), 1);
    }

    #[test]
    fn missing_capabilities_are_not_inferred_from_trait_impls() {
        let mut card = Schema::register(
            MissingCard(Card {
                text: "a".into(),
                label: "x".into(),
                unrelated: 0,
            }),
            |schema| {
                schema.expose(missing_editable);
            },
        );
        assert!(!card.select::<dyn Labeled>(|_| panic!("unregistered")));
    }
}
