+++
aliases = ["elements/lists.html", "guide/elements/lists/", "guide/rendering/layout/", "rendering/layout.html"]
title = "Choose a list implementation"
description = "Use equal-height virtualization only when the row-height invariant holds."
weight = 60
+++

Use `uniform_list` when each row has the same measured height. Use `list` when
rows require individual measurement. Either way, give the scrolling region a
finite viewport and keep its identity stable.

## Equal-height rows

The [large-list walkthrough](@/examples/lists.md) renders 10,000 rows. Its
callback receives a requested range and returns one element for each index.
It does not construct a hidden element for every item.

> [!WARNING]
> Wrapping text or expanding details can make row heights unequal. A uniform
> list estimates the entire scroll extent from a representative row; breaking
> that invariant can produce incorrect positions. Use the measured list for
> variable-height content.

## Retain scroll state

Store a scroll handle on the view and pass it back to the list on each render.
Use the handle's item-scrolling operation to reveal a selection. The list still
owns layout and the conversion from item indices to visible bounds.

Keep your data indices and logical item keys distinct. A stable item key should
follow an item when filtering or reordering, while an index identifies its
current position in the data source.

Read [`UniformList`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.UniformList.html)
and [`ListState`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ListState.html) for the
measurement and invalidation contracts.
