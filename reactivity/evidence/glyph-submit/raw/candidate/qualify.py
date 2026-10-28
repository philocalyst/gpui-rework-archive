from pathlib import Path
import subprocess,json
r=Path(__file__).parent
commands=[
 ['preserve_gate.py',str(r/'full-native')],['preserve_unit.py',str(r/'full-native')],
 ['native_checks.py'],['minimal_gate.py','minimal-library','native-units'],
 ['preserve_gate.py',str(r/'minimal-library')],['preserve_unit.py',str(r/'minimal-library')],
 ['minimal_native_checks.py'],['cost_fixture_gate.py','cost-fixture'],
 ['freeze_matrix.py'],['shader_receipt.py'],['matrix_runs.py','qualification'],['matrix_runs.py','allocations'],
]
for i,cmd in enumerate(commands):
 cmd=['python3',str(r/cmd[0]),*cmd[1:]]
 print('START',i,cmd[1:],flush=True)
 code=subprocess.run(cmd).returncode
 (r/('qualification-stage-'+str(i)+'.json')).write_text(json.dumps(dict(command=cmd,exit=code),indent=2))
 if code:raise SystemExit(code)
print('ALL QUALIFICATION STAGES COMPLETED',flush=True)
