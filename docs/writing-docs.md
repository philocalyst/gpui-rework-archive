# Writing GPUI documentation

GPUI's documentation is rustdoc. The tutorial, guides, concept pages and API
reference are all doc comments or Markdown files included into doc-only
modules. Rustdoc renders them, checks their links and runs their examples.

| Kind | Purpose | Lives in |
| --- | --- | --- |
| Tutorial | Teach by building one app, step by step | `crates/gpui/docs/tutorial/` |
| Guides | Get one task done | `crates/gpui/docs/guides/` |
| Concepts | Explain how and why GPUI works | `crates/gpui/docs/concepts/` |
| Reference | Describe one item exactly | `///` comments in `crates/gpui/src` |
| Examples | Complete programs to run and read | `crates/gpui/examples/` |

Pages are wired into rustdoc in `crates/gpui/src/_documentation.rs`. Build and
check everything with:

```sh
just docs        # build the API docs and guides, failing on broken links
just test-doc    # run every example in the documentation
just site        # build the website, including the live examples
```

## Voice

Write the way a patient colleague explains something at a whiteboard.

- **Lead with what the reader wants.** Say what the item is for before you say
  how it works. "Runs `f` on a background thread" beats "Spawns a task on the
  background executor's thread pool that will execute `f`."
- **Be direct.** Use "you" and the present tense. Prefer active verbs.
- **Be concrete.** Name the type, the method, the event and the number. Show an
  example rather than describing one.
- **Be exact about behavior.** Say what happens at the edges: empty input,
  closed windows, dropped handles, reentrancy. If a method panics or fails, say
  when, under a `# Panics` or `# Errors` heading.
- **Leave out filler.** Delete "note that", "simply", "just", "easily",
  "basically", "in order to", "it should be noted", "this function". Don't
  restate the signature in prose.
- **Never guess.** Every statement must be true of the code. If you are not
  sure, read the implementation or write an example that proves it.

## Reference documentation

Every public item gets a summary line. It is a single sentence, under about
fifteen words, that says what the item *is* (types) or *does* (functions):

```rust
/// A handle to state owned by the [`App`].
pub struct Entity<T> { /* ... */ }

/// Returns the number of pixels in one rem for this window.
pub fn rem_size(&self) -> Pixels { /* ... */ }
```

After the summary, add what a reader needs to use the item well, in this order,
skipping anything that doesn't apply:

1. When and why to use it, and what to use instead when it's the wrong tool.
2. Behavior that the signature doesn't show: defaults, units, ordering, when
   callbacks run, what is retained between frames.
3. `# Examples`. One example, or several headed `# Example: <what it shows>`.
4. `# Panics` and `# Errors`.
5. Links to the guide or concept page for the bigger picture.

Small items deserve small docs. A field like `Point::x` needs one line. Spend
words on the items readers struggle with: contexts, entities, elements,
focus, actions, layout and painting.

Link every GPUI item the first time it's mentioned: [`Entity`],
[`Context::notify`], [`Window::focus`]. Rustdoc fails the build on broken links.

## Examples

An example is a promise that the code works, so make it run:

- Prefer examples that run and assert. `assert_eq!` shows the reader what to
  expect and proves it to CI.
- Use [`TestApp`] to run app, entity and window code headlessly. Hide the
  harness with `#` so the reader sees normal application code:

  ````rust
  /// ```
  /// # use gpui::{AppContext, TestApp};
  /// # let mut app = TestApp::new();
  /// # app.update(|cx| {
  /// let count = cx.new(|_| 0);
  /// count.update(cx, |count, cx| {
  ///     *count += 1;
  ///     cx.notify();
  /// });
  /// assert_eq!(*count.read(cx), 1);
  /// # });
  /// ```
  ````

- Use `no_run` only for code that needs a real display, such as
  `gpui_platform::application().run(...)`. Never use `ignore`.
- Keep examples short and focused on the item being documented. Hide setup
  that doesn't teach anything; show everything a reader would need to type.
- Effects such as observers and event subscriptions run when the outermost
  update finishes. Each `TestApp::update` call is one turn of the event loop, so
  assert on the results of `notify` and `emit` in a *later* `update`.
- Mark examples that declare actions (`actions!`, `#[derive(Action)]`) as
  ```` ```standalone_crate ````. Doctests share one binary and actions register
  by name, so two examples declaring `editor::Save` would make every other
  example panic. `tests/doc_examples.rs` enforces this.

## Links in long-form pages

Pages in `crates/gpui/docs` can link to items by name, as in ``[`Entity`]``.
Link to another page by its full path:
`[the frame](crate::_documentation::concepts::the_frame)`.

## Long-form pages

- **Tutorial chapters** build one program from nothing. Each chapter ends with
  a program that runs. Introduce one idea at a time, show the code, then run it.
- **Guides** start from a task ("Run work off the main thread") and get the
  reader there with the fewest concepts. Link to concept pages instead of
  explaining internals inline.
- **Concept pages** explain how a part of GPUI works and why it was designed
  that way, including the trade-offs and what it doesn't do.

Use headings as signposts, keep paragraphs short and put a runnable example
near the top of every page. Callouts use plain blockquotes beginning with
**Note:**, **Tip:** or **Warning:**.

## Live examples

Examples under `crates/gpui/examples` run natively and, unless marked
native-only, in the browser. Embed one in any page with:

```html
<div class="gpui-example" data-example="counter">
  <a href="https://gpui-ce.github.io/examples/#counter">Run the counter example in your browser</a>
</div>
```

On the project site this becomes the running example. Elsewhere, such as on
docs.rs, the link remains.
