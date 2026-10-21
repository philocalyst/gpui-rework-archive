use gpui::{Affine, Color, El, Error, Point, PresentationToken, View, Win, WindowOptions, div};

struct Rectangle {
    bright: bool,
    broken: bool,
    clicks: u32,
}
impl Rectangle {
    fn click(&mut self) {
        self.clicks += 1;
        self.bright = !self.bright;
    }
}
impl View for Rectangle {
    fn view(&self) -> El<'_> {
        div()
            .size(64)
            .bg(if self.bright {
                Color::WHITE
            } else {
                Color::BLACK
            })
            .transform(if self.broken {
                Affine::scale(0.0, 1.0)
            } else {
                Affine::IDENTITY
            })
            .on_click(Self::click)
    }
}
fn recording() -> Win<Rectangle> {
    Win::recording(
        Rectangle {
            bright: false,
            broken: false,
            clicks: 0,
        },
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap()
}
fn token(win: &Win<Rectangle>) -> PresentationToken {
    win.with_scene(|_, token| token).unwrap()
}
fn target(win: &Win<Rectangle>) -> gpui::Target {
    win.snapshot().unwrap().nodes[0].target.unwrap()
}

#[test]
fn initial_recording_has_no_input_authority_until_actual_acknowledgement() {
    let mut win = recording();
    let before = win.snapshot().unwrap();
    assert_eq!(before.source_epoch, 0);
    assert_eq!(before.presentation_epoch, 0);
    assert!(!before.presentation_valid);
    assert_eq!(before.prepared_epoch, Some(0));
    assert_eq!(before.size, [0, 0]);
    assert!(before.nodes.is_empty());
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(
        win.click_at(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    // Borrowing/rasterizing diagnostically is not a native presentation receipt.
    win.with_pixels(|pixels, w, h| assert_eq!(pixels.len(), w as usize * h as usize * 4))
        .unwrap();
    assert!(!win.snapshot().unwrap().presentation_valid);
    let first = win
        .with_scene(|scene, token| {
            assert_eq!((scene.width, scene.height), (64, 64));
            assert_eq!(scene.draws().count(), 1);
            token
        })
        .unwrap();
    let commit = win.presented(first).unwrap();
    assert!(commit.presentation_valid);
    assert_eq!(commit.prepared_epoch, None);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }).unwrap(),
        Some(target(&win))
    );
    assert_eq!(win.counters().presentations, 1);
    // Surface exposure may redraw this same scene and acknowledge idempotently.
    assert_eq!(token(&win), first);
    assert_eq!(win.presented(first).unwrap(), commit);
    assert_eq!(win.counters().presentations, 1);
}

#[test]
fn unseen_visual_candidates_block_coordinate_routing_even_after_noop_edits() {
    let mut win = recording();
    let initial = token(&win);
    win.presented(initial).unwrap();
    let addressed = target(&win);
    let pending = win.activate(addressed).unwrap();
    assert_eq!((pending.source_epoch, pending.presentation_epoch), (1, 0));
    let candidate = token(&win);
    assert_ne!(candidate, initial);
    let noop = win.update(|_| {}).unwrap();
    assert_eq!((noop.source_epoch, noop.presentation_epoch), (2, 0));
    assert_eq!(noop.prepared_epoch, Some(2));
    assert_eq!(token(&win), candidate);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.presented(initial), Err(Error::StalePresentation));
    assert_eq!(win.presented(candidate).unwrap().presentation_epoch, 2);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }).unwrap(),
        Some(addressed)
    );
    // Once no visual candidate is outstanding, an equal edit may advance P.
    let noop = win.update(|_| {}).unwrap();
    assert_eq!((noop.source_epoch, noop.presentation_epoch), (3, 3));
    assert_eq!(noop.prepared_epoch, None);
}

#[test]
fn pending_coherent_sheet_survives_newer_preparation_failure_and_can_be_acknowledged() {
    let mut win = recording();
    win.presented(token(&win)).unwrap();
    let addressed = target(&win);
    win.update(|m| m.bright = true).unwrap();
    let coherent = token(&win);
    assert!(matches!(
        win.update(|m| m.broken = true),
        Err(Error::Canvas(_))
    ));
    let snapshot = win.snapshot().unwrap();
    assert_eq!((snapshot.source_epoch, snapshot.presentation_epoch), (2, 0));
    assert_eq!(snapshot.prepared_epoch, Some(1));
    assert_eq!(token(&win), coherent);
    let commit = win.presented(coherent).unwrap();
    assert_eq!((commit.source_epoch, commit.presentation_epoch), (2, 1));
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.presented(coherent).unwrap(), commit);
    win.update(|m| m.broken = false).unwrap();
    let recovered = token(&win);
    assert_ne!(coherent, recovered);
    assert_eq!(win.presented(coherent), Err(Error::StalePresentation));
    assert_eq!(win.presented(recovered).unwrap().presentation_epoch, 3);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }).unwrap(),
        Some(addressed)
    );
}

#[test]
fn tokens_reject_foreign_namespaces_and_replaced_candidates() {
    let mut a = recording();
    let mut b = recording();
    let original = token(&a);
    let foreign = token(&b);
    assert_ne!(original, foreign);
    assert_eq!(a.presented(foreign), Err(Error::StalePresentation));
    assert!(!a.snapshot().unwrap().presentation_valid);
    a.update(|m| m.bright = true).unwrap();
    assert_eq!(a.presented(original), Err(Error::StalePresentation));
    a.presented(token(&a)).unwrap();
    b.presented(foreign).unwrap();
    assert_ne!(target(&a), target(&b));
}

