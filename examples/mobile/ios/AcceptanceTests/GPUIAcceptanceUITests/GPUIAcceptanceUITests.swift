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
        defer {
            app.terminate()
            XCUIDevice.shared.orientation = .portrait
        }
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

        editor.typeText("漢字🙂")
        XCTAssertTrue(editor.valueDescription.contains("漢字🙂"), "CJK and supplementary-plane text should reach the editor")
        replaceEditorContents(editor, app: app, with: "再編集🙂")
        XCTAssertEqual(editor.value as? String, "再編集🙂")
        attachScreenshot("unicode-replaced")
    }

    func testPinyinCompositionCommitsThroughTheEditor() throws {
        let app = launchAcceptanceApp()
        defer {
            app.terminate()
            XCUIDevice.shared.orientation = .portrait
        }
        XCTAssertTrue(waitForPortrait(app), "each keyboard test must start in portrait orientation")

        let editor = element(label: "Editor", in: app)
        XCTAssertTrue(editor.waitForExistence(timeout: 20))
        tapEditorAtNativeFrameCenter(editor, app: app, label: "pinyin")
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 10))
        XCTAssertTrue(waitForVisibleKeyboard(app: app, keyboard: keyboard), "Pinyin entry requires an on-screen software keyboard")

        // Enable Chinese (Simplified) Pinyin in the simulator keyboard settings.
        // A missing candidate is a failure, never a silent skip or a unicode-only pass.
        for _ in 0..<8 {
            editor.typeText("nihao")
            let candidate = app.descendants(matching: .any)
                .matching(NSPredicate(format: "label CONTAINS[c] %@", "你好"))
                .firstMatch
            if candidate.waitForExistence(timeout: 1) {
                candidate.tap()
                XCTAssertTrue(editor.valueDescription.contains("你好"), "the selected Pinyin candidate must be committed to GPUI")
                attachScreenshot("pinyin-candidate-committed")
                return
            }

            replaceEditorContents(editor, app: app, with: "")
            let nextKeyboard = app.keyboards.buttons
                .matching(NSPredicate(format: "label CONTAINS[c] %@ OR identifier CONTAINS[c] %@", "next keyboard", "globe"))
                .firstMatch
            guard nextKeyboard.exists else {
                XCTFail("No keyboard-switch control found. Enable Chinese (Simplified) Pinyin in this simulator. Keyboard tree: \(app.keyboards.firstMatch.debugDescription)")
                return
            }
            nextKeyboard.tap()
        }
        XCTFail("No installed keyboard offered the Pinyin candidate 你好. Enable Chinese (Simplified) Pinyin in this simulator.")
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

        let window = app.windows.firstMatch
        print("IME_NATIVE_GEOMETRY inset=\(inset.label) windowFrame=\(String(describing: window.frame)) keyboardFrame=\(String(describing: keyboard.frame))")
        let geometric = max(0, min(window.frame.maxY, keyboard.frame.maxY) - max(window.frame.minY, keyboard.frame.minY))
        XCTAssertGreaterThan(reported, 0, "an offscreen UIKit keyboard proxy is not a presented software keyboard", file: file, line: line)
        XCTAssertGreaterThan(geometric, 0, "the keyboard frame must overlap the app window", file: file, line: line)
        XCTAssertLessThanOrEqual(abs(reported - Int(geometric.rounded())), 8, "IME inset should match keyboard-only overlap in window coordinates", file: file, line: line)
    }

    private func replaceEditorContents(_ editor: XCUIElement, app: XCUIApplication, with replacement: String) {
        editor.press(forDuration: 1.1)
        let selectAll = app.menuItems["Select All"].firstMatch
        XCTAssertTrue(selectAll.waitForExistence(timeout: 4), "the editor should expose Select All for deterministic replacement")
        selectAll.tap()
        editor.typeText(replacement)
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
