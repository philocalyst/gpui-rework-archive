
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006625e0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection>:
  6625e0:	41 57                	push   %r15
  6625e2:	41 56                	push   %r14
  6625e4:	41 55                	push   %r13
  6625e6:	41 54                	push   %r12
  6625e8:	53                   	push   %rbx
  6625e9:	48 83 ec 20          	sub    $0x20,%rsp
  6625ed:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  6625f2:	0f 84 54 01 00 00    	je     66274c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x16c>
  6625f8:	8b 06                	mov    (%rsi),%eax
  6625fa:	0f b6 4e 04          	movzbl 0x4(%rsi),%ecx
  6625fe:	4c 8b 77 38          	mov    0x38(%rdi),%r14
  662602:	4c 8b 7f 40          	mov    0x40(%rdi),%r15
  662606:	4c 89 fa             	mov    %r15,%rdx
  662609:	4d 85 ff             	test   %r15,%r15
  66260c:	74 3d                	je     66264b <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x6b>
  66260e:	31 d2                	xor    %edx,%edx
  662610:	49 83 ff 01          	cmp    $0x1,%r15
  662614:	74 29                	je     66263f <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x5f>
  662616:	4d 89 f8             	mov    %r15,%r8
  662619:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  662620:	4d 89 c1             	mov    %r8,%r9
  662623:	49 d1 e9             	shr    $1,%r9
  662626:	4d 8d 14 11          	lea    (%r9,%rdx,1),%r10
  66262a:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  66262e:	43 39 04 9e          	cmp    %eax,(%r14,%r11,4)
  662632:	49 0f 42 d2          	cmovb  %r10,%rdx
  662636:	4d 29 c8             	sub    %r9,%r8
  662639:	49 83 f8 01          	cmp    $0x1,%r8
  66263d:	77 e1                	ja     662620 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x40>
  66263f:	4c 8d 04 52          	lea    (%rdx,%rdx,2),%r8
  662643:	43 39 04 86          	cmp    %eax,(%r14,%r8,4)
  662647:	48 83 d2 00          	adc    $0x0,%rdx
  66264b:	fe c1                	inc    %cl
  66264d:	48 c1 e2 02          	shl    $0x2,%rdx
  662651:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  662655:	4d 8d 04 16          	lea    (%r14,%rdx,1),%r8
  662659:	49 83 c0 f4          	add    $0xfffffffffffffff4,%r8
  66265d:	4e 8d 0c bd 00 00 00 	lea    0x0(,%r15,4),%r9
  662664:	00 
  662665:	4f 8d 24 49          	lea    (%r9,%r9,2),%r12
  662669:	4d 89 e1             	mov    %r12,%r9
  66266c:	49 29 d1             	sub    %rdx,%r9
  66266f:	90                   	nop
  662670:	4d 85 c9             	test   %r9,%r9
  662673:	0f 84 d3 00 00 00    	je     66274c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x16c>
  662679:	41 39 40 0c          	cmp    %eax,0xc(%r8)
  66267d:	0f 85 c9 00 00 00    	jne    66274c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x16c>
  662683:	49 8d 50 0c          	lea    0xc(%r8),%rdx
  662687:	49 83 c1 f4          	add    $0xfffffffffffffff4,%r9
  66268b:	41 84 48 14          	test   %cl,0x14(%r8)
  66268f:	49 89 d0             	mov    %rdx,%r8
  662692:	74 dc                	je     662670 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x90>
  662694:	48 8d 44 24 10       	lea    0x10(%rsp),%rax
  662699:	48 89 f9             	mov    %rdi,%rcx
  66269c:	48 89 c7             	mov    %rax,%rdi
  66269f:	48 89 cb             	mov    %rcx,%rbx
  6626a2:	49 89 f5             	mov    %rsi,%r13
  6626a5:	48 89 ce             	mov    %rcx,%rsi
  6626a8:	ff 15 9a 4f 12 00    	call   *0x124f9a(%rip)        # 787648 <_DYNAMIC+0x398>
  6626ae:	41 8b 45 08          	mov    0x8(%r13),%eax
  6626b2:	41 0f b6 4d 0c       	movzbl 0xc(%r13),%ecx
  6626b7:	4d 85 ff             	test   %r15,%r15
  6626ba:	74 42                	je     6626fe <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x11e>
  6626bc:	31 d2                	xor    %edx,%edx
  6626be:	49 83 ff 01          	cmp    $0x1,%r15
  6626c2:	74 2b                	je     6626ef <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x10f>
  6626c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6626cb:	00 00 00 00 00 
  6626d0:	4c 89 fe             	mov    %r15,%rsi
  6626d3:	48 d1 ee             	shr    $1,%rsi
  6626d6:	48 8d 3c 16          	lea    (%rsi,%rdx,1),%rdi
  6626da:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  6626de:	43 39 04 86          	cmp    %eax,(%r14,%r8,4)
  6626e2:	48 0f 42 d7          	cmovb  %rdi,%rdx
  6626e6:	49 29 f7             	sub    %rsi,%r15
  6626e9:	49 83 ff 01          	cmp    $0x1,%r15
  6626ed:	77 e1                	ja     6626d0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0xf0>
  6626ef:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  6626f3:	41 39 04 b6          	cmp    %eax,(%r14,%rsi,4)
  6626f7:	48 83 d2 00          	adc    $0x0,%rdx
  6626fb:	49 89 d7             	mov    %rdx,%r15
  6626fe:	fe c1                	inc    %cl
  662700:	49 c1 e7 02          	shl    $0x2,%r15
  662704:	4b 8d 14 7f          	lea    (%r15,%r15,2),%rdx
  662708:	49 8d 34 16          	lea    (%r14,%rdx,1),%rsi
  66270c:	48 83 c6 f4          	add    $0xfffffffffffffff4,%rsi
  662710:	49 29 d4             	sub    %rdx,%r12
  662713:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66271a:	84 00 00 00 00 00 
  662720:	4d 85 e4             	test   %r12,%r12
  662723:	74 27                	je     66274c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x16c>
  662725:	39 46 0c             	cmp    %eax,0xc(%rsi)
  662728:	75 22                	jne    66274c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x16c>
  66272a:	48 8d 56 0c          	lea    0xc(%rsi),%rdx
  66272e:	49 83 c4 f4          	add    $0xfffffffffffffff4,%r12
  662732:	84 4e 14             	test   %cl,0x14(%rsi)
  662735:	48 89 d6             	mov    %rdx,%rsi
  662738:	74 e6                	je     662720 <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x140>
  66273a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  66273f:	48 89 de             	mov    %rbx,%rsi
  662742:	ff 15 00 4f 12 00    	call   *0x124f00(%rip)        # 787648 <_DYNAMIC+0x398>
  662748:	b0 01                	mov    $0x1,%al
  66274a:	eb 02                	jmp    66274e <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x16e>
  66274c:	31 c0                	xor    %eax,%eax
  66274e:	48 83 c4 20          	add    $0x20,%rsp
  662752:	5b                   	pop    %rbx
  662753:	41 5c                	pop    %r12
  662755:	41 5d                	pop    %r13
  662757:	41 5e                	pop    %r14
  662759:	41 5f                	pop    %r15
  66275b:	c3                   	ret
