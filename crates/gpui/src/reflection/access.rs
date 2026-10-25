use super::{CallableReflectionToken, ElementReflection, ReflectionGroup, ReflectionToken};
use std::marker::PhantomData;

/// A type-level flag used by builtin reflected access.
#[doc(hidden)]
pub struct Off;

/// A type-level flag used by builtin reflected access.
#[doc(hidden)]
pub struct On;

/// Type-level builtin capability flags carried by reflected tokens and groups.
#[doc(hidden)]
pub struct Access<Styled, Interactive, Stateful, Parent>(
    PhantomData<fn() -> (Styled, Interactive, Stateful, Parent)>,
);

/// One flag in the builtin access lattice.
#[doc(hidden)]
pub trait AccessFlag: 'static {
    /// Type-level OR with another flag.
    type Or<Right: AccessFlag>: AccessFlag;

    /// Storage for a builtin table that is present under this flag.
    type Slot<Token: CallableReflectionToken>: Copy + 'static;

    /// Resolves the exact builtin table when present, or produces unit when absent.
    fn bind<Token: CallableReflectionToken>(
        metadata: &'static ElementReflection,
        token: Token,
    ) -> Option<Self::Slot<Token>>;

    /// Merges slots from two groups without repeating metadata lookup.
    fn merge<Token, Right>(
        left: Self::Slot<Token>,
        right: Right::Slot<Token>,
    ) -> <Self::Or<Right> as AccessFlag>::Slot<Token>
    where
        Token: CallableReflectionToken,
        Right: AccessFlag;
}

impl AccessFlag for Off {
    type Or<Right: AccessFlag> = Right;
    type Slot<Token: CallableReflectionToken> = ();

    fn bind<Token: CallableReflectionToken>(
        _metadata: &'static ElementReflection,
        _token: Token,
    ) -> Option<Self::Slot<Token>> {
        Some(())
    }

    fn merge<Token, Right>(
        _left: Self::Slot<Token>,
        right: Right::Slot<Token>,
    ) -> <Self::Or<Right> as AccessFlag>::Slot<Token>
    where
        Token: CallableReflectionToken,
        Right: AccessFlag,
    {
        right
    }
}

impl AccessFlag for On {
    type Or<Right: AccessFlag> = On;
    type Slot<Token: CallableReflectionToken> = &'static Token::Methods;

    fn bind<Token: CallableReflectionToken>(
        metadata: &'static ElementReflection,
        token: Token,
    ) -> Option<Self::Slot<Token>> {
        metadata.resolve(token)
    }

    fn merge<Token, Right>(
        left: Self::Slot<Token>,
        _right: Right::Slot<Token>,
    ) -> <Self::Or<Right> as AccessFlag>::Slot<Token>
    where
        Token: CallableReflectionToken,
        Right: AccessFlag,
    {
        left
    }
}

/// Marker bound for valid builtin access flag sets.
#[doc(hidden)]
pub trait BuiltinAccess: Sized + 'static {
    /// Whether `Styled` is available.
    type Styled: AccessFlag;
    /// Whether `InteractiveElement` is available.
    type Interactive: AccessFlag;
    /// Whether `StatefulInteractiveElement` is available.
    type Stateful: AccessFlag;
    /// Whether `ParentElement` is available.
    type Parent: AccessFlag;

    /// Binds the builtin tables represented by this access set.
    fn bind_tables(metadata: &'static ElementReflection) -> Option<BuiltinTables<Self>>;
}

impl<Styled, Interactive, Stateful, Parent> BuiltinAccess
    for Access<Styled, Interactive, Stateful, Parent>
