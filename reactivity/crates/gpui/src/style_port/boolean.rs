//! One declared boolean recipe, with semantic and palette destinations.
use super::*;
use std::sync::atomic::{AtomicU64, Ordering};

// Description-only, never recycled, dereferenced, or retained by a window.
// Escaped members cannot accidentally attach to a later allocator address.
static NEXT_BINDING: AtomicU64 = AtomicU64::new(1);
fn next_id() -> u64 {
    NEXT_BINDING
        .try_update(Ordering::Relaxed, Ordering::Relaxed, |id| id.checked_add(1))
        .expect("boolean binding identity exhausted")
}

/// One explicitly shared boolean computation. Components use this internally;
/// callers can also share a predicate across ordinary semantic and style sinks.
/// Attach the owner to the resulting tree once. Unattached members are rejected
/// by ordinary description before any presentation can publish.
/// Creating a binding does not evaluate it. A surviving group evaluates once
/// during description and once per admitted source update. Separate bindings
/// remain separate computations. Literals keep ordinary snapshot semantics.
///
/// ```
/// use gpui::{BoolBinding, BoolInput, Color, Signal};
/// let disabled=Signal::new(false);
/// let binding=BoolBinding::new(&disabled);
/// let state=binding.state();
/// let control=binding.attach(gpui::button("Continue").disabled(state)
///     .bg(state.select(Color::WHITE,Color::BLACK)));
/// drop(control);
/// ```
///
/// ```compile_fail
/// let text=gpui::Signal::new(String::from("value"));
/// let binding=gpui::BoolBinding::new(&text);
/// ```
pub struct BoolBinding<'a> {
    input: PropInput<'a, bool>,
    id: u64,
}
/// A Copy destination operand belonging to one declared boolean computation.
///
/// ```compile_fail
/// let forged=gpui::BoolState { id:1, literal:false, borrow:std::marker::PhantomData };
/// ```
#[derive(Clone, Copy)]
pub struct BoolState<'a> {
    id: u64,
    literal: bool,
    borrow: std::marker::PhantomData<&'a ()>,
}
impl<'a> BoolBinding<'a> {
    pub fn new(input: impl IntoProp<'a, bool>) -> Self {
        let input = input.into_prop();
        let id = if input.literal().is_some() || input.boolean_id().is_some() {
            0
        } else {
            next_id()
        };
        Self { input, id }
    }
    pub fn state(&self) -> BoolState<'a> {
        BoolState {
            id: self.input.boolean_id().unwrap_or(self.id),
            literal: self.input.literal().unwrap_or(false),
            borrow: std::marker::PhantomData,
        }
    }
    /// The declaration remains available when a caller overrides one member.
    /// Groups with no surviving members do not capture or poll their source.
    pub fn attach(self, mut element: crate::El<'a>) -> crate::El<'a> {
        if self.id != 0 {
            let operand = self.input.boolean_operand();
            element.bind_boolean(Record::Owner {
                id: self.id,
                signal: operand.signal,
                recipe: operand.recipe,
            });
        }
        element
    }
}
impl sealed::Input<bool> for BoolState<'_> {
    const IS_LITERAL: bool = false;
}
impl<'a> IntoProp<'a, bool> for BoolState<'a> {
    fn into_prop(self) -> PropInput<'a, bool> {
        if self.id == 0 {
            return self.literal.into_prop();
        }
        PropInput(Operand::Boolean { id: self.id })
    }
}
/// Owned palette endpoints for an explicitly erased or shared boolean operand.
#[derive(Clone, Copy)]
pub struct BoolColors<'a> {
    pub input: PropInput<'a, bool>,
    pub colors: [Color; 2],
}
impl sealed::ColorInput for BoolColors<'_> {}
impl<'a> IntoColor<'a> for BoolColors<'a> {
    fn into_color(self) -> ColorInput<'a> {
        if let Some(value) = self.input.literal() {
            return self.colors[usize::from(value)].into_color();
        }
        ColorInput(ColorOperand::Boolean(self))
    }
}
impl<'a> BoolInput<'a> for BoolState<'a> {
    fn select(self, when_false: Color, when_true: Color) -> impl IntoColor<'a> + Copy {
        self.into_prop().select(when_false, when_true)
    }
}
impl<'a> BoolInput<'a> for PropInput<'a, bool> {
    fn select(self, when_false: Color, when_true: Color) -> impl IntoColor<'a> + Copy {
        BoolColors {
            input: self,
            colors: [when_false, when_true],
        }
    }
}
impl<'a> PropInput<'a, bool> {
    fn boolean_operand(self) -> OwnedMapOperand<'a> {
        match self.0 {
            Operand::Signal(signal) => OwnedMapOperand {
                signal,
                recipe: PendingRecipe::Inline(
                    Recipe::new(|input: &dyn std::any::Any| {
                        input
                            .downcast_ref::<Signal<bool>>()
                            .map(|signal| Scalar::Value(PropertyValue::Flag(**signal)))
                    })
                    .expect("zero capture fits"),
                ),
            },
            Operand::Mapped(map) => map.into(),
            _ => unreachable!("dynamic boolean source"),
        }
    }
}
impl<T> PropInput<'_, T> {
    pub(crate) fn boolean_id(&self) -> Option<u64> {
        match self.0 {
            Operand::Boolean { id } => Some(id),
            _ => None,
        }
    }
}
/// Inline cold records. Ordinary maps keep their original Vec stride; boolean
/// members require neither a boxed selection nor a duplicate source recipe.
pub(crate) enum Record<'a> {
    Owner {
        id: u64,
        signal: &'a dyn ErasedSignal,
        recipe: PendingRecipe,
    },
    Member {
        id: u64,
        sink: Sink,
        colors: Option<[Color; 2]>,
    },
}
impl Record<'_> {
    pub fn sink(&self) -> Option<Sink> {
        match self {
            Self::Owner { .. } => None,
            Self::Member { sink, .. } => Some(*sink),
        }
    }
}
pub(crate) struct GroupDraft<'a> {
    pub id: u64,
    pub signal: &'a dyn ErasedSignal,
    pub recipe: PendingRecipe,
    pub value: bool,
    pub members: Vec<MemberDraft>,
}
pub(crate) struct MemberDraft {
    pub id: u64,
    pub node: u32,
    pub sink: Sink,
    pub colors: Option<[Color; 2]>,
}
/// Inline records are collected without an intermediate enum-sized queue.
/// Forward members (for example an input frame before its control) are resolved
/// only after the complete ordinary description has supplied its owners.
#[derive(Default)]
pub(crate) struct Description<'a> {
    groups: Vec<GroupDraft<'a>>,
    forward: Vec<MemberDraft>,
}
impl<'a> Description<'a> {
    pub fn append(&mut self, records: Vec<Record<'a>>, node: u32) -> Result<(), crate::Error> {
        for record in records {
            match record {
                Record::Owner { id, signal, recipe } => {
                    if self.groups.iter().any(|group| group.id == id) {
                        return Err(crate::Error::BooleanBinding);
                    }
                    self.groups.push(GroupDraft {
                        id,
                        signal,
                        recipe,
                        value: false,
                        members: Vec::new(),
                    });
                }
                Record::Member { id, sink, colors } => {
                    let member = MemberDraft {
                        id,
                        node,
                        sink,
                        colors,
                    };
                    if let Some(group) = self.groups.iter_mut().find(|group| group.id == id) {
                        group.members.push(member);
                    } else {
                        self.forward.push(member);
                    }
                }
            }
        }
        Ok(())
    }
    pub fn finish(mut self) -> Result<Vec<GroupDraft<'a>>, crate::Error> {
        for member in self.forward {
            self.groups
                .iter_mut()
                .find(|group| group.id == member.id)
                .ok_or(crate::Error::BooleanBinding)?
                .members
                .push(member);
        }
        self.groups.retain(|group| !group.members.is_empty());
        for group in &mut self.groups {
            let Scalar::Value(PropertyValue::Flag(value)) =
                group.recipe.scalar(group.signal.as_any())?
            else {
                return Err(crate::Error::MapInput);
            };
            group.value = value;
        }
        Ok(self.groups)
    }
}

#[cfg(test)]
mod layout_probe {
    use super::*;
    #[test]
    fn print_boolean_headers() {
        macro_rules! show { ($($ty:ty),+ $(,)?) => { $( println!("BOOLEAN_HEADER {} size={} align={}", stringify!($ty), size_of::<$ty>(), align_of::<$ty>()); )+ }; }
        show!(
            PropInput<'_, bool>,
            PendingRecipe,
            DeferredRecipe,
            MapBinding<'_>,
            super::super::MapBindings<'_>,
            crate::El<'_>,
            crate::Style,
            crate::semantic::ElementExtra<'_>,
            crate::semantic::ControlAppearance,
            crate::element::DraftNode<'_>,
            BoolBinding<'_>,
            BoolState<'_>,
            BoolColors<'_>,
            Record<'_>,
            GroupDraft<'_>,
            MemberDraft
        );
    }
}
