#!/usr/bin/env python3
"""Install and exercise GPUI's Android NativeActivity example on x86_64.

The runner verifies APK metadata and native entry points, then drives controls by
accessibility labels. An optional test-only InputMethodService fixture sends real
InputConnection composition, commit, UTF-16 selection replacement, and delete calls.
"""
from __future__ import annotations

import argparse
import base64
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time
import zipfile
import xml.etree.ElementTree as ET


def run(*args: str, check: bool = True, timeout: int = 30) -> str:
    result = subprocess.run(args, text=True, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, timeout=timeout)
    if check and result.returncode:
        raise RuntimeError(f"command failed ({result.returncode}): {' '.join(args)}\n{result.stdout}")
    return result.stdout


def adb(serial: str, *args: str, check: bool = True, timeout: int = 30) -> str:
    return run(ADB, "-s", serial, *args, check=check, timeout=timeout)


def resolve_tool(name: str) -> str:
    found = shutil.which(name)
    if found:
        return found
    sdk = os.environ.get("ANDROID_HOME") or os.environ.get("ANDROID_SDK_ROOT")
    if sdk:
        if name == "adb":
            candidate = Path(sdk) / "platform-tools" / "adb"
        elif name == "aapt":
            matches = sorted((Path(sdk) / "build-tools").glob("*/aapt"))
            candidate = matches[-1] if matches else Path("/nonexistent")
        else:
            candidate = Path("/nonexistent")
        if candidate.exists():
            return str(candidate)
    raise RuntimeError(f"{name} not found; configure Android SDK tools in PATH or ANDROID_HOME")


def parse_tree(xml: str) -> ET.Element:
    return ET.fromstring(xml)


def exact_labels(xml: str) -> set[str]:
    labels: set[str] = set()
    for node in parse_tree(xml).iter():
        labels.update(value for value in (node.attrib.get("text"), node.attrib.get("content-desc")) if value)
    return labels


def dump_ui(serial: str, artifact: Path, name: str) -> str:
    remote = "/sdcard/gpui-mobile-window.xml"
    transient = "null root node returned by UiTestAutomationBridge"
    result = ""
    for attempt in range(3):
        result = adb(serial, "shell", "uiautomator", "dump", remote, check=False, timeout=45)
        if "dumped to" in result.lower():
            break
        if transient not in result or attempt == 2:
            raise RuntimeError(f"uiautomator dump failed: {result}")
        retry_record = artifact / f"{name}-transient-dump-{attempt + 1}.txt"
        retry_record.write_text(
            f"attempt={attempt + 1} transient=null-root\n"
            + f"command output:\n{result}\n"
            + f"top resumed activity:\n{top_resumed_activity(serial)}\n"
            + "UiAutomator/system logcat:\n"
            + adb(serial, "logcat", "-d", "-s", "UiAutomation:E", "UiTestAutomationBridge:E", "AndroidRuntime:E")
        )
        time.sleep(0.4)
    xml = adb(serial, "shell", "cat", remote, timeout=15)
    (artifact / f"{name}.xml").write_text(xml)
    return xml

def capture_failure_state(serial: str, artifact: Path, name: str, error: object) -> None:
    """Capture device evidence before IME cleanup can hide the failure state."""
    prefix = f"failure-{name}"
    errors: list[str] = []
    (artifact / f"{prefix}-error.txt").write_text(f"{type(error).__name__}: {error}\n")
    for suffix, command in (
        ("input-method.txt", ("shell", "dumpsys", "input_method")),
        ("window-displays.txt", ("shell", "dumpsys", "window", "displays")),
        ("window-windows.txt", ("shell", "dumpsys", "window", "windows")),
        ("activities.txt", ("shell", "dumpsys", "activity", "activities")),
        ("logcat.txt", ("logcat", "-d", "-b", "all")),
    ):
        try:
            (artifact / f"{prefix}-{suffix}").write_text(adb(serial, *command, timeout=45))
        except Exception as capture_error:
            errors.append(f"{suffix}: {capture_error}")
    try:
        (artifact / f"{prefix}-top-resumed.txt").write_text(top_resumed_activity(serial))
    except Exception as capture_error:
        errors.append(f"top-resumed: {capture_error}")
    try:
        capture_screen(serial, artifact, prefix)
    except Exception as capture_error:
        errors.append(f"screenshot: {capture_error}")
    try:
        dump_ui(serial, artifact, prefix)
    except Exception as capture_error:
        errors.append(f"uiautomator: {capture_error}")
    if errors:
        (artifact / f"{prefix}-capture-errors.txt").write_text("\n".join(errors) + "\n")


def input_method_is_shown(dump: str) -> bool:
    """Use InputMethodManager's shown request as the authoritative state.

    API 26 may leave mIsInputViewShown=true after the actual window surface
    has been hidden; mInputShown=false is the state used by requestHideSelf.
    Keep the view flag only as a compatibility fallback when mInputShown is
    absent from a platform dump.
    """
    shown = re.search(r"\bmInputShown\s*=\s*(true|false)", dump, re.IGNORECASE)
    if shown:
        return shown.group(1).lower() == "true"
    view = re.search(r"\bmIsInputViewShown\s*=\s*(true|false)", dump, re.IGNORECASE)
    return bool(view and view.group(1).lower() == "true")


