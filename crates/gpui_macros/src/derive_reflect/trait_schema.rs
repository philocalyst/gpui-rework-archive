use super::dispatch::{MethodDispatch, classify_method, forward_method};
use crate::trait_items::{UnknownMacros, configuration_attributes, normalize_trait_items};
use proc_macro::TokenStream;
use proc_macro2::{Span, TokenStream as TokenStream2};
use quote::{format_ident, quote};
use std::{
    collections::hash_map::DefaultHasher,
    hash::{Hash, Hasher},
    sync::atomic::{AtomicUsize, Ordering},
};
use syn::{
    ItemTrait, Meta, Path, PathArguments, Token, TraitBoundModifier, TraitItem, TypeParamBound,
    parse::Parser, parse_macro_input, parse_quote, punctuated::Punctuated,
};

static SCHEMA_IDS: AtomicUsize = AtomicUsize::new(0);

pub(crate) fn reflect_trait(args: TokenStream, input: TokenStream) -> TokenStream {
    let parser = Punctuated::<Meta, Token![,]>::parse_terminated;
    let settings = match parser.parse(args) {
        Ok(settings) => settings,
        Err(error) => return error.to_compile_error().into(),
    };
    let mut membership = false;
    let mut builtin = None;
    for setting in settings {
        match setting {
            Meta::Path(path) if path.is_ident("membership") && !membership => {
                membership = true;
            }
            Meta::NameValue(value) if value.path.is_ident("builtin") && builtin.is_none() => {
                let syn::Expr::Path(value) = value.value else {
                    return syn::Error::new_spanned(value, "builtin access must be an identifier")
                        .to_compile_error()
                        .into();
                };
                let Some(segment) = value.path.get_ident() else {
                    return syn::Error::new_spanned(value, "builtin access must be an identifier")
                        .to_compile_error()
                        .into();
                };
                if !matches!(
                    segment.to_string().as_str(),
                    "styled" | "interactive" | "stateful" | "parent"
                ) {
                    return syn::Error::new_spanned(
                        segment,
                        "expected builtin access `styled`, `interactive`, `stateful`, or `parent`",
                    )
                    .to_compile_error()
                    .into();
                }
                builtin = Some(segment.clone());
            }
            other => {
                return syn::Error::new_spanned(
                    other,
                    "expected #[reflect_trait], #[reflect_trait(membership)], or #[reflect_trait(builtin = styled|interactive|stateful|parent)]",
                )
                .to_compile_error()
                .into();
            }
        }
    }
    if membership && builtin.is_some() {
        return syn::Error::new(
            Span::call_site(),
            "membership reflection cannot declare builtin callable access",
        )
        .to_compile_error()
        .into();
    }
    let input = parse_macro_input!(input as ItemTrait);
    let expanded = if membership {
        expand_membership_trait(input)
    } else {
        expand_trait(input, builtin)
    };

    match expanded {
        Ok(output) => output.into(),
        Err(error) => error.to_compile_error().into(),
    }
}

