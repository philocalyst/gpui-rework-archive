use super::{
    Both, BuiltinAccess, BuiltinTables, ElementReflection, GroupTableRecord, GroupTables, NoAccess,
};
use smallvec::SmallVec;
use std::{
    any::{Any, TypeId},
    marker::PhantomData,
};

/// Identifies a trait made available to element reflection.
#[derive(Clone, Copy, Debug)]
pub struct ReflectedTrait {
    /// The fully qualified name of the trait.
    pub name: &'static str,
    type_id: fn() -> TypeId,
    /// Returns this trait's directly inherited reflected traits.
    pub supertraits: fn() -> &'static [ReflectedTrait],
}

impl ReflectedTrait {
    /// Creates a descriptor for a unique trait marker.
    #[doc(hidden)]
    pub const fn new(name: &'static str, type_id: fn() -> TypeId) -> Self {
        Self {
            name,
            type_id,
            supertraits: || &[],
        }
    }

    /// Attaches inheritance emitted by the trait's reflection macro.
    #[doc(hidden)]
    pub const fn with_supertraits(
        mut self,
        supertraits: fn() -> &'static [ReflectedTrait],
    ) -> Self {
        self.supertraits = supertraits;

        self
    }

    pub(super) fn trait_type_id(&self) -> TypeId {
        (self.type_id)()
    }
}

impl PartialEq for ReflectedTrait {
    fn eq(&self, other: &Self) -> bool {
        self.trait_type_id() == other.trait_type_id()
    }
}

impl Eq for ReflectedTrait {}

/// A typed reflected trait descriptor.
#[allow(private_bounds)]
pub trait ReflectionAdapter: adapter_mode_sealed::Sealed + 'static {
    /// The exact generated method table type, if this mode permits calls.
    fn adapter_type_id() -> Option<TypeId>;
}

mod adapter_mode_sealed {
    pub trait Sealed {}
}

/// A membership-only reflection token mode.
#[doc(hidden)]
pub struct Membership;

impl adapter_mode_sealed::Sealed for Membership {}

impl ReflectionAdapter for Membership {
    fn adapter_type_id() -> Option<TypeId> {
        None
    }
}

/// A callable reflection token mode for one exact generated method table.
#[doc(hidden)]
pub struct Callable<Methods>(PhantomData<fn() -> Methods>);

impl<Methods> adapter_mode_sealed::Sealed for Callable<Methods> {}

impl<Methods: Any + Send + Sync> ReflectionAdapter for Callable<Methods> {
    fn adapter_type_id() -> Option<TypeId> {
        Some(TypeId::of::<Methods>())
    }
}

/// A typed marker for reflected membership and callable capabilities.
pub trait ReflectionToken: Copy + 'static {
    /// The group for this token alone.
    type Group: ReflectionGroup;
    /// Builtin capabilities exposed by this token, including its reflected parents.
    type Access: BuiltinAccess;
    /// Whether this token checks membership only or requires its exact callable table.
    type Adapter: ReflectionAdapter;
    /// The erased runtime descriptor for this trait.
    fn reflected_trait(self) -> ReflectedTrait;

    /// Returns the membership and adapter requirements for this token.
    fn requirement(self) -> ReflectionRequirement {
        ReflectionRequirement::for_adapter::<Self::Adapter>(self.reflected_trait())
    }

    /// Requirements for this token and its callable parents.
    fn requirements(self) -> Vec<ReflectionRequirement> {
        vec![self.requirement()]
    }

    /// Appends this token's requirements without forcing generated tokens to allocate.
    #[doc(hidden)]
    fn append_requirements(self, requirements: &mut ReflectionRequirements) {
        for requirement in self.requirements() {
            if !requirements.contains(&requirement) {
                requirements.push(requirement);
            }
        }
    }
}

/// Inline storage used while assembling reflected trait requirements.
#[doc(hidden)]
pub type ReflectionRequirements = SmallVec<[ReflectionRequirement; 2]>;

/// A token whose generated method table permits calls on an erased element.
pub trait CallableReflectionToken: ReflectionToken<Adapter = Callable<Self::Methods>> {
    /// The trait's generated method table.
    type Methods: Any + Send + Sync;
}

