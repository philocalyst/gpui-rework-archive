//! Compiled API oracle; see README for the explicit amendment to frame generativity.
#![forbid(unsafe_code)]
#![doc = include_str!("../README.md")]

mod scope;

pub trait View {
    fn view(&self) -> El<'_>;
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Group {
    Row,
    Column,
    Box,
}

/// Owns description headers, borrows payloads. This lifetime is covariant and
/// ordinary: a description may live as long as all its borrowed operands.
#[must_use]
pub struct El<'a> {
    kind: Kind<'a>,
}

enum Kind<'a> {
    Text(&'a str),
    Value(&'a u64),
    Group(Group, Vec<El<'a>>),
}

pub fn text(value: &str) -> El<'_> {
    El {
        kind: Kind::Text(value),
    }
}

pub fn value(value: &u64) -> El<'_> {
    El {
        kind: Kind::Value(value),
    }
}

// Shape parameters avoid Rust's overlapping blanket Iterator/tuple impls. They
// are inferred at constructors; callers never name them in ordinary UI code.
#[doc(hidden)]
pub mod shape {
    pub struct One;
    pub struct Tuple<T>(pub(crate) std::marker::PhantomData<T>);
    pub struct Optional<T>(pub(crate) std::marker::PhantomData<T>);
    pub struct Iter<T>(pub(crate) std::marker::PhantomData<T>);
    pub struct Views;
}

mod sealed {
    pub trait Children<S> {}
}

pub trait ChildSeq<'a, S>: sealed::Children<S> {
    #[doc(hidden)]
    fn append(self, out: &mut Vec<El<'a>>);
}

impl sealed::Children<shape::One> for El<'_> {}
impl<'a> ChildSeq<'a, shape::One> for El<'a> {
    fn append(self, out: &mut Vec<El<'a>>) {
        out.push(self);
    }
}

impl<C, S> sealed::Children<shape::Optional<S>> for Option<C> where C: sealed::Children<S> {}
impl<'a, C, S> ChildSeq<'a, shape::Optional<S>> for Option<C>
where
    C: ChildSeq<'a, S>,
{
    fn append(self, out: &mut Vec<El<'a>>) {
        if let Some(children) = self {
            children.append(out);
        }
    }
}

impl<I, S> sealed::Children<shape::Iter<S>> for I
where
    I: Iterator,
    I::Item: sealed::Children<S>,
{
}
impl<'a, I, S> ChildSeq<'a, shape::Iter<S>> for I
where
    I: Iterator,
    I::Item: ChildSeq<'a, S>,
{
    fn append(self, out: &mut Vec<El<'a>>) {
        for children in self {
            children.append(out);
        }
    }
}

impl<T: View> sealed::Children<shape::Views> for &Vec<T> {}
impl<'a, T: View + 'a> ChildSeq<'a, shape::Views> for &'a Vec<T> {
    fn append(self, out: &mut Vec<El<'a>>) {
        out.extend(self.iter().map(View::view));
    }
}

