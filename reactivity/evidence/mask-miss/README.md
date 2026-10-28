# Whole-pixel mask miss: early GPU admission

Production b817779c5609a038edd8f7d22f46863416c9e17e passes 353 GPU/canvas
tests (3 ignored), strict Clippy, and all 336 unchanged public fixture images
against independent pre-change oracle 6faae98a. The bounded mutant 6afe48dd
removes only the whole-pixel condition and fails the ordinary proof-toggle
fixture: 3718 differing bytes, first byte 3098 expected 126, actual 125.
Independent oracle and candidate equal the failed mutant's proof-disabled image.
All source guards pass; executed binaries are retained by hash. Shipping core
is 38207 non-test code lines, +26 versus mask-tiles and +179 versus suffix.

This is admission to the preregistered native audit and screen only. No full
configuration/offline qualification, end-to-end performance win, adoption,
hardware cache-hit improvement, ZGX victory, or quality/scanout claim.
