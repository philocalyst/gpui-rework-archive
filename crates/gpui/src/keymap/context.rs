use crate::SharedString;
use anyhow::{Context as _, Result};
use std::fmt;

/// The named state contributed by one node on a key-dispatch path.
///
/// A context contains identifiers such as `Editor` and key-value entries such as `mode=insert`.
/// GPUI collects contexts from the root toward the focused node. A binding's
/// [`KeyBindingContextPredicate`] tests those nodes; it does not merge their
/// entries into one map. For example, `Editor && mode == insert` needs both
/// entries on the same node, while `Workspace > Editor` relates two nodes.
///
/// Attach the context with [`InteractiveElement::key_context`](crate::InteractiveElement::key_context).
/// It qualifies shortcuts on the focused path; attach a
/// [`FocusHandle`](crate::FocusHandle) and register an action listener separately.
/// The [input chapter](crate::_documentation::input#actions-and-key-bindings)
/// shows these parts together.
///
/// # Build a context
///
/// [`parse`](Self::parse) accepts a list of facts. The binding predicate is a
/// separate expression that tests those facts:
///
/// ```rust
/// use gpui::{KeyBindingContextPredicate as Predicate, KeyContext};
///
/// let editor = KeyContext::parse("Editor mode=insert").unwrap();
/// assert!(editor.contains("Editor"));
/// assert_eq!(editor.get("mode").unwrap(), "insert");
/// assert!(Predicate::parse("Editor && mode == insert")
///     .unwrap().eval(&[editor]));
/// ```
///
/// [`Default`] creates an empty context. [`new_with_defaults`](Self::new_with_defaults)
/// adds the compile target's operating system, not its focused component.
/// Names and values are case-sensitive. A bare identifier occupies its key
/// just as a key-value entry does.
///
/// # Change the facts
///
/// [`add`](Self::add), [`set`](Self::set), and [`extend`](Self::extend) keep an
/// existing entry. They do not replace it. Build the context from the current
/// state on each render, or clear it before changing a stored value. See
/// [`set`](Self::set) for an example.
/// These methods store strings without validating the entry grammar;
/// [`parse`](Self::parse) validates the textual form instead.
///
/// # Comparisons
///
/// Equality and hashing include entry order, even when two contexts answer
/// every predicate the same way:
///
/// ```rust
/// use gpui::{KeyBindingContextPredicate as Predicate, KeyContext};
///
/// let first = KeyContext::parse("Editor mode=insert").unwrap();
/// let second = KeyContext::parse("mode=insert Editor").unwrap();
/// assert_ne!(first, second);
/// let predicate = Predicate::parse("Editor && mode == insert").unwrap();
/// assert!(predicate.eval(&[first]));
/// assert!(predicate.eval(&[second]));
/// ```
#[derive(Clone, Default, Eq, PartialEq, Hash)]
pub struct KeyContext(Vec<ContextEntry>);

#[derive(Clone, Debug, Eq, PartialEq, Hash)]
/// An identifier or key-value entry in a [`KeyContext`].
pub struct ContextEntry {
    /// The entry's key, or its identifier when `value` is `None`.
    pub key: SharedString,
    /// The value of a keyed entry; `None` for a bare identifier.
    pub value: Option<SharedString>,
}

impl<'a> TryFrom<&'a str> for KeyContext {
    type Error = anyhow::Error;

    fn try_from(value: &'a str) -> Result<Self> {
        Self::parse(value)
    }
}