where
    Styled: AccessFlag,
    Interactive: AccessFlag,
    Stateful: AccessFlag,
    Parent: AccessFlag,
{
    type Styled = Styled;
    type Interactive = Interactive;
    type Stateful = Stateful;
    type Parent = Parent;
    fn bind_tables(metadata: &'static ElementReflection) -> Option<BuiltinTables<Self>> {
        Some(BuiltinTables {
            styled: Styled::bind(metadata, crate::__GpuiReflectStyled)?,
            interactive: Interactive::bind(metadata, crate::__GpuiReflectInteractiveElement)?,
            stateful: Stateful::bind(metadata, crate::__GpuiReflectStatefulInteractiveElement)?,
            parent: Parent::bind(metadata, crate::__GpuiReflectParentElement)?,
        })
    }
}

/// Builtin table references selected by a group's access flags.
#[doc(hidden)]
pub struct BuiltinTables<Access: BuiltinAccess> {
    /// `Styled` table, or unit when the flag is off.
    pub styled: <Access::Styled as AccessFlag>::Slot<crate::__GpuiReflectStyled>,
    /// `InteractiveElement` table, or unit when the flag is off.
    pub interactive:
        <Access::Interactive as AccessFlag>::Slot<crate::__GpuiReflectInteractiveElement>,
    /// `StatefulInteractiveElement` table, or unit when the flag is off.
    pub stateful:
        <Access::Stateful as AccessFlag>::Slot<crate::__GpuiReflectStatefulInteractiveElement>,
    /// `ParentElement` table, or unit when the flag is off.
    pub parent: <Access::Parent as AccessFlag>::Slot<crate::__GpuiReflectParentElement>,
}

impl<Access: BuiltinAccess> Copy for BuiltinTables<Access> {}

impl<Access: BuiltinAccess> Clone for BuiltinTables<Access> {
    fn clone(&self) -> Self {
        *self
    }
}

/// The empty set of builtin capabilities.
#[doc(hidden)]
pub type NoAccess = Access<Off, Off, Off, Off>;

/// Combines two builtin access sets.
#[doc(hidden)]
pub trait AccessUnion<Rhs: BuiltinAccess>: BuiltinAccess {
    /// The bitwise union of both access sets.
    type Output: BuiltinAccess;

    /// Combines already-bound builtin table slots from both access records.
    fn merge_tables(
        left: &BuiltinTables<Self>,
        right: &BuiltinTables<Rhs>,
    ) -> BuiltinTables<Self::Output>;
}

impl<Left, Right> AccessUnion<Right> for Left
where
    Left: BuiltinAccess,
    Right: BuiltinAccess,
{
    type Output = Access<
        <Left::Styled as AccessFlag>::Or<Right::Styled>,
        <Left::Interactive as AccessFlag>::Or<Right::Interactive>,
        <Left::Stateful as AccessFlag>::Or<Right::Stateful>,
        <Left::Parent as AccessFlag>::Or<Right::Parent>,
    >;

    fn merge_tables(
        left: &BuiltinTables<Self>,
        right: &BuiltinTables<Right>,
    ) -> BuiltinTables<Self::Output> {
        BuiltinTables {
            styled: <Left::Styled as AccessFlag>::merge::<crate::__GpuiReflectStyled, Right::Styled>(
                left.styled,
                right.styled,
            ),
            interactive: <Left::Interactive as AccessFlag>::merge::<
                crate::__GpuiReflectInteractiveElement,
                Right::Interactive,
            >(left.interactive, right.interactive),
            stateful: <Left::Stateful as AccessFlag>::merge::<
                crate::__GpuiReflectStatefulInteractiveElement,
                Right::Stateful,
            >(left.stateful, right.stateful),
            parent: <Left::Parent as AccessFlag>::merge::<
                crate::__GpuiReflectParentElement,
                Right::Parent,
            >(left.parent, right.parent),
        }
    }
}

