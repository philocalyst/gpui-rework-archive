import os,pathlib,subprocess,tempfile,select,signal,time,json,hashlib,pty
binary=pathlib.Path('/root/targets/typed-length-port-sol-native-20261024/debug/examples/halloween')
xdotool='/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool'
import_image='/nix/store/1zns14x0dv9krcnbznbxkqlj28jxmdcp-imagemagick-7.1.2-31/bin/import'
with tempfile.TemporaryDirectory(prefix='gpui-length-native-') as runtime:
 os.chmod(runtime,0o700)
 r,w=os.pipe()
 with open('/tmp/gpui-length-xvfb.log','w') as log:
  server=subprocess.Popen(['/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','-displayfd',str(w),'-screen','0','1200x800x24','-nolisten','tcp','-noreset'],pass_fds=(w,),stdout=log,stderr=log,start_new_session=True)
  os.close(w)
  try:
   assert select.select([r],[],[],10)[0]
   display=':'+os.read(r,32).decode().strip()
   env=dict(os.environ,DISPLAY=display,XDG_RUNTIME_DIR=runtime,WINIT_X11_SCALE_FACTOR='1')
   for name in ['WAYLAND_DISPLAY','AT_SPI_BUS_ADDRESS','NO_AT_BRIDGE']: env.pop(name,None)
   with open('/tmp/gpui-length-native-run.log','w') as log:
    master,slave=pty.openpty()
    app=subprocess.Popen(['/nix/store/8snmq54bp5d5vp5dihgn7xr53hayx629-dbus-1.16.2/bin/dbus-run-session','--',str(binary)],env=env,stdout=slave,stderr=slave,start_new_session=True)
    os.close(slave)
    try:
     window=None
     for _ in range(100):
      if app.poll() is not None: raise RuntimeError('application exited '+str(app.returncode))
      found=subprocess.run([xdotool,'search','--onlyvisible','--name','After dark'],env=env,stdout=subprocess.PIPE,stderr=subprocess.DEVNULL,text=True)
      if found.returncode==0: window=found.stdout.strip().splitlines()[0];break
      time.sleep(.1)
     assert window
     subprocess.run([xdotool,'windowfocus','--sync',window],env=env,check=True)
     transcript=''
     def presented_after(epoch):
      nonlocal_dummy=None
      deadline=time.monotonic()+45
      while time.monotonic()<deadline:
       if select.select([master],[],[],.1)[0]:
        chunk=os.read(master,65536).decode();log.write(chunk);log.flush()
        print(chunk.strip(),flush=True)
        for line in chunk.splitlines():
         if line.startswith('party-presented S='):
          source=int(line.split('S=')[1].split()[0])
          if source>=epoch:return source
       if app.poll() is not None:raise RuntimeError('application exited')
      raise TimeoutError('no acknowledged frame at S='+str(epoch))
     epoch=presented_after(0)
     subprocess.run([import_image,'-window',window,'/tmp/gpui-length-halloween-native-draft.png'],env=env,check=True)
     subprocess.run([xdotool,'mousemove','--window',window,'70','365'],env=env,check=True)
     time.sleep(.1)
     subprocess.run([xdotool,'mousedown','1'],env=env,check=True)
     epoch=presented_after(epoch+1)
     subprocess.run([xdotool,'mouseup','1'],env=env,check=True)
     epoch=presented_after(epoch+1)
     subprocess.run([import_image,'-window',window,'/tmp/gpui-length-halloween-native-focus.png'],env=env,check=True)
     for index,key in enumerate(['space','Return','Tab','space','space','Tab','Return']):
      subprocess.run([xdotool,'key','--clearmodifiers',key],env=env,check=True)
      epoch=presented_after(epoch+1)
      if index==3:
       subprocess.run([import_image,'-window',window,'/tmp/gpui-length-halloween-native-disabled.png'],env=env,check=True)
     subprocess.run([import_image,'-window',window,'/tmp/gpui-length-halloween-native-ready.png'],env=env,check=True)
     subprocess.run([xdotool,'windowsize','--sync',window,'960','700'],env=env,check=True)
     resize_epoch=presented_after(epoch)
     geometry=subprocess.check_output([xdotool,'getwindowgeometry','--shell',window],env=env,text=True)
     assert 'WIDTH=960' in geometry and 'HEIGHT=700' in geometry,geometry
     subprocess.run([import_image,'-window',window,'/tmp/gpui-length-halloween-native-resized.png'],env=env,check=True)
     result={'binary':str(binary),'binary_sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'window':window,'display':display,'renderer':'ReferenceCpu','screenshots':['draft','focus','disabled','ready','resized'],'events':['pointer lanterns','Space lanterns','Enter lanterns','Tab treats','Space treats off','Space treats on','Tab finish','Enter finish'],'final_acknowledged_epoch':epoch,'resize_acknowledged_epoch':resize_epoch,'resized_geometry':geometry,'process_live_after_events':app.poll() is None,'limitation':'Xvfb software display; no hardware GPU or physical display claim'}
     pathlib.Path('/tmp/gpui-length-native-capture.json').write_text(json.dumps(result,indent=2)+'\n')
     print(json.dumps(result))
    finally:
     if app.poll() is None: os.killpg(app.pid,signal.SIGTERM)
     app.wait(timeout=5)
     os.close(master)
  finally:
   os.close(r);os.killpg(server.pid,signal.SIGTERM);server.wait(timeout=5)
