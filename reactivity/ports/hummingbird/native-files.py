#!/usr/bin/env python3
"""Actual Registry actions on the public app and real audio service; no hardware."""
import argparse
import ctypes
import hashlib
import json
import os
from pathlib import Path
import select
import subprocess
import time
import shutil
import sqlite3


def close_window(display, window):
    """Send the normal WM_DELETE_WINDOW protocol, not XDestroyWindow/SIGTERM."""
    class Data(ctypes.Union):
        _fields_ = [("l", ctypes.c_long * 5)]

    class Message(ctypes.Structure):
        _fields_ = [("type", ctypes.c_int), ("serial", ctypes.c_ulong),
                    ("send_event", ctypes.c_int), ("display", ctypes.c_void_p),
                    ("window", ctypes.c_ulong), ("message_type", ctypes.c_ulong),
                    ("format", ctypes.c_int), ("data", Data)]

    class Event(ctypes.Union):
        _fields_ = [("message", Message), ("pad", ctypes.c_long * 24)]

    x11 = ctypes.CDLL("libX11.so.6")
    x11.XOpenDisplay.argtypes = [ctypes.c_char_p]
    x11.XOpenDisplay.restype = ctypes.c_void_p
    x11.XInternAtom.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_int]
    x11.XInternAtom.restype = ctypes.c_ulong
    x11.XSendEvent.argtypes = [ctypes.c_void_p, ctypes.c_ulong, ctypes.c_int, ctypes.c_long, ctypes.POINTER(Event)]
    x11.XFlush.argtypes = [ctypes.c_void_p]
    x11.XCloseDisplay.argtypes = [ctypes.c_void_p]
    connection = x11.XOpenDisplay(display.encode())
    assert connection
    event = Event()
    event.message.type = 33
    event.message.display = connection
    event.message.window = window
    event.message.message_type = x11.XInternAtom(connection, b"WM_PROTOCOLS", 0)
    event.message.format = 32
    event.message.data.l[0] = x11.XInternAtom(connection, b"WM_DELETE_WINDOW", 0)
    assert x11.XSendEvent(connection, window, 0, 0, ctypes.byref(event))
    x11.XFlush(connection)
    x11.XCloseDisplay(connection)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("binary", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--collections", action="store_true", help=argparse.SUPPRESS)
    args = parser.parse_args()
    args.output.mkdir(exist_ok=False)
    args.output = args.output.resolve()
    deadline = time.monotonic() + 150
    events, children = [], []
    root = Path(__file__).resolve().parents[3]
    paths = subprocess.check_output(["git", "ls-files", "reactivity/ports/hummingbird", "reactivity/crates/gpui/src"], cwd=root, text=True).splitlines()

    def guard():
        return {"sources": {p: hashlib.sha256((root / p).read_bytes()).hexdigest() for p in paths},
                "binary": hashlib.sha256(args.binary.read_bytes()).hexdigest()}

    before = guard()
    (args.output / "before.json").write_text(json.dumps(before, indent=2) + "\n")

    def wait(predicate, description):
        while time.monotonic() < deadline:
            value = predicate()
            if value:
                return value
            time.sleep(.05)  # External client discovery only.
        raise TimeoutError(description)

    with (args.output / "native.log").open("w") as log:
        try:
            read, write = os.pipe()
            children.append(subprocess.Popen([
                "/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb",
                "-displayfd", str(write), "-screen", "0", "1024x1000x24", "-nolisten", "tcp"],
                pass_fds=(write,), stdout=log, stderr=log))
            os.close(write)
            assert select.select([read], [], [], 15)[0], "Xvfb readiness"
            display = ":" + os.read(read, 32).decode().strip()
            os.close(read)
            runtime = args.output / "runtime"
            runtime.mkdir(mode=0o700)
            env = dict(os.environ, DISPLAY=display, GSETTINGS_BACKEND="memory", XDG_RUNTIME_DIR=str(runtime.resolve()))
            children.append(subprocess.Popen([
                "/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher",
                "--launch-immediately", "--a11y=1"], env=env, stdout=log, stderr=log))
            session = env["DBUS_SESSION_BUS_ADDRESS"]

            def bus(address, *command):
                result = subprocess.run(["busctl", "--json=short", "--timeout=2", "--address=" + address, *command], env=env, text=True, capture_output=True, check=True)
                if not result.stdout.strip():
                    return []
                data = json.loads(result.stdout)["data"]
                return [data] if command[0] == "get-property" else data

            def discover():
                try:
                    return bus(session, "call", "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Bus", "GetAddress")[0]
                except subprocess.CalledProcessError:
                    return None

            address = wait(discover, "private accessibility bus")
            bus(session, "set-property", "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Status", "IsEnabled", "b", "true")
            app = subprocess.Popen([str(args.binary), "--library", str(args.output / "library.sqlite")], env=env, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=log)
            children.append(app)
            pending = b""

            def command(value):
                nonlocal pending
                app.stdin.write((value + "\n").encode())
                app.stdin.flush()
                lines = []
                while time.monotonic() < deadline:
                    while b"\n" in pending:
                        line, pending = pending.split(b"\n", 1)
                        line = line.decode()
                        lines.append(line)
                        if line == "ACK," + value:
                            events.append({"command": value, "reply": lines})
                            return lines
                    assert select.select([app.stdout], [], [], 5)[0], "command reply watchdog"
                    chunk = os.read(app.stdout.fileno(), 4096)
                    assert chunk, "app exited during command"
                    pending += chunk
                raise TimeoutError(value)

            def tree():
                queue = [("org.a11y.atspi.Registry", "/org/a11y/atspi/accessible/root")]
                nodes = []
                while queue:
                    destination, path = queue.pop(0)
                    assert len(nodes) < 500
                    name = bus(address, "get-property", destination, path, "org.a11y.atspi.Accessible", "Name")[0]
                    nodes.append((name, destination, path))
                    queue.extend(tuple(child) for child in bus(address, "call", destination, path, "org.a11y.atspi.Accessible", "GetChildren")[0])
                return nodes

            def named(name):
                assert app.poll() is None, "native app exited"
                try:
                    return next((node for node in tree() if node[0] == name), None)
                except subprocess.CalledProcessError:
                    assert app.poll() is None, "native app exited"
                    return None

            def find(name):
                node = wait(lambda: named(name), name)
                events.append({"visible": name, "provider": node[1:]})
                return node

            def invoke(name):
                node = find(name)
                assert bus(address, "call", node[1], node[2], "org.a11y.atspi.Action", "DoAction", "i", "0") == [True]

            def search(value):
                node = find("Search recordings")
                assert bus(address, "call", node[1], node[2], "org.a11y.atspi.EditableText", "SetTextContents", "s", value) == [True]

            def stats():
                line = command("stats")[0].split(",")
                return [int(v) for v in line[1:5]] + [line[5] == "true"]

            music = args.output / "Καφέ"
            music.mkdir()
            for name, extension in [("Καλημέρα", "wav"), ("Second", "flac"), ("Third", "mp3")]:
                shutil.copyfile(Path(__file__).parent / f"assets/audio/stereo.{extension}", music / f"{name}.{extension}")
            (args.output / "fixtures.json").write_text(json.dumps({str(path): hashlib.sha256(path.read_bytes()).hexdigest() for path in music.iterdir()}, indent=2) + "\n")
            find("0 recordings for ‘’ — Title")
            invoke("Files")
            node = find("Library root path")
            assert bus(address, "call", node[1], node[2], "org.a11y.atspi.EditableText", "SetTextContents", "s", str(music)) == [True]
            invoke("Add library root")
            find("Library roots updated")
            find(f"Open {music}")
            assert stats() == [0, 0, 0, 0, False], "root admission or pure Files query started playback"
            invoke("Index library roots")
            find("Indexed 3; unchanged 0; removed 0; failed 0")
            invoke("Tracks")
            find("3 recordings for ‘’ — Title")
            command("collision")
            invoke("Prepare Καλημέρα")
            with sqlite3.connect(f"file:{args.output / 'library.sqlite'}?mode=ro", uri=True) as connection:
                track_id = connection.execute("SELECT id FROM track WHERE title=?", ["Καλημέρα"]).fetchone()[0]
            find(f"Prepared request 3: recording {track_id} — {music / 'Καλημέρα.wav'}")
            assert stats() == [0, 0, 0, 0, False], "scan, query, pure Prepare or unmatched reply played"
            invoke("Files")
            invoke(f"Open {music}")
            find("3 entries; 3 recordings")
            invoke("Play all files")
            find("Collection playback started")
            wait(lambda: stats()[0] == 1, "Files context real service open")
            assert stats()[1:3] == [0, 0], "zero-credit Files sink accepted PCM"
            command("credit")
            wait(lambda: stats()[1:3] == [64, 64], "bounded Files PCM production")
            find("Queue — 3 entries")
            invoke("Stop")
            find("No decoder plan")
            wait(lambda: not stats()[4], "Stop revokes Files output gate")
            command("disconnect")
            find("Library worker closed")
            invoke("Files")
            invoke("Index library roots")
            find("Library worker is closed")
            assert stats()[0] == 1, "closed worker restarted Files playback"
            xdotool = "/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool"
            window = int(subprocess.check_output([xdotool, "search", "--onlyvisible", "--name", "Hummingbird"], env=env, text=True).splitlines()[0])
            close_window(display, window)
            app.stdin.close()
            assert app.wait(timeout=10) == 0, "WM close did not retire application services"
            log.flush()
            assert "HUMMINGBIRD_NATIVE_CLOSED" in (args.output / "native.log").read_text()
            (args.output / "result.json").write_text(json.dumps({"passed": True, "events": events, "files": True, "scope": "Actual Registry/public Window roots, real indexing, Files context and pure Prepare actions; real SQLite/audio owners; bounded counting output, no hardware or timing claim; unmatched full-Selection collision."}, indent=2) + "\n")
        finally:
            for child in reversed(children):
                if child.poll() is None:
                    child.terminate()
            for child in reversed(children):
                try:
                    child.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    child.kill()
                    child.wait()
            after = guard()
            (args.output / "after.json").write_text(json.dumps(after, indent=2) + "\n")
            (args.output / "events.json").write_text(json.dumps(events, indent=2) + "\n")
            assert before == after, "source/binary changed during native capture"
    print("DONE: public native Files/indexing/Library/SQL/one-click/audio/Stop/disconnect/WM close; all children exited")


if __name__ == "__main__":
    main()
