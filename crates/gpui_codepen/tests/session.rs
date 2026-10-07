use gpui_ce_codepen::{
    guest::{Frame, Node, PROTOCOL_VERSION, div, json},
    highlight::rust_highlights,
    session::{Backend, Reply, Session},
};
fn frame(text: &str) -> Frame {
    Frame {
        version: PROTOCOL_VERSION,
        root: div().child(text).into(),
        state: json!({"count": 4}),
    }
}
fn reply(generation: u64, frame: Option<Frame>, diagnostics: &str) -> Reply {
    Reply {
        generation,
        frame,
        diagnostics: diagnostics.into(),
        elapsed_ms: 1,
    }
}

#[test]
fn stale_compilation_cannot_commit_a_tree_or_state() {
    let mut s = Session::default();
    let old = s.request("old".into(), Backend::Miri, None);
    let new = s.request("new".into(), Backend::Miri, None);
    assert!(!s.accept(reply(old.generation, Some(frame("stale")), "")));
    assert!(s.running);
    assert!(s.frame.is_none());
    assert!(s.accept(reply(new.generation, Some(frame("current")), "")));
    assert!(!s.running);
    assert_eq!(s.frame, Some(frame("current").into()));
}
#[test]
fn failed_edits_preserve_last_successful_preview_and_state() {
    let mut s = Session::default();
    let good = s.request("good".into(), Backend::Miri, None);
    s.accept(reply(good.generation, Some(frame("last valid")), ""));
    let bad = s.request("bad".into(), Backend::Miri, Some("increment".into()));
    assert_eq!(bad.input.state["count"], 4);
    assert_eq!(bad.input.event.as_deref(), Some("increment"));
    s.accept(reply(bad.generation, None, "error[E0308]"));
    assert_eq!(s.frame, Some(frame("last valid").into()));
    assert_eq!(s.diagnostics, "error[E0308]");
}
#[test]
fn malformed_guest_frame_cannot_reach_the_renderer() {
    let mut s = Session::default();
    let req = s.request("source".into(), Backend::Miri, None);
    let mut bad = frame("bad");
    bad.version = 999;
    assert!(s.accept(reply(req.generation, Some(bad), "")));
    assert!(s.frame.is_none());
    assert!(s.diagnostics.contains("protocol"));
    let duplicate = Frame {
        version: 1,
        state: json!(null),
        root: div().children([div().id("same"), div().id("same")]).into(),
    };
    assert!(duplicate.validate().unwrap_err().contains("duplicate"));
    let bad_style = Frame {
        version: 1,
        state: json!(null),
        root: div().w(f32::INFINITY).into(),
    };
    assert!(bad_style.validate().is_err());
    let mut node: Node = div().into();
    for _ in 0..55 {
        node = div().child(node).into();
    }
    assert!(
        Frame {
            version: 1,
            root: node,
            state: json!(null)
        }
        .validate()
        .is_err()
    );
}
#[test]
fn highlighting_keeps_unicode_ranges_valid_and_ignores_quotes_in_comments() {
    let text = "// \"日本語\"\nfn render() { let title = \"🌿 café\"; }";
    let spans = rust_highlights(text);
    assert_eq!(&text[spans[0].0.clone()], "// \"日本語\"");
    assert!(
        spans
            .iter()
            .any(|(range, _)| &text[range.clone()] == "\"🌿 café\"")
    );
    for (range, _) in spans {
        assert!(text.is_char_boundary(range.start));
        assert!(text.is_char_boundary(range.end));
    }
}

#[test]
fn highlighting_handles_raw_strings_nested_comments_chars_and_lifetimes() {
    let text = "fn x<'a>() { /* outer /* nested */ end */ let s = r##\"// 🌱\"##; let c = '語'; }";
    let spans = rust_highlights(text);
    let words: Vec<_> = spans
        .iter()
        .map(|(range, _)| &text[range.clone()])
        .collect();
    for expected in [
        "'a",
        "/* outer /* nested */ end */",
        "r##\"// 🌱\"##",
        "'語'",
    ] {
        assert!(words.contains(&expected), "missing {expected:?}: {words:?}");
    }
    assert!(spans.windows(2).all(|w| w[0].0.end <= w[1].0.start));
}

#[test]
fn styles_preserve_last_setter_wins_in_both_chain_orders() {
    fn style(div: gpui_ce_codepen::guest::Div) -> gpui_ce_codepen::guest::Style {
        let Node::Div { style, .. } = Node::from(div) else {
            unreachable!()
        };
        style
    }
    let full = style(
        div()
            .w(200.)
            .w_full()
            .h(100.)
            .h_full()
            .justify_center()
            .justify_between(),
    );
    assert!(full.full_width && full.full_height && full.justify_between);
    assert!(full.width.is_none() && full.height.is_none() && !full.justify_center);
    let fixed = style(
        div()
            .w_full()
            .w(200.)
            .h_full()
            .h(100.)
            .justify_between()
            .justify_center(),
    );
    assert_eq!(fixed.width, Some(200.));
    assert_eq!(fixed.height, Some(100.));
    assert!(
        !fixed.full_width && !fixed.full_height && !fixed.justify_between && fixed.justify_center
    );
}

#[test]
fn compact_transport_preserves_tree_styles_and_unicode_and_rejects_truncation() {
    let frame = Frame {
        version: 1,
        state: json!({"text": "🌿日本語", "count": 8}),
        root: div()
            .id("card")
            .flex()
            .flex_col()
            .w(240.)
            .p_4()
            .gap_3()
            .rounded_lg()
            .bg(0x123456ff)
            .text_color(0xfedcbaff)
            .opacity(0.8)
            .hover(|s| s.bg(0x333333ff).border(2.))
            .on_click("increment")
            .children([Node::from("🌿 café"), div().h(20.).font_bold().into()])
            .into(),
    };
    let bytes = gpui_ce_codepen::guest::wire::encode(&frame);
    assert_eq!(gpui_ce_codepen::guest::wire::decode(&bytes).unwrap(), frame);
    for len in 0..bytes.len() {
        assert!(gpui_ce_codepen::guest::wire::decode(&bytes[..len]).is_err());
    }
    let mut trailing = bytes;
    trailing.push(0);
    assert!(gpui_ce_codepen::guest::wire::decode(&trailing).is_err());
}

#[test]
fn oversized_state_stops_during_encoding() {
    let frame = Frame {
        version: 1,
        state: json!({"text": "x".repeat(65_536)}),
        root: div().into(),
    };
    assert!(std::panic::catch_unwind(|| gpui_ce_codepen::guest::wire::encode(&frame)).is_err());
}
