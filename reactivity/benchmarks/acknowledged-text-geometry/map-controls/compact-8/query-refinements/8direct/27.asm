
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000686c00 <<gpui_canvas::text::layout::CaretBuilder>::freeze>:
  686c00:	41 57                	push   %r15
  686c02:	41 56                	push   %r14
  686c04:	41 55                	push   %r13
  686c06:	41 54                	push   %r12
  686c08:	53                   	push   %rbx
  686c09:	49 89 ff             	mov    %rdi,%r15
  686c0c:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  686c10:	48 8b 5e 10          	mov    0x10(%rsi),%rbx
  686c14:	4c 8b 6e 18          	mov    0x18(%rsi),%r13
  686c18:	83 3e 01             	cmpl   $0x1,(%rsi)
  686c1b:	75 4c                	jne    686c69 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0x69>
  686c1d:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  686c23:	4d 39 ee             	cmp    %r13,%r14
  686c26:	0f 86 92 00 00 00    	jbe    686cbe <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xbe>
  686c2c:	49 c1 e6 02          	shl    $0x2,%r14
  686c30:	4f 8d 34 76          	lea    (%r14,%r14,2),%r14
  686c34:	4d 85 ed             	test   %r13,%r13
  686c37:	74 6f                	je     686ca8 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xa8>
  686c39:	4a 8d 04 ad 00 00 00 	lea    0x0(,%r13,4),%rax
  686c40:	00 
  686c41:	4c 8d 24 40          	lea    (%rax,%rax,2),%r12
  686c45:	ba 04 00 00 00       	mov    $0x4,%edx
  686c4a:	48 89 df             	mov    %rbx,%rdi
  686c4d:	4c 89 f6             	mov    %r14,%rsi
  686c50:	4c 89 e1             	mov    %r12,%rcx
  686c53:	ff 15 8f 2b 10 00    	call   *0x102b8f(%rip)        # 7897e8 <_DYNAMIC+0x380>
  686c59:	48 85 c0             	test   %rax,%rax
  686c5c:	74 78                	je     686cd6 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xd6>
  686c5e:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  686c64:	48 89 c3             	mov    %rax,%rbx
  686c67:	eb 55                	jmp    686cbe <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xbe>
  686c69:	4d 39 ee             	cmp    %r13,%r14
  686c6c:	76 32                	jbe    686ca0 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xa0>
  686c6e:	49 c1 e6 03          	shl    $0x3,%r14
  686c72:	4d 85 ed             	test   %r13,%r13
  686c75:	74 2e                	je     686ca5 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xa5>
  686c77:	4e 8d 24 ed 00 00 00 	lea    0x0(,%r13,8),%r12
  686c7e:	00 
  686c7f:	ba 04 00 00 00       	mov    $0x4,%edx
  686c84:	48 89 df             	mov    %rbx,%rdi
  686c87:	4c 89 f6             	mov    %r14,%rsi
  686c8a:	4c 89 e1             	mov    %r12,%rcx
  686c8d:	ff 15 55 2b 10 00    	call   *0x102b55(%rip)        # 7897e8 <_DYNAMIC+0x380>
  686c93:	48 85 c0             	test   %rax,%rax
  686c96:	74 4e                	je     686ce6 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xe6>
  686c98:	45 31 e4             	xor    %r12d,%r12d
  686c9b:	48 89 c3             	mov    %rax,%rbx
  686c9e:	eb 1e                	jmp    686cbe <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xbe>
  686ca0:	45 31 e4             	xor    %r12d,%r12d
  686ca3:	eb 19                	jmp    686cbe <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xbe>
  686ca5:	45 31 e4             	xor    %r12d,%r12d
  686ca8:	ba 04 00 00 00       	mov    $0x4,%edx
  686cad:	48 89 df             	mov    %rbx,%rdi
  686cb0:	4c 89 f6             	mov    %r14,%rsi
  686cb3:	ff 15 f7 29 10 00    	call   *0x1029f7(%rip)        # 7896b0 <_DYNAMIC+0x248>
  686cb9:	bb 04 00 00 00       	mov    $0x4,%ebx
  686cbe:	49 89 5f 08          	mov    %rbx,0x8(%r15)
  686cc2:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  686cc6:	4d 89 27             	mov    %r12,(%r15)
  686cc9:	4c 89 f8             	mov    %r15,%rax
  686ccc:	5b                   	pop    %rbx
  686ccd:	41 5c                	pop    %r12
  686ccf:	41 5d                	pop    %r13
  686cd1:	41 5e                	pop    %r14
  686cd3:	41 5f                	pop    %r15
  686cd5:	c3                   	ret
  686cd6:	bf 04 00 00 00       	mov    $0x4,%edi
  686cdb:	4c 89 e6             	mov    %r12,%rsi
  686cde:	ff 15 fc 2a 10 00    	call   *0x102afc(%rip)        # 7897e0 <_DYNAMIC+0x378>
  686ce4:	eb 0e                	jmp    686cf4 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xf4>
  686ce6:	bf 04 00 00 00       	mov    $0x4,%edi
  686ceb:	4c 89 e6             	mov    %r12,%rsi
  686cee:	ff 15 ec 2a 10 00    	call   *0x102aec(%rip)        # 7897e0 <_DYNAMIC+0x378>
  686cf4:	0f 0b                	ud2
  686cf6:	eb 00                	jmp    686cf8 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xf8>
  686cf8:	49 89 c7             	mov    %rax,%r15
  686cfb:	ba 04 00 00 00       	mov    $0x4,%edx
  686d00:	48 89 df             	mov    %rbx,%rdi
  686d03:	4c 89 f6             	mov    %r14,%rsi
  686d06:	ff 15 a4 29 10 00    	call   *0x1029a4(%rip)        # 7896b0 <_DYNAMIC+0x248>
  686d0c:	4c 89 ff             	mov    %r15,%rdi
  686d0f:	e8 6c 6a 0f 00       	call   77d780 <_Unwind_Resume@plt>
