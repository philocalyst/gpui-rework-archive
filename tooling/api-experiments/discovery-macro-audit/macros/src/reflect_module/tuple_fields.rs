//! Tuple borrows follow the fields retained by Rust's cfg expansion.
//!
//! Rust does not allow cfg attributes on individual tuple-pattern positions. For conditional
//! tuples, a linear macro ladder carries only surviving positions into each generated getter.
//! These helpers use native patterns; no offsets or reconstructed references are involved.
use proc_macro2::TokenStream as TokenStream2;
use quote::{format_ident, quote};
use syn::{Type, parse_quote};

use super::{cfg_attribute_presence, cfg_attrs};

pub(super) struct TupleFieldHelpers {
    pub(super) getters: Vec<syn::Ident>,
    pub(super) getters_mut: Vec<syn::Ident>,
    pub(super) definitions: Vec<TokenStream2>,
}

pub(super) fn tuple_field_helpers(
    fields: &syn::punctuated::Punctuated<syn::Field, syn::Token![,]>,
    pattern_type: &syn::Ident,
    root: &Type,
    descriptor: &syn::Ident,
    generics: &syn::Generics,
    variant: Option<&syn::Ident>,
    macro_attrs: &[syn::Attribute],
) -> TupleFieldHelpers {
    let (_, ty_generics, _) = generics.split_for_impl();
    let (impl_generics, _, where_clause) = generics.split_for_impl();
    let getters: Vec<_> = (0..fields.len())
        .map(|index| format_ident!("__get_field_{index}"))
        .collect();
    let getters_mut: Vec<_> = (0..fields.len())
        .map(|index| format_ident!("__get_field_mut_{index}"))
        .collect();
    let stage_names: Vec<_> = (0..=fields.len())
        .map(|index| format_ident!("__{}_stage_{}", descriptor, index))
        .collect();
    let target = if let Some(variant) = variant {
        quote!(#pattern_type::#variant)
    } else {
        quote!(#pattern_type)
    };
    // Ordinary tuples need no cfg machinery, and their field count should not consume
    // the user's macro recursion budget.
    if fields
        .iter()
        .all(|field| cfg_attrs(&field.attrs).is_empty())
    {
        let definitions = fields.iter().enumerate().map(|(index, field)| {
            let ty = &field.ty;
            let get = &getters[index];
            let get_mut = &getters_mut[index];
            if variant.is_some() {
                let before = vec![quote!(_); index];
                let body = quote!(match value {
                    #target(#(#before,)* field, ..) => Some(field),
                    _ => None,
                });
                quote! {
                    fn #get(value: &#root) -> Option<&#ty> { #body }
                    fn #get_mut(value: &mut #root) -> Option<&mut #ty> { #body }
                }
            } else {
                let index = syn::Index::from(index);
                quote! {
                    fn #get(value: &#root) -> &#ty { &value.#index }
                    fn #get_mut(value: &mut #root) -> &mut #ty { &mut value.#index }
                }
            }
        });
        let definition = quote! {
            #(#macro_attrs)*
            impl #impl_generics #descriptor #ty_generics #where_clause {
                #(#definitions)*
            }
        };
        return TupleFieldHelpers {
            getters,
            getters_mut,
            definitions: vec![definition],
        };
    }
    let mut macros = Vec::new();
    for index in (0..fields.len()).rev() {
        let stage = &stage_names[index];
        let next_stage = &stage_names[index + 1];
        let field = &fields[index];
        let ty = &field.ty;
        let cfg = cfg_attrs(&field.attrs);
        let presence = cfg
            .iter()
            .map(|attr| cfg_attribute_presence(&attr.meta))
            .collect::<Vec<_>>();
        let presence = quote!(all(#(#presence),*));
        let bind = format_ident!("__active_field_{index}");
        let get = &getters[index];
        let get_mut = &getters_mut[index];
        let maybe = variant.is_some();
        let getter_body = if maybe {
            quote!(match value { #target($($before,)* #bind, ..) => Some(#bind), _ => None })
        } else {
            quote!(match value { #target($($before,)* #bind, ..) => #bind })
        };
        let lifetime: syn::Lifetime = parse_quote!('__gpui_reflect);
        let ret = if maybe {
            quote!(Option<&#lifetime #ty>)
        } else {
            quote!(&#lifetime #ty)
        };
        let ret_mut = if maybe {
            quote!(Option<&#lifetime mut #ty>)
        } else {
            quote!(&#lifetime mut #ty)
        };
        macros.push(quote! {
            #(#macro_attrs)*
            macro_rules! #stage {
                ($($before:ident,)*) => {
                    #[cfg(#presence)]
                    impl #impl_generics #descriptor #ty_generics #where_clause {
                        fn #get<'__gpui_reflect>(value: &'__gpui_reflect #root) -> #ret {
                            #getter_body
                        }
                        fn #get_mut<'__gpui_reflect>(value: &'__gpui_reflect mut #root) -> #ret_mut {
                            #getter_body
                        }
                    }
                    #[cfg(#presence)] #next_stage!($($before,)* #bind,);
                    #[cfg(not(#presence))] #next_stage!($($before,)*);
                };
            }
        });
    }
    let terminal_stage = &stage_names[fields.len()];
    let initial_stage = &stage_names[0];
    macros.push(quote! {
        #(#macro_attrs)*
        macro_rules! #terminal_stage {
            ($($before:ident,)*) => {};
        }
    });
    macros.push(quote!(#(#macro_attrs)* #initial_stage!();));
    TupleFieldHelpers {
        getters,
        getters_mut,
        definitions: macros,
    }
}
