use proc_macro2::TokenStream as TokenStream2;
use quote::{format_ident, quote};
use syn::{parse_quote, Fields, Item, ItemEnum, ItemStruct, Type};

use super::{cfg_attrs, impl_targets, methods, roles, schema};

pub(super) fn reflect_struct(item: &ItemStruct, items: &[Item]) -> syn::Result<Vec<TokenStream2>> {
    let name = &item.ident;
    let fields_name = format_ident!("__{}Fields", name);
    let methods_name = format_ident!("__{}Methods", name);
    let generics = &item.generics;
    let (_, ty_generics, _) = generics.split_for_impl();
    let root: Type = parse_quote!(#name #ty_generics);
    let vis = &item.vis;
    let type_attrs = cfg_attrs(&item.attrs);
    // Trait access is the stable API. Inherent shorthands are only emitted when
    // they do not shadow a method supplied by the user's type.
    let has_fields_method = has_inherent_method(name, items, "fields");
    let has_methods_method = has_inherent_method(name, items, "methods");

    let fields = struct_field_accessors(&item.fields, &root, name, items);
    let field_defs = fields.iter().map(|field| &field.definition);
    let field_inits = fields.iter().map(|field| &field.initializer);
    let schema_fields: Vec<_> = fields
        .iter()
        .filter(|field| !field.schema_conversion.is_empty())
        .map(|field| &field.schema_conversion)
        .collect();
    let fields_decl = quote!(#vis struct #fields_name #generics {
        #(#field_defs,)*
        #[doc(hidden)] __marker: ::core::marker::PhantomData<fn() -> #root>,
    });
    let methods = methods::method_accessors(name, &root, generics, &type_attrs, items)?;
    let method_defs = methods.iter().map(|method| &method.member);
    let method_inits = methods.iter().map(|method| &method.initializer);
    let methods_decl = quote!(#vis struct #methods_name #generics {
        #(#method_defs,)*
        #[doc(hidden)] __marker: ::core::marker::PhantomData<fn() -> #root>,
    });
    let method_impls = methods
        .iter()
        .flat_map(|method| [&method.declaration, &method.implementation]);
    let fields_convenience = if has_fields_method {
        TokenStream2::new()
    } else {
        quote!(#vis fn fields() -> #fields_name #ty_generics {
            <Self as ::gpui::reflection::HasFields>::fields()
        })
    };
    let methods_convenience = if has_methods_method {
        TokenStream2::new()
    } else {
        quote!(#vis fn methods() -> #methods_name #ty_generics {
            <Self as ::gpui::reflection::HasMethods>::methods()
        })
    };
    let mut describe_generics = generics.clone();
    describe_generics
        .make_where_clause()
        .predicates
        .push(parse_quote!(Self: 'static));
    let (describe_impl_generics, _, describe_where) = describe_generics.split_for_impl();
    let (access_impl_generics, _, access_where) = generics.split_for_impl();
    let variant = quote!(None);
    let roles = roles::role_registrations(name, &root, items);
    let type_shape_override = schema::type_shape_override(generics, &root);

    Ok(vec![quote! {
        #(#type_attrs)* #fields_decl
        #(#type_attrs)* #methods_decl

        #(#type_attrs)* impl #access_impl_generics #root #access_where {
            #fields_convenience
            #methods_convenience
        }

        #(#type_attrs)* impl #access_impl_generics ::gpui::reflection::HasFields for #root #access_where {
            type Fields = #fields_name #ty_generics;
            fn fields() -> Self::Fields {
                #fields_name { #(#field_inits,)* __marker: ::core::marker::PhantomData }
            }
        }
        #(#type_attrs)* impl #access_impl_generics ::gpui::reflection::HasMethods for #root #access_where {
            type Methods = #methods_name #ty_generics;
            fn methods() -> Self::Methods {
                #methods_name { #(#method_inits,)* __marker: ::core::marker::PhantomData }
            }
        }

        #(#method_impls)*

        #(#type_attrs)* impl #describe_impl_generics ::gpui::reflection::Describe for #root #describe_where {
            fn build_type() -> ::gpui::reflection::Type {
                let fields = <Self as ::gpui::reflection::HasFields>::fields();
                ::gpui::reflection::Type::new_with_roles::<Self>(
                    ::std::any::type_name::<Self>(),
                    vec![#(#schema_fields,)*],
                    #variant,
                    vec![#(#roles,)*],
                )
            }
            #type_shape_override
        }
    }])
}

