# Share state between views

Several views often need the same data: a model, a document or a setting. This guide
shows how to hand that data to each view, react when it changes, send typed events, keep
listeners alive, and store app-wide state. The model and ownership rules are in
[ownership](crate::_documentation::concepts::ownership); this page is about choosing and
wiring the pieces together.

## Share a model through entity handles

Create the model once, then pass a clone of its [`Entity`] to every view that needs it.
Each clone is another handle to the same value, so an update made through one handle is
visible through all of them.

```rust
use gpui::{AppContext, Context, Entity, Subscription, TestApp};

#[derive(Default)]
struct Cart {
    items: Vec<String>,
}

struct Badge {
    count: usize,
    _observation: Subscription,
}

impl Badge {
    fn new(cart: &Entity<Cart>, cx: &mut Context<Self>) -> Self {
        Self {
            count: cart.read(cx).items.len(),
            _observation: cx.observe(cart, |badge, cart, cx| {
                badge.count = cart.read(cx).items.len();
            }),
        }
    }
}

let mut app = TestApp::new();
let (cart, badge) = app.update(|cx| {
    let cart = cx.new(|_| Cart::default());
    let badge = cx.new(|cx| Badge::new(&cart, cx));
    (cart, badge)
});

app.update(|cx| {
    cart.update(cx, |cart, cx| {
        cart.items.push("Keyboard".into());
        cx.notify();
    });
});

// The observer runs when the update above finishes, so check in the next update.
app.update(|cx| assert_eq!(badge.read(cx).count, 1));
```

Pass `&Entity<T>` into constructors and store the clone you need. Each stored handle keeps
the model alive, so the model lives as long as any view holds it.

## React to every change with `observe`

[`Context::observe`] runs a callback each time the observed entity calls
[`Context::notify`]. Use it when a view needs to recompute something from the model but
doesn't need to know what changed. The callback receives the observed entity, so it can
read the new state directly.

```rust
# use gpui::{AppContext, Context, Entity, Subscription, TestApp};
# #[derive(Default)]
# struct Cart { items: Vec<String> }
# struct Badge { count: usize, _observation: Subscription }
# impl Badge {
#     fn new(cart: &Entity<Cart>, cx: &mut Context<Self>) -> Self {
#         Self {
#             count: cart.read(cx).items.len(),
#             _observation: cx.observe(cart, |badge, cart, cx| {
#                 badge.count = cart.read(cx).items.len();
#             }),
#         }
#     }
# }
# let mut app = TestApp::new();
# let (cart, badge) = app.update(|cx| {
#     let cart = cx.new(|_| Cart::default());
#     let badge = cx.new(|cx| Badge::new(&cart, cx));
#     (cart, badge)
# });
app.update(|cx| {
    cart.update(cx, |cart, cx| {
        cart.items.push("Mouse".into());
        cart.items.push("Cable".into());
        cx.notify();
    });
});
app.update(|cx| assert_eq!(badge.read(cx).count, 2));
```

Observers run once per update, not once per `notify`. Two `notify` calls in one update
cost the same as one. The observer runs after the update that notified has finished, so
it never sees the model in the middle of a change.

If the observer is only needed while the observing view is alive, store its
[`Subscription`] in a field, as the `Badge` above does. When the view is released, the
subscription is dropped and the callback stops.

## Send typed events with `emit` and `subscribe`

Use events when a listener needs to know *what happened*, not just that something
changed. Implement [`EventEmitter`] for each event type the model can emit, call
[`Context::emit`] in the model, and call [`Context::subscribe`] in the listener. The
callback receives the event by reference and only the event types the listener asked
for.

```rust
use gpui::{AppContext, Context, Entity, EventEmitter, Subscription, TestApp};

enum UploadEvent {
    Finished { name: String },
}

struct Uploads;

impl EventEmitter<UploadEvent> for Uploads {}

struct Notifications {
    finished: Vec<String>,
    _subscription: Subscription,
}

impl Notifications {
    fn new(uploads: &Entity<Uploads>, cx: &mut Context<Self>) -> Self {
        Self {
            finished: Vec::new(),
            _subscription: cx.subscribe(uploads, |this, _uploads, event, _cx| match event {
                UploadEvent::Finished { name } => this.finished.push(name.clone()),
            }),
        }
    }
}

let mut app = TestApp::new();
let (uploads, notifications) = app.update(|cx| {
    let uploads = cx.new(|_| Uploads);
    let notifications = cx.new(|cx| Notifications::new(&uploads, cx));
    (uploads, notifications)
});

app.update(|cx| {
    uploads.update(cx, |_uploads, cx| {
        cx.emit(UploadEvent::Finished { name: "logo.png".into() });
    });
});

app.update(|cx| {
    assert_eq!(notifications.read(cx).finished, vec!["logo.png".to_string()]);
});
```

