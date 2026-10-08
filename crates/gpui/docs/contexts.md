# Choose a context

The canonical explanation is [ownership and data flow](../src/_ownership_and_data_flow.rs),
also published as the [ownership chapter](https://gpui-ce.github.io/book/ownership.html).
It covers entity access, element identity, notifications, subscriptions, globals,
and work that crosses an `await`.

| Value | What it gives the caller |
| --- | --- |
| `App` | Synchronous access to application state and services |
| `Context<T>` | The same app access plus the identity and operations of one entity being built or updated |
| `AsyncApp` | A weak app handle that reacquires access for synchronous callbacks after a wait |
| `AsyncWindowContext` | Async app access plus the identity of one window; window operations can fail after it closes |
| `TestAppContext` | A simulated app with controlled task ordering, time, input, and test helpers |

Follow each method's error and panic contract. An async context does not make
every operation fallible, and a test context does not make every failure a panic.
The [testing chapter](https://gpui-ce.github.io/book/testing.html) shows which
effects and tasks each test helper drives.

`Window` owns one window's layout, drawing, focus, and dispatch state. It is
usually lent alongside an app context; obtain callback-scoped access through
a window handle's `update` method. `Entity<T>` and `WindowHandle<T>` identify
stored state. Neither handle alone grants a mutable borrow of that state.
