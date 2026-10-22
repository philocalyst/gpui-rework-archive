
/tmp/gpui-text-map-query-controls/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000685700 <<gpui_canvas::text::layout::TextGeometry>::validates_selection>:
  685700:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  685705:	0f 84 15 01 00 00    	je     685820 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x120>
  68570b:	53                   	push   %rbx
  68570c:	44 8b 06             	mov    (%rsi),%r8d
  68570f:	44 0f b6 4e 04       	movzbl 0x4(%rsi),%r9d
  685714:	48 8b 47 38          	mov    0x38(%rdi),%rax
  685718:	48 8b 4f 40          	mov    0x40(%rdi),%rcx
  68571c:	48 89 ca             	mov    %rcx,%rdx
  68571f:	48 85 c9             	test   %rcx,%rcx
  685722:	74 39                	je     68575d <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x5d>
  685724:	31 d2                	xor    %edx,%edx
  685726:	48 83 f9 01          	cmp    $0x1,%rcx
  68572a:	74 24                	je     685750 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x50>
  68572c:	48 89 cf             	mov    %rcx,%rdi
  68572f:	90                   	nop
  685730:	49 89 fa             	mov    %rdi,%r10
  685733:	49 d1 ea             	shr    $1,%r10
  685736:	4d 8d 1c 12          	lea    (%r10,%rdx,1),%r11
  68573a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  68573e:	44 39 44 d8 10       	cmp    %r8d,0x10(%rax,%rbx,8)
  685743:	49 0f 42 d3          	cmovb  %r11,%rdx
  685747:	4c 29 d7             	sub    %r10,%rdi
  68574a:	48 83 ff 01          	cmp    $0x1,%rdi
  68574e:	77 e0                	ja     685730 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x30>
  685750:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  685754:	44 39 44 f8 10       	cmp    %r8d,0x10(%rax,%rdi,8)
  685759:	48 83 d2 00          	adc    $0x0,%rdx
  68575d:	41 fe c1             	inc    %r9b
  685760:	48 c1 e2 03          	shl    $0x3,%rdx
  685764:	4c 8d 1c 52          	lea    (%rdx,%rdx,2),%r11
  685768:	4a 8d 3c 18          	lea    (%rax,%r11,1),%rdi
  68576c:	48 8d 14 cd 00 00 00 	lea    0x0(,%rcx,8),%rdx
  685773:	00 
  685774:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  685778:	49 89 d2             	mov    %rdx,%r10
  68577b:	4d 29 da             	sub    %r11,%r10
  68577e:	66 90                	xchg   %ax,%ax
  685780:	4d 85 d2             	test   %r10,%r10
  685783:	0f 84 93 00 00 00    	je     68581c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11c>
  685789:	44 39 47 10          	cmp    %r8d,0x10(%rdi)
  68578d:	0f 85 89 00 00 00    	jne    68581c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11c>
  685793:	49 83 c2 e8          	add    $0xffffffffffffffe8,%r10
  685797:	44 84 4f 14          	test   %r9b,0x14(%rdi)
  68579b:	48 8d 7f 18          	lea    0x18(%rdi),%rdi
  68579f:	74 df                	je     685780 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x80>
  6857a1:	8b 7e 08             	mov    0x8(%rsi),%edi
  6857a4:	0f b6 76 0c          	movzbl 0xc(%rsi),%esi
  6857a8:	48 85 c9             	test   %rcx,%rcx
  6857ab:	74 42                	je     6857ef <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xef>
  6857ad:	45 31 c0             	xor    %r8d,%r8d
  6857b0:	48 83 f9 01          	cmp    $0x1,%rcx
  6857b4:	74 2a                	je     6857e0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xe0>
  6857b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  6857bd:	00 00 00 
  6857c0:	49 89 c9             	mov    %rcx,%r9
  6857c3:	49 d1 e9             	shr    $1,%r9
  6857c6:	4f 8d 14 01          	lea    (%r9,%r8,1),%r10
  6857ca:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  6857ce:	42 39 7c d8 10       	cmp    %edi,0x10(%rax,%r11,8)
  6857d3:	4d 0f 42 c2          	cmovb  %r10,%r8
  6857d7:	4c 29 c9             	sub    %r9,%rcx
  6857da:	48 83 f9 01          	cmp    $0x1,%rcx
  6857de:	77 e0                	ja     6857c0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xc0>
  6857e0:	4b 8d 0c 40          	lea    (%r8,%r8,2),%rcx
  6857e4:	39 7c c8 10          	cmp    %edi,0x10(%rax,%rcx,8)
  6857e8:	49 83 d0 00          	adc    $0x0,%r8
  6857ec:	4c 89 c1             	mov    %r8,%rcx
  6857ef:	40 fe c6             	inc    %sil
  6857f2:	48 c1 e1 03          	shl    $0x3,%rcx
  6857f6:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  6857fa:	48 01 c8             	add    %rcx,%rax
  6857fd:	48 29 ca             	sub    %rcx,%rdx
  685800:	48 85 d2             	test   %rdx,%rdx
  685803:	74 17                	je     68581c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11c>
  685805:	39 78 10             	cmp    %edi,0x10(%rax)
  685808:	75 12                	jne    68581c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11c>
  68580a:	48 83 c2 e8          	add    $0xffffffffffffffe8,%rdx
  68580e:	40 84 70 14          	test   %sil,0x14(%rax)
  685812:	48 8d 40 18          	lea    0x18(%rax),%rax
  685816:	74 e8                	je     685800 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x100>
  685818:	b0 01                	mov    $0x1,%al
  68581a:	5b                   	pop    %rbx
  68581b:	c3                   	ret
  68581c:	31 c0                	xor    %eax,%eax
  68581e:	5b                   	pop    %rbx
  68581f:	c3                   	ret
  685820:	31 c0                	xor    %eax,%eax
  685822:	c3                   	ret
