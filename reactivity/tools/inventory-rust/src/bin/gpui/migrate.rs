//! Local source edits under the pinned GPUI API contract, not Rust name resolution.
use proc_macro2::{LineColumn, Span};
use std::ops::Range;
use syn::{
    Expr, Item, Path, UseTree,
    spanned::Spanned,
    visit::{self, Visit},
};

pub struct Edit {
    pub bytes: Range<usize>,
    pub replacement: String,
}
pub struct Diagnostic {
    pub at: LineColumn,
    pub message: String,
}
pub struct Plan {
    pub edits: Vec<Edit>,
    pub diagnostics: Vec<Diagnostic>,
}

struct Source<'a> {
    text: &'a str,
    lines: Vec<usize>,
}
impl<'a> Source<'a> {
    fn new(text: &'a str) -> Self {
        Self {
            text,
            lines: std::iter::once(0)
                .chain(text.match_indices('\n').map(|(i, _)| i + 1))
                .collect(),
        }
    }
    fn byte(&self, at: LineColumn) -> Option<usize> {
        let start = *self.lines.get(at.line.checked_sub(1)?)?;
        let line = &self.text[start..self.lines.get(at.line).copied().unwrap_or(self.text.len())];
        // proc_macro2 columns count Unicode characters, not UTF-8 bytes.
        let offset = line
            .char_indices()
            .map(|(i, _)| i)
            .chain(std::iter::once(line.len()))
            .nth(at.column)?;
        Some(start + offset)
    }
    fn range(&self, span: Span) -> Option<Range<usize>> {
        Some(self.byte(span.start())?..self.byte(span.end())?)
    }
}

