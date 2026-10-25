use module_reflection_frontier::{ElementSchema, Reflect};

#[module_reflection_frontier::reflect]
mod view {
    pub trait Reset {
        fn reset(&mut self);
    }

    pub struct Counter {
        pub count: i32,
        label: String,
    }

    impl Counter {
        pub fn new(count: i32, label: String) -> Self {
            Self { count, label }
        }

        pub fn increment(&mut self, by: i32) -> i32 {
            self.count += by;
            self.count
        }

        fn private_label(&self) -> &str {
            &self.label
        }
    }

    impl Reset for Counter {
        fn reset(&mut self) {
            self.count = 0;
        }
    }

    pub struct Pair<T> {
        pub left: T,
        pub right: T,
    }

    pub struct Point(pub f32, pub f32);

    impl<T: Clone> Pair<T> {
        pub fn duplicate_left(&self) -> T {
            self.left.clone()
        }
    }

    pub enum Event<T> {
        Quit,
        Value(T),
        Named { value: T, source: String },
    }

    pub fn private_label_len(value: &Counter) -> usize {
        <Counter as ::module_reflection_frontier::Reflect>::fields()
            .label
            .get(value)
            .len()
    }
}

#[test]
fn generated_named_fields_are_typed_and_settable() {
    let mut value = view::Counter::new(2, "ticks".into());
    let fields = view::Counter::fields();
    assert_eq!(*fields.count.get(&value), 2);
    fields.count.set(&mut value, 5);
    assert_eq!(*fields.count.get(&value), 5);
    assert_eq!(view::private_label_len(&value), 5);
    assert_eq!(view::Counter::field_names(), &["count", "label"]);
}

#[test]
fn impls_generics_variants_and_schema_are_discovered() {
    let methods = view::Counter::methods();
    assert!(
        methods
            .iter()
            .any(|method| method.name == "increment" && method.trait_name.is_none())
    );
    assert!(
        methods
            .iter()
            .any(|method| method.name == "reset" && method.trait_name.as_deref() == Some("Reset"))
    );
    assert!(methods.iter().all(|method| method.signature.contains("fn")));

    let pair = view::Pair {
        left: String::from("a"),
        right: String::from("b"),
    };
    let fields = <view::Pair<String> as Reflect>::fields();
    assert_eq!(fields.left.get(&pair), "a");
    assert_eq!(
        <view::Pair<String> as Reflect>::methods()[0].name,
        "duplicate_left"
    );

    let point = view::Point(1.5, 2.5);
    let point_fields = view::Point::fields();
    assert_eq!(*point_fields.field_0.get(&point), 1.5);
    assert_eq!(*point_fields.field_1.get(&point), 2.5);

    let variants = <view::Event<u8> as Reflect>::variants();
    assert_eq!(
        variants
            .iter()
            .map(|variant| variant.name)
            .collect::<Vec<_>>(),
        ["Quit", "Value", "Named"]
    );
    assert_eq!(variants[2].fields, &["value", "source"]);

    let schema = <view::Counter as ElementSchema>::schema();
    assert!(schema.type_name.ends_with("::view::Counter"));
    assert_eq!(schema.fields, ["count", "label"]);
    assert_eq!(schema.methods.len(), methods.len());
}