def parse_ime_geometry(api: int, display_dump: str, legacy_window_dump: str = "") -> list[tuple[int, str]]:
    """Return visible IME occlusion heights in physical pixels and their evidence.

    API 30+ uses only WindowInsets' published IME source frames. API 26-29
    have no InsetsSource dump, so use the shown InputMethod window frame and
    its visible/content inset, which marks the keyboard's top edge within the
    IME window (LatinIME can own a full-screen window with a large top inset).
    """
    geometries: list[tuple[int, str]] = []
    if api >= 30:
        sources = re.findall(
            r"InsetsSource id=\S+ type=ime frame=\[(-?\d+),(-?\d+)\]"
            r"\[(-?\d+),(-?\d+)\].*?visible=(true|false)",
            display_dump,
        )
        for left, top, right, bottom, visible in sources:
            width = int(right) - int(left)
            height = int(bottom) - int(top)
            if visible == "true" and width > 0 and height > 0:
                geometries.append((height, f"InsetsSource frame=[{left},{top}][{right},{bottom}] size={width}x{height}"))
        return geometries

    blocks = re.split(r"(?m)^\s*Window #\d+ ", legacy_window_dump)[1:]
    for block in blocks:
        header = block.splitlines()[0] if block.splitlines() else ""
        if "InputMethod" not in header:
            continue
        surface = re.search(
            r"Surface:\s*shown=(true|false).*?rect=\([-\d.]+,[-\d.]+\)"
            r"\s+([\d.]+)\s+x\s+([\d.]+)",
            block,
        )
        frame = re.search(r"mFrame=\[(-?\d+),(-?\d+)\]\[(-?\d+),(-?\d+)\]", block)
        visible_insets = re.search(
            r"mGivenVisibleInsets=\[(-?\d+),(-?\d+)\]\[(-?\d+),(-?\d+)\]", block
        )
        content_insets = re.search(
            r"mGivenContentInsets=\[(-?\d+),(-?\d+)\]\[(-?\d+),(-?\d+)\]", block
        )
        if not surface or surface.group(1) != "true" or not frame:
            continue
        surface_width, surface_height = float(surface.group(2)), float(surface.group(3))
        frame_top, frame_bottom = int(frame.group(2)), int(frame.group(4))
        frame_height = frame_bottom - frame_top
        # InputMethod visible insets describe the area before keyboard pixels;
        # content insets are a compatibility fallback when visible is absent.
        top_inset = int(visible_insets.group(2)) if visible_insets else 0
        if top_inset <= 0 and content_insets:
            top_inset = int(content_insets.group(2))
        occlusion = min(frame_height, int(surface_height + 0.5)) - min(frame_height, max(0, top_inset))
        if surface_width > 0 and frame_height > 0 and occlusion > 0:
            geometries.append((occlusion,
                f"InputMethod Surface shown=true size={surface_width:g}x{surface_height:g} "
                f"frame=[{frame.group(1)},{frame_top}][{frame.group(3)},{frame_bottom}] "
                f"visible_inset_top={int(visible_insets.group(2)) if visible_insets else 'missing'} "
                f"content_inset_top={int(content_insets.group(2)) if content_insets else 'missing'} "
                f"occlusion={occlusion}px"))
    return geometries


def check_keyboard_inset(serial: str, artifact: Path, name: str, visible: bool) -> int:
    api = int(adb(serial, "shell", "getprop", "ro.build.version.sdk").strip())
    deadline = time.monotonic() + 18
    last_label = ""
    last_geometry = "no visible IME frame"
    last_ime = ""
    last_window = ""
    last_legacy = ""
    while time.monotonic() < deadline:
        xml = dump_ui(serial, artifact, f"{name}-keyboard-inset")
        labels = exact_labels(xml)
        label = next((value for value in labels if value.startswith("Keyboard inset: ")), "")
        match = re.fullmatch(r"Keyboard inset: (\d+) px", label)
        if match:
            logical = int(match.group(1))
            last_label = label
            last_ime = adb(serial, "shell", "dumpsys", "input_method")
            shown = input_method_is_shown(last_ime)
            last_window = adb(serial, "shell", "dumpsys", "window", "displays")
            if api < 30:
                last_legacy = adb(serial, "shell", "dumpsys", "window", "windows")
            geometries = parse_ime_geometry(api, last_window, last_legacy)
            last_geometry = "; ".join(detail for _height, detail in geometries) or (
                "no visible IME geometry (legacy window parser or modern InsetsSource absent)"
            )
            geometry_visible = bool(geometries)
            if shown == visible and geometry_visible == visible:
                if visible:
                    physical_bottom = geometries[-1][0]
                else:
                    physical_bottom = 0
                density_output = adb(serial, "shell", "wm", "density")
                density_match = re.search(r"(?:Physical|Override) density:\s*(\d+)", density_output)
                if not density_match:
                    raise RuntimeError(f"could not read emulator density: {density_output}")
                density = int(density_match.group(1)) / 160.0
                expected = int(physical_bottom / density + 0.5)
                if abs(logical - expected) > 1:
                    raise RuntimeError(
                        f"{name}: {label} disagrees with Android IME geometry: "
                        f"physical_occlusion={physical_bottom}px density={density:g} expected≈{expected}px; {last_geometry}"
                    )
                (artifact / f"{name}-keyboard-inset.txt").write_text(
                    f"api={api}\naccessibility probe: {label}\n"
                    f"expected logical inset from Android IME geometry: {expected} px\n"
                    f"physical IME occlusion: {physical_bottom} px\n"
                    f"display density scale: {density:g}\n"
                    f"input_method_shown={shown}\nkeyboard visible expected: {visible}\n"
                    f"geometry: {last_geometry}\nwindow displays:\n{last_window}\n"
                    f"legacy window dump:\n{last_legacy}"
                )
                return logical
        time.sleep(0.25)
    last_shown_state = input_method_is_shown(last_ime)
    raise RuntimeError(
        f"{name}: keyboard inset did not reach visible={visible}; last probe={last_label!r}; "
        f"last input_method shown={last_shown_state}; geometry={last_geometry}"
    )

