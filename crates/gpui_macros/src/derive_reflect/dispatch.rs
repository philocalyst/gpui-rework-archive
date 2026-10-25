use crate::trait_items::configuration_attributes;
use proc_macro2::{Span, TokenStream as TokenStream2};
use quote::{format_ident, quote};
use syn::{
    FnArg, GenericArgument, GenericParam, Lifetime, LifetimeParam, Meta, PathArguments, ReturnType,
    Signature, Token, TraitBoundModifier, TraitItemFn, Type, TypeParamBound, parse_quote,
    punctuated::Punctuated,
    visit_mut::{self, VisitMut},
};

pub(super) enum MethodDispatch {
    Concrete(ForwardedSignature),
    WrapperDefault,
}

pub(super) fn classify_method(method: &mut TraitItemFn) -> syn::Result<MethodDispatch> {
    let mut wrapper_default = false;
    let mut attributes = Vec::new();

    for attribute in std::mem::take(&mut method.attrs) {
        if !attribute.path().is_ident("reflect") {
            reject_conditional_wrapper_default(&attribute.meta)?;
            attributes.push(attribute);

            continue;
        }

        let settings =
            attribute.parse_args_with(Punctuated::<Meta, Token![,]>::parse_terminated)?;

        if settings.is_empty() {
            return Err(syn::Error::new_spanned(
                attribute,
                "expected #[reflect(wrapper_default)] on a provided method",
            ));
        }

        for setting in settings {
            if !matches!(&setting, Meta::Path(path) if path.is_ident("wrapper_default")) {
                return Err(syn::Error::new_spanned(
                    setting,
                    "unknown reflected method setting; expected wrapper_default",
                ));
            }

            if wrapper_default {
                return Err(syn::Error::new_spanned(
                    setting,
                    "duplicate wrapper_default setting",
                ));
            }

            wrapper_default = true;
        }
    }

    method.attrs = attributes;
    configuration_attributes(&method.attrs)?;

    if wrapper_default {
        if method.default.is_none() {
            return Err(syn::Error::new_spanned(
                &method.sig,
                "wrapper_default requires a provided method body",
            ));
        }

        return Ok(MethodDispatch::WrapperDefault);
    }

    if method.default.is_some()
        && matches!(method.sig.inputs.first(), Some(FnArg::Receiver(receiver))
            if receiver.reference.is_none() && receiver.colon_token.is_none())
    {
        return Ok(MethodDispatch::WrapperDefault);
    }

    let signature = validate_forwarded_signature(&method.sig).map_err(|mut error| {
        if method.default.is_some() {
            error.combine(syn::Error::new_spanned(
                &method.sig.ident,
                "use #[reflect(wrapper_default)] to intentionally run this provided body on ReflectedElement; concrete overrides will not be dispatched",
            ));
        }

        error
    })?;

    Ok(MethodDispatch::Concrete(signature))
}

fn reject_conditional_wrapper_default(meta: &Meta) -> syn::Result<()> {
    if !meta.path().is_ident("cfg_attr") {
        return Ok(());
    }

    let Meta::List(list) = meta else {
        return Err(syn::Error::new_spanned(meta, "expected cfg_attr arguments"));
    };
    let arguments = list.parse_args_with(Punctuated::<Meta, Token![,]>::parse_terminated)?;

    for attribute in arguments.iter().skip(1) {
        if attribute.path().is_ident("reflect") {
            return Err(syn::Error::new_spanned(
                attribute,
                "conditional reflected method settings are unsupported; use #[reflect(wrapper_default)] directly",
            ));
        }

        reject_conditional_wrapper_default(attribute)?;
    }

    Ok(())
}

pub(super) struct ForwardedSignature {
    pub(super) signature: Signature,
    pub(super) lifetimes: Punctuated<GenericParam, Token![,]>,
    pub(super) element_lifetime: Lifetime,
    pub(super) mutable: bool,
    pub(super) erased_arguments: Vec<TokenStream2>,
    pub(super) argument_names: Vec<syn::Ident>,
    pub(super) preparations: Vec<TokenStream2>,
    pub(super) output: ReturnType,
}

