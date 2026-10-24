from pathlib import Path
import json,os,subprocess,tempfile,select,signal,sys
rows=[json.loads(s) for s in Path('/tmp/gpui-length-native-artifacts-15.jsonl').read_text().splitlines() if s.startswith('{')]
exe=next(r['executable'] for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']=='gpui' and r['profile']['test'])
with tempfile.TemporaryDirectory(prefix='gpui-length-native-property-') as runtime:
 os.chmod(runtime,0o700)
 r,w=os.pipe()
 with open('/tmp/gpui-length-native-property-xvfb.log','w') as log:
  server=subprocess.Popen(['/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','-displayfd',str(w),'-screen','0','1200x800x24','-nolisten','tcp','-noreset'],pass_fds=(w,),stdout=log,stderr=log,start_new_session=True)
  os.close(w)
  try:
   assert select.select([r],[],[],10)[0]
   display=':'+os.read(r,32).decode().strip()
   env=dict(os.environ,DISPLAY=display,XDG_RUNTIME_DIR=runtime,WINIT_X11_SCALE_FACTOR='1')
   for name in ['WAYLAND_DISPLAY','AT_SPI_BUS_ADDRESS','NO_AT_BRIDGE']:env.pop(name,None)
   args=['/nix/store/8snmq54bp5d5vp5dihgn7xr53hayx629-dbus-1.16.2/bin/dbus-run-session','--',exe,'--ignored','--exact','native::property_action_tests::native_contained_property_entry_recovers_and_reports_stale_targets','--nocapture','--test-threads=1']
   with open('/tmp/gpui-length-native-property-test-15.log','w') as output:
    app=subprocess.Popen(args,env=env,stdout=output,stderr=output,start_new_session=True)
    try:code=app.wait(timeout=50)
    finally:
     if app.poll() is None:os.killpg(app.pid,signal.SIGTERM);app.wait(timeout=5)
   print('native property test exit='+str(code))
   sys.exit(code)
  finally:
   os.close(r);os.killpg(server.pid,signal.SIGTERM);server.wait(timeout=5)
