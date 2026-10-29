//! Local feature qualification. Diagnostic captures never drive candidate decisions.
use super::layout_handle_tests::{Constrained, Resources};
use super::structural_trace_tests::Tree;
use crate::prelude::*;
use crate::runtime::layout_preservation::Mode;
use serde_json::{Value, json};

fn allocation(a: allocation_counter::AllocationInfo) -> Value {
    json!({"bytes":a.bytes_total,"count":a.count_total,"retained_delta":a.bytes_current,"peak_delta":a.bytes_max})
}
fn run<M: View + 'static>(
    case: &str,
    steps: usize,
    build: impl Fn(usize) -> M,
    update: impl Fn(&mut Win<M>, usize),
    output: &std::path::Path,
) -> Value {
    let mut modes: Vec<_> = [Mode::Automatic, Mode::Ordered, Mode::Append, Mode::Forced]
        .into_iter()
        .map(|mode| {
            let mut owner = Win::with_size(build(0), 64, 64).unwrap();
            owner.layout_preservation_mode(mode);
            (mode, owner, None)
        })
        .collect();
    let mut frames = Vec::new();
    for step in 0..steps {
        let mut fresh = Win::with_size(build(step), 64, 64).unwrap();
        let expected = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
        let expected_layout = fresh.layout_capture();
        for (mode, owner, previous) in &mut modes {
            owner.structural_reset();
            let source = allocation_counter::measure(|| {
                if step != 0 {
                    update(owner, step);
                }
            });
            let report = owner.layout_preservation_report();
            let mut capture = None;
            let capture_allocation =
                allocation_counter::measure(|| capture = Some(owner.layout_capture()));
            let capture = capture.unwrap();
            capture.assert_equivalent(&expected_layout);
            let comparison = previous.as_ref().map(|old| capture.compare(old));
            let retired = previous.as_ref().map(|old| old.assert_retired(owner));
            let actual = owner.with_pixels(|p, _, _| p.to_vec()).unwrap();
            assert_eq!(
                actual, expected,
                "{case} {mode:?} step {step}: fresh CPU oracle"
            );
            std::fs::write(output.join(format!("{case}-{mode:?}-{step}.rgba")), &actual).unwrap();
            frames.push(json!({"step":step,"mode":format!("{mode:?}"),"source_allocation":allocation(source),"diagnostic_capture_allocation":allocation(capture_allocation),"layout":capture.report(),"comparison":comparison,"retired_handles_checked":retired,"preservation":report,"producer":owner.structural_observation(),"fresh_cpu_wrong_bytes":0}));
            *previous = Some(capture);
        }
    }
    json!({"case":case,"frames":frames})
}
struct Measured {
    values: Signal<Vec<(u64, String)>>,
}
impl Measured {
    const VALUES: Source<Self, Vec<(u64, String)>> =
        Source::new(FieldId::new(1), "values", |m| &m.values, |m| &mut m.values);
    fn values(step: usize) -> Vec<(u64, String)> {
        let keys = if step == 0 { [1, 2, 3] } else { [3, 1, 2] };
        keys.into_iter()
            .map(|k| {
                (
                    k,
                    format!(
                        "{}{}",
                        if step == 0 {
                            "a"
                        } else if step == 1 {
                            "long"
                        } else {
                            "wide"
                        },
                        k
                    ),
                )
            })
            .collect()
    }
    fn new(step: usize) -> Self {
        Self {
            values: Signal::new(Self::values(step)),
        }
    }
}
impl crate::ItemSource for Measured {
    fn len(&self) -> usize {
        self.values.len()
    }
    fn key(&self, index: usize) -> crate::ItemKey {
        crate::ItemKey::new(self.values[index].0)
    }
    fn index_of(&self, key: crate::ItemKey) -> Option<usize> {
        self.values.iter().position(|v| v.0 == key.get())
    }
    fn row(&self, index: usize) -> El<'_> {
        text(&self.values[index].1).font_size(12).w(48).h(16)
    }
}
impl View for Measured {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::VALUES)
    }
    fn view(&self) -> El<'_> {
        crate::uniform_list(crate::ListId::new(8), self, 16)
            .size(64)
            .bg(Color::WHITE)
    }
}
#[test]
#[ignore = "explicit bounded layout preservation qualification"]
fn live_layout_preservation() {
    let output =
        std::path::PathBuf::from(std::env::var("GPUI_LAYOUT_PRESERVATION_OUTPUT").unwrap());
    std::fs::create_dir(&output).unwrap();
    let mut cases = Vec::new();
    for (keyed, fillers) in [(true, 4), (true, 256), (false, 4)] {
        let keys = |i| match i {
            1 => vec![1, 9, 2, 3],
            3 => vec![3, 1, 2],
            _ => vec![1, 2, 3],
        };
        cases.push(run(
            &format!("{}-{fillers}", if keyed { "keyed" } else { "unkeyed" }),
            4,
            |i| Tree::new(keyed, fillers, keys(i)),
            |w, i| {
                w.set(Tree::KEYS, keys(i)).unwrap();
            },
            &output,
        ));
        std::fs::write(
            output.join("partial.json"),
            serde_json::to_vec_pretty(&cases).unwrap(),
        )
        .unwrap();
    }
    cases.push(run(
        "resources",
        3,
        |i| Resources::new(i == 1),
        |w, i| {
            w.set(Resources::NEXT, i == 1).unwrap();
        },
        &output,
    ));
    cases.push(run(
        "constraints",
        3,
        |i| Constrained {
            narrow: Signal::new(i == 1),
        },
        |w, i| {
            w.set(Constrained::NARROW, i == 1).unwrap();
        },
        &output,
    ));
    cases.push(run(
        "measured",
        3,
        Measured::new,
        |w, i| {
            w.set(Measured::VALUES, Measured::values(i)).unwrap();
        },
        &output,
    ));
    std::fs::write(
        output.join("trace.json"),
        serde_json::to_vec_pretty(&cases).unwrap(),
    )
    .unwrap();
}
#[test]
#[ignore = "explicit bounded preservation failure and routing controls"]
fn layout_preservation_authority() {
    let output =
        std::path::PathBuf::from(std::env::var("GPUI_LAYOUT_PRESERVATION_FAULT_OUTPUT").unwrap());
    std::fs::create_dir(&output).unwrap();
    let mut rows = Vec::new();
    for mode in [Mode::Ordered, Mode::Append] {
        let mut owner = Win::with_size(Tree::new(true, 4, vec![1, 2, 3]), 64, 64).unwrap();
        owner.layout_preservation_mode(mode);
        owner.set(Tree::KEYS, vec![3, 1, 2]).unwrap();
        let good = owner.with_scene(|_, t| t).unwrap();
        owner.structural_reset();
        assert!(owner.set(Tree::KEYS, vec![u64::MAX]).is_err());
        assert_eq!(owner.with_scene(|_, t| t).unwrap(), good);
        owner.presented(good).unwrap();
        let failure = owner.layout_preservation_report();
        assert!(failure["committed"].is_null());
        owner.structural_reset();
        owner.set(Tree::KEYS, vec![1, 2, 3]).unwrap();
        let rebuilt = owner.structural_observation();
        assert_eq!(rebuilt["work"]["layout_full_rebuilds"], 1);
        let mut fresh = Win::with_size(Tree::new(true, 4, vec![1, 2, 3]), 64, 64).unwrap();
        owner
            .layout_capture()
            .assert_equivalent(&fresh.layout_capture());
        assert_eq!(
            owner.with_pixels(|p, _, _| p.to_vec()).unwrap(),
            fresh.with_pixels(|p, _, _| p.to_vec()).unwrap()
        );
        rows.push(json!({"case":"failed-newer","mode":format!("{mode:?}"),"failure":failure,"recovery":rebuilt,"older_ack_accepted":true}));
    }
    let mut owner = Win::with_size(Measured::new(0), 64, 64).unwrap();
    owner.set(Measured::VALUES, Measured::values(1)).unwrap();
    let qualified = owner.layout_preservation_report();
    assert!(qualified["route_rows"].as_u64().unwrap() > 0);
    let good = owner.with_scene(|_, t| t).unwrap();
    owner.layout_wrong_route();
    let rejected = owner.set(Measured::VALUES, Measured::values(2));
    assert!(
        rejected.is_err(),
        "obsolete sorted-preorder route must be falsified"
    );
    assert_eq!(owner.with_scene(|_, t| t).unwrap(), good);
    owner.presented(good).unwrap();
    rows.push(json!({"case":"wrong-route","qualified":qualified,"rejected":format!("{rejected:?}"),"older_ack_accepted":true}));
    let mut owner = Win::with_size(Resources::new(false), 64, 64).unwrap();
    owner.layout_inject_poison();
    owner.structural_reset();
    owner.set(Resources::NEXT, true).unwrap();
    let mut fresh = Win::with_size(Resources::new(true), 64, 64).unwrap();
    owner
        .layout_capture()
        .assert_equivalent(&fresh.layout_capture());
    assert_eq!(
        owner.with_pixels(|p, _, _| p.to_vec()).unwrap(),
        fresh.with_pixels(|p, _, _| p.to_vec()).unwrap()
    );
    let rebuilt = owner.structural_observation();
    assert_eq!(rebuilt["work"]["layout_full_rebuilds"], 1);
    rows.push(json!({"case":"poison-recovery","producer":rebuilt,"preservation":owner.layout_preservation_report()}));
    std::fs::write(
        output.join("trace.json"),
        serde_json::to_vec_pretty(&rows).unwrap(),
    )
    .unwrap();
}
