//! The portable component boundary between interpreted Rust and GPUI.
//! No window handles or native pointers cross this boundary. Vendored Miri
//! executes the Rust component; native GPUI owns layout, painting and events.
use serde::{Deserialize, Serialize};
pub use serde_json::{Value, json};

pub mod wire;

pub const PROTOCOL_VERSION: u32 = 1;
pub const MAX_SOURCE_BYTES: usize = 64 * 1024;
pub const MAX_FRAME_BYTES: usize = 1024 * 1024;

#[derive(Clone, Debug, Default, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PreviewContext {
    pub state: Value,
    pub event: Option<String>,
}
impl PreviewContext {
    pub fn clicked(&self, id: &str) -> bool {
        self.event.as_deref() == Some(id)
    }
}

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Frame {
    pub version: u32,
    pub root: Node,
    pub state: Value,
}

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case", deny_unknown_fields)]
pub enum Node {
    Text {
        text: String,
    },
    Div {
        id: Option<String>,
        style: Style,
        hover: Option<Style>,
        click: Option<String>,
        children: Vec<Node>,
    },

}

#[derive(Clone, Debug, Default, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Style {
    pub flex: bool,
    pub column: bool,
    pub wrap: bool,
    pub grow: bool,
    pub width: Option<f32>,
    pub height: Option<f32>,
    pub full_width: bool,
    pub full_height: bool,
    pub padding: Option<f32>,
    pub gap: Option<f32>,
    pub radius: Option<f32>,
    pub border: Option<f32>,
    pub background: Option<u32>,
    pub color: Option<u32>,
    pub border_color: Option<u32>,
    pub font_size: Option<f32>,
    pub bold: bool,
    pub center: bool,
    pub justify_center: bool,
    pub justify_between: bool,
    pub opacity: Option<f32>,
    pub shadow: bool,
    pub clip: bool,
}

#[derive(Clone, Debug)]
pub struct Div {
    id: Option<String>,
    style: Style,
    hover: Option<Style>,
    click: Option<String>,
    children: Vec<Node>,
}
/// Hover refinements expose styles only, just like native GPUI.
pub struct HoverStyle {
    style: Style,
}
pub fn div() -> Div {
    Div {
        id: None,
        style: Style::default(),
        hover: None,
        click: None,
        children: Vec::new(),
    }
}
pub fn px(value: f32) -> f32 {
    value
}
pub fn rgb(value: u32) -> u32 {
    (value << 8) | 255
}
pub fn rgba(value: u32) -> u32 {
    value
}

