extern crate discovery_macro_audit as gpui;

use discovery_macro_audit::reflect;
use discovery_macro_audit::reflection::HasMethods;
use std::fmt::Display;
use std::str::Chars;

#[reflect]
mod probe {
    pub struct Root<'a> {
        pub value: &'a str,
    }

    impl<'a> Root<'a> {
        pub fn chars(&self, _independent: &str) -> std::str::Chars<'_> {
            self.value.chars()
        }

        pub fn display(&self, _independent: &str) -> Box<dyn std::fmt::Display + '_> {
            Box::new(self.value)
        }
    }
}

#[test]
fn placeholder_lifetimes_in_generic_return_types_borrow_from_receiver() {
    let root = probe::Root { value: "receiver" };
    let independent = String::from("independent");
    let methods = <probe::Root<'_> as HasMethods>::methods();

    let mut chars: Chars<'_> = methods.chars.call(&root, &independent);
    assert_eq!(chars.next(), Some('r'));

    let display: Box<dyn Display + '_> = methods.display.call(&root, &independent);
    assert_eq!(display.to_string(), "receiver");
}
