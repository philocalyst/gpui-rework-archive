# Four-cell mask reuse: early correctness admission

Production7565d788dcdf62f87c43a2d4910764a3ff2be764 passes353 GPU/canvas tests
(3 ignored),strict Clippy and all336 independent exact frame comparisons across
RGBA8sRGB,BGRA8sRGB,RGBA16Float,banked/literal,inline/compact,clip chains,
fractional boundaries,transforms,density fallbacks and HDR negative/subnormal
channels. Public fixture bytes are unchanged from the independently compiled
pre-mask oracle6faae98a. Replay and proof-toggle comparisons also pass.

The bounded mutant849ea944 drops only cached Y selection. Its public fixture
process exits normally and its internal replay/compact checks pass, but the
independent pixel oracle rejects96/336 frames, all banked. The first differing
SDR byte is3098 (expected126,actual125). This is an external exact-oracle failure,
not a fabricated Rust test panic. The real candidate has zero mismatched bytes.

Only certified unit masks with all16 points inside one rectangular clip use
per-fragment caching. At most four distinct mask texels are fetched; valid cell
coverage feeds the same color multiplication and16 painter-order blends. Invalid
membership returns literal zero; valid zero coverage retains its original color
product. Final anchor/delta reduction and output conversion are unchanged.
Clip chains and boundary pixels fall back. No persistent cache,storage/header,
pipeline,API,dependency or unsafe addition. The parent mask-address optimization
remains rejected alone by native screenb8e6667b; this is a separate combined trial.

Initialsource4af395b9 passed353 tests and336 exact frames but failed strict
Clippy on an overwritten local initializer. The failed gate,generated shader,
source and executable receipts remain. Revisedsource7565d788 uses a helper
return; the GPU package was explicitly cleaned before the corrected build.
The revised WGSL is21978 bytes,SHA256
d1a06065c06f9b9f4296b23442e19519e9c3d00e99e06f30b8e5a64f631e3697,
verified inside the actual freshly rebuilt/executed render ELF. Offline modules
and native profile are not yet qualified. Shipping inventory38163 lines is+74
from rejected mask-address parent and+135 from qualified suffix baseline.
Existing CPU renderer/record/header types are byte-identical to the parent;
shader register/LLVM cost and native ELF/cold/RSS costs remain to be measured.

Run `python3 verify.py` for independent rederivation. This dossier admits only
the preregistered early shader CPU screen:64 processes atseed20261113,20%
stream/mixed improvement and<=5% scroll regression,exact work/cadence gates.
No performance observation or adoption is claimed here. Full configuration,
offline/native,cost-matrix,ZGX,physical hardware,scanout and quality gates remain
open. Canonical executables are retained in external hash-addressed storage;
only verified completed caches were reclaimed. All changes remain local.