pub(super) struct ForwardedMethod {
    pub(super) field: TokenStream2,
    pub(super) initializer: TokenStream2,
    pub(super) implementation: TokenStream2,
}

fn validate_forwarded_signature(signature: &Signature) -> syn::Result<ForwardedSignature> {
    if signature.asyncness.is_some()
        || signature.unsafety.is_some()
        || signature.abi.is_some()
        || signature.constness.is_some()
        || signature.variadic.is_some()
        || signature.generics.where_clause.is_some()
        || signature.generics.params.iter().any(|parameter| {
            !matches!(parameter, GenericParam::Lifetime(parameter) if parameter.bounds.is_empty())
        })
    {
        return Err(syn::Error::new_spanned(
            signature,
            "forwarded reflected methods support borrowed receivers, lifetime parameters, and concrete types",
        ));
    }

    let Some(FnArg::Receiver(receiver)) = signature.inputs.first() else {
        return Err(syn::Error::new_spanned(
            signature,
            "forwarded reflected methods must have an &self or &mut self receiver",
        ));
    };

    if receiver.colon_token.is_some() {
        return Err(syn::Error::new_spanned(
            receiver,
            "typed receivers are not supported",
        ));
    }

    let Some((_, lifetime)) = &receiver.reference else {
        return Err(syn::Error::new_spanned(
            receiver,
            "forwarded reflected methods must have an &self or &mut self receiver",
        ));
    };

    let lifetime = lifetime.as_ref().filter(|lifetime| lifetime.ident != "_");
    let element_lifetime = lifetime
        .cloned()
        .unwrap_or_else(|| Lifetime::new("'__gpui_element", Span::mixed_site()));
    let mut lifetimes = signature.generics.params.clone();

    if lifetime.is_none() {
        lifetimes.push(GenericParam::Lifetime(LifetimeParam::new(
            element_lifetime.clone(),
        )));
    }

    let mut signature = signature.clone();
    let mut erased_arguments = Vec::new();
    let mut argument_names = Vec::new();
    let mut preparations = Vec::new();

    for (idx, argument) in signature.inputs.iter_mut().skip(1).enumerate() {
        let FnArg::Typed(argument) = argument else {
            unreachable!()
        };
        let argument_name = format_ident!("argument_{idx}");
        *argument.pat = parse_quote!(#argument_name);
        argument_names.push(argument_name.clone());

        if let Type::ImplTrait(iterator) = argument.ty.as_ref() {
            let bounds = iterator.bounds.iter().collect::<Vec<_>>();
            let [TypeParamBound::Trait(bound)] = bounds.as_slice() else {
                return Err(syn::Error::new_spanned(
                    iterator,
                    "only impl IntoIterator<Item = ConcreteType> can be erased",
                ));
            };
            let segment = bound.path.segments.last().unwrap();
            let PathArguments::AngleBracketed(arguments) = &segment.arguments else {
                return Err(syn::Error::new_spanned(
                    iterator,
                    "an iterator Item type is required",
                ));
            };
            let arguments = arguments.args.iter().collect::<Vec<_>>();
            let [GenericArgument::AssocType(item)] = arguments.as_slice() else {
                return Err(syn::Error::new_spanned(
                    iterator,
                    "an iterator Item type is required",
                ));
            };

            if segment.ident != "IntoIterator"
                || item.ident != "Item"
                || bound.modifier != TraitBoundModifier::None
                || bound.lifetimes.is_some()
            {
                return Err(syn::Error::new_spanned(
                    iterator,
                    "only impl IntoIterator<Item = ConcreteType> can be erased",
                ));
            }

            validate_type(&item.ty)?;
            let item_type = &item.ty;
            erased_arguments.push(quote! { &mut dyn ::std::iter::Iterator<Item = #item_type> });
            preparations.push(quote! { let mut #argument_name = #argument_name.into_iter(); });

            continue;
        }

        validate_type(&argument.ty)?;
        let argument_type = &argument.ty;
        erased_arguments.push(quote! { #argument_type });
    }

    let mut output = signature.output.clone();

    if let ReturnType::Type(_, output_type) = &mut output {
        validate_type(output_type)?;
        OutputLifetimes(&element_lifetime).visit_type_mut(output_type);
    }

    Ok(ForwardedSignature {
        signature,
        lifetimes,
        element_lifetime,
        mutable: receiver.mutability.is_some(),
        erased_arguments,
        argument_names,
        preparations,
        output,
    })
}

pub(super) fn forward_method(
    method: &TraitItemFn,
    trait_name: &syn::Ident,
    lowered: ForwardedSignature,
) -> syn::Result<ForwardedMethod> {
    let ForwardedSignature {
        signature,
        lifetimes,
        element_lifetime,
        mutable,
        erased_arguments,
        argument_names,
        preparations,
        output,
    } = lowered;

    let method_name = &signature.ident;

    let erased_receiver = if mutable {
        quote! { &#element_lifetime mut dyn ::std::any::Any }
    } else {
        quote! { &#element_lifetime dyn ::std::any::Any }
    };

    let downcast = if mutable {
        quote! { downcast_mut }
    } else {
        quote! { downcast_ref }
    };

    let parts = if mutable {
        quote! { __reflection_parts_mut }
    } else {
        quote! { __reflection_parts }
    };

    let forwarded_arguments = signature.inputs.iter().skip(1).zip(&argument_names).map(|(argument, name)| {
        if matches!(argument, FnArg::Typed(argument) if matches!(*argument.ty, Type::ImplTrait(_))) {
            return quote! { &mut #name };
        }

        quote! { #name }
    });
    let configurations = configuration_attributes(&method.attrs)?;
    let lifetime_binder = if lifetimes.is_empty() {
        quote! {}
    } else {
        quote! { for<#lifetimes> }
    };

    Ok(ForwardedMethod {
        field: quote! {
            #(#configurations)*
            #method_name: #lifetime_binder fn(#erased_receiver, #(#erased_arguments),*) #output,
        },
        initializer: quote! {
            #(#configurations)*
            #method_name: |element, #(#argument_names),*| {
                let concrete = element.#downcast::<Type>().expect("reflected element type changed");

                <Type as #trait_name>::#method_name(concrete, #(#argument_names),*)
            },
        },
        implementation: quote! {
            #(#configurations)*
            #signature {
                #(#preparations)*
                let (methods, element) = self.#parts(#trait_name);

                (methods.#method_name)(element, #(#forwarded_arguments),*)
            }
        },
    })
}

fn validate_type(type_name: &Type) -> syn::Result<()> {
    struct UnsupportedType(Option<syn::Error>);

    impl VisitMut for UnsupportedType {
        fn visit_type_mut(&mut self, type_name: &mut Type) {
            if matches!(type_name, Type::ImplTrait(_))
                || matches!(type_name, Type::Path(path) if path.path.segments.iter().any(|segment| segment.ident == "Self"))
            {
                self.0 = Some(syn::Error::new_spanned(
                    type_name,
                    "forwarded reflected methods cannot use Self or impl Trait outside a supported iterator argument",
                ));

                return;
            }

            visit_mut::visit_type_mut(self, type_name);
        }
    }

    let mut visitor = UnsupportedType(None);
    visitor.visit_type_mut(&mut type_name.clone());

    match visitor.0 {
        Some(error) => Err(error),
        None => Ok(()),
    }
}

struct OutputLifetimes<'life>(&'life Lifetime);

impl VisitMut for OutputLifetimes<'_> {
    fn visit_type_bare_fn_mut(&mut self, _function: &mut syn::TypeBareFn) {}

    fn visit_parenthesized_generic_arguments_mut(
        &mut self,
        _arguments: &mut syn::ParenthesizedGenericArguments,
    ) {
    }

    fn visit_type_reference_mut(&mut self, reference: &mut syn::TypeReference) {
        if reference
            .lifetime
            .as_ref()
            .is_none_or(|lifetime| lifetime.ident == "_")
        {
            reference.lifetime = Some(self.0.clone());
        }

        visit_mut::visit_type_reference_mut(self, reference);
    }
}
