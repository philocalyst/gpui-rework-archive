//! Bounded rectangle-only producer experiment. All indices remain checked.
use super::*;
use crate::{
    element::DraftNode,
    local_component::{Mode, Origin, Report},
};
use gpui_reactivity_state::Revision;

#[derive(Clone, Copy)]
pub(super) struct Seed {
    key: usize,
    scope: u32,
    start: usize,
    end: usize,
    input: Option<Revision>,
}
#[derive(Clone, Copy)]
struct Certificate {
    seed: Seed,
    namespace: NonZeroU64,
    root: u64,
    parent: u64,
    token: PresentationToken,
    epoch: u64,
}
#[derive(Default)]
pub(super) struct State {
    pub mode: Mode,
    pub report: Report,
    pending: Option<Seed>,
    committed: Option<Certificate>,
    local_staged: bool,
}
impl State {
    pub fn reset_report(&mut self) {
        self.report = Report {
            mode: self.mode,
            state_header_bytes: size_of::<Self>(),
            ..Report::default()
        };
        self.local_staged = false;
    }
    pub fn revoke(&mut self) {
        self.pending = None;
        self.committed = None;
        self.local_staged = false;
        self.report.certificate_live = false;
    }
    pub fn pending(&mut self, seed: Option<Seed>) {
        self.pending = seed;
        self.committed = None;
    }
    pub fn commit(
        &mut self,
        nodes: &[Node],
        namespace: NonZeroU64,
        token: Option<PresentationToken>,
        epoch: u64,
    ) {
        let Some(seed) = self.pending.take() else {
            return;
        };
        let Some(token) = token else {
            self.revoke();
            return;
        };
        let Some(node) = nodes.get(seed.start) else {
            self.revoke();
            return;
        };
        let Some(parent) = node.parent().index().and_then(|index| nodes.get(index)) else {
            self.revoke();
            return;
        };
        self.committed = Some(Certificate {
            seed,
            namespace,
            root: node.identity(),
            parent: parent.identity(),
            token,
            epoch,
        });
        self.report.certificate_live = true;
        self.report.admitted = self.local_staged;
        self.local_staged = false;
    }
}

pub(super) fn probe<M: 'static>(
    sources: &Sources<M>,
    model: &M,
    drafts: &[DraftNode<'_>],
    plain_columns: bool,
    state: &mut State,
) -> Result<Option<Seed>, Error> {
    state.report.full_drafts = drafts.len();
    let mut root = None;
    let mut scopes = 0;
    let mut supported = plain_columns;
    for (index, draft) in drafts.iter().enumerate() {
        state.report.full_occurrence_visits += 1;
        supported &= draft.kind == NodeKind::Div
            && draft.text.is_none()
            && draft.on_click.is_none()
            && draft.component_depth <= 1;
        scopes += usize::from(draft.components.scope().is_some());
        if draft.local_recipe != 0 {
            if root.is_some() {
                supported = false;
            }
            root = Some(index);
        }
    }
    let Some(start) = root.filter(|_| supported && scopes == 1) else {
        return Ok(None);
    };
    if drafts[start].parent != Some(0) {
        return Ok(None);
    }
    let mut end = start + 1;
    while end < drafts.len() {
        state.report.extent_visits += 1;
        if !drafts[end]
            .parent
            .is_some_and(|parent| parent as usize >= start)
        {
            break;
        }
        end += 1;
    }
    for recipe in sources.local_replays() {
        state.report.recipe_entries_examined += 1;
        if recipe.key() == drafts[start].local_recipe {
            let scope = recipe.scope(sources)?;
            if drafts[start].components.scope() != Some(scope) {
                return Ok(None);
            }
            return Ok(Some(Seed {
                key: recipe.key(),
                scope,
                start,
                end,
                input: recipe.stamp(model, sources)?,
            }));
        }
    }
    Ok(None)
}

