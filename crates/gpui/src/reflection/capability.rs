//! Macro-free, typed capabilities for values erased into [`crate::AnyElement`].
//!
//! A capability binds a trait-object view to each concrete element type in that
//! element's reflected schema. Queries borrow the stored receiver and never
//! retain a trait-object pointer.

use super::{
    BuiltinAccess, CallableReflectionToken, IncludesCallableTrait, IncludesReflectedTrait,
    NoAccess, ReflectedImplementation, ReflectedTrait, ReflectionGroup, ReflectionRequirement,
    ReflectionRequirements, ReflectionToken,
};
use crate::AnyElement;
use std::{
    any::{Any, TypeId},
    marker::PhantomData,
};

fn capability_type_id<Target: ?Sized + 'static, Key: ?Sized + 'static>() -> TypeId {
    TypeId::of::<Capability<Target, Key>>()
}

/// A typed handle for borrowing a custom trait view from a reflected element.
///
/// `Target` is usually a trait object such as `dyn Draggable`. `Key` distinguishes
/// multiple projections with the same trait-object type; it defaults to `Target`
/// when a type needs only one projection.
///
/// Every concrete element that supports the handle registers an adapter in its
/// [`super::Reflect::build_reflection`] implementation:
///
/// ```ignore
/// fn build_reflection() -> Vec<ReflectedImplementation<Card>> {
///     vec![Capability::<dyn Draggable>::new("Draggable")
///         .bind::<Card>(|card| card)]
/// }
/// ```
///
/// The projection is a function pointer so the registered schema contains no
/// captured element state. Use separate key types to register separate views of
/// the same trait from one element.
pub struct Capability<Target: ?Sized + 'static, Key: ?Sized + 'static = Target> {
    descriptor: ReflectedTrait,
    marker: PhantomData<fn(&mut Target, &mut Key)>,
}

/// The type-level group supplied by one capability handle.
#[doc(hidden)]
pub struct CapabilityGroup<Target: ?Sized + 'static, Key: ?Sized + 'static>(
    PhantomData<fn(&mut Target, &mut Key)>,
);

impl<Target: ?Sized + 'static, Key: ?Sized + 'static> ReflectionGroup
    for CapabilityGroup<Target, Key>
{
    type Access = NoAccess;
    type Tables =
        super::GroupTables<&'static CapabilityTable<Target, Key>, super::BuiltinTables<NoAccess>>;

    fn bind_tables(metadata: &'static super::ElementReflection) -> Option<Self::Tables> {
        Some(super::GroupTables {
            callables: metadata.resolve(Capability::<Target, Key>::new("Capability"))?,
            builtins: NoAccess::bind_tables(metadata)?,
        })
    }
}

impl<Target: ?Sized + 'static, Key: ?Sized + 'static>
    IncludesReflectedTrait<Capability<Target, Key>> for CapabilityGroup<Target, Key>
{
}

impl<Target: ?Sized + 'static, Key: ?Sized + 'static> IncludesCallableTrait<Capability<Target, Key>>
    for CapabilityGroup<Target, Key>
{
    fn methods(tables: &Self::Tables) -> &'static CapabilityTable<Target, Key> {
        tables.callables
    }
}

impl<Target: ?Sized + 'static, Key: ?Sized + 'static> Copy for Capability<Target, Key> {}

impl<Target: ?Sized + 'static, Key: ?Sized + 'static> Clone for Capability<Target, Key> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<Target: ?Sized + 'static, Key: ?Sized + 'static> Capability<Target, Key> {
    /// Creates a handle with a diagnostic name.
    pub const fn new(name: &'static str) -> Self {
        Self {
            descriptor: ReflectedTrait::new(name, capability_type_id::<Target, Key>),
            marker: PhantomData,
        }
    }

