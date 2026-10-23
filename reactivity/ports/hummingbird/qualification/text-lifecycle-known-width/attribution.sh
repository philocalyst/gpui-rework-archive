#!/usr/bin/env bash
source /tmp/gpui-hummingbird-browser-allocation-env.sh
capture_dir=/tmp/gpui-hummingbird-browser-allocation-evidence/known-qualification
probe_dir=/tmp/gpui-hummingbird-browser-allocation-evidence/probe
python=/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3
destination="$capture_dir/known-attribution"
if [ -e "$destination" ]; then exit 90; fi
mkdir "$destination"
"$python" "$capture_dir/guard.py" verify > "$destination/source-before.log" 2>&1 || exit $?
printf '%s\n' "cargo build --offline --locked --manifest-path $probe_dir/Cargo.toml --message-format=json" > "$destination/build.command"
cargo build --offline --locked --manifest-path "$probe_dir/Cargo.toml" --message-format=json > "$destination/build.jsonl" 2> "$destination/build.log"
gate_exit=$?
printf '%s\n' "$gate_exit" > "$destination/build.exit"
if [ "$gate_exit" -ne 0 ]; then exit "$gate_exit"; fi
"$python" - "$destination" <<'PY'
import pathlib,json,sys,shutil,hashlib
out=pathlib.Path(sys.argv[1])
rows=[json.loads(line) for line in (out/'build.jsonl').read_text().splitlines() if line.startswith('{')]
rows=[row for row in rows if row.get('executable') and row['target']['name']=='browser-allocation-sites']
assert len(rows)==1
source=pathlib.Path(rows[0]['executable']);binary=out/'browser-allocation-sites'
shutil.copy2(source,binary);binary.chmod(0o555)
(out/'binary.json').write_text(json.dumps({'sha256':hashlib.file_digest(binary.open('rb'),'sha256').hexdigest(),'artifact':rows[0]},indent=2)+'\n')
PY
printf '%s\n' "timeout --signal=TERM --kill-after=5s 120s $destination/browser-allocation-sites $destination/raw" > "$destination/runtime.command"
timeout --signal=TERM --kill-after=5s 120s "$destination/browser-allocation-sites" "$destination/raw" > "$destination/runtime.log" 2>&1
gate_exit=$?
printf '%s\n' "$gate_exit" > "$destination/runtime.exit"
"$python" "$capture_dir/guard.py" verify > "$destination/source-after.log" 2>&1
if [ "$gate_exit" -ne 0 ]; then exit "$gate_exit"; fi
cp /tmp/gpui-hummingbird-browser-allocation-evidence/analyze.py "$destination/analyze.py"
"$python" "$destination/analyze.py" "$destination/browser-allocation-sites" > "$destination/analysis.log" 2>&1
gate_exit=$?
printf '%s\n' "$gate_exit" > "$destination/analysis.exit"
exit "$gate_exit"
