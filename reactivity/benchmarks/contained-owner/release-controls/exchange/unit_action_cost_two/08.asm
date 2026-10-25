
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000708bc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>:
  708bc0:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  708bc7:	48 85 c0             	test   %rax,%rax
  708bca:	0f 84 f4 00 00 00    	je     708cc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x104>
  708bd0:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  708bd7:	48 85 c0             	test   %rax,%rax
  708bda:	0f 84 e4 00 00 00    	je     708cc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x104>
  708be0:	89 d1                	mov    %edx,%ecx
  708be2:	c1 e9 08             	shr    $0x8,%ecx
  708be5:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  708bea:	41 80 f8 ff          	cmp    $0xff,%r8b
  708bee:	0f 84 8e 00 00 00    	je     708c82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708bf4:	45 31 c9             	xor    %r9d,%r9d
  708bf7:	41 80 f8 06          	cmp    $0x6,%r8b
  708bfb:	41 0f 92 c1          	setb   %r9b
  708bff:	41 0f 93 c2          	setae  %r10b
  708c03:	41 38 d0             	cmp    %dl,%r8b
  708c06:	41 0f 94 c3          	sete   %r11b
  708c0a:	45 20 d3             	and    %r10b,%r11b
  708c0d:	80 fa 06             	cmp    $0x6,%dl
  708c10:	45 0f b6 d3          	movzbl %r11b,%r10d
  708c14:	45 0f 43 ca          	cmovae %r10d,%r9d
  708c18:	45 84 c9             	test   %r9b,%r9b
  708c1b:	74 65                	je     708c82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708c1d:	41 80 f8 05          	cmp    $0x5,%r8b
  708c21:	77 2b                	ja     708c4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x8e>
  708c23:	41 38 d0             	cmp    %dl,%r8b
  708c26:	75 5a                	jne    708c82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708c28:	44 0f b7 c1          	movzwl %cx,%r8d
  708c2c:	80 fa 05             	cmp    $0x5,%dl
  708c2f:	74 0a                	je     708c3b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x7b>
  708c31:	44 0f b6 ca          	movzbl %dl,%r9d
  708c35:	41 83 f9 04          	cmp    $0x4,%r9d
  708c39:	75 13                	jne    708c4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x8e>
  708c3b:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  708c3f:	75 41                	jne    708c82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708c41:	41 89 d0             	mov    %edx,%r8d
  708c44:	41 c1 e8 10          	shr    $0x10,%r8d
  708c48:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  708c4c:	75 34                	jne    708c82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708c4e:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  708c55:	0f b6 86 20 08 00 00 	movzbl 0x820(%rsi),%eax
  708c5c:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  708c63:	00 
  708c64:	74 3a                	je     708ca0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe0>
  708c66:	84 c0                	test   %al,%al
  708c68:	74 0a                	je     708c74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xb4>
  708c6a:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  708c71:	ff 
  708c72:	74 2c                	je     708ca0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe0>
  708c74:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  708c7b:	b9 01 00 00 00       	mov    $0x1,%ecx
  708c80:	eb 20                	jmp    708ca2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe2>
  708c82:	88 50 13             	mov    %dl,0x13(%rax)
  708c85:	66 89 48 14          	mov    %cx,0x14(%rax)
  708c89:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  708c90:	00 00 00 00 
  708c94:	c6 86 1f 08 00 00 01 	movb   $0x1,0x81f(%rsi)
  708c9b:	e9 50 1f 01 00       	jmp    71abf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  708ca0:	31 c9                	xor    %ecx,%ecx
  708ca2:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  708ca9:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  708cad:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  708cb1:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  708cb5:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  708cb9:	88 47 30             	mov    %al,0x30(%rdi)
  708cbc:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  708cc3:	c3                   	ret
  708cc4:	50                   	push   %rax
  708cc5:	48 8d 3d 99 18 96 ff 	lea    -0x69e767(%rip),%rdi        # 6a565 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  708ccc:	48 8d 15 45 23 3f 00 	lea    0x3f2345(%rip),%rdx        # afb018 <__frame_dummy_init_array_entry+0x7b0>
  708cd3:	be 11 00 00 00       	mov    $0x11,%esi
  708cd8:	ff 15 f2 06 42 00    	call   *0x4206f2(%rip)        # b293d0 <_DYNAMIC+0x348>
