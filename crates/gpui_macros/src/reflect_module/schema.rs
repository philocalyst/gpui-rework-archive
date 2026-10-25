use proc_macro2::TokenStream as TokenStream2;
use quote::{format_ident, quote};
use syn::{Item, PathArguments, Type};

pub(super) fn child_shape(ty: &Type, _items: &[Item]) -> TokenStream2 {
    let mut candidates = Vec::new();
    collect_shape_arguments(ty, &mut candidates);
    // Each probe is type-checked at this field's site, retaining its actual generic bounds.
    // Provision only stores factories: none of the recursive child shapes are built here.
    quote!(|| {
        use ::gpui::reflection::{ProbeShape as _, ProbePartialShape as _, ProvideShape as _, ProvidePartialShape as _};
        #((&::gpui::reflection::TypeProbe::<#candidates>::new()).provide();)*
        #((&::gpui::reflection::TypeProbe::<#candidates>::new()).provide_partial();)*
        let probe = ::gpui::reflection::TypeProbe::<#ty>::new();
        (&probe).full_shape().unwrap_or_else(|| (&probe).partial_shape())
    })
}

fn collect_shape_arguments<'a>(ty: &'a Type, candidates: &mut Vec<&'a Type>) {
    candidates.push(ty);
    match ty {
        Type::Array(array) => collect_shape_arguments(&array.elem, candidates),
        Type::Tuple(tuple) => {
            for element in &tuple.elems {
                collect_shape_arguments(element, candidates);
            }
        }
        Type::Paren(paren) => collect_shape_arguments(&paren.elem, candidates),
        Type::Group(group) => collect_shape_arguments(&group.elem, candidates),
        Type::Path(path) => {
            for segment in &path.path.segments {
                if let PathArguments::AngleBracketed(arguments) = &segment.arguments {
                    for argument in &arguments.args {
                        if let syn::GenericArgument::Type(ty) = argument {
                            collect_shape_arguments(ty, candidates);
                        }
                    }
                }
            }
        }
        // A bare function can introduce its own bound lifetimes. Never move types out of that
        // binder, and never assume the referent of a pointer or reference is sized.
        _ => {}
    }
}

pub(super) fn type_registration(
    generics: &syn::Generics,
    root: &Type,
    attrs: &[syn::Attribute],
) -> TokenStream2 {
    if !generics.params.is_empty() {
        return TokenStream2::new();
    }
    quote! {
        #(#attrs)*
        ::gpui::private::inventory::submit! {
            ::gpui::reflection::TypeRegistration::of::<#root>()
        }
    }
}

pub(super) fn type_shape_override(generics: &syn::Generics, root: &Type) -> TokenStream2 {
    if !generics.params.is_empty() {
        return TokenStream2::new();
    }
    quote! {
        fn type_shape() -> ::gpui::reflection::Type {
            static TYPE: ::std::sync::LazyLock<::gpui::reflection::Type> =
                ::std::sync::LazyLock::new(|| ::gpui::reflection::Type::of::<#root>());
            *TYPE
        }
    }
}

pub(super) fn snake_case(value: &str) -> syn::Ident {
    format_ident!("{}", heck::ToSnakeCase::to_snake_case(value))
}

pub(super) fn pascal_case(value: &str) -> String {
    heck::ToUpperCamelCase::to_upper_camel_case(value)
}
