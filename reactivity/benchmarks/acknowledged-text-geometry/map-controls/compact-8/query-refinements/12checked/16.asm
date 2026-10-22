
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662690 <<gpui_canvas::text::layout::TextGeometry>::stops>:
  662690:	53                   	push   %rbx
  662691:	89 d0                	mov    %edx,%eax
  662693:	31 d2                	xor    %edx,%edx
  662695:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  66269a:	4c 8b 47 40          	mov    0x40(%rdi),%r8
  66269e:	49 0f 45 d0          	cmovne %r8,%rdx
  6626a2:	b9 04 00 00 00       	mov    $0x4,%ecx
  6626a7:	48 0f 45 4f 38       	cmovne 0x38(%rdi),%rcx
  6626ac:	85 f6                	test   %esi,%esi
  6626ae:	74 4c                	je     6626fc <<gpui_canvas::text::layout::TextGeometry>::stops+0x6c>
  6626b0:	48 85 d2             	test   %rdx,%rdx
  6626b3:	0f 84 96 00 00 00    	je     66274f <<gpui_canvas::text::layout::TextGeometry>::stops+0xbf>
  6626b9:	31 ff                	xor    %edi,%edi
  6626bb:	48 83 fa 01          	cmp    $0x1,%rdx
  6626bf:	74 2d                	je     6626ee <<gpui_canvas::text::layout::TextGeometry>::stops+0x5e>
  6626c1:	4d 89 c1             	mov    %r8,%r9
  6626c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6626cb:	00 00 00 00 00 
  6626d0:	4d 89 ca             	mov    %r9,%r10
  6626d3:	49 d1 ea             	shr    $1,%r10
  6626d6:	4d 8d 1c 3a          	lea    (%r10,%rdi,1),%r11
  6626da:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  6626de:	39 34 99             	cmp    %esi,(%rcx,%rbx,4)
  6626e1:	49 0f 42 fb          	cmovb  %r11,%rdi
  6626e5:	4d 29 d1             	sub    %r10,%r9
  6626e8:	49 83 f9 01          	cmp    $0x1,%r9
  6626ec:	77 e2                	ja     6626d0 <<gpui_canvas::text::layout::TextGeometry>::stops+0x40>
  6626ee:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  6626f2:	42 39 34 89          	cmp    %esi,(%rcx,%r9,4)
  6626f6:	48 83 d7 00          	adc    $0x0,%rdi
  6626fa:	eb 0c                	jmp    662708 <<gpui_canvas::text::layout::TextGeometry>::stops+0x78>
  6626fc:	31 ff                	xor    %edi,%edi
  6626fe:	be 00 00 00 00       	mov    $0x0,%esi
  662703:	48 85 d2             	test   %rdx,%rdx
  662706:	74 4d                	je     662755 <<gpui_canvas::text::layout::TextGeometry>::stops+0xc5>
  662708:	31 f6                	xor    %esi,%esi
  66270a:	48 83 fa 01          	cmp    $0x1,%rdx
  66270e:	74 21                	je     662731 <<gpui_canvas::text::layout::TextGeometry>::stops+0xa1>
  662710:	49 89 f1             	mov    %rsi,%r9
  662713:	4d 89 c2             	mov    %r8,%r10
  662716:	49 d1 ea             	shr    $1,%r10
  662719:	4c 01 d6             	add    %r10,%rsi
  66271c:	4c 8d 1c 76          	lea    (%rsi,%rsi,2),%r11
  662720:	42 39 04 99          	cmp    %eax,(%rcx,%r11,4)
  662724:	49 0f 47 f1          	cmova  %r9,%rsi
  662728:	4d 29 d0             	sub    %r10,%r8
  66272b:	49 83 f8 01          	cmp    $0x1,%r8
  66272f:	77 df                	ja     662710 <<gpui_canvas::text::layout::TextGeometry>::stops+0x80>
  662731:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  662735:	42 3b 04 81          	cmp    (%rcx,%r8,4),%eax
  662739:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  66273d:	48 39 fe             	cmp    %rdi,%rsi
  662740:	73 13                	jae    662755 <<gpui_canvas::text::layout::TextGeometry>::stops+0xc5>
  662742:	48 8d 0d df 9f 11 00 	lea    0x119fdf(%rip),%rcx        # 77c728 <anon.0ce93d74e9d39703631c89632b12715b.3.llvm.7854699070981760621+0x48>
  662749:	ff 15 b1 4d 12 00    	call   *0x124db1(%rip)        # 787500 <_DYNAMIC+0x3e0>
  66274f:	48 89 d6             	mov    %rdx,%rsi
  662752:	48 89 d7             	mov    %rdx,%rdi
  662755:	48 29 fe             	sub    %rdi,%rsi
  662758:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  66275c:	48 8d 04 81          	lea    (%rcx,%rax,4),%rax
  662760:	48 89 f2             	mov    %rsi,%rdx
  662763:	5b                   	pop    %rbx
  662764:	c3                   	ret