impl sealed::Children<shape::Tuple<()>> for () {}
impl<'a> ChildSeq<'a, shape::Tuple<()>> for () {
    fn append(self, _: &mut Vec<El<'a>>) {}
}

macro_rules! tuples {
    ($($ty:ident $shape:ident $name:ident),+) => {
        impl<$($ty, $shape),+> sealed::Children<shape::Tuple<($($shape,)+)>> for ($($ty,)+)
        where $($ty: sealed::Children<$shape>),+ {}
        impl<'a, $($ty, $shape),+> ChildSeq<'a, shape::Tuple<($($shape,)+)>> for ($($ty,)+)
        where $($ty: ChildSeq<'a, $shape>),+ {
            fn append(self, out: &mut Vec<El<'a>>) {
                let ($($name,)+) = self;
                $($name.append(out);)+
            }
        }
    };
}
tuples!(A SA a);
tuples!(A SA a, B SB b);
tuples!(A SA a, B SB b, C SC c);
tuples!(A SA a, B SB b, C SC c, D SD d);

fn group<'a, C, S>(kind: Group, children: C) -> El<'a>
where
    C: ChildSeq<'a, S>,
{
    let mut nodes = Vec::new();
    children.append(&mut nodes);
    El {
        kind: Kind::Group(kind, nodes),
    }
}

pub fn row<'a, C, S>(children: C) -> El<'a>
where
    C: ChildSeq<'a, S>,
{
    group(Group::Row, children)
}

pub fn column<'a, C, S>(children: C) -> El<'a>
where
    C: ChildSeq<'a, S>,
{
    group(Group::Column, children)
}

pub fn div<'a>() -> El<'a> {
    group(Group::Box, ())
}

impl<'a> El<'a> {
    /// Add to an existing group. Text/value leaves reject children in this oracle.
    pub fn child<C, S>(mut self, child: C) -> Self
    where
        C: ChildSeq<'a, S>,
    {
        match &mut self.kind {
            Kind::Group(_, children) => child.append(children),
            _ => panic!("only groups accept children"),
        }
        self
    }
}

#[derive(Debug, PartialEq, Eq)]
pub enum OwnedKind {
    Text(String),
    Value(u64),
    Group(Group),
}

/// Preorder representation; direct child counts delimit nested groups.
#[derive(Debug, PartialEq, Eq)]
pub struct OwnedNode {
    pub kind: OwnedKind,
    pub children: usize,
}

#[derive(Default, Debug, PartialEq, Eq)]
pub struct Retained {
    nodes: Vec<OwnedNode>,
}

impl Retained {
    pub fn nodes(&self) -> &[OwnedNode] {
        &self.nodes
    }
}

#[derive(Default, Debug, PartialEq, Eq)]
pub struct Promotion {
    pub visited: usize,
    pub text_copies: usize,
    pub text_bytes_copied: usize,
}

enum Operand<'a> {
    Text(&'a str),
    Value(&'a u64),
    Group(Group),
}

struct Pending<'a> {
    operand: Operand<'a>,
    children: usize,
}

// Each header is visited once. No subtree flattening or repeated splice copies.
struct Description<'el, 'a> {
    stack: Vec<&'el El<'a>>,
}

impl<'a> Iterator for Description<'_, 'a> {
    type Item = Pending<'a>;
    fn next(&mut self) -> Option<Self::Item> {
        let el = self.stack.pop()?;
        let (operand, children) = match &el.kind {
            Kind::Text(text) => (Operand::Text(text), 0),
            Kind::Value(value) => (Operand::Value(value), 0),
            Kind::Group(group, children) => {
                self.stack.extend(children.iter().rev());
                (Operand::Group(*group), children.len())
            }
        };
        Some(Pending { operand, children })
    }
}

/// Borrow root, explicitly lower within a fresh internal scope, and retain owned
/// operands. No borrowed data or cursor can appear in Retained.
pub fn describe(root: &(impl View + ?Sized), retained: &mut Retained) -> Promotion {
    scope::with_frame(|frame| {
        let description = root.view();
        let cursor = frame.lower(Description {
            stack: vec![&description],
        });
        promote(frame.read(cursor), retained)
    })
}

fn promote(pending: &[Pending<'_>], retained: &mut Retained) -> Promotion {
    let mut report = Promotion {
        visited: pending.len(),
        ..Promotion::default()
    };
    for (index, node) in pending.iter().enumerate() {
        let equal = retained.nodes.get(index).is_some_and(|old| {
            old.children == node.children
                && match (&old.kind, &node.operand) {
                    (OwnedKind::Text(old), Operand::Text(new)) => old == new,
                    (OwnedKind::Value(old), Operand::Value(new)) => old == *new,
                    (OwnedKind::Group(old), Operand::Group(new)) => old == new,
                    _ => false,
                }
        });
        if equal {
            continue;
        }
        let kind = match node.operand {
            Operand::Text(text) => {
                report.text_copies += 1;
                report.text_bytes_copied += text.len();
                OwnedKind::Text(text.to_owned())
            }
            Operand::Value(value) => OwnedKind::Value(*value),
            Operand::Group(group) => OwnedKind::Group(group),
        };
        let owned = OwnedNode {
            kind,
            children: node.children,
        };
        if index < retained.nodes.len() {
            retained.nodes[index] = owned;
        } else {
            retained.nodes.push(owned);
        }
    }
    retained.nodes.truncate(pending.len());
    report
}

#[cfg(test)]
mod ledger {
    use super::*;
    use std::mem::size_of;

    #[test]
    fn representation_and_group_capacity_ledger() {
        let description = column((text("left"), row((text("right"), value(&7)))));
        let mut pending = vec![&description];
        let mut groups = 0;
        let mut len = 0;
        let mut capacity = 0;
        while let Some(el) = pending.pop() {
            if let Kind::Group(_, children) = &el.kind {
                groups += usize::from(children.capacity() != 0);
                len += children.len();
                capacity += children.capacity();
                pending.extend(children.iter());
            }
        }
        assert_eq!(groups, 2);
        assert_eq!(len, 4);
        assert!(capacity >= len);
        eprintln!(
            "El={} Pending={} OwnedNode={} Retained={} Cursor={} ",
            size_of::<El<'_>>(),
            size_of::<Pending<'_>>(),
            size_of::<OwnedNode>(),
            size_of::<Retained>(),
            size_of::<scope::Cursor<'_>>()
        );
        eprintln!(
            "two-group sample: live group allocations={groups}, child slots={len}, capacity={capacity}, group payload bytes={}",
            capacity * size_of::<El<'_>>()
        );
    }
}