impl KeyContext {
    /// Create a context containing the compile target's `os` entry.
    ///
    /// The value is `macos`, `linux` (also on FreeBSD), `windows`, or
    /// `unknown` on other targets, including WebAssembly. This does not
    /// inspect a browser's host operating system. [`Self::default`] creates
    /// an empty context instead.
    pub fn new_with_defaults() -> Self {
        let mut context = Self::default();
        #[cfg(target_os = "macos")]
        context.set("os", "macos");
        #[cfg(any(target_os = "linux", target_os = "freebsd"))]
        context.set("os", "linux");
        #[cfg(target_os = "windows")]
        context.set("os", "windows");
        #[cfg(not(any(
            target_os = "macos",
            target_os = "linux",
            target_os = "freebsd",
            target_os = "windows"
        )))]
        context.set("os", "unknown");
        context
    }

    /// Return the first bare identifier, usually the component's name.
    ///
    /// Key-value entries are skipped. Returns `None` when the context is
    /// empty or contains only key-value entries.
    ///
    /// ```rust
    /// use gpui::KeyContext;
    ///
    /// let context = KeyContext::parse("mode=insert Editor selection").unwrap();
    /// assert_eq!(context.primary().unwrap().key, "Editor");
    /// let secondary: Vec<_> = context.secondary()
    ///     .map(|entry| entry.key.as_ref()).collect();
    /// assert_eq!(secondary, ["mode", "selection"]);
    /// assert!(context.contains("selection"));
    /// assert!(context.get("selection").is_none()); // A fact without a value.
    /// assert!(!context.contains("missing"));
    /// ```
    pub fn primary(&self) -> Option<&ContextEntry> {
        self.0.iter().find(|p| p.value.is_none())
    }

    /// Iterate in insertion order, excluding the first bare identifier.
    ///
    /// If there is no [`primary`](Self::primary) entry, every entry is returned.
    /// See its example for the order of bare and valued entries.
    pub fn secondary(&self) -> impl Iterator<Item = &ContextEntry> {
        let primary = self.primary();
        self.0.iter().filter(move |&p| Some(p) != primary)
    }

    /// Parse identifiers and key-value entries from a string.
    ///
    /// Entries are separated by whitespace. The accepted forms are:
    ///
    /// - a single identifier, such as `StatusBar`
    /// - a key-value pair, such as `mode = visible`
    /// - a mixture, such as `StatusBar mode = visible`
    ///
    /// Use [`KeyBindingContextPredicate::parse`] for the boolean expression syntax used by
    /// keybinding `context` fields.
    /// Identifiers and values accept Unicode letters and numbers, `_`, and `-`.
    /// Empty input creates an empty context. Repeated keys retain their first entry.
    ///
    /// # Errors
    ///
    /// Unsupported punctuation or a missing key/value returns an error.
    /// Quotes are not supported; a value must fit the identifier syntax.
    ///
    /// ```rust
    /// use gpui::KeyContext;
    ///
    /// assert!(KeyContext::parse("Editor mode=insert").is_ok());
    /// assert!(KeyContext::parse("Editor && mode == insert").is_err());
    /// assert!(KeyContext::parse("mode=\"insert\"").is_err());
    /// assert!(KeyContext::parse("mode=").is_err());
    /// ```
    pub fn parse(source: &str) -> Result<Self> {
        let mut context = Self::default();
        let source = skip_whitespace(source);
        Self::parse_expr(source, &mut context)?;
        Ok(context)
    }

    fn parse_expr(mut source: &str, context: &mut Self) -> Result<()> {
        while !source.is_empty() {
            let key = source
                .chars()
                .take_while(|c| is_identifier_char(*c))
                .collect::<String>();
            anyhow::ensure!(
                !key.is_empty(),
                "expected a context identifier at {source:?}"
            );
            source = skip_whitespace(&source[key.len()..]);
            if let Some(suffix) = source.strip_prefix('=') {
                source = skip_whitespace(suffix);
                let value = source
                    .chars()
                    .take_while(|c| is_identifier_char(*c))
                    .collect::<String>();
                anyhow::ensure!(
                    !value.is_empty(),
                    "expected a value for context key {key:?}"
                );
                source = skip_whitespace(&source[value.len()..]);
                context.set(key, value);
            } else {
                context.add(key);
            }
        }
        Ok(())
    }

    /// Check if this context is empty.
    pub fn is_empty(&self) -> bool {
        self.0.is_empty()
    }

    /// Clear this context.
    pub fn clear(&mut self) {
        self.0.clear();
    }

    /// Add entries from `other` whose keys are not already present.
    ///
    /// Existing values in `self` win; this does not replace an existing key's value.
    pub fn extend(&mut self, other: &Self) {
        for entry in &other.0 {
            if !self.contains(&entry.key) {
                self.0.push(entry.clone());
            }
        }
    }

    /// Add a bare identifier when its key is absent.
    ///
    /// An existing key-value entry also prevents insertion. For example,
    /// adding `mode` to `mode=insert` preserves the value `insert`.
    pub fn add<I: Into<SharedString>>(&mut self, identifier: I) {
        let key = identifier.into();

        if !self.contains(&key) {
            self.0.push(ContextEntry { key, value: None })
        }
    }

    /// Add a key-value pair only if this context does not already contain `key`.
    ///
    /// This is an insert operation, not an overwrite. To change a value, construct or clear the
    /// context with the desired entry before extending it.
    ///
    /// ```rust
    /// use gpui::KeyContext;
    ///
    /// let mut context = KeyContext::parse("Editor mode=insert").unwrap();
    /// context.set("mode", "normal");
    /// assert_eq!(context.get("mode").unwrap(), "insert");
    ///
    /// context.clear();
    /// context.add("Editor");
    /// context.set("mode", "normal");
    /// assert_eq!(context.get("mode").unwrap(), "normal");
    ///
    /// context.add("selection");
    /// context.set("selection", "multiple");
    /// assert!(context.contains("selection"));
    /// assert!(context.get("selection").is_none()); // The bare entry wins too.
    /// ```
    pub fn set<S1: Into<SharedString>, S2: Into<SharedString>>(&mut self, key: S1, value: S2) {
        let key = key.into();
        if !self.contains(&key) {
            self.0.push(ContextEntry {
                key,
                value: Some(value.into()),
            })
        }
    }

    /// Check if this context contains a given identifier or key.
    pub fn contains(&self, key: &str) -> bool {
        self.0.iter().any(|entry| entry.key.as_ref() == key)
    }

    /// Return a key's associated value.
    ///
    /// A bare identifier and an absent key both return `None`. Use
    /// [`Self::contains`] when that distinction matters.
    pub fn get(&self, key: &str) -> Option<&SharedString> {
        self.0
            .iter()
            .find(|entry| entry.key.as_ref() == key)?
            .value
            .as_ref()
    }
}

