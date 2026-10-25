comparators/mygo and comparators/nanoui in /root/gpui-bench-luna are third-party git clones (partial clones) that were
untracked directories of the worktree, so the snapshot commit below this one does not contain them. Each directory here holds:
  info.txt       origin URL, HEAD sha, unpushed-commit count (0 for both), and git status at archive time
  tracked.patch  git diff HEAD --binary (local changes to tracked files)
  untracked.tar  untracked, non-ignored files
Ignored build output (nanoui/.zig-cache, ~200 MB) was not archived.

Also excluded from this worktree's snapshot because GitHub rejects files over 100 MB:
  reactivity/benchmarks/luna-accessibility-floor/runs/session-bus-late-activation-20261021/late-activation-probe-original
  104,280,640 bytes, sha256 c7f74470a0f53c2823c9f54d47e31c9d3ae38d595f65919e0ba3919599283343
  stored as the asset "luna-late-activation-probe-original" on the private release "archive-assets-20261024" of this repo.
