
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000708cc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>:
  708cc0:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  708cc7:	48 85 c0             	test   %rax,%rax
  708cca:	0f 84 f4 00 00 00    	je     708dc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x104>
  708cd0:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  708cd7:	48 85 c0             	test   %rax,%rax
  708cda:	0f 84 e4 00 00 00    	je     708dc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x104>
  708ce0:	89 d1                	mov    %edx,%ecx
  708ce2:	c1 e9 08             	shr    $0x8,%ecx
  708ce5:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  708cea:	41 80 f8 ff          	cmp    $0xff,%r8b
  708cee:	0f 84 8e 00 00 00    	je     708d82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708cf4:	45 31 c9             	xor    %r9d,%r9d
  708cf7:	41 80 f8 06          	cmp    $0x6,%r8b
  708cfb:	41 0f 92 c1          	setb   %r9b
  708cff:	41 0f 93 c2          	setae  %r10b
  708d03:	41 38 d0             	cmp    %dl,%r8b
  708d06:	41 0f 94 c3          	sete   %r11b
  708d0a:	45 20 d3             	and    %r10b,%r11b
  708d0d:	80 fa 06             	cmp    $0x6,%dl
  708d10:	45 0f b6 d3          	movzbl %r11b,%r10d
  708d14:	45 0f 43 ca          	cmovae %r10d,%r9d
  708d18:	45 84 c9             	test   %r9b,%r9b
  708d1b:	74 65                	je     708d82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708d1d:	41 80 f8 05          	cmp    $0x5,%r8b
  708d21:	77 2b                	ja     708d4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x8e>
  708d23:	41 38 d0             	cmp    %dl,%r8b
  708d26:	75 5a                	jne    708d82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708d28:	44 0f b7 c1          	movzwl %cx,%r8d
  708d2c:	80 fa 05             	cmp    $0x5,%dl
  708d2f:	74 0a                	je     708d3b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x7b>
  708d31:	44 0f b6 ca          	movzbl %dl,%r9d
  708d35:	41 83 f9 04          	cmp    $0x4,%r9d
  708d39:	75 13                	jne    708d4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x8e>
  708d3b:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  708d3f:	75 41                	jne    708d82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708d41:	41 89 d0             	mov    %edx,%r8d
  708d44:	41 c1 e8 10          	shr    $0x10,%r8d
  708d48:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  708d4c:	75 34                	jne    708d82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708d4e:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  708d55:	0f b6 86 20 08 00 00 	movzbl 0x820(%rsi),%eax
  708d5c:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  708d63:	00 
  708d64:	74 3a                	je     708da0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe0>
  708d66:	84 c0                	test   %al,%al
  708d68:	74 0a                	je     708d74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xb4>
  708d6a:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  708d71:	ff 
  708d72:	74 2c                	je     708da0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe0>
  708d74:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  708d7b:	b9 01 00 00 00       	mov    $0x1,%ecx
  708d80:	eb 20                	jmp    708da2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe2>
  708d82:	88 50 13             	mov    %dl,0x13(%rax)
  708d85:	66 89 48 14          	mov    %cx,0x14(%rax)
  708d89:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  708d90:	00 00 00 00 
  708d94:	c6 86 1f 08 00 00 01 	movb   $0x1,0x81f(%rsi)
  708d9b:	e9 50 1f 01 00       	jmp    71acf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  708da0:	31 c9                	xor    %ecx,%ecx
  708da2:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  708da9:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  708dad:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  708db1:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  708db5:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  708db9:	88 47 30             	mov    %al,0x30(%rdi)
  708dbc:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  708dc3:	c3                   	ret
  708dc4:	50                   	push   %rax
  708dc5:	48 8d 3d 09 18 96 ff 	lea    -0x69e7f7(%rip),%rdi        # 6a5d5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  708dcc:	48 8d 15 e5 22 3f 00 	lea    0x3f22e5(%rip),%rdx        # afb0b8 <__frame_dummy_init_array_entry+0x7b0>
  708dd3:	be 11 00 00 00       	mov    $0x11,%esi
  708dd8:	ff 15 da 06 42 00    	call   *0x4206da(%rip)        # b294b8 <_DYNAMIC+0x348>
