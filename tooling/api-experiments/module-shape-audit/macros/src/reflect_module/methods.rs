use proc_macro2::TokenStream as TokenStream2;
use quote::{ToTokens, format_ident, quote};
use std::collections::HashMap;
use syn::visit_mut::VisitMut;
use syn::{
    Expr, ExprPath, FnArg, GenericParam, ImplItem, Item, PatType, ReturnType, Type, TypePath,
    parse_quote,
};

use super::{cfg_attrs, impl_targets, schema};

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
    let mut method_counts = HashMap::<String, usize>::new();
    for item in items {
        let Item::Impl(implementation) = item else {
            continue;
        };
        if implementation.trait_.is_none() && impl_targets(implementation, type_name) {
            for impl_item in &implementation.items {
                if let ImplItem::Fn(method) = impl_item {
                    *method_counts
                        .entry(method.sig.ident.to_string())
                        .or_default() += 1;
                }
            }
        }
    }
    let mut method_occurrences = HashMap::<String, usize>::new();
    for item in items {
        let Item::Impl(implementation) = item else {
            continue;
        };
        if implementation.trait_.is_some() || !impl_targets(implementation, type_name) {
            continue;
        }
        let impl_cfg = cfg_attrs(&implementation.attrs);
        for impl_item in &implementation.items {
            let ImplItem::Fn(method) = impl_item else {
                continue;
            };
            let method_name = &method.sig.ident;
            let method_key = method_name.to_string();
            let occurrence = method_occurrences.entry(method_key.clone()).or_default();
            *occurrence += 1;
            let mut specialized_root: Type = implementation.self_ty.as_ref().clone();
            impl_generic_substitutions(&implementation.generics, type_generics)
                .visit_type_mut(&mut specialized_root);
            let field_ident = if method_counts.get(&method_key).copied().unwrap_or_default() > 1 {
                let suffix = implementation.self_ty.to_token_stream().to_string();
                let suffix = suffix
                    .chars()
                    .map(|character| {
                        if character.is_ascii_alphanumeric() {
                            character
                        } else {
                            '_'
                        }
                    })
                    .collect::<String>();
                schema::snake_case(&format!("{method_key}_for_{suffix}_{}", occurrence))
            } else {
                method_name.clone()
            };
            let accessor = format_ident!(
                "__{}Method{}",
                type_name,
                schema::pascal_case(&field_ident.to_string())
            );
            let generics = type_generics;
            let (_, ty_generics, _) = generics.split_for_impl();
            let method_vis = &method.vis;
            let mut attrs = type_attrs.to_vec();
            attrs.extend(impl_cfg.clone());
            attrs.extend(cfg_attrs(&method.attrs));
            let declaration = quote!(#(#attrs)* #method_vis struct #accessor #generics (::core::marker::PhantomData<fn() -> #root>););
            let member = quote!(#(#attrs)* #method_vis #field_ident: #accessor #ty_generics);
            let initializer =
                quote!(#(#attrs)* #field_ident: #accessor(::core::marker::PhantomData));
            let implementation = method_handle_impl(
                method,
                &specialized_root,
                &implementation.generics,
                generics,
                &accessor,
            )?;
            output.push(MethodAccessor {
                declaration,
                member,
                initializer,
                implementation: quote!(#(#attrs)* #implementation),
            });
        }
    }
    Ok(output)
}

fn helper_generics(
    type_generics: &syn::Generics,
    impl_generics: &syn::Generics,
    root: &Type,
) -> syn::Generics {
    let mut output = type_generics.clone();
    let mut substitutions = impl_generic_substitutions(impl_generics, type_generics);
    for (source, target) in impl_generics.params.iter().zip(output.params.iter_mut()) {
        match (source, target) {
            (GenericParam::Type(source), GenericParam::Type(target)) => {
                for bound in &source.bounds {
                    let mut bound = bound.clone();
                    substitutions.visit_type_param_bound_mut(&mut bound);
                    ReplaceSelf { root }.visit_type_param_bound_mut(&mut bound);
                    target.bounds.push(bound);
                }
            }
            (GenericParam::Lifetime(source), GenericParam::Lifetime(target)) => {
                for bound in &source.bounds {
                    let mut bound = bound.clone();
                    substitutions.visit_lifetime_mut(&mut bound);
                    target.bounds.push(bound);
                }
            }
            (GenericParam::Const(_), GenericParam::Const(_)) => {}
            _ => {}
        }
    }
    if let Some(where_clause) = &impl_generics.where_clause {
        for predicate in &where_clause.predicates {
            let mut predicate = predicate.clone();
            substitutions.visit_where_predicate_mut(&mut predicate);
            ReplaceSelf { root }.visit_where_predicate_mut(&mut predicate);
            output.make_where_clause().predicates.push(predicate);
        }
    }
    output
}

fn impl_generic_substitutions(
    impl_generics: &syn::Generics,
    type_generics: &syn::Generics,
) -> ImplGenericSubstitutions {
    let mut substitutions = ImplGenericSubstitutions::default();
    for (source, target) in impl_generics.params.iter().zip(type_generics.params.iter()) {
        match (source, target) {
            (GenericParam::Type(source), GenericParam::Type(target)) => {
                substitutions
                    .types
                    .insert(source.ident.to_string(), target.ident.clone());
            }
            (GenericParam::Lifetime(source), GenericParam::Lifetime(target)) => {
                substitutions
                    .lifetimes
                    .insert(source.lifetime.ident.to_string(), target.lifetime.clone());
            }
            (GenericParam::Const(source), GenericParam::Const(target)) => {
                substitutions
                    .types
                    .insert(source.ident.to_string(), target.ident.clone());
            }
            _ => {}
        }
    }
    substitutions
}

#[derive(Default)]
struct ImplGenericSubstitutions {
    types: HashMap<String, syn::Ident>,
    lifetimes: HashMap<String, syn::Lifetime>,
}

impl VisitMut for ImplGenericSubstitutions {
    fn visit_type_path_mut(&mut self, node: &mut TypePath) {
        if node.qself.is_none() {
            if let Some(first) = node.path.segments.first_mut() {
                if let Some(replacement) = self.types.get(&first.ident.to_string()) {
                    first.ident = replacement.clone();
                }
            }
        }
        syn::visit_mut::visit_type_path_mut(self, node);
    }

    fn visit_expr_path_mut(&mut self, node: &mut ExprPath) {
        if node.qself.is_none() {
            if let Some(first) = node.path.segments.first_mut() {
                if let Some(replacement) = self.types.get(&first.ident.to_string()) {
                    first.ident = replacement.clone();
                }
            }
        }
        syn::visit_mut::visit_expr_path_mut(self, node);
    }

    fn visit_lifetime_mut(&mut self, node: &mut syn::Lifetime) {
        if let Some(replacement) = self.lifetimes.get(&node.ident.to_string()) {
            *node = replacement.clone();
        }
    }
}

fn method_handle_impl(
    method: &syn::ImplItemFn,
    root: &Type,
    impl_generics_source: &syn::Generics,
    type_generics: &syn::Generics,
    accessor: &syn::Ident,
) -> syn::Result<TokenStream2> {
    let impl_method = method;
    let method = &impl_method.sig;
    let mut wrapper_sig = method.clone();
    wrapper_sig.ident = format_ident!("call");
    wrapper_sig.constness = None;
    wrapper_sig.abi = None;
    let mut substitutions = impl_generic_substitutions(impl_generics_source, type_generics);
    substitutions.visit_signature_mut(&mut wrapper_sig);
    let receiver = wrapper_sig.inputs.iter().find_map(|input| match input {
        FnArg::Receiver(receiver) => Some(receiver.clone()),
        _ => None,
    });
    let mut call_args = Vec::new();
    for (index, input) in wrapper_sig.inputs.iter_mut().enumerate() {
        if let FnArg::Typed(argument) = input {
            let ident = format_ident!("__arg_{index}");
            argument.pat = Box::new(parse_quote!(#ident));
            call_args.push(quote!(#ident));
        }
    }
    let mut generics = helper_generics(type_generics, impl_generics_source, root);
    ReplaceSelf { root }.visit_generics_mut(&mut generics);
    let (handle_impl_generics, ty_generics, where_clause) = generics.split_for_impl();
    let mut method_generics = wrapper_sig.generics.clone();
    ReplaceSelf { root }.visit_generics_mut(&mut method_generics);
    let recv_lifetime: syn::Lifetime;
    if let Some(receiver) = &receiver {
        let borrows_receiver = receiver.reference.is_some();
        let synthetic_lifetime = || fresh_receiver_lifetime(method, impl_generics_source);
        let mut receiver_reference_lifetime = receiver.lifetime().cloned();
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
                receiver_reference_lifetime = Some(synthetic);
                method_generics.params.insert(
                    0,
                    GenericParam::Lifetime(parse_quote!('__gpui_reflect_self)),
                );
            }
        }
        recv_lifetime = receiver_reference_lifetime
            .clone()
            .unwrap_or_else(synthetic_lifetime);
        if borrows_receiver && receiver.lifetime().is_none() {
            method_generics.params.insert(
                0,
                GenericParam::Lifetime(parse_quote!('__gpui_reflect_self)),
            );
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
        recv_lifetime = parse_quote!('__gpui_reflect_self);
        let mut self_rewriter = ReplaceSelf { root };
        self_rewriter.visit_signature_mut(&mut wrapper_sig);
    }
    wrapper_sig.inputs.insert(0, parse_quote!(&self));
    wrapper_sig.generics = method_generics;
    let method_generics = &wrapper_sig.generics;
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
    let _ = (recv_lifetime, method_generics);
    Ok(quote! {
        #(#wrapper_attrs)*
        impl #handle_impl_generics #accessor #ty_generics #where_clause {
            #vis #wrapper_sig { #call }
        }
    })
}

fn fresh_receiver_lifetime(
    method: &syn::Signature,
    impl_generics: &syn::Generics,
) -> syn::Lifetime {
    let mut used = HashMap::<String, ()>::new();
    for param in method
        .generics
        .params
        .iter()
        .chain(impl_generics.params.iter())
    {
        if let GenericParam::Lifetime(param) = param {
            used.insert(param.lifetime.ident.to_string(), ());
        }
    }
    let base = "__gpui_reflect_self";
    let mut name = base.to_string();
    let mut suffix = 0usize;
    while used.contains_key(&name) {
        suffix += 1;
        name = format!("{base}_{suffix}");
    }
    syn::Lifetime::new(&format!("'{name}"), proc_macro2::Span::call_site())
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
        if self.lifetime.is_none() {
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
    fn visit_type_reference_mut(&mut self, ty: &mut syn::TypeReference) {
        if ty.lifetime.is_none() {
            ty.lifetime = Some(self.lifetime.clone());
            self.found = true;
        }
        syn::visit_mut::visit_type_reference_mut(self, ty);
    }
}
