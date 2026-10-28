# Mask tile traversal: exact early GPU admission

Productiond63782dd4c528860c21c6cc45caa177adce2cd08 passes353 GPU/canvas tests
(3 ignored),strict Clippy and336 unchanged independent public reference frames.
The same fixture checks proof-enabled output equals proof-disabled sampling,
inline/compact packet equality and exact replay. New private packet checks prove
literal mask tiles receive the bounded tag,banked packets do not,tagged ranges
remain within the actual index array,Stats remain untagged counts,and disabling
tile proofs removes the new tag. No fixture/API/dependency/pipeline/unsafe change.

Wrong-Y mutantfb4bb250 fails the unchanged public fixture with testexit101:
proof-enabled literal output differs from its proof-disabled fallback in1,836
bytes; firstbyte3098 is125 rather than126. The fallback bytes equal the independently
compiled pre-change oracle6faae98a and the real candidate. Full actual/reference
images and panic arrays are retained. The first witness parser looked only in
stderr; the harness prints this failure in stdout. Its assertion and script remain;
v2 reads both existing streams. No test rerun or changed witness.

Generated WGSL22041 bytes,SHA256
d798300f08a0c14bdb32705d93d15fa30e707db630880a060d4f6ace88e5d60d,
is verified inside the freshly rebuilt/executed GPU render ELF. Shipping38181
lines is+18 over four-cell parent and+153 over qualified suffix baseline. New
selection reuses bit30 in the existing range word; no header,buffer or persistent
capacity addition. Extra CSR search and generated shader/register/ELF/cold costs
remain charged. Uniform tile priority and other literal fallback stay intact.

This dossier admits only the separately preregistered actual-native selected-path
audit,then the fixed64-process early CPU screen. No performance observation or
adoption yet. Generic draw-major,mask-address and banked-only four-cell failures
retain their verdicts. Full configurations,offline/native,cost matrix,ZGX,physical
GPU,two hardware classes,scanout and quality gates remain open. Run `python3
verify.py` to independently verify the raw evidence. Canonical executables remain
external and hash-addressed. All changes local.
