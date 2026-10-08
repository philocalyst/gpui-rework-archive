use anyhow::{Context as _, Result};
use collections::{HashMap, TypeIdHashMap};
pub use gpui_macros::Action;
pub use no_action::{NoAction, Unbind, is_no_action, is_unbind};
use serde_json::json;
use std::{
    any::{Any, TypeId},
    fmt::Display,
};

/// Defines and registers payload-free action types in a namespace.
///
/// Use this when a command needs only a name. Derive [`Action`] on a struct
/// when callers must supply data, such as a destination or selection policy.
///
/// ```rust,standalone_crate
/// use gpui::actions;
/// actions!(editor, [MoveUp, MoveDown, MoveLeft, MoveRight, Newline]);
/// ```
///
/// Each generated type implements `Clone`, `PartialEq`, `Default`, `Debug`,
/// and [`Action`]. Its registered name includes the namespace, such as
/// `editor::MoveUp`. Attributes and doc comments may precede each listed name.
///
/// The namespace is optional, but helps avoid collisions between commands
/// from different modules. Use one identifier for it, such as `editor`.
/// Declaration does not install a key binding or a
/// handler: use [`App::bind_keys`](crate::App::bind_keys) and
/// [`InteractiveElement::on_action`](crate::InteractiveElement::on_action).
#[macro_export]
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-actions.md")]
// docs:examples:end
macro_rules! actions {
    ($namespace:path, [ $( $(#[$attr:meta])* $name:ident),* $(,)? ]) => {
        $(
            #[derive(::std::clone::Clone, ::std::cmp::PartialEq, ::std::default::Default, ::std::fmt::Debug, gpui::Action)]
            #[action(namespace = $namespace)]
            $(#[$attr])*
            pub struct $name;
        )*
    };
    ([ $( $(#[$attr:meta])* $name:ident),* $(,)? ]) => {
        $(
            #[derive(::std::clone::Clone, ::std::cmp::PartialEq, ::std::default::Default, ::std::fmt::Debug, gpui::Action)]
            $(#[$attr])*
            pub struct $name;
        )*
    };
}

/// A typed command shared by key bindings, menus, and programmatic dispatch.
///
/// An action describes the requested operation. A handler decides what that
/// operation means in the focused view: for example, a movement command can
/// move an editor's cursor or a list's selection. Declare the type, bind an
/// input if needed, then attach a handler. Registration by name lets
/// [`App::build_action`](crate::App::build_action) construct it from configuration;
/// registration alone does not make it available in the element tree.
///
/// Use [`actions!`] for commands without data, and the derive macro for commands
/// carrying data. Dispatch follows the focused element path; a bubbling
/// handler consumes the action unless it calls [`App::propagate`](crate::App::propagate).
/// See the [keyboard walkthrough](https://gpui-ce.github.io/examples/actions/)
/// for the complete focus, context, binding, and handler setup.
///
/// # Declare a command with data
///
/// ```no_run
/// use gpui::Action;
///
/// /// Select the next match, optionally replacing the newest selection.
/// #[derive(Clone, PartialEq, serde::Deserialize, schemars::JsonSchema, Action)]
/// #[action(namespace = editor)]
/// #[serde(deny_unknown_fields)]
/// pub struct SelectNext {
///     pub replace_newest: bool,
/// }
///
/// # fn configure(cx: &mut gpui::App) -> Result<(), gpui::ActionBuildError> {
/// let action = cx.build_action(
///     "editor::SelectNext",
///     Some(serde_json::json!({"replace_newest": true})),
/// )?;
/// cx.dispatch_action(action.as_ref());
/// # Ok(())
/// # }
/// ```
///
/// The type must be `'static` and `Send`. The derive needs `Clone` and
/// `PartialEq`; types with fields also need `serde::Deserialize` and
/// `schemars::JsonSchema` unless JSON construction is disabled. Unit actions
/// do not need those JSON traits and ignore the supplied JSON value.
/// `serde::Serialize` is not required. `deny_unknown_fields` is an application
/// choice that helps catch misspelled configuration keys.
/// The derive accepts concrete types; implement the trait manually when a
/// generic command needs its own registration and naming policy.
///
/// # Configure the derive
///
/// Combine these options in `#[action(...)]`:
///
/// | Option | Effect |
/// | --- | --- |
/// | `namespace = editor` | Prefix the name with this identifier and `::`. |
/// | `name = "SelectNext"` | Override the type's name; this string cannot contain `::`. |
/// | `no_json` | Make [`build`](Self::build) return an error and omit the JSON schema. |
/// | `no_register` | Implement the trait without adding the type to the named registry. |
/// | `deprecated_aliases = ["editor::OldName"]` | Accept old names through the same builder. |
/// | `deprecated = "Use another command"` | Expose a migration message to configuration tools. |
///
/// Canonical names and aliases must be unique across the application's linked
/// action types. A collision panics during app construction. `no_register`
/// does not disable the trait's builder; combine it with `no_json` for an
/// action that should only be constructed directly in Rust.
///
/// # Implement the trait manually
///
/// Usually the derive supplies the correct clone, equality, name, and builder
/// behavior. For a custom implementation, keep [`name`](Self::name) consistent
/// with [`name_for_type`](Self::name_for_type), and make
/// [`partial_eq`](Self::partial_eq) return `false` for a different concrete type.
/// Invoke [`register_action!`](crate::register_action) with the type's identifier
/// if it should also be constructible by name. The registration macro supplies
/// registry metadata; it does not implement this trait or attach a handler.
pub trait Action: Any + Send {
    /// Clone the action into an owned trait object.
    fn boxed_clone(&self) -> Box<dyn Action>;

    /// Compares type and payload with another action.
    ///
    /// Return false for a different concrete type. Key-binding lookup uses
    /// this comparison, so two values of the same command type can have
    /// different shortcuts when their payloads differ.
    fn partial_eq(&self, action: &dyn Action) -> bool;

    /// Returns the canonical name used in configuration and command lists.
    ///
    /// Deriving with `no_register` still supplies a name. Constructing through
    /// a deprecated alias also leaves this canonical name unchanged.
    fn name(&self) -> &'static str;

    /// Returns the same canonical name as [`Self::name`], without an instance.
    fn name_for_type() -> &'static str
    where
        Self: Sized;

    /// Build this action from its JSON payload.
    ///
    /// The named registry supplies `{}` when no payload is given. Derived unit
    /// actions ignore the value; derived actions with fields deserialize it.
    /// Return an error for invalid input. Registry callers report it as
    /// [`ActionBuildError::BuildError`].
    /// Calling this trait method directly does not require registration.
    ///
    /// # Example: validate a command's data
    ///
    /// This command is deliberately absent from the named registry, but its
    /// derived builder still validates the payload:
    ///
    /// ```rust
    /// use gpui::Action;
    ///
    /// #[derive(Clone, PartialEq, serde::Deserialize, schemars::JsonSchema, Action)]
    /// #[action(namespace = documentation_action_build, no_register)]
    /// #[serde(deny_unknown_fields)]
    /// struct JumpToRow { row: u32 }
    ///
    /// let command = JumpToRow::build(serde_json::json!({"row": 12})).unwrap();
    /// assert!(command.partial_eq(&JumpToRow { row: 12 }));
    /// assert!(!command.partial_eq(&JumpToRow { row: 13 }));
    /// assert!(JumpToRow::build(serde_json::json!({"row": "twelve"})).is_err());
    /// assert!(JumpToRow::build(serde_json::json!({"row": 12, "typo": true})).is_err());
    /// ```
    fn build(value: serde_json::Value) -> Result<Box<dyn Action>>
    where
        Self: Sized;

    /// Returns a JSON schema for the command's payload, if one is available.
    ///
    /// The default is `None`. The derive also returns `None` for unit actions
    /// and `no_json` actions; it otherwise asks `schemars` for the type's schema.
    /// Schema absence alone therefore does not mean JSON construction fails.
    fn action_json_schema(_: &mut schemars::SchemaGenerator) -> Option<schemars::Schema>
    where
        Self: Sized,
    {
        None
    }

    /// Lists old names that the registry should accept for this command.
    ///
    /// Each alias uses the same builder as the canonical name. The default is
    /// an empty slice. Applications can use
    /// [`App::deprecated_actions_to_preferred_actions`](crate::App::deprecated_actions_to_preferred_actions)
    /// to offer configuration migrations; GPUI does not display warnings itself.
    fn deprecated_aliases() -> &'static [&'static str]
    where
        Self: Sized,
    {
        &[]
    }

    /// Returns migration guidance for this command, if it is deprecated.
    ///
    /// The default is `None`. This is metadata for application configuration
    /// tools; it neither disables the command nor emits a warning. Registered
    /// messages are available through
    /// [`App::action_deprecation_messages`](crate::App::action_deprecation_messages).
    fn deprecation_message() -> Option<&'static str>
    where
        Self: Sized,
    {
        None
    }

    /// Returns prose that configuration tools can show for this command.
    ///
    /// The default is `None`. The derive collects the struct's literal doc
    /// comments, trimming each line. Retrieve registered prose through
    /// [`App::action_documentation`](crate::App::action_documentation).
    fn documentation() -> Option<&'static str>
    where
        Self: Sized,
    {
        None
    }
}

impl std::fmt::Debug for dyn Action {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("dyn Action")
            .field("name", &self.name())
            .finish()
    }
}

impl dyn Action {
    /// Exposes the concrete action for type tests and downcasting.
    ///
    /// Handlers registered through typed element APIs already receive `&A`.
    /// Use this when processing an erased action in custom dispatch code.
    pub fn as_any(&self) -> &dyn Any {
        self as &dyn Any
    }
}

/// Error returned when the action registry cannot construct a named action from JSON.
#[derive(Debug)]
pub enum ActionBuildError {
    /// No canonical name or registered alias matched the request.
    NotFound {
        /// The requested name, unchanged from the caller's input.
        name: String,
    },
    /// The registered builder rejected the payload.
    ///
    /// Derived builders reject invalid field data and all JSON construction
    /// for `#[action(no_json)]` types. A custom builder can report other errors.
    BuildError {
        /// The requested name, which may be a deprecated alias.
        name: String,
        /// The error returned by the builder, including its context.
        error: anyhow::Error,
    },
}

impl std::error::Error for ActionBuildError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            ActionBuildError::NotFound { .. } => None,
            ActionBuildError::BuildError { error, .. } => error.source(),
        }
    }
}

impl Display for ActionBuildError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ActionBuildError::NotFound { name } => {
                write!(f, "Didn't find an action named \"{name}\"")
            }
            ActionBuildError::BuildError { name, error } => {
                write!(f, "Error while building action \"{name}\": {error}")
            }
        }
    }
}

