import { gpuiWasm } from "./wasm-runtime.js";

const states = ["Idle", "Hovered", "Pressed", "Activated"];

class GpuiPlayground extends HTMLElement {
  #wasm;
  #messageHandler;

  async connectedCallback() {
    if (this.dataset.ready) return;
    this.dataset.ready = "pending";
    if (this.dataset.example === "counter") this.dataset.renderer = "pending";
    this.#wirePanels();
    if (this.dataset.example === "counter") this.#counter();

    try {
      this.#wasm = await gpuiWasm;
      this.dataset.ready = "true";
      if (this.dataset.example !== "counter") {
        this.querySelector("[data-runtime]")?.replaceChildren("Rust · WebAssembly");
        this.#wireExample();
        this.querySelectorAll("[data-panel=result] :disabled").forEach((control) => { control.disabled = false; });
      }
    } catch (error) {
      this.dataset.ready = "false";
      this.querySelector("[data-runtime]")?.replaceChildren("Static preview");
      console.error("The GPUI example runtime could not start", error);
    }
  }

  disconnectedCallback() {
    if (this.#messageHandler) window.removeEventListener("message", this.#messageHandler);
  }

  #wirePanels() {
    const controls = [...this.querySelectorAll("nav [data-view]")];
    const panels = [...this.querySelectorAll("[data-panel]")];
    const select = (name) => {
      controls.forEach((button) => button.setAttribute("aria-pressed", String(button.dataset.view === name)));
      panels.forEach((panel) => { panel.hidden = panel.dataset.panel !== name; });
    };

    controls.forEach((button, index) => {
      button.disabled = false;
      button.addEventListener("click", () => select(button.dataset.view));
      button.addEventListener("keydown", (event) => {
        if (event.key !== "ArrowLeft" && event.key !== "ArrowRight") return;
        event.preventDefault();
        const direction = event.key === "ArrowRight" ? 1 : -1;
        controls[(index + direction + controls.length) % controls.length].focus();
      });
    });
    select("result");
  }

  #wireExample() {
    if (this.dataset.example === "layout") this.#layout();
    if (this.dataset.example === "interaction") this.#interaction();
  }

  #counter() {
    const frame = this.querySelector("iframe[data-gpui]");
    if (frame) {
      const output = this.querySelector("[data-count]");
      const controls = [...this.querySelectorAll("[data-counter-controls] button")];
      const send = (message) => frame.contentWindow?.postMessage(message, "*");
      this.#messageHandler = (event) => {
        if (event.source !== frame.contentWindow || typeof event.data !== "string") return;
        const match = /^gpui-counter:(ready|count):(-?\d+)$/.exec(event.data);
        if (!match) return;
        output.value = match[2];
        output.textContent = match[2];
        controls.forEach((control) => { control.disabled = false; });
        this.dataset.renderer = "ready";
        this.querySelector("[data-runtime]")?.replaceChildren("GPUI · WebAssembly");
      };
      window.addEventListener("message", this.#messageHandler);
      frame.addEventListener("error", () => { this.dataset.renderer = "error"; });
      this.querySelectorAll("[data-delta]").forEach((button) => {
        button.addEventListener("click", () => send(`gpui-counter:delta:${button.dataset.delta}`));
      });
      this.querySelector("[data-reset]")?.addEventListener("click", () => send("gpui-counter:reset"));
      frame.addEventListener("load", () => send("gpui-counter:sync"));
      return;
    }
    const output = this.querySelector("[data-count]");
    const announce = (value) => {
      output.value = value;
      output.textContent = value;
    };
    this.querySelectorAll("[data-delta]").forEach((button) => {
      button.addEventListener("click", () => announce(this.#wasm.counter_step(Number(output.value), Number(button.dataset.delta))));
    });
    this.querySelector("[data-reset]")?.addEventListener("click", () => announce(this.#wasm.counter_reset()));
  }

  #layout() {
    const range = this.querySelector("input[type=range]");
    const stage = this.querySelector("[data-layout]");
    const measurement = this.querySelector("[data-measurement]");
    const arrange = () => {
      const width = Number(range.value);
      stage.dataset.mode = this.#wasm.layout_mode(width);
      stage.style.setProperty("--study-width", `${width}px`);
      stage.style.setProperty("--study-gap", `${this.#wasm.layout_gap(width)}px`);
      measurement.value = `${width}px · ${["column", "compact row", "spacious row"][stage.dataset.mode]}`;
      measurement.textContent = measurement.value;
    };
    range.addEventListener("input", arrange);
    this.querySelector("[data-reset]")?.addEventListener("click", () => { range.value = range.defaultValue; arrange(); });
    arrange();
  }

  #interaction() {
    const target = this.querySelector("[data-interaction]");
    const output = this.querySelector("output[data-state]");
    let state = 0;
    const transition = (event) => {
      state = this.#wasm.interaction_transition(state, event);
      target.dataset.state = state;
      output.value = states[state];
      output.textContent = states[state];
    };
    target.addEventListener("pointerenter", () => transition(1));
    target.addEventListener("pointerdown", () => transition(2));
    target.addEventListener("pointerup", () => transition(3));
    target.addEventListener("pointerleave", () => transition(0));
    target.addEventListener("pointercancel", () => transition(0));
    target.addEventListener("focus", () => transition(1));
    target.addEventListener("blur", () => transition(0));
    target.addEventListener("keydown", (event) => { if (event.key === " " || event.key === "Enter") transition(2); });
    target.addEventListener("keyup", (event) => { if (event.key === " " || event.key === "Enter") transition(3); });
    this.querySelector("[data-reset]")?.addEventListener("click", () => transition(0));
  }
}

if (!customElements.get("gpui-playground")) customElements.define("gpui-playground", GpuiPlayground);
