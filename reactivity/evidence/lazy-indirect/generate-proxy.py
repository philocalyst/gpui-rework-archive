from pathlib import Path
import re
base=Path(__file__).resolve().parents[2]
s=(base/'vendor/wgpu-hal/src/dynamic/device.rs').read_text(); trait=s[s.index('pub trait DynDevice: DynResource {')+len('pub trait DynDevice: DynResource {'):s.index('\nimpl<D: Device')].rsplit('}',1)[0]
imports=s[:s.index('pub trait DynDevice: DynResource {')].replace('use crate::{','use hal::{').replace('use super::{','use hal::{').replace('    ComputePipelineDescriptor, Device, DeviceError, FenceValue,','    ComputePipelineDescriptor, DeviceError, FenceValue,').replace('Api, BindGroupDescriptor','BindGroupDescriptor').replace('DynResourceExt as _,','')
imports=imports.replace('borrow::ToOwned as _, ', '').replace('RayObjectIntersectionState,', '').replace('DynResource, ', '')
out=[imports,'impl hal::DynDevice for Probe {']
for m in re.finditer(r'(unsafe )?fn (\w+)\s*\(',trait):
 start=m.start(); pos=m.end(); depth=1
 while depth:
  if trait[pos]=='(':depth+=1
  if trait[pos]==')':depth-=1
  pos+=1
 params=trait[m.end():pos-1];end=pos
 brackets=0
 while brackets or trait[end] not in ';{':
  if trait[end]=='[': brackets+=1
  if trait[end]==']': brackets-=1
  end+=1
 sig=trait[start:end];name=m[2]
 # parse top-level commas with nested generics
 args=[];lev=0;last=0
 for i,c in enumerate(params+','):
  if c in '<([':lev+=1
  if c in '>)]':lev-=1
  if c==',' and lev==0:
   arg=params[last:i].strip();last=i+1
   if arg and arg!='&self':args.append(arg.split(':',1)[0].strip())
 call=f'self.inner.{name}('+', '.join(args)+')';call=('unsafe { '+call+' }') if m[1] else call
 if name.startswith('create_') and 'Result<Box<' in sig:
  # Fail with Device error via From impls supported by HAL errors? all variants Device except PipelineCache uses Device.
  err='DeviceError::Lost' if re.search(r'Box<dyn \w+>, DeviceError>',sig) else ('PipelineCacheError::Device(DeviceError::Lost)' if 'PipelineCacheError' in sig else 'ShaderError::Device(DeviceError::Lost)' if 'ShaderError' in sig else 'PipelineError::Device(DeviceError::Lost)')
  err = err.replace('DeviceError::Lost', 'self.error()')
  out.append(sig+' {\n'+('        self.events.layout_flags.lock().unwrap().push(desc.flags);\n' if name=='create_pipeline_layout' else '')+f'        self.before("{name}", || {err})?;\n        let value = {call}?;\n        self.record_handle("{name}", handle(value.as_ref()));\n        Ok(value)\n    }}')
 elif name.startswith('destroy_'):
  out.append(sig+' {\n'+f'        self.record_handle("{name}", handle({args[0]}.as_ref()));\n        {call}\n    }}')
 elif name=='add_raw_buffer':
  out.append(sig+' {\n        self.record_handle("create_buffer", handle(buffer));\n        '+call+'\n    }')
 elif name=='create_pipeline_layout':raise Exception('unexpected')
 else:out.append(sig+' { '+call+' }')
out.append('}')
(base/'evidence/lazy-indirect/proxy.rs').write_text('\n'.join(out))

import subprocess
subprocess.run(["rustfmt", "--edition", "2021", str(base / "evidence/lazy-indirect/proxy.rs")], check=True)
