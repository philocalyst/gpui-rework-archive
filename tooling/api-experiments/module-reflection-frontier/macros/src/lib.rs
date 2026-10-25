use proc_macro::TokenStream;
use quote::{format_ident, quote};
use syn::{Fields, ImplItem, Item, ItemEnum, ItemImpl, ItemMod, ItemStruct, Type, parse_macro_input};

#[proc_macro_attribute]
pub fn reflect(_attr: TokenStream, input: TokenStream) -> TokenStream {
    let mut module = parse_macro_input!(input as ItemMod);
    let Some((brace, items)) = module.content.as_mut() else {
        return syn::Error::new_spanned(
            &module,
            "`#[reflect]` requires an inline module so it can inspect the module's items and private fields",
        )
        .to_compile_error()
        .into();
    };
    let _ = brace;

    let types: Vec<Item> = items
        .iter()
        .filter(|item| matches!(item, Item::Struct(_) | Item::Enum(_)))
        .cloned()
        .collect();
    for item in items.iter() {
        if let Item::Union(union) = item {
            return syn::Error::new_spanned(union, "`#[reflect]` currently supports structs and enums, not unions")
                .to_compile_error().into();
        }
        if let Item::Impl(implementation) = item {
            let reflected = types.iter().any(|item| match item {
                Item::Struct(item) => impl_targets(implementation, &item.ident),
                Item::Enum(item) => impl_targets(implementation, &item.ident),
                _ => false,
            });
            if reflected {
                for impl_item in &implementation.items {
                    if !matches!(impl_item, ImplItem::Fn(_)) {
                        return syn::Error::new_spanned(
                            impl_item,
                            "reflection records method signatures; associated constants and types need an explicit schema entry",
                        ).to_compile_error().into();
                    }
                }
            }
        }
    }
    let mut generated = Vec::new();
    for item in &types {
        match item {
            Item::Struct(item) => generated.extend(reflect_struct(item, items)),
            Item::Enum(item) => generated.extend(reflect_enum(item, items)),
            _ => unreachable!(),
        }
    }
    items.extend(generated.into_iter().map(syn::Item::Verbatim));
    quote!(#module).into()
}

fn reflect_struct(item: &ItemStruct, items: &[Item]) -> Vec<proc_macro2::TokenStream> {
    let name = &item.ident;
    let fields_name = format_ident!("__{}Fields", name);
    let vis = &item.vis;
    let generics = &item.generics;
    let (impl_generics, ty_generics, where_clause) = item.generics.split_for_impl();
    let type_ty: Type = syn::parse_quote!(#name #ty_generics);

    let (field_defs, field_inits) = match &item.fields {
        Fields::Named(fields) => {
            let defs = fields.named.iter().map(|field| {
                let ident = field.ident.as_ref().unwrap();
                let field_vis = &field.vis;
                let ty = &field.ty;
                quote!(#field_vis #ident: ::module_reflection_frontier::Field<#type_ty, #ty>)
            });
            let inits = fields.named.iter().map(|field| {
                let ident = field.ident.as_ref().unwrap();
                let key = ident.to_string();
                quote!(#ident: ::module_reflection_frontier::Field::new(
                    #key,
                    |value: &#type_ty| &value.#ident,
                    |value: &mut #type_ty, next| value.#ident = next,
                ))
            });
            (quote!(#(#defs,)*), quote!(#(#inits,)*))
        }
        Fields::Unnamed(fields) => {
            let defs = fields.unnamed.iter().enumerate().map(|(index, field)| {
                let ident = format_ident!("field_{index}");
                let field_vis = &field.vis;
                let ty = &field.ty;
                quote!(#field_vis #ident: ::module_reflection_frontier::Field<#type_ty, #ty>)
            });
            let inits = fields.unnamed.iter().enumerate().map(|(index, _)| {
                let ident = format_ident!("field_{index}");
                let key = format!("{index}");
                let index = syn::Index::from(index);
                quote!(#ident: ::module_reflection_frontier::Field::new(
                    #key,
                    |value: &#type_ty| &value.#index,
                    |value: &mut #type_ty, next| value.#index = next,
                ))
            });
            (quote!(#(#defs,)*), quote!(#(#inits,)*))
        }
        Fields::Unit => (quote!(), quote!()),
    };
    let fields_decl = quote!(#vis struct #fields_name #generics { #field_defs });
    let fields_ctor = quote!(#fields_name { #field_inits });
    let methods = method_records(name, items);
    let field_names: Vec<String> = match &item.fields {
        Fields::Named(fields) => fields.named.iter().map(|field| field.ident.as_ref().unwrap().to_string()).collect(),
        Fields::Unnamed(fields) => (0..fields.unnamed.len()).map(|i| i.to_string()).collect(),
        Fields::Unit => vec![],
    };
    let method_ident = format_ident!("__{}_METHODS", name.to_string().to_uppercase());
    let field_ident = format_ident!("__{}_FIELD_NAMES", name.to_string().to_uppercase());
    vec![quote! {
        #fields_decl
        impl #impl_generics ::module_reflection_frontier::Reflect for #type_ty #where_clause {
            type Fields = #fields_name #ty_generics;
            fn fields() -> Self::Fields { #fields_ctor }
            fn field_names() -> &'static [&'static str] {
                const #field_ident: &[&str] = &[#(#field_names),*];
                #field_ident
            }
            fn methods() -> &'static [::module_reflection_frontier::MethodRecord] {
                const #method_ident: &[::module_reflection_frontier::MethodRecord] = &[#(#methods),*];
                #method_ident
            }
        }
        impl #impl_generics ::module_reflection_frontier::ElementSchema for #type_ty #where_clause {}
    }]
}

fn reflect_enum(item: &ItemEnum, items: &[Item]) -> Vec<proc_macro2::TokenStream> {
    let name = &item.ident;
    let (impl_generics, ty_generics, where_clause) = item.generics.split_for_impl();
    let type_ty: Type = syn::parse_quote!(#name #ty_generics);
    let variant_records = item.variants.iter().map(|variant| {
        let variant_name = variant.ident.to_string();
        let field_names: Vec<String> = match &variant.fields {
            Fields::Named(fields) => fields.named.iter().map(|field| field.ident.as_ref().unwrap().to_string()).collect(),
            Fields::Unnamed(fields) => (0..fields.unnamed.len()).map(|i| i.to_string()).collect(),
            Fields::Unit => vec![],
        };
        quote!(::module_reflection_frontier::VariantRecord { name: #variant_name, fields: &[#(#field_names),*] })
    });
    let methods = method_records(name, items);
    let method_ident = format_ident!("__{}_METHODS", name.to_string().to_uppercase());
    let variant_ident = format_ident!("__{}_VARIANTS", name.to_string().to_uppercase());
    vec![quote! {
        impl #impl_generics ::module_reflection_frontier::Reflect for #type_ty #where_clause {
            type Fields = ();
            fn fields() -> Self::Fields { () }
            fn field_names() -> &'static [&'static str] { &[] }
            fn methods() -> &'static [::module_reflection_frontier::MethodRecord] {
                const #method_ident: &[::module_reflection_frontier::MethodRecord] = &[#(#methods),*];
                #method_ident
            }
            fn variants() -> &'static [::module_reflection_frontier::VariantRecord] {
                const #variant_ident: &[::module_reflection_frontier::VariantRecord] = &[#(#variant_records),*];
                #variant_ident
            }
        }
        impl #impl_generics ::module_reflection_frontier::ElementSchema for #type_ty #where_clause {}
    }]
}

fn method_records(type_name: &syn::Ident, items: &[Item]) -> Vec<proc_macro2::TokenStream> {
    let mut output = Vec::new();
    for item in items {
        let Item::Impl(implementation) = item else { continue };
        if !impl_targets(implementation, type_name) { continue; }
        for impl_item in &implementation.items {
            let ImplItem::Fn(method) = impl_item else { continue };
            let method_name = method.sig.ident.to_string();
            let sig = &method.sig;
            let signature = quote!(#sig).to_string();
            let trait_name = implementation.trait_.as_ref().map(|(_, path, _)| quote!(#path).to_string());
            let trait_name_tokens = match trait_name {
                Some(value) => quote!(Some(#value)),
                None => quote!(None),
            };
            output.push(quote!(::module_reflection_frontier::MethodRecord {
                name: #method_name,
                signature: #signature,
                trait_name: #trait_name_tokens,
            }));
        }
    }
    output
}

fn impl_targets(implementation: &ItemImpl, type_name: &syn::Ident) -> bool {
    let Type::Path(path) = implementation.self_ty.as_ref() else { return false };
    path.path.segments.last().is_some_and(|segment| segment.ident == *type_name)
}
