# Image placement correctness prerequisite

Qualified locally; no performance or ZGX comparison claim. Production correction
`2c4e7e65b174b98c1efc41aff1920c0f352b4bf7`; baseline production
`4afe067fe3e243fac40369301321f44962aa808d`. Preregistration
`1fd301f9c0cbe7b25be39316483879a4e41fd0d2`; independent baseline oracle
`5c4a6c47d07dbf0e36f24e79b5ef19fc0059698b`.

GPUI already puts a node's layout position into its admitted transform. It also
used Cephal's location-inclusive content_box_x/y as the image's local rectangle
origin, applying position twice. The local-publication research exposed an image
intended at y=50 drawn at y=98 and omitted by a rounded ancestor clip. Comparing
against another full GPUI frame did not expose the shared initial-scene bug.

The correction uses border + padding for the local image origin. Content extents
and all public interfaces are unchanged. Direct addition preserves local padding
without cancellation against a large global location. No dependency, shader,
unsafe code, retained field, or ownership change.

## Independent oracle and qualification

The public regression manually places a Canvas image independently of GPUI layout
helpers. It compares every byte, resource presence and semantic containment:
rows/columns, parent and image padding, fractional scale/translation, rounded
ancestor clipping, nearest/linear sampling, and an ordinary scrolled image.
The old production implementation fails both tests on actual differing pixels;
the corrected implementation passes all 16 placement combinations and scrolling.
The exact failed baseline ELF and source guards are preserved.

- Focused tests and strict Clippy pass.
- GPUI + Canvas default: 991 passed, 13 explicitly ignored.
- GPUI + Canvas X11: 1065 passed, 44 explicitly ignored.
- Actual native workload port: 10 tests passed.
- Strict all-target Clippy passes in both feature configurations.
- Eleven explicitly executed native Todo/Library/controlled-list/overscan/IME/
  AT-SPI scripts pass on private X11 :94. Ignored tests were not silently counted
  as passing the ordinary suites.
- Every recorded source guard is empty. Executed test ELFs were copied to the
  content-addressed preservation store before subsequent builds.

## Costs and limits

Shipping inventory remains 36,962 non-test lines. The correction replaces two
expressions; no retained header or capacity changes. Native example ELF remains
26,306,600 bytes. Its linked present_walk shrinks 25,808 to 25,792 bytes, with
explicit prologue subtractions 4096+216 to 4096+200 bytes; this is linked code
inspection, not a latency measurement or total stack-depth guarantee.

No timing compares the old missing/misplaced image work with correct rendering.
Machine-code references use the preserved production-equivalent native port
baseline and candidate standalone build before test feature unification.
Environment is a KVM VM with software Vulkan selected explicitly, not physical
GPU or scanout qualification. The surrounding local-publication and scroll
experiments remain separate and retain their failed gates.

Run `python3 verify.py` to verify the manifest, gate counts, baseline pixel failure,
source guards and preserved binary hashes. Raw commands, stdout/stderr, source
commits, compiler/environment, machine-code inspection and inventory are included.