macro_rules! flag_methods { ($($name:ident => $field:ident),* $(,)?) => { $(pub fn $name(mut self) -> Self { self.style.$field = true; self })* }; }
macro_rules! value_methods { ($($name:ident => $field:ident : $ty:ty),* $(,)?) => { $(pub fn $name(mut self, value: $ty) -> Self { self.style.$field = Some(value); self })* }; }
impl Div {
    flag_methods!(flex => flex, flex_col => column, flex_wrap => wrap, flex_grow => grow,
        items_center => center,
        font_bold => bold, shadow_lg => shadow, overflow_hidden => clip);
    value_methods!(p => padding: f32, gap => gap: f32,
        rounded => radius: f32, border => border: f32, bg => background: u32,
        text_color => color: u32, border_color => border_color: u32,
        text_size => font_size: f32, opacity => opacity: f32);
    pub fn w(mut self, value: f32) -> Self {
        self.style.width = Some(value);
        self.style.full_width = false;
        self
    }
    pub fn h(mut self, value: f32) -> Self {
        self.style.height = Some(value);
        self.style.full_height = false;
        self
    }
    pub fn w_full(mut self) -> Self {
        self.style.full_width = true;
        self.style.width = None;
        self
    }
    pub fn h_full(mut self) -> Self {
        self.style.full_height = true;
        self.style.height = None;
        self
    }
    pub fn justify_center(mut self) -> Self {
        self.style.justify_center = true;
        self.style.justify_between = false;
        self
    }
    pub fn justify_between(mut self) -> Self {
        self.style.justify_between = true;
        self.style.justify_center = false;
        self
    }
    pub fn flex_row(mut self) -> Self {
        self.style.column = false;
        self
    }
    pub fn size(self, value: f32) -> Self {
        self.w(value).h(value)
    }
    pub fn size_full(self) -> Self {
        self.w_full().h_full()
    }
    pub fn id(mut self, id: impl Into<String>) -> Self {
        self.id = Some(id.into());
        self
    }
    pub fn on_click(mut self, id: impl Into<String>) -> Self {
        self.click = Some(id.into());
        self
    }
    pub fn hover(mut self, apply: impl FnOnce(HoverStyle) -> HoverStyle) -> Self {
        self.hover = Some(
            apply(HoverStyle {
                style: Style::default(),
            })
            .style,
        );
        self
    }
    pub fn child(mut self, child: impl Into<Node>) -> Self {
        self.children.push(child.into());
        self
    }
    pub fn children(mut self, children: impl IntoIterator<Item = impl Into<Node>>) -> Self {
        self.children.extend(children.into_iter().map(Into::into));
        self
    }
    pub fn when(self, condition: bool, apply: impl FnOnce(Self) -> Self) -> Self {
        if condition { apply(self) } else { self }
    }
    pub fn p_2(self) -> Self {
        self.p(8.)
    }
    pub fn p_4(self) -> Self {
        self.p(16.)
    }
    pub fn p_6(self) -> Self {
        self.p(24.)
    }
    pub fn p_8(self) -> Self {
        self.p(32.)
    }
    pub fn gap_2(self) -> Self {
        self.gap(8.)
    }
    pub fn gap_3(self) -> Self {
        self.gap(12.)
    }
    pub fn gap_4(self) -> Self {
        self.gap(16.)
    }
    pub fn rounded_md(self) -> Self {
        self.rounded(6.)
    }
    pub fn rounded_lg(self) -> Self {
        self.rounded(8.)
    }
    pub fn rounded_xl(self) -> Self {
        self.rounded(12.)
    }
    pub fn border_1(self) -> Self {
        self.border(1.)
    }
    pub fn text_sm(self) -> Self {
        self.text_size(14.)
    }
    pub fn text_lg(self) -> Self {
        self.text_size(18.)
    }
    pub fn text_xl(self) -> Self {
        self.text_size(20.)
    }
    pub fn text_2xl(self) -> Self {
        self.text_size(24.)
    }
    pub fn text_3xl(self) -> Self {
        self.text_size(30.)
    }
}
impl HoverStyle {
    flag_methods!(font_bold => bold, shadow_lg => shadow, overflow_hidden => clip);
    value_methods!(w => width: f32, h => height: f32, p => padding: f32, gap => gap: f32,
        rounded => radius: f32, border => border: f32, bg => background: u32,
        text_color => color: u32, border_color => border_color: u32,
        text_size => font_size: f32, opacity => opacity: f32);
}
impl From<Div> for Node {
    fn from(d: Div) -> Self {
        Self::Div {
            id: d.id,
            style: d.style,
            hover: d.hover,
            click: d.click,
            children: d.children,
        }
    }
}
impl From<String> for Node {
    fn from(text: String) -> Self {
        Self::Text { text }
    }
}
impl From<&str> for Node {
    fn from(text: &str) -> Self {
        Self::from(text.to_owned())
    }
}

