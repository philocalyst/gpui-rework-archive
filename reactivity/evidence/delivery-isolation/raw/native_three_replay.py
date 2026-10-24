import hashlib,json,os,pathlib,subprocess,tempfile,time
root=pathlib.Path('/tmp/gpui-delivery-isolation-captures')
input_root=root
root=root/'native-replay'
root.mkdir(exist_ok=False)
artifacts=[]
for line in (input_root/'native-build.jsonl').read_text().splitlines():
 try: row=json.loads(line)
 except ValueError: continue
 if row.get('reason')=='compiler-artifact' and row.get('target',{}).get('name')=='gpui' and row.get('profile',{}).get('test') and row.get('executable'):
  artifacts.append(row['executable'])
assert len(artifacts)==1, artifacts
binary=pathlib.Path(artifacts[0]); before=hashlib.sha256(binary.read_bytes()).hexdigest()
results={'binary':str(binary),'before':before,'cases':[]}
with tempfile.TemporaryFile() as display, (root/'native-three-xvfb.log').open('wb') as log:
 xvfb=subprocess.Popen(['/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','-displayfd',str(display.fileno()),'-screen','0','1280x900x24','-nolisten','tcp','-ac'],pass_fds=(display.fileno(),),stdout=log,stderr=subprocess.STDOUT)
 try:
  number=''
  for attempt in range(100):
   display.seek(0); number=display.read().decode().strip()
   if number: break
   assert xvfb.poll() is None, 'Xvfb exited'
   time.sleep(.05)
  assert number, 'Xvfb startup watchdog'
  env=os.environ.copy();env['DISPLAY']=':'+number
  results['display']=env['DISPLAY']
  for name in ['native_source_inbox_patches_and_rearms_without_describing_the_owner','native_remote_results_wake_bounded_owner_turns_without_polling','native_final_producer_drop_drains_saturated_and_quiescent_status_lanes']:
   exact='native::remote_tests::'+name
   cmd=['dbus-run-session','--',str(binary),'--exact',exact,'--ignored','--nocapture','--test-threads=1']
   with (root/('native-three-'+name+'.log')).open('wb') as output:
    result=subprocess.run(cmd,env=env,stdout=output,stderr=subprocess.STDOUT,timeout=90)
   results['cases'].append({'name':exact,'command':cmd,'status':result.returncode})
   (root/'native-three-results.json').write_text(json.dumps(results,indent=2)+'\n')
   assert result.returncode==0, exact
 finally:
  xvfb.terminate()
  try:xvfb.wait(timeout=5)
  except subprocess.TimeoutExpired:xvfb.kill();xvfb.wait()
results['after']=hashlib.sha256(binary.read_bytes()).hexdigest()
assert before==results['after']
(root/'native-three-results.json').write_text(json.dumps(results,indent=2)+'\n')
print(json.dumps(results,indent=2))
