
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074c650 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>>:
  74c650:	41 57                	push   %r15
  74c652:	41 56                	push   %r14
  74c654:	41 55                	push   %r13
  74c656:	41 54                	push   %r12
  74c658:	53                   	push   %rbx
  74c659:	48 83 ec 70          	sub    $0x70,%rsp
  74c65d:	48 89 fb             	mov    %rdi,%rbx
  74c660:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  74c667:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74c66e:	00 00 
  74c670:	4d 01 fe             	add    %r15,%r14
  74c673:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  74c67a:	00 00 
  74c67c:	0f 84 90 00 00 00    	je     74c712 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xc2>
  74c682:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74c687:	0f 85 b5 00 00 00    	jne    74c742 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xf2>
  74c68d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  74c694:	ff 
  74c695:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  74c69c:	00 
  74c69d:	ff c0                	inc    %eax
  74c69f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  74c6a6:	00 
  74c6a7:	83 f8 40             	cmp    $0x40,%eax
  74c6aa:	0f 83 9f 00 00 00    	jae    74c74f <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xff>
  74c6b0:	89 c0                	mov    %eax,%eax
  74c6b2:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74c6b6:	48 c1 e0 04          	shl    $0x4,%rax
  74c6ba:	0f 57 c0             	xorps  %xmm0,%xmm0
  74c6bd:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74c6c3:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74c6c9:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74c6cf:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  74c6d6:	00 
  74c6d7:	48 8b 02             	mov    (%rdx),%rax
  74c6da:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  74c6de:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  74c6e3:	48 89 c2             	mov    %rax,%rdx
  74c6e6:	e8 65 e9 fb ff       	call   70b050 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click>
  74c6eb:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  74c6f0:	75 78                	jne    74c76a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x11a>
  74c6f2:	48 8d 35 8f e1 3a 00 	lea    0x3ae18f(%rip),%rsi        # afa888 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74c6f9:	48 89 df             	mov    %rbx,%rdi
  74c6fc:	e8 8f 88 00 00       	call   754f90 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74c701:	48 89 d8             	mov    %rbx,%rax
  74c704:	48 83 c4 70          	add    $0x70,%rsp
  74c708:	5b                   	pop    %rbx
  74c709:	41 5c                	pop    %r12
  74c70b:	41 5d                	pop    %r13
  74c70d:	41 5e                	pop    %r14
  74c70f:	41 5f                	pop    %r15
  74c711:	c3                   	ret
  74c712:	49 89 d4             	mov    %rdx,%r12
  74c715:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74c71a:	4c 89 f7             	mov    %r14,%rdi
  74c71d:	49 89 f5             	mov    %rsi,%r13
  74c720:	31 f6                	xor    %esi,%esi
  74c722:	ff 15 30 bd 3d 00    	call   *0x3dbd30(%rip)        # b28458 <memset@GLIBC_2.2.5>
  74c728:	4c 89 e2             	mov    %r12,%rdx
  74c72b:	4c 89 ee             	mov    %r13,%rsi
  74c72e:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  74c735:	00 01 
  74c737:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74c73c:	0f 84 4b ff ff ff    	je     74c68d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x3d>
  74c742:	48 8d 3d f7 e4 3a 00 	lea    0x3ae4f7(%rip),%rdi        # afac40 <anon.cf030bdcd33bba1955553babc00e59a7.15.llvm.15067004318175258651>
  74c749:	ff 15 11 bd 3d 00    	call   *0x3dbd11(%rip)        # b28460 <_DYNAMIC+0x7a8>
  74c74f:	48 8d 3d 56 e9 91 ff 	lea    -0x6e16aa(%rip),%rdi        # 6b0ac <anon.cf030bdcd33bba1955553babc00e59a7.12.llvm.15067004318175258651>
  74c756:	48 8d 15 cb e4 3a 00 	lea    0x3ae4cb(%rip),%rdx        # afac28 <anon.cf030bdcd33bba1955553babc00e59a7.14.llvm.15067004318175258651>
  74c75d:	be 4b 00 00 00       	mov    $0x4b,%esi
  74c762:	ff 15 88 b9 3d 00    	call   *0x3db988(%rip)        # b280f0 <_DYNAMIC+0x438>
  74c768:	eb 4a                	jmp    74c7b4 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x164>
  74c76a:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74c76f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  74c774:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  74c779:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  74c77e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  74c783:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  74c788:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  74c78d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  74c791:	48 8d 3d bc e5 91 ff 	lea    -0x6e1a44(%rip),%rdi        # 6ad54 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74c798:	48 8d 0d 51 e1 3a 00 	lea    0x3ae151(%rip),%rcx        # afa8f0 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74c79f:	4c 8d 05 02 e1 3a 00 	lea    0x3ae102(%rip),%r8        # afa8a8 <anon.2d1f820267f84878e0cbda50021465a1.3.llvm.17676285964678017166>
  74c7a6:	48 89 e2             	mov    %rsp,%rdx
  74c7a9:	be 2b 00 00 00       	mov    $0x2b,%esi
  74c7ae:	ff 15 54 b8 3d 00    	call   *0x3db854(%rip)        # b28008 <_DYNAMIC+0x350>
  74c7b4:	0f 0b                	ud2
  74c7b6:	48 89 c3             	mov    %rax,%rbx
  74c7b9:	48 89 e7             	mov    %rsp,%rdi
  74c7bc:	e8 df 2c 00 00       	call   74f4a0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74c7c1:	48 89 df             	mov    %rbx,%rdi
  74c7c4:	e8 a7 b9 3a 00       	call   af8170 <_Unwind_Resume@plt>
  74c7c9:	64 49 ff 07          	incq   %fs:(%r15)
  74c7cd:	48 89 c7             	mov    %rax,%rdi
  74c7d0:	e8 9b b9 3a 00       	call   af8170 <_Unwind_Resume@plt>
