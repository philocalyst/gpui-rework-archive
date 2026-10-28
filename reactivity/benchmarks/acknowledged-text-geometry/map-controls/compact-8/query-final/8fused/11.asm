
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000665460 <<gpui_canvas::text::TextLayout>::position_at>:
  665460:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  665464:	b2 02                	mov    $0x2,%dl
  665466:	48 85 c9             	test   %rcx,%rcx
  665469:	0f 84 98 00 00 00    	je     665507 <<gpui_canvas::text::TextLayout>::position_at+0xa7>
  66546f:	66 0f 7e c0          	movd   %xmm0,%eax
  665473:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  665478:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  66547d:	0f 9d c0             	setge  %al
  665480:	66 0f 7e ce          	movd   %xmm1,%esi
  665484:	81 e6 ff ff ff 7f    	and    $0x7fffffff,%esi
  66548a:	81 fe 00 00 80 7f    	cmp    $0x7f800000,%esi
  665490:	40 0f 9d c6          	setge  %sil
  665494:	40 08 c6             	or     %al,%sil
  665497:	75 6d                	jne    665506 <<gpui_canvas::text::TextLayout>::position_at+0xa6>
  665499:	50                   	push   %rax
  66549a:	48 8d 79 10          	lea    0x10(%rcx),%rdi
  66549e:	48 8b 71 50          	mov    0x50(%rcx),%rsi
  6654a2:	48 85 f6             	test   %rsi,%rsi
  6654a5:	74 56                	je     6654fd <<gpui_canvas::text::TextLayout>::position_at+0x9d>
  6654a7:	48 8b 41 48          	mov    0x48(%rcx),%rax
  6654ab:	31 c9                	xor    %ecx,%ecx
  6654ad:	48 83 fe 01          	cmp    $0x1,%rsi
  6654b1:	74 30                	je     6654e3 <<gpui_canvas::text::TextLayout>::position_at+0x83>
  6654b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6654ba:	84 00 00 00 00 00 
  6654c0:	48 89 ca             	mov    %rcx,%rdx
  6654c3:	49 89 f0             	mov    %rsi,%r8
  6654c6:	49 d1 e8             	shr    $1,%r8
  6654c9:	4c 01 c1             	add    %r8,%rcx
  6654cc:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
  6654d0:	42 0f 2e 4c c8 08    	ucomiss 0x8(%rax,%r9,8),%xmm1
  6654d6:	48 0f 42 ca          	cmovb  %rdx,%rcx
  6654da:	4c 29 c6             	sub    %r8,%rsi
  6654dd:	48 83 fe 01          	cmp    $0x1,%rsi
  6654e1:	77 dd                	ja     6654c0 <<gpui_canvas::text::TextLayout>::position_at+0x60>
  6654e3:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  6654e7:	31 f6                	xor    %esi,%esi
  6654e9:	0f 2e 4c d0 08       	ucomiss 0x8(%rax,%rdx,8),%xmm1
  6654ee:	40 0f 93 c6          	setae  %sil
  6654f2:	48 01 ce             	add    %rcx,%rsi
  6654f5:	48 83 fe 01          	cmp    $0x1,%rsi
  6654f9:	48 83 d6 ff          	adc    $0xffffffffffffffff,%rsi
  6654fd:	e8 ae 7f 01 00       	call   67d4b0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  665502:	48 83 c4 08          	add    $0x8,%rsp
  665506:	c3                   	ret
  665507:	c3                   	ret
