
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074e6c0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>>:
  74e6c0:	41 57                	push   %r15
  74e6c2:	41 56                	push   %r14
  74e6c4:	41 55                	push   %r13
  74e6c6:	41 54                	push   %r12
  74e6c8:	53                   	push   %rbx
  74e6c9:	48 83 ec 70          	sub    $0x70,%rsp
  74e6cd:	48 89 fb             	mov    %rdi,%rbx
  74e6d0:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  74e6d7:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74e6de:	00 00 
  74e6e0:	4d 01 fe             	add    %r15,%r14
  74e6e3:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  74e6ea:	00 00 
  74e6ec:	0f 84 90 00 00 00    	je     74e782 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xc2>
  74e6f2:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74e6f7:	0f 85 b5 00 00 00    	jne    74e7b2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xf2>
  74e6fd:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  74e704:	ff 
  74e705:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  74e70c:	00 
  74e70d:	ff c0                	inc    %eax
  74e70f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  74e716:	00 
  74e717:	83 f8 40             	cmp    $0x40,%eax
  74e71a:	0f 83 9f 00 00 00    	jae    74e7bf <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xff>
  74e720:	89 c0                	mov    %eax,%eax
  74e722:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74e726:	48 c1 e0 04          	shl    $0x4,%rax
  74e72a:	0f 57 c0             	xorps  %xmm0,%xmm0
  74e72d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74e733:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74e739:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74e73f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  74e746:	00 
  74e747:	48 8b 02             	mov    (%rdx),%rax
  74e74a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  74e74e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  74e753:	48 89 c2             	mov    %rax,%rdx
  74e756:	e8 75 ce fb ff       	call   70b5d0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click>
  74e75b:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  74e760:	75 78                	jne    74e7da <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x11a>
  74e762:	48 8d 35 47 d5 3a 00 	lea    0x3ad547(%rip),%rsi        # afbcb0 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74e769:	48 89 df             	mov    %rbx,%rdi
  74e76c:	e8 8f eb 01 00       	call   76d300 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74e771:	48 89 d8             	mov    %rbx,%rax
  74e774:	48 83 c4 70          	add    $0x70,%rsp
  74e778:	5b                   	pop    %rbx
  74e779:	41 5c                	pop    %r12
  74e77b:	41 5d                	pop    %r13
  74e77d:	41 5e                	pop    %r14
  74e77f:	41 5f                	pop    %r15
  74e781:	c3                   	ret
  74e782:	49 89 d4             	mov    %rdx,%r12
  74e785:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74e78a:	4c 89 f7             	mov    %r14,%rdi
  74e78d:	49 89 f5             	mov    %rsi,%r13
  74e790:	31 f6                	xor    %esi,%esi
  74e792:	ff 15 88 b1 3d 00    	call   *0x3db188(%rip)        # b29920 <memset@GLIBC_2.2.5>
  74e798:	4c 89 e2             	mov    %r12,%rdx
  74e79b:	4c 89 ee             	mov    %r13,%rsi
  74e79e:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  74e7a5:	00 01 
  74e7a7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74e7ac:	0f 84 4b ff ff ff    	je     74e6fd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x3d>
  74e7b2:	48 8d 3d ff e1 3a 00 	lea    0x3ae1ff(%rip),%rdi        # afc9b8 <anon.547532fe00eaf98ca33efb65e1aed586.15.llvm.9042944481482549913>
  74e7b9:	ff 15 69 b1 3d 00    	call   *0x3db169(%rip)        # b29928 <_DYNAMIC+0x7b8>
  74e7bf:	48 8d 3d ba d6 91 ff 	lea    -0x6e2946(%rip),%rdi        # 6be80 <anon.547532fe00eaf98ca33efb65e1aed586.12.llvm.9042944481482549913>
  74e7c6:	48 8d 15 d3 e1 3a 00 	lea    0x3ae1d3(%rip),%rdx        # afc9a0 <anon.547532fe00eaf98ca33efb65e1aed586.14.llvm.9042944481482549913>
  74e7cd:	be 4b 00 00 00       	mov    $0x4b,%esi
  74e7d2:	ff 15 e0 ad 3d 00    	call   *0x3dade0(%rip)        # b295b8 <_DYNAMIC+0x448>
  74e7d8:	eb 4a                	jmp    74e824 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x164>
  74e7da:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74e7df:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  74e7e4:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  74e7e9:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  74e7ee:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  74e7f3:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  74e7f8:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  74e7fd:	0f 29 04 24          	movaps %xmm0,(%rsp)
  74e801:	48 8d 3d 5c c7 91 ff 	lea    -0x6e38a4(%rip),%rdi        # 6af64 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74e808:	48 8d 0d 09 d5 3a 00 	lea    0x3ad509(%rip),%rcx        # afbd18 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74e80f:	4c 8d 05 ea d4 3a 00 	lea    0x3ad4ea(%rip),%r8        # afbd00 <anon.2d1f820267f84878e0cbda50021465a1.6.llvm.17676285964678017166>
  74e816:	48 89 e2             	mov    %rsp,%rdx
  74e819:	be 2b 00 00 00       	mov    $0x2b,%esi
  74e81e:	ff 15 9c ac 3d 00    	call   *0x3dac9c(%rip)        # b294c0 <_DYNAMIC+0x350>
  74e824:	0f 0b                	ud2
  74e826:	48 89 c3             	mov    %rax,%rbx
  74e829:	48 89 e7             	mov    %rsp,%rdi
  74e82c:	e8 1f 22 00 00       	call   750a50 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74e831:	48 89 df             	mov    %rbx,%rdi
  74e834:	e8 17 ad 3a 00       	call   af9550 <_Unwind_Resume@plt>
  74e839:	64 49 ff 07          	incq   %fs:(%r15)
  74e83d:	48 89 c7             	mov    %rax,%rdi
  74e840:	e8 0b ad 3a 00       	call   af9550 <_Unwind_Resume@plt>
