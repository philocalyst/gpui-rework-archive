use proc_macro::TokenStream;
use proc_macro2::TokenStream as TokenStream2;
use quote::quote;
use syn::{ImplItem, Item, ItemImpl, ItemMod, Type, parse_quote};

mod fields;
mod methods;
mod roles;
mod schema;
mod subjects;
mod tuple_fields;

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
    let subject_traits = subjects::SubjectTraits::new(items);

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
            .and_then(|(_, path, _)| subject_traits.resolve(path));
        if subject_trait.is_none()
            || !types
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
            let hook = if subject_trait == Some(subjects::SubjectTrait::Element) {
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
    let segments = &path.path.segments;
    path.qself.is_none()
        && path.path.leading_colon.is_none()
        && (segments.len() == 1 || (segments.len() == 2 && segments[0].ident == "self"))
        && segments
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

pub(super) fn cfg_attribute_presence(meta: &syn::Meta) -> TokenStream2 {
    match meta {
        syn::Meta::List(list) if list.path.is_ident("cfg") => list.tokens.clone(),
        syn::Meta::List(list) if list.path.is_ident("cfg_attr") => {
            let parsed = syn::parse::Parser::parse2(
                syn::punctuated::Punctuated::<syn::Meta, syn::Token![,]>::parse_terminated,
                list.tokens.clone(),
            );
            let Ok(parsed) = parsed else {
                return quote!(all());
            };
            let mut parts = parsed.into_iter();
            let Some(predicate) = parts.next() else {
                return quote!(all());
            };
            let predicate = match predicate {
                syn::Meta::List(predicate) if predicate.path.is_ident("cfg") => predicate.tokens,
                other => quote!(#other),
            };
            let payload_presence = parts.map(|payload| cfg_attribute_presence(&payload));
            quote!(any(not(#predicate), all(#(#payload_presence),*)))
        }
        _ => quote!(all()),
    }
}
