use hummingbird_gpui_port::{database::Database, search::{Searcher, SearchInput, Sort, Version}};
fn main() {
    let database = Database::fixture().unwrap();
    database.connection().execute_batch("BEGIN IMMEDIATE").unwrap();
    for id in 20_000..45_000 {
        database.insert_track(id, &format!("Library recording {id}"), None, Some("Worker Ensemble"), 240, None).unwrap();
    }
    database.connection().execute_batch("COMMIT").unwrap();
    for query in ["", "no such title", "μαρ", "Worker"] {
        let mut searcher = Searcher::default();
        for phase in ["cold", "warm"] {
            let input = SearchInput::freeze(query, Sort::Title, Version::default()).unwrap();
            let mut page = None;
            let allocation = allocation_counter::measure(|| page = searcher.search(&database, input, || false));
            let page = page.unwrap().unwrap();
            let hash = page.ids().fold(0xcbf29ce484222325u64, |hash,id| (hash ^ id as u64).wrapping_mul(0x100000001b3));
            println!("{query:?},{phase},{},{hash},{},{},{},{},{}",page.rows.len(),allocation.count_total,allocation.bytes_total,allocation.bytes_current,allocation.bytes_max,allocation.count_current);
        }
    }
}
