
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006831f0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}>:
  6831f0:	55                   	push   %rbp
  6831f1:	41 57                	push   %r15
  6831f3:	41 56                	push   %r14
  6831f5:	41 55                	push   %r13
  6831f7:	41 54                	push   %r12
  6831f9:	53                   	push   %rbx
  6831fa:	48 83 ec 48          	sub    $0x48,%rsp
  6831fe:	4c 8b 4a 08          	mov    0x8(%rdx),%r9
  683202:	4c 8b 52 10          	mov    0x10(%rdx),%r10
  683206:	4c 8b 42 18          	mov    0x18(%rdx),%r8
  68320a:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  68320e:	48 8b 42 28          	mov    0x28(%rdx),%rax
  683212:	48 83 3a 01          	cmpq   $0x1,(%rdx)
  683216:	75 31                	jne    683249 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x59>
  683218:	4d 85 d2             	test   %r10,%r10
  68321b:	0f 84 ba 01 00 00    	je     6833db <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1eb>
  683221:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  683228:	0f 1f 84 00 00 00 00 
  68322f:	00 
  683230:	45 0f b6 59 08       	movzbl 0x8(%r9),%r11d
  683235:	41 f6 c3 02          	test   $0x2,%r11b
  683239:	75 66                	jne    6832a1 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xb1>
  68323b:	49 83 c1 0c          	add    $0xc,%r9
  68323f:	49 ff ca             	dec    %r10
  683242:	75 ec                	jne    683230 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x40>
  683244:	e9 92 01 00 00       	jmp    6833db <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1eb>
  683249:	4d 85 d2             	test   %r10,%r10
  68324c:	0f 84 89 01 00 00    	je     6833db <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1eb>
  683252:	41 8b 29             	mov    (%r9),%ebp
  683255:	ba 01 00 00 00       	mov    $0x1,%edx
  68325a:	4c 29 d2             	sub    %r10,%rdx
  68325d:	49 ff ca             	dec    %r10
  683260:	49 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%r11
  683267:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  68326e:	00 00 
  683270:	4a 8d 1c 1a          	lea    (%rdx,%r11,1),%rbx
  683274:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  683278:	74 40                	je     6832ba <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xca>
  68327a:	49 8d 5b 01          	lea    0x1(%r11),%rbx
  68327e:	43 39 6c d9 10       	cmp    %ebp,0x10(%r9,%r11,8)
  683283:	49 89 db             	mov    %rbx,%r11
  683286:	74 e8                	je     683270 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x80>
  683288:	4d 8d 0c d9          	lea    (%r9,%rbx,8),%r9
  68328c:	31 d2                	xor    %edx,%edx
  68328e:	48 85 db             	test   %rbx,%rbx
  683291:	74 35                	je     6832c8 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xd8>
  683293:	41 39 69 f8          	cmp    %ebp,-0x8(%r9)
  683297:	41 0f 94 c3          	sete   %r11b
  68329b:	41 80 f3 03          	xor    $0x3,%r11b
  68329f:	eb 2a                	jmp    6832cb <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xdb>
  6832a1:	41 8b 29             	mov    (%r9),%ebp
  6832a4:	41 0f b6 51 0b       	movzbl 0xb(%r9),%edx
  6832a9:	45 0f b7 51 09       	movzwl 0x9(%r9),%r10d
  6832ae:	41 c1 e2 08          	shl    $0x8,%r10d
  6832b2:	c1 e2 18             	shl    $0x18,%edx
  6832b5:	44 09 d2             	or     %r10d,%edx
  6832b8:	eb 11                	jmp    6832cb <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xdb>
  6832ba:	4c 89 d3             	mov    %r10,%rbx
  6832bd:	4d 8d 0c d9          	lea    (%r9,%rbx,8),%r9
  6832c1:	31 d2                	xor    %edx,%edx
  6832c3:	48 85 db             	test   %rbx,%rbx
  6832c6:	75 cb                	jne    683293 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xa3>
  6832c8:	41 b3 03             	mov    $0x3,%r11b
  6832cb:	f3 41 0f 10 49 04    	movss  0x4(%r9),%xmm1
  6832d1:	45 0f b6 cb          	movzbl %r11b,%r9d
  6832d5:	41 09 d1             	or     %edx,%r9d
  6832d8:	89 6c 24 04          	mov    %ebp,0x4(%rsp)
  6832dc:	f3 0f 11 4c 24 08    	movss  %xmm1,0x8(%rsp)
  6832e2:	44 89 4c 24 0c       	mov    %r9d,0xc(%rsp)
  6832e7:	41 f6 c0 01          	test   $0x1,%r8b
  6832eb:	74 27                	je     683314 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x124>
  6832ed:	48 85 c0             	test   %rax,%rax
  6832f0:	0f 84 e5 00 00 00    	je     6833db <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1eb>
  6832f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  6832fd:	00 00 00 
  683300:	f6 41 08 01          	testb  $0x1,0x8(%rcx)
  683304:	75 17                	jne    68331d <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x12d>
  683306:	48 83 c1 0c          	add    $0xc,%rcx
  68330a:	48 ff c8             	dec    %rax
  68330d:	75 f1                	jne    683300 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x110>
  68330f:	e9 c7 00 00 00       	jmp    6833db <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1eb>
  683314:	48 85 c0             	test   %rax,%rax
  683317:	0f 84 be 00 00 00    	je     6833db <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1eb>
  68331d:	48 8b 56 38          	mov    0x38(%rsi),%rdx
  683321:	48 8b 46 40          	mov    0x40(%rsi),%rax
  683325:	48 89 c3             	mov    %rax,%rbx
  683328:	48 85 c0             	test   %rax,%rax
  68332b:	74 4b                	je     683378 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x188>
  68332d:	45 31 c0             	xor    %r8d,%r8d
  683330:	48 83 f8 01          	cmp    $0x1,%rax
  683334:	74 2a                	je     683360 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x170>
  683336:	49 89 c1             	mov    %rax,%r9
  683339:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  683340:	4d 89 c2             	mov    %r8,%r10
  683343:	4d 89 cb             	mov    %r9,%r11
  683346:	49 d1 eb             	shr    $1,%r11
  683349:	4d 01 d8             	add    %r11,%r8
  68334c:	4b 8d 1c 40          	lea    (%r8,%r8,2),%rbx
  683350:	39 2c da             	cmp    %ebp,(%rdx,%rbx,8)
  683353:	4d 0f 47 c2          	cmova  %r10,%r8
  683357:	4d 29 d9             	sub    %r11,%r9
  68335a:	49 83 f9 01          	cmp    $0x1,%r9
  68335e:	77 e0                	ja     683340 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x150>
  683360:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  683364:	31 db                	xor    %ebx,%ebx
  683366:	42 39 2c ca          	cmp    %ebp,(%rdx,%r9,8)
  68336a:	0f 96 c3             	setbe  %bl
  68336d:	4c 01 c3             	add    %r8,%rbx
  683370:	48 83 fb 01          	cmp    $0x1,%rbx
  683374:	48 83 d3 ff          	adc    $0xffffffffffffffff,%rbx
  683378:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  68337d:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  683382:	48 39 c3             	cmp    %rax,%rbx
  683385:	0f 83 9a 01 00 00    	jae    683525 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x335>
  68338b:	49 89 fc             	mov    %rdi,%r12
  68338e:	44 8b 31             	mov    (%rcx),%r14d
  683391:	f3 0f 10 41 04       	movss  0x4(%rcx),%xmm0
  683396:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  68339b:	48 8d 04 5b          	lea    (%rbx,%rbx,2),%rax
  68339f:	44 8b 7c c2 04       	mov    0x4(%rdx,%rax,8),%r15d
  6833a4:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6833a9:	48 8d 54 24 04       	lea    0x4(%rsp),%rdx
  6833ae:	49 89 f5             	mov    %rsi,%r13
  6833b1:	ff 15 19 64 10 00    	call   *0x106419(%rip)        # 7897d0 <_DYNAMIC+0x368>
  6833b7:	f3 0f 10 2c 24       	movss  (%rsp),%xmm5
  6833bc:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  6833c1:	0f 2e e5             	ucomiss %xmm5,%xmm4
  6833c4:	75 02                	jne    6833c8 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1d8>
  6833c6:	7b 1c                	jnp    6833e4 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1f4>
  6833c8:	45 39 fe             	cmp    %r15d,%r14d
  6833cb:	77 17                	ja     6833e4 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1f4>
  6833cd:	0f 2e ec             	ucomiss %xmm4,%xmm5
  6833d0:	0f 96 c1             	setbe  %cl
  6833d3:	4c 89 e0             	mov    %r12,%rax
  6833d6:	e9 b2 00 00 00       	jmp    68348d <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x29d>
  6833db:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  6833df:	e9 32 01 00 00       	jmp    683516 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x326>
  6833e4:	49 8b 4d 20          	mov    0x20(%r13),%rcx
  6833e8:	49 8b 55 28          	mov    0x28(%r13),%rdx
  6833ec:	48 89 d6             	mov    %rdx,%rsi
  6833ef:	48 85 d2             	test   %rdx,%rdx
  6833f2:	4c 89 e0             	mov    %r12,%rax
  6833f5:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  6833fa:	74 46                	je     683442 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x252>
  6833fc:	31 f6                	xor    %esi,%esi
  6833fe:	48 83 fa 01          	cmp    $0x1,%rdx
  683402:	74 2f                	je     683433 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x243>
  683404:	48 89 d7             	mov    %rdx,%rdi
  683407:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  68340e:	00 00 
  683410:	49 89 f8             	mov    %rdi,%r8
  683413:	49 d1 e8             	shr    $1,%r8
  683416:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  68341a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  68341e:	46 8b 54 d1 10       	mov    0x10(%rcx,%r10,8),%r10d
  683423:	4c 39 d3             	cmp    %r10,%rbx
  683426:	49 0f 47 f1          	cmova  %r9,%rsi
  68342a:	4c 29 c7             	sub    %r8,%rdi
  68342d:	48 83 ff 01          	cmp    $0x1,%rdi
  683431:	77 dd                	ja     683410 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x220>
  683433:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  683437:	8b 7c f9 10          	mov    0x10(%rcx,%rdi,8),%edi
  68343b:	48 39 df             	cmp    %rbx,%rdi
  68343e:	48 83 d6 00          	adc    $0x0,%rsi
  683442:	48 c1 e6 03          	shl    $0x3,%rsi
  683446:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  68344a:	48 8d 3c 31          	lea    (%rcx,%rsi,1),%rdi
  68344e:	48 c1 e2 03          	shl    $0x3,%rdx
  683452:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  683456:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  68345d:	00 00 00 
  683460:	48 39 f2             	cmp    %rsi,%rdx
  683463:	74 59                	je     6834be <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2ce>
  683465:	49 89 f8             	mov    %rdi,%r8
  683468:	8b 7f 10             	mov    0x10(%rdi),%edi
  68346b:	48 39 fb             	cmp    %rdi,%rbx
  68346e:	75 4e                	jne    6834be <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2ce>
  683470:	49 8d 78 18          	lea    0x18(%r8),%rdi
  683474:	48 83 c6 18          	add    $0x18,%rsi
  683478:	41 39 28             	cmp    %ebp,(%r8)
  68347b:	77 e3                	ja     683460 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x270>
  68347d:	41 3b 68 04          	cmp    0x4(%r8),%ebp
  683481:	77 dd                	ja     683460 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x270>
  683483:	0f b6 4c 31 fd       	movzbl -0x3(%rcx,%rsi,1),%ecx
  683488:	45 39 fe             	cmp    %r15d,%r14d
  68348b:	77 38                	ja     6834c5 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2d5>
  68348d:	0f 28 cc             	movaps %xmm4,%xmm1
  683490:	f3 0f 5d cd          	minss  %xmm5,%xmm1
  683494:	0f 28 c1             	movaps %xmm1,%xmm0
  683497:	f3 0f c2 c1 03       	cmpunordss %xmm1,%xmm0
  68349c:	0f 28 d0             	movaps %xmm0,%xmm2
  68349f:	0f 55 d1             	andnps %xmm1,%xmm2
  6834a2:	0f 54 c4             	andps  %xmm4,%xmm0
  6834a5:	0f 56 c2             	orps   %xmm2,%xmm0
  6834a8:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
  6834ae:	0f 28 dd             	movaps %xmm5,%xmm3
  6834b1:	f3 0f 5c dc          	subss  %xmm4,%xmm3
  6834b5:	0f 54 1d 24 1e 9a ff 	andps  -0x65e1dc(%rip),%xmm3        # 252e0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  6834bc:	eb 18                	jmp    6834d6 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2e6>
  6834be:	31 c9                	xor    %ecx,%ecx
  6834c0:	45 39 fe             	cmp    %r15d,%r14d
  6834c3:	76 c8                	jbe    68348d <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x29d>
  6834c5:	0f 28 c4             	movaps %xmm4,%xmm0
  6834c8:	84 c9                	test   %cl,%cl
  6834ca:	74 04                	je     6834d0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2e0>
  6834cc:	f3 0f 5c c3          	subss  %xmm3,%xmm0
  6834d0:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
  6834d6:	45 39 fe             	cmp    %r15d,%r14d
  6834d9:	f3 0f 10 54 24 1c    	movss  0x1c(%rsp),%xmm2
  6834df:	89 28                	mov    %ebp,(%rax)
  6834e1:	c6 40 04 01          	movb   $0x1,0x4(%rax)
  6834e5:	44 89 70 08          	mov    %r14d,0x8(%rax)
  6834e9:	c6 40 0c 00          	movb   $0x0,0xc(%rax)
  6834ed:	f3 0f 11 40 10       	movss  %xmm0,0x10(%rax)
  6834f2:	f3 0f 11 48 14       	movss  %xmm1,0x14(%rax)
  6834f7:	f3 0f 11 58 18       	movss  %xmm3,0x18(%rax)
  6834fc:	f3 0f 11 50 1c       	movss  %xmm2,0x1c(%rax)
  683501:	48 89 58 20          	mov    %rbx,0x20(%rax)
  683505:	f3 0f 11 60 28       	movss  %xmm4,0x28(%rax)
  68350a:	f3 0f 11 68 2c       	movss  %xmm5,0x2c(%rax)
  68350f:	0f 97 40 30          	seta   0x30(%rax)
  683513:	88 48 31             	mov    %cl,0x31(%rax)
  683516:	48 83 c4 48          	add    $0x48,%rsp
  68351a:	5b                   	pop    %rbx
  68351b:	41 5c                	pop    %r12
  68351d:	41 5d                	pop    %r13
  68351f:	41 5e                	pop    %r14
  683521:	41 5f                	pop    %r15
  683523:	5d                   	pop    %rbp
  683524:	c3                   	ret
  683525:	48 8d 15 8c c8 0f 00 	lea    0xfc88c(%rip),%rdx        # 77fdb8 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1b0>
  68352c:	48 89 df             	mov    %rbx,%rdi
  68352f:	48 89 c6             	mov    %rax,%rsi
  683532:	ff 15 a0 62 10 00    	call   *0x1062a0(%rip)        # 7897d8 <_DYNAMIC+0x370>