#[test]
fn resize_keeps_targets_and_source_epoch_but_requires_new_geometry_ack() {
    let mut win = recording();
    let first = token(&win);
    win.presented(first).unwrap();
    let addressed = target(&win);
    win.reset_counters().unwrap();
    let changed = win.resize([32, 24]).unwrap();
    assert_eq!((changed.source_epoch, changed.presentation_epoch), (0, 0));
    assert_eq!(changed.prepared_epoch, Some(0));
    assert_eq!(win.snapshot().unwrap().size, [64, 64]);
    assert_eq!(win.snapshot().unwrap().requested_size, [32, 24]);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.presented(first), Err(Error::StalePresentation));
    let resized = win
        .with_scene(|scene, token| {
            assert_eq!((scene.width, scene.height), (32, 24));
            token
        })
        .unwrap();
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().layout_runs, 1);
    let counts = win.counters();
    assert_eq!(win.resize([32, 24]).unwrap(), changed);
    assert_eq!(win.counters(), counts);
    assert_eq!(
        win.resize([0, 24]),
        Err(Error::Canvas(gpui_canvas::Error::InvalidDimensions))
    );
    assert_eq!(token(&win), resized);
    win.presented(resized).unwrap();
    assert_eq!(win.snapshot().unwrap().size, [32, 24]);
    assert_eq!(target(&win), addressed);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }).unwrap(),
        Some(addressed)
    );
    assert_eq!(win.hit_target(Point { x: 40.0, y: 8.0 }).unwrap(), None);
}

#[test]
fn headless_keeps_automatic_presentation_and_resize_behavior() {
    let mut win = Win::with_size(
        Rectangle {
            bright: false,
            broken: false,
            clicks: 0,
        },
        64,
        64,
    )
    .unwrap();
    assert!(win.snapshot().unwrap().presentation_valid);
    let addressed = target(&win);
    let commit = win.resize([40, 30]).unwrap();
    assert!(commit.presentation_valid);
    assert_eq!(commit.prepared_epoch, None);
    assert_eq!(win.snapshot().unwrap().size, [40, 30]);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }).unwrap(),
        Some(addressed)
    );
    win.with_pixels(|bytes, w, h| assert_eq!(bytes.len(), w as usize * h as usize * 4))
        .unwrap();
}

#[test]
fn surface_loss_revokes_coordinates_until_current_scene_is_presented_again() {
    let mut win = recording();
    let current = token(&win);
    win.presented(current).unwrap();
    let addressed = target(&win);
    let before = win.counters();
    win.presentation_lost().unwrap();
    assert!(!win.snapshot().unwrap().presentation_valid);
    assert_eq!(win.snapshot().unwrap().prepared_epoch, Some(0));
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(
        win.click_at(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(token(&win), current);
    assert_eq!(win.counters(), before);
    let noop = win.update(|_| {}).unwrap();
    assert_eq!((noop.source_epoch, noop.presentation_epoch), (1, 0));
    assert_eq!(noop.prepared_epoch, Some(1));
    let after = win.presented(current).unwrap();
    assert_eq!((after.source_epoch, after.presentation_epoch), (1, 1));
    assert!(after.presentation_valid);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }).unwrap(),
        Some(addressed)
    );
    assert_eq!(win.counters().paint_passes, before.paint_passes);
    assert_eq!(win.counters().layout_runs, before.layout_runs);
    assert_eq!(win.counters().presentations, before.presentations + 1);
}

#[test]
fn reacknowledgement_after_surface_loss_cannot_cover_a_failed_new_source() {
    let mut win = recording();
    let current = token(&win);
    win.presented(current).unwrap();
    win.presentation_lost().unwrap();
    assert!(win.update(|m| m.broken = true).is_err());
    let commit = win.presented(current).unwrap();
    assert_eq!((commit.source_epoch, commit.presentation_epoch), (1, 0));
    assert!(commit.presentation_valid);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
}

#[test]
fn software_surface_rendering_returns_the_exact_unacknowledged_scene_token() {
    let mut win = recording();
    let mut words = vec![0xffffffff; 64 * 64];
    let initial = win.render_bgrx(&mut words).unwrap();
    assert_eq!(initial, token(&win));
    assert!(words.iter().all(|word| *word == 0));
    assert!(!win.snapshot().unwrap().presentation_valid);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    let mut wrong_length = [0x12345678];
    assert_eq!(
        win.render_bgrx(&mut wrong_length),
        Err(Error::Canvas(gpui_canvas::Error::InvalidDimensions))
    );
    assert_eq!(wrong_length, [0x12345678]);
    win.presented(initial).unwrap();
    win.update(|model| model.bright = true).unwrap();
    let pending = win.render_bgrx(&mut words).unwrap();
    assert_eq!(pending, token(&win));
    assert_ne!(pending, initial);
    assert!(words.iter().all(|word| *word == 0x00ffffff));
    assert_eq!(win.snapshot().unwrap().presentation_epoch, 0);
    assert_eq!(
        win.hit_target(Point { x: 8.0, y: 8.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.presented(pending).unwrap().presentation_epoch, 1);
}
