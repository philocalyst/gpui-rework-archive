
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fdb80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused>:
  6fdb80:	55                   	push   %rbp
  6fdb81:	41 57                	push   %r15
  6fdb83:	41 56                	push   %r14
  6fdb85:	41 55                	push   %r13
  6fdb87:	41 54                	push   %r12
  6fdb89:	53                   	push   %rbx
  6fdb8a:	48 83 ec 48          	sub    $0x48,%rsp
  6fdb8e:	4d 89 cf             	mov    %r9,%r15
  6fdb91:	49 89 f6             	mov    %rsi,%r14
  6fdb94:	49 89 fc             	mov    %rdi,%r12
  6fdb97:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  6fdb9e:	00 
  6fdb9f:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  6fdba6:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  6fdbad:	48 85 c0             	test   %rax,%rax
  6fdbb0:	74 12                	je     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdbb2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fdbb9:	48 85 c0             	test   %rax,%rax
  6fdbbc:	74 06                	je     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdbbe:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fdbc2:	75 5a                	jne    6fdc1e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x9e>
  6fdbc4:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  6fdbcb:	00 00 
  6fdbcd:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fdbd2:	4c 89 e7             	mov    %r12,%rdi
  6fdbd5:	4c 89 f6             	mov    %r14,%rsi
  6fdbd8:	e8 83 09 00 00       	call   6fe560 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>
  6fdbdd:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fdbe2:	74 2b                	je     6fdc0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdbe4:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  6fdbeb:	75 22                	jne    6fdc0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdbed:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  6fdbf4:	01 
  6fdbf5:	75 18                	jne    6fdc0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdbf7:	41 80 be 22 07 00 00 	cmpb   $0x0,0x722(%r14)
  6fdbfe:	00 
  6fdbff:	75 0e                	jne    6fdc0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdc01:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  6fdc08:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  6fdc0f:	48 83 c4 48          	add    $0x48,%rsp
  6fdc13:	5b                   	pop    %rbx
  6fdc14:	41 5c                	pop    %r12
  6fdc16:	41 5d                	pop    %r13
  6fdc18:	41 5e                	pop    %r14
  6fdc1a:	41 5f                	pop    %r15
  6fdc1c:	5d                   	pop    %rbp
  6fdc1d:	c3                   	ret
  6fdc1e:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  6fdc25:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  6fdc2a:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  6fdc31:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fdc36:	48 8b 30             	mov    (%rax),%rsi
  6fdc39:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  6fdc40:	48 85 c0             	test   %rax,%rax
  6fdc43:	0f 84 9b 00 00 00    	je     6fdce4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x164>
  6fdc49:	83 f8 01             	cmp    $0x1,%eax
  6fdc4c:	0f 85 ae 00 00 00    	jne    6fdd00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x180>
  6fdc52:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  6fdc59:	4d 85 c9             	test   %r9,%r9
  6fdc5c:	0f 84 62 ff ff ff    	je     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdc62:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fdc69:	31 ff                	xor    %edi,%edi
  6fdc6b:	49 83 f9 01          	cmp    $0x1,%r9
  6fdc6f:	74 33                	je     6fdca4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x124>
  6fdc71:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6fdc78:	0f 1f 84 00 00 00 00 
  6fdc7f:	00 
  6fdc80:	49 89 fa             	mov    %rdi,%r10
  6fdc83:	4d 89 cb             	mov    %r9,%r11
  6fdc86:	49 d1 eb             	shr    $1,%r11
  6fdc89:	4c 01 df             	add    %r11,%rdi
  6fdc8c:	48 89 fb             	mov    %rdi,%rbx
  6fdc8f:	48 c1 e3 04          	shl    $0x4,%rbx
  6fdc93:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  6fdc97:	49 0f 47 fa          	cmova  %r10,%rdi
  6fdc9b:	4d 29 d9             	sub    %r11,%r9
  6fdc9e:	49 83 f9 01          	cmp    $0x1,%r9
  6fdca2:	77 dc                	ja     6fdc80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x100>
  6fdca4:	49 89 fa             	mov    %rdi,%r10
  6fdca7:	49 c1 e2 04          	shl    $0x4,%r10
  6fdcab:	45 31 c9             	xor    %r9d,%r9d
  6fdcae:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  6fdcb2:	41 0f 96 c1          	setbe  %r9b
  6fdcb6:	49 01 f9             	add    %rdi,%r9
  6fdcb9:	0f 84 05 ff ff ff    	je     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdcbf:	49 c1 e1 04          	shl    $0x4,%r9
  6fdcc3:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  6fdcc8:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  6fdccd:	48 39 fe             	cmp    %rdi,%rsi
  6fdcd0:	0f 83 ee fe ff ff    	jae    6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdcd6:	4c 01 c8             	add    %r9,%rax
  6fdcd9:	8b 40 f8             	mov    -0x8(%rax),%eax
  6fdcdc:	48 01 c6             	add    %rax,%rsi
  6fdcdf:	e9 82 00 00 00       	jmp    6fdd66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e6>
  6fdce4:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  6fdceb:	0f 82 d3 fe ff ff    	jb     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdcf1:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  6fdcf8:	0f 83 c6 fe ff ff    	jae    6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdcfe:	eb 66                	jmp    6fdd66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e6>
  6fdd00:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  6fdd07:	48 85 ff             	test   %rdi,%rdi
  6fdd0a:	0f 84 b4 fe ff ff    	je     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd10:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fdd17:	48 83 ff 01          	cmp    $0x1,%rdi
  6fdd1b:	75 0b                	jne    6fdd28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1a8>
  6fdd1d:	48 39 30             	cmp    %rsi,(%rax)
  6fdd20:	0f 85 9e fe ff ff    	jne    6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd26:	eb 3b                	jmp    6fdd63 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e3>
  6fdd28:	45 31 c9             	xor    %r9d,%r9d
  6fdd2b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6fdd30:	4d 89 ca             	mov    %r9,%r10
  6fdd33:	49 89 fb             	mov    %rdi,%r11
  6fdd36:	49 d1 eb             	shr    $1,%r11
  6fdd39:	4d 01 d9             	add    %r11,%r9
  6fdd3c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  6fdd40:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  6fdd44:	4d 0f 47 ca          	cmova  %r10,%r9
  6fdd48:	4c 29 df             	sub    %r11,%rdi
  6fdd4b:	48 83 ff 01          	cmp    $0x1,%rdi
  6fdd4f:	77 df                	ja     6fdd30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1b0>
  6fdd51:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  6fdd55:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  6fdd59:	0f 85 65 fe ff ff    	jne    6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd5f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  6fdd63:	8b 70 08             	mov    0x8(%rax),%esi
  6fdd66:	4c 89 f7             	mov    %r14,%rdi
  6fdd69:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  6fdd6e:	4c 89 c5             	mov    %r8,%rbp
  6fdd71:	48 89 cb             	mov    %rcx,%rbx
  6fdd74:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  6fdd79:	49 89 d7             	mov    %rdx,%r15
  6fdd7c:	e8 cf 47 00 00       	call   702550 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::editing_at>
  6fdd81:	4c 89 fa             	mov    %r15,%rdx
  6fdd84:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6fdd89:	48 89 d9             	mov    %rbx,%rcx
  6fdd8c:	49 89 e8             	mov    %rbp,%r8
  6fdd8f:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  6fdd94:	48 85 c0             	test   %rax,%rax
  6fdd97:	0f 84 27 fe ff ff    	je     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd9d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fdda1:	0f 84 1d fe ff ff    	je     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdda7:	48 8b 38             	mov    (%rax),%rdi
  6fddaa:	4d 85 ff             	test   %r15,%r15
  6fddad:	74 19                	je     6fddc8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x248>
  6fddaf:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  6fddb6:	4c 31 fe             	xor    %r15,%rsi
  6fddb9:	49 89 e9             	mov    %rbp,%r9
  6fddbc:	49 31 f9             	xor    %rdi,%r9
  6fddbf:	49 09 f1             	or     %rsi,%r9
  6fddc2:	40 0f 94 c6          	sete   %sil
  6fddc6:	eb 02                	jmp    6fddca <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x24a>
  6fddc8:	31 f6                	xor    %esi,%esi
  6fddca:	44 8b 48 18          	mov    0x18(%rax),%r9d
  6fddce:	8b 40 20             	mov    0x20(%rax),%eax
  6fddd1:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  6fddd8:	4d 85 d2             	test   %r10,%r10
  6fdddb:	74 17                	je     6fddf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x274>
  6fdddd:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  6fdde4:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  6fddeb:	4c 09 d7             	or     %r10,%rdi
  6fddee:	40 0f 94 c7          	sete   %dil
  6fddf2:	eb 02                	jmp    6fddf6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x276>
  6fddf4:	31 ff                	xor    %edi,%edi
  6fddf6:	41 39 c1             	cmp    %eax,%r9d
  6fddf9:	0f 85 c5 fd ff ff    	jne    6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fddff:	40 30 fe             	xor    %dil,%sil
  6fde02:	0f 84 bc fd ff ff    	je     6fdbc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fde08:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  6fde0f:	00 00 
  6fde11:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fde16:	4c 89 e7             	mov    %r12,%rdi
  6fde19:	4c 89 f6             	mov    %r14,%rsi
  6fde1c:	e8 3f 07 00 00       	call   6fe560 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>
  6fde21:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fde26:	0f 85 b8 fd ff ff    	jne    6fdbe4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x64>
  6fde2c:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  6fde33:	48 85 c0             	test   %rax,%rax
  6fde36:	74 2a                	je     6fde62 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x2e2>
  6fde38:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fde3e:	0f 84 cb fd ff ff    	je     6fdc0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fde44:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  6fde49:	0f 85 c0 fd ff ff    	jne    6fdc0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fde4f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fde54:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  6fde5b:	74 11                	je     6fde6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x2ee>
  6fde5d:	e9 ad fd ff ff       	jmp    6fdc0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fde62:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fde68:	0f 85 a1 fd ff ff    	jne    6fdc0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fde6e:	4c 89 e7             	mov    %r12,%rdi
  6fde71:	4c 89 f6             	mov    %r14,%rsi
  6fde74:	4c 89 fa             	mov    %r15,%rdx
  6fde77:	48 89 e9             	mov    %rbp,%rcx
  6fde7a:	48 83 c4 48          	add    $0x48,%rsp
  6fde7e:	5b                   	pop    %rbx
  6fde7f:	41 5c                	pop    %r12
  6fde81:	41 5d                	pop    %r13
  6fde83:	41 5e                	pop    %r14
  6fde85:	41 5f                	pop    %r15
  6fde87:	5d                   	pop    %rbp
  6fde88:	e9 a3 7e 00 00       	jmp    705d30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>
