//! HTTP GET requests for remote images and application services.
//!
//! [`App::http_client`](crate::App::http_client) returns a shared handle to the
//! app's installed client. Configure it before startup with
//! [`Application::with_http_client`](crate::Application::with_http_client), or
//! replace it later with [`App::set_http_client`](crate::App::set_http_client).
//! Previously cloned handles keep the old client. The
//! [assets chapter](crate::_documentation::assets#choose-an-image-source)
//! explains which image sources use this service and how to retry cached loads.
//!
//! Core application constructors start with
//! [`NullHttpClient`](crate::http_client::NullHttpClient), which returns
//! an error for every request. On WebAssembly,
//! [`gpui_platform::application()`](crate::_documentation::platforms#browser-startup)
//! installs the browser's Fetch adapter. Native applications must supply their
//! transport. [`BlockedHttpClient`](crate::http_client::BlockedHttpClient)
//! deliberately rejects requests with
//! [`PermissionDenied`](std::io::ErrorKind::PermissionDenied); it is useful when
//! the installed service should report that network access is disabled.
//!
//! # Check the status before using the body
//!
//! A completed request can return HTTP 404 or 500. Those are responses, not
//! transport errors: `?` alone does not reject them. This helper accepts any
//! successful status and returns the collected bytes:
//!
//! ```
//! use gpui::http_client::HttpClient;
//!
//! async fn required_bytes(client: &dyn HttpClient, url: &str) -> anyhow::Result<Vec<u8>> {
//!     let response = client.get(url, true).await?;
//!     anyhow::ensure!(response.status.is_success(), "GET {url}: HTTP {}", response.status);
//!     Ok(response.body)
//! }
//! # struct Fixture(http::StatusCode);
//! # impl HttpClient for Fixture {
//! #     fn get(&self, _: &str, _: bool)
//! #         -> futures::future::BoxFuture<'static, anyhow::Result<gpui::http_client::HttpResponse>>
//! #     {
//! #         let status = self.0;
//! #         Box::pin(async move {
//! #             Ok(gpui::http_client::HttpResponse { status, body: b"bytes".to_vec() })
//! #         })
//! #     }
//! # }
//! # let ok = Fixture(http::StatusCode::OK);
//! # assert_eq!(futures::executor::block_on(required_bytes(&ok, "https://example.test/data"))?, b"bytes");
//! # let missing = Fixture(http::StatusCode::NOT_FOUND);
//! # assert!(futures::executor::block_on(required_bytes(&missing, "https://example.test/data")).is_err());
//! # Ok::<(), anyhow::Error>(())
//! ```
//!
//! [`ImageAssetLoader`](crate::ImageAssetLoader) similarly rejects non-success
//! statuses before decoding. A custom service can choose another policy, such
//! as treating 404 as an absent optional resource.
//!
//! # Implement a transport
//!
//! [`HttpClient::get`](crate::http_client::HttpClient::get) returns an owned,
//! `Send` future. Clone the transport handle and copy or parse the URL before
//! returning; the future cannot borrow
//! `self` or the caller's string. The client collects the entire body before
//! producing [`HttpResponse`](crate::http_client::HttpResponse). Enforce byte
//! limits while collecting it when responses need a bound; checking
//! `body.len()` afterward cannot prevent that
//! allocation. This interface exposes neither response headers nor a stream.
//!
//! Timeouts, redirects, authentication, and retries belong to the concrete
//! transport. Dropping the returned future stops polling it, but only the
//! transport can cancel an operation it already started. The browser adapter,
//! for example, does not explicitly abort Fetch when its Rust future is dropped.
//! Under `headless`, `FakeHttpClient` supplies empty 200 or 404 responses for
//! every URL; use a custom fixture when the requested URL or body matters.

use futures::future::BoxFuture;
use http::StatusCode;

