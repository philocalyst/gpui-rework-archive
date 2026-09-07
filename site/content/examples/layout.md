+++
title = "Layout that answers to its container."
description = "One arrangement decision, expressed as a function of width, drives two panels through three states."
weight = 2
[extra]
category = "LAYOUT"
playground = true
+++

Responsive layout in GPUI is ordinary Rust: measure, decide, then style. The `arrangement` function below turns a width into one of three states, and `render` reads that state to choose a flex direction and a gap.

{{ <playground example="layout" title="The workbench" number="02" label="Flex and gaps" /> }}

## What to notice

The buttons only change `self.width`. Everything else, the column-versus-row decision, the gap, the caption in the plate, is derived inside `render`. There is no second source of truth to keep in sync.

`when(condition, |element| …)` applies a style only when the condition holds. It is the idiom for conditional layout throughout the framework.

## Try it deliberately

1. Switch between the three widths and watch the panels reflow.
2. Open **Source** and move the `340.` breakpoint to `500.`, then compile. Compact now stacks.
3. Replace `.gap(px(gap))` with `.gap_8()` to see the fixed Tailwind-style spacing helpers.

Read [Layout basics](@/guide/rendering/layout.md) for the full flex and grid vocabulary, and [`container_query`](@/guide/elements/advanced.md) for measuring the available space instead of choosing it.
