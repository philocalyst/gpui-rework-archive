#![allow(dead_code)]

//! Audit harness that compiles the production value API directly from its source files.
//! This deliberately does not depend on GPUI's large workspace or duplicate the production code.

#[path = "../../../../crates/gpui/src/reflection/value.rs"]
pub mod production;

#[cfg(test)]
mod tests {
    use schema_slots_frontier::{Describe, Kind, SchemaBuilder, Type};
    use std::{
        process::{Command, Stdio},
        sync::{
            Arc, Barrier,
            atomic::{AtomicUsize, Ordering},
        },
        thread,
        time::{Duration, Instant},
    };

    use crate::production::{
        Field, ProvideShape as _, Schema, TypeKind, TypeProbe, TypeRegistration,
    };

    struct InventoryChild {
        value: u32,
    }
    static INVENTORY_CHILD_BUILDS: AtomicUsize = AtomicUsize::new(0);
    impl crate::production::Describe for InventoryChild {
        fn build_type() -> Schema<Self> {
            INVENTORY_CHILD_BUILDS.fetch_add(1, Ordering::SeqCst);
            Schema::new(
                vec![
                    Field::new("value", |v: &Self| &v.value, |v| &mut v.value)
                        .into_schema(|| crate::production::Type::opaque::<u32>()),
                ],
                None,
            )
        }
    }
    inventory::submit! { TypeRegistration::of::<InventoryChild>() }

    struct InventoryParent {
        child: InventoryChild,
    }
    impl crate::production::Describe for InventoryParent {
        fn build_type() -> Schema<Self> {
            Schema::new(
                vec![
                    Field::new("child", |v: &Self| &v.child, |v| &mut v.child)
                        .into_schema(crate::production::Type::discover::<InventoryChild>),
                ],
                None,
            )
        }
    }

    struct InventoryRecursive {
        next: Option<Box<InventoryRecursive>>,
    }
    static INVENTORY_RECURSIVE_BUILDS: AtomicUsize = AtomicUsize::new(0);
    impl crate::production::Describe for InventoryRecursive {
        fn build_type() -> Schema<Self> {
            INVENTORY_RECURSIVE_BUILDS.fetch_add(1, Ordering::SeqCst);
            (&TypeProbe::<Self>::new()).provide();
            (&TypeProbe::<Option<Box<Self>>>::new()).provide();
            (&TypeProbe::<Box<Self>>::new()).provide();
            Schema::new(
                vec![
                    Field::new("next", |v: &Self| &v.next, |v| &mut v.next)
                        .into_schema(crate::production::Type::discover::<Option<Box<Self>>>),
                ],
                None,
            )
        }
    }
    inventory::submit! { TypeRegistration::of::<InventoryRecursive>() }

    struct InventoryConcurrent;
    static INVENTORY_CONCURRENT_BUILDS: AtomicUsize = AtomicUsize::new(0);
    impl crate::production::Describe for InventoryConcurrent {
        fn build_type() -> Schema<Self> {
            INVENTORY_CONCURRENT_BUILDS.fetch_add(1, Ordering::SeqCst);
            Schema::new(Vec::new(), None)
        }
    }
    inventory::submit! { TypeRegistration::of::<InventoryConcurrent>() }

    struct Racing;
    static BUILDS: AtomicUsize = AtomicUsize::new(0);
    impl Describe for Racing {
        fn describe() -> SchemaBuilder<Self> {
            BUILDS.fetch_add(1, Ordering::SeqCst);
            SchemaBuilder::scalar()
        }
    }

    #[test]
    fn concurrent_first_describe_builds_exactly_once() {
        BUILDS.store(0, Ordering::SeqCst);
        let barrier = Arc::new(Barrier::new(65));
        let workers: Vec<_> = (0..64)
            .map(|_| {
                let barrier = barrier.clone();
                thread::spawn(move || {
                    barrier.wait();
                    for _ in 0..100 {
                        assert_eq!(Type::of::<Racing>().snapshot().kind(), Kind::Scalar);
                    }
                })
            })
            .collect();
        barrier.wait();
        for worker in workers {
            worker.join().unwrap();
        }
        assert_eq!(BUILDS.load(Ordering::SeqCst), 1);
    }

    struct Upgrade;
    impl Describe for Upgrade {
        fn describe() -> SchemaBuilder<Self> {
            SchemaBuilder::scalar()
        }
    }

    #[test]
    fn old_handles_observe_upgrade_and_snapshots_keep_old_identity() {
        let handle = Type::opaque::<Upgrade>();
        let old = handle.snapshot();
        assert_eq!(old.kind(), Kind::Opaque);
        assert_eq!(Type::of::<Upgrade>(), handle);
        let new = handle.snapshot();
        assert_eq!(new.kind(), Kind::Scalar);
        assert!(!old.matches(new));
    }

    #[test]
    fn readers_racing_opaque_and_described_access_eventually_see_shape() {
        struct ConcurrentUpgrade;
        impl Describe for ConcurrentUpgrade {
            fn describe() -> SchemaBuilder<Self> {
                SchemaBuilder::scalar()
            }
        }
        let handle = Type::opaque::<ConcurrentUpgrade>();
        let readers: Vec<_> = (0..32)
            .map(|_| {
                let handle = handle;
                thread::spawn(move || {
                    for _ in 0..10_000 {
                        let _ = handle.snapshot();
                    }
                })
            })
            .collect();
        let builder = thread::spawn(|| Type::of::<ConcurrentUpgrade>());
        for reader in readers {
            reader.join().unwrap();
        }
        assert_eq!(builder.join().unwrap().snapshot().kind(), Kind::Scalar);
        assert_eq!(handle.snapshot().kind(), Kind::Scalar);
    }

