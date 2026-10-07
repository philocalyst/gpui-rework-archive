//! The small HTTP boundary used by GPUI services.
//!
//! GPUI asks for a complete response through [`crate::http_client::HttpClient`], leaving transport, policy, and
//! redirect handling to the application. The built-in clients make absence and denial explicit;
//! neither performs network I/O.

use futures::future::BoxFuture;
use http::StatusCode;

/// A complete response returned by [`crate::http_client::HttpClient::get`].
pub struct HttpResponse {
    /// The HTTP status code.
    pub status: StatusCode,
    /// The response body bytes.
    pub body: Vec<u8>,
}

/// Performs GET requests for services that need remote bytes.
///
/// Implementations choose their timeout, TLS, proxy, and cache policy. `follow_redirects` is a
/// request from the caller; implementations should report transport failures as `anyhow::Error`.
pub trait HttpClient: 'static + Send + Sync {
    /// Perform a GET request and return the full response.
    fn get(
        &self,
        url: &str,
        follow_redirects: bool,
    ) -> BoxFuture<'static, anyhow::Result<HttpResponse>>;
}

/// A client used when no HTTP service is configured.
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
#[cfg(any(test, feature = "test-support"))]
pub struct FakeHttpClient {
    status: StatusCode,
}

#[cfg(any(test, feature = "test-support"))]
impl FakeHttpClient {
    /// Create a fake client that returns 404 responses.
    pub fn with_404_response() -> std::sync::Arc<dyn HttpClient> {
        std::sync::Arc::new(Self {
            status: StatusCode::NOT_FOUND,
        })
    }

    /// Create a fake client that returns 200 responses.
    pub fn with_200_response() -> std::sync::Arc<dyn HttpClient> {
        std::sync::Arc::new(Self {
            status: StatusCode::OK,
        })
    }
}

#[cfg(any(test, feature = "test-support"))]
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
