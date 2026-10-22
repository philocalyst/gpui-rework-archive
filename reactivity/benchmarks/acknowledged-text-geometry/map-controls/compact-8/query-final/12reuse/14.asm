
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000681150 <<gpui_canvas::text::layout::TextGeometry>::validates_selection>:
  681150:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  681155:	0f 84 14 01 00 00    	je     68126f <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11f>
  68115b:	53                   	push   %rbx
  68115c:	44 8b 06             	mov    (%rsi),%r8d
  68115f:	44 0f b6 4e 04       	movzbl 0x4(%rsi),%r9d
  681164:	48 8b 47 38          	mov    0x38(%rdi),%rax
  681168:	48 8b 4f 40          	mov    0x40(%rdi),%rcx
  68116c:	48 89 ca             	mov    %rcx,%rdx
  68116f:	48 85 c9             	test   %rcx,%rcx
  681172:	74 37                	je     6811ab <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x5b>
  681174:	31 d2                	xor    %edx,%edx
  681176:	48 83 f9 01          	cmp    $0x1,%rcx
  68117a:	74 23                	je     68119f <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x4f>
  68117c:	48 89 cf             	mov    %rcx,%rdi
  68117f:	90                   	nop
  681180:	49 89 fa             	mov    %rdi,%r10
  681183:	49 d1 ea             	shr    $1,%r10
  681186:	4d 8d 1c 12          	lea    (%r10,%rdx,1),%r11
  68118a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  68118e:	44 39 04 98          	cmp    %r8d,(%rax,%rbx,4)
  681192:	49 0f 42 d3          	cmovb  %r11,%rdx
  681196:	4c 29 d7             	sub    %r10,%rdi
  681199:	48 83 ff 01          	cmp    $0x1,%rdi
  68119d:	77 e1                	ja     681180 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x30>
  68119f:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  6811a3:	44 39 04 b8          	cmp    %r8d,(%rax,%rdi,4)
  6811a7:	48 83 d2 00          	adc    $0x0,%rdx
  6811ab:	41 fe c1             	inc    %r9b
  6811ae:	48 c1 e2 02          	shl    $0x2,%rdx
  6811b2:	4c 8d 1c 52          	lea    (%rdx,%rdx,2),%r11
  6811b6:	4a 8d 3c 18          	lea    (%rax,%r11,1),%rdi
  6811ba:	48 8d 14 8d 00 00 00 	lea    0x0(,%rcx,4),%rdx
  6811c1:	00 
  6811c2:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  6811c6:	49 89 d2             	mov    %rdx,%r10
  6811c9:	4d 29 da             	sub    %r11,%r10
  6811cc:	0f 1f 40 00          	nopl   0x0(%rax)
  6811d0:	4d 85 d2             	test   %r10,%r10
  6811d3:	0f 84 92 00 00 00    	je     68126b <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11b>
  6811d9:	44 39 07             	cmp    %r8d,(%rdi)
  6811dc:	0f 85 89 00 00 00    	jne    68126b <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11b>
  6811e2:	49 83 c2 f4          	add    $0xfffffffffffffff4,%r10
  6811e6:	44 84 4f 08          	test   %r9b,0x8(%rdi)
  6811ea:	48 8d 7f 0c          	lea    0xc(%rdi),%rdi
  6811ee:	74 e0                	je     6811d0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x80>
  6811f0:	8b 7e 08             	mov    0x8(%rsi),%edi
  6811f3:	0f b6 76 0c          	movzbl 0xc(%rsi),%esi
  6811f7:	48 85 c9             	test   %rcx,%rcx
  6811fa:	74 41                	je     68123d <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xed>
  6811fc:	45 31 c0             	xor    %r8d,%r8d
  6811ff:	48 83 f9 01          	cmp    $0x1,%rcx
  681203:	74 2a                	je     68122f <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xdf>
  681205:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68120c:	00 00 00 00 
  681210:	49 89 c9             	mov    %rcx,%r9
  681213:	49 d1 e9             	shr    $1,%r9
  681216:	4f 8d 14 01          	lea    (%r9,%r8,1),%r10
  68121a:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  68121e:	42 39 3c 98          	cmp    %edi,(%rax,%r11,4)
  681222:	4d 0f 42 c2          	cmovb  %r10,%r8
  681226:	4c 29 c9             	sub    %r9,%rcx
  681229:	48 83 f9 01          	cmp    $0x1,%rcx
  68122d:	77 e1                	ja     681210 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xc0>
  68122f:	4b 8d 0c 40          	lea    (%r8,%r8,2),%rcx
  681233:	39 3c 88             	cmp    %edi,(%rax,%rcx,4)
  681236:	49 83 d0 00          	adc    $0x0,%r8
  68123a:	4c 89 c1             	mov    %r8,%rcx
  68123d:	40 fe c6             	inc    %sil
  681240:	48 c1 e1 02          	shl    $0x2,%rcx
  681244:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  681248:	48 01 c8             	add    %rcx,%rax
  68124b:	48 29 ca             	sub    %rcx,%rdx
  68124e:	66 90                	xchg   %ax,%ax
  681250:	48 85 d2             	test   %rdx,%rdx
  681253:	74 16                	je     68126b <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11b>
  681255:	39 38                	cmp    %edi,(%rax)
  681257:	75 12                	jne    68126b <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11b>
  681259:	48 83 c2 f4          	add    $0xfffffffffffffff4,%rdx
  68125d:	40 84 70 08          	test   %sil,0x8(%rax)
  681261:	48 8d 40 0c          	lea    0xc(%rax),%rax
  681265:	74 e9                	je     681250 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x100>
  681267:	b0 01                	mov    $0x1,%al
  681269:	5b                   	pop    %rbx
  68126a:	c3                   	ret
  68126b:	31 c0                	xor    %eax,%eax
  68126d:	5b                   	pop    %rbx
  68126e:	c3                   	ret
  68126f:	31 c0                	xor    %eax,%eax
  681271:	c3                   	ret
