# iOS app acceptance tests

`GPUIAcceptanceUITests.xcodeproj` builds the Rust acceptance executable from this checkout with `examples/mobile/ios/build-rust.sh`, packages it with the shared iOS `Info.plist`, and runs XCUITest against bundle ID `dev.gpui.mobile.acceptance`. The small Swift application target exists only so Xcode can build/install the actual Rust app as the UI test target; its placeholder executable is replaced by the Rust package before installation.

Run from macOS after installing the simulator Rust target and selecting a booted iPhone simulator:

```sh
IOS_SIMULATOR_UDID=<simulator-uuid> ./examples/mobile/ios/run-app-acceptance.sh
```

Enable **Chinese (Simplified) – Pinyin** in the simulator’s keyboard settings before running the suite. The Pinyin test fails if it cannot find and commit the `你好` candidate; it does not silently treat direct Unicode insertion as IME coverage. The other editor test covers direct CJK/emoji entry and selection replacement. XCUITest geometry and the keyboard-only inset probe are both checked with the keyboard shown in portrait and landscape.

The `.xcresult` bundle and full `xcodebuild` log are kept under `target/ios-app-acceptance/run.*`. Screenshots are attached to individual test activities inside the result bundle. The suite checks the app’s accessibility identifiers/roles and pointer activation; XCUITest tapping is not a substitute for enabling VoiceOver and testing its spoken focus order and accessibility-action activation on-device. The current acceptance app supports a single iOS scene, so the suite does not claim multiwindow coverage. The existing `run-native-text-input-test.sh` remains a separate UIKit protocol-level test and does not replace these app-level checks.
