use proc_macro::TokenStream;
use quote::{format_ident, quote};
use syn::{Fields, ImplItem, Item, ItemMod, Type as SynType};

#[proc_macro_attribute]
pub fn reflect_module(_: TokenStream, input: TokenStream) -> TokenStream {
    let mut module = syn::parse_macro_input!(input as ItemMod);
    let Some((_, items)) = module.content.as_mut() else {
        return syn::Error::new_spanned(module, "frontier prototype requires an inline module")
            .to_compile_error().into();
    };

    let structs: Vec<_> = items.iter().filter_map(|item| match item {
        Item::Struct(s) => Some(s.clone()),
        _ => None,
    }).collect();
    let impls: Vec<_> = items.iter().filter_map(|item| match item {
        Item::Impl(i) => Some(i.clone()),
        _ => None,
    }).collect();

    let mut generated = Vec::new();
    for structure in &structs {
        let ty = &structure.ident;
        let vis = &structure.vis;
        let type_view_fn = format_ident!("__{}_type_view", ty.to_string().to_lowercase());
        let ident = ty.to_string();
        let mut field_defs = Vec::new();
        if let Fields::Named(fields) = &structure.fields {
            for field in &fields.named {
                let name = field.ident.as_ref().unwrap();
                let field_name = name.to_string();
                let field_ty = &field.ty;
                let type_name = quote!(#field_ty).to_string().replace(' ', "");
                let kind = value_kind(field_ty);
                let (get_expr, set_expr) = if let Some((_value_ty, to_value, from_value)) = kind {
                    (quote!(::frontier_reflect::Value::#to_value(v.#name)), quote! {
                        let ::frontier_reflect::Value::#from_value(value) = value else { return false };
                        v.#name = value;
                        true
                    })
                } else {
                    (quote!(::frontier_reflect::Value::Borrowed(&mut v.#name)), quote!(false))
                };
                field_defs.push(quote! {
                    ::frontier_reflect::Field {
                        name: #field_name,
                        type_name: #type_name,
                        get: |target| {
                            let v = target.downcast_mut::<#ty>()?;
                            Some(#get_expr)
                        },
                        set: |target, value| {
                            let Some(v) = target.downcast_mut::<#ty>() else { return false };
                            #set_expr
                        },
                    }
                });
            }
        }

        let methods = impls.iter().filter(|i| matches!(&*i.self_ty, SynType::Path(p) if p.path.is_ident(ty)))
            .flat_map(|i| i.items.iter()).filter_map(|item| match item {
                ImplItem::Fn(f) if matches!(f.vis, syn::Visibility::Public(_))
                    && matches!(f.sig.inputs.first(), Some(syn::FnArg::Receiver(r)) if r.reference.is_some() && r.mutability.is_some())
                    && f.sig.inputs.len() == 1
                    && matches!(f.sig.output, syn::ReturnType::Default) => Some(f.sig.ident.clone()),
                _ => None,
            }).collect::<Vec<_>>();
        let method_defs = methods.iter().map(|method| {
            let name = method.to_string();
            quote! {
                ::frontier_reflect::Method {
                    name: #name,
                    call: |target| {
                        let Some(v) = target.downcast_mut::<#ty>() else { return false };
                        v.#method();
                        true
                    },
                }
            }
        });
        generated.push(quote! {
            #vis fn #type_view_fn() -> &'static ::frontier_reflect::Type {
                static TYPE: ::frontier_reflect::Type = ::frontier_reflect::Type {
                    name: #ident,
                    fields: &[#(#field_defs),*],
                    methods: &[#(#method_defs),*],
                };
                &TYPE
            }
            impl ::frontier_reflect::Describe for #ty {
                fn type_view() -> &'static ::frontier_reflect::Type { #type_view_fn() }
            }
        });
    }
    let generated_file: syn::File = syn::parse2(quote!(#(#generated)*)).expect("generated impls parse");
    items.extend(generated_file.items);
    quote!(#module).into()
}

fn value_kind(ty: &SynType) -> Option<(proc_macro2::TokenStream, syn::Ident, syn::Ident)> {
    let SynType::Path(path) = ty else { return None };
    let name = path.path.segments.last()?.ident.to_string();
    match name.as_str() {
        "f32" => Some((quote!(f32), format_ident!("F32"), format_ident!("F32"))),
        "u32" => Some((quote!(u32), format_ident!("U32"), format_ident!("U32"))),
        "bool" => Some((quote!(bool), format_ident!("Bool"), format_ident!("Bool"))),
        _ => None,
    }
}
