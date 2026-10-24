from pathlib import Path
import json,subprocess
root=Path('/tmp/gpui-delivery-isolation-cost-sol')
git=['git','-c','safe.directory='+str(root),'-C',str(root)]
assert not subprocess.check_output(git+['status','--porcelain'],text=True)
assert subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()=='22cd93e21daacdf140da62607efe1f61bb96725a'
pin='22541342e3c10a962bc61f76088c7bfdb1b21bbd'
paths=subprocess.check_output(git+['diff','--name-only','HEAD',pin,'--','reactivity/crates','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/vendor','reactivity/ports/hummingbird/Cargo.lock'],text=True).splitlines()
paths=[p for p in paths if p not in ['reactivity/crates/gpui/examples/ordinary_control.rs','reactivity/crates/gpui/examples/field_control.rs']]
subprocess.run(git+['checkout',pin,'--',*paths],check=True)
subprocess.run(git+['commit','-m','Overlay exact isolated-source admission kernel on matched ordinary and coarse consumers'],check=True)
Path('/tmp/gpui-delivery-isolation-captures/cost-b-overlay.json').write_text(json.dumps({'producer':pin,'paths':paths,'note':'Cost consumers remain byte-identical to baseline; all other differing library inputs copied exactly'},indent=2)+'\n')
