
/tmp/gpui-text-map-query-controls/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660180 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>:
  660180:	55                   	push   %rbp
  660181:	41 57                	push   %r15
  660183:	41 56                	push   %r14
  660185:	41 55                	push   %r13
  660187:	41 54                	push   %r12
  660189:	53                   	push   %rbx
  66018a:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  660191:	4c 8b 67 20          	mov    0x20(%rdi),%r12
  660195:	4d 85 e4             	test   %r12,%r12
  660198:	0f 84 03 04 00 00    	je     6605a1 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x421>
  66019e:	48 89 d3             	mov    %rdx,%rbx
  6601a1:	49 89 f7             	mov    %rsi,%r15
  6601a4:	4d 8d 74 24 10       	lea    0x10(%r12),%r14
  6601a9:	4c 89 f7             	mov    %r14,%rdi
  6601ac:	ff 15 16 72 12 00    	call   *0x127216(%rip)        # 7873c8 <_DYNAMIC+0x340>
  6601b2:	89 c5                	mov    %eax,%ebp
  6601b4:	84 c0                	test   %al,%al
  6601b6:	0f 84 e7 03 00 00    	je     6605a3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x423>
  6601bc:	41 8b 37             	mov    (%r15),%esi
  6601bf:	41 8b 47 08          	mov    0x8(%r15),%eax
  6601c3:	39 f0                	cmp    %esi,%eax
  6601c5:	0f 84 d8 03 00 00    	je     6605a3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x423>
  6601cb:	89 f2                	mov    %esi,%edx
  6601cd:	0f 47 d0             	cmova  %eax,%edx
  6601d0:	0f 42 f0             	cmovb  %eax,%esi
  6601d3:	4c 89 f7             	mov    %r14,%rdi
  6601d6:	ff 15 f4 71 12 00    	call   *0x1271f4(%rip)        # 7873d0 <_DYNAMIC+0x348>
  6601dc:	48 89 d1             	mov    %rdx,%rcx
  6601df:	f3 41 0f 10 44 24 5c 	movss  0x5c(%r12),%xmm0
  6601e6:	f3 0f 59 05 ca d2 9b 	mulss  -0x642d36(%rip),%xmm0        # 1d4b8 <GCC_except_table0+0x90>
  6601ed:	ff 
  6601ee:	48 8d bc 24 00 01 00 	lea    0x100(%rsp),%rdi
  6601f5:	00 
  6601f6:	4c 89 f6             	mov    %r14,%rsi
  6601f9:	48 89 c2             	mov    %rax,%rdx
  6601fc:	ff 15 d6 71 12 00    	call   *0x1271d6(%rip)        # 7873d8 <_DYNAMIC+0x350>
  660202:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  660209:	00 
  66020a:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  66020f:	f3 0f 6f 84 24 00 01 	movdqu 0x100(%rsp),%xmm0
  660216:	00 00 
  660218:	f3 0f 6f 8c 24 10 01 	movdqu 0x110(%rsp),%xmm1
  66021f:	00 00 
  660221:	0f 10 94 24 20 01 00 	movups 0x120(%rsp),%xmm2
  660228:	00 
  660229:	0f 10 9c 24 30 01 00 	movups 0x130(%rsp),%xmm3
  660230:	00 
  660231:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
  660236:	0f 29 54 24 50       	movaps %xmm2,0x50(%rsp)
  66023b:	66 0f 7f 4c 24 40    	movdqa %xmm1,0x40(%rsp)
  660241:	66 0f 7f 44 24 30    	movdqa %xmm0,0x30(%rsp)
  660247:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  66024c:	48 8b 0b             	mov    (%rbx),%rcx
  66024f:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  660254:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  660259:	48 85 c0             	test   %rax,%rax
  66025c:	0f 84 41 03 00 00    	je     6605a3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x423>
  660262:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  660267:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%rsp)
  66026e:	00 
  66026f:	4c 8d 64 24 28       	lea    0x28(%rsp),%r12
  660274:	4c 8d ac 24 a8 00 00 	lea    0xa8(%rsp),%r13
  66027b:	00 
  66027c:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
  660282:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  660288:	0f 28 f0             	movaps %xmm0,%xmm6
  66028b:	0f 28 f9             	movaps %xmm1,%xmm7
  66028e:	0f 29 b4 24 90 00 00 	movaps %xmm6,0x90(%rsp)
  660295:	00 
  660296:	0f 29 bc 24 80 00 00 	movaps %xmm7,0x80(%rsp)
  66029d:	00 
  66029e:	66 90                	xchg   %ax,%ax
  6602a0:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  6602a5:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  6602ab:	48 83 f8 01          	cmp    $0x1,%rax
  6602af:	74 26                	je     6602d7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x157>
  6602b1:	49 8d 4e 28          	lea    0x28(%r14),%rcx
  6602b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  6602b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6602c0:	8b 71 e8             	mov    -0x18(%rcx),%esi
  6602c3:	3b 31                	cmp    (%rcx),%esi
  6602c5:	75 10                	jne    6602d7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x157>
  6602c7:	49 ff c7             	inc    %r15
  6602ca:	48 83 c1 18          	add    $0x18,%rcx
  6602ce:	48 ff ca             	dec    %rdx
  6602d1:	48 83 fa 02          	cmp    $0x2,%rdx
  6602d5:	77 e9                	ja     6602c0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x140>
  6602d7:	4c 29 f8             	sub    %r15,%rax
  6602da:	0f 82 d7 02 00 00    	jb     6605b7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x437>
  6602e0:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  6602e4:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  6602e8:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  6602ed:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6602f2:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6602f7:	48 85 f6             	test   %rsi,%rsi
  6602fa:	0f 85 c8 00 00 00    	jne    6603c8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x248>
  660300:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  660305:	48 85 c0             	test   %rax,%rax
  660308:	0f 84 d2 02 00 00    	je     6605e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x460>
  66030e:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  660313:	ba 01 00 00 00       	mov    $0x1,%edx
  660318:	48 83 f8 01          	cmp    $0x1,%rax
  66031c:	74 2b                	je     660349 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c9>
  66031e:	48 8d 71 28          	lea    0x28(%rcx),%rsi
  660322:	48 8d 78 01          	lea    0x1(%rax),%rdi
  660326:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  66032d:	00 00 00 
  660330:	44 8b 46 e8          	mov    -0x18(%rsi),%r8d
  660334:	44 3b 06             	cmp    (%rsi),%r8d
  660337:	75 10                	jne    660349 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c9>
  660339:	48 ff c2             	inc    %rdx
  66033c:	48 83 c6 18          	add    $0x18,%rsi
  660340:	48 ff cf             	dec    %rdi
  660343:	48 83 ff 02          	cmp    $0x2,%rdi
  660347:	77 e7                	ja     660330 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1b0>
  660349:	48 29 d0             	sub    %rdx,%rax
  66034c:	0f 82 65 02 00 00    	jb     6605b7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x437>
  660352:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  660356:	48 8d 34 f1          	lea    (%rcx,%rsi,8),%rsi
  66035a:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  66035f:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  660364:	4c 89 b4 24 a8 00 00 	mov    %r14,0xa8(%rsp)
  66036b:	00 
  66036c:	4c 89 bc 24 b0 00 00 	mov    %r15,0xb0(%rsp)
  660373:	00 
  660374:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  66037b:	00 
  66037c:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  660383:	00 
  660384:	48 8d bc 24 c8 00 00 	lea    0xc8(%rsp),%rdi
  66038b:	00 
  66038c:	4c 89 e6             	mov    %r12,%rsi
  66038f:	4c 89 ea             	mov    %r13,%rdx
  660392:	e8 e9 07 00 00       	call   660b80 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>
  660397:	80 bc 24 cc 00 00 00 	cmpb   $0x2,0xcc(%rsp)
  66039e:	02 
  66039f:	0f 85 8b 00 00 00    	jne    660430 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2b0>
  6603a5:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6603aa:	48 85 c0             	test   %rax,%rax
  6603ad:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  6603b4:	00 
  6603b5:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  6603bc:	00 
  6603bd:	0f 85 dd fe ff ff    	jne    6602a0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  6603c3:	e9 18 02 00 00       	jmp    6605e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x460>
  6603c8:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  6603cf:	00 00 
  6603d1:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6603d6:	e8 05 0a 00 00       	call   660de0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  6603db:	48 85 c0             	test   %rax,%rax
  6603de:	0f 85 ec 01 00 00    	jne    6605d0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x450>
  6603e4:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6603e9:	48 85 c0             	test   %rax,%rax
  6603ec:	0f 84 de 01 00 00    	je     6605d0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x450>
  6603f2:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6603f7:	ba 01 00 00 00       	mov    $0x1,%edx
  6603fc:	48 83 f8 01          	cmp    $0x1,%rax
  660400:	0f 84 43 ff ff ff    	je     660349 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c9>
  660406:	48 8d 71 28          	lea    0x28(%rcx),%rsi
  66040a:	48 8d 78 01          	lea    0x1(%rax),%rdi
  66040e:	44 8b 46 e8          	mov    -0x18(%rsi),%r8d
  660412:	44 3b 06             	cmp    (%rsi),%r8d
  660415:	0f 85 2e ff ff ff    	jne    660349 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c9>
  66041b:	48 ff c2             	inc    %rdx
  66041e:	48 83 c6 18          	add    $0x18,%rsi
  660422:	48 ff cf             	dec    %rdi
  660425:	48 83 ff 02          	cmp    $0x2,%rdi
  660429:	77 e3                	ja     66040e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x28e>
  66042b:	e9 19 ff ff ff       	jmp    660349 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c9>
  660430:	f3 0f 10 84 24 e0 00 	movss  0xe0(%rsp),%xmm0
  660437:	00 00 
  660439:	0f 57 c9             	xorps  %xmm1,%xmm1
  66043c:	0f 2e c1             	ucomiss %xmm1,%xmm0
  66043f:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
  660444:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  66044b:	00 
  66044c:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  660453:	00 
  660454:	75 06                	jne    66045c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2dc>
  660456:	0f 8b ac 00 00 00    	jnp    660508 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x388>
  66045c:	f3 0f 10 8c 24 d8 00 	movss  0xd8(%rsp),%xmm1
  660463:	00 00 
  660465:	f3 0f 10 9c 24 dc 00 	movss  0xdc(%rsp),%xmm3
  66046c:	00 00 
  66046e:	f3 0f 10 94 24 e4 00 	movss  0xe4(%rsp),%xmm2
  660475:	00 00 
  660477:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  66047e:	00 
  66047f:	f6 44 24 14 01       	testb  $0x1,0x14(%rsp)
  660484:	0f 84 eb 00 00 00    	je     660575 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3f5>
  66048a:	48 39 44 24 18       	cmp    %rax,0x18(%rsp)
  66048f:	0f 85 90 00 00 00    	jne    660525 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a5>
  660495:	f3 0f 10 64 24 10    	movss  0x10(%rsp),%xmm4
  66049b:	0f 2e e3             	ucomiss %xmm3,%xmm4
  66049e:	0f 85 81 00 00 00    	jne    660525 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a5>
  6604a4:	7a 7f                	jp     660525 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a5>
  6604a6:	f3 0f 10 64 24 0c    	movss  0xc(%rsp),%xmm4
  6604ac:	0f 2e e2             	ucomiss %xmm2,%xmm4
  6604af:	75 74                	jne    660525 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a5>
  6604b1:	7a 72                	jp     660525 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a5>
  6604b3:	0f 28 e9             	movaps %xmm1,%xmm5
  6604b6:	f3 0f 58 e8          	addss  %xmm0,%xmm5
  6604ba:	0f 2e ef             	ucomiss %xmm7,%xmm5
  6604bd:	72 61                	jb     660520 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a0>
  6604bf:	0f 28 e6             	movaps %xmm6,%xmm4
  6604c2:	f3 0f 58 e7          	addss  %xmm7,%xmm4
  6604c6:	0f 2e e1             	ucomiss %xmm1,%xmm4
  6604c9:	72 55                	jb     660520 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a0>
  6604cb:	0f 28 c4             	movaps %xmm4,%xmm0
  6604ce:	f3 0f 5f c5          	maxss  %xmm5,%xmm0
  6604d2:	0f 28 f0             	movaps %xmm0,%xmm6
  6604d5:	f3 0f c2 f0 03       	cmpunordss %xmm0,%xmm6
  6604da:	0f 28 d6             	movaps %xmm6,%xmm2
  6604dd:	0f 55 d0             	andnps %xmm0,%xmm2
  6604e0:	0f 54 f4             	andps  %xmm4,%xmm6
  6604e3:	0f 56 f2             	orps   %xmm2,%xmm6
  6604e6:	0f 28 c7             	movaps %xmm7,%xmm0
  6604e9:	f3 0f 5d c1          	minss  %xmm1,%xmm0
  6604ed:	0f 28 c8             	movaps %xmm0,%xmm1
  6604f0:	f3 0f c2 c8 03       	cmpunordss %xmm0,%xmm1
  6604f5:	0f 28 d1             	movaps %xmm1,%xmm2
  6604f8:	0f 55 d0             	andnps %xmm0,%xmm2
  6604fb:	0f 54 cf             	andps  %xmm7,%xmm1
  6604fe:	0f 56 ca             	orps   %xmm2,%xmm1
  660501:	f3 0f 5c f1          	subss  %xmm1,%xmm6
  660505:	0f 28 f9             	movaps %xmm1,%xmm7
  660508:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  66050d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  660512:	48 85 c0             	test   %rax,%rax
  660515:	0f 85 73 fd ff ff    	jne    66028e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x10e>
  66051b:	e9 c0 00 00 00       	jmp    6605e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x460>
  660520:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  660525:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  66052a:	48 c1 c2 07          	rol    $0x7,%rdx
  66052e:	66 0f 7e f9          	movd   %xmm7,%ecx
  660532:	48 31 d1             	xor    %rdx,%rcx
  660535:	48 c1 c1 07          	rol    $0x7,%rcx
  660539:	66 0f 6e 64 24 10    	movd   0x10(%rsp),%xmm4
  66053f:	66 0f 7e e2          	movd   %xmm4,%edx
  660543:	48 31 ca             	xor    %rcx,%rdx
  660546:	48 c1 c2 07          	rol    $0x7,%rdx
  66054a:	66 0f 7e f1          	movd   %xmm6,%ecx
  66054e:	48 31 d1             	xor    %rdx,%rcx
  660551:	48 c1 c1 07          	rol    $0x7,%rcx
  660555:	66 0f 6e 64 24 0c    	movd   0xc(%rsp),%xmm4
  66055b:	66 0f 7e e2          	movd   %xmm4,%edx
  66055f:	48 31 ca             	xor    %rcx,%rdx
  660562:	48 c1 c2 07          	rol    $0x7,%rdx
  660566:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  66056a:	48 31 d1             	xor    %rdx,%rcx
  66056d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  660572:	48 89 0b             	mov    %rcx,(%rbx)
  660575:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  66057a:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  66057f:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  660584:	b1 01                	mov    $0x1,%cl
  660586:	89 4c 24 14          	mov    %ecx,0x14(%rsp)
  66058a:	48 85 c0             	test   %rax,%rax
  66058d:	0f 85 e9 fc ff ff    	jne    66027c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xfc>
  660593:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  660599:	f3 0f 11 5c 24 10    	movss  %xmm3,0x10(%rsp)
  66059f:	eb 4c                	jmp    6605ed <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x46d>
  6605a1:	31 ed                	xor    %ebp,%ebp
  6605a3:	89 e8                	mov    %ebp,%eax
  6605a5:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  6605ac:	5b                   	pop    %rbx
  6605ad:	41 5c                	pop    %r12
  6605af:	41 5d                	pop    %r13
  6605b1:	41 5e                	pop    %r14
  6605b3:	41 5f                	pop    %r15
  6605b5:	5d                   	pop    %rbp
  6605b6:	c3                   	ret
  6605b7:	48 8d 3d d2 50 9c ff 	lea    -0x63af2e(%rip),%rdi        # 25690 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0xd10>
  6605be:	48 8d 15 53 c0 11 00 	lea    0x11c053(%rip),%rdx        # 77c618 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.8511590685880311727+0x18>
  6605c5:	be 13 00 00 00       	mov    $0x13,%esi
  6605ca:	ff 15 08 6d 12 00    	call   *0x126d08(%rip)        # 7872d8 <_DYNAMIC+0x250>
  6605d0:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  6605d7:	00 
  6605d8:	0f 28 bc 24 80 00 00 	movaps 0x80(%rsp),%xmm7
  6605df:	00 
  6605e0:	0f 28 c6             	movaps %xmm6,%xmm0
  6605e3:	0f 28 cf             	movaps %xmm7,%xmm1
  6605e6:	f6 44 24 14 01       	testb  $0x1,0x14(%rsp)
  6605eb:	74 b6                	je     6605a3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x423>
  6605ed:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6605f2:	48 c1 c1 07          	rol    $0x7,%rcx
  6605f6:	66 0f 7e c8          	movd   %xmm1,%eax
  6605fa:	48 31 c8             	xor    %rcx,%rax
  6605fd:	48 c1 c0 07          	rol    $0x7,%rax
  660601:	66 0f 6e 4c 24 10    	movd   0x10(%rsp),%xmm1
  660607:	66 0f 7e c9          	movd   %xmm1,%ecx
  66060b:	48 31 c1             	xor    %rax,%rcx
  66060e:	48 c1 c1 07          	rol    $0x7,%rcx
  660612:	66 0f 7e c0          	movd   %xmm0,%eax
  660616:	48 31 c8             	xor    %rcx,%rax
  660619:	48 c1 c0 07          	rol    $0x7,%rax
  66061d:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  660623:	66 0f 7e c1          	movd   %xmm0,%ecx
  660627:	48 31 c1             	xor    %rax,%rcx
  66062a:	48 c1 c1 07          	rol    $0x7,%rcx
  66062e:	8b 44 24 18          	mov    0x18(%rsp),%eax
  660632:	48 31 c8             	xor    %rcx,%rax
  660635:	48 89 03             	mov    %rax,(%rbx)
  660638:	e9 66 ff ff ff       	jmp    6605a3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x423>
