
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660230 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>:
  660230:	55                   	push   %rbp
  660231:	41 57                	push   %r15
  660233:	41 56                	push   %r14
  660235:	41 55                	push   %r13
  660237:	41 54                	push   %r12
  660239:	53                   	push   %rbx
  66023a:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  660241:	4c 8b 67 20          	mov    0x20(%rdi),%r12
  660245:	4d 85 e4             	test   %r12,%r12
  660248:	0f 84 fb 03 00 00    	je     660649 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x419>
  66024e:	48 89 d3             	mov    %rdx,%rbx
  660251:	49 89 f7             	mov    %rsi,%r15
  660254:	4d 8d 74 24 10       	lea    0x10(%r12),%r14
  660259:	4c 89 f7             	mov    %r14,%rdi
  66025c:	ff 15 fe 71 12 00    	call   *0x1271fe(%rip)        # 787460 <_DYNAMIC+0x340>
  660262:	89 c5                	mov    %eax,%ebp
  660264:	84 c0                	test   %al,%al
  660266:	0f 84 df 03 00 00    	je     66064b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  66026c:	41 8b 37             	mov    (%r15),%esi
  66026f:	41 8b 47 08          	mov    0x8(%r15),%eax
  660273:	39 f0                	cmp    %esi,%eax
  660275:	0f 84 d0 03 00 00    	je     66064b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  66027b:	89 f2                	mov    %esi,%edx
  66027d:	0f 47 d0             	cmova  %eax,%edx
  660280:	0f 42 f0             	cmovb  %eax,%esi
  660283:	4c 89 f7             	mov    %r14,%rdi
  660286:	ff 15 dc 71 12 00    	call   *0x1271dc(%rip)        # 787468 <_DYNAMIC+0x348>
  66028c:	48 89 d1             	mov    %rdx,%rcx
  66028f:	f3 41 0f 10 44 24 5c 	movss  0x5c(%r12),%xmm0
  660296:	f3 0f 59 05 2a d2 9b 	mulss  -0x642dd6(%rip),%xmm0        # 1d4c8 <GCC_except_table0+0x88>
  66029d:	ff 
  66029e:	48 8d bc 24 00 01 00 	lea    0x100(%rsp),%rdi
  6602a5:	00 
  6602a6:	4c 89 f6             	mov    %r14,%rsi
  6602a9:	48 89 c2             	mov    %rax,%rdx
  6602ac:	ff 15 be 71 12 00    	call   *0x1271be(%rip)        # 787470 <_DYNAMIC+0x350>
  6602b2:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  6602b9:	00 
  6602ba:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6602bf:	f3 0f 6f 84 24 00 01 	movdqu 0x100(%rsp),%xmm0
  6602c6:	00 00 
  6602c8:	f3 0f 6f 8c 24 10 01 	movdqu 0x110(%rsp),%xmm1
  6602cf:	00 00 
  6602d1:	0f 10 94 24 20 01 00 	movups 0x120(%rsp),%xmm2
  6602d8:	00 
  6602d9:	0f 10 9c 24 30 01 00 	movups 0x130(%rsp),%xmm3
  6602e0:	00 
  6602e1:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
  6602e6:	0f 29 54 24 50       	movaps %xmm2,0x50(%rsp)
  6602eb:	66 0f 7f 4c 24 40    	movdqa %xmm1,0x40(%rsp)
  6602f1:	66 0f 7f 44 24 30    	movdqa %xmm0,0x30(%rsp)
  6602f7:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6602fc:	48 8b 0b             	mov    (%rbx),%rcx
  6602ff:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  660304:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  660309:	48 85 c0             	test   %rax,%rax
  66030c:	0f 84 39 03 00 00    	je     66064b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  660312:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  660317:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%rsp)
  66031e:	00 
  66031f:	4c 8d 64 24 28       	lea    0x28(%rsp),%r12
  660324:	4c 8d ac 24 a8 00 00 	lea    0xa8(%rsp),%r13
  66032b:	00 
  66032c:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
  660332:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  660338:	0f 28 f0             	movaps %xmm0,%xmm6
  66033b:	0f 28 f9             	movaps %xmm1,%xmm7
  66033e:	0f 29 b4 24 90 00 00 	movaps %xmm6,0x90(%rsp)
  660345:	00 
  660346:	0f 29 bc 24 80 00 00 	movaps %xmm7,0x80(%rsp)
  66034d:	00 
  66034e:	66 90                	xchg   %ax,%ax
  660350:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  660355:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  66035b:	48 83 f8 01          	cmp    $0x1,%rax
  66035f:	74 23                	je     660384 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x154>
  660361:	41 8b 0e             	mov    (%r14),%ecx
  660364:	49 8d 56 0c          	lea    0xc(%r14),%rdx
  660368:	48 8d 70 01          	lea    0x1(%rax),%rsi
  66036c:	0f 1f 40 00          	nopl   0x0(%rax)
  660370:	3b 0a                	cmp    (%rdx),%ecx
  660372:	75 10                	jne    660384 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x154>
  660374:	49 ff c7             	inc    %r15
  660377:	48 83 c2 0c          	add    $0xc,%rdx
  66037b:	48 ff ce             	dec    %rsi
  66037e:	48 83 fe 02          	cmp    $0x2,%rsi
  660382:	77 ec                	ja     660370 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x140>
  660384:	4c 29 f8             	sub    %r15,%rax
  660387:	0f 82 d2 02 00 00    	jb     66065f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x42f>
  66038d:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  660391:	49 8d 0c 8e          	lea    (%r14,%rcx,4),%rcx
  660395:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  66039a:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  66039f:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6603a4:	48 85 f6             	test   %rsi,%rsi
  6603a7:	0f 85 c6 00 00 00    	jne    660473 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x243>
  6603ad:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6603b2:	48 85 c0             	test   %rax,%rax
  6603b5:	0f 84 cd 02 00 00    	je     660688 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  6603bb:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6603c0:	ba 01 00 00 00       	mov    $0x1,%edx
  6603c5:	48 83 f8 01          	cmp    $0x1,%rax
  6603c9:	74 29                	je     6603f4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  6603cb:	8b 31                	mov    (%rcx),%esi
  6603cd:	48 8d 79 0c          	lea    0xc(%rcx),%rdi
  6603d1:	4c 8d 40 01          	lea    0x1(%rax),%r8
  6603d5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6603dc:	00 00 00 00 
  6603e0:	3b 37                	cmp    (%rdi),%esi
  6603e2:	75 10                	jne    6603f4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  6603e4:	48 ff c2             	inc    %rdx
  6603e7:	48 83 c7 0c          	add    $0xc,%rdi
  6603eb:	49 ff c8             	dec    %r8
  6603ee:	49 83 f8 02          	cmp    $0x2,%r8
  6603f2:	77 ec                	ja     6603e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1b0>
  6603f4:	48 29 d0             	sub    %rdx,%rax
  6603f7:	0f 82 62 02 00 00    	jb     66065f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x42f>
  6603fd:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  660401:	48 8d 34 b1          	lea    (%rcx,%rsi,4),%rsi
  660405:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  66040a:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  66040f:	4c 89 b4 24 a8 00 00 	mov    %r14,0xa8(%rsp)
  660416:	00 
  660417:	4c 89 bc 24 b0 00 00 	mov    %r15,0xb0(%rsp)
  66041e:	00 
  66041f:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  660426:	00 
  660427:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  66042e:	00 
  66042f:	48 8d bc 24 c8 00 00 	lea    0xc8(%rsp),%rdi
  660436:	00 
  660437:	4c 89 e6             	mov    %r12,%rsi
  66043a:	4c 89 ea             	mov    %r13,%rdx
  66043d:	e8 ee 07 00 00       	call   660c30 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>
  660442:	80 bc 24 cc 00 00 00 	cmpb   $0x2,0xcc(%rsp)
  660449:	02 
  66044a:	0f 85 88 00 00 00    	jne    6604d8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2a8>
  660450:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  660455:	48 85 c0             	test   %rax,%rax
  660458:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  66045f:	00 
  660460:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  660467:	00 
  660468:	0f 85 e2 fe ff ff    	jne    660350 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  66046e:	e9 15 02 00 00       	jmp    660688 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  660473:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  66047a:	00 00 
  66047c:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  660481:	e8 1a 0a 00 00       	call   660ea0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  660486:	48 85 c0             	test   %rax,%rax
  660489:	0f 85 e9 01 00 00    	jne    660678 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x448>
  66048f:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  660494:	48 85 c0             	test   %rax,%rax
  660497:	0f 84 db 01 00 00    	je     660678 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x448>
  66049d:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6604a2:	ba 01 00 00 00       	mov    $0x1,%edx
  6604a7:	48 83 f8 01          	cmp    $0x1,%rax
  6604ab:	0f 84 43 ff ff ff    	je     6603f4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  6604b1:	8b 31                	mov    (%rcx),%esi
  6604b3:	48 8d 79 0c          	lea    0xc(%rcx),%rdi
  6604b7:	4c 8d 40 01          	lea    0x1(%rax),%r8
  6604bb:	3b 37                	cmp    (%rdi),%esi
  6604bd:	0f 85 31 ff ff ff    	jne    6603f4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  6604c3:	48 ff c2             	inc    %rdx
  6604c6:	48 83 c7 0c          	add    $0xc,%rdi
  6604ca:	49 ff c8             	dec    %r8
  6604cd:	49 83 f8 02          	cmp    $0x2,%r8
  6604d1:	77 e8                	ja     6604bb <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x28b>
  6604d3:	e9 1c ff ff ff       	jmp    6603f4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  6604d8:	f3 0f 10 84 24 e0 00 	movss  0xe0(%rsp),%xmm0
  6604df:	00 00 
  6604e1:	0f 57 c9             	xorps  %xmm1,%xmm1
  6604e4:	0f 2e c1             	ucomiss %xmm1,%xmm0
  6604e7:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
  6604ec:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  6604f3:	00 
  6604f4:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  6604fb:	00 
  6604fc:	75 06                	jne    660504 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2d4>
  6604fe:	0f 8b ac 00 00 00    	jnp    6605b0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x380>
  660504:	f3 0f 10 8c 24 d8 00 	movss  0xd8(%rsp),%xmm1
  66050b:	00 00 
  66050d:	f3 0f 10 9c 24 dc 00 	movss  0xdc(%rsp),%xmm3
  660514:	00 00 
  660516:	f3 0f 10 94 24 e4 00 	movss  0xe4(%rsp),%xmm2
  66051d:	00 00 
  66051f:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  660526:	00 
  660527:	f6 44 24 14 01       	testb  $0x1,0x14(%rsp)
  66052c:	0f 84 eb 00 00 00    	je     66061d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3ed>
  660532:	48 39 44 24 18       	cmp    %rax,0x18(%rsp)
  660537:	0f 85 90 00 00 00    	jne    6605cd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66053d:	f3 0f 10 64 24 10    	movss  0x10(%rsp),%xmm4
  660543:	0f 2e e3             	ucomiss %xmm3,%xmm4
  660546:	0f 85 81 00 00 00    	jne    6605cd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66054c:	7a 7f                	jp     6605cd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66054e:	f3 0f 10 64 24 0c    	movss  0xc(%rsp),%xmm4
  660554:	0f 2e e2             	ucomiss %xmm2,%xmm4
  660557:	75 74                	jne    6605cd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  660559:	7a 72                	jp     6605cd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66055b:	0f 28 e9             	movaps %xmm1,%xmm5
  66055e:	f3 0f 58 e8          	addss  %xmm0,%xmm5
  660562:	0f 2e ef             	ucomiss %xmm7,%xmm5
  660565:	72 61                	jb     6605c8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x398>
  660567:	0f 28 e6             	movaps %xmm6,%xmm4
  66056a:	f3 0f 58 e7          	addss  %xmm7,%xmm4
  66056e:	0f 2e e1             	ucomiss %xmm1,%xmm4
  660571:	72 55                	jb     6605c8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x398>
  660573:	0f 28 c4             	movaps %xmm4,%xmm0
  660576:	f3 0f 5f c5          	maxss  %xmm5,%xmm0
  66057a:	0f 28 f0             	movaps %xmm0,%xmm6
  66057d:	f3 0f c2 f0 03       	cmpunordss %xmm0,%xmm6
  660582:	0f 28 d6             	movaps %xmm6,%xmm2
  660585:	0f 55 d0             	andnps %xmm0,%xmm2
  660588:	0f 54 f4             	andps  %xmm4,%xmm6
  66058b:	0f 56 f2             	orps   %xmm2,%xmm6
  66058e:	0f 28 c7             	movaps %xmm7,%xmm0
  660591:	f3 0f 5d c1          	minss  %xmm1,%xmm0
  660595:	0f 28 c8             	movaps %xmm0,%xmm1
  660598:	f3 0f c2 c8 03       	cmpunordss %xmm0,%xmm1
  66059d:	0f 28 d1             	movaps %xmm1,%xmm2
  6605a0:	0f 55 d0             	andnps %xmm0,%xmm2
  6605a3:	0f 54 cf             	andps  %xmm7,%xmm1
  6605a6:	0f 56 ca             	orps   %xmm2,%xmm1
  6605a9:	f3 0f 5c f1          	subss  %xmm1,%xmm6
  6605ad:	0f 28 f9             	movaps %xmm1,%xmm7
  6605b0:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  6605b5:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6605ba:	48 85 c0             	test   %rax,%rax
  6605bd:	0f 85 7b fd ff ff    	jne    66033e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x10e>
  6605c3:	e9 c0 00 00 00       	jmp    660688 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  6605c8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6605cd:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  6605d2:	48 c1 c2 07          	rol    $0x7,%rdx
  6605d6:	66 0f 7e f9          	movd   %xmm7,%ecx
  6605da:	48 31 d1             	xor    %rdx,%rcx
  6605dd:	48 c1 c1 07          	rol    $0x7,%rcx
  6605e1:	66 0f 6e 64 24 10    	movd   0x10(%rsp),%xmm4
  6605e7:	66 0f 7e e2          	movd   %xmm4,%edx
  6605eb:	48 31 ca             	xor    %rcx,%rdx
  6605ee:	48 c1 c2 07          	rol    $0x7,%rdx
  6605f2:	66 0f 7e f1          	movd   %xmm6,%ecx
  6605f6:	48 31 d1             	xor    %rdx,%rcx
  6605f9:	48 c1 c1 07          	rol    $0x7,%rcx
  6605fd:	66 0f 6e 64 24 0c    	movd   0xc(%rsp),%xmm4
  660603:	66 0f 7e e2          	movd   %xmm4,%edx
  660607:	48 31 ca             	xor    %rcx,%rdx
  66060a:	48 c1 c2 07          	rol    $0x7,%rdx
  66060e:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  660612:	48 31 d1             	xor    %rdx,%rcx
  660615:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  66061a:	48 89 0b             	mov    %rcx,(%rbx)
  66061d:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  660622:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  660627:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  66062c:	b1 01                	mov    $0x1,%cl
  66062e:	89 4c 24 14          	mov    %ecx,0x14(%rsp)
  660632:	48 85 c0             	test   %rax,%rax
  660635:	0f 85 f1 fc ff ff    	jne    66032c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xfc>
  66063b:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  660641:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
  660647:	eb 4c                	jmp    660695 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x465>
  660649:	31 ed                	xor    %ebp,%ebp
  66064b:	89 e8                	mov    %ebp,%eax
  66064d:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  660654:	5b                   	pop    %rbx
  660655:	41 5c                	pop    %r12
  660657:	41 5d                	pop    %r13
  660659:	41 5e                	pop    %r14
  66065b:	41 5f                	pop    %r15
  66065d:	5d                   	pop    %rbp
  66065e:	c3                   	ret
  66065f:	48 8d 3d 5a 50 9c ff 	lea    -0x63afa6(%rip),%rdi        # 256c0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0xd10>
  660666:	48 8d 15 2b c0 11 00 	lea    0x11c02b(%rip),%rdx        # 77c698 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.17478163706573382256+0x18>
  66066d:	be 13 00 00 00       	mov    $0x13,%esi
  660672:	ff 15 f8 6c 12 00    	call   *0x126cf8(%rip)        # 787370 <_DYNAMIC+0x250>
  660678:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  66067f:	00 
  660680:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  660687:	00 
  660688:	0f 28 c6             	movaps %xmm6,%xmm0
  66068b:	0f 28 cf             	movaps %xmm7,%xmm1
  66068e:	f6 44 24 14 01       	testb  $0x1,0x14(%rsp)
  660693:	74 b6                	je     66064b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  660695:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  66069a:	48 c1 c1 07          	rol    $0x7,%rcx
  66069e:	66 0f 7e c8          	movd   %xmm1,%eax
  6606a2:	48 31 c8             	xor    %rcx,%rax
  6606a5:	48 c1 c0 07          	rol    $0x7,%rax
  6606a9:	66 0f 6e 4c 24 10    	movd   0x10(%rsp),%xmm1
  6606af:	66 0f 7e c9          	movd   %xmm1,%ecx
  6606b3:	48 31 c1             	xor    %rax,%rcx
  6606b6:	48 c1 c1 07          	rol    $0x7,%rcx
  6606ba:	66 0f 7e c0          	movd   %xmm0,%eax
  6606be:	48 31 c8             	xor    %rcx,%rax
  6606c1:	48 c1 c0 07          	rol    $0x7,%rax
  6606c5:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  6606cb:	66 0f 7e c1          	movd   %xmm0,%ecx
  6606cf:	48 31 c1             	xor    %rax,%rcx
  6606d2:	48 c1 c1 07          	rol    $0x7,%rcx
  6606d6:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6606da:	48 31 c8             	xor    %rcx,%rax
  6606dd:	48 89 03             	mov    %rax,(%rbx)
  6606e0:	e9 66 ff ff ff       	jmp    66064b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
