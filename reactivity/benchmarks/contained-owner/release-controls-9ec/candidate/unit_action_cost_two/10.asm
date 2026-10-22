
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000708c50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>:
  708c50:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  708c57:	48 85 c0             	test   %rax,%rax
  708c5a:	0f 84 f4 00 00 00    	je     708d54 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x104>
  708c60:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  708c67:	48 85 c0             	test   %rax,%rax
  708c6a:	0f 84 e4 00 00 00    	je     708d54 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x104>
  708c70:	89 d1                	mov    %edx,%ecx
  708c72:	c1 e9 08             	shr    $0x8,%ecx
  708c75:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  708c7a:	41 80 f8 ff          	cmp    $0xff,%r8b
  708c7e:	0f 84 8e 00 00 00    	je     708d12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708c84:	45 31 c9             	xor    %r9d,%r9d
  708c87:	41 80 f8 06          	cmp    $0x6,%r8b
  708c8b:	41 0f 92 c1          	setb   %r9b
  708c8f:	41 0f 93 c2          	setae  %r10b
  708c93:	41 38 d0             	cmp    %dl,%r8b
  708c96:	41 0f 94 c3          	sete   %r11b
  708c9a:	45 20 d3             	and    %r10b,%r11b
  708c9d:	80 fa 06             	cmp    $0x6,%dl
  708ca0:	45 0f b6 d3          	movzbl %r11b,%r10d
  708ca4:	45 0f 43 ca          	cmovae %r10d,%r9d
  708ca8:	45 84 c9             	test   %r9b,%r9b
  708cab:	74 65                	je     708d12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708cad:	41 80 f8 05          	cmp    $0x5,%r8b
  708cb1:	77 2b                	ja     708cde <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x8e>
  708cb3:	41 38 d0             	cmp    %dl,%r8b
  708cb6:	75 5a                	jne    708d12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708cb8:	44 0f b7 c1          	movzwl %cx,%r8d
  708cbc:	80 fa 05             	cmp    $0x5,%dl
  708cbf:	74 0a                	je     708ccb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x7b>
  708cc1:	44 0f b6 ca          	movzbl %dl,%r9d
  708cc5:	41 83 f9 04          	cmp    $0x4,%r9d
  708cc9:	75 13                	jne    708cde <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x8e>
  708ccb:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  708ccf:	75 41                	jne    708d12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708cd1:	41 89 d0             	mov    %edx,%r8d
  708cd4:	41 c1 e8 10          	shr    $0x10,%r8d
  708cd8:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  708cdc:	75 34                	jne    708d12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  708cde:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  708ce5:	0f b6 86 20 08 00 00 	movzbl 0x820(%rsi),%eax
  708cec:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  708cf3:	00 
  708cf4:	74 3a                	je     708d30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe0>
  708cf6:	84 c0                	test   %al,%al
  708cf8:	74 0a                	je     708d04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xb4>
  708cfa:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  708d01:	ff 
  708d02:	74 2c                	je     708d30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe0>
  708d04:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  708d0b:	b9 01 00 00 00       	mov    $0x1,%ecx
  708d10:	eb 20                	jmp    708d32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe2>
  708d12:	88 50 13             	mov    %dl,0x13(%rax)
  708d15:	66 89 48 14          	mov    %cx,0x14(%rax)
  708d19:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  708d20:	00 00 00 00 
  708d24:	c6 86 1f 08 00 00 01 	movb   $0x1,0x81f(%rsi)
  708d2b:	e9 50 1f 01 00       	jmp    71ac80 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  708d30:	31 c9                	xor    %ecx,%ecx
  708d32:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  708d39:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  708d3d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  708d41:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  708d45:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  708d49:	88 47 30             	mov    %al,0x30(%rdi)
  708d4c:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  708d53:	c3                   	ret
  708d54:	50                   	push   %rax
  708d55:	48 8d 3d 69 18 96 ff 	lea    -0x69e797(%rip),%rdi        # 6a5c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  708d5c:	48 8d 15 e5 22 3f 00 	lea    0x3f22e5(%rip),%rdx        # afb048 <__frame_dummy_init_array_entry+0x7b0>
  708d63:	be 11 00 00 00       	mov    $0x11,%esi
  708d68:	ff 15 da 06 42 00    	call   *0x4206da(%rip)        # b29448 <_DYNAMIC+0x348>
