use crate::{Action, DummyKeyboardMapper, KeyBinding, KeyBindingContextPredicate, SharedString};
use std::{any::TypeId, collections::HashMap};

/// Alternative shortcuts for default-constructible actions under one predicate.
///
/// [`with`](Self::with) collects shortcut strings by action type.
/// [`as_keybindings`](Self::as_keybindings) parses them into bindings suitable
/// for [`App::bind_keys`](crate::App::bind_keys). Use an ordered collection of
/// [`KeyBinding`] values when relative precedence between action types matters.
///
/// ```rust
/// use gpui::{ActionBindingCollection, KeyContext, actions};
///
/// actions!(documentation_alternatives, [Submit]);
/// let alternatives = ActionBindingCollection::default()
///     .with::<Submit>("enter")
///     .with::<Submit>("ctrl-enter");
/// let bindings: Vec<_> = alternatives.as_keybindings(Some("Editor")).collect();
/// assert_eq!(bindings.len(), 2);
/// assert_eq!(bindings[0].keystrokes()[0].inner().key, "enter");
/// assert!(bindings[1].keystrokes()[0].inner().modifiers.control);
/// let editor = KeyContext::parse("Editor").unwrap();
/// for binding in &bindings {
///     assert!(binding.predicate().unwrap().eval(&[editor.clone()]));
/// }
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
    /// The first call for a type stores `A::default()`; later calls for that
    /// type append alternatives in order. Duplicate strings are retained.
    /// [`Self::as_keybindings`] clones the stored action for each alternative.
    /// Use [`KeyBinding::new`] directly for an action carrying a particular
    /// value, such as a destination path.
    ///
    /// The string is stored without parsing. Invalid syntax is reported as a
    /// panic when the [`as_keybindings`](Self::as_keybindings) iterator reaches it.
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
    /// recoverable parse errors are required. Since actions are stored in a hash map, do not rely on the relative order
    /// of bindings for different action types; use an ordered `Vec<KeyBinding>` when tie-breaking
    /// precedence between actions matters.
    /// Alternatives for one type keep the order of their `with` calls.
    ///
    /// # Panics
    ///
    /// An invalid context panics when this method is called. An invalid
    /// keystroke panics later, when the iterator reaches that alternative.
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
