use hummingbird_gpui_port::{app::Library, queue::{Track, TrackRef}, queue_playback::{EndOfStream, PlanStamp, Plan, PlaybackQueue}, queue_view::QueueScreen, worker::PlaybackRequest};
fn main() {
    macro_rules! row { ($ty:ty) => { println!("{} size={} align={}", stringify!($ty), size_of::<$ty>(), align_of::<$ty>()); }; }
    row!(Library); row!(Track); row!(TrackRef); row!(PlaybackRequest);
    row!(PlanStamp); row!(EndOfStream); row!(Plan); row!(Option<Plan>);
    row!(PlaybackQueue); row!(QueueScreen);
}
