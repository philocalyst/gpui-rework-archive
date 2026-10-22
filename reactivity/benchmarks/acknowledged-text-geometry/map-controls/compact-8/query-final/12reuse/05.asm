
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680380 <<gpui_canvas::text::layout::TextGeometry>::move_visual>:
  680380:	55                   	push   %rbp
  680381:	41 57                	push   %r15
  680383:	41 56                	push   %r14
  680385:	41 55                	push   %r13
  680387:	41 54                	push   %r12
  680389:	53                   	push   %rbx
  68038a:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  680391:	41 89 cf             	mov    %ecx,%r15d
  680394:	41 89 d6             	mov    %edx,%r14d
  680397:	89 f5                	mov    %esi,%ebp
  680399:	48 89 fb             	mov    %rdi,%rbx
  68039c:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6803a1:	48 89 de             	mov    %rbx,%rsi
  6803a4:	89 ea                	mov    %ebp,%edx
  6803a6:	44 89 f1             	mov    %r14d,%ecx
  6803a9:	ff 15 b1 73 10 00    	call   *0x1073b1(%rip)        # 787760 <_DYNAMIC+0x440>
  6803af:	83 7c 24 30 01       	cmpl   $0x1,0x30(%rsp)
  6803b4:	75 76                	jne    68042c <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xac>
  6803b6:	85 ed                	test   %ebp,%ebp
  6803b8:	0f 95 c1             	setne  %cl
  6803bb:	44 89 74 24 18       	mov    %r14d,0x18(%rsp)
  6803c0:	44 89 f2             	mov    %r14d,%edx
  6803c3:	f6 d2                	not    %dl
  6803c5:	48 8b 43 20          	mov    0x20(%rbx),%rax
  6803c9:	48 8b 73 28          	mov    0x28(%rbx),%rsi
  6803cd:	49 89 f5             	mov    %rsi,%r13
  6803d0:	84 ca                	test   %cl,%dl
  6803d2:	75 5f                	jne    680433 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xb3>
  6803d4:	48 85 f6             	test   %rsi,%rsi
  6803d7:	0f 84 b0 00 00 00    	je     68048d <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x10d>
  6803dd:	31 c9                	xor    %ecx,%ecx
  6803df:	48 83 fe 01          	cmp    $0x1,%rsi
  6803e3:	74 2c                	je     680411 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x91>
  6803e5:	48 89 f2             	mov    %rsi,%rdx
  6803e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6803ef:	00 
  6803f0:	49 89 c9             	mov    %rcx,%r9
  6803f3:	48 89 d7             	mov    %rdx,%rdi
  6803f6:	48 d1 ef             	shr    $1,%rdi
  6803f9:	48 01 f9             	add    %rdi,%rcx
  6803fc:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  680400:	42 39 2c c0          	cmp    %ebp,(%rax,%r8,8)
  680404:	49 0f 47 c9          	cmova  %r9,%rcx
  680408:	48 29 fa             	sub    %rdi,%rdx
  68040b:	48 83 fa 01          	cmp    $0x1,%rdx
  68040f:	77 df                	ja     6803f0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x70>
  680411:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  680415:	45 31 ed             	xor    %r13d,%r13d
  680418:	39 2c d0             	cmp    %ebp,(%rax,%rdx,8)
  68041b:	41 0f 96 c5          	setbe  %r13b
  68041f:	49 01 cd             	add    %rcx,%r13
  680422:	49 83 fd 01          	cmp    $0x1,%r13
  680426:	49 83 d5 ff          	adc    $0xffffffffffffffff,%r13
  68042a:	eb 61                	jmp    68048d <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x10d>
  68042c:	b2 02                	mov    $0x2,%dl
  68042e:	e9 0b 04 00 00       	jmp    68083e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4be>
  680433:	48 85 f6             	test   %rsi,%rsi
  680436:	74 4a                	je     680482 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x102>
  680438:	45 31 ed             	xor    %r13d,%r13d
  68043b:	48 83 fe 01          	cmp    $0x1,%rsi
  68043f:	74 2e                	je     68046f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xef>
  680441:	48 89 f1             	mov    %rsi,%rcx
  680444:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  68044b:	00 00 00 00 00 
  680450:	48 89 ca             	mov    %rcx,%rdx
  680453:	48 d1 ea             	shr    $1,%rdx
  680456:	4e 8d 04 2a          	lea    (%rdx,%r13,1),%r8
  68045a:	4b 8d 3c 40          	lea    (%r8,%r8,2),%rdi
  68045e:	39 6c f8 04          	cmp    %ebp,0x4(%rax,%rdi,8)
  680462:	4d 0f 42 e8          	cmovb  %r8,%r13
  680466:	48 29 d1             	sub    %rdx,%rcx
  680469:	48 83 f9 01          	cmp    $0x1,%rcx
  68046d:	77 e1                	ja     680450 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xd0>
  68046f:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  680476:	00 
  680477:	4c 01 e9             	add    %r13,%rcx
  68047a:	39 6c c8 04          	cmp    %ebp,0x4(%rax,%rcx,8)
  68047e:	49 83 d5 00          	adc    $0x0,%r13
  680482:	48 8d 4e ff          	lea    -0x1(%rsi),%rcx
  680486:	4c 39 e9             	cmp    %r13,%rcx
  680489:	4c 0f 42 e9          	cmovb  %rcx,%r13
  68048d:	44 89 3c 24          	mov    %r15d,(%rsp)
  680491:	45 31 ff             	xor    %r15d,%r15d
  680494:	48 83 7b 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rbx)
  680499:	48 8b 7b 40          	mov    0x40(%rbx),%rdi
  68049d:	4c 0f 45 ff          	cmovne %rdi,%r15
  6804a1:	b9 04 00 00 00       	mov    $0x4,%ecx
  6804a6:	48 0f 45 4b 38       	cmovne 0x38(%rbx),%rcx
  6804ab:	49 39 f5             	cmp    %rsi,%r13
  6804ae:	0f 83 b5 03 00 00    	jae    680869 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4e9>
  6804b4:	4a 8d 14 6d 00 00 00 	lea    0x0(,%r13,2),%rdx
  6804bb:	00 
  6804bc:	4c 01 ea             	add    %r13,%rdx
  6804bf:	44 8b 04 d0          	mov    (%rax,%rdx,8),%r8d
  6804c3:	45 85 c0             	test   %r8d,%r8d
  6804c6:	74 45                	je     68050d <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x18d>
  6804c8:	4d 89 fe             	mov    %r15,%r14
  6804cb:	4d 85 ff             	test   %r15,%r15
  6804ce:	74 40                	je     680510 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x190>
  6804d0:	45 31 f6             	xor    %r14d,%r14d
  6804d3:	49 83 ff 01          	cmp    $0x1,%r15
  6804d7:	74 26                	je     6804ff <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x17f>
  6804d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6804e0:	49 89 f9             	mov    %rdi,%r9
  6804e3:	49 d1 e9             	shr    $1,%r9
  6804e6:	4f 8d 14 31          	lea    (%r9,%r14,1),%r10
  6804ea:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  6804ee:	46 39 04 99          	cmp    %r8d,(%rcx,%r11,4)
  6804f2:	4d 0f 42 f2          	cmovb  %r10,%r14
  6804f6:	4c 29 cf             	sub    %r9,%rdi
  6804f9:	48 83 ff 01          	cmp    $0x1,%rdi
  6804fd:	77 e1                	ja     6804e0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x160>
  6804ff:	4b 8d 3c 76          	lea    (%r14,%r14,2),%rdi
  680503:	44 39 04 b9          	cmp    %r8d,(%rcx,%rdi,4)
  680507:	49 83 d6 00          	adc    $0x0,%r14
  68050b:	eb 03                	jmp    680510 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x190>
  68050d:	45 31 f6             	xor    %r14d,%r14d
  680510:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  680515:	89 6c 24 0c          	mov    %ebp,0xc(%rsp)
  680519:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  68051f:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  680525:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  680529:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  68052e:	4d 29 f7             	sub    %r14,%r15
  680531:	4b 8d 04 76          	lea    (%r14,%r14,2),%rax
  680535:	4c 8d 24 81          	lea    (%rcx,%rax,4),%r12
  680539:	f3 0f 10 43 4c       	movss  0x4c(%rbx),%xmm0
  68053e:	f3 0f 59 05 b2 cf 99 	mulss  -0x66304e(%rip),%xmm0        # 1d4f8 <GCC_except_table0+0x88>
  680545:	ff 
  680546:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
  68054c:	f3 0f 10 05 d4 cf 99 	movss  -0x66302c(%rip),%xmm0        # 1d528 <GCC_except_table0+0xb8>
  680553:	ff 
  680554:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  68055a:	b0 02                	mov    $0x2,%al
  68055c:	89 44 24 10          	mov    %eax,0x10(%rsp)
  680560:	31 f6                	xor    %esi,%esi
  680562:	4d 89 fe             	mov    %r15,%r14
  680565:	4c 89 e5             	mov    %r12,%rbp
  680568:	eb 09                	jmp    680573 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f3>
  68056a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  680570:	40 b6 01             	mov    $0x1,%sil
  680573:	48 89 e8             	mov    %rbp,%rax
  680576:	4c 89 e2             	mov    %r12,%rdx
  680579:	4c 89 f1             	mov    %r14,%rcx
  68057c:	49 83 fe 01          	cmp    $0x1,%r14
  680580:	74 33                	je     6805b5 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x235>
  680582:	4d 85 f6             	test   %r14,%r14
  680585:	0f 84 4c 02 00 00    	je     6807d7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x457>
  68058b:	8b 38                	mov    (%rax),%edi
  68058d:	4c 8d 40 0c          	lea    0xc(%rax),%r8
  680591:	4d 8d 4e 01          	lea    0x1(%r14),%r9
  680595:	b9 01 00 00 00       	mov    $0x1,%ecx
  68059a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  6805a0:	41 3b 38             	cmp    (%r8),%edi
  6805a3:	75 10                	jne    6805b5 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x235>
  6805a5:	48 ff c1             	inc    %rcx
  6805a8:	49 83 c0 0c          	add    $0xc,%r8
  6805ac:	49 ff c9             	dec    %r9
  6805af:	49 83 f9 02          	cmp    $0x2,%r9
  6805b3:	77 eb                	ja     6805a0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x220>
  6805b5:	49 29 ce             	sub    %rcx,%r14
  6805b8:	0f 82 92 02 00 00    	jb     680850 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4d0>
  6805be:	40 f6 c6 01          	test   $0x1,%sil
  6805c2:	0f 84 70 01 00 00    	je     680738 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3b8>
  6805c8:	4c 89 fe             	mov    %r15,%rsi
  6805cb:	49 83 ff 01          	cmp    $0x1,%r15
  6805cf:	74 34                	je     680605 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x285>
  6805d1:	4d 85 ff             	test   %r15,%r15
  6805d4:	0f 84 fd 01 00 00    	je     6807d7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x457>
  6805da:	8b 3a                	mov    (%rdx),%edi
  6805dc:	4c 8d 42 0c          	lea    0xc(%rdx),%r8
  6805e0:	4d 8d 4f 01          	lea    0x1(%r15),%r9
  6805e4:	be 01 00 00 00       	mov    $0x1,%esi
  6805e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6805f0:	41 3b 38             	cmp    (%r8),%edi
  6805f3:	75 10                	jne    680605 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x285>
  6805f5:	48 ff c6             	inc    %rsi
  6805f8:	49 83 c0 0c          	add    $0xc,%r8
  6805fc:	49 ff c9             	dec    %r9
  6805ff:	49 83 f9 02          	cmp    $0x2,%r9
  680603:	77 eb                	ja     6805f0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x270>
  680605:	49 29 f7             	sub    %rsi,%r15
  680608:	0f 82 42 02 00 00    	jb     680850 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4d0>
  68060e:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  680612:	4c 8d 24 ba          	lea    (%rdx,%rdi,4),%r12
  680616:	48 8d 3c 49          	lea    (%rcx,%rcx,2),%rdi
  68061a:	48 8d 2c b8          	lea    (%rax,%rdi,4),%rbp
  68061e:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  680623:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  680628:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  68062d:	48 89 b4 24 80 00 00 	mov    %rsi,0x80(%rsp)
  680634:	00 
  680635:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  68063a:	48 89 de             	mov    %rbx,%rsi
  68063d:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  680643:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
  680648:	e8 13 fa ff ff       	call   680060 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>
  68064d:	0f b6 4c 24 34       	movzbl 0x34(%rsp),%ecx
  680652:	80 f9 02             	cmp    $0x2,%cl
  680655:	0f 84 15 ff ff ff    	je     680570 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  68065b:	8b 44 24 30          	mov    0x30(%rsp),%eax
  68065f:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  680664:	3b 42 04             	cmp    0x4(%rdx),%eax
  680667:	0f 87 6a 01 00 00    	ja     6807d7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x457>
  68066d:	4c 39 6c 24 50       	cmp    %r13,0x50(%rsp)
  680672:	0f 85 f8 fe ff ff    	jne    680570 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  680678:	f6 44 24 60 01       	testb  $0x1,0x60(%rsp)
  68067d:	0f 85 ed fe ff ff    	jne    680570 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  680683:	f3 0f 10 44 24 58    	movss  0x58(%rsp),%xmm0
  680689:	f3 0f 10 4c 24 5c    	movss  0x5c(%rsp),%xmm1
  68068f:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  680693:	74 31                	je     6806c6 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x346>
  680695:	0f 28 d8             	movaps %xmm0,%xmm3
  680698:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  68069c:	0f 28 d3             	movaps %xmm3,%xmm2
  68069f:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  6806a4:	0f 28 e2             	movaps %xmm2,%xmm4
  6806a7:	0f 55 e3             	andnps %xmm3,%xmm4
  6806aa:	0f 54 d0             	andps  %xmm0,%xmm2
  6806ad:	0f 56 d4             	orps   %xmm4,%xmm2
  6806b0:	f3 0f 5c 54 24 08    	subss  0x8(%rsp),%xmm2
  6806b6:	0f 57 db             	xorps  %xmm3,%xmm3
  6806b9:	0f 2e d3             	ucomiss %xmm3,%xmm2
  6806bc:	40 b6 01             	mov    $0x1,%sil
  6806bf:	77 39                	ja     6806fa <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x37a>
  6806c1:	e9 ad fe ff ff       	jmp    680573 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f3>
  6806c6:	0f 28 d0             	movaps %xmm0,%xmm2
  6806c9:	f3 0f 5d d1          	minss  %xmm1,%xmm2
  6806cd:	0f 28 da             	movaps %xmm2,%xmm3
  6806d0:	f3 0f c2 da 03       	cmpunordss %xmm2,%xmm3
  6806d5:	0f 28 e3             	movaps %xmm3,%xmm4
  6806d8:	0f 55 e2             	andnps %xmm2,%xmm4
  6806db:	0f 54 d8             	andps  %xmm0,%xmm3
  6806de:	0f 56 dc             	orps   %xmm4,%xmm3
  6806e1:	f3 0f 10 54 24 08    	movss  0x8(%rsp),%xmm2
  6806e7:	f3 0f 5c d3          	subss  %xmm3,%xmm2
  6806eb:	0f 57 db             	xorps  %xmm3,%xmm3
  6806ee:	0f 2e d3             	ucomiss %xmm3,%xmm2
  6806f1:	40 b6 01             	mov    $0x1,%sil
  6806f4:	0f 86 79 fe ff ff    	jbe    680573 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f3>
  6806fa:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  680700:	0f 2e da             	ucomiss %xmm2,%xmm3
  680703:	0f 86 6a fe ff ff    	jbe    680573 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f3>
  680709:	0f 2e c8             	ucomiss %xmm0,%xmm1
  68070c:	0f 96 c2             	setbe  %dl
  68070f:	32 14 24             	xor    (%rsp),%dl
  680712:	0f 45 44 24 38       	cmovne 0x38(%rsp),%eax
  680717:	0f b6 54 24 3c       	movzbl 0x3c(%rsp),%edx
  68071c:	0f b6 c9             	movzbl %cl,%ecx
  68071f:	0f 45 ca             	cmovne %edx,%ecx
  680722:	80 e1 01             	and    $0x1,%cl
  680725:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
  680729:	f3 0f 11 54 24 04    	movss  %xmm2,0x4(%rsp)
  68072f:	89 44 24 14          	mov    %eax,0x14(%rsp)
  680733:	e9 3b fe ff ff       	jmp    680573 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f3>
  680738:	4d 89 f9             	mov    %r15,%r9
  68073b:	49 83 ff 01          	cmp    $0x1,%r15
  68073f:	74 2d                	je     68076e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3ee>
  680741:	4d 85 ff             	test   %r15,%r15
  680744:	0f 84 8d 00 00 00    	je     6807d7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x457>
  68074a:	8b 32                	mov    (%rdx),%esi
  68074c:	48 8d 7a 0c          	lea    0xc(%rdx),%rdi
  680750:	4d 8d 47 01          	lea    0x1(%r15),%r8
  680754:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  68075a:	3b 37                	cmp    (%rdi),%esi
  68075c:	75 10                	jne    68076e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3ee>
  68075e:	49 ff c1             	inc    %r9
  680761:	48 83 c7 0c          	add    $0xc,%rdi
  680765:	49 ff c8             	dec    %r8
  680768:	49 83 f8 02          	cmp    $0x2,%r8
  68076c:	77 ec                	ja     68075a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3da>
  68076e:	4c 89 ff             	mov    %r15,%rdi
  680771:	4c 29 cf             	sub    %r9,%rdi
  680774:	0f 82 d6 00 00 00    	jb     680850 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4d0>
  68077a:	4f 8d 1c 49          	lea    (%r9,%r9,2),%r11
  68077e:	4e 8d 04 9a          	lea    (%rdx,%r11,4),%r8
  680782:	48 89 fe             	mov    %rdi,%rsi
  680785:	48 83 ff 01          	cmp    $0x1,%rdi
  680789:	74 30                	je     6807bb <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x43b>
  68078b:	48 85 ff             	test   %rdi,%rdi
  68078e:	74 47                	je     6807d7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x457>
  680790:	45 8b 10             	mov    (%r8),%r10d
  680793:	4a 8d 14 9a          	lea    (%rdx,%r11,4),%rdx
  680797:	48 83 c2 0c          	add    $0xc,%rdx
  68079b:	4d 29 cf             	sub    %r9,%r15
  68079e:	49 ff c7             	inc    %r15
  6807a1:	be 01 00 00 00       	mov    $0x1,%esi
  6807a6:	44 3b 12             	cmp    (%rdx),%r10d
  6807a9:	75 10                	jne    6807bb <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x43b>
  6807ab:	48 ff c6             	inc    %rsi
  6807ae:	48 83 c2 0c          	add    $0xc,%rdx
  6807b2:	49 ff cf             	dec    %r15
  6807b5:	49 83 ff 02          	cmp    $0x2,%r15
  6807b9:	77 eb                	ja     6807a6 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x426>
  6807bb:	48 29 f7             	sub    %rsi,%rdi
  6807be:	0f 82 8c 00 00 00    	jb     680850 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4d0>
  6807c4:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
  6807c8:	4d 8d 24 90          	lea    (%r8,%rdx,4),%r12
  6807cc:	49 89 ff             	mov    %rdi,%r15
  6807cf:	4c 89 c2             	mov    %r8,%rdx
  6807d2:	e9 3f fe ff ff       	jmp    680616 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x296>
  6807d7:	8b 54 24 10          	mov    0x10(%rsp),%edx
  6807db:	80 fa 02             	cmp    $0x2,%dl
  6807de:	8b 44 24 14          	mov    0x14(%rsp),%eax
  6807e2:	75 5a                	jne    68083e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4be>
  6807e4:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  6807e8:	74 18                	je     680802 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x482>
  6807ea:	49 ff c5             	inc    %r13
  6807ed:	4c 3b 6c 24 20       	cmp    0x20(%rsp),%r13
  6807f2:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  6807f6:	73 3e                	jae    680836 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4b6>
  6807f8:	f3 0f 10 05 34 cd 99 	movss  -0x6632cc(%rip),%xmm0        # 1d534 <GCC_except_table0+0xc4>
  6807ff:	ff 
  680800:	eb 1f                	jmp    680821 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4a1>
  680802:	4d 85 ed             	test   %r13,%r13
  680805:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  680809:	74 23                	je     68082e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4ae>
  68080b:	49 ff cd             	dec    %r13
  68080e:	b8 01 00 00 00       	mov    $0x1,%eax
  680813:	48 83 f8 01          	cmp    $0x1,%rax
  680817:	75 1d                	jne    680836 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4b6>
  680819:	f3 0f 10 05 ff cc 99 	movss  -0x663301(%rip),%xmm0        # 1d520 <GCC_except_table0+0xb0>
  680820:	ff 
  680821:	48 89 df             	mov    %rbx,%rdi
  680824:	4c 89 ee             	mov    %r13,%rsi
  680827:	e8 54 00 00 00       	call   680880 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  68082c:	eb 10                	jmp    68083e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4be>
  68082e:	31 c0                	xor    %eax,%eax
  680830:	48 83 f8 01          	cmp    $0x1,%rax
  680834:	74 e3                	je     680819 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x499>
  680836:	8b 44 24 18          	mov    0x18(%rsp),%eax
  68083a:	89 c2                	mov    %eax,%edx
  68083c:	89 c8                	mov    %ecx,%eax
  68083e:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  680845:	5b                   	pop    %rbx
  680846:	41 5c                	pop    %r12
  680848:	41 5d                	pop    %r13
  68084a:	41 5e                	pop    %r14
  68084c:	41 5f                	pop    %r15
  68084e:	5d                   	pop    %rbp
  68084f:	c3                   	ret
  680850:	48 8d 3d ea d7 bd ff 	lea    -0x422816(%rip),%rdi        # 25e041 <anon.329e3194b7ea4d30c6973e63ae7c35c7.13.llvm.3101811785982658095+0x2d1>
  680857:	48 8d 15 32 d1 0f 00 	lea    0xfd132(%rip),%rdx        # 77d990 <anon.11946e5055af849423ef6f6fa3ccb0e0.6.llvm.6812186184794855116+0x90>
  68085e:	be 13 00 00 00       	mov    $0x13,%esi
  680863:	ff 15 07 6d 10 00    	call   *0x106d07(%rip)        # 787570 <_DYNAMIC+0x250>
  680869:	48 8d 15 08 d1 0f 00 	lea    0xfd108(%rip),%rdx        # 77d978 <anon.11946e5055af849423ef6f6fa3ccb0e0.6.llvm.6812186184794855116+0x78>
  680870:	4c 89 ef             	mov    %r13,%rdi
  680873:	ff 15 3f 6e 10 00    	call   *0x106e3f(%rip)        # 7876b8 <_DYNAMIC+0x398>