impl fmt::Debug for KeyContext {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut entries = self.0.iter().peekable();
        while let Some(entry) = entries.next() {
            if let Some(ref value) = entry.value {
                write!(f, "{}={}", entry.key, value)?;
            } else {
                write!(f, "{}", entry.key)?;
            }
            if entries.peek().is_some() {
                write!(f, " ")?;
            }
        }
        Ok(())
    }
}

/// A predicate that determines whether a key binding is enabled on a context path.
///
/// A binding uses [`Self::depth_of`] to find the deepest matching context.
/// `Editor && mode == insert` requires both entries on that node;
/// `Workspace > Editor` relates separate ancestor and descendant nodes.
/// [`Self::parse`] describes the operators, including the different scopes of
/// `!=` and `!`. See the [input chapter](crate::_documentation::input#actions-and-key-bindings)
/// for the connection between contexts, bindings, and action listeners.
#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub enum KeyBindingContextPredicate {
    /// A predicate that will match a given identifier.
    Identifier(SharedString),
    /// A predicate that will match a given key-value pair.
    Equal(SharedString, SharedString),
    /// Match when the current node's value differs, including an absent key.
    NotEqual(SharedString, SharedString),
    /// Match a child predicate below the first ancestor matching the parent.
    ///
    /// The nodes need not be adjacent. The child is evaluated on the path
    /// below that ancestor, which also bounds negation in the child predicate.
    Descendant(
        Box<KeyBindingContextPredicate>,
        Box<KeyBindingContextPredicate>,
    ),
    /// Match when the predicate matches no node on the current path.
    ///
    /// Unlike [`Self::NotEqual`], this checks the path rather than one node.
    Not(Box<KeyBindingContextPredicate>),
    /// A predicate that will match if both of its children match.
    And(
        Box<KeyBindingContextPredicate>,
        Box<KeyBindingContextPredicate>,
    ),
    /// A predicate that will match if either of its children match.
    Or(
        Box<KeyBindingContextPredicate>,
        Box<KeyBindingContextPredicate>,
    ),
}

impl fmt::Display for KeyBindingContextPredicate {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Identifier(name) => write!(f, "{name}"),
            Self::Equal(left, right) => write!(f, "{left} == {right}"),
            Self::NotEqual(left, right) => write!(f, "{left} != {right}"),
            Self::Descendant(parent, child) => write!(f, "{parent} > {child}"),
            Self::Not(pred) => match pred.as_ref() {
                Self::Identifier(name) => write!(f, "!{name}"),
                _ => write!(f, "!({pred})"),
            },
            Self::And(..) => self.fmt_joined(f, " && ", LogicalOperator::And, |node| {
                matches!(node, Self::Or(..))
            }),
            Self::Or(..) => self.fmt_joined(f, " || ", LogicalOperator::Or, |node| {
                matches!(node, Self::And(..))
            }),
        }
    }
}

impl KeyBindingContextPredicate {
    /// Parse the expression used in a key binding's `context` field.
    ///
    /// An element supplies entries such as `Editor mode=insert` through
    /// [`KeyContext::parse`]. A binding tests them with this expression syntax:
    ///
    /// | Expression | Matches when |
    /// | --- | --- |
    /// | `Editor` | The current node contains the identifier or key `Editor` |
    /// | `mode == insert` | The current node has that key and value |
    /// | `mode != readonly` | The current value differs, or the key is absent |
    /// | `Editor && mode == insert` | Both checks match the current node |
    /// | `Editor \|\| Terminal` | Either check matches the current node |
    /// | `!Dialog` | No node on the path contains `Dialog` |
    /// | `Workspace > Editor` | The current node is below a matching ancestor |
    ///
    /// From tightest to loosest, precedence is `!`, `==`/`!=`, `&&`, `||`,
    /// then `>`. Use parentheses to make a grouping explicit. In particular,
    /// write `!(mode == readonly)` to negate an equality. Write spaces around
    /// `>`: the parser also accepts Vim operator characters within identifiers.
    ///
    /// `!=` and `!` answer different questions. The former checks one node;
    /// the latter rejects a match anywhere on its path. After `>`, that path
    /// begins below the first matching ancestor. For example,
    /// `Workspace > !Dialog` ignores a `Dialog` above the matching workspace.
    ///
    /// # Errors
    ///
    /// Empty input, missing operands, unmatched parentheses, unsupported
    /// characters, and trailing unparsed input return an error. The operands
    /// of `==` and `!=` must be identifiers, not grouped boolean expressions.
    /// Use an absent binding predicate for an unconditional binding.
    ///
    /// # Example
    ///
    /// ```rust
    /// use gpui::{KeyBindingContextPredicate as Predicate, KeyContext};
    /// let path = [
    ///     KeyContext::parse("Workspace").unwrap(),
    ///     KeyContext::parse("Editor mode=insert").unwrap(),
    /// ];
    /// assert!(Predicate::parse("Workspace > Editor && mode == insert").unwrap().eval(&path));
    /// assert!(!Predicate::parse("Workspace && Editor").unwrap().eval(&path));
    /// ```
    ///
    /// A read-only ancestor does not replace the editor's local mode, but a
    /// path-wide exclusion can still see it:
    ///
    /// ```rust
    /// use gpui::{KeyBindingContextPredicate as Predicate, KeyContext};
    /// let path = [
    ///     KeyContext::parse("Workspace mode=readonly").unwrap(),
    ///     KeyContext::parse("Editor mode=insert").unwrap(),
    /// ];
    /// assert!(Predicate::parse("Editor && mode != readonly").unwrap().eval(&path));
    /// assert!(!Predicate::parse("Editor && !(mode == readonly)").unwrap().eval(&path));
    /// assert!(Predicate::parse("Workspace > Editor && !(mode == readonly)").unwrap().eval(&path));
    /// ```
    pub fn parse(source: &str) -> Result<Self> {
        let source = skip_whitespace(source);
        let (predicate, rest) = Self::parse_expr(source, 0)?;
        if let Some(next) = rest.chars().next() {
            anyhow::bail!("unexpected character '{next:?}'");
        } else {
            Ok(predicate)
        }
    }

