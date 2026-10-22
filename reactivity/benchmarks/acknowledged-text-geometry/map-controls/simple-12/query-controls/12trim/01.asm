
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006614b0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>:
  6614b0:	55                   	push   %rbp
  6614b1:	41 57                	push   %r15
  6614b3:	41 56                	push   %r14
  6614b5:	41 55                	push   %r13
  6614b7:	41 54                	push   %r12
  6614b9:	53                   	push   %rbx
  6614ba:	48 83 ec 48          	sub    $0x48,%rsp
  6614be:	48 8b 0a             	mov    (%rdx),%rcx
  6614c1:	4c 8b 42 08          	mov    0x8(%rdx),%r8
  6614c5:	4c 8b 6a 10          	mov    0x10(%rdx),%r13
  6614c9:	48 8b 42 18          	mov    0x18(%rdx),%rax
  6614cd:	48 83 c1 f4          	add    $0xfffffffffffffff4,%rcx
  6614d1:	49 c1 e0 02          	shl    $0x2,%r8
  6614d5:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
  6614d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6614e0:	48 85 d2             	test   %rdx,%rdx
  6614e3:	0f 84 0a 01 00 00    	je     6615f3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x143>
  6614e9:	4c 8d 71 0c          	lea    0xc(%rcx),%r14
  6614ed:	48 83 c2 f4          	add    $0xfffffffffffffff4,%rdx
  6614f1:	f6 41 14 02          	testb  $0x2,0x14(%rcx)
  6614f5:	4c 89 f1             	mov    %r14,%rcx
  6614f8:	74 e6                	je     6614e0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x30>
  6614fa:	48 c1 e0 02          	shl    $0x2,%rax
  6614fe:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  661502:	31 c9                	xor    %ecx,%ecx
  661504:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  66150b:	00 00 00 00 00 
  661510:	48 39 c8             	cmp    %rcx,%rax
  661513:	0f 84 da 00 00 00    	je     6615f3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x143>
  661519:	4c 8d 61 0c          	lea    0xc(%rcx),%r12
  66151d:	41 f6 44 0d 08 01    	testb  $0x1,0x8(%r13,%rcx,1)
  661523:	4c 89 e1             	mov    %r12,%rcx
  661526:	74 e8                	je     661510 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x60>
  661528:	41 8b 2e             	mov    (%r14),%ebp
  66152b:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  66152f:	48 8b 46 28          	mov    0x28(%rsi),%rax
  661533:	48 89 c3             	mov    %rax,%rbx
  661536:	48 85 c0             	test   %rax,%rax
  661539:	74 4e                	je     661589 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xd9>
  66153b:	31 d2                	xor    %edx,%edx
  66153d:	48 83 f8 01          	cmp    $0x1,%rax
  661541:	74 2e                	je     661571 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xc1>
  661543:	49 89 c0             	mov    %rax,%r8
  661546:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  66154d:	00 00 00 
  661550:	49 89 d1             	mov    %rdx,%r9
  661553:	4d 89 c2             	mov    %r8,%r10
  661556:	49 d1 ea             	shr    $1,%r10
  661559:	4c 01 d2             	add    %r10,%rdx
  66155c:	4c 8d 1c 52          	lea    (%rdx,%rdx,2),%r11
  661560:	42 39 2c d9          	cmp    %ebp,(%rcx,%r11,8)
  661564:	49 0f 47 d1          	cmova  %r9,%rdx
  661568:	4d 29 d0             	sub    %r10,%r8
  66156b:	49 83 f8 01          	cmp    $0x1,%r8
  66156f:	77 df                	ja     661550 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xa0>
  661571:	4c 8d 04 52          	lea    (%rdx,%rdx,2),%r8
  661575:	31 db                	xor    %ebx,%ebx
  661577:	42 39 2c c1          	cmp    %ebp,(%rcx,%r8,8)
  66157b:	0f 96 c3             	setbe  %bl
  66157e:	48 01 d3             	add    %rdx,%rbx
  661581:	48 83 fb 01          	cmp    $0x1,%rbx
  661585:	48 83 d3 ff          	adc    $0xffffffffffffffff,%rbx
  661589:	89 6c 24 0c          	mov    %ebp,0xc(%rsp)
  66158d:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  661592:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  661597:	48 39 c3             	cmp    %rax,%rbx
  66159a:	0f 83 a6 01 00 00    	jae    661746 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x296>
  6615a0:	47 8b 7c 25 f4       	mov    -0xc(%r13,%r12,1),%r15d
  6615a5:	48 8d 04 5b          	lea    (%rbx,%rbx,2),%rax
  6615a9:	8b 6c c1 04          	mov    0x4(%rcx,%rax,8),%ebp
  6615ad:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  6615b2:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  6615b7:	4c 89 f2             	mov    %r14,%rdx
  6615ba:	ff 15 88 60 12 00    	call   *0x126088(%rip)        # 787648 <_DYNAMIC+0x398>
  6615c0:	45 89 fb             	mov    %r15d,%r11d
  6615c3:	f3 41 0f 10 46 04    	movss  0x4(%r14),%xmm0
  6615c9:	f3 43 0f 10 4c 25 f8 	movss  -0x8(%r13,%r12,1),%xmm1
  6615d0:	41 89 ec             	mov    %ebp,%r12d
  6615d3:	41 39 ef             	cmp    %ebp,%r15d
  6615d6:	77 24                	ja     6615fc <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x14c>
  6615d8:	0f 2e c1             	ucomiss %xmm1,%xmm0
  6615db:	75 02                	jne    6615df <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x12f>
  6615dd:	7b 1d                	jnp    6615fc <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x14c>
  6615df:	0f 2e c8             	ucomiss %xmm0,%xmm1
  6615e2:	0f 96 c1             	setbe  %cl
  6615e5:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6615ea:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  6615ee:	e9 bb 00 00 00       	jmp    6616ae <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1fe>
  6615f3:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  6615f7:	e9 3b 01 00 00       	jmp    661737 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x287>
  6615fc:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  661601:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  661605:	49 8b 57 10          	mov    0x10(%r15),%rdx
  661609:	48 89 d6             	mov    %rdx,%rsi
  66160c:	48 85 d2             	test   %rdx,%rdx
  66160f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  661614:	0f 28 6c 24 30       	movaps 0x30(%rsp),%xmm5
  661619:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  66161d:	74 43                	je     661662 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1b2>
  66161f:	31 f6                	xor    %esi,%esi
  661621:	48 83 fa 01          	cmp    $0x1,%rdx
  661625:	74 2c                	je     661653 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1a3>
  661627:	48 89 d7             	mov    %rdx,%rdi
  66162a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  661630:	49 89 f8             	mov    %rdi,%r8
  661633:	49 d1 e8             	shr    $1,%r8
  661636:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  66163a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  66163e:	46 8b 54 d1 10       	mov    0x10(%rcx,%r10,8),%r10d
  661643:	4c 39 d3             	cmp    %r10,%rbx
  661646:	49 0f 47 f1          	cmova  %r9,%rsi
  66164a:	4c 29 c7             	sub    %r8,%rdi
  66164d:	48 83 ff 01          	cmp    $0x1,%rdi
  661651:	77 dd                	ja     661630 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x180>
  661653:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  661657:	8b 7c f9 10          	mov    0x10(%rcx,%rdi,8),%edi
  66165b:	48 39 df             	cmp    %rbx,%rdi
  66165e:	48 83 d6 00          	adc    $0x0,%rsi
  661662:	48 c1 e6 03          	shl    $0x3,%rsi
  661666:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  66166a:	4c 8d 04 31          	lea    (%rcx,%rsi,1),%r8
  66166e:	41 8b 3e             	mov    (%r14),%edi
  661671:	48 c1 e2 03          	shl    $0x3,%rdx
  661675:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  661679:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  661680:	48 39 f2             	cmp    %rsi,%rdx
  661683:	74 5a                	je     6616df <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x22f>
  661685:	4d 89 c1             	mov    %r8,%r9
  661688:	45 8b 40 10          	mov    0x10(%r8),%r8d
  66168c:	4c 39 c3             	cmp    %r8,%rbx
  66168f:	75 4e                	jne    6616df <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x22f>
  661691:	4d 8d 41 18          	lea    0x18(%r9),%r8
  661695:	48 83 c6 18          	add    $0x18,%rsi
  661699:	41 39 39             	cmp    %edi,(%r9)
  66169c:	77 e2                	ja     661680 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1d0>
  66169e:	41 3b 79 04          	cmp    0x4(%r9),%edi
  6616a2:	77 dc                	ja     661680 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1d0>
  6616a4:	0f b6 4c 31 fd       	movzbl -0x3(%rcx,%rsi,1),%ecx
  6616a9:	45 39 e3             	cmp    %r12d,%r11d
  6616ac:	77 38                	ja     6616e6 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x236>
  6616ae:	0f 28 d8             	movaps %xmm0,%xmm3
  6616b1:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  6616b5:	0f 28 d3             	movaps %xmm3,%xmm2
  6616b8:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  6616bd:	0f 28 e2             	movaps %xmm2,%xmm4
  6616c0:	0f 55 e3             	andnps %xmm3,%xmm4
  6616c3:	0f 54 d0             	andps  %xmm0,%xmm2
  6616c6:	0f 56 d4             	orps   %xmm4,%xmm2
  6616c9:	f3 0f 10 5c 24 24    	movss  0x24(%rsp),%xmm3
  6616cf:	0f 28 e9             	movaps %xmm1,%xmm5
  6616d2:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  6616d6:	0f 54 2d b3 3a 9c ff 	andps  -0x63c54d(%rip),%xmm5        # 25190 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  6616dd:	eb 18                	jmp    6616f7 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x247>
  6616df:	31 c9                	xor    %ecx,%ecx
  6616e1:	45 39 e3             	cmp    %r12d,%r11d
  6616e4:	76 c8                	jbe    6616ae <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1fe>
  6616e6:	0f 28 d0             	movaps %xmm0,%xmm2
  6616e9:	84 c9                	test   %cl,%cl
  6616eb:	74 04                	je     6616f1 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x241>
  6616ed:	f3 0f 5c d5          	subss  %xmm5,%xmm2
  6616f1:	f3 0f 10 5c 24 24    	movss  0x24(%rsp),%xmm3
  6616f7:	45 39 e3             	cmp    %r12d,%r11d
  6616fa:	f3 0f 10 64 24 2c    	movss  0x2c(%rsp),%xmm4
  661700:	89 28                	mov    %ebp,(%rax)
  661702:	c6 40 04 01          	movb   $0x1,0x4(%rax)
  661706:	44 89 58 08          	mov    %r11d,0x8(%rax)
  66170a:	c6 40 0c 00          	movb   $0x0,0xc(%rax)
  66170e:	f3 0f 11 50 10       	movss  %xmm2,0x10(%rax)
  661713:	f3 0f 11 58 14       	movss  %xmm3,0x14(%rax)
  661718:	f3 0f 11 68 18       	movss  %xmm5,0x18(%rax)
  66171d:	f3 0f 11 60 1c       	movss  %xmm4,0x1c(%rax)
  661722:	48 89 58 20          	mov    %rbx,0x20(%rax)
  661726:	f3 0f 11 40 28       	movss  %xmm0,0x28(%rax)
  66172b:	f3 0f 11 48 2c       	movss  %xmm1,0x2c(%rax)
  661730:	0f 97 40 30          	seta   0x30(%rax)
  661734:	88 48 31             	mov    %cl,0x31(%rax)
  661737:	48 83 c4 48          	add    $0x48,%rsp
  66173b:	5b                   	pop    %rbx
  66173c:	41 5c                	pop    %r12
  66173e:	41 5d                	pop    %r13
  661740:	41 5e                	pop    %r14
  661742:	41 5f                	pop    %r15
  661744:	5d                   	pop    %rbp
  661745:	c3                   	ret
  661746:	48 8d 15 3b b1 11 00 	lea    0x11b13b(%rip),%rdx        # 77c888 <anon.b75840af67eff6c7867889150027a6c7.3.llvm.2112026857664668335+0x18>
  66174d:	48 89 df             	mov    %rbx,%rdi
  661750:	48 89 c6             	mov    %rax,%rsi
  661753:	ff 15 f7 5e 12 00    	call   *0x125ef7(%rip)        # 787650 <_DYNAMIC+0x3a0>