pub(super) fn expand_trait(
    mut input: ItemTrait,
    builtin: Option<syn::Ident>,
) -> syn::Result<TokenStream2> {
    if !input.generics.params.is_empty() || input.generics.where_clause.is_some() {
        return Err(syn::Error::new_spanned(
            &input.ident,
            "reflect_trait requires a non-generic trait without a where clause",
        ));
    }

    if input.unsafety.is_some() {
        return Err(syn::Error::new_spanned(
            &input.ident,
            "unsafe traits cannot be forwarded through reflected elements",
        ));
    }

    normalize_trait_items(&mut input, UnknownMacros::Reject)?;

    let name = &input.ident;
    let visibility = &input.vis;
    let marker = format_ident!("__GpuiReflect{name}");
    let group = format_ident!("__GpuiReflect{name}Group");
    let methods = format_ident!("__GpuiReflect{name}Methods");
    let collect_name = format_ident!("__GpuiReflect{name}Collect");
    let schema = schema_path(&parse_quote!(#name));
    let schema_name = &schema.segments.last().unwrap().ident;
    let export_name = schema_export_name(name);
    let mut parents = Vec::new();

    for bound in &input.supertraits {
        let TypeParamBound::Trait(bound) = bound else {
            return Err(syn::Error::new_spanned(
                bound,
                "reflected supertraits must be non-generic trait paths",
            ));
        };

        if bound.path.is_ident("Sized") {
            continue;
        }

        if bound.modifier != TraitBoundModifier::None
            || bound.lifetimes.is_some()
            || bound
                .path
                .segments
                .iter()
                .any(|segment| !matches!(segment.arguments, PathArguments::None))
        {
            return Err(syn::Error::new_spanned(
                bound,
                "reflected supertraits must be non-generic trait paths",
            ));
        }

        parents.push(bound.path.clone());
    }

    let parent_aliases = (0..parents.len())
        .map(|idx| format_ident!("Parent{idx}"))
        .collect::<Vec<_>>();
    let parent_imports = (0..parents.len())
        .map(|idx| format_ident!("__GpuiReflect{name}Parent{idx}"))
        .collect::<Vec<_>>();
    let parent_schemas = parents.iter().map(schema_path);
    let parent_accesses = parent_aliases.iter().map(|alias| {
        quote! {
            <#schema_name::#alias::Marker as gpui::reflection::ReflectionToken>::Access
        }
    });
    let own_access = builtin_access_type(builtin.as_ref());
    let access_type = union_access_types(parent_accesses.chain(std::iter::once(own_access)));
    let mut forwarded = Vec::new();

    for item in &mut input.items {
        match item {
            TraitItem::Fn(method) => {
                if let MethodDispatch::Concrete(signature) = classify_method(method)? {
                    forwarded.push(forward_method(method, name, signature)?);
                }
            }
            TraitItem::Type(_) => {
                return Err(syn::Error::new_spanned(
                    item,
                    "reflected traits cannot have associated types",
                ));
            }
            TraitItem::Const(_) => {
                return Err(syn::Error::new_spanned(
                    item,
                    "callable reflected traits cannot expose associated constants; move a shared value outside the trait, or expose a borrowed method for concrete values",
                ));
            }
            other => {
                return Err(syn::Error::new_spanned(
                    other,
                    "reflect_trait cannot classify this trait item; use a supported method declaration",
                ));
            }
        }
    }

    let fields = forwarded.iter().map(|method| &method.field);
    let initializers = forwarded.iter().map(|method| &method.initializer);
    let implementations = forwarded.iter().map(|method| &method.implementation);
    let parent_members = parents.iter().zip(&parent_aliases).map(|(parent, alias)| {
        quote! {
            __GpuiReflectionGroup: gpui::reflection::IncludesCallableTrait<#schema_name::#alias::Marker>,
            gpui::reflection::ReflectedElement<__GpuiReflectionGroup, __GpuiReflectionReceiver>: #parent,
        }
    });
    let builtin_group_impls = builtin_includes_impls(&marker, builtin.as_ref());
    let builtin_marker_check = builtin_marker_type(builtin.as_ref()).map(|builtin_marker| {
        quote! {
            const _: fn(#marker) -> #builtin_marker = |token| token;
        }
    });
    let configurations = configuration_attributes(&input.attrs)?;
    let parent_import_items = parent_schemas.zip(&parent_imports).map(|(schema, import)| {
        quote! {
            #(#configurations)*
            #[doc(hidden)]
            pub use #schema as #import;
        }
    });
    let parent_checks =
        parents
            .iter()
            .zip(&parent_aliases)
            .enumerate()
            .map(|(idx, (parent, alias))| {
                let check = format_ident!("__GPUI_REFLECTION_PARENT_CHECK_{export_name}_{idx}");

                quote! {
                    #(#configurations)*
                    #[allow(non_upper_case_globals)]
                    const #check: #schema_name::#alias::Marker = #parent;
                }
            });
    let collector = schema_collector(&export_name, &format_ident!("callable"), &parent_aliases);

    Ok(quote! {
        #input

        #(#configurations)*
        #[doc(hidden)]
        #[derive(Clone, Copy, Default)]
        pub struct #marker;

        #(#configurations)*
        #[doc(hidden)]
        pub struct #methods { #(#fields)* }

        #builtin_marker_check

        #(#parent_import_items)*
        #(#parent_checks)*

        #(#configurations)*
        #[doc(hidden)]
        #[allow(non_snake_case)]
        pub mod #schema_name {
            pub type Marker = super::#marker;
            #(pub use super::#parent_imports as #parent_aliases;)*
            pub use super::#collect_name as collect;
        }

        #(#configurations)*
        #[doc(hidden)]
        #[macro_export]
        #collector

        #(#configurations)*
        #[doc(hidden)]
        pub use #export_name as #collect_name;

        #(#configurations)*
        #schema_name::collect! { [items pub #group] [[#schema_name] any] [] [] [] [] }

        #(#configurations)*
        impl gpui::reflection::ReflectionToken for #marker {
            type Group = #group;
            type Access = #access_type;
            type Adapter = gpui::reflection::Callable<#methods>;

            fn requirement(self) -> gpui::reflection::ReflectionRequirement {
                gpui::reflection::ReflectionRequirement::callable(self)
            }

            fn requirements(self) -> Vec<gpui::reflection::ReflectionRequirement> {
                let mut requirements = gpui::reflection::ReflectionRequirements::new();
                gpui::reflection::ReflectionToken::append_requirements(self, &mut requirements);
                requirements.into_vec()
            }

            fn append_requirements(
                self,
                requirements: &mut gpui::reflection::ReflectionRequirements,
            ) {
                let requirement = gpui::reflection::ReflectionToken::requirement(self);

                if !requirements.contains(&requirement) {
                    requirements.push(requirement);
                }

                #(gpui::reflection::ReflectionToken::append_requirements(
                    #parents,
                    requirements,
                );)*
            }

            fn reflected_trait(self) -> gpui::reflection::ReflectedTrait {
                gpui::reflection::ReflectedTrait::new(
                    concat!(module_path!(), "::", stringify!(#name)),
                    || ::std::any::TypeId::of::<#marker>(),
                ).with_supertraits(|| {
                    static PARENTS: ::std::sync::LazyLock<Vec<gpui::reflection::ReflectedTrait>>
                        = ::std::sync::LazyLock::new(|| vec![
                            #(gpui::reflection::ReflectionToken::reflected_trait(
                                #parents,
                            )),*
                        ]);

                    &PARENTS
                })
            }
        }

        #(#configurations)*
        impl gpui::reflection::CallableReflectionToken for #marker {
            type Methods = #methods;
        }

        #builtin_group_impls

        #(#configurations)*
        impl #marker {
            #[doc(hidden)]
            #[allow(private_bounds)]
            pub fn __register<Type: #name + 'static>(
                self,
                implementations: &mut Vec<gpui::reflection::ReflectedImplementation<Type>>,
            ) {
                let descriptor = gpui::reflection::ReflectionToken::reflected_trait(self);

                if implementations.iter().any(|implementation| {
                    implementation.descriptor == descriptor
                        && implementation.methods.as_deref().is_some_and(|methods| methods.is::<#methods>())
                }) {
                    return;
                }

                implementations.push(gpui::reflection::ReflectedImplementation::__new(
                    descriptor,
                    Some(Box::new(#methods { #(#initializers)* })),
                ));

                #(#parents.__register::<Type>(implementations);)*
            }
        }

        #(#configurations)*
        impl<__GpuiReflectionGroup, __GpuiReflectionReceiver> #name
            for gpui::reflection::ReflectedElement<__GpuiReflectionGroup, __GpuiReflectionReceiver>
        where
            __GpuiReflectionGroup: gpui::reflection::IncludesCallableTrait<#marker>,
            __GpuiReflectionReceiver: gpui::reflection::ReflectionReceiver,
            #(#parent_members)*
        {
            #(#implementations)*
        }

        #(#configurations)*
        #[doc = concat!("Descriptor for the ", stringify!(#name), " trait.")]
        #[allow(non_upper_case_globals)]
        #visibility const #name: #marker = #marker;
    })
}

