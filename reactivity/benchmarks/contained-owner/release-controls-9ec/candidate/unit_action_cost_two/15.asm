
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074e650 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>>:
  74e650:	41 57                	push   %r15
  74e652:	41 56                	push   %r14
  74e654:	41 55                	push   %r13
  74e656:	41 54                	push   %r12
  74e658:	53                   	push   %rbx
  74e659:	48 83 ec 70          	sub    $0x70,%rsp
  74e65d:	48 89 fb             	mov    %rdi,%rbx
  74e660:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  74e667:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74e66e:	00 00 
  74e670:	4d 01 fe             	add    %r15,%r14
  74e673:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  74e67a:	00 00 
  74e67c:	0f 84 90 00 00 00    	je     74e712 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xc2>
  74e682:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74e687:	0f 85 b5 00 00 00    	jne    74e742 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xf2>
  74e68d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  74e694:	ff 
  74e695:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  74e69c:	00 
  74e69d:	ff c0                	inc    %eax
  74e69f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  74e6a6:	00 
  74e6a7:	83 f8 40             	cmp    $0x40,%eax
  74e6aa:	0f 83 9f 00 00 00    	jae    74e74f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xff>
  74e6b0:	89 c0                	mov    %eax,%eax
  74e6b2:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74e6b6:	48 c1 e0 04          	shl    $0x4,%rax
  74e6ba:	0f 57 c0             	xorps  %xmm0,%xmm0
  74e6bd:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74e6c3:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74e6c9:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74e6cf:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  74e6d6:	00 
  74e6d7:	48 8b 02             	mov    (%rdx),%rax
  74e6da:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  74e6de:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  74e6e3:	48 89 c2             	mov    %rax,%rdx
  74e6e6:	e8 75 ce fb ff       	call   70b560 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click>
  74e6eb:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  74e6f0:	75 78                	jne    74e76a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x11a>
  74e6f2:	48 8d 35 47 d5 3a 00 	lea    0x3ad547(%rip),%rsi        # afbc40 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74e6f9:	48 89 df             	mov    %rbx,%rdi
  74e6fc:	e8 8f eb 01 00       	call   76d290 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74e701:	48 89 d8             	mov    %rbx,%rax
  74e704:	48 83 c4 70          	add    $0x70,%rsp
  74e708:	5b                   	pop    %rbx
  74e709:	41 5c                	pop    %r12
  74e70b:	41 5d                	pop    %r13
  74e70d:	41 5e                	pop    %r14
  74e70f:	41 5f                	pop    %r15
  74e711:	c3                   	ret
  74e712:	49 89 d4             	mov    %rdx,%r12
  74e715:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74e71a:	4c 89 f7             	mov    %r14,%rdi
  74e71d:	49 89 f5             	mov    %rsi,%r13
  74e720:	31 f6                	xor    %esi,%esi
  74e722:	ff 15 88 b1 3d 00    	call   *0x3db188(%rip)        # b298b0 <memset@GLIBC_2.2.5>
  74e728:	4c 89 e2             	mov    %r12,%rdx
  74e72b:	4c 89 ee             	mov    %r13,%rsi
  74e72e:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  74e735:	00 01 
  74e737:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74e73c:	0f 84 4b ff ff ff    	je     74e68d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x3d>
  74e742:	48 8d 3d ff e1 3a 00 	lea    0x3ae1ff(%rip),%rdi        # afc948 <anon.547532fe00eaf98ca33efb65e1aed586.15.llvm.9042944481482549913>
  74e749:	ff 15 69 b1 3d 00    	call   *0x3db169(%rip)        # b298b8 <_DYNAMIC+0x7b8>
  74e74f:	48 8d 3d 1a d7 91 ff 	lea    -0x6e28e6(%rip),%rdi        # 6be70 <anon.547532fe00eaf98ca33efb65e1aed586.12.llvm.9042944481482549913>
  74e756:	48 8d 15 d3 e1 3a 00 	lea    0x3ae1d3(%rip),%rdx        # afc930 <anon.547532fe00eaf98ca33efb65e1aed586.14.llvm.9042944481482549913>
  74e75d:	be 4b 00 00 00       	mov    $0x4b,%esi
  74e762:	ff 15 e0 ad 3d 00    	call   *0x3dade0(%rip)        # b29548 <_DYNAMIC+0x448>
  74e768:	eb 4a                	jmp    74e7b4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x164>
  74e76a:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74e76f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  74e774:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  74e779:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  74e77e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  74e783:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  74e788:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  74e78d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  74e791:	48 8d 3d bc c7 91 ff 	lea    -0x6e3844(%rip),%rdi        # 6af54 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74e798:	48 8d 0d 09 d5 3a 00 	lea    0x3ad509(%rip),%rcx        # afbca8 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74e79f:	4c 8d 05 ea d4 3a 00 	lea    0x3ad4ea(%rip),%r8        # afbc90 <anon.2d1f820267f84878e0cbda50021465a1.6.llvm.17676285964678017166>
  74e7a6:	48 89 e2             	mov    %rsp,%rdx
  74e7a9:	be 2b 00 00 00       	mov    $0x2b,%esi
  74e7ae:	ff 15 9c ac 3d 00    	call   *0x3dac9c(%rip)        # b29450 <_DYNAMIC+0x350>
  74e7b4:	0f 0b                	ud2
  74e7b6:	48 89 c3             	mov    %rax,%rbx
  74e7b9:	48 89 e7             	mov    %rsp,%rdi
  74e7bc:	e8 1f 22 00 00       	call   7509e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74e7c1:	48 89 df             	mov    %rbx,%rdi
  74e7c4:	e8 17 ad 3a 00       	call   af94e0 <_Unwind_Resume@plt>
  74e7c9:	64 49 ff 07          	incq   %fs:(%r15)
  74e7cd:	48 89 c7             	mov    %rax,%rdi
  74e7d0:	e8 0b ad 3a 00       	call   af94e0 <_Unwind_Resume@plt>
