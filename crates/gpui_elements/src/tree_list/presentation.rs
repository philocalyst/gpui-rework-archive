//! Paint-only exit presentation. Canonical model, selection, and hit testing
//! are updated immediately; a short-lived scene snapshot supplies outgoing pixels.

use super::*;

#[derive(Clone)]
pub(super) struct StoredPaint {
    pub snapshot: Rc<gpui::PaintSnapshot>,
    pub bounds: gpui::Bounds<Pixels>,
    pub generation: u64,
}

#[derive(Clone)]
pub(super) struct ExitPaint {
    pub paint: StoredPaint,
    pub started_at: Duration,
}

pub(super) fn capture_exits<Id: Clone + Eq + Hash + Debug + 'static>(
    state: &mut TreeViewState<Id>,
    now: Instant,
    reduced_motion: bool,
) {
    if reduced_motion {
        state.exit_rows.clear();
        state
            .paint_cache
            .retain(|id, _| state.tree.visible_index(id).is_some());
        return;
    }
    let started_at = state.motion_time(now);
    let outgoing: Vec<_> = state
        .paint_cache
        .keys()
        .filter(|id| state.tree.visible_index(id).is_none())
        .cloned()
        .collect();
    for id in outgoing {
        if let Some(paint) = state.paint_cache.remove(&id) {
            if state.exit_rows.len() < super::super::animation::MAX_MOTION_ROWS {
                state.exit_rows.insert(id, ExitPaint { paint, started_at });
            }
        }
    }
    state
        .exit_rows
        .retain(|id, _| state.tree.visible_index(id).is_none());
}

pub(super) fn exit_overlay<Id: Clone + Eq + Hash + Debug + 'static>(
    state: gpui::WeakEntity<TreeViewState<Id>>,
) -> AnyElement {
    div()
        .absolute()
        .inset_0()
        .child(
            gpui::canvas(
                |_, _, _| (),
                move |_, _, window, cx| {
                    let now = cx.background_executor().now();
                    let exits = state
                        .update(cx, |state, _| {
                            let generation = state.paint_generation;
                            state
                                .paint_cache
                                .retain(|_, paint| paint.generation == generation);
                            let time = state.motion_time(now);
                            let viewport = state.list.viewport_bounds();
                            (
                                time,
                                viewport,
                                state
                                    .exit_rows
                                    .iter()
                                    .map(|(id, exit)| (id.clone(), exit.clone()))
                                    .collect::<Vec<_>>(),
                            )
                        })
                        .ok();
                    let Some((time, viewport, exits)) = exits else {
                        return;
                    };
                    if exits.is_empty() {
                        return;
                    }
                    window.with_content_mask(
                        Some(gpui::ContentMask { bounds: viewport }),
                        |window| {
                            for (id, exit) in exits {
                                let elapsed = time.saturating_sub(exit.started_at);
                                let progress = (elapsed.as_secs_f32()
                                    / super::super::animation::DEFAULT_TREE_MOTION_DURATION
                                        .as_secs_f32())
                                .clamp(0., 1.);
                                let eased = progress * progress * (3. - 2. * progress);
                                let opacity = 1. - eased;
                                if opacity > 0.001 {
                                    let mut origin = exit.paint.bounds.origin;
                                    origin.y -= exit.paint.bounds.size.height * eased * 0.2;
                                    if !window.replay_paint_snapshot(
                                        &exit.paint.snapshot,
                                        origin,
                                        opacity,
                                    ) {
                                        let _ = state.update(cx, |state, _| {
                                            state.exit_rows.remove(&id);
                                        });
                                    }
                                }
                            }
                        },
                    );
                    window.request_animation_frame();
                },
            )
            .size_full(),
        )
        .into_any_element()
}

/// Global cache budget includes active outgoing rows. Unusually complex
/// delegates continue rendering live but skip exit capture beyond this budget.
const MAX_PAINT_BYTES: usize = 8 * 1024 * 1024;

pub(super) fn store_paint<Id: Clone + Eq + Hash + Debug + 'static>(
    state: &mut TreeViewState<Id>,
    id: Id,
    snapshot: Option<gpui::PaintSnapshot>,
    bounds: gpui::Bounds<Pixels>,
) {
    state.paint_cache.remove(&id);
    if state.reduced_motion {
        return;
    }
    let Some(snapshot) = snapshot else {
        return;
    };
    let size = snapshot.estimated_byte_size();
    let retained = state
        .paint_cache
        .values()
        .map(|paint| paint.snapshot.estimated_byte_size())
        .chain(
            state
                .exit_rows
                .values()
                .map(|exit| exit.paint.snapshot.estimated_byte_size()),
        )
        .fold(0usize, usize::saturating_add);
    if retained.saturating_add(size) > MAX_PAINT_BYTES
        || state.paint_cache.len() >= super::super::animation::MAX_MOTION_ROWS
    {
        return;
    }
    state.paint_cache.insert(
        id,
        StoredPaint {
            snapshot: Rc::new(snapshot),
            bounds,
            generation: state.paint_generation,
        },
    );
}
