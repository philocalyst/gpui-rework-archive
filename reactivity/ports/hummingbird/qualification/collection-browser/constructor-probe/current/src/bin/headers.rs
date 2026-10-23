use hummingbird_gpui_port::{app::connect,browser::{Browser,Collections,Input,Navigation,Page,PlayRequest,PreparedListing,TrackRows},database::Database,search::{Sort,Version},worker::Worker};
fn main() {
    println!("BROWSER_HEADERS browser={} navigation={} input={} request={} listing={} page={} rows={} collections={}",size_of::<Browser>(),size_of::<Navigation>(),size_of::<Input>(),size_of::<PlayRequest>(),size_of::<PreparedListing>(),size_of::<Page>(),size_of::<TrackRows>(),size_of::<Collections>());
    let (worker,inbox)=Worker::new(Database::fixture().unwrap()).unwrap();
    let (model,questions)=connect(worker.handle()).unwrap();
    for length in [0,1024] {
        let query="x".repeat(length);
        let mut input=None;
        let requests=allocation_counter::measure(|| input=Some(Input::freeze(model.browser().navigation(),&query,Sort::Title,Version::default()).unwrap()));
        println!("INPUT length={length} query_capacity={} refs={} requests={requests:?}",input.as_ref().unwrap().query.capacity(),triomphe::Arc::strong_count(input.as_ref().unwrap()));
        drop(input);
    }
    drop((model,questions,inbox));
    worker.finish().unwrap();
}
