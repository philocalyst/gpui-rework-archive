
/tmp/gpui-text-map-query-final/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000685830 <<gpui_canvas::text::layout::TextGeometry>::source_line>:
  685830:	f6 d2                	not    %dl
  685832:	85 f6                	test   %esi,%esi
  685834:	41 0f 95 c0          	setne  %r8b
  685838:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  68583c:	48 8b 47 28          	mov    0x28(%rdi),%rax
  685840:	44 84 c2             	test   %r8b,%dl
  685843:	75 54                	jne    685899 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x69>
  685845:	48 85 c0             	test   %rax,%rax
  685848:	0f 84 98 00 00 00    	je     6858e6 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xb6>
  68584e:	31 d2                	xor    %edx,%edx
  685850:	48 83 f8 01          	cmp    $0x1,%rax
  685854:	74 2b                	je     685881 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x51>
  685856:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  68585d:	00 00 00 
  685860:	48 89 d7             	mov    %rdx,%rdi
  685863:	49 89 c0             	mov    %rax,%r8
  685866:	49 d1 e8             	shr    $1,%r8
  685869:	4c 01 c2             	add    %r8,%rdx
  68586c:	4c 8d 0c 52          	lea    (%rdx,%rdx,2),%r9
  685870:	42 39 34 c9          	cmp    %esi,(%rcx,%r9,8)
  685874:	48 0f 47 d7          	cmova  %rdi,%rdx
  685878:	4c 29 c0             	sub    %r8,%rax
  68587b:	48 83 f8 01          	cmp    $0x1,%rax
  68587f:	77 df                	ja     685860 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x30>
  685881:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  685885:	31 c0                	xor    %eax,%eax
  685887:	39 34 f9             	cmp    %esi,(%rcx,%rdi,8)
  68588a:	0f 96 c0             	setbe  %al
  68588d:	48 01 d0             	add    %rdx,%rax
  685890:	48 83 f8 01          	cmp    $0x1,%rax
  685894:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  685898:	c3                   	ret
  685899:	48 89 c2             	mov    %rax,%rdx
  68589c:	48 85 c0             	test   %rax,%rax
  68589f:	74 3b                	je     6858dc <<gpui_canvas::text::layout::TextGeometry>::source_line+0xac>
  6858a1:	31 d2                	xor    %edx,%edx
  6858a3:	48 83 f8 01          	cmp    $0x1,%rax
  6858a7:	74 27                	je     6858d0 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xa0>
  6858a9:	48 89 c7             	mov    %rax,%rdi
  6858ac:	0f 1f 40 00          	nopl   0x0(%rax)
  6858b0:	49 89 f8             	mov    %rdi,%r8
  6858b3:	49 d1 e8             	shr    $1,%r8
  6858b6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  6858ba:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  6858be:	42 39 74 d1 04       	cmp    %esi,0x4(%rcx,%r10,8)
  6858c3:	49 0f 42 d1          	cmovb  %r9,%rdx
  6858c7:	4c 29 c7             	sub    %r8,%rdi
  6858ca:	48 83 ff 01          	cmp    $0x1,%rdi
  6858ce:	77 e0                	ja     6858b0 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x80>
  6858d0:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  6858d4:	39 74 f9 04          	cmp    %esi,0x4(%rcx,%rdi,8)
  6858d8:	48 83 d2 00          	adc    $0x0,%rdx
  6858dc:	48 ff c8             	dec    %rax
  6858df:	48 39 d0             	cmp    %rdx,%rax
  6858e2:	48 0f 43 c2          	cmovae %rdx,%rax
  6858e6:	c3                   	ret
