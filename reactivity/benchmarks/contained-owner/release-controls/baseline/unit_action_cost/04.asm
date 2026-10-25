
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000073d400 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>>:
  73d400:	41 57                	push   %r15
  73d402:	41 56                	push   %r14
  73d404:	41 55                	push   %r13
  73d406:	41 54                	push   %r12
  73d408:	53                   	push   %rbx
  73d409:	48 83 ec 70          	sub    $0x70,%rsp
  73d40d:	48 89 fb             	mov    %rdi,%rbx
  73d410:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  73d417:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  73d41e:	00 00 
  73d420:	4d 01 fe             	add    %r15,%r14
  73d423:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  73d42a:	00 00 
  73d42c:	0f 84 90 00 00 00    	je     73d4c2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xc2>
  73d432:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  73d437:	0f 85 b5 00 00 00    	jne    73d4f2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xf2>
  73d43d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  73d444:	ff 
  73d445:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  73d44c:	00 
  73d44d:	ff c0                	inc    %eax
  73d44f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  73d456:	00 
  73d457:	83 f8 40             	cmp    $0x40,%eax
  73d45a:	0f 83 9f 00 00 00    	jae    73d4ff <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xff>
  73d460:	89 c0                	mov    %eax,%eax
  73d462:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  73d466:	48 c1 e0 04          	shl    $0x4,%rax
  73d46a:	0f 57 c0             	xorps  %xmm0,%xmm0
  73d46d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  73d473:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  73d479:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  73d47f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  73d486:	00 
  73d487:	48 8b 02             	mov    (%rdx),%rax
  73d48a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  73d48e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  73d493:	48 89 c2             	mov    %rax,%rdx
  73d496:	e8 85 1d fd ff       	call   70f220 <<gpui::runtime::Win<unit_action_cost::Model>>::click>
  73d49b:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  73d4a0:	75 78                	jne    73d51a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x11a>
  73d4a2:	48 8d 35 17 71 39 00 	lea    0x397117(%rip),%rsi        # ad45c0 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.13997896436471750083>
  73d4a9:	48 89 df             	mov    %rbx,%rdi
  73d4ac:	e8 0f 9c ff ff       	call   7370c0 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  73d4b1:	48 89 d8             	mov    %rbx,%rax
  73d4b4:	48 83 c4 70          	add    $0x70,%rsp
  73d4b8:	5b                   	pop    %rbx
  73d4b9:	41 5c                	pop    %r12
  73d4bb:	41 5d                	pop    %r13
  73d4bd:	41 5e                	pop    %r14
  73d4bf:	41 5f                	pop    %r15
  73d4c1:	c3                   	ret
  73d4c2:	49 89 d4             	mov    %rdx,%r12
  73d4c5:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  73d4ca:	4c 89 f7             	mov    %r14,%rdi
  73d4cd:	49 89 f5             	mov    %rsi,%r13
  73d4d0:	31 f6                	xor    %esi,%esi
  73d4d2:	ff 15 f8 43 3c 00    	call   *0x3c43f8(%rip)        # b018d0 <memset@GLIBC_2.2.5>
  73d4d8:	4c 89 e2             	mov    %r12,%rdx
  73d4db:	4c 89 ee             	mov    %r13,%rsi
  73d4de:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  73d4e5:	00 01 
  73d4e7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  73d4ec:	0f 84 4b ff ff ff    	je     73d43d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x3d>
  73d4f2:	48 8d 3d 1f 6d 39 00 	lea    0x396d1f(%rip),%rdi        # ad4218 <anon.ff3cab21037877729def149be6643aa6.6.llvm.17844888298126827638>
  73d4f9:	ff 15 d9 43 3c 00    	call   *0x3c43d9(%rip)        # b018d8 <_DYNAMIC+0x7e8>
  73d4ff:	48 8d 3d e6 c6 92 ff 	lea    -0x6d391a(%rip),%rdi        # 69bec <anon.ff3cab21037877729def149be6643aa6.3.llvm.17844888298126827638>
  73d506:	48 8d 15 f3 6c 39 00 	lea    0x396cf3(%rip),%rdx        # ad4200 <anon.ff3cab21037877729def149be6643aa6.5.llvm.17844888298126827638>
  73d50d:	be 4b 00 00 00       	mov    $0x4b,%esi
  73d512:	ff 15 78 3e 3c 00    	call   *0x3c3e78(%rip)        # b01390 <_DYNAMIC+0x2a0>
  73d518:	eb 4a                	jmp    73d564 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x164>
  73d51a:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  73d51f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  73d524:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  73d529:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  73d52e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  73d533:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  73d538:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  73d53d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  73d541:	48 8d 3d 48 cc 92 ff 	lea    -0x6d33b8(%rip),%rdi        # 6a190 <anon.d860f86f9d097745b4f11ed46a5e2623.5.llvm.13997896436471750083>
  73d548:	48 8d 0d a9 70 39 00 	lea    0x3970a9(%rip),%rcx        # ad45f8 <anon.d860f86f9d097745b4f11ed46a5e2623.4.llvm.13997896436471750083>
  73d54f:	4c 8d 05 8a 70 39 00 	lea    0x39708a(%rip),%r8        # ad45e0 <anon.d860f86f9d097745b4f11ed46a5e2623.3.llvm.13997896436471750083>
  73d556:	48 89 e2             	mov    %rsp,%rdx
  73d559:	be 2b 00 00 00       	mov    $0x2b,%esi
  73d55e:	ff 15 fc 3e 3c 00    	call   *0x3c3efc(%rip)        # b01460 <_DYNAMIC+0x370>
  73d564:	0f 0b                	ud2
  73d566:	48 89 c3             	mov    %rax,%rbx
  73d569:	48 89 e7             	mov    %rsp,%rdi
  73d56c:	e8 6f 22 00 00       	call   73f7e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  73d571:	48 89 df             	mov    %rbx,%rdi
  73d574:	e8 67 42 39 00       	call   ad17e0 <_Unwind_Resume@plt>
  73d579:	64 49 ff 07          	incq   %fs:(%r15)
  73d57d:	48 89 c7             	mov    %rax,%rdi
  73d580:	e8 5b 42 39 00       	call   ad17e0 <_Unwind_Resume@plt>
