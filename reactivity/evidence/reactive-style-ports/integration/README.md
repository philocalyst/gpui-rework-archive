# Combined direct-style integration

Implementation `b1fc101435ad62b4ffb6718970846ff7ff154333` combines direct style
ports and compact generic Flex with the shared public/native pointer protocol,
ordinary scroll, rounded geometry and Canvas/GPU color-patch primitives.

[checks.json](checks.json) records ten successful gates and raw-log SHA-256
digests. [source-sha256.json](source-sha256.json) hashes 254 first-party Rust,
crate-manifest and workspace inputs; tracked first-party source bytes were
checked against the implementation commit during packaging. These are source
and log hashes, not an assertion that every output executable was hashed.

The default workspace passes 609 cases/doctests with 11 intentionally ignored
fixtures. Accessible X11/Wayland native units pass 126 with 19 ignored fixtures.
The actual native style, Todo and ordinary-scroll scripts separately execute
their full server-image oracles. Strict all-target Linux Clippy covers accessible
X11/Wayland, parallel Canvas and Vulkan GPU test code. Strict desktop Clippy also
passes for the actual Apple aarch64 and Windows MSVC adapters; these are
cross-compilation checks. Counts overlap and are not summed into a larger total.

The exact same-feature native header probe reports Canvas552, Renderer872,
GpuSurface1056 and NativeHost688 bytes. The isolated X11-only host's 680-byte
figure uses a different feature set. Plain Node40, Presented80, Style88, El176
and Runtime2384 are unchanged by the styles. Literal Flex is12 bytes; four
borrowed Signal operands use40. The independent baseline probe and construction
allocation ledgers remain in [compact-flex](../compact-flex/README.md).

Linux execution uses Xvfb94 and Mesa llvmpipe. This campaign establishes
correctness on that software backend, with no latency, RSS, scanout or hardware
performance claim. It does not yet connect a Source update directly to a GPU
color patch. The unchanged Canvas/GPU implementation has the separately pinned
actual Vulkan campaign in [paint integration](../../paint-patch/integration/checks.json);
those readbacks were not repeated here.
