
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fdac0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused>:
  6fdac0:	55                   	push   %rbp
  6fdac1:	41 57                	push   %r15
  6fdac3:	41 56                	push   %r14
  6fdac5:	41 55                	push   %r13
  6fdac7:	41 54                	push   %r12
  6fdac9:	53                   	push   %rbx
  6fdaca:	48 83 ec 48          	sub    $0x48,%rsp
  6fdace:	4d 89 cf             	mov    %r9,%r15
  6fdad1:	49 89 f6             	mov    %rsi,%r14
  6fdad4:	49 89 fc             	mov    %rdi,%r12
  6fdad7:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  6fdade:	00 
  6fdadf:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  6fdae6:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  6fdaed:	48 85 c0             	test   %rax,%rax
  6fdaf0:	74 12                	je     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdaf2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fdaf9:	48 85 c0             	test   %rax,%rax
  6fdafc:	74 06                	je     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdafe:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fdb02:	75 5a                	jne    6fdb5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x9e>
  6fdb04:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  6fdb0b:	00 00 
  6fdb0d:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fdb12:	4c 89 e7             	mov    %r12,%rdi
  6fdb15:	4c 89 f6             	mov    %r14,%rsi
  6fdb18:	e8 b3 09 00 00       	call   6fe4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>
  6fdb1d:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fdb22:	74 2b                	je     6fdb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdb24:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  6fdb2b:	75 22                	jne    6fdb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdb2d:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  6fdb34:	01 
  6fdb35:	75 18                	jne    6fdb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdb37:	41 80 be 22 07 00 00 	cmpb   $0x0,0x722(%r14)
  6fdb3e:	00 
  6fdb3f:	75 0e                	jne    6fdb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdb41:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  6fdb48:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  6fdb4f:	48 83 c4 48          	add    $0x48,%rsp
  6fdb53:	5b                   	pop    %rbx
  6fdb54:	41 5c                	pop    %r12
  6fdb56:	41 5d                	pop    %r13
  6fdb58:	41 5e                	pop    %r14
  6fdb5a:	41 5f                	pop    %r15
  6fdb5c:	5d                   	pop    %rbp
  6fdb5d:	c3                   	ret
  6fdb5e:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  6fdb65:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  6fdb6a:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  6fdb71:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fdb76:	48 8b 30             	mov    (%rax),%rsi
  6fdb79:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  6fdb80:	48 85 c0             	test   %rax,%rax
  6fdb83:	0f 84 9b 00 00 00    	je     6fdc24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x164>
  6fdb89:	83 f8 01             	cmp    $0x1,%eax
  6fdb8c:	0f 85 ae 00 00 00    	jne    6fdc40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x180>
  6fdb92:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  6fdb99:	4d 85 c9             	test   %r9,%r9
  6fdb9c:	0f 84 62 ff ff ff    	je     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdba2:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fdba9:	31 ff                	xor    %edi,%edi
  6fdbab:	49 83 f9 01          	cmp    $0x1,%r9
  6fdbaf:	74 33                	je     6fdbe4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x124>
  6fdbb1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6fdbb8:	0f 1f 84 00 00 00 00 
  6fdbbf:	00 
  6fdbc0:	49 89 fa             	mov    %rdi,%r10
  6fdbc3:	4d 89 cb             	mov    %r9,%r11
  6fdbc6:	49 d1 eb             	shr    $1,%r11
  6fdbc9:	4c 01 df             	add    %r11,%rdi
  6fdbcc:	48 89 fb             	mov    %rdi,%rbx
  6fdbcf:	48 c1 e3 04          	shl    $0x4,%rbx
  6fdbd3:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  6fdbd7:	49 0f 47 fa          	cmova  %r10,%rdi
  6fdbdb:	4d 29 d9             	sub    %r11,%r9
  6fdbde:	49 83 f9 01          	cmp    $0x1,%r9
  6fdbe2:	77 dc                	ja     6fdbc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x100>
  6fdbe4:	49 89 fa             	mov    %rdi,%r10
  6fdbe7:	49 c1 e2 04          	shl    $0x4,%r10
  6fdbeb:	45 31 c9             	xor    %r9d,%r9d
  6fdbee:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  6fdbf2:	41 0f 96 c1          	setbe  %r9b
  6fdbf6:	49 01 f9             	add    %rdi,%r9
  6fdbf9:	0f 84 05 ff ff ff    	je     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdbff:	49 c1 e1 04          	shl    $0x4,%r9
  6fdc03:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  6fdc08:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  6fdc0d:	48 39 fe             	cmp    %rdi,%rsi
  6fdc10:	0f 83 ee fe ff ff    	jae    6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdc16:	4c 01 c8             	add    %r9,%rax
  6fdc19:	8b 40 f8             	mov    -0x8(%rax),%eax
  6fdc1c:	48 01 c6             	add    %rax,%rsi
  6fdc1f:	e9 82 00 00 00       	jmp    6fdca6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e6>
  6fdc24:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  6fdc2b:	0f 82 d3 fe ff ff    	jb     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdc31:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  6fdc38:	0f 83 c6 fe ff ff    	jae    6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdc3e:	eb 66                	jmp    6fdca6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e6>
  6fdc40:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  6fdc47:	48 85 ff             	test   %rdi,%rdi
  6fdc4a:	0f 84 b4 fe ff ff    	je     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdc50:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fdc57:	48 83 ff 01          	cmp    $0x1,%rdi
  6fdc5b:	75 0b                	jne    6fdc68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1a8>
  6fdc5d:	48 39 30             	cmp    %rsi,(%rax)
  6fdc60:	0f 85 9e fe ff ff    	jne    6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdc66:	eb 3b                	jmp    6fdca3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e3>
  6fdc68:	45 31 c9             	xor    %r9d,%r9d
  6fdc6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6fdc70:	4d 89 ca             	mov    %r9,%r10
  6fdc73:	49 89 fb             	mov    %rdi,%r11
  6fdc76:	49 d1 eb             	shr    $1,%r11
  6fdc79:	4d 01 d9             	add    %r11,%r9
  6fdc7c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  6fdc80:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  6fdc84:	4d 0f 47 ca          	cmova  %r10,%r9
  6fdc88:	4c 29 df             	sub    %r11,%rdi
  6fdc8b:	48 83 ff 01          	cmp    $0x1,%rdi
  6fdc8f:	77 df                	ja     6fdc70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1b0>
  6fdc91:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  6fdc95:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  6fdc99:	0f 85 65 fe ff ff    	jne    6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdc9f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  6fdca3:	8b 70 08             	mov    0x8(%rax),%esi
  6fdca6:	4c 89 f7             	mov    %r14,%rdi
  6fdca9:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  6fdcae:	4c 89 c5             	mov    %r8,%rbp
  6fdcb1:	48 89 cb             	mov    %rcx,%rbx
  6fdcb4:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  6fdcb9:	49 89 d7             	mov    %rdx,%r15
  6fdcbc:	e8 ff 47 00 00       	call   7024c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::editing_at>
  6fdcc1:	4c 89 fa             	mov    %r15,%rdx
  6fdcc4:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6fdcc9:	48 89 d9             	mov    %rbx,%rcx
  6fdccc:	49 89 e8             	mov    %rbp,%r8
  6fdccf:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  6fdcd4:	48 85 c0             	test   %rax,%rax
  6fdcd7:	0f 84 27 fe ff ff    	je     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdcdd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fdce1:	0f 84 1d fe ff ff    	je     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdce7:	48 8b 38             	mov    (%rax),%rdi
  6fdcea:	4d 85 ff             	test   %r15,%r15
  6fdced:	74 19                	je     6fdd08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x248>
  6fdcef:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  6fdcf6:	4c 31 fe             	xor    %r15,%rsi
  6fdcf9:	49 89 e9             	mov    %rbp,%r9
  6fdcfc:	49 31 f9             	xor    %rdi,%r9
  6fdcff:	49 09 f1             	or     %rsi,%r9
  6fdd02:	40 0f 94 c6          	sete   %sil
  6fdd06:	eb 02                	jmp    6fdd0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x24a>
  6fdd08:	31 f6                	xor    %esi,%esi
  6fdd0a:	44 8b 48 18          	mov    0x18(%rax),%r9d
  6fdd0e:	8b 40 20             	mov    0x20(%rax),%eax
  6fdd11:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  6fdd18:	4d 85 d2             	test   %r10,%r10
  6fdd1b:	74 17                	je     6fdd34 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x274>
  6fdd1d:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  6fdd24:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  6fdd2b:	4c 09 d7             	or     %r10,%rdi
  6fdd2e:	40 0f 94 c7          	sete   %dil
  6fdd32:	eb 02                	jmp    6fdd36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x276>
  6fdd34:	31 ff                	xor    %edi,%edi
  6fdd36:	41 39 c1             	cmp    %eax,%r9d
  6fdd39:	0f 85 c5 fd ff ff    	jne    6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd3f:	40 30 fe             	xor    %dil,%sil
  6fdd42:	0f 84 bc fd ff ff    	je     6fdb04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd48:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  6fdd4f:	00 00 
  6fdd51:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fdd56:	4c 89 e7             	mov    %r12,%rdi
  6fdd59:	4c 89 f6             	mov    %r14,%rsi
  6fdd5c:	e8 6f 07 00 00       	call   6fe4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>
  6fdd61:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fdd66:	0f 85 b8 fd ff ff    	jne    6fdb24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x64>
  6fdd6c:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  6fdd73:	48 85 c0             	test   %rax,%rax
  6fdd76:	74 2a                	je     6fdda2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x2e2>
  6fdd78:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fdd7e:	0f 84 cb fd ff ff    	je     6fdb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdd84:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  6fdd89:	0f 85 c0 fd ff ff    	jne    6fdb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdd8f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fdd94:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  6fdd9b:	74 11                	je     6fddae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x2ee>
  6fdd9d:	e9 ad fd ff ff       	jmp    6fdb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdda2:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fdda8:	0f 85 a1 fd ff ff    	jne    6fdb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fddae:	4c 89 e7             	mov    %r12,%rdi
  6fddb1:	4c 89 f6             	mov    %r14,%rsi
  6fddb4:	4c 89 fa             	mov    %r15,%rdx
  6fddb7:	48 89 e9             	mov    %rbp,%rcx
  6fddba:	48 83 c4 48          	add    $0x48,%rsp
  6fddbe:	5b                   	pop    %rbx
  6fddbf:	41 5c                	pop    %r12
  6fddc1:	41 5d                	pop    %r13
  6fddc3:	41 5e                	pop    %r14
  6fddc5:	41 5f                	pop    %r15
  6fddc7:	5d                   	pop    %rbp
  6fddc8:	e9 d3 7e 00 00       	jmp    705ca0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>
