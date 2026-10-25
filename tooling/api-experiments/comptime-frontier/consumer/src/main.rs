use frontier_reflect::{Value, reflect_module, view};

#[reflect_module]
mod elements {
    pub struct Child { pub label: u32 }

    pub struct Panel {
        pub opacity: f32,
        pub visible: bool,
        pub children: u32,
        pub child: Child,
    }

    impl Panel {
        pub fn clear(&mut self) { self.children = 0; }
        #[allow(dead_code)]
        fn private_helper(&mut self) { self.visible = true; }
    }
}

fn main() {
    let mut panel = elements::Panel { opacity: 0.4, visible: false, children: 3, child: elements::Child { label: 7 } };
    let mut view = view(&mut panel);
    assert_eq!(view.ty().name, "Panel");
    assert_eq!(view.ty().fields.len(), 4);
    assert_eq!(view.get("opacity").map(|v| matches!(v, Value::F32(x) if x == 0.4)), Some(true));
    assert!(view.set("opacity", Value::F32(0.8)));
    assert!(view.set("visible", Value::Bool(true)));
    let Some(Value::Borrowed(child)) = view.get("child") else { panic!("nested field not exposed") };
    assert_eq!(child.downcast_ref::<elements::Child>().unwrap().label, 7);
    assert!(!view.call("private_helper"));
    assert!(view.call("clear"));
    assert!(!view.call("missing"));
    drop(view);
    assert_eq!(panel.opacity, 0.8);
    assert!(panel.visible);
    assert_eq!(panel.children, 0);
}
