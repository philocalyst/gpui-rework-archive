use crate::{App, BorrowAppContext};

/// Marks a type that can occupy one application-wide state slot in [`App`].
///
/// A global is one value per app, keyed by its concrete type. It is useful for
/// state shared across unrelated entities, such as configuration or a service
/// handle. Prefer an [`Entity`](crate::Entity) when the value has its own
/// lifecycle, needs weak handles, or must notify independently of other
/// globals.
///
/// Implement the empty trait, then install a value with [`App::set_global`]:
///
/// ```
/// use gpui::{App, Global};
///
/// struct Settings { font_size: f32 }
/// impl Global for Settings {}
///
/// fn configure(cx: &mut App) {
///     cx.set_global(Settings { font_size: 16.0 });
///     assert_eq!(cx.global::<Settings>().font_size, 16.0);
/// }
/// ```
///
/// The `'static` bound excludes borrowed data with a shorter lifetime. It does
/// not require the value to live until process exit; the app owns and drops it.
/// To restrict access, keep the global type private and expose selected
/// operations through your own functions or a public wrapper.
pub trait Global: 'static {
    // This trait is intentionally left empty, by virtue of being a marker trait.
    //
    // Use additional traits with blanket implementations to attach functionality
    // to types that implement `Global`.
}

/// A typed convenience trait for reading a global value from an [`App`].
pub trait ReadGlobal {
    /// Returns the global instance of the implementing type.
    ///
    /// Panics if a global for that type has not been assigned. Use
    /// [`App::try_global`] when absence is expected.
    fn global(cx: &App) -> &Self;
}

impl<T: Global> ReadGlobal for T {
    fn global(cx: &App) -> &Self {
        cx.global::<T>()
    }
}

/// A typed convenience trait for setting or updating a global through an app context.
///
/// `update_global` temporarily leases the value to the callback and schedules
/// observers for that type when it is restored. `set_global` replaces the
/// stored value and schedules the same observers. Use the callback's context
/// to access other app state without holding a direct borrow of the global.
pub trait UpdateGlobal {
    /// Updates the global instance of the implementing type using the provided closure.
    ///
    /// This method provides the closure with mutable access to the context and the global simultaneously.
    /// It panics if the value is missing or already being updated. Use
    /// [`BorrowAppContext::update_default_global`] to initialize a missing value
    /// from [`Default`]. During the callback, access this global through the
    /// supplied value; reading it again through the context panics.
    fn update_global<C, F, R>(cx: &mut C, update: F) -> R
    where
        C: BorrowAppContext,
        F: FnOnce(&mut Self, &mut C) -> R;

    /// Set the global instance of the implementing type, replacing any previous value.
    fn set_global<C>(cx: &mut C, global: Self)
    where
        C: BorrowAppContext;
}

impl<T: Global> UpdateGlobal for T {
    #[track_caller]
    fn update_global<C, F, R>(cx: &mut C, update: F) -> R
    where
        C: BorrowAppContext,
        F: FnOnce(&mut Self, &mut C) -> R,
    {
        cx.update_global(update)
    }

    fn set_global<C>(cx: &mut C, global: Self)
    where
        C: BorrowAppContext,
    {
        cx.set_global(global)
    }
}
