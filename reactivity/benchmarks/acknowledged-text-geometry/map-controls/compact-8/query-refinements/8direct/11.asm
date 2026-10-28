
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000665c90 <<gpui_canvas::text::TextLayout>::position_at>:
  665c90:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  665c94:	b2 02                	mov    $0x2,%dl
  665c96:	48 85 c9             	test   %rcx,%rcx
  665c99:	0f 84 98 00 00 00    	je     665d37 <<gpui_canvas::text::TextLayout>::position_at+0xa7>
  665c9f:	66 0f 7e c0          	movd   %xmm0,%eax
  665ca3:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  665ca8:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  665cad:	0f 9d c0             	setge  %al
  665cb0:	66 0f 7e ce          	movd   %xmm1,%esi
  665cb4:	81 e6 ff ff ff 7f    	and    $0x7fffffff,%esi
  665cba:	81 fe 00 00 80 7f    	cmp    $0x7f800000,%esi
  665cc0:	40 0f 9d c6          	setge  %sil
  665cc4:	40 08 c6             	or     %al,%sil
  665cc7:	75 6d                	jne    665d36 <<gpui_canvas::text::TextLayout>::position_at+0xa6>
  665cc9:	50                   	push   %rax
  665cca:	48 8d 79 10          	lea    0x10(%rcx),%rdi
  665cce:	48 8b 71 50          	mov    0x50(%rcx),%rsi
  665cd2:	48 85 f6             	test   %rsi,%rsi
  665cd5:	74 56                	je     665d2d <<gpui_canvas::text::TextLayout>::position_at+0x9d>
  665cd7:	48 8b 41 48          	mov    0x48(%rcx),%rax
  665cdb:	31 c9                	xor    %ecx,%ecx
  665cdd:	48 83 fe 01          	cmp    $0x1,%rsi
  665ce1:	74 30                	je     665d13 <<gpui_canvas::text::TextLayout>::position_at+0x83>
  665ce3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  665cea:	84 00 00 00 00 00 
  665cf0:	48 89 ca             	mov    %rcx,%rdx
  665cf3:	49 89 f0             	mov    %rsi,%r8
  665cf6:	49 d1 e8             	shr    $1,%r8
  665cf9:	4c 01 c1             	add    %r8,%rcx
  665cfc:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
  665d00:	42 0f 2e 4c c8 08    	ucomiss 0x8(%rax,%r9,8),%xmm1
  665d06:	48 0f 42 ca          	cmovb  %rdx,%rcx
  665d0a:	4c 29 c6             	sub    %r8,%rsi
  665d0d:	48 83 fe 01          	cmp    $0x1,%rsi
  665d11:	77 dd                	ja     665cf0 <<gpui_canvas::text::TextLayout>::position_at+0x60>
  665d13:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  665d17:	31 f6                	xor    %esi,%esi
  665d19:	0f 2e 4c d0 08       	ucomiss 0x8(%rax,%rdx,8),%xmm1
  665d1e:	40 0f 93 c6          	setae  %sil
  665d22:	48 01 ce             	add    %rcx,%rsi
  665d25:	48 83 fe 01          	cmp    $0x1,%rsi
  665d29:	48 83 d6 ff          	adc    $0xffffffffffffffff,%rsi
  665d2d:	e8 3e db 01 00       	call   683870 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  665d32:	48 83 c4 08          	add    $0x8,%rsp
  665d36:	c3                   	ret
  665d37:	c3                   	ret
