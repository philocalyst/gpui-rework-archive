
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006864e0 <<gpui_canvas::text::layout::TextGeometry>::source_line>:
  6864e0:	f6 d2                	not    %dl
  6864e2:	85 f6                	test   %esi,%esi
  6864e4:	41 0f 95 c0          	setne  %r8b
  6864e8:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
  6864ec:	48 8b 47 40          	mov    0x40(%rdi),%rax
  6864f0:	44 84 c2             	test   %r8b,%dl
  6864f3:	75 54                	jne    686549 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x69>
  6864f5:	48 85 c0             	test   %rax,%rax
  6864f8:	0f 84 98 00 00 00    	je     686596 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xb6>
  6864fe:	31 d2                	xor    %edx,%edx
  686500:	48 83 f8 01          	cmp    $0x1,%rax
  686504:	74 2b                	je     686531 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x51>
  686506:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  68650d:	00 00 00 
  686510:	48 89 d7             	mov    %rdx,%rdi
  686513:	49 89 c0             	mov    %rax,%r8
  686516:	49 d1 e8             	shr    $1,%r8
  686519:	4c 01 c2             	add    %r8,%rdx
  68651c:	4c 8d 0c 52          	lea    (%rdx,%rdx,2),%r9
  686520:	42 39 34 c9          	cmp    %esi,(%rcx,%r9,8)
  686524:	48 0f 47 d7          	cmova  %rdi,%rdx
  686528:	4c 29 c0             	sub    %r8,%rax
  68652b:	48 83 f8 01          	cmp    $0x1,%rax
  68652f:	77 df                	ja     686510 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x30>
  686531:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  686535:	31 c0                	xor    %eax,%eax
  686537:	39 34 f9             	cmp    %esi,(%rcx,%rdi,8)
  68653a:	0f 96 c0             	setbe  %al
  68653d:	48 01 d0             	add    %rdx,%rax
  686540:	48 83 f8 01          	cmp    $0x1,%rax
  686544:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  686548:	c3                   	ret
  686549:	48 89 c2             	mov    %rax,%rdx
  68654c:	48 85 c0             	test   %rax,%rax
  68654f:	74 3b                	je     68658c <<gpui_canvas::text::layout::TextGeometry>::source_line+0xac>
  686551:	31 d2                	xor    %edx,%edx
  686553:	48 83 f8 01          	cmp    $0x1,%rax
  686557:	74 27                	je     686580 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xa0>
  686559:	48 89 c7             	mov    %rax,%rdi
  68655c:	0f 1f 40 00          	nopl   0x0(%rax)
  686560:	49 89 f8             	mov    %rdi,%r8
  686563:	49 d1 e8             	shr    $1,%r8
  686566:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  68656a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  68656e:	42 39 74 d1 04       	cmp    %esi,0x4(%rcx,%r10,8)
  686573:	49 0f 42 d1          	cmovb  %r9,%rdx
  686577:	4c 29 c7             	sub    %r8,%rdi
  68657a:	48 83 ff 01          	cmp    $0x1,%rdi
  68657e:	77 e0                	ja     686560 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x80>
  686580:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  686584:	39 74 f9 04          	cmp    %esi,0x4(%rcx,%rdi,8)
  686588:	48 83 d2 00          	adc    $0x0,%rdx
  68658c:	48 ff c8             	dec    %rax
  68658f:	48 39 d0             	cmp    %rdx,%rax
  686592:	48 0f 43 c2          	cmovae %rdx,%rax
  686596:	c3                   	ret
