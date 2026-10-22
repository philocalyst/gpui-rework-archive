//! Read-only distribution fixture. Its maps are instrumentation, not retained UI.
use super::*;
use crate::prelude::*;
#[path = "../../examples/support/graphics.rs"]
mod graphics;
#[cfg(any(
    feature = "accessibility",
    all(target_os = "linux", any(feature = "x11", feature = "x11-minimal"))
))]
use crate::native::test_library as library;
#[cfg(not(any(
    feature = "accessibility",
    all(target_os = "linux", any(feature = "x11", feature = "x11-minimal"))
)))]
#[path = "../../examples/support/library.rs"]
mod library;
#[cfg(all(target_os = "linux", any(feature = "x11", feature = "x11-minimal")))]
use crate::native::test_todos as todos;
#[cfg(not(all(target_os = "linux", any(feature = "x11", feature = "x11-minimal"))))]
#[path = "../../examples/support/todos.rs"]
mod todos;
#[path = "../../examples/support/workspace.rs"]
mod workspace;

fn style_key(style: Style, transform: bool) -> [u32; 24] {
    let mut key = [0; 24];
    key[..4].copy_from_slice(&[
        u32::from(style.width.is_some()),
        style.width.unwrap_or_default().to_bits(),
        u32::from(style.height.is_some()),
        style.height.unwrap_or_default().to_bits(),
    ]);
    key[4..7].copy_from_slice(&[style.gap, style.padding, style.font_size].map(f32::to_bits));
    key[7] = style.fg.space() as u32;
    key[8..12].copy_from_slice(&style.fg.channels().map(f32::to_bits));
    key[12] = style.bg.space() as u32;
    key[13..17].copy_from_slice(&style.bg.channels().map(f32::to_bits));
    // Closed repr(u8) enums and a bool fit the existing distribution-key word.
    key[17] = style.flow as u32
        | ((style.align as u32) << 8)
        | ((style.justify as u32) << 16)
        | (u32::from(style.wrap) << 24);
    if transform {
        key[18..].copy_from_slice(&affine_key(style.transform));
    }
    key
}
fn affine_key(map: Affine) -> [u32; 6] {
    [map.a, map.b, map.c, map.d, map.tx, map.ty].map(f32::to_bits)
}
fn acknowledge<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn open<M: View + 'static>(model: M, size: [u32; 2]) -> Win<M> {
    let mut win = Win::recording(
        model,
        WindowOptions {
            size,
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    win
}
fn ledger<M: View + 'static>(name: &str, win: &Win<M>) {
    let runtime = win.runtime().unwrap();
    let styles = runtime
        .nodes
        .iter()
        .enumerate()
        .map(|(index, _)| style_key(*runtime.styles.get(index), true))
        .collect::<BTreeSet<_>>();
    let sans_transform = runtime
        .nodes
        .iter()
        .enumerate()
        .map(|(index, _)| style_key(*runtime.styles.get(index), false))
        .collect::<BTreeSet<_>>();
    let authored = runtime
        .nodes
        .iter()
        .enumerate()
        .map(|(index, _)| affine_key(runtime.styles.get(index).transform))
        .collect::<BTreeSet<_>>();
    let defaults = runtime
        .nodes
        .iter()
        .enumerate()
        .filter(|(index, _)| {
            style_key(*runtime.styles.get(*index), true) == style_key(Style::default(), true)
        })
        .count();
    let maps = runtime
        .presented
        .iter()
        .filter_map(|node| node.transform.get())
        .map(affine_key)
        .collect::<BTreeSet<_>>();
    let linear = maps
        .iter()
        .map(|map| [map[0], map[1], map[2], map[3]])
        .collect::<BTreeSet<_>>();
    let none = runtime
        .presented
        .iter()
        .filter(|node| node.transform.get().is_none())
        .count();
    let (mode, style_bytes) = match &runtime.styles {
        styles::Styles::Default => ("default", 0),
        styles::Styles::Dense(values) => ("dense", values.capacity() * size_of::<Style>()),
        styles::Styles::Shared { palette, indices } => (
            "shared",
            size_of_val(palette.as_ref()) + size_of_val(indices.as_ref()),
        ),
    };
    println!(
        "{name},{},{},{},{},{},{},{},{},{},{},{},{mode},{style_bytes}",
        runtime.nodes.len(),
        styles.len(),
        sans_transform.len(),
        defaults,
        authored.len(),
        runtime.presented.len(),
        maps.len(),
        linear.len(),
        none,
        runtime.nodes.capacity() * size_of::<Node>(),
        runtime.presented.capacity() * size_of::<Presented>()
    );
}

