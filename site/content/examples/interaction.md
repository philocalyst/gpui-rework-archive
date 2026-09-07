+++
title = "One element, four moods."
description = "Hover, press, release, and keyboard activation move a small state machine that the visuals are derived from."
weight = 3
[extra]
category = "INTERACTIVITY"
playground = true
+++

Interaction in GPUI is a set of listeners on an element. This exhibit wires `on_hover`, `on_mouse_down`, `on_click`, and `on_key_down` to a single `Mood`, and derives colour and lift from that mood every frame.

{{ <playground example="interaction" title="The specimen" number="03" label="Pointer and keyboard" /> }}

## What to notice

The listeners never set a colour. They set a mood, call `cx.notify()`, and let `render` translate mood into paint. That separation is what keeps hover, press, and keyboard activation consistent with each other.

`focusable()` makes the element part of the tab order, so Space and Enter can activate it without a pointer.

## Try it deliberately

1. Hover, then press and release. The mood readout above the canvas follows along.
2. Click the canvas once, press Tab until the specimen is focused, and press Space.
3. Open **Source** and give `Mood::Pressed` a different `fill`, then compile.

Read [Events](@/guide/interactivity/events.md) and [Focus](@/guide/interactivity/focus.md) for the complete listener catalogue.
