//! Safe early-bound reflection experiment. This is intentionally independent of GPUI.
use std::{
    any::{Any, TypeId},
    collections::HashMap,
    hint::black_box,
    marker::PhantomData,
    time::{Duration, Instant},
};

trait Draggable {
    fn payload(&self) -> u64;
    fn bump(&mut self);
}
trait Badge {
    fn badge(&self) -> u64;
    fn set_badge(&mut self, n: u64);
}
trait Styled {
    fn style(&self) -> u64;
}
trait Interactive: Styled {
    fn click(&mut self);
}

#[derive(Default)]
struct Card {
    payload: u64,
    badge: u64,
    style: u64,
    clicks: u64,
}
impl Draggable for Card {
    fn payload(&self) -> u64 {
        self.payload
    }
    fn bump(&mut self) {
        self.payload += 1;
    }
}
impl Badge for Card {
    fn badge(&self) -> u64 {
        self.badge
    }
    fn set_badge(&mut self, n: u64) {
        self.badge = n;
    }
}
impl Styled for Card {
    fn style(&self) -> u64 {
        self.style
    }
}
impl Interactive for Card {
    fn click(&mut self) {
        self.clicks += 1;
    }
}

/// A monomorphic schema table: concrete `Any` projection happens once per
/// borrowed view, after table validation. Actual trait calls use the native view.
struct Table<T: ?Sized + 'static> {
    project: for<'a> fn(&'a mut dyn Any) -> Option<&'a mut T>,
}
impl<T: ?Sized + 'static> Table<T> {
    fn get<'a>(&self, element: &'a mut dyn Any) -> Option<&'a mut T> {
        (self.project)(element)
    }
}
fn card_as_draggable<'a>(v: &'a mut dyn Any) -> Option<&'a mut (dyn Draggable + 'static)> {
    Some(v.downcast_mut::<Card>()? as &mut (dyn Draggable + 'static))
}
fn card_as_badge<'a>(v: &'a mut dyn Any) -> Option<&'a mut (dyn Badge + 'static)> {
    Some(v.downcast_mut::<Card>()? as &mut (dyn Badge + 'static))
}
fn card_as_styled<'a>(v: &'a mut dyn Any) -> Option<&'a mut (dyn Styled + 'static)> {
    Some(v.downcast_mut::<Card>()? as &mut (dyn Styled + 'static))
}
fn card_as_interactive<'a>(v: &'a mut dyn Any) -> Option<&'a mut (dyn Interactive + 'static)> {
    Some(v.downcast_mut::<Card>()? as &mut (dyn Interactive + 'static))
}

static DRAG: Table<dyn Draggable> = Table {
    project: card_as_draggable,
};
static BADGE: Table<dyn Badge> = Table {
    project: card_as_badge,
};
static STYLE: Table<dyn Styled> = Table {
    project: card_as_styled,
};
static INTERACTIVE: Table<dyn Interactive> = Table {
    project: card_as_interactive,
};

/// Runtime registry resembles the current reflected schema. Construction is cold;
/// warm dispatch performs a map lookup and Any table downcast for each capability.
struct Schema {
    tables: HashMap<TypeId, Box<dyn Any + Send + Sync>>,
}
impl Schema {
    fn card() -> Self {
        let mut tables: HashMap<TypeId, Box<dyn Any + Send + Sync>> = HashMap::new();
        tables.insert(
            TypeId::of::<dyn Draggable>(),
            Box::new(&DRAG as &'static Table<dyn Draggable>),
        );
        tables.insert(
            TypeId::of::<dyn Badge>(),
            Box::new(&BADGE as &'static Table<dyn Badge>),
        );
        tables.insert(
            TypeId::of::<dyn Styled>(),
            Box::new(&STYLE as &'static Table<dyn Styled>),
        );
        tables.insert(
            TypeId::of::<dyn Interactive>(),
            Box::new(&INTERACTIVE as &'static Table<dyn Interactive>),
        );
        Self { tables }
    }
    fn resolve<T: ?Sized + 'static>(&self) -> Option<&'static Table<T>> {
        self.tables
            .get(&TypeId::of::<T>())?
            .downcast_ref::<&'static Table<T>>()
            .copied()
    }
}

/// Marker types are the typed schema. A token group binds its table slot once.
trait Group: 'static {
    type Access: Builtins;
    type Callables;
    fn bind(schema: &Schema) -> Option<NativeTables<Self::Callables, Self::Access>>;
}
struct DraggableGroup;
struct BadgeGroup;
struct StyledGroup;
struct InteractiveGroup;

/// Type-level total OR. `Off` contributes unit storage; `On` contributes a
/// typed table reference. OR is right-biased only in representation: On wins.
struct Off;
struct On;
trait Flag: 'static {
    type Or<R: Flag>: Flag;
    type Slot<T: 'static>;
}
impl Flag for Off {
    type Or<R: Flag> = R;
    type Slot<T: 'static> = ();
}
impl Flag for On {
    type Or<R: Flag> = On;
    type Slot<T: 'static> = &'static T;
}
struct Access<S: Flag, I: Flag>(PhantomData<fn() -> (S, I)>);
trait Builtins: 'static {
    type Styled: Flag;
    type Interactive: Flag;
}
impl<S: Flag, I: Flag> Builtins for Access<S, I> {
    type Styled = S;
    type Interactive = I;
}
struct BuiltinSlots<A: Builtins> {
    styled: <A::Styled as Flag>::Slot<Table<dyn Styled>>,
    interactive: <A::Interactive as Flag>::Slot<Table<dyn Interactive>>,
}
struct NativeTables<C, A: Builtins> {
    callables: C,
    builtins: BuiltinSlots<A>,
}

trait MergeFlag<R: Flag, T: 'static>: Flag {
    type Out: Flag;
    fn merge(left: Self::Slot<T>, right: R::Slot<T>) -> <Self::Out as Flag>::Slot<T>;
}
impl<T: 'static> MergeFlag<Off, T> for Off {
    type Out = Off;
    fn merge(_: (), _: ()) -> () {
        ()
    }
}
impl<T: 'static> MergeFlag<On, T> for Off {
    type Out = On;
    fn merge(_: (), right: &'static T) -> &'static T {
        right
    }
}
impl<T: 'static> MergeFlag<Off, T> for On {
    type Out = On;
    fn merge(left: &'static T, _: ()) -> &'static T {
        left
    }
}
impl<T: 'static> MergeFlag<On, T> for On {
    type Out = On;
    fn merge(left: &'static T, _: &'static T) -> &'static T {
        left
    }
}
trait MergeAccess<R: Builtins>: Builtins {
    type Out: Builtins;
    fn merge(left: BuiltinSlots<Self>, right: BuiltinSlots<R>) -> BuiltinSlots<Self::Out>
    where
        Self: Sized;
}
impl<S1, I1, S2, I2> MergeAccess<Access<S2, I2>> for Access<S1, I1>
where
    S1: Flag + MergeFlag<S2, Table<dyn Styled>, Out = <S1 as Flag>::Or<S2>>,
    I1: Flag + MergeFlag<I2, Table<dyn Interactive>, Out = <I1 as Flag>::Or<I2>>,
    S2: Flag,
    I2: Flag,
{
    type Out = Access<S1::Or<S2>, I1::Or<I2>>;
    fn merge(
        left: BuiltinSlots<Self>,
        right: BuiltinSlots<Access<S2, I2>>,
    ) -> BuiltinSlots<Self::Out> {
        BuiltinSlots {
            styled: S1::merge(left.styled, right.styled),
            interactive: I1::merge(left.interactive, right.interactive),
        }
    }
}
impl Group for DraggableGroup {
    type Access = Access<Off, Off>;
    type Callables = &'static Table<dyn Draggable>;
    fn bind(s: &Schema) -> Option<NativeTables<Self::Callables, Self::Access>> {
        Some(NativeTables {
            callables: s.resolve()?,
            builtins: BuiltinSlots {
                styled: (),
                interactive: (),
            },
        })
    }
}
impl Group for BadgeGroup {
    type Access = Access<Off, Off>;
    type Callables = &'static Table<dyn Badge>;
    fn bind(s: &Schema) -> Option<NativeTables<Self::Callables, Self::Access>> {
        Some(NativeTables {
            callables: s.resolve()?,
            builtins: BuiltinSlots {
                styled: (),
                interactive: (),
            },
        })
    }
}
impl Group for StyledGroup {
    type Access = Access<On, Off>;
    type Callables = ();
    fn bind(s: &Schema) -> Option<NativeTables<Self::Callables, Self::Access>> {
        Some(NativeTables {
            callables: (),
            builtins: BuiltinSlots {
                styled: s.resolve()?,
                interactive: (),
            },
        })
    }
}
impl Group for InteractiveGroup {
    type Access = Access<On, On>;
    type Callables = &'static Table<dyn Interactive>;
    fn bind(s: &Schema) -> Option<NativeTables<Self::Callables, Self::Access>> {
        Some(NativeTables {
            callables: s.resolve()?,
            builtins: BuiltinSlots {
                styled: s.resolve()?,
                interactive: s.resolve()?,
            },
        })
    }
}
trait ExposesStyled {}
impl<I: Flag> ExposesStyled for Access<On, I> {}
trait ExposesInteractive {}
impl<S: Flag> ExposesInteractive for Access<S, On> {}