/// Implemented by groups that expose the builtin `Styled` capability.
pub trait HasStyled: BuiltinAccess<Styled = On> {
    /// Returns the exact builtin `Styled` table carried by this access record.
    fn styled(
        tables: &BuiltinTables<Self>,
    ) -> &'static <crate::__GpuiReflectStyled as CallableReflectionToken>::Methods;
}
impl<I: AccessFlag, T: AccessFlag, P: AccessFlag> HasStyled for Access<On, I, T, P> {
    fn styled(
        tables: &BuiltinTables<Self>,
    ) -> &'static <crate::__GpuiReflectStyled as CallableReflectionToken>::Methods {
        tables.styled
    }
}

/// Implemented by groups that expose the builtin `InteractiveElement` capability.
pub trait HasInteractive: BuiltinAccess<Interactive = On> {
    /// Returns the exact builtin `InteractiveElement` table carried by this access record.
    fn interactive(
        tables: &BuiltinTables<Self>,
    ) -> &'static <crate::__GpuiReflectInteractiveElement as CallableReflectionToken>::Methods;
}
impl<S: AccessFlag, T: AccessFlag, P: AccessFlag> HasInteractive for Access<S, On, T, P> {
    fn interactive(
        tables: &BuiltinTables<Self>,
    ) -> &'static <crate::__GpuiReflectInteractiveElement as CallableReflectionToken>::Methods {
        tables.interactive
    }
}

/// Implemented by groups that expose the builtin `StatefulInteractiveElement` capability.
pub trait HasStateful: BuiltinAccess<Stateful = On> {
    /// Returns the exact builtin `StatefulInteractiveElement` table carried by this access record.
    fn stateful(
        tables: &BuiltinTables<Self>,
    ) -> &'static <crate::__GpuiReflectStatefulInteractiveElement as CallableReflectionToken>::Methods;
}
impl<S: AccessFlag, I: AccessFlag, P: AccessFlag> HasStateful for Access<S, I, On, P> {
    fn stateful(
        tables: &BuiltinTables<Self>,
    ) -> &'static <crate::__GpuiReflectStatefulInteractiveElement as CallableReflectionToken>::Methods
    {
        tables.stateful
    }
}

/// Implemented by groups that expose the builtin `ParentElement` capability.
pub trait HasParent: BuiltinAccess<Parent = On> {
    /// Returns the exact builtin `ParentElement` table carried by this access record.
    fn parent(
        tables: &BuiltinTables<Self>,
    ) -> &'static <crate::__GpuiReflectParentElement as CallableReflectionToken>::Methods;
}
impl<S: AccessFlag, I: AccessFlag, T: AccessFlag> HasParent for Access<S, I, T, On> {
    fn parent(
        tables: &BuiltinTables<Self>,
    ) -> &'static <crate::__GpuiReflectParentElement as CallableReflectionToken>::Methods {
        tables.parent
    }
}

/// A group containing the union of two reflected requirement groups.
#[doc(hidden)]
pub struct Both<Left, Right>(PhantomData<fn() -> (Left, Right)>);

/// The native table record for one reflection group.
#[doc(hidden)]
pub struct GroupTables<Callables, Builtins> {
    /// Callable method tables generated for the group's custom traits.
    pub callables: Callables,
    /// Builtin tables selected from the group's access flags.
    pub builtins: Builtins,
}

/// Projects the callable portion of a native group table record.
#[doc(hidden)]
pub trait GroupTableRecord: Copy + 'static {
    /// The group-specific custom callable table record.
    type Callables: Copy + 'static;

    /// The builtin tables already resolved for this group.
    type Builtins: Copy + 'static;

    /// Returns the callable portion of this record.
    fn callables(&self) -> &Self::Callables;

    /// Returns the builtin table portion of this record.
    fn builtins(&self) -> &Self::Builtins;
}

impl<Callables: Copy, Builtins: Copy> Copy for GroupTables<Callables, Builtins> {}

