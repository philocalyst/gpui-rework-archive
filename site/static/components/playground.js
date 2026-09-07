// <gpui-playground>: an editable GPUI exhibit.
//
// The result is GPUI itself, compiled to WebAssembly, drawing in an iframe.
// The source panel is a textarea laid over a highlighted mirror (the approach
// David Bushell settled on for his text-editor experiments: the textarea keeps
// selection, IME and accessibility; the mirror carries colour). Edits are sent
// to the live compiler, which runs the real Rust toolchain and answers with a
// fresh bundle or with rustc's diagnostics.

const KEYWORDS = new Set("as break const continue crate else enum extern false fn for if impl in let loop match mod move mut pub ref return self Self static struct super trait true type unsafe use where while dyn async await try".split(" "));
const TYPES = /^(?:[iu](?:8|16|32|64|128|size)|f32|f64|bool|char|str|String|Option|Result|Vec|Box|Rc|Arc|Self)$/;

const escape = (text) => text.replace(/[&<>]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;" })[c]);

/** Tokenise Rust source into Giallo's class vocabulary, one <span class="line"> per line. */
export function highlight(source, marks = new Map()) {
  const out = [];
  let i = 0, line = 1, buffer = "";
  const flush = () => {
    const mark = marks.get(line);
    out.push(`<span class="line"${mark ? ` data-level="${mark}"` : ""}>${buffer || " "}</span>`);
    buffer = "";
    line += 1;
  };
  const emit = (text, cls) => {
    const parts = text.split("\n");
    parts.forEach((part, index) => {
      if (part) buffer += cls ? `<span class="${cls}">${escape(part)}</span>` : escape(part);
      if (index < parts.length - 1) flush();
    });
  };
  const rest = () => source.slice(i);
  while (i < source.length) {
    const s = rest();
    let m;
    if ((m = /^\/\/[^\n]*/.exec(s))) { emit(m[0], "z-4"); i += m[0].length; continue; }
    if ((m = /^\/\*[\s\S]*?\*\//.exec(s))) { emit(m[0], "z-4"); i += m[0].length; continue; }
    if ((m = /^b?r#*"[\s\S]*?"#*/.exec(s))) { emit(m[0], "z-2"); i += m[0].length; continue; }
    if ((m = /^b?"(?:\\[\s\S]|[^"\\])*"/.exec(s))) { emit(m[0], "z-2"); i += m[0].length; continue; }
    if ((m = /^b?'(?:\\[\s\S]|[^'\\])'/.exec(s))) { emit(m[0], "z-2"); i += m[0].length; continue; }
    if ((m = /^'[A-Za-z_][A-Za-z0-9_]*/.exec(s))) { emit(m[0], "z-9"); i += m[0].length; continue; }
    if ((m = /^#!?\[[^\]\n]*\]/.exec(s))) { emit(m[0], "z-9"); i += m[0].length; continue; }
    if ((m = /^(?:0x[0-9A-Fa-f_]+|0b[01_]+|0o[0-7_]+|\d[\d_]*(?:\.\d[\d_]*)?(?:[eE][+-]?\d+)?|\d[\d_]*\.(?![.a-zA-Z_]))(?:[iuf](?:8|16|32|64|128|size))?/.exec(s))) { emit(m[0], "z-1"); i += m[0].length; continue; }
    if ((m = /^[A-Za-z_][A-Za-z0-9_]*!/.exec(s))) { emit(m[0], "z-9"); i += m[0].length; continue; }
    if ((m = /^[A-Za-z_][A-Za-z0-9_]*/.exec(s))) {
      const word = m[0];
      const next = s.slice(word.length).match(/^\s*(::|\()?/)?.[1];
      let cls = null;
      if (KEYWORDS.has(word)) cls = word === "self" || word === "Self" || word === "true" || word === "false" ? "z-1" : "z-8";
      else if (/^[A-Z][A-Z0-9_]+$/.test(word) && word.length > 1) cls = "z-1";
      else if (TYPES.test(word) || /^[A-Z]/.test(word)) cls = "z-6 z-b";
      else if (next === "(") cls = "z-6";
      emit(word, cls); i += word.length; continue;
    }
    if ((m = /^(?:::|->|=>|\.\.=?|[-+*\/%&|^!=<>]=|&&|\|\||<<|>>|[-+*\/%&|^!=<>.?@])/.exec(s))) { emit(m[0], "z-8"); i += m[0].length; continue; }
    if ((m = /^\s+/.exec(s))) { emit(m[0], null); i += m[0].length; continue; }
    emit(s[0], null); i += 1;
  }
  flush();
  return out.join("");
}

const LOCAL = /^(localhost|127\.0\.0\.1|\[::1\])$/;
const runtimeLabel = { pending: "Loading GPUI…", ready: "GPUI · WebAssembly · GPU", live: "Live build · GPUI · GPU", error: "Renderer unavailable" };

class GpuiPlayground extends HTMLElement {
  #frame; #input; #view; #status; #report; #runtime; #compile; #reset; #diagnostics;
  #original; #committedSrc; #compiler = null; #timer = 0; #lastBuilt = ""; #marks = new Map(); #onMessage; #onKey;

  connectedCallback() {
    if (this.dataset.ready) return;
    this.#frame = this.querySelector("iframe[data-gpui]");
    this.#input = this.querySelector("[data-source]");
    this.#view = this.querySelector(".editor__view");
    this.#status = this.querySelector("[data-status]");
    this.#report = this.querySelector("[data-report]");
    this.#runtime = this.querySelector("[data-runtime]");
    this.#compile = this.querySelector("[data-compile]");
    this.#reset = this.querySelector("[data-reset-source]");
    this.#diagnostics = this.querySelector("[data-diagnostics]");
    this.#original = this.#input.value;
    this.#committedSrc = this.#frame.getAttribute("src");
    this.dataset.renderer = "pending";

    this.#wireModes();
    this.#wireEditor();
    this.#wireFrame();
    this.dataset.ready = "true";
    this.#render();
    this.#discoverCompiler();
  }

  disconnectedCallback() {
    window.removeEventListener("message", this.#onMessage);
    document.removeEventListener("keydown", this.#onKey);
  }

  // ----- modes -----------------------------------------------------------
  #wireModes() {
    const buttons = [...this.querySelectorAll("[data-view]")];
    const expand = this.querySelector("[data-expand]");
    const select = (mode) => {
      this.dataset.mode = mode;
      buttons.forEach((button) => button.setAttribute("aria-pressed", String(button.dataset.view === mode)));
      this.querySelector("[data-panel=result]").hidden = mode === "source";
      this.querySelector("[data-panel=source]").hidden = mode === "result";
      if (mode !== "result") this.#syncScroll();
    };
    buttons.forEach((button, index) => {
      button.disabled = false;
      button.addEventListener("click", () => select(button.dataset.view));
      button.addEventListener("keydown", (event) => {
        if (event.key !== "ArrowLeft" && event.key !== "ArrowRight") return;
        event.preventDefault();
        buttons[(index + (event.key === "ArrowRight" ? 1 : -1) + buttons.length) % buttons.length].focus();
      });
    });
    const setExpanded = (on) => {
      const apply = () => {
        this.toggleAttribute("data-expanded", on);
        expand.setAttribute("aria-pressed", String(on));
        expand.setAttribute("aria-label", on ? "Collapse exhibit" : "Expand exhibit");
        expand.textContent = on ? "⤡" : "⤢";
        select(on ? (innerWidth >= 820 ? "split" : "source") : "result");
        if (on) this.#input.focus({ preventScroll: true });
      };
      if (document.startViewTransition && !matchMedia("(prefers-reduced-motion: reduce)").matches) document.startViewTransition(apply);
      else apply();
    };
    expand.disabled = false;
    expand.addEventListener("click", () => setExpanded(!this.hasAttribute("data-expanded")));
    this.#onKey = (event) => { if (event.key === "Escape" && this.hasAttribute("data-expanded")) setExpanded(false); };
    document.addEventListener("keydown", this.#onKey);
    select("result");
  }

  // ----- editor ----------------------------------------------------------
  #wireEditor() {
    const input = this.#input;
    input.addEventListener("input", () => { this.#marks.clear(); this.#render(); this.#scheduleCompile(); });
    input.addEventListener("scroll", () => this.#syncScroll(), { passive: true });
    input.addEventListener("keydown", (event) => {
      if ((event.metaKey || event.ctrlKey) && event.key === "Enter") { event.preventDefault(); this.#compileNow(); return; }
      if (event.key === "Tab") {
        event.preventDefault();
        const { selectionStart: start, selectionEnd: end, value } = input;
        const lineStart = value.lastIndexOf("\n", start - 1) + 1;
        if (event.shiftKey) {
          const removed = /^ {1,4}/.exec(value.slice(lineStart))?.[0].length ?? 0;
          if (removed) { input.setRangeText("", lineStart, lineStart + removed, "preserve"); input.setSelectionRange(Math.max(lineStart, start - removed), Math.max(lineStart, end - removed)); }
        } else input.setRangeText("    ", start, end, "end");
        input.dispatchEvent(new Event("input"));
        return;
      }
      if (event.key === "Enter" && !event.shiftKey) {
        event.preventDefault();
        const { selectionStart: start, value } = input;
        const lineStart = value.lastIndexOf("\n", start - 1) + 1;
        const indent = /^[ \t]*/.exec(value.slice(lineStart))[0];
        const before = value.slice(lineStart, start).trimEnd();
        const opens = /[({[]$/.test(before);
        const closesNext = /^[)}\]]/.test(value.slice(start).trimStart()) && opens;
        const insert = "\n" + indent + (opens ? "    " : "") + (closesNext ? "\n" + indent : "");
        input.setRangeText(insert, start, input.selectionEnd, "end");
        if (closesNext) input.setSelectionRange(start + 1 + indent.length + 4, start + 1 + indent.length + 4);
        input.dispatchEvent(new Event("input"));
      }
    });
    this.#reset.disabled = false;
    this.#reset.addEventListener("click", () => {
      input.value = this.#original;
      this.#marks.clear();
      this.#render();
      this.#frame.setAttribute("src", this.#committedSrc);
      this.dataset.renderer = "pending";
      this.#setStatus(this.#compiler ? "Restored the committed exhibit" : "Restored", this.#compiler ? "ready" : "offline");
      this.#lastBuilt = "";
    });
    this.#compile.addEventListener("click", () => this.#compileNow());
  }

  #render() {
    this.#view.innerHTML = highlight(this.#input.value, this.#marks);
    this.#syncScroll();
  }

  #syncScroll() {
    this.#view.scrollTop = this.#input.scrollTop;
    this.#view.scrollLeft = this.#input.scrollLeft;
  }

  // ----- renderer frame --------------------------------------------------
  #wireFrame() {
    this.#onMessage = (event) => {
      if (event.source !== this.#frame.contentWindow || typeof event.data !== "string") return;
      const match = /^gpui-exhibit:([a-z_]+):([\s\S]*)$/.exec(event.data);
      if (!match) return;
      const [, key, value] = match;
      const live = this.#frame.getAttribute("src") !== this.#committedSrc;
      if (key === "ready") {
        this.dataset.renderer = live ? "live" : "ready";
        this.#runtime.textContent = runtimeLabel[live ? "live" : "ready"];
        this.#report.value = "first frame drawn";
        this.#report.textContent = "first frame drawn";
        return;
      }
      this.#report.value = `${key} = ${value}`;
      this.#report.textContent = `${key} = ${value}`;
      this.dataset.lastReport = `${key}:${value}`;
    };
    window.addEventListener("message", this.#onMessage);
    this.#frame.addEventListener("error", () => { this.dataset.renderer = "error"; this.#runtime.textContent = runtimeLabel.error; });
  }

  // ----- compiler --------------------------------------------------------
  async #discoverCompiler() {
    const params = new URLSearchParams(location.search);
    if (params.has("compiler")) { try { localStorage.setItem("gpui-compiler", params.get("compiler")); } catch {} }
    let stored = null;
    try { stored = localStorage.getItem("gpui-compiler"); } catch {}
    const configured = this.dataset.compiler || document.querySelector('meta[name="gpui-compiler"]')?.content || "";
    const base = stored || configured || (LOCAL.test(location.hostname) ? "http://127.0.0.1:1117" : "");
    if (!base) return this.#offline();
    try {
      const controller = new AbortController();
      const timer = setTimeout(() => controller.abort(), 2500);
      const response = await fetch(`${base.replace(/\/$/, "")}/status`, { signal: controller.signal });
      clearTimeout(timer);
      if (!response.ok) throw new Error(String(response.status));
      this.#compiler = base.replace(/\/$/, "");
      this.#compile.disabled = false;
      this.#setStatus("Compiler ready · edit, then ⌘↵", "ready");
    } catch {
      this.#offline();
    }
  }

  #offline() {
    this.#compiler = null;
    this.#compile.disabled = true;
    this.#setStatus("Compiler offline · run `just site-live` to make edits build", "offline");
  }

  #scheduleCompile() {
    if (!this.#compiler || this.dataset.autocompile === "false") return;
    clearTimeout(this.#timer);
    this.#timer = setTimeout(() => this.#compileNow(), 1400);
  }

  async #compileNow() {
    if (!this.#compiler) return this.#setStatus("No compiler reachable. Start one with `just site-live`.", "offline");
    const source = this.#input.value;
    if (source === this.#lastBuilt) return;
    clearTimeout(this.#timer);
    this.#setStatus("Compiling with rustc", "busy");
    const started = performance.now();
    try {
      const response = await fetch(`${this.#compiler}/compile`, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ source }) });
      const result = await response.json();
      if (!response.ok) throw Object.assign(new Error(result.error || "Compilation failed"), { result });
      this.#lastBuilt = source;
      this.#marks = new Map((result.warnings || []).filter((w) => w.line).map((w) => [w.line, "warning"]));
      this.#render();
      this.#showDiagnostics(result.warnings || []);
      const seconds = result.cached ? "cached" : `${((performance.now() - started) / 1000).toFixed(1)}s`;
      this.dataset.renderer = "pending";
      this.#runtime.textContent = "Loading live build…";
      this.#frame.setAttribute("src", `${this.#compiler}${result.url}`);
      this.#setStatus(`Built in ${seconds} · GPUI redrawing`, "ok");
    } catch (error) {
      const diagnostics = error.result?.diagnostics || [];
      this.#marks = new Map(diagnostics.filter((d) => d.line).map((d) => [d.line, d.level]));
      this.#render();
      this.#showDiagnostics(diagnostics, error.result?.log);
      const first = diagnostics.find((d) => d.level === "error");
      this.#setStatus(first ? `Error on line ${first.line}: ${first.message}` : (error.result ? error.message : "Compiler unreachable"), "error");
      if (!error.result) this.#offline();
    }
  }

  #showDiagnostics(list, log = "") {
    const pre = this.#diagnostics.querySelector("pre");
    if (!list.length && !log) { this.#diagnostics.hidden = true; pre.textContent = ""; return; }
    pre.innerHTML = list.map((d) => `<span class="diag-${d.level}">${d.level}</span>${d.line ? ` <span class="diag-loc">example.rs:${d.line}:${d.column ?? 1}</span>` : ""}: ${escape(d.message)}`).join("\n") + (log ? `\n\n${escape(log)}` : "");
    this.#diagnostics.hidden = false;
    this.#diagnostics.open = list.some((d) => d.level === "error");
  }

  #setStatus(text, state) {
    this.dataset.compile = state;
    this.#status.value = text;
    this.#status.textContent = text;
  }
}

if (!customElements.get("gpui-playground")) customElements.define("gpui-playground", GpuiPlayground);
