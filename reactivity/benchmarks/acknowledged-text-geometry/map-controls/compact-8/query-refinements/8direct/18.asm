
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000683d00 <<gpui_canvas::text::layout::TextGeometry>::caret_line>:
  683d00:	55                   	push   %rbp
  683d01:	41 56                	push   %r14
  683d03:	53                   	push   %rbx
  683d04:	48 83 ec 20          	sub    $0x20,%rsp
  683d08:	89 d5                	mov    %edx,%ebp
  683d0a:	89 f3                	mov    %esi,%ebx
  683d0c:	49 89 fe             	mov    %rdi,%r14
  683d0f:	48 8d 7c 24 0c       	lea    0xc(%rsp),%rdi
  683d14:	4c 89 f6             	mov    %r14,%rsi
  683d17:	89 da                	mov    %ebx,%edx
  683d19:	89 e9                	mov    %ebp,%ecx
  683d1b:	ff 15 b7 5c 10 00    	call   *0x105cb7(%rip)        # 7899d8 <_DYNAMIC+0x570>
  683d21:	83 7c 24 0c 01       	cmpl   $0x1,0xc(%rsp)
  683d26:	75 72                	jne    683d9a <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x9a>
  683d28:	85 db                	test   %ebx,%ebx
  683d2a:	0f 95 c0             	setne  %al
  683d2d:	40 f6 d5             	not    %bpl
  683d30:	49 8b 4e 38          	mov    0x38(%r14),%rcx
  683d34:	49 8b 56 40          	mov    0x40(%r14),%rdx
  683d38:	40 84 c5             	test   %al,%bpl
  683d3b:	75 61                	jne    683d9e <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x9e>
  683d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  683d42:	48 85 d2             	test   %rdx,%rdx
  683d45:	0f 84 b0 00 00 00    	je     683dfb <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xfb>
  683d4b:	31 f6                	xor    %esi,%esi
  683d4d:	48 83 fa 01          	cmp    $0x1,%rdx
  683d51:	74 2e                	je     683d81 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x81>
  683d53:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  683d5a:	84 00 00 00 00 00 
  683d60:	48 89 f7             	mov    %rsi,%rdi
  683d63:	49 89 d0             	mov    %rdx,%r8
  683d66:	49 d1 e8             	shr    $1,%r8
  683d69:	4c 01 c6             	add    %r8,%rsi
  683d6c:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  683d70:	42 39 1c c9          	cmp    %ebx,(%rcx,%r9,8)
  683d74:	48 0f 47 f7          	cmova  %rdi,%rsi
  683d78:	4c 29 c2             	sub    %r8,%rdx
  683d7b:	48 83 fa 01          	cmp    $0x1,%rdx
  683d7f:	77 df                	ja     683d60 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x60>
  683d81:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  683d85:	31 d2                	xor    %edx,%edx
  683d87:	39 1c f9             	cmp    %ebx,(%rcx,%rdi,8)
  683d8a:	0f 96 c2             	setbe  %dl
  683d8d:	48 01 f2             	add    %rsi,%rdx
  683d90:	48 83 fa 01          	cmp    $0x1,%rdx
  683d94:	48 83 d2 ff          	adc    $0xffffffffffffffff,%rdx
  683d98:	eb 61                	jmp    683dfb <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xfb>
  683d9a:	31 c0                	xor    %eax,%eax
  683d9c:	eb 5d                	jmp    683dfb <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xfb>
  683d9e:	48 89 d0             	mov    %rdx,%rax
  683da1:	48 85 d2             	test   %rdx,%rdx
  683da4:	74 46                	je     683dec <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xec>
  683da6:	31 c0                	xor    %eax,%eax
  683da8:	48 83 fa 01          	cmp    $0x1,%rdx
  683dac:	74 32                	je     683de0 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xe0>
  683dae:	48 89 d6             	mov    %rdx,%rsi
  683db1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  683db8:	0f 1f 84 00 00 00 00 
  683dbf:	00 
  683dc0:	48 89 f7             	mov    %rsi,%rdi
  683dc3:	48 d1 ef             	shr    $1,%rdi
  683dc6:	4c 8d 04 07          	lea    (%rdi,%rax,1),%r8
  683dca:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  683dce:	42 39 5c c9 04       	cmp    %ebx,0x4(%rcx,%r9,8)
  683dd3:	49 0f 42 c0          	cmovb  %r8,%rax
  683dd7:	48 29 fe             	sub    %rdi,%rsi
  683dda:	48 83 fe 01          	cmp    $0x1,%rsi
  683dde:	77 e0                	ja     683dc0 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xc0>
  683de0:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  683de4:	39 5c f1 04          	cmp    %ebx,0x4(%rcx,%rsi,8)
  683de8:	48 83 d0 00          	adc    $0x0,%rax
  683dec:	48 ff ca             	dec    %rdx
  683def:	48 39 c2             	cmp    %rax,%rdx
  683df2:	48 0f 43 d0          	cmovae %rax,%rdx
  683df6:	b8 01 00 00 00       	mov    $0x1,%eax
  683dfb:	48 83 c4 20          	add    $0x20,%rsp
  683dff:	5b                   	pop    %rbx
  683e00:	41 5e                	pop    %r14
  683e02:	5d                   	pop    %rbp
  683e03:	c3                   	ret
