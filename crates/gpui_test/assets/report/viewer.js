const el = (doc, tag, text, attrs = {}) => {
  const node = doc.createElement(tag);
  if (text !== undefined && text !== null) node.textContent = String(text);
  for (const [name, value] of Object.entries(attrs)) {
    if (value !== undefined && value !== null) node.setAttribute(name, String(value));
  }
  return node;
};
const ns = (value) => Number.isFinite(value) ? (value / 1e6).toFixed(3) : "n/a";
const count = (value) => Number.isSafeInteger(value) ? value.toLocaleString() : "n/a";
const statusLabel = (value) => ({
  baseline_unavailable: "no baseline", new: "new", unchanged: "unchanged", changed: "changed",
}[value] || value || "unknown");

function assetURL(path, baseURL, doc) {
  if (typeof path !== "string" || path.startsWith("/") || path.includes("\\") ||
      path.split("/").some((part) => !part || part === "." || part === "..")) return null;
  try {
    const base = new URL(baseURL || ".", doc.baseURI);
    if (!["http:", "https:", "file:"].includes(base.protocol) || base.search || base.hash) return null;
    if (!base.pathname.endsWith("/")) base.pathname += "/";
    const url = new URL(path.split("/").map(encodeURIComponent).join("/"), base);
    return url.origin === base.origin && url.pathname.startsWith(base.pathname) ? url.href : null;
  } catch { return null; }
}

function link(parent, doc, label, href) {
  if (href) parent.append(el(doc, "a", label, { href }));
}
function image(doc, label, path, baseURL, attrs = {}) {
  const src = assetURL(path, baseURL, doc);
  if (!src) return null;
  const node = el(doc, "img", undefined, { src, alt: label, loading: "eager", ...attrs });
  node.title = label;
  return node;
}
function rowsOf(manifest) {
  return (manifest.scenarios || []).flatMap((scenario) =>
    (scenario.checkpoints || []).map((checkpoint) => ({ scenario, checkpoint })));
}
function targetOf(scenario, checkpoint) {
  return `#${encodeURIComponent(`${scenario.id}/${checkpoint.id}`)}`;
}
function changeLabel(kind) {
  return ({
    scenario_added: "Scenario added", scenario_removed: "Scenario removed",
    scenario_metadata_changed: "Scenario details changed", checkpoint_added: "Checkpoint added",
    checkpoint_removed: "Checkpoint removed", checkpoint_metadata_changed: "Timeline changed",
    pixels_changed: "Pixels changed", scene_changed: "Scene data changed",
  })[kind] || "Report changed";
}

function renderChanges(root, doc, changes) {
  const section = el(doc, "section");
  section.append(el(doc, "h2", "Baseline changes"));
  if (!changes.length) section.append(el(doc, "p", "No typed changes recorded.", { class: "muted" }));
  else {
    const details = el(doc, "details");
    details.append(el(doc, "summary", `${changes.length} recorded changes`));
    const list = el(doc, "ul");
    for (const change of changes) {
      const item = el(doc, "li");
      item.append(el(doc, "strong", `${changeLabel(change.kind)} · `));
      const removed = change.kind === "checkpoint_removed" || change.kind === "scenario_removed";
      if (removed) item.append(doc.createTextNode(`${change.scenario_id}${change.checkpoint_id ? ` / ${change.checkpoint_id}` : ""} — removed from current captures; no current image is available.`));
      else {
        const target = change.checkpoint_id ? `${change.scenario_id}/${change.checkpoint_id}` : change.scenario_id;
        item.append(el(doc, "a", target, { href: `#${encodeURIComponent(target)}` }));
        item.append(doc.createTextNode(` — ${change.detail || ""}`));
      }
      list.append(item);
    }
    details.append(list); section.append(details);
  }
  root.append(section);
}

function renderGlobalDetails(root, doc, manifest, baseURL) {
  const graph = el(doc, "details");
  graph.append(el(doc, "summary", "Timing graph · expand to inspect the full suite"));
  const p = el(doc, "p");
  link(p, doc, "Open full-size SVG", assetURL("metrics.svg", baseURL, doc));
  graph.append(p);
  const scroll = el(doc, "div", undefined, { class: "graph-scroll" });
  const graphImage = image(doc, "Scenario timing graph", "metrics.svg", baseURL, { loading: "lazy" });
  if (graphImage) scroll.append(graphImage);
  graph.append(scroll); root.append(graph);

  const replay = manifest.native_replay;
  if (replay) {
    const details = el(doc, "details");
    details.append(el(doc, "summary", `Native replay · GPU timestamps ${replay.timestamp_reason ? "unavailable" : "available"}`));
    details.append(el(doc, "p", `Adapter: ${replay.adapter}; driver: ${replay.driver || "n/a"}; backend: ${replay.backend}; device: ${replay.device_type}.`));
    details.append(el(doc, "p", "Native replay is diagnostic; CPU captures determine baseline status. Encode/submit/completion includes CPU encoding, submission, and queue completion. GPU timing is the device timestamp interval."));
    if (replay.timestamp_reason) details.append(el(doc, "p", replay.timestamp_reason));
    const metrics = rowsOf(manifest).map(({ checkpoint }) => checkpoint.native?.metrics).find(Boolean);
    if (metrics) details.append(el(doc, "p", `Tracked allocation: ${metrics.allocation_scope}. Device allocation: ${metrics.device_allocation_scope || metrics.allocation_reason || "unavailable"}.`));
    root.append(details);
  }

  const checks = manifest.platform_checks;
  if (checks) {
    const details = el(doc, "details");
    details.append(el(doc, "summary", `Platform checks · ${checks.status} · ${checks.platform}`));
    const table = el(doc, "table"), body = el(doc, "tbody");
    for (const [name, available] of Object.entries(checks.capabilities || {})) {
      const row = el(doc, "tr");
      row.append(el(doc, "th", name.replaceAll("_", " ")), el(doc, "td", available ? "available" : "unavailable"));
      body.append(row);
    }
    for (const event of checks.events || []) {
      const row = el(doc, "tr");
      row.append(el(doc, "th", event.name), el(doc, "td", `${count(event.polls)} polls · ${count(event.elapsed_ms)} ms`));
      body.append(row);
    }
    table.append(body); details.append(table);
    if (checks.frame) details.append(el(doc, "p", `Frame: ${checks.frame.capture_width}×${checks.frame.capture_height}, ${count(checks.frame.painted_pixels)} painted pixels.`));
    if (checks.resize) details.append(el(doc, "p", `Resize callback: ${checks.resize.callback_count} at ${checks.resize.width}×${checks.resize.height}.`));
    for (const error of checks.errors || []) details.append(el(doc, "p", error, { class: "error" }));
    root.append(details);
  }
}

