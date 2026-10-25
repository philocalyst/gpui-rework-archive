use proc_macro::TokenStream;
use quote::quote;
use syn::{ImplItem, Item, ItemImpl, ItemMod, Type, parse_quote};

mod fields;
mod methods;
mod roles;
mod schema;

/// Expands `#[gpui::reflect]` on an inline module. The expansion stays in that module so its
/// generated accessors can safely reach private fields and native methods.
pub(crate) fn reflect_module(input: TokenStream) -> syn::Result<TokenStream> {
    let mut module: ItemMod = syn::parse(input)?;
    let Some((_, items)) = module.content.as_mut() else {
        return Err(syn::Error::new_spanned(
            &module,
            "`#[reflect]` requires an inline module so private fields and local impls are visible",
        ));
    };

    let types: Vec<Item> = items
        .iter()
        .filter(|item| matches!(item, Item::Struct(_) | Item::Enum(_)))
        .cloned()
        .collect();
    let mut generated = Vec::new();

    for item in items.iter() {
        if let Item::Impl(implementation) = item {
            if types
                .iter()
                .any(|item| item_matches_type(item, implementation))
            {
                for impl_item in &implementation.items {
                    if let ImplItem::Fn(method) = impl_item {
                        methods::validate_method(method)?;
                    }
                }
            }
        }
    }

    for item in items.iter_mut() {
        let Item::Impl(implementation) = item else {
            continue;
        };
        let subject_trait = implementation
            .trait_
            .as_ref()
            .and_then(|(_, path, _)| path.segments.last())
            .map(|segment| segment.ident.to_string());
        if !matches!(
            subject_trait.as_deref(),
            Some("RenderOnce" | "View" | "Element")
        ) || !types
            .iter()
            .any(|item| item_matches_type(item, implementation))
        {
            continue;
        }
        let has_hook = implementation
            .items
            .iter()
            .any(|item| matches!(item, ImplItem::Fn(method) if method.sig.ident == "query_type"));
        if !has_hook {
            let hook = if subject_trait.as_deref() == Some("Element") {
                parse_quote! {
                    #[doc(hidden)]
                    fn query_type(&self) -> ::gpui::reflection::Type {
                        <Self as ::gpui::reflection::Describe>::type_shape()
                    }
                }
            } else {
                parse_quote! {
                    #[doc(hidden)]
                    fn query_type() -> ::gpui::reflection::Type {
                        <Self as ::gpui::reflection::Describe>::type_shape()
                    }
                }
            };
            implementation.items.push(hook);
        }
    }

    for item in &types {
        match item {
            Item::Struct(item) => generated.extend(fields::reflect_struct(item, items)?),
            Item::Enum(item) => generated.extend(fields::reflect_enum(item, items)?),
            _ => unreachable!(),
        }
    }

    items.extend(generated.into_iter().map(syn::Item::Verbatim));
    Ok(quote!(#module).into())
}

pub(super) fn item_matches_type(item: &Item, implementation: &ItemImpl) -> bool {
    match item {
        Item::Struct(item) => impl_targets(implementation, &item.ident),
        Item::Enum(item) => impl_targets(implementation, &item.ident),
        _ => false,
    }
}

pub(super) fn impl_targets(implementation: &ItemImpl, name: &syn::Ident) -> bool {
    let Type::Path(path) = implementation.self_ty.as_ref() else {
        return false;
    };
    path.path
        .segments
        .last()
        .is_some_and(|segment| segment.ident == *name)
}

pub(super) fn cfg_attrs(attrs: &[syn::Attribute]) -> Vec<syn::Attribute> {
    attrs
        .iter()
        .filter(|attr| attr.path().is_ident("cfg") || attr.path().is_ident("cfg_attr"))
        .cloned()
        .collect()
}
