//! Indexed membership proofs and a builtin access-flag lattice.
use std::marker::PhantomData;

pub struct Here;
pub struct Left<I>(PhantomData<I>);
pub struct Right<I>(PhantomData<I>);
pub struct Leaf<T>(PhantomData<T>);
pub struct Both<A, B>(PhantomData<fn() -> (A, B)>);

pub trait Contains<T, Index> {}
impl<T> Contains<T, Here> for Leaf<T> {}
impl<A, B, T, I> Contains<T, Left<I>> for Both<A, B> where A: Contains<T, I> {}
impl<A, B, T, I> Contains<T, Right<I>> for Both<A, B> where B: Contains<T, I> {}

pub struct Off;
pub struct On;
pub struct Empty;

pub trait Or<Rhs> {
    type Output;
}
impl Or<Off> for Off {
    type Output = Off;
}
impl Or<On> for Off {
    type Output = On;
}
impl Or<Off> for On {
    type Output = On;
}
impl Or<On> for On {
    type Output = On;
}

pub struct Access<Styled, Interactive, Parent>(PhantomData<fn() -> (Styled, Interactive, Parent)>);
pub trait Union<Rhs> {
    type Output;
}
impl<S, I, P, S2, I2, P2> Union<Access<S2, I2, P2>> for Access<S, I, P>
where
    S: Or<S2>,
    I: Or<I2>,
    P: Or<P2>,
{
    type Output = Access<S::Output, I::Output, P::Output>;
}

pub trait HasStyled {}
impl<I, P> HasStyled for Access<On, I, P> {}
pub trait HasInteractive {}
impl<S, P> HasInteractive for Access<S, On, P> {}
pub trait HasParent {}
impl<S, I> HasParent for Access<S, I, On> {}

pub trait Token {
    type Members;
    type LocalAccess;
}

pub trait MemberTree {
    type Access;
}
impl MemberTree for Empty {
    type Access = Access<Off, Off, Off>;
}
impl<T: Token> MemberTree for Leaf<T> {
    type Access = T::LocalAccess;
}
impl<A, B> MemberTree for Both<A, B>
where
    A: MemberTree,
    B: MemberTree,
    A::Access: Union<B::Access>,
{
    type Access = <A::Access as Union<B::Access>>::Output;
}

pub struct StyledToken;
impl Token for StyledToken {
    type Members = Leaf<Self>;
    type LocalAccess = Access<On, Off, Off>;
}
pub struct InteractiveToken;
impl Token for InteractiveToken {
    // Demonstrate a token whose reflected parents are included in the proof.
    type Members = Both<Leaf<Self>, Leaf<StyledToken>>;
    type LocalAccess = Access<Off, On, Off>;
}
pub struct ParentToken;
impl Token for ParentToken {
    type Members = Leaf<Self>;
    type LocalAccess = Access<Off, Off, On>;
}
pub struct SharedToken;
impl Token for SharedToken {
    type Members = Leaf<Self>;
    type LocalAccess = Access<Off, Off, Off>;
}
pub struct LeftCapability;
impl Token for LeftCapability {
    type Members = Both<Leaf<Self>, Leaf<SharedToken>>;
    type LocalAccess = Access<Off, Off, Off>;
}
pub struct RightCapability;
impl Token for RightCapability {
    type Members = Both<Leaf<Self>, Leaf<SharedToken>>;
    type LocalAccess = Access<Off, Off, Off>;
}
pub struct CustomToken;
impl Token for CustomToken {
    type Members = Leaf<Self>;
    type LocalAccess = Access<Off, Off, Off>;
}

pub struct Group<Members>(PhantomData<fn() -> Members>);
pub type EmptyGroup = Group<Empty>;

pub trait Extend<T: Token> {
    type Output;
}
impl<M, T> Extend<T> for Group<M>
where
    M: MemberTree,
    T: Token,
    M::Access: Union<<T::Members as MemberTree>::Access>,
    T::Members: MemberTree,
{
    type Output = Group<Both<M, T::Members>>;
}

pub struct ReflectedElement<G>(PhantomData<fn() -> G>);
impl<G> Copy for ReflectedElement<G> {}
impl<G> Clone for ReflectedElement<G> {
    fn clone(&self) -> Self {
        *self
    }
}
impl ReflectedElement<EmptyGroup> {
    pub fn new() -> Self {
        Self(PhantomData)
    }
}
impl<G> ReflectedElement<G> {
    pub fn with<T>(self, _: T) -> ReflectedElement<<G as Extend<T>>::Output>
    where
        T: Token,
        G: Extend<T>,
    {
        ReflectedElement(PhantomData)
    }

    /// `Index` is inferred from `Contains` when one proof exists. If a marker
    /// appears on multiple paths, the caller must select the intended path.
    pub fn narrow<T, Index>(self) -> Projection<G, T, Index>
    where
        G: MembersOf<T, Index>,
    {
        Projection(PhantomData)
    }
}

pub trait MembersOf<T, I> {}
impl<M, T, I> MembersOf<T, I> for Group<M> where M: Contains<T, I> {}

pub struct Projection<G, T, I>(PhantomData<fn() -> (G, T, I)>);
impl<G, T, I> Copy for Projection<G, T, I> {}
impl<G, T, I> Clone for Projection<G, T, I> {
    fn clone(&self) -> Self {
        *self
    }
}

/// Simplified builtin callable traits: access is enabled from the group's
/// accumulated flags, independently of the membership tree.
pub trait Styled {
    fn bg(self) -> Self
    where
        Self: Sized;
}
impl<G> Styled for ReflectedElement<G>
where
    G: AccessGroup,
    <G as AccessGroup>::Bits: HasStyled,
{
    fn bg(self) -> Self {
        self
    }
}

pub trait Interactive {
    fn on_click(self) -> Self
    where
        Self: Sized;
}
impl<G> Interactive for ReflectedElement<G>
where
    G: AccessGroup,
    <G as AccessGroup>::Bits: HasInteractive,
{
    fn on_click(self) -> Self {
        self
    }
}

pub trait Parent {
    fn child(self) -> Self
    where
        Self: Sized;
}
impl<G> Parent for ReflectedElement<G>
where
    G: AccessGroup,
    <G as AccessGroup>::Bits: HasParent,
{
    fn child(self) -> Self {
        self
    }
}
pub trait AccessGroup {
    type Bits;
}
impl<M: MemberTree> AccessGroup for Group<M> {
    type Bits = M::Access;
}
