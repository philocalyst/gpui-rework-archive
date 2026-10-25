use crate::{derive_element_traits, derive_reflect};
use proc_macro::TokenStream;
use proc_macro2::Span;
use proc_macro2::TokenStream as TokenStream2;
use quote::quote;
use syn::{
    Attribute, Data, DeriveInput, Fields, Member, Meta, Type, parse_macro_input, parse_quote,
    punctuated::Punctuated,
};

#[derive(Default)]
struct ElementField {
    member: Option<Member>,
    ty: Option<Type>,
    index: usize,
    options: ElementOptions,
}

#[derive(Clone, Copy, Default)]
struct ElementOptions {
    style: bool,
    children: bool,
    interactive: bool,
    stateful: bool,
}

fn element_field(input: &DeriveInput) -> syn::Result<ElementField> {
    let Data::Struct(data) = &input.data else {
        return Err(syn::Error::new_spanned(
            &input.ident,
            "Element derive requires a struct",
        ));
    };

    let mut found = ElementField::default();

    for (index, field) in data.fields.iter().enumerate() {
        for attribute in &field.attrs {
            if !attribute.path().is_ident("element") {
                continue;
            }

            if found.member.is_some() {
                return Err(syn::Error::new_spanned(
                    attribute,
                    "only one #[element] field is allowed",
                ));
            }

            found.options = parse_element_attribute(attribute)?;
            found.index = index;
            found.member = Some(match &data.fields {
                Fields::Named(_) => Member::Named(field.ident.clone().expect("named field")),
                Fields::Unnamed(_) => Member::Unnamed(index.into()),
                Fields::Unit => unreachable!(),
            });
            found.ty = Some(field.ty.clone());
        }
    }

    if found.member.is_none() {
        return Err(syn::Error::new_spanned(
            &input.ident,
            "Element derive requires one #[element] field",
        ));
    }

    Ok(found)
}

fn parse_element_attribute(attribute: &Attribute) -> syn::Result<ElementOptions> {
    match &attribute.meta {
        Meta::Path(_) => Ok(ElementOptions::default()),
        Meta::List(_) => {
            let settings = attribute
                .parse_args_with(Punctuated::<syn::Ident, syn::Token![,]>::parse_terminated)?;
            let mut options = ElementOptions::default();
            for setting in settings {
                let slot = if setting == "stateful" {
                    &mut options.stateful
                } else if setting == "style" {
                    &mut options.style
                } else if setting == "children" {
                    &mut options.children
                } else if setting == "interactive" || setting == "interactivity" {
                    &mut options.interactive
                } else {
                    return Err(syn::Error::new_spanned(
                        setting,
                        "expected style, children, interactive, or stateful",
                    ));
                };
                if std::mem::replace(slot, true) {
                    return Err(syn::Error::new_spanned(setting, "duplicate element option"));
                }
            }
            Ok(options)
        }
        Meta::NameValue(_) => Err(syn::Error::new_spanned(
            attribute,
            "expected #[element] or a list of element capabilities",
        )),
    }
}

fn has_attribute(input: &DeriveInput, name: &str) -> bool {
    let Data::Struct(data) = &input.data else {
        return false;
    };

    data.fields.iter().any(|field| {
        field
            .attrs
            .iter()
            .any(|attribute| attribute.path().is_ident(name))
    })
}