fn builtin_access_type(builtin: Option<&syn::Ident>) -> TokenStream2 {
    let (styled, interactive, stateful, parent) = match builtin.map(ToString::to_string).as_deref()
    {
        Some("styled") => (
            quote!(gpui::reflection::On),
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::Off),
        ),
        Some("interactive") => (
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::On),
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::Off),
        ),
        Some("stateful") => (
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::On),
            quote!(gpui::reflection::Off),
        ),
        Some("parent") => (
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::Off),
            quote!(gpui::reflection::On),
        ),
        _ => return quote!(gpui::reflection::NoAccess),
    };

    quote!(gpui::reflection::Access<#styled, #interactive, #stateful, #parent>)
}

fn union_access_types(accesses: impl IntoIterator<Item = TokenStream2>) -> TokenStream2 {
    accesses.into_iter().fold(
        quote!(gpui::reflection::NoAccess),
        |combined, next| quote!(<#combined as gpui::reflection::AccessUnion<#next>>::Output),
    )
}

fn builtin_includes_impls(marker: &syn::Ident, builtin: Option<&syn::Ident>) -> TokenStream2 {
    let (has, slot) = match builtin.map(ToString::to_string).as_deref() {
        Some("styled") => (quote!(gpui::reflection::HasStyled), quote!(styled)),
        Some("interactive") => (
            quote!(gpui::reflection::HasInteractive),
            quote!(interactive),
        ),
        Some("stateful") => (quote!(gpui::reflection::HasStateful), quote!(stateful)),
        Some("parent") => (quote!(gpui::reflection::HasParent), quote!(parent)),
        _ => return TokenStream2::new(),
    };

    quote! {
        impl<__Left, __Right> gpui::reflection::IncludesReflectedTrait<#marker>
            for gpui::reflection::Both<__Left, __Right>
        where
            __Left: gpui::reflection::ReflectionGroup,
            __Right: gpui::reflection::ReflectionGroup,
            <__Left::Access as gpui::reflection::AccessUnion<__Right::Access>>::Output: #has,
        {}

        impl<__Left, __Right> gpui::reflection::IncludesCallableTrait<#marker>
            for gpui::reflection::Both<__Left, __Right>
        where
            __Left: gpui::reflection::ReflectionGroup,
            __Right: gpui::reflection::ReflectionGroup,
            <__Left::Access as gpui::reflection::AccessUnion<__Right::Access>>::Output: #has,
        {
            fn methods(
                tables: &Self::Tables,
            ) -> &'static <#marker as gpui::reflection::CallableReflectionToken>::Methods {
                <<__Left::Access as gpui::reflection::AccessUnion<__Right::Access>>::Output as #has>::#slot(
                    &tables.builtins,
                )
            }
        }
    }
}

