
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007087a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>:
  7087a0:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  7087a7:	48 85 c0             	test   %rax,%rax
  7087aa:	0f 84 f4 00 00 00    	je     7088a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x104>
  7087b0:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  7087b7:	48 85 c0             	test   %rax,%rax
  7087ba:	0f 84 e4 00 00 00    	je     7088a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x104>
  7087c0:	89 d1                	mov    %edx,%ecx
  7087c2:	c1 e9 08             	shr    $0x8,%ecx
  7087c5:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  7087ca:	41 80 f8 ff          	cmp    $0xff,%r8b
  7087ce:	0f 84 8e 00 00 00    	je     708862 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  7087d4:	45 31 c9             	xor    %r9d,%r9d
  7087d7:	41 80 f8 06          	cmp    $0x6,%r8b
  7087db:	41 0f 92 c1          	setb   %r9b
  7087df:	41 0f 93 c2          	setae  %r10b
  7087e3:	41 38 d0             	cmp    %dl,%r8b
  7087e6:	41 0f 94 c3          	sete   %r11b
  7087ea:	45 20 d3             	and    %r10b,%r11b
  7087ed:	80 fa 06             	cmp    $0x6,%dl
  7087f0:	45 0f b6 d3          	movzbl %r11b,%r10d
  7087f4:	45 0f 43 ca          	cmovae %r10d,%r9d
  7087f8:	45 84 c9             	test   %r9b,%r9b
  7087fb:	74 65                	je     708862 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  7087fd:	41 80 f8 05          	cmp    $0x5,%r8b
  708801:	77 2b                	ja     70882e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x8e>
  708803:	41 38 d0             	cmp    %dl,%r8b
  708806:	75 5a                	jne    708862 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  708808:	44 0f b7 c1          	movzwl %cx,%r8d
  70880c:	80 fa 05             	cmp    $0x5,%dl
  70880f:	74 0a                	je     70881b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x7b>
  708811:	44 0f b6 ca          	movzbl %dl,%r9d
  708815:	41 83 f9 04          	cmp    $0x4,%r9d
  708819:	75 13                	jne    70882e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x8e>
  70881b:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  70881f:	75 41                	jne    708862 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  708821:	41 89 d0             	mov    %edx,%r8d
  708824:	41 c1 e8 10          	shr    $0x10,%r8d
  708828:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  70882c:	75 34                	jne    708862 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  70882e:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  708835:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  70883c:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  708843:	00 
  708844:	74 3a                	je     708880 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe0>
  708846:	84 c0                	test   %al,%al
  708848:	74 0a                	je     708854 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xb4>
  70884a:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  708851:	ff 
  708852:	74 2c                	je     708880 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe0>
  708854:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  70885b:	b9 01 00 00 00       	mov    $0x1,%ecx
  708860:	eb 20                	jmp    708882 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe2>
  708862:	88 50 13             	mov    %dl,0x13(%rax)
  708865:	66 89 48 14          	mov    %cx,0x14(%rax)
  708869:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  708870:	00 00 00 00 
  708874:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  70887b:	e9 40 f9 01 00       	jmp    7281c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  708880:	31 c9                	xor    %ecx,%ecx
  708882:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  708889:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70888d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  708891:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  708895:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  708899:	88 47 30             	mov    %al,0x30(%rdi)
  70889c:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  7088a3:	c3                   	ret
  7088a4:	50                   	push   %rax
  7088a5:	48 8d 3d 19 1b 96 ff 	lea    -0x69e4e7(%rip),%rdi        # 6a3c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32d8>
  7088ac:	48 8d 15 dd 13 3f 00 	lea    0x3f13dd(%rip),%rdx        # af9c90 <__frame_dummy_init_array_entry+0x768>
  7088b3:	be 11 00 00 00       	mov    $0x11,%esi
  7088b8:	ff 15 42 f7 41 00    	call   *0x41f742(%rip)        # b28000 <_DYNAMIC+0x348>
