
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006624d0 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds>:
  6624d0:	53                   	push   %rbx
  6624d1:	f6 42 08 01          	testb  $0x1,0x8(%rdx)
  6624d5:	44 8b 02             	mov    (%rdx),%r8d
  6624d8:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  6624dc:	48 8b 76 28          	mov    0x28(%rsi),%rsi
  6624e0:	74 58                	je     66253a <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x6a>
  6624e2:	45 85 c0             	test   %r8d,%r8d
  6624e5:	74 53                	je     66253a <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x6a>
  6624e7:	48 89 f0             	mov    %rsi,%rax
  6624ea:	48 85 f6             	test   %rsi,%rsi
  6624ed:	74 3e                	je     66252d <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x5d>
  6624ef:	31 c0                	xor    %eax,%eax
  6624f1:	48 83 fe 01          	cmp    $0x1,%rsi
  6624f5:	74 29                	je     662520 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x50>
  6624f7:	49 89 f1             	mov    %rsi,%r9
  6624fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  662500:	4d 89 ca             	mov    %r9,%r10
  662503:	49 d1 ea             	shr    $1,%r10
  662506:	4d 8d 1c 02          	lea    (%r10,%rax,1),%r11
  66250a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  66250e:	44 39 44 d9 04       	cmp    %r8d,0x4(%rcx,%rbx,8)
  662513:	49 0f 42 c3          	cmovb  %r11,%rax
  662517:	4d 29 d1             	sub    %r10,%r9
  66251a:	49 83 f9 01          	cmp    $0x1,%r9
  66251e:	77 e0                	ja     662500 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x30>
  662520:	4c 8d 0c 40          	lea    (%rax,%rax,2),%r9
  662524:	46 39 44 c9 04       	cmp    %r8d,0x4(%rcx,%r9,8)
  662529:	48 83 d0 00          	adc    $0x0,%rax
  66252d:	4c 8d 46 ff          	lea    -0x1(%rsi),%r8
  662531:	49 39 c0             	cmp    %rax,%r8
  662534:	49 0f 42 c0          	cmovb  %r8,%rax
  662538:	eb 4f                	jmp    662589 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xb9>
  66253a:	48 89 f0             	mov    %rsi,%rax
  66253d:	48 85 f6             	test   %rsi,%rsi
  662540:	74 47                	je     662589 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xb9>
  662542:	45 31 c9             	xor    %r9d,%r9d
  662545:	48 83 fe 01          	cmp    $0x1,%rsi
  662549:	74 26                	je     662571 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xa1>
  66254b:	48 89 f0             	mov    %rsi,%rax
  66254e:	66 90                	xchg   %ax,%ax
  662550:	4d 89 ca             	mov    %r9,%r10
  662553:	49 89 c3             	mov    %rax,%r11
  662556:	49 d1 eb             	shr    $1,%r11
  662559:	4d 01 d9             	add    %r11,%r9
  66255c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  662560:	44 39 04 d9          	cmp    %r8d,(%rcx,%rbx,8)
  662564:	4d 0f 47 ca          	cmova  %r10,%r9
  662568:	4c 29 d8             	sub    %r11,%rax
  66256b:	48 83 f8 01          	cmp    $0x1,%rax
  66256f:	77 df                	ja     662550 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x80>
  662571:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  662575:	31 c0                	xor    %eax,%eax
  662577:	46 39 04 d1          	cmp    %r8d,(%rcx,%r10,8)
  66257b:	0f 96 c0             	setbe  %al
  66257e:	4c 01 c8             	add    %r9,%rax
  662581:	48 83 f8 01          	cmp    $0x1,%rax
  662585:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  662589:	48 39 f0             	cmp    %rsi,%rax
  66258c:	73 3d                	jae    6625cb <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xfb>
  66258e:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  662592:	f3 0f 10 42 04       	movss  0x4(%rdx),%xmm0
  662597:	f3 0f 10 0d dd ae 9b 	movss  -0x645123(%rip),%xmm1        # 1d47c <GCC_except_table0+0x48>
  66259e:	ff 
  66259f:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  6625a3:	f3 0f 5c c8          	subss  %xmm0,%xmm1
  6625a7:	f3 0f 10 54 c1 08    	movss  0x8(%rcx,%rax,8),%xmm2
  6625ad:	f3 0f 10 5c c1 0c    	movss  0xc(%rcx,%rax,8),%xmm3
  6625b3:	f3 0f 11 07          	movss  %xmm0,(%rdi)
  6625b7:	f3 0f 11 57 04       	movss  %xmm2,0x4(%rdi)
  6625bc:	f3 0f 11 4f 08       	movss  %xmm1,0x8(%rdi)
  6625c1:	f3 0f 11 5f 0c       	movss  %xmm3,0xc(%rdi)
  6625c6:	48 89 f8             	mov    %rdi,%rax
  6625c9:	5b                   	pop    %rbx
  6625ca:	c3                   	ret
  6625cb:	48 8d 15 ce a2 11 00 	lea    0x11a2ce(%rip),%rdx        # 77c8a0 <anon.b75840af67eff6c7867889150027a6c7.3.llvm.2112026857664668335+0x30>
  6625d2:	48 89 c7             	mov    %rax,%rdi
  6625d5:	ff 15 75 50 12 00    	call   *0x125075(%rip)        # 787650 <_DYNAMIC+0x3a0>