fn builtin_marker_type(builtin: Option<&syn::Ident>) -> Option<TokenStream2> {
    match builtin.map(ToString::to_string).as_deref() {
        Some("styled") => Some(quote!(::gpui::__GpuiReflectStyled)),
        Some("interactive") => Some(quote!(::gpui::__GpuiReflectInteractiveElement)),
        Some("stateful") => Some(quote!(::gpui::__GpuiReflectStatefulInteractiveElement)),
        Some("parent") => Some(quote!(::gpui::__GpuiReflectParentElement)),
        _ => None,
    }
}

pub(super) fn expand_membership_trait(input: ItemTrait) -> syn::Result<TokenStream2> {
    if !input.generics.params.is_empty() || input.generics.where_clause.is_some() {
        return Err(syn::Error::new_spanned(
            &input.ident,
            "membership reflection requires a non-generic trait without a where clause",
        ));
    }

    let name = &input.ident;
    let visibility = &input.vis;
    let marker = format_ident!("__GpuiReflect{name}");
    let collect_name = format_ident!("__GpuiReflect{name}Collect");
    let schema = schema_path(&parse_quote!(#name));
    let schema_name = &schema.segments.last().unwrap().ident;
    let export_name = schema_export_name(name);
    let collector = schema_collector(&export_name, &format_ident!("membership"), &[]);
    let configurations = configuration_attributes(&input.attrs)?;

    Ok(quote! {
        #input

        #(#configurations)*
        #[doc(hidden)]
        #[derive(Clone, Copy, Default)]
        pub struct #marker;

        #(#configurations)*
        #[doc(hidden)]
        #[allow(non_snake_case)]
        pub mod #schema_name {
            pub type Marker = super::#marker;
            pub use super::#collect_name as collect;
        }

        #(#configurations)*
        #[doc(hidden)]
        #[macro_export]
        #collector

        #(#configurations)*
        #[doc(hidden)]
        pub use #export_name as #collect_name;

        #(#configurations)*
        impl gpui::reflection::ReflectionToken for #marker {
            type Group = gpui::reflection::ErasedReflectionGroup;
            type Access = gpui::reflection::NoAccess;
            type Adapter = gpui::reflection::Membership;

            fn reflected_trait(self) -> gpui::reflection::ReflectedTrait {
                gpui::reflection::ReflectedTrait::new(
                    concat!(module_path!(), "::", stringify!(#name)),
                    || ::std::any::TypeId::of::<#marker>(),
                )
            }

        }

        #(#configurations)*
        impl #marker {
            #[doc(hidden)]
            #[allow(private_bounds)]
            pub fn __register<Type: #name + 'static>(
                self,
                implementations: &mut Vec<gpui::reflection::ReflectedImplementation<Type>>,
            ) {
                implementations.push(gpui::reflection::ReflectedImplementation::__new(
                    gpui::reflection::ReflectionToken::reflected_trait(self),
                    None,
                ));
            }
        }

        #(#configurations)*
        #[doc = concat!("Membership descriptor for the ", stringify!(#name), " trait.")]
        #[allow(non_upper_case_globals)]
        #visibility const #name: #marker = #marker;
    })
}