impl<Callables: Copy, Builtins: Copy> Clone for GroupTables<Callables, Builtins> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<Callables: Copy + 'static, Builtins: Copy + 'static> GroupTableRecord
    for GroupTables<Callables, Builtins>
{
    type Callables = Callables;
    type Builtins = Builtins;

    fn callables(&self) -> &Self::Callables {
        &self.callables
    }

    fn builtins(&self) -> &Self::Builtins {
        &self.builtins
    }
}

impl<Left, Right> ReflectionGroup for Both<Left, Right>
where
    Left: ReflectionGroup,
    Right: ReflectionGroup,
    Left::Tables: GroupTableRecord<Builtins = BuiltinTables<Left::Access>>,
    Right::Tables: GroupTableRecord<Builtins = BuiltinTables<Right::Access>>,
{
    type Access = <Left::Access as AccessUnion<Right::Access>>::Output;
    type Tables = GroupTables<(Left::Tables, Right::Tables), BuiltinTables<Self::Access>>;

    fn bind_tables(metadata: &'static ElementReflection) -> Option<Self::Tables> {
        let left = Left::bind_tables(metadata)?;
        let right = Right::bind_tables(metadata)?;
        let builtins = <Left::Access as AccessUnion<Right::Access>>::merge_tables(
            GroupTableRecord::builtins(&left),
            GroupTableRecord::builtins(&right),
        );
        Some(GroupTables {
            callables: (left, right),
            builtins,
        })
    }
}

/// Proves group membership for a trait.
#[doc(hidden)]
pub trait IncludesReflectedTrait<Token>: ReflectionGroup
where
    Token: ReflectionToken,
{
}

/// Proves callable access to a trait.
pub trait IncludesCallableTrait<Token>: IncludesReflectedTrait<Token>
where
    Token: CallableReflectionToken,
{
    /// Returns this group's already-bound native method table for `Token`.
    fn methods(tables: &Self::Tables) -> &'static Token::Methods;
}

/// The root index for a callable token contained in a group.
#[doc(hidden)]
pub struct Here;

/// A callable proof found in the left side of a composed group.
#[doc(hidden)]
pub struct Left<Index>(PhantomData<fn() -> Index>);

/// A callable proof found in the right side of a composed group.
#[doc(hidden)]
pub struct Right<Index>(PhantomData<fn() -> Index>);

/// An indexed proof that a group exposes a callable token.
#[doc(hidden)]
pub trait ContainsCallable<Token, Index>: ReflectionGroup
where
    Token: CallableReflectionToken,
{
    /// Returns the indexed native method table for `Token`.
    fn methods(tables: &Self::Tables) -> &'static Token::Methods;
}

impl<Group, Token> ContainsCallable<Token, Here> for Group
where
    Group: ReflectionGroup + IncludesCallableTrait<Token>,
    Token: CallableReflectionToken,
{
    fn methods(tables: &Self::Tables) -> &'static Token::Methods {
        Group::methods(tables)
    }
}

impl<LeftGroup, RightGroup, Token, Index> ContainsCallable<Token, Left<Index>>
    for Both<LeftGroup, RightGroup>
where
    LeftGroup: ReflectionGroup + ContainsCallable<Token, Index>,
    RightGroup: ReflectionGroup,
    Token: CallableReflectionToken,
{
    fn methods(tables: &Self::Tables) -> &'static Token::Methods {
        <LeftGroup as ContainsCallable<Token, Index>>::methods(
            &GroupTableRecord::callables(tables).0,
        )
    }
}

impl<LeftGroup, RightGroup, Token, Index> ContainsCallable<Token, Right<Index>>
    for Both<LeftGroup, RightGroup>
where
    LeftGroup: ReflectionGroup,
    RightGroup: ReflectionGroup + ContainsCallable<Token, Index>,
    Token: CallableReflectionToken,
{
    fn methods(tables: &Self::Tables) -> &'static Token::Methods {
        <RightGroup as ContainsCallable<Token, Index>>::methods(
            &GroupTableRecord::callables(tables).1,
        )
    }
}
