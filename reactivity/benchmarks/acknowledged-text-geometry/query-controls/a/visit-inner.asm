
/tmp/gpui-ack-query-comparison/a/client:     file format elf64-x86-64


Disassembly of section .text:

00000000009b23c0 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>>:
  9b23c0:	55                   	push   %rbp
  9b23c1:	41 57                	push   %r15
  9b23c3:	41 56                	push   %r14
  9b23c5:	41 55                	push   %r13
  9b23c7:	41 54                	push   %r12
  9b23c9:	53                   	push   %rbx
  9b23ca:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  9b23d1:	4c 8b 36             	mov    (%rsi),%r14
  9b23d4:	4d 85 f6             	test   %r14,%r14
  9b23d7:	0f 84 ec 00 00 00    	je     9b24c9 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x109>
  9b23dd:	b8 0e 00 00 00       	mov    $0xe,%eax
  9b23e2:	41 80 be 2e 07 00 00 	cmpb   $0x0,0x72e(%r14)
  9b23e9:	00 
  9b23ea:	0f 85 d4 00 00 00    	jne    9b24c4 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x104>
  9b23f0:	b8 12 00 00 00       	mov    $0x12,%eax
  9b23f5:	41 80 be 2c 07 00 00 	cmpb   $0x1,0x72c(%r14)
  9b23fc:	01 
  9b23fd:	0f 85 c1 00 00 00    	jne    9b24c4 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x104>
  9b2403:	48 89 d3             	mov    %rdx,%rbx
  9b2406:	48 89 3c 24          	mov    %rdi,(%rsp)
  9b240a:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  9b240f:	4c 89 f6             	mov    %r14,%rsi
  9b2412:	e8 09 ca 05 00       	call   a0ee20 <<gpui::runtime::query::Context>::new::<ack_query_control::Page>>
  9b2417:	49 8b ae 80 05 00 00 	mov    0x580(%r14),%rbp
  9b241e:	48 85 ed             	test   %rbp,%rbp
  9b2421:	0f 84 ab 00 00 00    	je     9b24d2 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x112>
  9b2427:	4c 8b 2b             	mov    (%rbx),%r13
  9b242a:	4c 8b 64 24 48       	mov    0x48(%rsp),%r12
  9b242f:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  9b2434:	45 31 ff             	xor    %r15d,%r15d
  9b2437:	eb 6d                	jmp    9b24a6 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0xe6>
  9b2439:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  9b2440:	48 8b 09             	mov    (%rcx),%rcx
  9b2443:	48 d1 e9             	shr    $1,%rcx
  9b2446:	f3 41 0f 6f 44 04 10 	movdqu 0x10(%r12,%rax,1),%xmm0
  9b244d:	41 0f b6 44 04 4d    	movzbl 0x4d(%r12,%rax,1),%eax
  9b2453:	49 01 c5             	add    %rax,%r13
  9b2456:	49 01 cd             	add    %rcx,%r13
  9b2459:	66 0f 6f c8          	movdqa %xmm0,%xmm1
  9b245d:	66 0f ef d2          	pxor   %xmm2,%xmm2
  9b2461:	66 0f 6a ca          	punpckhdq %xmm2,%xmm1
  9b2465:	66 0f 62 c2          	punpckldq %xmm2,%xmm0
  9b2469:	66 0f d4 c1          	paddq  %xmm1,%xmm0
  9b246d:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
  9b2472:	66 0f d4 c8          	paddq  %xmm0,%xmm1
  9b2476:	66 48 0f 7e c8       	movq   %xmm1,%rax
  9b247b:	49 01 c5             	add    %rax,%r13
  9b247e:	4c 89 2b             	mov    %r13,(%rbx)
  9b2481:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  9b2486:	44 89 fe             	mov    %r15d,%esi
  9b2489:	ff 15 b9 d9 b7 00    	call   *0xb7d9b9(%rip)        # 152fe48 <_DYNAMIC+0x2a8>
  9b248f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  9b2494:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  9b2499:	48 8d 44 24 08       	lea    0x8(%rsp),%rax
  9b249e:	49 ff c7             	inc    %r15
  9b24a1:	4c 39 fd             	cmp    %r15,%rbp
  9b24a4:	74 2c                	je     9b24d2 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x112>
  9b24a6:	44 89 ff             	mov    %r15d,%edi
  9b24a9:	49 39 fe             	cmp    %rdi,%r14
  9b24ac:	76 44                	jbe    9b24f2 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x132>
  9b24ae:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  9b24b2:	48 c1 e0 04          	shl    $0x4,%rax
  9b24b6:	49 8b 4c 04 28       	mov    0x28(%r12,%rax,1),%rcx
  9b24bb:	48 85 c9             	test   %rcx,%rcx
  9b24be:	75 80                	jne    9b2440 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x80>
  9b24c0:	31 c9                	xor    %ecx,%ecx
  9b24c2:	eb 82                	jmp    9b2446 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x86>
  9b24c4:	48 89 07             	mov    %rax,(%rdi)
  9b24c7:	eb 14                	jmp    9b24dd <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x11d>
  9b24c9:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  9b24d0:	eb 0b                	jmp    9b24dd <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x11d>
  9b24d2:	48 8b 3c 24          	mov    (%rsp),%rdi
  9b24d6:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  9b24dd:	48 89 f8             	mov    %rdi,%rax
  9b24e0:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  9b24e7:	5b                   	pop    %rbx
  9b24e8:	41 5c                	pop    %r12
  9b24ea:	41 5d                	pop    %r13
  9b24ec:	41 5e                	pop    %r14
  9b24ee:	41 5f                	pop    %r15
  9b24f0:	5d                   	pop    %rbp
  9b24f1:	c3                   	ret
  9b24f2:	48 8d 15 97 97 b0 00 	lea    0xb09797(%rip),%rdx        # 14bbc90 <anon.4f30a6cd6a480c72024200c3c0ce5643.6.llvm.7025785412757978569>
  9b24f9:	4c 89 f6             	mov    %r14,%rsi
  9b24fc:	ff 15 4e d9 b7 00    	call   *0xb7d94e(%rip)        # 152fe50 <_DYNAMIC+0x2b0>
