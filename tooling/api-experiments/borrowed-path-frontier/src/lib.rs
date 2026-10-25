//! Lifetime-indexed projection experiment.

/// A typed path carries only its root and leaf types, so composition is
/// independent of any particular borrow duration.
pub trait TypedPath {
    type Root;
    type Leaf;

    fn then<Next>(self, next: Next) -> Then<Self, Next>
    where
        Self: Sized,
        Next: TypedPath<Root = Self::Leaf>,
    {
        Then { outer: self, inner: next }
    }

    /// Borrow this path for the duration inferred from `root`.
    fn get<'a>(&self, root: &'a Self::Root) -> Option<&'a Self::Leaf>
    where
        Self: BorrowPath<'a>,
    {
        <Self as BorrowPath<'a>>::getborrow(self, root)
    }

    fn get_mut<'a>(&self, root: &'a mut Self::Root) -> Option<&'a mut Self::Leaf>
    where
        Self: BorrowPath<'a>,
    {
        <Self as BorrowPath<'a>>::getborrow_mut(self, root)
    }
}

/// The borrow-indexed implementation of a path. Lifetime bounds live on this
/// companion trait, where each call can choose the lifetime it actually uses.
///
/// A projected borrow remains tied to the root borrow:
/// ```compile_fail
/// use borrowed_path_frontier::{Borrowed, Field, Owner};
/// fn child<'a, 's>(x: &'a Owner<'s>) -> &'a Borrowed<'s> { &x.child }
/// fn child_mut<'a, 's>(x: &'a mut Owner<'s>) -> &'a mut Borrowed<'s> { &mut x.child }
/// fn text<'a, 's>(x: &'a Borrowed<'s>) -> &'a &'s str { &x.text }
/// fn text_mut<'a, 's>(x: &'a mut Borrowed<'s>) -> &'a mut &'s str { &mut x.text }
/// type Path<'s> = borrowed_path_frontier::Then<
///     Field<Owner<'s>, Borrowed<'s>>, Field<Borrowed<'s>, &'s str>>;
/// fn escape<'s>(root: &Owner<'s>) -> &'static &'s str {
///     let path: Path<'s> = Field::new(child, child_mut).then(Field::new(text, text_mut));
///     path.get(root).unwrap()
/// }
/// ```
///
/// Mutable projections preserve Rust's exclusive-borrow rule:
/// ```compile_fail
/// use borrowed_path_frontier::{Borrowed, Field, Owner};
/// fn child<'a, 's>(x: &'a Owner<'s>) -> &'a Borrowed<'s> { &x.child }
/// fn child_mut<'a, 's>(x: &'a mut Owner<'s>) -> &'a mut Borrowed<'s> { &mut x.child }
/// fn text<'a, 's>(x: &'a Borrowed<'s>) -> &'a &'s str { &x.text }
/// fn text_mut<'a, 's>(x: &'a mut Borrowed<'s>) -> &'a mut &'s str { &mut x.text }
/// type Path<'s> = borrowed_path_frontier::Then<
///     Field<Owner<'s>, Borrowed<'s>>, Field<Borrowed<'s>, &'s str>>;
/// fn alias<'s>(root: &mut Owner<'s>) {
///     let path: Path<'s> = Field::new(child, child_mut).then(Field::new(text, text_mut));
///     let first = path.get_mut(root).unwrap();
///     let second = path.get_mut(root).unwrap();
///     println!("{first} {second}");
/// }
/// ```
pub trait BorrowPath<'a>: TypedPath
where
    Self::Root: 'a,
    Self::Leaf: 'a,
{
    fn getborrow(&self, root: &'a Self::Root) -> Option<&'a Self::Leaf>;
    fn getborrow_mut(&self, root: &'a mut Self::Root) -> Option<&'a mut Self::Leaf>;
}

pub struct Field<R, L> {
    get: for<'a> fn(&'a R) -> &'a L,
    get_mut: for<'a> fn(&'a mut R) -> &'a mut L,
}
impl<R, L> Copy for Field<R, L> {}
impl<R, L> Clone for Field<R, L> { fn clone(&self) -> Self { *self } }
impl<R, L> Field<R, L> {
    pub const fn new(
        get: for<'a> fn(&'a R) -> &'a L,
        get_mut: for<'a> fn(&'a mut R) -> &'a mut L,
    ) -> Self { Self { get, get_mut } }
}
impl<R, L> TypedPath for Field<R, L> {
    type Root = R;
    type Leaf = L;
}
impl<'a, R: 'a, L: 'a> BorrowPath<'a> for Field<R, L> {
    fn getborrow(&self, root: &'a R) -> Option<&'a L> { Some((self.get)(root)) }
    fn getborrow_mut(&self, root: &'a mut R) -> Option<&'a mut L> { Some((self.get_mut)(root)) }
}

pub struct Then<O, I> { outer: O, inner: I }
impl<O: Copy, I: Copy> Copy for Then<O, I> {}
impl<O: Copy, I: Copy> Clone for Then<O, I> { fn clone(&self) -> Self { *self } }
impl<O, I> TypedPath for Then<O, I>
where O: TypedPath, I: TypedPath<Root = O::Leaf>
{
    type Root = O::Root;
    type Leaf = I::Leaf;
}
impl<'a, O, I> BorrowPath<'a> for Then<O, I>
where
    O: BorrowPath<'a>,
    O::Leaf: 'a,
    I: BorrowPath<'a, Root = O::Leaf>,
    O::Root: 'a,
    I::Leaf: 'a,
{
    fn getborrow(&self, root: &'a O::Root) -> Option<&'a I::Leaf> {
        self.inner.getborrow(self.outer.getborrow(root)?)
    }
    fn getborrow_mut(&self, root: &'a mut O::Root) -> Option<&'a mut I::Leaf> {
        self.inner.getborrow_mut(self.outer.getborrow_mut(root)?)
    }
}

#[derive(Debug, PartialEq)]
pub struct Borrowed<'s> { pub text: &'s str }
#[derive(Debug, PartialEq)]
pub struct Owner<'s> { pub child: Borrowed<'s> }
fn child<'a, 's>(x: &'a Owner<'s>) -> &'a Borrowed<'s> { &x.child }
fn child_mut<'a, 's>(x: &'a mut Owner<'s>) -> &'a mut Borrowed<'s> { &mut x.child }
fn text<'a, 's>(x: &'a Borrowed<'s>) -> &'a &'s str { &x.text }
fn text_mut<'a, 's>(x: &'a mut Borrowed<'s>) -> &'a mut &'s str { &mut x.text }

#[cfg(test)]
mod tests {
    use super::*;

    fn borrowed_path<'s>() -> Then<Field<Owner<'s>, Borrowed<'s>>, Field<Borrowed<'s>, &'s str>> {
        Field::new(child, child_mut).then(Field::new(text, text_mut))
    }

    #[test]
    fn nested_borrowed_leaf_composes_with_inferred_borrow() {
        let source = String::from("short lived");
        let root = Owner { child: Borrowed { text: &source } };
        let path = borrowed_path();
        assert_eq!(*path.get(&root).unwrap(), "short lived");
    }

    #[test]
    fn mutable_composition_preserves_exclusive_borrow() {
        let source = String::from("before");
        let mut root = Owner { child: Borrowed { text: &source } };
        let path = borrowed_path();
        *path.get_mut(&mut root).unwrap() = "after";
        assert_eq!(root.child.text, "after");
    }

    #[test]
    fn direct_path_can_borrow_nonstatic_leaf() {
        let source = String::from("borrowed");
        let root = Borrowed { text: &source };
        let path = Field::new(text, text_mut);
        assert_eq!(*path.get(&root).unwrap(), "borrowed");
    }
}
