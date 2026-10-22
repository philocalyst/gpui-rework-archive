
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fabb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused>:
  6fabb0:	55                   	push   %rbp
  6fabb1:	41 57                	push   %r15
  6fabb3:	41 56                	push   %r14
  6fabb5:	41 55                	push   %r13
  6fabb7:	41 54                	push   %r12
  6fabb9:	53                   	push   %rbx
  6fabba:	48 83 ec 48          	sub    $0x48,%rsp
  6fabbe:	4d 89 cf             	mov    %r9,%r15
  6fabc1:	49 89 f6             	mov    %rsi,%r14
  6fabc4:	49 89 fc             	mov    %rdi,%r12
  6fabc7:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  6fabce:	00 
  6fabcf:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  6fabd6:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  6fabdd:	48 85 c0             	test   %rax,%rax
  6fabe0:	74 12                	je     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fabe2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fabe9:	48 85 c0             	test   %rax,%rax
  6fabec:	74 06                	je     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fabee:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fabf2:	75 5a                	jne    6fac4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x9e>
  6fabf4:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  6fabfb:	00 00 
  6fabfd:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fac02:	4c 89 e7             	mov    %r12,%rdi
  6fac05:	4c 89 f6             	mov    %r14,%rsi
  6fac08:	e8 83 09 00 00       	call   6fb590 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>
  6fac0d:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fac12:	74 2b                	je     6fac3f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fac14:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  6fac1b:	75 22                	jne    6fac3f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fac1d:	41 80 be 1e 08 00 00 	cmpb   $0x1,0x81e(%r14)
  6fac24:	01 
  6fac25:	75 18                	jne    6fac3f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fac27:	41 80 be 22 08 00 00 	cmpb   $0x0,0x822(%r14)
  6fac2e:	00 
  6fac2f:	75 0e                	jne    6fac3f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fac31:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  6fac38:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  6fac3f:	48 83 c4 48          	add    $0x48,%rsp
  6fac43:	5b                   	pop    %rbx
  6fac44:	41 5c                	pop    %r12
  6fac46:	41 5d                	pop    %r13
  6fac48:	41 5e                	pop    %r14
  6fac4a:	41 5f                	pop    %r15
  6fac4c:	5d                   	pop    %rbp
  6fac4d:	c3                   	ret
  6fac4e:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  6fac55:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  6fac5a:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  6fac61:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fac66:	48 8b 30             	mov    (%rax),%rsi
  6fac69:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  6fac70:	48 85 c0             	test   %rax,%rax
  6fac73:	0f 84 9b 00 00 00    	je     6fad14 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x164>
  6fac79:	83 f8 01             	cmp    $0x1,%eax
  6fac7c:	0f 85 ae 00 00 00    	jne    6fad30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x180>
  6fac82:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  6fac89:	4d 85 c9             	test   %r9,%r9
  6fac8c:	0f 84 62 ff ff ff    	je     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fac92:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fac99:	31 ff                	xor    %edi,%edi
  6fac9b:	49 83 f9 01          	cmp    $0x1,%r9
  6fac9f:	74 33                	je     6facd4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x124>
  6faca1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6faca8:	0f 1f 84 00 00 00 00 
  6facaf:	00 
  6facb0:	49 89 fa             	mov    %rdi,%r10
  6facb3:	4d 89 cb             	mov    %r9,%r11
  6facb6:	49 d1 eb             	shr    $1,%r11
  6facb9:	4c 01 df             	add    %r11,%rdi
  6facbc:	48 89 fb             	mov    %rdi,%rbx
  6facbf:	48 c1 e3 04          	shl    $0x4,%rbx
  6facc3:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  6facc7:	49 0f 47 fa          	cmova  %r10,%rdi
  6faccb:	4d 29 d9             	sub    %r11,%r9
  6facce:	49 83 f9 01          	cmp    $0x1,%r9
  6facd2:	77 dc                	ja     6facb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x100>
  6facd4:	49 89 fa             	mov    %rdi,%r10
  6facd7:	49 c1 e2 04          	shl    $0x4,%r10
  6facdb:	45 31 c9             	xor    %r9d,%r9d
  6facde:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  6face2:	41 0f 96 c1          	setbe  %r9b
  6face6:	49 01 f9             	add    %rdi,%r9
  6face9:	0f 84 05 ff ff ff    	je     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6facef:	49 c1 e1 04          	shl    $0x4,%r9
  6facf3:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  6facf8:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  6facfd:	48 39 fe             	cmp    %rdi,%rsi
  6fad00:	0f 83 ee fe ff ff    	jae    6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad06:	4c 01 c8             	add    %r9,%rax
  6fad09:	8b 40 f8             	mov    -0x8(%rax),%eax
  6fad0c:	48 01 c6             	add    %rax,%rsi
  6fad0f:	e9 82 00 00 00       	jmp    6fad96 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e6>
  6fad14:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  6fad1b:	0f 82 d3 fe ff ff    	jb     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad21:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  6fad28:	0f 83 c6 fe ff ff    	jae    6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad2e:	eb 66                	jmp    6fad96 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e6>
  6fad30:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  6fad37:	48 85 ff             	test   %rdi,%rdi
  6fad3a:	0f 84 b4 fe ff ff    	je     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad40:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fad47:	48 83 ff 01          	cmp    $0x1,%rdi
  6fad4b:	75 0b                	jne    6fad58 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1a8>
  6fad4d:	48 39 30             	cmp    %rsi,(%rax)
  6fad50:	0f 85 9e fe ff ff    	jne    6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad56:	eb 3b                	jmp    6fad93 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e3>
  6fad58:	45 31 c9             	xor    %r9d,%r9d
  6fad5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6fad60:	4d 89 ca             	mov    %r9,%r10
  6fad63:	49 89 fb             	mov    %rdi,%r11
  6fad66:	49 d1 eb             	shr    $1,%r11
  6fad69:	4d 01 d9             	add    %r11,%r9
  6fad6c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  6fad70:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  6fad74:	4d 0f 47 ca          	cmova  %r10,%r9
  6fad78:	4c 29 df             	sub    %r11,%rdi
  6fad7b:	48 83 ff 01          	cmp    $0x1,%rdi
  6fad7f:	77 df                	ja     6fad60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1b0>
  6fad81:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  6fad85:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  6fad89:	0f 85 65 fe ff ff    	jne    6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad8f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  6fad93:	8b 70 08             	mov    0x8(%rax),%esi
  6fad96:	4c 89 f7             	mov    %r14,%rdi
  6fad99:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  6fad9e:	4c 89 c5             	mov    %r8,%rbp
  6fada1:	48 89 cb             	mov    %rcx,%rbx
  6fada4:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  6fada9:	49 89 d7             	mov    %rdx,%r15
  6fadac:	e8 0f 66 00 00       	call   7013c0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::editing_at>
  6fadb1:	4c 89 fa             	mov    %r15,%rdx
  6fadb4:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6fadb9:	48 89 d9             	mov    %rbx,%rcx
  6fadbc:	49 89 e8             	mov    %rbp,%r8
  6fadbf:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  6fadc4:	48 85 c0             	test   %rax,%rax
  6fadc7:	0f 84 27 fe ff ff    	je     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fadcd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fadd1:	0f 84 1d fe ff ff    	je     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fadd7:	48 8b 38             	mov    (%rax),%rdi
  6fadda:	4d 85 ff             	test   %r15,%r15
  6faddd:	74 19                	je     6fadf8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x248>
  6faddf:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  6fade6:	4c 31 fe             	xor    %r15,%rsi
  6fade9:	49 89 e9             	mov    %rbp,%r9
  6fadec:	49 31 f9             	xor    %rdi,%r9
  6fadef:	49 09 f1             	or     %rsi,%r9
  6fadf2:	40 0f 94 c6          	sete   %sil
  6fadf6:	eb 02                	jmp    6fadfa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x24a>
  6fadf8:	31 f6                	xor    %esi,%esi
  6fadfa:	44 8b 48 18          	mov    0x18(%rax),%r9d
  6fadfe:	8b 40 20             	mov    0x20(%rax),%eax
  6fae01:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  6fae08:	4d 85 d2             	test   %r10,%r10
  6fae0b:	74 17                	je     6fae24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x274>
  6fae0d:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  6fae14:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  6fae1b:	4c 09 d7             	or     %r10,%rdi
  6fae1e:	40 0f 94 c7          	sete   %dil
  6fae22:	eb 02                	jmp    6fae26 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x276>
  6fae24:	31 ff                	xor    %edi,%edi
  6fae26:	41 39 c1             	cmp    %eax,%r9d
  6fae29:	0f 85 c5 fd ff ff    	jne    6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fae2f:	40 30 fe             	xor    %dil,%sil
  6fae32:	0f 84 bc fd ff ff    	je     6fabf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fae38:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  6fae3f:	00 00 
  6fae41:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fae46:	4c 89 e7             	mov    %r12,%rdi
  6fae49:	4c 89 f6             	mov    %r14,%rsi
  6fae4c:	e8 3f 07 00 00       	call   6fb590 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>
  6fae51:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fae56:	0f 85 b8 fd ff ff    	jne    6fac14 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x64>
  6fae5c:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  6fae63:	48 85 c0             	test   %rax,%rax
  6fae66:	74 2a                	je     6fae92 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x2e2>
  6fae68:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fae6e:	0f 84 cb fd ff ff    	je     6fac3f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fae74:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  6fae79:	0f 85 c0 fd ff ff    	jne    6fac3f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fae7f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fae84:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  6fae8b:	74 11                	je     6fae9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x2ee>
  6fae8d:	e9 ad fd ff ff       	jmp    6fac3f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fae92:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fae98:	0f 85 a1 fd ff ff    	jne    6fac3f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fae9e:	4c 89 e7             	mov    %r12,%rdi
  6faea1:	4c 89 f6             	mov    %r14,%rsi
  6faea4:	4c 89 fa             	mov    %r15,%rdx
  6faea7:	48 89 e9             	mov    %rbp,%rcx
  6faeaa:	48 83 c4 48          	add    $0x48,%rsp
  6faeae:	5b                   	pop    %rbx
  6faeaf:	41 5c                	pop    %r12
  6faeb1:	41 5d                	pop    %r13
  6faeb3:	41 5e                	pop    %r14
  6faeb5:	41 5f                	pop    %r15
  6faeb7:	5d                   	pop    %rbp
  6faeb8:	e9 43 a4 00 00       	jmp    705300 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>
