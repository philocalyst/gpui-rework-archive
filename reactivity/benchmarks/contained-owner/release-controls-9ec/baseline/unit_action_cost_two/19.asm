
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fcf20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused>:
  6fcf20:	55                   	push   %rbp
  6fcf21:	41 57                	push   %r15
  6fcf23:	41 56                	push   %r14
  6fcf25:	41 55                	push   %r13
  6fcf27:	41 54                	push   %r12
  6fcf29:	53                   	push   %rbx
  6fcf2a:	48 83 ec 48          	sub    $0x48,%rsp
  6fcf2e:	4d 89 cf             	mov    %r9,%r15
  6fcf31:	49 89 f6             	mov    %rsi,%r14
  6fcf34:	49 89 fc             	mov    %rdi,%r12
  6fcf37:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  6fcf3e:	00 
  6fcf3f:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  6fcf46:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  6fcf4d:	48 85 c0             	test   %rax,%rax
  6fcf50:	74 12                	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fcf52:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fcf59:	48 85 c0             	test   %rax,%rax
  6fcf5c:	74 06                	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fcf5e:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fcf62:	75 5a                	jne    6fcfbe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x9e>
  6fcf64:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  6fcf6b:	00 00 
  6fcf6d:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fcf72:	4c 89 e7             	mov    %r12,%rdi
  6fcf75:	4c 89 f6             	mov    %r14,%rsi
  6fcf78:	e8 b3 02 00 00       	call   6fd230 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>
  6fcf7d:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fcf82:	74 2b                	je     6fcfaf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fcf84:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  6fcf8b:	75 22                	jne    6fcfaf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fcf8d:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  6fcf94:	01 
  6fcf95:	75 18                	jne    6fcfaf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fcf97:	41 80 be 22 07 00 00 	cmpb   $0x0,0x722(%r14)
  6fcf9e:	00 
  6fcf9f:	75 0e                	jne    6fcfaf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fcfa1:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  6fcfa8:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  6fcfaf:	48 83 c4 48          	add    $0x48,%rsp
  6fcfb3:	5b                   	pop    %rbx
  6fcfb4:	41 5c                	pop    %r12
  6fcfb6:	41 5d                	pop    %r13
  6fcfb8:	41 5e                	pop    %r14
  6fcfba:	41 5f                	pop    %r15
  6fcfbc:	5d                   	pop    %rbp
  6fcfbd:	c3                   	ret
  6fcfbe:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  6fcfc5:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  6fcfca:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  6fcfd1:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fcfd6:	48 8b 30             	mov    (%rax),%rsi
  6fcfd9:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  6fcfe0:	48 85 c0             	test   %rax,%rax
  6fcfe3:	0f 84 9b 00 00 00    	je     6fd084 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x164>
  6fcfe9:	83 f8 01             	cmp    $0x1,%eax
  6fcfec:	0f 85 ae 00 00 00    	jne    6fd0a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x180>
  6fcff2:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  6fcff9:	4d 85 c9             	test   %r9,%r9
  6fcffc:	0f 84 62 ff ff ff    	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd002:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fd009:	31 ff                	xor    %edi,%edi
  6fd00b:	49 83 f9 01          	cmp    $0x1,%r9
  6fd00f:	74 33                	je     6fd044 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x124>
  6fd011:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6fd018:	0f 1f 84 00 00 00 00 
  6fd01f:	00 
  6fd020:	49 89 fa             	mov    %rdi,%r10
  6fd023:	4d 89 cb             	mov    %r9,%r11
  6fd026:	49 d1 eb             	shr    $1,%r11
  6fd029:	4c 01 df             	add    %r11,%rdi
  6fd02c:	48 89 fb             	mov    %rdi,%rbx
  6fd02f:	48 c1 e3 04          	shl    $0x4,%rbx
  6fd033:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  6fd037:	49 0f 47 fa          	cmova  %r10,%rdi
  6fd03b:	4d 29 d9             	sub    %r11,%r9
  6fd03e:	49 83 f9 01          	cmp    $0x1,%r9
  6fd042:	77 dc                	ja     6fd020 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x100>
  6fd044:	49 89 fa             	mov    %rdi,%r10
  6fd047:	49 c1 e2 04          	shl    $0x4,%r10
  6fd04b:	45 31 c9             	xor    %r9d,%r9d
  6fd04e:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  6fd052:	41 0f 96 c1          	setbe  %r9b
  6fd056:	49 01 f9             	add    %rdi,%r9
  6fd059:	0f 84 05 ff ff ff    	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd05f:	49 c1 e1 04          	shl    $0x4,%r9
  6fd063:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  6fd068:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  6fd06d:	48 39 fe             	cmp    %rdi,%rsi
  6fd070:	0f 83 ee fe ff ff    	jae    6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd076:	4c 01 c8             	add    %r9,%rax
  6fd079:	8b 40 f8             	mov    -0x8(%rax),%eax
  6fd07c:	48 01 c6             	add    %rax,%rsi
  6fd07f:	e9 82 00 00 00       	jmp    6fd106 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e6>
  6fd084:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  6fd08b:	0f 82 d3 fe ff ff    	jb     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd091:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  6fd098:	0f 83 c6 fe ff ff    	jae    6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd09e:	eb 66                	jmp    6fd106 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e6>
  6fd0a0:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  6fd0a7:	48 85 ff             	test   %rdi,%rdi
  6fd0aa:	0f 84 b4 fe ff ff    	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd0b0:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fd0b7:	48 83 ff 01          	cmp    $0x1,%rdi
  6fd0bb:	75 0b                	jne    6fd0c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1a8>
  6fd0bd:	48 39 30             	cmp    %rsi,(%rax)
  6fd0c0:	0f 85 9e fe ff ff    	jne    6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd0c6:	eb 3b                	jmp    6fd103 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1e3>
  6fd0c8:	45 31 c9             	xor    %r9d,%r9d
  6fd0cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6fd0d0:	4d 89 ca             	mov    %r9,%r10
  6fd0d3:	49 89 fb             	mov    %rdi,%r11
  6fd0d6:	49 d1 eb             	shr    $1,%r11
  6fd0d9:	4d 01 d9             	add    %r11,%r9
  6fd0dc:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  6fd0e0:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  6fd0e4:	4d 0f 47 ca          	cmova  %r10,%r9
  6fd0e8:	4c 29 df             	sub    %r11,%rdi
  6fd0eb:	48 83 ff 01          	cmp    $0x1,%rdi
  6fd0ef:	77 df                	ja     6fd0d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x1b0>
  6fd0f1:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  6fd0f5:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  6fd0f9:	0f 85 65 fe ff ff    	jne    6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd0ff:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  6fd103:	8b 70 08             	mov    0x8(%rax),%esi
  6fd106:	4c 89 f7             	mov    %r14,%rdi
  6fd109:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  6fd10e:	4c 89 c5             	mov    %r8,%rbp
  6fd111:	48 89 cb             	mov    %rcx,%rbx
  6fd114:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  6fd119:	49 89 d7             	mov    %rdx,%r15
  6fd11c:	e8 cf 40 00 00       	call   7011f0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::editing_at>
  6fd121:	4c 89 fa             	mov    %r15,%rdx
  6fd124:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6fd129:	48 89 d9             	mov    %rbx,%rcx
  6fd12c:	49 89 e8             	mov    %rbp,%r8
  6fd12f:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  6fd134:	48 85 c0             	test   %rax,%rax
  6fd137:	0f 84 27 fe ff ff    	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd13d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fd141:	0f 84 1d fe ff ff    	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd147:	48 8b 38             	mov    (%rax),%rdi
  6fd14a:	4d 85 ff             	test   %r15,%r15
  6fd14d:	74 19                	je     6fd168 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x248>
  6fd14f:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  6fd156:	4c 31 fe             	xor    %r15,%rsi
  6fd159:	49 89 e9             	mov    %rbp,%r9
  6fd15c:	49 31 f9             	xor    %rdi,%r9
  6fd15f:	49 09 f1             	or     %rsi,%r9
  6fd162:	40 0f 94 c6          	sete   %sil
  6fd166:	eb 02                	jmp    6fd16a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x24a>
  6fd168:	31 f6                	xor    %esi,%esi
  6fd16a:	44 8b 48 18          	mov    0x18(%rax),%r9d
  6fd16e:	8b 40 20             	mov    0x20(%rax),%eax
  6fd171:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  6fd178:	4d 85 d2             	test   %r10,%r10
  6fd17b:	74 17                	je     6fd194 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x274>
  6fd17d:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  6fd184:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  6fd18b:	4c 09 d7             	or     %r10,%rdi
  6fd18e:	40 0f 94 c7          	sete   %dil
  6fd192:	eb 02                	jmp    6fd196 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x276>
  6fd194:	31 ff                	xor    %edi,%edi
  6fd196:	41 39 c1             	cmp    %eax,%r9d
  6fd199:	0f 85 c5 fd ff ff    	jne    6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd19f:	40 30 fe             	xor    %dil,%sil
  6fd1a2:	0f 84 bc fd ff ff    	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x44>
  6fd1a8:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  6fd1af:	00 00 
  6fd1b1:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fd1b6:	4c 89 e7             	mov    %r12,%rdi
  6fd1b9:	4c 89 f6             	mov    %r14,%rsi
  6fd1bc:	e8 6f 00 00 00       	call   6fd230 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>
  6fd1c1:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fd1c6:	0f 85 b8 fd ff ff    	jne    6fcf84 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x64>
  6fd1cc:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  6fd1d3:	48 85 c0             	test   %rax,%rax
  6fd1d6:	74 2a                	je     6fd202 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x2e2>
  6fd1d8:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fd1de:	0f 84 cb fd ff ff    	je     6fcfaf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fd1e4:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  6fd1e9:	0f 85 c0 fd ff ff    	jne    6fcfaf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fd1ef:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd1f4:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  6fd1fb:	74 11                	je     6fd20e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x2ee>
  6fd1fd:	e9 ad fd ff ff       	jmp    6fcfaf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fd202:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fd208:	0f 85 a1 fd ff ff    	jne    6fcfaf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused+0x8f>
  6fd20e:	4c 89 e7             	mov    %r12,%rdi
  6fd211:	4c 89 f6             	mov    %r14,%rsi
  6fd214:	4c 89 fa             	mov    %r15,%rdx
  6fd217:	48 89 e9             	mov    %rbp,%rcx
  6fd21a:	48 83 c4 48          	add    $0x48,%rsp
  6fd21e:	5b                   	pop    %rbx
  6fd21f:	41 5c                	pop    %r12
  6fd221:	41 5d                	pop    %r13
  6fd223:	41 5e                	pop    %r14
  6fd225:	41 5f                	pop    %r15
  6fd227:	5d                   	pop    %rbp
  6fd228:	e9 a3 77 00 00       	jmp    7049d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>
