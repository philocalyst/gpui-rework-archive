//! Late-bound immutable metadata slots. A Type is a one-pointer identity handle;
//! metadata may be attached once later without changing handle identity.
use std::{
    any::{Any, TypeId},
    collections::HashMap,
    marker::PhantomData,
    sync::{Mutex, OnceLock},
};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Kind {
    Opaque,
    Scalar,
    Record,
    Sequence,
    Optional,
}

#[derive(Clone, Copy)]
pub struct Type(&'static TypeEntry);
struct TypeEntry {
    id: TypeId,
    name: &'static str,
    shape: OnceLock<Shape>,
}
#[derive(Clone, Copy)]
pub struct ShapeSnapshot {
    entry: &'static TypeEntry,
    shape: Option<&'static Shape>,
}
#[derive(Debug)]
pub struct Shape {
    pub kind: Kind,
    pub complete: bool,
    pub fields: &'static [&'static str],
    pub child: Option<Type>,
}

impl Type {
    pub fn opaque<T: Any + Send + Sync>() -> Self {
        Self(entry::<T>(std::any::type_name::<T>()))
    }
    pub fn of<T: Describe>() -> Self {
        let ty = Self::opaque::<T>();
        ty.0.shape.get_or_init(|| T::describe().build());
        ty
    }
    pub fn vec<T: Any + Send + Sync>() -> Self {
        Self::of::<Vec<T>>()
    }
    pub fn option<T: Any + Send + Sync>() -> Self {
        Self::of::<Option<T>>()
    }
    pub fn snapshot(self) -> ShapeSnapshot {
        ShapeSnapshot {
            entry: self.0,
            shape: self.0.shape.get(),
        }
    }
    pub fn name(self) -> &'static str {
        self.0.name
    }
    pub fn is<T: Any>(self) -> bool {
        self.0.id == TypeId::of::<T>()
    }
}
impl std::fmt::Debug for Type {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_tuple("Type").field(&self.name()).finish()
    }
}
impl PartialEq for Type {
    fn eq(&self, o: &Self) -> bool {
        std::ptr::eq(self.0, o.0)
    }
}
impl Eq for Type {}
impl ShapeSnapshot {
    pub fn kind(self) -> Kind {
        self.shape.map_or(Kind::Opaque, |s| s.kind)
    }
    pub fn complete(self) -> bool {
        self.shape.is_some_and(|s| s.complete)
    }
    pub fn fields(self) -> &'static [&'static str] {
        self.shape.map_or(&[], |s| s.fields)
    }
    pub fn matches(self, other: Self) -> bool {
        std::ptr::eq(self.entry, other.entry)
            && self.shape.map(|s| s as *const _) == other.shape.map(|s| s as *const _)
    }
}

