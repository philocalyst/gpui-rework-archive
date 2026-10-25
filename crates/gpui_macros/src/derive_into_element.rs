use proc_macro::TokenStream;
use proc_macro2::TokenStream as TokenStream2;
use quote::quote;
use syn::{DeriveInput, Token, parse_macro_input};

pub fn derive_into_element(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as DeriveInput);

    expand_into_element(&input)
        .unwrap_or_else(syn::Error::into_compile_error)
        .into()
}

fn expand_into_element(input: &DeriveInput) -> syn::Result<TokenStream2> {
    let mut concrete = false;

    for attribute in &input.attrs {
        if !attribute.path().is_ident("into_element") {
            continue;
        }

        if concrete {
            return Err(syn::Error::new_spanned(
                attribute,
                "duplicate #[into_element(self)]",
            ));
        }

        attribute.parse_args::<Token![self]>()?;
        concrete = true;
    }

    let name = &input.ident;
    let (impl_generics, type_generics, where_clause) = input.generics.split_for_impl();
    // View supplies conversion directly, including every RenderOnce component. Retain this derive as a source
    // compatibility shim; concrete Element implementations still opt into self conversion.
    if !concrete {
        return Ok(TokenStream2::new());
    }
    Ok(quote! {
        impl #impl_generics gpui::IntoElement for #name #type_generics #where_clause {
            type Element = Self;

            #[track_caller]
            fn into_element(self) -> Self::Element {
                self
            }
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rejects_invalid_concrete_conversion_settings() {
        for declaration in [
            "#[into_element] struct Invalid;",
            "#[into_element(unknown)] struct Invalid;",
            "#[into_element(self, unknown)] struct Invalid;",
            "#[into_element(self)] #[into_element(self)] struct Invalid;",
        ] {
            let input = syn::parse_str(declaration).unwrap();

            assert!(expand_into_element(&input).is_err());
        }
    }
}
