//! Complete public compute calls, with filtering and dirty-layout cells separated.
use cephal::style::Dimension;
use gpui_reactivity_core::{
    NodeId, NodeKind,
    layout::{AvailableSpace, LayoutTree, Size, Style},
};
use std::time::Instant;

fn cpu_ns() -> u64 {
    #[repr(C)]
    struct Timespec {
        seconds: i64,
        nanoseconds: i64,
    }
    unsafe extern "C" {
        fn clock_gettime(clock: i32, time: *mut Timespec) -> i32;
    }
    let mut time = Timespec {
        seconds: 0,
        nanoseconds: 0,
    };
    // SAFETY: Linux CLOCK_PROCESS_CPUTIME_ID and a live writable timespec.
    assert_eq!(unsafe { clock_gettime(2, &mut time) }, 0);
    time.seconds as u64 * 1_000_000_000 + time.nanoseconds as u64
}
fn style(width: f32) -> Style {
    Style {
        size: Size {
            width: Dimension::length(width),
            height: Dimension::length(1.),
        },
        ..Style::DEFAULT
    }
}
fn fingerprint(tree: &LayoutTree, nodes: &[NodeId]) -> u64 {
    let mut hash = 0xcbf29ce484222325_u64;
    for node in nodes {
        let l = tree.layout(*node).unwrap();
        for byte in l.order.to_le_bytes() {
            hash = (hash ^ u64::from(byte)).wrapping_mul(0x100000001b3);
        }
        let rects = [l.scrollable_overflow_rect, l.border, l.padding, l.margin];
        for f in [
            l.location.x,
            l.location.y,
            l.size.width,
            l.size.height,
            l.scrollbar_size.width,
            l.scrollbar_size.height,
        ]
        .into_iter()
        .chain(
            rects
                .into_iter()
                .flat_map(|r| [r.left, r.right, r.top, r.bottom]),
        ) {
            for byte in f.to_bits().to_le_bytes() {
                hash = (hash ^ u64::from(byte)).wrapping_mul(0x100000001b3);
            }
        }
    }
    hash
}
fn main() {
    let case = std::env::args().nth(1).expect("case");
    let (count, depth, edits, shuffled, full) = match case.as_str() {
        "tiny" => (256, 8, 8, false, true),
        "contiguous" => (65536, 8, 256, false, false),
        "shuffled" => (65536, 128, 512, true, false),
        "medium-depth" => (65536, 32, 512, true, false),
        "shallow" => (65536, 1, 512, true, false),
        "single-full" => (32768, 8, 32, true, true),
        "mixed-depth" => (65536, 128, 512, true, false),
        _ => panic!("unknown case"),
    };
    let viewport = Size {
        width: AvailableSpace::Definite(960.),
        height: AvailableSpace::Definite(720.),
    };
    eprintln!(
        "TOPOLOGY,header={},aggregate_slot={}",
        std::mem::size_of::<gpui_reactivity_core::Tree>(),
        gpui_reactivity_core::Tree::entry_bytes()
    );
    let cold = Instant::now();
    let mut tree = LayoutTree::new();
    let root = tree.insert(None, NodeKind::Element, style(960.)).unwrap();
    let query = if full {
        root
    } else {
        tree.insert(None, NodeKind::Element, style(960.)).unwrap()
    };
    let branches = count / depth;
    let mut tips = vec![root; branches];
    let mut nodes = vec![root];
    // Interleaving branches by depth separates each dependent parent from its
    // child. Odd affine permutations are bijections for these power-of-two cells.
    if shuffled {
        for level in 0..depth {
            for j in 0..branches {
                let i = (j * 193 + level * 37) % branches;
                if case == "mixed-depth" && level > (i * 53) % 128 {
                    continue;
                }
                let node = tree
                    .insert(Some(tips[i]), NodeKind::Element, style(1.))
                    .unwrap();
                tips[i] = node;
                nodes.push(node);
            }
        }
    } else {
        for tip in &mut tips {
            for _ in 0..depth {
                let node = tree
                    .insert(Some(*tip), NodeKind::Element, style(1.))
                    .unwrap();
                *tip = node;
                nodes.push(node);
            }
        }
    }
    tree.compute(root, viewport).unwrap();
    if !full {
        tree.compute(query, viewport).unwrap();
    }
    let targets: Vec<_> = tips.into_iter().take(edits).collect();
    for id in &targets {
        tree.mark_dirty(*id).unwrap();
    }
    eprintln!(
        "COLD,{case},{},{:?}",
        cold.elapsed().as_nanos(),
        tree.storage()
    );
    let mut step = 0;
    let mut run = || {
        if full {
            for id in &targets {
                tree.set_style(*id, style(1. + (step % 2) as f32)).unwrap();
            }
        }
        let computed = tree.compute(query, viewport).unwrap();
        if !full {
            assert!(!computed);
        }
        step += 1;
    };
    for _ in 0..200 {
        run();
    }
    println!("case,batch,ops,cpu_ns,wall_ns");
    for batch in 0..40 {
        let wall = Instant::now();
        let cpu = cpu_ns();
        for _ in 0..5 {
            run();
        }
        let cpu = cpu_ns() - cpu;
        let wall = wall.elapsed().as_nanos();
        println!("{case},{batch},5,{cpu},{wall}");
    }
    if !full {
        assert!(tree.compute(root, viewport).unwrap());
    }
    eprintln!(
        "FINAL,{case},{:016x},{:?}",
        fingerprint(&tree, &nodes),
        tree.stats()
    );
}
