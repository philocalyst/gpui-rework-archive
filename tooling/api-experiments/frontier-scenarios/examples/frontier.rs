use gpui::{
    App, Div, IntoElement, ParentElement, RenderOnce, Select, SelectableElement, Window, div,
    reflection::{Capability, reflect_trait},
};
use std::sync::Arc;

// A normal trait can have associated types and GATs, but those features do not
// make it a callable reflected trait object. Membership is still useful for
// filtering; the object-safe companion below is the borrowed callable surface.
#[reflect_trait(membership)]
trait QuerySource {
    type Item;
    type Cursor<'a>
    where
        Self: 'a;

    fn start<'a>(&'a self) -> Self::Cursor<'a>;
    fn next<'a>(&'a self, cursor: &mut Self::Cursor<'a>) -> Option<Self::Item>;
}

#[reflect_trait]
trait QuerySourceView {
    fn item_count(&self) -> usize;
}

const QUERY_SOURCE_VIEW: Capability<dyn QuerySourceView> = Capability::new("QuerySourceView");

#[derive(gpui::Element)]
#[reflect(QuerySource, capability(QUERY_SOURCE_VIEW => |source| source))]
struct StringQuery {
    #[element]
    inner: Div,
    items: Vec<String>,
}

impl QuerySource for StringQuery {
    type Item = String;
    type Cursor<'a> = std::slice::Iter<'a, String>;

    fn start<'a>(&'a self) -> Self::Cursor<'a> {
        self.items.iter()
    }

    fn next<'a>(&'a self, cursor: &mut Self::Cursor<'a>) -> Option<Self::Item> {
        cursor.next().cloned()
    }
}

impl QuerySourceView for StringQuery {
    fn item_count(&self) -> usize {
        self.items.len()
    }
}

fn membership_and_object_safe_query(root: impl IntoElement) -> impl IntoElement {
    root.select_mut(
        Select::descendants()
            .reflects(QuerySource)
            .capability(QUERY_SOURCE_VIEW),
        |source| {
            let _item_count = source.item_count();
        },
    )
}

struct Primary;
struct Secondary;

trait TextValue {
    fn append(&mut self, suffix: &str);
    fn as_str(&self) -> &str;
}

struct TextSlot(String);

impl TextValue for TextSlot {
    fn append(&mut self, suffix: &str) {
        self.0.push_str(suffix);
    }

    fn as_str(&self) -> &str {
        &self.0
    }
}

const PRIMARY_TEXT: Capability<dyn TextValue, Primary> = Capability::new("PrimaryText");
const SECONDARY_TEXT: Capability<dyn TextValue, Secondary> = Capability::new("SecondaryText");

// Two fields expose exactly the same trait-object type. The key gives each
// projection a separate descriptor and lets selectors borrow either field.
#[derive(gpui::Element)]
#[reflect(
    capability(PRIMARY_TEXT => |pair| &mut pair.primary),
    capability(SECONDARY_TEXT => |pair| &mut pair.secondary)
)]
struct PairElement {
    #[element]
    inner: Div,
    primary: TextSlot,
    secondary: TextSlot,
}

fn edit_both_lenses(root: impl IntoElement) -> impl IntoElement {
    root.select_mut(Select::descendants().capability(PRIMARY_TEXT), |value| {
        value.append(" primary")
    })
    .select_mut(Select::descendants().capability(SECONDARY_TEXT), |value| {
        value.append(" secondary")
    })
}

// This generic wrapper gets a separate reflected schema for each concrete T.
// Its projection is ordinary safe Rust and is monomorphized for that T.
trait DisplayText {
    fn text(&self) -> &str;
}

impl DisplayText for String {
    fn text(&self) -> &str {
        self
    }
}

const NOTE_TEXT: Capability<dyn DisplayText> = Capability::new("NoteText");

#[derive(gpui::Element)]
#[reflect(capability(NOTE_TEXT => |note| &mut note.value))]
struct GenericNote<T: DisplayText + 'static> {
    #[element]
    inner: Div,
    value: T,
}

fn generic_note_selection(root: impl IntoElement) -> impl IntoElement {
    root.select_mut(Select::descendants().capability(NOTE_TEXT), |note| {
        let _text = note.text();
    })
}

// Theme state belongs to the application callback, not the static reflection
// schema. An Arc makes the captured value satisfy the selector's 'static bound.
#[derive(Clone)]
struct Theme {
    accent: u32,
}

