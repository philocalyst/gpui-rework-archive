
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fabc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused>:
  6fabc0:	55                   	push   %rbp
  6fabc1:	41 57                	push   %r15
  6fabc3:	41 56                	push   %r14
  6fabc5:	41 55                	push   %r13
  6fabc7:	41 54                	push   %r12
  6fabc9:	53                   	push   %rbx
  6fabca:	48 83 ec 48          	sub    $0x48,%rsp
  6fabce:	4d 89 cf             	mov    %r9,%r15
  6fabd1:	49 89 f6             	mov    %rsi,%r14
  6fabd4:	49 89 fc             	mov    %rdi,%r12
  6fabd7:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  6fabde:	00 
  6fabdf:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  6fabe6:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  6fabed:	48 85 c0             	test   %rax,%rax
  6fabf0:	74 12                	je     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fabf2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fabf9:	48 85 c0             	test   %rax,%rax
  6fabfc:	74 06                	je     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fabfe:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fac02:	75 5a                	jne    6fac5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x9e>
  6fac04:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  6fac0b:	00 00 
  6fac0d:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fac12:	4c 89 e7             	mov    %r12,%rdi
  6fac15:	4c 89 f6             	mov    %r14,%rsi
  6fac18:	e8 b3 09 00 00       	call   6fb5d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>
  6fac1d:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fac22:	74 2b                	je     6fac4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fac24:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  6fac2b:	75 22                	jne    6fac4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fac2d:	41 80 be 1e 08 00 00 	cmpb   $0x1,0x81e(%r14)
  6fac34:	01 
  6fac35:	75 18                	jne    6fac4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fac37:	41 80 be 22 08 00 00 	cmpb   $0x0,0x822(%r14)
  6fac3e:	00 
  6fac3f:	75 0e                	jne    6fac4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fac41:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  6fac48:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  6fac4f:	48 83 c4 48          	add    $0x48,%rsp
  6fac53:	5b                   	pop    %rbx
  6fac54:	41 5c                	pop    %r12
  6fac56:	41 5d                	pop    %r13
  6fac58:	41 5e                	pop    %r14
  6fac5a:	41 5f                	pop    %r15
  6fac5c:	5d                   	pop    %rbp
  6fac5d:	c3                   	ret
  6fac5e:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  6fac65:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  6fac6a:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  6fac71:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fac76:	48 8b 30             	mov    (%rax),%rsi
  6fac79:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  6fac80:	48 85 c0             	test   %rax,%rax
  6fac83:	0f 84 9b 00 00 00    	je     6fad24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x164>
  6fac89:	83 f8 01             	cmp    $0x1,%eax
  6fac8c:	0f 85 ae 00 00 00    	jne    6fad40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x180>
  6fac92:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  6fac99:	4d 85 c9             	test   %r9,%r9
  6fac9c:	0f 84 62 ff ff ff    	je     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6faca2:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6faca9:	31 ff                	xor    %edi,%edi
  6facab:	49 83 f9 01          	cmp    $0x1,%r9
  6facaf:	74 33                	je     6face4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x124>
  6facb1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6facb8:	0f 1f 84 00 00 00 00 
  6facbf:	00 
  6facc0:	49 89 fa             	mov    %rdi,%r10
  6facc3:	4d 89 cb             	mov    %r9,%r11
  6facc6:	49 d1 eb             	shr    $1,%r11
  6facc9:	4c 01 df             	add    %r11,%rdi
  6faccc:	48 89 fb             	mov    %rdi,%rbx
  6faccf:	48 c1 e3 04          	shl    $0x4,%rbx
  6facd3:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  6facd7:	49 0f 47 fa          	cmova  %r10,%rdi
  6facdb:	4d 29 d9             	sub    %r11,%r9
  6facde:	49 83 f9 01          	cmp    $0x1,%r9
  6face2:	77 dc                	ja     6facc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x100>
  6face4:	49 89 fa             	mov    %rdi,%r10
  6face7:	49 c1 e2 04          	shl    $0x4,%r10
  6faceb:	45 31 c9             	xor    %r9d,%r9d
  6facee:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  6facf2:	41 0f 96 c1          	setbe  %r9b
  6facf6:	49 01 f9             	add    %rdi,%r9
  6facf9:	0f 84 05 ff ff ff    	je     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6facff:	49 c1 e1 04          	shl    $0x4,%r9
  6fad03:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  6fad08:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  6fad0d:	48 39 fe             	cmp    %rdi,%rsi
  6fad10:	0f 83 ee fe ff ff    	jae    6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad16:	4c 01 c8             	add    %r9,%rax
  6fad19:	8b 40 f8             	mov    -0x8(%rax),%eax
  6fad1c:	48 01 c6             	add    %rax,%rsi
  6fad1f:	e9 82 00 00 00       	jmp    6fada6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e6>
  6fad24:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  6fad2b:	0f 82 d3 fe ff ff    	jb     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad31:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  6fad38:	0f 83 c6 fe ff ff    	jae    6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad3e:	eb 66                	jmp    6fada6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e6>
  6fad40:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  6fad47:	48 85 ff             	test   %rdi,%rdi
  6fad4a:	0f 84 b4 fe ff ff    	je     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad50:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fad57:	48 83 ff 01          	cmp    $0x1,%rdi
  6fad5b:	75 0b                	jne    6fad68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1a8>
  6fad5d:	48 39 30             	cmp    %rsi,(%rax)
  6fad60:	0f 85 9e fe ff ff    	jne    6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad66:	eb 3b                	jmp    6fada3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e3>
  6fad68:	45 31 c9             	xor    %r9d,%r9d
  6fad6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6fad70:	4d 89 ca             	mov    %r9,%r10
  6fad73:	49 89 fb             	mov    %rdi,%r11
  6fad76:	49 d1 eb             	shr    $1,%r11
  6fad79:	4d 01 d9             	add    %r11,%r9
  6fad7c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  6fad80:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  6fad84:	4d 0f 47 ca          	cmova  %r10,%r9
  6fad88:	4c 29 df             	sub    %r11,%rdi
  6fad8b:	48 83 ff 01          	cmp    $0x1,%rdi
  6fad8f:	77 df                	ja     6fad70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1b0>
  6fad91:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  6fad95:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  6fad99:	0f 85 65 fe ff ff    	jne    6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fad9f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  6fada3:	8b 70 08             	mov    0x8(%rax),%esi
  6fada6:	4c 89 f7             	mov    %r14,%rdi
  6fada9:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  6fadae:	4c 89 c5             	mov    %r8,%rbp
  6fadb1:	48 89 cb             	mov    %rcx,%rbx
  6fadb4:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  6fadb9:	49 89 d7             	mov    %rdx,%r15
  6fadbc:	e8 6f 66 00 00       	call   701430 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::editing_at>
  6fadc1:	4c 89 fa             	mov    %r15,%rdx
  6fadc4:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6fadc9:	48 89 d9             	mov    %rbx,%rcx
  6fadcc:	49 89 e8             	mov    %rbp,%r8
  6fadcf:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  6fadd4:	48 85 c0             	test   %rax,%rax
  6fadd7:	0f 84 27 fe ff ff    	je     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6faddd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fade1:	0f 84 1d fe ff ff    	je     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fade7:	48 8b 38             	mov    (%rax),%rdi
  6fadea:	4d 85 ff             	test   %r15,%r15
  6faded:	74 19                	je     6fae08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x248>
  6fadef:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  6fadf6:	4c 31 fe             	xor    %r15,%rsi
  6fadf9:	49 89 e9             	mov    %rbp,%r9
  6fadfc:	49 31 f9             	xor    %rdi,%r9
  6fadff:	49 09 f1             	or     %rsi,%r9
  6fae02:	40 0f 94 c6          	sete   %sil
  6fae06:	eb 02                	jmp    6fae0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x24a>
  6fae08:	31 f6                	xor    %esi,%esi
  6fae0a:	44 8b 48 18          	mov    0x18(%rax),%r9d
  6fae0e:	8b 40 20             	mov    0x20(%rax),%eax
  6fae11:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  6fae18:	4d 85 d2             	test   %r10,%r10
  6fae1b:	74 17                	je     6fae34 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x274>
  6fae1d:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  6fae24:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  6fae2b:	4c 09 d7             	or     %r10,%rdi
  6fae2e:	40 0f 94 c7          	sete   %dil
  6fae32:	eb 02                	jmp    6fae36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x276>
  6fae34:	31 ff                	xor    %edi,%edi
  6fae36:	41 39 c1             	cmp    %eax,%r9d
  6fae39:	0f 85 c5 fd ff ff    	jne    6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fae3f:	40 30 fe             	xor    %dil,%sil
  6fae42:	0f 84 bc fd ff ff    	je     6fac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fae48:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  6fae4f:	00 00 
  6fae51:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fae56:	4c 89 e7             	mov    %r12,%rdi
  6fae59:	4c 89 f6             	mov    %r14,%rsi
  6fae5c:	e8 6f 07 00 00       	call   6fb5d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>
  6fae61:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fae66:	0f 85 b8 fd ff ff    	jne    6fac24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x64>
  6fae6c:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  6fae73:	48 85 c0             	test   %rax,%rax
  6fae76:	74 2a                	je     6faea2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x2e2>
  6fae78:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fae7e:	0f 84 cb fd ff ff    	je     6fac4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fae84:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  6fae89:	0f 85 c0 fd ff ff    	jne    6fac4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fae8f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fae94:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  6fae9b:	74 11                	je     6faeae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x2ee>
  6fae9d:	e9 ad fd ff ff       	jmp    6fac4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6faea2:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6faea8:	0f 85 a1 fd ff ff    	jne    6fac4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6faeae:	4c 89 e7             	mov    %r12,%rdi
  6faeb1:	4c 89 f6             	mov    %r14,%rsi
  6faeb4:	4c 89 fa             	mov    %r15,%rdx
  6faeb7:	48 89 e9             	mov    %rbp,%rcx
  6faeba:	48 83 c4 48          	add    $0x48,%rsp
  6faebe:	5b                   	pop    %rbx
  6faebf:	41 5c                	pop    %r12
  6faec1:	41 5d                	pop    %r13
  6faec3:	41 5e                	pop    %r14
  6faec5:	41 5f                	pop    %r15
  6faec7:	5d                   	pop    %rbp
  6faec8:	e9 a3 a4 00 00       	jmp    705370 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>
