use super::*;
use crate::{El, Signal, Source, Sources, text_input};
use icu_segmenter::GraphemeClusterSegmenter;

struct Document(Signal<String>, f32);
impl Document {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "document", |m| &m.0, |m| &mut m.0);
}
impl View for Document {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        text_input(&self.0).w(self.1).h(250)
    }
}

#[test]
fn real_public_input_runs_match_icu_lengths_and_native_endpoint_roundtrips() {
    let long = format!("a{}\r\n", "\u{301}".repeat(200));
    for value in [
        "",
        "\r\n\n",
        "office ffi café a\u{301}  ",
        "abc אבג 123 العربية\r\nlast\n",
        "a\u{2067}אבג 12\u{2069} z\u{2028}",
        &long,
    ] {
        let win = Win::demo(Document(Signal::new(value.into()), 77.));
        let mut cohort = Cohort::default();
        cohort.refresh(&win).unwrap();
        assert_eq!(cohort.inputs.len(), 1);
        let input = &cohort.inputs[0];
        for (index, run) in input.geometry.runs().enumerate() {
            let range = run.text_range();
            let slice = &value[range.start.byte()..range.end.byte()];
            let reference = text_run(slice);
            let lengths = reference
                .decoded_character_lengths()
                .unwrap()
                .collect::<Vec<_>>();
            for placed in [false, true] {
                let node = geometry_run(value, &input.geometry, run, placed);
                assert_eq!(node.value(), reference.value());
                assert_eq!(
                    node.decoded_character_lengths()
                        .unwrap()
                        .collect::<Vec<_>>(),
                    lengths
                );
                if placed {
                    let units = input
                        .geometry
                        .graphemes_in(range.clone())
                        .unwrap()
                        .collect::<Vec<_>>();
                    let rect = run.bounds();
                    let rtl = run.direction() == gpui_canvas::TextDirection::RightToLeft;
                    assert_eq!(
                        node.character_positions().unwrap(),
                        units
                            .iter()
                            .map(|unit| {
                                let bounds = unit.bounds();
                                if rtl {
                                    rect.x + rect.width - bounds.x - bounds.width
                                } else {
                                    bounds.x - rect.x
                                }
                            })
                            .collect::<Vec<_>>()
                    );
                    assert_eq!(
                        node.character_widths().unwrap(),
                        units
                            .iter()
                            .map(|unit| unit.bounds().width)
                            .collect::<Vec<_>>()
                    );
                } else {
                    assert!(node.character_positions().is_none());
                    assert!(node.character_widths().is_none());
                    assert!(node.bounds().is_none());
                }
            }
            for (character_index, byte) in GraphemeClusterSegmenter::new()
                .segment_str(slice)
                .enumerate()
            {
                let native = accesskit::TextPosition {
                    node: NodeId(input.base + 1 + index as u64),
                    character_index,
                };
                let position = input.position(native).unwrap();
                assert_eq!(position.offset.byte(), range.start.byte() + byte);
                let roundtrip = input.position(input.native_position(position)).unwrap();
                assert_eq!(roundtrip.offset, position.offset);
                assert_eq!(
                    input.geometry.caret_line(roundtrip),
                    input.geometry.caret_line(position)
                );
            }
            assert!(
                input
                    .position(accesskit::TextPosition {
                        node: NodeId(input.base + 1 + index as u64),
                        character_index: lengths.len() + 1
                    })
                    .is_none()
            );
        }
    }
}

// Frozen production emitter at main 51f38a3a9b; resource control only.
fn reference_geometry_run(
    value: &str,
    geometry: &gpui_canvas::TextGeometry,
    run: gpui_canvas::TextRun,
    placed: bool,
) -> Node {
    let range = run.text_range();
    let mut node = text_run(&value[range.start.byte()..range.end.byte()]);
    // An admitted, nonpainted offscreen paragraph may have no invertible P
    // placement. Preserve text/actions without inventing window geometry.
    if !placed {
        return node;
    }
    let rect = run.bounds();
    node.set_bounds(accesskit::Rect {
        x0: f64::from(rect.x),
        y0: f64::from(rect.y),
        x1: f64::from(rect.x) + f64::from(rect.width),
        y1: f64::from(rect.y) + f64::from(rect.height),
    });
    let rtl = run.direction() == gpui_canvas::TextDirection::RightToLeft;
    node.set_text_direction(if rtl {
        accesskit::TextDirection::RightToLeft
    } else {
        accesskit::TextDirection::LeftToRight
    });
    let count = node.character_lengths().len();
    let mut positions = Vec::with_capacity(count);
    let mut widths = Vec::with_capacity(count);
    for unit in geometry
        .graphemes_in(range)
        .expect("run endpoints are legal grapheme boundaries")
    {
        let bounds = unit.bounds();
        positions.push(if rtl {
            rect.x + rect.width - bounds.x - bounds.width
        } else {
            bounds.x - rect.x
        });
        widths.push(bounds.width);
    }
    assert_eq!(positions.len(), count);
    node.set_character_positions(positions);
    node.set_character_widths(widths);
    node
}

fn allocation_record(case: &str, phase: &str, cost: allocation_counter::AllocationInfo) {
    println!(
        "{{\"case\":{case:?},\"phase\":{phase:?},\"calls\":{},\"requested\":{},\"retained\":{},\"peak\":{},\"retained_allocations\":{}}}",
        cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max, cost.count_current
    );
}