function checkpointDelta(scenario, index) {
  if (index >= scenario.checkpoints.length - 1) return null;
  const current = scenario.checkpoints[index];
  const next = scenario.checkpoints[index + 1];
  if (scenario.checkpoints.length < 2 || !Number.isSafeInteger(current.time_ns) || !Number.isSafeInteger(next.time_ns)) return null;
  const delta = next.time_ns - current.time_ns;
  return delta > 0 ? delta : null;
}
function stepOnly(scenario) {
  return scenario.checkpoints.some((checkpoint, index, items) => index > 0 &&
    (!Number.isSafeInteger(checkpoint.time_ns) || !Number.isSafeInteger(items[index - 1].time_ns) || checkpoint.time_ns <= items[index - 1].time_ns));
}
function preloadNext(scenario, checkpoint, baseURL, doc) {
  const index = scenario.checkpoints.indexOf(checkpoint);
  const next = scenario.checkpoints[index + 1];
  if (!next) return;
  for (const path of [next.before_png, next.png]) {
    const src = assetURL(path, baseURL, doc);
    if (src) { const preload = new doc.defaultView.Image(); preload.src = src; }
  }
}

function changedCheckpoint(checkpoint) {
  return checkpoint.motion?.difference?.changed_pixels > 0 || checkpoint.pixels_changed === true || (checkpoint.pixels_changed == null &&
    (checkpoint.status === "new" || checkpoint.status === "changed"));
}
function checkpointStatus(checkpoint) {
  return checkpoint.status === "unchanged" && checkpoint.motion?.difference?.changed_pixels > 0
    ? "motion changed" : statusLabel(checkpoint.status);
}
function svgNode(doc, tag, attrs = {}, text) {
  const node = doc.createElementNS("http://www.w3.org/2000/svg", tag);
  for (const [key, value] of Object.entries(attrs)) node.setAttribute(key, String(value));
  if (text !== undefined) node.textContent = text;
  return node;
}
function activatePoint(point, label, selectIndex, index) {
  point.setAttribute("aria-label", label);
  point.addEventListener("click", () => selectIndex(index));
  point.addEventListener("keydown", (event) => {
    if (event.key === "Enter" || event.key === " ") { event.preventDefault(); selectIndex(index); }
  });
}
function differencePercent(difference, key = "changed_pixels") {
  const total = difference?.total_pixels;
  const changed = key === "changed_pixels" ? difference?.changed_pixels : difference?.visible?.changed_pixels;
  return Number.isFinite(total) && total > 0 && Number.isFinite(changed)
    ? Math.max(0, Math.min(100, changed / total * 100)) : null;
}
function renderTrend(doc, scenario, selectedIndex, selectIndex) {
  const checkpoints = scenario.checkpoints || [];
  const data = checkpoints.map((checkpoint) => ({
    exact: checkpoint.pixels_changed === false ? 0 : differencePercent(checkpoint.difference),
    visible: checkpoint.pixels_changed === false ? 0 : differencePercent(checkpoint.difference, "visible"),
    motion: differencePercent(checkpoint.motion?.difference),
  }));
  if (!data.some((point) => point.exact !== null || point.visible !== null || point.motion !== null)) {
    return el(doc, "p", "Per-frame pixel difference statistics are unavailable.", { class: "muted" });
  }
  const width = 720, height = 180, left = 42, right = 12, top = 12, bottom = 30;
  const plotWidth = width - left - right, plotHeight = height - top - bottom;
  const peak = Math.max(0, ...data.flatMap((point) => Object.values(point).filter(Number.isFinite)));
  const magnitude = peak > 0 ? 10 ** Math.floor(Math.log10(peak)) : 1;
  const scale = Math.min(100, [1, 2, 5, 10].map((step) => step * magnitude).find((limit) => limit >= peak) || 100);
  const x = (index) => left + (checkpoints.length <= 1 ? plotWidth / 2 : index * plotWidth / (checkpoints.length - 1));
  const y = (percent) => top + plotHeight * (1 - percent / scale);
  const svg = svgNode(doc, "svg", { class: "frame-trend", viewBox: `0 0 ${width} ${height}`, role: "img", "aria-label": "Per-frame exact and visible error plus transition error as a percentage of image area. Orange diamonds mark timestamp mismatches." });
  svg.append(svgNode(doc, "title", {}, "Pixel difference by checkpoint"));
  svg.append(svgNode(doc, "desc", {}, "Per-frame exact and visible errors plus previous-to-current transition error as a percentage of image area. Timestamp mismatches use an orange diamond."));
  for (const pct of [0, scale / 2, scale]) {
    const py = y(pct);
    svg.append(svgNode(doc, "line", { x1: left, y1: py, x2: width - right, y2: py, class: "trend-grid" }));
    svg.append(svgNode(doc, "text", { x: left - 7, y: py + 4, "text-anchor": "end" }, `${Number(pct.toPrecision(3))}%`));
  }
  for (const [key, className] of [["exact", "trend-exact"], ["visible", "trend-visible"], ["motion", "trend-motion"]]) {
    let segment = [];
    const flush = () => {
      if (segment.length > 1) svg.append(svgNode(doc, "polyline", { points: segment.join(" "), class: className }));
      segment = [];
    };
    data.forEach((point, index) => {
      if (point[key] === null) { flush(); return; }
      segment.push(`${x(index)},${y(point[key])}`);
    });
    flush();
  }
  checkpoints.forEach((checkpoint, index) => {
    const exact = data[index].exact, visible = data[index].visible;
    const motion = data[index].motion;
    const title = `${checkpoint.name}: exact ${exact === null ? "n/a" : `${exact.toFixed(3)}%`}, visible ${visible === null ? "n/a" : `${visible.toFixed(3)}%`}, transition ${motion === null ? "n/a" : `${motion.toFixed(3)}%`}`;
    if (exact !== null) {
      const point = svgNode(doc, "circle", { cx: x(index), cy: y(exact), r: index === selectedIndex ? 5 : 3, class: `trend-point trend-exact-point${index === selectedIndex ? " selected" : ""}`, tabindex: "0", "aria-label": title });
      point.append(svgNode(doc, "title", {}, title)); activatePoint(point, title, selectIndex, index);
      svg.append(point);
    }
    if (visible !== null) {
      const point = svgNode(doc, "circle", { cx: x(index), cy: y(visible), r: index === selectedIndex ? 4 : 2.5, class: `trend-point trend-visible-point${index === selectedIndex ? " selected" : ""}`, tabindex: "0", "aria-label": title });
      point.append(svgNode(doc, "title", {}, title)); activatePoint(point, title, selectIndex, index); svg.append(point);
    }
    if (motion !== null) {
      const point = svgNode(doc, "circle", { cx: x(index), cy: y(motion), r: index === selectedIndex ? 5 : 3, class: `trend-point trend-motion-point${index === selectedIndex ? " selected" : ""}`, tabindex: "0", "aria-label": title });
      point.append(svgNode(doc, "title", {}, title)); activatePoint(point, title, selectIndex, index); svg.append(point);
    }
    if (checkpoint.before_time_ns != null && checkpoint.time_ns != null && checkpoint.before_time_ns !== checkpoint.time_ns) {
      const marker = svgNode(doc, "rect", { x: x(index) - 4, y: top - 6, width: 8, height: 8, transform: `rotate(45 ${x(index)} ${top - 2})`, class: "trend-time-mismatch" });
      marker.append(svgNode(doc, "title", {}, `${checkpoint.name}: baseline/current timestamps differ`)); svg.append(marker);
    }
  });
  const labels = el(doc, "p", undefined, { class: "trend-legend" });
  labels.append(el(doc, "span", "Exact RGBA change", { class: "legend-exact" }), el(doc, "span", "Visible pixel change", { class: "legend-visible" }), el(doc, "span", "Transition error", { class: "legend-motion" }), el(doc, "span", "Timestamp mismatch", { class: "legend-mismatch" }));
  const container = el(doc, "div", undefined, { class: "trend-wrap" });
  container.append(svg, labels);
  return container;
}

