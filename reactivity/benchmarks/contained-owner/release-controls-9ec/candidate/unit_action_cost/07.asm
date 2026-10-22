
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000073dfe0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>>:
  73dfe0:	41 57                	push   %r15
  73dfe2:	41 56                	push   %r14
  73dfe4:	41 55                	push   %r13
  73dfe6:	41 54                	push   %r12
  73dfe8:	53                   	push   %rbx
  73dfe9:	48 83 ec 70          	sub    $0x70,%rsp
  73dfed:	48 89 fb             	mov    %rdi,%rbx
  73dff0:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  73dff7:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  73dffe:	00 00 
  73e000:	4d 01 fe             	add    %r15,%r14
  73e003:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  73e00a:	00 00 
  73e00c:	0f 84 90 00 00 00    	je     73e0a2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xc2>
  73e012:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  73e017:	0f 85 b5 00 00 00    	jne    73e0d2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xf2>
  73e01d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  73e024:	ff 
  73e025:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  73e02c:	00 
  73e02d:	ff c0                	inc    %eax
  73e02f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  73e036:	00 
  73e037:	83 f8 40             	cmp    $0x40,%eax
  73e03a:	0f 83 9f 00 00 00    	jae    73e0df <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xff>
  73e040:	89 c0                	mov    %eax,%eax
  73e042:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  73e046:	48 c1 e0 04          	shl    $0x4,%rax
  73e04a:	0f 57 c0             	xorps  %xmm0,%xmm0
  73e04d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  73e053:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  73e059:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  73e05f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  73e066:	00 
  73e067:	48 8b 02             	mov    (%rdx),%rax
  73e06a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  73e06e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  73e073:	48 89 c2             	mov    %rax,%rdx
  73e076:	e8 15 1d fd ff       	call   70fd90 <<gpui::runtime::Win<unit_action_cost::Model>>::click>
  73e07b:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  73e080:	75 78                	jne    73e0fa <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x11a>
  73e082:	48 8d 35 1f 72 39 00 	lea    0x39721f(%rip),%rsi        # ad52a8 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.15216714876769819238>
  73e089:	48 89 df             	mov    %rbx,%rdi
  73e08c:	e8 0f 9c ff ff       	call   737ca0 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  73e091:	48 89 d8             	mov    %rbx,%rax
  73e094:	48 83 c4 70          	add    $0x70,%rsp
  73e098:	5b                   	pop    %rbx
  73e099:	41 5c                	pop    %r12
  73e09b:	41 5d                	pop    %r13
  73e09d:	41 5e                	pop    %r14
  73e09f:	41 5f                	pop    %r15
  73e0a1:	c3                   	ret
  73e0a2:	49 89 d4             	mov    %rdx,%r12
  73e0a5:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  73e0aa:	4c 89 f7             	mov    %r14,%rdi
  73e0ad:	49 89 f5             	mov    %rsi,%r13
  73e0b0:	31 f6                	xor    %esi,%esi
  73e0b2:	ff 15 50 45 3c 00    	call   *0x3c4550(%rip)        # b02608 <memset@GLIBC_2.2.5>
  73e0b8:	4c 89 e2             	mov    %r12,%rdx
  73e0bb:	4c 89 ee             	mov    %r13,%rsi
  73e0be:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  73e0c5:	00 01 
  73e0c7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  73e0cc:	0f 84 4b ff ff ff    	je     73e01d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x3d>
  73e0d2:	48 8d 3d 17 6e 39 00 	lea    0x396e17(%rip),%rdi        # ad4ef0 <anon.ff3cab21037877729def149be6643aa6.6.llvm.17844888298126827638>
  73e0d9:	ff 15 31 45 3c 00    	call   *0x3c4531(%rip)        # b02610 <_DYNAMIC+0x7f8>
  73e0df:	48 8d 3d 5e bd 92 ff 	lea    -0x6d42a2(%rip),%rdi        # 69e44 <anon.ff3cab21037877729def149be6643aa6.3.llvm.17844888298126827638>
  73e0e6:	48 8d 15 eb 6d 39 00 	lea    0x396deb(%rip),%rdx        # ad4ed8 <anon.ff3cab21037877729def149be6643aa6.5.llvm.17844888298126827638>
  73e0ed:	be 4b 00 00 00       	mov    $0x4b,%esi
  73e0f2:	ff 15 c0 3f 3c 00    	call   *0x3c3fc0(%rip)        # b020b8 <_DYNAMIC+0x2a0>
  73e0f8:	eb 4a                	jmp    73e144 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x164>
  73e0fa:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  73e0ff:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  73e104:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  73e109:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  73e10e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  73e113:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  73e118:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  73e11d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  73e121:	48 8d 3d c0 c2 92 ff 	lea    -0x6d3d40(%rip),%rdi        # 6a3e8 <anon.d860f86f9d097745b4f11ed46a5e2623.5.llvm.15216714876769819238>
  73e128:	48 8d 0d b1 71 39 00 	lea    0x3971b1(%rip),%rcx        # ad52e0 <anon.d860f86f9d097745b4f11ed46a5e2623.4.llvm.15216714876769819238>
  73e12f:	4c 8d 05 92 71 39 00 	lea    0x397192(%rip),%r8        # ad52c8 <anon.d860f86f9d097745b4f11ed46a5e2623.3.llvm.15216714876769819238>
  73e136:	48 89 e2             	mov    %rsp,%rdx
  73e139:	be 2b 00 00 00       	mov    $0x2b,%esi
  73e13e:	ff 15 44 40 3c 00    	call   *0x3c4044(%rip)        # b02188 <_DYNAMIC+0x370>
  73e144:	0f 0b                	ud2
  73e146:	48 89 c3             	mov    %rax,%rbx
  73e149:	48 89 e7             	mov    %rsp,%rdi
  73e14c:	e8 6f 22 00 00       	call   7403c0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  73e151:	48 89 df             	mov    %rbx,%rdi
  73e154:	e8 e7 42 39 00       	call   ad2440 <_Unwind_Resume@plt>
  73e159:	64 49 ff 07          	incq   %fs:(%r15)
  73e15d:	48 89 c7             	mov    %rax,%rdi
  73e160:	e8 db 42 39 00       	call   ad2440 <_Unwind_Resume@plt>
