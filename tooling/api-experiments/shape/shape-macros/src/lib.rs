use proc_macro::TokenStream;
use quote::quote;
use syn::{DeriveInput, Fields, Meta, Path, parse_macro_input, parse_quote};

#[proc_macro_derive(Shape, attributes(shape))]
pub fn derive_shape(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as DeriveInput);
    let ident = &input.ident;
    let fields = match &input.data {
        syn::Data::Struct(data) => match &data.fields {
            Fields::Named(named) => named.named.iter().map(|f| {
                let name = f.ident.as_ref().unwrap().to_string();
                let ty = &f.ty;
                quote!(shape_api_experiment::FieldInfo { name: #name, type_name: ::std::any::type_name::<#ty>() })
            }).collect::<Vec<_>>(),
            Fields::Unit => Vec::new(),
            _ => return syn::Error::new_spanned(ident, "Shape experiment supports named-field and unit structs")
                .to_compile_error().into(),
        },
        _ => return syn::Error::new_spanned(ident, "Shape experiment supports structs")
            .to_compile_error().into(),
    };
    let mut capabilities: Vec<Path> = Vec::new();
    for attr in &input.attrs {
        if attr.path().is_ident("shape") {
            if let Meta::List(list) = &attr.meta {
                let parsed = syn::parse2::<syn::Expr>(list.tokens.clone());
                if let Ok(syn::Expr::Call(call)) = parsed {
                    if call.func.to_token_stream().to_string() == "capabilities" {
                        for arg in call.args {
                            if let syn::Expr::Path(path) = arg {
                                capabilities.push(path.path);
                            }
                        }
                    }
                }
            }
        }
    }
    let generic = !input.generics.params.is_empty();
    let mut generics = input.generics.clone();
    let capability_bounds: Vec<syn::WherePredicate> = capabilities
        .iter()
        .map(|capability| parse_quote!(Self: shape_api_experiment::Implements<#capability>))
        .collect();
    generics
        .make_where_clause()
        .predicates
        .extend(capability_bounds);
    let (ig, tg, wc) = generics.split_for_impl();
    if generic && !input.attrs.iter().any(|a| a.path().is_ident("shape")) {
        return syn::Error::new_spanned(ident, "generic Shape derives require explicit #[shape(capabilities(...))], including builtin capabilities")
            .to_compile_error().into();
    }
    let builtin_probes = if generic {
        Vec::new()
    } else {
        vec![
            quote!({
                struct Probe<T>(::std::marker::PhantomData<T>);
                trait Detect {
                    fn register(self, capabilities: &mut Vec<shape_api_experiment::CapabilityInfo>);
                }
                impl<T> Detect for &Probe<T> {
                    fn register(self, _: &mut Vec<shape_api_experiment::CapabilityInfo>) {}
                }
                impl<T: shape_api_experiment::traits::Styled> Detect for &&Probe<T> {
                    fn register(self, caps: &mut Vec<shape_api_experiment::CapabilityInfo>) {
                        caps.push(<shape_api_experiment::capabilities::Styled as shape_api_experiment::Capability>::info());
                    }
                }
                (&&Probe::<Self>(::std::marker::PhantomData)).register(&mut capabilities);
            }),
            quote!({
                struct Probe<T>(::std::marker::PhantomData<T>);
                trait Detect {
                    fn register(self, capabilities: &mut Vec<shape_api_experiment::CapabilityInfo>);
                }
                impl<T> Detect for &Probe<T> {
                    fn register(self, _: &mut Vec<shape_api_experiment::CapabilityInfo>) {}
                }
                impl<T: shape_api_experiment::traits::Parent> Detect for &&Probe<T> {
                    fn register(self, caps: &mut Vec<shape_api_experiment::CapabilityInfo>) {
                        caps.push(<shape_api_experiment::capabilities::Parent as shape_api_experiment::Capability>::info());
                    }
                }
                (&&Probe::<Self>(::std::marker::PhantomData)).register(&mut capabilities);
            }),
        ]
    };
    let registration = (!generic).then(|| {
        quote! {
            shape_api_experiment::__inventory::submit! {
                shape_api_experiment::ShapeRegistration {
                    type_id: || ::std::any::TypeId::of::<#ident>(),
                    shape: <#ident as shape_api_experiment::Shape>::shape,
                }
            }
        }
    });
    let expanded = quote! {
        impl #ig shape_api_experiment::Shape for #ident #tg #wc {
            fn shape() -> &'static shape_api_experiment::ShapeInfo {
                shape_api_experiment::metadata_for::<Self>(|| shape_api_experiment::ShapeInfo {
                    type_name: ::std::any::type_name::<Self>(),
                    fields: vec![#(#fields),*],
                    capabilities: {
                        let mut capabilities = vec![#(<#capabilities as shape_api_experiment::Capability>::info()),*];
                        #(#builtin_probes)*
                        capabilities.sort_unstable_by_key(|cap| cap.type_id);
                        capabilities.dedup_by_key(|cap| cap.type_id);
                        capabilities
                    },
                })
            }
        }
        #registration
    };
    expanded.into()
}

use quote::ToTokens;
