use super::{expand_membership_trait, expand_reflect, expand_trait};
use crate::trait_items::{UnknownMacros, configuration_attributes, normalize_trait_items};
use quote::quote;
use syn::{ItemTrait, TraitItem, TraitItemFn, parse_quote};

#[test]
fn automatic_trait_probes_type_their_registration_receiver() {
    let output = expand_reflect(parse_quote! { struct Card; }).unwrap();
    let rendered = output.to_string();

    assert!(rendered.contains("trait Detect < Receiver : 'static >"));
    assert!(rendered.contains("ReflectedImplementation < Receiver >"));
    assert!(rendered.contains("Detect < Receiver > for & Probe < Receiver >"));
    syn::parse2::<syn::File>(output).unwrap();
}

#[test]
fn registers_capabilities_with_identity_or_projection() {
    for (declaration, expected) in [
        (
            "#[reflect(capability(DRAG))] struct Card;",
            "DRAG . bind :: < Self > (| element | element)",
        ),
        (
            "#[reflect(capability(DRAG => |element| &mut element.drag))] struct Card;",
            "DRAG . bind :: < Self > (| element | & mut element . drag)",
        ),
    ] {
        let output = expand_reflect(syn::parse_str(declaration).unwrap()).unwrap();
        assert!(output.to_string().contains(expected), "{output}");
        syn::parse2::<syn::File>(output).unwrap();
    }
}

#[test]
fn accepts_explicit_generic_registration_and_membership_declarations() {
    for declaration in [
        "#[reflect(gpui::Styled)] struct Panel<State>(State) where State: Clone;",
        "#[reflect()] struct Buffer<const COUNT: usize>([u8; COUNT]);",
        "#[reflect(Marker)] struct Borrowed<'data>(&'data str);",
    ] {
        let output = expand_reflect(syn::parse_str(declaration).unwrap()).unwrap();

        syn::parse2::<syn::File>(output).unwrap();
    }

    let error = expand_reflect(parse_quote! { struct Missing<State>(State); }).unwrap_err();

    assert!(error.to_string().contains("explicit #[reflect(...)] list"));

    let output = expand_membership_trait(parse_quote! {
        trait PaintSource: std::fmt::Debug + Send {
            type Brush;
            const PALETTE_SIZE: usize;
            fn paint<Input>(&self, input: Input) -> Self::Brush;
        }
    })
    .unwrap();

    syn::parse2::<syn::File>(output).unwrap();

    for declaration in [
        "trait Generic<State> {}",
        "trait Conditional where Self: Send {}",
    ] {
        assert!(expand_membership_trait(syn::parse_str(declaration).unwrap()).is_err());
    }
}

fn assert_rejected(item: &str, expected: &str) {
    let input = syn::parse_str(&format!("trait Invalid {{ {item} }}")).unwrap();
    let error = expand_trait(input, None).unwrap_err().to_compile_error();

    assert!(error.to_string().contains(expected), "{item}: {error}");
}

#[test]
fn rejects_signatures_that_cannot_be_forwarded() {
    for declaration in [
        "trait Generic<Item> {}",
        "trait Associated { type Item; }",
        "trait Owned { fn consume(self); }",
        "trait ReturningSelf { fn copy(&self) -> Self; }",
        "trait GenericMethod { fn update<Type>(&mut self, value: Type); }",
        "trait AsyncMethod { async fn update(&mut self); }",
    ] {
        assert!(expand_trait(syn::parse_str(declaration).unwrap(), None).is_err());
    }
}

#[test]
fn accepts_borrowed_defaults_and_wrapper_methods() {
    for method in [
        "fn read(&self) -> &str { \"default\" }",
        "fn build<Input>(self, value: Input) -> Self { self }",
        "#[reflect(wrapper_default)] fn edit<Input>(&mut self, value: Input) {}",
        "#[reflect(wrapper_default)] fn read(&self) -> usize { 12 }",
        "#[reflect(wrapper_default)] fn consume(self: Box<Self>) {}",
    ] {
        let input = syn::parse_str(&format!("trait Supported: Sized {{ {method} }}")).unwrap();
        let output = expand_trait(input, None).unwrap();

        syn::parse2::<syn::File>(output).unwrap();
    }
}