    /// Return the deepest matching prefix depth on a context path.
    ///
    /// `contexts` are ordered from the outermost node to the focused node. `None` means the
    /// predicate does not match any prefix; a returned depth is the number of contexts in the
    /// deepest prefix where it matches.
    /// Negation still sees the complete `contexts` path, including nodes below
    /// the prefix being tested. A descendant predicate narrows that scope as
    /// described in [`Self::parse`].
    ///
    /// ```rust
    /// use gpui::{KeyBindingContextPredicate as Predicate, KeyContext};
    ///
    /// let path = [
    ///     KeyContext::parse("Workspace").unwrap(),
    ///     KeyContext::parse("Editor").unwrap(),
    ///     KeyContext::parse("Dialog").unwrap(),
    /// ];
    /// let editor = Predicate::parse("Editor").unwrap();
    /// assert!(!editor.eval(&path)); // The last node is Dialog.
    /// assert_eq!(editor.depth_of(&path), Some(2));
    /// assert_eq!(Predicate::parse("Editor && !Dialog").unwrap().depth_of(&path), None);
    /// assert_eq!(editor.depth_of(&[]), None);
    /// ```
    pub fn depth_of(&self, contexts: &[KeyContext]) -> Option<usize> {
        for depth in (0..=contexts.len()).rev() {
            let context_slice = &contexts[0..depth];
            if self.eval_inner(context_slice, contexts) {
                return Some(depth);
            }
        }
        None
    }

    /// Evaluate this predicate at the last node of a context path.
    ///
    /// Order contexts outermost to innermost. An identifier or equality checks
    /// only the last node; descendant and negation checks can inspect the path.
    /// An empty path never matches. Use [`Self::depth_of`] to search for the
    /// deepest match, as key binding resolution does.
    #[allow(unused)]
    pub fn eval(&self, contexts: &[KeyContext]) -> bool {
        self.eval_inner(contexts, contexts)
    }

    /// Evaluate against a prefix while retaining the full path for descendant and negation checks.
    ///
    /// This helper is used by [`Self::depth_of`]. Use [`Self::eval`] to test a
    /// complete path, or `depth_of` to find a matching ancestor.
    ///
    /// Pass a prefix as `contexts` and the complete path as `all_contexts`.
    /// The last prefix node supplies local identifiers and values. `!` checks
    /// `all_contexts`, so a negated fact below the prefix can reject it. After
    /// a matching `>`, both paths are narrowed to the suffix below that ancestor.
    /// An empty prefix returns false.
    pub fn eval_inner(&self, contexts: &[KeyContext], all_contexts: &[KeyContext]) -> bool {
        let Some(context) = contexts.last() else {
            return false;
        };
        match self {
            Self::Identifier(name) => context.contains(name),
            Self::Equal(left, right) => context
                .get(left)
                .map(|value| value == right)
                .unwrap_or(false),
            Self::NotEqual(left, right) => context
                .get(left)
                .map(|value| value != right)
                .unwrap_or(true),
            Self::Not(pred) => {
                for i in 0..all_contexts.len() {
                    if pred.eval_inner(&all_contexts[..=i], all_contexts) {
                        return false;
                    }
                }
                true
            }
            // Workspace > Pane > Editor
            //
            // Pane > (Pane > Editor) // should match?
            // (Pane > Pane) > Editor // should not match?
            // Pane > !Workspace <-- should match?
            // !Workspace        <-- shouldn't match?
            Self::Descendant(parent, child) => {
                for i in 0..contexts.len() - 1 {
                    // [Workspace >  Pane], [Editor]
                    if parent.eval_inner(&contexts[..=i], all_contexts) {
                        if !child.eval_inner(&contexts[i + 1..], &contexts[i + 1..]) {
                            return false;
                        }
                        return true;
                    }
                }
                false
            }
            Self::And(left, right) => {
                left.eval_inner(contexts, all_contexts) && right.eval_inner(contexts, all_contexts)
            }
            Self::Or(left, right) => {
                left.eval_inner(contexts, all_contexts) || right.eval_inner(contexts, all_contexts)
            }
        }
    }

