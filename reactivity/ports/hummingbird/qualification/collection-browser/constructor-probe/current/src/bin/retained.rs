use hummingbird_gpui_port::{browser::CollectionRow,query::TrackSearchRow,queue::{Entry,EntryKey,Track,TrackRef}};
fn main() {
    println!("RETAINED_HEADERS collection_row={} track_row={} entry={} key={} track={} track_ref={}",size_of::<CollectionRow>(),size_of::<TrackSearchRow>(),size_of::<Entry>(),size_of::<EntryKey>(),size_of::<Track>(),size_of::<TrackRef>());
}
