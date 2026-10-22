
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000705610 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input>:
  705610:	41 57                	push   %r15
  705612:	41 56                	push   %r14
  705614:	41 55                	push   %r13
  705616:	41 54                	push   %r12
  705618:	53                   	push   %rbx
  705619:	48 83 ec 40          	sub    $0x40,%rsp
  70561d:	48 89 fb             	mov    %rdi,%rbx
  705620:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  705627:	74 0c                	je     705635 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x25>
  705629:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  705630:	e9 8c 01 00 00       	jmp    7057c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  705635:	4d 89 c7             	mov    %r8,%r15
  705638:	49 89 f6             	mov    %rsi,%r14
  70563b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  705640:	e8 7b d0 ff ff       	call   7026c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::input_index>
  705645:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70564a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70564f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705653:	0f 85 e2 00 00 00    	jne    70573b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x12b>
  705659:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  705660:	49 39 f4             	cmp    %rsi,%r12
  705663:	0f 83 89 01 00 00    	jae    7057f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1e2>
  705669:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  70566d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  705674:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  705678:	89 f8                	mov    %edi,%eax
  70567a:	83 e0 07             	and    $0x7,%eax
  70567d:	83 f8 06             	cmp    $0x6,%eax
  705680:	0f 84 49 01 00 00    	je     7057cf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1bf>
  705686:	c1 ef 03             	shr    $0x3,%edi
  705689:	0f 84 40 01 00 00    	je     7057cf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1bf>
  70568f:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  705696:	ff cf                	dec    %edi
  705698:	48 39 fe             	cmp    %rdi,%rsi
  70569b:	0f 86 61 01 00 00    	jbe    705802 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1f2>
  7056a1:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  7056a8:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  7056ac:	48 c1 e1 04          	shl    $0x4,%rcx
  7056b0:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  7056b5:	0f 84 21 01 00 00    	je     7057dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1cc>
  7056bb:	48 01 c8             	add    %rcx,%rax
  7056be:	48 8b 78 40          	mov    0x40(%rax),%rdi
  7056c2:	48 8b 37             	mov    (%rdi),%rsi
  7056c5:	48 d1 ee             	shr    $1,%rsi
  7056c8:	48 83 c7 10          	add    $0x10,%rdi
  7056cc:	4c 89 fa             	mov    %r15,%rdx
  7056cf:	ff 15 3b 3f 42 00    	call   *0x423f3b(%rip)        # b29610 <_DYNAMIC+0x4a0>
  7056d5:	84 c0                	test   %al,%al
  7056d7:	0f 84 82 00 00 00    	je     70575f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x14f>
  7056dd:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  7056e4:	49 ff c5             	inc    %r13
  7056e7:	0f 84 fc 00 00 00    	je     7057e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1d9>
  7056ed:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  7056f4:	00 00 00 00 
  7056f8:	4c 89 f7             	mov    %r14,%rdi
  7056fb:	4c 89 e6             	mov    %r12,%rsi
  7056fe:	4c 89 fa             	mov    %r15,%rdx
  705701:	e8 da d0 ff ff       	call   7027e0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::set_selection>
  705706:	84 c0                	test   %al,%al
  705708:	74 5e                	je     705768 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x158>
  70570a:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  705711:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  705718:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  70571f:	01 00 00 00 
  705723:	48 89 df             	mov    %rbx,%rdi
  705726:	4c 89 f6             	mov    %r14,%rsi
  705729:	48 83 c4 40          	add    $0x40,%rsp
  70572d:	5b                   	pop    %rbx
  70572e:	41 5c                	pop    %r12
  705730:	41 5d                	pop    %r13
  705732:	41 5e                	pop    %r14
  705734:	41 5f                	pop    %r15
  705736:	e9 55 3e 02 00       	jmp    729590 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  70573b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  705740:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  705744:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  705749:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70574e:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  705752:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  705756:	48 89 03             	mov    %rax,(%rbx)
  705759:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  70575d:	eb 62                	jmp    7057c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  70575f:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  705766:	eb 59                	jmp    7057c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  705768:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70576f:	00 
  705770:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  705777:	00 
  705778:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70577f:	00 
  705780:	74 1c                	je     70579e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x18e>
  705782:	84 c0                	test   %al,%al
  705784:	74 0a                	je     705790 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x180>
  705786:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70578d:	ff 
  70578e:	74 0e                	je     70579e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x18e>
  705790:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  705797:	b9 01 00 00 00       	mov    $0x1,%ecx
  70579c:	eb 02                	jmp    7057a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x190>
  70579e:	31 c9                	xor    %ecx,%ecx
  7057a0:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  7057a7:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7057ab:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7057af:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  7057b3:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  7057b7:	88 43 30             	mov    %al,0x30(%rbx)
  7057ba:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7057c1:	48 83 c4 40          	add    $0x40,%rsp
  7057c5:	5b                   	pop    %rbx
  7057c6:	41 5c                	pop    %r12
  7057c8:	41 5d                	pop    %r13
  7057ca:	41 5e                	pop    %r14
  7057cc:	41 5f                	pop    %r15
  7057ce:	c3                   	ret
  7057cf:	48 8d 3d 6a 58 3f 00 	lea    0x3f586a(%rip),%rdi        # afb040 <__frame_dummy_init_array_entry+0x738>
  7057d6:	ff 15 9c 3c 42 00    	call   *0x423c9c(%rip)        # b29478 <_DYNAMIC+0x308>
  7057dc:	48 8d 3d 75 52 3f 00 	lea    0x3f5275(%rip),%rdi        # afaa58 <__frame_dummy_init_array_entry+0x150>
  7057e3:	ff 15 8f 3c 42 00    	call   *0x423c8f(%rip)        # b29478 <_DYNAMIC+0x308>
  7057e9:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  7057f0:	eb cf                	jmp    7057c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  7057f2:	48 8d 15 2f 58 3f 00 	lea    0x3f582f(%rip),%rdx        # afb028 <__frame_dummy_init_array_entry+0x720>
  7057f9:	4c 89 e7             	mov    %r12,%rdi
  7057fc:	ff 15 c6 3c 42 00    	call   *0x423cc6(%rip)        # b294c8 <_DYNAMIC+0x358>
  705802:	48 8d 15 37 52 3f 00 	lea    0x3f5237(%rip),%rdx        # afaa40 <__frame_dummy_init_array_entry+0x138>
  705809:	ff 15 b9 3c 42 00    	call   *0x423cb9(%rip)        # b294c8 <_DYNAMIC+0x358>
