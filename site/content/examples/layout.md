+++
title = "Space is a material."
description = "Move the constraint. Watch a composition reorganize itself around the room it actually has."
weight = 2
[extra]
category = "LAYOUT / CONSTRAINTS"
playground = true
+++

An interface is always negotiating with a rectangle. This study makes that constraint visible: adjust the container width and observe how the workbench and inspector share space.

{{ <playground example="layout" title="A room of its own" number="02" label="Layout constraints" /> }}

## Read the arrangement

The slider supplies the available width. Rust/WASM chooses the study’s arrangement and the preview applies it. This deliberately small model exposes a layout decision; GPUI’s actual layout engine has a much richer set of constraints.

Move slowly through the range. Watch when the two regions stack and when they can sit alongside each other. The range control also works with the arrow keys.

## Constraints before coordinates

In GPUI, start with a parent’s layout mode and the dimensions its children need. Use growth, shrink, padding, and gap to describe relationships. Fixed coordinates are useful when you need them; they should be a decision rather than the default.

The documentation site itself uses intrinsic CSS layout: wrapping flex items and automatically fitted grid columns, without viewport media queries.

## Keep going

The [layout reference](@/guide/rendering/layout.md) explains the framework’s layout vocabulary. The [styling chapter](@/guide/rendering/styling.md) covers the fluent methods that shape an element’s appearance.
