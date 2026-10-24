//! Reusable contained editor: ordinary model/input sources and catalog writes.
use gpui::{
    ColorSpace, Error, PropertyChange, PropertyState,
    prelude::*,
    property::{Contribution, PropertyId, PropertyValue},
    property_action, property_selection,
};

pub struct ValueEntry {
    pub draft: Signal<String>,
    pub selected: Option<(Target, PropertyId, PropertyValue)>,
    pub status: String,
}
impl Default for ValueEntry {
    fn default() -> Self {
        Self {
            draft: Signal::new(String::new()),
            selected: None,
            status: String::new(),
        }
    }
}
impl ValueEntry {
    const DRAFT: Source<Self, String> =
        Source::new(FieldId::new(1), "draft", |m| &m.draft, |m| &mut m.draft);
    pub fn select(&mut self, target: Target, id: PropertyId, value: PropertyValue) {
        self.selected = Some((target, id, value));
        self.status.clear();
        *self.draft = match value {
            PropertyValue::Number(value) => value.to_string(),
            PropertyValue::Dimension(value) => value.to_string(),
            PropertyValue::Transform(value) => format!(
                "{}, {}, {}, {}, {}, {}",
                value.a, value.b, value.c, value.d, value.tx, value.ty
            ),
            PropertyValue::Color(color) | PropertyValue::Brush(gpui::Brush::Solid(color)) => {
                let [a, b, c, d] = color.channels();
                format!("{a}, {b}, {c}, {d}")
            }
            _ => String::new(),
        };
    }
    fn contribution(&self) -> Result<PropertyChange, &'static str> {
        let (target, id, previous) = self.selected.ok_or("Select a property")?;
        let source = self.draft.trim();
        let scalar = || source.parse::<f32>().map_err(|_| "Expected a number");
        let value = match previous {
            PropertyValue::Number(_) => PropertyValue::Number(scalar()?),
            PropertyValue::Dimension(_) => PropertyValue::Dimension(
                source
                    .parse()
                    .map_err(|_| "Expected auto, points or a percentage")?,
            ),
            PropertyValue::Transform(_) => {
                let [a, b, c, d, tx, ty] = numbers(source)?;
                PropertyValue::Transform(Affine { a, b, c, d, tx, ty })
            }
            PropertyValue::Color(color) | PropertyValue::Brush(gpui::Brush::Solid(color)) => {
                let [r, g, b, alpha] = numbers(source)?;
                let color = match color.space() {
                    ColorSpace::Srgb => Color::srgb(r, g, b, alpha),
                    ColorSpace::LinearSrgb => Color::linear_srgb(r, g, b, alpha),
                    ColorSpace::DisplayP3 => Color::display_p3(r, g, b, alpha),
                    ColorSpace::LinearDisplayP3 => Color::linear_display_p3(r, g, b, alpha),
                    ColorSpace::Oklch => Color::oklch(r, g, b, alpha),
                }
                .map_err(|_| "Invalid authored color")?;
                if matches!(previous, PropertyValue::Brush(_)) {
                    PropertyValue::Brush(gpui::Brush::Solid(color))
                } else {
                    PropertyValue::Color(color)
                }
            }
            _ => return Err("This editor accepts numeric, color and transform values"),
        };
        Ok((target, id, Contribution::Set(value)))
    }
    fn proposal(&self) -> Option<PropertyChange> {
        self.contribution().ok()
    }
    fn inherit(&self) -> Option<PropertyChange> {
        self.selected
            .map(|(target, id, _)| (target, id, Contribution::Inherit))
    }
    pub fn selected_logically(&mut self, result: Result<PropertyState, &Error>) {
        match result {
            Ok(state) => self.select(state.target, state.id, state.value),
            Err(error) => self.status = format!("Rejected: {error}"),
        }
    }
    fn refresh(&self, _: Target) -> Option<(Target, PropertyId)> {
        self.selected.map(|(target, id, _)| (target, id))
    }
    fn applied_logically(&mut self, result: Result<PropertyState, &Error>) {
        self.status = match result {
            Ok(state) => {
                self.select(state.target, state.id, state.value);
                "Logical contribution accepted".into()
            }
            Err(error) => format!("Rejected: {error}"),
        };
    }
}
fn numbers<const N: usize>(source: &str) -> Result<[f32; N], &'static str> {
    let mut fields = source.split(',');
    let mut result = [0.; N];
    for value in &mut result {
        *value = fields
            .next()
            .ok_or("Too few components")?
            .trim()
            .parse()
            .map_err(|_| "Expected a number")?;
    }
    if fields.next().is_some() {
        return Err("Too many components");
    }
    Ok(result)
}
impl View for ValueEntry {
    fn sources() -> Sources<Self> {
        // Error text depends on ordinary reads of the draft, so it is an owner
        // dependency. Declaring this direct-only would leave that caption stale.
        Sources::new().field(Self::DRAFT)
    }
    fn view(&self) -> El<'_> {
        let message = self.contribution().err().unwrap_or(&self.status);
        column((
            text_input(&self.draft).name("Property draft").w(280).h(32),
            button("Apply")
                .h(32)
                .on_click(property_action(Self::proposal, Self::applied_logically)),
            button("Inherit")
                .h(32)
                .on_click(property_action(Self::inherit, Self::applied_logically)),
            button("Refresh selection")
                .h(32)
                .on_click(property_selection(Self::refresh, Self::selected_logically)),
            text(message).name("Property result").h(32),
        ))
        .gap(8)
    }
}
