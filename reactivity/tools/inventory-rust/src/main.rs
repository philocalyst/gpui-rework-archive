//! Read JSON lines containing path/text; emit test spans and module declarations.
//! Syn owns Rust lexing/parsing, including raw strings and nested block comments.
use proc_macro2::{Span, TokenStream, TokenTree};
use serde_json::{Value, json};
use std::io::{self, BufRead};
use syn::{Attribute, Meta, punctuated::Punctuated, spanned::Spanned, visit::Visit};

// Could this cfg be true when `test` is false? None means another cfg decides.
fn non_test_cfg(meta: &Meta) -> Option<bool> {
    match meta {
        Meta::Path(path) if path.is_ident("test") => Some(false),
        Meta::List(list) => {
            let args = list
                .parse_args_with(Punctuated::<Meta, syn::Token![,]>::parse_terminated)
                .ok()?;
            let values: Vec<_> = args.iter().map(non_test_cfg).collect();
            if list.path.is_ident("all") {
                if values.contains(&Some(false)) {
                    Some(false)
                } else if values.iter().all(|v| *v == Some(true)) {
                    Some(true)
                } else {
                    None
                }
            } else if list.path.is_ident("any") {
                if values.contains(&Some(true)) {
                    Some(true)
                } else if values.iter().all(|v| *v == Some(false)) {
                    Some(false)
                } else {
                    None
                }
            } else if list.path.is_ident("not") && values.len() == 1 {
                values[0].map(|v| !v)
            } else {
                None
            }
        }
        _ => None,
    }
}

fn test_attribute(meta: &Meta) -> bool {
    if meta
        .path()
        .segments
        .last()
        .is_some_and(|s| s.ident == "test")
    {
        return true;
    }
    if let Meta::List(list) = meta {
        if list.path.is_ident("cfg") {
            return list
                .parse_args::<Meta>()
                .ok()
                .is_some_and(|m| non_test_cfg(&m) == Some(false));
        }
    }
    false
}

fn sensitive_cfg_attr(meta: &Meta) -> bool {
    let Meta::List(list) = meta else {
        return false;
    };
    if !list.path.is_ident("cfg_attr") {
        return false;
    }
    list.parse_args_with(Punctuated::<Meta, syn::Token![,]>::parse_terminated)
        .is_ok_and(|args| {
            args.iter().skip(1).any(|m| {
                test_attribute(m)
                    || m.path().is_ident("cfg")
                    || m.path().is_ident("path")
                    || sensitive_cfg_attr(m)
            })
        })
}

fn conditional_paths(meta: &Meta, paths: &mut Vec<String>) {
    if let Meta::NameValue(value) = meta {
        if value.path.is_ident("path") {
            if let syn::Expr::Lit(expr) = &value.value {
                if let syn::Lit::Str(path) = &expr.lit {
                    paths.push(path.value());
                }
            }
        }
    } else if let Meta::List(list) = meta {
        if list.path.is_ident("cfg_attr") {
            if let Ok(args) =
                list.parse_args_with(Punctuated::<Meta, syn::Token![,]>::parse_terminated)
            {
                for arg in args.iter().skip(1) {
                    conditional_paths(arg, paths);
                }
            }
        }
    }
}

// Read Syn's existing fields instead of re-tokenizing each complete subtree.
trait Attributed: Spanned {
    fn attributes(&self) -> &[Attribute];
}

macro_rules! enum_attributes {
    ($name:ident: $($variant:ident),+ $(,)?) => {
        impl Attributed for syn::$name {
            fn attributes(&self) -> &[Attribute] {
                #[allow(unreachable_patterns)] // GenericParam/FnArg are exhaustive; the other enums are not.
                match self { $(Self::$variant(node) => &node.attrs,)+ _ => &[] }
            }
        }
    };
}
macro_rules! struct_attributes {
    ($($name:ident),+ $(,)?) => { $(impl Attributed for syn::$name {
        fn attributes(&self) -> &[Attribute] { &self.attrs }
    })+ };
}

// Syn is pinned; each list covers its attribute-bearing variants. Verbatim
// syntax has no parsed attributes and remains conservatively charged.
enum_attributes!(Item: Const, Enum, ExternCrate, Fn, ForeignMod, Impl, Macro, Mod,
    Static, Struct, Trait, TraitAlias, Type, Union, Use);
enum_attributes!(ImplItem: Const, Fn, Type, Macro);
enum_attributes!(TraitItem: Const, Fn, Type, Macro);
enum_attributes!(ForeignItem: Fn, Static, Type, Macro);
enum_attributes!(Expr: Array, Assign, Async, Await, Binary, Block, Break, Call,
    Cast, Closure, Const, Continue, Field, ForLoop, Group, If, Index, Infer, Let,
    Lit, Loop, Macro, Match, MethodCall, Paren, Path, Range, RawAddr, Reference,
    Repeat, Return, Struct, Try, TryBlock, Tuple, Unary, Unsafe, While, Yield);
