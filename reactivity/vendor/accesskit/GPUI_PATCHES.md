# Coordinated private text extension

This complete package starts from crates.io `accesskit` 0.25.1, upstream commit
`ce8164ba92995cfa86005b6259115e08c8244253`. Archive SHA-256:
`ad442f58ee04714aaa0ba0a2768c1ea1935b29507bb22ddece8cbbc76db02932`.
The upstream Apache-2.0 and MIT licenses are retained.

Ordinary `character_lengths` keeps its upstream `Vec<u8>`, property ID, one entry
per selectable unit, and serialized array. Long units use a private property
value variant. Its serialized object is `{units, data}`: `data` starts with
`units` one-byte entries followed by one little-endian u32 per zero escape.
An escaped length must exceed 255. A checked borrowed decoder validates the
complete value, exact overflow consumption, sums, and UTF-8 boundaries before
consumers use it. Geometry arrays still index selectable units, never overflow
entries. The exceptional retained payload is one `Box<[u8]>` allocation.

`ActionData::ReplaceText(Box<TextReplacement>)` is an appended private variant
carrying one selection and replacement value atomically. Older variant order is
preserved. This extension is **not** compatible with an upstream-only reader of
exceptional serialized lengths or the new action. Raw `character_lengths()`
consumers must not interpret zero as a real empty unit. Deploy with the matching
vendored consumer and adapters; do not publish this package as upstream 0.25.1.

The matching consumer uses the checked decoder for byte, Unicode scalar, and
UTF-16 conversion. Explicit editing adapters additionally round-trip offsets to
reject interior-unit positions, rather than silently flooring them. The GPUI
native producer emits ICU grapheme units, including unsplit CRLF, and withdraws
source actions when acknowledged text has no current qualified source lease.
