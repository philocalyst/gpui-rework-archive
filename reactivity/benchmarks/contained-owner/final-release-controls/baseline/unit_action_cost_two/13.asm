
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000709480 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select>:
  709480:	41 57                	push   %r15
  709482:	41 56                	push   %r14
  709484:	41 55                	push   %r13
  709486:	41 54                	push   %r12
  709488:	53                   	push   %rbx
  709489:	48 83 ec 60          	sub    $0x60,%rsp
  70948d:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  709494:	74 0c                	je     7094a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x22>
  709496:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70949d:	e9 69 01 00 00       	jmp    70960b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x18b>
  7094a2:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  7094a9:	0f 85 14 01 00 00    	jne    7095c3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x143>
  7094af:	49 89 d6             	mov    %rdx,%r14
  7094b2:	48 89 fb             	mov    %rdi,%rbx
  7094b5:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7094ba:	49 89 f4             	mov    %rsi,%r12
  7094bd:	49 89 cf             	mov    %rcx,%r15
  7094c0:	48 89 ca             	mov    %rcx,%rdx
  7094c3:	e8 88 e4 01 00       	call   727950 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  7094c8:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7094cd:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7094d2:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  7094d6:	0f 85 ee 00 00 00    	jne    7095ca <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x14a>
  7094dc:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  7094e3:	00 
  7094e4:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  7094e9:	48 85 f6             	test   %rsi,%rsi
  7094ec:	48 89 df             	mov    %rbx,%rdi
  7094ef:	0f 84 29 01 00 00    	je     70961e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x19e>
  7094f5:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  7094fc:	00 
  7094fd:	0f 84 1b 01 00 00    	je     70961e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x19e>
  709503:	4c 89 e2             	mov    %r12,%rdx
  709506:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  70950d:	00 
  70950e:	48 83 fe 1c          	cmp    $0x1c,%rsi
  709512:	0f 82 d2 00 00 00    	jb     7095ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x16a>
  709518:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  70951c:	48 83 f8 02          	cmp    $0x2,%rax
  709520:	0f 93 c1             	setae  %cl
  709523:	48 39 f0             	cmp    %rsi,%rax
  709526:	0f 92 c0             	setb   %al
  709529:	84 c1                	test   %al,%cl
  70952b:	0f 84 e8 00 00 00    	je     709619 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x199>
  709531:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  709538:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  70953c:	0f 84 f7 00 00 00    	je     709639 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x1b9>
  709542:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  709549:	00 00 
  70954b:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709550:	e8 2b e5 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709555:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  70955c:	00 
  70955d:	48 85 c0             	test   %rax,%rax
  709560:	0f 84 ba 00 00 00    	je     709620 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x1a0>
  709566:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70956d:	48 85 c0             	test   %rax,%rax
  709570:	0f 84 aa 00 00 00    	je     709620 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x1a0>
  709576:	4c 89 e6             	mov    %r12,%rsi
  709579:	49 ff c5             	inc    %r13
  70957c:	4c 89 30             	mov    %r14,(%rax)
  70957f:	4c 89 78 08          	mov    %r15,0x8(%rax)
  709583:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  709589:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  709590:	00 
  709591:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  709598:	00 
  709599:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  7095a0:	00 00 00 00 00 
  7095a5:	41 c6 84 24 1f 07 00 	movb   $0x1,0x71f(%r12)
  7095ac:	00 01 
  7095ae:	48 89 df             	mov    %rbx,%rdi
  7095b1:	48 83 c4 60          	add    $0x60,%rsp
  7095b5:	5b                   	pop    %rbx
  7095b6:	41 5c                	pop    %r12
  7095b8:	41 5d                	pop    %r13
  7095ba:	41 5e                	pop    %r14
  7095bc:	41 5f                	pop    %r15
  7095be:	e9 fd eb 01 00       	jmp    7281c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  7095c3:	b9 11 00 00 00       	mov    $0x11,%ecx
  7095c8:	eb 03                	jmp    7095cd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x14d>
  7095ca:	48 89 df             	mov    %rbx,%rdi
  7095cd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  7095d2:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  7095d7:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  7095dc:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  7095e1:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  7095e6:	0f 29 04 24          	movaps %xmm0,(%rsp)
  7095ea:	48 89 0f             	mov    %rcx,(%rdi)
  7095ed:	48 89 47 08          	mov    %rax,0x8(%rdi)
  7095f1:	0f 28 04 24          	movaps (%rsp),%xmm0
  7095f5:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  7095fa:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  7095fe:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  709602:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709607:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70960b:	48 83 c4 60          	add    $0x60,%rsp
  70960f:	5b                   	pop    %rbx
  709610:	41 5c                	pop    %r12
  709612:	41 5d                	pop    %r13
  709614:	41 5e                	pop    %r14
  709616:	41 5f                	pop    %r15
  709618:	c3                   	ret
  709619:	b9 11 00 00 00       	mov    $0x11,%ecx
  70961e:	eb ca                	jmp    7095ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x16a>
  709620:	48 8d 3d 9e 0d 96 ff 	lea    -0x69f262(%rip),%rdi        # 6a3c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32d8>
  709627:	48 8d 15 62 06 3f 00 	lea    0x3f0662(%rip),%rdx        # af9c90 <__frame_dummy_init_array_entry+0x768>
  70962e:	be 11 00 00 00       	mov    $0x11,%esi
  709633:	ff 15 c7 e9 41 00    	call   *0x41e9c7(%rip)        # b28000 <_DYNAMIC+0x348>
  709639:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  709640:	eb c9                	jmp    70960b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x18b>
