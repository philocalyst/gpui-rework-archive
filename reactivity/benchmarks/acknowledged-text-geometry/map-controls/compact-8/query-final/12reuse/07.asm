
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006643f0 <<gpui_canvas::text::TextLayout>::position_at>:
  6643f0:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  6643f4:	b2 02                	mov    $0x2,%dl
  6643f6:	48 85 c9             	test   %rcx,%rcx
  6643f9:	0f 84 98 00 00 00    	je     664497 <<gpui_canvas::text::TextLayout>::position_at+0xa7>
  6643ff:	66 0f 7e c0          	movd   %xmm0,%eax
  664403:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  664408:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  66440d:	0f 9d c0             	setge  %al
  664410:	66 0f 7e ce          	movd   %xmm1,%esi
  664414:	81 e6 ff ff ff 7f    	and    $0x7fffffff,%esi
  66441a:	81 fe 00 00 80 7f    	cmp    $0x7f800000,%esi
  664420:	40 0f 9d c6          	setge  %sil
  664424:	40 08 c6             	or     %al,%sil
  664427:	75 6d                	jne    664496 <<gpui_canvas::text::TextLayout>::position_at+0xa6>
  664429:	50                   	push   %rax
  66442a:	48 8d 79 10          	lea    0x10(%rcx),%rdi
  66442e:	48 8b 71 38          	mov    0x38(%rcx),%rsi
  664432:	48 85 f6             	test   %rsi,%rsi
  664435:	74 56                	je     66448d <<gpui_canvas::text::TextLayout>::position_at+0x9d>
  664437:	48 8b 41 30          	mov    0x30(%rcx),%rax
  66443b:	31 c9                	xor    %ecx,%ecx
  66443d:	48 83 fe 01          	cmp    $0x1,%rsi
  664441:	74 30                	je     664473 <<gpui_canvas::text::TextLayout>::position_at+0x83>
  664443:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66444a:	84 00 00 00 00 00 
  664450:	48 89 ca             	mov    %rcx,%rdx
  664453:	49 89 f0             	mov    %rsi,%r8
  664456:	49 d1 e8             	shr    $1,%r8
  664459:	4c 01 c1             	add    %r8,%rcx
  66445c:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
  664460:	42 0f 2e 4c c8 08    	ucomiss 0x8(%rax,%r9,8),%xmm1
  664466:	48 0f 42 ca          	cmovb  %rdx,%rcx
  66446a:	4c 29 c6             	sub    %r8,%rsi
  66446d:	48 83 fe 01          	cmp    $0x1,%rsi
  664471:	77 dd                	ja     664450 <<gpui_canvas::text::TextLayout>::position_at+0x60>
  664473:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  664477:	31 f6                	xor    %esi,%esi
  664479:	0f 2e 4c d0 08       	ucomiss 0x8(%rax,%rdx,8),%xmm1
  66447e:	40 0f 93 c6          	setae  %sil
  664482:	48 01 ce             	add    %rcx,%rsi
  664485:	48 83 fe 01          	cmp    $0x1,%rsi
  664489:	48 83 d6 ff          	adc    $0xffffffffffffffff,%rsi
  66448d:	e8 ee c3 01 00       	call   680880 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  664492:	48 83 c4 08          	add    $0x8,%rsp
  664496:	c3                   	ret
  664497:	c3                   	ret