enum_attributes!(Pat: Const, Ident, Lit, Macro, Or, Paren, Path, Range, Reference,
    Rest, Slice, Struct, Tuple, TupleStruct, Type, Wild);
enum_attributes!(GenericParam: Lifetime, Type, Const);
enum_attributes!(FnArg: Receiver, Typed);
struct_attributes!(ItemMod, Local, Field, Variant, Arm, StmtMacro);

#[derive(Default)]
struct Analysis {
    tests: Vec<[usize; 4]>,
    uncertain: Vec<Value>,
    modules: Vec<Value>,
    macro_modules: Vec<Value>,
    // Directory beneath the current source file's module directory.
    inline: Vec<String>,
    inherited_test: bool,
}

impl Analysis {
    fn range(span: Span) -> [usize; 4] {
        [
            span.start().line,
            span.start().column,
            span.end().line,
            span.end().column,
        ]
    }

    fn inspect(&mut self, attrs: &[Attribute], span: Span) -> bool {
        let test = attrs.iter().any(|a| test_attribute(&a.meta));
        if test {
            self.tests.push(Self::range(span));
        }
        for attr in attrs {
            if sensitive_cfg_attr(&attr.meta) {
                // cfg_attr may inject cfg/test/path, including nested cfg_attr.
                // Keep its code charged and expose the ambiguity for review.
                self.uncertain.push(json!({"lines": Self::range(span), "reason": "cfg_attr requires configuration-specific review"}));
            }
        }
        test
    }

    fn node(&mut self, node: &impl Attributed) -> bool {
        let attrs = node.attributes();
        // Spanned itself may tokenize a subtree. Only pay that cost when the
        // attributes can produce a test span or an uncertainty diagnostic.
        if attrs
            .iter()
            .any(|a| test_attribute(&a.meta) || sensitive_cfg_attr(&a.meta))
        {
            self.inspect(attrs, node.span())
        } else {
            false
        }
    }

    fn macro_tokens(&mut self, tokens: TokenStream) {
        let tokens: Vec<_> = tokens.into_iter().collect();
        for triple in tokens.windows(3) {
            if let [
                TokenTree::Ident(keyword),
                TokenTree::Ident(name),
                TokenTree::Punct(end),
            ] = triple
            {
                if keyword == "mod" && end.as_char() == ';' {
                    self.macro_modules
                        .push(json!({"name": name.to_string(), "inline": self.inline,
                        "test_only": self.inherited_test, "lines": Self::range(name.span())}));
                    self.uncertain
                        .push(json!({"lines": Self::range(name.span()),
                        "reason": "out-of-line module inside unexpanded macro tokens"}));
                }
            }
        }
        for pair in tokens.windows(2) {
            if matches!(&pair[0], TokenTree::Punct(p) if p.as_char() == '#') {
                if let TokenTree::Group(group) = &pair[1] {
                    if let Ok(meta) = syn::parse2::<Meta>(group.stream()) {
                        if test_attribute(&meta) || sensitive_cfg_attr(&meta) {
                            self.uncertain.push(json!({"lines": Self::range(group.span()), "reason": "test-related attribute inside unexpanded macro tokens"}));
                        }
                    }
                }
            }
        }
        for token in tokens {
            if let TokenTree::Group(group) = token {
                self.macro_tokens(group.stream());
            }
        }
    }
}

impl<'ast> Visit<'ast> for Analysis {
    fn visit_item(&mut self, node: &'ast syn::Item) {
        // Modules must still be visited to propagate their test status to files.
        if let syn::Item::Mod(module) = node {
            self.visit_item_mod(module);
        } else if !self.node(node) {
            syn::visit::visit_item(self, node);
        }
    }

    fn visit_item_mod(&mut self, node: &'ast syn::ItemMod) {
        let test = self.node(node) || self.inherited_test;
        let old_test = self.inherited_test;
        self.inherited_test = test;
        if let Some((_, items)) = &node.content {
            self.inline.push(node.ident.to_string());
            for item in items {
                self.visit_item(item);
            }
            self.inline.pop();
        } else {
            let path = node.attrs.iter().find_map(|a| {
                if !a.path().is_ident("path") {
                    return None;
                }
                if let Meta::NameValue(value) = &a.meta {
                    if let syn::Expr::Lit(expr) = &value.value {
                        if let syn::Lit::Str(path) = &expr.lit {
                            return Some(path.value());
                        }
                    }
                }
                None
            });
            let mut alternate_paths = Vec::new();
            for attr in &node.attrs {
                if attr.path().is_ident("cfg_attr") {
                    conditional_paths(&attr.meta, &mut alternate_paths);
                }
            }
            self.modules.push(
                json!({"name": node.ident.to_string(), "inline": self.inline,
                "path": path, "test_only": test, "lines": Self::range(node.span()),
                "alternate_paths": alternate_paths,
                "uncertain": node.attrs.iter().any(|a| sensitive_cfg_attr(&a.meta))}),
            );
        }
        self.inherited_test = old_test;
    }