fn has_inherent_method(type_name: &syn::Ident, items: &[Item], name: &str) -> bool {
    items.iter().any(|item| {
        let Item::Impl(implementation) = item else {
            return false;
        };
        implementation.trait_.is_none()
            && impl_targets(implementation, type_name)
            && implementation
                .items
                .iter()
                .any(|item| matches!(item, syn::ImplItem::Fn(method) if method.sig.ident == name))
    })
}

pub(super) fn reflect_enum(item: &ItemEnum, items: &[Item]) -> syn::Result<Vec<TokenStream2>> {
    let name = &item.ident;
    let fields_name = format_ident!("__{}VariantFields", name);
    let methods_name = format_ident!("__{}Methods", name);
    let generics = &item.generics;
    let (_, ty_generics, _) = generics.split_for_impl();
    let root: Type = parse_quote!(#name #ty_generics);
    let vis = &item.vis;
    let type_attrs = cfg_attrs(&item.attrs);
    let has_variant_fields_method = has_inherent_method(name, items, "variant_fields");
    let has_methods_method = has_inherent_method(name, items, "methods");

    let mut variant_structs = Vec::new();
    let mut variant_defs = Vec::new();
    let mut variant_inits = Vec::new();
    let mut schema_fields = Vec::new();
    let mut variant_arms = Vec::new();
    for variant in &item.variants {
        let variant_name = &variant.ident;
        let variant_field_name = format_ident!("__{}{}Fields", name, variant_name);
        let variant_accessor = schema::snake_case(&variant_name.to_string());
        let mut variant_attrs = type_attrs.clone();
        variant_attrs.extend(cfg_attrs(&variant.attrs));
        let mut defs = Vec::new();
        let mut inits = Vec::new();
        match &variant.fields {
            Fields::Named(fields) => {
                for field in &fields.named {
                    let field_name = field.ident.as_ref().unwrap();
                    let field_vis = vis;
                    let attrs = cfg_attrs(&field.attrs);
                    let ty = &field.ty;
                    let child_shape = schema::child_shape(ty, items);
                    let mut schema_attrs = variant_attrs.clone();
                    schema_attrs.extend(attrs.clone());
                    let bind = format_ident!("__value_{}", field_name);
                    let get = quote!(|value: &#root| match value {
                        Self::#variant_name { #field_name: #bind, .. } => Some(#bind),
                        _ => None,
                    });
                    let get_mut = quote!(|value: &mut #root| match value {
                        Self::#variant_name { #field_name: #bind, .. } => Some(#bind),
                        _ => None,
                    });
                    defs.push(quote!(#(#attrs)* #field_vis #field_name: ::gpui::reflection::VariantField<#root, #ty>));
                    inits.push(
                        quote!(#(#attrs)* #field_name: ::gpui::reflection::VariantField::new(
                            stringify!(#variant_name), stringify!(#field_name), #get, #get_mut,
                        )),
                    );
                    schema_fields.push(
                        quote!(#(#schema_attrs)* fields.#variant_accessor.#field_name.into_schema(#child_shape)),
                    );
                }
                variant_arms.push(quote!(#(#variant_attrs)* Self::#variant_name { .. } => stringify!(#variant_name)));
            }
            Fields::Unnamed(fields) => {
                let binds: Vec<_> = (0..fields.unnamed.len())
                    .map(|index| format_ident!("__field_{index}"))
                    .collect();
                for (index, field) in fields.unnamed.iter().enumerate() {
                    let field_name = format_ident!("field_{index}");
                    let field_vis = vis;
                    let attrs = cfg_attrs(&field.attrs);
                    let ty = &field.ty;
                    let child_shape = schema::child_shape(ty, items);
                    let mut schema_attrs = variant_attrs.clone();
                    schema_attrs.extend(attrs.clone());
                    let bind = &binds[index];
                    defs.push(quote!(#(#attrs)* #field_vis #field_name: ::gpui::reflection::VariantField<#root, #ty>));
                    inits.push(quote!(#(#attrs)* #field_name: ::gpui::reflection::VariantField::new(
                        stringify!(#variant_name), stringify!(#index),
                        |value: &#root| match value { Self::#variant_name(#(#binds),*) => Some(#bind), _ => None },
                        |value: &mut #root| match value { Self::#variant_name(#(#binds),*) => Some(#bind), _ => None },
                    )));
                    schema_fields.push(
                        quote!(#(#schema_attrs)* fields.#variant_accessor.#field_name.into_schema(#child_shape)),
                    );
                }
                variant_arms.push(quote!(#(#variant_attrs)* Self::#variant_name ( .. ) => stringify!(#variant_name)));
            }
            Fields::Unit => variant_arms
                .push(quote!(#(#variant_attrs)* Self::#variant_name => stringify!(#variant_name))),
        }
        variant_structs.push(
            quote!(#(#variant_attrs)* #vis struct #variant_field_name #generics {
                #(#defs,)*
                #[doc(hidden)] __marker: ::core::marker::PhantomData<fn() -> #root>,
            }),
        );
        variant_defs.push(
            quote!(#(#variant_attrs)* #vis #variant_accessor: #variant_field_name #ty_generics),
        );
        variant_inits.push(quote!(#(#variant_attrs)* #variant_accessor: #variant_field_name { #(#inits,)* __marker: ::core::marker::PhantomData }));
    }

    let methods = methods::method_accessors(name, &root, generics, &type_attrs, items)?;
    let method_defs = methods.iter().map(|method| &method.member);
    let method_inits = methods.iter().map(|method| &method.initializer);
    let method_impls = methods
        .iter()
        .flat_map(|method| [&method.declaration, &method.implementation]);
    let methods_decl = quote!(#vis struct #methods_name #generics {
        #(#method_defs,)*
        #[doc(hidden)] __marker: ::core::marker::PhantomData<fn() -> #root>,
    });
    let mut describe_generics = generics.clone();
    describe_generics
        .make_where_clause()
        .predicates
        .push(parse_quote!(Self: 'static));
    let (describe_impl_generics, _, describe_where) = describe_generics.split_for_impl();
    let (access_impl_generics, _, access_where) = generics.split_for_impl();
    let variant_fields_convenience = if has_variant_fields_method {
        TokenStream2::new()
    } else {
        quote!(#vis fn variant_fields() -> #fields_name #ty_generics {
            <Self as ::gpui::reflection::HasVariantFields>::variant_fields()
        })
    };
    let methods_convenience = if has_methods_method {
        TokenStream2::new()
    } else {
        quote!(#vis fn methods() -> #methods_name #ty_generics {
            <Self as ::gpui::reflection::HasMethods>::methods()
        })
    };
    let roles = roles::role_registrations(name, &root, items);
    let type_shape_override = schema::type_shape_override(generics, &root);

    Ok(vec![quote! {
        #(#variant_structs)*
        #(#type_attrs)* #vis struct #fields_name #generics {
            #(#variant_defs,)*
            #[doc(hidden)] __marker: ::core::marker::PhantomData<fn() -> #root>,
        }
        #(#type_attrs)* #methods_decl
        #(#type_attrs)* impl #access_impl_generics #root #access_where {
            #variant_fields_convenience
            #methods_convenience
        }
        #(#type_attrs)* impl #access_impl_generics ::gpui::reflection::HasVariantFields for #root #access_where {
            type VariantFields = #fields_name #ty_generics;
            fn variant_fields() -> Self::VariantFields {
                #fields_name { #(#variant_inits,)* __marker: ::core::marker::PhantomData }
            }
        }
        #(#type_attrs)* impl #access_impl_generics ::gpui::reflection::HasMethods for #root #access_where {
            type Methods = #methods_name #ty_generics;
            fn methods() -> Self::Methods {
                #methods_name { #(#method_inits,)* __marker: ::core::marker::PhantomData }
            }
        }
        #(#method_impls)*
        #(#type_attrs)* impl #describe_impl_generics ::gpui::reflection::Describe for #root #describe_where {
            fn build_type() -> ::gpui::reflection::Type {
                let fields = <Self as ::gpui::reflection::HasVariantFields>::variant_fields();
                ::gpui::reflection::Type::new_with_roles::<Self>(
                    ::std::any::type_name::<Self>(),
                    vec![#(#schema_fields,)*],
                    Some(|value: &dyn ::std::any::Any| value.downcast_ref::<Self>().map(|value| match value { #(#variant_arms),* })),
                    vec![#(#roles,)*],
                )
            }
            #type_shape_override
        }
    }])
}

struct FieldAccessor {
    definition: TokenStream2,
    initializer: TokenStream2,
    schema_conversion: TokenStream2,
}

fn struct_field_accessors(
    fields: &Fields,
    root: &Type,
    type_name: &syn::Ident,
    items: &[Item],
) -> Vec<FieldAccessor> {
    let mut output = Vec::new();
    let entries: Vec<(
        syn::Ident,
        syn::Visibility,
        Type,
        TokenStream2,
        Vec<syn::Attribute>,
    )> = match fields {
        Fields::Named(fields) => fields
            .named
            .iter()
            .map(|field| {
                (
                    field.ident.clone().unwrap(),
                    field.vis.clone(),
                    field.ty.clone(),
                    {
                        let ident = field.ident.as_ref().unwrap();
                        quote!(&value.#ident)
                    },
                    cfg_attrs(&field.attrs),
                )
            })
            .collect(),
        Fields::Unnamed(fields) => fields
            .unnamed
            .iter()
            .enumerate()
            .map(|(index, field)| {
                (
                    format_ident!("field_{index}"),
                    field.vis.clone(),
                    field.ty.clone(),
                    {
                        let index = syn::Index::from(index);
                        quote!(&value.#index)
                    },
                    cfg_attrs(&field.attrs),
                )
            })
            .collect(),
        Fields::Unit => vec![],
    };
    let _ = type_name;
    for (field_name, vis, ty, getter, attrs) in entries {
        let schema_attr = &attrs;
        let access = if let Some(index) = field_name
            .to_string()
            .strip_prefix("field_")
            .and_then(|index| index.parse::<usize>().ok())
        {
            let index = syn::Index::from(index);
            quote!(#index)
        } else {
            quote!(#field_name)
        };
        let get = quote!(|value: &#root| #getter);
        let get_mut = quote!(|value: &mut #root| &mut value.#access);
        let child = schema::child_shape(&ty, items);
        output.push(FieldAccessor {
            definition: quote!(#(#attrs)* #vis #field_name: ::gpui::reflection::Field<#root, #ty>),
            initializer: quote!(#(#attrs)* #field_name: ::gpui::reflection::Field::new(stringify!(#field_name), #get, #get_mut)),
            schema_conversion: if matches!(&vis, syn::Visibility::Public(_)) {
                quote!(#(#schema_attr)* fields.#field_name.into_schema(#child))
            } else {
                TokenStream2::new()
            },
        });
    }
    output
}
