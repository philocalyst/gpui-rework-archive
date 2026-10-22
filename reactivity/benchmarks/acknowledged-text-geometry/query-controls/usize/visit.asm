
/tmp/gpui-ack-query-comparison/usize/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a272b0 <query_visit_control>:
  a272b0:	55                   	push   %rbp
  a272b1:	41 57                	push   %r15
  a272b3:	41 56                	push   %r14
  a272b5:	41 55                	push   %r13
  a272b7:	41 54                	push   %r12
  a272b9:	53                   	push   %rbx
  a272ba:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  a272c1:	48 8b 37             	mov    (%rdi),%rsi
  a272c4:	48 85 f6             	test   %rsi,%rsi
  a272c7:	0f 84 e0 00 00 00    	je     a273ad <query_visit_control+0xfd>
  a272cd:	80 be 2e 07 00 00 00 	cmpb   $0x0,0x72e(%rsi)
  a272d4:	0f 85 da 00 00 00    	jne    a273b4 <query_visit_control+0x104>
  a272da:	80 be 2c 07 00 00 01 	cmpb   $0x1,0x72c(%rsi)
  a272e1:	0f 85 d4 00 00 00    	jne    a273bb <query_visit_control+0x10b>
  a272e7:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  a272ec:	e8 5f cb fe ff       	call   a13e50 <<gpui::runtime::query::Context>::new::<ack_query_control::Page>>
  a272f1:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  a272f6:	4d 85 f6             	test   %r14,%r14
  a272f9:	0f 84 8a 00 00 00    	je     a27389 <query_visit_control+0xd9>
  a272ff:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  a27304:	4c 8b 64 24 48       	mov    0x48(%rsp),%r12
  a27309:	49 83 c4 10          	add    $0x10,%r12
  a2730d:	45 31 ff             	xor    %r15d,%r15d
  a27310:	4c 8b 2d b1 86 b0 00 	mov    0xb086b1(%rip),%r13        # 152f9c8 <_DYNAMIC+0x2a8>
  a27317:	48 8d 6c 24 08       	lea    0x8(%rsp),%rbp
  a2731c:	eb 5d                	jmp    a2737b <query_visit_control+0xcb>
  a2731e:	66 90                	xchg   %ax,%ax
  a27320:	48 8b 00             	mov    (%rax),%rax
  a27323:	48 d1 e8             	shr    $1,%rax
  a27326:	f3 41 0f 6f 04 24    	movdqu (%r12),%xmm0
  a2732c:	41 0f b6 4c 24 3d    	movzbl 0x3d(%r12),%ecx
  a27332:	49 01 cf             	add    %rcx,%r15
  a27335:	49 01 c7             	add    %rax,%r15
  a27338:	66 0f 6f c8          	movdqa %xmm0,%xmm1
  a2733c:	66 0f ef d2          	pxor   %xmm2,%xmm2
  a27340:	66 0f 6a ca          	punpckhdq %xmm2,%xmm1
  a27344:	66 0f 62 c2          	punpckldq %xmm2,%xmm0
  a27348:	66 0f d4 c1          	paddq  %xmm1,%xmm0
  a2734c:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
  a27351:	66 0f d4 c8          	paddq  %xmm0,%xmm1
  a27355:	66 48 0f 7e c8       	movq   %xmm1,%rax
  a2735a:	49 01 c7             	add    %rax,%r15
  a2735d:	49 8b 74 24 10       	mov    0x10(%r12),%rsi
  a27362:	48 89 df             	mov    %rbx,%rdi
  a27365:	41 ff d5             	call   *%r13
  a27368:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  a2736d:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  a27372:	49 83 c4 50          	add    $0x50,%r12
  a27376:	49 ff ce             	dec    %r14
  a27379:	74 11                	je     a2738c <query_visit_control+0xdc>
  a2737b:	49 8b 44 24 18       	mov    0x18(%r12),%rax
  a27380:	48 85 c0             	test   %rax,%rax
  a27383:	75 9b                	jne    a27320 <query_visit_control+0x70>
  a27385:	31 c0                	xor    %eax,%eax
  a27387:	eb 9d                	jmp    a27326 <query_visit_control+0x76>
  a27389:	45 31 ff             	xor    %r15d,%r15d
  a2738c:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  a27391:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
  a27396:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  a2739b:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  a273a2:	5b                   	pop    %rbx
  a273a3:	41 5c                	pop    %r12
  a273a5:	41 5d                	pop    %r13
  a273a7:	41 5e                	pop    %r14
  a273a9:	41 5f                	pop    %r15
  a273ab:	5d                   	pop    %rbp
  a273ac:	c3                   	ret
  a273ad:	b8 0d 00 00 00       	mov    $0xd,%eax
  a273b2:	eb 0c                	jmp    a273c0 <query_visit_control+0x110>
  a273b4:	b8 0e 00 00 00       	mov    $0xe,%eax
  a273b9:	eb 05                	jmp    a273c0 <query_visit_control+0x110>
  a273bb:	b8 12 00 00 00       	mov    $0x12,%eax
  a273c0:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  a273c5:	48 8d 3d 66 37 77 ff 	lea    -0x88c89a(%rip),%rdi        # 19ab32 <anon.190f1985feed7bbc93ff012c981e677f.17.llvm.15481281055357035939+0xf>
  a273cc:	48 8d 0d fd 77 a9 00 	lea    0xa977fd(%rip),%rcx        # 14bebd0 <anon.190f1985feed7bbc93ff012c981e677f.19.llvm.15481281055357035939+0xd8>
  a273d3:	4c 8d 05 b6 7b a9 00 	lea    0xa97bb6(%rip),%r8        # 14bef90 <anon.190f1985feed7bbc93ff012c981e677f.118.llvm.15481281055357035939+0x118>
  a273da:	48 8d 54 24 18       	lea    0x18(%rsp),%rdx
  a273df:	be 2b 00 00 00       	mov    $0x2b,%esi
  a273e4:	ff 15 b6 86 b0 00    	call   *0xb086b6(%rip)        # 152faa0 <_DYNAMIC+0x380>
  a273ea:	0f 0b                	ud2
  a273ec:	48 89 c3             	mov    %rax,%rbx
  a273ef:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  a273f4:	e8 07 8b ff ff       	call   a1ff00 <core::ptr::drop_glue::<gpui::runtime::Error>>
  a273f9:	48 89 df             	mov    %rbx,%rdi
  a273fc:	e8 6f 2e a9 00       	call   14ba270 <_Unwind_Resume@plt>