fn reflect_input(input: &DeriveInput, element_options: ElementOptions) -> syn::Result<DeriveInput> {
    let mut augmented = input.clone();

    if input.generics.params.is_empty() {
        return Ok(augmented);
    }
    let has_reflect_attribute = input
        .attrs
        .iter()
        .any(|attribute| attribute.path().is_ident("reflect"));
    if !has_reflect_attribute {
        // The aggregate derive knows its builtin delegates, so generic Element wrappers get an
        // explicit reflection list from those selections (or an empty one) automatically. A
        // standalone Reflect derive still enforces its explicit-list requirement.
        augmented.attrs.push(parse_quote!(#[reflect()]));
    }

    let reflected_entries = input
        .attrs
        .iter()
        .filter(|attribute| attribute.path().is_ident("reflect"))
        .filter_map(|attribute| {
            attribute
                .parse_args_with(Punctuated::<Meta, syn::Token![,]>::parse_terminated)
                .ok()
        })
        .flatten()
        .filter_map(|meta| match meta {
            Meta::Path(path) => Some(path),
            _ => None,
        })
        .collect::<Vec<_>>();

    let mut add_builtin = |enabled: bool, path: syn::Path| {
        let canonical_path = quote!(#path).to_string();
        if enabled
            && !reflected_entries
                .iter()
                .any(|entry| quote!(#entry).to_string() == canonical_path)
        {
            augmented.attrs.push(parse_quote!(#[reflect(#path)]));
        }
    };

    add_builtin(
        element_options.style || has_attribute(input, "style"),
        parse_quote!(gpui::Styled),
    );
    add_builtin(
        element_options.children || has_attribute(input, "children"),
        parse_quote!(gpui::ParentElement),
    );
    add_builtin(
        element_options.interactive || has_attribute(input, "interactivity"),
        parse_quote!(gpui::InteractiveElement),
    );
    add_builtin(
        element_options.stateful,
        parse_quote!(gpui::StatefulInteractiveElement),
    );

    Ok(augmented)
}

fn delegate_input(
    input: &DeriveInput,
    element_field: &ElementField,
    marker: &str,
    requested: bool,
) -> syn::Result<Option<DeriveInput>> {
    let explicit = has_attribute(input, marker);
    if requested && explicit {
        return Err(syn::Error::new_spanned(
            &input.ident,
            format!("specify either #[element({marker})] or a separate #[{marker}] field"),
        ));
    }
    if !requested && !explicit {
        return Ok(None);
    }

    let mut augmented = input.clone();
    if requested {
        let Data::Struct(data) = &mut augmented.data else {
            unreachable!("element_field validates struct input")
        };
        let marker = syn::Ident::new(marker, Span::call_site());
        data.fields
            .iter_mut()
            .nth(element_field.index)
            .expect("element field index")
            .attrs
            .push(parse_quote!(#[#marker(delegate)]));
    }
    Ok(Some(augmented))
}

fn expand_element(input: &DeriveInput) -> syn::Result<TokenStream2> {
    let element_field = element_field(input)?;
    let member = element_field
        .member
        .clone()
        .expect("validated element field");
    let element_type = element_field
        .ty
        .clone()
        .expect("validated element field type");
    let options = element_field.options;
    let name = &input.ident;
    let mut element_generics = input.generics.clone();
    element_generics
        .make_where_clause()
        .predicates
        .push(parse_quote!(#element_type: gpui::Element));
    element_generics
        .make_where_clause()
        .predicates
        .push(parse_quote!(Self: gpui::reflection::Reflect));
    let (impl_generics, type_generics, where_clause) = element_generics.split_for_impl();

    let reflect = derive_reflect::expand_reflect(reflect_input(input, options)?)?;
    let stateful_input = options.stateful.then(|| {
        let mut input = input.clone();
        let element_type = element_field.ty.as_ref().expect("element field type");
        input
            .generics
            .make_where_clause()
            .predicates
            .push(parse_quote!(#element_type: gpui::StatefulInteractiveElement));
        input
    });
    let stateful = stateful_input
        .as_ref()
        .map(|input| derive_element_traits::expand_stateful_interactive_element(input));
    let style_input = delegate_input(input, &element_field, "style", options.style)?;
    let children_input = delegate_input(input, &element_field, "children", options.children)?;
    let interactive_input =
        delegate_input(input, &element_field, "interactivity", options.interactive)?;
    let styled = style_input
        .as_ref()
        .map(derive_element_traits::expand_styled)
        .transpose()?;
    let parent = children_input
        .as_ref()
        .map(derive_element_traits::expand_parent_element)
        .transpose()?;
    let interactive = interactive_input
        .as_ref()
        .map(derive_element_traits::expand_interactive_element)
        .transpose()?;

    Ok(quote! {
        #reflect

        impl #impl_generics gpui::IntoElement for #name #type_generics #where_clause {
            type Element = Self;

            fn into_element(self) -> Self::Element {
                self
            }
        }

        impl #impl_generics gpui::Element for #name #type_generics #where_clause {
            type RequestLayoutState = <#element_type as gpui::Element>::RequestLayoutState;
            type PrepaintState = <#element_type as gpui::Element>::PrepaintState;

            fn reflection(&self) -> &'static gpui::reflection::ElementReflection {
                <Self as gpui::reflection::Reflect>::reflection()
            }

            fn query_type(&self) -> gpui::reflection::Type {
                use gpui::reflection::ProbeShape as _;
                let probe = gpui::reflection::TypeProbe::<Self>::new();
                (&probe).full_shape().unwrap_or_else(gpui::reflection::Type::discover::<Self>)
            }

            fn id(&self) -> Option<gpui::ElementId> {
                gpui::Element::id(&self.#member)
            }

            fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
                gpui::Element::source_location(&self.#member)
            }

            fn request_layout(
                &mut self,
                id: Option<&gpui::GlobalElementId>,
                inspector_id: Option<&gpui::InspectorElementId>,
                window: &mut gpui::Window,
                cx: &mut gpui::App,
            ) -> (gpui::LayoutId, Self::RequestLayoutState) {
                gpui::Element::request_layout(&mut self.#member, id, inspector_id, window, cx)
            }

            fn prepaint(
                &mut self,
                id: Option<&gpui::GlobalElementId>,
                inspector_id: Option<&gpui::InspectorElementId>,
                bounds: gpui::Bounds<gpui::Pixels>,
                request_layout: &mut Self::RequestLayoutState,
                window: &mut gpui::Window,
                cx: &mut gpui::App,
            ) -> Self::PrepaintState {
                gpui::Element::prepaint(
                    &mut self.#member,
                    id,
                    inspector_id,
                    bounds,
                    request_layout,
                    window,
                    cx,
                )
            }

            fn paint(
                &mut self,
                id: Option<&gpui::GlobalElementId>,
                inspector_id: Option<&gpui::InspectorElementId>,
                bounds: gpui::Bounds<gpui::Pixels>,
                request_layout: &mut Self::RequestLayoutState,
                prepaint: &mut Self::PrepaintState,
                window: &mut gpui::Window,
                cx: &mut gpui::App,
            ) {
                gpui::Element::paint(
                    &mut self.#member,
                    id,
                    inspector_id,
                    bounds,
                    request_layout,
                    prepaint,
                    window,
                    cx,
                );
            }

            fn a11y_role(&self) -> Option<gpui::accesskit::Role> {
                gpui::Element::a11y_role(&self.#member)
            }

            fn is_a11y_hidden(&self) -> bool {
                gpui::Element::is_a11y_hidden(&self.#member)
            }

            fn write_a11y_info(&self, node: &mut gpui::accesskit::Node) {
                gpui::Element::write_a11y_info(&self.#member, node);
            }

            fn a11y_synthetic_children(
                &mut self,
                prepaint: &mut Self::PrepaintState,
                builder: &mut gpui::A11ySubtreeBuilder,
            ) {
                gpui::Element::a11y_synthetic_children(&mut self.#member, prepaint, builder);
            }
        }

        #styled
        #parent
        #interactive
        #stateful
    })
}

pub fn derive_element(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as DeriveInput);

    expand_element(&input)
        .unwrap_or_else(syn::Error::into_compile_error)
        .into()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn requires_one_element_field_and_recognizes_stateful() {
        for (input, message) in [
            ("enum Bad { Item }", "requires a struct"),
            ("struct Bad;", "requires one #[element] field"),
            (
                "struct Bad { #[element] a: (), #[element] b: () }",
                "only one #[element] field",
            ),
            (
                "struct Bad { #[element(unknown)] field: () }",
                "expected style, children, interactive, or stateful",
            ),
            (
                "struct Bad { #[element = true] field: () }",
                "expected #[element] or a list of element capabilities",
            ),
        ] {
            let input = syn::parse_str(input).unwrap();
            assert!(
                expand_element(&input)
                    .unwrap_err()
                    .to_string()
                    .contains(message)
            );
        }
    }
    #[test]
    fn aggregate_emits_lifecycle_reflection_and_marked_builder_traits() {
        let input: DeriveInput = syn::parse_quote! {
            #[reflect(Custom)]
            struct Example {
                #[element(style, children, interactive, stateful)]
                inner: gpui::Stateful<gpui::Div>,
            }
        };
        let generated = expand_element(&input).unwrap().to_string();

        for expected in [
            "gpui :: Element",
            "gpui :: IntoElement",
            "write_a11y_info",
            "a11y_synthetic_children",
            "source_location",
            "gpui :: Styled",
            "gpui :: ParentElement",
            "gpui :: InteractiveElement",
            "gpui :: StatefulInteractiveElement",
            "Custom",
        ] {
            assert!(
                generated.contains(expected),
                "missing {expected} in {generated}"
            );
        }
    }

    #[test]
    fn generic_element_reflection_includes_delegated_builtin_capabilities() {
        let input: DeriveInput = syn::parse_quote! {
            #[reflect(Custom, capability(DRAG => |element| element))]
            struct Example<E> {
                #[element(style, children, interactive, stateful)]
                inner: E,
            }
        };

        let reflect_input = reflect_input(&input, element_field(&input).unwrap().options).unwrap();
        let entries = reflect_input
            .attrs
            .iter()
            .filter(|attribute| attribute.path().is_ident("reflect"))
            .flat_map(|attribute| {
                attribute
                    .parse_args_with(Punctuated::<Meta, syn::Token![,]>::parse_terminated)
                    .unwrap()
            })
            .filter_map(|meta| match meta {
                Meta::Path(path) => path
                    .segments
                    .last()
                    .map(|segment| segment.ident.to_string()),
                _ => None,
            })
            .collect::<Vec<_>>();

        for expected in [
            "Custom",
            "Styled",
            "ParentElement",
            "InteractiveElement",
            "StatefulInteractiveElement",
        ] {
            assert!(entries.iter().any(|entry| entry == expected), "{entries:?}");
        }
        assert_eq!(
            entries
                .iter()
                .filter(|entry| entry.as_str() == "Styled")
                .count(),
            1
        );
        assert!(expand_element(&input).is_ok());
    }

    #[test]
    fn generic_element_injects_its_builtin_reflect_list() {
        let input: DeriveInput = syn::parse_quote! {
            struct Example<E> {
                #[element(style)]
                inner: E,
            }
        };

        let generated = expand_element(&input).unwrap().to_string();
        assert!(generated.contains("gpui :: Styled"));
    }

    #[test]
    fn a_custom_trait_with_a_builtin_name_does_not_suppress_builtin_registration() {
        let input: DeriveInput = syn::parse_quote! {
            #[reflect(other::Styled)]
            struct Example<E> {
                #[element(style)]
                inner: E,
            }
        };

        let augmented = reflect_input(&input, element_field(&input).unwrap().options).unwrap();
        let entries = augmented
            .attrs
            .iter()
            .filter(|attribute| attribute.path().is_ident("reflect"))
            .flat_map(|attribute| {
                attribute
                    .parse_args_with(Punctuated::<Meta, syn::Token![,]>::parse_terminated)
                    .unwrap()
            })
            .filter_map(|meta| match meta {
                Meta::Path(path) => Some(quote!(#path).to_string()),
                _ => None,
            })
            .collect::<Vec<_>>();

        assert!(entries.contains(&"other :: Styled".to_string()));
        assert!(entries.contains(&"gpui :: Styled".to_string()));
    }
}