    /// Return whether this predicate subsumes `other` for keymap suppression.
    ///
    /// This is a structural predicate relation used to decide whether a disabled binding covers
    /// another binding; it is not a general-purpose logical equivalence solver.
    pub fn is_superset(&self, other: &Self) -> bool {
        if self == other {
            return true;
        }

        if let KeyBindingContextPredicate::Or(left, right) = self {
            return left.is_superset(other) || right.is_superset(other);
        }

        match other {
            KeyBindingContextPredicate::Descendant(_, child) => self.is_superset(child),
            KeyBindingContextPredicate::And(left, right) => {
                self.is_superset(left) || self.is_superset(right)
            }
            KeyBindingContextPredicate::Identifier(_) => false,
            KeyBindingContextPredicate::Equal(_, _) => false,
            KeyBindingContextPredicate::NotEqual(_, _) => false,
            KeyBindingContextPredicate::Not(_) => false,
            KeyBindingContextPredicate::Or(_, _) => false,
        }
    }

    fn parse_expr(mut source: &str, min_precedence: u32) -> anyhow::Result<(Self, &str)> {
        type Op = fn(
            KeyBindingContextPredicate,
            KeyBindingContextPredicate,
        ) -> Result<KeyBindingContextPredicate>;

        let (mut predicate, rest) = Self::parse_primary(source)?;
        source = rest;

        'parse: loop {
            for (operator, precedence, constructor) in [
                (">", PRECEDENCE_CHILD, Self::new_child as Op),
                ("&&", PRECEDENCE_AND, Self::new_and as Op),
                ("||", PRECEDENCE_OR, Self::new_or as Op),
                ("==", PRECEDENCE_EQ, Self::new_eq as Op),
                ("!=", PRECEDENCE_EQ, Self::new_neq as Op),
            ] {
                if source.starts_with(operator) && precedence >= min_precedence {
                    source = skip_whitespace(&source[operator.len()..]);
                    let (right, rest) = Self::parse_expr(source, precedence + 1)?;
                    predicate = constructor(predicate, right)?;
                    source = rest;
                    continue 'parse;
                }
            }
            break;
        }

        Ok((predicate, source))
    }

    fn parse_primary(mut source: &str) -> anyhow::Result<(Self, &str)> {
        let next = source.chars().next().context("unexpected end")?;
        match next {
            '(' => {
                source = skip_whitespace(&source[1..]);
                let (predicate, rest) = Self::parse_expr(source, 0)?;
                let stripped = rest.strip_prefix(')').context("expected a ')'")?;
                source = skip_whitespace(stripped);
                Ok((predicate, source))
            }
            '!' => {
                let source = skip_whitespace(&source[1..]);
                let (predicate, source) = Self::parse_expr(source, PRECEDENCE_NOT)?;
                Ok((KeyBindingContextPredicate::Not(Box::new(predicate)), source))
            }
            _ if is_identifier_char(next) => {
                let len = source
                    .find(|c: char| !is_identifier_char(c) && !is_vim_operator_char(c))
                    .unwrap_or(source.len());
                let (identifier, rest) = source.split_at(len);
                source = skip_whitespace(rest);
                Ok((
                    KeyBindingContextPredicate::Identifier(identifier.to_string().into()),
                    source,
                ))
            }
            _ if is_vim_operator_char(next) => {
                let (operator, rest) = source.split_at(1);
                source = skip_whitespace(rest);
                Ok((
                    KeyBindingContextPredicate::Identifier(operator.to_string().into()),
                    source,
                ))
            }
            _ => anyhow::bail!("unexpected character '{next:?}'"),
        }
    }

    fn new_or(self, other: Self) -> Result<Self> {
        Ok(Self::Or(Box::new(self), Box::new(other)))
    }

    fn new_and(self, other: Self) -> Result<Self> {
        Ok(Self::And(Box::new(self), Box::new(other)))
    }

    fn new_child(self, other: Self) -> Result<Self> {
        Ok(Self::Descendant(Box::new(self), Box::new(other)))
    }

    fn new_eq(self, other: Self) -> Result<Self> {
        if let (Self::Identifier(left), Self::Identifier(right)) = (self, other) {
            Ok(Self::Equal(left, right))
        } else {
            anyhow::bail!("operands of == must be identifiers");
        }
    }

    fn new_neq(self, other: Self) -> Result<Self> {
        if let (Self::Identifier(left), Self::Identifier(right)) = (self, other) {
            Ok(Self::NotEqual(left, right))
        } else {
            anyhow::bail!("operands of != must be identifiers");
        }
    }

    fn fmt_joined(
        &self,
        f: &mut fmt::Formatter<'_>,
        separator: &str,
        operator: LogicalOperator,
        needs_parens: impl Fn(&Self) -> bool + Copy,
    ) -> fmt::Result {
        let mut first = true;
        self.fmt_joined_inner(f, separator, operator, needs_parens, &mut first)
    }

    fn fmt_joined_inner(
        &self,
        f: &mut fmt::Formatter<'_>,
        separator: &str,
        operator: LogicalOperator,
        needs_parens: impl Fn(&Self) -> bool + Copy,
        first: &mut bool,
    ) -> fmt::Result {
        match (operator, self) {
            (LogicalOperator::And, Self::And(left, right))
            | (LogicalOperator::Or, Self::Or(left, right)) => {
                left.fmt_joined_inner(f, separator, operator, needs_parens, first)?;
                right.fmt_joined_inner(f, separator, operator, needs_parens, first)
            }
            (_, node) => {
                if !*first {
                    f.write_str(separator)?;
                }
                *first = false;

                if needs_parens(node) {
                    write!(f, "({node})")
                } else {
                    write!(f, "{node}")
                }
            }
        }
    }
}

