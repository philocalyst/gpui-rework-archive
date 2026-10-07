use crate::{Action, DummyKeyboardMapper, KeyBinding, KeyBindingContextPredicate, SharedString};
use std::{any::TypeId, collections::HashMap};

/// A generic collection of `Action` -> keystrokes which can be bound under a shared key-context.
/// Use `as_keybindings` to create an iterator of `KeyBinding` to provide to `App::bind_keys`.
///
/// ```rust
/// # use gpui::{ActionBindingCollection, Action};
/// gpui::actions!([MyAction]);
/// # #[gpui::test]
/// # fn test(app: &mut gpui::TestAppContext) {
/// app.bind_keys(ActionBindingCollection::default().with::<MyAction>("enter").as_keybindings(None));
/// # }
/// ```
#[derive(Default)]
pub struct ActionBindingCollection {
    entries: HashMap<TypeId, ActionBindingEntry>,
}

#[derive(Debug)]
struct ActionBindingEntry {
    // The action used to build Keybinding
    action: Box<dyn Action>,
    // The keystrokes that trigger the action
    // NOTE: could limit allocations by utilizing smallvec
    keystrokes: Vec<SharedString>,
}

impl ActionBindingCollection {
    /// Add another keystroke that invokes `A`.
    ///
    /// Calling this repeatedly for the same action collects multiple alternatives. `A::default()`
    /// supplies the action value when [`Self::as_keybindings`] constructs the bindings.
    pub fn with<A: Action + Default>(mut self, keystrokes: impl Into<SharedString>) -> Self {
        let action_id = TypeId::of::<A>();
        let entry = self.entries.entry(action_id);
        let entry = entry.or_insert_with(|| ActionBindingEntry {
            action: Box::new(A::default()),
            keystrokes: Vec::with_capacity(5),
        });
        entry.keystrokes.push(keystrokes.into());
        self
    }

    /// Create one `KeyBinding` per action/keystroke pair with the same optional context.
    ///
    /// Pass the iterator to [`App::bind_keys`](crate::App::bind_keys). The bindings use the dummy
    /// keyboard mapper, so use [`KeyBinding::load`] directly when platform key equivalents or
    /// recoverable parse errors are required. This method panics if the context or a keystroke
    /// cannot be parsed. Since actions are stored in a hash map, do not rely on the relative order
    /// of bindings for different action types; use an ordered `Vec<KeyBinding>` when tie-breaking
    /// precedence between actions matters.
    pub fn as_keybindings(&self, context: Option<&str>) -> impl Iterator<Item = KeyBinding> {
        let context_predicate =
            context.map(|context| KeyBindingContextPredicate::parse(context).unwrap().into());
        let iter = self.entries.iter();
        let iter = iter.map(move |(_, entry)| {
            let action = &entry.action;
            let context_predicate = context_predicate.clone();
            entry.keystrokes.iter().map(move |keystrokes| {
                let keybinding = KeyBinding::load(
                    keystrokes.as_str(),
                    action.boxed_clone(),
                    context_predicate.clone(),
                    false,
                    None,
                    &DummyKeyboardMapper,
                );
                keybinding.expect("failed to load keybinding")
            })
        });
        iter.flatten()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::TestAppContext;

    actions!([TestAction]);

    #[gpui::test]
    fn test_default_empty(_cx: &mut TestAppContext) {
        assert!(ActionBindingCollection::default().entries.is_empty());
    }

    #[gpui::test]
    fn test_single_binding(_cx: &mut TestAppContext) {
        let collection = ActionBindingCollection::default();
        let collection = collection.with::<TestAction>("enter");

        let entry = collection.entries.get(&TypeId::of::<TestAction>());
        let entry = entry.map(|entry| &entry.keystrokes);
        assert_eq!(entry, Some(&vec![SharedString::new_static("enter")]));

        let out_bindings = collection.as_keybindings(None).collect::<Vec<_>>();
        assert_eq!(out_bindings.len(), 1);
    }

    #[gpui::test]
    fn test_single_action_many_keys(_cx: &mut TestAppContext) {
        let collection = ActionBindingCollection::default();
        let collection = collection.with::<TestAction>("enter");
        let collection = collection.with::<TestAction>("escape");

        let entry = collection.entries.get(&TypeId::of::<TestAction>());
        let entry = entry.map(|entry| &entry.keystrokes);
        assert_eq!(
            entry,
            Some(&vec![
                SharedString::new_static("enter"),
                SharedString::new_static("escape")
            ])
        );

        let out_bindings = collection.as_keybindings(None).collect::<Vec<_>>();
        assert_eq!(out_bindings.len(), 2);
    }

    #[gpui::test]
    fn test_single_action_many_keys_context(_cx: &mut TestAppContext) {
        let collection = ActionBindingCollection::default();
        let collection = collection.with::<TestAction>("enter");
        let collection = collection.with::<TestAction>("escape");
        let out_bindings = collection
            .as_keybindings(Some("test_content"))
            .collect::<Vec<_>>();
        assert_eq!(out_bindings.len(), 2);
    }
}
