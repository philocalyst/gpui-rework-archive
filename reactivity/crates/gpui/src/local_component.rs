//! Non-shipping single-region description experiment. No implicit legacy opt-in.
//!
//! Registering a descriptor promises that an exact child edit changes only this
//! one description hole. Parent/sibling descriptions, placement and recipe must
//! be independent of that child; child description is read-only/deterministic.
//! Mutable external inputs must be declared owner sources. False promises cannot
//! generally be detected. They never grant unchecked memory access.
use crate::{Component, El, Source, Sources, View, source::BindError};
use gpui_reactivity_state::Revision;

/// Closed caller write intent, including the difference between no write and
/// an explicit setter equal to the child's current value.
pub enum WidthInput<P> {
    Absent,
    Literal(f64),
    Optional(Source<P, Option<f64>>),
}
impl<P> Copy for WidthInput<P> {}
impl<P> Clone for WidthInput<P> {
    fn clone(&self) -> Self {
        *self
    }
}
pub struct RootRecipe<P> {
    width: WidthInput<P>,
}
impl<P> Copy for RootRecipe<P> {}
impl<P> Clone for RootRecipe<P> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<P> RootRecipe<P> {
    pub const fn width(width: WidthInput<P>) -> Self {
        Self { width }
    }
    fn value(self, parent: &P) -> Option<f64> {
        match self.width {
            WidthInput::Absent => None,
            WidthInput::Literal(value) => Some(value),
            WidthInput::Optional(source) => **source.local_recipe_read(parent),
        }
    }
    fn stamp(self, parent: &P, sources: &Sources<P>) -> Result<Option<Revision>, crate::Error> {
        let revision = match self.width {
            WidthInput::Optional(source) => {
                Some(source.borrow_registered(parent, sources)?.revision())
            }
            _ => None,
        };
        if let Some(width) = self.value(parent) {
            crate::style_port::Scalar::Number(width).admit(crate::property::PropertyId::Width)?;
        }
        Ok(revision)
    }
}

/// A static recipe descriptor, shared by registration and insertion. Static
/// descriptor identity is private recipe authority, never a semantic node ID.
pub struct LocalComponent<P, C> {
    pub(crate) component: Component<P, C>,
    recipe: RootRecipe<P>,
}
impl<P, C> LocalComponent<P, C> {
    pub const fn new(component: Component<P, C>, recipe: RootRecipe<P>) -> Self {
        Self { component, recipe }
    }
}
pub(crate) trait Replay<P> {
    fn key(&self) -> usize;
    fn scope(&self, sources: &Sources<P>) -> Result<u32, BindError>;
    fn stamp(&self, parent: &P, sources: &Sources<P>) -> Result<Option<Revision>, crate::Error>;
    fn render<'a>(&self, parent: &'a P) -> El<'a>;
    fn render_without_caller<'a>(&self, parent: &'a P) -> El<'a>;
}
impl<P: 'static, C: View + 'static> Replay<P> for LocalComponent<P, C> {
    fn key(&self) -> usize {
        std::ptr::from_ref(self) as usize
    }
    fn scope(&self, sources: &Sources<P>) -> Result<u32, BindError> {
        Ok(sources
            .component_entry::<C>(self.component.id())?
            .qualify_scope(0))
    }
    fn stamp(&self, parent: &P, sources: &Sources<P>) -> Result<Option<Revision>, crate::Error> {
        self.recipe.stamp(parent, sources)
    }
    fn render_without_caller<'a>(&self, parent: &'a P) -> El<'a> {
        self.component.view(parent)
    }
    fn render<'a>(&self, parent: &'a P) -> El<'a> {
        let child = self.component.view(parent);
        match self.recipe.value(parent) {
            Some(width) => child.w(width),
            None => child,
        }
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, serde::Serialize)]
pub enum Mode {
    #[default]
    Replay,
    FullRoot,
    /// Negative control: deliberately omit caller composition on replay only.
    OmitCallerMutant,
}

#[derive(Clone, Debug, Default, serde::Serialize)]
pub struct Origin {
    pub predecessor_epoch: u64,
    pub new_epoch: u64,
    pub namespace: u64,
    pub root_identity: u64,
    pub parent_identity: u64,
    pub input_revision: Option<u32>,
    pub caller_replayed: bool,
    pub old_range: [usize; 2],
    pub new_range: [usize; 2],
    /// New local rank, old absolute rank, surviving/new semantic identity.
    pub correspondence: Vec<(usize, Option<usize>, u64)>,
}

#[derive(Clone, Debug, Default, serde::Serialize)]
pub struct FullWork {
    pub old_nodes: usize,
    pub old_node_capacity_bytes: usize,
    pub old_style_payload_bytes: Option<usize>,
    pub new_counts_bytes: usize,
    pub child_count_visits: usize,
    pub depth_unwinds: usize,
    pub ordinal_unwinds: usize,
    pub reconciled_nodes: usize,
    pub sibling_count_visits: usize,
    pub sibling_prefix_visits: usize,
    pub sibling_address_visits: usize,
    pub sibling_scratch_bytes: usize,
    pub old_key_scan_visits: usize,
    pub old_identity_scan_visits: usize,
    pub new_node_capacity_bytes: usize,
    pub new_style_payload_bytes: Option<usize>,
    pub identity_index_inputs: usize,
    pub identity_index_bytes: usize,
    pub fanout_groups: usize,
}
#[derive(Clone, Debug, Default, serde::Serialize)]
pub struct Report {
    pub full_work: FullWork,
    pub mode: Mode,
    pub admitted: bool,
    pub fallback: &'static str,
    pub certificate_live: bool,
    pub full_drafts: usize,
    pub full_occurrence_visits: usize,
    pub extent_visits: usize,
    pub new_counts_scratch_bytes: usize,
    pub replacement_records_written: usize,
    pub ordinal_unwinds: usize,
    pub old_style_payload_bytes: usize,
    pub old_identity_index_bytes: usize,
    pub identity_index_bytes: usize,
    pub local_drafts: usize,
    pub source_schema_validations: usize,
    pub recipe_entries_examined: usize,
    pub old_plain_visits: usize,
    pub sibling_count_visits: usize,
    pub sibling_prefix_visits: usize,
    pub sibling_address_visits: usize,
    pub sibling_scratch_bytes: usize,
    pub new_child_count_visits: usize,
    pub matched_records: usize,
    pub reminted_records: usize,
    pub old_nodes_consumed: usize,
    pub node_records_written: usize,
    pub node_payload_written_bytes: usize,
    pub parent_rank_checks: usize,
    pub parent_rank_rewrites: usize,
    pub style_records_written: usize,
    pub style_payload_written_bytes: usize,
    pub depth_visits: usize,
    pub depth_unwinds: usize,
    pub identity_index_inputs: usize,
    pub fanout_entries_examined: usize,
    pub node_old_capacity_bytes: usize,
    pub node_new_capacity_bytes: usize,
    pub style_new_capacity_bytes: usize,
    pub local_draft_capacity_bytes: usize,
    pub replacement_capacity_bytes: usize,
    pub correspondence_capacity_bytes: usize,
    pub state_header_bytes: usize,
    pub origin: Option<Origin>,
}
