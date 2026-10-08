//! Browser [`fetch`](https://developer.mozilla.org/en-US/docs/Web/API/Window/fetch) adapter.
//!
//! Browser CORS, origin, redirect, and permission policies apply; this client does not provide a
//! native networking fallback.

use anyhow::anyhow;
use gpui::http_client::{HttpClient, HttpResponse};
use std::future::Future;
use std::pin::Pin;
use std::task::Poll;
use wasm_bindgen::JsCast as _;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(catch, js_name = "fetch")]
    fn global_fetch(input: &web_sys::Request) -> Result<js_sys::Promise, JsValue>;
}

/// GPUI HTTP client backed by the browser's global `fetch` function.
///
/// `get` sends a GET request and buffers the complete response body. HTTP error
/// statuses are returned in [`HttpResponse::status`]; check that field before
/// using the body. Request construction, Fetch rejection, invalid status
/// conversion, and body collection can return errors.
///
/// Browser CORS, origin, redirect, and permission rules apply. Setting
/// `follow_redirects` to `false` selects Fetch's `manual` redirect mode. An
/// [opaque redirect](https://fetch.spec.whatwg.org/#concept-filtered-response-opaque-redirect)
/// then has status zero, which this adapter rejects as an invalid HTTP status
/// rather than returning a 3xx response.
///
/// Dropping the future stops polling the response; this adapter does not attach
/// an abort signal to stop a Fetch operation it has already started.
///
/// The web constructors in `gpui_ce_platform` install this client. Construct
/// it directly when embedding the web platform yourself.
///
/// ```no_run
/// # async fn example() -> anyhow::Result<()> {
/// use gpui::http_client::HttpClient;
/// let response = gpui_ce_web::FetchHttpClient::default()
///     .get("https://example.com/data", true)
///     .await?;
/// if response.status.is_success() {
///     let json = String::from_utf8(response.body)?;
///     # let _ = json;
/// }
/// # Ok(())
/// # }
/// ```
pub struct FetchHttpClient;

impl Default for FetchHttpClient {
    fn default() -> Self {
        Self
    }
}

#[cfg(feature = "multithreaded")]
impl FetchHttpClient {
    /// Constructs the client in multithreaded WebAssembly builds.
    ///
    /// # Safety
    ///
    /// The caller must ensure the client is used only with the browser runtime and its main-thread
    /// Fetch integration. The returned future is marked `Send` to satisfy GPUI's HTTP-client
    /// interface, but its JavaScript Fetch operations still run on the browser main thread.
    pub unsafe fn new() -> Self {
        Self
    }
}

#[cfg(not(feature = "multithreaded"))]
impl FetchHttpClient {
    /// Constructs the client in single-threaded WebAssembly builds.
    pub fn new() -> Self {
        Self
    }
}

/// Wraps a `!Send` future to satisfy the `Send` bound on `BoxFuture`.
struct AssertSend<F>(F);

unsafe impl<F> Send for AssertSend<F> {}

impl<F: Future> Future for AssertSend<F> {
    type Output = F::Output;

    fn poll(self: Pin<&mut Self>, cx: &mut std::task::Context<'_>) -> Poll<Self::Output> {
        let inner = unsafe { self.map_unchecked_mut(|this| &mut this.0) };
        inner.poll(cx)
    }
}

impl HttpClient for FetchHttpClient {
    fn get(
        &self,
        url: &str,
        follow_redirects: bool,
    ) -> futures::future::BoxFuture<'static, anyhow::Result<HttpResponse>> {
        let url = url.to_string();
        Box::pin(AssertSend(async move {
            let init = web_sys::RequestInit::new();
            init.set_method("GET");

            if !follow_redirects {
                init.set_redirect(web_sys::RequestRedirect::Manual);
            }

            let request = web_sys::Request::new_with_str_and_init(&url, &init)
                .map_err(|error| anyhow!("failed to create fetch Request: {error:?}"))?;

            let promise = global_fetch(&request)
                .map_err(|error| anyhow!("fetch threw an error: {error:?}"))?;
            let response_value = wasm_bindgen_futures::JsFuture::from(promise)
                .await
                .map_err(|error| anyhow!("fetch failed: {error:?}"))?;

            let web_response: web_sys::Response = response_value
                .dyn_into()
                .map_err(|error| anyhow!("fetch result is not a Response: {error:?}"))?;

            let status_code = http::StatusCode::from_u16(web_response.status())
                .map_err(|_| anyhow!("invalid status code"))?;

            let body_promise = web_response
                .array_buffer()
                .map_err(|error| anyhow!("failed to initiate response body read: {error:?}"))?;
            let body_value = wasm_bindgen_futures::JsFuture::from(body_promise)
                .await
                .map_err(|error| anyhow!("failed to read response body: {error:?}"))?;
            let array_buffer: js_sys::ArrayBuffer = body_value
                .dyn_into()
                .map_err(|error| anyhow!("response body is not an ArrayBuffer: {error:?}"))?;
            let body = js_sys::Uint8Array::new(&array_buffer).to_vec();

            Ok(HttpResponse {
                status: status_code,
                body,
            })
        }))
    }
}
