
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006840c0 <<gpui_canvas::text::layout::TextGeometry>::validates_selection>:
  6840c0:	41 56                	push   %r14
  6840c2:	53                   	push   %rbx
  6840c3:	48 83 ec 18          	sub    $0x18,%rsp
  6840c7:	49 89 f6             	mov    %rsi,%r14
  6840ca:	48 89 fb             	mov    %rdi,%rbx
  6840cd:	8b 16                	mov    (%rsi),%edx
  6840cf:	0f b6 4e 04          	movzbl 0x4(%rsi),%ecx
  6840d3:	48 8d 7c 24 04       	lea    0x4(%rsp),%rdi
  6840d8:	48 89 de             	mov    %rbx,%rsi
  6840db:	ff 15 f7 58 10 00    	call   *0x1058f7(%rip)        # 7899d8 <_DYNAMIC+0x570>
  6840e1:	83 7c 24 04 00       	cmpl   $0x0,0x4(%rsp)
  6840e6:	74 24                	je     68410c <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x4c>
  6840e8:	41 8b 56 08          	mov    0x8(%r14),%edx
  6840ec:	41 0f b6 4e 0c       	movzbl 0xc(%r14),%ecx
  6840f1:	48 8d 7c 24 04       	lea    0x4(%rsp),%rdi
  6840f6:	48 89 de             	mov    %rbx,%rsi
  6840f9:	ff 15 d9 58 10 00    	call   *0x1058d9(%rip)        # 7899d8 <_DYNAMIC+0x570>
  6840ff:	0f b6 44 24 04       	movzbl 0x4(%rsp),%eax
  684104:	48 83 c4 18          	add    $0x18,%rsp
  684108:	5b                   	pop    %rbx
  684109:	41 5e                	pop    %r14
  68410b:	c3                   	ret
  68410c:	31 c0                	xor    %eax,%eax
  68410e:	48 83 c4 18          	add    $0x18,%rsp
  684112:	5b                   	pop    %rbx
  684113:	41 5e                	pop    %r14
  684115:	c3                   	ret
