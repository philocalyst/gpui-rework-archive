# Comparison with other toolkits

Rust has several good UI toolkits, and they make different trade-offs. This page
describes how GPUI's approach differs from the most common alternatives, so you
can tell whether it fits what you're building. It compares designs, not
benchmarks, and each project changes quickly: check its own documentation for
current details.

## At a glance

| Toolkit | How you describe the interface | How state flows | How it draws |
| --- | --- | --- | --- |
| **GPUI** | Rust code that builds an element tree each frame, styled with Tailwind-like methods | Entities owned by the app; you notify on change | Its own GPU renderer |
| [egui](https://github.com/emilk/egui) | Immediate mode: Rust code that draws widgets every frame | Your own structs, passed to the UI each frame | Its own GPU renderer |
| [iced](https://github.com/iced-rs/iced) | The Elm architecture: a `view` function returns widgets | Messages handled by an `update` function | Its own GPU or software renderer |
| [Slint](https://slint.dev) | A declarative markup language, compiled to Rust | Properties and bindings in the markup | Its own renderers, including for embedded devices |
| [Dioxus](https://dioxuslabs.com) | React-style components with an `rsx!` macro, styled with CSS | Hooks and signals | A webview or the DOM, with a native renderer in development |
| [Xilem](https://github.com/linebender/xilem), [Floem](https://github.com/lapce/floem) | Reactive view trees | Reactive state: view functions or fine-grained signals | Their own GPU renderers |
| [Tauri](https://tauri.app) | Any web framework | Whatever the web framework uses, with Rust on the backend | The system webview |

## egui

egui is the quickest way to put a working interface in front of someone. In
immediate mode, your code describes and handles the whole interface every frame,
in one pass: `if ui.button("Save").clicked() { save() }`. There is no separate
state model to design, and it comes with a large set of ready-made widgets.

GPUI also rebuilds its element tree every frame, but it separates building the
interface from handling events and from layout. That separation is what makes
flexbox and grid layout, focus and keyboard dispatch, and very large views
practical. Choose egui for tools, debug panels and apps where getting something
working quickly matters most. Choose GPUI when you need precise layout, a
keyboard-driven interface, or an app that will grow large.

## iced

iced follows the Elm architecture: all changes flow through messages to a single
`update` function, and `view` describes the interface from the current state.
This is easy to reason about and test, and iced provides a solid set of widgets.

GPUI lets state live in many entities that update and observe each other
directly, rather than routing everything through one function. That scales more
naturally to apps with many independent parts, at the cost of the Elm
architecture's single, inspectable flow of changes. iced has more built-in
widgets; GPUI expects you to build your own components from its elements.

## Slint

Slint describes interfaces in its own declarative language, with live preview
and design tooling, and runs on everything from microcontrollers to desktops.
Choose it for embedded devices, or when designers will work on the interface
directly. GPUI is plain Rust from top to bottom and targets desktop and web.

## Dioxus and Tauri

Dioxus brings React's model to Rust: components, hooks and signals, with HTML and
CSS for structure and style. Tauri lets you write the interface in any web
framework and the backend in Rust. Both are excellent choices if your team knows
web development or you want to share code with a website.

GPUI doesn't use HTML, CSS or a webview. Its styling borrows Tailwind's names and
its layout follows CSS flexbox and grid, so web experience transfers, but the
interface is Rust code drawn by GPUI's own renderer. That gives you consistent
performance and behavior without a browser engine, and it means web libraries
and CSS don't apply.

## Xilem and Floem

Xilem and Floem are newer reactive toolkits, related to the Linebender projects
and the Lapce editor respectively. Like GPUI, they draw with their own GPU
renderers. Their state models are reactive: Xilem
rebuilds lightweight view trees from app state, and Floem uses fine-grained
signals that update only what depends on them.

GPUI's model is less automatic. You call `notify` when an entity changes, and the
windows that display it re-render. That's more explicit than signals, and it has
been exercised at scale in Zed.

## Choosing GPUI

GPUI is a good fit when:

* you are building a substantial desktop application, especially one used
  mostly from the keyboard, such as an editor or a developer tool;
* you want full control over how the interface looks and behaves, and you're
  happy to build your own components;
* you care about rendering performance with large amounts of text and content;
* you want to test interface behavior with fast, deterministic tests.

It is a weaker fit when you need a large library of ready-made widgets, native
platform controls, mobile platforms, or a stable API. [Design](crate::_documentation::design)
explains the reasoning behind these trade-offs.

## GPUI and GPUI Community Edition

GPUI-CE is a fork of the GPUI that Zed uses. It tracks upstream and adds features
for applications other than Zed, including a web backend, a new text system and
motion APIs. [Upstream](crate::_documentation::upstream) lists the differences
and how to port code between the two.
