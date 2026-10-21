//! Borrowed semantic queries over the acknowledged sheet, shared by tools and
//! application users. Queries never construct a diagnostic snapshot or mirror.
use super::{Actions, Error, Presented, Runtime, Target, View, Win};
use crate::identity::Sites;
use crate::{Rect, Role};

// One borrowed context on the visitor stack, not a context pointer or semantic
// mirror retained per node. Every part borrows this same acknowledged sheet.
struct Context<'a> {
    sites: &'a Sites,
    nodes: &'a [Presented],
    focused: Option<Target>,
}
impl<'a> Context<'a> {
    fn new<M>(runtime: &'a Runtime<M>) -> Self {
        Self {
            sites: &runtime.sites,
            nodes: &runtime.presented,
            focused: runtime.focused,
        }
    }
    fn part(&self, node: &'a Presented) -> Part<'_> {
        Part {
            node,
            context: self,
        }
    }
}

#[derive(Clone, Copy)]
/// Borrowed semantic data cannot outlive a visitor invocation.
///
/// ```compile_fail
/// use gpui::{El, View, Win, text};
/// struct Page;
/// impl View for Page { fn view(&self) -> El<'_> { text("page") } }
/// let win = Win::demo(Page);
/// let mut saved = None;
/// win.visit(|part| saved = part.text()).unwrap();
/// println!("{saved:?}");
/// ```
pub struct Part<'a> {
    node: &'a Presented,
    context: &'a Context<'a>,
}
impl<'a> Part<'a> {
    /// Stable window-qualified identity, also used by input and inspector APIs.
    /// Merely reading a target does not grant it a particular action.
    pub fn target(self) -> Target {
        self.context.sites.target(self.node.identity)
    }
    pub fn parent(self) -> Option<Target> {
        self.node.parent.map(|index| {
            self.context
                .sites
                .target(self.context.nodes[index].identity)
        })
    }
    /// Current interaction focus on this presented part. Structural/value and
    /// geometry data come from the acknowledged sheet; focus can change without
    /// a frame or source edit, and is revoked immediately on logical removal.
    pub fn focused(self) -> bool {
        self.context.focused == Some(self.target())
    }
    pub fn actions(self) -> Actions {
        self.node.actions
    }
    pub fn role(self) -> Role {
        self.node.kind.role()
    }
    pub fn text(self) -> Option<&'a str> {
        self.node.text.as_deref()
    }
    /// Accessible name for text-labelled controls. An input's edited value is
    /// deliberately not used as its name. Explicit input labels and described-by
    /// relationships require the separate semantic metadata integration.
    pub fn name(self) -> Option<&'a str> {
        (self.node.kind != super::NodeKind::Input)
            .then(|| self.text())
            .flatten()
    }
    pub fn value(self) -> Option<&'a str> {
        (self.node.kind == super::NodeKind::Input)
            .then(|| self.text())
            .flatten()
    }
    /// Physical viewport-clipped bounds of the acknowledged presentation.
    pub fn bounds(self) -> Rect {
        self.node.bounds
    }
    /// The canonical local rectangle before window/viewport clipping.
    pub fn local_bounds(self) -> Rect {
        self.node.rect
    }
    /// Absolute node-local to window-physical transform, already including
    /// ancestors and DPI. Applying it again as a parent transform is incorrect.
    pub fn transform(self) -> Option<crate::Affine> {
        self.node.transform
    }
    /// Conservative full window-physical bounds, derived only when requested.
    /// Native adapters add the window-to-screen mapping. This differs from
    /// `bounds()` for partially clipped elements and must not be used as a hit
    /// predicate. No second full rectangle is retained per semantic node.
    pub fn unclipped_bounds(self) -> Option<Rect> {
        self.node
            .transform
            .and_then(|map| gpui_reactivity_core::CoordinateSpace::new(map).bounds(self.node.rect))
    }
}