trait Themeable {
    fn apply_theme(&mut self, theme: &Theme);
    fn accent(&self) -> u32;
}

const THEMEABLE: Capability<dyn Themeable> = Capability::new("Themeable");

#[derive(gpui::Element)]
#[reflect(capability(THEMEABLE => |element| element))]
struct ThemedElement {
    #[element]
    inner: Div,
    accent: u32,
}

impl Themeable for ThemedElement {
    fn apply_theme(&mut self, theme: &Theme) {
        self.accent = theme.accent;
    }

    fn accent(&self) -> u32 {
        self.accent
    }
}

trait ThemeSelectionExt: SelectableElement + Sized {
    fn apply_theme_to_descendants(self, theme: Arc<Theme>) -> impl IntoElement {
        self.select_mut(
            Select::descendants().capability(THEMEABLE),
            move |element| element.apply_theme(&theme),
        )
    }
}

impl<T: SelectableElement> ThemeSelectionExt for T {}

fn themed_root(root: impl IntoElement, theme: Arc<Theme>) -> impl IntoElement {
    root.apply_theme_to_descendants(theme)
}

// Select::component lends the authored one-shot component before its render
// consumes it. Its rendered div is a child with independent selector metadata.
#[derive(gpui::IntoElement)]
struct Notice {
    label: String,
}

impl Notice {
    fn prefix(&mut self, prefix: &str) {
        self.label.insert_str(0, prefix);
    }
}

impl RenderOnce for Notice {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        div().child(self.label)
    }
}

fn edit_before_render(root: impl IntoElement) -> impl IntoElement {
    root.select_mut(
        Select::descendants().class("notice").component::<Notice>(),
        |notice| notice.prefix("[urgent] "),
    )
}

// A diamond repeats Root through two branches. The leaf selector should expose
// inherited methods once, while each branch keeps its own method available.
#[reflect_trait]
trait RootValue {
    fn root_value(&self) -> usize;
}

#[reflect_trait]
trait LeftValue: RootValue {
    fn left_value(&self) -> usize;
}

#[reflect_trait]
trait RightValue: RootValue {
    fn right_value(&self) -> usize;
}

#[reflect_trait]
trait DiamondValue: LeftValue + RightValue {
    fn diamond_value(&self) -> usize;
}

#[derive(gpui::Element)]
#[reflect(DiamondValue)]
struct DiamondElement {
    #[element]
    inner: Div,
    value: usize,
}

impl RootValue for DiamondElement {
    fn root_value(&self) -> usize {
        self.value
    }
}

impl LeftValue for DiamondElement {
    fn left_value(&self) -> usize {
        self.value + 1
    }
}

impl RightValue for DiamondElement {
    fn right_value(&self) -> usize {
        self.value + 2
    }
}

impl DiamondValue for DiamondElement {
    fn diamond_value(&self) -> usize {
        self.value + 3
    }
}

fn use_diamond_methods(root: impl IntoElement) -> impl IntoElement {
    root.map_selected(Select::descendants().reflects(DiamondValue), |element| {
        let _ = (
            element.root_value(),
            element.left_value(),
            element.right_value(),
            element.diamond_value(),
        );
        element
    })
}

fn main() {
    let mut pair = PairElement {
        inner: div(),
        primary: TextSlot("left".into()),
        secondary: TextSlot("right".into()),
    }
    .into_any_element();
    PRIMARY_TEXT.get_mut(&mut pair).unwrap().append("!");
    SECONDARY_TEXT.get_mut(&mut pair).unwrap().append("?");
    assert_eq!(PRIMARY_TEXT.get_mut(&mut pair).unwrap().as_str(), "left!");
    assert_eq!(
        SECONDARY_TEXT.get_mut(&mut pair).unwrap().as_str(),
        "right?"
    );

    let mut generic = GenericNote {
        inner: div(),
        value: String::from("generic"),
    }
    .into_any_element();
    assert_eq!(NOTE_TEXT.get_mut(&mut generic).unwrap().text(), "generic");

    let mut themed = ThemedElement {
        inner: div(),
        accent: 0,
    }
    .into_any_element();
    let theme = Theme { accent: 0x123456 };
    let themed_view = THEMEABLE.get_mut(&mut themed).unwrap();
    themed_view.apply_theme(&theme);
    assert_eq!(themed_view.accent(), 0x123456);
}
