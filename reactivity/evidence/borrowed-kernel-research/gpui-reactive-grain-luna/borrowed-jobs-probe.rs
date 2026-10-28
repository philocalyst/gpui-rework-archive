#![allow(dead_code)]

use std::cell::Cell;

// The owner itself is !Sync, but two selected fields are Sync.
struct Model {
    title: String,
    bytes: Vec<u8>,
    local: Cell<u32>,
}

struct Job<'job, I: ?Sized, O: ?Sized> {
    input: &'job I,
    output: &'job mut O,
    run: fn(&'job I, &'job mut O),
}
struct Nil;
struct Cons<H, T>(H, T);

trait RunJobs {
    fn run(self);
}
impl RunJobs for Nil {
    fn run(self) {}
}
impl<'job, I, O, T> RunJobs for Cons<Job<'job, I, O>, T>
where
    I: Sync + ?Sized,
    O: Send + ?Sized,
    T: RunJobs,
{
    fn run(self) {
        let Cons(job, tail) = self;
        // Probe only: runtime code should use a persistent worker pool plus
        // balanced join, not create OS threads per frame.
        std::thread::scope(|scope| {
            scope.spawn(move || (job.run)(job.input, job.output));
            tail.run();
        });
    }
}

fn borrow_title<'job, 'frame>(
    input: &'job &'frame String,
    output: &'job mut Option<&'frame str>,
) {
    *output = Some(input.as_str());
}
fn borrow_bytes<'job, 'frame>(
    input: &'job &'frame Vec<u8>,
    output: &'job mut Option<&'frame [u8]>,
) {
    *output = Some(input.as_slice());
}
fn write_number<'a>(input: &'a u32, output: &'a mut u32) {
    *output = *input + 1;
}
fn read_model<'a>(input: &'a Model, output: &'a mut u32) {
    *output = input.local.get();
}
fn read_cell<'a>(input: &'a Cell<u32>, output: &'a mut u32) {
    *output = input.get();
}

fn main() {
    let model = Model {
        title: String::from("borrowed"),
        bytes: vec![1, 2, 3],
        local: Cell::new(8),
    };
    let title_input = &model.title;
    let bytes_input = &model.bytes;
    {
        let mut title_out = None;
        let mut bytes_out = None;
        let jobs = Cons(
            Job { input: &title_input, output: &mut title_out, run: borrow_title },
            Cons(
                Job { input: &bytes_input, output: &mut bytes_out, run: borrow_bytes },
                Nil,
            ),
        );
        jobs.run();
        assert_eq!(title_out, Some("borrowed"));
        assert_eq!(bytes_out, Some(&[1, 2, 3][..]));
    }
    model.local.set(9);

    #[cfg(negative_whole_model)]
    {
        let mut out = 0;
        Cons(Job { input: &model, output: &mut out, run: read_model }, Nil).run();
    }

    #[cfg(negative_cell_field)]
    {
        let mut out = 0;
        Cons(Job { input: &model.local, output: &mut out, run: read_cell }, Nil).run();
    }

    #[cfg(negative_aliased_output)]
    {
        let mut out = 0;
        let value = 1;
        let jobs = Cons(
            Job { input: &value, output: &mut out, run: write_number },
            Cons(Job { input: &value, output: &mut out, run: write_number }, Nil),
        );
        jobs.run();
    }
}
