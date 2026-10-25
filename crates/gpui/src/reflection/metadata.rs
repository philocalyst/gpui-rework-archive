use super::{CallableReflectionToken, ReflectedTrait, ReflectionRequirement, ReflectionToken};
use collections::TypeIdHashMap;
use parking_lot::RwLock;
use std::{
    any::{Any, TypeId},
    cell::RefCell,
    marker::PhantomData,
    sync::LazyLock,
};

/// Supplies concrete registrations through `build_reflection`.
/// Handwritten and generic providers must forward [`crate::Element::reflection`] to `Reflect::reflection`.
///
/// Registrations belong to `Self`. Deriving this trait on a [`crate::RenderOnce`]
/// component does not reflect its [`crate::ViewElement`] wrapper or rendered root.
/// For callable component traits after erasure, implement and reflect those traits
/// on the concrete [`crate::Element`] that survives conversion.
pub trait Reflect: Sized + 'static {
    /// Builds deterministic registrations without retaining element instances or callback state.
    fn build_reflection() -> Vec<ReflectedImplementation<Self>>;

    /// Returns the process-owned metadata for this concrete type.
    fn reflection() -> &'static ElementReflection {
        metadata_for::<Self>(Self::build_reflection)
    }

    /// Returns the reflected traits implemented by this concrete type.
    fn reflected_traits() -> Vec<ReflectedTrait> {
        Self::reflection().descriptors().to_vec()
    }
}

/// A concrete implementation of a reflected trait.
pub struct ReflectedImplementation<Receiver: 'static> {
    /// The identity and inheritance of the implemented trait.
    pub descriptor: ReflectedTrait,
    /// Generated forwarding functions, or `None` for membership alone.
    pub methods: Option<Box<dyn Any + Send + Sync>>,
    #[allow(dead_code)]
    receiver: PhantomData<fn(Receiver) -> Receiver>,
}

impl<Receiver: 'static> ReflectedImplementation<Receiver> {
    /// Creates a typed registration for macro-generated reflection metadata.
    ///
    /// The receiver parameter ties the generated table to the concrete element type.
    #[doc(hidden)]
    pub fn __new(descriptor: ReflectedTrait, methods: Option<Box<dyn Any + Send + Sync>>) -> Self {
        Self {
            descriptor,
            methods,
            receiver: PhantomData,
        }
    }
}

/// Immutable reflection metadata retained by erased elements for process lifetime.
pub struct ElementReflection {
    concrete_type: Option<TypeId>,
    descriptors: Vec<ReflectedTrait>,
    methods: TypeIdHashMap<Box<dyn Any + Send + Sync>>,
}

impl ElementReflection {
    pub(super) fn build<Receiver: 'static>(
        implementations: Vec<ReflectedImplementation<Receiver>>,
    ) -> Self {
        let concrete_type = TypeId::of::<Receiver>();
        let mut reflection = Self {
            concrete_type: Some(concrete_type),
            descriptors: Vec::new(),
            methods: TypeIdHashMap::default(),
        };

        for implementation in implementations {
            let trait_id = implementation.descriptor.trait_type_id();

            if !reflection.descriptors.contains(&implementation.descriptor) {
                reflection.descriptors.push(implementation.descriptor);
            }

            let Some(methods) = implementation.methods else {
                continue;
            };

            assert!(
                !reflection.methods.contains_key(&trait_id),
                "duplicate callable registration for {} on {concrete_type:?}",
                implementation.descriptor.name,
            );

            reflection.methods.insert(trait_id, methods);
        }

        reflection
    }

    /// The concrete receiver identity, or `None` for shared unreflected metadata.
    pub fn concrete_type(&self) -> Option<TypeId> {
        self.concrete_type
    }

    /// Returns registered trait membership, including traits without adapters.
    pub fn descriptors(&self) -> &[ReflectedTrait] {
        &self.descriptors
    }

    /// Checks membership and any adapter requirement supplied by a token.
    pub fn implements_trait<Token: ReflectionToken>(&self, token: Token) -> bool {
        self.satisfies(token.requirement())
    }

    /// Checks membership and the required method table before granting callable access.
    pub fn satisfies(&self, requirement: ReflectionRequirement) -> bool {
        if !self.descriptors.contains(&requirement.descriptor) {
            return false;
        }

        let Some(expected) = requirement.adapter_type else {
            return true;
        };

        self.methods
            .get(&requirement.descriptor.trait_type_id())
            .is_some_and(|methods| methods.as_ref().type_id() == expected)
    }

    /// Returns whether the exact generated table for a callable token is available.
    pub fn has_adapter<Token: CallableReflectionToken>(&self, token: Token) -> bool {
        self.satisfies(ReflectionRequirement::callable(token))
    }

    pub(crate) fn method_table<Methods: Any>(
        &'static self,
        descriptor: ReflectedTrait,
    ) -> Option<&'static Methods> {
        self.methods
            .get(&descriptor.trait_type_id())
            .and_then(|methods| methods.downcast_ref())
    }

    /// Resolves the exact typed table attached to a callable token.
    #[doc(hidden)]
    pub fn resolve<Token: CallableReflectionToken>(
        &'static self,
        token: Token,
    ) -> Option<&'static Token::Methods> {
        self.method_table(token.reflected_trait())
    }

    #[cfg(feature = "bench-support")]
    pub(super) fn methods_for<Token: CallableReflectionToken>(
        &'static self,
        token: Token,
    ) -> &'static Token::Methods {
        let descriptor = token.reflected_trait();

        self.method_table(descriptor).unwrap_or_else(|| {
            panic!(
                "element {:?} has no method table for {}",
                self.concrete_type, descriptor.name
            )
        })
    }

    pub(crate) fn validate_receiver(&self, expected: TypeId) {
        if let Some(actual) = self.concrete_type {
            assert_eq!(
                actual, expected,
                "reflection metadata targets a different concrete receiver"
            );
        }
    }
}

