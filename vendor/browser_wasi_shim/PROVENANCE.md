Vendored @bjorn3/browser_wasi_shim 0.4.2 from its npm release.

Source: https://github.com/bjorn3/browser_wasi_shim

Only the published JavaScript runtime and original licenses are included.

Local WASI Preview 1 ABI fixes: `poll_oneoff` writes its required event-count output; clock subscription flags are read at byte 40, after the 64-bit timeout and precision fields. These prevent an uninitialized event count in mio and preserve absolute clock deadlines.

`Filestat.write_bytes` uses the Preview 1 64-byte layout: size at byte 32 and timestamps at bytes 40, 48, and 56, without overlapping fields.
