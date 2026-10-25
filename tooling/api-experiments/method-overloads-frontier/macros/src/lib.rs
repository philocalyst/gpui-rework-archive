use proc_macro::TokenStream;
mod reflect_module;

#[proc_macro_attribute]
pub fn reflect(_: TokenStream, input: TokenStream) -> TokenStream {
    match reflect_module::reflect_module(input) { Ok(tokens) => tokens, Err(error) => error.into_compile_error().into() }
}
