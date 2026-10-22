
/tmp/gpui-text-map-query-controls/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000685590 <<gpui_canvas::text::layout::TextGeometry>::caret_line>:
  685590:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  685595:	0f 84 02 01 00 00    	je     68569d <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x10d>
  68559b:	53                   	push   %rbx
  68559c:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
  6855a0:	48 8b 47 40          	mov    0x40(%rdi),%rax
  6855a4:	49 89 c0             	mov    %rax,%r8
  6855a7:	48 85 c0             	test   %rax,%rax
  6855aa:	74 40                	je     6855ec <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x5c>
  6855ac:	45 31 c0             	xor    %r8d,%r8d
  6855af:	48 83 f8 01          	cmp    $0x1,%rax
  6855b3:	74 2a                	je     6855df <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x4f>
  6855b5:	49 89 c1             	mov    %rax,%r9
  6855b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6855bf:	00 
  6855c0:	4d 89 ca             	mov    %r9,%r10
  6855c3:	49 d1 ea             	shr    $1,%r10
  6855c6:	4f 8d 1c 02          	lea    (%r10,%r8,1),%r11
  6855ca:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  6855ce:	39 74 d9 10          	cmp    %esi,0x10(%rcx,%rbx,8)
  6855d2:	4d 0f 42 c3          	cmovb  %r11,%r8
  6855d6:	4d 29 d1             	sub    %r10,%r9
  6855d9:	49 83 f9 01          	cmp    $0x1,%r9
  6855dd:	77 e1                	ja     6855c0 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x30>
  6855df:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  6855e3:	42 39 74 c9 10       	cmp    %esi,0x10(%rcx,%r9,8)
  6855e8:	49 83 d0 00          	adc    $0x0,%r8
  6855ec:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
  6855f0:	49 c1 e0 03          	shl    $0x3,%r8
  6855f4:	4f 8d 14 40          	lea    (%r8,%r8,2),%r10
  6855f8:	4c 01 d1             	add    %r10,%rcx
  6855fb:	48 c1 e0 03          	shl    $0x3,%rax
  6855ff:	4c 8d 04 40          	lea    (%rax,%rax,2),%r8
  685603:	4d 29 d0             	sub    %r10,%r8
  685606:	31 c0                	xor    %eax,%eax
  685608:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  68560f:	00 
  685610:	4d 85 c0             	test   %r8,%r8
  685613:	0f 84 82 00 00 00    	je     68569b <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x10b>
  685619:	39 71 10             	cmp    %esi,0x10(%rcx)
  68561c:	0f 85 79 00 00 00    	jne    68569b <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x10b>
  685622:	49 83 c0 e8          	add    $0xffffffffffffffe8,%r8
  685626:	44 84 49 14          	test   %r9b,0x14(%rcx)
  68562a:	48 8d 49 18          	lea    0x18(%rcx),%rcx
  68562e:	74 e0                	je     685610 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x80>
  685630:	85 f6                	test   %esi,%esi
  685632:	0f 95 c0             	setne  %al
  685635:	f6 d2                	not    %dl
  685637:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  68563b:	49 89 d0             	mov    %rdx,%r8
  68563e:	48 8b 57 28          	mov    0x28(%rdi),%rdx
  685642:	41 84 c0             	test   %al,%r8b
  685645:	75 59                	jne    6856a0 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x110>
  685647:	b8 01 00 00 00       	mov    $0x1,%eax
  68564c:	48 85 d2             	test   %rdx,%rdx
  68564f:	0f 84 a6 00 00 00    	je     6856fb <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x16b>
  685655:	31 ff                	xor    %edi,%edi
  685657:	48 83 fa 01          	cmp    $0x1,%rdx
  68565b:	74 24                	je     685681 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xf1>
  68565d:	0f 1f 00             	nopl   (%rax)
  685660:	49 89 f8             	mov    %rdi,%r8
  685663:	49 89 d1             	mov    %rdx,%r9
  685666:	49 d1 e9             	shr    $1,%r9
  685669:	4c 01 cf             	add    %r9,%rdi
  68566c:	4c 8d 14 7f          	lea    (%rdi,%rdi,2),%r10
  685670:	42 39 34 d1          	cmp    %esi,(%rcx,%r10,8)
  685674:	49 0f 47 f8          	cmova  %r8,%rdi
  685678:	4c 29 ca             	sub    %r9,%rdx
  68567b:	48 83 fa 01          	cmp    $0x1,%rdx
  68567f:	77 df                	ja     685660 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xd0>
  685681:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  685685:	31 d2                	xor    %edx,%edx
  685687:	42 39 34 c1          	cmp    %esi,(%rcx,%r8,8)
  68568b:	0f 96 c2             	setbe  %dl
  68568e:	48 01 fa             	add    %rdi,%rdx
  685691:	48 83 fa 01          	cmp    $0x1,%rdx
  685695:	48 83 d2 ff          	adc    $0xffffffffffffffff,%rdx
  685699:	5b                   	pop    %rbx
  68569a:	c3                   	ret
  68569b:	5b                   	pop    %rbx
  68569c:	c3                   	ret
  68569d:	31 c0                	xor    %eax,%eax
  68569f:	c3                   	ret
  6856a0:	48 89 d0             	mov    %rdx,%rax
  6856a3:	48 85 d2             	test   %rdx,%rdx
  6856a6:	74 44                	je     6856ec <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x15c>
  6856a8:	31 c0                	xor    %eax,%eax
  6856aa:	48 83 fa 01          	cmp    $0x1,%rdx
  6856ae:	74 30                	je     6856e0 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x150>
  6856b0:	48 89 d7             	mov    %rdx,%rdi
  6856b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6856ba:	84 00 00 00 00 00 
  6856c0:	49 89 f8             	mov    %rdi,%r8
  6856c3:	49 d1 e8             	shr    $1,%r8
  6856c6:	4d 8d 0c 00          	lea    (%r8,%rax,1),%r9
  6856ca:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  6856ce:	42 39 74 d1 04       	cmp    %esi,0x4(%rcx,%r10,8)
  6856d3:	49 0f 42 c1          	cmovb  %r9,%rax
  6856d7:	4c 29 c7             	sub    %r8,%rdi
  6856da:	48 83 ff 01          	cmp    $0x1,%rdi
  6856de:	77 e0                	ja     6856c0 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x130>
  6856e0:	48 8d 3c 40          	lea    (%rax,%rax,2),%rdi
  6856e4:	39 74 f9 04          	cmp    %esi,0x4(%rcx,%rdi,8)
  6856e8:	48 83 d0 00          	adc    $0x0,%rax
  6856ec:	48 ff ca             	dec    %rdx
  6856ef:	48 39 c2             	cmp    %rax,%rdx
  6856f2:	48 0f 43 d0          	cmovae %rax,%rdx
  6856f6:	b8 01 00 00 00       	mov    $0x1,%eax
  6856fb:	5b                   	pop    %rbx
  6856fc:	c3                   	ret
