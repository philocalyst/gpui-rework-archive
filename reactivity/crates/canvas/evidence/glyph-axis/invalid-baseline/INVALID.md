These 500 rows do not compare the preceding output-cache algorithm with
GlyphAxis. The purported saved baseline was copied after a GlyphAxis rebuild;
both binaries report the new 126744 geometric queries for the labels fixture.
The original output-cache binary recorded 1846272. Preserve these rows only as
an invalid experiment audit. Do not use their timings as a change measurement.
The corrected runner builds baseline source 62f6841939 in a separate worktree
and target directory, checks both activation counts before collecting rows,
and checks immutable executable hashes before every invocation.