#[derive(Clone, Copy)]
enum LogicalOperator {
    And,
    Or,
}

const PRECEDENCE_CHILD: u32 = 1;
const PRECEDENCE_OR: u32 = 2;
const PRECEDENCE_AND: u32 = 3;
const PRECEDENCE_EQ: u32 = 4;
const PRECEDENCE_NOT: u32 = 5;

fn is_identifier_char(c: char) -> bool {
    c.is_alphanumeric() || c == '_' || c == '-'
}

fn is_vim_operator_char(c: char) -> bool {
    c == '>' || c == '<' || c == '~' || c == '"' || c == '?'
}

fn skip_whitespace(source: &str) -> &str {
    let len = source
        .find(|c: char| !c.is_whitespace())
        .unwrap_or(source.len());
    &source[len..]
}

#[cfg(test)]
mod tests {
    use core::slice;

    use super::*;
    use crate as gpui;
    use KeyBindingContextPredicate::*;

    #[test]
    fn test_actions_definition() {
        {
            actions!(test_only, [A, B, C, D, E, F, G]);
        }

        {
            actions!(
                test_only,
                [
                    H, I, J, K, L, M, N, // Don't wrap, test the trailing comma
                ]
            );
        }
    }

    #[test]
    fn test_parse_context() {
        let mut expected = KeyContext::default();
        expected.add("baz");
        expected.set("foo", "bar");
        assert_eq!(KeyContext::parse("baz foo=bar").unwrap(), expected);
        assert_eq!(KeyContext::parse("baz foo = bar").unwrap(), expected);
        assert_eq!(
            KeyContext::parse("  baz foo   =   bar baz").unwrap(),
            expected
        );
        assert_eq!(KeyContext::parse(" baz foo = bar").unwrap(), expected);
    }

    #[test]
    fn malformed_context_returns_an_error() {
        for source in [
            ".",
            "Editor && enabled",
            "mode=",
            "=insert",
            "mode==insert",
            "mode=\"insert\"",
        ] {
            assert!(KeyContext::parse(source).is_err(), "accepted {source:?}");
        }
        assert!(KeyContext::parse(" \n ").unwrap().is_empty());
        assert_eq!(
            KeyContext::parse("mode=insert mode=normal")
                .unwrap()
                .get("mode")
                .unwrap(),
            "insert"
        );
    }

    #[test]
    fn test_parse_identifiers() {
        // Identifiers
        assert_eq!(
            KeyBindingContextPredicate::parse("abc12").unwrap(),
            Identifier("abc12".into())
        );
        assert_eq!(
            KeyBindingContextPredicate::parse("_1a").unwrap(),
            Identifier("_1a".into())
        );
    }

    #[test]
    fn test_parse_negations() {
        assert_eq!(
            KeyBindingContextPredicate::parse("!abc").unwrap(),
            Not(Box::new(Identifier("abc".into())))
        );
        assert_eq!(
            KeyBindingContextPredicate::parse(" ! ! abc").unwrap(),
            Not(Box::new(Not(Box::new(Identifier("abc".into())))))
        );
    }

    #[test]
    fn test_parse_equality_operators() {
        assert_eq!(
            KeyBindingContextPredicate::parse("a == b").unwrap(),
            Equal("a".into(), "b".into())
        );
        assert_eq!(
            KeyBindingContextPredicate::parse("c!=d").unwrap(),
            NotEqual("c".into(), "d".into())
        );
        assert_eq!(
            KeyBindingContextPredicate::parse("c == !d")
                .unwrap_err()
                .to_string(),
            "operands of == must be identifiers"
        );
    }

    #[test]
    fn test_parse_boolean_operators() {
        assert_eq!(
            KeyBindingContextPredicate::parse("a || b").unwrap(),
            Or(
                Box::new(Identifier("a".into())),
                Box::new(Identifier("b".into()))
            )
        );
        assert_eq!(
            KeyBindingContextPredicate::parse("a || !b && c").unwrap(),
            Or(
                Box::new(Identifier("a".into())),
                Box::new(And(
                    Box::new(Not(Box::new(Identifier("b".into())))),
                    Box::new(Identifier("c".into()))
                ))
            )
        );
        assert_eq!(
            KeyBindingContextPredicate::parse("a && b || c&&d").unwrap(),
            Or(
                Box::new(And(
                    Box::new(Identifier("a".into())),
                    Box::new(Identifier("b".into()))
                )),
                Box::new(And(
                    Box::new(Identifier("c".into())),
                    Box::new(Identifier("d".into()))
                ))
            )
        );
        assert_eq!(
            KeyBindingContextPredicate::parse("a == b && c || d == e && f").unwrap(),
            Or(
                Box::new(And(
                    Box::new(Equal("a".into(), "b".into())),
                    Box::new(Identifier("c".into()))
                )),
                Box::new(And(
                    Box::new(Equal("d".into(), "e".into())),
                    Box::new(Identifier("f".into()))
                ))
            )
        );
        assert_eq!(
            KeyBindingContextPredicate::parse("a && b && c && d").unwrap(),
            And(
                Box::new(And(
                    Box::new(And(
                        Box::new(Identifier("a".into())),
                        Box::new(Identifier("b".into()))
                    )),
                    Box::new(Identifier("c".into())),
                )),
                Box::new(Identifier("d".into()))
            ),
        );
    }