/// Both retains both native records. Identical inherited builtin entries resolve
/// to the same immutable static table ref; no union casts or type erasure occur.
struct Both<L, R>(PhantomData<fn() -> (L, R)>);
impl<L: Group, R: Group> Group for Both<L, R>
where
    L::Access: MergeAccess<R::Access>,
{
    type Access = <L::Access as MergeAccess<R::Access>>::Out;
    type Callables = (L::Callables, R::Callables);
    fn bind(s: &Schema) -> Option<NativeTables<Self::Callables, Self::Access>> {
        let left = L::bind(s)?;
        let right = R::bind(s)?;
        Some(NativeTables {
            callables: (left.callables, right.callables),
            builtins: L::Access::merge(left.builtins, right.builtins),
        })
    }
}

/// The selector cache stores this `Tables` value after exact runtime validation.
/// Binding rejects any missing table before the receiver is borrowed.
struct Bound<G: Group> {
    tables: NativeTables<G::Callables, G::Access>,
    _group: PhantomData<fn() -> G>,
}
impl<G: Group> Bound<G> {
    fn validate(schema: &Schema) -> Option<Self> {
        Some(Self {
            tables: G::bind(schema)?,
            _group: PhantomData,
        })
    }
}

fn fluent_registry(schema: &Schema, element: &mut dyn Any) -> Option<u64> {
    // Simulate four fluent capability calls. Every call repeats registry lookup,
    // table downcast, then receiver projection before invoking one trait method.
    let drag = schema.resolve::<dyn Draggable>()?.get(element)?.payload();
    let badge = schema.resolve::<dyn Badge>()?.get(element)?.badge();
    schema.resolve::<dyn Draggable>()?.get(element)?.bump();
    schema
        .resolve::<dyn Badge>()?
        .get(element)?
        .set_badge(black_box(badge + 1));
    Some(drag.wrapping_add(badge))
}
fn fluent_bound(
    bound: &Bound<Both<DraggableGroup, BadgeGroup>>,
    element: &mut dyn Any,
) -> Option<u64> {
    let (drag_table, badge_table) = bound.tables.callables;
    let drag = drag_table.get(element)?.payload();
    let badge = badge_table.get(element)?.badge();
    drag_table.get(element)?.bump();
    badge_table.get(element)?.set_badge(black_box(badge + 1));
    Some(drag.wrapping_add(badge))
}

