//! Layered style values and the derive macro that resolves them.
//!
//! Refinable values distinguish an unset field from a field set to its type's
//! default. This lets GPUI merge inherited and local style layers without losing
//! the caller's intent.

/// Derive [`Refineable`] for a struct with named fields.
pub use derive_refineable::Refineable;

/// Applies partial overrides while preserving fields that a layer leaves unset.
///
/// An override records presence separately from value. `Some(false)` overrides
/// an earlier `true`; `None` leaves it alone. GPUI uses this distinction when
/// combining inherited styles, authored styles, and interaction styles.
/// [`Cascade`] preserves the order of several such layers.
///
/// # Derive a refinement
///
/// Generated code expects this package under the crate name `refineable`, even
/// when the derive is imported through GPUI. Declare it as
/// `refineable = { package = "gpui_ce_refineable", version = "0.2.2" }` in Cargo.
/// Keep it on the same release or Git revision as GPUI.
///
/// The derive accepts a struct with named fields and generates a public
/// companion named `NameRefinement`, with the source fields' visibilities.
/// Both types implement this trait. The refinement's [`Default`] is an empty
/// override, not a copy of the concrete type's defaults:
///
/// ```
/// use refineable::{IsEmpty, Refineable};
///
/// #[derive(Clone, Default, Refineable)]
/// struct Options {
///     line_numbers: bool,
///     padding: u32,
/// }
///
/// let base = Options { line_numbers: true, padding: 8 };
/// let override_ = OptionsRefinement {
///     line_numbers: Some(false),
///     ..Default::default()
/// };
/// assert!(!override_.is_empty());
/// let resolved = base.refined(override_);
/// assert!(!resolved.line_numbers);
/// assert_eq!(resolved.padding, 8);
/// ```
///
/// Plain fields become `Option<FieldType>` in the companion. Mark a field
/// `#[refineable]` to merge it recursively through its nested refinement
/// instead. The nested refinement's name must be in scope: a field of type
/// `Border` uses `BorderRefinement`; a type already ending in `Refinement`
/// keeps that name.
///
/// An unqualified `Option<T>` field remains `Option<T>` in the refinement.
/// `Some(value)` sets the concrete field to `Some(value)`; `None` still means
/// “leave it alone.” This representation cannot clear an existing optional
/// field. Choose a separate reset value or a custom refinement when clearing
/// is part of the configuration contract.
///
/// The generated `From<NameRefinement> for Name` fills omitted plain fields
/// with their type's `Default`, independently of a custom `Name::default()`.
/// Use [`from_cascade`](Self::from_cascade) to start from the concrete type's
/// own defaults instead. Generated implementations require the field traits
/// used by their operations, including `Clone`, `PartialEq`, and those defaults.
///
/// # Derive attributes
///
/// `#[refineable(Debug)]` formats only present refinement fields.
/// `#[refineable(Serialize)]` derives serialization and skips absent fields
/// and empty nested refinements. Other traits can be listed in the same
/// attribute to derive them on the companion. The refinement also provides
/// `is_some()`, the opposite of [`IsEmpty::is_empty`]; both test presence, so
/// an explicit field equal to its default still counts as an override.
pub trait Refineable: Clone {
    /// The partial-update type, which can itself be refined by another layer.
    type Refinement: Refineable<Refinement = Self::Refinement> + IsEmpty + Default;

    /// Applies the given refinement to this instance, modifying it in place.
    ///
    /// Only supplied fields are applied, including values equal to their default.
    ///
    /// * For refineable fields, this recursively calls `refine`.
    /// * For other fields, the value is replaced if present in the refinement.
    fn refine(&mut self, refinement: &Self::Refinement);

    /// Consumes this value and applies the supplied fields, returning the result.
    ///
    /// The derive moves plain replacement fields rather than cloning them.
    /// Clone the receiver first when the original value must be retained.
    fn refined(self, refinement: Self::Refinement) -> Self;

    /// Creates an instance from a cascade by merging all refinements atop the default value.
    fn from_cascade(cascade: &Cascade<Self>) -> Self
    where
        Self: Default + Sized,
    {
        Self::default().refined(cascade.merged())
    }

