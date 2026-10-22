
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067d8c0 <<gpui_canvas::text::layout::Stops>::slice>:
  67d8c0:	50                   	push   %rax
  67d8c1:	48 8b 46 10          	mov    0x10(%rsi),%rax
  67d8c5:	49 89 c8             	mov    %rcx,%r8
  67d8c8:	49 29 d0             	sub    %rdx,%r8
  67d8cb:	41 0f 92 c2          	setb   %r10b
  67d8cf:	48 39 c1             	cmp    %rax,%rcx
  67d8d2:	41 0f 97 c1          	seta   %r9b
  67d8d6:	45 08 d1             	or     %r10b,%r9b
  67d8d9:	83 3e 01             	cmpl   $0x1,(%rsi)
  67d8dc:	75 18                	jne    67d8f6 <<gpui_canvas::text::layout::Stops>::slice+0x36>
  67d8de:	45 84 c9             	test   %r9b,%r9b
  67d8e1:	75 32                	jne    67d915 <<gpui_canvas::text::layout::Stops>::slice+0x55>
  67d8e3:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  67d8e7:	48 c1 e2 02          	shl    $0x2,%rdx
  67d8eb:	48 03 56 08          	add    0x8(%rsi),%rdx
  67d8ef:	b8 01 00 00 00       	mov    $0x1,%eax
  67d8f4:	eb 0f                	jmp    67d905 <<gpui_canvas::text::layout::Stops>::slice+0x45>
  67d8f6:	45 84 c9             	test   %r9b,%r9b
  67d8f9:	75 23                	jne    67d91e <<gpui_canvas::text::layout::Stops>::slice+0x5e>
  67d8fb:	48 c1 e2 03          	shl    $0x3,%rdx
  67d8ff:	48 03 56 08          	add    0x8(%rsi),%rdx
  67d903:	31 c0                	xor    %eax,%eax
  67d905:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  67d909:	4c 89 47 10          	mov    %r8,0x10(%rdi)
  67d90d:	48 89 07             	mov    %rax,(%rdi)
  67d910:	48 89 f8             	mov    %rdi,%rax
  67d913:	59                   	pop    %rcx
  67d914:	c3                   	ret
  67d915:	4c 8d 05 14 1e 10 00 	lea    0x101e14(%rip),%r8        # 77f730 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xd8>
  67d91c:	eb 07                	jmp    67d925 <<gpui_canvas::text::layout::Stops>::slice+0x65>
  67d91e:	4c 8d 05 f3 1d 10 00 	lea    0x101df3(%rip),%r8        # 77f718 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xc0>
  67d925:	48 89 d7             	mov    %rdx,%rdi
  67d928:	48 89 ce             	mov    %rcx,%rsi
  67d92b:	48 89 c2             	mov    %rax,%rdx
  67d92e:	4c 89 c1             	mov    %r8,%rcx
  67d931:	ff 15 b9 bf 10 00    	call   *0x10bfb9(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
