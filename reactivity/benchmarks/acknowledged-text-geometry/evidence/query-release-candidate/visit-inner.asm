
/tmp/gpui-acknowledged-text-evidence/query-release-candidate/client:     file format elf64-x86-64


Disassembly of section .text:

00000000009b2330 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>>:
  9b2330:	55                   	push   %rbp
  9b2331:	41 57                	push   %r15
  9b2333:	41 56                	push   %r14
  9b2335:	41 55                	push   %r13
  9b2337:	41 54                	push   %r12
  9b2339:	53                   	push   %rbx
  9b233a:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  9b2341:	4c 8b 36             	mov    (%rsi),%r14
  9b2344:	4d 85 f6             	test   %r14,%r14
  9b2347:	0f 84 ec 00 00 00    	je     9b2439 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x109>
  9b234d:	b8 0e 00 00 00       	mov    $0xe,%eax
  9b2352:	41 80 be 2e 07 00 00 	cmpb   $0x0,0x72e(%r14)
  9b2359:	00 
  9b235a:	0f 85 d4 00 00 00    	jne    9b2434 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x104>
  9b2360:	b8 12 00 00 00       	mov    $0x12,%eax
  9b2365:	41 80 be 2c 07 00 00 	cmpb   $0x1,0x72c(%r14)
  9b236c:	01 
  9b236d:	0f 85 c1 00 00 00    	jne    9b2434 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x104>
  9b2373:	48 89 d3             	mov    %rdx,%rbx
  9b2376:	48 89 3c 24          	mov    %rdi,(%rsp)
  9b237a:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  9b237f:	4c 89 f6             	mov    %r14,%rsi
  9b2382:	e8 c9 31 05 00       	call   a05550 <<gpui::runtime::query::Context>::new::<ack_query_control::Page>>
  9b2387:	49 8b ae 80 05 00 00 	mov    0x580(%r14),%rbp
  9b238e:	48 85 ed             	test   %rbp,%rbp
  9b2391:	0f 84 ab 00 00 00    	je     9b2442 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x112>
  9b2397:	4c 8b 2b             	mov    (%rbx),%r13
  9b239a:	4c 8b 64 24 48       	mov    0x48(%rsp),%r12
  9b239f:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  9b23a4:	45 31 ff             	xor    %r15d,%r15d
  9b23a7:	eb 6d                	jmp    9b2416 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0xe6>
  9b23a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  9b23b0:	48 8b 09             	mov    (%rcx),%rcx
  9b23b3:	48 d1 e9             	shr    $1,%rcx
  9b23b6:	f3 41 0f 6f 44 04 10 	movdqu 0x10(%r12,%rax,1),%xmm0
  9b23bd:	41 0f b6 44 04 4d    	movzbl 0x4d(%r12,%rax,1),%eax
  9b23c3:	49 01 c5             	add    %rax,%r13
  9b23c6:	49 01 cd             	add    %rcx,%r13
  9b23c9:	66 0f 6f c8          	movdqa %xmm0,%xmm1
  9b23cd:	66 0f ef d2          	pxor   %xmm2,%xmm2
  9b23d1:	66 0f 6a ca          	punpckhdq %xmm2,%xmm1
  9b23d5:	66 0f 62 c2          	punpckldq %xmm2,%xmm0
  9b23d9:	66 0f d4 c1          	paddq  %xmm1,%xmm0
  9b23dd:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
  9b23e2:	66 0f d4 c8          	paddq  %xmm0,%xmm1
  9b23e6:	66 48 0f 7e c8       	movq   %xmm1,%rax
  9b23eb:	49 01 c5             	add    %rax,%r13
  9b23ee:	4c 89 2b             	mov    %r13,(%rbx)
  9b23f1:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  9b23f6:	44 89 fe             	mov    %r15d,%esi
  9b23f9:	ff 15 21 d0 b7 00    	call   *0xb7d021(%rip)        # 152f420 <_DYNAMIC+0x2a8>
  9b23ff:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  9b2404:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  9b2409:	48 8d 44 24 08       	lea    0x8(%rsp),%rax
  9b240e:	49 ff c7             	inc    %r15
  9b2411:	4c 39 fd             	cmp    %r15,%rbp
  9b2414:	74 2c                	je     9b2442 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x112>
  9b2416:	44 89 ff             	mov    %r15d,%edi
  9b2419:	49 39 fe             	cmp    %rdi,%r14
  9b241c:	76 44                	jbe    9b2462 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x132>
  9b241e:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  9b2422:	48 c1 e0 04          	shl    $0x4,%rax
  9b2426:	49 8b 4c 04 28       	mov    0x28(%r12,%rax,1),%rcx
  9b242b:	48 85 c9             	test   %rcx,%rcx
  9b242e:	75 80                	jne    9b23b0 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x80>
  9b2430:	31 c9                	xor    %ecx,%ecx
  9b2432:	eb 82                	jmp    9b23b6 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x86>
  9b2434:	48 89 07             	mov    %rax,(%rdi)
  9b2437:	eb 14                	jmp    9b244d <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x11d>
  9b2439:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  9b2440:	eb 0b                	jmp    9b244d <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>+0x11d>
  9b2442:	48 8b 3c 24          	mov    (%rsp),%rdi
  9b2446:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  9b244d:	48 89 f8             	mov    %rdi,%rax
  9b2450:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  9b2457:	5b                   	pop    %rbx
  9b2458:	41 5c                	pop    %r12
  9b245a:	41 5d                	pop    %r13
  9b245c:	41 5e                	pop    %r14
  9b245e:	41 5f                	pop    %r15
  9b2460:	5d                   	pop    %rbp
  9b2461:	c3                   	ret
  9b2462:	48 8d 15 a7 8d b0 00 	lea    0xb08da7(%rip),%rdx        # 14bb210 <anon.48d9e785fb7b83d7ec5d9c1f3105de7c.6.llvm.3048913293334227403>
  9b2469:	4c 89 f6             	mov    %r14,%rsi
  9b246c:	ff 15 b6 cf b7 00    	call   *0xb7cfb6(%rip)        # 152f428 <_DYNAMIC+0x2b0>
