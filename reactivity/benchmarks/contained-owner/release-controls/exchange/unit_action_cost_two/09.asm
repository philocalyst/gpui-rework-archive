
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000709a70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>:
  709a70:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  709a77:	48 85 c0             	test   %rax,%rax
  709a7a:	0f 84 f4 00 00 00    	je     709b74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x104>
  709a80:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  709a87:	48 85 c0             	test   %rax,%rax
  709a8a:	0f 84 e4 00 00 00    	je     709b74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x104>
  709a90:	89 d1                	mov    %edx,%ecx
  709a92:	c1 e9 08             	shr    $0x8,%ecx
  709a95:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  709a9a:	41 80 f8 ff          	cmp    $0xff,%r8b
  709a9e:	0f 84 8e 00 00 00    	je     709b32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709aa4:	45 31 c9             	xor    %r9d,%r9d
  709aa7:	41 80 f8 06          	cmp    $0x6,%r8b
  709aab:	41 0f 92 c1          	setb   %r9b
  709aaf:	41 0f 93 c2          	setae  %r10b
  709ab3:	41 38 d0             	cmp    %dl,%r8b
  709ab6:	41 0f 94 c3          	sete   %r11b
  709aba:	45 20 d3             	and    %r10b,%r11b
  709abd:	80 fa 06             	cmp    $0x6,%dl
  709ac0:	45 0f b6 d3          	movzbl %r11b,%r10d
  709ac4:	45 0f 43 ca          	cmovae %r10d,%r9d
  709ac8:	45 84 c9             	test   %r9b,%r9b
  709acb:	74 65                	je     709b32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709acd:	41 80 f8 05          	cmp    $0x5,%r8b
  709ad1:	77 2b                	ja     709afe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x8e>
  709ad3:	41 38 d0             	cmp    %dl,%r8b
  709ad6:	75 5a                	jne    709b32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709ad8:	44 0f b7 c1          	movzwl %cx,%r8d
  709adc:	80 fa 05             	cmp    $0x5,%dl
  709adf:	74 0a                	je     709aeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x7b>
  709ae1:	44 0f b6 ca          	movzbl %dl,%r9d
  709ae5:	41 83 f9 04          	cmp    $0x4,%r9d
  709ae9:	75 13                	jne    709afe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x8e>
  709aeb:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  709aef:	75 41                	jne    709b32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709af1:	41 89 d0             	mov    %edx,%r8d
  709af4:	41 c1 e8 10          	shr    $0x10,%r8d
  709af8:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  709afc:	75 34                	jne    709b32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709afe:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  709b05:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  709b0c:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  709b13:	00 
  709b14:	74 3a                	je     709b50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe0>
  709b16:	84 c0                	test   %al,%al
  709b18:	74 0a                	je     709b24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xb4>
  709b1a:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  709b21:	ff 
  709b22:	74 2c                	je     709b50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe0>
  709b24:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  709b2b:	b9 01 00 00 00       	mov    $0x1,%ecx
  709b30:	eb 20                	jmp    709b52 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe2>
  709b32:	88 50 13             	mov    %dl,0x13(%rax)
  709b35:	66 89 48 14          	mov    %cx,0x14(%rax)
  709b39:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  709b40:	00 00 00 00 
  709b44:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  709b4b:	e9 40 f9 01 00       	jmp    729490 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  709b50:	31 c9                	xor    %ecx,%ecx
  709b52:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  709b59:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  709b5d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  709b61:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  709b65:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  709b69:	88 47 30             	mov    %al,0x30(%rdi)
  709b6c:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  709b73:	c3                   	ret
  709b74:	50                   	push   %rax
  709b75:	48 8d 3d e9 09 96 ff 	lea    -0x69f617(%rip),%rdi        # 6a565 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  709b7c:	48 8d 15 95 14 3f 00 	lea    0x3f1495(%rip),%rdx        # afb018 <__frame_dummy_init_array_entry+0x7b0>
  709b83:	be 11 00 00 00       	mov    $0x11,%esi
  709b88:	ff 15 42 f8 41 00    	call   *0x41f842(%rip)        # b293d0 <_DYNAMIC+0x348>
