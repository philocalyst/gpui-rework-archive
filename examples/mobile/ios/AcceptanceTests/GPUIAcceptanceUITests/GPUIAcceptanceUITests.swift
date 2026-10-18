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
        XCTAssertEqual(countStatus(in: app).label, "Count: 1")
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
        XCTAssertFalse(editor.frame.intersects(landscapeKeyboard.frame))
        attachScreenshot("keyboard-landscape")
        XCUIDevice.shared.orientation = .portrait
        XCTAssertTrue(waitForPortrait(app))
        let restoredPortraitKeyboard = app.keyboards.firstMatch
        XCTAssertTrue(restoredPortraitKeyboard.waitForExistence(timeout: 10))
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: restoredPortraitKeyboard), "the software keyboard must remain visible after restoring portrait")
        assertKeyboardInsetMatchesGeometry(app: app, keyboard: restoredPortraitKeyboard)
        app.typeText("漢字🙂")
        XCTAssertTrue(editor.valueDescription.contains("漢字🙂"), "CJK and supplementary-plane text should reach the editor")
        replaceEditorContents(editor, app: app, with: "再編集🙂")
        XCTAssertEqual(editor.value as? String, "再編集🙂")
        attachScreenshot("unicode-replaced")
    }


    func testPinyinCompositionCommitsThroughTheEditor() throws {
        let app = launchAcceptanceApp()
        defer { app.terminate(); XCUIDevice.shared.orientation = .portrait }
        XCTAssertTrue(waitForPortrait(app), "each keyboard test must start in portrait orientation")
        let editor = element(label: "Editor", in: app)
        XCTAssertTrue(editor.waitForExistence(timeout: 20))
        tapEditorAtNativeFrameCenter(editor, app: app, label: "pinyin")
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 10))
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: keyboard), "Pinyin entry requires an on-screen software keyboard")
        print("IME_KEYBOARD_AX_BEGIN")
        print(app.keyboards.firstMatch.debugDescription)
        print("IME_KEYBOARD_AX_END")
        XCTAssertTrue(selectPinyinKeyboard(app: app), "the active keyboard must expose Latin Pinyin keys and Chinese input controls")
        attachScreenshot("pinyin-keyboard-selected")
        for character in "nihao" {
            let label = String(character)
            let key = app.keys.matching(NSPredicate(format: "label == %@", label)).firstMatch
            XCTAssertTrue(key.waitForExistence(timeout: 5), "the onscreen Pinyin keyboard must expose the \(label) key")
            key.tap()
        }
        attachScreenshot("pinyin-composition")
        let candidate = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS[c] %@", "你好")).firstMatch
        XCTAssertTrue(candidate.waitForExistence(timeout: 8), "typing n-i-h-a-o on Pinyin must offer the 你好 candidate")
        XCTAssertTrue(candidate.isHittable, "the Pinyin candidate must be visible and selectable")
        candidate.tap()
        XCTAssertTrue(editor.valueDescription.contains("你好"), "the selected Pinyin candidate must be committed to GPUI")
        attachScreenshot("pinyin-candidate-committed")
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
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.225)).tap()
        attachScreenshot("release-coordinate-after-increment")
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.72)).press(forDuration: 0.1, thenDragTo: window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.38)))
        attachScreenshot("release-coordinate-after-scroll")
        window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.284)).tap()
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 10), "a coordinate tap on the Release editor should present the software keyboard")
        let windowFrame = window.frame
        let keyplaneFrame = keyboard.frame
        let overlap = max(0, min(windowFrame.maxY, keyplaneFrame.maxY) - max(windowFrame.minY, keyplaneFrame.minY))
        XCTAssertGreaterThan(overlap, 0, "the Release software keyboard must visibly overlap the application window")
        attachScreenshot("release-coordinate-keyboard")
        app.typeText("Release🙂")
        attachScreenshot("release-coordinate-after-text")
    }

    func testBackgroundResumeAndFreshRelaunch() throws {
        let app = launchAcceptanceApp()
        XCTAssertTrue(element(label: "GPUI mobile acceptance", in: app).waitForExistence(timeout: 20))
        incrementButton(in: app).tap()
        XCTAssertEqual(countStatus(in: app).label, "Count: 1")

        XCUIDevice.shared.press(.home)
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 10))
        app.activate()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 15))
        XCTAssertEqual(element(label: "Lifecycle: active", in: app).label, "Lifecycle: active")
        XCTAssertEqual(countStatus(in: app).label, "Count: 1")
        attachScreenshot("resumed")

        app.terminate()
        app.launchArguments = ["--gpui-test-accessibility-container-query", "--gpui-test-log-ime"]
        app.launch()
        XCTAssertTrue(element(label: "GPUI mobile acceptance", in: app).waitForExistence(timeout: 20))
        XCTAssertEqual(countStatus(in: app).label, "Count: 0", "a fresh process must recreate the example model")
        attachScreenshot("fresh-relaunch")
        app.terminate()
    }


    private func launchAcceptanceApp() -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: appIdentifier)
        app.launchArguments = ["--gpui-test-accessibility-container-query", "--gpui-test-log-ime"]
        app.launch()
        return app
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

    private func waitForVisibleKeyboard(app: XCUIApplication, keyboard: XCUIElement, timeout: TimeInterval = 8) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            let windowFrame = app.windows.firstMatch.frame
            let keyboardFrame = keyboard.frame
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


    private func replaceEditorContents(_ editor: XCUIElement, app: XCUIApplication, with replacement: String) {
        editor.press(forDuration: 1.1)
        let selectAll = app.menuItems["Select All"].firstMatch
        XCTAssertTrue(selectAll.waitForExistence(timeout: 4), "the editor should expose Select All for deterministic replacement")
        selectAll.tap()
        app.typeText(replacement)
    }


    private func selectPinyinKeyboard(app: XCUIApplication) -> Bool {
        for _ in 0..<8 {
            let keyboard = app.keyboards.firstMatch
            let latinPinyinKeysPresent = keyboard.keys["n"].exists && keyboard.keys["i"].exists && keyboard.keys["h"].exists && keyboard.keys["a"].exists && keyboard.keys["o"].exists
            let chineseInputControlsPresent = keyboard.keys["删除"].exists && keyboard.keys["数字"].exists && keyboard.buttons["emoji"].exists
            if latinPinyinKeysPresent && chineseInputControlsPresent {
                print("IME_KEYBOARD_LAYOUT confirmed=Chinese-Pinyin active controls=删除,数字,表情符号")
                return true
            }

            // The system omits the globe button when only one keyboard is enabled.
            // If it is present, advance to the next layout and inspect again.
            let nextKeyboard = keyboard.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@ OR identifier CONTAINS[c] %@", "next keyboard", "globe")).firstMatch
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
