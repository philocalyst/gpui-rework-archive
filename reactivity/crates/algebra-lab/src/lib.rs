//! Rooted link-cut experiments: exact subpixel translations and approximate affine products.
//!
//! No subtree bounds, damage, clipping, layout or paint skipping are provided.
//! Keys are append-only, arena-scoped capabilities. Queries mutate preferred
//! paths; operations are amortized O(log n), not worst-case logarithmic.
//! See `EXACT.md` for the integer proof/viewport path and `NOTES.md` for affine limits.
#![forbid(unsafe_code)]

use std::sync::atomic::{AtomicU64, Ordering};

const NIL: u32 = u32::MAX;
static NEXT_ARENA: AtomicU64 = AtomicU64::new(1);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Error {
    ForeignKey,
    Capacity,
    Cycle,
    NotRoot,
    InvalidTransform,
    NumericRange,
    DifferentComponent,
    RendererRange,
}

/// Six f64 coefficients: [a c tx; b d ty; 0 0 1]. Singular maps are legal.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Affine {
    pub a: f64,
    pub b: f64,
    pub c: f64,
    pub d: f64,
    pub tx: f64,
    pub ty: f64,
}

impl Affine {
    pub const IDENTITY: Self = Self {
        a: 1.0,
        b: 0.0,
        c: 0.0,
        d: 1.0,
        tx: 0.0,
        ty: 0.0,
    };
    pub const fn translation(x: f64, y: f64) -> Self {
        Self {
            tx: x,
            ty: y,
            ..Self::IDENTITY
        }
    }
    pub const fn scale(x: f64, y: f64) -> Self {
        Self {
            a: x,
            d: y,
            ..Self::IDENTITY
        }
    }
    pub fn coefficients(self) -> [f64; 6] {
        [self.a, self.b, self.c, self.d, self.tx, self.ty]
    }
    pub fn is_admitted(self) -> bool {
        self.coefficients()
            .into_iter()
            .all(|v| v.is_finite() && !v.is_subnormal())
    }
    /// Applies rhs first. Arithmetic is checked for overflow and multiplicative
    /// underflow; zero resulting from exact cancellation is permitted. Floating
    /// multiplication is not associative: splay regrouping changes rounding.
    #[inline]
    pub fn compose(self, rhs: Self) -> Result<Self, Error> {
        if !self.is_admitted() || !rhs.is_admitted() {
            return Err(Error::InvalidTransform);
        }
        let mul = |x: f64, y: f64| {
            let p = x * y;
            if !p.is_finite() || p.is_subnormal() || (p == 0.0 && x != 0.0 && y != 0.0) {
                Err(Error::NumericRange)
            } else {
                Ok(p)
            }
        };
        let sum = |x: f64, y: f64| {
            let s = x + y;
            if s.is_finite() && !s.is_subnormal() {
                Ok(s)
            } else {
                Err(Error::NumericRange)
            }
        };
        Ok(Self {
            a: sum(mul(self.a, rhs.a)?, mul(self.c, rhs.b)?)?,
            b: sum(mul(self.b, rhs.a)?, mul(self.d, rhs.b)?)?,
            c: sum(mul(self.a, rhs.c)?, mul(self.c, rhs.d)?)?,
            d: sum(mul(self.b, rhs.c)?, mul(self.d, rhs.d)?)?,
            tx: sum(sum(mul(self.a, rhs.tx)?, mul(self.c, rhs.ty)?)?, self.tx)?,
            ty: sum(sum(mul(self.b, rhs.tx)?, mul(self.d, rhs.ty)?)?, self.ty)?,
        })
    }
}

