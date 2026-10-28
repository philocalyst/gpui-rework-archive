use gpui::{Win, WindowOptions};
use hummingbird_gpui_port::{app::{Library, connect}, database::Database, worker::{Worker, LibraryEvent, Selection}, search::SourceError};
#[test]
fn requested_ui_construction_and_static_owner_bill() {
    for cohort in 0..4 {
        let database = Database::fixture().unwrap();
        let mut spawned = None;
        let spawn = allocation_counter::measure(|| spawned = Some(Worker::new(database).unwrap()));
        let (worker, inbox) = spawned.unwrap();
        let mut connection = None;
        let connected = allocation_counter::measure(|| connection = Some(connect(worker.handle()).unwrap()));
        let (model, questions) = connection.unwrap();
        let model_bytes = std::mem::size_of_val(&model);
        let questions_bytes = std::mem::size_of_val(&questions);
        let mut window = None;
        let mounted = allocation_counter::measure(|| {
            window = Some(Win::with_questions(model, questions, WindowOptions {size:[720, 1100], ..Default::default()}).unwrap()
                .with_inbox_status(inbox, Library::receive).unwrap());
        });
        let window = window.unwrap();
        println!("COHORT {cohort} model={model_bytes} questions={questions_bytes} event={} selection={} error={} win={} ui_current_plus_inline={} spawn={spawn:?} connected={connected:?} mounted={mounted:?}",
            std::mem::size_of::<LibraryEvent>(),std::mem::size_of::<Selection>(),std::mem::size_of::<SourceError>(),std::mem::size_of_val(&window),
            spawn.bytes_current+connected.bytes_current+mounted.bytes_current+std::mem::size_of_val(&window) as i64);
        drop(window);
        worker.finish().unwrap();
    }
}