#[test]
#[ignore = "matched public-owner allocation control; run alone"]
fn public_owner_and_native_projection_resource_control() {
    println!(
        "{{\"headers\":true,\"geometry\":{},\"layout\":{},\"grapheme\":{},\"run\":{},\"native_input\":{},\"cohort\":{}}}",
        size_of::<gpui_canvas::TextGeometry>(),
        size_of::<gpui_canvas::TextLayout>(),
        size_of::<gpui_canvas::TextGrapheme>(),
        size_of::<gpui_canvas::TextRun>(),
        size_of::<Input>(),
        size_of::<Cohort>() - 3 * size_of::<usize>()
    );
    let requested_case = std::env::var("GPUI_CANONICAL_RESOURCE_CASE").ok();
    let mut visited = 0;
    for (case, value) in [
        ("empty", String::new()),
        ("tiny", "a".into()),
        ("label", "office café a\u{301} אבג".into()),
        ("wrapped32k", "a".repeat(32768)),
        ("mixed", "office abc אבג العربية\r\n".repeat(64)),
        ("long-grapheme", format!("a{}\r\n", "\u{301}".repeat(1024))),
    ] {
        if requested_case
            .as_ref()
            .is_some_and(|requested| requested != case)
        {
            continue;
        }
        visited += 1;
        let mut owner = None;
        let cost = allocation_counter::measure(|| {
            owner = Some(
                Win::recording(
                    Document(Signal::new(value.clone()), 400.),
                    crate::WindowOptions::default(),
                )
                .unwrap(),
            );
        });
        let mut win = owner.unwrap();
        allocation_record(case, "cold_public_owner_c", cost);
        let token = win.with_scene(|_, token| token).unwrap();
        let cost = allocation_counter::measure(|| {
            win.presented(token).unwrap();
        });
        allocation_record(case, "ack", cost);
        assert_eq!((cost.count_total, cost.bytes_total), (0, 0));
        let mut cohort = Cohort::default();
        let cost = allocation_counter::measure(|| {
            cohort.refresh(&win).unwrap();
        });
        allocation_record(case, "native_cohort", cost);
        let input = &cohort.inputs[0];
        println!(
            "{{\"case\":{case:?},\"stage\":\"p_with_native_lease\",\"map_strong\":{},\"graphemes_iterator\":{},\"runs_iterator\":{}}}",
            Arc::strong_count(&input.geometry),
            size_of_val(&input.geometry.graphemes()),
            size_of_val(&input.geometry.runs())
        );
        for placed in [false, true] {
            let mut expected = None;
            let reference = allocation_counter::measure(|| {
                expected = Some(
                    input
                        .geometry
                        .runs()
                        .map(|run| reference_geometry_run(&value, &input.geometry, run, placed))
                        .collect::<Vec<_>>(),
                );
            });
            let expected = expected.unwrap();
            let mut actual = None;
            let current = allocation_counter::measure(|| {
                actual = Some(
                    input
                        .geometry
                        .runs()
                        .map(|run| geometry_run(&value, &input.geometry, run, placed))
                        .collect::<Vec<_>>(),
                );
            });
            let actual = actual.unwrap();
            assert_eq!(actual.len(), expected.len());
            for (actual, expected) in actual.iter().zip(&expected) {
                assert_eq!(actual.value(), expected.value());
                assert_eq!(
                    actual
                        .decoded_character_lengths()
                        .unwrap()
                        .collect::<Vec<_>>(),
                    expected
                        .decoded_character_lengths()
                        .unwrap()
                        .collect::<Vec<_>>()
                );
                let bits = |values: Option<&[f32]>| {
                    values.map(|values| {
                        values
                            .iter()
                            .map(|value| value.to_bits())
                            .collect::<Vec<_>>()
                    })
                };
                assert_eq!(
                    bits(actual.character_positions()),
                    bits(expected.character_positions())
                );
                assert_eq!(
                    bits(actual.character_widths()),
                    bits(expected.character_widths())
                );
                assert_eq!(actual.bounds(), expected.bounds());
                assert_eq!(actual.text_direction(), expected.text_direction());
            }
            allocation_record(
                case,
                if placed {
                    "reference_placed"
                } else {
                    "reference_unplaced"
                },
                reference,
            );
            allocation_record(
                case,
                if placed {
                    "current_placed"
                } else {
                    "current_unplaced"
                },
                current,
            );
            assert_eq!(
                (
                    current.count_total,
                    current.bytes_total,
                    current.bytes_current,
                    current.bytes_max
                ),
                (
                    reference.count_total,
                    reference.bytes_total,
                    reference.bytes_current,
                    reference.bytes_max
                )
            );
        }
        drop(cohort);
        let mut replacement = value.clone();
        if replacement.is_empty() {
            replacement.push('b');
        } else {
            replacement.replace_range(..1, "b");
        }
        let cost = allocation_counter::measure(|| {
            win.set(Document::VALUE, replacement.clone()).unwrap();
        });
        allocation_record(case, "old_p_new_c", cost);
        let eligible = win.with_scene(|_, token| token).unwrap();
        let cost = allocation_counter::measure(|| {
            assert!(win.set(Document::VALUE, "漢".into()).is_err());
        });
        allocation_record(case, "old_p_eligible_c_failed_l", cost);
        let cost = allocation_counter::measure(|| {
            win.presented(eligible).unwrap();
        });
        allocation_record(case, "eligible_ack_after_failure", cost);
        assert_eq!((cost.count_total, cost.bytes_total), (0, 0));
        let mut presented = None;
        win.visit(|part| {
            if part.role() == Role::TextInput {
                presented = Some(part.value().unwrap().to_owned());
            }
        })
        .unwrap();
        assert_eq!(presented.as_deref(), Some(replacement.as_str()));
    }
    assert_eq!(visited, if requested_case.is_some() { 1 } else { 6 });
}