#[test]
fn rejects_unsupported_defaults_and_invalid_wrapper_settings() {
    for (item, message) in [
        (
            "fn generic<Input>(&self, value: Input) {}",
            "wrapper_default",
        ),
        (
            "fn copy(&self) -> Self { unreachable!() }",
            "cannot use Self",
        ),
        ("fn consume(self: Box<Self>) {}", "typed receivers"),
        ("fn create() -> usize { 0 }", "&self or &mut self"),
        (
            "async fn update(&mut self) {}",
            "forwarded reflected methods",
        ),
        (
            "fn update(&mut self) where Self: Sized {}",
            "forwarded reflected methods",
        ),
        (
            "#[reflect(wrapper_default)] fn required(&self);",
            "requires a provided method body",
        ),
        (
            "#[reflect(unknown)] fn read(&self) {}",
            "unknown reflected method setting",
        ),
        (
            "#[reflect(wrapper_default = true)] fn read(&self) {}",
            "unknown reflected method setting",
        ),
        (
            "#[reflect()] fn read(&self) {}",
            "expected #[reflect(wrapper_default)]",
        ),
        (
            "#[reflect(wrapper_default, wrapper_default)] fn read(&self) {}",
            "duplicate wrapper_default",
        ),
        (
            "#[reflect(wrapper_default)] #[reflect(wrapper_default)] fn read(&self) {}",
            "duplicate wrapper_default",
        ),
        (
            "#[cfg_attr(all(), reflect(wrapper_default))] fn read(&self) {}",
            "conditional reflected method settings",
        ),
    ] {
        assert_rejected(item, message);
    }
}

#[test]
fn rejects_constants_macros_and_unclassified_items() {
    for item in ["const LIMIT: usize;", "const LIMIT: usize = 12;"] {
        assert_rejected(item, "cannot expose associated constants");
    }

    assert_rejected(
        "#[cfg(any())] external_methods!();",
        "cannot classify this trait-item macro",
    );

    let mut input: ItemTrait = parse_quote! { trait Invalid {} };
    input
        .items
        .push(TraitItem::Verbatim(quote! { unsupported; }));

    assert!(
        expand_trait(input, None)
            .unwrap_err()
            .to_string()
            .contains("cannot classify this trait item")
    );
}

#[test]
fn retains_nested_configuration() {
    let input: TraitItemFn = parse_quote! {
        #[cfg(feature = "enabled")]
        #[cfg_attr(all(), cfg_attr(all(), cfg(any()), allow(dead_code)), doc = "disabled")]
        fn content(&self);
    };

    let expected: TraitItemFn = parse_quote! {
        #[cfg(feature = "enabled")]
        #[cfg_attr(all(), cfg_attr(all(), cfg(any())))]
        fn content(&self);
    };

    assert_eq!(
        configuration_attributes(&input.attrs).unwrap(),
        expected.attrs
    );
}

#[test]
fn rejects_malformed_configuration() {
    for attribute in [
        "#[cfg]",
        "#[cfg_attr(all())]",
        "#[cfg_attr(all(), cfg_attr(all()))]",
    ] {
        assert_rejected(&format!("{attribute} fn read(&self) {{}}"), "cfg");
    }
}

#[test]
fn preserves_order_and_attributes_when_normalizing_macros() {
    let mut input: ItemTrait = parse_quote! {
        trait Styled {
            fn before(&self);

            /// Generated styles.
            #[cfg_attr(all(), cfg_attr(all(), cfg(any())))]
            visibility_style_methods!();

            fn after(&self);
        }
    };
    let TraitItem::Macro(invocation) = &input.items[1] else {
        unreachable!();
    };

    let attributes = invocation.attrs.clone();
    normalize_trait_items(&mut input, UnknownMacros::Reject).unwrap();

    for (idx, name) in ["before", "visible", "invisible", "after"]
        .iter()
        .enumerate()
    {
        let TraitItem::Fn(method) = &input.items[idx] else {
            panic!("expected a normalized method");
        };

        assert_eq!(method.sig.ident, name);

        if (1..3).contains(&idx) {
            assert!(method.attrs.starts_with(&attributes));
        }
    }

    expand_trait(input, None).unwrap();
    assert_rejected("style_helpers!(invalid);", "unexpected token");
}
