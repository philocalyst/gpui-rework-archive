use std::marker::PhantomData;

struct NonSyncModel { value: std::cell::Cell<u32> }
struct Job<'a, I, O> { input: &'a I, output: &'a mut O }
fn recipe<I, O>(input: &I, output: &mut O) where I: Sync, O: Send { *output = (*input).clone(); }
fn run<M, I: Sync, O: Send>(model: &M, outputs: &mut [O], freeze: fn(&M)->&I) {
    let jobs: Vec<Job<'_, I, O>> = outputs.iter_mut().map(|output| Job { input: freeze(model), output }).collect();
    std::thread::scope(|scope| {
        for job in jobs { scope.spawn(move || recipe(job.input, job.output)); }
    });
}
fn not_send_model_compile_fail() {
    let model = NonSyncModel { value: std::cell::Cell::new(1) };
    let _ = std::thread::spawn(move || model.value.get());
}
fn shared_read_with_sync_field() {
    struct Model { value: u32 }
    let model = Model { value: 1 };
    let borrowed = &model.value;
    std::thread::scope(|scope| scope.spawn(|| assert_eq!(*borrowed, 1)));
}
