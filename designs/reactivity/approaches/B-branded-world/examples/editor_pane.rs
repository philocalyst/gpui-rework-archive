//! Historical maximal-brand experiment; multi-callback protocols still need runtime state.
//! See `designs/reactivity/approaches/B-branded-world/README.md` for the correction.
//!
//! Approach B — complex example: split editor panes with session-typed drag & drop.
//!
//! Design sketch (target API). Demonstrates:
//!   - a real screen (tabbed split panes) built from free functions over one `'ui`
//!   - session-typed drag & drop: the tab-drag protocol is a linear state machine;
//!     dropping twice, finishing a cancelled drag, or leaking a drag across frames
//!     does not compile
//!   - keyed reactive collections of panes/tabs
//!   - the async sender bridge: a `'static` write handle for background work,
//!     the ONE deliberately runtime-checked boundary in this approach
//!   - paint capability tokens for a custom-painted drop indicator

use gpui::{
    div, rgb, text, Build, Dragging, DropTarget, El, Events, Hovering, PaintCx, Sig, SigVec, Ui,
};

// ---------------------------------------------------------------------------
// Domain model: plain structs, branded signal fields.
// ---------------------------------------------------------------------------

#[derive(Clone, PartialEq)]
struct Tab {
    id: u64,
    title: String,
    dirty: bool,
}

struct Pane<'ui> {
    tabs: SigVec<'ui, Tab>,        // keyed reactive vec: per-row subscriptions
    active: Sig<'ui, Option<u64>>, // active tab id
}

struct Workspace<'ui> {
    left: Pane<'ui>,
    right: Pane<'ui>,
    split: Sig<'ui, f32>, // 0.0..1.0 divider position
}

// ---------------------------------------------------------------------------
// The drag protocol as session types. Each state is a distinct linear type;
// every transition consumes `self`. The only way to obtain `TabDrag` is from
// the framework inside a mouse-down handler, and every path must end in
// `.drop_into()` or `.cancel()` — both consuming. There is no clone, no copy,
// and no way to store it past the interaction (it borrows `'ui` *and* is
// re-granted each event by the dispatcher).
//
//   mouse-down:  events.begin_drag(payload)      -> TabDrag<Started>
//   mouse-move:  drag.over(&target)              -> TabDrag<Over>   (or stays Started)
//   mouse-up:    drag.drop_into(&target, events) -> ()   consumed
//   escape:      drag.cancel(events)             -> ()   consumed
// ---------------------------------------------------------------------------

fn tab_strip<'ui>(
    ui: &mut Build<'ui>,
    pane: &Pane<'ui>,
    other_pane_target: DropTarget<'ui, Tab>,
) -> El<'ui> {
    let active = pane.active;
    let tabs = pane.tabs;

    div(ui)
        .flex()
        .gap_px()
        .children_keyed(ui, tabs, |t| t.id, move |ui, tab| {
            let id = tab.id;
            div(ui)
                .px_3()
                .py_1()
                .bg(active.map(move |a| {
                    if a == Some(id) { rgb(0x1e1e2e) } else { rgb(0x11111b) }
                }))
                .child(text(ui, tab.title.clone()))
                .child_if(ui, tab.dirty, |ui| text(ui, "●"))
                .on_click(move |_, ev: &mut Events<'ui>| active.set(ev, Some(id)))
                // Session start: the framework hands us a linear Started-state
                // value. The closure signature *requires* us to return a
                // continuation — we cannot simply drop the protocol on the floor.
                .on_drag(tabs.item(id), move |drag: gpui::TabDrag<'ui, gpui::Started, Tab>| {
                    drag // handed back to the dispatcher; advanced on next event
                })
        })
        // Drop side: registering as a target mints a DropTarget<'ui, Tab> that
        // hover/drop transitions are typed against.
        .drop_target(other_pane_target, move |dropped: Tab, ev: &mut Events<'ui>| {
            tabs.push(ev, dropped);
        })
        .build(ui)
}

