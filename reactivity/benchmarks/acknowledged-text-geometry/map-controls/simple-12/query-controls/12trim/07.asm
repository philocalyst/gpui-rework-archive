
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000679970 <<gpui_canvas::text::TextLayout>::position_at>:
  679970:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  679974:	b2 02                	mov    $0x2,%dl
  679976:	48 85 c9             	test   %rcx,%rcx
  679979:	0f 84 98 00 00 00    	je     679a17 <<gpui_canvas::text::TextLayout>::position_at+0xa7>
  67997f:	66 0f 7e c0          	movd   %xmm0,%eax
  679983:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  679988:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  67998d:	0f 9d c0             	setge  %al
  679990:	66 0f 7e ce          	movd   %xmm1,%esi
  679994:	81 e6 ff ff ff 7f    	and    $0x7fffffff,%esi
  67999a:	81 fe 00 00 80 7f    	cmp    $0x7f800000,%esi
  6799a0:	40 0f 9d c6          	setge  %sil
  6799a4:	40 08 c6             	or     %al,%sil
  6799a7:	75 6d                	jne    679a16 <<gpui_canvas::text::TextLayout>::position_at+0xa6>
  6799a9:	50                   	push   %rax
  6799aa:	48 8d 79 10          	lea    0x10(%rcx),%rdi
  6799ae:	48 8b 71 38          	mov    0x38(%rcx),%rsi
  6799b2:	48 85 f6             	test   %rsi,%rsi
  6799b5:	74 56                	je     679a0d <<gpui_canvas::text::TextLayout>::position_at+0x9d>
  6799b7:	48 8b 41 30          	mov    0x30(%rcx),%rax
  6799bb:	31 c9                	xor    %ecx,%ecx
  6799bd:	48 83 fe 01          	cmp    $0x1,%rsi
  6799c1:	74 30                	je     6799f3 <<gpui_canvas::text::TextLayout>::position_at+0x83>
  6799c3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6799ca:	84 00 00 00 00 00 
  6799d0:	48 89 ca             	mov    %rcx,%rdx
  6799d3:	49 89 f0             	mov    %rsi,%r8
  6799d6:	49 d1 e8             	shr    $1,%r8
  6799d9:	4c 01 c1             	add    %r8,%rcx
  6799dc:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
  6799e0:	42 0f 2e 4c c8 08    	ucomiss 0x8(%rax,%r9,8),%xmm1
  6799e6:	48 0f 42 ca          	cmovb  %rdx,%rcx
  6799ea:	4c 29 c6             	sub    %r8,%rsi
  6799ed:	48 83 fe 01          	cmp    $0x1,%rsi
  6799f1:	77 dd                	ja     6799d0 <<gpui_canvas::text::TextLayout>::position_at+0x60>
  6799f3:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  6799f7:	31 f6                	xor    %esi,%esi
  6799f9:	0f 2e 4c d0 08       	ucomiss 0x8(%rax,%rdx,8),%xmm1
  6799fe:	40 0f 93 c6          	setae  %sil
  679a02:	48 01 ce             	add    %rcx,%rsi
  679a05:	48 83 fe 01          	cmp    $0x1,%rsi
  679a09:	48 83 d6 ff          	adc    $0xffffffffffffffff,%rsi
  679a0d:	e8 2e 82 fe ff       	call   661c40 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  679a12:	48 83 c4 08          	add    $0x8,%rsp
  679a16:	c3                   	ret
  679a17:	c3                   	ret
