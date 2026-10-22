
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680040 <<gpui_canvas::text::layout::TextGeometry>::source_line>:
  680040:	f6 d2                	not    %dl
  680042:	85 f6                	test   %esi,%esi
  680044:	41 0f 95 c0          	setne  %r8b
  680048:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
  68004c:	48 8b 47 40          	mov    0x40(%rdi),%rax
  680050:	44 84 c2             	test   %r8b,%dl
  680053:	75 54                	jne    6800a9 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x69>
  680055:	48 85 c0             	test   %rax,%rax
  680058:	0f 84 98 00 00 00    	je     6800f6 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xb6>
  68005e:	31 d2                	xor    %edx,%edx
  680060:	48 83 f8 01          	cmp    $0x1,%rax
  680064:	74 2b                	je     680091 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x51>
  680066:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  68006d:	00 00 00 
  680070:	48 89 d7             	mov    %rdx,%rdi
  680073:	49 89 c0             	mov    %rax,%r8
  680076:	49 d1 e8             	shr    $1,%r8
  680079:	4c 01 c2             	add    %r8,%rdx
  68007c:	4c 8d 0c 52          	lea    (%rdx,%rdx,2),%r9
  680080:	42 39 34 c9          	cmp    %esi,(%rcx,%r9,8)
  680084:	48 0f 47 d7          	cmova  %rdi,%rdx
  680088:	4c 29 c0             	sub    %r8,%rax
  68008b:	48 83 f8 01          	cmp    $0x1,%rax
  68008f:	77 df                	ja     680070 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x30>
  680091:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  680095:	31 c0                	xor    %eax,%eax
  680097:	39 34 f9             	cmp    %esi,(%rcx,%rdi,8)
  68009a:	0f 96 c0             	setbe  %al
  68009d:	48 01 d0             	add    %rdx,%rax
  6800a0:	48 83 f8 01          	cmp    $0x1,%rax
  6800a4:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  6800a8:	c3                   	ret
  6800a9:	48 89 c2             	mov    %rax,%rdx
  6800ac:	48 85 c0             	test   %rax,%rax
  6800af:	74 3b                	je     6800ec <<gpui_canvas::text::layout::TextGeometry>::source_line+0xac>
  6800b1:	31 d2                	xor    %edx,%edx
  6800b3:	48 83 f8 01          	cmp    $0x1,%rax
  6800b7:	74 27                	je     6800e0 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xa0>
  6800b9:	48 89 c7             	mov    %rax,%rdi
  6800bc:	0f 1f 40 00          	nopl   0x0(%rax)
  6800c0:	49 89 f8             	mov    %rdi,%r8
  6800c3:	49 d1 e8             	shr    $1,%r8
  6800c6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  6800ca:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  6800ce:	42 39 74 d1 04       	cmp    %esi,0x4(%rcx,%r10,8)
  6800d3:	49 0f 42 d1          	cmovb  %r9,%rdx
  6800d7:	4c 29 c7             	sub    %r8,%rdi
  6800da:	48 83 ff 01          	cmp    $0x1,%rdi
  6800de:	77 e0                	ja     6800c0 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x80>
  6800e0:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  6800e4:	39 74 f9 04          	cmp    %esi,0x4(%rcx,%rdi,8)
  6800e8:	48 83 d2 00          	adc    $0x0,%rdx
  6800ec:	48 ff c8             	dec    %rax
  6800ef:	48 39 d0             	cmp    %rdx,%rax
  6800f2:	48 0f 43 c2          	cmovae %rdx,%rax
  6800f6:	c3                   	ret
