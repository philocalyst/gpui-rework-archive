
/tmp/gpui-acknowledged-text-evidence/query-release-baseline/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a26c70 <query_visit_control>:
  a26c70:	55                   	push   %rbp
  a26c71:	41 57                	push   %r15
  a26c73:	41 56                	push   %r14
  a26c75:	41 55                	push   %r13
  a26c77:	41 54                	push   %r12
  a26c79:	53                   	push   %rbx
  a26c7a:	48 83 ec 78          	sub    $0x78,%rsp
  a26c7e:	48 8b 1f             	mov    (%rdi),%rbx
  a26c81:	48 85 db             	test   %rbx,%rbx
  a26c84:	0f 84 eb 00 00 00    	je     a26d75 <query_visit_control+0x105>
  a26c8a:	80 bb 6e 07 00 00 00 	cmpb   $0x0,0x76e(%rbx)
  a26c91:	0f 85 e5 00 00 00    	jne    a26d7c <query_visit_control+0x10c>
  a26c97:	80 bb 6c 07 00 00 01 	cmpb   $0x1,0x76c(%rbx)
  a26c9e:	0f 85 df 00 00 00    	jne    a26d83 <query_visit_control+0x113>
  a26ca4:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  a26ca9:	48 89 de             	mov    %rbx,%rsi
  a26cac:	e8 5f c9 fe ff       	call   a13610 <<gpui::runtime::query::Context>::new::<ack_query_control::Page>>
  a26cb1:	48 8b 83 80 05 00 00 	mov    0x580(%rbx),%rax
  a26cb8:	48 85 c0             	test   %rax,%rax
  a26cbb:	0f 84 93 00 00 00    	je     a26d54 <query_visit_control+0xe4>
  a26cc1:	48 8b 9b 78 05 00 00 	mov    0x578(%rbx),%rbx
  a26cc8:	48 c1 e0 04          	shl    $0x4,%rax
  a26ccc:	4c 8d 24 80          	lea    (%rax,%rax,4),%r12
  a26cd0:	45 31 ff             	xor    %r15d,%r15d
  a26cd3:	4c 8d 74 24 18       	lea    0x18(%rsp),%r14
  a26cd8:	4c 8b 2d e1 10 b0 00 	mov    0xb010e1(%rip),%r13        # 1527dc0 <_DYNAMIC+0x2a8>
  a26cdf:	48 8d 6c 24 08       	lea    0x8(%rsp),%rbp
  a26ce4:	eb 61                	jmp    a26d47 <query_visit_control+0xd7>
  a26ce6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  a26ced:	00 00 00 
  a26cf0:	48 8b 00             	mov    (%rax),%rax
  a26cf3:	48 d1 e8             	shr    $1,%rax
  a26cf6:	f3 0f 6f 43 10       	movdqu 0x10(%rbx),%xmm0
  a26cfb:	0f b6 4b 4d          	movzbl 0x4d(%rbx),%ecx
  a26cff:	49 01 cf             	add    %rcx,%r15
  a26d02:	49 01 c7             	add    %rax,%r15
  a26d05:	66 0f 6f c8          	movdqa %xmm0,%xmm1
  a26d09:	66 0f ef d2          	pxor   %xmm2,%xmm2
  a26d0d:	66 0f 6a ca          	punpckhdq %xmm2,%xmm1
  a26d11:	66 0f 62 c2          	punpckldq %xmm2,%xmm0
  a26d15:	66 0f d4 c1          	paddq  %xmm1,%xmm0
  a26d19:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
  a26d1e:	66 0f d4 c8          	paddq  %xmm0,%xmm1
  a26d22:	66 48 0f 7e c8       	movq   %xmm1,%rax
  a26d27:	49 01 c7             	add    %rax,%r15
  a26d2a:	48 89 df             	mov    %rbx,%rdi
  a26d2d:	4c 89 f6             	mov    %r14,%rsi
  a26d30:	41 ff d5             	call   *%r13
  a26d33:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  a26d38:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  a26d3d:	48 83 c3 50          	add    $0x50,%rbx
  a26d41:	49 83 c4 b0          	add    $0xffffffffffffffb0,%r12
  a26d45:	74 10                	je     a26d57 <query_visit_control+0xe7>
  a26d47:	48 8b 43 28          	mov    0x28(%rbx),%rax
  a26d4b:	48 85 c0             	test   %rax,%rax
  a26d4e:	75 a0                	jne    a26cf0 <query_visit_control+0x80>
  a26d50:	31 c0                	xor    %eax,%eax
  a26d52:	eb a2                	jmp    a26cf6 <query_visit_control+0x86>
  a26d54:	45 31 ff             	xor    %r15d,%r15d
  a26d57:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  a26d5c:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
  a26d61:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  a26d66:	48 83 c4 78          	add    $0x78,%rsp
  a26d6a:	5b                   	pop    %rbx
  a26d6b:	41 5c                	pop    %r12
  a26d6d:	41 5d                	pop    %r13
  a26d6f:	41 5e                	pop    %r14
  a26d71:	41 5f                	pop    %r15
  a26d73:	5d                   	pop    %rbp
  a26d74:	c3                   	ret
  a26d75:	b8 0d 00 00 00       	mov    $0xd,%eax
  a26d7a:	eb 0c                	jmp    a26d88 <query_visit_control+0x118>
  a26d7c:	b8 0e 00 00 00       	mov    $0xe,%eax
  a26d81:	eb 05                	jmp    a26d88 <query_visit_control+0x118>
  a26d83:	b8 12 00 00 00       	mov    $0x12,%eax
  a26d88:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  a26d8d:	48 8d 3d c6 30 77 ff 	lea    -0x88cf3a(%rip),%rdi        # 199e5a <anon.a23595fcc480aa659b9263ff5c71fce0.17.llvm.14522215023961316445+0xf>
  a26d94:	48 8d 0d 4d 09 a9 00 	lea    0xa9094d(%rip),%rcx        # 14b76e8 <anon.a23595fcc480aa659b9263ff5c71fce0.19.llvm.14522215023961316445+0xd8>
  a26d9b:	4c 8d 05 36 0d a9 00 	lea    0xa90d36(%rip),%r8        # 14b7ad8 <anon.a23595fcc480aa659b9263ff5c71fce0.110.llvm.14522215023961316445+0xb8>
  a26da2:	48 8d 54 24 18       	lea    0x18(%rsp),%rdx
  a26da7:	be 2b 00 00 00       	mov    $0x2b,%esi
  a26dac:	ff 15 de 10 b0 00    	call   *0xb010de(%rip)        # 1527e90 <_DYNAMIC+0x378>
  a26db2:	0f 0b                	ud2
  a26db4:	48 89 c3             	mov    %rax,%rbx
  a26db7:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  a26dbc:	e8 af 8d ff ff       	call   a1fb70 <core::ptr::drop_glue::<gpui::runtime::Error>>
  a26dc1:	48 89 df             	mov    %rbx,%rdi
  a26dc4:	e8 77 ba a8 00       	call   14b2840 <_Unwind_Resume@plt>

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .plt:
