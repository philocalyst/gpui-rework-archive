from pathlib import Path
import hashlib,json,os,select,shutil,subprocess,sys,time
cap=Path('/tmp/gpui-a11y-action-poll-captures/native-registry');root=Path('/tmp/gpui-a11y-action-poll-root')
if '--inner' not in sys.argv:
    cap.mkdir(exist_ok=False)
    binary=Path('/tmp/gpui-a11y-action-poll-target/debug/deps/gpui-e5c9359d761e98c0')
    shutil.copy2(binary,cap/'gpui-tests');(cap/'gpui-tests').chmod(0o555)
    paths=list((root/'reactivity/crates/gpui/src/native').rglob('*.rs'))+[root/'reactivity/crates/gpui/src/native.rs',cap/'gpui-tests',root/'reactivity/Cargo.lock',root/'.cargo/config.toml']
    guard={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    (cap/'before.json').write_text(json.dumps(guard,indent=2)+'\n')
    command=['dbus-run-session','--',sys.executable,__file__,'--inner']
    with (cap/'session.log').open('w') as log:result=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,timeout=100)
    assert guard=={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    (cap/'after.json').write_text(json.dumps(guard,indent=2)+'\n');(cap/'status').write_text(str(result.returncode)+'\n')
    print('REGISTRY',result.returncode);sys.exit(result.returncode)
services=[];read,write=os.pipe()
with (cap/'services.log').open('w') as log:
    try:
        services.append(subprocess.Popen(['/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','-displayfd',str(write),'-screen','0','1024x768x24','-nolisten','tcp'],pass_fds=(write,),stdout=log,stderr=log))
        os.close(write);assert select.select([read],[],[],20)[0]
        number=os.read(read,32).decode().strip();assert number.isdecimal()
        env=dict(os.environ,DISPLAY=':'+number,GSETTINGS_BACKEND='memory')
        services.append(subprocess.Popen(['/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher','--launch-immediately','--a11y=0'],env=env,stdout=log,stderr=log))
        for _ in range(100):
            ready=subprocess.run(['busctl','--user','--timeout=1','call','org.a11y.Bus','/org/a11y/bus','org.a11y.Bus','GetAddress'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
            if ready.returncode==0:break
            time.sleep(.05)
        assert ready.returncode==0
        name='native::accessibility::linux_tests::failure::native_atspi_failed_source_keeps_old_p_and_public_action_repairs'
        args=[str(cap/'gpui-tests'),name,'--exact','--ignored','--nocapture','--test-threads=1']
        (cap/'command.json').write_text(json.dumps({'argv':args,'display':env['DISPLAY'],'scope':'actual native AT-SPI Registry client; functional only'},indent=2)+'\n')
        with (cap/'client.log').open('w') as client:
            result=subprocess.run(args,env=env,stdout=client,stderr=subprocess.STDOUT,timeout=80)
        (cap/'result.json').write_text(json.dumps({'exit':result.returncode,'test':name},indent=2)+'\n')
    finally:
        os.close(read)
        for p in reversed(services):p.terminate()
        for p in reversed(services):
            try:p.wait(timeout=5)
            except subprocess.TimeoutExpired:p.kill();p.wait()
sys.exit(result.returncode)
