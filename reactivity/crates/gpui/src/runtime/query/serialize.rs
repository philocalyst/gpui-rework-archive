//! Serialization borrows the same presentation and getters as ordinary queries.
use super::{Context, Part, sheet};
use crate::{Actions, Error, Rect, View, Win, remote::LaneSet};
use serde::{
    Serialize, Serializer,
    ser::{SerializeSeq, SerializeStruct},
};

/// A borrowed, serializable semantic presentation. No strings, resources or
/// node records are cloned. Its borrow prevents editing/closing the owner until
/// serialization ends. It follows `Win::visit`, including old P while C is pending.
/// Focus is current interaction state; all structural values come from P.
///
/// Serialized target identities are process-local diagnostics. Target has no
/// Deserialize implementation and cannot regain authority from a file.
///
/// ```compile_fail
/// use gpui::{El, View, Win, text};
/// struct Page;
/// impl View for Page { fn view(&self) -> El<'_> { text("page") } }
/// let mut win = Win::demo(Page);
/// let snapshot = win.semantics().unwrap();
/// win.close();
/// snapshot.write_json(std::io::sink()).unwrap();
/// ```
#[derive(Serialize)]
pub struct SemanticSnapshot<'a> {
    schema_version: u32,
    source_epoch: u64,
    presentation_epoch: u64,
    presentation_valid: bool,
    prepared_epoch: Option<u64>,
    size: [u32; 2],
    requested_size: [u32; 2],
    scale_factor: f32,
    requested_scale_factor: f32,
    nodes: Context<'a>,
}
impl SemanticSnapshot<'_> {
    /// Stream directly to an application-owned writer. Writer errors leave the
    /// window untouched; the writer may already contain a partial document.
    pub fn write_json(&self, writer: impl std::io::Write) -> Result<(), Error> {
        serde_json::to_writer(writer, self).map_err(|error| Error::Serialization(error.to_string()))
    }
    /// Allocate only the output JSON, without building an owned semantic tree.
    pub fn to_json(&self) -> Result<String, Error> {
        serde_json::to_string(self).map_err(|error| Error::Serialization(error.to_string()))
    }
}

impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Borrow the same acknowledged semantic sheet as `visit` and accessibility.
    /// Serializers may inspect it repeatedly while this borrow prevents mutation.
    /// This rejects closed, quarantined or detached presentations. A pending or
    /// failed candidate still exposes the preceding valid P and its own epochs.
    pub fn semantics(&self) -> Result<SemanticSnapshot<'_>, Error> {
        let runtime = self.runtime()?;
        sheet(runtime)?;
        Ok(SemanticSnapshot {
            schema_version: 1,
            source_epoch: runtime.source_epoch,
            presentation_epoch: runtime.presentation_epoch,
            presentation_valid: runtime.presentation_valid,
            prepared_epoch: runtime.prepared_epoch(),
            size: runtime.presentation_size,
            requested_size: runtime.requested_size,
            scale_factor: runtime.presentation_scale_factor,
            requested_scale_factor: runtime.requested_scale_factor,
            nodes: Context::new(runtime),
        })
    }
}

impl Serialize for Context<'_> {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut nodes = serializer.serialize_seq(Some(self.nodes.len()))?;
        for index in 0..self.nodes.len() {
            nodes.serialize_element(&self.part(index))?;
        }
        nodes.end()
    }
}

impl Serialize for Actions {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut actions = serializer.serialize_seq(Some(self.iter().count()))?;
        for action in self.iter() {
            actions.serialize_element(&action)?;
        }
        actions.end()
    }
}

fn rect(rect: Rect) -> [f32; 4] {
    [rect.x, rect.y, rect.width, rect.height]
}

impl Serialize for Part<'_> {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut node = serializer.serialize_struct(
            "Part",
            21 + usize::from(self.checked().is_some()) + usize::from(self.marked_text().is_some()),
        )?;
        node.serialize_field("target", &self.target())?;
        node.serialize_field("parent", &self.parent())?;
        node.serialize_field("role", &self.role())?;
        if let Some(checked) = self.checked() {
            node.serialize_field("checked", &checked)?;
        }
        node.serialize_field("text", &self.text())?;
        node.serialize_field("name", &self.name())?;
        node.serialize_field("description", &self.description())?;
        node.serialize_field("value", &self.value())?;
        node.serialize_field("selection", &self.selection().map(Selection::from))?;
        if let Some(marked) = self.marked_text() {
            node.serialize_field("marked_text", &marked)?;
        }
        node.serialize_field("focused", &self.focused())?;
        node.serialize_field("disabled", &self.disabled())?;
        node.serialize_field("invalid", &self.invalid())?;
        node.serialize_field("actions", &self.actions())?;
        node.serialize_field("bounds", &rect(self.bounds()))?;
        node.serialize_field("local_bounds", &rect(self.local_bounds()))?;
        node.serialize_field("unclipped_bounds", &self.unclipped_bounds().map(rect))?;
        node.serialize_field(
            "transform",
            &self.transform().map(|m| [m.a, m.b, m.c, m.d, m.tx, m.ty]),
        )?;
        node.serialize_field("list", &self.list())?;
        node.serialize_field("list_item", &self.list_item())?;
        node.serialize_field("viewport", &self.viewport())?;
        node.serialize_field("corner_radius", &self.corner_radius())?;
        node.serialize_field("clips_children", &self.clips_children())?;
        node.end()
    }
}

#[derive(Serialize)]
struct Selection {
    anchor: SelectionPosition,
    focus: SelectionPosition,
}
#[derive(Serialize)]
struct SelectionPosition {
    byte: usize,
    affinity: &'static str,
}
impl From<gpui_canvas::TextPosition> for SelectionPosition {
    fn from(position: gpui_canvas::TextPosition) -> Self {
        Self {
            byte: position.offset.byte(),
            affinity: match position.affinity {
                gpui_canvas::CaretAffinity::Upstream => "upstream",
                gpui_canvas::CaretAffinity::Downstream => "downstream",
            },
        }
    }
}
impl From<gpui_canvas::TextSelection> for Selection {
    fn from(selection: gpui_canvas::TextSelection) -> Self {
        Self {
            anchor: selection.anchor.into(),
            focus: selection.focus.into(),
        }
    }
}
