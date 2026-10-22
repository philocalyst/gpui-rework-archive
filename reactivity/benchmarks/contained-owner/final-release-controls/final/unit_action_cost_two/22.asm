
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006faac0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused>:
  6faac0:	55                   	push   %rbp
  6faac1:	41 57                	push   %r15
  6faac3:	41 56                	push   %r14
  6faac5:	41 55                	push   %r13
  6faac7:	41 54                	push   %r12
  6faac9:	53                   	push   %rbx
  6faaca:	48 83 ec 48          	sub    $0x48,%rsp
  6faace:	4d 89 cf             	mov    %r9,%r15
  6faad1:	49 89 f6             	mov    %rsi,%r14
  6faad4:	49 89 fc             	mov    %rdi,%r12
  6faad7:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  6faade:	00 
  6faadf:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  6faae6:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  6faaed:	48 85 c0             	test   %rax,%rax
  6faaf0:	74 12                	je     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6faaf2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6faaf9:	48 85 c0             	test   %rax,%rax
  6faafc:	74 06                	je     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6faafe:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fab02:	75 5a                	jne    6fab5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x9e>
  6fab04:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  6fab0b:	00 00 
  6fab0d:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fab12:	4c 89 e7             	mov    %r12,%rdi
  6fab15:	4c 89 f6             	mov    %r14,%rsi
  6fab18:	e8 b3 09 00 00       	call   6fb4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>
  6fab1d:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fab22:	74 2b                	je     6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fab24:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  6fab2b:	75 22                	jne    6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fab2d:	41 80 be 1e 08 00 00 	cmpb   $0x1,0x81e(%r14)
  6fab34:	01 
  6fab35:	75 18                	jne    6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fab37:	41 80 be 22 08 00 00 	cmpb   $0x0,0x822(%r14)
  6fab3e:	00 
  6fab3f:	75 0e                	jne    6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fab41:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  6fab48:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  6fab4f:	48 83 c4 48          	add    $0x48,%rsp
  6fab53:	5b                   	pop    %rbx
  6fab54:	41 5c                	pop    %r12
  6fab56:	41 5d                	pop    %r13
  6fab58:	41 5e                	pop    %r14
  6fab5a:	41 5f                	pop    %r15
  6fab5c:	5d                   	pop    %rbp
  6fab5d:	c3                   	ret
  6fab5e:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  6fab65:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  6fab6a:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  6fab71:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fab76:	48 8b 30             	mov    (%rax),%rsi
  6fab79:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  6fab80:	48 85 c0             	test   %rax,%rax
  6fab83:	0f 84 9b 00 00 00    	je     6fac24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x164>
  6fab89:	83 f8 01             	cmp    $0x1,%eax
  6fab8c:	0f 85 ae 00 00 00    	jne    6fac40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x180>
  6fab92:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  6fab99:	4d 85 c9             	test   %r9,%r9
  6fab9c:	0f 84 62 ff ff ff    	je     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6faba2:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6faba9:	31 ff                	xor    %edi,%edi
  6fabab:	49 83 f9 01          	cmp    $0x1,%r9
  6fabaf:	74 33                	je     6fabe4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x124>
  6fabb1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6fabb8:	0f 1f 84 00 00 00 00 
  6fabbf:	00 
  6fabc0:	49 89 fa             	mov    %rdi,%r10
  6fabc3:	4d 89 cb             	mov    %r9,%r11
  6fabc6:	49 d1 eb             	shr    $1,%r11
  6fabc9:	4c 01 df             	add    %r11,%rdi
  6fabcc:	48 89 fb             	mov    %rdi,%rbx
  6fabcf:	48 c1 e3 04          	shl    $0x4,%rbx
  6fabd3:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  6fabd7:	49 0f 47 fa          	cmova  %r10,%rdi
  6fabdb:	4d 29 d9             	sub    %r11,%r9
  6fabde:	49 83 f9 01          	cmp    $0x1,%r9
  6fabe2:	77 dc                	ja     6fabc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x100>
  6fabe4:	49 89 fa             	mov    %rdi,%r10
  6fabe7:	49 c1 e2 04          	shl    $0x4,%r10
  6fabeb:	45 31 c9             	xor    %r9d,%r9d
  6fabee:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  6fabf2:	41 0f 96 c1          	setbe  %r9b
  6fabf6:	49 01 f9             	add    %rdi,%r9
  6fabf9:	0f 84 05 ff ff ff    	je     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fabff:	49 c1 e1 04          	shl    $0x4,%r9
  6fac03:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  6fac08:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  6fac0d:	48 39 fe             	cmp    %rdi,%rsi
  6fac10:	0f 83 ee fe ff ff    	jae    6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fac16:	4c 01 c8             	add    %r9,%rax
  6fac19:	8b 40 f8             	mov    -0x8(%rax),%eax
  6fac1c:	48 01 c6             	add    %rax,%rsi
  6fac1f:	e9 82 00 00 00       	jmp    6faca6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e6>
  6fac24:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  6fac2b:	0f 82 d3 fe ff ff    	jb     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fac31:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  6fac38:	0f 83 c6 fe ff ff    	jae    6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fac3e:	eb 66                	jmp    6faca6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e6>
  6fac40:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  6fac47:	48 85 ff             	test   %rdi,%rdi
  6fac4a:	0f 84 b4 fe ff ff    	je     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fac50:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fac57:	48 83 ff 01          	cmp    $0x1,%rdi
  6fac5b:	75 0b                	jne    6fac68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1a8>
  6fac5d:	48 39 30             	cmp    %rsi,(%rax)
  6fac60:	0f 85 9e fe ff ff    	jne    6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fac66:	eb 3b                	jmp    6faca3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e3>
  6fac68:	45 31 c9             	xor    %r9d,%r9d
  6fac6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6fac70:	4d 89 ca             	mov    %r9,%r10
  6fac73:	49 89 fb             	mov    %rdi,%r11
  6fac76:	49 d1 eb             	shr    $1,%r11
  6fac79:	4d 01 d9             	add    %r11,%r9
  6fac7c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  6fac80:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  6fac84:	4d 0f 47 ca          	cmova  %r10,%r9
  6fac88:	4c 29 df             	sub    %r11,%rdi
  6fac8b:	48 83 ff 01          	cmp    $0x1,%rdi
  6fac8f:	77 df                	ja     6fac70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1b0>
  6fac91:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  6fac95:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  6fac99:	0f 85 65 fe ff ff    	jne    6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fac9f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  6faca3:	8b 70 08             	mov    0x8(%rax),%esi
  6faca6:	4c 89 f7             	mov    %r14,%rdi
  6faca9:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  6facae:	4c 89 c5             	mov    %r8,%rbp
  6facb1:	48 89 cb             	mov    %rcx,%rbx
  6facb4:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  6facb9:	49 89 d7             	mov    %rdx,%r15
  6facbc:	e8 6f 66 00 00       	call   701330 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::editing_at>
  6facc1:	4c 89 fa             	mov    %r15,%rdx
  6facc4:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6facc9:	48 89 d9             	mov    %rbx,%rcx
  6faccc:	49 89 e8             	mov    %rbp,%r8
  6faccf:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  6facd4:	48 85 c0             	test   %rax,%rax
  6facd7:	0f 84 27 fe ff ff    	je     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6facdd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6face1:	0f 84 1d fe ff ff    	je     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6face7:	48 8b 38             	mov    (%rax),%rdi
  6facea:	4d 85 ff             	test   %r15,%r15
  6faced:	74 19                	je     6fad08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x248>
  6facef:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  6facf6:	4c 31 fe             	xor    %r15,%rsi
  6facf9:	49 89 e9             	mov    %rbp,%r9
  6facfc:	49 31 f9             	xor    %rdi,%r9
  6facff:	49 09 f1             	or     %rsi,%r9
  6fad02:	40 0f 94 c6          	sete   %sil
  6fad06:	eb 02                	jmp    6fad0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x24a>
  6fad08:	31 f6                	xor    %esi,%esi
  6fad0a:	44 8b 48 18          	mov    0x18(%rax),%r9d
  6fad0e:	8b 40 20             	mov    0x20(%rax),%eax
  6fad11:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  6fad18:	4d 85 d2             	test   %r10,%r10
  6fad1b:	74 17                	je     6fad34 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x274>
  6fad1d:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  6fad24:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  6fad2b:	4c 09 d7             	or     %r10,%rdi
  6fad2e:	40 0f 94 c7          	sete   %dil
  6fad32:	eb 02                	jmp    6fad36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x276>
  6fad34:	31 ff                	xor    %edi,%edi
  6fad36:	41 39 c1             	cmp    %eax,%r9d
  6fad39:	0f 85 c5 fd ff ff    	jne    6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad3f:	40 30 fe             	xor    %dil,%sil
  6fad42:	0f 84 bc fd ff ff    	je     6fab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad48:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  6fad4f:	00 00 
  6fad51:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fad56:	4c 89 e7             	mov    %r12,%rdi
  6fad59:	4c 89 f6             	mov    %r14,%rsi
  6fad5c:	e8 6f 07 00 00       	call   6fb4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>
  6fad61:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fad66:	0f 85 b8 fd ff ff    	jne    6fab24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x64>
  6fad6c:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  6fad73:	48 85 c0             	test   %rax,%rax
  6fad76:	74 2a                	je     6fada2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x2e2>
  6fad78:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fad7e:	0f 84 cb fd ff ff    	je     6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fad84:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  6fad89:	0f 85 c0 fd ff ff    	jne    6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fad8f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fad94:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  6fad9b:	74 11                	je     6fadae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x2ee>
  6fad9d:	e9 ad fd ff ff       	jmp    6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fada2:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fada8:	0f 85 a1 fd ff ff    	jne    6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fadae:	4c 89 e7             	mov    %r12,%rdi
  6fadb1:	4c 89 f6             	mov    %r14,%rsi
  6fadb4:	4c 89 fa             	mov    %r15,%rdx
  6fadb7:	48 89 e9             	mov    %rbp,%rcx
  6fadba:	48 83 c4 48          	add    $0x48,%rsp
  6fadbe:	5b                   	pop    %rbx
  6fadbf:	41 5c                	pop    %r12
  6fadc1:	41 5d                	pop    %r13
  6fadc3:	41 5e                	pop    %r14
  6fadc5:	41 5f                	pop    %r15
  6fadc7:	5d                   	pop    %rbp
  6fadc8:	e9 a3 a4 00 00       	jmp    705270 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>
