use proc_macro2::TokenStream as TokenStream2;
use quote::{ToTokens, format_ident, quote};
use std::collections::{HashMap, HashSet};
use syn::visit_mut::VisitMut;
use syn::{
    Expr, ExprPath, FnArg, GenericParam, ImplItem, Item, PatType, ReturnType, Type, TypePath,
    parse_quote,
};

use super::{cfg_attribute_presence, cfg_attrs, impl_targets, schema};

pub(super) struct MethodAccessor {
    pub(super) declaration: TokenStream2,
    pub(super) member: TokenStream2,
    pub(super) initializer: TokenStream2,
    pub(super) implementation: TokenStream2,
}

pub(super) fn method_accessors(
    type_name: &syn::Ident,
    root: &Type,
    type_generics: &syn::Generics,
    type_attrs: &[syn::Attribute],
    items: &[Item],
) -> syn::Result<Vec<MethodAccessor>> {
    let mut output = Vec::new();
    let mut grouped = Vec::<(String, Vec<(syn::ImplItemFn, syn::ItemImpl)>)>::new();
    let mut positions = HashMap::<String, usize>::new();
    for item in items {
        let Item::Impl(implementation) = item else {
            continue;
        };
        if implementation.trait_.is_none() && impl_targets(implementation, type_name) {
            for impl_item in &implementation.items {
                if let ImplItem::Fn(method) = impl_item {
                    let key = method.sig.ident.to_string();
                    let position = *positions.entry(key.clone()).or_insert_with(|| {
                        grouped.push((key.clone(), Vec::new()));
                        grouped.len() - 1
                    });
                    grouped[position]
                        .1
                        .push((method.clone(), implementation.clone()));
                }
            }
        }
    }
    for (method_key, methods) in grouped {
        let method_name = &methods[0].0.sig.ident;
        let accessor = format_ident!("__{}Method{}", type_name, schema::pascal_case(&method_key));
        let (impl_generics, ty_generics, where_clause) = type_generics.split_for_impl();
        // The aggregate field must be visible wherever any overload is visible;
        // each generated `call` method below keeps its native visibility.
        let field_vis = quote!(pub);
        let attrs = type_attrs.to_vec();
        let declarations_cfg = cfg_union_attrs(&methods);
        // Handles retain no receiver. Copy them by value so returned impl Trait and async
        // futures cannot accidentally capture a borrow of a temporary descriptor.
        let declaration = quote! {
            #(#attrs)* #(#declarations_cfg)*
            #field_vis struct #accessor #type_generics (::core::marker::PhantomData<fn() -> #root>) #where_clause;
            #(#attrs)* #(#declarations_cfg)*
            impl #impl_generics ::core::marker::Copy for #accessor #ty_generics #where_clause {}
            #(#attrs)* #(#declarations_cfg)*
            impl #impl_generics ::core::clone::Clone for #accessor #ty_generics #where_clause {
                fn clone(&self) -> Self { *self }
            }
        };
        let member = quote!(#(#attrs)* #(#declarations_cfg)* #field_vis #method_name: #accessor #ty_generics);
        let initializer = quote!(#(#attrs)* #(#declarations_cfg)* #method_name: #accessor(::core::marker::PhantomData));
        let implementations = methods
            .iter()
            .map(|(method, implementation)| {
                let specialized_root: Type = implementation.self_ty.as_ref().clone();
                let method_impl = method_handle_impl(
                    method,
                    &specialized_root,
                    &implementation.generics,
                    &accessor,
                )?;
                // Preserve each native method's own condition on its call implementation.
                let mut attrs = cfg_attrs(&implementation.attrs);
                attrs.extend(cfg_attrs(&method.attrs));
                Ok::<_, syn::Error>(quote!(#(#attrs)* #method_impl))
            })
            .collect::<syn::Result<Vec<_>>>()?;
        output.push(MethodAccessor {
            declaration,
            member,
            initializer,
            implementation: quote!(#(#implementations)*),
        });
    }
    Ok(output)
}

fn cfg_union_attrs(methods: &[(syn::ImplItemFn, syn::ItemImpl)]) -> Vec<syn::Attribute> {
    let alternatives = methods.iter().map(|(method, implementation)| {
        let conditions = cfg_attrs(&implementation.attrs)
            .into_iter()
            .chain(cfg_attrs(&method.attrs))
            .map(|attr| cfg_attribute_presence(&attr.meta));
        quote!(all(#(#conditions),*))
    });
    let alternatives = alternatives.collect::<Vec<_>>();
    vec![parse_quote!(#[cfg(any(#(#alternatives),*))])]
}

fn method_handle_impl(
    method: &syn::ImplItemFn,
    root: &Type,
    impl_generics_source: &syn::Generics,
    accessor: &syn::Ident,
) -> syn::Result<TokenStream2> {
    let impl_method = method;
    let method = &impl_method.sig;
    let mut wrapper_sig = method.clone();
    wrapper_sig.ident = format_ident!("call");
    wrapper_sig.constness = None;
    wrapper_sig.abi = None;
    let receiver = wrapper_sig.inputs.iter().find_map(|input| match input {
        FnArg::Receiver(receiver) => Some(receiver.clone()),
        _ => None,
    });
    let mut call_args = Vec::new();
    for (index, input) in wrapper_sig.inputs.iter_mut().enumerate() {
        if let FnArg::Typed(argument) = input {
            let ident = format_ident!("__arg_{index}");
            *argument.pat = parse_quote!(#ident);
            call_args.push(quote!(#ident));
        }
    }
    let mut generics = impl_generics_source.clone();
    ReplaceSelf { root }.visit_generics_mut(&mut generics);
    let (handle_impl_generics, _, where_clause) = generics.split_for_impl();
    let helper_args = match root {
        Type::Path(path) => path
            .path
            .segments
            .last()
            .and_then(|s| match &s.arguments {
                syn::PathArguments::AngleBracketed(args) => Some(args.to_token_stream()),
                _ => None,
            })
            .unwrap_or_default(),
        _ => quote!(),
    };
    let mut method_generics = wrapper_sig.generics.clone();
    ReplaceSelf { root }.visit_generics_mut(&mut method_generics);
    if let Some(receiver) = &receiver {
        let borrows_receiver = receiver.reference.is_some();
        let synthetic_lifetime = || fresh_receiver_lifetime(method, impl_generics_source);
        let mut receiver_reference_lifetime = receiver
            .lifetime()
            .filter(|lifetime| lifetime.ident != "_")
            .cloned();
        let mut custom_receiver_type = receiver.colon_token.is_some().then(|| {
            let mut ty = receiver.ty.as_ref().clone();
            ReplaceSelf { root }.visit_type_mut(&mut ty);
            ty
        });
        if let Some(ty) = &mut custom_receiver_type {
            let mut scan = FirstReferenceLifetime { lifetime: None };
            scan.visit_type_mut(ty);
            if receiver_reference_lifetime.is_none() {
                receiver_reference_lifetime = scan.lifetime;
            }
            let synthetic = synthetic_lifetime();
            let mut bind_receiver = BindElidedReturnReferences {
                lifetime: receiver_reference_lifetime.as_ref().unwrap_or(&synthetic),
                found: false,
            };
            bind_receiver.visit_type_mut(ty);
            if bind_receiver.found && receiver_reference_lifetime.is_none() {
                receiver_reference_lifetime = Some(synthetic.clone());
                method_generics
                    .params
                    .insert(0, GenericParam::Lifetime(parse_quote!(#synthetic)));
            }
        }
        let recv_lifetime = receiver_reference_lifetime
            .clone()
            .unwrap_or_else(synthetic_lifetime);
        if borrows_receiver && receiver_reference_lifetime.is_none() {
            method_generics
                .params
                .insert(0, GenericParam::Lifetime(parse_quote!(#recv_lifetime)));
        }
        let receiver_ty: Type = if let Some(ty) = custom_receiver_type {
            ty
        } else if receiver.reference.is_some() {
            if receiver.mutability.is_some() {
                parse_quote!(&#recv_lifetime mut #root)
            } else {
                parse_quote!(&#recv_lifetime #root)
            }
        } else {
            root.clone()
        };
        let recv_arg = FnArg::Typed(PatType {
            attrs: vec![],
            pat: Box::new(parse_quote!(__receiver)),
            colon_token: Default::default(),
            ty: Box::new(receiver_ty),
        });
        wrapper_sig.inputs = wrapper_sig
            .inputs
            .iter()
            .filter(|input| !matches!(input, FnArg::Receiver(_)))
            .cloned()
            .collect();
        wrapper_sig.inputs.insert(0, recv_arg);
        let mut self_rewriter = ReplaceSelf { root };
        self_rewriter.visit_signature_mut(&mut wrapper_sig);
        if borrows_receiver || receiver_reference_lifetime.is_some() {
            if let ReturnType::Type(_, output) = &mut wrapper_sig.output {
                let mut refs = BindElidedReturnReferences {
                    lifetime: &recv_lifetime,
                    found: false,
                };
                refs.visit_type_mut(output);
            }
        }
    } else {
        let mut self_rewriter = ReplaceSelf { root };
        self_rewriter.visit_signature_mut(&mut wrapper_sig);
    }
    wrapper_sig.inputs.insert(0, parse_quote!(self));
    wrapper_sig.generics = method_generics;
    let wrapper_attrs = cfg_attrs(&impl_method.attrs);
    let method_name = &method.ident;
    let vis = &impl_method.vis;
    let generic_args: Vec<TokenStream2> = method
        .generics
        .params
        .iter()
        .filter_map(|param| match param {
            // Late-bound lifetimes are inferred at the call site. Naming one explicitly in a
            // turbofish is rejected by Rust (E0794); only type and const arguments belong here.
            GenericParam::Lifetime(_) => None,
            GenericParam::Type(param) => {
                let ident = &param.ident;
                Some(quote!(#ident))
            }
            GenericParam::Const(param) => {
                let ident = &param.ident;
                Some(quote!(#ident))
            }
        })
        .collect();
    let turbofish = if generic_args.is_empty() {
        quote!()
    } else {
        quote!(::<#(#generic_args),*>)
    };
    let call = if receiver.is_some() {
        quote!(__receiver.#method_name #turbofish (#(#call_args),*))
    } else {
        quote!(<#root>::#method_name #turbofish (#(#call_args),*))
    };
    let call = if method.asyncness.is_some() {
        quote!(#call.await)
    } else {
        call
    };
    let call = if method.unsafety.is_some() {
        quote!(unsafe { #call })
    } else {
        call
    };
    let wrapper_sig = &wrapper_sig;
    Ok(quote! {
        #(#wrapper_attrs)*
        impl #handle_impl_generics #accessor #helper_args #where_clause {
            #vis #wrapper_sig { #call }
        }
    })
}

fn fresh_receiver_lifetime(
    method: &syn::Signature,
    impl_generics: &syn::Generics,
) -> syn::Lifetime {
    let mut used = LifetimeNames::default();
    // Higher-ranked binders in arguments or returns must not shadow our new outer lifetime.
    used.visit_signature_mut(&mut method.clone());
    used.visit_generics_mut(&mut impl_generics.clone());
    let base = "__gpui_reflect_self";
    let mut name = base.to_string();
    let mut suffix = 0usize;
    while used.0.contains(&name) {
        suffix += 1;
        name = format!("{base}_{suffix}");
    }
    syn::Lifetime::new(&format!("'{name}"), proc_macro2::Span::call_site())
}

#[derive(Default)]
struct LifetimeNames(HashSet<String>);
impl VisitMut for LifetimeNames {
    fn visit_lifetime_mut(&mut self, lifetime: &mut syn::Lifetime) {
        self.0.insert(lifetime.ident.to_string());
    }
}

pub(super) fn validate_method(method: &syn::ImplItemFn) -> syn::Result<()> {
    if method.sig.variadic.is_some() {
        return Err(syn::Error::new_spanned(
            &method.sig,
            "reflected native handles do not support variadic methods",
        ));
    }
    Ok(())
}

pub(super) struct ReplaceSelf<'a> {
    pub(super) root: &'a Type,
}
impl VisitMut for ReplaceSelf<'_> {
    fn visit_type_mut(&mut self, ty: &mut Type) {
        if let Type::Path(TypePath { qself: None, path }) = ty {
            if path.is_ident("Self") {
                *ty = self.root.clone();
                return;
            }
            self.rebase_self_path(path);
        }
        syn::visit_mut::visit_type_mut(self, ty);
    }

    fn visit_expr_mut(&mut self, expr: &mut Expr) {
        if let Expr::Path(ExprPath {
            qself: None, path, ..
        }) = expr
        {
            if self.rebase_self_path(path) {
                return;
            }
        }
        syn::visit_mut::visit_expr_mut(self, expr);
    }
}

impl ReplaceSelf<'_> {
    fn rebase_self_path(&self, path: &mut syn::Path) -> bool {
        if !path
            .segments
            .first()
            .is_some_and(|segment| segment.ident == "Self")
        {
            return false;
        }
        let Type::Path(root) = self.root else {
            return false;
        };
        let mut segments = root.path.segments.clone();
        segments.extend(path.segments.iter().skip(1).cloned());
        path.leading_colon = root.path.leading_colon;
        path.segments = segments;
        true
    }
}

struct FirstReferenceLifetime {
    lifetime: Option<syn::Lifetime>,
}
impl VisitMut for FirstReferenceLifetime {
    fn visit_type_reference_mut(&mut self, ty: &mut syn::TypeReference) {
        if self.lifetime.is_none()
            && ty
                .lifetime
                .as_ref()
                .is_some_and(|lifetime| lifetime.ident != "_")
        {
            self.lifetime = ty.lifetime.clone();
        }
        syn::visit_mut::visit_type_reference_mut(self, ty);
    }
}

struct BindElidedReturnReferences<'a> {
    lifetime: &'a syn::Lifetime,
    found: bool,
}
impl VisitMut for BindElidedReturnReferences<'_> {
    fn visit_lifetime_mut(&mut self, lifetime: &mut syn::Lifetime) {
        if lifetime.ident == "_" {
            *lifetime = self.lifetime.clone();
            self.found = true;
        }
    }

    fn visit_type_reference_mut(&mut self, ty: &mut syn::TypeReference) {
        if ty
            .lifetime
            .as_ref()
            .is_none_or(|lifetime| lifetime.ident == "_")
        {
            ty.lifetime = Some(self.lifetime.clone());
            self.found = true;
        }
        syn::visit_mut::visit_type_reference_mut(self, ty);
    }

    // Function signatures have their own elision rules. Their argument/return borrows do
    // not become loans of the enclosing method's receiver.
    fn visit_type_bare_fn_mut(&mut self, _: &mut syn::TypeBareFn) {}

    fn visit_parenthesized_generic_arguments_mut(
        &mut self,
        _: &mut syn::ParenthesizedGenericArguments,
    ) {
    }
}