Events are queued like notifications and delivered when the emitting update finishes.
A model can emit several event types by implementing `EventEmitter` once per type. The
[events example](crate::_documentation::examples::events) wires one model to three views: one
changes it, one observes it and one subscribes to its event.

## Keep subscriptions alive

[`Context::observe`], [`Context::subscribe`] and [`App::observe_global`] return a
[`Subscription`]. The callback runs for as long as the subscription exists. Choose one of
two lifetimes:

* **Store it** in a field of the listening view, when the listener should stop when the
  view goes away. This is the usual choice. Name the field with a leading underscore if
  you never read it, as `_observation` above.
* **Call [`Subscription::detach`]**, when the callback should keep running until either
  the listener or the observed entity is released. Use it for subscriptions made in a
  constructor where nothing else owns them.

Dropping a subscription you didn't store or detach stops it immediately, so don't let one
fall out of scope by accident.

## Share app-wide state with a global

A global is one value of a type for the whole [`App`]. Use one for state that exists once,
such as settings, a theme or a feature flag. Implement [`Global`] for the type, then read
and write it through the app.

```rust
use std::{cell::Cell, rc::Rc};

use gpui::{BorrowAppContext, Global, TestApp};

#[derive(Default)]
struct Settings {
    font_size: f32,
}

impl Global for Settings {}

let mut app = TestApp::new();
let changes = Rc::new(Cell::new(0));

// Set the global in its own update. Global notifications from `set_global` are
// queued, and an observer added in the same update would miss them.
app.update(|cx| cx.set_global(Settings { font_size: 14.0 }));

app.update(|cx| {
    let changes = changes.clone();
    cx.observe_global::<Settings>(move |_cx| changes.set(changes.get() + 1))
        .detach();

    cx.update_global::<Settings, _>(|settings, _cx| settings.font_size = 16.0);
});

app.update(|cx| {
    assert_eq!(cx.global::<Settings>().font_size, 16.0);
    assert_eq!(changes.get(), 1);
});
```

[`App::global`] panics if no value of the type has been set, so set globals before any
view reads them. [`App::try_global`] returns `None` instead. [`App::observe_global`] runs when [`BorrowAppContext::update_global`] or
a global lease ends; a view can observe a global with [`Context::observe_global`], which
passes the view's state and context to the callback. Prefer an entity whenever there could
be more than one instance of the state.

## Avoid cycles with weak handles

A strong [`Entity`] keeps its value alive. If a parent holds a child and the child holds
the parent through another strong handle, neither is ever released. Store a
[`WeakEntity`] for the back-reference. Reach the value through it with
[`WeakEntity::update`], which returns a `Result` that fails once the value is gone.

```rust
use gpui::{AppContext, Entity, TestApp, WeakEntity};

struct Parent {
    title: String,
    child: Option<Entity<Child>>,
}

struct Child {
    parent: WeakEntity<Parent>,
}

let mut app = TestApp::new();
let (parent, child) = app.update(|cx| {
    let parent = cx.new(|_| Parent {
        title: "Inbox".into(),
        child: None,
    });
    let child = cx.new(|_| Child {
        parent: parent.downgrade(),
    });
    parent.update(cx, |parent, _cx| parent.child = Some(child.clone()));
    (parent, child)
});

app.update(|cx| {
    let weak = child.read(cx).parent.clone();
    let title = weak.update(cx, |parent, _cx| parent.title.clone());
    assert_eq!(title.unwrap(), "Inbox");
});

// Drop the last strong handle to the parent.
drop(parent);

app.update(|cx| {
    let weak = child.read(cx).parent.clone();
    assert!(weak.update(cx, |parent, _cx| parent.title.clone()).is_err());
});
```

Use a weak handle for any callback that outlives the current frame, too. The closures that
[`Context::listener`] and [`Context::spawn`] create already capture weak handles for this
reason.

## Choose a mechanism

| You want to | Use |
| --- | --- |
| Show the same data in several views | A model as `Entity<T>`, cloned into each view |
| Recompute something when a model changes | [`Context::observe`] and [`Context::notify`] |
| Tell listeners what happened | [`EventEmitter`], [`Context::emit`] and [`Context::subscribe`] |
| Hold one value for the whole app | [`Global`] with [`App::set_global`] and [`BorrowAppContext::update_global`] |
| Refer to an entity that may be gone | [`WeakEntity`] |

Start with a model and observers. Move to events when observers start asking "which
change was it?". Use a global only for state that is singular by nature.

## See also

- [Ownership and data flow](crate::_documentation::concepts::ownership), for how entities,
  updates and effects work.
- [Contexts](crate::_documentation::concepts::contexts), for `Context<T>` and `App`.
- [Run work in the background](crate::_documentation::guides::async_work), for tasks that
  update a model later.
- [The events example](crate::_documentation::examples::events).