type ActionBuilder = fn(json: serde_json::Value) -> anyhow::Result<Box<dyn Action>>;

pub(crate) struct ActionRegistry {
    by_name: HashMap<&'static str, ActionData>,
    names_by_type_id: TypeIdHashMap<&'static str>,
    all_names: Vec<&'static str>, // So we can return a static slice.
    deprecated_aliases: HashMap<&'static str, &'static str>, // deprecated name -> preferred name
    deprecation_messages: HashMap<&'static str, &'static str>, // action name -> deprecation message
    documentation: HashMap<&'static str, &'static str>, // action name -> documentation
}

impl Default for ActionRegistry {
    fn default() -> Self {
        let mut this = ActionRegistry {
            by_name: Default::default(),
            names_by_type_id: Default::default(),
            documentation: Default::default(),
            all_names: Default::default(),
            deprecated_aliases: Default::default(),
            deprecation_messages: Default::default(),
        };

        this.load_actions();

        this
    }
}

struct ActionData {
    pub build: ActionBuilder,
    pub json_schema: fn(&mut schemars::SchemaGenerator) -> Option<schemars::Schema>,
}

/// This type must be public so that our macros can build it in other crates.
/// But this is an implementation detail and should not be used directly.
#[doc(hidden)]
pub struct MacroActionBuilder(pub fn() -> MacroActionData);

