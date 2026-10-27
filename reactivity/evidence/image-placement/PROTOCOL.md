# Image content uses node-local coordinates

Correctness prerequisite discovered during BBTree/Solid/Ripple local-publication
research. Base `4afe067fe3e243fac40369301321f44962aa808d`; isolated branch
`local/image-placement`, worktree `/home/user/gpui-image-placement-lab`, unique
target `/home/user/gpui-image-placement-target`, raw evidence in
`/home/user/gpui-image-placement-evidence`. All changes local.

The initial-scene diagnostic at local-publication commit `bb6771c2014d` shows
an image node at layout y=48 with a transform already containing that position,
but its Canvas local rectangle also starts at y=48. Under a rounded ancestor,
the image falls outside the clip and is never leased. This predates sparse text
publication: the failure occurs during initial mounting. Exact comparison with
another full GPUI frame alone misses the shared bug.

Cephal's content_box_x/y include location + border + padding. GPUI's admitted
node transform already includes location. Emit border + padding as the image's
local origin, without subtracting large rounded global coordinates. Width and
height remain the existing content extents. No APIs/dependencies/shaders change.

Freeze the independent public regression first and demonstrate baseline pixel
failure. Compare complete pixels against a manually positioned Canvas image
with the same resource, sampling, clip geometry and transform; do not construct
the expected origin with the faulty content_box_x/y methods. Exercise rows,
columns, padding, translations/scales, rounded ancestor clipping and an ordinary
scroll. Verify image leases and acknowledged semantic placement.

After the baseline failure, preserve its exact ELF and source guards, then
freeze the correction. Run focused tests, the default/X11 GPUI+Canvas suites,
strict all-target Clippy, native port tests and actual native Todo/Library/IME
scripts. The old production implementation is the bounded negative control;
it must fail actual independent pixels, not merely a work-count assertion.

Report source/machine-code/header costs independently. This correction changes
previously incorrect output, so timing old missing-image work against correct
image work is not a performance comparison. No ZGX victory or general adoption
of the surrounding architecture experiments follows from this prerequisite.
