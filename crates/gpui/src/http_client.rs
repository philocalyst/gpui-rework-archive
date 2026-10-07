//! The small HTTP boundary used by GPUI services.
//!
//! [`crate::http_client::HttpClient`] separates a service's request from the application's
//! transport policy. A caller passes the URI text and its redirect preference; the client owns
//! TLS, proxy, timeout,
//! and other transport choices, then resolves to a complete
//! [`crate::http_client::HttpResponse`] or a transport
//! error. The body is fully collected as `Vec<u8>` before the future completes; this interface
//! has no streaming or response-size limit. Clients and callers should bound responses where
//! needed. An HTTP status such as 404 is still a successful transport response; the service
//! decides whether a status is acceptable.
//!
//! The returned future is `'static`, so implementations must own anything they need after
//! `get` returns. A request can be cancelled by dropping the surrounding future or GPUI task if
//! the implementation observes cancellation. This trait does not define retries, authentication,
//! response-size limits, or redirect security policy; the caller and concrete client must agree
//! on those behaviors.
//!
//! Use [`crate::http_client::NullHttpClient`] when no network service was configured, and
//! [`crate::http_client::BlockedHttpClient`] when policy deliberately denies network access. Both
//! fail the request, but the latter reports a permission-denied error. Under tests or the
//! `headless` feature, the fake client's `with_200_response` and `with_404_response` constructors
//! provide deterministic empty responses without inspecting the requested URL. Implement
//! [`crate::http_client::HttpClient`] with a real transport to perform network I/O.

use futures::future::BoxFuture;
use http::StatusCode;

/// A fully collected response returned by [`crate::http_client::HttpClient::get`].
///
/// A non-success status is still represented as a response. Consumers should inspect `status`
/// before interpreting the body; transport failures are returned as errors instead.
pub struct HttpResponse {
    /// The HTTP status code, including 4xx and 5xx responses.
    pub status: StatusCode,
    /// The complete response body, collected by the client before the future resolves.
    pub body: Vec<u8>,
}

/// Performs full-body GET requests for services that need remote bytes.
///
/// Implementations choose their timeout, TLS, proxy, and cache policy. `follow_redirects` is a
/// request from the caller, not a guarantee that redirects are safe or followed. HTTP status
/// codes are returned in [`crate::http_client::HttpResponse`]; this method's error is for transport or client-side
/// failures.
pub trait HttpClient: 'static + Send + Sync {
    /// Perform a GET request and collect the full response body.
    ///
    /// The returned future is `'static` and can outlive the borrow of `self`; copy or parse `url`
    /// before returning if the request needs it later. Treat the URL as opaque request text
    /// unless the concrete client needs to parse it.
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
    /// Create a new `BlockedHttpClient`.
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

/// A fake HTTP client for testing.
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
