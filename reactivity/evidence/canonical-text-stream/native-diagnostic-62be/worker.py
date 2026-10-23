from pathlib import Path
import hashlib,json,os,signal,subprocess,sys,time
from normal_close import close
base=Path(__file__).parent
reg=json.loads((base/'registration.json').read_text())
label=sys.argv[1];out=base/'results'/label;out.mkdir()
assert os.sched_getaffinity(0)=={0}
assert not Path('/tmp/.X11-unix/X116').exists()
env=dict(os.environ,DISPLAY=':116')
state={'label':label,'mode':'clock-disabled functional diagnostic; NEVER performance samples','cpu':sorted(os.sched_getaffinity(0)),'argv':reg['native_commands'][label]}
server=monitor=child=None
try:
    with (out/'xvfb.log').open('w') as log:server=subprocess.Popen(reg['xvfb_command'],env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
    for _ in range(200):
        assert server.poll() is None
        if Path('/tmp/.X11-unix/X116').exists():break
        time.sleep(.01)
    assert Path('/tmp/.X11-unix/X116').exists()
    with (out/'dbus-monitor.log').open('w') as log:monitor=subprocess.Popen(reg['monitor_command'],env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
    for _ in range(100):
        if (out/'dbus-monitor.log').stat().st_size or monitor.poll() is not None:break
        time.sleep(.01)
    state['monitor_started']=monitor.poll() is None
    argv=reg['native_commands'][label]
    if reg['strace_available_for_both']:
        argv=[reg['strace'],'-ff','-ttt','-T','-s','32','-o',str(out/'syscall'),'-e',reg['strace_syscalls'],*argv]
    state['executed_argv']=argv
    with (out/'native.log').open('w') as log:
        child=subprocess.Popen(argv,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:state['native_exit']=child.wait(timeout=80)
        except subprocess.TimeoutExpired:
            state['external_80s_guard']='normal-close attempt after fixture60s watchdog did not finish'
            try:
                os.environ['DISPLAY']=':116';close();state['external_normal_close']='sent WM_DELETE_WINDOW plus XSync'
            except BaseException as e:state['external_normal_close_error']=repr(e)
            try:state['native_exit']=child.wait(timeout=10)
            except subprocess.TimeoutExpired:
                state['forced_cleanup']=True;os.killpg(child.pid,signal.SIGKILL);state['native_exit']=child.wait()
    lines=(out/'native.log').read_text().splitlines()
    outputs=[json.loads(line) for line in lines if line.startswith('{')]
    state['native_json']=outputs
    if outputs:
        assert len(outputs)==1 and outputs[0]['elapsed_ns']==[] and outputs[0]['host_ack_elapsed_ns']==[]
        assert outputs[0]['count']==128 and outputs[0]['provider_completed_cycles']==128
    state['status']='diagnostic execution complete; no performance inference'
except BaseException as e:
    state['status']='diagnostic wrapper failure; preserve';state['failure']=repr(e)
finally:
    if child is not None and child.poll() is None:
        try:os.environ['DISPLAY']=':116';close();child.wait(timeout=5)
        except BaseException:os.killpg(child.pid,signal.SIGKILL);child.wait();state['forced_cleanup']=True
    for name,process in [('monitor',monitor),('xvfb',server)]:
        if process is not None:
            if process.poll() is None:process.terminate()
            try:state[name+'_exit']=process.wait(timeout=5)
            except subprocess.TimeoutExpired:process.kill();state[name+'_exit']=process.wait()
    (out/'metadata.json').write_text(json.dumps(state,indent=2)+'\n')
print(json.dumps(state,indent=2))