/// A statically linked metadata factory emitted for a monomorphic derive.
#[doc(hidden)]
pub struct ReflectionRegistration {
    /// Returns the registered concrete type's identity.
    pub type_id: fn() -> TypeId,
    /// Initializes that type's metadata on demand.
    pub reflection: fn() -> &'static ElementReflection,
}

inventory::collect!(ReflectionRegistration);

type ReflectionFactory = fn() -> &'static ElementReflection;

static LINKED_REFLECTIONS: LazyLock<TypeIdHashMap<ReflectionFactory>> = LazyLock::new(|| {
    let mut factories = TypeIdHashMap::default();

    for registration in inventory::iter::<ReflectionRegistration> {
        let type_id = (registration.type_id)();
        assert!(
            factories.insert(type_id, registration.reflection).is_none(),
            "duplicate reflection factories for {type_id:?}",
        );
    }

    factories
});

static REFLECTIONS: LazyLock<RwLock<TypeIdHashMap<&'static ElementReflection>>> =
    LazyLock::new(|| RwLock::new(TypeIdHashMap::default()));

static EMPTY_REFLECTION: LazyLock<ElementReflection> = LazyLock::new(|| ElementReflection {
    concrete_type: None,
    descriptors: Vec::new(),
    methods: TypeIdHashMap::default(),
});

thread_local! {
    pub(super) static INITIALIZING: RefCell<Vec<TypeId>> = const { RefCell::new(Vec::new()) };
}

struct InitializationGuard(TypeId);

impl InitializationGuard {
    fn enter(type_id: TypeId) -> Self {
        INITIALIZING.with(|stack| {
            let mut stack = stack.borrow_mut();
            assert!(
                !stack.contains(&type_id),
                "recursive reflection initialization for {type_id:?}"
            );
            stack.push(type_id);
        });

        Self(type_id)
    }
}

impl Drop for InitializationGuard {
    fn drop(&mut self) {
        INITIALIZING.with(|stack| {
            let completed = stack.borrow_mut().pop();

            debug_assert_eq!(completed, Some(self.0));
        });
    }
}

/// Initializes a concrete registration outside the cache lock and retains one immutable winner.
#[doc(hidden)]
pub fn metadata_for<Type: 'static>(
    build: fn() -> Vec<ReflectedImplementation<Type>>,
) -> &'static ElementReflection {
    let type_id = TypeId::of::<Type>();

    if let Some(reflection) = REFLECTIONS.read().get(&type_id).copied() {
        return reflection;
    }

    let _initialization = InitializationGuard::enter(type_id);
    let candidate = Box::new(ElementReflection::build::<Type>(build()));
    let mut cache = REFLECTIONS.write();

    if let Some(reflection) = cache.get(&type_id).copied() {
        drop(cache);
        drop(candidate);

        return reflection;
    }

    let reflection = Box::leak(candidate);
    cache.insert(type_id, reflection);

    reflection
}

/// Resolves only statically linked metadata for the default `Element::reflection` path.
/// Generic providers opt in by forwarding `Element::reflection` to `Reflect::reflection`.
/// Ordinary unreflected types share an empty entry and never touch the demand cache.
#[doc(hidden)]
pub fn linked_metadata_for<Type: 'static>() -> &'static ElementReflection {
    linked_metadata_for_type(TypeId::of::<Type>())
}

fn linked_metadata_for_type(type_id: TypeId) -> &'static ElementReflection {
    let Some(factory) = LINKED_REFLECTIONS.get(&type_id) else {
        return &EMPTY_REFLECTION;
    };

    let reflection = factory();
    reflection.validate_receiver(type_id);
    assert_eq!(
        reflection.concrete_type(),
        Some(type_id),
        "linked reflection factory returned empty metadata"
    );

    reflection
}

pub(super) fn linked_metadata(type_id: TypeId) -> &'static ElementReflection {
    if let Some(reflection) = REFLECTIONS.read().get(&type_id).copied() {
        return reflection;
    }

    linked_metadata_for_type(type_id)
}

/// Returns descriptors from linked metadata or an already initialized generic provider.
/// Generic registrations become visible after their metadata has been requested.
#[doc(hidden)]
pub fn registered_traits(type_id: TypeId) -> &'static [ReflectedTrait] {
    linked_metadata(type_id).descriptors()
}