    #[test]
    fn test_parse_parenthesized_expressions() {
        assert_eq!(
            KeyBindingContextPredicate::parse("a && (b == c || d != e)").unwrap(),
            And(
                Box::new(Identifier("a".into())),
                Box::new(Or(
                    Box::new(Equal("b".into(), "c".into())),
                    Box::new(NotEqual("d".into(), "e".into())),
                )),
            ),
        );
        assert_eq!(
            KeyBindingContextPredicate::parse(" ( a || b ) ").unwrap(),
            Or(
                Box::new(Identifier("a".into())),
                Box::new(Identifier("b".into())),
            )
        );
    }

    #[test]
    fn test_is_superset() {
        assert_is_superset("editor", "editor", true);
        assert_is_superset("editor", "workspace", false);

        assert_is_superset("editor", "editor && vim_mode", true);
        assert_is_superset("editor", "mode == full && editor", true);
        assert_is_superset("editor && mode == full", "editor", false);

        assert_is_superset("editor", "something > editor", true);
        assert_is_superset("editor", "editor > menu", false);

        assert_is_superset("foo || bar || baz", "bar", true);
        assert_is_superset("foo || bar || baz", "quux", false);

        #[track_caller]
        fn assert_is_superset(a: &str, b: &str, result: bool) {
            let a = KeyBindingContextPredicate::parse(a).unwrap();
            let b = KeyBindingContextPredicate::parse(b).unwrap();
            assert_eq!(a.is_superset(&b), result, "({a:?}).is_superset({b:?})");
        }
    }

    #[test]
    fn test_child_operator() {
        let predicate = KeyBindingContextPredicate::parse("parent > child").unwrap();

        let parent_context = KeyContext::try_from("parent").unwrap();
        let child_context = KeyContext::try_from("child").unwrap();

        let contexts = vec![parent_context.clone(), child_context.clone()];
        assert!(predicate.eval(&contexts));

        let grandparent_context = KeyContext::try_from("grandparent").unwrap();

        let contexts = vec![
            grandparent_context,
            parent_context.clone(),
            child_context.clone(),
        ];
        assert!(predicate.eval(&contexts));

        let other_context = KeyContext::try_from("other").unwrap();

        let contexts = vec![other_context.clone(), child_context.clone()];
        assert!(!predicate.eval(&contexts));

        let contexts = vec![parent_context.clone(), other_context, child_context.clone()];
        assert!(predicate.eval(&contexts));

        assert!(!predicate.eval(&[]));
        assert!(!predicate.eval(slice::from_ref(&child_context)));
        assert!(!predicate.eval(&[parent_context]));

        let zany_predicate = KeyBindingContextPredicate::parse("child > child").unwrap();
        assert!(!zany_predicate.eval(slice::from_ref(&child_context)));
        assert!(zany_predicate.eval(&[child_context.clone(), child_context]));
    }

