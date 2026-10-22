
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007073b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused>:
  7073b0:	55                   	push   %rbp
  7073b1:	41 57                	push   %r15
  7073b3:	41 56                	push   %r14
  7073b5:	41 55                	push   %r13
  7073b7:	41 54                	push   %r12
  7073b9:	53                   	push   %rbx
  7073ba:	48 83 ec 48          	sub    $0x48,%rsp
  7073be:	4d 89 cf             	mov    %r9,%r15
  7073c1:	49 89 f6             	mov    %rsi,%r14
  7073c4:	49 89 fc             	mov    %rdi,%r12
  7073c7:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  7073ce:	00 
  7073cf:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  7073d6:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  7073dd:	48 85 c0             	test   %rax,%rax
  7073e0:	74 12                	je     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7073e2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  7073e9:	48 85 c0             	test   %rax,%rax
  7073ec:	74 06                	je     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7073ee:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  7073f2:	75 5a                	jne    70744e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x9e>
  7073f4:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  7073fb:	00 00 
  7073fd:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  707402:	4c 89 e7             	mov    %r12,%rdi
  707405:	4c 89 f6             	mov    %r14,%rsi
  707408:	e8 b3 09 00 00       	call   707dc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>
  70740d:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  707412:	74 2b                	je     70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707414:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  70741b:	75 22                	jne    70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  70741d:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  707424:	01 
  707425:	75 18                	jne    70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707427:	41 80 be 22 07 00 00 	cmpb   $0x0,0x722(%r14)
  70742e:	00 
  70742f:	75 0e                	jne    70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707431:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  707438:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  70743f:	48 83 c4 48          	add    $0x48,%rsp
  707443:	5b                   	pop    %rbx
  707444:	41 5c                	pop    %r12
  707446:	41 5d                	pop    %r13
  707448:	41 5e                	pop    %r14
  70744a:	41 5f                	pop    %r15
  70744c:	5d                   	pop    %rbp
  70744d:	c3                   	ret
  70744e:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  707455:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  70745a:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  707461:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  707466:	48 8b 30             	mov    (%rax),%rsi
  707469:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  707470:	48 85 c0             	test   %rax,%rax
  707473:	0f 84 9b 00 00 00    	je     707514 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x164>
  707479:	83 f8 01             	cmp    $0x1,%eax
  70747c:	0f 85 ae 00 00 00    	jne    707530 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x180>
  707482:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  707489:	4d 85 c9             	test   %r9,%r9
  70748c:	0f 84 62 ff ff ff    	je     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707492:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  707499:	31 ff                	xor    %edi,%edi
  70749b:	49 83 f9 01          	cmp    $0x1,%r9
  70749f:	74 33                	je     7074d4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x124>
  7074a1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7074a8:	0f 1f 84 00 00 00 00 
  7074af:	00 
  7074b0:	49 89 fa             	mov    %rdi,%r10
  7074b3:	4d 89 cb             	mov    %r9,%r11
  7074b6:	49 d1 eb             	shr    $1,%r11
  7074b9:	4c 01 df             	add    %r11,%rdi
  7074bc:	48 89 fb             	mov    %rdi,%rbx
  7074bf:	48 c1 e3 04          	shl    $0x4,%rbx
  7074c3:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  7074c7:	49 0f 47 fa          	cmova  %r10,%rdi
  7074cb:	4d 29 d9             	sub    %r11,%r9
  7074ce:	49 83 f9 01          	cmp    $0x1,%r9
  7074d2:	77 dc                	ja     7074b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x100>
  7074d4:	49 89 fa             	mov    %rdi,%r10
  7074d7:	49 c1 e2 04          	shl    $0x4,%r10
  7074db:	45 31 c9             	xor    %r9d,%r9d
  7074de:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  7074e2:	41 0f 96 c1          	setbe  %r9b
  7074e6:	49 01 f9             	add    %rdi,%r9
  7074e9:	0f 84 05 ff ff ff    	je     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7074ef:	49 c1 e1 04          	shl    $0x4,%r9
  7074f3:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  7074f8:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  7074fd:	48 39 fe             	cmp    %rdi,%rsi
  707500:	0f 83 ee fe ff ff    	jae    7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707506:	4c 01 c8             	add    %r9,%rax
  707509:	8b 40 f8             	mov    -0x8(%rax),%eax
  70750c:	48 01 c6             	add    %rax,%rsi
  70750f:	e9 82 00 00 00       	jmp    707596 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e6>
  707514:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  70751b:	0f 82 d3 fe ff ff    	jb     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707521:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  707528:	0f 83 c6 fe ff ff    	jae    7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70752e:	eb 66                	jmp    707596 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e6>
  707530:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  707537:	48 85 ff             	test   %rdi,%rdi
  70753a:	0f 84 b4 fe ff ff    	je     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707540:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  707547:	48 83 ff 01          	cmp    $0x1,%rdi
  70754b:	75 0b                	jne    707558 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1a8>
  70754d:	48 39 30             	cmp    %rsi,(%rax)
  707550:	0f 85 9e fe ff ff    	jne    7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707556:	eb 3b                	jmp    707593 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1e3>
  707558:	45 31 c9             	xor    %r9d,%r9d
  70755b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  707560:	4d 89 ca             	mov    %r9,%r10
  707563:	49 89 fb             	mov    %rdi,%r11
  707566:	49 d1 eb             	shr    $1,%r11
  707569:	4d 01 d9             	add    %r11,%r9
  70756c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  707570:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  707574:	4d 0f 47 ca          	cmova  %r10,%r9
  707578:	4c 29 df             	sub    %r11,%rdi
  70757b:	48 83 ff 01          	cmp    $0x1,%rdi
  70757f:	77 df                	ja     707560 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x1b0>
  707581:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  707585:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  707589:	0f 85 65 fe ff ff    	jne    7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70758f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  707593:	8b 70 08             	mov    0x8(%rax),%esi
  707596:	4c 89 f7             	mov    %r14,%rdi
  707599:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  70759e:	4c 89 c5             	mov    %r8,%rbp
  7075a1:	48 89 cb             	mov    %rcx,%rbx
  7075a4:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  7075a9:	49 89 d7             	mov    %rdx,%r15
  7075ac:	e8 5f 31 00 00       	call   70a710 <<gpui::runtime::Runtime<unit_action_cost::Model>>::editing_at>
  7075b1:	4c 89 fa             	mov    %r15,%rdx
  7075b4:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  7075b9:	48 89 d9             	mov    %rbx,%rcx
  7075bc:	49 89 e8             	mov    %rbp,%r8
  7075bf:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  7075c4:	48 85 c0             	test   %rax,%rax
  7075c7:	0f 84 27 fe ff ff    	je     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7075cd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  7075d1:	0f 84 1d fe ff ff    	je     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  7075d7:	48 8b 38             	mov    (%rax),%rdi
  7075da:	4d 85 ff             	test   %r15,%r15
  7075dd:	74 19                	je     7075f8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x248>
  7075df:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  7075e6:	4c 31 fe             	xor    %r15,%rsi
  7075e9:	49 89 e9             	mov    %rbp,%r9
  7075ec:	49 31 f9             	xor    %rdi,%r9
  7075ef:	49 09 f1             	or     %rsi,%r9
  7075f2:	40 0f 94 c6          	sete   %sil
  7075f6:	eb 02                	jmp    7075fa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x24a>
  7075f8:	31 f6                	xor    %esi,%esi
  7075fa:	44 8b 48 18          	mov    0x18(%rax),%r9d
  7075fe:	8b 40 20             	mov    0x20(%rax),%eax
  707601:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  707608:	4d 85 d2             	test   %r10,%r10
  70760b:	74 17                	je     707624 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x274>
  70760d:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  707614:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  70761b:	4c 09 d7             	or     %r10,%rdi
  70761e:	40 0f 94 c7          	sete   %dil
  707622:	eb 02                	jmp    707626 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x276>
  707624:	31 ff                	xor    %edi,%edi
  707626:	41 39 c1             	cmp    %eax,%r9d
  707629:	0f 85 c5 fd ff ff    	jne    7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  70762f:	40 30 fe             	xor    %dil,%sil
  707632:	0f 84 bc fd ff ff    	je     7073f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x44>
  707638:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  70763f:	00 00 
  707641:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  707646:	4c 89 e7             	mov    %r12,%rdi
  707649:	4c 89 f6             	mov    %r14,%rsi
  70764c:	e8 6f 07 00 00       	call   707dc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>
  707651:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  707656:	0f 85 b8 fd ff ff    	jne    707414 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x64>
  70765c:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  707663:	48 85 c0             	test   %rax,%rax
  707666:	74 2a                	je     707692 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x2e2>
  707668:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  70766e:	0f 84 cb fd ff ff    	je     70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707674:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  707679:	0f 85 c0 fd ff ff    	jne    70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  70767f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  707684:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  70768b:	74 11                	je     70769e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x2ee>
  70768d:	e9 ad fd ff ff       	jmp    70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  707692:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  707698:	0f 85 a1 fd ff ff    	jne    70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused+0x8f>
  70769e:	4c 89 e7             	mov    %r12,%rdi
  7076a1:	4c 89 f6             	mov    %r14,%rsi
  7076a4:	4c 89 fa             	mov    %r15,%rdx
  7076a7:	48 89 e9             	mov    %rbp,%rcx
  7076aa:	48 83 c4 48          	add    $0x48,%rsp
  7076ae:	5b                   	pop    %rbx
  7076af:	41 5c                	pop    %r12
  7076b1:	41 5d                	pop    %r13
  7076b3:	41 5e                	pop    %r14
  7076b5:	41 5f                	pop    %r15
  7076b7:	5d                   	pop    %rbp
  7076b8:	e9 c3 53 00 00       	jmp    70ca80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>
