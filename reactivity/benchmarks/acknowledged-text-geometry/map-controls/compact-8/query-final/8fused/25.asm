
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680430 <<gpui_canvas::text::layout::CaretBuilder>::push>:
  680430:	55                   	push   %rbp
  680431:	41 57                	push   %r15
  680433:	41 56                	push   %r14
  680435:	41 55                	push   %r13
  680437:	41 54                	push   %r12
  680439:	53                   	push   %rbx
  68043a:	48 83 ec 48          	sub    $0x48,%rsp
  68043e:	49 89 d7             	mov    %rdx,%r15
  680441:	49 89 f5             	mov    %rsi,%r13
  680444:	48 89 fb             	mov    %rdi,%rbx
  680447:	4c 8d 77 08          	lea    0x8(%rdi),%r14
  68044b:	83 3f 01             	cmpl   $0x1,(%rdi)
  68044e:	75 6e                	jne    6804be <<gpui_canvas::text::layout::CaretBuilder>::push+0x8e>
  680450:	4c 8b 63 18          	mov    0x18(%rbx),%r12
  680454:	4c 3b 63 08          	cmp    0x8(%rbx),%r12
  680458:	75 09                	jne    680463 <<gpui_canvas::text::layout::CaretBuilder>::push+0x33>
  68045a:	4c 89 f7             	mov    %r14,%rdi
  68045d:	ff 15 c5 97 10 00    	call   *0x1097c5(%rip)        # 789c28 <_DYNAMIC+0x700>
  680463:	48 8b 43 10          	mov    0x10(%rbx),%rax
  680467:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  68046b:	41 8b 55 08          	mov    0x8(%r13),%edx
  68046f:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
  680473:	49 8b 55 00          	mov    0x0(%r13),%rdx
  680477:	48 89 14 88          	mov    %rdx,(%rax,%rcx,4)
  68047b:	49 ff c4             	inc    %r12
  68047e:	4c 89 63 18          	mov    %r12,0x18(%rbx)
  680482:	45 8b 2f             	mov    (%r15),%r13d
  680485:	48 8b 43 08          	mov    0x8(%rbx),%rax
  680489:	4c 29 e0             	sub    %r12,%rax
  68048c:	4c 39 e8             	cmp    %r13,%rax
  68048f:	0f 82 42 02 00 00    	jb     6806d7 <<gpui_canvas::text::layout::CaretBuilder>::push+0x2a7>
  680495:	4d 85 ed             	test   %r13,%r13
  680498:	74 1b                	je     6804b5 <<gpui_canvas::text::layout::CaretBuilder>::push+0x85>
  68049a:	48 8b 43 10          	mov    0x10(%rbx),%rax
  68049e:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  6804a2:	41 8b 57 0c          	mov    0xc(%r15),%edx
  6804a6:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
  6804aa:	49 8b 57 04          	mov    0x4(%r15),%rdx
  6804ae:	48 89 14 88          	mov    %rdx,(%rax,%rcx,4)
  6804b2:	49 ff c4             	inc    %r12
  6804b5:	4c 89 63 18          	mov    %r12,0x18(%rbx)
  6804b9:	e9 0a 02 00 00       	jmp    6806c8 <<gpui_canvas::text::layout::CaretBuilder>::push+0x298>
  6804be:	45 8b 27             	mov    (%r15),%r12d
  6804c1:	49 83 fc 01          	cmp    $0x1,%r12
  6804c5:	0f 85 9f 00 00 00    	jne    68056a <<gpui_canvas::text::layout::CaretBuilder>::push+0x13a>
  6804cb:	41 80 7f 0c 02       	cmpb   $0x2,0xc(%r15)
  6804d0:	0f 85 df 00 00 00    	jne    6805b5 <<gpui_canvas::text::layout::CaretBuilder>::push+0x185>
  6804d6:	41 80 7d 08 01       	cmpb   $0x1,0x8(%r13)
  6804db:	0f 85 d4 00 00 00    	jne    6805b5 <<gpui_canvas::text::layout::CaretBuilder>::push+0x185>
  6804e1:	41 8b 6f 04          	mov    0x4(%r15),%ebp
  6804e5:	41 39 6d 00          	cmp    %ebp,0x0(%r13)
  6804e9:	0f 85 c6 00 00 00    	jne    6805b5 <<gpui_canvas::text::layout::CaretBuilder>::push+0x185>
  6804ef:	f3 41 0f 10 45 04    	movss  0x4(%r13),%xmm0
  6804f5:	4c 8b 63 18          	mov    0x18(%rbx),%r12
  6804f9:	4c 3b 63 08          	cmp    0x8(%rbx),%r12
  6804fd:	75 15                	jne    680514 <<gpui_canvas::text::layout::CaretBuilder>::push+0xe4>
  6804ff:	4c 89 f7             	mov    %r14,%rdi
  680502:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  680508:	ff 15 12 97 10 00    	call   *0x109712(%rip)        # 789c20 <_DYNAMIC+0x6f8>
  68050e:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  680514:	48 8b 43 10          	mov    0x10(%rbx),%rax
  680518:	42 89 2c e0          	mov    %ebp,(%rax,%r12,8)
  68051c:	f3 42 0f 11 44 e0 04 	movss  %xmm0,0x4(%rax,%r12,8)
  680523:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  680528:	48 89 43 18          	mov    %rax,0x18(%rbx)
  68052c:	f3 41 0f 10 47 08    	movss  0x8(%r15),%xmm0
  680532:	48 3b 43 08          	cmp    0x8(%rbx),%rax
  680536:	75 15                	jne    68054d <<gpui_canvas::text::layout::CaretBuilder>::push+0x11d>
  680538:	4c 89 f7             	mov    %r14,%rdi
  68053b:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  680541:	ff 15 d9 96 10 00    	call   *0x1096d9(%rip)        # 789c20 <_DYNAMIC+0x6f8>
  680547:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  68054d:	48 8b 43 10          	mov    0x10(%rbx),%rax
  680551:	42 89 6c e0 08       	mov    %ebp,0x8(%rax,%r12,8)
  680556:	f3 42 0f 11 44 e0 0c 	movss  %xmm0,0xc(%rax,%r12,8)
  68055d:	49 83 c4 02          	add    $0x2,%r12
  680561:	4c 89 63 18          	mov    %r12,0x18(%rbx)
  680565:	e9 5e 01 00 00       	jmp    6806c8 <<gpui_canvas::text::layout::CaretBuilder>::push+0x298>
  68056a:	41 80 7d 08 03       	cmpb   $0x3,0x8(%r13)
  68056f:	75 44                	jne    6805b5 <<gpui_canvas::text::layout::CaretBuilder>::push+0x185>
  680571:	41 8b 6d 00          	mov    0x0(%r13),%ebp
  680575:	f3 41 0f 10 45 04    	movss  0x4(%r13),%xmm0
  68057b:	4c 8b 7b 18          	mov    0x18(%rbx),%r15
  68057f:	4c 3b 7b 08          	cmp    0x8(%rbx),%r15
  680583:	75 15                	jne    68059a <<gpui_canvas::text::layout::CaretBuilder>::push+0x16a>
  680585:	4c 89 f7             	mov    %r14,%rdi
  680588:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  68058e:	ff 15 8c 96 10 00    	call   *0x10968c(%rip)        # 789c20 <_DYNAMIC+0x6f8>
  680594:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  68059a:	48 8b 43 10          	mov    0x10(%rbx),%rax
  68059e:	42 89 2c f8          	mov    %ebp,(%rax,%r15,8)
  6805a2:	f3 42 0f 11 44 f8 04 	movss  %xmm0,0x4(%rax,%r15,8)
  6805a9:	49 ff c7             	inc    %r15
  6805ac:	4c 89 7b 18          	mov    %r15,0x18(%rbx)
  6805b0:	e9 13 01 00 00       	jmp    6806c8 <<gpui_canvas::text::layout::CaretBuilder>::push+0x298>
  6805b5:	48 8b 43 10          	mov    0x10(%rbx),%rax
  6805b9:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  6805bd:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  6805c4:	00 00 
  6805c6:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  6805cb:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6805d2:	00 00 
  6805d4:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6805d9:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  6805de:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6805e3:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  6805e8:	e8 b3 6b ff ff       	call   6771a0 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter>
  6805ed:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
  6805f2:	48 3b 6c 24 08       	cmp    0x8(%rsp),%rbp
  6805f7:	75 0b                	jne    680604 <<gpui_canvas::text::layout::CaretBuilder>::push+0x1d4>
  6805f9:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6805fe:	ff 15 24 96 10 00    	call   *0x109624(%rip)        # 789c28 <_DYNAMIC+0x700>
  680604:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  680609:	48 8d 0c 6d 00 00 00 	lea    0x0(,%rbp,2),%rcx
  680610:	00 
  680611:	48 01 e9             	add    %rbp,%rcx
  680614:	41 8b 55 08          	mov    0x8(%r13),%edx
  680618:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
  68061c:	49 8b 55 00          	mov    0x0(%r13),%rdx
  680620:	48 89 14 88          	mov    %rdx,(%rax,%rcx,4)
  680624:	48 ff c5             	inc    %rbp
  680627:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  68062c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  680631:	48 29 e8             	sub    %rbp,%rax
  680634:	4c 39 e0             	cmp    %r12,%rax
  680637:	0f 82 c5 00 00 00    	jb     680702 <<gpui_canvas::text::layout::CaretBuilder>::push+0x2d2>
  68063d:	45 84 e4             	test   %r12b,%r12b
  680640:	74 23                	je     680665 <<gpui_canvas::text::layout::CaretBuilder>::push+0x235>
  680642:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  680647:	48 8d 0c 6d 00 00 00 	lea    0x0(,%rbp,2),%rcx
  68064e:	00 
  68064f:	48 01 e9             	add    %rbp,%rcx
  680652:	41 8b 57 0c          	mov    0xc(%r15),%edx
  680656:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
  68065a:	49 8b 57 04          	mov    0x4(%r15),%rdx
  68065e:	48 89 14 88          	mov    %rdx,(%rax,%rcx,4)
  680662:	48 ff c5             	inc    %rbp
  680665:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  68066a:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  68066f:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  680674:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  680679:	80 3b 00             	cmpb   $0x0,(%rbx)
  68067c:	74 16                	je     680694 <<gpui_canvas::text::layout::CaretBuilder>::push+0x264>
  68067e:	49 8b 06             	mov    (%r14),%rax
  680681:	48 85 c0             	test   %rax,%rax
  680684:	74 29                	je     6806af <<gpui_canvas::text::layout::CaretBuilder>::push+0x27f>
  680686:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
  68068a:	48 c1 e0 02          	shl    $0x2,%rax
  68068e:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  680692:	eb 10                	jmp    6806a4 <<gpui_canvas::text::layout::CaretBuilder>::push+0x274>
  680694:	49 8b 36             	mov    (%r14),%rsi
  680697:	48 85 f6             	test   %rsi,%rsi
  68069a:	74 13                	je     6806af <<gpui_canvas::text::layout::CaretBuilder>::push+0x27f>
  68069c:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
  6806a0:	48 c1 e6 03          	shl    $0x3,%rsi
  6806a4:	ba 04 00 00 00       	mov    $0x4,%edx
  6806a9:	ff 15 c1 90 10 00    	call   *0x1090c1(%rip)        # 789770 <_DYNAMIC+0x248>
  6806af:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  6806b6:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6806bb:	49 89 46 10          	mov    %rax,0x10(%r14)
  6806bf:	0f 28 44 24 20       	movaps 0x20(%rsp),%xmm0
  6806c4:	41 0f 11 06          	movups %xmm0,(%r14)
  6806c8:	48 83 c4 48          	add    $0x48,%rsp
  6806cc:	5b                   	pop    %rbx
  6806cd:	41 5c                	pop    %r12
  6806cf:	41 5d                	pop    %r13
  6806d1:	41 5e                	pop    %r14
  6806d3:	41 5f                	pop    %r15
  6806d5:	5d                   	pop    %rbp
  6806d6:	c3                   	ret
  6806d7:	b9 04 00 00 00       	mov    $0x4,%ecx
  6806dc:	41 b8 0c 00 00 00    	mov    $0xc,%r8d
  6806e2:	4c 89 f7             	mov    %r14,%rdi
  6806e5:	4c 89 e6             	mov    %r12,%rsi
  6806e8:	4c 89 ea             	mov    %r13,%rdx
  6806eb:	e8 20 45 ff ff       	call   674c10 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  6806f0:	4c 8b 63 18          	mov    0x18(%rbx),%r12
  6806f4:	4d 85 ed             	test   %r13,%r13
  6806f7:	0f 85 9d fd ff ff    	jne    68049a <<gpui_canvas::text::layout::CaretBuilder>::push+0x6a>
  6806fd:	e9 b3 fd ff ff       	jmp    6804b5 <<gpui_canvas::text::layout::CaretBuilder>::push+0x85>
  680702:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  680707:	b9 04 00 00 00       	mov    $0x4,%ecx
  68070c:	41 b8 0c 00 00 00    	mov    $0xc,%r8d
  680712:	48 89 ee             	mov    %rbp,%rsi
  680715:	4c 89 e2             	mov    %r12,%rdx
  680718:	e8 f3 44 ff ff       	call   674c10 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  68071d:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
  680722:	45 84 e4             	test   %r12b,%r12b
  680725:	0f 85 17 ff ff ff    	jne    680642 <<gpui_canvas::text::layout::CaretBuilder>::push+0x212>
  68072b:	e9 35 ff ff ff       	jmp    680665 <<gpui_canvas::text::layout::CaretBuilder>::push+0x235>
  680730:	48 89 c3             	mov    %rax,%rbx
  680733:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  680738:	48 85 c0             	test   %rax,%rax
  68073b:	74 18                	je     680755 <<gpui_canvas::text::layout::CaretBuilder>::push+0x325>
  68073d:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  680742:	48 c1 e0 02          	shl    $0x2,%rax
  680746:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  68074a:	ba 04 00 00 00       	mov    $0x4,%edx
  68074f:	ff 15 1b 90 10 00    	call   *0x10901b(%rip)        # 789770 <_DYNAMIC+0x248>
  680755:	48 89 df             	mov    %rbx,%rdi
  680758:	e8 b3 d0 0f 00       	call   77d810 <_Unwind_Resume@plt>