const channelError = (value) => Number.isFinite(value) ? Number(value.toPrecision(4)).toString() : "n/a";
function differenceText(label, difference) {
  if (!difference) return "";
  const bounds = difference.bounds
    ? `; exact bounds ${difference.bounds.x},${difference.bounds.y} ${difference.bounds.width}×${difference.bounds.height}` : "";
  const visible = difference.visible
    ? `; visible ${count(difference.visible.changed_pixels)} px, mean/peak ${channelError(difference.visible.mean_channel_error)}/${channelError(difference.visible.max_channel_error)}` : "";
  const hidden = difference.visible && difference.changed_pixels > difference.visible.changed_pixels
    ? "; some exact changes have no visible color or alpha error" : "";
  const zeroVisible = difference.visible && difference.changed_pixels > 0 && difference.visible.mean_channel_error === 0
    ? "; visible mean error is zero despite exact pixel changes" : "";
  const extent = difference.size_changed ? "; image extent changed" : "";
  return `${label}: exact ${count(difference.changed_pixels)}/${count(difference.total_pixels)} px, mean/peak ${channelError(difference.mean_channel_error)}/${channelError(difference.max_channel_error)}${visible}${bounds}${extent}${hidden}${zeroVisible}.`;
}

function renderComparison(doc, scenario, checkpoint, baseURL) {
  const view = doc.defaultView;
  const section = el(doc, "section", undefined, { class: "visual-compare" });
  const currentURL = assetURL(checkpoint.png, baseURL, doc);
  const verifiedEqual = checkpoint.pixels_changed === false;
  const beforePath = checkpoint.before_png || (verifiedEqual ? checkpoint.png : null);
  const beforeURL = assetURL(beforePath, baseURL, doc);
  const hasBaseline = Boolean(beforeURL && currentURL);
  const controls = el(doc, "div", undefined, { class: "compare-controls", role: "group", "aria-label": "Image comparison mode" });
  const stageScroll = el(doc, "div", undefined, { class: "comparison-scroll" });
  const stage = el(doc, "div", undefined, { class: "comparison-stage" });
  const beforeImg = hasBaseline ? image(doc, "Before baseline", beforePath, baseURL, { class: "image-before" }) : null;
  if (beforeImg) stage.append(beforeImg);
  const currentImg = currentURL ? image(doc, "Current capture", checkpoint.png, baseURL, { class: "image-current" }) : null;
  if (currentImg) stage.append(currentImg);
  const diffImg = checkpoint.diff_png ? image(doc, "Exact RGBA differences in red", checkpoint.diff_png, baseURL, { class: "image-diff", hidden: true }) : null;
  if (diffImg) stage.append(diffImg);
  const heatmapImg = checkpoint.heatmap_png ? image(doc, "Visible magnitude heatmap", checkpoint.heatmap_png, baseURL, { class: "image-heatmap", hidden: true }) : null;
  if (heatmapImg) stage.append(heatmapImg);
  const motionImg = checkpoint.motion?.diff_png ? image(doc, "Transition differences in red", checkpoint.motion.diff_png, baseURL, { class: "image-motion", hidden: true }) : null;
  if (motionImg) stage.append(motionImg);
  const motionHeatmapImg = checkpoint.motion?.heatmap_png ? image(doc, "Transition magnitude heatmap", checkpoint.motion.heatmap_png, baseURL, { class: "image-motion-heatmap", hidden: true }) : null;
  if (motionHeatmapImg) stage.append(motionHeatmapImg);
  stageScroll.append(stage);
  const modeButtons = new Map();
  for (const [mode, label] of [["wipe", "Wipe"], ["blink", "Blink"], ["side", "Side by side"], ["diff", "Exact red"], ["heatmap", "Magnitude heatmap"], ["motion", "Transition red"], ["motion-heatmap", "Transition heatmap"]]) {
    const button = el(doc, "button", label, { type: "button", "aria-pressed": "false" });
    button.disabled = mode === "diff" ? !diffImg : mode === "heatmap" ? !heatmapImg :
      mode === "motion" ? !motionImg : mode === "motion-heatmap" ? !motionHeatmapImg : !hasBaseline;
    controls.append(button); modeButtons.set(mode, button);
  }
  const rangeLabel = el(doc, "label", "Wipe divider", { class: "wipe-control" });
  const wipe = el(doc, "input", undefined, { type: "range", min: "0", max: "100", value: "50", "aria-label": "Before/current wipe position" });
  wipe.disabled = !hasBaseline;
  const wipeValue = el(doc, "output", "50% before / 50% current"); rangeLabel.append(wipe, wipeValue);
  const zoom = el(doc, "button", "Actual pixels", { type: "button", "aria-pressed": "false" });
  const focus = el(doc, "button", "Focus changes", { type: "button" });
  const bounds = checkpoint.difference?.bounds || checkpoint.motion?.difference?.bounds;
  focus.disabled = !bounds;
  controls.append(rangeLabel, zoom, focus);
  section.append(controls, stageScroll);
  if (!hasBaseline) section.append(el(doc, "p", "No baseline image is available. Before/current controls are disabled; inspect the current capture and any available difference images.", { class: "muted" }));
  else if (verifiedEqual && !checkpoint.before_png) section.append(el(doc, "p", "Baseline image reused from the current capture because this checkpoint is verified pixel-identical.", { class: "muted" }));
  const dimensions = el(doc, "p", "Before: unavailable · Current: loading…", { class: "image-stats" });
  const stats = el(doc, "p", "", { class: "image-stats" });
  section.append(dimensions, stats);
  const beforeTime = checkpoint.before_time_ns;
  const currentTime = checkpoint.time_ns;
  if (checkpoint.before_png || beforeTime != null || verifiedEqual) {
    const pairing = beforeTime == null
      ? "Baseline timestamp unknown; images are paired by checkpoint ID."
      : beforeTime === currentTime
        ? `Baseline and current captures are timestamped ${ns(currentTime)} ms.`
        : `Paired by checkpoint ID at different times: baseline ${ns(beforeTime)} ms, current ${ns(currentTime)} ms.`;
    section.append(el(doc, "p", pairing, { class: "muted" }));
  }
  const lines = [differenceText("CPU vs baseline", checkpoint.difference), differenceText("Native vs CPU", checkpoint.native?.difference)].filter(Boolean);
  stats.textContent = lines.join(" ");

  let mode = diffImg ? "diff" : motionImg ? "motion" : hasBaseline ? "wipe" : "current";
  let blinkTimer = null;
  let actualPixels = false;
  let disposed = false;
  const updateWipe = () => {
    const value = Number(wipe.value);
    const cutoff = stage.clientWidth * value / 100;
    stage.style.setProperty("--wipe-position", `${value}%`);
    if (mode === "wipe") {
      if (beforeImg) beforeImg.style.clipPath = `inset(0 ${Math.max(0, beforeImg.clientWidth - cutoff)}px 0 0)`;
      if (currentImg) currentImg.style.clipPath = `inset(0 0 0 ${cutoff}px)`;
    }
  };
  const setMode = (next) => {
    mode = next;
    stage.className = `comparison-stage mode-${mode}${actualPixels ? " pixel-zoom" : ""}`;
    for (const [name, button] of modeButtons) button.setAttribute("aria-pressed", String(name === mode));
    rangeLabel.hidden = mode !== "wipe";
    const showingDifference = ["diff", "heatmap", "motion", "motion-heatmap"].includes(mode);
    if (beforeImg) beforeImg.hidden = showingDifference || mode === "current";
    if (currentImg) currentImg.hidden = showingDifference;
    if (diffImg) diffImg.hidden = mode !== "diff";
    if (heatmapImg) heatmapImg.hidden = mode !== "heatmap";
    if (motionImg) motionImg.hidden = mode !== "motion";
    if (motionHeatmapImg) motionHeatmapImg.hidden = mode !== "motion-heatmap";
    if (mode === "side" && beforeImg && currentImg) {
      stage.className = `comparison-stage mode-side${actualPixels ? " pixel-zoom" : ""}`;
      stage.append(beforeImg, currentImg);
    } else if (beforeImg && currentImg && beforeImg.parentNode === stage && currentImg.parentNode === stage) stage.insertBefore(beforeImg, currentImg);
    if (blinkTimer) view.clearInterval(blinkTimer);
    if (mode === "blink") {
      let showCurrent = true;
      blinkTimer = view.setInterval(() => {
        showCurrent = !showCurrent;
        if (beforeImg) beforeImg.hidden = showCurrent;
        if (currentImg) currentImg.hidden = !showCurrent;
      }, 550);
    }
    if (mode !== "wipe") {
      if (beforeImg) beforeImg.style.removeProperty("clip-path");
      if (currentImg) currentImg.style.removeProperty("clip-path");
    }
    updateWipe();
    fitStage();
  };
  modeButtons.forEach((button, name) => button.addEventListener("click", () => setMode(name)));
  wipe.addEventListener("input", () => {
    const value = Number(wipe.value);
    wipeValue.value = `${value}% before / ${100 - value}% current`;
    wipe.setAttribute("aria-valuetext", `Before ${value} percent, current ${100 - value} percent`);
    updateWipe();
  });
  const setZoom = (enabled) => {
    actualPixels = enabled;
    zoom.setAttribute("aria-pressed", String(actualPixels));
    zoom.textContent = actualPixels ? "Fit to panel" : "Actual pixels";
    stage.classList.toggle("pixel-zoom", actualPixels);
    fitStage();
  };
  zoom.addEventListener("click", () => setZoom(!actualPixels));
  focus.addEventListener("click", () => {
    if (!bounds) return;
    if (!["diff", "heatmap", "motion", "motion-heatmap"].includes(mode)) {
      if (diffImg) setMode("diff");
      else if (motionImg) setMode("motion");
    }
    const selectedBounds = mode.startsWith("motion") ? checkpoint.motion?.difference?.bounds || bounds : bounds;
    setZoom(true);
    stageScroll.scrollTo({ left: Math.max(0, selectedBounds.x - 24), top: Math.max(0, selectedBounds.y - 24) });
  });
  const allImages = [beforeImg, currentImg, diffImg, heatmapImg, motionImg, motionHeatmapImg].filter(Boolean);
  const imageSize = (img) => img.complete && img.naturalWidth ? `${img.naturalWidth}×${img.naturalHeight}` : "loading";
  const fitStage = () => {
    if (disposed) return;
    const loaded = allImages.filter((img) => img.complete && img.naturalWidth && img.naturalHeight);
    if (!loaded.length) return;
    const unionWidth = Math.max(...loaded.map((img) => img.naturalWidth));
    const unionHeight = Math.max(...loaded.map((img) => img.naturalHeight));
    const sideBySide = mode === "side" && beforeImg && currentImg;
    const fitWidth = sideBySide ? beforeImg.naturalWidth + currentImg.naturalWidth : unionWidth;
    const availableWidth = stageScroll.clientWidth || doc.documentElement.clientWidth || fitWidth;
    const availableHeight = Math.max(1, view.innerHeight * 0.75);
    const scale = actualPixels ? 1 : Math.min(1, availableWidth / fitWidth, availableHeight / unionHeight);
    stage.style.width = `${fitWidth * scale}px`;
    stage.style.height = `${unionHeight * scale}px`;
    stage.style.aspectRatio = `${fitWidth} / ${unionHeight}`;
    for (const img of allImages) {
      if (!img.complete || !img.naturalWidth || !img.naturalHeight) continue;
      img.style.width = `${img.naturalWidth * scale}px`;
      img.style.height = `${img.naturalHeight * scale}px`;
      img.style.position = sideBySide && (img === beforeImg || img === currentImg) ? "relative" : "absolute";
      img.style.left = "0"; img.style.top = "0";
    }
    dimensions.textContent = `Before: ${beforeImg ? imageSize(beforeImg) : "unavailable"} px · Current: ${currentImg ? imageSize(currentImg) : "unavailable"} px`;
    updateWipe();
  };
  for (const img of allImages) {
    img.addEventListener("load", fitStage);
    img.addEventListener("error", () => {
      if (img === currentImg) dimensions.textContent = "Before: unavailable · Current: image could not be loaded.";
      else fitStage();
    });
  }
  const onResize = () => fitStage();
  view.addEventListener("resize", onResize);
  if (allImages.some((img) => img.complete && img.naturalWidth)) fitStage();
  setMode(mode);
  preloadNext(scenario, checkpoint, baseURL, doc);
  return { element: section, layout: fitStage, cleanup: () => { disposed = true; if (blinkTimer) view.clearInterval(blinkTimer); view.removeEventListener("resize", onResize); } };
}