// The dispatcher-side protocol (framework-internal, shown for the design):
//
//   fn on_mouse_move<'ui>(drag: TabDrag<'ui, Started, T>, hit: Option<&DropTarget<'ui, T>>)
//       -> EitherDrag<'ui, T> {
//       match hit {
//           Some(t) => EitherDrag::Over(drag.over(t)),   // Started consumed → Over
//           None => EitherDrag::Started(drag),
//       }
//   }
//
//   fn on_mouse_up<'ui>(drag: TabDrag<'ui, Over, T>, ev: &mut Events<'ui>) {
//       drag.drop_into(ev); // Over consumed. Calling drop_into on Started: no such
//   }                       // method. Calling it twice: use of moved value.

// ---------------------------------------------------------------------------
// Custom paint with a capability token: the drop indicator draws a quad
// directly. `PaintCx<'ui>` cannot be constructed, stored, or smuggled out of
// the paint pass — release builds get the same guarantee as debug builds.
// ---------------------------------------------------------------------------

fn drop_indicator<'ui>(ui: &mut Build<'ui>, visible: Sig<'ui, bool>) -> El<'ui> {
    gpui::canvas(ui, move |bounds, paint: &mut PaintCx<'ui>| {
        // reading `visible` here: `paint.frame()` exposes &Frame<'ui> — reads OK,
        // writes impossible (no Events token exists during paint).
        if visible.get(paint.frame()) {
            paint.quad(bounds.inset(2.0), rgb(0x3b82f6), /*corner*/ 3.0);
        }
    })
}

// ---------------------------------------------------------------------------
// Async bridge: the one runtime-checked boundary. `Sig<'ui,T>` is !'static by
// design (a task may outlive the UI), so background work gets a sender.
// ---------------------------------------------------------------------------

fn watch_file_saves<'ui>(ui: &mut Build<'ui>, tabs: SigVec<'ui, Tab>) {
    let tx = tabs.sender(); // 'static + Send; enqueues through the FrameWaker
    ui.spawn(async move {
        while let Some(saved_id) = fake_save_events().await {
            // Err(UiGone) after teardown — the residue is one Result, here,
            // not a panic anywhere a handle might dangle.
            if tx.update(move |ts| {
                if let Some(t) = ts.iter_mut().find(|t| t.id == saved_id) {
                    t.dirty = false;
                }
            }).is_err() {
                break;
            }
        }
    });
}

// ---------------------------------------------------------------------------
// Assembly.
// ---------------------------------------------------------------------------

fn workspace<'ui>(ui: &mut Build<'ui>, ws: &Workspace<'ui>) -> El<'ui> {
    let split = ws.split;
    let (left_target, right_target) = ui.drop_targets::<Tab>();

    watch_file_saves(ui, ws.left.tabs);
    watch_file_saves(ui, ws.right.tabs);

    div(ui)
        .flex()
        .size_full()
        .child(
            div(ui)
                .w(split.map(|s| gpui::relative(s))) // divider drag = 1 layout node dirty
                .child(tab_strip(ui, &ws.left, right_target))
                .child(drop_indicator(ui, ui.hovering(left_target))),
        )
        .child(divider(ui, split))
        .child(
            div(ui)
                .flex_1()
                .child(tab_strip(ui, &ws.right, left_target))
                .child(drop_indicator(ui, ui.hovering(right_target))),
        )
        .build(ui)
}

fn divider<'ui>(ui: &mut Build<'ui>, split: Sig<'ui, f32>) -> El<'ui> {
    div(ui)
        .w_1()
        .cursor_col_resize()
        .on_drag_move(move |delta_frac: f32, ev: &mut Events<'ui>| {
            split.update(ev, |s| *s = (*s + delta_frac).clamp(0.1, 0.9));
        })
        .build(ui)
}

fn main() {
    gpui::run(|ui: &mut Ui<'_>| {
        let ws = Workspace {
            left: Pane { tabs: ui.sig_vec([]), active: ui.sig(None) },
            right: Pane { tabs: ui.sig_vec([]), active: ui.sig(None) },
            split: ui.sig(0.5),
        };
        ui.window(Default::default(), move |ui| workspace(ui, &ws));
    });
}

async fn fake_save_events() -> Option<u64> { None }
