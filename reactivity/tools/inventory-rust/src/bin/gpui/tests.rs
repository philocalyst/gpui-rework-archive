use super::*;

fn rewrite(body: &str) -> (String, migrate::Plan) {
    let input = format!("use gpui::{{div, px, Styled}};\nfn example() {{ let _ = {body}; }}\n");
    let plan = migrate::plan(&input).unwrap();
    (migrate::apply(&input, &plan.edits), plan)
}

#[test]
fn closed_sizing_chain_preserves_explicit_f32_rounding() {
    let (output, plan) = rewrite(
        "div().flex().w(px(16777217.0)).h(px(24.)).size(px(80.0_f32)).gap(px(3e-2)).p(px(-0.0))",
    );
    assert_eq!(plan.edits.len(), 5);
    assert!(
        output.contains(".w(16777217.0_f32).h(24.0_f32).size(80.0_f32).gap(3e-2_f32).p(-0.0_f32)")
    );
    syn::parse_file(&output).unwrap();
    // Decimal -> f64 -> f32 can double-round differently from old px(f32).
    let halfway = "1.0000000596046448";
    assert_ne!(
        halfway.parse::<f32>().unwrap().to_bits(),
        (halfway.parse::<f64>().unwrap() as f32).to_bits()
    );
    let (output, _) = rewrite(&format!("div().w(px({halfway}))"));
    assert!(output.contains("1.0000000596046448_f32"));
}

#[test]
fn spans_convert_unicode_columns_and_preserve_crlf_comments_and_other_bytes() {
    let source = "use gpui::{div,px,Styled};\r\nfn f(){ let café = \"💜\"; /* keep */ let _ = div().w(px(12.3)); }\r\n";
    let plan = migrate::plan(source).unwrap();
    assert_eq!(plan.edits.len(), 1);
    assert_eq!(
        migrate::apply(source, &plan.edits),
        source.replace("px(12.3)", "12.3_f32")
    );
    let (output, plan) = rewrite("div().p(px(1.0)).w(px(/* keep this */ 2.0))");
    assert!(plan.edits.is_empty());
    assert!(output.contains("/* keep this */"));
}

#[test]
fn unknown_or_invalid_chains_are_never_partially_rewritten() {
    for body in [
        "div().w(px(2.0)).child(\"x\")",
        "div().w(px(2.0)).custom()",
        "div().apply(|d| d.w(px(2.0)))",
        "some_receiver.w(px(2.0))",
        "div().w(px(-1.0))",
        "div().w(px(1e100))",
        "div().w(px(2))",
        "div().w(px(2.0f64))",
        "div().w(px(value))",
        "div().font_size(px(12.0))",
        "div().rounded(px(4.0))",
        "div().w::<f32>(px(2.0))",
    ] {
        assert!(rewrite(body).1.edits.is_empty(), "{body}");
    }
}

#[test]
fn ambiguous_imports_macros_and_shadowed_names_are_declined() {
    for source in [
        "use gpui::*; fn f(){ div().w(px(2.0)); }",
        "use gpui::Styled; use other::*; fn f(){gpui::div().w(gpui::px(2.0));}",
        "use gpui::{div as d,px,Styled}; fn f(){ d().w(px(2.0)); }",
        "use gpui::{div,px,Styled}; fn f(px: fn(f32)->f32){ div().w(px(2.0)); }",
        "use gpui::{div,px,Styled}; fn div(){} fn f(){div().w(px(2.0));}",
        "use gpui::{div,px,Styled}; fn f(){introduce_binding!();div().w(px(2.0));}",
        "use gpui::Styled; extern crate other as gpui; fn f(){gpui::div().w(gpui::px(2.0));}",
        "use gpui::Styled; fn f<gpui>(){gpui::div().w(gpui::px(2.0));}",
        "use gpui::{div,px}; fn f(){div().w(px(2.0));}",
        "mod nested {use gpui::{div,px,Styled};} fn f(){div().w(px(2.0));}",
        "fn nested(){use gpui::{div,px,Styled};} fn f(){div().w(px(2.0));}",
        "use gpui::{div,px,Styled}; unsafe extern \"C\" {fn px(v:f32)->f32;} fn f(){div().w(px(2.0));}",
    ] {
        assert!(migrate::plan(source).unwrap().edits.is_empty(), "{source}");
    }
    let source = "use gpui::Styled; fn div(){} fn px(){} fn f(){::gpui::div().w(::gpui::px(2.0));}";
    assert_eq!(
        migrate::plan(source).unwrap().edits.len(),
        1,
        "qualified paths bypass local helper shadowing"
    );
}

#[test]
fn realistic_pinned_sources_remain_manual_and_the_real_leaf_excerpt_is_rewritten() {
    let hummingbird = include_str!("../../../fixtures/migrate/hummingbird-window-header.rs.txt");
    let gpui = include_str!("../../../fixtures/migrate/gpui-counter.rs.txt");
    for source in [hummingbird, gpui] {
        let plan = migrate::plan(source).unwrap();
        assert!(plan.edits.is_empty());
        assert!(
            plan.diagnostics
                .iter()
                .any(|d| d.message.contains("scaffolding"))
        );
    }
    // Exact upstream expression; the enclosing test function/imports are a
    // declared parser context, not a fabricated successful application port.
    let excerpt = "div().w(px(72.0))";
    assert!(hummingbird.contains(excerpt));
    assert_eq!(rewrite(excerpt).1.edits.len(), 1);
}

#[test]
fn strings_are_not_code_and_parse_errors_do_not_create_plans() {
    let source = "fn f(){let s=r###\"div().w(px(12.0))\"###;}";
    assert!(migrate::plan(source).unwrap().edits.is_empty());
    assert!(migrate::plan("fn broken( {").is_err());
}

#[test]
fn temporary_collision_never_deletes_a_preexisting_file() {
    let directory = env::temp_dir().join(format!("gpui-migrate-collision-{}", std::process::id()));
    fs::create_dir_all(&directory).unwrap();
    let source = directory.join("input.rs");
    fs::write(&source, "original").unwrap();
    let temporary = directory.join(format!(".gpui-migrate-{}-input.rs", std::process::id()));
    fs::write(&temporary, "owned by someone else").unwrap();
    assert!(write_file(&source, "original", "replacement").is_err());
    assert_eq!(
        fs::read_to_string(&temporary).unwrap(),
        "owned by someone else"
    );
    assert_eq!(fs::read_to_string(&source).unwrap(), "original");
    fs::remove_dir_all(directory).unwrap();
}
