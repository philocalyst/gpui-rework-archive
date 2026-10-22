
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000705270 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>:
  705270:	41 57                	push   %r15
  705272:	41 56                	push   %r14
  705274:	41 54                	push   %r12
  705276:	53                   	push   %rbx
  705277:	50                   	push   %rax
  705278:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70527f:	48 85 c0             	test   %rax,%rax
  705282:	74 12                	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705284:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  70528b:	48 85 c0             	test   %rax,%rax
  70528e:	74 06                	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705290:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705294:	75 63                	jne    7052f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x89>
  705296:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  70529d:	0f b6 86 20 08 00 00 	movzbl 0x820(%rsi),%eax
  7052a4:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  7052ab:	00 
  7052ac:	74 1c                	je     7052ca <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5a>
  7052ae:	84 c0                	test   %al,%al
  7052b0:	74 0a                	je     7052bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x4c>
  7052b2:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  7052b9:	ff 
  7052ba:	74 0e                	je     7052ca <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5a>
  7052bc:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  7052c3:	b9 01 00 00 00       	mov    $0x1,%ecx
  7052c8:	eb 02                	jmp    7052cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5c>
  7052ca:	31 c9                	xor    %ecx,%ecx
  7052cc:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  7052d3:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  7052d7:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  7052db:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  7052df:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  7052e3:	88 47 30             	mov    %al,0x30(%rdi)
  7052e6:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  7052ed:	48 83 c4 08          	add    $0x8,%rsp
  7052f1:	5b                   	pop    %rbx
  7052f2:	41 5c                	pop    %r12
  7052f4:	41 5e                	pop    %r14
  7052f6:	41 5f                	pop    %r15
  7052f8:	c3                   	ret
  7052f9:	48 8b 00             	mov    (%rax),%rax
  7052fc:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  705303:	4d 85 c0             	test   %r8,%r8
  705306:	0f 84 99 00 00 00    	je     7053a5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x135>
  70530c:	41 83 f8 01          	cmp    $0x1,%r8d
  705310:	0f 85 ab 00 00 00    	jne    7053c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x151>
  705316:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  70531d:	4d 85 d2             	test   %r10,%r10
  705320:	0f 84 70 ff ff ff    	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705326:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  70532d:	45 31 c9             	xor    %r9d,%r9d
  705330:	49 83 fa 01          	cmp    $0x1,%r10
  705334:	74 2e                	je     705364 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0xf4>
  705336:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  70533d:	00 00 00 
  705340:	4d 89 cb             	mov    %r9,%r11
  705343:	4c 89 d3             	mov    %r10,%rbx
  705346:	48 d1 eb             	shr    $1,%rbx
  705349:	49 01 d9             	add    %rbx,%r9
  70534c:	4d 89 ce             	mov    %r9,%r14
  70534f:	49 c1 e6 04          	shl    $0x4,%r14
  705353:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  705357:	4d 0f 47 cb          	cmova  %r11,%r9
  70535b:	49 29 da             	sub    %rbx,%r10
  70535e:	49 83 fa 01          	cmp    $0x1,%r10
  705362:	77 dc                	ja     705340 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0xd0>
  705364:	4d 89 cb             	mov    %r9,%r11
  705367:	49 c1 e3 04          	shl    $0x4,%r11
  70536b:	45 31 d2             	xor    %r10d,%r10d
  70536e:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  705372:	41 0f 96 c2          	setbe  %r10b
  705376:	4d 01 ca             	add    %r9,%r10
  705379:	0f 84 17 ff ff ff    	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  70537f:	49 c1 e2 04          	shl    $0x4,%r10
  705383:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  705388:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  70538d:	4c 39 c8             	cmp    %r9,%rax
  705390:	0f 83 00 ff ff ff    	jae    705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705396:	4d 01 d0             	add    %r10,%r8
  705399:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  70539d:	4c 01 c0             	add    %r8,%rax
  7053a0:	e9 82 00 00 00       	jmp    705427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b7>
  7053a5:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  7053ac:	0f 82 e4 fe ff ff    	jb     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7053b2:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  7053b9:	0f 83 d7 fe ff ff    	jae    705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7053bf:	eb 66                	jmp    705427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b7>
  7053c1:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  7053c8:	4d 85 c9             	test   %r9,%r9
  7053cb:	0f 84 c5 fe ff ff    	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7053d1:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  7053d8:	49 83 f9 01          	cmp    $0x1,%r9
  7053dc:	75 0b                	jne    7053e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x179>
  7053de:	49 39 00             	cmp    %rax,(%r8)
  7053e1:	0f 85 af fe ff ff    	jne    705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7053e7:	eb 3a                	jmp    705423 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b3>
  7053e9:	45 31 d2             	xor    %r10d,%r10d
  7053ec:	0f 1f 40 00          	nopl   0x0(%rax)
  7053f0:	4d 89 d3             	mov    %r10,%r11
  7053f3:	4c 89 cb             	mov    %r9,%rbx
  7053f6:	48 d1 eb             	shr    $1,%rbx
  7053f9:	49 01 da             	add    %rbx,%r10
  7053fc:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  705400:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  705404:	4d 0f 47 d3          	cmova  %r11,%r10
  705408:	49 29 d9             	sub    %rbx,%r9
  70540b:	49 83 f9 01          	cmp    $0x1,%r9
  70540f:	77 df                	ja     7053f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x180>
  705411:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  705415:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  705419:	0f 85 77 fe ff ff    	jne    705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  70541f:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  705423:	41 8b 40 08          	mov    0x8(%r8),%eax
  705427:	48 89 fb             	mov    %rdi,%rbx
  70542a:	48 89 f7             	mov    %rsi,%rdi
  70542d:	49 89 f6             	mov    %rsi,%r14
  705430:	48 89 c6             	mov    %rax,%rsi
  705433:	49 89 cf             	mov    %rcx,%r15
  705436:	49 89 d4             	mov    %rdx,%r12
  705439:	e8 f2 be ff ff       	call   701330 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::editing_at>
  70543e:	4c 89 f6             	mov    %r14,%rsi
  705441:	48 89 df             	mov    %rbx,%rdi
  705444:	48 85 c0             	test   %rax,%rax
  705447:	0f 84 49 fe ff ff    	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  70544d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705451:	0f 84 3f fe ff ff    	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705457:	4c 89 e2             	mov    %r12,%rdx
  70545a:	4c 89 f9             	mov    %r15,%rcx
  70545d:	4c 8b 08             	mov    (%rax),%r9
  705460:	4d 85 e4             	test   %r12,%r12
  705463:	74 19                	je     70547e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x20e>
  705465:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  70546c:	49 31 d0             	xor    %rdx,%r8
  70546f:	49 89 ca             	mov    %rcx,%r10
  705472:	4d 31 ca             	xor    %r9,%r10
  705475:	4d 09 c2             	or     %r8,%r10
  705478:	41 0f 94 c0          	sete   %r8b
  70547c:	eb 03                	jmp    705481 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x211>
  70547e:	45 31 c0             	xor    %r8d,%r8d
  705481:	44 8b 50 18          	mov    0x18(%rax),%r10d
  705485:	8b 40 20             	mov    0x20(%rax),%eax
  705488:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  70548f:	4d 85 db             	test   %r11,%r11
  705492:	74 17                	je     7054ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x23b>
  705494:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  70549b:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  7054a2:	4d 09 d9             	or     %r11,%r9
  7054a5:	41 0f 94 c1          	sete   %r9b
  7054a9:	eb 03                	jmp    7054ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x23e>
  7054ab:	45 31 c9             	xor    %r9d,%r9d
  7054ae:	41 39 c2             	cmp    %eax,%r10d
  7054b1:	0f 85 df fd ff ff    	jne    705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7054b7:	45 30 c8             	xor    %r9b,%r8b
  7054ba:	0f 84 d6 fd ff ff    	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7054c0:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  7054c7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7054cb:	74 28                	je     7054f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x285>
  7054cd:	48 ff c0             	inc    %rax
  7054d0:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  7054d7:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  7054de:	c6 86 1f 08 00 00 01 	movb   $0x1,0x81f(%rsi)
  7054e5:	48 83 c4 08          	add    $0x8,%rsp
  7054e9:	5b                   	pop    %rbx
  7054ea:	41 5c                	pop    %r12
  7054ec:	41 5e                	pop    %r14
  7054ee:	41 5f                	pop    %r15
  7054f0:	e9 fb 56 01 00       	jmp    71abf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  7054f5:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  7054fc:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  705503:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  70550a:	e9 de fd ff ff       	jmp    7052ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x7d>
