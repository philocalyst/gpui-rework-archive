# Partial qualification checkpoint

Source df8ca59f69813e7dd05711fead98ed4278f1688d. No timing or adoption.
Canvas/GPU tests and strict Clippy pass. Full native build and library tests pass;
preserving169 executable artifacts exhausted the8GiB next-stage reserve, so port
tests and Clippy did not start. All failures/guards/artifact hashes are preserved.
The omission mutant fails the real pixel-support oracle at44,2 as required.
This checkpoint permits reclaiming completed target cache copies whose exact
bytes are independently preserved; source and evidence remain in Git/raw stores.

{
  "gpu-initial": {
    "passed": 349,
    "ignored": 3
  },
  "full-native-initial": {
    "passed": 1108,
    "ignored": 45
  }
}
