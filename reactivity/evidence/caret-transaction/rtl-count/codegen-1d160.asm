
/tmp/gpui-caret-transaction-bin/d54-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001d160 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>:
   1d160:	55                   	push   %rbp
   1d161:	41 57                	push   %r15
   1d163:	41 56                	push   %r14
   1d165:	41 55                	push   %r13
   1d167:	41 54                	push   %r12
   1d169:	53                   	push   %rbx
   1d16a:	48 81 ec 58 04 00 00 	sub    $0x458,%rsp
   1d171:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
   1d176:	f3 0f 11 44 24 2c    	movss  %xmm0,0x2c(%rsp)
   1d17c:	4c 8b 7f 70          	mov    0x70(%rdi),%r15
   1d180:	4c 89 f8             	mov    %r15,%rax
   1d183:	48 c1 e8 20          	shr    $0x20,%rax
   1d187:	75 10                	jne    1d199 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x39>
   1d189:	4c 8b a7 18 01 00 00 	mov    0x118(%rdi),%r12
   1d190:	4c 89 e0             	mov    %r12,%rax
   1d193:	48 c1 e8 20          	shr    $0x20,%rax
   1d197:	74 14                	je     1d1ad <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4d>
   1d199:	b0 02                	mov    $0x2,%al
   1d19b:	48 81 c4 58 04 00 00 	add    $0x458,%rsp
   1d1a2:	5b                   	pop    %rbx
   1d1a3:	41 5c                	pop    %r12
   1d1a5:	41 5d                	pop    %r13
   1d1a7:	41 5e                	pop    %r14
   1d1a9:	41 5f                	pop    %r15
   1d1ab:	5d                   	pop    %rbp
   1d1ac:	c3                   	ret
   1d1ad:	4d 89 fd             	mov    %r15,%r13
   1d1b0:	49 c1 e5 04          	shl    $0x4,%r13
   1d1b4:	4d 85 ff             	test   %r15,%r15
   1d1b7:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
   1d1bc:	74 2f                	je     1d1ed <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x8d>
   1d1be:	48 89 f3             	mov    %rsi,%rbx
   1d1c1:	ff 15 81 32 04 00    	call   *0x43281(%rip)        # 60448 <_DYNAMIC+0x280>
   1d1c7:	be 04 00 00 00       	mov    $0x4,%esi
   1d1cc:	4c 89 ef             	mov    %r13,%rdi
   1d1cf:	ff 15 7b 32 04 00    	call   *0x4327b(%rip)        # 60450 <_DYNAMIC+0x288>
   1d1d5:	48 85 c0             	test   %rax,%rax
   1d1d8:	0f 84 c2 0b 00 00    	je     1dda0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc40>
   1d1de:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1d1e3:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1d1e8:	48 89 de             	mov    %rbx,%rsi
   1d1eb:	eb 0a                	jmp    1d1f7 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x97>
   1d1ed:	b8 04 00 00 00       	mov    $0x4,%eax
   1d1f2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1d1f7:	48 b9 f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rcx
   1d1fe:	ff ff 7f 
   1d201:	48 8b 97 50 01 00 00 	mov    0x150(%rdi),%rdx
   1d208:	48 8d 2c 95 00 00 00 	lea    0x0(,%rdx,4),%rbp
   1d20f:	00 
   1d210:	48 89 d0             	mov    %rdx,%rax
   1d213:	48 c1 e8 3e          	shr    $0x3e,%rax
   1d217:	0f 95 c0             	setne  %al
   1d21a:	48 83 c1 04          	add    $0x4,%rcx
   1d21e:	48 39 cd             	cmp    %rcx,%rbp
   1d221:	0f 97 c1             	seta   %cl
   1d224:	08 c1                	or     %al,%cl
   1d226:	74 13                	je     1d23b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xdb>
   1d228:	31 db                	xor    %ebx,%ebx
   1d22a:	48 89 df             	mov    %rbx,%rdi
   1d22d:	48 89 ee             	mov    %rbp,%rsi
   1d230:	ff 15 fa 31 04 00    	call   *0x431fa(%rip)        # 60430 <_DYNAMIC+0x268>
   1d236:	e9 be 0b 00 00       	jmp    1ddf9 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc99>
   1d23b:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
   1d240:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
   1d247:	00 
   1d248:	48 85 ed             	test   %rbp,%rbp
   1d24b:	74 5a                	je     1d2a7 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x147>
   1d24d:	ff 15 f5 31 04 00    	call   *0x431f5(%rip)        # 60448 <_DYNAMIC+0x280>
   1d253:	bb 04 00 00 00       	mov    $0x4,%ebx
   1d258:	be 04 00 00 00       	mov    $0x4,%esi
   1d25d:	48 89 ef             	mov    %rbp,%rdi
   1d260:	ff 15 ea 31 04 00    	call   *0x431ea(%rip)        # 60450 <_DYNAMIC+0x288>
   1d266:	48 85 c0             	test   %rax,%rax
   1d269:	74 bf                	je     1d22a <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xca>
   1d26b:	49 89 c6             	mov    %rax,%r14
   1d26e:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
   1d273:	4c 89 eb             	mov    %r13,%rbx
   1d276:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1d27b:	49 83 fd 02          	cmp    $0x2,%r13
   1d27f:	72 39                	jb     1d2ba <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x15a>
   1d281:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
   1d285:	4c 89 f7             	mov    %r14,%rdi
   1d288:	be ff 00 00 00       	mov    $0xff,%esi
   1d28d:	ff 15 f5 31 04 00    	call   *0x431f5(%rip)        # 60488 <memset@GLIBC_2.2.5>
   1d293:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1d298:	49 8d 04 2e          	lea    (%r14,%rbp,1),%rax
   1d29c:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
   1d2a0:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   1d2a5:	eb 20                	jmp    1d2c7 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x167>
   1d2a7:	41 be 04 00 00 00    	mov    $0x4,%r14d
   1d2ad:	31 db                	xor    %ebx,%ebx
   1d2af:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
   1d2b4:	49 83 fd 02          	cmp    $0x2,%r13
   1d2b8:	73 c7                	jae    1d281 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x121>
   1d2ba:	4c 89 f0             	mov    %r14,%rax
   1d2bd:	4d 85 ed             	test   %r13,%r13
   1d2c0:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   1d2c5:	74 06                	je     1d2cd <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x16d>
   1d2c7:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%rax)
   1d2cd:	48 89 9c 24 80 00 00 	mov    %rbx,0x80(%rsp)
   1d2d4:	00 
   1d2d5:	4c 89 b4 24 88 00 00 	mov    %r14,0x88(%rsp)
   1d2dc:	00 
   1d2dd:	4c 89 ac 24 90 00 00 	mov    %r13,0x90(%rsp)
   1d2e4:	00 
   1d2e5:	48 89 bc 24 98 00 00 	mov    %rdi,0x98(%rsp)
   1d2ec:	00 
   1d2ed:	4c 89 7c 24 68       	mov    %r15,0x68(%rsp)
   1d2f2:	48 8d 44 24 70       	lea    0x70(%rsp),%rax
   1d2f7:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   1d2fc:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
   1d303:	00 00 
   1d305:	4d 85 e4             	test   %r12,%r12
   1d308:	0f 84 11 06 00 00    	je     1d91f <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7bf>
   1d30e:	4c 8b b7 10 01 00 00 	mov    0x110(%rdi),%r14
   1d315:	4d 6b cc 70          	imul   $0x70,%r12,%r9
   1d319:	4d 01 f1             	add    %r14,%r9
   1d31c:	48 8d ac 24 28 02 00 	lea    0x228(%rsp),%rbp
   1d323:	00 
   1d324:	48 8b 97 30 01 00 00 	mov    0x130(%rdi),%rdx
   1d32b:	4c 8b 97 28 01 00 00 	mov    0x128(%rdi),%r10
   1d332:	4c 8b 47 58          	mov    0x58(%rdi),%r8
   1d336:	4c 8b 9f e8 00 00 00 	mov    0xe8(%rdi),%r11
   1d33d:	4c 8b bf e0 00 00 00 	mov    0xe0(%rdi),%r15
   1d344:	4c 8b 67 50          	mov    0x50(%rdi),%r12
   1d348:	48 8b 47 38          	mov    0x38(%rdi),%rax
   1d34c:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
   1d353:	00 
   1d354:	4c 8b 6f 40          	mov    0x40(%rdi),%r13
   1d358:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
   1d35f:	00 00 
   1d361:	48 8d 05 a0 0e 04 00 	lea    0x40ea0(%rip),%rax        # 5e208 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0xc0>
   1d368:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   1d36d:	48 8d 05 bc 0d 04 00 	lea    0x40dbc(%rip),%rax        # 5e130 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.16.llvm.16159360244280900074>
   1d374:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   1d379:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
   1d37e:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
   1d385:	00 
   1d386:	4c 89 8c 24 b8 00 00 	mov    %r9,0xb8(%rsp)
   1d38d:	00 
   1d38e:	4c 89 94 24 b0 00 00 	mov    %r10,0xb0(%rsp)
   1d395:	00 
   1d396:	4c 89 9c 24 a8 00 00 	mov    %r11,0xa8(%rsp)
   1d39d:	00 
   1d39e:	4c 89 bc 24 d0 00 00 	mov    %r15,0xd0(%rsp)
   1d3a5:	00 
   1d3a6:	4c 89 a4 24 c8 00 00 	mov    %r12,0xc8(%rsp)
   1d3ad:	00 
   1d3ae:	4c 89 ac 24 a0 00 00 	mov    %r13,0xa0(%rsp)
   1d3b5:	00 
   1d3b6:	49 8b 46 10          	mov    0x10(%r14),%rax
   1d3ba:	49 8b 76 18          	mov    0x18(%r14),%rsi
   1d3be:	48 39 c6             	cmp    %rax,%rsi
   1d3c1:	0f 82 ac 09 00 00    	jb     1dd73 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc13>
   1d3c7:	48 39 d6             	cmp    %rdx,%rsi
   1d3ca:	0f 87 a3 09 00 00    	ja     1dd73 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc13>
   1d3d0:	48 39 f0             	cmp    %rsi,%rax
   1d3d3:	75 1a                	jne    1d3ef <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x28f>
   1d3d5:	49 83 c6 70          	add    $0x70,%r14
   1d3d9:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1d3de:	ff c0                	inc    %eax
   1d3e0:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   1d3e5:	4d 39 ce             	cmp    %r9,%r14
   1d3e8:	75 cc                	jne    1d3b6 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x256>
   1d3ea:	e9 46 09 00 00       	jmp    1dd35 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbd5>
   1d3ef:	f3 41 0f 10 46 28    	movss  0x28(%r14),%xmm0
   1d3f5:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
   1d3fb:	48 8d 0c b6          	lea    (%rsi,%rsi,4),%rcx
   1d3ff:	49 8d 0c ca          	lea    (%r10,%rcx,8),%rcx
   1d403:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
   1d40a:	00 
   1d40b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
   1d40f:	49 8d 1c c2          	lea    (%r10,%rax,8),%rbx
   1d413:	31 f6                	xor    %esi,%esi
   1d415:	48 8b 43 10          	mov    0x10(%rbx),%rax
   1d419:	80 7b 21 01          	cmpb   $0x1,0x21(%rbx)
   1d41d:	75 40                	jne    1d45f <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x2ff>
   1d41f:	4c 39 e8             	cmp    %r13,%rax
   1d422:	0f 83 ad 09 00 00    	jae    1ddd5 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc75>
   1d428:	48 6b c0 38          	imul   $0x38,%rax,%rax
   1d42c:	48 8b 8c 24 d8 00 00 	mov    0xd8(%rsp),%rcx
   1d433:	00 
   1d434:	f3 0f 10 44 01 24    	movss  0x24(%rcx,%rax,1),%xmm0
   1d43a:	48 83 c3 28          	add    $0x28,%rbx
   1d43e:	ff c6                	inc    %esi
   1d440:	f3 0f 10 4c 24 24    	movss  0x24(%rsp),%xmm1
   1d446:	f3 0f 58 c8          	addss  %xmm0,%xmm1
   1d44a:	f3 0f 11 4c 24 24    	movss  %xmm1,0x24(%rsp)
   1d450:	48 3b 9c 24 e8 00 00 	cmp    0xe8(%rsp),%rbx
   1d457:	00 
   1d458:	75 bb                	jne    1d415 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x2b5>
   1d45a:	e9 76 ff ff ff       	jmp    1d3d5 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x275>
   1d45f:	4c 39 c0             	cmp    %r8,%rax
   1d462:	0f 83 7e 09 00 00    	jae    1dde6 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc86>
   1d468:	89 74 24 28          	mov    %esi,0x28(%rsp)
   1d46c:	4c 39 d8             	cmp    %r11,%rax
   1d46f:	4c 8d 84 24 48 03 00 	lea    0x348(%rsp),%r8
   1d476:	00 
   1d477:	0f 83 4a 09 00 00    	jae    1ddc7 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc67>
   1d47d:	48 8d 0c c0          	lea    (%rax,%rax,8),%rcx
   1d481:	48 c1 e1 04          	shl    $0x4,%rcx
   1d485:	49 8d 14 0c          	lea    (%r12,%rcx,1),%rdx
   1d489:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
   1d48d:	48 c1 e6 04          	shl    $0x4,%rsi
   1d491:	4c 01 fe             	add    %r15,%rsi
   1d494:	48 89 bc 24 60 01 00 	mov    %rdi,0x160(%rsp)
   1d49b:	00 
   1d49c:	48 89 94 24 68 01 00 	mov    %rdx,0x168(%rsp)
   1d4a3:	00 
   1d4a4:	48 89 b4 24 70 01 00 	mov    %rsi,0x170(%rsp)
   1d4ab:	00 
   1d4ac:	48 89 9c 24 78 01 00 	mov    %rbx,0x178(%rsp)
   1d4b3:	00 
   1d4b4:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
   1d4b9:	89 94 24 80 01 00 00 	mov    %edx,0x180(%rsp)
   1d4c0:	8b 54 24 28          	mov    0x28(%rsp),%edx
   1d4c4:	89 94 24 84 01 00 00 	mov    %edx,0x184(%rsp)
   1d4cb:	89 84 24 88 01 00 00 	mov    %eax,0x188(%rsp)
   1d4d2:	41 0f b6 94 0c 8c 00 	movzbl 0x8c(%r12,%rcx,1),%edx
   1d4d9:	00 00 
   1d4db:	83 e2 01             	and    $0x1,%edx
   1d4de:	4c 89 c7             	mov    %r8,%rdi
   1d4e1:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
   1d4e8:	00 
   1d4e9:	4d 89 c5             	mov    %r8,%r13
   1d4ec:	e8 4f 22 00 00       	call   1f740 <<parley::layout::run::Clusters<()>>::new>
   1d4f1:	ba 10 01 00 00       	mov    $0x110,%edx
   1d4f6:	4c 8d bc 24 38 02 00 	lea    0x238(%rsp),%r15
   1d4fd:	00 
   1d4fe:	4c 89 ff             	mov    %r15,%rdi
   1d501:	4c 89 ee             	mov    %r13,%rsi
   1d504:	ff 15 0e 2f 04 00    	call   *0x42f0e(%rip)        # 60418 <memcpy@GLIBC_2.14>
   1d50a:	66 0f 6e 44 24 24    	movd   0x24(%rsp),%xmm0
   1d510:	66 0f 7e 44 24 08    	movd   %xmm0,0x8(%rsp)
   1d516:	eb 18                	jmp    1d530 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3d0>
   1d518:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
   1d51e:	f3 0f 58 c1          	addss  %xmm1,%xmm0
   1d522:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
   1d528:	4c 8d bc 24 38 02 00 	lea    0x238(%rsp),%r15
   1d52f:	00 
   1d530:	48 8d bc 24 a8 01 00 	lea    0x1a8(%rsp),%rdi
   1d537:	00 
   1d538:	4c 89 fe             	mov    %r15,%rsi
   1d53b:	e8 f0 24 00 00       	call   1fa30 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1d540:	83 bc 24 a8 01 00 00 	cmpl   $0x1,0x1a8(%rsp)
   1d547:	01 
   1d548:	0f 85 33 03 00 00    	jne    1d881 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x721>
   1d54e:	0f 10 45 84          	movups -0x7c(%rbp),%xmm0
   1d552:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
   1d559:	00 
   1d55a:	48 8b 84 24 f0 02 00 	mov    0x2f0(%rsp),%rax
   1d561:	00 
   1d562:	48 85 c0             	test   %rax,%rax
   1d565:	0f 84 1a 08 00 00    	je     1dd85 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc25>
   1d56b:	4c 8b ac 24 38 02 00 	mov    0x238(%rsp),%r13
   1d572:	00 
   1d573:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
   1d57a:	00 
   1d57b:	0f 29 84 24 90 01 00 	movaps %xmm0,0x190(%rsp)
   1d582:	00 
   1d583:	4d 85 ed             	test   %r13,%r13
   1d586:	0f 84 f5 02 00 00    	je     1d881 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x721>
   1d58c:	4c 89 ac 24 a8 01 00 	mov    %r13,0x1a8(%rsp)
   1d593:	00 
   1d594:	48 8d 94 24 f8 02 00 	lea    0x2f8(%rsp),%rdx
   1d59b:	00 
   1d59c:	48 8b 8a 68 ff ff ff 	mov    -0x98(%rdx),%rcx
   1d5a3:	48 89 4d a8          	mov    %rcx,-0x58(%rbp)
   1d5a7:	0f 10 82 48 ff ff ff 	movups -0xb8(%rdx),%xmm0
   1d5ae:	0f 10 8a 58 ff ff ff 	movups -0xa8(%rdx),%xmm1
   1d5b5:	0f 11 4d 98          	movups %xmm1,-0x68(%rbp)
   1d5b9:	0f 11 45 88          	movups %xmm0,-0x78(%rbp)
   1d5bd:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
   1d5c4:	00 
   1d5c5:	48 8b 42 40          	mov    0x40(%rdx),%rax
   1d5c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   1d5cd:	0f 10 02             	movups (%rdx),%xmm0
   1d5d0:	f3 0f 6f 4a 10       	movdqu 0x10(%rdx),%xmm1
   1d5d5:	f3 0f 6f 52 20       	movdqu 0x20(%rdx),%xmm2
   1d5da:	f3 0f 6f 5a 30       	movdqu 0x30(%rdx),%xmm3
   1d5df:	f3 0f 7f 5d e8       	movdqu %xmm3,-0x18(%rbp)
   1d5e4:	f3 0f 7f 55 d8       	movdqu %xmm2,-0x28(%rbp)
   1d5e9:	f3 0f 7f 4d c8       	movdqu %xmm1,-0x38(%rbp)
   1d5ee:	0f 11 45 b8          	movups %xmm0,-0x48(%rbp)
   1d5f2:	0f 28 84 24 90 01 00 	movaps 0x190(%rsp),%xmm0
   1d5f9:	00 
   1d5fa:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
   1d5fe:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
   1d603:	f3 0f 7e 84 24 c8 01 	movq   0x1c8(%rsp),%xmm0
   1d60a:	00 00 
   1d60c:	66 0f 7f 44 24 50    	movdqa %xmm0,0x50(%rsp)
   1d612:	44 8b bc 24 28 02 00 	mov    0x228(%rsp),%r15d
   1d619:	00 
   1d61a:	4c 3b 64 24 68       	cmp    0x68(%rsp),%r12
   1d61f:	75 0a                	jne    1d62b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4cb>
   1d621:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   1d626:	e8 95 e3 ff ff       	call   1b9c0 <<alloc::raw_vec::RawVec<parley::editing::geometry::Entry>>::grow_one>
   1d62b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
   1d630:	4c 89 e1             	mov    %r12,%rcx
   1d633:	48 c1 e1 04          	shl    $0x4,%rcx
   1d637:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   1d63c:	0f 13 04 08          	movlps %xmm0,(%rax,%rcx,1)
   1d640:	44 89 7c 08 08       	mov    %r15d,0x8(%rax,%rcx,1)
   1d645:	66 0f 6e 44 24 08    	movd   0x8(%rsp),%xmm0
   1d64b:	66 0f 7e 44 08 0c    	movd   %xmm0,0xc(%rax,%rcx,1)
   1d651:	49 8d 44 24 01       	lea    0x1(%r12),%rax
   1d656:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   1d65b:	48 83 bc 24 c0 01 00 	cmpq   $0x0,0x1c0(%rsp)
   1d662:	00 00 
   1d664:	74 2e                	je     1d694 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x534>
   1d666:	8b bc 24 c8 01 00 00 	mov    0x1c8(%rsp),%edi
   1d66d:	49 8b b5 18 01 00 00 	mov    0x118(%r13),%rsi
   1d674:	48 39 fe             	cmp    %rdi,%rsi
   1d677:	0f 86 3d 07 00 00    	jbe    1ddba <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc5a>
   1d67d:	49 8b 85 10 01 00 00 	mov    0x110(%r13),%rax
   1d684:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
   1d688:	66 0f 6e 44 08 50    	movd   0x50(%rax,%rcx,1),%xmm0
   1d68e:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
   1d692:	eb 09                	jmp    1d69d <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x53d>
   1d694:	66 0f ef c0          	pxor   %xmm0,%xmm0
   1d698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   1d69d:	48 8b 8c 24 b0 01 00 	mov    0x1b0(%rsp),%rcx
   1d6a4:	00 
   1d6a5:	48 8b 94 24 b8 01 00 	mov    0x1b8(%rsp),%rdx
   1d6ac:	00 
   1d6ad:	f3 0f 7e 4a 44       	movq   0x44(%rdx),%xmm1
   1d6b2:	66 0f d6 8c 24 f0 00 	movq   %xmm1,0xf0(%rsp)
   1d6b9:	00 00 
   1d6bb:	66 0f 7e 84 24 f8 00 	movd   %xmm0,0xf8(%rsp)
   1d6c2:	00 00 
   1d6c4:	89 84 24 fc 00 00 00 	mov    %eax,0xfc(%rsp)
   1d6cb:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
   1d6d2:	83 e1 01             	and    $0x1,%ecx
   1d6d5:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
   1d6dc:	00 
   1d6dd:	48 8d b4 24 d8 01 00 	lea    0x1d8(%rsp),%rsi
   1d6e4:	00 
   1d6e5:	48 89 ea             	mov    %rbp,%rdx
   1d6e8:	ff 15 32 2d 04 00    	call   *0x42d32(%rip)        # 60420 <_DYNAMIC+0x258>
   1d6ee:	66 0f 6f c8          	movdqa %xmm0,%xmm1
   1d6f2:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   1d6f8:	0f 84 1a fe ff ff    	je     1d518 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b8>
   1d6fe:	66 0f 7e 4c 24 50    	movd   %xmm1,0x50(%rsp)
   1d704:	8b bc 24 d0 01 00 00 	mov    0x1d0(%rsp),%edi
   1d70b:	49 8b 75 58          	mov    0x58(%r13),%rsi
   1d70f:	48 39 fe             	cmp    %rdi,%rsi
   1d712:	0f 86 96 06 00 00    	jbe    1ddae <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc4e>
   1d718:	49 8b 45 50          	mov    0x50(%r13),%rax
   1d71c:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
   1d720:	48 c1 e1 04          	shl    $0x4,%rcx
   1d724:	f3 41 0f 6f 45 68    	movdqu 0x68(%r13),%xmm0
   1d72a:	41 0f 10 8d 80 00 00 	movups 0x80(%r13),%xmm1
   1d731:	00 
   1d732:	f3 41 0f 6f 95 98 00 	movdqu 0x98(%r13),%xmm2
   1d739:	00 00 
   1d73b:	f3 0f 7f 84 24 f0 00 	movdqu %xmm0,0xf0(%rsp)
   1d742:	00 00 
   1d744:	0f 11 8c 24 00 01 00 	movups %xmm1,0x100(%rsp)
   1d74b:	00 
   1d74c:	f3 0f 7f 94 24 10 01 	movdqu %xmm2,0x110(%rsp)
   1d753:	00 00 
   1d755:	48 8b 44 08 50       	mov    0x50(%rax,%rcx,1),%rax
   1d75a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
   1d761:	00 
   1d762:	8b b4 24 28 02 00 00 	mov    0x228(%rsp),%esi
   1d769:	8b 94 24 2c 02 00 00 	mov    0x22c(%rsp),%edx
   1d770:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
   1d777:	00 
   1d778:	ff 15 92 2c 04 00    	call   *0x42c92(%rip)        # 60410 <_DYNAMIC+0x248>
   1d77e:	66 0f 6e 4c 24 50    	movd   0x50(%rsp),%xmm1
   1d784:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
   1d78b:	00 
   1d78c:	48 39 c2             	cmp    %rax,%rdx
   1d78f:	0f 82 44 01 00 00    	jb     1d8d9 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x779>
   1d795:	48 3b 94 24 90 00 00 	cmp    0x90(%rsp),%rdx
   1d79c:	00 
   1d79d:	0f 87 36 01 00 00    	ja     1d8d9 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x779>
   1d7a3:	48 89 d1             	mov    %rdx,%rcx
   1d7a6:	48 29 c1             	sub    %rax,%rcx
   1d7a9:	48 8d 34 85 00 00 00 	lea    0x0(,%rax,4),%rsi
   1d7b0:	00 
   1d7b1:	4c 01 ee             	add    %r13,%rsi
   1d7b4:	4c 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%r8
   1d7bb:	00 
   1d7bc:	48 8d 3c 95 00 00 00 	lea    0x0(,%rdx,4),%rdi
   1d7c3:	00 
   1d7c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   1d7cb:	00 00 00 00 00 
   1d7d0:	4c 39 c7             	cmp    %r8,%rdi
   1d7d3:	74 11                	je     1d7e6 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x686>
   1d7d5:	43 83 7c 05 00 ff    	cmpl   $0xffffffff,0x0(%r13,%r8,1)
   1d7db:	4d 8d 40 04          	lea    0x4(%r8),%r8
   1d7df:	74 ef                	je     1d7d0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x670>
   1d7e1:	e9 f3 00 00 00       	jmp    1d8d9 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x779>
   1d7e6:	4d 89 e0             	mov    %r12,%r8
   1d7e9:	49 c1 e8 20          	shr    $0x20,%r8
   1d7ed:	0f 85 e6 00 00 00    	jne    1d8d9 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x779>
   1d7f3:	48 39 c2             	cmp    %rax,%rdx
   1d7f6:	0f 84 1c fd ff ff    	je     1d518 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b8>
   1d7fc:	48 c1 e0 02          	shl    $0x2,%rax
   1d800:	48 29 c7             	sub    %rax,%rdi
   1d803:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
   1d807:	48 89 f2             	mov    %rsi,%rdx
   1d80a:	48 83 ff 1c          	cmp    $0x1c,%rdi
   1d80e:	72 4f                	jb     1d85f <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x6ff>
   1d810:	48 c1 ef 02          	shr    $0x2,%rdi
   1d814:	48 ff c7             	inc    %rdi
   1d817:	49 89 f8             	mov    %rdi,%r8
   1d81a:	48 ba f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rdx
   1d821:	ff ff 7f 
   1d824:	49 21 d0             	and    %rdx,%r8
   1d827:	4a 8d 14 86          	lea    (%rsi,%r8,4),%rdx
   1d82b:	66 41 0f 6e c4       	movd   %r12d,%xmm0
   1d830:	66 0f 70 c0 00       	pshufd $0x0,%xmm0,%xmm0
   1d835:	4c 01 e8             	add    %r13,%rax
   1d838:	48 83 c0 10          	add    $0x10,%rax
   1d83c:	45 31 c9             	xor    %r9d,%r9d
   1d83f:	90                   	nop
   1d840:	f3 42 0f 7f 44 88 f0 	movdqu %xmm0,-0x10(%rax,%r9,4)
   1d847:	f3 42 0f 7f 04 88    	movdqu %xmm0,(%rax,%r9,4)
   1d84d:	49 83 c1 08          	add    $0x8,%r9
   1d851:	4d 39 c8             	cmp    %r9,%r8
   1d854:	75 ea                	jne    1d840 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x6e0>
   1d856:	4c 39 c7             	cmp    %r8,%rdi
   1d859:	0f 84 b9 fc ff ff    	je     1d518 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b8>
   1d85f:	48 8d 04 8e          	lea    (%rsi,%rcx,4),%rax
   1d863:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1d86a:	84 00 00 00 00 00 
   1d870:	44 89 22             	mov    %r12d,(%rdx)
   1d873:	48 83 c2 04          	add    $0x4,%rdx
   1d877:	48 39 c2             	cmp    %rax,%rdx
   1d87a:	75 f4                	jne    1d870 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x710>
   1d87c:	e9 97 fc ff ff       	jmp    1d518 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b8>
   1d881:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1d888:	00 
   1d889:	e8 62 1b 00 00       	call   1f3f0 <<parley::layout::run::Run<()>>::advance>
   1d88e:	4c 8b bc 24 d0 00 00 	mov    0xd0(%rsp),%r15
   1d895:	00 
   1d896:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
   1d89d:	00 
   1d89e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1d8a3:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
   1d8a8:	48 8b 94 24 c0 00 00 	mov    0xc0(%rsp),%rdx
   1d8af:	00 
   1d8b0:	4c 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%r9
   1d8b7:	00 
   1d8b8:	4c 8b 94 24 b0 00 00 	mov    0xb0(%rsp),%r10
   1d8bf:	00 
   1d8c0:	4c 8b 9c 24 a8 00 00 	mov    0xa8(%rsp),%r11
   1d8c7:	00 
   1d8c8:	4c 8b ac 24 a0 00 00 	mov    0xa0(%rsp),%r13
   1d8cf:	00 
   1d8d0:	8b 74 24 28          	mov    0x28(%rsp),%esi
   1d8d4:	e9 61 fb ff ff       	jmp    1d43a <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x2da>
   1d8d9:	48 8b 74 24 68       	mov    0x68(%rsp),%rsi
   1d8de:	48 85 f6             	test   %rsi,%rsi
   1d8e1:	74 14                	je     1d8f7 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x797>
   1d8e3:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
   1d8e8:	48 c1 e6 04          	shl    $0x4,%rsi
   1d8ec:	ba 04 00 00 00       	mov    $0x4,%edx
   1d8f1:	ff 15 69 2b 04 00    	call   *0x42b69(%rip)        # 60460 <_DYNAMIC+0x298>
   1d8f7:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
   1d8fe:	00 
   1d8ff:	48 85 f6             	test   %rsi,%rsi
   1d902:	0f 84 91 f8 ff ff    	je     1d199 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x39>
   1d908:	48 c1 e6 02          	shl    $0x2,%rsi
   1d90c:	ba 04 00 00 00       	mov    $0x4,%edx
   1d911:	4c 89 ef             	mov    %r13,%rdi
   1d914:	ff 15 46 2b 04 00    	call   *0x42b46(%rip)        # 60460 <_DYNAMIC+0x298>
   1d91a:	e9 7a f8 ff ff       	jmp    1d199 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x39>
   1d91f:	0f 10 00             	movups (%rax),%xmm0
   1d922:	0f 10 48 10          	movups 0x10(%rax),%xmm1
   1d926:	f3 0f 6f 50 20       	movdqu 0x20(%rax),%xmm2
   1d92b:	66 0f 7f 94 24 50 01 	movdqa %xmm2,0x150(%rsp)
   1d932:	00 00 
   1d934:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
   1d93b:	00 
   1d93c:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
   1d943:	00 
   1d944:	66 0f 6f 84 24 30 01 	movdqa 0x130(%rsp),%xmm0
   1d94b:	00 00 
   1d94d:	66 0f 6f 8c 24 40 01 	movdqa 0x140(%rsp),%xmm1
   1d954:	00 00 
   1d956:	66 0f 6f 94 24 50 01 	movdqa 0x150(%rsp),%xmm2
   1d95d:	00 00 
   1d95f:	f3 0f 7f 94 24 70 03 	movdqu %xmm2,0x370(%rsp)
   1d966:	00 00 
   1d968:	f3 0f 7f 8c 24 60 03 	movdqu %xmm1,0x360(%rsp)
   1d96f:	00 00 
   1d971:	f3 0f 7f 84 24 50 03 	movdqu %xmm0,0x350(%rsp)
   1d978:	00 00 
   1d97a:	48 8b 8c 24 e0 00 00 	mov    0xe0(%rsp),%rcx
   1d981:	00 
   1d982:	4c 8b 21             	mov    (%rcx),%r12
   1d985:	48 8b 59 08          	mov    0x8(%rcx),%rbx
   1d989:	49 39 dc             	cmp    %rbx,%r12
   1d98c:	0f 97 c0             	seta   %al
   1d98f:	4c 89 bc 24 48 03 00 	mov    %r15,0x348(%rsp)
   1d996:	00 
   1d997:	0a 41 10             	or     0x10(%rcx),%al
   1d99a:	a8 01                	test   $0x1,%al
   1d99c:	0f 85 49 03 00 00    	jne    1dceb <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb8b>
   1d9a2:	48 8b 84 24 68 03 00 	mov    0x368(%rsp),%rax
   1d9a9:	00 
   1d9aa:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1d9af:	4c 8b ac 24 70 03 00 	mov    0x370(%rsp),%r13
   1d9b6:	00 
   1d9b7:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
   1d9be:	00 
   1d9bf:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
   1d9c4:	48 8b ac 24 58 03 00 	mov    0x358(%rsp),%rbp
   1d9cb:	00 
   1d9cc:	48 8b 84 24 78 03 00 	mov    0x378(%rsp),%rax
   1d9d3:	00 
   1d9d4:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1d9d9:	4d 89 e6             	mov    %r12,%r14
   1d9dc:	0f 1f 40 00          	nopl   0x0(%rax)
   1d9e0:	49 39 dc             	cmp    %rbx,%r12
   1d9e3:	49 83 d6 00          	adc    $0x0,%r14
   1d9e7:	4d 85 e4             	test   %r12,%r12
   1d9ea:	0f 84 20 02 00 00    	je     1dc10 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab0>
   1d9f0:	49 8d 44 24 ff       	lea    -0x1(%r12),%rax
   1d9f5:	4c 39 e8             	cmp    %r13,%rax
   1d9f8:	0f 83 12 02 00 00    	jae    1dc10 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab0>
   1d9fe:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   1da03:	42 8b 44 a0 fc       	mov    -0x4(%rax,%r12,4),%eax
   1da08:	4d 39 ec             	cmp    %r13,%r12
   1da0b:	0f 83 2f 02 00 00    	jae    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da11:	48 39 c5             	cmp    %rax,%rbp
   1da14:	0f 86 26 02 00 00    	jbe    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da1a:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
   1da1f:	42 8b 3c a1          	mov    (%rcx,%r12,4),%edi
   1da23:	48 39 fd             	cmp    %rdi,%rbp
   1da26:	0f 86 14 02 00 00    	jbe    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da2c:	48 89 c1             	mov    %rax,%rcx
   1da2f:	48 c1 e1 04          	shl    $0x4,%rcx
   1da33:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   1da38:	48 01 f1             	add    %rsi,%rcx
   1da3b:	48 89 fa             	mov    %rdi,%rdx
   1da3e:	48 c1 e2 04          	shl    $0x4,%rdx
   1da42:	44 8b 01             	mov    (%rcx),%r8d
   1da45:	44 3b 04 16          	cmp    (%rsi,%rdx,1),%r8d
   1da49:	0f 85 f1 01 00 00    	jne    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da4f:	48 03 54 24 10       	add    0x10(%rsp),%rdx
   1da54:	44 8b 49 04          	mov    0x4(%rcx),%r9d
   1da58:	44 3b 4a 04          	cmp    0x4(%rdx),%r9d
   1da5c:	0f 85 de 01 00 00    	jne    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da62:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   1da67:	4c 39 86 18 01 00 00 	cmp    %r8,0x118(%rsi)
   1da6e:	0f 86 cc 01 00 00    	jbe    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da74:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   1da79:	48 8b b6 10 01 00 00 	mov    0x110(%rsi),%rsi
   1da80:	4d 6b c0 70          	imul   $0x70,%r8,%r8
   1da84:	4e 03 4c 06 10       	add    0x10(%rsi,%r8,1),%r9
   1da89:	4e 3b 4c 06 18       	cmp    0x18(%rsi,%r8,1),%r9
   1da8e:	0f 83 ac 01 00 00    	jae    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da94:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1da99:	4d 3b 8a 30 01 00 00 	cmp    0x130(%r10),%r9
   1daa0:	0f 83 9a 01 00 00    	jae    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1daa6:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1daab:	4d 8b 92 28 01 00 00 	mov    0x128(%r10),%r10
   1dab2:	4f 8d 0c 89          	lea    (%r9,%r9,4),%r9
   1dab6:	43 80 7c ca 21 00    	cmpb   $0x0,0x21(%r10,%r9,8)
   1dabc:	0f 85 7e 01 00 00    	jne    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1dac2:	4f 8d 0c ca          	lea    (%r10,%r9,8),%r9
   1dac6:	4d 8b 49 10          	mov    0x10(%r9),%r9
   1daca:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1dacf:	4d 3b 4a 58          	cmp    0x58(%r10),%r9
   1dad3:	0f 83 67 01 00 00    	jae    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1dad9:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1dade:	4d 3b 8a e8 00 00 00 	cmp    0xe8(%r10),%r9
   1dae5:	0f 83 55 01 00 00    	jae    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1daeb:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1daf0:	4d 8b 52 50          	mov    0x50(%r10),%r10
   1daf4:	4f 8d 0c c9          	lea    (%r9,%r9,8),%r9
   1daf8:	49 c1 e1 04          	shl    $0x4,%r9
   1dafc:	47 0f b6 9c 0a 8c 00 	movzbl 0x8c(%r10,%r9,1),%r11d
   1db03:	00 00 
   1db05:	4c 8d 57 01          	lea    0x1(%rdi),%r10
   1db09:	49 39 c2             	cmp    %rax,%r10
   1db0c:	0f 94 44 24 50       	sete   0x50(%rsp)
   1db11:	45 31 d2             	xor    %r10d,%r10d
   1db14:	4c 8d 48 01          	lea    0x1(%rax),%r9
   1db18:	49 39 f9             	cmp    %rdi,%r9
   1db1b:	40 0f 94 c7          	sete   %dil
   1db1f:	45 89 d9             	mov    %r11d,%r9d
   1db22:	41 f6 c3 01          	test   $0x1,%r11b
   1db26:	74 08                	je     1db30 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x9d0>
   1db28:	0f b6 7c 24 50       	movzbl 0x50(%rsp),%edi
   1db2d:	45 31 d2             	xor    %r10d,%r10d
   1db30:	41 88 fa             	mov    %dil,%r10b
   1db33:	41 80 fa 01          	cmp    $0x1,%r10b
   1db37:	0f 85 03 01 00 00    	jne    1dc40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1db3d:	41 f6 c1 01          	test   $0x1,%r9b
   1db41:	75 03                	jne    1db46 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x9e6>
   1db43:	48 89 d1             	mov    %rdx,%rcx
   1db46:	4c 01 c6             	add    %r8,%rsi
   1db49:	f3 0f 10 41 0c       	movss  0xc(%rcx),%xmm0
   1db4e:	f3 0f 10 4e 40       	movss  0x40(%rsi),%xmm1
   1db53:	f3 0f 10 56 44       	movss  0x44(%rsi),%xmm2
   1db58:	0f 28 d9             	movaps %xmm1,%xmm3
   1db5b:	f3 0f 5d 5e 48       	minss  0x48(%rsi),%xmm3
   1db60:	0f 28 e3             	movaps %xmm3,%xmm4
   1db63:	f3 0f c2 e3 03       	cmpunordss %xmm3,%xmm4
   1db68:	0f 28 ec             	movaps %xmm4,%xmm5
   1db6b:	0f 55 eb             	andnps %xmm3,%xmm5
   1db6e:	0f 54 e1             	andps  %xmm1,%xmm4
   1db71:	0f 56 e5             	orps   %xmm5,%xmm4
   1db74:	f3 0f 10 4c 24 2c    	movss  0x2c(%rsp),%xmm1
   1db7a:	f3 0f 58 c8          	addss  %xmm0,%xmm1
   1db7e:	0f 28 da             	movaps %xmm2,%xmm3
   1db81:	f3 0f 5f 5e 4c       	maxss  0x4c(%rsi),%xmm3
   1db86:	0f 28 eb             	movaps %xmm3,%xmm5
   1db89:	f3 0f c2 eb 03       	cmpunordss %xmm3,%xmm5
   1db8e:	0f 28 f5             	movaps %xmm5,%xmm6
   1db91:	0f 55 f3             	andnps %xmm3,%xmm6
   1db94:	0f 54 ea             	andps  %xmm2,%xmm5
   1db97:	0f 56 ee             	orps   %xmm6,%xmm5
   1db9a:	0f 14 c8             	unpcklps %xmm0,%xmm1
   1db9d:	0f 14 ec             	unpcklps %xmm4,%xmm5
   1dba0:	0f 16 cd             	movlhps %xmm5,%xmm1
   1dba3:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
   1dba6:	0f 5a d5             	cvtps2pd %xmm5,%xmm2
   1dba9:	66 0f 6f c8          	movdqa %xmm0,%xmm1
   1dbad:	66 0f 6c ca          	punpcklqdq %xmm2,%xmm1
   1dbb1:	66 0f 6f d8          	movdqa %xmm0,%xmm3
   1dbb5:	66 0f 6d da          	punpckhqdq %xmm2,%xmm3
   1dbb9:	f3 0f 7f 9c 24 60 02 	movdqu %xmm3,0x260(%rsp)
   1dbc0:	00 00 
   1dbc2:	f3 0f 7f 8c 24 50 02 	movdqu %xmm1,0x250(%rsp)
   1dbc9:	00 00 
   1dbcb:	f3 0f 7f 9c 24 40 02 	movdqu %xmm3,0x240(%rsp)
   1dbd2:	00 00 
   1dbd4:	66 0f d6 84 24 70 02 	movq   %xmm0,0x270(%rsp)
   1dbdb:	00 00 
   1dbdd:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1dbe2:	48 8b 00             	mov    (%rax),%rax
   1dbe5:	4c 31 e0             	xor    %r12,%rax
   1dbe8:	66 0f 6f c8          	movdqa %xmm0,%xmm1
   1dbec:	66 0f 6c ca          	punpcklqdq %xmm2,%xmm1
   1dbf0:	66 0f 6d c2          	punpckhqdq %xmm2,%xmm0
   1dbf4:	66 0f 6f d0          	movdqa %xmm0,%xmm2
   1dbf8:	66 0f 6f d9          	movdqa %xmm1,%xmm3
   1dbfc:	e9 b4 00 00 00       	jmp    1dcb5 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb55>
   1dc01:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1dc08:	0f 1f 84 00 00 00 00 
   1dc0f:	00 
   1dc10:	31 c9                	xor    %ecx,%ecx
   1dc12:	4d 39 ec             	cmp    %r13,%r12
   1dc15:	73 46                	jae    1dc5d <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xafd>
   1dc17:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   1dc1c:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
   1dc20:	49 89 c0             	mov    %rax,%r8
   1dc23:	49 c1 e0 04          	shl    $0x4,%r8
   1dc27:	4c 03 44 24 10       	add    0x10(%rsp),%r8
   1dc2c:	48 39 c5             	cmp    %rax,%rbp
   1dc2f:	b8 00 00 00 00       	mov    $0x0,%eax
   1dc34:	4c 0f 46 c0          	cmovbe %rax,%r8
   1dc38:	eb 26                	jmp    1dc60 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb00>
   1dc3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   1dc40:	48 89 c1             	mov    %rax,%rcx
   1dc43:	48 c1 e1 04          	shl    $0x4,%rcx
   1dc47:	48 03 4c 24 10       	add    0x10(%rsp),%rcx
   1dc4c:	48 39 c5             	cmp    %rax,%rbp
   1dc4f:	b8 00 00 00 00       	mov    $0x0,%eax
   1dc54:	48 0f 46 c8          	cmovbe %rax,%rcx
   1dc58:	4d 39 ec             	cmp    %r13,%r12
   1dc5b:	72 ba                	jb     1dc17 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab7>
   1dc5d:	45 31 c0             	xor    %r8d,%r8d
   1dc60:	48 8d bc 24 38 02 00 	lea    0x238(%rsp),%rdi
   1dc67:	00 
   1dc68:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   1dc6d:	4c 89 e2             	mov    %r12,%rdx
   1dc70:	66 0f 6e 44 24 2c    	movd   0x2c(%rsp),%xmm0
   1dc76:	e8 e5 01 00 00       	call   1de60 <parley::editing::geometry::pair_from_entries::<()>>
   1dc7b:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1dc80:	48 8b 00             	mov    (%rax),%rax
   1dc83:	4c 31 e0             	xor    %r12,%rax
   1dc86:	48 83 bc 24 38 02 00 	cmpq   $0x1,0x238(%rsp)
   1dc8d:	00 01 
   1dc8f:	75 41                	jne    1dcd2 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb72>
   1dc91:	f3 0f 6f 84 24 40 02 	movdqu 0x240(%rsp),%xmm0
   1dc98:	00 00 
   1dc9a:	f3 0f 6f 8c 24 50 02 	movdqu 0x250(%rsp),%xmm1
   1dca1:	00 00 
   1dca3:	f3 0f 6f 94 24 60 02 	movdqu 0x260(%rsp),%xmm2
   1dcaa:	00 00 
   1dcac:	f3 0f 6f 9c 24 70 02 	movdqu 0x270(%rsp),%xmm3
   1dcb3:	00 00 
   1dcb5:	66 0f ef cb          	pxor   %xmm3,%xmm1
   1dcb9:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1dcbd:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1dcc1:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1dcc6:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1dcca:	66 48 0f 7e c9       	movq   %xmm1,%rcx
   1dccf:	48 31 c8             	xor    %rcx,%rax
   1dcd2:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   1dcd7:	48 89 01             	mov    %rax,(%rcx)
   1dcda:	49 39 dc             	cmp    %rbx,%r12
   1dcdd:	73 0c                	jae    1dceb <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb8b>
   1dcdf:	4d 89 f4             	mov    %r14,%r12
   1dce2:	49 39 de             	cmp    %rbx,%r14
   1dce5:	0f 86 f5 fc ff ff    	jbe    1d9e0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x880>
   1dceb:	4d 85 ff             	test   %r15,%r15
   1dcee:	74 1a                	je     1dd0a <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbaa>
   1dcf0:	48 8b bc 24 50 03 00 	mov    0x350(%rsp),%rdi
   1dcf7:	00 
   1dcf8:	49 c1 e7 04          	shl    $0x4,%r15
   1dcfc:	ba 04 00 00 00       	mov    $0x4,%edx
   1dd01:	4c 89 fe             	mov    %r15,%rsi
   1dd04:	ff 15 56 27 04 00    	call   *0x42756(%rip)        # 60460 <_DYNAMIC+0x298>
   1dd0a:	48 8b b4 24 60 03 00 	mov    0x360(%rsp),%rsi
   1dd11:	00 
   1dd12:	48 85 f6             	test   %rsi,%rsi
   1dd15:	74 17                	je     1dd2e <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbce>
   1dd17:	48 8b bc 24 68 03 00 	mov    0x368(%rsp),%rdi
   1dd1e:	00 
   1dd1f:	48 c1 e6 02          	shl    $0x2,%rsi
   1dd23:	ba 04 00 00 00       	mov    $0x4,%edx
   1dd28:	ff 15 32 27 04 00    	call   *0x42732(%rip)        # 60460 <_DYNAMIC+0x298>
   1dd2e:	31 c0                	xor    %eax,%eax
   1dd30:	e9 66 f4 ff ff       	jmp    1d19b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b>
   1dd35:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
   1dd3a:	48 8d 44 24 70       	lea    0x70(%rsp),%rax
   1dd3f:	0f 10 00             	movups (%rax),%xmm0
   1dd42:	0f 10 48 10          	movups 0x10(%rax),%xmm1
   1dd46:	f3 0f 6f 50 20       	movdqu 0x20(%rax),%xmm2
   1dd4b:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
   1dd52:	00 
   1dd53:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
   1dd5a:	00 
   1dd5b:	66 0f 7f 94 24 50 01 	movdqa %xmm2,0x150(%rsp)
   1dd62:	00 00 
   1dd64:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
   1dd68:	0f 85 d6 fb ff ff    	jne    1d944 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7e4>
   1dd6e:	e9 26 f4 ff ff       	jmp    1d199 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x39>
   1dd73:	48 8d 0d 56 03 04 00 	lea    0x40356(%rip),%rcx        # 5e0d0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.10.llvm.16159360244280900074>
   1dd7a:	48 89 c7             	mov    %rax,%rdi
   1dd7d:	ff 15 7d 26 04 00    	call   *0x4267d(%rip)        # 60400 <_DYNAMIC+0x238>
   1dd83:	eb 74                	jmp    1ddf9 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc99>
   1dd85:	48 8d 3d 81 8a fe ff 	lea    -0x1757f(%rip),%rdi        # 680d <anon.5cab36dad6fad55fc602ca21d50a03ec.0.llvm.18336280871641450522>
   1dd8c:	48 8d 15 f5 07 04 00 	lea    0x407f5(%rip),%rdx        # 5e588 <anon.5cab36dad6fad55fc602ca21d50a03ec.38.llvm.18336280871641450522>
   1dd93:	be 63 00 00 00       	mov    $0x63,%esi
   1dd98:	ff 15 6a 26 04 00    	call   *0x4266a(%rip)        # 60408 <_DYNAMIC+0x240>
   1dd9e:	eb 59                	jmp    1ddf9 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc99>
   1dda0:	bf 04 00 00 00       	mov    $0x4,%edi
   1dda5:	4c 89 ee             	mov    %r13,%rsi
   1dda8:	ff 15 82 26 04 00    	call   *0x42682(%rip)        # 60430 <_DYNAMIC+0x268>
   1ddae:	48 8d 05 93 03 04 00 	lea    0x40393(%rip),%rax        # 5e148 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074>
   1ddb5:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   1ddba:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
   1ddbf:	ff 15 33 26 04 00    	call   *0x42633(%rip)        # 603f8 <_DYNAMIC+0x230>
   1ddc5:	eb 32                	jmp    1ddf9 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc99>
   1ddc7:	4c 89 5c 24 30       	mov    %r11,0x30(%rsp)
   1ddcc:	48 8d 0d 4d 04 04 00 	lea    0x4044d(%rip),%rcx        # 5e220 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0xd8>
   1ddd3:	eb 0c                	jmp    1dde1 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc81>
   1ddd5:	4c 89 6c 24 30       	mov    %r13,0x30(%rsp)
   1ddda:	48 8d 0d 57 04 04 00 	lea    0x40457(%rip),%rcx        # 5e238 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0xf0>
   1dde1:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
   1dde6:	48 89 c7             	mov    %rax,%rdi
   1dde9:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
   1ddee:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
   1ddf3:	ff 15 ff 25 04 00    	call   *0x425ff(%rip)        # 603f8 <_DYNAMIC+0x230>
   1ddf9:	0f 0b                	ud2
   1ddfb:	eb 1e                	jmp    1de1b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcbb>
   1ddfd:	eb 1c                	jmp    1de1b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcbb>
   1ddff:	eb 1a                	jmp    1de1b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcbb>
   1de01:	48 89 c3             	mov    %rax,%rbx
   1de04:	48 8d bc 24 48 03 00 	lea    0x348(%rsp),%rdi
   1de0b:	00 
   1de0c:	e8 bf ee ff ff       	call   1ccd0 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
   1de11:	48 89 df             	mov    %rbx,%rdi
   1de14:	e8 c7 f1 03 00       	call   5cfe0 <_Unwind_Resume@plt>
   1de19:	eb 00                	jmp    1de1b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcbb>
   1de1b:	48 89 c3             	mov    %rax,%rbx
   1de1e:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   1de23:	e8 a8 ee ff ff       	call   1ccd0 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
   1de28:	48 89 df             	mov    %rbx,%rdi
   1de2b:	e8 b0 f1 03 00       	call   5cfe0 <_Unwind_Resume@plt>
   1de30:	48 89 c3             	mov    %rax,%rbx
   1de33:	4d 85 ff             	test   %r15,%r15
   1de36:	75 08                	jne    1de40 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xce0>
   1de38:	48 89 df             	mov    %rbx,%rdi
   1de3b:	e8 a0 f1 03 00       	call   5cfe0 <_Unwind_Resume@plt>
   1de40:	ba 04 00 00 00       	mov    $0x4,%edx
   1de45:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   1de4a:	4c 89 ee             	mov    %r13,%rsi
   1de4d:	ff 15 0d 26 04 00    	call   *0x4260d(%rip)        # 60460 <_DYNAMIC+0x298>
   1de53:	48 89 df             	mov    %rbx,%rdi
   1de56:	e8 85 f1 03 00       	call   5cfe0 <_Unwind_Resume@plt>
