# Contained property editor evidence

[The implementation and controls](IMPLEMENTATION.md) preserve producer shipping
source `c3248fd11c138124e221af9487030b849445eca1`, final test source
`d8b26c1179296009b637cdb8adc1d25285d2751b` and evidence commit
`5b8fbc95e567d247a4f74f3044b5bedb1c18e8c6`. Main integrates that code at
`f0bd5335ae`, preserving the separately added checkbox export. Those producer
results are not retagged as combined-main qualification.

`producer.tar.gz` losslessly retains the complete 564-file producer directory,
including earlier controls, raw assembly, commands, source guards and failures.
`producer-files.json` hashes every uncompressed file and the original Git tar
stream. The expanded archive is about 33.5 MB; generated assembly and inventory
costs remain charged in the producer ledger. The human-readable implementation
note is copied byte for byte alongside it. Inspect the original directory in a
temporary location:

```sh
mkdir -p /tmp/contained-property-evidence
tar -xzf producer.tar.gz -C /tmp/contained-property-evidence
```

Independent integration review found an uncovered counter case: with a no-op
result method, a real property edit can be omitted from `Commit.changed_nodes`
by the following coarse description. The exact identity-union correction is now
integrated at `1d5bc3061c`, where all 11 public regression cases pass. Its producer
archive is `evidence/property-change-union/`. Broad combined qualification remains
pending. These later findings do not retag the recorded producer executions.

The public mounting/picking seam remains open: the native fixture initializes
its selected Target through an ordinary Win inside a private host fixture.
The current parser is reusable consumer code; arbitrary value entry in the
built-in inspector is still separate work.
