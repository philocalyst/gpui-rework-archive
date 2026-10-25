
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fdbc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused>:
  6fdbc0:	55                   	push   %rbp
  6fdbc1:	41 57                	push   %r15
  6fdbc3:	41 56                	push   %r14
  6fdbc5:	41 55                	push   %r13
  6fdbc7:	41 54                	push   %r12
  6fdbc9:	53                   	push   %rbx
  6fdbca:	48 83 ec 48          	sub    $0x48,%rsp
  6fdbce:	4d 89 cf             	mov    %r9,%r15
  6fdbd1:	49 89 f6             	mov    %rsi,%r14
  6fdbd4:	49 89 fc             	mov    %rdi,%r12
  6fdbd7:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  6fdbde:	00 
  6fdbdf:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  6fdbe6:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  6fdbed:	48 85 c0             	test   %rax,%rax
  6fdbf0:	74 12                	je     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdbf2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fdbf9:	48 85 c0             	test   %rax,%rax
  6fdbfc:	74 06                	je     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdbfe:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fdc02:	75 5a                	jne    6fdc5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x9e>
  6fdc04:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  6fdc0b:	00 00 
  6fdc0d:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fdc12:	4c 89 e7             	mov    %r12,%rdi
  6fdc15:	4c 89 f6             	mov    %r14,%rsi
  6fdc18:	e8 b3 09 00 00       	call   6fe5d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>
  6fdc1d:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fdc22:	74 2b                	je     6fdc4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdc24:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  6fdc2b:	75 22                	jne    6fdc4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdc2d:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  6fdc34:	01 
  6fdc35:	75 18                	jne    6fdc4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdc37:	41 80 be 22 07 00 00 	cmpb   $0x0,0x722(%r14)
  6fdc3e:	00 
  6fdc3f:	75 0e                	jne    6fdc4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdc41:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  6fdc48:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  6fdc4f:	48 83 c4 48          	add    $0x48,%rsp
  6fdc53:	5b                   	pop    %rbx
  6fdc54:	41 5c                	pop    %r12
  6fdc56:	41 5d                	pop    %r13
  6fdc58:	41 5e                	pop    %r14
  6fdc5a:	41 5f                	pop    %r15
  6fdc5c:	5d                   	pop    %rbp
  6fdc5d:	c3                   	ret
  6fdc5e:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  6fdc65:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  6fdc6a:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  6fdc71:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fdc76:	48 8b 30             	mov    (%rax),%rsi
  6fdc79:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  6fdc80:	48 85 c0             	test   %rax,%rax
  6fdc83:	0f 84 9b 00 00 00    	je     6fdd24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x164>
  6fdc89:	83 f8 01             	cmp    $0x1,%eax
  6fdc8c:	0f 85 ae 00 00 00    	jne    6fdd40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x180>
  6fdc92:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  6fdc99:	4d 85 c9             	test   %r9,%r9
  6fdc9c:	0f 84 62 ff ff ff    	je     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdca2:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fdca9:	31 ff                	xor    %edi,%edi
  6fdcab:	49 83 f9 01          	cmp    $0x1,%r9
  6fdcaf:	74 33                	je     6fdce4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x124>
  6fdcb1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6fdcb8:	0f 1f 84 00 00 00 00 
  6fdcbf:	00 
  6fdcc0:	49 89 fa             	mov    %rdi,%r10
  6fdcc3:	4d 89 cb             	mov    %r9,%r11
  6fdcc6:	49 d1 eb             	shr    $1,%r11
  6fdcc9:	4c 01 df             	add    %r11,%rdi
  6fdccc:	48 89 fb             	mov    %rdi,%rbx
  6fdccf:	48 c1 e3 04          	shl    $0x4,%rbx
  6fdcd3:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  6fdcd7:	49 0f 47 fa          	cmova  %r10,%rdi
  6fdcdb:	4d 29 d9             	sub    %r11,%r9
  6fdcde:	49 83 f9 01          	cmp    $0x1,%r9
  6fdce2:	77 dc                	ja     6fdcc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x100>
  6fdce4:	49 89 fa             	mov    %rdi,%r10
  6fdce7:	49 c1 e2 04          	shl    $0x4,%r10
  6fdceb:	45 31 c9             	xor    %r9d,%r9d
  6fdcee:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  6fdcf2:	41 0f 96 c1          	setbe  %r9b
  6fdcf6:	49 01 f9             	add    %rdi,%r9
  6fdcf9:	0f 84 05 ff ff ff    	je     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdcff:	49 c1 e1 04          	shl    $0x4,%r9
  6fdd03:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  6fdd08:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  6fdd0d:	48 39 fe             	cmp    %rdi,%rsi
  6fdd10:	0f 83 ee fe ff ff    	jae    6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd16:	4c 01 c8             	add    %r9,%rax
  6fdd19:	8b 40 f8             	mov    -0x8(%rax),%eax
  6fdd1c:	48 01 c6             	add    %rax,%rsi
  6fdd1f:	e9 82 00 00 00       	jmp    6fdda6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e6>
  6fdd24:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  6fdd2b:	0f 82 d3 fe ff ff    	jb     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd31:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  6fdd38:	0f 83 c6 fe ff ff    	jae    6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd3e:	eb 66                	jmp    6fdda6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e6>
  6fdd40:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  6fdd47:	48 85 ff             	test   %rdi,%rdi
  6fdd4a:	0f 84 b4 fe ff ff    	je     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd50:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fdd57:	48 83 ff 01          	cmp    $0x1,%rdi
  6fdd5b:	75 0b                	jne    6fdd68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1a8>
  6fdd5d:	48 39 30             	cmp    %rsi,(%rax)
  6fdd60:	0f 85 9e fe ff ff    	jne    6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd66:	eb 3b                	jmp    6fdda3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e3>
  6fdd68:	45 31 c9             	xor    %r9d,%r9d
  6fdd6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6fdd70:	4d 89 ca             	mov    %r9,%r10
  6fdd73:	49 89 fb             	mov    %rdi,%r11
  6fdd76:	49 d1 eb             	shr    $1,%r11
  6fdd79:	4d 01 d9             	add    %r11,%r9
  6fdd7c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  6fdd80:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  6fdd84:	4d 0f 47 ca          	cmova  %r10,%r9
  6fdd88:	4c 29 df             	sub    %r11,%rdi
  6fdd8b:	48 83 ff 01          	cmp    $0x1,%rdi
  6fdd8f:	77 df                	ja     6fdd70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1b0>
  6fdd91:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  6fdd95:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  6fdd99:	0f 85 65 fe ff ff    	jne    6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdd9f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  6fdda3:	8b 70 08             	mov    0x8(%rax),%esi
  6fdda6:	4c 89 f7             	mov    %r14,%rdi
  6fdda9:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  6fddae:	4c 89 c5             	mov    %r8,%rbp
  6fddb1:	48 89 cb             	mov    %rcx,%rbx
  6fddb4:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  6fddb9:	49 89 d7             	mov    %rdx,%r15
  6fddbc:	e8 ff 47 00 00       	call   7025c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::editing_at>
  6fddc1:	4c 89 fa             	mov    %r15,%rdx
  6fddc4:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6fddc9:	48 89 d9             	mov    %rbx,%rcx
  6fddcc:	49 89 e8             	mov    %rbp,%r8
  6fddcf:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  6fddd4:	48 85 c0             	test   %rax,%rax
  6fddd7:	0f 84 27 fe ff ff    	je     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdddd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fdde1:	0f 84 1d fe ff ff    	je     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fdde7:	48 8b 38             	mov    (%rax),%rdi
  6fddea:	4d 85 ff             	test   %r15,%r15
  6fdded:	74 19                	je     6fde08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x248>
  6fddef:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  6fddf6:	4c 31 fe             	xor    %r15,%rsi
  6fddf9:	49 89 e9             	mov    %rbp,%r9
  6fddfc:	49 31 f9             	xor    %rdi,%r9
  6fddff:	49 09 f1             	or     %rsi,%r9
  6fde02:	40 0f 94 c6          	sete   %sil
  6fde06:	eb 02                	jmp    6fde0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x24a>
  6fde08:	31 f6                	xor    %esi,%esi
  6fde0a:	44 8b 48 18          	mov    0x18(%rax),%r9d
  6fde0e:	8b 40 20             	mov    0x20(%rax),%eax
  6fde11:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  6fde18:	4d 85 d2             	test   %r10,%r10
  6fde1b:	74 17                	je     6fde34 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x274>
  6fde1d:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  6fde24:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  6fde2b:	4c 09 d7             	or     %r10,%rdi
  6fde2e:	40 0f 94 c7          	sete   %dil
  6fde32:	eb 02                	jmp    6fde36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x276>
  6fde34:	31 ff                	xor    %edi,%edi
  6fde36:	41 39 c1             	cmp    %eax,%r9d
  6fde39:	0f 85 c5 fd ff ff    	jne    6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fde3f:	40 30 fe             	xor    %dil,%sil
  6fde42:	0f 84 bc fd ff ff    	je     6fdc04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fde48:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  6fde4f:	00 00 
  6fde51:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fde56:	4c 89 e7             	mov    %r12,%rdi
  6fde59:	4c 89 f6             	mov    %r14,%rsi
  6fde5c:	e8 6f 07 00 00       	call   6fe5d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>
  6fde61:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fde66:	0f 85 b8 fd ff ff    	jne    6fdc24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x64>
  6fde6c:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  6fde73:	48 85 c0             	test   %rax,%rax
  6fde76:	74 2a                	je     6fdea2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x2e2>
  6fde78:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fde7e:	0f 84 cb fd ff ff    	je     6fdc4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fde84:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  6fde89:	0f 85 c0 fd ff ff    	jne    6fdc4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fde8f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fde94:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  6fde9b:	74 11                	je     6fdeae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x2ee>
  6fde9d:	e9 ad fd ff ff       	jmp    6fdc4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdea2:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fdea8:	0f 85 a1 fd ff ff    	jne    6fdc4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fdeae:	4c 89 e7             	mov    %r12,%rdi
  6fdeb1:	4c 89 f6             	mov    %r14,%rsi
  6fdeb4:	4c 89 fa             	mov    %r15,%rdx
  6fdeb7:	48 89 e9             	mov    %rbp,%rcx
  6fdeba:	48 83 c4 48          	add    $0x48,%rsp
  6fdebe:	5b                   	pop    %rbx
  6fdebf:	41 5c                	pop    %r12
  6fdec1:	41 5d                	pop    %r13
  6fdec3:	41 5e                	pop    %r14
  6fdec5:	41 5f                	pop    %r15
  6fdec7:	5d                   	pop    %rbp
  6fdec8:	e9 d3 7e 00 00       	jmp    705da0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>
