use accesskit::{ActionHandler, ActionRequest, ActivationHandler, DeactivationHandler, TreeUpdate};
use accesskit_unix::Adapter;
use std::{thread, time::Duration};
struct H;
impl ActivationHandler for H { fn request_initial_tree(&mut self) -> Option<TreeUpdate> { None } }
impl ActionHandler for H { fn do_action(&mut self, _: ActionRequest) {} }
impl DeactivationHandler for H { fn deactivate_accessibility(&mut self) {} }
fn sample(label: &str) {
    let tids = std::fs::read_dir("/proc/self/task").unwrap().map(|e| e.unwrap().path()).collect::<Vec<_>>();
    let names = tids.iter().map(|p| std::fs::read_to_string(p.join("comm")).unwrap_or_default().trim().to_string()).collect::<Vec<_>>();
    let rollup = std::fs::read_to_string("/proc/self/smaps_rollup").unwrap_or_default();
    let rss = rollup.lines().find(|l| l.starts_with("Rss:")).unwrap_or("");
    let pss = rollup.lines().find(|l| l.starts_with("Pss:")).unwrap_or("");
    println!("{label} tasks={} names={:?} {} {}", names.len(), names, rss, pss);
}
fn main() {
    sample("baseline");
    let _adapters = (0..6).map(|_| Adapter::new(H, H, H)).collect::<Vec<_>>();
    for i in 0..20 {
        thread::sleep(Duration::from_millis(250));
        sample(&format!("after-{i}"));
    }
}