impl Frame {
    /// Validate before constructing GPUI elements, even when the guest is faulty.
    pub fn validate(&self) -> Result<(), String> {
        if self.version != PROTOCOL_VERSION {
            return Err("unsupported component protocol".into());
        }
        if serde_json::to_vec(&self.state)
            .map_err(|e| e.to_string())?
            .len()
            > 64 * 1024
        {
            return Err("component state exceeds 64 KiB".into());
        }
        let mut remaining = 4096;
        let mut ids = std::collections::HashSet::new();
        fn walk(
            node: &Node,
            depth: usize,
            remaining: &mut usize,
            ids: &mut std::collections::HashSet<String>,
        ) -> Result<(), String> {
            if depth > 48 || *remaining == 0 {
                return Err("component exceeds the depth or element budget".into());
            }
            *remaining -= 1;
            match node {
                Node::Text { text } => {
                    if text.len() > 64 * 1024 {
                        return Err("text exceeds 64 KiB".into());
                    }
                }
                Node::Div {
                    id,
                    style,
                    hover,
                    click,
                    children,
                } => {
                    for key in [id, click].into_iter().flatten() {
                        if key.len() > 256 {
                            return Err("element identifiers exceed 256 bytes".into());
                        }
                    }
                    if let Some(id) = id {
                        if !ids.insert(id.clone()) {
                            return Err(format!("duplicate element id: {id}"));
                        }
                    }
                    fn check(s: &Style) -> Result<(), String> {
                        for n in [
                            s.width,
                            s.height,
                            s.padding,
                            s.gap,
                            s.radius,
                            s.border,
                            s.font_size,
                        ]
                        .into_iter()
                        .flatten()
                        {
                            if !n.is_finite() || !(0. ..=8192.).contains(&n) {
                                return Err(
                                    "style lengths must be finite and between 0 and 8192".into()
                                );
                            }
                        }
                        if s.opacity
                            .is_some_and(|n| !n.is_finite() || !(0. ..=1.).contains(&n))
                        {
                            return Err("opacity must be between 0 and 1".into());
                        }
                        Ok(())
                    }
                    check(style)?;
                    if let Some(hover) = hover {
                        check(hover)?;
                    }
                    for child in children {
                        walk(child, depth + 1, remaining, ids)?;
                    }
                }
            }
            Ok(())
        }
        walk(&self.root, 0, &mut remaining, &mut ids)
    }
}

pub fn evaluate(input: &str, render: fn(&mut PreviewContext) -> Node) -> String {
    let mut cx: PreviewContext = serde_json::from_str(input).expect("invalid preview input");
    let root = render(&mut cx);
    serde_json::to_string(&Frame {
        version: PROTOCOL_VERSION,
        root,
        state: cx.state,
    })
    .expect("invalid preview output")
}

/// Persistent interpreter entry point. Only the bounded input transport is a
/// host shim; JSON, application logic, allocation and output all execute in Miri.
#[cfg(miri)]
pub fn run(render: fn(&mut PreviewContext) -> Node) {
    unsafe extern "C" {
        fn gpui_codepen_receive(buffer: *mut u8, capacity: usize) -> usize;
        fn gpui_codepen_emit(buffer: *const u8, len: usize);
    }
    unsafe {
        gpui_codepen_emit(std::ptr::null(), 0);
    }
    let mut buffer = vec![0u8; 64 * 1024 + 512];
    loop {
        // The shim checks the ABI, bound and destination through Miri's memory
        // model, and may only read the pipe provided by the compiler worker.
        let len = unsafe { gpui_codepen_receive(buffer.as_mut_ptr(), buffer.len()) };
        if len == 0 {
            break;
        }
        let mut cx: PreviewContext =
            serde_json::from_slice(&buffer[..len]).expect("invalid preview input");
        let root = render(&mut cx);
        let output = wire::encode(&Frame {
            version: PROTOCOL_VERSION,
            root,
            state: cx.state,
        });
        assert!(
            output.len() <= MAX_FRAME_BYTES,
            "component frame exceeds 1 MiB"
        );
        unsafe {
            gpui_codepen_emit(output.as_ptr(), output.len());
        }
    }
}
#[cfg(not(miri))]
pub fn run(_: fn(&mut PreviewContext) -> Node) {
    panic!("GPUI components must run in the vendored Miri interpreter");
}

#[macro_export]
macro_rules! export {
    ($render:path) => {
        fn main() {
            $crate::run($render);
        }
    };
}
