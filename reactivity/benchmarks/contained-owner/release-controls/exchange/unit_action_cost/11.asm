
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007072a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused>:
  7072a0:	55                   	push   %rbp
  7072a1:	41 57                	push   %r15
  7072a3:	41 56                	push   %r14
  7072a5:	41 55                	push   %r13
  7072a7:	41 54                	push   %r12
  7072a9:	53                   	push   %rbx
  7072aa:	48 83 ec 48          	sub    $0x48,%rsp
  7072ae:	4d 89 cf             	mov    %r9,%r15
  7072b1:	49 89 f6             	mov    %rsi,%r14
  7072b4:	49 89 fc             	mov    %rdi,%r12
  7072b7:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  7072be:	00 
  7072bf:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  7072c6:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  7072cd:	48 85 c0             	test   %rax,%rax
  7072d0:	74 12                	je     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7072d2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  7072d9:	48 85 c0             	test   %rax,%rax
  7072dc:	74 06                	je     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7072de:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  7072e2:	75 5a                	jne    70733e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x9e>
  7072e4:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  7072eb:	00 00 
  7072ed:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  7072f2:	4c 89 e7             	mov    %r12,%rdi
  7072f5:	4c 89 f6             	mov    %r14,%rsi
  7072f8:	e8 b3 09 00 00       	call   707cb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>
  7072fd:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  707302:	74 2b                	je     70732f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707304:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  70730b:	75 22                	jne    70732f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  70730d:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  707314:	01 
  707315:	75 18                	jne    70732f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707317:	41 80 be 22 07 00 00 	cmpb   $0x0,0x722(%r14)
  70731e:	00 
  70731f:	75 0e                	jne    70732f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707321:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  707328:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  70732f:	48 83 c4 48          	add    $0x48,%rsp
  707333:	5b                   	pop    %rbx
  707334:	41 5c                	pop    %r12
  707336:	41 5d                	pop    %r13
  707338:	41 5e                	pop    %r14
  70733a:	41 5f                	pop    %r15
  70733c:	5d                   	pop    %rbp
  70733d:	c3                   	ret
  70733e:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  707345:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  70734a:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  707351:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  707356:	48 8b 30             	mov    (%rax),%rsi
  707359:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  707360:	48 85 c0             	test   %rax,%rax
  707363:	0f 84 9b 00 00 00    	je     707404 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x164>
  707369:	83 f8 01             	cmp    $0x1,%eax
  70736c:	0f 85 ae 00 00 00    	jne    707420 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x180>
  707372:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  707379:	4d 85 c9             	test   %r9,%r9
  70737c:	0f 84 62 ff ff ff    	je     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707382:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  707389:	31 ff                	xor    %edi,%edi
  70738b:	49 83 f9 01          	cmp    $0x1,%r9
  70738f:	74 33                	je     7073c4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x124>
  707391:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  707398:	0f 1f 84 00 00 00 00 
  70739f:	00 
  7073a0:	49 89 fa             	mov    %rdi,%r10
  7073a3:	4d 89 cb             	mov    %r9,%r11
  7073a6:	49 d1 eb             	shr    $1,%r11
  7073a9:	4c 01 df             	add    %r11,%rdi
  7073ac:	48 89 fb             	mov    %rdi,%rbx
  7073af:	48 c1 e3 04          	shl    $0x4,%rbx
  7073b3:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  7073b7:	49 0f 47 fa          	cmova  %r10,%rdi
  7073bb:	4d 29 d9             	sub    %r11,%r9
  7073be:	49 83 f9 01          	cmp    $0x1,%r9
  7073c2:	77 dc                	ja     7073a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x100>
  7073c4:	49 89 fa             	mov    %rdi,%r10
  7073c7:	49 c1 e2 04          	shl    $0x4,%r10
  7073cb:	45 31 c9             	xor    %r9d,%r9d
  7073ce:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  7073d2:	41 0f 96 c1          	setbe  %r9b
  7073d6:	49 01 f9             	add    %rdi,%r9
  7073d9:	0f 84 05 ff ff ff    	je     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7073df:	49 c1 e1 04          	shl    $0x4,%r9
  7073e3:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  7073e8:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  7073ed:	48 39 fe             	cmp    %rdi,%rsi
  7073f0:	0f 83 ee fe ff ff    	jae    7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7073f6:	4c 01 c8             	add    %r9,%rax
  7073f9:	8b 40 f8             	mov    -0x8(%rax),%eax
  7073fc:	48 01 c6             	add    %rax,%rsi
  7073ff:	e9 82 00 00 00       	jmp    707486 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e6>
  707404:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  70740b:	0f 82 d3 fe ff ff    	jb     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707411:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  707418:	0f 83 c6 fe ff ff    	jae    7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70741e:	eb 66                	jmp    707486 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e6>
  707420:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  707427:	48 85 ff             	test   %rdi,%rdi
  70742a:	0f 84 b4 fe ff ff    	je     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707430:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  707437:	48 83 ff 01          	cmp    $0x1,%rdi
  70743b:	75 0b                	jne    707448 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1a8>
  70743d:	48 39 30             	cmp    %rsi,(%rax)
  707440:	0f 85 9e fe ff ff    	jne    7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707446:	eb 3b                	jmp    707483 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e3>
  707448:	45 31 c9             	xor    %r9d,%r9d
  70744b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  707450:	4d 89 ca             	mov    %r9,%r10
  707453:	49 89 fb             	mov    %rdi,%r11
  707456:	49 d1 eb             	shr    $1,%r11
  707459:	4d 01 d9             	add    %r11,%r9
  70745c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  707460:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  707464:	4d 0f 47 ca          	cmova  %r10,%r9
  707468:	4c 29 df             	sub    %r11,%rdi
  70746b:	48 83 ff 01          	cmp    $0x1,%rdi
  70746f:	77 df                	ja     707450 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1b0>
  707471:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  707475:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  707479:	0f 85 65 fe ff ff    	jne    7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70747f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  707483:	8b 70 08             	mov    0x8(%rax),%esi
  707486:	4c 89 f7             	mov    %r14,%rdi
  707489:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  70748e:	4c 89 c5             	mov    %r8,%rbp
  707491:	48 89 cb             	mov    %rcx,%rbx
  707494:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  707499:	49 89 d7             	mov    %rdx,%r15
  70749c:	e8 5f 31 00 00       	call   70a600 <<gpui::runtime::Runtime<unit_action_cost::Model>>::editing_at>
  7074a1:	4c 89 fa             	mov    %r15,%rdx
  7074a4:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  7074a9:	48 89 d9             	mov    %rbx,%rcx
  7074ac:	49 89 e8             	mov    %rbp,%r8
  7074af:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  7074b4:	48 85 c0             	test   %rax,%rax
  7074b7:	0f 84 27 fe ff ff    	je     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7074bd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  7074c1:	0f 84 1d fe ff ff    	je     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7074c7:	48 8b 38             	mov    (%rax),%rdi
  7074ca:	4d 85 ff             	test   %r15,%r15
  7074cd:	74 19                	je     7074e8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x248>
  7074cf:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  7074d6:	4c 31 fe             	xor    %r15,%rsi
  7074d9:	49 89 e9             	mov    %rbp,%r9
  7074dc:	49 31 f9             	xor    %rdi,%r9
  7074df:	49 09 f1             	or     %rsi,%r9
  7074e2:	40 0f 94 c6          	sete   %sil
  7074e6:	eb 02                	jmp    7074ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x24a>
  7074e8:	31 f6                	xor    %esi,%esi
  7074ea:	44 8b 48 18          	mov    0x18(%rax),%r9d
  7074ee:	8b 40 20             	mov    0x20(%rax),%eax
  7074f1:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  7074f8:	4d 85 d2             	test   %r10,%r10
  7074fb:	74 17                	je     707514 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x274>
  7074fd:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  707504:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  70750b:	4c 09 d7             	or     %r10,%rdi
  70750e:	40 0f 94 c7          	sete   %dil
  707512:	eb 02                	jmp    707516 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x276>
  707514:	31 ff                	xor    %edi,%edi
  707516:	41 39 c1             	cmp    %eax,%r9d
  707519:	0f 85 c5 fd ff ff    	jne    7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70751f:	40 30 fe             	xor    %dil,%sil
  707522:	0f 84 bc fd ff ff    	je     7072e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707528:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  70752f:	00 00 
  707531:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  707536:	4c 89 e7             	mov    %r12,%rdi
  707539:	4c 89 f6             	mov    %r14,%rsi
  70753c:	e8 6f 07 00 00       	call   707cb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>
  707541:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  707546:	0f 85 b8 fd ff ff    	jne    707304 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x64>
  70754c:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  707553:	48 85 c0             	test   %rax,%rax
  707556:	74 2a                	je     707582 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x2e2>
  707558:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  70755e:	0f 84 cb fd ff ff    	je     70732f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707564:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  707569:	0f 85 c0 fd ff ff    	jne    70732f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  70756f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  707574:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  70757b:	74 11                	je     70758e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x2ee>
  70757d:	e9 ad fd ff ff       	jmp    70732f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707582:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  707588:	0f 85 a1 fd ff ff    	jne    70732f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  70758e:	4c 89 e7             	mov    %r12,%rdi
  707591:	4c 89 f6             	mov    %r14,%rsi
  707594:	4c 89 fa             	mov    %r15,%rdx
  707597:	48 89 e9             	mov    %rbp,%rcx
  70759a:	48 83 c4 48          	add    $0x48,%rsp
  70759e:	5b                   	pop    %rbx
  70759f:	41 5c                	pop    %r12
  7075a1:	41 5d                	pop    %r13
  7075a3:	41 5e                	pop    %r14
  7075a5:	41 5f                	pop    %r15
  7075a7:	5d                   	pop    %rbp
  7075a8:	e9 c3 53 00 00       	jmp    70c970 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>
