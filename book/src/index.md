# The GPUI Book

GPUI stores application state in entities and builds an element tree to draw
each view. These chapters explain how those parts fit together: who owns a
value, when a change reaches the screen, where input goes, and how to test the
result.

Start with [ownership and data flow](ownership.md) if you are new to GPUI.
Follow [rendering](rendering.md) to understand the work behind a frame, then
[layout and style](layout.md) to size and place its elements,
[animation](animation.md) to keep changes continuous across frames,
[text and fonts](text.md) for labels, measurement, and caret positions, and
[input and focus](input.md) to connect that frame to a user's actions.
[Accessibility](accessibility.md) connects its controls to names, roles, and
keyboard navigation.
[Custom drawing](drawing.md) covers coordinate systems, clipping, and paths.
[Scheduling](scheduling.md) covers work that outlives a callback;
[testing](testing.md) shows how to make its order and timing observable.
[Platform boundaries](platforms.md) explains which services come from GPUI and
which depend on the operating system or browser.

For complete programs, use the [walkthroughs]({{#gpui-site}}/examples/).
For signatures and individual method contracts, use the
[API reference]({{#gpui-api}}). Each chapter is rendered from the same source
as its conceptual rustdoc guide. Changes to those explanations appear in both
places.

The book describes the source snapshot behind this site. See
[version and platform notes]({{#gpui-site}}/reference/versions/) before using a
snippet with a different release.
