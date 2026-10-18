import XCTest

final class GPUIAcceptanceUITests: XCTestCase {
    private let appIdentifier = "dev.gpui.mobile.acceptance"

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
    }

    func testAccessibilityCounterAndLongScroll() throws {
        let app = launchAcceptanceApp()
        defer { app.terminate() }

        XCTAssertTrue(element(label: "GPUI mobile acceptance", in: app).waitForExistence(timeout: 20))
        XCTAssertEqual(element(label: "GPUI mobile acceptance", in: app).label, "GPUI mobile acceptance")
        XCTAssertEqual(countStatus(in: app).label, "Count: 0")
        XCTAssertTrue(element(label: "Editor", in: app).exists)

        let increment = incrementButton(in: app)
        XCTAssertTrue(increment.isHittable)
        XCTAssertEqual(increment.elementType, .button, "the published accessibility node should retain its Button role")
        increment.tap()
        let statusAfterTap = countStatus(in: app)
        print("COUNTER_AFTER_TAP immediate=\(statusAfterTap.label)")
        waitForCount(statusAfterTap, value: "Count: 1", context: "single increment tap")
        attachScreenshot("counter-updated")

        let scrollEnd = element(label: "Scroll end", in: app)
        for _ in 0..<8 where !scrollEnd.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(scrollEnd.isHittable, "the final acceptance row should be reachable by scrolling")
        attachScreenshot("scroll-end")
    }

    func testKeyboardInsetsRotationUnicodeAndReplacement() throws {
        let app = launchAcceptanceApp()
        defer { app.terminate(); XCUIDevice.shared.orientation = .portrait }
        XCTAssertTrue(waitForPortrait(app), "each keyboard test must start in portrait orientation")
        let editor = element(label: "Editor", in: app)
        XCTAssertTrue(editor.waitForExistence(timeout: 20))
        tapEditorAtNativeFrameCenter(editor, app: app, label: "keyboard-insets")
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 10), "tapping the editor should publish a UIKit keyboard element")
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: keyboard), "the software keyboard must be visible in the app window with a positive inset")
        assertKeyboardInsetMatchesGeometry(app: app, keyboard: keyboard)
        XCTAssertFalse(editor.frame.intersects(keyboard.frame), "the focused editor must remain visible above the keyboard")
        attachScreenshot("keyboard-portrait")

        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssertTrue(waitForLandscape(app))
        let landscapeKeyboard = app.keyboards.firstMatch
        XCTAssertTrue(landscapeKeyboard.waitForExistence(timeout: 10))
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: landscapeKeyboard), "the software keyboard must remain visible after rotation")
        attachScreenshot("keyboard-landscape-before-inset-assert")
        assertKeyboardInsetMatchesGeometry(app: app, keyboard: landscapeKeyboard)
        XCTAssertFalse(editor.frame.intersects(landscapeKeyboard.frame), "the focused editor must be scrolled fully above the landscape keyboard")
        attachScreenshot("keyboard-landscape")

        XCUIDevice.shared.orientation = .portrait
        XCTAssertTrue(waitForPortrait(app))
        let restoredPortraitKeyboard = app.keyboards.firstMatch
        XCTAssertTrue(restoredPortraitKeyboard.waitForExistence(timeout: 10))
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: restoredPortraitKeyboard), "the software keyboard must remain visible after restoring portrait")
        assertKeyboardInsetMatchesGeometry(app: app, keyboard: restoredPortraitKeyboard)

        // Exercise real IME composition after resizing: tap Pinyin keys, then
        // select its native candidate rather than injecting text into GPUI.
        XCTAssertTrue(selectPinyinKeyboard(app: app), "the active keyboard must expose Latin Pinyin keys and Chinese controls")
        tapPinyinKeys(app)
        let candidate = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS[c] %@", "你好")).firstMatch
        XCTAssertTrue(candidate.waitForExistence(timeout: 8), "typing n-i-h-a-o on Pinyin must offer the 你好 candidate")
        XCTAssertTrue(candidate.isHittable, "the Pinyin candidate must be visible and selectable")
        candidate.tap()
        XCTAssertEqual(editor.valueDescription, "你好", "the selected Pinyin candidate must be committed after rotation")
        attachScreenshot("rotated-pinyin-committed")

        // Select a supplementary-plane scalar from the native emoji picker.
        let emojiSwitch = app.keyboards.firstMatch.buttons["emoji"]
        XCTAssertTrue(emojiSwitch.waitForExistence(timeout: 5), "Pinyin keyboard should expose its native emoji switch")
        emojiSwitch.tap()
        let emojiKeyboard = app.keyboards.firstMatch
        XCTAssertTrue(emojiKeyboard.waitForExistence(timeout: 5))
        print("IME_EMOJI_KEYBOARD_AX_BEGIN")
        print(emojiKeyboard.debugDescription)
        print("IME_EMOJI_KEYBOARD_AX_END")
        let emoji = emojiKeyboard.keys["🙂"]
        XCTAssertTrue(emoji.waitForExistence(timeout: 5), "the native emoji keyboard should expose the supplementary-plane slightly smiling face key")
        XCTAssertTrue(emoji.isHittable)
        emoji.tap()
        XCTAssertEqual(editor.valueDescription, "你好🙂", "selecting the native emoji must append its full Unicode scalar")
        attachScreenshot("cjk-plus-emoji")

        XCTAssertTrue(selectPinyinKeyboard(app: app), "the keyboard switcher should return to Chinese-Pinyin")
        let deleteKey = app.keyboards.firstMatch.keys
            .matching(NSPredicate(format: "label == %@ OR label == %@ OR label == %@", "删除", "delete", "Delete"))
            .firstMatch
        XCTAssertTrue(deleteKey.waitForExistence(timeout: 5), "the Pinyin keyboard should expose a native delete key")
        deleteKey.tap()
        XCTAssertEqual(editor.valueDescription, "你好", "one backspace should remove the complete emoji without leaving a UTF-16 surrogate")
        attachScreenshot("emoji-deleted")

        // Clear the known two-scalar CJK fixture with real Backspace taps,
        // then verify selected-range replacement through native word selection.
        deleteKey.tap()
        deleteKey.tap()
        XCTAssertEqual(editor.valueDescription, "", "two real Backspaces should clear the known CJK fixture")
        XCTAssertTrue(selectEnglishKeyboard(app: app), "return to English before the ASCII selected-range replacement")
        typeEnglishKeys(app, "hello")
        XCTAssertEqual(editor.valueDescription, "hello")
        let editorWindow = app.windows.firstMatch
        let wordTapX = editor.frame.minX + 24
        editorWindow.coordinate(withNormalizedOffset: CGVector(dx: wordTapX / editorWindow.frame.width, dy: editor.frame.midY / editorWindow.frame.height)).doubleTap()
        let replacementKey = app.keys.matching(NSPredicate(format: "label ==[c] %@", "r")).firstMatch
        XCTAssertTrue(replacementKey.waitForExistence(timeout: 5), "the English keyboard should expose the real replacement key")
        replacementKey.tap()
        XCTAssertEqual(editor.valueDescription, "r", "a real keyboard key should replace the selected word")
        attachScreenshot("unicode-replaced-by-selected-word")
    }


    func testPinyinCompositionCommitsThroughTheEditor() throws {
        let app = XCUIApplication(bundleIdentifier: appIdentifier)
        app.launchArguments = []
        app.launch()
        defer { app.terminate(); XCUIDevice.shared.orientation = .portrait }
        XCTAssertTrue(waitForPortrait(app), "the uninstrumented app must start in portrait orientation")
        let window = app.windows.firstMatch
        XCTAssertTrue(window.waitForExistence(timeout: 20))
        // Focus before making any app accessibility queries, so the default
        // Release path is tested without the debug container-query hook.
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.284)).tap()
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 10))
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: keyboard), "Pinyin entry requires an onscreen software keyboard")
        print("IME_KEYBOARD_AX_BEGIN")
        print(app.keyboards.firstMatch.debugDescription)
        print("IME_KEYBOARD_AX_END")
        XCTAssertTrue(selectPinyinKeyboard(app: app), "the active keyboard must expose Latin Pinyin keys and Chinese input controls")
        let editor = element(label: "Editor", in: app)
        tapPinyinKeys(app)
        let candidate = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS[c] %@", "你好")).firstMatch
        XCTAssertTrue(candidate.waitForExistence(timeout: 8), "typing n-i-h-a-o on Pinyin must offer the 你好 candidate")
        XCTAssertTrue(candidate.isHittable, "the Pinyin candidate must be visible and selectable")
        candidate.tap()
        XCTAssertEqual(editor.valueDescription, "你好", "the selected Pinyin candidate must be committed to the uninstrumented GPUI editor")
        attachScreenshot("pinyin-candidate-committed-unflagged")
    }


    func testReleaseCoordinateInteractionSmoke() throws {
        let app = XCUIApplication(bundleIdentifier: appIdentifier)
        app.launchArguments = []
        app.launch()
        defer { app.terminate(); XCUIDevice.shared.orientation = .portrait }
        let window = app.windows.firstMatch
        XCTAssertTrue(window.waitForExistence(timeout: 20), "the uninstrumented Release app should open a native window")
        XCTAssertGreaterThan(window.frame.width, 0)
        attachScreenshot("release-coordinate-launch")

        // Exercise the editor in a fresh, uninstrumented process before any
        // scroll or Accessibility container query can affect focus state.
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.284)).tap()
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 10), "a coordinate tap at the screenshot-derived Release editor center should present the software keyboard")
        let windowFrame = window.frame
        let keyplaneFrame = keyboard.frame
        print("RELEASE_KEYBOARD_GEOMETRY window=\(String(describing: windowFrame)) keyplane=\(String(describing: keyplaneFrame)) keyboardHittable=\(keyboard.isHittable)")
        attachScreenshot("release-coordinate-keyboard-frame")
        let overlap = max(0, min(windowFrame.maxY, keyplaneFrame.maxY) - max(windowFrame.minY, keyplaneFrame.minY))
        XCTAssertGreaterThan(overlap, 0, "the Release software keyboard must visibly overlap the application window")
        attachScreenshot("release-coordinate-keyboard")
        let editor = element(label: "Editor", in: app)
        for character in "release" {
            let keyLabel = String(character)
            let key = app.keys.matching(NSPredicate(format: "label == %@", keyLabel)).firstMatch
            XCTAssertTrue(key.waitForExistence(timeout: 5), "the visible software keyboard should expose the \(keyLabel) key")
            key.tap()
        }
        XCTAssertTrue(editor.valueDescription.localizedCaseInsensitiveContains("release"), "on-screen keyboard input should update the GPUI editor")
        attachScreenshot("release-coordinate-after-text")

        // Check ordinary coordinate input and scrolling after the first-focus
        // smoke, then refocus the editor at its known native center.
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.225)).tap()
        attachScreenshot("release-coordinate-after-increment")
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.72)).press(forDuration: 0.1, thenDragTo: window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.38)))
        RunLoop.current.run(until: Date().addingTimeInterval(1.0))
        attachScreenshot("release-coordinate-after-scroll")
        // Return the viewport to its launch position before using the known
        // editor center again; the editor may move while the list is scrolled.
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.38)).press(forDuration: 0.1, thenDragTo: window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.72)))
        RunLoop.current.run(until: Date().addingTimeInterval(5.0))
        attachScreenshot("release-coordinate-scroll-reset")

        // Wait for the editor's native accessibility frame to stop moving after
        // the reverse drag. A fixed window coordinate can hit a scroll item if
        // momentum has not settled, even though the editor was at that point
        // before the drag.
        let refocusEditor = element(label: "Editor", in: app)
        let settleDeadline = Date().addingTimeInterval(5.0)
        var previousEditorFrame = refocusEditor.frame
        var stableEditorFrameSamples = 0
        while Date() < settleDeadline && stableEditorFrameSamples < 4 {
            RunLoop.current.run(until: Date().addingTimeInterval(0.25))
            let currentEditorFrame = refocusEditor.frame
            let frameIsStable = abs(currentEditorFrame.minX - previousEditorFrame.minX) < 0.5
                && abs(currentEditorFrame.minY - previousEditorFrame.minY) < 0.5
                && abs(currentEditorFrame.width - previousEditorFrame.width) < 0.5
                && abs(currentEditorFrame.height - previousEditorFrame.height) < 0.5
            stableEditorFrameSamples = frameIsStable ? stableEditorFrameSamples + 1 : 0
            previousEditorFrame = currentEditorFrame
        }
        XCTAssertGreaterThanOrEqual(stableEditorFrameSamples, 4, "the editor frame must settle after scroll before refocus")
        XCTAssertTrue(refocusEditor.isHittable, "the editor must be visible and hittable after resetting the scroll position")
        print("RELEASE_EDITOR_REFOCUS_FRAME \(String(describing: refocusEditor.frame))")
        refocusEditor.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        let refocusedKeyboard = app.keyboards.firstMatch
        XCTAssertTrue(refocusedKeyboard.waitForExistence(timeout: 10), "the Release editor should regain the software keyboard after button and scroll input")
        let refocusedKeyboardFrame = refocusedKeyboard.frame
        let refocusedOverlap = max(0, min(window.frame.maxY, refocusedKeyboardFrame.maxY) - max(window.frame.minY, refocusedKeyboardFrame.minY))
        XCTAssertGreaterThan(refocusedOverlap, 0, "the refocused Release keyboard must visibly overlap the app window")
        XCTAssertTrue(refocusEditor.valueDescription.localizedCaseInsensitiveContains("release"), "refocusing should preserve the typed editor value")
        attachScreenshot("release-coordinate-refocused-editor")
    }

    func testReleaseSingleTapRefocusAfterFlingSettles() throws {
        let app = XCUIApplication(bundleIdentifier: appIdentifier)
        app.launchArguments = []
        app.launch()
        defer { app.terminate(); XCUIDevice.shared.orientation = .portrait }
        let window = app.windows.firstMatch
        XCTAssertTrue(window.waitForExistence(timeout: 20))

        // Establish default, uninstrumented software-keyboard input first.
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.284)).tap()
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: app.keyboards.firstMatch, timeout: 8))
        let xKey = app.keys.matching(NSPredicate(format: "label == %@", "x")).firstMatch
        XCTAssertTrue(xKey.waitForExistence(timeout: 5))
        xKey.tap()
        let editor = element(label: "Editor", in: app)
        XCTAssertTrue(editor.valueDescription.contains("x"))

        // Dismiss the keyboard, scroll down and back up, then wait beyond the
        // recognizer's ~3.33 second maximum fling duration before refocusing.
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.225)).tap()
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.72)).press(
            forDuration: 0.1,
            thenDragTo: window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.38))
        )
        RunLoop.current.run(until: Date().addingTimeInterval(1.0))
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.38)).press(
            forDuration: 0.1,
            thenDragTo: window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.72))
        )
        RunLoop.current.run(until: Date().addingTimeInterval(5.0))

        let settledEditor = element(label: "Editor", in: app)
        var previousFrame = settledEditor.frame
        var stableSamples = 0
        for _ in 0..<6 {
            RunLoop.current.run(until: Date().addingTimeInterval(0.25))
            let frame = settledEditor.frame
            let stable = abs(frame.minX - previousFrame.minX) < 0.5
                && abs(frame.minY - previousFrame.minY) < 0.5
                && abs(frame.width - previousFrame.width) < 0.5
                && abs(frame.height - previousFrame.height) < 0.5
            stableSamples = stable ? stableSamples + 1 : 0
            previousFrame = frame
        }
        XCTAssertGreaterThanOrEqual(stableSamples, 4, "the viewport and editor frame must remain stable after fling settlement")
        XCTAssertTrue(settledEditor.isHittable)
        print("SETTLED_REFOCUS editorFrame=\(String(describing: settledEditor.frame)) samples=\(stableSamples)")
        attachScreenshot("settled-refocus-before-tap")
        settledEditor.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: keyboard, timeout: 8), "one editor tap after the full fling window must restore the visible software keyboard")
        XCTAssertTrue(editor.valueDescription.contains("x"), "settled refocus must preserve the editor value")
        assertKeyboardInsetMatchesGeometry(app: app, keyboard: keyboard)
        attachScreenshot("settled-refocus-after-tap")
    }

    func testCaretHitTestingWithPaddingHorizontalScrollAndUtf16() throws {
        let app = launchAcceptanceApp()
        defer { app.terminate(); XCUIDevice.shared.orientation = .portrait }
        XCTAssertTrue(waitForPortrait(app))
        let editor = element(label: "Editor", in: app)
        XCTAssertTrue(editor.waitForExistence(timeout: 20))
        tapEditorAtNativeFrameCenter(editor, app: app, label: "caret-origin-probe")
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: app.keyboards.firstMatch, timeout: 8))
        XCTAssertTrue(selectEnglishKeyboard(app: app), "ASCII caret probes require the real English QWERTY layout")
        let window = app.windows.firstMatch

        func typeKeys(_ text: String) {
            for character in text {
                if character.isWhitespace {
                    let space = app.keys.matching(NSPredicate(format: "identifier ==[c] %@ OR label ==[c] %@", "space", "space")).firstMatch
                    XCTAssertTrue(space.waitForExistence(timeout: 5), "the English software keyboard should expose its space bar")
                    space.tap()
                    continue
                }
                let label = String(character).lowercased()
                let key = app.keys.matching(NSPredicate(format: "label == %@", label)).firstMatch
                XCTAssertTrue(key.waitForExistence(timeout: 5), "the software keyboard should expose the \(label) key")
                key.tap()
            }
        }
        func backspace() {
            let key = app.keys.matching(NSPredicate(format: "identifier == %@ OR label == %@ OR label == %@", "delete", "Delete", "删除")).firstMatch
            XCTAssertTrue(key.waitForExistence(timeout: 5), "the current keyboard should expose Backspace")
            key.tap()
        }
        func deleteCharacters(_ count: Int) {
            // Backspace acts at the current selection. Each caret insertion
            // leaves the cursor beside its marker, so explicitly move to the
            // known end before clearing this short, known fixture value.
            editor.coordinate(withNormalizedOffset: CGVector(dx: 0.98, dy: 0.5)).tap()
            for _ in 0..<count { backspace() }
            XCTAssertEqual(editor.valueDescription, "", "the known fixture value should be cleared before the next caret case")
        }
        func placeCaret(_ x: CGFloat, label: String) {
            let y = editor.frame.midY
            print("CARET_POINT label=\(label) point=(\(x), \(y)) editor=\(String(describing: editor.frame))")
            let point = window.coordinate(withNormalizedOffset: CGVector(dx: x / window.frame.width, dy: y / window.frame.height))
            point.tap()
            print("CARET_POINT completed label=\(label)")
        }

        // The text has 8 points of internal padding. Place the caret at the
        // measured first glyph, after the first two glyphs, and at the end.
        typeKeys("abc")
        placeCaret(editor.frame.minX + 9, label: "padded-start")
        typeKeys("x")
        XCTAssertEqual(editor.valueDescription, "xabc", "a touch at the first glyph should place the caret at UTF-16 offset zero")
        attachScreenshot("caret-padded-start")

        deleteCharacters(4)
        typeKeys("abc")
        placeCaret(editor.frame.minX + 25, label: "padded-middle")
        typeKeys("x")
        XCTAssertEqual(editor.valueDescription, "abcx", "the same interior tap as native UITextField leaves the selection at its initial end")
        attachScreenshot("caret-padded-middle-native-equivalent")

        deleteCharacters(4)
        typeKeys("abc")
        placeCaret(editor.frame.minX + 37, label: "padded-end")
        typeKeys("x")
        XCTAssertEqual(editor.valueDescription, "abcx", "a touch at the final caret should map to UTF-16 offset three")
        attachScreenshot("caret-padded-end")

        deleteCharacters(4)
        let longText = "abcdefghijk lmnopqrstuv wabcdefghijk lmnopqrstuv"
        typeKeys(longText)
        XCTAssertEqual(editor.valueDescription, longText)

        // Append a real supplementary-plane scalar with the simulator emoji
        // keyboard while the field is horizontally scrolled to its end.
        let emojiSwitch = app.keyboards.firstMatch.buttons["emoji"]
        XCTAssertTrue(emojiSwitch.waitForExistence(timeout: 5))
        emojiSwitch.tap()
        let emoji = app.keyboards.firstMatch.keys["🙂"]
        XCTAssertTrue(emoji.waitForExistence(timeout: 5))
        emoji.tap()
        XCTAssertEqual(editor.valueDescription, longText + "🙂")
        XCTAssertTrue(selectEnglishKeyboard(app: app), "return to English QWERTY before ASCII caret probes")

        // The right edge is the end of the horizontally scrolled line. An
        // inserted real key must remain after the emoji; two Backspaces then
        // remove the ASCII suffix and the complete UTF-16 surrogate pair.
        placeCaret(editor.frame.maxX - 10, label: "scrolled-unicode-end")
        typeKeys("x")
        XCTAssertEqual(editor.valueDescription, longText + "🙂x", "the scrolled end hit must resolve after the supplementary scalar")
        backspace()
        backspace()
        XCTAssertEqual(editor.valueDescription, longText, "one Backspace must remove the complete supplementary scalar")
        attachScreenshot("caret-scrolled-unicode-end")

        // Now hit near the left edge of the scrolled viewport. The position
        // must include horizontal scroll rather than resetting to document 0.
        placeCaret(editor.frame.minX + 20, label: "scrolled-left")
        typeKeys("x")
        let scrolledValue = editor.valueDescription
        guard let inserted = scrolledValue.firstIndex(of: "x") else {
            XCTFail("the left-viewport caret probe should insert its marker")
            return
        }
        let utf16Offset = scrolledValue[..<inserted].utf16.count
        print("CARET_SCROLL_INSERT valueLengthUtf16=\(scrolledValue.utf16.count) insertedUtf16Offset=\(utf16Offset)")
        XCTAssertGreaterThan(utf16Offset, 8, "the left visible point must map into the horizontally scrolled document")
        XCTAssertLessThan(utf16Offset, longText.utf16.count - 3, "the left visible point must remain before the document end")
        attachScreenshot("caret-horizontal-scroll-left")
    }

    func testBackgroundResumeAndFreshRelaunch() throws {
        let app = launchAcceptanceApp()
        XCTAssertTrue(element(label: "GPUI mobile acceptance", in: app).waitForExistence(timeout: 20))
        incrementButton(in: app).tap()
        waitForCount(countStatus(in: app), value: "Count: 1", context: "background/resume counter")

        XCUIDevice.shared.press(.home)
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 10))
        app.activate()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 15))
        XCTAssertEqual(element(label: "Lifecycle: active", in: app).label, "Lifecycle: active")
        XCTAssertEqual(countStatus(in: app).label, "Count: 1")
        attachScreenshot("resumed")

        app.terminate()
        app.launchArguments = []
        app.launch()
        XCTAssertTrue(element(label: "GPUI mobile acceptance", in: app).waitForExistence(timeout: 20))
        XCTAssertEqual(countStatus(in: app).label, "Count: 0", "a fresh process must recreate the example model")
        attachScreenshot("fresh-relaunch")
        app.terminate()
    }


    private func launchAcceptanceApp() -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: appIdentifier)
        app.launchArguments = []
        app.launch()
        return app
    }

    private func waitForCount(_ status: XCUIElement, value: String, context: String) {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "label == %@", value),
            object: status
        )
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 2), .completed, "\(context) should publish \(value) within two seconds")
        XCTAssertEqual(status.label, value)
    }

    private func typeEnglishKeys(_ app: XCUIApplication, _ text: String) {
        for character in text.lowercased() {
            let key = app.keys.matching(NSPredicate(format: "label ==[c] %@", String(character))).firstMatch
            XCTAssertTrue(key.waitForExistence(timeout: 5), "the English software keyboard should expose the \(character) key")
            key.tap()
        }
    }

    private func element(label: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)
            .matching(NSPredicate(format: "label == %@", label))
            .firstMatch
    }

    private func countStatus(in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)
            .matching(NSPredicate(format: "label BEGINSWITH %@", "Count: "))
            .firstMatch
    }

    private func incrementButton(in app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label == %@", "Increment")).firstMatch
    }

    private func tapEditorAtNativeFrameCenter(_ editor: XCUIElement, app: XCUIApplication, label: String) {
        let window = app.windows.firstMatch
        print("EDITOR_NATIVE_TAP label=\(label) editorFrame=\(String(describing: editor.frame)) windowFrame=\(String(describing: window.frame)) hittable=\(editor.isHittable)")
        attachScreenshot("\(label)-editor-before-coordinate-tap")
        window.coordinate(withNormalizedOffset: CGVector(dx: editor.frame.midX / window.frame.width, dy: editor.frame.midY / window.frame.height)).tap()
    }

    private func keyboardInset(in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)
            .matching(NSPredicate(format: "label BEGINSWITH %@", "Keyboard inset: "))
            .firstMatch
    }

    private func keyboardDescription(in app: XCUIApplication) -> String {
        let current = app.keyboards.firstMatch
        return current.exists ? String(describing: current.frame) : "absent"
    }

    private func waitForVisibleKeyboard(app: XCUIApplication, keyboard: XCUIElement, timeout: TimeInterval = 8) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            let currentKeyboard = app.keyboards.firstMatch
            guard currentKeyboard.exists else {
                print("IME_VISIBLE_POLL keyboard=absent inset=\(keyboardInset(in: app).label)")
                RunLoop.current.run(until: Date().addingTimeInterval(0.2))
                continue
            }
            let windowFrame = app.windows.firstMatch.frame
            let keyboardFrame = currentKeyboard.frame
            let overlap = max(0, min(windowFrame.maxY, keyboardFrame.maxY) - max(windowFrame.minY, keyboardFrame.minY))
            let label = keyboardInset(in: app).label
            let pieces = label.split(separator: " ")
            let inset = pieces.count >= 2 ? Int(pieces[pieces.count - 2]) ?? 0 : 0
            print("IME_VISIBLE_POLL inset=\(label) windowFrame=\(String(describing: windowFrame)) keyboardFrame=\(String(describing: keyboardFrame)) overlap=\(overlap)")
            if inset > 0 && overlap > 0 { return true }
            RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        }
        return false
    }

    private func assertKeyboardInsetMatchesGeometry(app: XCUIApplication, keyboard: XCUIElement, file: StaticString = #filePath, line: UInt = #line) {
        let inset = keyboardInset(in: app)
        XCTAssertTrue(inset.waitForExistence(timeout: 8), "keyboard inset probe is required for the native acceptance app", file: file, line: line)
        let components = inset.label.split(separator: " ")
        guard components.count >= 2, let reported = Int(components[components.count - 2]) else {
            XCTFail("unexpected keyboard inset label: \(inset.label)", file: file, line: line)
            return
        }
        let windowFrame = app.windows.firstMatch.frame
        let fullKeyboard = app.descendants(matching: .any).matching(identifier: "inputView").firstMatch
        XCTAssertTrue(fullKeyboard.waitForExistence(timeout: 5), "the native inputView container is required to measure the complete UIKit keyboard frame", file: file, line: line)
        let nativeKeyboardFrame = fullKeyboard.frame
        let actualOcclusion = nativeKeyboardFrame.intersection(windowFrame)
        let keyplaneFrame = keyboard.frame
        print("IME_NATIVE_GEOMETRY inset=\(inset.label) windowFrame=\(String(describing: windowFrame)) nativeInputViewFrame=\(String(describing: nativeKeyboardFrame)) keyplaneFrame=\(String(describing: keyplaneFrame))")
        XCTAssertGreaterThan(actualOcclusion.height, 0, "the complete native keyboard container must overlap the app window", file: file, line: line)
        XCTAssertLessThanOrEqual(abs(reported - Int(actualOcclusion.height.rounded())), 8, "IME inset must match full native inputView occlusion in window coordinates", file: file, line: line)
        XCTAssertGreaterThan(keyplaneFrame.intersection(actualOcclusion).height, 0, "the AX keyplane must overlap the full keyboard occlusion", file: file, line: line)
        XCTAssertGreaterThanOrEqual(keyplaneFrame.minY, actualOcclusion.minY - 8, "the AX keyplane must be contained by the full keyboard region", file: file, line: line)
        XCTAssertLessThanOrEqual(keyplaneFrame.maxY, actualOcclusion.maxY + 8, "the AX keyplane must be contained by the full keyboard region", file: file, line: line)
    }


    private func tapPinyinKeys(_ app: XCUIApplication) {
        for character in "nihao" {
            let label = String(character)
            let key = app.keys.matching(NSPredicate(format: "label == %@", label)).firstMatch
            XCTAssertTrue(key.waitForExistence(timeout: 5), "the onscreen Pinyin keyboard should expose the \(label) key")
            key.tap()
        }
    }


    private func selectEnglishKeyboard(app: XCUIApplication) -> Bool {
        for attempt in 0..<8 {
            let keyboard = app.keyboards.firstMatch
            let nextKeyboard = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@ OR identifier CONTAINS[c] %@", "next keyboard", "globe")).firstMatch
            let chineseDelete = keyboard.keys["删除"].exists
            let chineseNumbers = keyboard.descendants(matching: .any)
                .matching(NSPredicate(format: "label == %@ OR identifier == %@", "数字", "numbers"))
                .firstMatch.exists
            let isChinesePinyin = chineseDelete || chineseNumbers
            let hasLetters = "abcxyz".allSatisfy { character in
                keyboard.keys.matching(NSPredicate(format: "label ==[c] %@", String(character))).firstMatch.exists
            }
            let hasEnglishDelete = keyboard.keys
                .matching(NSPredicate(format: "label ==[c] %@", "delete"))
                .firstMatch.exists
            print("KEYBOARD_LAYOUT attempt=\(attempt) pinyin=\(isChinesePinyin) letters=\(hasLetters) englishDelete=\(hasEnglishDelete) labels=\(keyboard.keys.allElementsBoundByIndex.map(\.label))")
            if !isChinesePinyin && hasLetters && hasEnglishDelete { return true }
            guard nextKeyboard.waitForExistence(timeout: 1) else {
                print("ENGLISH_KEYBOARD_NOT_FOUND\n\(app.debugDescription)")
                return false
            }
            nextKeyboard.tap()
        }
        print("ENGLISH_KEYBOARD_FINAL_TREE\n\(app.debugDescription)")
        return false
    }

    private func selectPinyinKeyboard(app: XCUIApplication) -> Bool {
        for _ in 0..<8 {
            let keyboard = app.keyboards.firstMatch
            let latinPinyinKeysPresent = keyboard.keys["n"].exists && keyboard.keys["i"].exists && keyboard.keys["h"].exists && keyboard.keys["a"].exists && keyboard.keys["o"].exists
            let numericInputKeyPresent = keyboard.descendants(matching: .any)
                .matching(NSPredicate(format: "label == %@ OR label == %@ OR identifier == %@", "数字", "numbers", "more"))
                .firstMatch.exists
            let chineseInputControlsPresent = keyboard.keys["删除"].exists && numericInputKeyPresent && keyboard.buttons["emoji"].exists
            if latinPinyinKeysPresent && chineseInputControlsPresent {
                print("IME_KEYBOARD_LAYOUT confirmed=Chinese-Pinyin controls=删除,numbers-or-数字,emoji; candidate commit is still required")
                return true
            }

            // The system omits the globe button when only one keyboard is enabled.
            // If it is present, advance to the next layout and inspect again.
            let nextKeyboard = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@ OR identifier CONTAINS[c] %@", "next keyboard", "globe")).firstMatch
            guard nextKeyboard.waitForExistence(timeout: 1) else { return false }
            nextKeyboard.tap()
        }
        return false
    }

    private func waitForLandscape(_ app: XCUIApplication, timeout: TimeInterval = 10) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            let frame = app.windows.firstMatch.frame
            if frame.width > frame.height { return true }
            RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        }
        return false
    }

    private func waitForPortrait(_ app: XCUIApplication, timeout: TimeInterval = 10) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            let frame = app.windows.firstMatch.frame
            if frame.height >= frame.width { return true }
            RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        }
        return false
    }

    private func attachScreenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

private extension XCUIElement {
    var valueDescription: String {
        (value as? String) ?? label
    }
}
