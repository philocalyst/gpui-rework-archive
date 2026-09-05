+++
title = "The difference is in the response."
description = "A control is a conversation: idle, pointed at, focused, and pressed."
weight = 3
[extra]
category = "INPUT / FEEDBACK"
playground = true
+++

A button has more than one appearance because a person has more than one way to reach it. This experiment makes those states explicit.

{{ <playground example="interaction" title="A responsive character" number="03" label="Input states" /> }}

## Give it your attention

Hover the control. Press it and hold. Move the pointer away. Now use Tab to focus it and hold Space. The label describes the current state, and the visual treatment follows it.

Rust/WASM resolves the input flags into a state. The browser supplies native keyboard and pointer events, with semantic controls that remain part of its accessibility tree.

## Focus is part of the design

Pointer hover cannot stand in for keyboard focus. In GPUI, use a focus handle and track focus deliberately. A focus indicator tells a keyboard user where the next action will land.

Read [Focus](@/guide/interactivity/focus.md) for the framework’s focus model and [Events](@/guide/interactivity/events.md) for dispatch and listeners. For application commands that should work from more than one control, continue to [Actions & Keymap](@/guide/interactivity/actions-keymap.md).