/// A trait membership check, optionally requiring a compatible callable table.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ReflectionRequirement {
    /// The trait whose membership is required.
    pub descriptor: ReflectedTrait,
    pub(super) adapter_type: Option<TypeId>,
}

impl ReflectionRequirement {
    fn for_adapter<Adapter: ReflectionAdapter>(descriptor: ReflectedTrait) -> Self {
        let adapter_type = Adapter::adapter_type_id();

        Self {
            descriptor,
            adapter_type,
        }
    }

    /// Returns whether this requirement also checks the exact callable method table.
    pub fn is_callable(&self) -> bool {
        self.adapter_type.is_some()
    }

    /// Requires membership only.
    pub fn membership(descriptor: ReflectedTrait) -> Self {
        descriptor.requirement()
    }

    /// Requires membership and the token's exact method table.
    pub fn callable<Token: CallableReflectionToken>(token: Token) -> Self {
        Self::for_adapter::<Callable<Token::Methods>>(token.reflected_trait())
    }
}

impl ReflectionToken for ReflectedTrait {
    type Group = ErasedReflectionGroup;
    type Access = NoAccess;
    type Adapter = Membership;

    fn reflected_trait(self) -> ReflectedTrait {
        self
    }

    fn append_requirements(self, requirements: &mut ReflectionRequirements) {
        let requirement = self.requirement();
        if !requirements.contains(&requirement) {
            requirements.push(requirement);
        }
    }
}

/// The group for membership-only tokens and erased descriptors.
#[doc(hidden)]
pub struct ErasedReflectionGroup;

impl ReflectionGroup for ErasedReflectionGroup {
    type Access = NoAccess;
    type Tables = GroupTables<(), BuiltinTables<NoAccess>>;

    fn bind_tables(metadata: &'static ElementReflection) -> Option<Self::Tables> {
        Some(GroupTables {
            callables: (),
            builtins: NoAccess::bind_tables(metadata)?,
        })
    }
}

/// A generated set of reflected traits.
#[doc(hidden)]
pub trait ReflectionGroup: 'static {
    /// Builtin capabilities exposed by this group.
    type Access: BuiltinAccess;

    /// Native, typed method tables bound against one immutable metadata instance.
    type Tables: GroupTableRecord<Builtins = BuiltinTables<Self::Access>> + 'static;

    /// Checks and resolves this group's complete set of native method tables.
    fn bind_tables(metadata: &'static ElementReflection) -> Option<Self::Tables>;
}

/// Runtime requirements for a generated trait group.
#[doc(hidden)]
pub struct ReflectedTraitGroup<Group>
where
    Group: ReflectionGroup,
{
    requirements: SmallVec<[ReflectionRequirement; 2]>,
    group: PhantomData<fn() -> Group>,
}

impl<Group> ReflectedTraitGroup<Group>
where
    Group: ReflectionGroup,
{
    /// Creates a reflected trait group from its runtime descriptors.
    #[doc(hidden)]
    pub fn new(traits: impl IntoIterator<Item = ReflectedTrait>) -> Self {
        Self::with_requirements(traits.into_iter().map(ReflectionRequirement::membership))
    }

    /// Creates a group with membership and adapter requirements.
    #[doc(hidden)]
    pub fn with_requirements(
        requirements: impl IntoIterator<Item = ReflectionRequirement>,
    ) -> Self {
        let mut registered = SmallVec::new();

        for requirement in requirements {
            if !registered.contains(&requirement) {
                registered.push(requirement);
            }
        }

        Self {
            requirements: registered,
            group: PhantomData,
        }
    }
}

/// Supplies a trait group's runtime requirements.
#[doc(hidden)]
pub trait ReflectedTraits {
    /// The type that records group membership.
    type Group: ReflectionGroup;

    /// Returns the erased runtime descriptors in this trait set.
    fn reflected_traits(self) -> SmallVec<[ReflectedTrait; 2]>
    where
        Self: Sized,
    {
        self.reflected_requirements()
            .into_iter()
            .map(|requirement| requirement.descriptor)
            .collect()
    }

    /// Returns each trait's membership and adapter requirements.
    fn reflected_requirements(self) -> SmallVec<[ReflectionRequirement; 2]>;

