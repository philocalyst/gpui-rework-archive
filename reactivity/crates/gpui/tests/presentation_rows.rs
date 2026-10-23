//! Candidate row ownership is exercised through ordinary public window APIs.
use gpui::{Error, Role, WindowOptions, prelude::*};

struct Page {
    checked: [bool; 32],
    broken: bool,
    shear: f32,
}
impl Default for Page {
    fn default() -> Self {
        Self {
            checked: [false; 32],
            broken: false,
            shear: 0.1,
        }
    }
}
impl View for Page {
    fn view(&self) -> El<'_> {
        column((0..32).map(|index| {
            checkbox(format!("item {index}"), self.checked[index])
                .w(180)
                .h(24)
                .rounded(4.)
                .transform(Affine {
                    a: if self.broken && index == 31 { 0. } else { 1. },
                    b: if self.broken && index == 31 {
                        0.
                    } else {
                        self.shear
                    },
                    c: 0.2,
                    d: 1.,
                    tx: 0.,
                    ty: 0.,
                })
                .on_click(move |m: &mut Self| m.checked[index] = !m.checked[index])
        }))
    }
}
fn token<M: View + 'static>(win: &Win<M>) -> gpui::PresentationToken {
    win.with_scene(|_, token| token).unwrap()
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    win.presented(token(win)).unwrap();
}
fn page() -> Win<Page> {
    let mut win = Win::recording(
        Page::default(),
        WindowOptions {
            size: [400, 900],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
fn displayed<M: View + 'static>(win: &Win<M>, name: &str) -> Option<Target> {
    let mut target = None;
    win.visit(|part| {
        if part.name() == Some(name) {
            target = Some(part.target())
        }
    })
    .unwrap();
    target
}
fn checked(win: &Win<Page>, index: usize) -> bool {
    let name = format!("item {index}");
    let mut result = None;
    win.visit(|part| {
        if part.name() == Some(name.as_str()) {
            result = part.checked()
        }
    })
    .unwrap();
    result.unwrap()
}
#[test]
fn coalesced_candidates_keep_p_immutable_and_ack_latest_changes_in_place() {
    let mut win = page();
    let target = win.query().name("item 7").one().unwrap();
    let bounds = win.bounds(target).unwrap();
    win.activate(target).unwrap();
    let first = token(&win);
    assert!(!checked(&win, 7));
    win.update(|m| m.checked[11] = true).unwrap();
    let second = token(&win);
    assert_ne!(first, second);
    assert_eq!(win.presented(first), Err(Error::StalePresentation));
    assert!(!checked(&win, 7));
    assert!(!checked(&win, 11));
    win.presented(second).unwrap();
    assert!(checked(&win, 7));
    assert!(checked(&win, 11));
    assert_eq!(win.query().name("item 7").one().unwrap(), target);
    assert_eq!(win.bounds(target).unwrap(), bounds);
}
#[test]
fn failed_later_preparation_preserves_the_old_exact_candidate_then_repairs() {
    let mut win = page();
    win.update(|m| m.checked[7] = true).unwrap();
    let coherent = token(&win);
    assert!(
        win.update(|m| {
            m.checked[9] = true;
            m.broken = true
        })
        .is_err()
    );
    assert_eq!(token(&win), coherent);
    assert!(!checked(&win, 7));
    assert!(!checked(&win, 9));
    let commit = win.presented(coherent).unwrap();
    assert!(commit.source_epoch > commit.presentation_epoch);
    assert!(checked(&win, 7));
    assert!(!checked(&win, 9));
    win.update(|m| m.broken = false).unwrap();
    ack(&mut win);
    assert!(checked(&win, 7));
    assert!(checked(&win, 9));
}
#[test]
fn independent_geometry_pools_and_viewport_changes_resolve_their_own_rows() {
    let mut win = page();
    let target = win.query().name("item 7").one().unwrap();
    let old = win.bounds(target).unwrap();
    win.update(|m| m.shear = 0.3).unwrap();
    let changed = token(&win);
    assert_eq!(win.bounds(target).unwrap(), old);
    win.presented(changed).unwrap();
    assert_ne!(win.bounds(target).unwrap(), old);
    let unit = win.bounds(target).unwrap();
    win.resize_scaled([800, 1800], 2.).unwrap();
    assert_eq!(win.bounds(target).unwrap(), unit);
    ack(&mut win);
    let scaled = win.bounds(target).unwrap();
    assert_eq!(scaled.x, unit.x * 2.);
    assert_eq!(scaled.y, unit.y * 2.);
    assert_eq!(win.query().name("item 7").one().unwrap(), target);
}

struct List {
    reverse: bool,
}
const LIST: ListId = ListId::new(57);
impl ItemSource for List {
    fn len(&self) -> usize {
        100
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(if self.reverse { 99 - index } else { index } as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let index = usize::try_from(key.get()).ok()?;
        (index < 100).then(|| if self.reverse { 99 - index } else { index })
    }
    fn row(&self, index: usize) -> El<'_> {
        button(format!("row {}", self.key(index).get()))
            .w(160)
            .h(24)
            .on_click(|_: &mut Self| {})
    }
}
impl View for List {
    fn view(&self) -> El<'_> {
        uniform_list(LIST, self, 24).w(160).h(72)
    }
}
#[test]
fn keyed_reorder_and_compacted_virtual_rows_use_full_topology_recovery() {
    let mut win = Win::recording(
        List { reverse: false },
        WindowOptions {
            size: [200, 100],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let list = win.list(LIST).unwrap();
    let old = win.query().name("row 0").one().unwrap();
    win.scroll_to_index(list, 1).unwrap();
    assert_eq!(displayed(&win, "row 0"), Some(old));
    ack(&mut win);
    assert_eq!(win.query().name("row 0").count().unwrap(), 0);
    assert_eq!(win.activate(old), Err(Error::StaleTarget));
    let surviving = win.query().name("row 2").one().unwrap();
    win.update(|m| m.reverse = true).unwrap();
    assert_eq!(displayed(&win, "row 2"), Some(surviving));
    ack(&mut win);
    assert_eq!(win.role(Role::Button).count().unwrap(), 3);
    assert_eq!(win.list_state(list).unwrap().visible_range, 97..100);
    assert_eq!(win.query().name("row 2").one().unwrap(), surviving);
    assert_eq!(win.activate(old), Err(Error::StaleTarget));
}