struct Counter {
    count: Signal<u32>,
}
impl Counter {
    const COUNT: Source<Self, u32> =
        Source::new(FieldId::new(1), "count", |m| &m.count, |m| &mut m.count);
}
impl View for Counter {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COUNT)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.count).text_lg(),
            button("Increment")
                .p(8)
                .bg(rgb(0xdbeafe))
                .on_click(Self::COUNT.update(|count| *count += 1)),
        ))
        .p(12)
        .gap(8)
    }
}
struct Adversary {
    count: usize,
    mode: u8,
    frame: u32,
}
impl View for Adversary {
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            match self.mode {
                0 => div(),
                1 => div().size(1).bg(rgb(0xdbeafe)),
                2 => div()
                    .size(1 + index % 4)
                    .bg(rgb((index % 8) as u32 * 0x10203)),
                _ => div()
                    .size(1)
                    .bg(rgb(index as u32))
                    .transform(Affine::rotation(
                        index as f32 * 0.00001 + self.frame as f32 * 0.01,
                    )),
            }
        }))
    }
}

#[test]
#[ignore = "explicit retained style/map distribution; no timing claim"]
fn real_application_and_adversarial_distribution() {
    println!(
        "Style={},Node={},Presented={},Runtime={}",
        size_of::<Style>(),
        size_of::<Node>(),
        size_of::<Presented>(),
        size_of::<Runtime<()>>()
    );
    println!(
        "trace,nodes,styles,styles_without_transform,default_styles,authored_maps,p_nodes,p_maps,p_linear,p_none,node_capacity_bytes,p_capacity_bytes,style_mode,style_capacity_bytes"
    );
    let mut counter = open(
        Counter {
            count: Signal::new(0),
        },
        [360, 240],
    );
    ledger("counter_mount", &counter);
    counter.activate(counter.button("Increment")).unwrap();
    acknowledge(&mut counter);
    ledger("counter_increment", &counter);
    let mut todos = open(todos::Todos::default(), [640, 1000]);
    ledger("todos_empty", &todos);
    for index in 0..32 {
        todos
            .type_text(todos.input(), &format!("Task {index}"))
            .unwrap();
        acknowledge(&mut todos);
        todos.activate(todos.button("Add")).unwrap();
        acknowledge(&mut todos);
        if [0, 7, 31].contains(&index) {
            ledger(&format!("todos_{}", index + 1), &todos);
        }
    }
    let mut workspace = open(workspace::Workspace::default(), [1100, 800]);
    ledger("workspace_mount", &workspace);
    workspace.activate(workspace.button("Rotate")).unwrap();
    acknowledge(&mut workspace);
    ledger("workspace_rotate", &workspace);
    let mut library = open(library::Library::new(250_000), [760, 600]);
    ledger("library_mount", &library);
    let list = library.list(library::LIBRARY).unwrap();
    library.scroll_to_index(list, 120_000).unwrap();
    acknowledge(&mut library);
    ledger("library_middle", &library);
    library.scroll_to_index(list, 249_999).unwrap();
    acknowledge(&mut library);
    ledger("library_tail", &library);
    library.resize_scaled([760, 600], 1.5).unwrap();
    acknowledge(&mut library);
    ledger("library_density", &library);
    for mode in 0..4 {
        let mut win = open(
            Adversary {
                count: 4096,
                mode,
                frame: 0,
            },
            [640, 480],
        );
        ledger(&format!("adversary_{mode}"), &win);
        if mode == 3 {
            for frame in 1..33 {
                win.update(|m| m.frame = frame).unwrap();
                acknowledge(&mut win);
            }
            ledger("adversary_unique_after_32_updates", &win);
        }
    }
}

fn cost(label: &str, operations: usize, mut operation: impl FnMut()) {
    let start = std::time::Instant::now();
    for _ in 0..operations {
        operation();
    }
    let elapsed = start.elapsed().as_nanos();
    println!("cost,{label},{operations},{elapsed}");
}

