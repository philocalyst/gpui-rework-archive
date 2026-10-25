use gpui::reflection::HasMethods;
use std::{
    future::Future,
    pin::Pin,
    task::{Context, Poll, Waker},
};

fn identity(value: &str) -> &str {
    value
}

#[gpui::reflect]
mod probe {
    use std::pin::Pin;

    pub struct Root<'__gpui_reflect_self> {
        pub value: &'__gpui_reflect_self str,
    }

    impl<'__gpui_reflect_self> Root<'__gpui_reflect_self> {
        pub fn borrow_both<'arg>(&self, independent: &'arg str) -> (&Self, &'arg str) {
            (self, independent)
        }

        pub fn chars(&self, _independent: &str) -> std::str::Chars<'_> {
            self.value.chars()
        }

        pub fn display(&self, _independent: &str) -> Box<dyn std::fmt::Display + '_> {
            Box::new(self.value)
        }
    }

    pub struct MethodsOnly(pub u8);

    impl MethodsOnly {
        pub fn explicit_ref<'__gpui_reflect_self>(
            self: &Self,
            independent: &'__gpui_reflect_self str,
        ) -> (&'_ Self, &'__gpui_reflect_self str) {
            (self, independent)
        }

        pub fn pinned<'__gpui_reflect_self>(
            self: Pin<&Self>,
            independent: &'__gpui_reflect_self str,
        ) -> (Pin<&Self>, &'__gpui_reflect_self str) {
            (self, independent)
        }

        pub fn placeholder_borrows<'arg>(&self, independent: &'arg str) -> (&'_ Self, &'arg str) {
            (self, independent)
        }

        pub fn fn_pointer(&self) -> fn(&str) -> &str {
            identity
        }

        pub fn fn_trait(&self) -> Box<dyn Fn(&str) -> &str> {
            Box::new(identity)
        }

        pub fn higher_ranked_arg(
            &self,
            callback: for<'__gpui_reflect_self> fn(
                &'__gpui_reflect_self str,
            ) -> &'__gpui_reflect_self str,
        ) -> usize {
            callback("binder").len()
        }

        pub fn owned_iterator(&self) -> impl Iterator<Item = u8> {
            [self.0].into_iter()
        }

        pub async fn async_value(&self) -> u8 {
            self.0
        }
    }

    fn identity(value: &str) -> &str {
        value
    }
}

#[test]
fn reflected_methods_preserve_receiver_and_argument_borrows() {
    let owned_receiver = String::from("receiver");
    let root = probe::Root {
        value: &owned_receiver,
    };
    let independent = String::from("argument");
    let methods = <probe::Root<'_> as HasMethods>::methods();

    let (native_receiver, native_argument) = root.borrow_both(&independent);
    assert_eq!(native_receiver.value, "receiver");
    assert_eq!(native_argument, "argument");

    let (receiver, argument) = methods.borrow_both.call(&root, &independent);
    assert_eq!(receiver.value, "receiver");
    assert_eq!(argument, "argument");
    assert_eq!(
        methods.chars.call(&root, &independent).collect::<String>(),
        "receiver"
    );
    assert_eq!(
        methods.display.call(&root, &independent).to_string(),
        "receiver"
    );
    let borrow_both = methods.borrow_both;
    let _copied_borrow_both = borrow_both;
    let (_, argument) = borrow_both.call(&root, &independent);
    assert_eq!(argument, "argument");

    let methods = <probe::MethodsOnly as HasMethods>::methods();
    let receiver_only = probe::MethodsOnly(9);
    let (native_receiver, native_argument) = receiver_only.explicit_ref(&independent);
    assert_eq!(native_receiver.0, 9);
    assert_eq!(native_argument, "argument");
    let (receiver, argument) = methods.explicit_ref.call(&receiver_only, &independent);
    assert_eq!(receiver.0, 9);
    assert_eq!(argument, "argument");

    let (receiver, argument) = methods
        .placeholder_borrows
        .call(&receiver_only, &independent);
    assert_eq!(receiver.0, 9);
    assert_eq!(argument, "argument");

    let pinned = Pin::new(&receiver_only);
    let (receiver, argument) = methods.pinned.call(pinned, &independent);
    assert_eq!(receiver.get_ref().0, 9);
    assert_eq!(argument, "argument");
}

#[test]
fn nested_function_signatures_keep_independent_borrows() {
    let methods = <probe::MethodsOnly as HasMethods>::methods();
    let receiver_only = probe::MethodsOnly(9);
    let function = {
        let temporary = probe::MethodsOnly(4);
        methods.fn_pointer.call(&temporary)
    };
    let other_argument = String::from("independent");
    assert_eq!(function(&other_argument), "independent");

    let fn_trait = {
        let temporary = probe::MethodsOnly(5);
        methods.fn_trait.call(&temporary)
    };
    assert_eq!(fn_trait(&other_argument), "independent");
    assert_eq!(methods.higher_ranked_arg.call(&receiver_only, identity), 6);
}

#[test]
fn returned_values_and_futures_do_not_borrow_temporary_descriptors() {
    let receiver_only = probe::MethodsOnly(9);
    let mut iter = <probe::MethodsOnly as HasMethods>::methods()
        .owned_iterator
        .call(&receiver_only);
    assert_eq!(iter.next(), Some(9));

    let future = <probe::MethodsOnly as HasMethods>::methods()
        .async_value
        .call(&receiver_only);
    let mut context = Context::from_waker(Waker::noop());
    assert_eq!(
        std::pin::pin!(future).as_mut().poll(&mut context),
        Poll::Ready(9)
    );
}

mod where_bounds {
    use gpui::reflection::{HasFields, HasMethods, HasVariantFields};

    #[gpui::reflect]
    mod probe {
        pub struct Bounded<T>
        where
            T: Clone,
        {
            pub value: T,
        }

        impl<T> Bounded<T>
        where
            T: Clone,
        {
            pub fn cloned(&self) -> T {
                self.value.clone()
            }
        }

        pub enum BoundedEnum<T>
        where
            T: Clone,
        {
            Empty,
            Value(T),
        }

        pub struct BoundedTuple<T>(pub T)
        where
            T: Clone;
    }

    #[test]
    fn reflected_accessors_preserve_where_bounds() {
        let value = probe::Bounded {
            value: String::from("value"),
        };
        let fields = <probe::Bounded<String> as HasFields>::fields();
        assert_eq!(fields.value.get(&value), "value");
        let methods = <probe::Bounded<String> as HasMethods>::methods();
        assert_eq!(methods.cloned.call(&value), "value");

        let variant = probe::BoundedEnum::Value(String::from("enum"));
        let fields = <probe::BoundedEnum<String> as HasVariantFields>::variant_fields();
        assert_eq!(
            fields.value.field_0.get(&variant).map(String::as_str),
            Some("enum")
        );
        assert!(
            fields
                .value
                .field_0
                .get(&probe::BoundedEnum::Empty)
                .is_none()
        );

        let tuple = probe::BoundedTuple(String::from("tuple"));
        let tuple_fields = <probe::BoundedTuple<String> as HasFields>::fields();
        assert_eq!(tuple_fields.field_0.get(&tuple), "tuple");
    }
}
