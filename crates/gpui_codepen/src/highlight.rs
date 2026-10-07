use gpui::{Hsla, rgb, rgb_to_hsla};
use rustc_lexer::{FrontmatterAllowed, LiteralKind, TokenKind};
use std::ops::Range;

/// Rust's own lexer recognizes raw/byte/C strings, lifetimes, character
/// literals, and nested block comments. Highlighting never determines execution.
pub fn rust_highlights(source: &str) -> Vec<(Range<usize>, Hsla)> {
    let mut offset = 0;
    let mut spans = Vec::new();
    for token in rustc_lexer::tokenize(source, FrontmatterAllowed::No) {
        let end = offset + token.len as usize;
        let word = &source[offset..end];
        let color = match token.kind {
            TokenKind::LineComment { .. } | TokenKind::BlockComment { .. } => Some(0x748c82),
            TokenKind::Literal {
                kind: LiteralKind::Int { .. } | LiteralKind::Float { .. },
                ..
            } => Some(0xeac490),
            TokenKind::Literal { .. } => Some(0x9fd2a6),
            TokenKind::Ident | TokenKind::RawIdent | TokenKind::ForcedKeywordIdent => {
                if [
                    "as", "async", "await", "break", "const", "continue", "crate", "dyn", "else",
                    "enum", "extern", "false", "fn", "for", "if", "impl", "in", "let", "loop",
                    "match", "mod", "move", "mut", "pub", "ref", "return", "self", "Self",
                    "static", "struct", "super", "trait", "true", "type", "unsafe", "use", "where",
                    "while", "yield",
                ]
                .contains(&word)
                {
                    Some(0xc3afe4)
                } else if word.chars().next().is_some_and(char::is_uppercase) {
                    Some(0x93c9db)
                } else if source[end..].trim_start().starts_with(['(', '!']) {
                    Some(0xe4d7a4)
                } else {
                    None
                }
            }
            TokenKind::Lifetime { .. } | TokenKind::RawLifetime => Some(0x93c9db),
            _ => None,
        };
        if let Some(color) = color {
            spans.push((offset..end, rgb_to_hsla(rgb(color))));
        }
        offset = end;
    }
    spans
}