#[derive(Default)]
struct Names {
    div: bool,
    px: bool,
    styled: bool,
    shadow_div: bool,
    shadow_px: bool,
    shadow_gpui: bool,
    glob: bool,
    macros: bool,
    scope_ambiguous: bool,
    blocks: usize,
    diagnostics: Vec<Diagnostic>,
}
impl Names {
    fn note(&mut self, span: Span, message: &str) {
        self.diagnostics.push(Diagnostic {
            at: span.start(),
            message: message.into(),
        });
    }
    fn binding(&mut self, name: &syn::Ident) {
        match name.to_string().as_str() {
            "div" => self.shadow_div = true,
            "px" => self.shadow_px = true,
            "gpui" => self.shadow_gpui = true,
            _ => return,
        }
        self.note(
            name.span(),
            "name binding requires manual resolution; unqualified edits are disabled",
        );
    }
    fn imports(&mut self, tree: &UseTree, prefix: &mut Vec<String>) {
        match tree {
            UseTree::Path(p) => {
                prefix.push(p.ident.to_string());
                self.imports(&p.tree, prefix);
                prefix.pop();
            }
            UseTree::Group(g) => {
                for item in &g.items {
                    self.imports(item, prefix);
                }
            }
            UseTree::Glob(g) => {
                self.glob = true;
                self.note(g.span(), "glob import prevents unqualified name proof");
            }
            UseTree::Rename(r) => {
                self.binding(&r.rename);
                if r.ident == "gpui" || prefix.first().is_some_and(|p| p == "gpui") {
                    self.shadow_gpui = true;
                    self.note(r.span(), "GPUI import aliases require manual migration");
                }
            }
            UseTree::Name(n) => {
                let canonical = prefix.as_slice() == ["gpui"];
                match n.ident.to_string().as_str() {
                    "div" if canonical => self.div = true,
                    "px" if canonical => {
                        self.px = true;
                        self.note(
                            n.span(),
                            "legacy px import retained; remove after reviewing all remaining uses",
                        );
                    }
                    "Styled" if canonical => {
                        self.styled = true;
                        self.note(
                            n.span(),
                            "legacy Styled import retained; target builders are inherent methods",
                        );
                    }
                    "div" | "px" | "gpui" => self.binding(&n.ident),
                    _ => {}
                }
            }
        }
    }
    fn resolves(&self, path: &Path, name: &str) -> bool {
        if self.macros
            || self.glob
            || self.scope_ambiguous
            || self.shadow_gpui
            || path.segments.iter().any(|s| !s.arguments.is_empty())
        {
            return false;
        }
        let parts: Vec<_> = path.segments.iter().map(|s| s.ident.to_string()).collect();
        if parts == ["gpui", name] {
            return true;
        }
        parts == [name]
            && path.leading_colon.is_none()
            && !self.glob
            && match name {
                "div" => self.div && !self.shadow_div,
                "px" => self.px && !self.shadow_px,
                _ => false,
            }
    }
}
impl<'ast> Visit<'ast> for Names {
    fn visit_item(&mut self, item: &'ast Item) {
        match item {
            Item::Use(u) => {
                if self.blocks != 0 {
                    self.scope_ambiguous = true;
                    self.note(
                        u.span(),
                        "nested imports require scope resolution; file edits disabled",
                    );
                }
                self.imports(&u.tree, &mut Vec::new());
            }
            Item::Fn(i) => self.binding(&i.sig.ident),
            Item::Mod(i) => {
                self.binding(&i.ident);
                if i.content.is_some() {
                    self.scope_ambiguous = true;
                    self.note(i.span(), "inline module scopes require separate name resolution; file edits disabled");
                }
            }
            Item::Const(i) => self.binding(&i.ident),
            Item::Static(i) => self.binding(&i.ident),
            Item::Struct(i) => self.binding(&i.ident),
            Item::Enum(i) => self.binding(&i.ident),
            Item::Union(i) => self.binding(&i.ident),
            Item::Type(i) => self.binding(&i.ident),
            Item::Trait(i) => self.binding(&i.ident),
            Item::ExternCrate(i) if i.rename.is_some() || i.ident != "gpui" => {
                self.shadow_gpui = true;
                self.note(
                    i.span(),
                    "extern-crate aliases prevent crate identity proof",
                );
            }
            _ => {}
        }
        visit::visit_item(self, item);
    }
    fn visit_block(&mut self, block: &'ast syn::Block) {
        self.blocks += 1;
        visit::visit_block(self, block);
        self.blocks -= 1;
    }
    fn visit_foreign_item_fn(&mut self, item: &'ast syn::ForeignItemFn) {
        self.binding(&item.sig.ident);
        visit::visit_foreign_item_fn(self, item);
    }
    fn visit_foreign_item_static(&mut self, item: &'ast syn::ForeignItemStatic) {
        self.binding(&item.ident);
        visit::visit_foreign_item_static(self, item);
    }
    fn visit_pat_ident(&mut self, ident: &'ast syn::PatIdent) {
        self.binding(&ident.ident);
        visit::visit_pat_ident(self, ident);
    }
    fn visit_type_param(&mut self, param: &'ast syn::TypeParam) {
        self.binding(&param.ident);
        visit::visit_type_param(self, param);
    }
    fn visit_const_param(&mut self, param: &'ast syn::ConstParam) {
        self.binding(&param.ident);
        visit::visit_const_param(self, param);
    }
    fn visit_macro(&mut self, mac: &'ast syn::Macro) {
        self.macros = true;
        self.note(
            mac.span(),
            "macro expansion is opaque and can introduce bindings; file edits disabled",
        );
    }
    fn visit_attribute(&mut self, attr: &'ast syn::Attribute) {
        self.macros = true;
        self.note(
            attr.span(),
            "attributes may expand or configure names; file edits disabled",
        );
    }
    fn visit_path(&mut self, path: &'ast Path) {
        if let Some(last) = path.segments.last()
            && matches!(
                last.ident.to_string().as_str(),
                "Entity"
                    | "Context"
                    | "ViewContext"
                    | "App"
                    | "Window"
                    | "Render"
                    | "RenderOnce"
                    | "IntoElement"
                    | "AnyElement"
                    | "TextInput"
                    | "TextInputState"
                    | "InputState"
                    | "FocusHandle"
            )
        {
            self.note(
                path.span(),
                "ownership/render/input scaffolding needs an application-owned migration",
            );
        }
        visit::visit_path(self, path);
    }
    fn visit_expr_method_call(&mut self, call: &'ast syn::ExprMethodCall) {
        if matches!(
            call.method.to_string().as_str(),
            "notify"
                | "listener"
                | "new_view"
                | "new_entity"
                | "update"
                | "read"
                | "subscribe"
                | "observe"
        ) {
            self.note(
                call.method.span(),
                "state/context callback requires a manual owner/source decision",
            );
        }
        visit::visit_expr_method_call(self, call);
    }
}

