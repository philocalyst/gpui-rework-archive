
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662760 <<gpui_canvas::text::layout::TextGeometry>::source_line>:
  662760:	f6 d2                	not    %dl
  662762:	85 f6                	test   %esi,%esi
  662764:	41 0f 95 c0          	setne  %r8b
  662768:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  66276c:	48 8b 47 28          	mov    0x28(%rdi),%rax
  662770:	44 84 c2             	test   %r8b,%dl
  662773:	75 54                	jne    6627c9 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x69>
  662775:	48 85 c0             	test   %rax,%rax
  662778:	0f 84 98 00 00 00    	je     662816 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xb6>
  66277e:	31 d2                	xor    %edx,%edx
  662780:	48 83 f8 01          	cmp    $0x1,%rax
  662784:	74 2b                	je     6627b1 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x51>
  662786:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  66278d:	00 00 00 
  662790:	48 89 d7             	mov    %rdx,%rdi
  662793:	49 89 c0             	mov    %rax,%r8
  662796:	49 d1 e8             	shr    $1,%r8
  662799:	4c 01 c2             	add    %r8,%rdx
  66279c:	4c 8d 0c 52          	lea    (%rdx,%rdx,2),%r9
  6627a0:	42 39 34 c9          	cmp    %esi,(%rcx,%r9,8)
  6627a4:	48 0f 47 d7          	cmova  %rdi,%rdx
  6627a8:	4c 29 c0             	sub    %r8,%rax
  6627ab:	48 83 f8 01          	cmp    $0x1,%rax
  6627af:	77 df                	ja     662790 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x30>
  6627b1:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  6627b5:	31 c0                	xor    %eax,%eax
  6627b7:	39 34 f9             	cmp    %esi,(%rcx,%rdi,8)
  6627ba:	0f 96 c0             	setbe  %al
  6627bd:	48 01 d0             	add    %rdx,%rax
  6627c0:	48 83 f8 01          	cmp    $0x1,%rax
  6627c4:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  6627c8:	c3                   	ret
  6627c9:	48 89 c2             	mov    %rax,%rdx
  6627cc:	48 85 c0             	test   %rax,%rax
  6627cf:	74 3b                	je     66280c <<gpui_canvas::text::layout::TextGeometry>::source_line+0xac>
  6627d1:	31 d2                	xor    %edx,%edx
  6627d3:	48 83 f8 01          	cmp    $0x1,%rax
  6627d7:	74 27                	je     662800 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xa0>
  6627d9:	48 89 c7             	mov    %rax,%rdi
  6627dc:	0f 1f 40 00          	nopl   0x0(%rax)
  6627e0:	49 89 f8             	mov    %rdi,%r8
  6627e3:	49 d1 e8             	shr    $1,%r8
  6627e6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  6627ea:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  6627ee:	42 39 74 d1 04       	cmp    %esi,0x4(%rcx,%r10,8)
  6627f3:	49 0f 42 d1          	cmovb  %r9,%rdx
  6627f7:	4c 29 c7             	sub    %r8,%rdi
  6627fa:	48 83 ff 01          	cmp    $0x1,%rdi
  6627fe:	77 e0                	ja     6627e0 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x80>
  662800:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  662804:	39 74 f9 04          	cmp    %esi,0x4(%rcx,%rdi,8)
  662808:	48 83 d2 00          	adc    $0x0,%rdx
  66280c:	48 ff c8             	dec    %rax
  66280f:	48 39 d0             	cmp    %rdx,%rax
  662812:	48 0f 43 c2          	cmovae %rdx,%rax
  662816:	c3                   	ret