impl Default for Affine {
    fn default() -> Self {
        Self::IDENTITY
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct Key {
    arena: u64,
    index: u32,
}

#[derive(Clone, Copy, Debug, Default)]
pub struct Work {
    pub accesses: u64,
    pub rotations: u64,
    pub pulls: u64,
    pub compositions: u64,
}

mod translation;
use translation::ExactTranslations;
pub use translation::{RelativeTranslation, SUBPIXELS_PER_PIXEL, Translation, WideTranslation};

// Private algebra seam: production admission requires associative combine on all
// reachable values. ApproxAffine explicitly does not satisfy exact IEEE laws;
// ExactTranslations does, with a path-length overflow proof in translation.rs.
trait Algebra {
    type Local: Copy;
    type Product: Copy;
    fn validate(value: Self::Local) -> Result<(), Error>;
    fn lift(value: Self::Local) -> Self::Product;
    fn combine(left: Self::Product, right: Self::Product) -> Self::Product;
    fn finish(value: Self::Product) -> Result<Self::Product, Error>;
}
struct ApproxAffine;
impl Algebra for ApproxAffine {
    type Local = Affine;
    type Product = Affine;
    fn validate(value: Affine) -> Result<(), Error> {
        if value.is_admitted() {
            Ok(())
        } else {
            Err(Error::InvalidTransform)
        }
    }
    fn lift(value: Affine) -> Affine {
        value
    }
    fn combine(left: Affine, right: Affine) -> Affine {
        if left.a.is_nan() || right.a.is_nan() {
            return Affine {
                a: f64::NAN,
                ..Affine::IDENTITY
            };
        }
        left.compose(right).unwrap_or(Affine {
            a: f64::NAN,
            ..Affine::IDENTITY
        })
    }
    fn finish(value: Affine) -> Result<Affine, Error> {
        if value.a.is_nan() {
            Err(Error::NumericRange)
        } else {
            Ok(value)
        }
    }
}

/// Approximate six-f64 path products. See the cancellation characterization:
/// query history can change rounding; this is not the exact coordinate lane.
pub struct Forest(Dynamic<ApproxAffine>);
/// Sparse coordinate-space forest with exact 1/256-pixel translations.
/// Per-node payload is 64 bytes; do not allocate one for every UI primitive.
pub struct TranslationForest(Dynamic<ExactTranslations>);

// Only wrappers are generated. There is one splay/cut/link implementation below.
macro_rules! forest_api {
    ($forest:ident, $algebra:ty, $local:ty, $product:ty) => {
        impl Default for $forest {
            fn default() -> Self {
                Self::new()
            }
        }
        impl $forest {
            pub fn new() -> Self {
                Self(Dynamic::new())
            }
            pub fn len(&self) -> usize {
                self.0.len()
            }
            pub fn is_empty(&self) -> bool {
                self.0.is_empty()
            }
            pub fn node_bytes() -> usize {
                Dynamic::<$algebra>::node_bytes()
            }
            pub fn allocated_bytes(&self) -> usize {
                self.0.allocated_bytes()
            }
            pub fn reserve_nodes(&mut self, additional: usize) -> Result<(), Error> {
                self.0.reserve_nodes(additional)
            }
            pub fn work(&self) -> Work {
                self.0.work()
            }
            pub fn reset_work(&mut self) {
                self.0.reset_work();
            }
            pub fn insert(&mut self, parent: Option<Key>, local: $local) -> Result<Key, Error> {
                self.0.insert(parent, local)
            }
            pub fn parent(&self, key: Key) -> Result<Option<Key>, Error> {
                self.0.parent(key)
            }
            pub fn local(&self, key: Key) -> Result<$local, Error> {
                self.0.local(key)
            }
            pub fn set_local(&mut self, key: Key, local: $local) -> Result<(), Error> {
                self.0.set_local(key, local)
            }
            pub fn world(&mut self, key: Key) -> Result<$product, Error> {
                self.0.world(key)
            }
            pub fn cut(&mut self, key: Key) -> Result<Option<Key>, Error> {
                self.0.cut(key)
            }
            pub fn link(&mut self, root: Key, parent: Key) -> Result<(), Error> {
                self.0.link(root, parent)
            }
            pub fn reparent(&mut self, key: Key, parent: Option<Key>) -> Result<(), Error> {
                self.0.reparent(key, parent)
            }
        }
    };
}
forest_api!(Forest, ApproxAffine, Affine, Affine);
forest_api!(
    TranslationForest,
    ExactTranslations,
    Translation,
    WideTranslation
);

struct Node<A: Algebra> {
    left: u32,
    right: u32,
    // Auxiliary parent if its child link names this node; otherwise path parent.
    up: u32,
    // Represented parent remains stable across rotations, for inspection/cut API.
    parent: u32,
    local: A::Local,
    product: A::Product,
}

struct Dynamic<A: Algebra> {
    arena: u64,
    nodes: Vec<Node<A>>,
    work: Work,
}

impl<A: Algebra> Default for Dynamic<A> {
    fn default() -> Self {
        Self::new()
    }
}

impl<A: Algebra> Dynamic<A> {
    pub fn new() -> Self {
        let arena = NEXT_ARENA
            .try_update(Ordering::Relaxed, Ordering::Relaxed, |n| n.checked_add(1))
            .expect("algebra arena identity exhausted");
        Self {
            arena,
            nodes: Vec::new(),
            work: Work::default(),
        }
    }
    pub fn len(&self) -> usize {
        self.nodes.len()
    }
    /// Reserve exact mount capacity when known. Allocation failure is explicit.
    pub fn reserve_nodes(&mut self, additional: usize) -> Result<(), Error> {
        let total = self
            .nodes
            .len()
            .checked_add(additional)
            .ok_or(Error::Capacity)?;
        if total >= NIL as usize {
            return Err(Error::Capacity);
        }
        self.nodes
            .try_reserve_exact(additional)
            .map_err(|_| Error::Capacity)
    }
    pub fn is_empty(&self) -> bool {
        self.nodes.is_empty()
    }
    pub fn node_bytes() -> usize {
        std::mem::size_of::<Node<A>>()
    }
    pub fn allocated_bytes(&self) -> usize {
        self.nodes.capacity() * Self::node_bytes()
    }
    pub fn work(&self) -> Work {
        self.work
    }
    pub fn reset_work(&mut self) {
        self.work = Work::default();
    }

    /// Append a fresh node, optionally attached under an existing node. Existing
    /// nodes cannot be descendants of a not-yet-created node, so linking is O(1).
    pub fn insert(&mut self, parent: Option<Key>, local: A::Local) -> Result<Key, Error> {
        let parent = self.optional(parent)?;
        A::validate(local)?;
        let index = u32::try_from(self.nodes.len()).map_err(|_| Error::Capacity)?;
        if index == NIL {
            return Err(Error::Capacity);
        }
        self.nodes.push(Node {
            left: NIL,
            right: NIL,
            up: parent,
            parent,
            local,
            product: A::lift(local),
        });
        Ok(self.key(index))
    }
    pub fn parent(&self, key: Key) -> Result<Option<Key>, Error> {
        let i = self.index(key)?;
        Ok((self.node(i).parent != NIL).then(|| self.key(self.node(i).parent)))
    }
    pub fn local(&self, key: Key) -> Result<A::Local, Error> {
        Ok(self.node(self.index(key)?).local)
    }
    pub fn set_local(&mut self, key: Key, local: A::Local) -> Result<(), Error> {
        let i = self.index(key)?;
        A::validate(local)?;
        self.access(i);
        self.node_mut(i).local = local;
        self.pull(i);
        Ok(())
    }
    /// Expose the represented root-to-node path. Its auxiliary in-order product
    /// is parent-first, so multiplication order is left × local × right.
    pub fn world(&mut self, key: Key) -> Result<A::Product, Error> {
        let i = self.index(key)?;
        self.access(i);
        A::finish(self.node(i).product)
    }
    pub fn cut(&mut self, key: Key) -> Result<Option<Key>, Error> {
        let i = self.index(key)?;
        let old = self.node(i).parent;
        self.cut_index(i);
        Ok((old != NIL).then(|| self.key(old)))
    }
    /// Link a represented root under another component; a nonroot is rejected.
    pub fn link(&mut self, root: Key, parent: Key) -> Result<(), Error> {
        let i = self.index(root)?;
        let p = self.index(parent)?;
        if self.node(i).parent != NIL {
            return Err(Error::NotRoot);
        }
        if self.root(p) == i {
            return Err(Error::Cycle);
        }
        self.attach(i, p);
        Ok(())
    }
    /// Move a subtree. Invalid keys are checked before changing represented
    /// topology. Cycle failure restores the old edge; auxiliary paths may change.
    /// This serial in-memory operation invokes no callbacks and allocates nothing.
    pub fn reparent(&mut self, key: Key, parent: Option<Key>) -> Result<(), Error> {
        let i = self.index(key)?;
        let p = self.optional(parent)?;
        let old = self.node(i).parent;
        if old == p {
            return Ok(());
        }
        self.cut_index(i);
        if p != NIL && self.root(p) == i {
            if old != NIL {
                self.attach(i, old);
            }
            return Err(Error::Cycle);
        }
        if p != NIL {
            self.attach(i, p);
        }
        Ok(())
    }

    fn node(&self, i: u32) -> &Node<A> {
        &self.nodes[i as usize]
    }
    fn node_mut(&mut self, i: u32) -> &mut Node<A> {
        &mut self.nodes[i as usize]
    }
    fn key(&self, index: u32) -> Key {
        Key {
            arena: self.arena,
            index,
        }
    }
    fn index(&self, key: Key) -> Result<u32, Error> {
        if key.arena != self.arena || key.index as usize >= self.nodes.len() {
            Err(Error::ForeignKey)
        } else {
            Ok(key.index)
        }
    }
    fn optional(&self, key: Option<Key>) -> Result<u32, Error> {
        key.map_or(Ok(NIL), |k| self.index(k))
    }
    fn aux_root(&self, i: u32) -> bool {
        let p = self.node(i).up;
        p == NIL || (self.node(p).left != i && self.node(p).right != i)
    }
    fn pull(&mut self, i: u32) {
        self.work.pulls += 1;
        let n = self.node(i);
        let (left, right, local) = (n.left, n.right, n.local);
        let mut product = A::lift(local);
        if left != NIL {
            self.work.compositions += 1;
            product = A::combine(self.node(left).product, product);
        }
        if right != NIL {
            self.work.compositions += 1;
            product = A::combine(product, self.node(right).product);
        }
        self.node_mut(i).product = product;
    }
    fn rotate(&mut self, i: u32) {
        self.work.rotations += 1;
        let p = self.node(i).up;
        let g = self.node(p).up;
        let p_root = self.aux_root(p);
        if self.node(p).left == i {
            let middle = self.node(i).right;
            self.node_mut(p).left = middle;
            if middle != NIL {
                self.node_mut(middle).up = p;
            }
            self.node_mut(i).right = p;
        } else {
            let middle = self.node(i).left;
            self.node_mut(p).right = middle;
            if middle != NIL {
                self.node_mut(middle).up = p;
            }
            self.node_mut(i).left = p;
        }
        if !p_root {
            if self.node(g).left == p {
                self.node_mut(g).left = i;
            } else {
                self.node_mut(g).right = i;
            }
        }
        self.node_mut(i).up = g;
        self.node_mut(p).up = i;
        self.pull(p);
        self.pull(i);
    }
    fn splay(&mut self, i: u32) {
        while !self.aux_root(i) {
            let p = self.node(i).up;
            if !self.aux_root(p) {
                let g = self.node(p).up;
                if (self.node(p).left == i) == (self.node(g).left == p) {
                    self.rotate(p);
                } else {
                    self.rotate(i);
                }
            }
            self.rotate(i);
        }
    }
    fn access(&mut self, i: u32) {
        self.work.accesses += 1;
        let mut last = NIL;
        let mut cursor = i;
        while cursor != NIL {
            self.splay(cursor);
            // The old right child keeps `up = cursor` as its dashed/path parent.
            self.node_mut(cursor).right = last;
            if last != NIL {
                self.node_mut(last).up = cursor;
            }
            self.pull(cursor);
            last = cursor;
            cursor = self.node(cursor).up;
        }
        self.splay(i);
    }
    fn root(&mut self, i: u32) -> u32 {
        self.access(i);
        let mut root = i;
        while self.node(root).left != NIL {
            root = self.node(root).left;
        }
        self.splay(root);
        root
    }
    fn cut_index(&mut self, i: u32) {
        self.access(i);
        let left = self.node(i).left;
        if left != NIL {
            self.node_mut(left).up = NIL;
        }
        self.node_mut(i).left = NIL;
        self.node_mut(i).parent = NIL;
        self.pull(i);
    }
    fn attach(&mut self, i: u32, parent: u32) {
        self.access(i);
        debug_assert_eq!(self.node(i).left, NIL);
        self.node_mut(i).up = parent;
        self.node_mut(i).parent = parent;
    }
}
