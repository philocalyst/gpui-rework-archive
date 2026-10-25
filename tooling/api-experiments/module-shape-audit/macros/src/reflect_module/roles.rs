use proc_macro2::TokenStream as TokenStream2;
use quote::quote;
use std::collections::{HashMap, HashSet};
use syn::visit_mut::VisitMut;
use syn::{FnArg, GenericParam, Item, ItemTrait, Meta, TraitItem, Type, TypeParamBound};

use super::impl_targets;

pub(super) fn role_registrations(
    type_name: &syn::Ident,
    root: &Type,
    items: &[Item],
) -> Vec<TokenStream2> {
    let mut roles = Vec::new();
    for item in items {
        let Item::Impl(implementation) = item else {
            continue;
        };
        if !impl_targets(implementation, type_name) {
            continue;
        }
        let Some((_, trait_path, _)) = &implementation.trait_ else {
            continue;
        };
        // Conditional impls can impose predicates that a Describe impl must not impose on every
        // instantiation. Keep the Rust impl and omit only this optional native role.
        if implementation.generics.where_clause.is_some()
            || implementation
                .generics
                .params
                .iter()
                .any(|param| matches!(param, GenericParam::Type(param) if !param.bounds.is_empty()))
        {
            continue;
        }
        let Some(resolved_trait) = resolve_local_trait_bound(trait_path, items) else {
            continue;
        };
        let Some(trait_item) = local_trait(&resolved_trait, items) else {
            continue;
        };

        let mut seen = HashSet::new();
        let mut trait_attrs = Vec::new();
        let mut bindings = Vec::new();
        let mut binding_names = HashMap::new();
        if !collect_trait_tree(
            trait_item,
            items,
            root,
            &mut seen,
            &mut trait_attrs,
            &mut bindings,
            &mut binding_names,
        ) {
            continue;
        }

        let target = if bindings.is_empty() {
            quote!(dyn #trait_path)
        } else {
            quote!(dyn #trait_path<#(#bindings),*>)
        };
        let mut attrs = role_cfg_attrs(&implementation.attrs);
        attrs.extend(trait_attrs);
        roles.push(quote!(
            #(#attrs)*
            ::gpui::reflection::Role::<Self, #target>::new(
                |value: &mut Self| value as &mut #target,
            ).into_schema()
        ));
    }
    roles
}

fn collect_trait_tree(
    item: &ItemTrait,
    items: &[Item],
    root: &Type,
    seen: &mut HashSet<String>,
    attrs: &mut Vec<syn::Attribute>,
    bindings: &mut Vec<TokenStream2>,
    binding_names: &mut HashMap<String, String>,
) -> bool {
    let key = item.ident.to_string();
    if !seen.insert(key) {
        return true;
    }
    attrs.extend(role_cfg_attrs(&item.attrs));
    for bound in &item.supertraits {
        match bound {
            TypeParamBound::Lifetime(_) => {}
            TypeParamBound::Trait(bound) => {
                if let Some(local) = resolve_local_trait_bound(&bound.path, items) {
                    let Some(parent) = local_trait(&local, items) else {
                        return false;
                    };
                    if !collect_trait_tree(
                        parent,
                        items,
                        root,
                        seen,
                        attrs,
                        bindings,
                        binding_names,
                    ) {
                        return false;
                    }
                } else if !known_external_supertrait(&bound.path) {
                    // We cannot inspect external associated items. Omitting this optional role is
                    // safer than generating a trait object with missing bindings.
                    return false;
                }
            }
            _ => return false,
        }
    }

    let mut associated_names = binding_names.keys().cloned().collect::<HashSet<_>>();
    for member in &item.items {
        let TraitItem::Type(associated) = member else {
            continue;
        };
        if !associated.generics.params.is_empty() {
            // A GAT bounded by Self: Sized is unavailable through the trait object and does not
            // need an object binding. Other GATs make the trait non-dyn-compatible.
            if where_clause_requires_sized(&associated.generics.where_clause) {
                continue;
            }
            return false;
        }
        // cfg on associated items cannot be represented on a generic argument. Keep the Rust
        // impl intact and omit this optional role when the associated binding is conditional.
        if !role_cfg_attrs(&associated.attrs).is_empty() {
            return false;
        }

        let name_text = associated.ident.to_string();
        if let Some(previous_trait) = binding_names.get(&name_text) {
            // The same declaration can arrive through a trait diamond, but distinct associated
            // items with the same name cannot be represented by an unambiguous object binding.
            if previous_trait != &item.ident.to_string() {
                return false;
            }
        } else {
            binding_names.insert(name_text.clone(), item.ident.to_string());
            associated_names.insert(name_text.clone());
            let declaring_trait = &item.ident;
            let name = &associated.ident;
            bindings.push(quote!(#name = <#root as #declaring_trait>::#name));
        }
    }
    if !trait_is_object_safe(item, &associated_names) {
        return false;
    }
    true
}

fn known_external_supertrait(path: &syn::Path) -> bool {
    path.segments.len() == 1
        && path.segments.last().is_some_and(|segment| {
            matches!(
                segment.ident.to_string().as_str(),
                "Send" | "Sync" | "Unpin"
            )
        })
}

fn role_cfg_attrs(attrs: &[syn::Attribute]) -> Vec<syn::Attribute> {
    let mut output = Vec::new();
    for attr in attrs {
        if attr.path().is_ident("cfg") {
            output.push(attr.clone());
            continue;
        }
        if !attr.path().is_ident("cfg_attr") {
            continue;
        }
        let Meta::List(list) = &attr.meta else {
            continue;
        };
        let parser = syn::punctuated::Punctuated::<Meta, syn::Token![,]>::parse_terminated;
        let Ok(metas) = syn::parse::Parser::parse2(parser, list.tokens.clone()) else {
            continue;
        };
        let mut metas = metas.into_iter();
        let Some(predicate) = metas.next() else {
            continue;
        };
        let cfgs = metas
            .filter(|meta| meta.path().is_ident("cfg"))
            .collect::<Vec<_>>();
        if !cfgs.is_empty() {
            output.push(syn::parse_quote!(#[cfg_attr(#predicate, #(#cfgs),*)]));
        }
    }
    output
}

fn local_trait<'a>(name: &syn::Ident, items: &'a [Item]) -> Option<&'a ItemTrait> {
    items.iter().find_map(|item| match item {
        Item::Trait(item) if item.ident == *name => Some(item),
        _ => None,
    })
}

fn resolve_local_trait_alias(name: &syn::Ident, items: &[Item]) -> Option<syn::Ident> {
    if local_trait(name, items).is_some() {
        return Some(name.clone());
    }
    for item in items {
        let Item::Use(item) = item else { continue };
        if let Some(original) = imported_name(&item.tree, name) {
            if local_trait(&original, items).is_some() {
                return Some(original);
            }
        }
    }
    None
}

fn resolve_local_trait_bound(path: &syn::Path, items: &[Item]) -> Option<syn::Ident> {
    let first = path.segments.first()?.ident.to_string();
    if path.segments.len() > 1 && first != "self" {
        return None;
    }
    resolve_local_trait_alias(&path.segments.last()?.ident, items)
}

fn imported_name(tree: &syn::UseTree, requested: &syn::Ident) -> Option<syn::Ident> {
    match tree {
        syn::UseTree::Path(path) => imported_name(&path.tree, requested),
        syn::UseTree::Name(name) if name.ident == *requested => Some(name.ident.clone()),
        syn::UseTree::Rename(rename) if rename.rename == *requested => Some(rename.ident.clone()),
        syn::UseTree::Group(group) => group
            .items
            .iter()
            .find_map(|tree| imported_name(tree, requested)),
        _ => None,
    }
}

fn trait_is_object_safe(item: &ItemTrait, associated_names: &HashSet<String>) -> bool {
    // Lifetime parameters are also left unsupported here: naming the object lifetime in the
    // generated target needs a concrete binding that this local shape pass does not infer.
    if !item.generics.params.is_empty()
        || item.supertraits.iter().any(|bound| {
            matches!(bound, TypeParamBound::Trait(bound)
                if matches!(bound.modifier, syn::TraitBoundModifier::None)
                    && bound.path.segments.last().is_some_and(|segment| segment.ident == "Sized"))
        })
    {
        return false;
    }

    for member in &item.items {
        match member {
            TraitItem::Const(_) | TraitItem::Macro(_) => return false,
            TraitItem::Type(associated) => {
                if !associated.generics.params.is_empty()
                    && !where_clause_requires_sized(&associated.generics.where_clause)
                {
                    return false;
                }
            }
            TraitItem::Fn(method) => {
                // Such methods are not part of the trait-object vtable, so their async/generic
                // signatures and Self mentions do not affect dyn compatibility.
                if where_clause_requires_sized(&method.sig.generics.where_clause) {
                    continue;
                }
                if method.sig.asyncness.is_some()
                    || method
                        .sig
                        .generics
                        .params
                        .iter()
                        .any(|param| !matches!(param, GenericParam::Lifetime(_)))
                {
                    return false;
                }
                if !matches!(method.sig.inputs.first(), Some(FnArg::Receiver(_))) {
                    return false;
                }
                let mut scan = SignatureShapeScan::default();
                scan.visit_signature_mut(&mut method.sig.clone());
                if scan.contains_impl_trait {
                    return false;
                }
                let mut check = IllegalSelfType {
                    associated: associated_names,
                    illegal: false,
                };
                for input in method.sig.inputs.iter().skip(1) {
                    if let FnArg::Typed(input) = input {
                        check.visit_type_mut(&mut input.ty.as_ref().clone());
                    }
                }
                let mut output = method.sig.output.clone();
                check.visit_return_type_mut(&mut output);
                if check.illegal {
                    return false;
                }
            }
            _ => {}
        }
    }
    true
}

fn where_clause_requires_sized(where_clause: &Option<syn::WhereClause>) -> bool {
    where_clause.as_ref().is_some_and(|where_clause| {
        where_clause.predicates.iter().any(|predicate| {
            let syn::WherePredicate::Type(predicate) = predicate else {
                return false;
            };
            if !matches!(&predicate.bounded_ty, Type::Path(path)
                if path.qself.is_none() && path.path.is_ident("Self"))
            {
                return false;
            }
            predicate.bounds.iter().any(|bound| {
                matches!(bound, TypeParamBound::Trait(bound)
                    if matches!(bound.modifier, syn::TraitBoundModifier::None)
                        && bound.path.segments.last().is_some_and(|segment| segment.ident == "Sized"))
            })
        })
    })
}

#[derive(Default)]
struct SignatureShapeScan {
    contains_impl_trait: bool,
}
impl VisitMut for SignatureShapeScan {
    fn visit_type_impl_trait_mut(&mut self, _: &mut syn::TypeImplTrait) {
        self.contains_impl_trait = true;
    }
}

struct IllegalSelfType<'a> {
    associated: &'a HashSet<String>,
    illegal: bool,
}

impl VisitMut for IllegalSelfType<'_> {
    fn visit_type_path_mut(&mut self, node: &mut syn::TypePath) {
        if node.qself.is_none()
            && node
                .path
                .segments
                .first()
                .is_some_and(|segment| segment.ident == "Self")
        {
            let allowed = node.path.segments.iter().nth(1).is_some_and(|segment| {
                self.associated
                    .iter()
                    .any(|name| name == &segment.ident.to_string())
            });
            if !allowed {
                self.illegal = true;
            }
        } else if let Some(qself) = &node.qself {
            if matches!(qself.ty.as_ref(), Type::Path(path) if path.qself.is_none() && path.path.is_ident("Self"))
            {
                let allowed = node.path.segments.last().is_some_and(|segment| {
                    self.associated
                        .iter()
                        .any(|name| name == &segment.ident.to_string())
                });
                if !allowed {
                    self.illegal = true;
                }
            }
        }
        syn::visit_mut::visit_type_path_mut(self, node);
    }
}
