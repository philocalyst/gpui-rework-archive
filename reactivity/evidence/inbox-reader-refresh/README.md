# Publish Reader status changes after exact inbox delivery

An exact `with_inbox_for` edit can invalidate a dependent question without
consuming a completion. The runtime refreshed that question to Pending but
discarded the refresh result when choosing between a direct patch and owner
description. Typed `with_ready` correctly returned None while the visible Reader
kept its previous chrome. The owner now publishes the Pending/Updating state,
retaining the previous content according to the existing Reader policy.

The fix propagates the existing refresh boolean into the existing description
gate. It adds no retained field, queue, recipe, dependency or public API. Sources
whose questions do not change retain the exact path.

Root qualifies `8c56ff0bbedbcdfde7484a97182b104aadccdbf5`: **240 passed,
five ignored**, ten harnesses, and strict default all-target checks pass. A
separate clean original-runtime control compiles and fails the exact public
regression at its missing Updating assertion, exit 101. Both actual regression
executables are frozen. The 12,010 materialized file guards match per run;
baseline and fixed trees differ only in `runtime/turn.rs`, with the same test.

Core is **31,814** non-test/non-comment lines, **+1**, including build code.
The qualification archive contains raw logs, command/toolchain records, source
guards, exact changed source and patch, both regression executables and their
hashes. Every archive member was reopened and verified. It is not a standalone
snapshot of every dependency. No timing, RSS, native-platform runtime or binary
size improvement is inferred from these functional gates.
