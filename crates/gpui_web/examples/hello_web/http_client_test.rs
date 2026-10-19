//! Exercises Fetch-backed HTTP clients shared between the browser and real workers.

use gpui::{Platform as _, http_client::HttpClient as _};
use gpui_web::WebPlatform;
use std::sync::Arc;
use wasm_bindgen::prelude::*;

fn main() {}

#[wasm_bindgen]
pub async fn test_worker_fetch(url: String) -> Result<(), JsValue> {
    let platform = WebPlatform::new(true);
    let client = Arc::new(platform.fetch_http_client());
    let background = platform.background_executor();
    let main_thread = std::thread::current().id();
    let readers = (0..8).map(|_| {
        let client = client.clone();
        let url = url.clone();
        background.spawn(async move {
            anyhow::ensure!(
                std::thread::current().id() != main_thread,
                "request must execute on a real worker"
            );
            let response = client.get(&url, true).await?;
            anyhow::ensure!(
                response.status.is_success(),
                "HTTP request failed: {}",
                response.status
            );
            let bytes = response.body;
            anyhow::ensure!(bytes.len() == 32768 * 3, "response did not reach EOF");
            for (index, chunk) in bytes.chunks_exact(3).enumerate() {
                let expected = [
                    (index % 251) as u8,
                    (index % 239) as u8,
                    (index % 227) as u8,
                ];
                anyhow::ensure!(chunk == expected, "response bytes must remain ordered");
            }
            anyhow::Ok(())
        })
    });
    futures::future::try_join_all(readers)
        .await
        .map(|_| ())
        .map_err(|error| JsValue::from_str(&error.to_string()))
}
