
/tmp/gpui-text-map-query-refinements/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000664350 <<gpui_canvas::text::TextLayout>::position_at>:
  664350:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  664354:	b2 02                	mov    $0x2,%dl
  664356:	48 85 c9             	test   %rcx,%rcx
  664359:	0f 84 98 00 00 00    	je     6643f7 <<gpui_canvas::text::TextLayout>::position_at+0xa7>
  66435f:	66 0f 7e c0          	movd   %xmm0,%eax
  664363:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  664368:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  66436d:	0f 9d c0             	setge  %al
  664370:	66 0f 7e ce          	movd   %xmm1,%esi
  664374:	81 e6 ff ff ff 7f    	and    $0x7fffffff,%esi
  66437a:	81 fe 00 00 80 7f    	cmp    $0x7f800000,%esi
  664380:	40 0f 9d c6          	setge  %sil
  664384:	40 08 c6             	or     %al,%sil
  664387:	75 6d                	jne    6643f6 <<gpui_canvas::text::TextLayout>::position_at+0xa6>
  664389:	50                   	push   %rax
  66438a:	48 8d 79 10          	lea    0x10(%rcx),%rdi
  66438e:	48 8b 71 38          	mov    0x38(%rcx),%rsi
  664392:	48 85 f6             	test   %rsi,%rsi
  664395:	74 56                	je     6643ed <<gpui_canvas::text::TextLayout>::position_at+0x9d>
  664397:	48 8b 41 30          	mov    0x30(%rcx),%rax
  66439b:	31 c9                	xor    %ecx,%ecx
  66439d:	48 83 fe 01          	cmp    $0x1,%rsi
  6643a1:	74 30                	je     6643d3 <<gpui_canvas::text::TextLayout>::position_at+0x83>
  6643a3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6643aa:	84 00 00 00 00 00 
  6643b0:	48 89 ca             	mov    %rcx,%rdx
  6643b3:	49 89 f0             	mov    %rsi,%r8
  6643b6:	49 d1 e8             	shr    $1,%r8
  6643b9:	4c 01 c1             	add    %r8,%rcx
  6643bc:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
  6643c0:	42 0f 2e 4c c8 08    	ucomiss 0x8(%rax,%r9,8),%xmm1
  6643c6:	48 0f 42 ca          	cmovb  %rdx,%rcx
  6643ca:	4c 29 c6             	sub    %r8,%rsi
  6643cd:	48 83 fe 01          	cmp    $0x1,%rsi
  6643d1:	77 dd                	ja     6643b0 <<gpui_canvas::text::TextLayout>::position_at+0x60>
  6643d3:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  6643d7:	31 f6                	xor    %esi,%esi
  6643d9:	0f 2e 4c d0 08       	ucomiss 0x8(%rax,%rdx,8),%xmm1
  6643de:	40 0f 93 c6          	setae  %sil
  6643e2:	48 01 ce             	add    %rcx,%rsi
  6643e5:	48 83 fe 01          	cmp    $0x1,%rsi
  6643e9:	48 83 d6 ff          	adc    $0xffffffffffffffff,%rsi
  6643ed:	e8 be 09 02 00       	call   684db0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  6643f2:	48 83 c4 08          	add    $0x8,%rsp
  6643f6:	c3                   	ret
  6643f7:	c3                   	ret
