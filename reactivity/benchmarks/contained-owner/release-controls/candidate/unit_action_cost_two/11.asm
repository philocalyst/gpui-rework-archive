
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000709b70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>:
  709b70:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  709b77:	48 85 c0             	test   %rax,%rax
  709b7a:	0f 84 f4 00 00 00    	je     709c74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x104>
  709b80:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  709b87:	48 85 c0             	test   %rax,%rax
  709b8a:	0f 84 e4 00 00 00    	je     709c74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x104>
  709b90:	89 d1                	mov    %edx,%ecx
  709b92:	c1 e9 08             	shr    $0x8,%ecx
  709b95:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  709b9a:	41 80 f8 ff          	cmp    $0xff,%r8b
  709b9e:	0f 84 8e 00 00 00    	je     709c32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709ba4:	45 31 c9             	xor    %r9d,%r9d
  709ba7:	41 80 f8 06          	cmp    $0x6,%r8b
  709bab:	41 0f 92 c1          	setb   %r9b
  709baf:	41 0f 93 c2          	setae  %r10b
  709bb3:	41 38 d0             	cmp    %dl,%r8b
  709bb6:	41 0f 94 c3          	sete   %r11b
  709bba:	45 20 d3             	and    %r10b,%r11b
  709bbd:	80 fa 06             	cmp    $0x6,%dl
  709bc0:	45 0f b6 d3          	movzbl %r11b,%r10d
  709bc4:	45 0f 43 ca          	cmovae %r10d,%r9d
  709bc8:	45 84 c9             	test   %r9b,%r9b
  709bcb:	74 65                	je     709c32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709bcd:	41 80 f8 05          	cmp    $0x5,%r8b
  709bd1:	77 2b                	ja     709bfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x8e>
  709bd3:	41 38 d0             	cmp    %dl,%r8b
  709bd6:	75 5a                	jne    709c32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709bd8:	44 0f b7 c1          	movzwl %cx,%r8d
  709bdc:	80 fa 05             	cmp    $0x5,%dl
  709bdf:	74 0a                	je     709beb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x7b>
  709be1:	44 0f b6 ca          	movzbl %dl,%r9d
  709be5:	41 83 f9 04          	cmp    $0x4,%r9d
  709be9:	75 13                	jne    709bfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0x8e>
  709beb:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  709bef:	75 41                	jne    709c32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709bf1:	41 89 d0             	mov    %edx,%r8d
  709bf4:	41 c1 e8 10          	shr    $0x10,%r8d
  709bf8:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  709bfc:	75 34                	jne    709c32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xc2>
  709bfe:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  709c05:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  709c0c:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  709c13:	00 
  709c14:	74 3a                	je     709c50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe0>
  709c16:	84 c0                	test   %al,%al
  709c18:	74 0a                	je     709c24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xb4>
  709c1a:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  709c21:	ff 
  709c22:	74 2c                	je     709c50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe0>
  709c24:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  709c2b:	b9 01 00 00 00       	mov    $0x1,%ecx
  709c30:	eb 20                	jmp    709c52 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor+0xe2>
  709c32:	88 50 13             	mov    %dl,0x13(%rax)
  709c35:	66 89 48 14          	mov    %cx,0x14(%rax)
  709c39:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  709c40:	00 00 00 00 
  709c44:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  709c4b:	e9 40 f9 01 00       	jmp    729590 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  709c50:	31 c9                	xor    %ecx,%ecx
  709c52:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  709c59:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  709c5d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  709c61:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  709c65:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  709c69:	88 47 30             	mov    %al,0x30(%rdi)
  709c6c:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  709c73:	c3                   	ret
  709c74:	50                   	push   %rax
  709c75:	48 8d 3d 59 09 96 ff 	lea    -0x69f6a7(%rip),%rdi        # 6a5d5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  709c7c:	48 8d 15 35 14 3f 00 	lea    0x3f1435(%rip),%rdx        # afb0b8 <__frame_dummy_init_array_entry+0x7b0>
  709c83:	be 11 00 00 00       	mov    $0x11,%esi
  709c88:	ff 15 2a f8 41 00    	call   *0x41f82a(%rip)        # b294b8 <_DYNAMIC+0x348>