pub struct Query<'a, M: View + 'static> {
    runtime: Option<&'a Runtime<M>>,
    role: Option<Role>,
    text: Option<(&'a str, bool)>,
}
impl<'a, M: View + 'static> Query<'a, M> {
    pub fn text<'b>(self, text: &'b str) -> Query<'b, M>
    where
        'a: 'b,
    {
        Query {
            runtime: self.runtime,
            role: self.role,
            text: Some((text, false)),
        }
    }
    pub fn containing<'b>(self, text: &'b str) -> Query<'b, M>
    where
        'a: 'b,
    {
        Query {
            runtime: self.runtime,
            role: self.role,
            text: Some((text, true)),
        }
    }
    fn matches(&self, part: Part<'_>) -> bool {
        self.role.is_none_or(|role| part.role() == role)
            && self.text.is_none_or(|(text, contains)| {
                part.text().is_some_and(|actual| {
                    if contains {
                        actual.contains(text)
                    } else {
                        actual == text
                    }
                })
            })
    }
    /// Count the presented matches without minting target records.
    pub fn count(&self) -> Result<usize, Error> {
        let mut count = 0;
        let runtime = self.runtime.ok_or(Error::Closed)?;
        sheet(runtime)?;
        let context = Context::new(runtime);
        for node in &runtime.presented {
            count += usize::from(self.matches(context.part(node)));
        }
        Ok(count)
    }
    /// Resolve one unique live match. Ambiguity is an error, not first-match
    /// dispatch to a possibly different instance of a reusable component.
    pub fn one(&self) -> Result<Target, Error> {
        let runtime = self.runtime.ok_or(Error::Closed)?;
        runtime.live()?;
        runtime.current_presentation()?;
        let mut identity = 0;
        let mut count = 0;
        let context = Context::new(runtime);
        for node in &runtime.presented {
            if self.matches(context.part(node)) {
                count += 1;
                identity = node.identity;
            }
        }
        match count {
            0 => Err(Error::MissingElement),
            1 => Ok(runtime.sites.target(identity)),
            matches => Err(Error::AmbiguousElement { matches }),
        }
    }
}

fn sheet<M: View + 'static>(runtime: &Runtime<M>) -> Result<(), Error> {
    runtime.live()?;
    if runtime.presentation_valid {
        Ok(())
    } else {
        Err(Error::PresentationStale)
    }
}
impl<M: View + 'static> Win<M> {
    pub fn query(&self) -> Query<'_, M> {
        Query {
            runtime: self.inner.as_deref(),
            role: None,
            text: None,
        }
    }
    pub fn role(&self, role: Role) -> Query<'_, M> {
        Query {
            runtime: self.inner.as_deref(),
            role: Some(role),
            text: None,
        }
    }
    pub fn contains_text(&self, text: &str) -> Result<bool, Error> {
        Ok(self.query().containing(text).count()? != 0)
    }
    /// Visit a borrowed coherent semantic sheet, including an older sheet while
    /// accepted source edits await a successful presentation. Parts cannot escape
    /// this borrow. No target records or snapshot strings are allocated.
    pub fn visit(&self, mut visitor: impl FnMut(Part<'_>)) -> Result<(), Error> {
        let runtime = self.runtime()?;
        sheet(runtime)?;
        let context = Context::new(runtime);
        for node in &runtime.presented {
            visitor(context.part(node));
        }
        Ok(())
    }
    pub fn bounds(&self, target: Target) -> Result<Rect, Error> {
        let runtime = self.runtime()?;
        sheet(runtime)?;
        let identity = runtime.sites.resolve(target).ok_or(Error::StaleTarget)?;
        runtime
            .presented
            .iter()
            .find(|node| node.identity == identity)
            .map(|node| node.bounds)
            .ok_or(Error::StaleTarget)
    }
    pub fn filter_count(
        &self,
        mut predicate: impl FnMut(Part<'_>) -> bool,
    ) -> Result<usize, Error> {
        let mut count = 0;
        self.visit(|part| count += usize::from(predicate(part)))?;
        Ok(count)
    }
}
