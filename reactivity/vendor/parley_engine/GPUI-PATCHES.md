# Parley Engine 0.12.0 local repairs

Published crate: `https://static.crates.io/crates/parley_engine/parley_engine-0.12.0.crate`.
Archive SHA-256: `b74c0d373e462e504ad4436710a39f099e18e848e1ee711f70cd2dcd5a69b290`.
Upstream commit: `6e1143dda817360dd3a2a64f9133c6e5dfabd881`, directory
`parley_engine`. The original package manifests, MIT/Apache licenses and VCS
metadata accompany the full source. The workspace's root lock resolves this
path patch; the package's independent published lock is not used.

The prior Parley 0.11 fixes move to this new 0.12 engine boundary:

- Coverage counts use `usize`, matching the owned character slice. Saturating
  `u8` counts could report complete coverage for a long grapheme with an
  uncovered tail. Fraction comparison uses `u128` products on supported
  32/64-bit targets. Pairwise normalization's two-element `Form.len` stays u8.
  Upstream 0.12 already removed the old 32-element mapping scratch truncation.
- A shaped cluster stores its complete glyph count as u32, independently of
  packed flags. Inline glyphs still use the existing explicit flag. The old
  `cluster.glyphs as u8` cast truncated a single long combining grapheme.
- Shaping uses HarfBuzz's monotone-grapheme source cluster policy, preserving
  canonical original-byte ownership against the independent Rustybuzz oracle.
  Public caret/grapheme boundaries remain ICU-analyzed. Parley 0.12's public
  grapheme clusters can cover several shaped clusters, so the Parley adapter
  exposes a borrowed shaped-source iterator for glyph lowering.
- The direct engine skrifa requirement is updated to 0.49.0. HarfRust remains
  0.12: the latest 0.14 API removed the buffer/cache types this released engine
  uses and requires a separate upstream shaper migration. This is a documented
  transitive-major constraint, not a claim that all lock versions are latest.

Canvas preserves its 32768-byte/retained-glyph admission and existing transient
hostile-font expansion limitation. These patches add no persistent Canvas
mapping fields and no unsafe code. The public debug/release Unicode corpus
checks full glyph IDs, byte clusters and positions, including 512 accents;
selection checks source affinity, wrap ownership and allocation-free queries.