/// This type must be public so that our macros can build it in other crates.
/// But this is an implementation detail and should not be used directly.
#[doc(hidden)]
pub struct MacroActionData {
    pub name: &'static str,
    pub type_id: TypeId,
    pub build: ActionBuilder,
    pub json_schema: fn(&mut schemars::SchemaGenerator) -> Option<schemars::Schema>,
    pub deprecated_aliases: &'static [&'static str],
    pub deprecation_message: Option<&'static str>,
    pub documentation: Option<&'static str>,
}

inventory::collect!(MacroActionBuilder);

impl ActionRegistry {
    /// Load all registered actions into the registry.
    pub(crate) fn load_actions(&mut self) {
        for builder in inventory::iter::<MacroActionBuilder> {
            let action = builder.0();
            self.insert_action(action);
        }
    }

    fn insert_action(&mut self, action: MacroActionData) {
        let name = action.name;
        if self.by_name.contains_key(name) {
            panic!(
                "Action with name `{name}` already registered \
                (might be registered in `#[action(deprecated_aliases = [...])]`."
            );
        }
        self.by_name.insert(
            name,
            ActionData {
                build: action.build,
                json_schema: action.json_schema,
            },
        );
        for &alias in action.deprecated_aliases {
            if self.by_name.contains_key(alias) {
                panic!(
                    "Action with name `{alias}` already registered. \
                    `{alias}` is specified in `#[action(deprecated_aliases = [...])]` for action `{name}`."
                );
            }
            self.by_name.insert(
                alias,
                ActionData {
                    build: action.build,
                    json_schema: action.json_schema,
                },
            );
            self.deprecated_aliases.insert(alias, name);
            self.all_names.push(alias);
        }
        self.names_by_type_id.insert(action.type_id, name);
        self.all_names.push(name);
        if let Some(deprecation_msg) = action.deprecation_message {
            self.deprecation_messages.insert(name, deprecation_msg);
        }
        if let Some(documentation) = action.documentation {
            self.documentation.insert(name, documentation);
        }
    }

