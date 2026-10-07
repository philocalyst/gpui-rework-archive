//! Layered style values and the derive macro that resolves them.
//!
//! Refinable values distinguish an unset field from a field set to its type's
//! default. This lets GPUI merge inherited and local style layers without losing
//! the caller's intent.

/// Derive [`Refineable`] for a struct with named fields.
pub use derive_refineable::Refineable;

/// A trait for types that can be refined with partial updates.
///
/// The `Refineable` trait enables hierarchical configuration patterns where a base configuration
/// can be selectively overridden by refinements. A refinement records which fields were supplied,
/// so a supplied value equal to the field's default still overrides an earlier value. This is
/// particularly useful for styling, settings, and theme hierarchies.
///
/// # Derive Macro
///
/// The `#[derive(Refineable)]` macro automatically generates a companion refinement type and
/// implements this trait. For a struct `Style`, it creates `StyleRefinement` where each field is
/// wrapped appropriately:
///
/// - **Refineable fields** (marked with `#[refineable]`): Become the corresponding refinement type
///   (e.g., `Bar` becomes `BarRefinement`, or `BarRefinement` remains `BarRefinement`)
/// - **Optional fields** (`Option<T>`): Remain as `Option<T>`
/// - **Regular fields**: Become `Option<T>`
///
/// ## Attributes
///
/// The derive accepts a struct with named fields and generates a companion
/// `StyleRefinement` type (using the source struct's name plus `Refinement`). Plain fields become
/// `Option<FieldType>` in that type; a `None` means "leave the current value alone", while
/// `Some(value)` replaces it. Fields marked `#[refineable]` use the nested type's refinement and
/// merge recursively.
///
/// For a field whose type is `Option<T>`, the generated refinement field is also `Option<T>`.
/// Consequently `Some(value)` sets the field to `Some(value)`, and `None` means "no update"; this
/// derive cannot express clearing an existing `Some` back to `None` for that field. Use a different
/// representation if a layer must distinguish "unset" from "set to none".
///
/// The derive macro supports these attributes on the struct:
/// - `#[refineable(Debug)]`: Implements `Debug` for the refinement type
/// - `#[refineable(Serialize)]`: Derives `Serialize` which skips serializing `None`
/// - `#[refineable(OtherTrait)]`: Derives additional traits on the refinement type
///
/// Fields can be marked with:
/// - `#[refineable]`: Field is itself refineable (uses the nested refinement type and recursively
///   applies updates). The field type must name the nested struct; this derive supports named-field
///   structs, not tuple structs, unit structs, enums, or unions.
///
/// The generated refinement type implements [`Default`] as an empty update, [`IsEmpty`] to test
/// whether any update is present, and `From<StyleRefinement> for Style` to turn it into a concrete
/// value (omitted plain fields use `Default`). Its inherent `is_some` method is only a presence
/// check; a field set to its default still counts as present. Use [`IsEmpty::is_empty`] to test
/// whether the refinement contains any changes.
pub trait Refineable: Clone {
    type Refinement: Refineable<Refinement = Self::Refinement> + IsEmpty + Default;

    /// Applies the given refinement to this instance, modifying it in place.
    ///
    /// Only non-empty values in the refinement are applied.
    ///
    /// * For refineable fields, this recursively calls `refine`.
    /// * For other fields, the value is replaced if present in the refinement.
    fn refine(&mut self, refinement: &Self::Refinement);

    /// Returns a new instance with the refinement applied, equivalent to cloning `self` and calling
    /// `refine` on it.
    fn refined(self, refinement: Self::Refinement) -> Self;

    /// Creates an instance from a cascade by merging all refinements atop the default value.
    fn from_cascade(cascade: &Cascade<Self>) -> Self
    where
        Self: Default + Sized,
    {
        Self::default().refined(cascade.merged())
    }

    /// Returns `true` if this instance would contain all values from the refinement.
    ///
    /// For refineable fields, this recursively checks `is_superset_of`. For other fields, this
    /// checks if the refinement's `Some` values match this instance's values.
    fn is_superset_of(&self, refinement: &Self::Refinement) -> bool;

    /// Returns a refinement that represents the difference between this instance and the given
    /// refinement.
    ///
    /// For refineable fields, this recursively calls `subtract`. For other fields, the field is
    /// `None` if the field's value is equal to the refinement.
    fn subtract(&self, refinement: &Self::Refinement) -> Self::Refinement;
}

/// A refinement value that contains no changes.
pub trait IsEmpty {
    /// Returns `true` if applying this refinement would have no effect.
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
/// This is useful for implementing configuration hierarchies like CSS cascading,
/// where styles from different sources (user agent, user, author) are combined
/// with specific precedence rules.
pub struct Cascade<S: Refineable>(Vec<Option<S::Refinement>>);

impl<S: Refineable + Default> Default for Cascade<S> {
    fn default() -> Self {
        Self(vec![Some(Default::default())])
    }
}

/// A handle to a specific slot in a cascade.
///
/// Slots are used to identify specific positions in the cascade where
/// refinements can be set or updated.
#[derive(Copy, Clone)]
/// A stable handle returned by [`Cascade::reserve`] for one precedence layer.
pub struct CascadeSlot(usize);

impl<S: Refineable + Default> Cascade<S> {
    /// Reserves a new slot in the cascade and returns a handle to it.
    ///
    /// The new slot is initially empty (`None`) and can be populated later
    /// using `set()`.
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
    /// during merging.
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
