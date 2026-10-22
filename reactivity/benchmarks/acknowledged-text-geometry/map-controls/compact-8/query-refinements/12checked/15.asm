
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006625d0 <<gpui_canvas::text::layout::TextGeometry>::source_line>:
  6625d0:	f6 d2                	not    %dl
  6625d2:	85 f6                	test   %esi,%esi
  6625d4:	41 0f 95 c0          	setne  %r8b
  6625d8:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  6625dc:	48 8b 47 28          	mov    0x28(%rdi),%rax
  6625e0:	44 84 c2             	test   %r8b,%dl
  6625e3:	75 54                	jne    662639 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x69>
  6625e5:	48 85 c0             	test   %rax,%rax
  6625e8:	0f 84 98 00 00 00    	je     662686 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xb6>
  6625ee:	31 d2                	xor    %edx,%edx
  6625f0:	48 83 f8 01          	cmp    $0x1,%rax
  6625f4:	74 2b                	je     662621 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x51>
  6625f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  6625fd:	00 00 00 
  662600:	48 89 d7             	mov    %rdx,%rdi
  662603:	49 89 c0             	mov    %rax,%r8
  662606:	49 d1 e8             	shr    $1,%r8
  662609:	4c 01 c2             	add    %r8,%rdx
  66260c:	4c 8d 0c 52          	lea    (%rdx,%rdx,2),%r9
  662610:	42 39 34 c9          	cmp    %esi,(%rcx,%r9,8)
  662614:	48 0f 47 d7          	cmova  %rdi,%rdx
  662618:	4c 29 c0             	sub    %r8,%rax
  66261b:	48 83 f8 01          	cmp    $0x1,%rax
  66261f:	77 df                	ja     662600 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x30>
  662621:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  662625:	31 c0                	xor    %eax,%eax
  662627:	39 34 f9             	cmp    %esi,(%rcx,%rdi,8)
  66262a:	0f 96 c0             	setbe  %al
  66262d:	48 01 d0             	add    %rdx,%rax
  662630:	48 83 f8 01          	cmp    $0x1,%rax
  662634:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  662638:	c3                   	ret
  662639:	48 89 c2             	mov    %rax,%rdx
  66263c:	48 85 c0             	test   %rax,%rax
  66263f:	74 3b                	je     66267c <<gpui_canvas::text::layout::TextGeometry>::source_line+0xac>
  662641:	31 d2                	xor    %edx,%edx
  662643:	48 83 f8 01          	cmp    $0x1,%rax
  662647:	74 27                	je     662670 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xa0>
  662649:	48 89 c7             	mov    %rax,%rdi
  66264c:	0f 1f 40 00          	nopl   0x0(%rax)
  662650:	49 89 f8             	mov    %rdi,%r8
  662653:	49 d1 e8             	shr    $1,%r8
  662656:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  66265a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  66265e:	42 39 74 d1 04       	cmp    %esi,0x4(%rcx,%r10,8)
  662663:	49 0f 42 d1          	cmovb  %r9,%rdx
  662667:	4c 29 c7             	sub    %r8,%rdi
  66266a:	48 83 ff 01          	cmp    $0x1,%rdi
  66266e:	77 e0                	ja     662650 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x80>
  662670:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  662674:	39 74 f9 04          	cmp    %esi,0x4(%rcx,%rdi,8)
  662678:	48 83 d2 00          	adc    $0x0,%rdx
  66267c:	48 ff c8             	dec    %rax
  66267f:	48 39 d0             	cmp    %rdx,%rax
  662682:	48 0f 43 c2          	cmovae %rdx,%rax
  662686:	c3                   	ret
