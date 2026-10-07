# GPUI report viewer

`index.html`, `viewer.css`, and `viewer.js` are trusted static viewer sources embedded by the Rust report writer and the forge publisher. The generated report is a self-contained HTML file; its manifest and capture assets stay beside it at their manifest-relative paths.

Websites can reuse the module directly:

```js
import { renderReport } from "./viewer.js";

const dispose = renderReport(document.querySelector("#report"), manifest, {
  baseURL: "/visual-reports/runs/<commit-sha>/",
});
// Call dispose() when removing the report view.
```

Load `viewer.css` alongside the module. The viewer creates nodes with DOM APIs and assigns report text through `textContent`. With no `baseURL`, assets resolve beside the report; a configured HTTP(S) `baseURL` can point to another static host and is path-scoped. Only the checked-in module runs; report data cannot supply scripts. Embedded instances keep selection local by default, so several reports can coexist without changing a site's URL or each other's selection. The standalone HTML opts into `useHash: true` for shareable checkpoint links.

Checkpoint comparison starts with the exact red diff when it exists. Wipe, blink, side-by-side, visible-magnitude heatmap, and actual-pixel zoom are available for the selected frame. A missing baseline is called out; the current image is reused only when the manifest records `pixels_changed: false`, including scene-only or metadata-only changes. Playback follows increasing adjacent captured `time_ns` deltas; equal, descending, or unavailable times expose explicit frame stepping instead.

Use the frame scrubber or changed-frame controls to inspect the timeline. Exact, visible, and signed transition error trends distinguish static image changes from motion changes; the percentage axis scales to show small errors. Transition red and transition heatmap visualize where motion diverged, even when the selected image matches the baseline again. Focus changes opens the selected difference at actual pixels near its reported bounds. The stylesheet is scoped to `.gpui-report`; page chrome and bootstrapping live in the HTML template, keeping module imports free of document side effects. Forge publication includes this trusted module, stylesheet, and a generated Markdown report beside the run assets.
