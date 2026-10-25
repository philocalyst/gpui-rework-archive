# Native macOS selected-text mutation

Complete crates.io `accesskit_macos` 0.27.1, upstream commit
`ce8164ba92995cfa86005b6259115e08c8244253`, archive SHA-256
`5701624bf6a11efb6d4c8e922bf44126ed96250e5faa9a7a0468c979635839a4`.
Upstream Apache-2.0 and MIT licenses are retained.

Adds the standard `setAccessibilitySelectedText:` setter, dispatching the
existing ReplaceSelectedText action only when the node advertises it. Upstream
0.27.1 exposes selected text for reading and selected-range writing, but does
not implement this selected-text setter. Earlier blanket replacement-support
claims therefore do not apply to the unpatched macOS adapter.

Selected-range mutation uses checked UTF-16 range arithmetic and exact
round-trip conversion through the matching consumer. Interior graphemes,
surrogate interiors, overflow, and out-of-range positions are rejected. Generic
read/navigation conversion retains upstream policy. The standard setter is
documented by Apple's NSAccessibilityProtocol accessibilitySelectedText API:
https://developer.apple.com/documentation/appkit/nsaccessibilityprotocol/accessibilityselectedtext%28%29

The all-target Apple cross check is compilation evidence only. No macOS runtime
or VoiceOver result is claimed. See the adjacent AccessKit/consumer patch notes
for the coordinated private exceptional-length schema.
