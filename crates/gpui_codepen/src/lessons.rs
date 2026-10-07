pub struct Lesson {
    pub title: &'static str,
    pub subtitle: &'static str,
    pub description: &'static str,
    pub challenge: &'static str,
    pub source: &'static str,
}
pub const LESSONS: &[Lesson] = &[
    Lesson {
        title: "01  Make something",
        subtitle: "Elements & styling",
        description: "A component is a Rust function that returns an element tree. Chain styles on div(), then add children. Every element in the preview is laid out and painted by GPUI.",
        challenge: "Try changing the title, the accent color, or rounded(24.). Edits run automatically.",
        source: r#"use gpui_codepen_guest::*;

fn render(_cx: &mut PreviewContext) -> Node {
    div()
        .flex().flex_col().gap_4()
        .w(px(360.)).p_8().rounded(px(24.))
        .bg(rgb(0x182c29))
        .text_color(rgb(0xe5f3eb))
        .child(div().text_sm()
            .text_color(rgb(0x91c9b0))
            .child("BUILT WITH GPUI"))
        .child(div().text_3xl().font_bold()
            .child("Ideas become interfaces."))
        .child("Change this Rust. See it here.")
        .child(div().p_4().rounded_lg()
            .bg(rgb(0xa9efc5))
            .text_color(rgb(0x133528))
            .child("Make it yours →"))
        .into()
}
"#,
    },
    Lesson {
        title: "02  Give it room",
        subtitle: "Flex layout",
        description: "Flex layouts compose from the outside in. A column stacks children, a row places them side by side. Padding belongs to the container; gap creates space between children.",
        challenge: "Change gap(12.) to gap(24.), or change the outer flex_col() to flex_row().",
        source: r#"use gpui_codepen_guest::*;

fn render(_cx: &mut PreviewContext) -> Node {
    div().flex().flex_col().gap(px(12.))
        .p_6().w(px(380.)).rounded_xl()
        .bg(rgb(0xffffff)).text_color(rgb(0x203b33))
        .child(div().text_2xl().font_bold()
            .child("A little breathing room"))
        .child(div().flex().gap_3().children(
            ["Explore", "Build", "Share"].map(|label| {
                div().flex_grow().p_4().rounded_lg()
                    .bg(rgb(0xe7f1eb)).child(label)
            })
        ))
        .child("The layout engine does the measuring.")
        .into()
}
"#,
    },
    Lesson {
        title: "03  Rust all the way",
        subtitle: "Loops & functions",
        description: "This is compiled or interpreted Rust, including types, functions, iteration, ownership, and the standard library. The editor is not parsing a lookalike language or substituting colors into a template.",
        challenge: "Change the number of bars, their widths, or the logic inside the helper function.",
        source: r#"use gpui_codepen_guest::*;

fn bar(index: u32) -> Div {
    let width = 60. + index as f32 * 38.;
    div().w(px(width)).h(px(26.)).rounded_md()
        .bg(rgb(0x39745d + index * 0x080800))
}

fn render(_cx: &mut PreviewContext) -> Node {
    div().flex().flex_col().gap_3().p_8()
        .w(px(360.)).rounded_xl()
        .bg(rgb(0xffffff)).text_color(rgb(0x203b33))
        .child(div().text_2xl().font_bold()
            .child("Made of real Rust"))
        .children((0..6).map(bar))
        .child(format!("{} bars, one helper function", 6))
        .into()
}
"#,
    },
    Lesson {
        title: "04  Make it respond",
        subtitle: "State & events",
        description: "A click carries an event ID into your Rust function. State is returned with each frame and supplied to the next render. Editing keeps state; Reset state starts again. Failed renders never commit their state.",
        challenge: "Click the button. Then change count += 1 to count += 5. Try adding a decrement button.",
        source: r#"use gpui_codepen_guest::*;

fn render(cx: &mut PreviewContext) -> Node {
    let mut count = cx.state["count"].as_i64().unwrap_or(0);
    if cx.clicked("increment") { count += 1; }
    cx.state = json!({ "count": count });

    div().flex().flex_col().gap_4().p_8()
        .w(px(340.)).rounded(px(24.))
        .bg(rgb(0xffffff)).text_color(rgb(0x203b33))
        .child("A SMALL INTERACTION")
        .child(div().text_size(px(64.)).font_bold()
            .child(count.to_string()))
        .child(div().id("increment-button")
            .on_click("increment")
            .p_4().rounded_lg()
            .bg(rgb(0x245c45))
            .text_color(rgb(0xffffff))
            .hover(|s| s.bg(rgb(0x347e5f)))
            .child("Count me in  +"))
        .into()
}
"#,
    },
    Lesson {
        title: "05  Build a component",
        subtitle: "Composition",
        description: "Small functions become a component library. Data becomes children through ordinary Rust iterators. Conditional styling makes state visible, and GPUI handles the hit testing and hover appearance.",
        challenge: "Add another task to the list. Change the selected row's color or make clicking it toggle off.",
        source: r#"use gpui_codepen_guest::*;

fn task(label: &str, index: usize, selected: bool) -> Div {
    div().id(format!("task-{index}"))
        .on_click(format!("select-{index}"))
        .flex().items_center().gap_3().p_4()
        .rounded_lg().bg(rgb(0xf2f5f0))
        .when(selected, |s| s.bg(rgb(0xd2ebd8)))
        .hover(|s| s.bg(rgb(0xe2edde)))
        .child(if selected { "●" } else { "○" })
        .child(label)
}

fn render(cx: &mut PreviewContext) -> Node {
    let mut selected = cx.state["selected"].as_u64().unwrap_or(0);
    for index in 0..3 {
        if cx.clicked(&format!("select-{index}")) {
            selected = index;
        }
    }
    cx.state = json!({ "selected": selected });
    div().flex().flex_col().gap_2().p_6()
        .w(px(380.)).rounded_xl().bg(rgb(0xffffff))
        .text_color(rgb(0x203b33))
        .child(div().text_2xl().font_bold()
            .child("The next small thing"))
        .children(["Make a sketch", "Write the Rust", "Try an idea"]
            .iter().enumerate().map(|(i, label)| {
                task(label, i, selected == i as u64)
            }))
        .into()
}
"#,
    },
];
