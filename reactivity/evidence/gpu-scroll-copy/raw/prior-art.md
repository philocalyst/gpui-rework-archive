# Prior art and the scope of the transfer

Scroll-image reuse is established graphics practice. DXGI1.2 `Present1` accepts
scroll and dirty regions, and its documentation requires coherent contents for
all updated regions. Multiple swapchain buffers require tracking which content
each buffer contains. [Microsoft presentation documentation](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-1-2-presentation-improvements).

This experiment uses an owned backing and separate overlap scratch; it assumes
nothing about swapchain preservation. Its application-transparent admission comes
from exact ordered canonical-command equivalence plus exact presentation-token
authority. The scroll operation is not claimed as a new invention or a BBTree cache
hit-rate improvement. [DXGI scroll/dirty parameter semantics](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_present_parameters).

BBTree supplies a useful discipline: gather immutable evidence, then commit ordered
mutations while invalidating stale evidence at structural boundaries. Its memory-yield
scheduler overlaps latency; that does not establish that a general UI async executor
would improve cache hit rates. Prior local breadth/column/memory-lane experiments
and their control regressions remain in the campaign record.

Solid's creation/read/block separation and coherent transition visibility remain
relevant upstream. This image experiment does not change task wakeups or claim to
implement Solid's async semantics. External blocked tasks still need real readiness
notifications; no no-op-waker polling of external work and no mutable window borrow
across await are introduced. Consult the pinned BBTree/Solid research and previous
negative task experiments in the campaign dossier for those separate obligations.