    /// Returns whether every supplied field already agrees with this value.
    ///
    /// For refineable fields, this recursively checks `is_superset_of`. For other fields, this
    /// checks if the refinement's `Some` values match this instance's values.
    fn is_superset_of(&self, refinement: &Self::Refinement) -> bool;

    /// Returns values from `self` that are not already supplied equally by `refinement`.
    ///
    /// For refineable fields, this recursively calls `subtract`. For other fields, the field is
    /// `None` if the field's value is equal to the refinement. Otherwise it
    /// contains this value's field, not the proposed replacement. This is not
    /// an undo operation, and it cannot express clearing an optional field
    /// that the refinement representation cannot clear.
    fn subtract(&self, refinement: &Self::Refinement) -> Self::Refinement;
}

/// Tests whether a refinement supplies any overrides.
pub trait IsEmpty {
    /// Returns `true` when no field is supplied, including in nested refinements.
    ///
    /// An explicit `Some(default_value)` is not empty, even if applying it to
    /// a particular value would leave that value unchanged.
    fn is_empty(&self) -> bool;
}

/// A cascade of refinements that can be merged in priority order.
///
/// A cascade maintains a sequence of optional refinements where later entries
/// take precedence over earlier ones. The first slot (index 0) is always the
/// base refinement and is guaranteed to be present. A reserved slot starts
/// inactive; setting it to `None` deactivates that layer without changing the
/// precedence of later slots. A [`CascadeSlot`] belongs to the cascade that
/// created it and must not be reused with another cascade.
///
/// Precedence is determined only by reservation order; this type does not
/// implement CSS selector specificity or origin rules. Reserve a transient
/// interaction layer after the base so it can override and later reveal it:
///
/// ```
/// use refineable::{Cascade, Refineable};
///
/// #[derive(Clone, Default, Refineable)]
/// struct Style { opacity: f32 }
///
/// let mut layers = Cascade::<Style>::default();
/// layers.base().opacity = Some(1.0);
/// let disabled = layers.reserve();
/// layers.set(disabled, Some(StyleRefinement { opacity: Some(0.5) }));
/// assert_eq!(Style::from_cascade(&layers).opacity, 0.5);
/// layers.set(disabled, None);
/// assert_eq!(Style::from_cascade(&layers).opacity, 1.0);
/// ```
pub struct Cascade<S: Refineable>(Vec<Option<S::Refinement>>);

impl<S: Refineable + Default> Default for Cascade<S> {
    fn default() -> Self {
        Self(vec![Some(Default::default())])
    }
}

/// A precedence position returned by [`Cascade::reserve`].
///
/// Copying it retains the same position. It carries no cascade identity, so
/// the caller must keep it with its originating cascade; using it with another
/// cascade can update the wrong layer or panic.
#[derive(Copy, Clone)]
pub struct CascadeSlot(usize);

impl<S: Refineable + Default> Cascade<S> {
    /// Reserves a new slot in the cascade and returns a handle to it.
    ///
    /// The new slot is initially empty (`None`) and can be populated later
    /// using [`Self::set`]. Its precedence is higher than every earlier slot.
    pub fn reserve(&mut self) -> CascadeSlot {
        self.0.push(None);
        CascadeSlot(self.0.len() - 1)
    }

    /// Returns a mutable reference to the base refinement (slot 0).
    ///
    /// The base refinement is always present and serves as the foundation
    /// for the cascade.
    pub fn base(&mut self) -> &mut S::Refinement {
        self.0[0].as_mut().unwrap()
    }

    /// Sets the refinement for a specific slot in the cascade.
    ///
    /// Setting a slot to `None` effectively removes it from consideration
    /// during merging. It does not remove the slot or reorder later layers.
    ///
    /// # Panics
    ///
    /// Panics if the slot index is outside this cascade. Slots from another
    /// cascade are invalid even when their index happens to be in bounds.
    pub fn set(&mut self, slot: CascadeSlot, refinement: Option<S::Refinement>) {
        self.0[slot.0] = refinement
    }

    /// Merges all refinements in the cascade into a single refinement.
    ///
    /// Refinements are applied in order, with later slots taking precedence.
    /// Empty slots (`None`) are skipped during merging.
    pub fn merged(&self) -> S::Refinement {
        let mut merged = self.0[0].clone().unwrap();
        for refinement in self.0.iter().skip(1).flatten() {
            merged.refine(refinement);
        }
        merged
    }
}
