
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007055a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input>:
  7055a0:	41 57                	push   %r15
  7055a2:	41 56                	push   %r14
  7055a4:	41 55                	push   %r13
  7055a6:	41 54                	push   %r12
  7055a8:	53                   	push   %rbx
  7055a9:	48 83 ec 40          	sub    $0x40,%rsp
  7055ad:	48 89 fb             	mov    %rdi,%rbx
  7055b0:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  7055b7:	74 0c                	je     7055c5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x25>
  7055b9:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  7055c0:	e9 8c 01 00 00       	jmp    705751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  7055c5:	4d 89 c7             	mov    %r8,%r15
  7055c8:	49 89 f6             	mov    %rsi,%r14
  7055cb:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  7055d0:	e8 7b d0 ff ff       	call   702650 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::input_index>
  7055d5:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7055da:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7055df:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7055e3:	0f 85 e2 00 00 00    	jne    7056cb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x12b>
  7055e9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7055f0:	49 39 f4             	cmp    %rsi,%r12
  7055f3:	0f 83 89 01 00 00    	jae    705782 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1e2>
  7055f9:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  7055fd:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  705604:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  705608:	89 f8                	mov    %edi,%eax
  70560a:	83 e0 07             	and    $0x7,%eax
  70560d:	83 f8 06             	cmp    $0x6,%eax
  705610:	0f 84 49 01 00 00    	je     70575f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1bf>
  705616:	c1 ef 03             	shr    $0x3,%edi
  705619:	0f 84 40 01 00 00    	je     70575f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1bf>
  70561f:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  705626:	ff cf                	dec    %edi
  705628:	48 39 fe             	cmp    %rdi,%rsi
  70562b:	0f 86 61 01 00 00    	jbe    705792 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1f2>
  705631:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  705638:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  70563c:	48 c1 e1 04          	shl    $0x4,%rcx
  705640:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  705645:	0f 84 21 01 00 00    	je     70576c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1cc>
  70564b:	48 01 c8             	add    %rcx,%rax
  70564e:	48 8b 78 40          	mov    0x40(%rax),%rdi
  705652:	48 8b 37             	mov    (%rdi),%rsi
  705655:	48 d1 ee             	shr    $1,%rsi
  705658:	48 83 c7 10          	add    $0x10,%rdi
  70565c:	4c 89 fa             	mov    %r15,%rdx
  70565f:	ff 15 3b 3f 42 00    	call   *0x423f3b(%rip)        # b295a0 <_DYNAMIC+0x4a0>
  705665:	84 c0                	test   %al,%al
  705667:	0f 84 82 00 00 00    	je     7056ef <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x14f>
  70566d:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  705674:	49 ff c5             	inc    %r13
  705677:	0f 84 fc 00 00 00    	je     705779 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1d9>
  70567d:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  705684:	00 00 00 00 
  705688:	4c 89 f7             	mov    %r14,%rdi
  70568b:	4c 89 e6             	mov    %r12,%rsi
  70568e:	4c 89 fa             	mov    %r15,%rdx
  705691:	e8 da d0 ff ff       	call   702770 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::set_selection>
  705696:	84 c0                	test   %al,%al
  705698:	74 5e                	je     7056f8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x158>
  70569a:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  7056a1:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  7056a8:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  7056af:	01 00 00 00 
  7056b3:	48 89 df             	mov    %rbx,%rdi
  7056b6:	4c 89 f6             	mov    %r14,%rsi
  7056b9:	48 83 c4 40          	add    $0x40,%rsp
  7056bd:	5b                   	pop    %rbx
  7056be:	41 5c                	pop    %r12
  7056c0:	41 5d                	pop    %r13
  7056c2:	41 5e                	pop    %r14
  7056c4:	41 5f                	pop    %r15
  7056c6:	e9 55 3e 02 00       	jmp    729520 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  7056cb:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7056d0:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  7056d4:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  7056d9:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  7056de:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  7056e2:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  7056e6:	48 89 03             	mov    %rax,(%rbx)
  7056e9:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  7056ed:	eb 62                	jmp    705751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  7056ef:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  7056f6:	eb 59                	jmp    705751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  7056f8:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  7056ff:	00 
  705700:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  705707:	00 
  705708:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70570f:	00 
  705710:	74 1c                	je     70572e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x18e>
  705712:	84 c0                	test   %al,%al
  705714:	74 0a                	je     705720 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x180>
  705716:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70571d:	ff 
  70571e:	74 0e                	je     70572e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x18e>
  705720:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  705727:	b9 01 00 00 00       	mov    $0x1,%ecx
  70572c:	eb 02                	jmp    705730 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x190>
  70572e:	31 c9                	xor    %ecx,%ecx
  705730:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  705737:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70573b:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70573f:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  705743:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  705747:	88 43 30             	mov    %al,0x30(%rbx)
  70574a:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  705751:	48 83 c4 40          	add    $0x40,%rsp
  705755:	5b                   	pop    %rbx
  705756:	41 5c                	pop    %r12
  705758:	41 5d                	pop    %r13
  70575a:	41 5e                	pop    %r14
  70575c:	41 5f                	pop    %r15
  70575e:	c3                   	ret
  70575f:	48 8d 3d 6a 58 3f 00 	lea    0x3f586a(%rip),%rdi        # afafd0 <__frame_dummy_init_array_entry+0x738>
  705766:	ff 15 9c 3c 42 00    	call   *0x423c9c(%rip)        # b29408 <_DYNAMIC+0x308>
  70576c:	48 8d 3d 75 52 3f 00 	lea    0x3f5275(%rip),%rdi        # afa9e8 <__frame_dummy_init_array_entry+0x150>
  705773:	ff 15 8f 3c 42 00    	call   *0x423c8f(%rip)        # b29408 <_DYNAMIC+0x308>
  705779:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  705780:	eb cf                	jmp    705751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  705782:	48 8d 15 2f 58 3f 00 	lea    0x3f582f(%rip),%rdx        # afafb8 <__frame_dummy_init_array_entry+0x720>
  705789:	4c 89 e7             	mov    %r12,%rdi
  70578c:	ff 15 c6 3c 42 00    	call   *0x423cc6(%rip)        # b29458 <_DYNAMIC+0x358>
  705792:	48 8d 15 37 52 3f 00 	lea    0x3f5237(%rip),%rdx        # afa9d0 <__frame_dummy_init_array_entry+0x138>
  705799:	ff 15 b9 3c 42 00    	call   *0x423cb9(%rip)        # b29458 <_DYNAMIC+0x358>
