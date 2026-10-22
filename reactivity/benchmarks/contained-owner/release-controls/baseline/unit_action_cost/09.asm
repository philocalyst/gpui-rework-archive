
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000706f40 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused>:
  706f40:	55                   	push   %rbp
  706f41:	41 57                	push   %r15
  706f43:	41 56                	push   %r14
  706f45:	41 55                	push   %r13
  706f47:	41 54                	push   %r12
  706f49:	53                   	push   %rbx
  706f4a:	48 83 ec 48          	sub    $0x48,%rsp
  706f4e:	4d 89 cf             	mov    %r9,%r15
  706f51:	49 89 f6             	mov    %rsi,%r14
  706f54:	49 89 fc             	mov    %rdi,%r12
  706f57:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  706f5e:	00 
  706f5f:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  706f66:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  706f6d:	48 85 c0             	test   %rax,%rax
  706f70:	74 12                	je     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  706f72:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  706f79:	48 85 c0             	test   %rax,%rax
  706f7c:	74 06                	je     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  706f7e:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  706f82:	75 5a                	jne    706fde <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x9e>
  706f84:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  706f8b:	00 00 
  706f8d:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  706f92:	4c 89 e7             	mov    %r12,%rdi
  706f95:	4c 89 f6             	mov    %r14,%rsi
  706f98:	e8 b3 02 00 00       	call   707250 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>
  706f9d:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  706fa2:	74 2b                	je     706fcf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  706fa4:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  706fab:	75 22                	jne    706fcf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  706fad:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  706fb4:	01 
  706fb5:	75 18                	jne    706fcf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  706fb7:	41 80 be 22 07 00 00 	cmpb   $0x0,0x722(%r14)
  706fbe:	00 
  706fbf:	75 0e                	jne    706fcf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  706fc1:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  706fc8:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  706fcf:	48 83 c4 48          	add    $0x48,%rsp
  706fd3:	5b                   	pop    %rbx
  706fd4:	41 5c                	pop    %r12
  706fd6:	41 5d                	pop    %r13
  706fd8:	41 5e                	pop    %r14
  706fda:	41 5f                	pop    %r15
  706fdc:	5d                   	pop    %rbp
  706fdd:	c3                   	ret
  706fde:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  706fe5:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  706fea:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  706ff1:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  706ff6:	48 8b 30             	mov    (%rax),%rsi
  706ff9:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  707000:	48 85 c0             	test   %rax,%rax
  707003:	0f 84 9b 00 00 00    	je     7070a4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x164>
  707009:	83 f8 01             	cmp    $0x1,%eax
  70700c:	0f 85 ae 00 00 00    	jne    7070c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x180>
  707012:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  707019:	4d 85 c9             	test   %r9,%r9
  70701c:	0f 84 62 ff ff ff    	je     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707022:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  707029:	31 ff                	xor    %edi,%edi
  70702b:	49 83 f9 01          	cmp    $0x1,%r9
  70702f:	74 33                	je     707064 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x124>
  707031:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  707038:	0f 1f 84 00 00 00 00 
  70703f:	00 
  707040:	49 89 fa             	mov    %rdi,%r10
  707043:	4d 89 cb             	mov    %r9,%r11
  707046:	49 d1 eb             	shr    $1,%r11
  707049:	4c 01 df             	add    %r11,%rdi
  70704c:	48 89 fb             	mov    %rdi,%rbx
  70704f:	48 c1 e3 04          	shl    $0x4,%rbx
  707053:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  707057:	49 0f 47 fa          	cmova  %r10,%rdi
  70705b:	4d 29 d9             	sub    %r11,%r9
  70705e:	49 83 f9 01          	cmp    $0x1,%r9
  707062:	77 dc                	ja     707040 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x100>
  707064:	49 89 fa             	mov    %rdi,%r10
  707067:	49 c1 e2 04          	shl    $0x4,%r10
  70706b:	45 31 c9             	xor    %r9d,%r9d
  70706e:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  707072:	41 0f 96 c1          	setbe  %r9b
  707076:	49 01 f9             	add    %rdi,%r9
  707079:	0f 84 05 ff ff ff    	je     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70707f:	49 c1 e1 04          	shl    $0x4,%r9
  707083:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  707088:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  70708d:	48 39 fe             	cmp    %rdi,%rsi
  707090:	0f 83 ee fe ff ff    	jae    706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707096:	4c 01 c8             	add    %r9,%rax
  707099:	8b 40 f8             	mov    -0x8(%rax),%eax
  70709c:	48 01 c6             	add    %rax,%rsi
  70709f:	e9 82 00 00 00       	jmp    707126 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e6>
  7070a4:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  7070ab:	0f 82 d3 fe ff ff    	jb     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7070b1:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  7070b8:	0f 83 c6 fe ff ff    	jae    706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7070be:	eb 66                	jmp    707126 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e6>
  7070c0:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  7070c7:	48 85 ff             	test   %rdi,%rdi
  7070ca:	0f 84 b4 fe ff ff    	je     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7070d0:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  7070d7:	48 83 ff 01          	cmp    $0x1,%rdi
  7070db:	75 0b                	jne    7070e8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1a8>
  7070dd:	48 39 30             	cmp    %rsi,(%rax)
  7070e0:	0f 85 9e fe ff ff    	jne    706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7070e6:	eb 3b                	jmp    707123 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e3>
  7070e8:	45 31 c9             	xor    %r9d,%r9d
  7070eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  7070f0:	4d 89 ca             	mov    %r9,%r10
  7070f3:	49 89 fb             	mov    %rdi,%r11
  7070f6:	49 d1 eb             	shr    $1,%r11
  7070f9:	4d 01 d9             	add    %r11,%r9
  7070fc:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  707100:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  707104:	4d 0f 47 ca          	cmova  %r10,%r9
  707108:	4c 29 df             	sub    %r11,%rdi
  70710b:	48 83 ff 01          	cmp    $0x1,%rdi
  70710f:	77 df                	ja     7070f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1b0>
  707111:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  707115:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  707119:	0f 85 65 fe ff ff    	jne    706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70711f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  707123:	8b 70 08             	mov    0x8(%rax),%esi
  707126:	4c 89 f7             	mov    %r14,%rdi
  707129:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  70712e:	4c 89 c5             	mov    %r8,%rbp
  707131:	48 89 cb             	mov    %rcx,%rbx
  707134:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  707139:	49 89 d7             	mov    %rdx,%r15
  70713c:	e8 2f 2a 00 00       	call   709b70 <<gpui::runtime::Runtime<unit_action_cost::Model>>::editing_at>
  707141:	4c 89 fa             	mov    %r15,%rdx
  707144:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  707149:	48 89 d9             	mov    %rbx,%rcx
  70714c:	49 89 e8             	mov    %rbp,%r8
  70714f:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  707154:	48 85 c0             	test   %rax,%rax
  707157:	0f 84 27 fe ff ff    	je     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70715d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  707161:	0f 84 1d fe ff ff    	je     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707167:	48 8b 38             	mov    (%rax),%rdi
  70716a:	4d 85 ff             	test   %r15,%r15
  70716d:	74 19                	je     707188 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x248>
  70716f:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  707176:	4c 31 fe             	xor    %r15,%rsi
  707179:	49 89 e9             	mov    %rbp,%r9
  70717c:	49 31 f9             	xor    %rdi,%r9
  70717f:	49 09 f1             	or     %rsi,%r9
  707182:	40 0f 94 c6          	sete   %sil
  707186:	eb 02                	jmp    70718a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x24a>
  707188:	31 f6                	xor    %esi,%esi
  70718a:	44 8b 48 18          	mov    0x18(%rax),%r9d
  70718e:	8b 40 20             	mov    0x20(%rax),%eax
  707191:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  707198:	4d 85 d2             	test   %r10,%r10
  70719b:	74 17                	je     7071b4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x274>
  70719d:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  7071a4:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  7071ab:	4c 09 d7             	or     %r10,%rdi
  7071ae:	40 0f 94 c7          	sete   %dil
  7071b2:	eb 02                	jmp    7071b6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x276>
  7071b4:	31 ff                	xor    %edi,%edi
  7071b6:	41 39 c1             	cmp    %eax,%r9d
  7071b9:	0f 85 c5 fd ff ff    	jne    706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7071bf:	40 30 fe             	xor    %dil,%sil
  7071c2:	0f 84 bc fd ff ff    	je     706f84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7071c8:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  7071cf:	00 00 
  7071d1:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  7071d6:	4c 89 e7             	mov    %r12,%rdi
  7071d9:	4c 89 f6             	mov    %r14,%rsi
  7071dc:	e8 6f 00 00 00       	call   707250 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>
  7071e1:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  7071e6:	0f 85 b8 fd ff ff    	jne    706fa4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x64>
  7071ec:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  7071f3:	48 85 c0             	test   %rax,%rax
  7071f6:	74 2a                	je     707222 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x2e2>
  7071f8:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  7071fe:	0f 84 cb fd ff ff    	je     706fcf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707204:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  707209:	0f 85 c0 fd ff ff    	jne    706fcf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  70720f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  707214:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  70721b:	74 11                	je     70722e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x2ee>
  70721d:	e9 ad fd ff ff       	jmp    706fcf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707222:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  707228:	0f 85 a1 fd ff ff    	jne    706fcf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  70722e:	4c 89 e7             	mov    %r12,%rdi
  707231:	4c 89 f6             	mov    %r14,%rsi
  707234:	4c 89 fa             	mov    %r15,%rdx
  707237:	48 89 e9             	mov    %rbp,%rcx
  70723a:	48 83 c4 48          	add    $0x48,%rsp
  70723e:	5b                   	pop    %rbx
  70723f:	41 5c                	pop    %r12
  707241:	41 5d                	pop    %r13
  707243:	41 5e                	pop    %r14
  707245:	41 5f                	pop    %r15
  707247:	5d                   	pop    %rbp
  707248:	e9 93 4c 00 00       	jmp    70bee0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>
