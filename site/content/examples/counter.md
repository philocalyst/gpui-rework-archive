+++
title = "A little state goes a long way."
description = "Two buttons, one number, and the relationship between a change and a redraw."
weight = 1
[extra]
category = "STATE / EVENTS"
playground = true
+++

A counter is small enough to hold in your head and complete enough to explain an application. It has persistent state, input, and a visual result. Turn the controls below, then open **Source** to inspect the mechanism.

{{ <playground example="counter" title="The observable counter" number="01" label="Entity state" /> }}

## What to notice

The number is state. The buttons are events. The displayed value is a projection of the current state. Reset restores the initial value without reloading the page, and each embedded experiment keeps its own state.

In GPUI, the struct is owned by an `Entity`. The click listener receives the entity’s state through its `Context`, updates the value, and calls `cx.notify()` to schedule a redraw.

## Try it deliberately

1. Increment three times, then decrement once. The visible result should be two.
2. Focus the increment button with the keyboard and activate it with Space or Enter.
3. Switch to Source, return to Result, and verify that the count remains.
4. Reset. The display returns to zero.

## Take the pattern with you

This experiment runs GPUI itself, compiled to WebAssembly and drawing through its GPU renderer. Click the controls inside the canvas, or use the semantic controls below it with a keyboard. Both paths update the same Rust entity. Source shows the exact Rust entry point used to compile this example.

Continue with the complete [counter tutorial](@/guide/getting-started/counter-tutorial.md), including application setup and the failure modes to watch for. Read [Entities](@/guide/fundamentals/entities.md) for the ownership model behind the small example.