function renderSelected(root, doc, selected, baseURL, playback, selectIndex) {
  root.replaceChildren();
  if (!selected) { root.append(el(doc, "p", "Choose a checkpoint from the timing table.")); return; }
  const { scenario, checkpoint } = selected;
  const index = scenario.checkpoints.indexOf(checkpoint);
  const panel = el(doc, "section", undefined, { class: "checkpoint-panel" });
  panel.append(el(doc, "h2", `${scenario.title} · ${checkpoint.name}`));
  const scene = assetURL(checkpoint.scene_json, baseURL, doc), sceneLink = el(doc, "p");
  link(sceneLink, doc, checkpoint.scene_json.endsWith(".gz") ? "Captured scene JSON (gzip)" : "Captured scene JSON", scene);
  panel.append(sceneLink);
  const timeline = el(doc, "nav", undefined, { class: "timeline", "aria-label": "Checkpoint timeline" });
  for (const item of scenario.checkpoints || []) timeline.append(el(doc, "a", item.name, {
    href: `#${encodeURIComponent(`${scenario.id}/${item.id}`)}`, class: "chip",
    "aria-current": item.id === checkpoint.id ? "true" : "false",
  }));
  panel.append(timeline);

  const scrub = el(doc, "div", undefined, { class: "frame-scrubber" });
  const scrubLabel = el(doc, "label", "Frame");
  const slider = el(doc, "input", undefined, { type: "range", min: "0", max: String(Math.max(0, scenario.checkpoints.length - 1)), step: "1", value: String(index) });
  const stamp = checkpoint.time_ns == null ? "time n/a" : `${ns(checkpoint.time_ns)} ms`;
  const frameStatus = `${checkpoint.name} · ${stamp} · ${checkpointStatus(checkpoint)}`;
  const scrubOutput = el(doc, "output", frameStatus, { "aria-live": "polite" });
  slider.setAttribute("aria-label", "Select checkpoint frame");
  slider.setAttribute("aria-valuetext", frameStatus);
  scrubLabel.append(slider); scrub.append(scrubLabel, scrubOutput); panel.append(scrub);
  slider.addEventListener("input", () => {
    const target = scenario.checkpoints[Number(slider.value)];
    if (!target) return;
    const time = target.time_ns == null ? "time n/a" : `${ns(target.time_ns)} ms`;
    const label = `${target.name} · ${time} · ${checkpointStatus(target)}`;
    scrubOutput.value = label; scrubOutput.textContent = label; slider.setAttribute("aria-valuetext", label);
  });
  slider.addEventListener("change", () => selectIndex(Number(slider.value)));

  const playbackBar = el(doc, "div", undefined, { class: "playback-controls", role: "group", "aria-label": "Checkpoint playback" });
  const previous = el(doc, "button", "Previous frame", { type: "button" });
  const next = el(doc, "button", "Next frame", { type: "button" });
  const changed = scenario.checkpoints.map((frame, frameIndex) => changedCheckpoint(frame) ? frameIndex : -1).filter((frameIndex) => frameIndex >= 0);
  const previousChangedIndex = changed.filter((frameIndex) => frameIndex < index).at(-1);
  const nextChangedIndex = changed.find((frameIndex) => frameIndex > index);
  const previousChanged = el(doc, "button", "Previous changed frame", { type: "button" });
  const nextChanged = el(doc, "button", "Next changed frame", { type: "button" });
  previousChanged.disabled = previousChangedIndex === undefined; nextChanged.disabled = nextChangedIndex === undefined;
  const equalTimes = stepOnly(scenario);
  const idleLabel = equalTimes ? "Step next · timestamps need steps" : index === scenario.checkpoints.length - 1 ? "Replay timeline" : "Play timeline";
  const play = el(doc, "button", playback.playing ? "Pause timeline" : idleLabel, { type: "button", "data-idle-label": idleLabel });
  previous.disabled = index <= 0; next.disabled = index >= scenario.checkpoints.length - 1;
  play.disabled = scenario.checkpoints.length < 2 || (equalTimes && index === scenario.checkpoints.length - 1);
  const delta = checkpointDelta(scenario, index);
  const playbackLabel = equalTimes
    ? "Timestamps are equal, descending, or unavailable; use explicit step controls."
    : `Capture time ${ns(checkpoint.time_ns)} ms${delta === null ? "" : ` · next frame after ${ns(delta)} ms`}.`;
  playbackBar.append(previous, next, previousChanged, nextChanged, play, el(doc, "span", playbackLabel, { class: "playback-label", "aria-live": "polite" }));
  panel.append(playbackBar);
  playback.button = play;
  previous.addEventListener("click", () => { playback.pause(); selectIndex(index - 1); });
  next.addEventListener("click", () => { playback.pause(); selectIndex(index + 1); });
  previousChanged.addEventListener("click", () => { playback.pause(); selectIndex(previousChangedIndex); });
  nextChanged.addEventListener("click", () => { playback.pause(); selectIndex(nextChangedIndex); });
  play.addEventListener("click", () => {
    if (equalTimes) selectIndex(index + 1);
    else if (playback.playing) playback.pause();
    else playback.play();
  });

  const trend = el(doc, "section", undefined, { class: "frame-trend-section" });
  trend.append(el(doc, "h3", "Frame error trend"), renderTrend(doc, scenario, index, (frameIndex) => { playback.pause(); selectIndex(frameIndex); }));
  panel.append(trend);

  if (checkpoint.motion) {
    const motion = checkpoint.motion, difference = motion.difference;
    const transition = el(doc, "section", undefined, { class: "motion-summary" });
    transition.append(el(doc, "h3", "Transition error · previous frame → current frame"));
    const previous = scenario.checkpoints.find((frame) => frame.id === motion.previous_checkpoint_id);
    const previousLink = el(doc, "p", "Previous checkpoint: ");
    link(previousLink, doc, motion.previous_checkpoint_id, previous ? targetOf(scenario, previous) : null);
    transition.append(previousLink);
    const percentage = difference.total_pixels > 0 ? (100 * difference.changed_pixels / difference.total_pixels).toFixed(3) : "n/a";
    const bounds = difference.bounds ? ` · bounds ${difference.bounds.x},${difference.bounds.y} ${difference.bounds.width}×${difference.bounds.height}` : "";
    transition.append(el(doc, "p", `${count(difference.changed_pixels)}/${count(difference.total_pixels)} pixels · ${percentage}% transition error · color/alpha/extent mean/peak ${channelError(difference.mean_channel_error)}/${channelError(difference.max_channel_error)}${bounds}.`));
    const durationText = (label, duration) => `${label}: ${duration == null ? "n/a (missing or non-monotonic timestamps)" : `${ns(duration)} ms`}`;
    transition.append(el(doc, "p", `${durationText("Baseline elapsed", motion.before_duration_ns)} · ${durationText("Current elapsed", motion.current_duration_ns)}`, { class: "muted" }));
    panel.append(transition);
  }

  const comparison = renderComparison(doc, scenario, checkpoint, baseURL);
  panel.append(comparison.element);
  const metrics = checkpoint.metrics || {};
  panel.append(el(doc, "p", `Status: ${checkpointStatus(checkpoint)} · ${count(metrics.frame_count)} samples · build p50/p95/p99 ${ns(metrics.scene_build_p50_ns)}/${ns(metrics.scene_build_p95_ns)}/${ns(metrics.scene_build_p99_ns)} ms · CPU p50/p95/p99 ${ns(metrics.cpu_render_p50_ns)}/${ns(metrics.cpu_render_p95_ns)}/${ns(metrics.cpu_render_p99_ns)} ms · ${count(metrics.primitive_count)} primitives · ${count(metrics.batch_count)} batches · ${count(metrics.bitmap_storage_bytes)} bitmap bytes.`));
  if (checkpoint.native) {
    const details = el(doc, "details"), native = checkpoint.native, nativeMetrics = native.metrics || {}, gpu = nativeMetrics.gpu || {};
    details.append(el(doc, "summary", `Native diagnostic · encode/submit p50 ${ns(nativeMetrics.encode_submit_completion?.p50_ns)} ms · GPU p50 ${ns(gpu.p50_ns)} ms · ${count(native.difference?.changed_pixels)} CPU/native differing pixels`));
    details.append(el(doc, "p", `Tracked owned memory: ${count(nativeMetrics.tracked_owned_bytes)} bytes (${nativeMetrics.allocation_scope}). Device allocation: ${count(nativeMetrics.device_allocated_bytes)} bytes (${nativeMetrics.device_allocation_scope || nativeMetrics.allocation_reason || "unavailable"}).`));
    const images = el(doc, "div", undefined, { class: "comparison" });
    for (const [label, path] of [["Native GPU replay", native.png], ["Native minus CPU · exact RGBA changes", native.diff_png], ["Native minus CPU · visible magnitude heatmap", native.heatmap_png]]) {
      const img = image(doc, label, path, baseURL, { loading: "lazy" }); if (img) { const figure = el(doc, "figure"); figure.append(el(doc, "figcaption", label), img); images.append(figure); }
    }
    details.append(images); panel.append(details);
  }
  root.append(panel);
  comparison.layout();
  return comparison.cleanup;
}

