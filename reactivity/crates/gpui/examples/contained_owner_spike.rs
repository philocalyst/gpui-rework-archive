//! Existing-API ownership spike, not a wired native Inspector Apply button.
use gpui::{
    ColorSpace, QuestionExecutor, Questions, TextSelection, WindowOptions,
    prelude::*,
    property::{Contribution, PropertyId, PropertyValue},
};

struct Application {
    width: Signal<f32>,
    presses: u32,
}
impl Application {
    const WIDTH: Source<Self, f32> =
        Source::new(FieldId::new(1), "width", |m| &m.width, |m| &mut m.width);
    fn press(&mut self) {
        self.presses += 1;
    }
}
impl View for Application {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::WIDTH)
    }
    fn view(&self) -> El<'_> {
        button("Caller behavior")
            .w(&self.width)
            .h(32)
            .on_click(Self::press)
    }
}

struct ValueEditor {
    draft: Signal<String>,
    selected: Option<(Target, PropertyId)>,
    value: PropertyValue,
}
impl ValueEditor {
    const DRAFT: Source<Self, String> =
        Source::new(FieldId::new(1), "draft", |m| &m.draft, |m| &mut m.draft);
    fn contribution(
        &self,
    ) -> Result<(Target, PropertyId, Contribution<PropertyValue>), &'static str> {
        let (target, id) = self.selected.ok_or("Select a property")?;
        let source = self.draft.trim();
        let scalar = || source.parse::<f32>().map_err(|_| "Expected a number");
        let value = match self.value {
            PropertyValue::Number(_) => PropertyValue::Number(scalar()?),
            PropertyValue::Dimension(_) => PropertyValue::Dimension(if source == "auto" {
                None
            } else {
                Some(scalar()?)
            }),
            PropertyValue::Transform(_) => {
                let [a, b, c, d, tx, ty] = numbers(source)?;
                PropertyValue::Transform(Affine { a, b, c, d, tx, ty })
            }
            PropertyValue::Color(color) => {
                let [r, g, b, alpha] = numbers(source)?;
                let color = match color.space() {
                    ColorSpace::Srgb => Color::srgb(r, g, b, alpha),
                    ColorSpace::LinearSrgb => Color::linear_srgb(r, g, b, alpha),
                    ColorSpace::DisplayP3 => Color::display_p3(r, g, b, alpha),
                    ColorSpace::LinearDisplayP3 => Color::linear_display_p3(r, g, b, alpha),
                    ColorSpace::Oklch => Color::oklch(r, g, b, alpha),
                }
                .map_err(|_| "Invalid authored color")?;
                PropertyValue::Color(color)
            }
            _ => return Err("This spike only parses numeric, color and transform values"),
        };
        Ok((target, id, Contribution::Set(value)))
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
impl View for ValueEditor {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::DRAFT)
    }
    fn view(&self) -> El<'_> {
        text_input(&self.draft).name("Property draft").w(280).h(32)
    }
}

struct Companion<A, T> {
    application: A,
    tool: T,
}
impl<A: View + 'static, T: View + 'static> Companion<A, T> {
    const APP: Component<Self, A> = Component::new(
        FieldId::new(1),
        "application",
        |m| &m.application,
        |m| &mut m.application,
    );
    const TOOL: Component<Self, T> =
        Component::new(FieldId::new(2), "tool", |m| &m.tool, |m| &mut m.tool);
}
impl<A: View + 'static, T: View + 'static> View for Companion<A, T> {
    fn sources() -> Sources<Self> {
        Sources::new()
            .component(Self::APP)
            .direct_component(Self::TOOL)
    }
    fn view(&self) -> El<'_> {
        row((Self::APP.view(self), Self::TOOL.view(self))).gap(12)
    }
}

/// The existing owned Future boundary type-checks for a standalone editor.
/// It cannot yet be lifted into Companion's registered component scope.
pub fn standalone_preview<X: QuestionExecutor>(executor: X) {
    let (questions, answer) = Questions::new()
        .question_future(
            ValueEditor::DRAFT,
            Clone::clone,
            executor,
            |draft| async move { Ok::<_, std::convert::Infallible>(draft) },
        )
        .unwrap();
    let _ = (questions, answer);
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let model = Companion {
        application: Application {
            width: Signal::new(120.),
            presses: 0,
        },
        tool: ValueEditor {
            draft: Signal::new(String::new()),
            selected: None,
            value: PropertyValue::Number(0.),
        },
    };
    let mut win = Win::with_options(model, WindowOptions::default())?;
    let target = win.button("Caller behavior");
    let input = win.find_input()?;
    for (id, draft) in [
        (PropertyId::Width, "193.25"),
        (PropertyId::CornerRadius, "7.125"),
        (PropertyId::Transform, "1, 0.25, -0.125, 1, 3.5, 2.25"),
        (PropertyId::Background, "0.125, 0.25, 0.75, 0.625"),
    ] {
        let value = win.property_value(target, id)?;
        win.update(|m| {
            m.tool.selected = Some((target, id));
            m.tool.value = value;
        })?;
        let end = win.root()?.tool.draft.len();
        win.select(input, TextSelection::from_bytes(0, end).unwrap())?;
        win.type_text(input, draft)?;
        // The borrow ends before the ordinary target-qualified transaction.
        // This explicit host call is the missing native-handler seam, not a pump.
        let (target, id, contribution) = win.root()?.tool.contribution()?;
        win.set_property_value(target, id, contribution)?;
    }
    win.update(|m| *m.application.width = 250.)?;
    assert_eq!(
        win.property_value(target, PropertyId::Width)?,
        PropertyValue::Dimension(Some(193.25))
    );
    win.set_property_value(target, PropertyId::Width, Contribution::Inherit)?;
    assert_eq!(
        win.property_value(target, PropertyId::Width)?,
        PropertyValue::Dimension(Some(250.))
    );
    win.click(target)?;
    assert_eq!(win.root()?.application.presses, 1);
    println!(
        "spike_headers,Win={},Companion={},Application={},Editor={},SignalString={},PropertyValue={},Contribution={},Component={},Source={}",
        size_of_val(&win),
        size_of::<Companion<Application, ValueEditor>>(),
        size_of::<Application>(),
        size_of::<ValueEditor>(),
        size_of::<Signal<String>>(),
        size_of::<PropertyValue>(),
        size_of::<Contribution<PropertyValue>>(),
        size_of::<Component<Companion<Application, ValueEditor>, ValueEditor>>(),
        size_of::<Source<ValueEditor, String>>()
    );
    Ok(())
}
