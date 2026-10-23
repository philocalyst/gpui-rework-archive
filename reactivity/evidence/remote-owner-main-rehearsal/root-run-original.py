from pathlib import Path
import hashlib, json, os, re, select, subprocess, sys

label = sys.argv[1]
root = Path('/tmp/gpui-a11y-action-poll-root')
dest = Path('/tmp/gpui-a11y-action-poll-captures')/label
dest.mkdir(parents=True, exist_ok=False)
paths = [root/'reactivity/crates/gpui/src/native.rs',
         root/'reactivity/crates/gpui/src/native/accessibility.rs',
         root/'reactivity/crates/gpui/src/native/accessibility/poll_tests.rs']
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
binaries = [p for p in Path('/tmp/gpui-a11y-action-poll-target/debug/deps').glob('gpui-*')
            if p.is_file() and re.fullmatch('gpui-[0-9a-f]+',p.name) and os.access(p,os.X_OK)]
assert len(binaries)==1, binaries
binary = binaries[0]
guard={str(p):sha(p) for p in [*paths,binary]}
(dest/'before.json').write_text(json.dumps(guard,indent=2)+'\n')
read,write=os.pipe()
with (dest/'xvfb.log').open('w') as log:
    server=subprocess.Popen(['/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb',
                             '-displayfd',str(write),'-screen','0','1024x768x24','-nolisten','tcp'],
                            pass_fds=(write,),stdout=log,stderr=subprocess.STDOUT)
    os.close(write)
    try:
        assert select.select([read],[],[],20)[0], 'Xvfb readiness watchdog'
        number=os.read(read,32).decode().strip(); assert number.isdecimal()
        environment=dict(os.environ,DISPLAY=':'+number,GSETTINGS_BACKEND='memory')
        command=['dbus-run-session','--',str(binary),
                 'native::accessibility::poll_tests::native_action_poll_stops_on_fatal_continues_after_repair_and_rearms_stale_budget',
                 '--exact','--ignored','--nocapture','--test-threads=1']
        (dest/'command.json').write_text(json.dumps({'argv':command,'display':environment['DISPLAY'],'scope':'functional native callback proof, direct ingress; no performance or actual AT-SPI claim'},indent=2)+'\n')
        with (dest/'stdout.log').open('w') as stdout,(dest/'stderr.log').open('w') as stderr:
            result=subprocess.run(command,env=environment,stdout=stdout,stderr=stderr,timeout=55)
        (dest/'status').write_text(str(result.returncode)+'\n')
    finally:
        os.close(read)
        server.terminate()
        try: server.wait(timeout=5)
        except subprocess.TimeoutExpired: server.kill();server.wait()
assert guard == {str(p):sha(p) for p in [*paths,binary]}, 'source or binary changed'
(dest/'after.json').write_text(json.dumps(guard,indent=2)+'\n')
print(label,result.returncode)
sys.exit(result.returncode)
