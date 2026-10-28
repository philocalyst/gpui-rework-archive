from pathlib import Path
import argparse
import hashlib
import json
import os
import re
import signal
import subprocess

parser=argparse.ArgumentParser()
parser.add_argument('--source',required=True,type=Path)
parser.add_argument('--pin',required=True)
parser.add_argument('--out',required=True,type=Path)
parser.add_argument('--timeout',required=True,type=int)
parser.add_argument('command',nargs=argparse.REMAINDER)
args=parser.parse_args()
command=args.command[1:] if args.command[:1]==['--'] else args.command
assert command and args.timeout>0
git=['git','-c',f'safe.directory={args.source}','-C',str(args.source)]
assert subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()==args.pin
assert not subprocess.check_output(git+['status','--porcelain'],text=True).strip()
files=[args.source/name for name in subprocess.check_output(git+['ls-files'],text=True).splitlines() if (args.source/name).is_file()]
guard=lambda:{str(path.relative_to(args.source)):hashlib.sha256(path.read_bytes()).hexdigest() for path in files}
before=guard()
args.out.mkdir(parents=True,exist_ok=False)
(args.out/'before.json').write_text(json.dumps(before,indent=2)+'\n')
(args.out/'command.json').write_text(json.dumps({'source':args.pin,'cwd':str(args.source),'argv':command,'timeout_seconds':args.timeout,'environment':{key:os.environ.get(key) for key in ['RUSTC','RUSTDOC','RUSTC_BOOTSTRAP','RUSTFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_TARGET_DIR','CARGO_BUILD_JOBS','MIRI','MIRI_SYSROOT','MIRIFLAGS','RUST_SRC_PATH']}},indent=2)+'\n')
(args.out/'rustc.txt').write_text(subprocess.check_output(['rustc','-Vv'],text=True))
with (args.out/'stdout.log').open('w') as stdout,(args.out/'stderr.log').open('w') as stderr:
    child=subprocess.Popen(command,cwd=args.source,stdout=stdout,stderr=stderr,start_new_session=True)
    try:
        status=child.wait(timeout=args.timeout)
    except subprocess.TimeoutExpired:
        os.killpg(child.pid,signal.SIGTERM)
        try:child.wait(timeout=5)
        except subprocess.TimeoutExpired:
            os.killpg(child.pid,signal.SIGKILL)
            child.wait()
        status=124
(args.out/'exit').write_text(str(status)+'\n')
after=guard()
(args.out/'after.json').write_text(json.dumps(after,indent=2)+'\n')
assert before==after
assert subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()==args.pin
assert not subprocess.check_output(git+['status','--porcelain'],text=True).strip()
rows=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;', (args.out/'stdout.log').read_text())
report={'source':args.pin,'exit':status,'guards':len(before),'guards_match':True,'passed':sum(int(row[0]) for row in rows),'failed':sum(int(row[1]) for row in rows),'ignored':sum(int(row[2]) for row in rows),'harnesses':len(rows),'scope':'Functional/source-identity gate; no timing inference.'}
(args.out/'result.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report),flush=True)
raise SystemExit(status)