def capture_screen(serial: str, artifact: Path, name: str) -> None:
    result = subprocess.run([ADB, "-s", serial, "exec-out", "screencap", "-p"],
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode:
        raise RuntimeError(f"screenshot failed: {result.stderr.decode(errors='replace')}")
    (artifact / f"{name}.png").write_bytes(result.stdout)


def wait_label(serial: str, artifact: Path, label: str, name: str,
               timeout: float = 20) -> str:
    deadline = time.monotonic() + timeout
    last = ""
    while time.monotonic() < deadline:
        last = dump_ui(serial, artifact, name)
        if label in exact_labels(last):
            return last
        time.sleep(0.5)
    raise RuntimeError(f"accessibility label {label!r} did not appear; last UI tree saved as {name}.xml")


def matching_nodes(xml: str, label: str) -> list[ET.Element]:
    found = []
    for node in parse_tree(xml).iter():
        attrs = node.attrib
        rid = attrs.get("resource-id", "")
        if label in (attrs.get("text"), attrs.get("content-desc")) or rid.endswith(label):
            found.append(node)
    return found


def tap_label(serial: str, xml: str, label: str) -> None:
    for node in matching_nodes(xml, label):
        bounds = re.fullmatch(r"\[(\d+),(\d+)\]\[(\d+),(\d+)\]", node.attrib.get("bounds", ""))
        if bounds:
            left, top, right, bottom = map(int, bounds.groups())
            adb(serial, "shell", "input", "tap", str((left + right) // 2), str((top + bottom) // 2))
            return
    raise RuntimeError(f"no accessibility node with tappable bounds for {label!r}")


def editor_value(xml: str, editor_label: str) -> str | None:
    for node in matching_nodes(xml, editor_label):
        # Android accessibility exposes editable contents as node text. Keep the
        # label separate so an app that hides the value cannot pass this check.
        if node.attrib.get("class", "").endswith("EditText") or node.attrib.get("editable") == "true":
            return node.attrib.get("text", "")
    return None


def wait_editor_value(serial: str, artifact: Path, editor_label: str,
                      expected: str, name: str, timeout: float = 12) -> str:
    deadline = time.monotonic() + timeout
    last = ""
    while time.monotonic() < deadline:
        last = dump_ui(serial, artifact, name)
        actual = editor_value(last, editor_label)
        if actual == expected:
            return last
        time.sleep(0.3)
    raise RuntimeError(f"editor accessible value mismatch: expected {expected!r}, got {editor_value(last, editor_label)!r}; tree saved as {name}.xml")


def check_apk(apk: Path, abi: str, min_api: int, output: Path, aapt: str,
              require_native_activity: bool = True) -> tuple[str, str]:
    if not apk.is_file():
        raise RuntimeError(f"APK does not exist: {apk}")
    with zipfile.ZipFile(apk) as archive:
        names = archive.namelist()
        libs = sorted(name for name in names if name.startswith(f"lib/{abi}/") and name.endswith(".so"))
        if not libs:
            raise RuntimeError(f"APK has no native shared library under lib/{abi}/")
        gpui_libs = [name for name in libs if "gpui" in Path(name).name.lower()]
        if not gpui_libs:
            raise RuntimeError(f"APK has no GPUI native library under lib/{abi}/")
        extracted = output / Path(gpui_libs[0]).name
        extracted.write_bytes(archive.read(gpui_libs[0]))
    badging = run(aapt, "dump", "badging", str(apk), timeout=45)
    sdk_match = re.search(r"sdkVersion:'(\d+)'", badging)
    package_match = re.search(r"package: name='([^']+)'", badging)
    if not sdk_match or not package_match:
        raise RuntimeError("aapt could not read APK package/minSdk metadata")
    actual_min = int(sdk_match.group(1))
    if actual_min > min_api:
        raise RuntimeError(f"APK minSdk {actual_min} exceeds emulator API {min_api}")
    if abi not in badging:
        raise RuntimeError(f"aapt metadata does not report expected ABI {abi}")
    readelf = shutil.which("llvm-readelf") or shutil.which("readelf")
    nm = shutil.which("llvm-nm") or shutil.which("nm")
    if not readelf or not nm:
        raise RuntimeError("readelf and nm are required to verify the native library")
    symbols = []
    for lib in gpui_libs:
        extracted = output / Path(lib).name
        extracted.write_bytes(zipfile.ZipFile(apk).read(lib))
        elf = run(readelf, "-h", str(extracted))
        expected_machine = {"x86_64": "Advanced Micro Devices X86-64"}.get(abi)
        if expected_machine and expected_machine not in elf:
            raise RuntimeError(f"native library ELF machine does not match {abi}: {elf}")
        symbols.append(run(nm, "-D", str(extracted), check=False))
    if require_native_activity and not any("ANativeActivity_onCreate" in table for table in symbols):
        raise RuntimeError("GPUI native libraries do not export ANativeActivity_onCreate")
    return f"package={package_match.group(1)} minSdk={actual_min} abi={abi} libs={','.join(Path(x).name for x in gpui_libs)}", package_match.group(1)


def check_java_apk(apk: Path, expected_package: str, min_api: int, aapt: str) -> str:
    if not apk.is_file():
        raise RuntimeError(f"IME APK does not exist: {apk}")
    badging = run(aapt, "dump", "badging", str(apk), timeout=45)
    sdk_match = re.search(r"sdkVersion:'(\d+)'", badging)
    package_match = re.search(r"package: name='([^']+)'", badging)
    if not sdk_match or not package_match:
        raise RuntimeError("aapt could not read IME APK package/minSdk metadata")
    actual_min = int(sdk_match.group(1))
    if actual_min > min_api:
        raise RuntimeError(f"IME APK minSdk {actual_min} exceeds emulator API {min_api}")
    if package_match.group(1) != expected_package:
        raise RuntimeError(f"IME APK package is {package_match.group(1)}, expected {expected_package}")
    return f"package={expected_package} minSdk={actual_min}"


def display_size(serial: str) -> tuple[int, int]:
    output = adb(serial, "shell", "wm", "size")
    match = re.search(r"(\d+)x(\d+)", output)
    if not match:
        raise RuntimeError(f"could not parse emulator display size: {output}")
    return int(match.group(1)), int(match.group(2))


def display_rotation(serial: str) -> int:
    output = adb(serial, "shell", "dumpsys", "window", "displays")
    match = re.search(r"mDisplayRotation=ROTATION_(0|90|180|270)", output)
    if not match:
        raise RuntimeError(f"could not read current display rotation from window manager: {output[:1000]}")
    return int(match.group(1))


def wait_rotation(serial: str, expected: int, timeout: float = 10) -> None:
    deadline = time.monotonic() + timeout
    last = None
    while time.monotonic() < deadline:
        last = display_rotation(serial)
        if last == expected:
            return
        time.sleep(0.2)
    raise RuntimeError(f"display rotation did not reach ROTATION_{expected}; last was ROTATION_{last}")


def top_resumed_activity(serial: str) -> str:
    output = adb(serial, "shell", "dumpsys", "activity", "activities")
    # Android 10+ reports topResumedActivity; older ActivityManager dumps use
    # mResumedActivity or ResumedActivity. Keep the record so callers still
    # assert the expected package instead of treating an absent modern field
    # as a backgrounded app.
    patterns = (
        r"^\s*topResumedActivity=.*$",
        r"^\s*mResumedActivity:\s*ActivityRecord.*$",
        r"^\s*ResumedActivity:\s*ActivityRecord.*$",
    )
    for pattern in patterns:
        match = re.search(pattern, output, re.MULTILINE)
        if match:
            return match.group(0).strip()
    raise RuntimeError("ActivityTaskManager did not report a resumed activity")


def wait_resumed_activity(serial: str, package: str, expected: bool, timeout: float = 20) -> str:
    deadline = time.monotonic() + timeout
    last = ""
    while time.monotonic() < deadline:
        last = top_resumed_activity(serial)
        if (package in last) == expected:
            return last
        time.sleep(0.25)
    state = "resumed" if expected else "backgrounded"
    raise RuntimeError(f"package {package!r} did not become {state}; last activity: {last}")


def check_ime_shown(
    serial: str, artifact: Path | None = None, timeout: float = 6
) -> None:
    deadline = time.monotonic() + timeout
    started = time.monotonic()
    last_ime = ""
    last_window = ""
    last_geometry = "no visible IME frame"
    last_error = ""
    try:
        api = int(adb(
            serial, "shell", "getprop", "ro.build.version.sdk",
            timeout=timeout,
        ).strip())
    except (ValueError, RuntimeError, subprocess.TimeoutExpired) as error:
        raise RuntimeError(f"could not determine Android API for IME visibility check: {error}") from error

    def bounded_adb(*args: str) -> str:
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            return ""
        return adb(serial, *args, timeout=remaining)

    while time.monotonic() < deadline:
        try:
            last_ime = bounded_adb("shell", "dumpsys", "input_method")
            shown = input_method_is_shown(last_ime)

            last_window = bounded_adb("shell", "dumpsys", "window", "displays")
            legacy_windows = bounded_adb("shell", "dumpsys", "window", "windows") if api < 30 else ""
            visible_frames = parse_ime_geometry(api, last_window, legacy_windows)
            last_geometry = (
                "; ".join(detail for _height, detail in visible_frames)
                if visible_frames
                else ("API30+ has no parsed visible nonempty InsetsSource type=ime frame"
                      if api >= 30 else "API<30 has no shown InputMethod surface with positive occlusion")
            )
            if shown and visible_frames:
                if artifact is not None:
                    (artifact / "ime-visible-startup.txt").write_text(
                        f"elapsed_seconds={time.monotonic() - started:.3f}\n"
                        f"api={api}\ninput_method_shown=true\n"
                        f"visible_geometry={last_geometry}\n"
                    )
                return
        except (RuntimeError, subprocess.TimeoutExpired) as error:
            last_error = str(error)
        time.sleep(min(0.15, max(0.0, deadline - time.monotonic())))

    shown_state = re.search(
        r"(mInputShown|mIsInputViewShown)\s*=\s*(true|false)",
        last_ime,
        re.IGNORECASE,
    )
    shown_text = shown_state.group(0) if shown_state else "input-method shown state unavailable"
    message = (
        f"soft keyboard did not become visible within {timeout:g}s for the editor: "
        f"{shown_text}; {last_geometry}"
    )
    if last_error:
        message += f"; last command error={last_error}"
    message += (
        f"; last IME state tail={last_ime[-1200:]!r}"
        f"; last window state tail={last_window[-1200:]!r}"
    )
    raise RuntimeError(message)


def wait_ime_hidden(serial: str, timeout: float = 6) -> str:
    deadline = time.monotonic() + timeout
    last = ""
    while time.monotonic() < deadline:
        last = adb(serial, "shell", "dumpsys", "input_method")
        if re.search(r"mInputShown\s*=\s*false", last, re.IGNORECASE):
            return last
        time.sleep(0.2)
    raise RuntimeError("soft keyboard remained visible after hide request")


def restore_secure_setting(serial: str, key: str, value: str) -> None:
    """Restore a possibly absent secure setting without passing an empty argv value."""
    if value in ("", "null"):
        adb(serial, "shell", "settings", "delete", "secure", key, check=False)
    else:
        adb(serial, "shell", "settings", "put", "secure", key, value)


def send_ime(serial: str, operation: str, *, text: str = "", first: int = 0, second: int = 0) -> None:
    command_id = str(time.monotonic_ns())
    command = ["shell", "am", "broadcast", "-n", "dev.gpui.acceptanceime/.ImeCommandReceiver",
               "-a", "dev.gpui.acceptanceime.COMMAND", "--es", "op", operation]
    if text:
        command.extend(("--es", "text", text))
    else:
        # An empty argv value is lost by `adb shell` quoting on Android 14;
        # use a null string extra, which the test receiver maps to empty text.
        command.extend(("--esn", "text"))
    command.extend(("--ei", "first", str(first), "--ei", "second", str(second),
                    "--el", "command_id", command_id))
    adb(serial, *command, timeout=8)
    expected = f"command-id={command_id} operation={operation} result=ok"
    deadline = time.monotonic() + 6
    while time.monotonic() < deadline:
        log = adb(serial, "logcat", "-d", "-s", "GpuiAcceptanceIme:I")
        if expected in log:
            return
        time.sleep(0.15)
    raise RuntimeError(f"acceptance IME command did not succeed: {operation}; expected log {expected!r}")


def query_ime_snapshot(serial: str) -> dict[str, object]:
    command_id = str(time.monotonic_ns())
    adb(serial, "shell", "am", "broadcast", "-n",
        "dev.gpui.acceptanceime/.ImeCommandReceiver",
        "-a", "dev.gpui.acceptanceime.COMMAND", "--es", "op", "query",
        "--esn", "text", "--ei", "first", "0", "--ei", "second", "0",
        "--el", "command_id", command_id)
    deadline = time.monotonic() + 6
    payload = None
    status = f"command-id={command_id} operation=query result=ok"
    while time.monotonic() < deadline:
        log = adb(serial, "logcat", "-d", "-s", "GpuiAcceptanceIme:I")
        if status in log:
            match = re.search(rf"query-id={command_id} data=(q2\|[^\r\n]+)", log)
            if match:
                payload = match.group(1)
                break
        time.sleep(0.15)
    if payload is None:
        raise RuntimeError(f"InputConnection query did not return for command {command_id}")
    fields = payload.split("|")
    if len(fields) != 11 or fields[0] != "q2":
        raise RuntimeError(f"malformed InputConnection query payload: {payload!r}")

    def decode(value: str) -> str | None:
        if value == "~":
            return None
        return base64.b64decode(value).decode("utf-8")

    return {
        "before": decode(fields[1]),
        "after": decode(fields[2]),
        "selected": decode(fields[3]),
        "text": decode(fields[4]),
        "selection_start": int(fields[5]),
        "selection_end": int(fields[6]),
        "surrounding_text": decode(fields[7]),
        "surrounding_selection_start": int(fields[8]),
        "surrounding_selection_end": int(fields[9]),
        "surrounding_offset": int(fields[10]),
    }


def assert_input_snapshot(serial: str, expected: dict[str, object], name: str) -> dict[str, object]:
    actual = query_ime_snapshot(serial)
    if any(
        (actual.get(key) not in (None, "") if key == "selected" and value in (None, "")
         else actual.get(key) != value)
        for key, value in expected.items()
    ):
        raise RuntimeError(f"immediate InputConnection snapshot {name} mismatch: expected {expected!r}, got {actual!r}")
    return actual


def wait_input_snapshot(serial: str, artifact: Path,
                        expected: dict[str, object], name: str,
                        timeout: float = 8) -> dict[str, object]:
    deadline = time.monotonic() + timeout
    last: dict[str, object] = {}
    while time.monotonic() < deadline:
        last = query_ime_snapshot(serial)
        with (artifact / "inputconnection-snapshots.txt").open("a") as stream:
            stream.write(f"{name}: {last!r}\n")
        if all(
            (last.get(key) in (None, "") if key == "selected" and value in (None, "")
             else last.get(key) == value)
            for key, value in expected.items()
        ):
            return last
        time.sleep(0.2)
    raise RuntimeError(f"InputConnection snapshot {name} mismatch: expected {expected!r}, got {last!r}")


def run_ime_contract(serial: str, artifact: Path, editor_label: str,
                     ime_package: str, ime_component: str, app_package: str,
                     api: int) -> None:
    old_ime = adb(serial, "shell", "settings", "get", "secure", "default_input_method").strip()
    old_show_ime = adb(serial, "shell", "settings", "get", "secure", "show_ime_with_hard_keyboard").strip()
    setting_record = artifact / "show-ime-with-hard-keyboard.txt"
    setting_record.write_text(f"before={old_show_ime!r}\n")
    try:
        # This dedicated emulator reports a QWERTY keyboard that is not hidden
        # in guest Configuration despite hw.keyboard=no in config.ini. Permit
        # the test IME to show, then restore the user's exact secure setting.
        adb(serial, "shell", "settings", "put", "secure", "show_ime_with_hard_keyboard", "1")
        adb(serial, "shell", "ime", "enable", ime_component)
        adb(serial, "shell", "ime", "set", ime_component)
        xml = dump_ui(serial, artifact, "ime-editor-before")
        if editor_label not in exact_labels(xml):
            raise RuntimeError(f"editor label {editor_label!r} missing before IME tests")
        tap_label(serial, xml, editor_label)
        check_ime_shown(serial, artifact)
        check_keyboard_inset(serial, artifact, "ime-keyboard-visible", True)
        capture_screen(serial, artifact, "ime-keyboard-visible")

        # Two composing updates replace the composing region; commit final CJK text.
        send_ime(serial, "compose", text="にほん")
        wait_editor_value(serial, artifact, editor_label, "にほん", "ime-compose-hiragana")
        send_ime(serial, "compose", text="日本語")
        wait_editor_value(serial, artifact, editor_label, "日本語", "ime-compose-converted")
        send_ime(serial, "commit", text="日本語")
        wait_editor_value(serial, artifact, editor_label, "日本語", "ime-commit-cjk")
        print("IME composition conversion and CJK commit: PASS")

        # Clear the first text, commit an astral character plus BMP CJK, and
        # replace UTF-16 offsets [3, 6). Code-point offsets would select wrongly.
        send_ime(serial, "select", first=0, second=3)
        send_ime(serial, "commit", text="")
        wait_editor_value(serial, artifact, editor_label, "", "ime-clear")
        original = "A😀日本語Z"
        send_ime(serial, "commit", text=original)
        wait_editor_value(serial, artifact, editor_label, original, "ime-original-unicode")
        def snapshot(text: str, before: str, after: str, selected: str,
                     selection_start: int, selection_end: int) -> dict[str, object]:
            return {
                "before": before, "after": after, "selected": selected,
                "text": text, "selection_start": selection_start,
                "selection_end": selection_end,
                # InputConnection.getSurroundingText was added in API 31.
                # Older platforms must report its unavailable sentinel while
                # still satisfying the before/after/selected/extracted checks.
                "surrounding_text": text if api >= 31 else None,
                "surrounding_selection_start": selection_start if api >= 31 else -1,
                "surrounding_selection_end": selection_end if api >= 31 else -1,
                "surrounding_offset": 0 if api >= 31 else -1,
            }

        end_snapshot = snapshot(original, original, "", "", 7, 7)
        assert_input_snapshot(serial, end_snapshot, "immediate-after-original-commit")
        wait_input_snapshot(serial, artifact, end_snapshot, "after-original-commit")
        # A UTF-16 offset inside the emoji's surrogate pair must normalize to
        # a valid Unicode boundary and report the same normalized cursor.
        send_ime(serial, "select", first=2, second=2)
        surrogate_snapshot = snapshot(original, "A😀", "日本語Z", "", 3, 3)
        assert_input_snapshot(serial, surrogate_snapshot, "immediate-surrogate-interior")
        wait_input_snapshot(serial, artifact, surrogate_snapshot, "surrogate-interior-normalized")
        # Each noncollapsed endpoint also maps forward independently. The
        # start inside the emoji moves to UTF-16 3 while end 4 stays after 日.
        send_ime(serial, "select", first=2, second=4)
        surrogate_range = snapshot(original, "A😀", "本語Z", "日", 3, 4)
        assert_input_snapshot(serial, surrogate_range, "immediate-surrogate-interior-range")
        wait_input_snapshot(serial, artifact, surrogate_range, "surrogate-interior-range")
        send_ime(serial, "select", first=7, second=7)
        assert_input_snapshot(serial, end_snapshot, "immediate-restore-end-cursor")
        wait_input_snapshot(serial, artifact, end_snapshot, "restore-end-cursor")
        selected_snapshot = snapshot(original, "A😀", "Z", "日本語", 3, 6)
        send_ime(serial, "select", first=3, second=6)
        assert_input_snapshot(serial, selected_snapshot, "immediate-selected-japanese")
        wait_input_snapshot(serial, artifact, selected_snapshot, "selected-japanese")
        send_ime(serial, "commit", text="かな")
        replaced = "A😀かなZ"
        replaced_snapshot = snapshot(replaced, "A😀かな", "Z", "", 5, 5)
        assert_input_snapshot(serial, replaced_snapshot, "immediate-selection-replacement")
        wait_editor_value(serial, artifact, editor_label, replaced, "ime-selection-replace")
        wait_input_snapshot(serial, artifact, replaced_snapshot, "after-selection-replacement")
        send_ime(serial, "delete", first=1, second=0)
        deleted = "A😀かZ"
        deleted_snapshot = snapshot(deleted, "A😀か", "Z", "", 4, 4)
        assert_input_snapshot(serial, deleted_snapshot, "immediate-surrounding-delete")
        wait_editor_value(serial, artifact, editor_label, deleted, "ime-delete-surrounding")
        wait_input_snapshot(serial, artifact, deleted_snapshot, "after-surrounding-delete")
        # AOSP protects the selected range and applies the requested deletion
        # immediately outside it. Verify forward and reversed anchor/focus.
        select_delete_text = original
        send_ime(serial, "select", first=0, second=7)
        send_ime(serial, "commit", text=select_delete_text)
        original_end = snapshot(original, original, "", "", 7, 7)
        assert_input_snapshot(serial, original_end, "immediate-restore-original-for-selected-delete")
        wait_editor_value(serial, artifact, editor_label, original, "ime-restore-original-for-selected-delete")
        wait_input_snapshot(serial, artifact, original_end, "restore-original-for-selected-delete")
        send_ime(serial, "select", first=3, second=4)
        selected_delete_snapshot = snapshot(original, "A😀", "本語Z", "日", 3, 4)
        assert_input_snapshot(serial, selected_delete_snapshot, "immediate-selection-before-delete")
        wait_input_snapshot(serial, artifact, selected_delete_snapshot, "selection-before-delete")
        send_ime(serial, "delete", first=0, second=1)
        selected_deleted = "A😀日語Z"
        selected_deleted_snapshot = snapshot(selected_deleted, "A😀", "語Z", "日", 3, 4)
        assert_input_snapshot(serial, selected_deleted_snapshot, "immediate-delete-after-selection")
        wait_editor_value(serial, artifact, editor_label, selected_deleted, "ime-delete-after-selection")
        wait_input_snapshot(serial, artifact, selected_deleted_snapshot, "after-delete-after-selection")
        send_ime(serial, "select", first=4, second=3)
        reversed_delete_snapshot = snapshot(selected_deleted, "A😀", "語Z", "日", 4, 3)
        assert_input_snapshot(serial, reversed_delete_snapshot, "immediate-reversed-selection-before-delete")
        wait_input_snapshot(serial, artifact, reversed_delete_snapshot, "reversed-selection-before-delete")
        send_ime(serial, "delete", first=0, second=1)
        reversed_deleted = "A😀日Z"
        reversed_deleted_snapshot = snapshot(reversed_deleted, "A😀", "Z", "日", 4, 3)
        assert_input_snapshot(serial, reversed_deleted_snapshot, "immediate-delete-after-reversed-selection")
        wait_editor_value(serial, artifact, editor_label, reversed_deleted, "ime-delete-after-reversed-selection")
        wait_input_snapshot(serial, artifact, reversed_deleted_snapshot, "after-delete-after-reversed-selection")
        send_ime(serial, "select", first=0, second=5)
        send_ime(serial, "commit", text=deleted)
        deleted_end_snapshot = snapshot(deleted, deleted, "", "", 5, 5)
        assert_input_snapshot(serial, deleted_end_snapshot, "immediate-restore-final-value")
        wait_editor_value(serial, artifact, editor_label, deleted, "ime-restore-final-value")
        wait_input_snapshot(serial, artifact, deleted_end_snapshot, "restore-final-value")

        # Deleting one UTF-16 unit after a caret inside an astral scalar must
        # round outward over the surrogate pair, never leave an invalid half.
        # The reversed-delete fixture A😀日Z is five UTF-16 code units.
        send_ime(serial, "select", first=0, second=5)
        send_ime(serial, "commit", text="A😀B")
        astral_text = "A😀B"
        astral_end = snapshot(astral_text, astral_text, "", "", 4, 4)
        assert_input_snapshot(serial, astral_end, "immediate-astral-delete-fixture")
        wait_editor_value(serial, artifact, editor_label, astral_text, "ime-astral-delete-fixture")
        wait_input_snapshot(serial, artifact, astral_end, "astral-delete-fixture")
        send_ime(serial, "select", first=1, second=1)
        astral_caret = snapshot(astral_text, "A", "😀B", "", 1, 1)
        assert_input_snapshot(serial, astral_caret, "immediate-astral-caret")
        wait_input_snapshot(serial, artifact, astral_caret, "astral-caret")
        send_ime(serial, "delete", first=0, second=1)
        astral_deleted = "AB"
        astral_deleted_snapshot = snapshot(astral_deleted, "A", "B", "", 1, 1)
        assert_input_snapshot(serial, astral_deleted_snapshot, "immediate-delete-after-surrogate-interior")
        wait_editor_value(serial, artifact, editor_label, astral_deleted, "ime-delete-after-surrogate-interior")
        wait_input_snapshot(serial, artifact, astral_deleted_snapshot, "after-delete-after-surrogate-interior")
        send_ime(serial, "select", first=0, second=2)
        send_ime(serial, "commit", text=deleted)
        assert_input_snapshot(serial, deleted_end_snapshot, "immediate-restore-after-astral-delete")
        wait_editor_value(serial, artifact, editor_label, deleted, "ime-restore-after-astral-delete")
        wait_input_snapshot(serial, artifact, deleted_end_snapshot, "restore-after-astral-delete")

        (artifact / "ime-contract.txt").write_text(
            f"composition: にほん -> 日本語 -> commit 日本語\n"
            f"InputConnection.commitText: {original}\n"
            f"InputConnection.setSelection UTF-16 [3,6) + commitText: {original} -> {replaced}\n"
            f"deleteSurroundingText(1,0): {replaced} -> {deleted}\n"
            f"surrogate-interior setSelection(2,2) normalized to cursor 3: {original}\n"
            f"noncollapsed setSelection(2,4) normalized to [3,4): selected 日\n"
            f"deleteSurroundingText(0,1) with selected [3,4): {original} -> {selected_deleted}, selection [3,4) retained\n"
            f"deleteSurroundingText(0,1) with reversed selection [4,3): {selected_deleted} -> {reversed_deleted}, orientation retained\n"
            f"deleteSurroundingText(0,1) at UTF-16 caret 1 in A😀B: A😀B -> AB\n"
            f"InputConnection immediate and post-GPUI-frame snapshots agree: yes\n")
        capture_screen(serial, artifact, "ime-cjk-selection-delete")

        # Exercise both explicit IME hide and Back while the test keyboard is
        # known to be visible. A Back key after restoring the prior IME can
        # accidentally target the Activity when the keyboard is already hidden.
        check_ime_shown(serial)
        send_ime(serial, "hide")
        try:
            hidden_ime = wait_ime_hidden(serial, timeout=15)
            check_keyboard_inset(serial, artifact, "ime-request-hide", False)
        except RuntimeError:
            failure = artifact / "ime-request-hide-failure.txt"
            failure.write_text(
                "=== input_method ===\n" + adb(serial, "shell", "dumpsys", "input_method")
                + "\n=== resumed activity ===\n" + top_resumed_activity(serial)
                + "\n=== activity state ===\n" + adb(serial, "shell", "dumpsys", "activity", "activities")
                + "\n=== logcat ===\n" + adb(serial, "logcat", "-d", "-s", "GpuiAcceptanceIme:I", "gpui-android:I", "AndroidRuntime:E")
            )
            capture_screen(serial, artifact, "ime-request-hide-failure")
            raise
        hidden_activity = wait_resumed_activity(serial, app_package, True)
        (artifact / "ime-request-hide.txt").write_text(
            f"requestHideSelf(0) hid keyboard: yes\n"
            f"foreground activity: {hidden_activity}\n{hidden_ime}")
        if api == 26:
            # Android 8 can block the helper receiver while requestShowSelf
            # waits for the hidden InputMethodService window. Re-focus the real
            # editor instead, then require actual IME geometry and inset below.
            editor_xml = dump_ui(serial, artifact, "ime-resume-editor-tap")
            tap_label(serial, editor_xml, editor_label)
            (artifact / "ime-resume-method.txt").write_text(
                "API 26 re-show requested by tapping the real editor;\n"
                "visible frame and app inset are asserted before Back.\n")
        else:
            send_ime(serial, "show")
        time.sleep(0.5)
        check_ime_shown(serial)
        check_keyboard_inset(serial, artifact, "ime-visible-back-shown", True)
        (artifact / "ime-visible-back-before-input-method.txt").write_text(
            adb(serial, "shell", "dumpsys", "input_method"))
        (artifact / "ime-visible-back-before-activities.txt").write_text(
            adb(serial, "shell", "dumpsys", "activity", "activities"))
        (artifact / "ime-visible-back-before-window.txt").write_text(
            adb(serial, "shell", "dumpsys", "window", "windows"))
        capture_screen(serial, artifact, "ime-visible-back-before")
        adb(serial, "shell", "input", "keyevent", "KEYCODE_BACK")
        time.sleep(0.5)
        (artifact / "ime-visible-back-after-input-method.txt").write_text(
            adb(serial, "shell", "dumpsys", "input_method"))
        (artifact / "ime-visible-back-after-activities.txt").write_text(
            adb(serial, "shell", "dumpsys", "activity", "activities"))
        (artifact / "ime-visible-back-after-logcat.txt").write_text(
            adb(serial, "logcat", "-d", "-b", "all"))
        capture_screen(serial, artifact, "ime-visible-back-after")
        back_ime = wait_ime_hidden(serial)
        check_keyboard_inset(serial, artifact, "ime-visible-back-hidden", False)
        back_activity = wait_resumed_activity(serial, app_package, True)
        (artifact / "ime-visible-back.txt").write_text(
            f"Back with keyboard confirmed visible hid IME: yes\n"
            f"foreground activity: {back_activity}\n{back_ime}")
        print("IME UTF-16 selection replacement, surrounding delete, explicit hide, and visible-keyboard Back: PASS")
    except Exception as error:
        capture_failure_state(serial, artifact, "ime-contract", error)
        raise
    finally:
        restore_secure_setting(serial, "show_ime_with_hard_keyboard", old_show_ime)
        setting_record.write_text(
            f"before={old_show_ime!r}\n"
            f"during=1\n"
            f"after={adb(serial, 'shell', 'settings', 'get', 'secure', 'show_ime_with_hard_keyboard').strip()!r}\n")
        if old_ime and old_ime not in ("null", "" ):
            adb(serial, "shell", "ime", "set", old_ime, check=False)
        adb(serial, "shell", "ime", "disable", ime_component, check=False)


def runtime_failure_lines(logs: str) -> list[str]:
    failures = re.findall(
        r"(?im)^.*(?:FATAL EXCEPTION|Fatal signal|ANR in |UnsatisfiedLinkError).*$", logs
    )
    # Android images can emit these two scoped platform-package startup
    # warnings independently of the app: Widevine's optional crypto module and
    # PrebuiltBugle's bundled curve25519 lookup. Keep every other loader error
    # fatal, including failures from GPUI/native app libraries.
    for line in logs.splitlines():
        lowered = line.lower()
        known_platform_warning = (
            ("wvcdm" in lowered and "liboemcrypto.so" in lowered)
            or (
                "libcurve25519.so" in lowered
                and "caller=/product/priv-app/prebuiltbugle/prebuiltbugle.apk" in lowered
            )
        )
        if "dlopen failed" in lowered and not known_platform_warning:
            failures.append(line)
    return failures


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("apk", type=Path)
    parser.add_argument("--package", default="dev.gpui.mobile.example")
    parser.add_argument("--activity", default="dev.gpui.mobile.GpuiInputActivity", help="Fully qualified NativeActivity component class")
    parser.add_argument("--abi", default="x86_64")
    parser.add_argument("--min-api", type=int, default=26)
    parser.add_argument("--root-label", default="GPUI mobile acceptance")
    parser.add_argument("--counter-label", default="Increment")
    parser.add_argument("--counter-before", default="Count: 0")
    parser.add_argument("--counter-after", default="Count: 1")
    parser.add_argument("--editor-label", default="Editor")
    parser.add_argument("--scroll-end-label", default="Scroll end")
    parser.add_argument("--ime-apk", type=Path, required=True, help="Separately built test-only acceptance IME APK")
    parser.add_argument("--ime-package", default="dev.gpui.acceptanceime")
    parser.add_argument("--ime-component", default="dev.gpui.acceptanceime/.AcceptanceImeService")
    parser.add_argument("--serial", default=os.environ.get("ANDROID_SERIAL", "emulator-5554"))
    parser.add_argument("--artifacts", type=Path, default=Path("../evidence/android/acceptance-run"))
    args = parser.parse_args()

    global ADB
    ADB = resolve_tool("adb")
    aapt = resolve_tool("aapt")
    args.artifacts.mkdir(parents=True, exist_ok=True)

    static, actual_package = check_apk(args.apk.resolve(), args.abi, args.min_api, args.artifacts, aapt)
    if actual_package != args.package:
        raise RuntimeError(f"APK package is {actual_package}, expected {args.package}")
    print(f"APK contract: {static}")
    print(f"Acceptance IME APK: {check_java_apk(args.ime_apk.resolve(), args.ime_package, args.min_api, aapt)}")
    device_abi = adb(args.serial, "shell", "getprop", "ro.product.cpu.abi").strip()
    api = int(adb(args.serial, "shell", "getprop", "ro.build.version.sdk").strip())
    if device_abi != args.abi:
        raise RuntimeError(f"emulator ABI is {device_abi}, expected {args.abi}")
    if api < args.min_api:
        raise RuntimeError(f"emulator API {api} is below declared min API {args.min_api}")
    print(f"Emulator: abi={device_abi} api={api}")

    try:
        adb(args.serial, "logcat", "-c")
    except RuntimeError as error:
        # Some API 26 emulator/logd combinations reject clearing the implicit
        # main buffer while accepting the explicit all-buffer operation.
        if "failed to clear the 'main' log" not in str(error):
            raise
        (args.artifacts / "logcat-clear-fallback.txt").write_text(
            f"default clear failed; retrying explicit all-buffer clear\n{error}\n"
        )
        adb(args.serial, "logcat", "-b", "all", "-c")
    run(ADB, "-s", args.serial, "install", "-r", str(args.apk.resolve()), timeout=180)
    run(ADB, "-s", args.serial, "install", "-r", str(args.ime_apk.resolve()), timeout=120)
    component = f"{args.package}/{args.activity}"
    run(ADB, "-s", args.serial, "shell", "am", "start", "-W", "-n", component, timeout=45)
    root_xml = wait_label(args.serial, args.artifacts, args.root_label, "launch")
    check_keyboard_inset(args.serial, args.artifacts, "launch", False)
    capture_screen(args.serial, args.artifacts, "first-frame")
    print("NativeActivity launch and first accessible frame: PASS")

    labels = exact_labels(root_xml)
    if args.counter_before not in labels:
        raise RuntimeError(f"initial counter value {args.counter_before!r} missing")
    tap_label(args.serial, root_xml, args.counter_label)
    after_tap = wait_label(args.serial, args.artifacts, args.counter_after, "counter")
    capture_screen(args.serial, args.artifacts, "counter-updated")
    print("Touch dispatch and counter update: PASS")

    # Scroll the actual app surface until its offscreen accessible sentinel appears.
    width, height = display_size(args.serial)
    scrolled = False
    for attempt in range(6):
        current = dump_ui(args.serial, args.artifacts, f"scroll-{attempt}")
        if args.scroll_end_label in exact_labels(current):
            scrolled = True
            break
        adb(args.serial, "shell", "input", "swipe", str(width // 2), str(height * 4 // 5),
            str(width // 2), str(height // 3), "250")
        time.sleep(0.3)
    if not scrolled:
        raise RuntimeError(f"scroll sentinel {args.scroll_end_label!r} never became accessible")
    capture_screen(args.serial, args.artifacts, "scroll-end")
    print("Touch swipe and scroll sentinel: PASS")
    for attempt in range(6):
        current = dump_ui(args.serial, args.artifacts, f"scroll-top-{attempt}")
        if args.editor_label in exact_labels(current):
            break
        adb(args.serial, "shell", "input", "swipe", str(width // 2), str(height // 3),
            str(width // 2), str(height * 4 // 5), "250")
        time.sleep(0.3)

    run_ime_contract(args.serial, args.artifacts, args.editor_label,
                     args.ime_package, args.ime_component, args.package, api)
    lifecycle_xml = wait_label(args.serial, args.artifacts, args.root_label, "lifecycle-before-rotation")
    if "A😀かZ" not in exact_labels(lifecycle_xml):
        raise RuntimeError("final editor value was not retained before rotation")

    # Force verified orientation transitions with the editor first hidden, then visible.
    old_auto = adb(args.serial, "shell", "settings", "get", "system", "accelerometer_rotation").strip()
    old_rotation = adb(args.serial, "shell", "settings", "get", "system", "user_rotation").strip()
    original_rotation = display_rotation(args.serial)
    hidden_rotation_setting = "1" if original_rotation != 90 else "0"
    visible_rotation_setting = "0" if hidden_rotation_setting == "1" else "1"
    hidden_rotation = 90 if hidden_rotation_setting == "1" else 0
    visible_rotation = 90 if visible_rotation_setting == "1" else 0
    try:
        adb(args.serial, "shell", "settings", "put", "system", "accelerometer_rotation", "0")
        adb(args.serial, "shell", "settings", "put", "system", "user_rotation", hidden_rotation_setting)
        wait_rotation(args.serial, hidden_rotation)
        rotated = wait_label(args.serial, args.artifacts, args.root_label, "rotated-hidden-keyboard")
        capture_screen(args.serial, args.artifacts, "rotation-keyboard-hidden")
        (args.artifacts / "rotation-hidden-window.txt").write_text(
            adb(args.serial, "shell", "dumpsys", "window", "displays"))
        if "A\U0001f600\u304bZ" not in exact_labels(rotated):
            raise RuntimeError("editor value was lost during rotation with keyboard hidden")
        xml = dump_ui(args.serial, args.artifacts, "rotation-editor")
        tap_label(args.serial, xml, args.editor_label)
        time.sleep(0.5)
        check_ime_shown(args.serial)
        adb(args.serial, "shell", "settings", "put", "system", "user_rotation", visible_rotation_setting)
        wait_rotation(args.serial, visible_rotation)
        rotated_ime = wait_label(args.serial, args.artifacts, args.root_label, "rotated-visible-keyboard")
        capture_screen(args.serial, args.artifacts, "rotation-keyboard-visible")
        (args.artifacts / "rotation-visible-window.txt").write_text(
            adb(args.serial, "shell", "dumpsys", "window", "displays"))
        if "A\U0001f600\u304bZ" not in exact_labels(rotated_ime):
            raise RuntimeError("editor value was lost during rotation with keyboard shown")
    finally:
        adb(args.serial, "shell", "input", "keyevent", "KEYCODE_BACK", check=False)
        adb(args.serial, "shell", "settings", "put", "system", "user_rotation", old_rotation if old_rotation.isdigit() else "0")
        adb(args.serial, "shell", "settings", "put", "system", "accelerometer_rotation", old_auto if old_auto.isdigit() else "1")
    print("Rotation, hidden/shown keyboard, and editor state: PASS")

    adb(args.serial, "shell", "input", "keyevent", "KEYCODE_HOME")
    background_activity = wait_resumed_activity(args.serial, args.package, False)
    (args.artifacts / "activity-backgrounded.txt").write_text(
        adb(args.serial, "shell", "dumpsys", "activity", "activities"))
    run(ADB, "-s", args.serial, "shell", "am", "start", "-W", "-n", component, timeout=45)
    foreground_activity = wait_resumed_activity(args.serial, args.package, True)
    (args.artifacts / "activity-foregrounded.txt").write_text(
        adb(args.serial, "shell", "dumpsys", "activity", "activities"))
    resumed = wait_label(args.serial, args.artifacts, args.root_label, "background-resume")
    capture_screen(args.serial, args.artifacts, "background-resume")
    labels = exact_labels(resumed)
    if "A😀かZ" not in labels:
        raise RuntimeError("editor value was lost after background/resume")
    if "Lifecycle: active" not in labels:
        raise RuntimeError("window lifecycle probe did not report active after resume")
    (args.artifacts / "lifecycle-contract.txt").write_text(
        f"background top resumed activity: {background_activity}\n"
        f"foreground top resumed activity: {foreground_activity}\n"
        "visible GPUI lifecycle probe after foreground: Lifecycle: active\n")
    print("Background/resume, activity focus, lifecycle probe, and redraw: PASS")

    adb(args.serial, "shell", "am", "force-stop", args.package)
    run(ADB, "-s", args.serial, "shell", "am", "start", "-W", "-n", component, timeout=45)
    wait_label(args.serial, args.artifacts, args.root_label, "fresh-launch")
    capture_screen(args.serial, args.artifacts, "force-stop-relaunch")
    print("Force-stop and fresh launch: PASS")

    logs = adb(args.serial, "logcat", "-d")
    (args.artifacts / "logcat.txt").write_text(logs)
    fatal = runtime_failure_lines(logs)
    if fatal:
        raise RuntimeError("crash/ANR/native loader failure found:\n" + "\n".join(fatal[-20:]))
    print(f"Crash/ANR/native loader scan: PASS; artifacts: {args.artifacts.resolve()}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, subprocess.TimeoutExpired) as error:
        print(f"ANDROID ACCEPTANCE FAILED: {error}", file=sys.stderr)
        raise SystemExit(1)