    /// Registers a borrowed projection for one concrete element type.
    ///
    /// The same handle can be bound to several element types. Each binding is
    /// stored in that type's memoized reflection schema. Bind a handle only once
    /// per concrete type; use a distinct `Key` type for a second projection of
    /// the same trait object from that element.
    pub fn bind<Element: 'static>(
        self,
        project: for<'a> fn(&'a mut Element) -> &'a mut Target,
    ) -> ReflectedImplementation<Element> {
        ReflectedImplementation::__new(
            self.descriptor,
            Some(Box::new(CapabilityTable::<Target, Key> {
                adapter: Box::new(BoundAdapter::<Element, Target> {
                    project,
                    marker: PhantomData,
                }),
                marker: PhantomData,
            })),
        )
    }

    /// Checks registration and lends a mutable view into the erased element.
    ///
    /// The returned reference is tied to `element`; another mutable capability
    /// query cannot overlap it. Calls remain valid across layout retries and
    /// should be written with those repeated calls in mind.
    ///
    /// ```compile_fail
    /// use gpui::{div, IntoElement, reflection::Capability};
    /// trait Value { fn value(&mut self); }
    /// let mut element = div().into_any_element();
    /// let capability = Capability::<dyn Value>::new("Value");
    /// let first = capability.get_mut(&mut element).unwrap();
    /// let second = capability.get_mut(&mut element).unwrap();
    /// first.value(); second.value();
    /// ```
    pub fn get_mut(self, element: &mut AnyElement) -> Option<&mut Target> {
        let methods = element
            .reflection()
            .method_table::<CapabilityTable<Target, Key>>(self.descriptor)?;
        methods.get_mut(element.inner_element_mut())
    }
}

impl<Target: ?Sized + 'static, Key: ?Sized + 'static> ReflectionToken for Capability<Target, Key> {
    type Group = CapabilityGroup<Target, Key>;
    type Access = super::NoAccess;
    type Adapter = super::Callable<CapabilityTable<Target, Key>>;

    fn reflected_trait(self) -> ReflectedTrait {
        self.descriptor
    }

    fn requirement(self) -> ReflectionRequirement {
        ReflectionRequirement::callable(self)
    }

    fn append_requirements(self, requirements: &mut ReflectionRequirements) {
        let requirement = self.requirement();
        if !requirements.contains(&requirement) {
            requirements.push(requirement);
        }
    }
}

impl<Target: ?Sized + 'static, Key: ?Sized + 'static> CallableReflectionToken
    for Capability<Target, Key>
{
    type Methods = CapabilityTable<Target, Key>;
}

/// The typed table stored in a reflected element schema for a capability.
#[doc(hidden)]
pub struct CapabilityTable<Target: ?Sized + 'static, Key: ?Sized + 'static> {
    adapter: Box<dyn CapabilityAdapter<Target>>,
    marker: PhantomData<fn(&mut Target, &mut Key)>,
}

impl<Target: ?Sized + 'static, Key: ?Sized + 'static> CapabilityTable<Target, Key> {
    pub(crate) fn get_mut<'a>(&self, element: &'a mut dyn Any) -> Option<&'a mut Target> {
        self.adapter.get_mut(element)
    }
}

trait CapabilityAdapter<Target: ?Sized + 'static>: Send + Sync {
    fn get_mut<'a>(&self, element: &'a mut dyn Any) -> Option<&'a mut Target>;
}

struct BoundAdapter<Element: 'static, Target: ?Sized + 'static> {
    project: for<'a> fn(&'a mut Element) -> &'a mut Target,
    marker: PhantomData<fn(&mut Element) -> &mut Target>,
}

