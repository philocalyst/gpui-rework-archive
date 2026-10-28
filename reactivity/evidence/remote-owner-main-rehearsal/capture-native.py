from pathlib import Path
import hashlib,json,os,re,select,shutil,signal,subprocess,sys
root=Path('/root/gpui-remote-owner-main-rehearsal')
out=Path('/tmp/gpui-remote-owner-main-qualification/native-capture')
out.mkdir(exist_ok=False)
log=(out/'services.log').open('w')
match=re.search(r'Running unittests .*?\(([^\n)]+/gpui-[0-9a-f]+)\)',(out.parent/'native.log').read_text())
assert match,'native library test executable was not recorded'
binary=out/'candidate-tests';shutil.copy2(match[1],binary);binary.chmod(0o555)
paths=subprocess.check_output(['git','ls-files','reactivity/crates/gpui/src','reactivity/crates/gpui/tests','reactivity/Cargo.lock','.cargo/config.toml'],cwd=root,text=True).splitlines()
def manifest():
 return {'source_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip(),'sources':{p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in paths},'binary_sha256':hashlib.sha256(binary.read_bytes()).hexdigest()}
before=manifest();(out/'before.json').write_text(json.dumps(before,indent=2)+'\n')
read,write=os.pipe();server=subprocess.Popen(['/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','-displayfd',str(write),'-screen','0','1280x900x24','-nolisten','tcp','-noreset'],pass_fds=(write,),stdout=log,stderr=subprocess.STDOUT)
os.close(write);results={}
def run(label,args,timeout,environment):
 (out/(label+'.command.json')).write_text(json.dumps({'argv':args,'display':environment['DISPLAY'],'timeout_seconds':timeout,'scope':'functional integration; watchdogs detect failure, no timing comparison'},indent=2)+'\n')
 with (out/(label+'.log')).open('w') as stream:
  process=subprocess.Popen(args,cwd=root,env=environment,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
  try:result=process.wait(timeout=timeout)
  except subprocess.TimeoutExpired:
   result='timeout';os.killpg(process.pid,signal.SIGTERM)
   try:process.wait(timeout=5)
   except subprocess.TimeoutExpired:os.killpg(process.pid,signal.SIGKILL);process.wait()
 results[label]=result;print(label,result,flush=True)
try:
 assert select.select([read],[],[],20)[0],'Xvfb readiness watchdog'
 number=os.read(read,32).decode().strip();assert number.isdecimal()
 environment=dict(os.environ,DISPLAY=':'+number,GSETTINGS_BACKEND='memory')
 tests=[('terminal','native::remote_tests::native_final_producer_drop_drains_saturated_and_quiescent_status_lanes'),('ordinary','native::remote_tests::native_remote_results_wake_bounded_owner_turns_without_polling'),('question','native::question_tests::native_question_result_and_credit_wake_without_unrelated_input'),('future','native::question_tests::native_future_cancellation_and_result_wake_without_unrelated_input'),('action-poll','native::accessibility::poll_tests::native_action_poll_stops_on_fatal_continues_after_repair_and_rearms_stale_budget')]
 for label,test in tests:
  run(label,['dbus-run-session','--',str(binary),test,'--exact','--ignored','--nocapture','--test-threads=1'],90,environment)
 # The actual Registry client has its own session and real bus launcher.
 registry_source=(out.parent/'root-registry-original.py').read_text()
 registry_source=registry_source.replace("cap=Path('/tmp/gpui-a11y-action-poll-captures/native-registry');root=Path('/tmp/gpui-a11y-action-poll-root')",f"cap=Path({str(out/'registry')!r});root=Path({str(root)!r})")
 registry_source=registry_source.replace("binary=Path('/tmp/gpui-a11y-action-poll-target/debug/deps/gpui-e5c9359d761e98c0')",f"binary=Path({str(binary)!r})")
 script=out/'registry.py';script.write_text(registry_source)
 run('registry',[sys.executable,str(script)],110,environment)
finally:
 os.close(read);server.terminate()
 try:server.wait(timeout=5)
 except subprocess.TimeoutExpired:server.kill();server.wait()
 log.close();after=manifest();(out/'after.json').write_text(json.dumps(after,indent=2)+'\n')
 results['source_binary_unchanged']=before==after
 (out/'results.json').write_text(json.dumps(results,indent=2)+'\n')
 print('DONE: all owned test/Xvfb processes exited',flush=True)
assert all(value==0 for key,value in results.items() if key!='source_binary_unchanged') and results['source_binary_unchanged']
