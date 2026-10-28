# Queued wake after native retirement

The frozen Todo benchmark exposed a panic when animation left a `WorkReady`
callback queued after `CloseRequested`. The native host kept `Some(Win)` after
`Win::close` had removed its runtime; delivery then assumed that owner was mounted.

Retirement now takes the host's owner before closing it. Closing still cancels
all lanes before destroying the model. Later callbacks see no owner to deliver
into; no new lifecycle flag or callback-specific exception is needed.

The real native lifecycle test explicitly dispatches `WorkReady` between window
retirement and `Exiting`. With the original production code it reproduces the
same `mounted owner exists` panic and exits 101. With the change, all eight
target/rejection/retirement cases pass, including pending upgrade close and direct
host drop. All 13 public Remote delivery/lifetime tests pass as well. Scripts,
full logs and the exact patch accompany this record.

These are functional checks on private Xvfb/software Vulkan. They establish no
frame-time improvement or foreign-platform runtime result. The original Todo
benchmark is preserved, including its three failed animation closes; it was not
rerun with this fix.
