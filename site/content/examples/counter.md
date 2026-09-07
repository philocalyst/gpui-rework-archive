+++
title = "A little state goes a long way."
description = "Two buttons, one number, and the relationship between a change and a redraw."
weight = 1
[extra]
category = "STATE / EVENTS"
playground = true
+++

A counter is small enough to hold in your head and complete enough to explain an application. It has persistent state, input, and a visual result. Press the buttons inside the canvas, then open **Source** to see the mechanism.

{{ <playground example="counter" title="The counter" number="01" label="Entity state" /> }}

## What to notice

The number is state. The buttons are events. The displayed value is a projection of the current state, recomputed by `render` every time `cx.notify()` runs.

In GPUI, the struct is owned by an `Entity`. Each click listener receives the entity's state through its `Context`, updates the value, and asks for a redraw. Nothing else touches the number.

## Try it deliberately

1. Increment three times, then decrement once. The visible result should be two.
2. Open **Source** and change `clamp(-99, 99)` to `clamp(0, 9)`, then compile. The counter now refuses to go negative.
3. Change the `rgb(0xf0603f)` coral to a colour of your own and compile again. Same program, new paint.
4. Press **Restore** to return to the committed exhibit.

## Take the pattern with you

Continue with the complete [counter tutorial](@/guide/getting-started/counter-tutorial.md), including application setup and the failure modes to watch for. Read [Entities](@/guide/fundamentals/entities.md) for the ownership model behind the small example.
