
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000683c80 <<gpui_canvas::text::layout::Stops>::slice>:
  683c80:	50                   	push   %rax
  683c81:	48 8b 46 10          	mov    0x10(%rsi),%rax
  683c85:	49 89 c8             	mov    %rcx,%r8
  683c88:	49 29 d0             	sub    %rdx,%r8
  683c8b:	41 0f 92 c2          	setb   %r10b
  683c8f:	48 39 c1             	cmp    %rax,%rcx
  683c92:	41 0f 97 c1          	seta   %r9b
  683c96:	45 08 d1             	or     %r10b,%r9b
  683c99:	83 3e 01             	cmpl   $0x1,(%rsi)
  683c9c:	75 18                	jne    683cb6 <<gpui_canvas::text::layout::Stops>::slice+0x36>
  683c9e:	45 84 c9             	test   %r9b,%r9b
  683ca1:	75 32                	jne    683cd5 <<gpui_canvas::text::layout::Stops>::slice+0x55>
  683ca3:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  683ca7:	48 c1 e2 02          	shl    $0x2,%rdx
  683cab:	48 03 56 08          	add    0x8(%rsi),%rdx
  683caf:	b8 01 00 00 00       	mov    $0x1,%eax
  683cb4:	eb 0f                	jmp    683cc5 <<gpui_canvas::text::layout::Stops>::slice+0x45>
  683cb6:	45 84 c9             	test   %r9b,%r9b
  683cb9:	75 23                	jne    683cde <<gpui_canvas::text::layout::Stops>::slice+0x5e>
  683cbb:	48 c1 e2 03          	shl    $0x3,%rdx
  683cbf:	48 03 56 08          	add    0x8(%rsi),%rdx
  683cc3:	31 c0                	xor    %eax,%eax
  683cc5:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  683cc9:	4c 89 47 10          	mov    %r8,0x10(%rdi)
  683ccd:	48 89 07             	mov    %rax,(%rdi)
  683cd0:	48 89 f8             	mov    %rdi,%rax
  683cd3:	59                   	pop    %rcx
  683cd4:	c3                   	ret
  683cd5:	4c 8d 05 0c c1 0f 00 	lea    0xfc10c(%rip),%r8        # 77fde8 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1e0>
  683cdc:	eb 07                	jmp    683ce5 <<gpui_canvas::text::layout::Stops>::slice+0x65>
  683cde:	4c 8d 05 eb c0 0f 00 	lea    0xfc0eb(%rip),%r8        # 77fdd0 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1c8>
  683ce5:	48 89 d7             	mov    %rdx,%rdi
  683ce8:	48 89 ce             	mov    %rcx,%rsi
  683ceb:	48 89 c2             	mov    %rax,%rdx
  683cee:	4c 89 c1             	mov    %r8,%rcx
  683cf1:	ff 15 41 5c 10 00    	call   *0x105c41(%rip)        # 789938 <_DYNAMIC+0x4d0>