fn entries() -> &'static Mutex<HashMap<TypeId, &'static TypeEntry>> {
    static E: OnceLock<Mutex<HashMap<TypeId, &'static TypeEntry>>> = OnceLock::new();
    E.get_or_init(|| Mutex::new(HashMap::new()))
}
fn entry<T: Any>(name: &'static str) -> &'static TypeEntry {
    let id = TypeId::of::<T>();
    let mut map = entries().lock().unwrap();
    *map.entry(id).or_insert_with(|| {
        Box::leak(Box::new(TypeEntry {
            id,
            name,
            shape: OnceLock::new(),
        }))
    })
}

pub struct SchemaBuilder<T: Any> {
    kind: Kind,
    complete: bool,
    fields: Vec<&'static str>,
    child: Option<Type>,
    _root: PhantomData<fn(T) -> T>,
}
impl<T: Any> SchemaBuilder<T> {
    pub fn record(_: fn(&T)) -> Self {
        Self {
            kind: Kind::Record,
            complete: true,
            fields: vec![],
            child: None,
            _root: PhantomData,
        }
    }
    pub fn scalar() -> Self {
        Self {
            kind: Kind::Scalar,
            complete: true,
            fields: vec![],
            child: None,
            _root: PhantomData,
        }
    }
    pub fn opaque() -> Self {
        Self {
            kind: Kind::Opaque,
            complete: false,
            fields: vec![],
            child: None,
            _root: PhantomData,
        }
    }
    pub fn field<U>(mut self, field: FieldDescriptor<T, U>) -> Self {
        self.fields.push(field.name);
        self
    }
    pub fn field_name(mut self, name: &'static str) -> Self {
        self.fields.push(name);
        self
    }
    pub fn complete(mut self) -> Self {
        self.complete = true;
        self
    }
    pub fn child(mut self, child: Type) -> Self {
        self.child = Some(child);
        self
    }
    pub fn build(self) -> Shape {
        Shape {
            kind: self.kind,
            complete: self.complete,
            fields: Box::leak(self.fields.into_boxed_slice()),
            child: self.child,
        }
    }
}
pub trait Describe: Any + Send + Sync + Sized + 'static {
    fn describe() -> SchemaBuilder<Self>;
}
impl<T: Any + Send + Sync + 'static> Describe for Vec<T> {
    fn describe() -> SchemaBuilder<Self> {
        SchemaBuilder {
            kind: Kind::Sequence,
            complete: true,
            fields: vec![],
            child: Some(Type::opaque::<T>()),
            _root: PhantomData,
        }
    }
}
impl<T: Any + Send + Sync + 'static> Describe for Option<T> {
    fn describe() -> SchemaBuilder<Self> {
        SchemaBuilder {
            kind: Kind::Optional,
            complete: true,
            fields: vec![],
            child: Some(Type::opaque::<T>()),
            _root: PhantomData,
        }
    }
}

