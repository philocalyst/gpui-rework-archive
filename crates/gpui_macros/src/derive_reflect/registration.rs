use proc_macro::TokenStream;
use proc_macro2::TokenStream as TokenStream2;
use quote::quote;
use syn::{
    DeriveInput, Expr, Ident, Path, Token, parse::Parse, parse::ParseStream, parse_macro_input,
    parse_quote, punctuated::Punctuated,
};
struct CapabilityRegistration {
    path: Path,
    projection: Option<Expr>,
}

enum ReflectEntry {
    Trait(Path),
    Capability(CapabilityRegistration),
}

impl Parse for ReflectEntry {
    fn parse(input: ParseStream) -> syn::Result<Self> {
        let lookahead = input.fork();
        if lookahead.peek(Ident) {
            let name: Ident = lookahead.parse()?;
            if name == "capability" && lookahead.peek(syn::token::Paren) {
                let _: Ident = input.parse()?;
                let content;
                syn::parenthesized!(content in input);
                let path: Path = content.parse()?;
                let projection = if content.peek(Token![=>]) {
                    content.parse::<Token![=>]>()?;
                    let expression: Expr = content.parse()?;
                    if !matches!(expression, Expr::Closure(_)) {
                        return Err(syn::Error::new_spanned(
                            expression,
                            "capability projection must be a closure",
                        ));
                    }
                    Some(expression)
                } else {
                    None
                };
                if !content.is_empty() {
                    return Err(content.error("unexpected tokens after capability registration"));
                }
                return Ok(Self::Capability(CapabilityRegistration {
                    path,
                    projection,
                }));
            }
        }

        input.parse().map(Self::Trait)
    }
}

pub fn derive_reflect(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as DeriveInput);

    match expand_reflect(input) {
        Ok(output) => output.into(),
        Err(error) => error.to_compile_error().into(),
    }
}

pub(crate) fn expand_reflect(input: DeriveInput) -> syn::Result<TokenStream2> {
    let type_name = &input.ident;
    let generic = !input.generics.params.is_empty();
    let automatic_traits: [Path; 4] = [
        parse_quote!(gpui::Styled),
        parse_quote!(gpui::InteractiveElement),
        parse_quote!(gpui::StatefulInteractiveElement),
        parse_quote!(gpui::ParentElement),
    ];
    let mut explicit_traits = Vec::new();
    let mut capabilities = Vec::new();
    let mut explicit_list = false;

    for attribute in &input.attrs {
        if attribute.path().is_ident("reflect") {
            explicit_list = true;
            let entries = attribute
                .parse_args_with(Punctuated::<ReflectEntry, Token![,]>::parse_terminated)?;
            for entry in entries {
                match entry {
                    ReflectEntry::Trait(path) => explicit_traits.push(path),
                    ReflectEntry::Capability(capability) => capabilities.push(capability),
                }
            }
        }
    }

    if generic && !explicit_list {
        return Err(syn::Error::new_spanned(
            type_name,
            "generic Reflect derives require an explicit #[reflect(...)] list, including builtin traits; use #[reflect()] for an empty registration",
        ));
    }

    let mut generics = input.generics.clone();

    if generic {
        let bounds = generics.make_where_clause();
        bounds.predicates.push(parse_quote!(Self: 'static));
        bounds.predicates.extend(
            explicit_traits
                .iter()
                .map(|path| -> syn::WherePredicate { parse_quote!(Self: #path) }),
        );
    }

    let (impl_generics, type_generics, where_clause) = generics.split_for_impl();
    let probes = automatic_traits.iter().filter(|_path| !generic).map(|trait_path| {
        quote! {
            {
                struct Probe<Type>(::std::marker::PhantomData<Type>);

                trait Detect<Receiver: 'static> {
                    fn register(self, implementations: &mut Vec<gpui::reflection::ReflectedImplementation<Receiver>>);
                }

                impl<Receiver: 'static> Detect<Receiver> for &Probe<Receiver> {
                    fn register(self, _implementations: &mut Vec<gpui::reflection::ReflectedImplementation<Receiver>>) {}
                }

                impl<Receiver: #trait_path + 'static> Detect<Receiver> for &&Probe<Receiver> {
                    fn register(self, implementations: &mut Vec<gpui::reflection::ReflectedImplementation<Receiver>>) {
                        #trait_path.__register::<Receiver>(implementations);
                    }
                }

                (&&Probe::<Self>(::std::marker::PhantomData)).register(&mut implementations);
            }
        }
    });
    let explicit = explicit_traits.iter().map(|trait_path| {
        quote! { #trait_path.__register::<Self>(&mut implementations); }
    });
    let capability_registrations = capabilities.iter().map(|capability| {
        let path = &capability.path;
        let projection = capability
            .projection
            .clone()
            .unwrap_or_else(|| parse_quote!(|element| element));
        quote! { implementations.push(#path.bind::<Self>(#projection)); }
    });
    let registration = (!generic).then(|| {
        quote! {
            gpui::private::inventory::submit! {
                gpui::reflection::ReflectionRegistration {
                    type_id: || ::std::any::TypeId::of::<#type_name>(),
                    reflection: <#type_name as gpui::reflection::Reflect>::reflection,
                }
            }
        }
    });
    let reflection = (!generic).then(|| {
        quote! {
            fn reflection() -> &'static gpui::reflection::ElementReflection {
                static REFLECTION: ::std::sync::LazyLock<
                    &'static gpui::reflection::ElementReflection,
                > = ::std::sync::LazyLock::new(|| {
                    gpui::reflection::metadata_for::<#type_name>(
                        <#type_name as gpui::reflection::Reflect>::build_reflection,
                    )
                });

                *REFLECTION
            }
        }
    });

    Ok(quote! {
        impl #impl_generics gpui::reflection::Reflect for #type_name #type_generics #where_clause {
            #reflection

            fn build_reflection() -> Vec<gpui::reflection::ReflectedImplementation<Self>> {
                let mut implementations = Vec::new();
                #(#probes)*
                #(#explicit)*
                #(#capability_registrations)*

                implementations
            }
        }

        #registration
    })
}
