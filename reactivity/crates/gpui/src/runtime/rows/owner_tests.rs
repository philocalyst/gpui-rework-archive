//! Whole-window ownership costs; ignored so the measured process runs one case.
use super::*;
use crate::prelude::*;
struct Page {
    count: usize,
    text: bool,
    general: bool,
    x: f32,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        if self.count == 1 {
            return div()
                .size(10)
                .bg(Color::BLACK)
                .transform(Affine::translation(self.x, 0.));
        }
        column((0..self.count).map(|index| {
            let el = if self.text {
                text("immutable text payload").w(240).h(20)
            } else {
                div().w(10).h(1).bg(Color::BLACK)
            };
            let map = Affine {
                a: 1.,
                b: if self.general { 0.1 } else { 0. },
                c: if self.general { 0.2 } else { 0. },
                d: 1.,
                tx: if index == self.count / 2 { self.x } else { 0. },
                ty: 0.,
            };
            if self.general {
                el.rounded(4.).transform(map)
            } else {
                el.transform(map)
            }
        }))
    }
}
fn report(stage: &str, win: &Win<Page>, cost: allocation_counter::AllocationInfo) {
    let r = win.runtime().unwrap();
    let (mode, count, capacity) = match r.prepared.as_ref().map(|p| &p.nodes) {
        None => ("none", 0, 0),
        Some(CandidateRows::Full(rows)) => {
            ("full", rows.len(), rows.capacity() * size_of::<Presented>())
        }
        Some(CandidateRows::Changes(rows)) => {
            ("changes", rows.len(), rows.capacity() * size_of::<Change>())
        }
    };
    let text = r.text.as_ref();
    let geometry = r.metadata.as_ref().and_then(|m| m.geometry.as_ref());
    let pgeo = geometry.map_or((0, 0), |g| g.record_storage());
    let cgeo = geometry
        .and_then(|g| g.candidate_storage())
        .unwrap_or_default();
    let leases: usize = r
        .presented
        .iter()
        .filter_map(|row| row.text.as_ref())
        .filter_map(SharedText::lease_count)
        .sum();
    println!(
        "ROW_OWNER stage={stage} logical={} l_node_bytes={} p_rows={} p_bytes={} c_mode={mode} c_owned_rows={count} c_bytes={capacity} shared_text_p_lease_sum={leases} l_text_slots_bytes={} p_text_entries={} p_text_bytes={} c_text_entries={} c_text_bytes={} p_geometry_records={} p_geometry_bytes={} c_geometry_records={} c_geometry_bytes={} images={} allocations={} requested={} retained_delta={} peak_extra={}",
        r.nodes.len(),
        r.nodes.capacity() * size_of::<Node>(),
        r.presented.len(),
        r.presented.capacity() * size_of::<Presented>(),
        r.texts.capacity() * size_of::<Option<TextSite>>(),
        text.map_or(0, |t| t.presented.len()),
        text.map_or(0, |t| t.presented.capacity()
            * size_of::<text_geometry::Entry>()),
        text.and_then(|t| t.candidate.as_ref()).map_or(0, Vec::len),
        text.and_then(|t| t.candidate.as_ref())
            .map_or(0, |c| c.capacity() * size_of::<text_geometry::Entry>()),
        pgeo.0,
        pgeo.1 * size_of::<geometry::Record>(),
        cgeo.0,
        cgeo.1 * size_of::<geometry::Record>(),
        usize::from(r.images.is_some()),
        cost.count_total,
        cost.bytes_total,
        cost.bytes_current,
        cost.bytes_max
    );
}
#[test]
#[ignore = "owner allocation control: one explicitly selected fresh-process case"]
fn whole_window_candidate_owner_costs() {
    let name = std::env::var("GPUI_ROW_OWNER_CASE").unwrap_or_else(|_| "workspace32".into());
    let (count, text) = match name.as_str() {
        "tiny1" => (1, false),
        "workspace32" => (32, false),
        "sparse16k" => (16384, false),
        "text32k" => (32768, true),
        "transformed32" | "inspector32" => (32, false),
        _ => panic!("unknown case"),
    };
    let mut win = None;
    let mount = allocation_counter::measure(|| {
        let page = Page {
            count,
            text,
            general: name == "transformed32" || name == "inspector32",
            x: 0.,
        };
        let options = WindowOptions {
            size: [400, 400],
            ..Default::default()
        };
        win = Some(
            if name == "inspector32" {
                Win::recording_with_inspector(page, options)
            } else {
                Win::recording(page, options)
            }
            .unwrap(),
        );
    });
    let mut win = win.unwrap();
    report("mount-C0", &win, mount);
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let p = win.runtime().unwrap().presented.as_ptr();
    let first = allocation_counter::measure(|| {
        win.update(|m| m.x = 0.125).unwrap();
    });
    report("C1", &win, first);
    let second = allocation_counter::measure(|| {
        win.update(|m| m.x = 0.25).unwrap();
    });
    report("C2", &win, second);
    let ack = allocation_counter::measure(|| {
        win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    });
    report("ACK", &win, ack);
    if count > 1 {
        assert_eq!(p, win.runtime().unwrap().presented.as_ptr());
    }
    assert_eq!(
        win.snapshot().unwrap().source_epoch,
        win.snapshot().unwrap().presentation_epoch
    );
}
