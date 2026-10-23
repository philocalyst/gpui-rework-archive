#![feature(type_alias_impl_trait)]
//! Constructibility probe only; not a production schema or performance fixture.
use std::{any::Any, marker::PhantomData};

trait Schema<M> {
    fn find<'a>(&self, model: &'a M, path: &[u32]) -> Option<&'a dyn Any>;
}
trait View: Sized + 'static {
    fn source_schema() -> impl Schema<Self> {
        Empty(PhantomData)
    }
}
struct Empty<M>(PhantomData<fn() -> M>);
impl<M> Schema<M> for Empty<M> {
    fn find<'a>(&self, _: &'a M, _: &[u32]) -> Option<&'a dyn Any> {
        None
    }
}
struct Source<M, T: 'static> {
    id: u32,
    read: fn(&M) -> &T,
}
impl<M, T: 'static> Schema<M> for &'static Source<M, T> {
    fn find<'a>(&self, model: &'a M, path: &[u32]) -> Option<&'a dyn Any> {
        (path == [self.id]).then(|| (self.read)(model) as &dyn Any)
    }
}
impl<M, A: Schema<M>, B: Schema<M>> Schema<M> for (A, B) {
    fn find<'a>(&self, model: &'a M, path: &[u32]) -> Option<&'a dyn Any> {
        self.0
            .find(model, path)
            .or_else(|| self.1.find(model, path))
    }
}
struct ComponentDeclaration<P, C> {
    id: u32,
    read: fn(&P) -> &C,
}
struct Component<P: 'static, C: 'static, S> {
    declaration: &'static ComponentDeclaration<P, C>,
    child: S,
}
impl<P: 'static, C: 'static, S: Schema<C>> Schema<P> for Component<P, C, S> {
    fn find<'a>(&self, model: &'a P, path: &[u32]) -> Option<&'a dyn Any> {
        let (&id, rest) = path.split_first()?;
        (id == self.declaration.id)
            .then(|| self.child.find((self.declaration.read)(model), rest))
            .flatten()
    }
}
fn component<P: 'static, C: View>(
    declaration: &'static ComponentDeclaration<P, C>,
) -> impl Schema<P> {
    Component {
        declaration,
        child: C::source_schema(),
    }
}
type MountedSchema<M: View> = impl Schema<M>;
#[define_opaque(MountedSchema)]
fn mount<M: View>() -> MountedSchema<M> {
    M::source_schema()
}
struct Runtime<M: View> {
    model: M,
    schema: MountedSchema<M>,
}
impl<M: View> Runtime<M> {
    fn new(model: M) -> Self {
        Self {
            model,
            schema: mount::<M>(),
        }
    }
    fn get<T: 'static>(&self, path: &[u32]) -> Option<&T> {
        self.schema.find(&self.model, path)?.downcast_ref()
    }
}
struct Child {
    value: u64,
}
impl Child {
    const VALUE: Source<Self, u64> = Source {
        id: 1,
        read: |m| &m.value,
    };
}
impl View for Child {
    fn source_schema() -> impl Schema<Self> {
        &Self::VALUE
    }
}
struct App {
    value: u64,
    child: Child,
}
impl App {
    const VALUE: Source<Self, u64> = Source {
        id: 1,
        read: |m| &m.value,
    };
    const CHILD: ComponentDeclaration<Self, Child> = ComponentDeclaration {
        id: 2,
        read: |m| &m.child,
    };
}
impl View for App {
    fn source_schema() -> impl Schema<Self> {
        (&Self::VALUE, component(&Self::CHILD))
    }
}
#[inline(never)]
fn probe(owner: &Runtime<App>) -> (u64, u64) {
    (
        *owner.get::<u64>(&[1]).unwrap(),
        *owner.get::<u64>(&[2, 1]).unwrap(),
    )
}
fn main() {
    let owner = Runtime::new(App {
        value: 7,
        child: Child { value: 11 },
    });
    assert_eq!(probe(&owner), (7, 11));
    assert!(owner.get::<u32>(&[2, 1]).is_none());
    assert!(owner.get::<u64>(&[9]).is_none());
    struct Blank;
    impl View for Blank {}
    assert_eq!(size_of::<MountedSchema<Blank>>(), 0);
    println!(
        "schema_blank={},schema_child={},schema_app={},runtime_app={}",
        size_of::<MountedSchema<Blank>>(),
        size_of::<MountedSchema<Child>>(),
        size_of::<MountedSchema<App>>(),
        size_of::<Runtime<App>>()
    );
}