fn schema_export_name(name: &syn::Ident) -> syn::Ident {
    let mut origin = DefaultHasher::new();
    std::env::var("CARGO_MANIFEST_DIR")
        .unwrap_or_default()
        .hash(&mut origin);
    std::env::var("CARGO_CRATE_NAME")
        .unwrap_or_default()
        .hash(&mut origin);

    format_ident!(
        "__gpui_reflect_schema_{}_{:x}_{}",
        name,
        origin.finish(),
        SCHEMA_IDS.fetch_add(1, Ordering::Relaxed),
    )
}

fn schema_collector(
    export_name: &syn::Ident,
    kind: &syn::Ident,
    parents: &[syn::Ident],
) -> TokenStream2 {
    quote! {
        macro_rules! #export_name {
            (
                [$($header:tt)*]
                [[$($schema:tt)*] $expectation:ident]
                [$($pending:tt)*]
                [$($members:tt)*]
                [$($witnesses:tt)*]
                [$($roots:tt)*]
            ) => {
                ::gpui::reflection::__collect_reflected_traits! {
                    [$($header)*]
                    [#export_name]
                    [$($schema)*::Marker]
                    [#kind]
                    [$expectation]
                    [#([[$($schema)*::#parents] callable])*]
                    [$($pending)*]
                    [$($members)*]
                    [$($witnesses)*]
                    [$($roots)*]
                }
            };
        }
    }
}

pub(crate) fn schema_path(path: &Path) -> Path {
    let mut schema = path.clone();
    let segment = schema.segments.last_mut().unwrap();
    segment.ident = format_ident!("__GpuiReflect{}Schema", segment.ident);

    schema
}
