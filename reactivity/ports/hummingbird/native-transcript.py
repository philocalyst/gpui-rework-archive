#!/usr/bin/env python3
"""Drive the ordinary app through real X11 input and actual AT-SPI on a private bus."""
import argparse
import hashlib
import json
import os
import pathlib
import subprocess
import tempfile
import time


def wait(predicate, deadline, description):
    while time.monotonic() < deadline:
        result = predicate()
        if result:
            return result
        time.sleep(0.05)  # External test-client discovery, never a production timer.
    raise TimeoutError(description)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("binary", type=pathlib.Path)
    parser.add_argument("--xvfb", type=pathlib.Path, required=True)
    parser.add_argument("--xdotool", type=pathlib.Path, required=True)
    parser.add_argument("--atspi-launcher", type=pathlib.Path, required=True)
    parser.add_argument("--output", type=pathlib.Path, required=True)
    parser.add_argument("--display", default=":127")
    args = parser.parse_args()
    if not os.environ.get("DBUS_SESSION_BUS_ADDRESS"):
        raise SystemExit("Run inside dbus-run-session; this probe requires its own session bus")
    if pathlib.Path("/tmp/.X11-unix/X" + args.display.removeprefix(":")).exists():
        raise SystemExit("Requested display already exists; choose a new owned display")
    binary = args.binary.resolve()
    processes = []
    events = []
    with tempfile.TemporaryDirectory(prefix="hummingbird-native-") as temporary:
        temporary = pathlib.Path(temporary)
        env = {**os.environ, "DISPLAY": args.display, "XDG_RUNTIME_DIR": str(temporary),
               "GSETTINGS_BACKEND": "memory"}
        deadline = time.monotonic() + 40
        native_log = temporary / "native.log"
        captured = False
        with native_log.open("w") as log:
            try:
                processes.append(subprocess.Popen([str(args.xvfb), args.display, "-screen", "0", "1024x768x24", "-nolisten", "tcp"], env=env, stdout=log, stderr=log))
                wait(lambda: subprocess.run([str(args.xdotool), "getdisplaygeometry"], env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0,
                     deadline, "owned Xvfb readiness")
                processes.append(subprocess.Popen([str(args.atspi_launcher), "--launch-immediately", "--a11y=1"], env=env, stdout=log, stderr=log))
                session = env["DBUS_SESSION_BUS_ADDRESS"]

                def bus(address, *command):
                    result = subprocess.run(["busctl", "--json=short", "--timeout=2", "--address=" + address, *command],
                                            env=env, text=True, capture_output=True, check=True)
                    if not result.stdout.strip():
                        return []
                    data = json.loads(result.stdout)["data"]
                    # busctl properties encode one bare value, while method
                    # replies encode a tuple of return values.
                    return [data] if command[0] == "get-property" else data

                def discover():
                    try:
                        return bus(session, "call", "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Bus", "GetAddress")[0]
                    except (subprocess.CalledProcessError, KeyError, ValueError):
                        return None

                address = wait(discover, deadline, "private accessibility bus")
                # Only the new private session's status service is changed.
                bus(session, "set-property", "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Status", "IsEnabled", "b", "true")
                processes.append(subprocess.Popen([str(binary), "--native"], env=env, stdout=log, stderr=log))

                def tree():
                    queue = [("org.a11y.atspi.Registry", "/org/a11y/atspi/accessible/root")]
                    result = []
                    while queue:
                        destination, path = queue.pop(0)
                        assert len(result) < 1000, "unexpected unbounded accessibility tree"
                        name = bus(address, "get-property", destination, path, "org.a11y.atspi.Accessible", "Name")[0]
                        result.append((name, destination, path))
                        queue.extend(tuple(child) for child in bus(address, "call", destination, path, "org.a11y.atspi.Accessible", "GetChildren")[0])
                    return result

                def named(name):
                    try:
                        return next((node for node in tree() if node[0] == name), None)
                    except (subprocess.CalledProcessError, KeyError, ValueError):
                        return None

                def find(name):
                    return wait(lambda: named(name), deadline, "visible acknowledged accessible: " + name)

                def invoke(node):
                    data = bus(address, "call", node[1], node[2], "org.a11y.atspi.Action", "DoAction", "i", "0")
                    assert data == [True], (node, data)

                find("9 recordings for ‘’ — Title")
                events.append({"stage": "initial", "visible_name": "9 recordings for ‘’ — Title"})
                # The old first row anchors the scroll position after resort,
                # so it remains visible even though its SQL index moves0→6.
                play = find("Play Album Track")
                invoke(play)
                find("Play request 1: recording 1 — /music/1.flac")
                events.append({"stage": "play", "id": 1, "path": "/music/1.flac"})
                invoke(find("Longest first"))
                find("9 recordings for ‘’ — Longest first")
                assert find("Play Album Track")[1:] == play[1:], "row's native action identity changed after SQL resort"
                events.append({"stage": "resort", "same_accessible_action": list(play[1:])})

                search = find("Search recordings")
                extents = bus(address, "call", search[1], search[2], "org.a11y.atspi.Component", "GetExtents", "u", "0")[0]
                window = subprocess.check_output([str(args.xdotool), "search", "--onlyvisible", "--name", "Hummingbird"], env=env, text=True).splitlines()[0]
                subprocess.run([str(args.xdotool), "windowfocus", "--sync", window], env=env, check=True)
                subprocess.run([str(args.xdotool), "mousemove", str(extents[0] + 12), str(extents[1] + extents[3] // 2), "click", "1"], env=env, check=True)
                subprocess.run([str(args.xdotool), "type", "--clearmodifiers", "--delay", "1", "cafe"], env=env, check=True)
                find("3 recordings for ‘cafe’ — Longest first")
                events.append({"stage": "x11_text_edit", "query": "cafe", "matched_ids": [13, 11, 21]})

                # Second edit traverses the actual native EditableText method.
                assert bus(address, "call", search[1], search[2], "org.a11y.atspi.EditableText", "SetTextContents", "s", "μαρ") == [True]
                find("1 recordings for ‘μαρ’ — Longest first")
                invoke(find("Play Καλημέρα"))
                find("Play request 2: recording 44 — /music/44.flac")
                events.append({"stage": "unicode_edit_and_play", "query": "μαρ", "id": 44, "path": "/music/44.flac"})
                log.flush()
                output = native_log.read_text()
                frames = [line.split(",")[1:] for line in output.splitlines() if line.startswith("HUMMINGBIRD_PRESENT,")]
                assert frames and all(source == presented for _, source, presented in frames), frames
                args.output.write_text(json.dumps({"method": "Ordinary Window/shared View; private Xvfb+AT-SPI2, actual X11 keyboard and AT-SPI edits/actions; acknowledged accessible labels, stable row action across SQL resort. No timing measurement.",
                                                   "binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
                                                   "events": events, "presented_frames": frames, "native_log": output}, indent=2) + "\n")
                captured = True
                print("Native render, SQL resort, stable action, X11 edit, Unicode AT-SPI edit and real-ID playback requests passed")
            finally:
                for process in reversed(processes):
                    process.terminate()
                for process in reversed(processes):
                    try:
                        process.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        process.kill()
                        process.wait()
                if not captured:
                    args.output.with_suffix(".failure.log").write_text(native_log.read_text())


if __name__ == "__main__":
    main()
