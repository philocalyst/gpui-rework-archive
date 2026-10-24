# Selected gradient producer evidence

The selected producer source is `a2dd48e908d6bb5e999f5b613af3a82407353ee5`.
[The composed integration](../clipping-gradients-integration/README.md) records its
adoption and subsequent public-sampler, clipping and damage fixes. The original
[report](REPORT.md) and handoff retain their historical qualification status.

Root independently verified all 89 producer-manifest files, including frozen
native executables and rejected-finalizer evidence. `root-byte-audit` records the
actual review bundle's 16 members (15 payloads plus the full manifest); the bundle
is a subset, not an archive of all 89 files. The first audit incorrectly assumed
otherwise, failed, and was corrected before import.

`review-bundle.tar.gz` contains the selected source capsule and compact review
materials. `qualification-logs.tar.gz` preserves commands, guards, raw test logs,
focused assembly and cost records. Full executables, compressed full assembly and
both selected/rejected source capsules remain in the independently audited
external archive `/tmp/gpui-gradient-bank-producer-full-root.tar.gz`, 81,656,040
bytes, SHA256 `0c8ff09681ad7a0981a3d1e85fd572f92a64b5eb6c4dd5a5102980ab354c4cb8`.
`archive-scope.json` lists every omitted payload and its exact hash. No unqualified
finalizer or historical timing result is adopted as current performance evidence.
