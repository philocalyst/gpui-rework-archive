# Portable GPU zero-source research

[The reviewed report](../../docs/gpu-zero-floor-luna.md) audits Core and HAL startup owners at shipping `8c17a763ee`. `producer.md` retains the original Luna response byte for byte; `review.json` records source checks and the rejected historical citation. The reviewed report governs the implementation direction.

Core eagerly creates a 512 KiB texture-copy zero source; DX12/GLES have a separate 256 KiB HAL buffer source. These are descriptor sizes. This read-only audit supplies no new allocation, GPU-memory, process-RSS or timing result. CPU-first blank presentation still avoids constructing a GPU device.

Root review withdrew the producer's inaccessible Dawn D3D12 pin and unverified historical render-target claim. The same accessible commit as its CommandBuffer example instead preserves an upload-copy fallback. The WebGPU security section was checked at an exact source pin; the producer's obsolete fragment was corrected. Full third-party source files are not copied into this evidence directory; hashes record the bytes actually read.

The implementation gates now explicitly require fallible admission before consuming initialization-tracker state, queue-order rather than handle-publication proof, no ordinary-submit scan added without charging its cost, lock-rank/callback review including outer caller guards, exact cleanup, and portable backend coverage. No lazy zero-source or atlas coverage-certificate implementation has been accepted. The next isolated spike targets the unused default external-texture parameters buffer/upload, not all startup owners at once.
