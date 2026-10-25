
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fa650 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused>:
  6fa650:	55                   	push   %rbp
  6fa651:	41 57                	push   %r15
  6fa653:	41 56                	push   %r14
  6fa655:	41 55                	push   %r13
  6fa657:	41 54                	push   %r12
  6fa659:	53                   	push   %rbx
  6fa65a:	48 83 ec 48          	sub    $0x48,%rsp
  6fa65e:	4d 89 cf             	mov    %r9,%r15
  6fa661:	49 89 f6             	mov    %rsi,%r14
  6fa664:	49 89 fc             	mov    %rdi,%r12
  6fa667:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  6fa66e:	00 
  6fa66f:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  6fa676:	4c 8b ae 60 06 00 00 	mov    0x660(%rsi),%r13
  6fa67d:	48 85 c0             	test   %rax,%rax
  6fa680:	74 12                	je     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa682:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fa689:	48 85 c0             	test   %rax,%rax
  6fa68c:	74 06                	je     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa68e:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fa692:	75 5a                	jne    6fa6ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x9e>
  6fa694:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  6fa69b:	00 00 
  6fa69d:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fa6a2:	4c 89 e7             	mov    %r12,%rdi
  6fa6a5:	4c 89 f6             	mov    %r14,%rsi
  6fa6a8:	e8 b3 02 00 00       	call   6fa960 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>
  6fa6ad:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fa6b2:	74 2b                	je     6fa6df <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fa6b4:	4d 39 ae 60 06 00 00 	cmp    %r13,0x660(%r14)
  6fa6bb:	75 22                	jne    6fa6df <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fa6bd:	41 80 be 1e 08 00 00 	cmpb   $0x1,0x81e(%r14)
  6fa6c4:	01 
  6fa6c5:	75 18                	jne    6fa6df <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fa6c7:	41 80 be 22 08 00 00 	cmpb   $0x0,0x822(%r14)
  6fa6ce:	00 
  6fa6cf:	75 0e                	jne    6fa6df <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fa6d1:	4d 89 be e8 05 00 00 	mov    %r15,0x5e8(%r14)
  6fa6d8:	49 89 ae f0 05 00 00 	mov    %rbp,0x5f0(%r14)
  6fa6df:	48 83 c4 48          	add    $0x48,%rsp
  6fa6e3:	5b                   	pop    %rbx
  6fa6e4:	41 5c                	pop    %r12
  6fa6e6:	41 5d                	pop    %r13
  6fa6e8:	41 5e                	pop    %r14
  6fa6ea:	41 5f                	pop    %r15
  6fa6ec:	5d                   	pop    %rbp
  6fa6ed:	c3                   	ret
  6fa6ee:	49 8b b6 80 06 00 00 	mov    0x680(%r14),%rsi
  6fa6f5:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  6fa6fa:	49 8b b6 88 06 00 00 	mov    0x688(%r14),%rsi
  6fa701:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fa706:	48 8b 30             	mov    (%rax),%rsi
  6fa709:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  6fa710:	48 85 c0             	test   %rax,%rax
  6fa713:	0f 84 9b 00 00 00    	je     6fa7b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x164>
  6fa719:	83 f8 01             	cmp    $0x1,%eax
  6fa71c:	0f 85 ae 00 00 00    	jne    6fa7d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x180>
  6fa722:	4d 8b 8e f8 01 00 00 	mov    0x1f8(%r14),%r9
  6fa729:	4d 85 c9             	test   %r9,%r9
  6fa72c:	0f 84 62 ff ff ff    	je     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa732:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fa739:	31 ff                	xor    %edi,%edi
  6fa73b:	49 83 f9 01          	cmp    $0x1,%r9
  6fa73f:	74 33                	je     6fa774 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x124>
  6fa741:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6fa748:	0f 1f 84 00 00 00 00 
  6fa74f:	00 
  6fa750:	49 89 fa             	mov    %rdi,%r10
  6fa753:	4d 89 cb             	mov    %r9,%r11
  6fa756:	49 d1 eb             	shr    $1,%r11
  6fa759:	4c 01 df             	add    %r11,%rdi
  6fa75c:	48 89 fb             	mov    %rdi,%rbx
  6fa75f:	48 c1 e3 04          	shl    $0x4,%rbx
  6fa763:	48 39 34 18          	cmp    %rsi,(%rax,%rbx,1)
  6fa767:	49 0f 47 fa          	cmova  %r10,%rdi
  6fa76b:	4d 29 d9             	sub    %r11,%r9
  6fa76e:	49 83 f9 01          	cmp    $0x1,%r9
  6fa772:	77 dc                	ja     6fa750 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x100>
  6fa774:	49 89 fa             	mov    %rdi,%r10
  6fa777:	49 c1 e2 04          	shl    $0x4,%r10
  6fa77b:	45 31 c9             	xor    %r9d,%r9d
  6fa77e:	4a 39 34 10          	cmp    %rsi,(%rax,%r10,1)
  6fa782:	41 0f 96 c1          	setbe  %r9b
  6fa786:	49 01 f9             	add    %rdi,%r9
  6fa789:	0f 84 05 ff ff ff    	je     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa78f:	49 c1 e1 04          	shl    $0x4,%r9
  6fa793:	4a 2b 74 08 f0       	sub    -0x10(%rax,%r9,1),%rsi
  6fa798:	42 8b 7c 08 fc       	mov    -0x4(%rax,%r9,1),%edi
  6fa79d:	48 39 fe             	cmp    %rdi,%rsi
  6fa7a0:	0f 83 ee fe ff ff    	jae    6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa7a6:	4c 01 c8             	add    %r9,%rax
  6fa7a9:	8b 40 f8             	mov    -0x8(%rax),%eax
  6fa7ac:	48 01 c6             	add    %rax,%rsi
  6fa7af:	e9 82 00 00 00       	jmp    6fa836 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e6>
  6fa7b4:	49 2b b6 f0 01 00 00 	sub    0x1f0(%r14),%rsi
  6fa7bb:	0f 82 d3 fe ff ff    	jb     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa7c1:	49 3b b6 f8 01 00 00 	cmp    0x1f8(%r14),%rsi
  6fa7c8:	0f 83 c6 fe ff ff    	jae    6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa7ce:	eb 66                	jmp    6fa836 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e6>
  6fa7d0:	49 8b be f8 01 00 00 	mov    0x1f8(%r14),%rdi
  6fa7d7:	48 85 ff             	test   %rdi,%rdi
  6fa7da:	0f 84 b4 fe ff ff    	je     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa7e0:	49 8b 86 f0 01 00 00 	mov    0x1f0(%r14),%rax
  6fa7e7:	48 83 ff 01          	cmp    $0x1,%rdi
  6fa7eb:	75 0b                	jne    6fa7f8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1a8>
  6fa7ed:	48 39 30             	cmp    %rsi,(%rax)
  6fa7f0:	0f 85 9e fe ff ff    	jne    6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa7f6:	eb 3b                	jmp    6fa833 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1e3>
  6fa7f8:	45 31 c9             	xor    %r9d,%r9d
  6fa7fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6fa800:	4d 89 ca             	mov    %r9,%r10
  6fa803:	49 89 fb             	mov    %rdi,%r11
  6fa806:	49 d1 eb             	shr    $1,%r11
  6fa809:	4d 01 d9             	add    %r11,%r9
  6fa80c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  6fa810:	48 39 34 98          	cmp    %rsi,(%rax,%rbx,4)
  6fa814:	4d 0f 47 ca          	cmova  %r10,%r9
  6fa818:	4c 29 df             	sub    %r11,%rdi
  6fa81b:	48 83 ff 01          	cmp    $0x1,%rdi
  6fa81f:	77 df                	ja     6fa800 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x1b0>
  6fa821:	4b 8d 3c 49          	lea    (%r9,%r9,2),%rdi
  6fa825:	48 39 34 b8          	cmp    %rsi,(%rax,%rdi,4)
  6fa829:	0f 85 65 fe ff ff    	jne    6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa82f:	48 8d 04 b8          	lea    (%rax,%rdi,4),%rax
  6fa833:	8b 70 08             	mov    0x8(%rax),%esi
  6fa836:	4c 89 f7             	mov    %r14,%rdi
  6fa839:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  6fa83e:	4c 89 c5             	mov    %r8,%rbp
  6fa841:	48 89 cb             	mov    %rcx,%rbx
  6fa844:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  6fa849:	49 89 d7             	mov    %rdx,%r15
  6fa84c:	e8 0f 58 00 00       	call   700060 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::editing_at>
  6fa851:	4c 89 fa             	mov    %r15,%rdx
  6fa854:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6fa859:	48 89 d9             	mov    %rbx,%rcx
  6fa85c:	49 89 e8             	mov    %rbp,%r8
  6fa85f:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  6fa864:	48 85 c0             	test   %rax,%rax
  6fa867:	0f 84 27 fe ff ff    	je     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa86d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  6fa871:	0f 84 1d fe ff ff    	je     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa877:	48 8b 38             	mov    (%rax),%rdi
  6fa87a:	4d 85 ff             	test   %r15,%r15
  6fa87d:	74 19                	je     6fa898 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x248>
  6fa87f:	49 8b b6 b0 05 00 00 	mov    0x5b0(%r14),%rsi
  6fa886:	4c 31 fe             	xor    %r15,%rsi
  6fa889:	49 89 e9             	mov    %rbp,%r9
  6fa88c:	49 31 f9             	xor    %rdi,%r9
  6fa88f:	49 09 f1             	or     %rsi,%r9
  6fa892:	40 0f 94 c6          	sete   %sil
  6fa896:	eb 02                	jmp    6fa89a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x24a>
  6fa898:	31 f6                	xor    %esi,%esi
  6fa89a:	44 8b 48 18          	mov    0x18(%rax),%r9d
  6fa89e:	8b 40 20             	mov    0x20(%rax),%eax
  6fa8a1:	4d 8b 96 e8 05 00 00 	mov    0x5e8(%r14),%r10
  6fa8a8:	4d 85 d2             	test   %r10,%r10
  6fa8ab:	74 17                	je     6fa8c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x274>
  6fa8ad:	4d 33 96 b0 05 00 00 	xor    0x5b0(%r14),%r10
  6fa8b4:	49 33 be f0 05 00 00 	xor    0x5f0(%r14),%rdi
  6fa8bb:	4c 09 d7             	or     %r10,%rdi
  6fa8be:	40 0f 94 c7          	sete   %dil
  6fa8c2:	eb 02                	jmp    6fa8c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x276>
  6fa8c4:	31 ff                	xor    %edi,%edi
  6fa8c6:	41 39 c1             	cmp    %eax,%r9d
  6fa8c9:	0f 85 c5 fd ff ff    	jne    6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa8cf:	40 30 fe             	xor    %dil,%sil
  6fa8d2:	0f 84 bc fd ff ff    	je     6fa694 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x44>
  6fa8d8:	48 c7 44 24 28 02 00 	movq   $0x2,0x28(%rsp)
  6fa8df:	00 00 
  6fa8e1:	4c 8d 4c 24 28       	lea    0x28(%rsp),%r9
  6fa8e6:	4c 89 e7             	mov    %r12,%rdi
  6fa8e9:	4c 89 f6             	mov    %r14,%rsi
  6fa8ec:	e8 6f 00 00 00       	call   6fa960 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>
  6fa8f1:	41 83 3c 24 fe       	cmpl   $0xfffffffe,(%r12)
  6fa8f6:	0f 85 b8 fd ff ff    	jne    6fa6b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x64>
  6fa8fc:	49 8b 86 80 06 00 00 	mov    0x680(%r14),%rax
  6fa903:	48 85 c0             	test   %rax,%rax
  6fa906:	74 2a                	je     6fa932 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x2e2>
  6fa908:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fa90e:	0f 84 cb fd ff ff    	je     6fa6df <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fa914:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  6fa919:	0f 85 c0 fd ff ff    	jne    6fa6df <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fa91f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fa924:	49 39 86 88 06 00 00 	cmp    %rax,0x688(%r14)
  6fa92b:	74 11                	je     6fa93e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x2ee>
  6fa92d:	e9 ad fd ff ff       	jmp    6fa6df <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fa932:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  6fa938:	0f 85 a1 fd ff ff    	jne    6fa6df <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused+0x8f>
  6fa93e:	4c 89 e7             	mov    %r12,%rdi
  6fa941:	4c 89 f6             	mov    %r14,%rsi
  6fa944:	4c 89 fa             	mov    %r15,%rdx
  6fa947:	48 89 e9             	mov    %rbp,%rcx
  6fa94a:	48 83 c4 48          	add    $0x48,%rsp
  6fa94e:	5b                   	pop    %rbx
  6fa94f:	41 5c                	pop    %r12
  6fa951:	41 5d                	pop    %r13
  6fa953:	41 5e                	pop    %r14
  6fa955:	41 5f                	pop    %r15
  6fa957:	5d                   	pop    %rbp
  6fa958:	e9 43 96 00 00       	jmp    703fa0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>
