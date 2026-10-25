
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000073e010 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>>:
  73e010:	41 57                	push   %r15
  73e012:	41 56                	push   %r14
  73e014:	41 55                	push   %r13
  73e016:	41 54                	push   %r12
  73e018:	53                   	push   %rbx
  73e019:	48 83 ec 70          	sub    $0x70,%rsp
  73e01d:	48 89 fb             	mov    %rdi,%rbx
  73e020:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  73e027:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  73e02e:	00 00 
  73e030:	4d 01 fe             	add    %r15,%r14
  73e033:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  73e03a:	00 00 
  73e03c:	0f 84 90 00 00 00    	je     73e0d2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xc2>
  73e042:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  73e047:	0f 85 b5 00 00 00    	jne    73e102 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xf2>
  73e04d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  73e054:	ff 
  73e055:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  73e05c:	00 
  73e05d:	ff c0                	inc    %eax
  73e05f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  73e066:	00 
  73e067:	83 f8 40             	cmp    $0x40,%eax
  73e06a:	0f 83 9f 00 00 00    	jae    73e10f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xff>
  73e070:	89 c0                	mov    %eax,%eax
  73e072:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  73e076:	48 c1 e0 04          	shl    $0x4,%rax
  73e07a:	0f 57 c0             	xorps  %xmm0,%xmm0
  73e07d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  73e083:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  73e089:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  73e08f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  73e096:	00 
  73e097:	48 8b 02             	mov    (%rdx),%rax
  73e09a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  73e09e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  73e0a3:	48 89 c2             	mov    %rax,%rdx
  73e0a6:	e8 15 1d fd ff       	call   70fdc0 <<gpui::runtime::Win<unit_action_cost::Model>>::click>
  73e0ab:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  73e0b0:	75 78                	jne    73e12a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x11a>
  73e0b2:	48 8d 35 1f 72 39 00 	lea    0x39721f(%rip),%rsi        # ad52d8 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.6888997129353907345>
  73e0b9:	48 89 df             	mov    %rbx,%rdi
  73e0bc:	e8 0f 9c ff ff       	call   737cd0 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  73e0c1:	48 89 d8             	mov    %rbx,%rax
  73e0c4:	48 83 c4 70          	add    $0x70,%rsp
  73e0c8:	5b                   	pop    %rbx
  73e0c9:	41 5c                	pop    %r12
  73e0cb:	41 5d                	pop    %r13
  73e0cd:	41 5e                	pop    %r14
  73e0cf:	41 5f                	pop    %r15
  73e0d1:	c3                   	ret
  73e0d2:	49 89 d4             	mov    %rdx,%r12
  73e0d5:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  73e0da:	4c 89 f7             	mov    %r14,%rdi
  73e0dd:	49 89 f5             	mov    %rsi,%r13
  73e0e0:	31 f6                	xor    %esi,%esi
  73e0e2:	ff 15 50 45 3c 00    	call   *0x3c4550(%rip)        # b02638 <memset@GLIBC_2.2.5>
  73e0e8:	4c 89 e2             	mov    %r12,%rdx
  73e0eb:	4c 89 ee             	mov    %r13,%rsi
  73e0ee:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  73e0f5:	00 01 
  73e0f7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  73e0fc:	0f 84 4b ff ff ff    	je     73e04d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x3d>
  73e102:	48 8d 3d 17 6e 39 00 	lea    0x396e17(%rip),%rdi        # ad4f20 <anon.ff3cab21037877729def149be6643aa6.6.llvm.17844888298126827638>
  73e109:	ff 15 31 45 3c 00    	call   *0x3c4531(%rip)        # b02640 <_DYNAMIC+0x7f8>
  73e10f:	48 8d 3d 2e bd 92 ff 	lea    -0x6d42d2(%rip),%rdi        # 69e44 <anon.ff3cab21037877729def149be6643aa6.3.llvm.17844888298126827638>
  73e116:	48 8d 15 eb 6d 39 00 	lea    0x396deb(%rip),%rdx        # ad4f08 <anon.ff3cab21037877729def149be6643aa6.5.llvm.17844888298126827638>
  73e11d:	be 4b 00 00 00       	mov    $0x4b,%esi
  73e122:	ff 15 c0 3f 3c 00    	call   *0x3c3fc0(%rip)        # b020e8 <_DYNAMIC+0x2a0>
  73e128:	eb 4a                	jmp    73e174 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x164>
  73e12a:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  73e12f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  73e134:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  73e139:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  73e13e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  73e143:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  73e148:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  73e14d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  73e151:	48 8d 3d 90 c2 92 ff 	lea    -0x6d3d70(%rip),%rdi        # 6a3e8 <anon.d860f86f9d097745b4f11ed46a5e2623.5.llvm.6888997129353907345>
  73e158:	48 8d 0d b1 71 39 00 	lea    0x3971b1(%rip),%rcx        # ad5310 <anon.d860f86f9d097745b4f11ed46a5e2623.4.llvm.6888997129353907345>
  73e15f:	4c 8d 05 92 71 39 00 	lea    0x397192(%rip),%r8        # ad52f8 <anon.d860f86f9d097745b4f11ed46a5e2623.3.llvm.6888997129353907345>
  73e166:	48 89 e2             	mov    %rsp,%rdx
  73e169:	be 2b 00 00 00       	mov    $0x2b,%esi
  73e16e:	ff 15 44 40 3c 00    	call   *0x3c4044(%rip)        # b021b8 <_DYNAMIC+0x370>
  73e174:	0f 0b                	ud2
  73e176:	48 89 c3             	mov    %rax,%rbx
  73e179:	48 89 e7             	mov    %rsp,%rdi
  73e17c:	e8 6f 22 00 00       	call   7403f0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  73e181:	48 89 df             	mov    %rbx,%rdi
  73e184:	e8 e7 42 39 00       	call   ad2470 <_Unwind_Resume@plt>
  73e189:	64 49 ff 07          	incq   %fs:(%r15)
  73e18d:	48 89 c7             	mov    %rax,%rdi
  73e190:	e8 db 42 39 00       	call   ad2470 <_Unwind_Resume@plt>