#[derive(Clone, Copy)]
pub struct FieldDescriptor<Root, Field> {
    name: &'static str,
    get: fn(&Root) -> &Field,
    get_mut: fn(&mut Root) -> &mut Field,
    _types: PhantomData<fn(&Root) -> &Field>,
}
impl<R, F> FieldDescriptor<R, F> {
    pub const fn new(name: &'static str, get: fn(&R) -> &F, get_mut: fn(&mut R) -> &mut F) -> Self {
        Self {
            name,
            get,
            get_mut,
            _types: PhantomData,
        }
    }
    pub fn name(&self) -> &'static str {
        self.name
    }
    pub fn get<'a>(&self, root: &'a R) -> &'a F {
        (self.get)(root)
    }
    pub fn get_mut<'a>(&self, root: &'a mut R) -> &'a mut F {
        (self.get_mut)(root)
    }
}
pub struct Schema<Root> {
    pub root: Type,
    pub snapshot: ShapeSnapshot,
    _root: PhantomData<fn(Root) -> Root>,
}
impl<T: Describe> Schema<T> {
    pub fn of() -> Self {
        let root = Type::of::<T>();
        Self {
            root,
            snapshot: root.snapshot(),
            _root: PhantomData,
        }
    }
    pub fn field<U>(&self, field: FieldDescriptor<T, U>) -> TypedField<T, U> {
        TypedField {
            root: self.root,
            field,
            _proof: PhantomData,
        }
    }
}
#[derive(Clone, Copy)]
pub struct TypedField<R, F> {
    root: Type,
    field: FieldDescriptor<R, F>,
    _proof: PhantomData<fn(&R) -> &F>,
}
impl<R: Any, F> TypedField<R, F> {
    pub fn get<'a>(&self, root: &'a R) -> Option<&'a F> {
        self.root.is::<R>().then(|| self.field.get(root))
    }
    pub fn get_mut<'a>(&self, root: &'a mut R) -> Option<&'a mut F> {
        self.root.is::<R>().then(|| self.field.get_mut(root))
    }
    pub fn root_type(&self) -> Type {
        self.root
    }
}
#[derive(Clone, Copy)]
pub struct RoleRegistration<R> {
    root: Type,
    name: &'static str,
    _proof: PhantomData<fn(&R) -> &R>,
}
impl<R: Describe> RoleRegistration<R> {
    pub fn new(name: &'static str, schema: &Schema<R>) -> Self {
        Self {
            root: schema.root,
            name,
            _proof: PhantomData,
        }
    }
    pub fn name(&self) -> &'static str {
        self.name
    }
    pub fn root(&self) -> Type {
        self.root
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::{
        sync::atomic::{AtomicUsize, Ordering},
        thread,
    };
    #[derive(Debug)]
    struct Leaf {
        n: u8,
    }
    #[derive(Debug)]
    struct Late;
    #[derive(Debug)]
    struct VectorLate;
    static BUILDS: AtomicUsize = AtomicUsize::new(0);
    impl Describe for Leaf {
        fn describe() -> SchemaBuilder<Self> {
            BUILDS.fetch_add(1, Ordering::SeqCst);
            SchemaBuilder::record(|_: &Leaf| ()).field_name("n")
        }
    }
    impl Describe for Late {
        fn describe() -> SchemaBuilder<Self> {
            SchemaBuilder::scalar()
        }
    }
    impl Describe for VectorLate {
        fn describe() -> SchemaBuilder<Self> {
            SchemaBuilder::record(|_: &VectorLate| ())
        }
    }
    #[allow(dead_code)]
    struct OpaqueLeaf;
    impl Describe for OpaqueLeaf {
        fn describe() -> SchemaBuilder<Self> {
            SchemaBuilder::scalar()
        }
    }
    #[derive(Debug)]
    struct Root {
        leaf: Leaf,
    }
    impl Describe for Root {
        fn describe() -> SchemaBuilder<Self> {
            SchemaBuilder::record(|_: &Root| ()).field(FieldDescriptor::new(
                "leaf",
                |r: &Root| &r.leaf,
                |r: &mut Root| &mut r.leaf,
            ))
        }
    }
    #[test]
    fn handle_upgrades_after_opaque_snapshot() {
        let x = Type::opaque::<Late>();
        let before = x.snapshot();
        assert_eq!(before.kind(), Kind::Opaque);
        assert_eq!(Type::of::<Late>(), x);
        assert_eq!(x.snapshot().kind(), Kind::Scalar);
        assert!(!before.matches(x.snapshot()));
    }
    #[test]
    fn generic_vec_schema_child_can_upgrade_later() {
        let v = Type::vec::<VectorLate>();
        let child = v.snapshot().shape.unwrap().child.unwrap();
        assert_eq!(child.snapshot().kind(), Kind::Opaque);
        Type::of::<VectorLate>();
        assert_eq!(child.snapshot().kind(), Kind::Record);
    }
    #[test]
    fn recursive_wrappers_initialize() {
        let _ = Type::vec::<Option<Box<Leaf>>>();
        let _ = Type::option::<Vec<Leaf>>();
    }
    #[test]
    fn concurrent_describe_once() {
        BUILDS.store(0, Ordering::SeqCst);
        let ts: Vec<_> = (0..24)
            .map(|_| {
                thread::spawn(|| {
                    let _ = Type::of::<Leaf>();
                })
            })
            .collect();
        for t in ts {
            t.join().unwrap()
        }
        assert_eq!(BUILDS.load(Ordering::SeqCst), 1);
    }
    #[test]
    fn typed_root_descriptors() {
        let s = Schema::<Root>::of();
        let f = s.field(FieldDescriptor::new(
            "leaf",
            |r: &Root| &r.leaf,
            |r: &mut Root| &mut r.leaf,
        ));
        let r = Root {
            leaf: Leaf { n: 4 },
        };
        assert_eq!(f.get(&r).unwrap().n, 4);
        let role = RoleRegistration::new("root", &s);
        assert_eq!(role.root(), s.root);
    }
    #[test]
    fn snapshot_caches_upgrade_transition() {
        let t = Type::opaque::<Vec<Leaf>>();
        let old = t.snapshot();
        let _ = Type::of::<Vec<Leaf>>();
        let fresh = t.snapshot();
        assert_eq!(old.kind(), Kind::Opaque);
        assert_eq!(fresh.kind(), Kind::Sequence);
        assert!(!old.matches(fresh));
    }
}
