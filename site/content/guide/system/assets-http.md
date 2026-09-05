+++
title = "Assets and HTTP: load once, share widely"
description = "Supply assets and network resources through the framework’s service boundaries."
weight = 31
aliases = ["/system/assets-http.html"]
[extra]
category = "SYSTEM"
legacy_source = "gpui-ce-docs/build/html/system/assets-http.html"
+++

Nobody wants to decode the same PNG sixty times a second. An **AssetSource** loads raw bytes by path ([crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs)), an **HttpClient** performs GET requests ([crates/gpui/src/http_client.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/http_client.rs)), and an **ImageCache** decodes images once and shares the handles ([crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs)). Load once, hold the handle, share everywhere.

```rust
// Set up a cache once, then hand out cheap clones. Decoding happens a single time.
let cache = RetainAllImageCache::new(cx); // returns `Entity<Self>` — shared ownership
let el = image_cache(RetainAllImageCacheProvider(cache.clone()));
// `image_cache.rs:241` builds the entity; `image_cache.rs:15` wraps a provider.
// Later, `cache.update(cx, |c, _| c.len())` tells you how many images you hold.
```

`AssetSource::load` returns `Result<Option<Cow<'static, [u8]>>>` — missing files are `Ok(None)`, not errors ([crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs)). Its sibling `list` enumerates a directory ([crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs)). The blank `()` implementation returns nothing at all, which makes it perfect for tests that need no assets ([crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs)).

|  |  |  |
| --- | --- | --- |
| Type | Where it lives | What you should know |
| `AssetSource::load` / `list` | `assets.rs:15` / `assets.rs:18` | `Cow` bytes; `None` means missing, not broken |
| `RenderImage` | `assets.rs:43` | decoded frames; `frame_count` counts animation (`assets.rs:104`) |
| `AnyImageCache::load` | `image_cache.rs:47` | per-request decode behind a provider |
| `RetainAllImageCache` | `image_cache.rs:228` | `new(cx)` gives an `Entity`; `len` counts entries (`image_cache.rs:308`) |

Table 36: Loading primitives, from raw bytes to shared images.

## Eviction is your job

Here is the nuance the name hides: `RetainAll` means **no** automatic eviction. Entries stay until you remove them, so a long-lived cache of remote avatars grows without bound unless you prune it. You have two scalpels — `remove` drops one image by `Resource` ([crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs)), and `clear` drops everything ([crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs)). Both need `window` plus `cx`, because eviction touches live scene state.

```rust
// Prune what you no longer show. Retain-all never prunes itself.
cache.update(cx, |c, _| c.is_empty()); // `image_cache.rs:313` — cheap emptiness check
// cache.update(cx, |c, cx| c.remove(&source, window, cx)); // drop one image
// cache.update(cx, |c, cx| c.clear(window, cx)); // drop everything, start fresh
```

> **Pitfall.** Re-decoding a PNG per frame costs roughly 10x. If scrolling janks, check whether you cached the `Entity` or accidentally reloaded pixels every frame.

## HTTP without surprises

|  |  |
| --- | --- |
| Client | What you should know |
| `HttpClient::get` | `http_client.rs:13`; `follow_redirects` flag decides redirect chasing |
| `NullHttpClient` | always errors; the default when none is set (`http_client.rs:23`) |
| `BlockedHttpClient` | denies every request; ideal for offline tests (`http_client.rs:36`) |
| `FakeHttpClient` | canned responses; `with_200_response` fakes success (`http_client.rs:83`) |

Table 37: The four HTTP clients, from real network to canned test double.

```rust
// Never hit the real network from a unit test. Fake it instead.
let client: Arc<dyn HttpClient> = FakeHttpClient::with_200_response();
let resp = client.get("https://example.com/x", true).await.unwrap();
// `true` means follow redirects; `BlockedHttpClient` errors with a
// "disallowed request" message (`http_client.rs:60`) when isolation matters.
```

> **Tip.** Write tests with `FakeHttpClient` and one offline run with `BlockedHttpClient`. The second catches the network call you forgot to fake.

Where next? Test the loading path headlessly (`system-testing`), then profile frame costs (`guides-performance`).

## Sources

- `AssetSource::load`, `list`, `()` impl: [crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs), [crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs), [crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs)
- `RenderImage`, `frame_count`: [crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs), [crates/gpui/src/assets.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/assets.rs)
- `image_cache` fn, `AnyImageCache::load`: [crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs), [crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs)
- `RetainAllImageCache`, `new`, `clear`, `remove`, `len`: [crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs), [crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs), [crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs), [crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs), [crates/gpui/src/elements/image_cache.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/image_cache.rs)
- `HttpClient::get`, `Null`, `Blocked`, `Fake`: [crates/gpui/src/http_client.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/http_client.rs), [crates/gpui/src/http_client.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/http_client.rs), [crates/gpui/src/http_client.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/http_client.rs), [crates/gpui/src/http_client.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/http_client.rs)
