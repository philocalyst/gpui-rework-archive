
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000703fa0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>:
  703fa0:	41 57                	push   %r15
  703fa2:	41 56                	push   %r14
  703fa4:	41 54                	push   %r12
  703fa6:	53                   	push   %rbx
  703fa7:	50                   	push   %rax
  703fa8:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  703faf:	48 85 c0             	test   %rax,%rax
  703fb2:	74 12                	je     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  703fb4:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  703fbb:	48 85 c0             	test   %rax,%rax
  703fbe:	74 06                	je     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  703fc0:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  703fc4:	75 63                	jne    704029 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x89>
  703fc6:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  703fcd:	0f b6 86 20 08 00 00 	movzbl 0x820(%rsi),%eax
  703fd4:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  703fdb:	00 
  703fdc:	74 1c                	je     703ffa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5a>
  703fde:	84 c0                	test   %al,%al
  703fe0:	74 0a                	je     703fec <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x4c>
  703fe2:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  703fe9:	ff 
  703fea:	74 0e                	je     703ffa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5a>
  703fec:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  703ff3:	b9 01 00 00 00       	mov    $0x1,%ecx
  703ff8:	eb 02                	jmp    703ffc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5c>
  703ffa:	31 c9                	xor    %ecx,%ecx
  703ffc:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  704003:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  704007:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  70400b:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  70400f:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  704013:	88 47 30             	mov    %al,0x30(%rdi)
  704016:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70401d:	48 83 c4 08          	add    $0x8,%rsp
  704021:	5b                   	pop    %rbx
  704022:	41 5c                	pop    %r12
  704024:	41 5e                	pop    %r14
  704026:	41 5f                	pop    %r15
  704028:	c3                   	ret
  704029:	48 8b 00             	mov    (%rax),%rax
  70402c:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  704033:	4d 85 c0             	test   %r8,%r8
  704036:	0f 84 99 00 00 00    	je     7040d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x135>
  70403c:	41 83 f8 01          	cmp    $0x1,%r8d
  704040:	0f 85 ab 00 00 00    	jne    7040f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x151>
  704046:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  70404d:	4d 85 d2             	test   %r10,%r10
  704050:	0f 84 70 ff ff ff    	je     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  704056:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  70405d:	45 31 c9             	xor    %r9d,%r9d
  704060:	49 83 fa 01          	cmp    $0x1,%r10
  704064:	74 2e                	je     704094 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0xf4>
  704066:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  70406d:	00 00 00 
  704070:	4d 89 cb             	mov    %r9,%r11
  704073:	4c 89 d3             	mov    %r10,%rbx
  704076:	48 d1 eb             	shr    $1,%rbx
  704079:	49 01 d9             	add    %rbx,%r9
  70407c:	4d 89 ce             	mov    %r9,%r14
  70407f:	49 c1 e6 04          	shl    $0x4,%r14
  704083:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  704087:	4d 0f 47 cb          	cmova  %r11,%r9
  70408b:	49 29 da             	sub    %rbx,%r10
  70408e:	49 83 fa 01          	cmp    $0x1,%r10
  704092:	77 dc                	ja     704070 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0xd0>
  704094:	4d 89 cb             	mov    %r9,%r11
  704097:	49 c1 e3 04          	shl    $0x4,%r11
  70409b:	45 31 d2             	xor    %r10d,%r10d
  70409e:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  7040a2:	41 0f 96 c2          	setbe  %r10b
  7040a6:	4d 01 ca             	add    %r9,%r10
  7040a9:	0f 84 17 ff ff ff    	je     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7040af:	49 c1 e2 04          	shl    $0x4,%r10
  7040b3:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  7040b8:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  7040bd:	4c 39 c8             	cmp    %r9,%rax
  7040c0:	0f 83 00 ff ff ff    	jae    703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7040c6:	4d 01 d0             	add    %r10,%r8
  7040c9:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  7040cd:	4c 01 c0             	add    %r8,%rax
  7040d0:	e9 82 00 00 00       	jmp    704157 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b7>
  7040d5:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  7040dc:	0f 82 e4 fe ff ff    	jb     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7040e2:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  7040e9:	0f 83 d7 fe ff ff    	jae    703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7040ef:	eb 66                	jmp    704157 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b7>
  7040f1:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  7040f8:	4d 85 c9             	test   %r9,%r9
  7040fb:	0f 84 c5 fe ff ff    	je     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  704101:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  704108:	49 83 f9 01          	cmp    $0x1,%r9
  70410c:	75 0b                	jne    704119 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x179>
  70410e:	49 39 00             	cmp    %rax,(%r8)
  704111:	0f 85 af fe ff ff    	jne    703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  704117:	eb 3a                	jmp    704153 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b3>
  704119:	45 31 d2             	xor    %r10d,%r10d
  70411c:	0f 1f 40 00          	nopl   0x0(%rax)
  704120:	4d 89 d3             	mov    %r10,%r11
  704123:	4c 89 cb             	mov    %r9,%rbx
  704126:	48 d1 eb             	shr    $1,%rbx
  704129:	49 01 da             	add    %rbx,%r10
  70412c:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  704130:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  704134:	4d 0f 47 d3          	cmova  %r11,%r10
  704138:	49 29 d9             	sub    %rbx,%r9
  70413b:	49 83 f9 01          	cmp    $0x1,%r9
  70413f:	77 df                	ja     704120 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x180>
  704141:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  704145:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  704149:	0f 85 77 fe ff ff    	jne    703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  70414f:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  704153:	41 8b 40 08          	mov    0x8(%r8),%eax
  704157:	48 89 fb             	mov    %rdi,%rbx
  70415a:	48 89 f7             	mov    %rsi,%rdi
  70415d:	49 89 f6             	mov    %rsi,%r14
  704160:	48 89 c6             	mov    %rax,%rsi
  704163:	49 89 cf             	mov    %rcx,%r15
  704166:	49 89 d4             	mov    %rdx,%r12
  704169:	e8 f2 be ff ff       	call   700060 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::editing_at>
  70416e:	4c 89 f6             	mov    %r14,%rsi
  704171:	48 89 df             	mov    %rbx,%rdi
  704174:	48 85 c0             	test   %rax,%rax
  704177:	0f 84 49 fe ff ff    	je     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  70417d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  704181:	0f 84 3f fe ff ff    	je     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  704187:	4c 89 e2             	mov    %r12,%rdx
  70418a:	4c 89 f9             	mov    %r15,%rcx
  70418d:	4c 8b 08             	mov    (%rax),%r9
  704190:	4d 85 e4             	test   %r12,%r12
  704193:	74 19                	je     7041ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x20e>
  704195:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  70419c:	49 31 d0             	xor    %rdx,%r8
  70419f:	49 89 ca             	mov    %rcx,%r10
  7041a2:	4d 31 ca             	xor    %r9,%r10
  7041a5:	4d 09 c2             	or     %r8,%r10
  7041a8:	41 0f 94 c0          	sete   %r8b
  7041ac:	eb 03                	jmp    7041b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x211>
  7041ae:	45 31 c0             	xor    %r8d,%r8d
  7041b1:	44 8b 50 18          	mov    0x18(%rax),%r10d
  7041b5:	8b 40 20             	mov    0x20(%rax),%eax
  7041b8:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  7041bf:	4d 85 db             	test   %r11,%r11
  7041c2:	74 17                	je     7041db <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x23b>
  7041c4:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  7041cb:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  7041d2:	4d 09 d9             	or     %r11,%r9
  7041d5:	41 0f 94 c1          	sete   %r9b
  7041d9:	eb 03                	jmp    7041de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x23e>
  7041db:	45 31 c9             	xor    %r9d,%r9d
  7041de:	41 39 c2             	cmp    %eax,%r10d
  7041e1:	0f 85 df fd ff ff    	jne    703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7041e7:	45 30 c8             	xor    %r9b,%r8b
  7041ea:	0f 84 d6 fd ff ff    	je     703fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7041f0:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  7041f7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7041fb:	74 28                	je     704225 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x285>
  7041fd:	48 ff c0             	inc    %rax
  704200:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  704207:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  70420e:	c6 86 1f 08 00 00 01 	movb   $0x1,0x81f(%rsi)
  704215:	48 83 c4 08          	add    $0x8,%rsp
  704219:	5b                   	pop    %rbx
  70421a:	41 5c                	pop    %r12
  70421c:	41 5e                	pop    %r14
  70421e:	41 5f                	pop    %r15
  704220:	e9 fb 56 01 00       	jmp    719920 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  704225:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  70422c:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  704233:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  70423a:	e9 de fd ff ff       	jmp    70401d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x7d>
