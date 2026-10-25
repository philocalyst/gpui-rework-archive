
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000709b00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>:
  709b00:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  709b07:	48 85 c0             	test   %rax,%rax
  709b0a:	0f 84 f4 00 00 00    	je     709c04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x104>
  709b10:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  709b17:	48 85 c0             	test   %rax,%rax
  709b1a:	0f 84 e4 00 00 00    	je     709c04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x104>
  709b20:	89 d1                	mov    %edx,%ecx
  709b22:	c1 e9 08             	shr    $0x8,%ecx
  709b25:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  709b2a:	41 80 f8 ff          	cmp    $0xff,%r8b
  709b2e:	0f 84 8e 00 00 00    	je     709bc2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709b34:	45 31 c9             	xor    %r9d,%r9d
  709b37:	41 80 f8 06          	cmp    $0x6,%r8b
  709b3b:	41 0f 92 c1          	setb   %r9b
  709b3f:	41 0f 93 c2          	setae  %r10b
  709b43:	41 38 d0             	cmp    %dl,%r8b
  709b46:	41 0f 94 c3          	sete   %r11b
  709b4a:	45 20 d3             	and    %r10b,%r11b
  709b4d:	80 fa 06             	cmp    $0x6,%dl
  709b50:	45 0f b6 d3          	movzbl %r11b,%r10d
  709b54:	45 0f 43 ca          	cmovae %r10d,%r9d
  709b58:	45 84 c9             	test   %r9b,%r9b
  709b5b:	74 65                	je     709bc2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709b5d:	41 80 f8 05          	cmp    $0x5,%r8b
  709b61:	77 2b                	ja     709b8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x8e>
  709b63:	41 38 d0             	cmp    %dl,%r8b
  709b66:	75 5a                	jne    709bc2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709b68:	44 0f b7 c1          	movzwl %cx,%r8d
  709b6c:	80 fa 05             	cmp    $0x5,%dl
  709b6f:	74 0a                	je     709b7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x7b>
  709b71:	44 0f b6 ca          	movzbl %dl,%r9d
  709b75:	41 83 f9 04          	cmp    $0x4,%r9d
  709b79:	75 13                	jne    709b8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x8e>
  709b7b:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  709b7f:	75 41                	jne    709bc2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709b81:	41 89 d0             	mov    %edx,%r8d
  709b84:	41 c1 e8 10          	shr    $0x10,%r8d
  709b88:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  709b8c:	75 34                	jne    709bc2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709b8e:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  709b95:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  709b9c:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  709ba3:	00 
  709ba4:	74 3a                	je     709be0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe0>
  709ba6:	84 c0                	test   %al,%al
  709ba8:	74 0a                	je     709bb4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xb4>
  709baa:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  709bb1:	ff 
  709bb2:	74 2c                	je     709be0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe0>
  709bb4:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  709bbb:	b9 01 00 00 00       	mov    $0x1,%ecx
  709bc0:	eb 20                	jmp    709be2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe2>
  709bc2:	88 50 13             	mov    %dl,0x13(%rax)
  709bc5:	66 89 48 14          	mov    %cx,0x14(%rax)
  709bc9:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  709bd0:	00 00 00 00 
  709bd4:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  709bdb:	e9 40 f9 01 00       	jmp    729520 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  709be0:	31 c9                	xor    %ecx,%ecx
  709be2:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  709be9:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  709bed:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  709bf1:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  709bf5:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  709bf9:	88 47 30             	mov    %al,0x30(%rdi)
  709bfc:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  709c03:	c3                   	ret
  709c04:	50                   	push   %rax
  709c05:	48 8d 3d b9 09 96 ff 	lea    -0x69f647(%rip),%rdi        # 6a5c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  709c0c:	48 8d 15 35 14 3f 00 	lea    0x3f1435(%rip),%rdx        # afb048 <__frame_dummy_init_array_entry+0x7b0>
  709c13:	be 11 00 00 00       	mov    $0x11,%esi
  709c18:	ff 15 2a f8 41 00    	call   *0x41f82a(%rip)        # b29448 <_DYNAMIC+0x348>
