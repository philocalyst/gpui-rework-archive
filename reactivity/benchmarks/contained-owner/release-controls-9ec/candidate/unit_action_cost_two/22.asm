
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000705300 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>:
  705300:	41 57                	push   %r15
  705302:	41 56                	push   %r14
  705304:	41 54                	push   %r12
  705306:	53                   	push   %rbx
  705307:	50                   	push   %rax
  705308:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70530f:	48 85 c0             	test   %rax,%rax
  705312:	74 12                	je     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705314:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  70531b:	48 85 c0             	test   %rax,%rax
  70531e:	74 06                	je     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705320:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705324:	75 63                	jne    705389 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x89>
  705326:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  70532d:	0f b6 86 20 08 00 00 	movzbl 0x820(%rsi),%eax
  705334:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  70533b:	00 
  70533c:	74 1c                	je     70535a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5a>
  70533e:	84 c0                	test   %al,%al
  705340:	74 0a                	je     70534c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x4c>
  705342:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  705349:	ff 
  70534a:	74 0e                	je     70535a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5a>
  70534c:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  705353:	b9 01 00 00 00       	mov    $0x1,%ecx
  705358:	eb 02                	jmp    70535c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x5c>
  70535a:	31 c9                	xor    %ecx,%ecx
  70535c:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  705363:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  705367:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  70536b:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  70536f:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  705373:	88 47 30             	mov    %al,0x30(%rdi)
  705376:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70537d:	48 83 c4 08          	add    $0x8,%rsp
  705381:	5b                   	pop    %rbx
  705382:	41 5c                	pop    %r12
  705384:	41 5e                	pop    %r14
  705386:	41 5f                	pop    %r15
  705388:	c3                   	ret
  705389:	48 8b 00             	mov    (%rax),%rax
  70538c:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  705393:	4d 85 c0             	test   %r8,%r8
  705396:	0f 84 99 00 00 00    	je     705435 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x135>
  70539c:	41 83 f8 01          	cmp    $0x1,%r8d
  7053a0:	0f 85 ab 00 00 00    	jne    705451 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x151>
  7053a6:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  7053ad:	4d 85 d2             	test   %r10,%r10
  7053b0:	0f 84 70 ff ff ff    	je     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7053b6:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  7053bd:	45 31 c9             	xor    %r9d,%r9d
  7053c0:	49 83 fa 01          	cmp    $0x1,%r10
  7053c4:	74 2e                	je     7053f4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0xf4>
  7053c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  7053cd:	00 00 00 
  7053d0:	4d 89 cb             	mov    %r9,%r11
  7053d3:	4c 89 d3             	mov    %r10,%rbx
  7053d6:	48 d1 eb             	shr    $1,%rbx
  7053d9:	49 01 d9             	add    %rbx,%r9
  7053dc:	4d 89 ce             	mov    %r9,%r14
  7053df:	49 c1 e6 04          	shl    $0x4,%r14
  7053e3:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  7053e7:	4d 0f 47 cb          	cmova  %r11,%r9
  7053eb:	49 29 da             	sub    %rbx,%r10
  7053ee:	49 83 fa 01          	cmp    $0x1,%r10
  7053f2:	77 dc                	ja     7053d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0xd0>
  7053f4:	4d 89 cb             	mov    %r9,%r11
  7053f7:	49 c1 e3 04          	shl    $0x4,%r11
  7053fb:	45 31 d2             	xor    %r10d,%r10d
  7053fe:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  705402:	41 0f 96 c2          	setbe  %r10b
  705406:	4d 01 ca             	add    %r9,%r10
  705409:	0f 84 17 ff ff ff    	je     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  70540f:	49 c1 e2 04          	shl    $0x4,%r10
  705413:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  705418:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  70541d:	4c 39 c8             	cmp    %r9,%rax
  705420:	0f 83 00 ff ff ff    	jae    705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705426:	4d 01 d0             	add    %r10,%r8
  705429:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  70542d:	4c 01 c0             	add    %r8,%rax
  705430:	e9 82 00 00 00       	jmp    7054b7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b7>
  705435:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  70543c:	0f 82 e4 fe ff ff    	jb     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705442:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  705449:	0f 83 d7 fe ff ff    	jae    705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  70544f:	eb 66                	jmp    7054b7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b7>
  705451:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  705458:	4d 85 c9             	test   %r9,%r9
  70545b:	0f 84 c5 fe ff ff    	je     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705461:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  705468:	49 83 f9 01          	cmp    $0x1,%r9
  70546c:	75 0b                	jne    705479 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x179>
  70546e:	49 39 00             	cmp    %rax,(%r8)
  705471:	0f 85 af fe ff ff    	jne    705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705477:	eb 3a                	jmp    7054b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x1b3>
  705479:	45 31 d2             	xor    %r10d,%r10d
  70547c:	0f 1f 40 00          	nopl   0x0(%rax)
  705480:	4d 89 d3             	mov    %r10,%r11
  705483:	4c 89 cb             	mov    %r9,%rbx
  705486:	48 d1 eb             	shr    $1,%rbx
  705489:	49 01 da             	add    %rbx,%r10
  70548c:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  705490:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  705494:	4d 0f 47 d3          	cmova  %r11,%r10
  705498:	49 29 d9             	sub    %rbx,%r9
  70549b:	49 83 f9 01          	cmp    $0x1,%r9
  70549f:	77 df                	ja     705480 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x180>
  7054a1:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  7054a5:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  7054a9:	0f 85 77 fe ff ff    	jne    705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7054af:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  7054b3:	41 8b 40 08          	mov    0x8(%r8),%eax
  7054b7:	48 89 fb             	mov    %rdi,%rbx
  7054ba:	48 89 f7             	mov    %rsi,%rdi
  7054bd:	49 89 f6             	mov    %rsi,%r14
  7054c0:	48 89 c6             	mov    %rax,%rsi
  7054c3:	49 89 cf             	mov    %rcx,%r15
  7054c6:	49 89 d4             	mov    %rdx,%r12
  7054c9:	e8 f2 be ff ff       	call   7013c0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::editing_at>
  7054ce:	4c 89 f6             	mov    %r14,%rsi
  7054d1:	48 89 df             	mov    %rbx,%rdi
  7054d4:	48 85 c0             	test   %rax,%rax
  7054d7:	0f 84 49 fe ff ff    	je     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7054dd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  7054e1:	0f 84 3f fe ff ff    	je     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  7054e7:	4c 89 e2             	mov    %r12,%rdx
  7054ea:	4c 89 f9             	mov    %r15,%rcx
  7054ed:	4c 8b 08             	mov    (%rax),%r9
  7054f0:	4d 85 e4             	test   %r12,%r12
  7054f3:	74 19                	je     70550e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x20e>
  7054f5:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  7054fc:	49 31 d0             	xor    %rdx,%r8
  7054ff:	49 89 ca             	mov    %rcx,%r10
  705502:	4d 31 ca             	xor    %r9,%r10
  705505:	4d 09 c2             	or     %r8,%r10
  705508:	41 0f 94 c0          	sete   %r8b
  70550c:	eb 03                	jmp    705511 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x211>
  70550e:	45 31 c0             	xor    %r8d,%r8d
  705511:	44 8b 50 18          	mov    0x18(%rax),%r10d
  705515:	8b 40 20             	mov    0x20(%rax),%eax
  705518:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  70551f:	4d 85 db             	test   %r11,%r11
  705522:	74 17                	je     70553b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x23b>
  705524:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  70552b:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  705532:	4d 09 d9             	or     %r11,%r9
  705535:	41 0f 94 c1          	sete   %r9b
  705539:	eb 03                	jmp    70553e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x23e>
  70553b:	45 31 c9             	xor    %r9d,%r9d
  70553e:	41 39 c2             	cmp    %eax,%r10d
  705541:	0f 85 df fd ff ff    	jne    705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705547:	45 30 c8             	xor    %r9b,%r8b
  70554a:	0f 84 d6 fd ff ff    	je     705326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x26>
  705550:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  705557:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  70555b:	74 28                	je     705585 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x285>
  70555d:	48 ff c0             	inc    %rax
  705560:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  705567:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  70556e:	c6 86 1f 08 00 00 01 	movb   $0x1,0x81f(%rsi)
  705575:	48 83 c4 08          	add    $0x8,%rsp
  705579:	5b                   	pop    %rbx
  70557a:	41 5c                	pop    %r12
  70557c:	41 5e                	pop    %r14
  70557e:	41 5f                	pop    %r15
  705580:	e9 fb 56 01 00       	jmp    71ac80 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  705585:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  70558c:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  705593:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  70559a:	e9 de fd ff ff       	jmp    70537d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change+0x7d>
