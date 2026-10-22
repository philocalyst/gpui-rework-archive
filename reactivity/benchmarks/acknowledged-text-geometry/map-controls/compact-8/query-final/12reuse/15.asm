
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000681280 <<gpui_canvas::text::layout::TextGeometry>::source_line>:
  681280:	f6 d2                	not    %dl
  681282:	85 f6                	test   %esi,%esi
  681284:	41 0f 95 c0          	setne  %r8b
  681288:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  68128c:	48 8b 47 28          	mov    0x28(%rdi),%rax
  681290:	44 84 c2             	test   %r8b,%dl
  681293:	75 54                	jne    6812e9 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x69>
  681295:	48 85 c0             	test   %rax,%rax
  681298:	0f 84 98 00 00 00    	je     681336 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xb6>
  68129e:	31 d2                	xor    %edx,%edx
  6812a0:	48 83 f8 01          	cmp    $0x1,%rax
  6812a4:	74 2b                	je     6812d1 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x51>
  6812a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  6812ad:	00 00 00 
  6812b0:	48 89 d7             	mov    %rdx,%rdi
  6812b3:	49 89 c0             	mov    %rax,%r8
  6812b6:	49 d1 e8             	shr    $1,%r8
  6812b9:	4c 01 c2             	add    %r8,%rdx
  6812bc:	4c 8d 0c 52          	lea    (%rdx,%rdx,2),%r9
  6812c0:	42 39 34 c9          	cmp    %esi,(%rcx,%r9,8)
  6812c4:	48 0f 47 d7          	cmova  %rdi,%rdx
  6812c8:	4c 29 c0             	sub    %r8,%rax
  6812cb:	48 83 f8 01          	cmp    $0x1,%rax
  6812cf:	77 df                	ja     6812b0 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x30>
  6812d1:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  6812d5:	31 c0                	xor    %eax,%eax
  6812d7:	39 34 f9             	cmp    %esi,(%rcx,%rdi,8)
  6812da:	0f 96 c0             	setbe  %al
  6812dd:	48 01 d0             	add    %rdx,%rax
  6812e0:	48 83 f8 01          	cmp    $0x1,%rax
  6812e4:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  6812e8:	c3                   	ret
  6812e9:	48 89 c2             	mov    %rax,%rdx
  6812ec:	48 85 c0             	test   %rax,%rax
  6812ef:	74 3b                	je     68132c <<gpui_canvas::text::layout::TextGeometry>::source_line+0xac>
  6812f1:	31 d2                	xor    %edx,%edx
  6812f3:	48 83 f8 01          	cmp    $0x1,%rax
  6812f7:	74 27                	je     681320 <<gpui_canvas::text::layout::TextGeometry>::source_line+0xa0>
  6812f9:	48 89 c7             	mov    %rax,%rdi
  6812fc:	0f 1f 40 00          	nopl   0x0(%rax)
  681300:	49 89 f8             	mov    %rdi,%r8
  681303:	49 d1 e8             	shr    $1,%r8
  681306:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  68130a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  68130e:	42 39 74 d1 04       	cmp    %esi,0x4(%rcx,%r10,8)
  681313:	49 0f 42 d1          	cmovb  %r9,%rdx
  681317:	4c 29 c7             	sub    %r8,%rdi
  68131a:	48 83 ff 01          	cmp    $0x1,%rdi
  68131e:	77 e0                	ja     681300 <<gpui_canvas::text::layout::TextGeometry>::source_line+0x80>
  681320:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  681324:	39 74 f9 04          	cmp    %esi,0x4(%rcx,%rdi,8)
  681328:	48 83 d2 00          	adc    $0x0,%rdx
  68132c:	48 ff c8             	dec    %rax
  68132f:	48 39 d0             	cmp    %rdx,%rax
  681332:	48 0f 43 c2          	cmovae %rdx,%rax
  681336:	c3                   	ret