    /// Construct an action based on its name and optional JSON parameters sourced from the keymap.
    pub fn build_action_type(&self, type_id: &TypeId) -> Result<Box<dyn Action>> {
        let name = self
            .names_by_type_id
            .get(type_id)
            .with_context(|| format!("no action type registered for {type_id:?}"))?;

        Ok(self.build_action(name, None)?)
    }

    #[cfg(feature = "profiler")]
    pub(crate) fn try_resolve_action(&self, type_id: &TypeId) -> Option<&'static str> {
        self.names_by_type_id.get(type_id).copied()
    }

    /// Construct an action based on its name and optional JSON parameters sourced from the keymap.
    pub fn build_action(
        &self,
        name: &str,
        params: Option<serde_json::Value>,
    ) -> std::result::Result<Box<dyn Action>, ActionBuildError> {
        let build_action = self
            .by_name
            .get(name)
            .ok_or_else(|| ActionBuildError::NotFound {
                name: name.to_owned(),
            })?
            .build;
        (build_action)(params.unwrap_or_else(|| json!({}))).map_err(|e| {
            ActionBuildError::BuildError {
                name: name.to_owned(),
                error: e,
            }
        })
    }

    pub fn all_action_names(&self) -> &[&'static str] {
        self.all_names.as_slice()
    }

    pub fn action_schemas(
        &self,
        generator: &mut schemars::SchemaGenerator,
    ) -> Vec<(&'static str, Option<schemars::Schema>)> {
        // Use the order from all_names so that the resulting schema has sensible order.
        self.all_names
            .iter()
            .map(|name| {
                let action_data = self
                    .by_name
                    .get(name)
                    .expect("All actions in all_names should be registered");
                (*name, (action_data.json_schema)(generator))
            })
            .collect::<Vec<_>>()
    }

    pub fn action_schema_by_name(
        &self,
        name: &str,
        generator: &mut schemars::SchemaGenerator,
    ) -> Option<Option<schemars::Schema>> {
        self.by_name
            .get(name)
            .map(|action_data| (action_data.json_schema)(generator))
    }

    pub fn deprecated_aliases(&self) -> &HashMap<&'static str, &'static str> {
        &self.deprecated_aliases
    }

    pub fn deprecation_messages(&self) -> &HashMap<&'static str, &'static str> {
        &self.deprecation_messages
    }

    pub fn documentation(&self) -> &HashMap<&'static str, &'static str> {
        &self.documentation
    }
}

/// Iterates the linked action registrations before constructing an app.
///
/// This supplies registry metadata for tools that generate configuration
/// schemas or action documentation. It includes types registered by the
/// derive or [`register_action!`](crate::register_action), excludes
/// `no_register` types, and has no guaranteed order. Use
/// [`App::is_action_available`](crate::App::is_action_available) to check live
/// handlers instead.
pub fn generate_list_of_all_registered_actions() -> impl Iterator<Item = MacroActionData> {
    inventory::iter::<MacroActionBuilder>
        .into_iter()
        .map(|builder| builder.0())
}

mod no_action {
    use crate as gpui;
    use schemars::JsonSchema;
    use serde::Deserialize;

    actions!(
        zed,
        [
            /// A keymap marker that suppresses lower-precedence bindings for the same input.
            ///
            /// Bind it in a context to remove a shortcut there. Source metadata
            /// also participates: a base-map removal does not suppress a user
            /// binding with stronger source precedence. This is interpreted by
            /// [`Keymap`](crate::Keymap), rather than dispatched as a command.
            NoAction
        ]
    );

    /// A keymap marker that suppresses a named action for matching keystrokes.
    ///
    /// Bind it in the desired context. During context-aware lookup, it suppresses
    /// matching candidates reached later in precedence order; it does not
    /// suppress other actions on those keys. In Zed-style keymap JSON:
    ///
    /// `["zed::Unbind", "editor::NewLine"]`
    ///
    /// In Rust, construct `Unbind("editor::NewLine".into())` and pass it to
    /// [`KeyBinding::new`](crate::KeyBinding::new).
    #[derive(Clone, Debug, PartialEq, Deserialize, JsonSchema, gpui::Action)]
    #[action(namespace = zed)]
    pub struct Unbind(pub gpui::SharedString);

    /// Returns whether or not this action represents a removed key binding.
    pub fn is_no_action(action: &dyn gpui::Action) -> bool {
        action.as_any().is::<NoAction>()
    }

    /// Returns whether or not this action represents an unbind marker.
    pub fn is_unbind(action: &dyn gpui::Action) -> bool {
        action.as_any().is::<Unbind>()
    }
}
