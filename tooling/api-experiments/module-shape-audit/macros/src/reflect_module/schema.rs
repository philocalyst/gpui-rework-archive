use proc_macro2::TokenStream as TokenStream2;
use quote::{format_ident, quote};
use syn::{Item, PathArguments, Type};

pub(super) fn child_shape(ty: &Type, items: &[Item]) -> TokenStream2 {
    if let Type::Path(path) = ty {
        if let Some(last) = path.path.segments.last() {
            if matches!(last.arguments, PathArguments::None) {
                if let Some(Item::Type(alias)) = items
                    .iter()
                    .find(|item| matches!(item, Item::Type(alias) if alias.ident == last.ident))
                {
                    if alias.generics.params.is_empty() {
                        return child_shape(&alias.ty, items);
                    }
                }
            }
            if let PathArguments::AngleBracketed(arguments) = &last.arguments {
                if let Some(syn::GenericArgument::Type(inner)) = arguments.args.first() {
                    let child = child_shape(inner, items);
                    if last.ident == "Option" {
                        return quote!(|| ::gpui::reflection::Type::option::<#inner>(#child));
                    }
                    if last.ident == "Vec" {
                        return quote!(|| ::gpui::reflection::Type::vec::<#inner>(#child));
                    }
                }
            }
            if items.iter().any(|item| match item {
                Item::Struct(item) => item.ident == last.ident,
                Item::Enum(item) => item.ident == last.ident,
                _ => false,
            }) && matches!(
                last.arguments,
                PathArguments::None | PathArguments::AngleBracketed(_)
            ) {
                return quote!(|| <#ty as ::gpui::reflection::Describe>::type_shape());
            }
        }
    }
    quote!(|| ::gpui::reflection::Type::opaque::<#ty>())
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