    fn visit_impl_item(&mut self, n: &'ast syn::ImplItem) {
        if !self.node(n) {
            syn::visit::visit_impl_item(self, n);
        }
    }
    fn visit_trait_item(&mut self, n: &'ast syn::TraitItem) {
        if !self.node(n) {
            syn::visit::visit_trait_item(self, n);
        }
    }
    fn visit_foreign_item(&mut self, n: &'ast syn::ForeignItem) {
        if !self.node(n) {
            syn::visit::visit_foreign_item(self, n);
        }
    }
    fn visit_expr(&mut self, n: &'ast syn::Expr) {
        if !self.node(n) {
            syn::visit::visit_expr(self, n);
        }
    }
    fn visit_pat(&mut self, n: &'ast syn::Pat) {
        if !self.node(n) {
            syn::visit::visit_pat(self, n);
        }
    }
    fn visit_generic_param(&mut self, n: &'ast syn::GenericParam) {
        if !self.node(n) {
            syn::visit::visit_generic_param(self, n);
        }
    }
    fn visit_fn_arg(&mut self, n: &'ast syn::FnArg) {
        if !self.node(n) {
            syn::visit::visit_fn_arg(self, n);
        }
    }
    fn visit_local(&mut self, n: &'ast syn::Local) {
        if !self.node(n) {
            syn::visit::visit_local(self, n);
        }
    }
    fn visit_field(&mut self, n: &'ast syn::Field) {
        if !self.node(n) {
            syn::visit::visit_field(self, n);
        }
    }
    fn visit_variant(&mut self, n: &'ast syn::Variant) {
        if !self.node(n) {
            syn::visit::visit_variant(self, n);
        }
    }
    fn visit_arm(&mut self, n: &'ast syn::Arm) {
        if !self.node(n) {
            syn::visit::visit_arm(self, n);
        }
    }
    fn visit_stmt_macro(&mut self, n: &'ast syn::StmtMacro) {
        if !self.node(n) {
            syn::visit::visit_stmt_macro(self, n);
        }
    }
    fn visit_macro(&mut self, n: &'ast syn::Macro) {
        self.macro_tokens(n.tokens.clone());
    }
}

fn analyze(text: &str) -> Value {
    match syn::parse_file(text) {
        Ok(file) => {
            let mut analysis = Analysis::default();
            let whole_file = analysis.inspect(&file.attrs, file.span());
            analysis.inherited_test = whole_file;
            analysis.visit_file(&file);
            json!({"test_ranges": analysis.tests, "file_test_only": whole_file,
                "modules": analysis.modules, "macro_modules": analysis.macro_modules, "unclassified": analysis.uncertain})
        }
        Err(error) => json!({"test_ranges": [], "modules": [], "unclassified": [{
            "lines": Analysis::range(error.span()), "reason": format!("Rust parse error: {error}")}]}),
    }
}

fn main() {
    for line in io::stdin().lock().lines() {
        let input: Value =
            serde_json::from_str(&line.expect("read input")).expect("valid JSON input");
        let mut result = analyze(input["text"].as_str().expect("text"));
        result["path"] = input["path"].clone();
        println!("{result}");
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn syntax_and_attributes() {
        let text = "const RAW: &str = r###\" } #[test] fn fake() { \"###;\n/* nested /* } */ #[test] */\n#[cfg(\n all(test, feature = \"x\")\n)]\nmod tests { #[test] fn real() {} }\n#[cfg(any(test, feature = \"x\"))]\nfn shared() {}\n";
        let result = analyze(text);
        assert_eq!(result["test_ranges"][0], json!([3, 0, 6, 34]));
        assert_eq!(result["unclassified"], json!([]));
    }

    #[test]
    fn file_modules_and_uncertain_macro() {
        let result = analyze(
            "#[cfg(test)] #[path = \"elsewhere.rs\"] mod checks;\nmod inner { #[cfg(test)] mod tests; }\n#[cfg_attr(feature = \"x\", test)] fn maybe() {}\ncustom! { #[test] fn generated() {} }\n",
        );
        assert_eq!(result["modules"][0]["path"], "elsewhere.rs");
        assert_eq!(result["modules"][0]["test_only"], true);
        assert_eq!(result["modules"][1]["inline"], json!(["inner"]));
        assert_eq!(result["modules"][1]["test_only"], true);
        assert_eq!(result["unclassified"].as_array().unwrap().len(), 2);
    }

    #[test]
    fn attributes_are_read_from_different_ast_shapes() {
        let result = analyze(
            "struct Shape {\n#[cfg(test)] only_test: (),\nlive: (),\n}\nimpl Shape {\n#[test] fn check() {}\n}\nfn production() {\n#[cfg(test)] let helper = ();\n#[cfg(test)] { let expression = (); }\n}\n",
        );
        let ranges = result["test_ranges"].as_array().unwrap();
        let starts: Vec<_> = ranges
            .iter()
            .map(|range| range[0].as_u64().unwrap())
            .collect();
        assert_eq!(starts, [2, 6, 9, 10]);
        assert_eq!(result["unclassified"], json!([]));
    }
}
