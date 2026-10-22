
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660280 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>:
  660280:	55                   	push   %rbp
  660281:	41 57                	push   %r15
  660283:	41 56                	push   %r14
  660285:	41 55                	push   %r13
  660287:	41 54                	push   %r12
  660289:	53                   	push   %rbx
  66028a:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  660291:	4c 8b 67 20          	mov    0x20(%rdi),%r12
  660295:	4d 85 e4             	test   %r12,%r12
  660298:	0f 84 fb 03 00 00    	je     660699 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x419>
  66029e:	48 89 d3             	mov    %rdx,%rbx
  6602a1:	49 89 f7             	mov    %rsi,%r15
  6602a4:	4d 8d 74 24 10       	lea    0x10(%r12),%r14
  6602a9:	4c 89 f7             	mov    %r14,%rdi
  6602ac:	ff 15 3e 73 12 00    	call   *0x12733e(%rip)        # 7875f0 <_DYNAMIC+0x340>
  6602b2:	89 c5                	mov    %eax,%ebp
  6602b4:	84 c0                	test   %al,%al
  6602b6:	0f 84 df 03 00 00    	je     66069b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  6602bc:	41 8b 37             	mov    (%r15),%esi
  6602bf:	41 8b 47 08          	mov    0x8(%r15),%eax
  6602c3:	39 f0                	cmp    %esi,%eax
  6602c5:	0f 84 d0 03 00 00    	je     66069b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  6602cb:	89 f2                	mov    %esi,%edx
  6602cd:	0f 47 d0             	cmova  %eax,%edx
  6602d0:	0f 42 f0             	cmovb  %eax,%esi
  6602d3:	4c 89 f7             	mov    %r14,%rdi
  6602d6:	ff 15 1c 73 12 00    	call   *0x12731c(%rip)        # 7875f8 <_DYNAMIC+0x348>
  6602dc:	48 89 d1             	mov    %rdx,%rcx
  6602df:	f3 41 0f 10 44 24 5c 	movss  0x5c(%r12),%xmm0
  6602e6:	f3 0f 59 05 da d1 9b 	mulss  -0x642e26(%rip),%xmm0        # 1d4c8 <GCC_except_table0+0x94>
  6602ed:	ff 
  6602ee:	48 8d bc 24 00 01 00 	lea    0x100(%rsp),%rdi
  6602f5:	00 
  6602f6:	4c 89 f6             	mov    %r14,%rsi
  6602f9:	48 89 c2             	mov    %rax,%rdx
  6602fc:	ff 15 fe 72 12 00    	call   *0x1272fe(%rip)        # 787600 <_DYNAMIC+0x350>
  660302:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  660309:	00 
  66030a:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  66030f:	f3 0f 6f 84 24 00 01 	movdqu 0x100(%rsp),%xmm0
  660316:	00 00 
  660318:	f3 0f 6f 8c 24 10 01 	movdqu 0x110(%rsp),%xmm1
  66031f:	00 00 
  660321:	0f 10 94 24 20 01 00 	movups 0x120(%rsp),%xmm2
  660328:	00 
  660329:	0f 10 9c 24 30 01 00 	movups 0x130(%rsp),%xmm3
  660330:	00 
  660331:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
  660336:	0f 29 54 24 50       	movaps %xmm2,0x50(%rsp)
  66033b:	66 0f 7f 4c 24 40    	movdqa %xmm1,0x40(%rsp)
  660341:	66 0f 7f 44 24 30    	movdqa %xmm0,0x30(%rsp)
  660347:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  66034c:	48 8b 0b             	mov    (%rbx),%rcx
  66034f:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  660354:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  660359:	48 85 c0             	test   %rax,%rax
  66035c:	0f 84 39 03 00 00    	je     66069b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  660362:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  660367:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%rsp)
  66036e:	00 
  66036f:	4c 8d 64 24 28       	lea    0x28(%rsp),%r12
  660374:	4c 8d ac 24 a8 00 00 	lea    0xa8(%rsp),%r13
  66037b:	00 
  66037c:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
  660382:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  660388:	0f 28 f0             	movaps %xmm0,%xmm6
  66038b:	0f 28 f9             	movaps %xmm1,%xmm7
  66038e:	0f 29 b4 24 90 00 00 	movaps %xmm6,0x90(%rsp)
  660395:	00 
  660396:	0f 29 bc 24 80 00 00 	movaps %xmm7,0x80(%rsp)
  66039d:	00 
  66039e:	66 90                	xchg   %ax,%ax
  6603a0:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  6603a5:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  6603ab:	48 83 f8 01          	cmp    $0x1,%rax
  6603af:	74 23                	je     6603d4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x154>
  6603b1:	41 8b 0e             	mov    (%r14),%ecx
  6603b4:	49 8d 56 0c          	lea    0xc(%r14),%rdx
  6603b8:	48 8d 70 01          	lea    0x1(%rax),%rsi
  6603bc:	0f 1f 40 00          	nopl   0x0(%rax)
  6603c0:	3b 0a                	cmp    (%rdx),%ecx
  6603c2:	75 10                	jne    6603d4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x154>
  6603c4:	49 ff c7             	inc    %r15
  6603c7:	48 83 c2 0c          	add    $0xc,%rdx
  6603cb:	48 ff ce             	dec    %rsi
  6603ce:	48 83 fe 02          	cmp    $0x2,%rsi
  6603d2:	77 ec                	ja     6603c0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x140>
  6603d4:	4c 29 f8             	sub    %r15,%rax
  6603d7:	0f 82 d2 02 00 00    	jb     6606af <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x42f>
  6603dd:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  6603e1:	49 8d 0c 8e          	lea    (%r14,%rcx,4),%rcx
  6603e5:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  6603ea:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6603ef:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6603f4:	48 85 f6             	test   %rsi,%rsi
  6603f7:	0f 85 c6 00 00 00    	jne    6604c3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x243>
  6603fd:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  660402:	48 85 c0             	test   %rax,%rax
  660405:	0f 84 cd 02 00 00    	je     6606d8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  66040b:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  660410:	ba 01 00 00 00       	mov    $0x1,%edx
  660415:	48 83 f8 01          	cmp    $0x1,%rax
  660419:	74 29                	je     660444 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  66041b:	8b 31                	mov    (%rcx),%esi
  66041d:	48 8d 79 0c          	lea    0xc(%rcx),%rdi
  660421:	4c 8d 40 01          	lea    0x1(%rax),%r8
  660425:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66042c:	00 00 00 00 
  660430:	3b 37                	cmp    (%rdi),%esi
  660432:	75 10                	jne    660444 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  660434:	48 ff c2             	inc    %rdx
  660437:	48 83 c7 0c          	add    $0xc,%rdi
  66043b:	49 ff c8             	dec    %r8
  66043e:	49 83 f8 02          	cmp    $0x2,%r8
  660442:	77 ec                	ja     660430 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1b0>
  660444:	48 29 d0             	sub    %rdx,%rax
  660447:	0f 82 62 02 00 00    	jb     6606af <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x42f>
  66044d:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  660451:	48 8d 34 b1          	lea    (%rcx,%rsi,4),%rsi
  660455:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  66045a:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  66045f:	4c 89 b4 24 a8 00 00 	mov    %r14,0xa8(%rsp)
  660466:	00 
  660467:	4c 89 bc 24 b0 00 00 	mov    %r15,0xb0(%rsp)
  66046e:	00 
  66046f:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  660476:	00 
  660477:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  66047e:	00 
  66047f:	48 8d bc 24 c8 00 00 	lea    0xc8(%rsp),%rdi
  660486:	00 
  660487:	4c 89 e6             	mov    %r12,%rsi
  66048a:	4c 89 ea             	mov    %r13,%rdx
  66048d:	e8 ee 07 00 00       	call   660c80 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>
  660492:	80 bc 24 cc 00 00 00 	cmpb   $0x2,0xcc(%rsp)
  660499:	02 
  66049a:	0f 85 88 00 00 00    	jne    660528 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2a8>
  6604a0:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6604a5:	48 85 c0             	test   %rax,%rax
  6604a8:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  6604af:	00 
  6604b0:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  6604b7:	00 
  6604b8:	0f 85 e2 fe ff ff    	jne    6603a0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  6604be:	e9 15 02 00 00       	jmp    6606d8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  6604c3:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  6604ca:	00 00 
  6604cc:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6604d1:	e8 1a 0a 00 00       	call   660ef0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  6604d6:	48 85 c0             	test   %rax,%rax
  6604d9:	0f 85 e9 01 00 00    	jne    6606c8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x448>
  6604df:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6604e4:	48 85 c0             	test   %rax,%rax
  6604e7:	0f 84 db 01 00 00    	je     6606c8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x448>
  6604ed:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6604f2:	ba 01 00 00 00       	mov    $0x1,%edx
  6604f7:	48 83 f8 01          	cmp    $0x1,%rax
  6604fb:	0f 84 43 ff ff ff    	je     660444 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  660501:	8b 31                	mov    (%rcx),%esi
  660503:	48 8d 79 0c          	lea    0xc(%rcx),%rdi
  660507:	4c 8d 40 01          	lea    0x1(%rax),%r8
  66050b:	3b 37                	cmp    (%rdi),%esi
  66050d:	0f 85 31 ff ff ff    	jne    660444 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  660513:	48 ff c2             	inc    %rdx
  660516:	48 83 c7 0c          	add    $0xc,%rdi
  66051a:	49 ff c8             	dec    %r8
  66051d:	49 83 f8 02          	cmp    $0x2,%r8
  660521:	77 e8                	ja     66050b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x28b>
  660523:	e9 1c ff ff ff       	jmp    660444 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  660528:	f3 0f 10 84 24 e0 00 	movss  0xe0(%rsp),%xmm0
  66052f:	00 00 
  660531:	0f 57 c9             	xorps  %xmm1,%xmm1
  660534:	0f 2e c1             	ucomiss %xmm1,%xmm0
  660537:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
  66053c:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  660543:	00 
  660544:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  66054b:	00 
  66054c:	75 06                	jne    660554 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2d4>
  66054e:	0f 8b ac 00 00 00    	jnp    660600 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x380>
  660554:	f3 0f 10 8c 24 d8 00 	movss  0xd8(%rsp),%xmm1
  66055b:	00 00 
  66055d:	f3 0f 10 9c 24 dc 00 	movss  0xdc(%rsp),%xmm3
  660564:	00 00 
  660566:	f3 0f 10 94 24 e4 00 	movss  0xe4(%rsp),%xmm2
  66056d:	00 00 
  66056f:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  660576:	00 
  660577:	f6 44 24 14 01       	testb  $0x1,0x14(%rsp)
  66057c:	0f 84 eb 00 00 00    	je     66066d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3ed>
  660582:	48 39 44 24 18       	cmp    %rax,0x18(%rsp)
  660587:	0f 85 90 00 00 00    	jne    66061d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66058d:	f3 0f 10 64 24 10    	movss  0x10(%rsp),%xmm4
  660593:	0f 2e e3             	ucomiss %xmm3,%xmm4
  660596:	0f 85 81 00 00 00    	jne    66061d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66059c:	7a 7f                	jp     66061d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66059e:	f3 0f 10 64 24 0c    	movss  0xc(%rsp),%xmm4
  6605a4:	0f 2e e2             	ucomiss %xmm2,%xmm4
  6605a7:	75 74                	jne    66061d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  6605a9:	7a 72                	jp     66061d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  6605ab:	0f 28 e9             	movaps %xmm1,%xmm5
  6605ae:	f3 0f 58 e8          	addss  %xmm0,%xmm5
  6605b2:	0f 2e ef             	ucomiss %xmm7,%xmm5
  6605b5:	72 61                	jb     660618 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x398>
  6605b7:	0f 28 e6             	movaps %xmm6,%xmm4
  6605ba:	f3 0f 58 e7          	addss  %xmm7,%xmm4
  6605be:	0f 2e e1             	ucomiss %xmm1,%xmm4
  6605c1:	72 55                	jb     660618 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x398>
  6605c3:	0f 28 c4             	movaps %xmm4,%xmm0
  6605c6:	f3 0f 5f c5          	maxss  %xmm5,%xmm0
  6605ca:	0f 28 f0             	movaps %xmm0,%xmm6
  6605cd:	f3 0f c2 f0 03       	cmpunordss %xmm0,%xmm6
  6605d2:	0f 28 d6             	movaps %xmm6,%xmm2
  6605d5:	0f 55 d0             	andnps %xmm0,%xmm2
  6605d8:	0f 54 f4             	andps  %xmm4,%xmm6
  6605db:	0f 56 f2             	orps   %xmm2,%xmm6
  6605de:	0f 28 c7             	movaps %xmm7,%xmm0
  6605e1:	f3 0f 5d c1          	minss  %xmm1,%xmm0
  6605e5:	0f 28 c8             	movaps %xmm0,%xmm1
  6605e8:	f3 0f c2 c8 03       	cmpunordss %xmm0,%xmm1
  6605ed:	0f 28 d1             	movaps %xmm1,%xmm2
  6605f0:	0f 55 d0             	andnps %xmm0,%xmm2
  6605f3:	0f 54 cf             	andps  %xmm7,%xmm1
  6605f6:	0f 56 ca             	orps   %xmm2,%xmm1
  6605f9:	f3 0f 5c f1          	subss  %xmm1,%xmm6
  6605fd:	0f 28 f9             	movaps %xmm1,%xmm7
  660600:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  660605:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  66060a:	48 85 c0             	test   %rax,%rax
  66060d:	0f 85 7b fd ff ff    	jne    66038e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x10e>
  660613:	e9 c0 00 00 00       	jmp    6606d8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  660618:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  66061d:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  660622:	48 c1 c2 07          	rol    $0x7,%rdx
  660626:	66 0f 7e f9          	movd   %xmm7,%ecx
  66062a:	48 31 d1             	xor    %rdx,%rcx
  66062d:	48 c1 c1 07          	rol    $0x7,%rcx
  660631:	66 0f 6e 64 24 10    	movd   0x10(%rsp),%xmm4
  660637:	66 0f 7e e2          	movd   %xmm4,%edx
  66063b:	48 31 ca             	xor    %rcx,%rdx
  66063e:	48 c1 c2 07          	rol    $0x7,%rdx
  660642:	66 0f 7e f1          	movd   %xmm6,%ecx
  660646:	48 31 d1             	xor    %rdx,%rcx
  660649:	48 c1 c1 07          	rol    $0x7,%rcx
  66064d:	66 0f 6e 64 24 0c    	movd   0xc(%rsp),%xmm4
  660653:	66 0f 7e e2          	movd   %xmm4,%edx
  660657:	48 31 ca             	xor    %rcx,%rdx
  66065a:	48 c1 c2 07          	rol    $0x7,%rdx
  66065e:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  660662:	48 31 d1             	xor    %rdx,%rcx
  660665:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  66066a:	48 89 0b             	mov    %rcx,(%rbx)
  66066d:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  660672:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  660677:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  66067c:	b1 01                	mov    $0x1,%cl
  66067e:	89 4c 24 14          	mov    %ecx,0x14(%rsp)
  660682:	48 85 c0             	test   %rax,%rax
  660685:	0f 85 f1 fc ff ff    	jne    66037c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xfc>
  66068b:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  660691:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
  660697:	eb 4c                	jmp    6606e5 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x465>
  660699:	31 ed                	xor    %ebp,%ebp
  66069b:	89 e8                	mov    %ebp,%eax
  66069d:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  6606a4:	5b                   	pop    %rbx
  6606a5:	41 5c                	pop    %r12
  6606a7:	41 5d                	pop    %r13
  6606a9:	41 5e                	pop    %r14
  6606ab:	41 5f                	pop    %r15
  6606ad:	5d                   	pop    %rbp
  6606ae:	c3                   	ret
  6606af:	48 8d 3d 0a 50 9c ff 	lea    -0x63aff6(%rip),%rdi        # 256c0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0xd10>
  6606b6:	48 8d 15 6b c1 11 00 	lea    0x11c16b(%rip),%rdx        # 77c828 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.17478163706573382256+0x18>
  6606bd:	be 13 00 00 00       	mov    $0x13,%esi
  6606c2:	ff 15 38 6e 12 00    	call   *0x126e38(%rip)        # 787500 <_DYNAMIC+0x250>
  6606c8:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  6606cf:	00 
  6606d0:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  6606d7:	00 
  6606d8:	0f 28 c6             	movaps %xmm6,%xmm0
  6606db:	0f 28 cf             	movaps %xmm7,%xmm1
  6606de:	f6 44 24 14 01       	testb  $0x1,0x14(%rsp)
  6606e3:	74 b6                	je     66069b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  6606e5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6606ea:	48 c1 c1 07          	rol    $0x7,%rcx
  6606ee:	66 0f 7e c8          	movd   %xmm1,%eax
  6606f2:	48 31 c8             	xor    %rcx,%rax
  6606f5:	48 c1 c0 07          	rol    $0x7,%rax
  6606f9:	66 0f 6e 4c 24 10    	movd   0x10(%rsp),%xmm1
  6606ff:	66 0f 7e c9          	movd   %xmm1,%ecx
  660703:	48 31 c1             	xor    %rax,%rcx
  660706:	48 c1 c1 07          	rol    $0x7,%rcx
  66070a:	66 0f 7e c0          	movd   %xmm0,%eax
  66070e:	48 31 c8             	xor    %rcx,%rax
  660711:	48 c1 c0 07          	rol    $0x7,%rax
  660715:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  66071b:	66 0f 7e c1          	movd   %xmm0,%ecx
  66071f:	48 31 c1             	xor    %rax,%rcx
  660722:	48 c1 c1 07          	rol    $0x7,%rcx
  660726:	8b 44 24 18          	mov    0x18(%rsp),%eax
  66072a:	48 31 c8             	xor    %rcx,%rax
  66072d:	48 89 03             	mov    %rax,(%rbx)
  660730:	e9 66 ff ff ff       	jmp    66069b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
