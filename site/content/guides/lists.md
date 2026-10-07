+++
aliases = ["elements/lists.html", "guide/elements/lists/", "guide/rendering/layout/", "rendering/layout.html"]
title = "Choose a list implementation"
description = "Use equal-height virtualization only when the row-height invariant holds."
weight = 60
+++

Use `uniform_list` when every row has the same height along the scrolling axis.
It measures one row and uses that height to map a scroll offset to an index.
Use `list` when rows need individual measurement. Either way, give the scrolling
region a finite viewport and keep its identity stable.

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

Store the scroll handle on the view and pass it to the list each render. A
toolbar can keep a clone of the handle and call `scroll_to_item`; clones refer
to the same position. The list still owns layout and conversion from item
indices to visible bounds. Give the list and its rows stable IDs when their
retained state should survive subsequent frames or data changes.

Keep data indices and logical item keys distinct. An index identifies the
item's current position; a stable key follows the same item through filtering
or reordering. If a uniform list's range is unchanged but item heights may have
changed, it still relies on the equal-height invariant: switch list type when
that invariant no longer holds.

## Update measured rows

`ListState` owns the measured heights used by a variable-height `list`. Use
`splice` or `reset` when the item sequence or count changes so the measurements
stay aligned with the data. Use `remeasure` when existing content may have
changed size and proportional position inside the current item is useful; use
`remeasure_items` when preserving the current pixel offset is the desired
behavior. `measure_all` can provide accurate scrollbar geometry immediately,
at the cost of measuring every row up front. A uniform height hint is cheaper
when an initial estimate is sufficient.

Read [`UniformList`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.UniformList.html)
and [`ListState`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ListState.html) for
the measurement, scroll anchoring, and invalidation contracts. Use the
[10,000-row example](@/examples/lists.md) when equal heights are valid; start
from `list` when content determines each row's height.