struct Rewriter<'a> {
    source: Source<'a>,
    names: Names,
    edits: Vec<Edit>,
}
impl Rewriter<'_> {
    fn literal(&self, expression: &Expr) -> Option<String> {
        let Expr::Call(call) = expression else {
            return None;
        };
        let Expr::Path(path) = call.func.as_ref() else {
            return None;
        };
        if path.qself.is_some() || !self.names.resolves(&path.path, "px") || call.args.len() != 1 {
            return None;
        }
        let (literal, negative) = match call.args.first()? {
            Expr::Lit(syn::ExprLit {
                lit: syn::Lit::Float(f),
                ..
            }) => (f, false),
            Expr::Unary(u) if matches!(u.op, syn::UnOp::Neg(_)) => match u.expr.as_ref() {
                Expr::Lit(syn::ExprLit {
                    lit: syn::Lit::Float(f),
                    ..
                }) => (f, true),
                _ => return None,
            },
            _ => return None,
        };
        if !matches!(literal.suffix(), "" | "f32") {
            return None;
        }
        let value = literal.base10_parse::<f32>().ok()?;
        if !value.is_finite() || (negative && value != 0.) {
            return None;
        }
        let wrapper = &self.source.text[self.source.range(expression.span())?];
        if wrapper.contains("/*") || wrapper.contains("//") {
            return None;
        }
        let mut body = self.source.text[self.source.range(literal.span())?].to_owned();
        if literal.suffix() == "f32" {
            body.truncate(body.len() - 3);
        }
        if body.ends_with('.') {
            body.push('0');
        }
        if !body.ends_with('_') {
            body.push('_');
        }
        Some(format!("{}{body}f32", if negative { "-" } else { "" }))
    }
    fn chain(&mut self, outer: &syn::ExprMethodCall) {
        let mut methods = vec![outer];
        let mut receiver = outer.receiver.as_ref();
        while let Expr::MethodCall(call) = receiver {
            methods.push(call);
            receiver = &call.receiver;
        }
        let constructor = match receiver {
            Expr::Call(call) => match call.func.as_ref() {
                Expr::Path(path) if path.path.segments.last().is_some_and(|s| s.ident == "div") => {
                    Some((call, path))
                }
                _ => None,
            },
            _ => None,
        };
        let Some((constructor, path)) = constructor else {
            let pixels = methods.iter().flat_map(|m| &m.args).any(|arg| match arg {
                Expr::Call(call) => matches!(call.func.as_ref(), Expr::Path(p) if p.path.segments.last().is_some_and(|s| s.ident == "px")),
                _ => false,
            });
            if pixels {
                self.names.note(
                    outer.method.span(),
                    "unknown receiver chain for pixel sizing; no edit",
                );
            }
            return;
        };
        let valid = path.qself.is_none()
            && constructor.args.is_empty()
            && self.names.styled
            && self.names.resolves(&path.path, "div");
        if !valid {
            self.names.note(
                constructor.span(),
                "div constructor name is unresolved or ambiguous; no edit",
            );
            return;
        }
        let mut pending = Vec::new();
        for method in methods.iter().rev() {
            let name = method.method.to_string();
            if method.turbofish.is_some() {
                self.names.note(
                    method.span(),
                    "generic receiver chain needs manual migration",
                );
                return;
            }
            if name == "flex" && method.args.is_empty() {
                continue;
            }
            if !matches!(name.as_str(), "w" | "h" | "size" | "p" | "gap") || method.args.len() != 1
            {
                self.names.note(method.method.span(), "unsupported receiver chain; no part of this chain is rewritten (layout defaults need review)");
                return;
            }
            let arg = method.args.first().unwrap();
            let Some(replacement) = self.literal(arg) else {
                self.names.note(arg.span(), "requires direct resolved px(finite f32 literal), with no wrapper comments; no chain edit");
                return;
            };
            let Some(bytes) = self.source.range(arg.span()) else {
                self.names
                    .note(arg.span(), "source span is not a UTF-8 boundary; no edit");
                return;
            };
            pending.push(Edit { bytes, replacement });
        }
        // This whitelist has no child-producing calls. A bare constructor is
        // therefore only a leaf spacer; explicit flex() preserves row direction.
        self.edits.extend(pending);
    }
}
impl<'ast> Visit<'ast> for Rewriter<'_> {
    fn visit_expr_method_call(&mut self, call: &'ast syn::ExprMethodCall) {
        // Never descend an unknown receiver and accidentally rewrite its prefix.
        self.chain(call);
    }
}

pub fn plan(text: &str) -> Result<Plan, String> {
    let file = syn::parse_file(text).map_err(|e| {
        format!(
            "{}:{}: parse error: {e}",
            e.span().start().line,
            e.span().start().column + 1
        )
    })?;
    let mut names = Names::default();
    names.visit_file(&file);
    let mut rewriter = Rewriter {
        source: Source::new(text),
        names,
        edits: Vec::new(),
    };
    rewriter.visit_file(&file);
    rewriter.edits.sort_by_key(|edit| edit.bytes.start);
    if rewriter
        .edits
        .windows(2)
        .any(|p| p[0].bytes.end > p[1].bytes.start)
    {
        return Err("overlapping edits; file rejected".into());
    }
    Ok(Plan {
        edits: rewriter.edits,
        diagnostics: rewriter.names.diagnostics,
    })
}
pub fn apply(text: &str, edits: &[Edit]) -> String {
    let mut output = text.to_owned();
    for edit in edits.iter().rev() {
        output.replace_range(edit.bytes.clone(), &edit.replacement);
    }
    output
}