    /// Appends requirements directly into an existing inline buffer.
    fn append_requirements(self, requirements: &mut ReflectionRequirements)
    where
        Self: Sized,
    {
        for requirement in self.reflected_requirements() {
            if !requirements.contains(&requirement) {
                requirements.push(requirement);
            }
        }
    }
}

impl<Token> ReflectedTraits for Token
where
    Token: ReflectionToken,
    Token::Group: ReflectionGroup,
{
    type Group = Token::Group;

    fn reflected_requirements(self) -> SmallVec<[ReflectionRequirement; 2]> {
        let mut requirements = ReflectionRequirements::new();
        ReflectionToken::append_requirements(self, &mut requirements);
        requirements
    }

    fn append_requirements(self, requirements: &mut ReflectionRequirements) {
        ReflectionToken::append_requirements(self, requirements);
    }
}

macro_rules! impl_reflected_traits_tuple {
    ($($Token:ident:$index:tt),+ => $group:ty) => {
        impl<$($Token),+> ReflectedTraits for ($($Token,)+)
        where
            $($Token: ReflectedTraits,)+
        {
            type Group = $group;

            fn reflected_requirements(self) -> SmallVec<[ReflectionRequirement; 2]> {
                let mut requirements = ReflectionRequirements::new();
                ReflectedTraits::append_requirements(self, &mut requirements);
                requirements
            }

            fn append_requirements(self, requirements: &mut ReflectionRequirements) {
                $(ReflectedTraits::append_requirements(self.$index, requirements);)+
            }
        }
    };
}

impl_reflected_traits_tuple!(A:0, B:1 => Both<<A as ReflectedTraits>::Group, <B as ReflectedTraits>::Group>);
impl_reflected_traits_tuple!(A:0, B:1, C:2 => Both<Both<<A as ReflectedTraits>::Group, <B as ReflectedTraits>::Group>, <C as ReflectedTraits>::Group>);
impl_reflected_traits_tuple!(A:0, B:1, C:2, D:3 => Both<Both<Both<<A as ReflectedTraits>::Group, <B as ReflectedTraits>::Group>, <C as ReflectedTraits>::Group>, <D as ReflectedTraits>::Group>);
impl_reflected_traits_tuple!(A:0, B:1, C:2, D:3, E:4 => Both<Both<Both<Both<<A as ReflectedTraits>::Group, <B as ReflectedTraits>::Group>, <C as ReflectedTraits>::Group>, <D as ReflectedTraits>::Group>, <E as ReflectedTraits>::Group>);
impl_reflected_traits_tuple!(A:0, B:1, C:2, D:3, E:4, F:5 => Both<Both<Both<Both<Both<<A as ReflectedTraits>::Group, <B as ReflectedTraits>::Group>, <C as ReflectedTraits>::Group>, <D as ReflectedTraits>::Group>, <E as ReflectedTraits>::Group>, <F as ReflectedTraits>::Group>);
impl_reflected_traits_tuple!(A:0, B:1, C:2, D:3, E:4, F:5, G:6 => Both<Both<Both<Both<Both<Both<<A as ReflectedTraits>::Group, <B as ReflectedTraits>::Group>, <C as ReflectedTraits>::Group>, <D as ReflectedTraits>::Group>, <E as ReflectedTraits>::Group>, <F as ReflectedTraits>::Group>, <G as ReflectedTraits>::Group>);
impl_reflected_traits_tuple!(A:0, B:1, C:2, D:3, E:4, F:5, G:6, H:7 => Both<Both<Both<Both<Both<Both<Both<<A as ReflectedTraits>::Group, <B as ReflectedTraits>::Group>, <C as ReflectedTraits>::Group>, <D as ReflectedTraits>::Group>, <E as ReflectedTraits>::Group>, <F as ReflectedTraits>::Group>, <G as ReflectedTraits>::Group>, <H as ReflectedTraits>::Group>);

impl<Group> ReflectedTraits for ReflectedTraitGroup<Group>
where
    Group: ReflectionGroup,
{
    type Group = Group;

    fn reflected_requirements(self) -> SmallVec<[ReflectionRequirement; 2]> {
        self.requirements
    }

    fn append_requirements(self, requirements: &mut ReflectionRequirements) {
        for requirement in self.requirements {
            if !requirements.contains(&requirement) {
                requirements.push(requirement);
            }
        }
    }
}