#[test]
#[ignore = "explicit paired release fixture; coordinate a quiet CPU window"]
fn retained_style_cost() {
    // Keep the real immutable font face resident for both executables. Loading
    // the font once would obscure the representation's much smaller costs.
    let mut counter = open(
        Counter {
            count: Signal::new(0),
        },
        [360, 240],
    );
    let counter_target = counter.button("Increment");
    let mut todos = open(todos::Todos::default(), [640, 1000]);
    let add = todos.button("Add");
    let input = todos.input();
    for index in 0..32 {
        todos.type_text(input, &format!("Task {index}")).unwrap();
        todos.activate(add).unwrap();
        acknowledge(&mut todos);
    }
    let mut workspace = open(workspace::Workspace::default(), [1100, 800]);
    let rotate = workspace.button("Rotate");
    let mut library = open(library::Library::new(250_000), [760, 600]);
    let list = library.list(library::LIBRARY).unwrap();
    for round in 0..3 {
        for mode in 0..4 {
            let mut mount_ns = 0;
            for _ in 0..4 {
                let start = std::time::Instant::now();
                let win = open(
                    Adversary {
                        count: 4096,
                        mode,
                        frame: 0,
                    },
                    [640, 480],
                );
                mount_ns += start.elapsed().as_nanos();
                win.with_scene(|scene, token| {
                    std::hint::black_box((scene.width, scene.draws().count(), token))
                })
                .unwrap();
                drop(win);
            }
            println!("cost,mount_{mode},4,{mount_ns}");
            let mut win = open(
                Adversary {
                    count: 4096,
                    mode,
                    frame: 0,
                },
                [640, 480],
            );
            cost(&format!("equal_{mode}"), 16, || {
                win.update(|_| {}).unwrap();
            });
            cost(&format!("update_{mode}"), 16, || {
                win.update(|model| model.frame += 1).unwrap();
                acknowledge(&mut win);
            });
            let panel = win.inspect().unwrap().nodes[1].target.unwrap();
            cost(&format!("first_override_{mode}"), 1, || {
                win.set_property(
                    panel,
                    crate::property::BACKGROUND,
                    Contribution::Set(Color::WHITE),
                )
                .unwrap();
                acknowledge(&mut win);
            });
            cost(&format!("warm_override_{mode}"), 16, || {
                win.set_property(
                    panel,
                    crate::property::BACKGROUND,
                    Contribution::Set(Color::BLACK),
                )
                .unwrap();
                acknowledge(&mut win);
                win.set_property(
                    panel,
                    crate::property::BACKGROUND,
                    Contribution::Set(Color::WHITE),
                )
                .unwrap();
                acknowledge(&mut win);
            });
        }
        cost("counter_exact", 32, || {
            counter.activate(counter_target).unwrap();
            acknowledge(&mut counter);
        });
        cost("todos_equal", 32, || {
            todos.update(|_| {}).unwrap();
        });
        cost("workspace_rotate", 32, || {
            workspace.activate(rotate).unwrap();
            acknowledge(&mut workspace);
        });
        cost("library_equal", 32, || {
            library.update(|_| {}).unwrap();
        });
        let mut index = 0;
        cost("library_scroll", 32, || {
            index = (index + 1003) % 250_000;
            library.scroll_to_index(list, index).unwrap();
            acknowledge(&mut library);
        });
        println!("round,{round}");
    }
}

#[test]
#[ignore = "explicit whole-owner allocation and peak ledger, including layout/canvas"]
fn retained_style_owner_memory() {
    for mode in 0..4 {
        for pending in [false, true] {
            let mut owner = None;
            let allocation = allocation_counter::measure(|| {
                let mut win = open(
                    Adversary {
                        count: 4096,
                        mode,
                        frame: 0,
                    },
                    [640, 480],
                );
                if pending {
                    win.update(|model| model.frame += 1).unwrap();
                    // Force a complete candidate even when the model edit has
                    // no visual effect. Keep the acknowledged 640-wide P.
                    win.resize([641, 480]).unwrap();
                }
                owner = Some(win);
            });
            println!(
                "owner_memory,mode={mode},pending={pending},allocations={},requested_bytes={},live_allocations={},live_bytes={},peak_bytes={}",
                allocation.count_total,
                allocation.bytes_total,
                allocation.count_current,
                allocation.bytes_current,
                allocation.bytes_max
            );
            std::hint::black_box(owner);
        }
    }
}

#[test]
fn inspector_shared_lane_is_reclaimed_after_inherit_and_redescription() {
    let mut win = open(
        Adversary {
            count: 128,
            mode: 0,
            frame: 0,
        },
        [64, 64],
    );
    assert!(matches!(
        win.runtime().unwrap().styles,
        styles::Styles::Default
    ));
    let panel = win.inspect().unwrap().nodes[1].target.unwrap();
    win.set_property(
        panel,
        crate::property::BACKGROUND,
        Contribution::Set(Color::WHITE),
    )
    .unwrap();
    assert!(matches!(
        win.runtime().unwrap().styles,
        styles::Styles::Shared { .. }
    ));
    win.set_property(panel, crate::property::BACKGROUND, Contribution::Inherit)
        .unwrap();
    win.update(|_| {}).unwrap();
    assert!(matches!(
        win.runtime().unwrap().styles,
        styles::Styles::Default
    ));
}
