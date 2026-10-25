import "./runtime.js";

// Begin loading while the GPUI frontend initializes. Evaluation reports any
// startup error and can retry; preloading never creates an interpreter session.
void globalThis.gpuiCodepenMiri.preload().catch(() => {});