fn time(mut f: impl FnMut() -> u64, iterations: u64) -> Duration {
    let start = Instant::now();
    let mut sum = 0u64;
    for _ in 0..iterations {
        sum = sum.wrapping_add(black_box(f()));
    }
    black_box(sum);
    start.elapsed()
}
fn main() {
    let schema = Schema::card();
    // The same repeated inherited `Styled` entry merges to `On`; both native
    // slots are identical typed &'static refs. No runtime OR is needed.
    type DuplicateBuiltins = Both<StyledGroup, Both<InteractiveGroup, StyledGroup>>;
    fn assert_builtin_access<A: ExposesStyled + ExposesInteractive>() {}
    assert_builtin_access::<<DuplicateBuiltins as Group>::Access>();
    let duplicate =
        Bound::<DuplicateBuiltins>::validate(&schema).expect("all exact tables present");
    assert!(std::ptr::eq(duplicate.tables.builtins.styled, &STYLE));
    let mut builtin_card = Card::default();
    black_box(
        duplicate
            .tables
            .builtins
            .styled
            .get(&mut builtin_card as &mut dyn Any)
            .unwrap()
            .style(),
    );
    duplicate
        .tables
        .builtins
        .interactive
        .get(&mut builtin_card as &mut dyn Any)
        .unwrap()
        .click();

    // Exact table validation is all-or-nothing and happens before borrowing.
    let missing = Schema {
        tables: HashMap::from([(
            TypeId::of::<dyn Draggable>(),
            Box::new(&DRAG as &'static Table<dyn Draggable>) as Box<dyn Any + Send + Sync>,
        )]),
    };
    assert!(Bound::<Both<DraggableGroup, BadgeGroup>>::validate(&missing).is_none());

    const N: u64 = 2_000_000;
    let bound = Bound::<Both<DraggableGroup, BadgeGroup>>::validate(&schema).unwrap();
    let mut card = Card::default();
    let registry = time(
        || fluent_registry(&schema, black_box(&mut card as &mut dyn Any)).unwrap(),
        N,
    );
    let mut card2 = Card::default();
    let cached = time(
        || fluent_bound(&bound, black_box(&mut card2 as &mut dyn Any)).unwrap(),
        N,
    );
    println!(
        "four calls, {N} iterations: warm registry {:?}; pre-bound tables {:?}; speedup {:.2}x; Bound bytes {}",
        registry,
        cached,
        registry.as_secs_f64() / cached.as_secs_f64(),
        std::mem::size_of_val(&bound)
    );
}
