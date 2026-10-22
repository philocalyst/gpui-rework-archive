
/tmp/gpui-acknowledged-text-evidence/query-release-candidate/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a50160 <gpui::native::accessibility::project>:
  a50160:	55                   	push   %rbp
  a50161:	41 57                	push   %r15
  a50163:	41 56                	push   %r14
  a50165:	41 55                	push   %r13
  a50167:	41 54                	push   %r12
  a50169:	53                   	push   %rbx
  a5016a:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
  a50171:	48 b8 57 57 57 57 57 	movabs $0x5757575757575757,%rax
  a50178:	57 57 57 
  a5017b:	48 89 84 24 3f 01 00 	mov    %rax,0x13f(%rsp)
  a50182:	00 
  a50183:	66 0f 28 05 75 ca 73 	movapd -0x8c358b(%rip),%xmm0        # 18cc00 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a5018a:	ff 
  a5018b:	66 0f 11 84 24 30 01 	movupd %xmm0,0x130(%rsp)
  a50192:	00 00 
  a50194:	66 0f 11 84 24 20 01 	movupd %xmm0,0x120(%rsp)
  a5019b:	00 00 
  a5019d:	66 0f 11 84 24 10 01 	movupd %xmm0,0x110(%rsp)
  a501a4:	00 00 
  a501a6:	66 0f 11 84 24 00 01 	movupd %xmm0,0x100(%rsp)
  a501ad:	00 00 
  a501af:	66 0f 11 84 24 f0 00 	movupd %xmm0,0xf0(%rsp)
  a501b6:	00 00 
  a501b8:	c6 84 24 54 01 00 00 	movb   $0x85,0x154(%rsp)
  a501bf:	85 
  a501c0:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  a501c7:	00 00 00 00 00 
  a501cc:	c7 84 24 50 01 00 00 	movl   $0x0,0x150(%rsp)
  a501d3:	00 00 00 00 
  a501d7:	48 c7 84 24 d8 00 00 	movq   $0x0,0xd8(%rsp)
  a501de:	00 00 00 00 00 
  a501e3:	48 c7 84 24 e0 00 00 	movq   $0x8,0xe0(%rsp)
  a501ea:	00 08 00 00 00 
  a501ef:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  a501f6:	00 00 00 00 00 
  a501fb:	4d 85 c0             	test   %r8,%r8
  a501fe:	0f 88 18 01 00 00    	js     a5031c <gpui::native::accessibility::project+0x1bc>
  a50204:	4d 89 cf             	mov    %r9,%r15
  a50207:	4d 89 c4             	mov    %r8,%r12
  a5020a:	49 89 d5             	mov    %rdx,%r13
  a5020d:	49 89 f6             	mov    %rsi,%r14
  a50210:	48 89 bc 24 d0 00 00 	mov    %rdi,0xd0(%rsp)
  a50217:	00 
  a50218:	74 43                	je     a5025d <gpui::native::accessibility::project+0xfd>
  a5021a:	48 89 8c 24 c8 00 00 	mov    %rcx,0xc8(%rsp)
  a50221:	00 
  a50222:	ff 15 90 f1 ad 00    	call   *0xadf190(%rip)        # 152f3b8 <_DYNAMIC+0x240>
  a50228:	bd 01 00 00 00       	mov    $0x1,%ebp
  a5022d:	be 01 00 00 00       	mov    $0x1,%esi
  a50232:	4c 89 e7             	mov    %r12,%rdi
  a50235:	ff 15 85 f1 ad 00    	call   *0xadf185(%rip)        # 152f3c0 <_DYNAMIC+0x248>
  a5023b:	48 85 c0             	test   %rax,%rax
  a5023e:	0f 84 da 00 00 00    	je     a5031e <gpui::native::accessibility::project+0x1be>
  a50244:	48 89 c3             	mov    %rax,%rbx
  a50247:	48 89 c7             	mov    %rax,%rdi
  a5024a:	48 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%rsi
  a50251:	00 
  a50252:	4c 89 e2             	mov    %r12,%rdx
  a50255:	ff 15 7d f1 ad 00    	call   *0xadf17d(%rip)        # 152f3d8 <memcpy@GLIBC_2.14>
  a5025b:	eb 05                	jmp    a50262 <gpui::native::accessibility::project+0x102>
  a5025d:	bb 01 00 00 00       	mov    $0x1,%ebx
  a50262:	4c 89 64 24 48       	mov    %r12,0x48(%rsp)
  a50267:	48 89 5c 24 50       	mov    %rbx,0x50(%rsp)
  a5026c:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  a50271:	c6 44 24 40 03       	movb   $0x3,0x40(%rsp)
  a50276:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a5027d:	00 
  a5027e:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a50283:	be 0f 00 00 00       	mov    $0xf,%esi
  a50288:	ff 15 f2 04 ae 00    	call   *0xae04f2(%rip)        # 1530780 <_DYNAMIC+0x1608>
  a5028e:	80 8c 24 51 01 00 00 	orb    $0x8,0x151(%rsp)
  a50295:	08 
  a50296:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  a5029a:	66 0f 29 44 24 40    	movapd %xmm0,0x40(%rsp)
  a502a0:	f2 41 0f 10 4d 28    	movsd  0x28(%r13),%xmm1
  a502a6:	0f 14 c8             	unpcklps %xmm0,%xmm1
  a502a9:	66 0f 28 05 af ea 73 	movapd -0x8c1551(%rip),%xmm0        # 18ed60 <anon.05933fb6bb17d4b782622fe161e9f81c.309.llvm.18391229140309290632+0x8b0>
  a502b0:	ff 
  a502b1:	66 0f 56 c8          	orpd   %xmm0,%xmm1
  a502b5:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  a502b9:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a502bf:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a502c6:	00 
  a502c7:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a502cc:	be 53 00 00 00       	mov    $0x53,%esi
  a502d1:	ff 15 c1 04 ae 00    	call   *0xae04c1(%rip)        # 1530798 <_DYNAMIC+0x1620>
  a502d7:	4d 8b 6e 38          	mov    0x38(%r14),%r13
  a502db:	4d 85 ed             	test   %r13,%r13
  a502de:	74 4f                	je     a5032f <gpui::native::accessibility::project+0x1cf>
  a502e0:	49 8d 5d 01          	lea    0x1(%r13),%rbx
  a502e4:	45 31 e4             	xor    %r12d,%r12d
  a502e7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  a502ee:	00 00 
  a502f0:	4c 89 ff             	mov    %r15,%rdi
  a502f3:	4c 89 f6             	mov    %r14,%rsi
  a502f6:	44 89 e2             	mov    %r12d,%edx
  a502f9:	e8 f2 c1 00 00       	call   a5c4f0 <<gpui::native::accessibility::text::Cohort>::text_count>
  a502fe:	48 01 c3             	add    %rax,%rbx
  a50301:	49 ff c4             	inc    %r12
  a50304:	4d 39 e5             	cmp    %r12,%r13
  a50307:	75 e7                	jne    a502f0 <gpui::native::accessibility::project+0x190>
  a50309:	48 b8 f0 f0 f0 f0 f0 	movabs $0xf0f0f0f0f0f0f0,%rax
  a50310:	f0 f0 00 
  a50313:	48 39 c3             	cmp    %rax,%rbx
  a50316:	0f 86 8e 02 00 00    	jbe    a505aa <gpui::native::accessibility::project+0x44a>
  a5031c:	31 ed                	xor    %ebp,%ebp
  a5031e:	48 89 ef             	mov    %rbp,%rdi
  a50321:	4c 89 e6             	mov    %r12,%rsi
  a50324:	ff 15 86 f1 ad 00    	call   *0xadf186(%rip)        # 152f4b0 <_DYNAMIC+0x338>
  a5032a:	e9 aa 02 00 00       	jmp    a505d9 <gpui::native::accessibility::project+0x479>
  a5032f:	41 bc 88 00 00 00    	mov    $0x88,%r12d
  a50335:	bb 01 00 00 00       	mov    $0x1,%ebx
  a5033a:	ff 15 78 f0 ad 00    	call   *0xadf078(%rip)        # 152f3b8 <_DYNAMIC+0x240>
  a50340:	bd 08 00 00 00       	mov    $0x8,%ebp
  a50345:	be 08 00 00 00       	mov    $0x8,%esi
  a5034a:	4c 89 e7             	mov    %r12,%rdi
  a5034d:	ff 15 6d f0 ad 00    	call   *0xadf06d(%rip)        # 152f3c0 <_DYNAMIC+0x248>
  a50353:	48 85 c0             	test   %rax,%rax
  a50356:	74 c6                	je     a5031e <gpui::native::accessibility::project+0x1be>
  a50358:	48 89 c7             	mov    %rax,%rdi
  a5035b:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
  a50360:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  a50365:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  a5036c:	00 00 
  a5036e:	0f 10 84 24 48 01 00 	movups 0x148(%rsp),%xmm0
  a50375:	00 
  a50376:	0f 11 84 24 b8 00 00 	movups %xmm0,0xb8(%rsp)
  a5037d:	00 
  a5037e:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  a50385:	00 
  a50386:	0f 11 84 24 a8 00 00 	movups %xmm0,0xa8(%rsp)
  a5038d:	00 
  a5038e:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  a50395:	00 
  a50396:	0f 11 84 24 98 00 00 	movups %xmm0,0x98(%rsp)
  a5039d:	00 
  a5039e:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  a503a5:	00 
  a503a6:	0f 11 84 24 88 00 00 	movups %xmm0,0x88(%rsp)
  a503ad:	00 
  a503ae:	66 0f 10 84 24 d8 00 	movupd 0xd8(%rsp),%xmm0
  a503b5:	00 00 
  a503b7:	66 0f 10 8c 24 e8 00 	movupd 0xe8(%rsp),%xmm1
  a503be:	00 00 
  a503c0:	0f 10 94 24 f8 00 00 	movups 0xf8(%rsp),%xmm2
  a503c7:	00 
  a503c8:	0f 10 9c 24 08 01 00 	movups 0x108(%rsp),%xmm3
  a503cf:	00 
  a503d0:	0f 11 5c 24 78       	movups %xmm3,0x78(%rsp)
  a503d5:	0f 11 54 24 68       	movups %xmm2,0x68(%rsp)
  a503da:	66 0f 11 4c 24 58    	movupd %xmm1,0x58(%rsp)
  a503e0:	66 0f 11 44 24 48    	movupd %xmm0,0x48(%rsp)
  a503e6:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  a503ed:	00 00 
  a503ef:	48 85 db             	test   %rbx,%rbx
  a503f2:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
  a503f9:	00 
  a503fa:	75 10                	jne    a5040c <gpui::native::accessibility::project+0x2ac>
  a503fc:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  a50401:	ff 15 71 03 ae 00    	call   *0xae0371(%rip)        # 1530778 <_DYNAMIC+0x1600>
  a50407:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  a5040c:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a50411:	ba 88 00 00 00       	mov    $0x88,%edx
  a50416:	ff 15 bc ef ad 00    	call   *0xadefbc(%rip)        # 152f3d8 <memcpy@GLIBC_2.14>
  a5041c:	48 c7 44 24 18 01 00 	movq   $0x1,0x18(%rsp)
  a50423:	00 00 
  a50425:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  a5042c:	00 00 
  a5042e:	48 c7 44 24 30 08 00 	movq   $0x8,0x30(%rsp)
  a50435:	00 00 
  a50437:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  a5043e:	00 00 
  a50440:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  a50447:	00 00 
  a50449:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
  a5044e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a50453:	4c 89 7c 24 48       	mov    %r15,0x48(%rsp)
  a50458:	48 8d 44 24 08       	lea    0x8(%rsp),%rax
  a5045d:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  a50462:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  a50467:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  a5046c:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a50471:	4c 89 f7             	mov    %r14,%rdi
  a50474:	e8 47 b4 02 00       	call   a7b8c0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>>
  a50479:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  a50480:	00 00 
  a50482:	48 c7 44 24 40 ff ff 	movq   $0xffffffffffffffff,0x40(%rsp)
  a50489:	ff ff 
  a5048b:	48 c7 44 24 58 ff ff 	movq   $0xffffffffffffffff,0x58(%rsp)
  a50492:	ff ff 
  a50494:	ff 15 1e ef ad 00    	call   *0xadef1e(%rip)        # 152f3b8 <_DYNAMIC+0x240>
  a5049a:	41 be 04 00 00 00    	mov    $0x4,%r14d
  a504a0:	bf 04 00 00 00       	mov    $0x4,%edi
  a504a5:	be 01 00 00 00       	mov    $0x1,%esi
  a504aa:	ff 15 10 ef ad 00    	call   *0xadef10(%rip)        # 152f3c0 <_DYNAMIC+0x248>
  a504b0:	48 85 c0             	test   %rax,%rax
  a504b3:	0f 84 12 01 00 00    	je     a505cb <gpui::native::accessibility::project+0x46b>
  a504b9:	c7 00 47 50 55 49    	movl   $0x49555047,(%rax)
  a504bf:	48 c7 44 24 40 04 00 	movq   $0x4,0x40(%rsp)
  a504c6:	00 00 
  a504c8:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  a504cd:	48 c7 44 24 50 04 00 	movq   $0x4,0x50(%rsp)
  a504d4:	00 00 
  a504d6:	ff 15 dc ee ad 00    	call   *0xadeedc(%rip)        # 152f3b8 <_DYNAMIC+0x240>
  a504dc:	41 be 05 00 00 00    	mov    $0x5,%r14d
  a504e2:	bf 05 00 00 00       	mov    $0x5,%edi
  a504e7:	be 01 00 00 00       	mov    $0x1,%esi
  a504ec:	ff 15 ce ee ad 00    	call   *0xadeece(%rip)        # 152f3c0 <_DYNAMIC+0x248>
  a504f2:	48 85 c0             	test   %rax,%rax
  a504f5:	0f 84 d0 00 00 00    	je     a505cb <gpui::native::accessibility::project+0x46b>
  a504fb:	c6 40 04 30          	movb   $0x30,0x4(%rax)
  a504ff:	c7 00 30 2e 31 2e    	movl   $0x2e312e30,(%rax)
  a50505:	48 c7 44 24 58 05 00 	movq   $0x5,0x58(%rsp)
  a5050c:	00 00 
  a5050e:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  a50513:	48 c7 44 24 68 05 00 	movq   $0x5,0x68(%rsp)
  a5051a:	00 00 
  a5051c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  a50521:	48 89 43 10          	mov    %rax,0x10(%rbx)
  a50525:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  a5052a:	0f 11 03             	movups %xmm0,(%rbx)
  a5052d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  a50532:	48 89 43 48          	mov    %rax,0x48(%rbx)
  a50536:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  a5053b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  a50540:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  a50545:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  a5054a:	48 89 53 38          	mov    %rdx,0x38(%rbx)
  a5054e:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  a50553:	48 89 53 40          	mov    %rdx,0x40(%rbx)
  a50557:	48 89 43 28          	mov    %rax,0x28(%rbx)
  a5055b:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  a5055f:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  a50563:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a50568:	0f 57 c0             	xorps  %xmm0,%xmm0
  a5056b:	0f 11 43 50          	movups %xmm0,0x50(%rbx)
  a5056f:	48 89 43 60          	mov    %rax,0x60(%rbx)
  a50573:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a50578:	48 85 c0             	test   %rax,%rax
  a5057b:	74 18                	je     a50595 <gpui::native::accessibility::project+0x435>
  a5057d:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a50582:	48 c1 e0 03          	shl    $0x3,%rax
  a50586:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  a5058a:	ba 08 00 00 00       	mov    $0x8,%edx
  a5058f:	ff 15 33 ee ad 00    	call   *0xadee33(%rip)        # 152f3c8 <_DYNAMIC+0x250>
  a50595:	48 89 d8             	mov    %rbx,%rax
  a50598:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
  a5059f:	5b                   	pop    %rbx
  a505a0:	41 5c                	pop    %r12
  a505a2:	41 5d                	pop    %r13
  a505a4:	41 5e                	pop    %r14
  a505a6:	41 5f                	pop    %r15
  a505a8:	5d                   	pop    %rbp
  a505a9:	c3                   	ret
  a505aa:	48 85 db             	test   %rbx,%rbx
  a505ad:	74 10                	je     a505bf <gpui::native::accessibility::project+0x45f>
  a505af:	48 89 d8             	mov    %rbx,%rax
  a505b2:	48 c1 e0 07          	shl    $0x7,%rax
  a505b6:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  a505ba:	e9 7b fd ff ff       	jmp    a5033a <gpui::native::accessibility::project+0x1da>
  a505bf:	bf 08 00 00 00       	mov    $0x8,%edi
  a505c4:	31 db                	xor    %ebx,%ebx
  a505c6:	e9 90 fd ff ff       	jmp    a5035b <gpui::native::accessibility::project+0x1fb>
  a505cb:	bf 01 00 00 00       	mov    $0x1,%edi
  a505d0:	4c 89 f6             	mov    %r14,%rsi
  a505d3:	ff 15 d7 ee ad 00    	call   *0xadeed7(%rip)        # 152f4b0 <_DYNAMIC+0x338>
  a505d9:	0f 0b                	ud2
  a505db:	48 89 c3             	mov    %rax,%rbx
  a505de:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a505e3:	e8 98 cb ff ff       	call   a4d180 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a505e8:	eb 3a                	jmp    a50624 <gpui::native::accessibility::project+0x4c4>
  a505ea:	ff 15 10 ee ad 00    	call   *0xadee10(%rip)        # 152f400 <_DYNAMIC+0x288>
  a505f0:	48 89 c3             	mov    %rax,%rbx
  a505f3:	eb 0d                	jmp    a50602 <gpui::native::accessibility::project+0x4a2>
  a505f5:	48 89 c3             	mov    %rax,%rbx
  a505f8:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a505fd:	e8 9e be ff ff       	call   a4c4a0 <core::ptr::drop_glue::<accesskit::TreeInfo>>
  a50602:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a50607:	48 85 c0             	test   %rax,%rax
  a5060a:	74 18                	je     a50624 <gpui::native::accessibility::project+0x4c4>
  a5060c:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a50611:	48 c1 e0 03          	shl    $0x3,%rax
  a50615:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  a50619:	ba 08 00 00 00       	mov    $0x8,%edx
  a5061e:	ff 15 a4 ed ad 00    	call   *0xadeda4(%rip)        # 152f3c8 <_DYNAMIC+0x250>
  a50624:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  a50629:	e8 e2 bb ff ff       	call   a4c210 <core::ptr::drop_glue::<alloc::vec::Vec<(accesskit::NodeId, accesskit::Node)>>>
  a5062e:	eb 12                	jmp    a50642 <gpui::native::accessibility::project+0x4e2>
  a50630:	eb 00                	jmp    a50632 <gpui::native::accessibility::project+0x4d2>
  a50632:	48 89 c3             	mov    %rax,%rbx
  a50635:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a5063c:	00 
  a5063d:	e8 8e bd ff ff       	call   a4c3d0 <core::ptr::drop_glue::<accesskit::Node>>
  a50642:	48 89 df             	mov    %rbx,%rdi
  a50645:	e8 a6 95 a6 00       	call   14b9bf0 <_Unwind_Resume@plt>
  a5064a:	ff 15 b0 ed ad 00    	call   *0xadedb0(%rip)        # 152f400 <_DYNAMIC+0x288>
