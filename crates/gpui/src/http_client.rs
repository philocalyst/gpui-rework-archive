use futures::future::BoxFuture;
use http::StatusCode;

/// The status and the full body of an HTTP response.
pub struct HttpResponse {
    /// The HTTP status code.
    pub status: StatusCode,
    /// The whole response body, read before the response is returned.
    pub body: Vec<u8>,
}

/// Makes the HTTP requests that the app needs, such as fetching image URLs.
///
/// Set the client with [`crate::Application::with_http_client`], and read it with [`crate::App::http_client`].
/// The app starts with [`NullHttpClient`], which fails every request, so URLs don't load until you
/// set a client. The constructors in `gpui_platform` set one.
pub trait HttpClient: 'static + Send + Sync {
    /// Sends a GET request to `url`, and returns the status and the body.
    ///
    /// When `follow_redirects` is `true`, redirects are followed. Return `Err` only when no response
    /// arrives, such as after a network failure. An error status such as 404 is an `Ok` response,
    /// because callers check the status themselves.
    fn get(
        &self,
        url: &str,
        follow_redirects: bool,
    ) -> BoxFuture<'static, anyhow::Result<HttpResponse>>;
}

/// An [`HttpClient`] that fails every request with "No HttpClient available".
///
/// The app uses it until you set another client.
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

/// An [`HttpClient`] that refuses every request with a `PermissionDenied` error.
///
/// Use it when a run must not reach the network.
pub struct BlockedHttpClient;

impl BlockedHttpClient {
    /// Creates a client that refuses every request. Same as [`Default::default`].
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

/// An [`HttpClient`] for tests that answers every request with one status and an empty body.
///
/// Available in tests and with the `test-support` feature.
#[cfg(any(test, feature = "test-support"))]
pub struct FakeHttpClient {
    status: StatusCode,
}

#[cfg(any(test, feature = "test-support"))]
impl FakeHttpClient {
    /// Returns a client that answers every request with `404 Not Found`.
    pub fn with_404_response() -> std::sync::Arc<dyn HttpClient> {
        std::sync::Arc::new(Self {
            status: StatusCode::NOT_FOUND,
        })
    }

    /// Returns a client that answers every request with `200 OK`.
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
