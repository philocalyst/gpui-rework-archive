from pathlib import Path
import subprocess,time,json,hashlib
root=Path('/root/gpui-hummingbird-library-intent-sol');out=Path('/tmp/gpui-intent-transport-native-final')
binary=Path('/tmp/gpui-hummingbird-audio-target/debug/deps/gpui-e5c9359d761e98c0')
files=subprocess.check_output(['git','ls-files','reactivity/crates/gpui/src'],cwd=root,text=True).splitlines()
def manifest():return {'commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip(),'binary_sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'sources':{p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in files}}
before=manifest();(out/'before.json').write_text(json.dumps(before,indent=2)+'\n')
assert not Path('/tmp/.X11-unix/X248').exists()
log=(out/'xvfb.log').open('w');x=subprocess.Popen(['/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb',':248','-screen','0','1280x900x24','-nolisten','tcp','-noreset'],stdout=log,stderr=subprocess.STDOUT)
results={}
try:
 for _ in range(100):
  if Path('/tmp/.X11-unix/X248').exists():break
  assert x.poll() is None;time.sleep(.02)
 else:raise RuntimeError('no Xvfb socket')
 for label,test in [('status','native::remote_tests::native_final_producer_drop_drains_saturated_and_quiescent_status_lanes'),('ordinary','native::remote_tests::native_remote_results_wake_bounded_owner_turns_without_polling'),('question','native::question_tests::native_question_result_and_credit_wake_without_unrelated_input'),('future','native::question_tests::native_future_cancellation_and_result_wake_without_unrelated_input')]:
  command=['bash','-c',f'source /tmp/gpui-hummingbird-audio-env.sh\nexport DISPLAY=:248\nexec dbus-run-session -- {binary} {test} --exact --ignored --nocapture --test-threads=1']
  (out/(label+'.command.json')).write_text(json.dumps(command)+'\n')
  with (out/(label+'.log')).open('w') as log:
   try:results[label]=subprocess.run(command,cwd=root,stdout=log,stderr=subprocess.STDOUT,timeout=90).returncode
   except subprocess.TimeoutExpired:results[label]='timeout'
  print(label,results[label],flush=True)
finally:
 x.terminate()
 try:x.wait(timeout=3)
 except subprocess.TimeoutExpired:x.kill();x.wait()
 log.close()
 after=manifest();(out/'after.json').write_text(json.dumps(after,indent=2)+'\n');results['source_binary_unchanged']=before==after
 (out/'results.json').write_text(json.dumps(results,indent=2)+'\n')
print('DONE',flush=True)
