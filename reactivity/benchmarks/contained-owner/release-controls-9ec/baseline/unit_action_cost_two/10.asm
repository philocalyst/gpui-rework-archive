
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fa4a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>:
  6fa4a0:	55                   	push   %rbp
  6fa4a1:	41 57                	push   %r15
  6fa4a3:	41 56                	push   %r14
  6fa4a5:	41 54                	push   %r12
  6fa4a7:	53                   	push   %rbx
  6fa4a8:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  6fa4af:	89 cd                	mov    %ecx,%ebp
  6fa4b1:	49 89 d7             	mov    %rdx,%r15
  6fa4b4:	49 89 f6             	mov    %rsi,%r14
  6fa4b7:	48 89 fb             	mov    %rdi,%rbx
  6fa4ba:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  6fa4c1:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fa4c8:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  6fa4cd:	e8 ae 98 05 00       	call   753d80 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::validate>
  6fa4d2:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  6fa4d7:	74 1e                	je     6fa4f7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x57>
  6fa4d9:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  6fa4e0:	00 
  6fa4e1:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fa4e6:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  6fa4eb:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  6fa4f0:	b8 20 00 00 00       	mov    $0x20,%eax
  6fa4f5:	eb 1e                	jmp    6fa515 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x75>
  6fa4f7:	40 0f b6 d5          	movzbl %bpl,%edx
  6fa4fb:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6fa500:	4c 89 f6             	mov    %r14,%rsi
  6fa503:	4c 89 f9             	mov    %r15,%rcx
  6fa506:	e8 d5 6d 01 00       	call   7112e0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::describe_inner>
  6fa50b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fa510:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fa515:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  6fa51a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  6fa51f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  6fa524:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  6fa529:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6fa52e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6fa533:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fa538:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6fa53d:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fa542:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fa547:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fa54c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fa550:	74 3d                	je     6fa58f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xef>
  6fa552:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fa556:	75 40                	jne    6fa598 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xf8>
  6fa558:	4c 89 f7             	mov    %r14,%rdi
  6fa55b:	e8 e0 f1 01 00       	call   719740 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fa560:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fa567:	49 8b 04 24          	mov    (%r12),%rax
  6fa56b:	48 85 c0             	test   %rax,%rax
  6fa56e:	74 05                	je     6fa575 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xd5>
  6fa570:	4c 89 ff             	mov    %r15,%rdi
  6fa573:	ff d0                	call   *%rax
  6fa575:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fa57a:	48 85 f6             	test   %rsi,%rsi
  6fa57d:	74 4f                	je     6fa5ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6fa57f:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fa584:	4c 89 ff             	mov    %r15,%rdi
  6fa587:	ff 15 73 d9 42 00    	call   *0x42d973(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fa58d:	eb 3f                	jmp    6fa5ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6fa58f:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fa596:	eb 36                	jmp    6fa5ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6fa598:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fa59d:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fa5a1:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  6fa5a6:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  6fa5ab:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  6fa5b0:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fa5b4:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  6fa5b8:	0f 11 03             	movups %xmm0,(%rbx)
  6fa5bb:	41 c6 86 1e 08 00 00 	movb   $0x0,0x81e(%r14)
  6fa5c2:	00 
  6fa5c3:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fa5ca:	00 00 00 00 
  6fa5ce:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  6fa5d5:	5b                   	pop    %rbx
  6fa5d6:	41 5c                	pop    %r12
  6fa5d8:	41 5e                	pop    %r14
  6fa5da:	41 5f                	pop    %r15
  6fa5dc:	5d                   	pop    %rbp
  6fa5dd:	c3                   	ret
  6fa5de:	48 89 c3             	mov    %rax,%rbx
  6fa5e1:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fa5e6:	48 85 f6             	test   %rsi,%rsi
  6fa5e9:	74 23                	je     6fa60e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x16e>
  6fa5eb:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fa5f0:	4c 89 ff             	mov    %r15,%rdi
  6fa5f3:	ff 15 07 d9 42 00    	call   *0x42d907(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fa5f9:	48 89 df             	mov    %rbx,%rdi
  6fa5fc:	e8 6f db 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fa601:	48 89 c3             	mov    %rax,%rbx
  6fa604:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6fa609:	e8 92 a2 ff ff       	call   6f48a0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fa60e:	48 89 df             	mov    %rbx,%rdi
  6fa611:	e8 5a db 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fa616:	ff 15 14 d9 42 00    	call   *0x42d914(%rip)        # b27f30 <_DYNAMIC+0x278>
  6fa61c:	48 89 c7             	mov    %rax,%rdi
  6fa61f:	ff 15 fb d9 42 00    	call   *0x42d9fb(%rip)        # b28020 <_DYNAMIC+0x368>
  6fa625:	49 89 c7             	mov    %rax,%r15
  6fa628:	49 89 d4             	mov    %rdx,%r12
  6fa62b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fa630:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fa635:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  6fa63c:	ff ff 
  6fa63e:	e9 15 ff ff ff       	jmp    6fa558 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xb8>
  6fa643:	ff 15 df d9 42 00    	call   *0x42d9df(%rip)        # b28028 <_DYNAMIC+0x370>