/// A status and complete body returned by [`HttpClient::get`].
///
/// A non-success status is still a response. Inspect [`status`](Self::status)
/// before interpreting [`body`](Self::body); transport failures are returned
/// as errors instead. Headers and the final URL after redirects are not retained.
pub struct HttpResponse {
    /// The HTTP status code, including 4xx and 5xx responses.
    pub status: StatusCode,
    /// The complete response body, collected by the client before the future resolves.
    pub body: Vec<u8>,
}

/// The app's transport for full-body GET requests.
///
/// Install an implementation with
/// [`Application::with_http_client`](crate::Application::with_http_client).
/// The client chooses connection handling and transport policy; services choose
/// which response statuses and bodies they accept. See the
/// [module](crate::http_client) for an example and the ownership boundary.
pub trait HttpClient: 'static + Send + Sync {
    /// Returns a future for a GET request and its complete response body.
    ///
    /// `follow_redirects` asks the client to follow redirects; the concrete
    /// transport determines how that request is implemented. The image loader
    /// passes `true`. An implementation may reject a URL or redirect before
    /// sending a request.
    ///
    /// The future owns its inputs and can outlive both `self` and `url`. HTTP
    /// error statuses belong in [`HttpResponse`]; errors report failures to
    /// obtain that response, including request construction or body collection.
    /// Calling this method does not guarantee that work waits for the first
    /// poll: that timing and cancellation behavior belong to the implementation.
    fn get(
        &self,
        url: &str,
        follow_redirects: bool,
    ) -> BoxFuture<'static, anyhow::Result<HttpResponse>>;
}

/// A client used when no HTTP service is configured.
///
/// Requests fail with an error explaining that no client is available.
pub struct NullHttpClient;

impl HttpClient for NullHttpClient {
    fn get(
        &self,
        _url: &str,
        _follow_redirects: bool,
    ) -> BoxFuture<'static, anyhow::Result<HttpResponse>> {
        Box::pin(async { anyhow::bail!("No HttpClient available") })
    }
}

/// A client that rejects every request with `PermissionDenied`.
///
/// Use this when the application wants accidental network access to fail distinctly from an
/// absent HTTP configuration.
pub struct BlockedHttpClient;

impl BlockedHttpClient {
    /// Creates a client that rejects every request with a permission error.
    pub fn new() -> Self {
        Self
    }
}

impl Default for BlockedHttpClient {
    fn default() -> Self {
        Self
    }
}

impl HttpClient for BlockedHttpClient {
    fn get(
        &self,
        _url: &str,
        _follow_redirects: bool,
    ) -> BoxFuture<'static, anyhow::Result<HttpResponse>> {
        Box::pin(async {
            Err(std::io::Error::new(
                std::io::ErrorKind::PermissionDenied,
                "BlockedHttpClient disallowed request",
            )
            .into())
        })
    }
}

/// A fixed-status client with an empty body, available with `headless`.
///
/// Both constructors return a shared [`HttpClient`] handle. Every request
/// completes successfully at the transport level with the chosen status;
/// neither URL nor redirect preference affects it. Use a custom implementation
/// when a test must inspect requests, supply bytes, or produce transport errors.
#[cfg(any(test, feature = "headless"))]
pub struct FakeHttpClient {
    status: StatusCode,
}

#[cfg(any(test, feature = "headless"))]
impl FakeHttpClient {
    /// Create a fake client that returns an empty 404 response for every URL.
    pub fn with_404_response() -> std::sync::Arc<dyn HttpClient> {
        std::sync::Arc::new(Self {
            status: StatusCode::NOT_FOUND,
        })
    }

    /// Create a fake client that returns an empty 200 response for every URL.
    pub fn with_200_response() -> std::sync::Arc<dyn HttpClient> {
        std::sync::Arc::new(Self {
            status: StatusCode::OK,
        })
    }
}

#[cfg(any(test, feature = "headless"))]
impl HttpClient for FakeHttpClient {
    fn get(
        &self,
        _url: &str,
        _follow_redirects: bool,
    ) -> BoxFuture<'static, anyhow::Result<HttpResponse>> {
        let status = self.status;
        Box::pin(async move {
            Ok(HttpResponse {
                status,
                body: Vec::new(),
            })
        })
    }
}