impl<M: View + 'static> Runtime<M> {
    pub(super) fn try_local_replay(&mut self, field: FieldId) -> Result<bool, Error> {
        self.local.report.fallback = "authority-or-scope";
        if self.local.mode == Mode::FullRoot {
            self.local.report.fallback = "forced-full-root";
            return Ok(false);
        }
        let Some(cert) = self.local.committed else {
            return Ok(false);
        };
        let Seed {
            key,
            scope,
            start,
            end,
            input,
        } = cert.seed;
        if field.local_scope() != scope
            || !self.logical_valid
            || self.dirty
            || self.rebuild_layout
            || self.complete_epoch.checked_add(1) != Some(self.source_epoch)
            || cert.epoch != self.complete_epoch
            || self.latest_token != Some(cert.token)
            || cert.namespace != self.sites.namespace()
            || end > self.nodes.len()
            || start >= end
            || self.nodes[start].identity() != cert.root
            || self.nodes[start].component_scope != scope
            || self.nodes[start].parent().index() != Some(0)
            || self.nodes[0].identity() != cert.parent
        {
            self.local.revoke();
            return Ok(false);
        }
        self.local.report.fallback = "unsupported-retained-scene";
        if !self.fanout.is_empty()
            || !self.texts.is_empty()
            || self.images.is_some()
            || self.handlers.is_some()
            || self.metadata.is_some()
            || !self.overrides.is_empty()
            || !self.viewports.is_empty()
            || !self.list_rows.is_empty()
            || matches!(self.styles, styles::Styles::Colors(_))
        {
            self.local.revoke();
            return Ok(false);
        }
        for (index, node) in self.nodes.iter().enumerate() {
            self.local.report.old_plain_visits += 1;
            if node.kind() != NodeKind::Div
                || node.has_handler()
                || (node.component_scope != 0 && index != start)
            {
                self.local.revoke();
                return Ok(false);
            }
        }
        self.sources.validate(&mut self.model)?;
        self.local.report.source_schema_validations += 1;
        let mut selected = None;
        for recipe in self.sources.local_replays() {
            self.local.report.recipe_entries_examined += 1;
            if recipe.key() == key {
                selected = Some(recipe);
                break;
            }
        }
        let Some(recipe) = selected else {
            self.local.revoke();
            return Ok(false);
        };
        if recipe.scope(&self.sources)? != scope
            || recipe.stamp(&self.model, &self.sources)? != input
        {
            self.local.revoke();
            return Ok(false);
        }
        let el = if self.local.mode == Mode::OmitCallerMutant {
            recipe.render_without_caller(&self.model)
        } else {
            recipe.render(&self.model)
        };
        let mut description = el.flatten_lists(MAX_NODES, &(), |_, _, _, _, _, _, _| {
            Err(ListError::MissingViewport.into())
        })?;
        self.local.report.local_drafts = description.nodes.len();
        self.local.report.local_draft_capacity_bytes =
            description.nodes.capacity() * size_of::<DraftNode<'_>>();
        let mut supported = description.backgrounds.is_empty()
            && description.geometry.is_empty()
            && description.style_ports.is_empty()
            && description.mapped_ports.is_empty()
            && description.viewports.is_empty()
            && description.annotations.is_empty()
            && description.images.is_empty();
        for (index, draft) in description.nodes.iter_mut().enumerate() {
            supported &= draft.kind == NodeKind::Div
                && draft.text.is_none()
                && draft.on_click.is_none()
                && draft.component_depth == usize::from(index == 0)
                && draft.local_recipe == 0;
            draft.components.admit(&self.model, &self.sources)?;
            supported &= draft.components.scope() == (index == 0).then_some(scope);
        }
        if !supported
            || description.nodes.is_empty()
            || description.nodes[0].kind != self.nodes[start].kind()
        {
            self.local.report.fallback = "unsupported-new-description";
            self.local.revoke();
            return Ok(false);
        }
        let old_len = self.nodes.len();
        let count = description.nodes.len();
        let new_len = old_len - (end - start) + count;
        if new_len > MAX_NODES {
            return Err(Error::ResourceLimit);
        }
        self.next_identity
            .checked_add(count as u64)
            .ok_or(Error::EpochExhausted)?;
        let siblings = siblings::Siblings::new(&self.nodes);
        self.local.report.sibling_count_visits = old_len;
        self.local.report.sibling_prefix_visits = old_len + 1;
        self.local.report.sibling_address_visits = old_len;
        self.local.report.sibling_scratch_bytes = (old_len * 2 + 2) * size_of::<u32>();
        let mut counts = vec![0usize; count];
        self.local.report.new_counts_scratch_bytes = counts.capacity() * size_of::<usize>();
        for draft in &description.nodes {
            self.local.report.new_child_count_visits += 1;
            if let Some(parent) = draft.parent {
                counts[parent as usize] += 1;
            }
        }
        let mut replacements: Vec<Node> = Vec::with_capacity(count);
        let mut new_styles = Vec::with_capacity(new_len);
        for index in 0..start {
            new_styles.push(self.styles.get(index));
        }
        let mut origin = Origin {
            predecessor_epoch: cert.epoch,
            new_epoch: self.source_epoch,
            namespace: cert.namespace.get(),
            root_identity: cert.root,
            parent_identity: cert.parent,
            old_range: [start, end],
            new_range: [start, start + count],
            correspondence: Vec::with_capacity(count),
        };
        let mut changed = 0;
        for (rank, draft) in description.nodes.into_iter().enumerate() {
            let parent = draft.parent.map(|index| index as usize);
            let ordinal = if rank == 0 {
                self.nodes[start].ordinal()
            } else if parent == Some(rank - 1) {
                0
            } else {
                let mut sibling = rank - 1;
                while replacements[sibling].parent().index() != parent.map(|p| start + p) {
                    sibling = replacements[sibling]
                        .parent()
                        .index()
                        .expect("validated local preorder")
                        - start;
                    self.local.report.ordinal_unwinds += 1;
                }
                replacements[sibling].ordinal() + 1
            };
            let old_rank = if rank == 0 {
                Some(start)
            } else {
                let parent_rank = parent.expect("single local root");
                self.by_identity
                    .get(replacements[parent_rank].identity())
                    .and_then(|old_parent| {
                        let old_children = siblings.children(Parent::new(Some(old_parent)));
                        (old_children.len() == counts[parent_rank])
                            .then(|| old_children.get(ordinal as usize).copied())
                            .flatten()
                    })
                    .map(|index| index as usize)
                    .filter(|&index| {
                        index >= start
                            && index < end
                            && self.nodes[index].kind().site_kind() == draft.kind.site_kind()
                            && self.nodes[index].component_scope == 0
                    })
            };
            let identity = if let Some(old_rank) = old_rank {
                self.local.report.matched_records += 1;
                if !styles::exact_eq(&self.styles.get(old_rank), &draft.style) {
                    changed += 1;
                }
                self.nodes[old_rank].identity
            } else {
                self.local.report.reminted_records += 1;
                changed += 1;
                let id = NonZeroU64::new(self.next_identity).expect("reserved identity");
                self.next_identity += 1;
                id
            };
            origin.correspondence.push((rank, old_rank, identity.get()));
            replacements.push(Node {
                identity,
                links: links::NodeLinks::new(parent.map(|p| start + p).or(Some(0)), ordinal, None),
                content: Content::new(draft.kind, TextSlot::NONE),
                component_scope: if rank == 0 { scope } else { 0 },
            });
            new_styles.push(draft.style);
        }
        for index in end..old_len {
            new_styles.push(self.styles.get(index));
        }
        self.local.report.replacement_records_written = count;
        self.local.report.old_style_payload_bytes = style_bytes(&self.styles);
        self.local.report.old_identity_index_bytes = index_bytes(&self.by_identity);
        self.local.report.replacement_capacity_bytes = replacements.capacity() * size_of::<Node>();
        self.local.report.correspondence_capacity_bytes =
            origin.correspondence.capacity() * size_of::<(usize, Option<usize>, u64)>();
        let mut nodes = Vec::with_capacity(new_len);
        self.local.report.node_old_capacity_bytes = self.nodes.capacity() * size_of::<Node>();
        let mut old = std::mem::take(&mut self.nodes).into_iter();
        for _ in 0..start {
            nodes.push(old.next().expect("prefix"));
        }
        for _ in start..end {
            drop(old.next().expect("old subtree"));
        }
        nodes.extend(replacements);
        for mut node in old {
            self.local.report.parent_rank_checks += 1;
            if let Some(parent) = node.parent().index().filter(|&p| p >= end) {
                node.links = links::NodeLinks::new(
                    Some(parent - (end - start) + count),
                    node.ordinal(),
                    None,
                );
                self.local.report.parent_rank_rewrites += 1;
            }
            nodes.push(node);
        }
        self.local.report.old_nodes_consumed = old_len;
        self.local.report.node_records_written = new_len;
        self.local.report.node_payload_written_bytes = new_len * size_of::<Node>();
        self.local.report.node_new_capacity_bytes = nodes.capacity() * size_of::<Node>();
        self.local.report.style_records_written = new_len;
        self.local.report.style_payload_written_bytes = new_len * size_of::<Style>();
        self.local.report.style_new_capacity_bytes = new_styles.capacity() * size_of::<Style>();
        let mut depth = 0usize;
        let mut max_depth = 0;
        for index in 0..nodes.len() {
            self.local.report.depth_visits += 1;
            if index != 0 {
                if nodes[index].parent().index() == Some(index - 1) {
                    depth += 1;
                } else {
                    let mut preceding = index - 1;
                    while nodes[preceding].parent().index() != nodes[index].parent().index() {
                        preceding = nodes[preceding]
                            .parent()
                            .index()
                            .expect("admitted single root");
                        depth -= 1;
                        self.local.report.depth_unwinds += 1;
                    }
                }
            }
            if depth > MAX_LAYOUT_DEPTH {
                return Err(Error::DepthLimit { node: index });
            }
            max_depth = max_depth.max(depth);
        }
        self.local.report.identity_index_inputs = new_len;
        self.by_identity = IdentityIndex::from_ids(nodes.iter().map(Node::identity));
        self.local.report.identity_index_bytes = index_bytes(&self.by_identity);
        self.nodes = nodes;
        self.styles = styles::Styles::Dense(new_styles);
        self.layout_depth = max_depth as u8;
        // Conservatively force the existing full layout/paint closure, even for
        // same-shape replay. This experiment does not authorize layout reuse.
        self.topology_changed = true;
        self.dirty = true;
        self.changed_nodes = changed + (end - start - self.local.report.matched_records);
        self.local.pending(Some(Seed {
            end: start + count,
            ..cert.seed
        }));
        self.local.local_staged = true;
        self.local.report.origin = Some(origin);
        self.local.report.fallback = "none";
        Ok(true)
    }
}

impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    pub fn set_local_replay_mode(&mut self, mode: Mode) -> Result<(), Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.local.mode = mode;
        // The full-root control never uses its retained certificate. Changing
        // back to replay requires a new full description, rather than revival.
        if mode == Mode::Replay {
            runtime.local.revoke();
        }
        Ok(())
    }
    pub fn revoke_local_replay(&mut self) -> Result<(), Error> {
        self.runtime_mut()?.local.revoke();
        Ok(())
    }
    pub fn local_replay_report(&self) -> Result<Report, Error> {
        let runtime = self.runtime()?;
        let mut report = runtime.local.report.clone();
        report.mode = runtime.local.mode;
        report.certificate_live = runtime.logical_valid && runtime.local.committed.is_some();
        report.state_header_bytes = size_of::<State>();
        Ok(report)
    }
}

fn style_bytes(styles: &styles::Styles) -> usize {
    match styles {
        styles::Styles::Default => 0,
        styles::Styles::Dense(v) => v.capacity() * size_of::<Style>(),
        styles::Styles::Shared { palette, indices } => {
            size_of_val(palette.as_ref()) + size_of_val(indices.as_ref())
        }
        styles::Styles::Colors(_) => 0, // Never admitted; no color storage claim.
    }
}
fn index_bytes(index: &IdentityIndex) -> usize {
    match index {
        IdentityIndex::Contiguous { .. } => 0,
        IdentityIndex::Runs(runs) => size_of_val(runs.as_ref()),
        IdentityIndex::Indexed(entries) => size_of_val(entries.as_ref()),
    }
}
