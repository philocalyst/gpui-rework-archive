use gpui::{Scene, SceneCapture, px, size};
use gpui_ce_codepen::{
    guest::{Frame, PROTOCOL_VERSION, wire},
    session::{Backend, FailureKind, Reply, Session},
};
fn frame() -> Frame {
    let mut scene = Scene::default();
    let bounds = gpui::Bounds::new(
        gpui::point(gpui::ScaledPixels(2.5), gpui::ScaledPixels(3.25)),
        size(gpui::ScaledPixels(70.), gpui::ScaledPixels(30.)),
    );
    scene.insert_primitive(gpui::Quad {
        bounds,
        content_mask: gpui::ContentMask {
            bounds,
            ..Default::default()
        },
        background: gpui::rgb(0x408020).into(),
        ..Default::default()
    });
    scene.finish();
    Frame {
        cursor: Default::default(),
        text: None,
        next_frame_ms: None,
        version: PROTOCOL_VERSION,
        viewport: size(px(320.), px(240.)),
        scale_factor: 1.,
        scene: SceneCapture::capture(&scene, |_| unreachable!()).unwrap(),
    }
}
fn reply(generation: u64, frame: Option<Frame>, diagnostics: &str) -> Reply {
    Reply {
        failure: None,
        generation,
        frame,
        diagnostics: diagnostics.into(),
        elapsed_ms: 3,
    }
}
#[test]
fn stale_replies_and_errors_preserve_last_good_scene() {
    let mut session = Session::default();
    let first = session.request("first".into(), Backend::Miri, None);
    assert!(session.accept(reply(first.generation, Some(frame()), "")));
    let current = session.frame.clone().unwrap();
    let next = session.request("second".into(), Backend::Miri, None);
    assert!(!session.accept(reply(first.generation, Some(frame()), "stale")));
    assert!(std::sync::Arc::ptr_eq(
        &current,
        session.frame.as_ref().unwrap()
    ));
    assert!(session.accept(reply(next.generation, None, "compile error")));
    assert_eq!(session.diagnostics, "compile error");
    assert_eq!(session.failure, Some(FailureKind::Rust));
    assert!(!session.running);
    assert!(std::sync::Arc::ptr_eq(
        &current,
        session.frame.as_ref().unwrap()
    ));
}
#[test]
fn runtime_availability_is_distinct_from_source_errors_and_recovers() {
    let mut session = Session::default();
    let first = session.request("valid source".into(), Backend::Miri, None);
    session.accept(reply(first.generation, Some(frame()), ""));
    let previous = session.frame.clone().unwrap();
    let next = session.request("valid source".into(), Backend::Miri, None);
    let mut unavailable = reply(next.generation, None, "Compiler assets are missing");
    unavailable.failure = Some(FailureKind::Unavailable);
    assert!(session.accept(unavailable));
    assert_eq!(session.failure, Some(FailureKind::Unavailable));
    assert!(std::sync::Arc::ptr_eq(&previous, session.frame.as_ref().unwrap()));
    let recovered = session.request("valid source".into(), Backend::Miri, None);
    session.accept(reply(recovered.generation, Some(frame()), ""));
    assert_eq!(session.failure, None);
    assert!(session.diagnostics.is_empty());
}
#[test]
fn binary_scenes_reject_wrong_version_and_trailing_bytes() {
    let frame = frame();
    let bytes = wire::encode(&frame);
    assert_eq!(wire::decode(&bytes).unwrap(), frame);
    for length in 0..bytes.len() {
        assert!(wire::decode(&bytes[..length]).is_err());
    }
    let mut trailing = bytes;
    trailing.push(0);
    assert!(wire::decode(&trailing).is_err());
    let mut invalid = frame;
    invalid.version = 0;
    assert!(wire::decode(&wire::encode(&invalid)).is_err());
    invalid.version = PROTOCOL_VERSION;
    invalid.scale_factor = f32::NAN;
    assert!(invalid.validate().is_err());
}
#[test]
fn reset_discards_the_scene_and_preserves_session_identity() {
    let mut session = Session::default();
    let request = session.request("source".into(), Backend::Miri, None);
    session.accept(reply(request.generation, Some(frame()), ""));
    session.reset();
    assert!(session.frame.is_none());
    assert_eq!(session.id, request.session_id);
}

#[test]
fn reset_rejects_an_outstanding_reply() {
    let mut session = Session::default();
    let request = session.request("source".into(), Backend::Miri, None);
    assert!(session.running);
    session.reset();
    assert!(!session.running);
    assert!(!session.accept(reply(request.generation, Some(frame()), "")));
    assert!(session.frame.is_none());
    assert_eq!(session.elapsed_ms, 0);
}
