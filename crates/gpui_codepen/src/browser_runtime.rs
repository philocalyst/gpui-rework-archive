//! Browser-local full Rust compiler/Miri transport. Scene replay and input
//! routing use the same GPUI controller and renderer as the native component.
use crate::session::{FailureKind, Reply, Request};
use js_sys::{Promise, Reflect, Uint8Array};
use wasm_bindgen::prelude::*;
use wasm_bindgen_futures::JsFuture;

#[wasm_bindgen(inline_js = "
export function evaluateMiri(id, generation, source, restart, input) {
    if (!globalThis.gpuiCodepenMiri) throw new Error('Browser Miri assets are missing');
    return globalThis.gpuiCodepenMiri.evaluate(id, generation, source, restart, input);
}
export function cancelMiri(id, generation) { globalThis.gpuiCodepenMiri?.cancel(id, generation); }
export function releaseMiri(id) { globalThis.gpuiCodepenMiri?.release(id); }
")]
extern "C" {
    #[wasm_bindgen(catch, js_name = evaluateMiri)]
    fn evaluate_js(
        id: &str,
        generation: f64,
        source: &str,
        restart: bool,
        input: &[u8],
    ) -> Result<Promise, JsValue>;
    #[wasm_bindgen(js_name = cancelMiri)]
    fn cancel_js(id: &str, generation: f64);
    #[wasm_bindgen(js_name = releaseMiri)]
    fn release_js(id: &str);
}

pub(crate) fn release(id: &str) {
    release_js(id);
}

struct CancelOnDrop {
    id: String,
    generation: u64,
    complete: bool,
}
impl Drop for CancelOnDrop {
    fn drop(&mut self) {
        if !self.complete {
            cancel_js(&self.id, self.generation as f64);
        }
    }
}

pub(crate) async fn evaluate(request: Request) -> Reply {
    let mut cancel = CancelOnDrop {
        id: request.session_id.clone(),
        generation: request.generation,
        complete: false,
    };
    let mut elapsed_ms = 0;
    let mut failure = FailureKind::Rust;
    let result = async {
        if request.source.len() > gpui_codepen_guest::MAX_SOURCE_BYTES {
            return Err(JsValue::from_str("Source exceeds 64 KiB"));
        }
        let input = gpui_codepen_guest::wire::encode_input(&request.input)
            .map_err(|e| JsValue::from_str(&e))?;
        failure = FailureKind::Unavailable;
        let value = JsFuture::from(evaluate_js(
            &request.session_id,
            request.generation as f64,
            &request.source,
            request.restart,
            &input,
        )?)
        .await?;
        elapsed_ms = Reflect::get(&value, &"elapsed_ms".into())?
            .as_f64()
            .unwrap_or(0.) as u64;
        let diagnostics = Reflect::get(&value, &"diagnostics".into())?
            .as_string()
            .unwrap_or_default();
        if !diagnostics.is_empty() {
            failure = if Reflect::get(&value, &"failure".into())?.as_string().as_deref() == Some("unavailable") {
                FailureKind::Unavailable
            } else { FailureKind::Rust };
            return Err(JsValue::from_str(&diagnostics));
        }
        let bytes = Reflect::get(&value, &"frame".into())?;
        let bytes = bytes.dyn_into::<Uint8Array>()
            .map_err(|_| JsValue::from_str("Rust interpreter returned no GPUI frame"))?;
        gpui_codepen_guest::wire::decode(&bytes.to_vec())
            .map_err(|e| JsValue::from_str(&e))
    }
    .await;
    cancel.complete = true;
    let (frame, diagnostics) = match result {
        Ok(frame) => (Some(frame), String::new()),
        Err(error) => (
            None,
            error.as_string().unwrap_or_else(|| format!("{error:?}")),
        ),
    };
    let failure = frame.is_none().then_some(failure);
    Reply {
        generation: request.generation,
        frame,
        diagnostics,
        failure,
        elapsed_ms,
    }
}
