
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660260 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>:
  660260:	55                   	push   %rbp
  660261:	41 57                	push   %r15
  660263:	41 56                	push   %r14
  660265:	41 55                	push   %r13
  660267:	41 54                	push   %r12
  660269:	53                   	push   %rbx
  66026a:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  660271:	4c 8b 67 20          	mov    0x20(%rdi),%r12
  660275:	4d 85 e4             	test   %r12,%r12
  660278:	0f 84 fb 03 00 00    	je     660679 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x419>
  66027e:	48 89 d3             	mov    %rdx,%rbx
  660281:	49 89 f7             	mov    %rsi,%r15
  660284:	4d 8d 74 24 10       	lea    0x10(%r12),%r14
  660289:	4c 89 f7             	mov    %r14,%rdi
  66028c:	ff 15 ce 73 12 00    	call   *0x1273ce(%rip)        # 787660 <_DYNAMIC+0x340>
  660292:	89 c5                	mov    %eax,%ebp
  660294:	84 c0                	test   %al,%al
  660296:	0f 84 df 03 00 00    	je     66067b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  66029c:	41 8b 37             	mov    (%r15),%esi
  66029f:	41 8b 47 08          	mov    0x8(%r15),%eax
  6602a3:	39 f0                	cmp    %esi,%eax
  6602a5:	0f 84 d0 03 00 00    	je     66067b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  6602ab:	89 f2                	mov    %esi,%edx
  6602ad:	0f 47 d0             	cmova  %eax,%edx
  6602b0:	0f 42 f0             	cmovb  %eax,%esi
  6602b3:	4c 89 f7             	mov    %r14,%rdi
  6602b6:	ff 15 ac 73 12 00    	call   *0x1273ac(%rip)        # 787668 <_DYNAMIC+0x348>
  6602bc:	48 89 d1             	mov    %rdx,%rcx
  6602bf:	f3 41 0f 10 44 24 5c 	movss  0x5c(%r12),%xmm0
  6602c6:	f3 0f 59 05 2a d2 9b 	mulss  -0x642dd6(%rip),%xmm0        # 1d4f8 <GCC_except_table0+0x88>
  6602cd:	ff 
  6602ce:	48 8d bc 24 00 01 00 	lea    0x100(%rsp),%rdi
  6602d5:	00 
  6602d6:	4c 89 f6             	mov    %r14,%rsi
  6602d9:	48 89 c2             	mov    %rax,%rdx
  6602dc:	ff 15 8e 73 12 00    	call   *0x12738e(%rip)        # 787670 <_DYNAMIC+0x350>
  6602e2:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  6602e9:	00 
  6602ea:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6602ef:	f3 0f 6f 84 24 00 01 	movdqu 0x100(%rsp),%xmm0
  6602f6:	00 00 
  6602f8:	f3 0f 6f 8c 24 10 01 	movdqu 0x110(%rsp),%xmm1
  6602ff:	00 00 
  660301:	0f 10 94 24 20 01 00 	movups 0x120(%rsp),%xmm2
  660308:	00 
  660309:	0f 10 9c 24 30 01 00 	movups 0x130(%rsp),%xmm3
  660310:	00 
  660311:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
  660316:	0f 29 54 24 50       	movaps %xmm2,0x50(%rsp)
  66031b:	66 0f 7f 4c 24 40    	movdqa %xmm1,0x40(%rsp)
  660321:	66 0f 7f 44 24 30    	movdqa %xmm0,0x30(%rsp)
  660327:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  66032c:	48 8b 0b             	mov    (%rbx),%rcx
  66032f:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  660334:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  660339:	48 85 c0             	test   %rax,%rax
  66033c:	0f 84 39 03 00 00    	je     66067b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  660342:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  660347:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%rsp)
  66034e:	00 
  66034f:	4c 8d 64 24 28       	lea    0x28(%rsp),%r12
  660354:	4c 8d ac 24 a8 00 00 	lea    0xa8(%rsp),%r13
  66035b:	00 
  66035c:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
  660362:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  660368:	0f 28 f0             	movaps %xmm0,%xmm6
  66036b:	0f 28 f9             	movaps %xmm1,%xmm7
  66036e:	0f 29 b4 24 90 00 00 	movaps %xmm6,0x90(%rsp)
  660375:	00 
  660376:	0f 29 bc 24 80 00 00 	movaps %xmm7,0x80(%rsp)
  66037d:	00 
  66037e:	66 90                	xchg   %ax,%ax
  660380:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  660385:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  66038b:	48 83 f8 01          	cmp    $0x1,%rax
  66038f:	74 23                	je     6603b4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x154>
  660391:	41 8b 0e             	mov    (%r14),%ecx
  660394:	49 8d 56 0c          	lea    0xc(%r14),%rdx
  660398:	48 8d 70 01          	lea    0x1(%rax),%rsi
  66039c:	0f 1f 40 00          	nopl   0x0(%rax)
  6603a0:	3b 0a                	cmp    (%rdx),%ecx
  6603a2:	75 10                	jne    6603b4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x154>
  6603a4:	49 ff c7             	inc    %r15
  6603a7:	48 83 c2 0c          	add    $0xc,%rdx
  6603ab:	48 ff ce             	dec    %rsi
  6603ae:	48 83 fe 02          	cmp    $0x2,%rsi
  6603b2:	77 ec                	ja     6603a0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x140>
  6603b4:	4c 29 f8             	sub    %r15,%rax
  6603b7:	0f 82 d2 02 00 00    	jb     66068f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x42f>
  6603bd:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  6603c1:	49 8d 0c 8e          	lea    (%r14,%rcx,4),%rcx
  6603c5:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  6603ca:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6603cf:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6603d4:	48 85 f6             	test   %rsi,%rsi
  6603d7:	0f 85 c6 00 00 00    	jne    6604a3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x243>
  6603dd:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6603e2:	48 85 c0             	test   %rax,%rax
  6603e5:	0f 84 cd 02 00 00    	je     6606b8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  6603eb:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6603f0:	ba 01 00 00 00       	mov    $0x1,%edx
  6603f5:	48 83 f8 01          	cmp    $0x1,%rax
  6603f9:	74 29                	je     660424 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  6603fb:	8b 31                	mov    (%rcx),%esi
  6603fd:	48 8d 79 0c          	lea    0xc(%rcx),%rdi
  660401:	4c 8d 40 01          	lea    0x1(%rax),%r8
  660405:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66040c:	00 00 00 00 
  660410:	3b 37                	cmp    (%rdi),%esi
  660412:	75 10                	jne    660424 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  660414:	48 ff c2             	inc    %rdx
  660417:	48 83 c7 0c          	add    $0xc,%rdi
  66041b:	49 ff c8             	dec    %r8
  66041e:	49 83 f8 02          	cmp    $0x2,%r8
  660422:	77 ec                	ja     660410 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1b0>
  660424:	48 29 d0             	sub    %rdx,%rax
  660427:	0f 82 62 02 00 00    	jb     66068f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x42f>
  66042d:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  660431:	48 8d 34 b1          	lea    (%rcx,%rsi,4),%rsi
  660435:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  66043a:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  66043f:	4c 89 b4 24 a8 00 00 	mov    %r14,0xa8(%rsp)
  660446:	00 
  660447:	4c 89 bc 24 b0 00 00 	mov    %r15,0xb0(%rsp)
  66044e:	00 
  66044f:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  660456:	00 
  660457:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  66045e:	00 
  66045f:	48 8d bc 24 c8 00 00 	lea    0xc8(%rsp),%rdi
  660466:	00 
  660467:	4c 89 e6             	mov    %r12,%rsi
  66046a:	4c 89 ea             	mov    %r13,%rdx
  66046d:	e8 ee 07 00 00       	call   660c60 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>
  660472:	80 bc 24 cc 00 00 00 	cmpb   $0x2,0xcc(%rsp)
  660479:	02 
  66047a:	0f 85 88 00 00 00    	jne    660508 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2a8>
  660480:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  660485:	48 85 c0             	test   %rax,%rax
  660488:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  66048f:	00 
  660490:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  660497:	00 
  660498:	0f 85 e2 fe ff ff    	jne    660380 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  66049e:	e9 15 02 00 00       	jmp    6606b8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  6604a3:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  6604aa:	00 00 
  6604ac:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6604b1:	e8 aa 0a 00 00       	call   660f60 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  6604b6:	48 85 c0             	test   %rax,%rax
  6604b9:	0f 85 e9 01 00 00    	jne    6606a8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x448>
  6604bf:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6604c4:	48 85 c0             	test   %rax,%rax
  6604c7:	0f 84 db 01 00 00    	je     6606a8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x448>
  6604cd:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6604d2:	ba 01 00 00 00       	mov    $0x1,%edx
  6604d7:	48 83 f8 01          	cmp    $0x1,%rax
  6604db:	0f 84 43 ff ff ff    	je     660424 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  6604e1:	8b 31                	mov    (%rcx),%esi
  6604e3:	48 8d 79 0c          	lea    0xc(%rcx),%rdi
  6604e7:	4c 8d 40 01          	lea    0x1(%rax),%r8
  6604eb:	3b 37                	cmp    (%rdi),%esi
  6604ed:	0f 85 31 ff ff ff    	jne    660424 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  6604f3:	48 ff c2             	inc    %rdx
  6604f6:	48 83 c7 0c          	add    $0xc,%rdi
  6604fa:	49 ff c8             	dec    %r8
  6604fd:	49 83 f8 02          	cmp    $0x2,%r8
  660501:	77 e8                	ja     6604eb <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x28b>
  660503:	e9 1c ff ff ff       	jmp    660424 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c4>
  660508:	f3 0f 10 84 24 e0 00 	movss  0xe0(%rsp),%xmm0
  66050f:	00 00 
  660511:	0f 57 c9             	xorps  %xmm1,%xmm1
  660514:	0f 2e c1             	ucomiss %xmm1,%xmm0
  660517:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
  66051c:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  660523:	00 
  660524:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  66052b:	00 
  66052c:	75 06                	jne    660534 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2d4>
  66052e:	0f 8b ac 00 00 00    	jnp    6605e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x380>
  660534:	f3 0f 10 8c 24 d8 00 	movss  0xd8(%rsp),%xmm1
  66053b:	00 00 
  66053d:	f3 0f 10 9c 24 dc 00 	movss  0xdc(%rsp),%xmm3
  660544:	00 00 
  660546:	f3 0f 10 94 24 e4 00 	movss  0xe4(%rsp),%xmm2
  66054d:	00 00 
  66054f:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  660556:	00 
  660557:	f6 44 24 14 01       	testb  $0x1,0x14(%rsp)
  66055c:	0f 84 eb 00 00 00    	je     66064d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3ed>
  660562:	48 39 44 24 18       	cmp    %rax,0x18(%rsp)
  660567:	0f 85 90 00 00 00    	jne    6605fd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66056d:	f3 0f 10 64 24 10    	movss  0x10(%rsp),%xmm4
  660573:	0f 2e e3             	ucomiss %xmm3,%xmm4
  660576:	0f 85 81 00 00 00    	jne    6605fd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66057c:	7a 7f                	jp     6605fd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66057e:	f3 0f 10 64 24 0c    	movss  0xc(%rsp),%xmm4
  660584:	0f 2e e2             	ucomiss %xmm2,%xmm4
  660587:	75 74                	jne    6605fd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  660589:	7a 72                	jp     6605fd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x39d>
  66058b:	0f 28 e9             	movaps %xmm1,%xmm5
  66058e:	f3 0f 58 e8          	addss  %xmm0,%xmm5
  660592:	0f 2e ef             	ucomiss %xmm7,%xmm5
  660595:	72 61                	jb     6605f8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x398>
  660597:	0f 28 e6             	movaps %xmm6,%xmm4
  66059a:	f3 0f 58 e7          	addss  %xmm7,%xmm4
  66059e:	0f 2e e1             	ucomiss %xmm1,%xmm4
  6605a1:	72 55                	jb     6605f8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x398>
  6605a3:	0f 28 c4             	movaps %xmm4,%xmm0
  6605a6:	f3 0f 5f c5          	maxss  %xmm5,%xmm0
  6605aa:	0f 28 f0             	movaps %xmm0,%xmm6
  6605ad:	f3 0f c2 f0 03       	cmpunordss %xmm0,%xmm6
  6605b2:	0f 28 d6             	movaps %xmm6,%xmm2
  6605b5:	0f 55 d0             	andnps %xmm0,%xmm2
  6605b8:	0f 54 f4             	andps  %xmm4,%xmm6
  6605bb:	0f 56 f2             	orps   %xmm2,%xmm6
  6605be:	0f 28 c7             	movaps %xmm7,%xmm0
  6605c1:	f3 0f 5d c1          	minss  %xmm1,%xmm0
  6605c5:	0f 28 c8             	movaps %xmm0,%xmm1
  6605c8:	f3 0f c2 c8 03       	cmpunordss %xmm0,%xmm1
  6605cd:	0f 28 d1             	movaps %xmm1,%xmm2
  6605d0:	0f 55 d0             	andnps %xmm0,%xmm2
  6605d3:	0f 54 cf             	andps  %xmm7,%xmm1
  6605d6:	0f 56 ca             	orps   %xmm2,%xmm1
  6605d9:	f3 0f 5c f1          	subss  %xmm1,%xmm6
  6605dd:	0f 28 f9             	movaps %xmm1,%xmm7
  6605e0:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  6605e5:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6605ea:	48 85 c0             	test   %rax,%rax
  6605ed:	0f 85 7b fd ff ff    	jne    66036e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x10e>
  6605f3:	e9 c0 00 00 00       	jmp    6606b8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  6605f8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6605fd:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  660602:	48 c1 c2 07          	rol    $0x7,%rdx
  660606:	66 0f 7e f9          	movd   %xmm7,%ecx
  66060a:	48 31 d1             	xor    %rdx,%rcx
  66060d:	48 c1 c1 07          	rol    $0x7,%rcx
  660611:	66 0f 6e 64 24 10    	movd   0x10(%rsp),%xmm4
  660617:	66 0f 7e e2          	movd   %xmm4,%edx
  66061b:	48 31 ca             	xor    %rcx,%rdx
  66061e:	48 c1 c2 07          	rol    $0x7,%rdx
  660622:	66 0f 7e f1          	movd   %xmm6,%ecx
  660626:	48 31 d1             	xor    %rdx,%rcx
  660629:	48 c1 c1 07          	rol    $0x7,%rcx
  66062d:	66 0f 6e 64 24 0c    	movd   0xc(%rsp),%xmm4
  660633:	66 0f 7e e2          	movd   %xmm4,%edx
  660637:	48 31 ca             	xor    %rcx,%rdx
  66063a:	48 c1 c2 07          	rol    $0x7,%rdx
  66063e:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  660642:	48 31 d1             	xor    %rdx,%rcx
  660645:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  66064a:	48 89 0b             	mov    %rcx,(%rbx)
  66064d:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  660652:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  660657:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  66065c:	b1 01                	mov    $0x1,%cl
  66065e:	89 4c 24 14          	mov    %ecx,0x14(%rsp)
  660662:	48 85 c0             	test   %rax,%rax
  660665:	0f 85 f1 fc ff ff    	jne    66035c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xfc>
  66066b:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  660671:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
  660677:	eb 4c                	jmp    6606c5 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x465>
  660679:	31 ed                	xor    %ebp,%ebp
  66067b:	89 e8                	mov    %ebp,%eax
  66067d:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  660684:	5b                   	pop    %rbx
  660685:	41 5c                	pop    %r12
  660687:	41 5d                	pop    %r13
  660689:	41 5e                	pop    %r14
  66068b:	41 5f                	pop    %r15
  66068d:	5d                   	pop    %rbp
  66068e:	c3                   	ret
  66068f:	48 8d 3d 5a 50 9c ff 	lea    -0x63afa6(%rip),%rdi        # 256f0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0xd10>
  660696:	48 8d 15 cb c1 11 00 	lea    0x11c1cb(%rip),%rdx        # 77c868 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.17478163706573382256+0x18>
  66069d:	be 13 00 00 00       	mov    $0x13,%esi
  6606a2:	ff 15 c8 6e 12 00    	call   *0x126ec8(%rip)        # 787570 <_DYNAMIC+0x250>
  6606a8:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  6606af:	00 
  6606b0:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  6606b7:	00 
  6606b8:	0f 28 c6             	movaps %xmm6,%xmm0
  6606bb:	0f 28 cf             	movaps %xmm7,%xmm1
  6606be:	f6 44 24 14 01       	testb  $0x1,0x14(%rsp)
  6606c3:	74 b6                	je     66067b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
  6606c5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6606ca:	48 c1 c1 07          	rol    $0x7,%rcx
  6606ce:	66 0f 7e c8          	movd   %xmm1,%eax
  6606d2:	48 31 c8             	xor    %rcx,%rax
  6606d5:	48 c1 c0 07          	rol    $0x7,%rax
  6606d9:	66 0f 6e 4c 24 10    	movd   0x10(%rsp),%xmm1
  6606df:	66 0f 7e c9          	movd   %xmm1,%ecx
  6606e3:	48 31 c1             	xor    %rax,%rcx
  6606e6:	48 c1 c1 07          	rol    $0x7,%rcx
  6606ea:	66 0f 7e c0          	movd   %xmm0,%eax
  6606ee:	48 31 c8             	xor    %rcx,%rax
  6606f1:	48 c1 c0 07          	rol    $0x7,%rax
  6606f5:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  6606fb:	66 0f 7e c1          	movd   %xmm0,%ecx
  6606ff:	48 31 c1             	xor    %rax,%rcx
  660702:	48 c1 c1 07          	rol    $0x7,%rcx
  660706:	8b 44 24 18          	mov    0x18(%rsp),%eax
  66070a:	48 31 c8             	xor    %rcx,%rax
  66070d:	48 89 03             	mov    %rax,(%rbx)
  660710:	e9 66 ff ff ff       	jmp    66067b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x41b>
