
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074e5c0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>>:
  74e5c0:	41 57                	push   %r15
  74e5c2:	41 56                	push   %r14
  74e5c4:	41 55                	push   %r13
  74e5c6:	41 54                	push   %r12
  74e5c8:	53                   	push   %rbx
  74e5c9:	48 83 ec 70          	sub    $0x70,%rsp
  74e5cd:	48 89 fb             	mov    %rdi,%rbx
  74e5d0:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  74e5d7:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74e5de:	00 00 
  74e5e0:	4d 01 fe             	add    %r15,%r14
  74e5e3:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  74e5ea:	00 00 
  74e5ec:	0f 84 90 00 00 00    	je     74e682 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xc2>
  74e5f2:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74e5f7:	0f 85 b5 00 00 00    	jne    74e6b2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xf2>
  74e5fd:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  74e604:	ff 
  74e605:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  74e60c:	00 
  74e60d:	ff c0                	inc    %eax
  74e60f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  74e616:	00 
  74e617:	83 f8 40             	cmp    $0x40,%eax
  74e61a:	0f 83 9f 00 00 00    	jae    74e6bf <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xff>
  74e620:	89 c0                	mov    %eax,%eax
  74e622:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74e626:	48 c1 e0 04          	shl    $0x4,%rax
  74e62a:	0f 57 c0             	xorps  %xmm0,%xmm0
  74e62d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74e633:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74e639:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74e63f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  74e646:	00 
  74e647:	48 8b 02             	mov    (%rdx),%rax
  74e64a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  74e64e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  74e653:	48 89 c2             	mov    %rax,%rdx
  74e656:	e8 75 ce fb ff       	call   70b4d0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click>
  74e65b:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  74e660:	75 78                	jne    74e6da <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x11a>
  74e662:	48 8d 35 a7 d5 3a 00 	lea    0x3ad5a7(%rip),%rsi        # afbc10 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74e669:	48 89 df             	mov    %rbx,%rdi
  74e66c:	e8 8f eb 01 00       	call   76d200 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74e671:	48 89 d8             	mov    %rbx,%rax
  74e674:	48 83 c4 70          	add    $0x70,%rsp
  74e678:	5b                   	pop    %rbx
  74e679:	41 5c                	pop    %r12
  74e67b:	41 5d                	pop    %r13
  74e67d:	41 5e                	pop    %r14
  74e67f:	41 5f                	pop    %r15
  74e681:	c3                   	ret
  74e682:	49 89 d4             	mov    %rdx,%r12
  74e685:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74e68a:	4c 89 f7             	mov    %r14,%rdi
  74e68d:	49 89 f5             	mov    %rsi,%r13
  74e690:	31 f6                	xor    %esi,%esi
  74e692:	ff 15 a0 b1 3d 00    	call   *0x3db1a0(%rip)        # b29838 <memset@GLIBC_2.2.5>
  74e698:	4c 89 e2             	mov    %r12,%rdx
  74e69b:	4c 89 ee             	mov    %r13,%rsi
  74e69e:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  74e6a5:	00 01 
  74e6a7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74e6ac:	0f 84 4b ff ff ff    	je     74e5fd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x3d>
  74e6b2:	48 8d 3d 37 e2 3a 00 	lea    0x3ae237(%rip),%rdi        # afc8f0 <anon.cf030bdcd33bba1955553babc00e59a7.15.llvm.14032215357312518664>
  74e6b9:	ff 15 81 b1 3d 00    	call   *0x3db181(%rip)        # b29840 <_DYNAMIC+0x7b8>
  74e6bf:	48 8d 3d 02 d7 91 ff 	lea    -0x6e28fe(%rip),%rdi        # 6bdc8 <anon.cf030bdcd33bba1955553babc00e59a7.12.llvm.14032215357312518664>
  74e6c6:	48 8d 15 0b e2 3a 00 	lea    0x3ae20b(%rip),%rdx        # afc8d8 <anon.cf030bdcd33bba1955553babc00e59a7.14.llvm.14032215357312518664>
  74e6cd:	be 4b 00 00 00       	mov    $0x4b,%esi
  74e6d2:	ff 15 f8 ad 3d 00    	call   *0x3dadf8(%rip)        # b294d0 <_DYNAMIC+0x448>
  74e6d8:	eb 4a                	jmp    74e724 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x164>
  74e6da:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74e6df:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  74e6e4:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  74e6e9:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  74e6ee:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  74e6f3:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  74e6f8:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  74e6fd:	0f 29 04 24          	movaps %xmm0,(%rsp)
  74e701:	48 8d 3d ec c7 91 ff 	lea    -0x6e3814(%rip),%rdi        # 6aef4 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74e708:	48 8d 0d 69 d5 3a 00 	lea    0x3ad569(%rip),%rcx        # afbc78 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74e70f:	4c 8d 05 4a d5 3a 00 	lea    0x3ad54a(%rip),%r8        # afbc60 <anon.2d1f820267f84878e0cbda50021465a1.6.llvm.17676285964678017166>
  74e716:	48 89 e2             	mov    %rsp,%rdx
  74e719:	be 2b 00 00 00       	mov    $0x2b,%esi
  74e71e:	ff 15 b4 ac 3d 00    	call   *0x3dacb4(%rip)        # b293d8 <_DYNAMIC+0x350>
  74e724:	0f 0b                	ud2
  74e726:	48 89 c3             	mov    %rax,%rbx
  74e729:	48 89 e7             	mov    %rsp,%rdi
  74e72c:	e8 1f 22 00 00       	call   750950 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74e731:	48 89 df             	mov    %rbx,%rdi
  74e734:	e8 77 ad 3a 00       	call   af94b0 <_Unwind_Resume@plt>
  74e739:	64 49 ff 07          	incq   %fs:(%r15)
  74e73d:	48 89 c7             	mov    %rax,%rdi
  74e740:	e8 6b ad 3a 00       	call   af94b0 <_Unwind_Resume@plt>
