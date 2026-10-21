# x11 empty-window profile-size diagnostic (no runtime capture yet)

Both binaries were built from GPUI cleanroom commit `88d65eae0a0e832e51a8c7156f236b1e3a8ec5dd`, the identical lockfile and the identical empty-window example, with feature `x11`. In this repository `x11` includes `accessibility` and `native`; the ThinLTO experiment keeps that feature set and the AccessKit Unix/AT-SPI code linked. The fixture is a genuinely blank `div()` window, not the zero-row header/button/text benchmark. The exact commands, binary hashes, build environment and fixture hashes are in [`manifest.json`](manifest.json).

The first artifact uses Cargo's untouched release defaults. The candidate sets only `CARGO_PROFILE_RELEASE_LTO=thin` and `CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1`; the verbose build log verifies those Rust flags. Cargo documents these profile controls and the 16-unit default release profile in [The Cargo Book, Profiles](https://doc.rust-lang.org/cargo/reference/profiles.html).

| Artifact | File bytes | `size` text | data | bss |
| --- | ---: | ---: | ---: | ---: |
| Default release | 24,558,648 | 19,079,607 | 478,064 | 10,580 |
| ThinLTO + 1 codegen unit | 19,884,088 | 16,986,851 | 337,832 | 11,176 |
| Change | −4,674,560 (−19.0%) | −2,092,756 (−11.0%) | −140,232 | +596 |

`readelf` program headers and full sorted symbol-size dumps are included for both variants. The linked-symbol inventory still contains `accesskit_unix` functions in both binaries, including AT-SPI bus registration and adapter processing. That confirms code is present; it does not show that AT-SPI was active, that a screen reader connected, or that accessibility latency remains correct. No binary was launched during this build-only stage. A linker map was not captured.

The Cargo-reported clean-target build times were 3m47s for default and 4m17s for ThinLTO. Treat this as raw context only: the builds ran at different times, filesystem state warmed between them, and other team Cargo jobs overlapped. It is not a controlled compile-time comparison.

The size reduction makes the profile candidate worth a guarded runtime diagnostic. It does not establish fewer resident or faulted pages: on-disk bytes are not RSS/PSS, and executable pages are faulted according to runtime paths. The next comparison should launch both exact binaries as fresh processes on one persistent Xvfb, preserve the ordinary native accessibility feature, and measure cold-ish startup and steady idle residency with file-backed/shared/private mappings split. Before accepting the candidate, also exercise actual surface creation, first acknowledged pixel, X11 expose/resize restoration, and AT-SPI activation/action delivery. Report compiled accessibility separately from observed activation. Do not convert this diagnostic into a product profile until the runtime gates pass.

Artifacts: `default-build.log`, `thin-build.log`, `default-readelf.txt`, `thin-readelf.txt`, `default-size.txt`, `thin-size.txt`, `default-symbols.txt`, and `thin-symbols.txt`. No source files were changed for the candidate.