impl<Element: 'static, Target: ?Sized + 'static> CapabilityAdapter<Target>
    for BoundAdapter<Element, Target>
{
    fn get_mut<'a>(&self, element: &'a mut dyn Any) -> Option<&'a mut Target> {
        let element = element.downcast_mut::<Element>()?;
        Some((self.project)(element))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::IntoElement;

    trait Value {
        fn value(&mut self) -> &mut String;
    }

    struct Left(String);
    struct Right(String);
    struct Pair {
        left: Left,
        right: Right,
    }
    impl Value for Left {
        fn value(&mut self) -> &mut String {
            &mut self.0
        }
    }
    impl Value for Right {
        fn value(&mut self) -> &mut String {
            &mut self.0
        }
    }

    struct Primary;
    struct Secondary;

    #[test]
    fn adapters_downcast_exact_targets_and_return_borrowed_dyn_views() {
        let common = Capability::<dyn Value>::new("Value");
        let left = common.bind::<Left>(|left| left);
        let right = common.bind::<Right>(|right| right);
        let left_table = left
            .methods
            .unwrap()
            .downcast::<CapabilityTable<dyn Value, dyn Value>>()
            .unwrap();
        let right_table = right
            .methods
            .unwrap()
            .downcast::<CapabilityTable<dyn Value, dyn Value>>()
            .unwrap();

        let mut value = Left("before".into());
        left_table
            .get_mut(&mut value)
            .unwrap()
            .value()
            .push_str(" left");
        assert!(right_table.get_mut(&mut value).is_none());
        assert_eq!(value.0, "before left");

        let mut value = Right("before".into());
        right_table
            .get_mut(&mut value)
            .unwrap()
            .value()
            .push_str(" right");
        assert_eq!(value.0, "before right");
    }

    #[test]
    fn keys_distinguish_same_trait_views_and_queries_can_be_interleaved() {
        let primary = Capability::<dyn Value, Primary>::new("PrimaryValue");
        let secondary = Capability::<dyn Value, Secondary>::new("SecondaryValue");
        assert_ne!(primary.reflected_trait(), secondary.reflected_trait());

        let primary = primary.bind::<Pair>(|pair| &mut pair.left);
        let secondary = secondary.bind::<Pair>(|pair| &mut pair.right);
        let primary = primary
            .methods
            .unwrap()
            .downcast::<CapabilityTable<dyn Value, Primary>>()
            .unwrap();
        let secondary = secondary
            .methods
            .unwrap()
            .downcast::<CapabilityTable<dyn Value, Secondary>>()
            .unwrap();
        let mut pair = Pair {
            left: Left("a".into()),
            right: Right("b".into()),
        };

        primary.get_mut(&mut pair).unwrap().value().push('1');
        secondary.get_mut(&mut pair).unwrap().value().push('2');
        primary.get_mut(&mut pair).unwrap().value().push('3');
        assert_eq!(pair.left.0, "a13");
        assert_eq!(pair.right.0, "b2");
    }

    #[test]
    fn adapter_identity_is_exact_for_target_and_key() {
        let primary = Capability::<dyn Value, Primary>::new("PrimaryValue");
        let implementation = primary.bind::<Left>(|left| left);
        let methods = implementation.methods.unwrap();
        assert!(methods.is::<CapabilityTable<dyn Value, Primary>>());
        assert!(!methods.is::<CapabilityTable<dyn Value, Secondary>>());

        let metadata =
            super::super::ElementReflection::build::<Left>(vec![primary.bind::<Left>(|left| left)]);
        assert!(metadata.satisfies(primary.requirement()));
        assert!(
            !metadata
                .satisfies(Capability::<dyn Value, Secondary>::new("SecondaryValue").requirement())
        );

        let mut wrong_table =
            Capability::<dyn Value, Secondary>::new("SecondaryValue").bind::<Left>(|left| left);
        wrong_table.descriptor = primary.reflected_trait();
        let wrong_metadata = super::super::ElementReflection::build::<Left>(vec![wrong_table]);
        assert!(!wrong_metadata.satisfies(primary.requirement()));
    }

    #[test]
    #[should_panic(expected = "duplicate callable registration")]
    fn duplicate_bindings_for_one_key_are_rejected() {
        let capability = Capability::<dyn Value, Primary>::new("PrimaryValue");
        let _ = super::super::ElementReflection::build::<Left>(vec![
            capability.bind::<Left>(|left| left),
            capability.bind::<Left>(|left| left),
        ]);
    }

    #[test]
    fn absent_capability_returns_none_from_any_element() {
        let mut element = crate::div().into_any_element();
        assert!(
            Capability::<dyn Value>::new("Value")
                .get_mut(&mut element)
                .is_none()
        );
    }
}