    #[test]
    fn test_not_operator() {
        let not_predicate = KeyBindingContextPredicate::parse("!editor").unwrap();
        let editor_context = KeyContext::try_from("editor").unwrap();
        let workspace_context = KeyContext::try_from("workspace").unwrap();
        let parent_context = KeyContext::try_from("parent").unwrap();
        let child_context = KeyContext::try_from("child").unwrap();

        assert!(not_predicate.eval(slice::from_ref(&workspace_context)));
        assert!(!not_predicate.eval(slice::from_ref(&editor_context)));
        assert!(!not_predicate.eval(&[editor_context.clone(), workspace_context.clone()]));
        assert!(!not_predicate.eval(&[workspace_context.clone(), editor_context.clone()]));

        let complex_not = KeyBindingContextPredicate::parse("!editor && workspace").unwrap();
        assert!(complex_not.eval(slice::from_ref(&workspace_context)));
        assert!(!complex_not.eval(&[editor_context.clone(), workspace_context.clone()]));

        let not_mode_predicate = KeyBindingContextPredicate::parse("!(mode == full)").unwrap();
        let mut mode_context = KeyContext::default();
        mode_context.set("mode", "full");
        assert!(!not_mode_predicate.eval(&[mode_context.clone()]));

        let mut other_mode_context = KeyContext::default();
        other_mode_context.set("mode", "partial");
        assert!(not_mode_predicate.eval(&[other_mode_context]));

        let not_descendant = KeyBindingContextPredicate::parse("!(parent > child)").unwrap();
        assert!(not_descendant.eval(slice::from_ref(&parent_context)));
        assert!(not_descendant.eval(slice::from_ref(&child_context)));
        assert!(!not_descendant.eval(&[parent_context.clone(), child_context.clone()]));

        let not_descendant = KeyBindingContextPredicate::parse("parent > !child").unwrap();
        assert!(!not_descendant.eval(slice::from_ref(&parent_context)));
        assert!(!not_descendant.eval(slice::from_ref(&child_context)));
        assert!(!not_descendant.eval(&[parent_context, child_context]));

        let double_not = KeyBindingContextPredicate::parse("!!editor").unwrap();
        assert!(double_not.eval(slice::from_ref(&editor_context)));
        assert!(!double_not.eval(slice::from_ref(&workspace_context)));

        // Test complex descendant cases
        let workspace_context = KeyContext::try_from("Workspace").unwrap();
        let pane_context = KeyContext::try_from("Pane").unwrap();
        let editor_context = KeyContext::try_from("Editor").unwrap();

        // Workspace > Pane > Editor
        let workspace_pane_editor = vec![
            workspace_context.clone(),
            pane_context.clone(),
            editor_context.clone(),
        ];

        // Pane > (Pane > Editor) - should not match
        let pane_pane_editor = KeyBindingContextPredicate::parse("Pane > (Pane > Editor)").unwrap();
        assert!(!pane_pane_editor.eval(&workspace_pane_editor));

        let workspace_pane_editor_predicate =
            KeyBindingContextPredicate::parse("Workspace > Pane > Editor").unwrap();
        assert!(workspace_pane_editor_predicate.eval(&workspace_pane_editor));

        // (Pane > Pane) > Editor - should not match
        let pane_pane_then_editor =
            KeyBindingContextPredicate::parse("(Pane > Pane) > Editor").unwrap();
        assert!(!pane_pane_then_editor.eval(&workspace_pane_editor));

        // Pane > !Workspace - should match
        let pane_not_workspace = KeyBindingContextPredicate::parse("Pane > !Workspace").unwrap();
        assert!(pane_not_workspace.eval(&[pane_context.clone(), editor_context.clone()]));
        assert!(!pane_not_workspace.eval(&[pane_context.clone(), workspace_context.clone()]));

        // !Workspace - shouldn't match when Workspace is in the context
        let not_workspace = KeyBindingContextPredicate::parse("!Workspace").unwrap();
        assert!(!not_workspace.eval(slice::from_ref(&workspace_context)));
        assert!(not_workspace.eval(slice::from_ref(&pane_context)));
        assert!(not_workspace.eval(slice::from_ref(&editor_context)));
        assert!(!not_workspace.eval(&workspace_pane_editor));
    }

    // MARK: - Display

    #[test]
    fn test_context_display() {
        fn ident(s: &str) -> Box<KeyBindingContextPredicate> {
            Box::new(Identifier(SharedString::new(s)))
        }
        fn eq(a: &str, b: &str) -> Box<KeyBindingContextPredicate> {
            Box::new(Equal(SharedString::new(a), SharedString::new(b)))
        }
        fn not_eq(a: &str, b: &str) -> Box<KeyBindingContextPredicate> {
            Box::new(NotEqual(SharedString::new(a), SharedString::new(b)))
        }
        fn and(
            a: Box<KeyBindingContextPredicate>,
            b: Box<KeyBindingContextPredicate>,
        ) -> Box<KeyBindingContextPredicate> {
            Box::new(And(a, b))
        }
        fn or(
            a: Box<KeyBindingContextPredicate>,
            b: Box<KeyBindingContextPredicate>,
        ) -> Box<KeyBindingContextPredicate> {
            Box::new(Or(a, b))
        }
        fn descendant(
            a: Box<KeyBindingContextPredicate>,
            b: Box<KeyBindingContextPredicate>,
        ) -> Box<KeyBindingContextPredicate> {
            Box::new(Descendant(a, b))
        }
        fn not(a: Box<KeyBindingContextPredicate>) -> Box<KeyBindingContextPredicate> {
            Box::new(Not(a))
        }

        let test_cases = [
            (ident("a"), "a"),
            (eq("a", "b"), "a == b"),
            (not_eq("a", "b"), "a != b"),
            (descendant(ident("a"), ident("b")), "a > b"),
            (not(ident("a")), "!a"),
            (not_eq("a", "b"), "a != b"),
            (descendant(ident("a"), ident("b")), "a > b"),
            (not(and(ident("a"), ident("b"))), "!(a && b)"),
            (not(or(ident("a"), ident("b"))), "!(a || b)"),
            (and(ident("a"), ident("b")), "a && b"),
            (and(and(ident("a"), ident("b")), ident("c")), "a && b && c"),
            (or(ident("a"), ident("b")), "a || b"),
            (or(or(ident("a"), ident("b")), ident("c")), "a || b || c"),
            (or(ident("a"), and(ident("b"), ident("c"))), "a || (b && c)"),
            (
                and(
                    and(
                        and(ident("a"), eq("b", "c")),
                        not(descendant(ident("d"), ident("e"))),
                    ),
                    eq("f", "g"),
                ),
                "a && b == c && !(d > e) && f == g",
            ),
            (
                and(and(ident("a"), or(ident("b"), ident("c"))), ident("d")),
                "a && (b || c) && d",
            ),
            (
                or(or(ident("a"), and(ident("b"), ident("c"))), ident("d")),
                "a || (b && c) || d",
            ),
        ];

        for (predicate, expected) in test_cases {
            let actual = predicate.to_string();
            assert_eq!(actual, expected);
            let parsed = KeyBindingContextPredicate::parse(&actual).unwrap();
            assert_eq!(parsed, *predicate);
        }
    }
}
