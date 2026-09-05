const url = new URL("../wasm/gpui_examples.wasm", import.meta.url);

async function instantiate() {
  const response = await fetch(url);
  if (!response.ok) throw new Error(`WASM request failed: ${response.status}`);

  if (WebAssembly.instantiateStreaming) {
    try {
      return (await WebAssembly.instantiateStreaming(response.clone(), {})).instance.exports;
    } catch {
      // Static hosts occasionally serve .wasm as application/octet-stream.
    }
  }

  return (await WebAssembly.instantiate(await response.arrayBuffer(), {})).instance.exports;
}

export const gpuiWasm = instantiate();

