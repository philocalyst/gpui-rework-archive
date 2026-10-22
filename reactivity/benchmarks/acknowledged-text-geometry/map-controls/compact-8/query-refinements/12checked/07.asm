
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006797e0 <<gpui_canvas::text::TextLayout>::position_at>:
  6797e0:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  6797e4:	b2 02                	mov    $0x2,%dl
  6797e6:	48 85 c9             	test   %rcx,%rcx
  6797e9:	0f 84 98 00 00 00    	je     679887 <<gpui_canvas::text::TextLayout>::position_at+0xa7>
  6797ef:	66 0f 7e c0          	movd   %xmm0,%eax
  6797f3:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  6797f8:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  6797fd:	0f 9d c0             	setge  %al
  679800:	66 0f 7e ce          	movd   %xmm1,%esi
  679804:	81 e6 ff ff ff 7f    	and    $0x7fffffff,%esi
  67980a:	81 fe 00 00 80 7f    	cmp    $0x7f800000,%esi
  679810:	40 0f 9d c6          	setge  %sil
  679814:	40 08 c6             	or     %al,%sil
  679817:	75 6d                	jne    679886 <<gpui_canvas::text::TextLayout>::position_at+0xa6>
  679819:	50                   	push   %rax
  67981a:	48 8d 79 10          	lea    0x10(%rcx),%rdi
  67981e:	48 8b 71 38          	mov    0x38(%rcx),%rsi
  679822:	48 85 f6             	test   %rsi,%rsi
  679825:	74 56                	je     67987d <<gpui_canvas::text::TextLayout>::position_at+0x9d>
  679827:	48 8b 41 30          	mov    0x30(%rcx),%rax
  67982b:	31 c9                	xor    %ecx,%ecx
  67982d:	48 83 fe 01          	cmp    $0x1,%rsi
  679831:	74 30                	je     679863 <<gpui_canvas::text::TextLayout>::position_at+0x83>
  679833:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67983a:	84 00 00 00 00 00 
  679840:	48 89 ca             	mov    %rcx,%rdx
  679843:	49 89 f0             	mov    %rsi,%r8
  679846:	49 d1 e8             	shr    $1,%r8
  679849:	4c 01 c1             	add    %r8,%rcx
  67984c:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
  679850:	42 0f 2e 4c c8 08    	ucomiss 0x8(%rax,%r9,8),%xmm1
  679856:	48 0f 42 ca          	cmovb  %rdx,%rcx
  67985a:	4c 29 c6             	sub    %r8,%rsi
  67985d:	48 83 fe 01          	cmp    $0x1,%rsi
  679861:	77 dd                	ja     679840 <<gpui_canvas::text::TextLayout>::position_at+0x60>
  679863:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  679867:	31 f6                	xor    %esi,%esi
  679869:	0f 2e 4c d0 08       	ucomiss 0x8(%rax,%rdx,8),%xmm1
  67986e:	40 0f 93 c6          	setae  %sil
  679872:	48 01 ce             	add    %rcx,%rsi
  679875:	48 83 fe 01          	cmp    $0x1,%rsi
  679879:	48 83 d6 ff          	adc    $0xffffffffffffffff,%rsi
  67987d:	e8 0e 84 fe ff       	call   661c90 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  679882:	48 83 c4 08          	add    $0x8,%rsp
  679886:	c3                   	ret
  679887:	c3                   	ret
