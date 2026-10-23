from pathlib import Path
import os,subprocess,time
root=Path('/root/gpui-ce3/reactivity')
xlog=Path('/tmp/gpui-close-root-xvfb.log').open('w')
xvfb=subprocess.Popen(['/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb',':244','-screen','0','1280x900x24','-nolisten','tcp','-noreset'],stdout=xlog,stderr=subprocess.STDOUT)
try:
 for _ in range(100):
  if Path('/tmp/.X11-unix/X244').exists():break
  if xvfb.poll() is not None:raise RuntimeError('owned Xvfb failed')
  time.sleep(.02)
 cmd="source /tmp/gpui-native-env.sh\nunset RUSTFLAGS CARGO_ENCODED_RUSTFLAGS\nexport DISPLAY=:244 CARGO_TARGET_DIR=/tmp/gpui-todo-comparison-target CARGO_BUILD_JOBS=1\nexec dbus-run-session -- cargo test --locked -p gpui --features x11 --lib automatic_target_rejects_before_renderer_and_close_unmaps_a_worker_retained_window -- --ignored --nocapture --test-threads=1"
 with Path('/tmp/gpui-close-root-candidate.log').open('w') as out:
  result=subprocess.run(['bash','-c',cmd],cwd=root,stdout=out,stderr=subprocess.STDOUT)
 print('CANDIDATE_EXIT',result.returncode)
 print('\n'.join(Path('/tmp/gpui-close-root-candidate.log').read_text().splitlines()[-24:]))
finally:
 xvfb.terminate()
 try:xvfb.wait(timeout=3)
 except subprocess.TimeoutExpired:xvfb.kill();xvfb.wait()
 xlog.close()