    #[test]
    fn panicking_initializer_can_retry_without_poisoning_the_slot() {
        struct Retry;
        static ATTEMPTS: AtomicUsize = AtomicUsize::new(0);
        impl Describe for Retry {
            fn describe() -> SchemaBuilder<Self> {
                if ATTEMPTS.fetch_add(1, Ordering::SeqCst) == 0 {
                    panic!("one deliberate build failure");
                }
                SchemaBuilder::scalar()
            }
        }
        assert!(std::panic::catch_unwind(Type::of::<Retry>).is_err());
        assert_eq!(Type::of::<Retry>().snapshot().kind(), Kind::Scalar);
        assert_eq!(ATTEMPTS.load(Ordering::SeqCst), 2);
    }

    #[test]
    fn recursive_same_slot_initialization_stalls_in_child_process() {
        // OnceLock intentionally detects no same-thread recursive initialization. Run the
        // reproducer in a child and kill it after a short deadline so the test suite stays live.
        const CHILD: &str = "SCHEMA_SLOT_RECURSION_CHILD";
        if std::env::var_os(CHILD).is_some() {
            struct Recursive;
            impl Describe for Recursive {
                fn describe() -> SchemaBuilder<Self> {
                    let _ = Type::of::<Self>();
                    SchemaBuilder::scalar()
                }
            }
            let _ = Type::of::<Recursive>();
            panic!("recursive initializer unexpectedly returned");
        }
        let exe = std::env::current_exe().unwrap();
        let mut child = Command::new(exe)
            .args([
                "--exact",
                "tests::recursive_same_slot_initialization_stalls_in_child_process",
                "--nocapture",
            ])
            .env(CHILD, "1")
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn()
            .unwrap();
        let deadline = Instant::now() + Duration::from_millis(500);
        loop {
            if let Some(status) = child.try_wait().unwrap() {
                panic!("recursive init child returned unexpectedly: {status}");
            }
            if Instant::now() >= deadline {
                break;
            }
            thread::sleep(Duration::from_millis(5));
        }
        child.kill().unwrap();
        let _ = child.wait();
    }

    #[test]
    fn recursive_wrapper_children_remain_lazy() {
        struct Child;
        impl Describe for Child {
            fn describe() -> SchemaBuilder<Self> {
                SchemaBuilder::scalar()
            }
        }
        let wrapped = Type::vec::<Child>().snapshot();
        assert_eq!(wrapped.kind(), Kind::Sequence);
    }

    #[test]
    fn inventory_child_factory_upgrades_an_old_cached_opaque_handle() {
        INVENTORY_CHILD_BUILDS.store(0, Ordering::SeqCst);
        let old = crate::production::Type::opaque::<InventoryChild>();
        assert_eq!(old.kind(), TypeKind::Opaque);

        let parent = crate::production::Type::of::<InventoryParent>();
        assert_eq!(INVENTORY_CHILD_BUILDS.load(Ordering::SeqCst), 0);
        let child = parent.fields().next().unwrap().ty;

        assert_eq!(child, old);
        assert_eq!(child.kind(), TypeKind::Struct);
        assert_eq!(old.field_names().collect::<Vec<_>>(), ["value"]);
        assert_eq!(INVENTORY_CHILD_BUILDS.load(Ordering::SeqCst), 1);
    }

    #[test]
    fn inventory_factory_and_recursive_child_resolvers_do_not_reenter_root_once_lock() {
        INVENTORY_RECURSIVE_BUILDS.store(0, Ordering::SeqCst);
        let ty = crate::production::Type::discover::<InventoryRecursive>();
        assert_eq!(ty.kind(), TypeKind::Struct);
        assert_eq!(INVENTORY_RECURSIVE_BUILDS.load(Ordering::SeqCst), 1);

        let root = InventoryRecursive {
            next: Some(Box::new(InventoryRecursive { next: None })),
        };
        let root_value = crate::production::Value::new(&root);
        let option = root_value.field("next").unwrap();
        let boxed = option.index(0).unwrap();
        let child = boxed.index(0).unwrap();
        assert!(child.downcast_ref::<InventoryRecursive>().is_some());
        assert_eq!(INVENTORY_RECURSIVE_BUILDS.load(Ordering::SeqCst), 1);
    }

    #[test]
    fn concurrent_inventory_discovery_publishes_one_schema() {
        INVENTORY_CONCURRENT_BUILDS.store(0, Ordering::SeqCst);
        let barrier = Arc::new(Barrier::new(33));
        let workers: Vec<_> = (0..32)
            .map(|_| {
                let barrier = barrier.clone();
                thread::spawn(move || {
                    barrier.wait();
                    for _ in 0..100 {
                        assert_eq!(
                            crate::production::Type::discover::<InventoryConcurrent>().kind(),
                            TypeKind::Struct
                        );
                    }
                })
            })
            .collect();
        barrier.wait();
        for worker in workers {
            worker.join().unwrap();
        }
        assert_eq!(INVENTORY_CONCURRENT_BUILDS.load(Ordering::SeqCst), 1);
    }
}
