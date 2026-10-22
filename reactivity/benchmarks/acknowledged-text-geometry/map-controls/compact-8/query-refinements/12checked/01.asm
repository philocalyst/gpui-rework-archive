
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661460 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>:
  661460:	55                   	push   %rbp
  661461:	41 57                	push   %r15
  661463:	41 56                	push   %r14
  661465:	41 55                	push   %r13
  661467:	41 54                	push   %r12
  661469:	53                   	push   %rbx
  66146a:	48 83 ec 48          	sub    $0x48,%rsp
  66146e:	48 8b 0a             	mov    (%rdx),%rcx
  661471:	4c 8b 42 08          	mov    0x8(%rdx),%r8
  661475:	4c 8b 6a 10          	mov    0x10(%rdx),%r13
  661479:	48 8b 42 18          	mov    0x18(%rdx),%rax
  66147d:	48 83 c1 f4          	add    $0xfffffffffffffff4,%rcx
  661481:	49 c1 e0 02          	shl    $0x2,%r8
  661485:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
  661489:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  661490:	48 85 d2             	test   %rdx,%rdx
  661493:	0f 84 0a 01 00 00    	je     6615a3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x143>
  661499:	4c 8d 71 0c          	lea    0xc(%rcx),%r14
  66149d:	48 83 c2 f4          	add    $0xfffffffffffffff4,%rdx
  6614a1:	f6 41 14 02          	testb  $0x2,0x14(%rcx)
  6614a5:	4c 89 f1             	mov    %r14,%rcx
  6614a8:	74 e6                	je     661490 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x30>
  6614aa:	48 c1 e0 02          	shl    $0x2,%rax
  6614ae:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6614b2:	31 c9                	xor    %ecx,%ecx
  6614b4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6614bb:	00 00 00 00 00 
  6614c0:	48 39 c8             	cmp    %rcx,%rax
  6614c3:	0f 84 da 00 00 00    	je     6615a3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x143>
  6614c9:	4c 8d 61 0c          	lea    0xc(%rcx),%r12
  6614cd:	41 f6 44 0d 08 01    	testb  $0x1,0x8(%r13,%rcx,1)
  6614d3:	4c 89 e1             	mov    %r12,%rcx
  6614d6:	74 e8                	je     6614c0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x60>
  6614d8:	41 8b 2e             	mov    (%r14),%ebp
  6614db:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  6614df:	48 8b 46 28          	mov    0x28(%rsi),%rax
  6614e3:	48 89 c3             	mov    %rax,%rbx
  6614e6:	48 85 c0             	test   %rax,%rax
  6614e9:	74 4e                	je     661539 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xd9>
  6614eb:	31 d2                	xor    %edx,%edx
  6614ed:	48 83 f8 01          	cmp    $0x1,%rax
  6614f1:	74 2e                	je     661521 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xc1>
  6614f3:	49 89 c0             	mov    %rax,%r8
  6614f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  6614fd:	00 00 00 
  661500:	49 89 d1             	mov    %rdx,%r9
  661503:	4d 89 c2             	mov    %r8,%r10
  661506:	49 d1 ea             	shr    $1,%r10
  661509:	4c 01 d2             	add    %r10,%rdx
  66150c:	4c 8d 1c 52          	lea    (%rdx,%rdx,2),%r11
  661510:	42 39 2c d9          	cmp    %ebp,(%rcx,%r11,8)
  661514:	49 0f 47 d1          	cmova  %r9,%rdx
  661518:	4d 29 d0             	sub    %r10,%r8
  66151b:	49 83 f8 01          	cmp    $0x1,%r8
  66151f:	77 df                	ja     661500 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xa0>
  661521:	4c 8d 04 52          	lea    (%rdx,%rdx,2),%r8
  661525:	31 db                	xor    %ebx,%ebx
  661527:	42 39 2c c1          	cmp    %ebp,(%rcx,%r8,8)
  66152b:	0f 96 c3             	setbe  %bl
  66152e:	48 01 d3             	add    %rdx,%rbx
  661531:	48 83 fb 01          	cmp    $0x1,%rbx
  661535:	48 83 d3 ff          	adc    $0xffffffffffffffff,%rbx
  661539:	89 6c 24 0c          	mov    %ebp,0xc(%rsp)
  66153d:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  661542:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  661547:	48 39 c3             	cmp    %rax,%rbx
  66154a:	0f 83 a6 01 00 00    	jae    6616f6 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x296>
  661550:	47 8b 7c 25 f4       	mov    -0xc(%r13,%r12,1),%r15d
  661555:	48 8d 04 5b          	lea    (%rbx,%rbx,2),%rax
  661559:	8b 6c c1 04          	mov    0x4(%rcx,%rax,8),%ebp
  66155d:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  661562:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  661567:	4c 89 f2             	mov    %r14,%rdx
  66156a:	ff 15 48 5f 12 00    	call   *0x125f48(%rip)        # 7874b8 <_DYNAMIC+0x398>
  661570:	45 89 fb             	mov    %r15d,%r11d
  661573:	f3 41 0f 10 46 04    	movss  0x4(%r14),%xmm0
  661579:	f3 43 0f 10 4c 25 f8 	movss  -0x8(%r13,%r12,1),%xmm1
  661580:	41 89 ec             	mov    %ebp,%r12d
  661583:	41 39 ef             	cmp    %ebp,%r15d
  661586:	77 24                	ja     6615ac <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x14c>
  661588:	0f 2e c1             	ucomiss %xmm1,%xmm0
  66158b:	75 02                	jne    66158f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x12f>
  66158d:	7b 1d                	jnp    6615ac <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x14c>
  66158f:	0f 2e c8             	ucomiss %xmm0,%xmm1
  661592:	0f 96 c1             	setbe  %cl
  661595:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  66159a:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  66159e:	e9 bb 00 00 00       	jmp    66165e <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1fe>
  6615a3:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  6615a7:	e9 3b 01 00 00       	jmp    6616e7 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x287>
  6615ac:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  6615b1:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  6615b5:	49 8b 57 10          	mov    0x10(%r15),%rdx
  6615b9:	48 89 d6             	mov    %rdx,%rsi
  6615bc:	48 85 d2             	test   %rdx,%rdx
  6615bf:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6615c4:	0f 28 6c 24 30       	movaps 0x30(%rsp),%xmm5
  6615c9:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  6615cd:	74 43                	je     661612 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1b2>
  6615cf:	31 f6                	xor    %esi,%esi
  6615d1:	48 83 fa 01          	cmp    $0x1,%rdx
  6615d5:	74 2c                	je     661603 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1a3>
  6615d7:	48 89 d7             	mov    %rdx,%rdi
  6615da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  6615e0:	49 89 f8             	mov    %rdi,%r8
  6615e3:	49 d1 e8             	shr    $1,%r8
  6615e6:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  6615ea:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  6615ee:	46 8b 54 d1 10       	mov    0x10(%rcx,%r10,8),%r10d
  6615f3:	4c 39 d3             	cmp    %r10,%rbx
  6615f6:	49 0f 47 f1          	cmova  %r9,%rsi
  6615fa:	4c 29 c7             	sub    %r8,%rdi
  6615fd:	48 83 ff 01          	cmp    $0x1,%rdi
  661601:	77 dd                	ja     6615e0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x180>
  661603:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  661607:	8b 7c f9 10          	mov    0x10(%rcx,%rdi,8),%edi
  66160b:	48 39 df             	cmp    %rbx,%rdi
  66160e:	48 83 d6 00          	adc    $0x0,%rsi
  661612:	48 c1 e6 03          	shl    $0x3,%rsi
  661616:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  66161a:	4c 8d 04 31          	lea    (%rcx,%rsi,1),%r8
  66161e:	41 8b 3e             	mov    (%r14),%edi
  661621:	48 c1 e2 03          	shl    $0x3,%rdx
  661625:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  661629:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  661630:	48 39 f2             	cmp    %rsi,%rdx
  661633:	74 5a                	je     66168f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x22f>
  661635:	4d 89 c1             	mov    %r8,%r9
  661638:	45 8b 40 10          	mov    0x10(%r8),%r8d
  66163c:	4c 39 c3             	cmp    %r8,%rbx
  66163f:	75 4e                	jne    66168f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x22f>
  661641:	4d 8d 41 18          	lea    0x18(%r9),%r8
  661645:	48 83 c6 18          	add    $0x18,%rsi
  661649:	41 39 39             	cmp    %edi,(%r9)
  66164c:	77 e2                	ja     661630 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1d0>
  66164e:	41 3b 79 04          	cmp    0x4(%r9),%edi
  661652:	77 dc                	ja     661630 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1d0>
  661654:	0f b6 4c 31 fd       	movzbl -0x3(%rcx,%rsi,1),%ecx
  661659:	45 39 e3             	cmp    %r12d,%r11d
  66165c:	77 38                	ja     661696 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x236>
  66165e:	0f 28 d8             	movaps %xmm0,%xmm3
  661661:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  661665:	0f 28 d3             	movaps %xmm3,%xmm2
  661668:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  66166d:	0f 28 e2             	movaps %xmm2,%xmm4
  661670:	0f 55 e3             	andnps %xmm3,%xmm4
  661673:	0f 54 d0             	andps  %xmm0,%xmm2
  661676:	0f 56 d4             	orps   %xmm4,%xmm2
  661679:	f3 0f 10 5c 24 24    	movss  0x24(%rsp),%xmm3
  66167f:	0f 28 e9             	movaps %xmm1,%xmm5
  661682:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  661686:	0f 54 2d 03 3b 9c ff 	andps  -0x63c4fd(%rip),%xmm5        # 25190 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  66168d:	eb 18                	jmp    6616a7 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x247>
  66168f:	31 c9                	xor    %ecx,%ecx
  661691:	45 39 e3             	cmp    %r12d,%r11d
  661694:	76 c8                	jbe    66165e <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1fe>
  661696:	0f 28 d0             	movaps %xmm0,%xmm2
  661699:	84 c9                	test   %cl,%cl
  66169b:	74 04                	je     6616a1 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x241>
  66169d:	f3 0f 5c d5          	subss  %xmm5,%xmm2
  6616a1:	f3 0f 10 5c 24 24    	movss  0x24(%rsp),%xmm3
  6616a7:	45 39 e3             	cmp    %r12d,%r11d
  6616aa:	f3 0f 10 64 24 2c    	movss  0x2c(%rsp),%xmm4
  6616b0:	89 28                	mov    %ebp,(%rax)
  6616b2:	c6 40 04 01          	movb   $0x1,0x4(%rax)
  6616b6:	44 89 58 08          	mov    %r11d,0x8(%rax)
  6616ba:	c6 40 0c 00          	movb   $0x0,0xc(%rax)
  6616be:	f3 0f 11 50 10       	movss  %xmm2,0x10(%rax)
  6616c3:	f3 0f 11 58 14       	movss  %xmm3,0x14(%rax)
  6616c8:	f3 0f 11 68 18       	movss  %xmm5,0x18(%rax)
  6616cd:	f3 0f 11 60 1c       	movss  %xmm4,0x1c(%rax)
  6616d2:	48 89 58 20          	mov    %rbx,0x20(%rax)
  6616d6:	f3 0f 11 40 28       	movss  %xmm0,0x28(%rax)
  6616db:	f3 0f 11 48 2c       	movss  %xmm1,0x2c(%rax)
  6616e0:	0f 97 40 30          	seta   0x30(%rax)
  6616e4:	88 48 31             	mov    %cl,0x31(%rax)
  6616e7:	48 83 c4 48          	add    $0x48,%rsp
  6616eb:	5b                   	pop    %rbx
  6616ec:	41 5c                	pop    %r12
  6616ee:	41 5d                	pop    %r13
  6616f0:	41 5e                	pop    %r14
  6616f2:	41 5f                	pop    %r15
  6616f4:	5d                   	pop    %rbp
  6616f5:	c3                   	ret
  6616f6:	48 8d 15 fb af 11 00 	lea    0x11affb(%rip),%rdx        # 77c6f8 <anon.0ce93d74e9d39703631c89632b12715b.3.llvm.7854699070981760621+0x18>
  6616fd:	48 89 df             	mov    %rbx,%rdi
  661700:	48 89 c6             	mov    %rax,%rsi
  661703:	ff 15 b7 5d 12 00    	call   *0x125db7(%rip)        # 7874c0 <_DYNAMIC+0x3a0>
