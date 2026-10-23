# Root replay of the audio/EOF package

Root independently replayed source and qualification patches from `e7ba208bb1`
and verified all 458 port blobs against reviewed commit `9145411365`, including
six audio assets and 37 added lock packages. The 338-path package leaves all
files outside this standalone application unchanged. Exact patch hashes and
the reconstructed tree are in `root-package-verification.json`.

The integrated 914 source passes 44 default and 107 native-feature all-target
tests (one native device test ignored), strict default/native lint, formatting,
the native example build and the actual external native-service Registry client.
All 9,141 recorded file guards match through those tests. Its frozen debug ELF
has SHA-256 `9e8fc4117032c21ef5f8696ee4ae09eed4b8fe382ba21c7e2b8ff245c5e9ea0e`.
The first native attempt failed because pkg-config was absent from the tool
environment; that attempt remains recorded. Correcting the SDK environment,
without source changes, allowed the complete native gate and client to pass.

This is historical evidence. Review subsequently reproduced the queued Prepared
versus source-publication race, so Root held adoption until applying the narrow
9f83 successor. [`../main-source-authority-integration`](../main-source-authority-integration)
records the final integrated source, its complete gates and a separately frozen
native executable. These old observations are not retagged as 9f83 results.