/** Render a validated report. Returns a disposer for web-site mount/unmount use. */
export function renderReport(root, manifest, { baseURL = "", useHash = false } = {}) {
  const doc = root.ownerDocument, view = doc.defaultView;
  const hadReportClass = root.classList.contains("gpui-report");
  root.classList.add("gpui-report");
  const scenarios = manifest.scenarios || [], rows = rowsOf(manifest), changes = manifest.changes || [];
  const playback = { playing: false, advancing: false, timer: null, button: null, pause() { this.playing = false; this.advancing = false; view.clearTimeout(this.timer); this.timer = null; if (this.button) this.button.textContent = this.button.dataset.idleLabel; } };
  let selected = rows[0] || null, panelCleanup = null, disposed = false;
  root.replaceChildren();
  const summary = el(doc, "p", undefined, { class: "summary", "aria-label": "Report summary" });
  const statuses = rows.map(({ checkpoint }) => checkpointStatus(checkpoint));
  for (const value of [`${scenarios.length} scenarios`, `${rows.length} checkpoints`, `${statuses.filter((s) => s === "changed" || s === "motion changed").length} changed`, `${statuses.filter((s) => s === "new").length} new`, `${changes.length} baseline changes`]) summary.append(el(doc, "span", value));
  root.append(summary); renderChanges(root, doc, changes); renderGlobalDetails(root, doc, manifest, baseURL);

  const search = el(doc, "input", undefined, { type: "search", placeholder: "Search scenarios or checkpoints", "aria-label": "Search scenarios or checkpoints" });
  const statusSelect = el(doc, "select", undefined, { "aria-label": "Filter by status" });
  for (const [value, label] of [["all", "All statuses"], ["changed", "Changed"], ["new", "New"], ["unchanged", "Unchanged"], ["baseline_unavailable", "No baseline"]]) statusSelect.append(el(doc, "option", label, { value }));
  const filter = el(doc, "div", undefined, { class: "controls" });
  filter.append(search, statusSelect); root.append(filter);

  const selectedRoot = el(doc, "div", undefined, { class: "selected-view" }); root.append(selectedRoot);
  const tableWrap = el(doc, "div", undefined, { class: "table-wrap" });
  const table = el(doc, "table"), head = el(doc, "thead"), header = el(doc, "tr"), body = el(doc, "tbody");
  for (const label of ["Scenario / checkpoint", "Status", "Build p50 / p95 / p99 ms", "CPU p50 / p95 / p99 ms"]) header.append(el(doc, "th", label, { scope: "col" }));
  head.append(header); table.append(head, body); tableWrap.append(table); root.append(tableWrap);
  const selectIndex = (index) => {
    if (index < 0 || !selected || index >= selected.scenario.checkpoints.length) return;
    if (useHash) view.location.hash = encodeURIComponent(`${selected.scenario.id}/${selected.scenario.checkpoints[index].id}`);
    else { selected = { scenario: selected.scenario, checkpoint: selected.scenario.checkpoints[index] }; onHash(); }
  };
  const findHashSelection = () => {
    let hash = "";
    try { hash = decodeURIComponent(view.location.hash.slice(1)); } catch { /* Keep the current selection for a malformed fragment. */ }
    const [scenarioId, checkpointId] = hash.split("/");
    return rows.find(({ scenario, checkpoint }) => scenario.id === scenarioId && (!checkpointId || checkpoint.id === checkpointId)) || selected;
  };
  const drawSelection = () => {
    if (useHash) selected = findHashSelection();
    if (panelCleanup) panelCleanup();
    panelCleanup = renderSelected(selectedRoot, doc, selected, baseURL, playback, selectIndex);
  };
  const updateTable = () => {
    body.replaceChildren();
    const query = search.value.trim().toLocaleLowerCase();
    for (const { scenario, checkpoint } of rows) {
      const status = checkpoint.status || scenario.status;
      const label = `${scenario.title} ${scenario.id} ${checkpoint.name} ${checkpoint.id}`.toLocaleLowerCase();
      const motionChanged = checkpoint.motion?.difference?.changed_pixels > 0;
      const matchesStatus = statusSelect.value === "all" || (statusSelect.value === "changed" ? status === "changed" || motionChanged : status === statusSelect.value && !motionChanged);
      if ((query && !label.includes(query)) || !matchesStatus) continue;
      const m = checkpoint.metrics || {}, row = el(doc, "tr"), item = el(doc, "td");
      item.append(el(doc, "a", `${scenario.title} / ${checkpoint.name}`, { href: targetOf(scenario, checkpoint) }));
      row.append(item, el(doc, "td", checkpointStatus(checkpoint)));
      row.append(el(doc, "td", [m.scene_build_p50_ns, m.scene_build_p95_ns, m.scene_build_p99_ns].map(ns).join(" / ")));
      row.append(el(doc, "td", [m.cpu_render_p50_ns, m.cpu_render_p95_ns, m.cpu_render_p99_ns].map(ns).join(" / ")));
      body.append(row);
    }
  };
  const onHash = () => {
    const automatic = playback.advancing;
    playback.advancing = false;
    if (playback.playing && !automatic) playback.pause();
    drawSelection();
    if (automatic && playback.playing) {
      const index = selected.scenario.checkpoints.indexOf(selected.checkpoint);
      if (index === selected.scenario.checkpoints.length - 1) playback.pause();
      else play();
    }
  };
  const onLocalLink = (event) => {
    const anchor = event.target.closest?.("a[href^='#']");
    if (!anchor || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
    const [scenarioId, checkpointId] = decodeURIComponent(anchor.getAttribute("href").slice(1)).split("/");
    const row = rows.find(({ scenario, checkpoint }) => scenario.id === scenarioId && (!checkpointId || checkpoint.id === checkpointId));
    if (!row) return;
    event.preventDefault(); selected = row; onHash();
  };
  search.addEventListener("input", updateTable); statusSelect.addEventListener("change", updateTable);
  if (useHash) view.addEventListener("hashchange", onHash);
  else root.addEventListener("click", onLocalLink);
  const play = () => {
    if (!selected || disposed) return;
    const scenario = selected.scenario, index = scenario.checkpoints.indexOf(selected.checkpoint);
    if (stepOnly(scenario)) { playback.pause(); return; }
    if (index >= scenario.checkpoints.length - 1) {
      playback.playing = true; playback.advancing = true; selectIndex(0); return;
    }
    const delta = checkpointDelta(scenario, index);
    if (delta === null) { playback.pause(); return; }
    view.clearTimeout(playback.timer);
    playback.playing = true;
    if (playback.button) playback.button.textContent = "Pause timeline";
    playback.timer = view.setTimeout(() => {
      if (!playback.playing || disposed) return;
      playback.advancing = true;
      selectIndex(index + 1);
    }, Math.max(1, delta / 1e6));
  };
  playback.play = play;
  updateTable(); drawSelection();
  return () => {
    if (disposed) return;
    disposed = true; playback.pause(); if (panelCleanup) panelCleanup();
    view.removeEventListener("hashchange", onHash); root.replaceChildren();
    root.removeEventListener("click", onLocalLink);
    if (!hadReportClass) root.classList.remove("gpui-report");
  };
}
