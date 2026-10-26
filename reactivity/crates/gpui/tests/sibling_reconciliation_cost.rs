//! Public complete-owner allocation controls; not a timing measurement.
use gpui::prelude::*;

struct Tree {
    width: usize,
    groups: usize,
    revision: usize,
}
impl View for Tree {
    fn view(&self) -> El<'_> {
        let mut root = column(());
        for _ in 0..self.groups {
            let mut group = column(());
            for _ in 0..self.width {
                group = group.child(div().w(1).h(1));
            }
            root = root.child(group);
        }
        root
    }
}

#[test]
fn ordinary_redescription_requested_allocation_rows() {
    drop(
        Win::with_size(
            Tree {
                width: 0,
                groups: 0,
                revision: 0,
            },
            240,
            120,
        )
        .unwrap(),
    );
    for (groups, width) in [
        (0, 0),
        (1, 0),
        (1, 1),
        (1, 32),
        (1, 1024),
        (32, 32),
        (1, 16384),
    ] {
        let mut owner = Win::with_size(
            Tree {
                width,
                groups,
                revision: 0,
            },
            240,
            120,
        )
        .unwrap();
        let original = owner.with_scene(|_, token| token).unwrap();
        let allocation = allocation_counter::measure(|| {
            for _ in 0..3 {
                let commit = owner.update(|model| model.revision += 1).unwrap();
                assert_eq!(commit.changed_nodes, 0);
            }
        });
        assert_eq!(owner.root().unwrap().revision, 3);
        assert_eq!(owner.with_scene(|_, token| token).unwrap(), original);
        println!(
            "SIBLING_OWNER groups={groups} width={width} count={} requested={} retained={} peak={}",
            allocation.count_total,
            allocation.bytes_total,
            allocation.bytes_current,
            allocation.bytes_max
        );
    }
}

/// Run only in a coordinated paired campaign with separately frozen binaries.
#[test]
#[ignore = "explicit matched release measurement"]
fn ordinary_redescription_release_samples() {
    let cohort = std::env::var("SIBLING_COHORT").unwrap();
    let (groups, width, iterations) = match cohort.as_str() {
        "tiny" => (0, 0, 20_000),
        "flat1k" => (1, 1024, 100),
        "nested1k" => (32, 32, 100),
        "flat16k" => (1, 16384, 10),
        _ => panic!("unknown cohort"),
    };
    let mut owner = Win::with_size(
        Tree {
            width,
            groups,
            revision: 0,
        },
        240,
        120,
    )
    .unwrap();
    for _ in 0..2 {
        owner.update(|model| model.revision += 1).unwrap();
    }
    let start = std::time::Instant::now();
    for _ in 0..iterations {
        let commit = owner.update(|model| model.revision += 1).unwrap();
        assert_eq!(commit.changed_nodes, 0);
        std::hint::black_box(commit);
    }
    let elapsed = start.elapsed().as_nanos();
    assert_eq!(owner.root().unwrap().revision, iterations + 2);
    println!("SIBLING_TIME cohort={cohort} iterations={iterations} elapsed_ns={elapsed}");
}
