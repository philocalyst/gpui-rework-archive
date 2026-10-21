//! Same public owner fixture on baseline/candidate; no private shaping calls.
use gpui::{WindowOptions, prelude::*};
use std::{hint::black_box, time::Instant};
struct Page {
    labels: Vec<String>,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        column(self.labels.iter().map(|label| text(label).w(600).h(24)))
            .w(600)
            .bg(Color::WHITE)
    }
}
fn report(
    count: usize,
    stage: &str,
    ns: u128,
    allocation: allocation_counter::AllocationInfo,
    nodes: usize,
    draws: usize,
    measures: u64,
) {
    println!(
        "{count},{stage},{ns},{},{},{},{},{nodes},{draws},{measures}",
        allocation.bytes_current,
        allocation.bytes_total,
        allocation.bytes_max,
        allocation.count_total
    );
}
fn main() -> Result<(), gpui::Error> {
    let count = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "1".into())
        .parse::<usize>()
        .unwrap();
    assert!([0, 1, 1000].contains(&count));
    let labels = [
        "Settings",
        "office café AVATAR",
        "Play 001",
        "Search library",
    ];
    let model = Page {
        labels: (0..count)
            .map(|index| labels[index % labels.len()].into())
            .collect(),
    };
    let mut owner = None;
    let start = Instant::now();
    let mounted = allocation_counter::measure(|| {
        owner = Some(
            Win::recording(
                model,
                WindowOptions {
                    size: [640, 480],
                    ..Default::default()
                },
            )
            .unwrap(),
        )
    });
    let elapsed = start.elapsed().as_nanos();
    let mut owner = owner.unwrap();
    let nodes = count + 1;
    let draws = owner.with_scene(|scene, _| scene.draws().len())?;
    println!(
        "count,stage,nanoseconds,retained_delta,total_requested,peak_new_bytes,allocations,nodes,draws,measure_calls"
    );
    report(
        count,
        "mount",
        elapsed,
        mounted,
        nodes,
        draws,
        owner.counters().measure_calls,
    );
    let mut output = vec![0; 640 * 480];
    let mut token = None;
    let start = Instant::now();
    let rendered =
        allocation_counter::measure(|| token = Some(owner.render_bgrx(&mut output).unwrap()));
    report(
        count,
        "render",
        start.elapsed().as_nanos(),
        rendered,
        nodes,
        draws,
        owner.counters().measure_calls,
    );
    save_pixels("initial", &output);
    owner.presented(token.unwrap())?;
    assert_eq!(owner.snapshot()?.nodes.len(), nodes);
    if count != 0 {
        assert!(output.iter().any(|&pixel| pixel != 0xffffff));
    }
    owner.reset_counters()?;
    let start = Instant::now();
    let edited = allocation_counter::measure(|| {
        owner
            .update(|page| {
                for label in &mut page.labels {
                    label.push('!');
                }
            })
            .unwrap();
    });
    report(
        count,
        "edit",
        start.elapsed().as_nanos(),
        edited,
        nodes,
        owner.with_scene(|scene, _| scene.draws().len())?,
        owner.counters().measure_calls,
    );
    let mut found = 0;
    owner.visit(|part| {
        if part.text().is_some_and(|text| text.ends_with('!')) {
            found += 1;
        }
    })?;
    // Recording has not acknowledged this newer candidate yet.
    assert_eq!(found, 0);
    let token = owner.render_bgrx(&mut output)?;
    save_pixels("edited", &output);
    owner.presented(token)?;
    owner.visit(|part| {
        if part.text().is_some_and(|text| text.ends_with('!')) {
            found += 1;
        }
    })?;
    assert_eq!(found, count);
    black_box(output);
    Ok(())
}

// Optional preflight artifact. Explicit per-word bytes, no pixel reinterpretation.
fn save_pixels(stage: &str, pixels: &[u32]) {
    if let Ok(prefix) = std::env::var("GPUI_TEXT_PIXELS") {
        use std::io::Write;
        let mut file = std::io::BufWriter::new(
            std::fs::File::create(format!("{prefix}.{stage}.bgrx")).unwrap(),
        );
        for pixel in pixels {
            file.write_all(&pixel.to_le_bytes()).unwrap();
        }
        file.flush().unwrap();
    }
}
