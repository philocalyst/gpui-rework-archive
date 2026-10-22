from pathlib import Path
import ctypes,os,signal,fcntl,struct,json,hashlib,sys
lib=ctypes.CDLL(None,use_errno=True)
lib.ptrace.restype=ctypes.c_long
class Regs(ctypes.Structure):
 _fields_=[(n,ctypes.c_ulonglong) for n in 'r15 r14 r13 r12 rbp rbx r11 r10 r9 r8 rax rcx rdx rsi rdi orig_rax rip cs eflags rsp ss fs_base gs_base ds es fs gs'.split()]
class Attr(ctypes.Structure):
 _fields_=[('type',ctypes.c_uint32),('size',ctypes.c_uint32),('config',ctypes.c_uint64),('sample_period',ctypes.c_uint64),('sample_type',ctypes.c_uint64),('read_format',ctypes.c_uint64),('flags',ctypes.c_uint64),('wakeup_events',ctypes.c_uint32),('bp_type',ctypes.c_uint32),('config1',ctypes.c_uint64),('config2',ctypes.c_uint64)]
class Iovec(ctypes.Structure):
 _fields_=[('base',ctypes.c_void_p),('length',ctypes.c_size_t)]
def ptrace(request,pid,addr=0,data=0):
 r=lib.ptrace(request,pid,ctypes.c_void_p(addr),data)
 if r==-1:raise OSError(ctypes.get_errno(),os.strerror(ctypes.get_errno()))
 return r
def read_child(pid,addr,length):
 b=ctypes.create_string_buffer(length);local=Iovec(ctypes.cast(b,ctypes.c_void_p),length);remote=Iovec(addr,length)
 r=lib.process_vm_readv(pid,ctypes.byref(local),1,ctypes.byref(remote),1,0)
 if r<0:raise OSError(ctypes.get_errno(),os.strerror(ctypes.get_errno()))
 return b.raw[:r].decode(errors='replace')
def trace(binary):
 before=hashlib.sha256(Path(binary).read_bytes()).hexdigest();rd,wr=os.pipe();child=os.fork()
 if child==0:
  try:
   os.close(rd);os.dup2(wr,1);os.close(wr);ptrace(0,0);os.kill(os.getpid(),signal.SIGSTOP);os.execv(binary,[binary])
  except BaseException:os._exit(127)
 os.close(wr);pid,status=os.waitpid(child,0);assert os.WIFSTOPPED(status),(pid,status)
 ptrace(0x4200,child,0,1)
 descriptors=[];events=['cycles','instructions','branches','branch_misses']
 try:
  for config in [0,1,4,5]:
   a=Attr();a.type=0;a.size=ctypes.sizeof(a);a.config=config;a.read_format=3;a.flags=(1 if not descriptors else 0)|(1<<5)|(1<<6)
   fd=lib.syscall(298,ctypes.byref(a),child,-1,descriptors[0] if descriptors else -1,0)
   if fd<0:raise OSError(ctypes.get_errno(),os.strerror(ctypes.get_errno()))
   descriptors.append(fd)
  leader=descriptors[0];inside=False;active=False;enable_after_write=False;done=False;records=[];write_records=[]
  ptrace(24,child)
  while True:
   pid,status=os.waitpid(child,0)
   if os.WIFEXITED(status):assert os.WEXITSTATUS(status)==0,status;break
   if os.WIFSIGNALED(status):raise RuntimeError(('child signaled',status))
   sig=os.WSTOPSIG(status)
   if sig==signal.SIGTRAP|0x80:
    regs=Regs();ptrace(12,child,0,ctypes.byref(regs))
    if not inside and regs.orig_rax==1 and regs.rdi==1:
     payload=read_child(child,regs.rsi,min(regs.rdx,65536));write_records.append(payload)
     fields=payload.strip().split(',')
     is_csv=len(fields)==14 and fields[0] in ['flat','opaque_overlap','alpha_overlap','sheared','labels','boundary_dense'] and fields[1] in ['true','false']
     if is_csv:
      assert active,('CSV phase not enabled',payload)
      fcntl.ioctl(leader,0x2401,1);active=False
      counts={}
      for event,fd in zip(events,descriptors):
       value,enabled,running=struct.unpack('QQQ',os.read(fd,24));assert enabled==running,(event,enabled,running)
       counts[event]={'value':value,'time_enabled_ns':enabled,'time_running_ns':running}
      records.append({'case':fields[0],'proofs':fields[1],'counts':counts,'csv':payload.strip()})
      done=fields[0]=='boundary_dense' and fields[1]=='true';enable_after_write=not done
     elif 'scene,proofs,median_frame_us,' in payload:
      enable_after_write=True
    elif inside and regs.orig_rax==1 and regs.rdi==1 and enable_after_write:
     fcntl.ioctl(leader,0x2403,1);fcntl.ioctl(leader,0x2400,1);active=True;enable_after_write=False
    inside=not inside;ptrace(24,child)
   else:ptrace(24,child,0,0 if sig in [signal.SIGSTOP,signal.SIGTRAP] else sig)
  stdout=os.read(rd,65536).decode();os.close(rd);after=hashlib.sha256(Path(binary).read_bytes()).hexdigest();assert before==after
  return {'binary':binary,'sha256':before,'records':records,'stdout':stdout,'write_payloads':write_records,'mechanism':'PTRACE_SYSCALL existing stdout write boundaries; user-only counters on child, no source changes. Each CSV phase includes its original warm frame plus3 timed scene rebuild/render frames and formatting, not just raster.'}
 finally:
  for fd in descriptors:os.close(fd)
if __name__=='__main__':
 result=trace(sys.argv[1]);Path(sys.argv[2]).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'complete':True,'phases':len(result['records']),'sha256':result['sha256']}))
