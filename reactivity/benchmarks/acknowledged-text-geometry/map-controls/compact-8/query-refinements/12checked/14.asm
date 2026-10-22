
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006624a0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection>:
  6624a0:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  6624a5:	0f 84 14 01 00 00    	je     6625bf <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11f>
  6624ab:	53                   	push   %rbx
  6624ac:	44 8b 06             	mov    (%rsi),%r8d
  6624af:	44 0f b6 4e 04       	movzbl 0x4(%rsi),%r9d
  6624b4:	48 8b 47 38          	mov    0x38(%rdi),%rax
  6624b8:	48 8b 4f 40          	mov    0x40(%rdi),%rcx
  6624bc:	48 89 ca             	mov    %rcx,%rdx
  6624bf:	48 85 c9             	test   %rcx,%rcx
  6624c2:	74 37                	je     6624fb <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x5b>
  6624c4:	31 d2                	xor    %edx,%edx
  6624c6:	48 83 f9 01          	cmp    $0x1,%rcx
  6624ca:	74 23                	je     6624ef <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x4f>
  6624cc:	48 89 cf             	mov    %rcx,%rdi
  6624cf:	90                   	nop
  6624d0:	49 89 fa             	mov    %rdi,%r10
  6624d3:	49 d1 ea             	shr    $1,%r10
  6624d6:	4d 8d 1c 12          	lea    (%r10,%rdx,1),%r11
  6624da:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  6624de:	44 39 04 98          	cmp    %r8d,(%rax,%rbx,4)
  6624e2:	49 0f 42 d3          	cmovb  %r11,%rdx
  6624e6:	4c 29 d7             	sub    %r10,%rdi
  6624e9:	48 83 ff 01          	cmp    $0x1,%rdi
  6624ed:	77 e1                	ja     6624d0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x30>
  6624ef:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  6624f3:	44 39 04 b8          	cmp    %r8d,(%rax,%rdi,4)
  6624f7:	48 83 d2 00          	adc    $0x0,%rdx
  6624fb:	41 fe c1             	inc    %r9b
  6624fe:	48 c1 e2 02          	shl    $0x2,%rdx
  662502:	4c 8d 1c 52          	lea    (%rdx,%rdx,2),%r11
  662506:	4a 8d 3c 18          	lea    (%rax,%r11,1),%rdi
  66250a:	48 8d 14 8d 00 00 00 	lea    0x0(,%rcx,4),%rdx
  662511:	00 
  662512:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  662516:	49 89 d2             	mov    %rdx,%r10
  662519:	4d 29 da             	sub    %r11,%r10
  66251c:	0f 1f 40 00          	nopl   0x0(%rax)
  662520:	4d 85 d2             	test   %r10,%r10
  662523:	0f 84 92 00 00 00    	je     6625bb <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11b>
  662529:	44 39 07             	cmp    %r8d,(%rdi)
  66252c:	0f 85 89 00 00 00    	jne    6625bb <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11b>
  662532:	49 83 c2 f4          	add    $0xfffffffffffffff4,%r10
  662536:	44 84 4f 08          	test   %r9b,0x8(%rdi)
  66253a:	48 8d 7f 0c          	lea    0xc(%rdi),%rdi
  66253e:	74 e0                	je     662520 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x80>
  662540:	8b 7e 08             	mov    0x8(%rsi),%edi
  662543:	0f b6 76 0c          	movzbl 0xc(%rsi),%esi
  662547:	48 85 c9             	test   %rcx,%rcx
  66254a:	74 41                	je     66258d <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xed>
  66254c:	45 31 c0             	xor    %r8d,%r8d
  66254f:	48 83 f9 01          	cmp    $0x1,%rcx
  662553:	74 2a                	je     66257f <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xdf>
  662555:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66255c:	00 00 00 00 
  662560:	49 89 c9             	mov    %rcx,%r9
  662563:	49 d1 e9             	shr    $1,%r9
  662566:	4f 8d 14 01          	lea    (%r9,%r8,1),%r10
  66256a:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  66256e:	42 39 3c 98          	cmp    %edi,(%rax,%r11,4)
  662572:	4d 0f 42 c2          	cmovb  %r10,%r8
  662576:	4c 29 c9             	sub    %r9,%rcx
  662579:	48 83 f9 01          	cmp    $0x1,%rcx
  66257d:	77 e1                	ja     662560 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xc0>
  66257f:	4b 8d 0c 40          	lea    (%r8,%r8,2),%rcx
  662583:	39 3c 88             	cmp    %edi,(%rax,%rcx,4)
  662586:	49 83 d0 00          	adc    $0x0,%r8
  66258a:	4c 89 c1             	mov    %r8,%rcx
  66258d:	40 fe c6             	inc    %sil
  662590:	48 c1 e1 02          	shl    $0x2,%rcx
  662594:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  662598:	48 01 c8             	add    %rcx,%rax
  66259b:	48 29 ca             	sub    %rcx,%rdx
  66259e:	66 90                	xchg   %ax,%ax
  6625a0:	48 85 d2             	test   %rdx,%rdx
  6625a3:	74 16                	je     6625bb <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11b>
  6625a5:	39 38                	cmp    %edi,(%rax)
  6625a7:	75 12                	jne    6625bb <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11b>
  6625a9:	48 83 c2 f4          	add    $0xfffffffffffffff4,%rdx
  6625ad:	40 84 70 08          	test   %sil,0x8(%rax)
  6625b1:	48 8d 40 0c          	lea    0xc(%rax),%rax
  6625b5:	74 e9                	je     6625a0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x100>
  6625b7:	b0 01                	mov    $0x1,%al
  6625b9:	5b                   	pop    %rbx
  6625ba:	c3                   	ret
  6625bb:	31 c0                	xor    %eax,%eax
  6625bd:	5b                   	pop    %rbx
  6625be:	c3                   	ret
  6625bf:	31 c0                	xor    %eax,%eax
  6625c1:	c3                   	ret
