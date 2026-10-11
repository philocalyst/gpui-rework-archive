# Tutorial: build a todo list

In this tutorial you build a small app from an empty project: a keyboard-friendly
todo list that you can add to, check off, filter and undo. It's simple enough to
finish in an afternoon and covers the ideas you need for any GPUI app.

<div class="gpui-example" data-example="todos">

The finished app is the `todos` example. Run it with `cargo run --example todos`
in a checkout of the GPUI repository.

</div>

Each chapter adds one feature and introduces the parts of GPUI it needs:

1. [Hello, window](tutorial::ch1_hello_window): an application, a window and
   your first view.
2. [State and events](tutorial::ch2_state): data that changes when you click,
   and telling GPUI to redraw.
3. [Layout and style](tutorial::ch3_layout_and_style): flexbox, spacing, color
   and hover states.
4. [Text input](tutorial::ch4_text_input): a text field, focus, actions and key
   bindings.
5. [Components](tutorial::ch5_components): splitting a view into reusable
   pieces, and filtering the list.
6. [Background work](tutorial::ch6_background_work): undoing a delete with a
   task that expires.
7. [Polish](tutorial::ch7_polish): animation and accessibility.
8. [Testing](tutorial::ch8_testing): driving the app from tests, without a
   window.

## Before you start

You should be comfortable with Rust's structs, closures and traits. You don't
need to know any other UI framework.

You need a recent stable Rust toolchain and, on Linux, a few system packages.
[Start a project](crate::_documentation::guides::start_a_project) lists them for
each platform.

The code in each chapter replaces or extends the code from the one before. Every
chapter ends with a program you can run, and [the finished
program](crate::_documentation::examples::todos) is there if you want to check
your work.
