# Pixel goldens (gpui_wgpu)

Infrequent GPU-backed image comparison — never part of PR gates. Run on a nightly/manual
GPU runner (or a machine with a software adapter).

- Compare: `GPUI_GOLDEN=1 cargo test -p gpui_ce_wgpu --features test-support --test pixel_goldens`
- Regenerate (bless): `GPUI_GOLDEN_UPDATE=1 GPUI_GOLDEN=1 cargo test -p gpui_ce_wgpu --features test-support --test pixel_goldens`
- Thresholds: per-channel mean abs-diff <= 1 and max <= 8 (tolerates 1-LSB cross-driver
  drift while catching real misrenders). On mismatch the actual PNG is written to
  `/tmp/gpui-golden-<case>-actual.png` for visual diffing.
- Goldens live per adapter/platform under `<adapter>/`; the harness writes `default/` by
  default. Rename to `metal/`, `dx12/`, `vulkan/`, etc. when a per-adapter matrix is needed.
- Every scene paints the full frame, so goldens are independent of the platform clear color
  and portable across adapters. The scenes are font-free (quads + underlines only).