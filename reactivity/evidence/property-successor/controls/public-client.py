#!/usr/bin/env python3
"""Replay the unchanged public property_editor via real private AT-SPI only."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('binary', type=Path)
    parser.add_argument('--xvfb', type=Path, required=True)
    parser.add_argument('--launcher', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--display', default=':163')
    args = parser.parse_args()
    session = os.environ.get('DBUS_SESSION_BUS_ADDRESS')
    if not session:
        raise SystemExit('Run under a private dbus-run-session')
    socket = Path('/tmp/.X11-unix/X' + args.display.removeprefix(':'))
    if socket.exists():
        raise SystemExit('Display already exists; choose an unused private display')
    processes = []
    events = []
    binary = args.binary.resolve()
    record = {'binary': str(binary), 'binary_sha256': hashlib.file_digest(binary.open('rb'), 'sha256').hexdigest(),
              'method': 'Unmodified public Window::document example; real private Registry/AT-SPI actions and EditableText; no host/model seeding or timing claim.', 'events': events}
    with tempfile.TemporaryDirectory(prefix='gpui-property-atspi-') as directory:
        env = {**os.environ, 'DISPLAY': args.display, 'XDG_RUNTIME_DIR': directory, 'GSETTINGS_BACKEND': 'memory'}
        log_path = Path(directory) / 'native.log'
        deadline = time.monotonic() + 75
        def wait(predicate, description):
            while time.monotonic() < deadline:
                try:
                    result = predicate()
                    if result:
                        return result
                except (subprocess.CalledProcessError, KeyError, ValueError):
                    pass
                time.sleep(0.05)
            raise TimeoutError(description)
        with log_path.open('w') as log:
            try:
                processes.append(subprocess.Popen([str(args.xvfb), args.display, '-screen', '0', '1024x768x24', '-nolisten', 'tcp'], env=env, stdout=log, stderr=log))
                wait(socket.exists, 'private Xvfb socket')
                processes.append(subprocess.Popen([str(args.launcher), '--launch-immediately', '--a11y=1'], env=env, stdout=log, stderr=log))
                def bus(address, *command):
                    output = subprocess.check_output(['busctl', '--json=short', '--timeout=2', '--address=' + address, '--', *command], env=env, text=True, stderr=subprocess.DEVNULL)
                    if not output.strip():
                        return []
                    data = json.loads(output)['data']
                    return [data] if command[0] == 'get-property' else data
                address = wait(lambda: bus(session, 'call', 'org.a11y.Bus', '/org/a11y/bus', 'org.a11y.Bus', 'GetAddress')[0], 'accessibility bus')
                bus(session, 'set-property', 'org.a11y.Bus', '/org/a11y/bus', 'org.a11y.Status', 'IsEnabled', 'b', 'true')
                processes.append(subprocess.Popen([str(binary), '--cpu'], env=env, stdout=log, stderr=log))
                def tree():
                    queue = [('org.a11y.atspi.Registry', '/org/a11y/atspi/accessible/root')]
                    result = []
                    while queue:
                        destination, path = queue.pop(0)
                        assert len(result) < 100, 'unexpected tree size'
                        name = bus(address, 'get-property', destination, path, 'org.a11y.atspi.Accessible', 'Name')[0]
                        result.append((name, destination, path))
                        queue.extend(tuple(child) for child in bus(address, 'call', destination, path, 'org.a11y.atspi.Accessible', 'GetChildren')[0])
                    return result
                def find(name):
                    return wait(lambda: next((node for node in tree() if node[0] == name), None), 'accessible ' + name)
                def call(node, interface, method, *arguments):
                    return bus(address, 'call', node[1], node[2], 'org.a11y.atspi.' + interface, method, *arguments)
                def action(name):
                    node = find(name)
                    assert call(node, 'Action', 'DoAction', 'i', '0') == [True]
                    events.append({'action': name, 'address': node[1:]})
                def text(expected):
                    def ready():
                        node = find('Property draft')
                        value = call(node, 'Text', 'GetText', 'ii', '0', '-1')[0]
                        return node if value == expected else None
                    node = wait(ready, 'acknowledged draft ' + expected)
                    bounds = call(node, 'Component', 'GetExtents', 'u', '0')[0]
                    extent = call(node, 'Text', 'GetCharacterExtents', 'iu', '0', '0')
                    assert bounds[2] > 0 and bounds[3] > 0
                    assert extent[2] > 0 and extent[3] > 0, extent
                    assert bounds[0] - 1 <= extent[0] < bounds[0] + bounds[2]
                    assert bounds[1] - 1 <= extent[1] < bounds[1] + bounds[3]
                    events.append({'draft': expected, 'bounds': bounds, 'character0': extent, 'address': node[1:]})
                    return node
                check = find('Inspect application')
                assert call(check, 'Accessible', 'GetRole') == [7]
                initial_bounds = call(find('Library button'), 'Component', 'GetExtents', 'u', '0')[0]
                action('Inspect application')
                wait(lambda: call(find('Inspect application'), 'Accessible', 'GetState')[0][0] & (1 << 4), 'acknowledged checked state')
                action('Library button')
                text('120')
                draft = find('Property draft')
                assert call(draft, 'EditableText', 'SetTextContents', 's', '193.25') == [True]
                text('193.25')
                action('Apply')
                enlarged = wait(lambda: (value if (value := call(find('Library button'), 'Component', 'GetExtents', 'u', '0')[0])[2] > initial_bounds[2] else None), 'acknowledged application width')
                text('193.25')
                events.append({'application_before': initial_bounds, 'application_after_apply': enlarged})
                action('Inherit')
                text('120')
                restored = call(find('Library button'), 'Component', 'GetExtents', 'u', '0')[0]
                assert restored == initial_bounds, (restored, initial_bounds)
                action('Refresh selection')
                text('120')
                record['final_tree'] = tree()
                record['passed'] = True
            except BaseException as error:
                record['passed'] = False
                record['failure'] = repr(error)
                raise
            finally:
                for process in reversed(processes):
                    process.terminate()
                for process in reversed(processes):
                    try:
                        process.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        process.kill()
                        process.wait()
                log.flush()
                record['native_log'] = log_path.read_text()
                args.output.write_text(json.dumps(record, indent=2) + '\n')
    print('Public Window: checkbox action, self selection, EditableText, Apply, Inherit, Refresh and acknowledged extents passed')


if __name__ == '__main__':
    main()
