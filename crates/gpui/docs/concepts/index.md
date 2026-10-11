# Concepts

These pages explain how GPUI works and why. Read them when you want to
understand the code you're writing rather than copy it, or when something
behaves in a way you didn't expect.

They build on each other, so if you're reading for the first time, read them in
order:

1. [Ownership and data flow](concepts::ownership): the app owns your state; you hold
   handles to it, and say when it changes.
2. [Contexts](concepts::contexts): what `cx` is, and which kind you have where.
3. [The frame](concepts::the_frame): how a change becomes pixels, and what lasts from one
   frame to the next.
4. [Elements, components and views](concepts::elements): the three ways to describe an
   interface, and how GPUI keeps track of them.
5. [Layout and style](concepts::layout_and_style): boxes, flexbox, grid and units.
6. [Input and dispatch](concepts::input_dispatch): where mouse and keyboard input goes,
   and how keystrokes become actions.
7. [Executors and tasks](concepts::executors): async work, threads, and cancellation.

For the reasoning behind these designs and the trade-offs they make, see
[Design](crate::_documentation::design).
