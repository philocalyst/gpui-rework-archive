//! Focus and normalized keys belong to the ordinary exclusive window runtime.
use super::{Commit, Error, NodeKind, Runtime, Target, View, Win};

/// Committed text and a small portable key floor. Text inserts at the end and
/// backspace removes one Unicode scalar. Selection, IME and shortcuts are not
/// represented by this enum.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Key<'a> {
    /// Committed printable text; payloads containing control characters are ignored.
    Text(&'a str),
    Backspace,
    Tab,
    ReverseTab,
    Enter,
    Space,
}

impl<M: View + 'static> Win<M> {
    /// Focus a live logical control without using displayed coordinates. This
    /// remains available to repair text after a failed presentation.
    pub fn focus(&mut self, target: Target) -> Result<Commit, Error> {
        self.runtime_mut()?.focus(target)
    }
    pub fn clear_focus(&mut self) -> Result<Commit, Error> {
        let runtime = self.runtime_mut()?;
        runtime.focused = None;
        runtime.changed_nodes = 0;
        Ok(runtime.commit())
    }
    /// A removed control or quarantined owner has no focus. Reading focus does
    /// not mutate source state, mint an identity, or require a current frame.
    pub fn focused(&self) -> Result<Option<Target>, Error> {
        Ok(self.runtime()?.focused)
    }
    /// Use the same keyboard barrier as the native adapter. Tab requires current
    /// presented geometry; focused editing and activation use logical authority.
    pub fn key(&mut self, key: Key<'_>) -> Result<Commit, Error> {
        let runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.changed_nodes = 0;
        if matches!(key, Key::Tab | Key::ReverseTab) {
            return runtime.tab(matches!(key, Key::ReverseTab));
        }
        let Some(target) = runtime.focused else {
            return Ok(runtime.commit());
        };
        match key {
            Key::Text(text) if text.chars().any(char::is_control) => Ok(runtime.commit()),
            Key::Text(text) => runtime.edit_text(target, |value| value.push_str(text)),
            Key::Backspace => runtime.edit_text(target, |value| {
                value.pop();
            }),
            Key::Enter => runtime.activate(target),
            Key::Space => {
                let identity = runtime.resolve(target)?;
                if runtime.nodes[runtime.by_identity[&identity]].kind == NodeKind::Input {
                    runtime.edit_text(target, |value| value.push(' '))
                } else {
                    runtime.activate(target)
                }
            }
            Key::Tab | Key::ReverseTab => unreachable!(),
        }
    }
}

impl<M: View + 'static> Runtime<M> {
    fn focusable(&self, identity: u64) -> bool {
        self.by_identity.get(&identity).is_some_and(|&index| {
            let node = &self.nodes[index];
            matches!(node.kind, NodeKind::Input | NodeKind::Button) || node.handler.is_some()
        })
    }
    pub(super) fn focus(&mut self, target: Target) -> Result<Commit, Error> {
        self.live()?;
        let identity = self.resolve(target)?;
        if !self.focusable(identity) {
            return Err(Error::NotInteractive);
        }
        self.focused = Some(target);
        self.changed_nodes = 0;
        Ok(self.commit())
    }
    pub(super) fn prune_focus(&mut self) {
        if self.focused.is_some_and(|target| {
            self.resolve(target)
                .ok()
                .is_none_or(|identity| !self.focusable(identity))
        }) {
            self.focused = None;
        }
    }
    fn tab(&mut self, reverse: bool) -> Result<Commit, Error> {
        self.current_presentation()?;
        let current = self.focused.and_then(|target| self.resolve(target).ok());
        // Iterate the acknowledged sheet directly; no alternate focus registry
        // or allocation is needed, including when wrapping at either end.
        let mut first = None;
        let mut last = None;
        let mut before = None;
        let mut after = None;
        let mut passed = false;
        for node in &self.presented {
            if !self.focusable(node.identity) {
                continue;
            }
            first.get_or_insert(node.identity);
            last = Some(node.identity);
            if Some(node.identity) == current {
                passed = true;
            } else if !passed {
                before = Some(node.identity);
            } else if after.is_none() {
                after = Some(node.identity);
            }
        }
        let identity = if reverse {
            if current.is_some() {
                before.or(last)
            } else {
                last
            }
        } else if current.is_some() {
            after.or(first)
        } else {
            first
        };
        self.focused = identity.map(|identity| self.sites.target(identity));
        Ok(self.commit())
    }
}
