
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006865a0 <<gpui_canvas::text::layout::TextGeometry>::stops>:
  6865a0:	41 57                	push   %r15
  6865a2:	41 56                	push   %r14
  6865a4:	53                   	push   %rbx
  6865a5:	41 89 d0             	mov    %edx,%r8d
  6865a8:	4c 8b 1e             	mov    (%rsi),%r11
  6865ab:	4c 8b 56 10          	mov    0x10(%rsi),%r10
  6865af:	31 c0                	xor    %eax,%eax
  6865b1:	49 83 fb 02          	cmp    $0x2,%r11
  6865b5:	4c 89 d2             	mov    %r10,%rdx
  6865b8:	48 0f 44 d0          	cmove  %rax,%rdx
  6865bc:	41 b9 04 00 00 00    	mov    $0x4,%r9d
  6865c2:	4c 0f 45 4e 08       	cmovne 0x8(%rsi),%r9
  6865c7:	45 85 c0             	test   %r8d,%r8d
  6865ca:	0f 84 8e 00 00 00    	je     68665e <<gpui_canvas::text::layout::TextGeometry>::stops+0xbe>
  6865d0:	41 f6 c3 01          	test   $0x1,%r11b
  6865d4:	75 3b                	jne    686611 <<gpui_canvas::text::layout::TextGeometry>::stops+0x71>
  6865d6:	48 85 d2             	test   %rdx,%rdx
  6865d9:	0f 84 50 01 00 00    	je     68672f <<gpui_canvas::text::layout::TextGeometry>::stops+0x18f>
  6865df:	31 c0                	xor    %eax,%eax
  6865e1:	48 83 fa 01          	cmp    $0x1,%rdx
  6865e5:	74 24                	je     68660b <<gpui_canvas::text::layout::TextGeometry>::stops+0x6b>
  6865e7:	4c 89 d6             	mov    %r10,%rsi
  6865ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  6865f0:	48 89 f3             	mov    %rsi,%rbx
  6865f3:	48 d1 eb             	shr    $1,%rbx
  6865f6:	4c 8d 34 03          	lea    (%rbx,%rax,1),%r14
  6865fa:	47 39 04 f1          	cmp    %r8d,(%r9,%r14,8)
  6865fe:	49 0f 42 c6          	cmovb  %r14,%rax
  686602:	48 29 de             	sub    %rbx,%rsi
  686605:	48 83 fe 01          	cmp    $0x1,%rsi
  686609:	77 e5                	ja     6865f0 <<gpui_canvas::text::layout::TextGeometry>::stops+0x50>
  68660b:	49 8d 34 c1          	lea    (%r9,%rax,8),%rsi
  68660f:	eb 46                	jmp    686657 <<gpui_canvas::text::layout::TextGeometry>::stops+0xb7>
  686611:	48 85 d2             	test   %rdx,%rdx
  686614:	0f 84 23 01 00 00    	je     68673d <<gpui_canvas::text::layout::TextGeometry>::stops+0x19d>
  68661a:	31 c0                	xor    %eax,%eax
  68661c:	48 83 fa 01          	cmp    $0x1,%rdx
  686620:	74 2d                	je     68664f <<gpui_canvas::text::layout::TextGeometry>::stops+0xaf>
  686622:	4c 89 d6             	mov    %r10,%rsi
  686625:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68662c:	00 00 00 00 
  686630:	48 89 f3             	mov    %rsi,%rbx
  686633:	48 d1 eb             	shr    $1,%rbx
  686636:	4c 8d 34 03          	lea    (%rbx,%rax,1),%r14
  68663a:	4f 8d 3c 76          	lea    (%r14,%r14,2),%r15
  68663e:	47 39 04 b9          	cmp    %r8d,(%r9,%r15,4)
  686642:	49 0f 42 c6          	cmovb  %r14,%rax
  686646:	48 29 de             	sub    %rbx,%rsi
  686649:	48 83 fe 01          	cmp    $0x1,%rsi
  68664d:	77 e1                	ja     686630 <<gpui_canvas::text::layout::TextGeometry>::stops+0x90>
  68664f:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  686653:	49 8d 34 b1          	lea    (%r9,%rsi,4),%rsi
  686657:	44 39 06             	cmp    %r8d,(%rsi)
  68665a:	48 83 d0 00          	adc    $0x0,%rax
  68665e:	41 f6 c3 01          	test   $0x1,%r11b
  686662:	75 4e                	jne    6866b2 <<gpui_canvas::text::layout::TextGeometry>::stops+0x112>
  686664:	48 85 d2             	test   %rdx,%rdx
  686667:	0f 84 8a 00 00 00    	je     6866f7 <<gpui_canvas::text::layout::TextGeometry>::stops+0x157>
  68666d:	31 f6                	xor    %esi,%esi
  68666f:	48 83 fa 01          	cmp    $0x1,%rdx
  686673:	74 28                	je     68669d <<gpui_canvas::text::layout::TextGeometry>::stops+0xfd>
  686675:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68667c:	00 00 00 00 
  686680:	49 89 f0             	mov    %rsi,%r8
  686683:	4d 89 d3             	mov    %r10,%r11
  686686:	49 d1 eb             	shr    $1,%r11
  686689:	4c 01 de             	add    %r11,%rsi
  68668c:	41 39 0c f1          	cmp    %ecx,(%r9,%rsi,8)
  686690:	49 0f 47 f0          	cmova  %r8,%rsi
  686694:	4d 29 da             	sub    %r11,%r10
  686697:	49 83 fa 01          	cmp    $0x1,%r10
  68669b:	77 e3                	ja     686680 <<gpui_canvas::text::layout::TextGeometry>::stops+0xe0>
  68669d:	41 3b 0c f1          	cmp    (%r9,%rsi,8),%ecx
  6866a1:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  6866a5:	48 39 c6             	cmp    %rax,%rsi
  6866a8:	72 59                	jb     686703 <<gpui_canvas::text::layout::TextGeometry>::stops+0x163>
  6866aa:	48 89 c1             	mov    %rax,%rcx
  6866ad:	e9 83 00 00 00       	jmp    686735 <<gpui_canvas::text::layout::TextGeometry>::stops+0x195>
  6866b2:	48 85 d2             	test   %rdx,%rdx
  6866b5:	74 5c                	je     686713 <<gpui_canvas::text::layout::TextGeometry>::stops+0x173>
  6866b7:	31 f6                	xor    %esi,%esi
  6866b9:	48 83 fa 01          	cmp    $0x1,%rdx
  6866bd:	74 22                	je     6866e1 <<gpui_canvas::text::layout::TextGeometry>::stops+0x141>
  6866bf:	90                   	nop
  6866c0:	49 89 f0             	mov    %rsi,%r8
  6866c3:	4d 89 d3             	mov    %r10,%r11
  6866c6:	49 d1 eb             	shr    $1,%r11
  6866c9:	4c 01 de             	add    %r11,%rsi
  6866cc:	48 8d 1c 76          	lea    (%rsi,%rsi,2),%rbx
  6866d0:	41 39 0c 99          	cmp    %ecx,(%r9,%rbx,4)
  6866d4:	49 0f 47 f0          	cmova  %r8,%rsi
  6866d8:	4d 29 da             	sub    %r11,%r10
  6866db:	49 83 fa 01          	cmp    $0x1,%r10
  6866df:	77 df                	ja     6866c0 <<gpui_canvas::text::layout::TextGeometry>::stops+0x120>
  6866e1:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  6866e5:	43 3b 0c 81          	cmp    (%r9,%r8,4),%ecx
  6866e9:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  6866ed:	48 39 c6             	cmp    %rax,%rsi
  6866f0:	72 2d                	jb     68671f <<gpui_canvas::text::layout::TextGeometry>::stops+0x17f>
  6866f2:	48 89 c1             	mov    %rax,%rcx
  6866f5:	eb 4c                	jmp    686743 <<gpui_canvas::text::layout::TextGeometry>::stops+0x1a3>
  6866f7:	31 c9                	xor    %ecx,%ecx
  6866f9:	be 00 00 00 00       	mov    $0x0,%esi
  6866fe:	48 85 c0             	test   %rax,%rax
  686701:	74 32                	je     686735 <<gpui_canvas::text::layout::TextGeometry>::stops+0x195>
  686703:	48 8d 0d c6 96 0f 00 	lea    0xf96c6(%rip),%rcx        # 77fdd0 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1c8>
  68670a:	48 89 c7             	mov    %rax,%rdi
  68670d:	ff 15 25 32 10 00    	call   *0x103225(%rip)        # 789938 <_DYNAMIC+0x4d0>
  686713:	31 c9                	xor    %ecx,%ecx
  686715:	be 00 00 00 00       	mov    $0x0,%esi
  68671a:	48 85 c0             	test   %rax,%rax
  68671d:	74 24                	je     686743 <<gpui_canvas::text::layout::TextGeometry>::stops+0x1a3>
  68671f:	48 8d 0d c2 96 0f 00 	lea    0xf96c2(%rip),%rcx        # 77fde8 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1e0>
  686726:	48 89 c7             	mov    %rax,%rdi
  686729:	ff 15 09 32 10 00    	call   *0x103209(%rip)        # 789938 <_DYNAMIC+0x4d0>
  68672f:	48 89 d1             	mov    %rdx,%rcx
  686732:	48 89 d6             	mov    %rdx,%rsi
  686735:	49 8d 04 c9          	lea    (%r9,%rcx,8),%rax
  686739:	31 d2                	xor    %edx,%edx
  68673b:	eb 13                	jmp    686750 <<gpui_canvas::text::layout::TextGeometry>::stops+0x1b0>
  68673d:	48 89 d1             	mov    %rdx,%rcx
  686740:	48 89 d6             	mov    %rdx,%rsi
  686743:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
  686747:	49 8d 04 81          	lea    (%r9,%rax,4),%rax
  68674b:	ba 01 00 00 00       	mov    $0x1,%edx
  686750:	48 29 ce             	sub    %rcx,%rsi
  686753:	48 89 47 08          	mov    %rax,0x8(%rdi)
  686757:	48 89 77 10          	mov    %rsi,0x10(%rdi)
  68675b:	48 89 17             	mov    %rdx,(%rdi)
  68675e:	48 89 f8             	mov    %rdi,%rax
  686761:	5b                   	pop    %rbx
  686762:	41 5e                	pop    %r14
  686764:	41 5f                	pop    %r15
  686766:	c3                   	ret
