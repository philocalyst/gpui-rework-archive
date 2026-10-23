
/tmp/gpui-caret-transaction-bin/62e-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001d0f0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>:
   1d0f0:	55                   	push   %rbp
   1d0f1:	41 57                	push   %r15
   1d0f3:	41 56                	push   %r14
   1d0f5:	41 55                	push   %r13
   1d0f7:	41 54                	push   %r12
   1d0f9:	53                   	push   %rbx
   1d0fa:	48 81 ec 58 04 00 00 	sub    $0x458,%rsp
   1d101:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
   1d106:	f3 0f 11 44 24 2c    	movss  %xmm0,0x2c(%rsp)
   1d10c:	4c 8b 7f 70          	mov    0x70(%rdi),%r15
   1d110:	4c 89 f8             	mov    %r15,%rax
   1d113:	48 c1 e8 20          	shr    $0x20,%rax
   1d117:	75 10                	jne    1d129 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x39>
   1d119:	4c 8b a7 18 01 00 00 	mov    0x118(%rdi),%r12
   1d120:	4c 89 e0             	mov    %r12,%rax
   1d123:	48 c1 e8 20          	shr    $0x20,%rax
   1d127:	74 14                	je     1d13d <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4d>
   1d129:	b0 02                	mov    $0x2,%al
   1d12b:	48 81 c4 58 04 00 00 	add    $0x458,%rsp
   1d132:	5b                   	pop    %rbx
   1d133:	41 5c                	pop    %r12
   1d135:	41 5d                	pop    %r13
   1d137:	41 5e                	pop    %r14
   1d139:	41 5f                	pop    %r15
   1d13b:	5d                   	pop    %rbp
   1d13c:	c3                   	ret
   1d13d:	4d 89 fd             	mov    %r15,%r13
   1d140:	49 c1 e5 04          	shl    $0x4,%r13
   1d144:	4d 85 ff             	test   %r15,%r15
   1d147:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
   1d14c:	74 2f                	je     1d17d <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x8d>
   1d14e:	48 89 f3             	mov    %rsi,%rbx
   1d151:	ff 15 41 32 04 00    	call   *0x43241(%rip)        # 60398 <_DYNAMIC+0x280>
   1d157:	be 04 00 00 00       	mov    $0x4,%esi
   1d15c:	4c 89 ef             	mov    %r13,%rdi
   1d15f:	ff 15 3b 32 04 00    	call   *0x4323b(%rip)        # 603a0 <_DYNAMIC+0x288>
   1d165:	48 85 c0             	test   %rax,%rax
   1d168:	0f 84 c2 0b 00 00    	je     1dd30 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc40>
   1d16e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1d173:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1d178:	48 89 de             	mov    %rbx,%rsi
   1d17b:	eb 0a                	jmp    1d187 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x97>
   1d17d:	b8 04 00 00 00       	mov    $0x4,%eax
   1d182:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1d187:	48 b9 f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rcx
   1d18e:	ff ff 7f 
   1d191:	48 8b 97 50 01 00 00 	mov    0x150(%rdi),%rdx
   1d198:	48 8d 2c 95 00 00 00 	lea    0x0(,%rdx,4),%rbp
   1d19f:	00 
   1d1a0:	48 89 d0             	mov    %rdx,%rax
   1d1a3:	48 c1 e8 3e          	shr    $0x3e,%rax
   1d1a7:	0f 95 c0             	setne  %al
   1d1aa:	48 83 c1 04          	add    $0x4,%rcx
   1d1ae:	48 39 cd             	cmp    %rcx,%rbp
   1d1b1:	0f 97 c1             	seta   %cl
   1d1b4:	08 c1                	or     %al,%cl
   1d1b6:	74 13                	je     1d1cb <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xdb>
   1d1b8:	31 db                	xor    %ebx,%ebx
   1d1ba:	48 89 df             	mov    %rbx,%rdi
   1d1bd:	48 89 ee             	mov    %rbp,%rsi
   1d1c0:	ff 15 ba 31 04 00    	call   *0x431ba(%rip)        # 60380 <_DYNAMIC+0x268>
   1d1c6:	e9 be 0b 00 00       	jmp    1dd89 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc99>
   1d1cb:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
   1d1d0:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
   1d1d7:	00 
   1d1d8:	48 85 ed             	test   %rbp,%rbp
   1d1db:	74 5a                	je     1d237 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x147>
   1d1dd:	ff 15 b5 31 04 00    	call   *0x431b5(%rip)        # 60398 <_DYNAMIC+0x280>
   1d1e3:	bb 04 00 00 00       	mov    $0x4,%ebx
   1d1e8:	be 04 00 00 00       	mov    $0x4,%esi
   1d1ed:	48 89 ef             	mov    %rbp,%rdi
   1d1f0:	ff 15 aa 31 04 00    	call   *0x431aa(%rip)        # 603a0 <_DYNAMIC+0x288>
   1d1f6:	48 85 c0             	test   %rax,%rax
   1d1f9:	74 bf                	je     1d1ba <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xca>
   1d1fb:	49 89 c6             	mov    %rax,%r14
   1d1fe:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
   1d203:	4c 89 eb             	mov    %r13,%rbx
   1d206:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1d20b:	49 83 fd 02          	cmp    $0x2,%r13
   1d20f:	72 39                	jb     1d24a <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x15a>
   1d211:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
   1d215:	4c 89 f7             	mov    %r14,%rdi
   1d218:	be ff 00 00 00       	mov    $0xff,%esi
   1d21d:	ff 15 b5 31 04 00    	call   *0x431b5(%rip)        # 603d8 <memset@GLIBC_2.2.5>
   1d223:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1d228:	49 8d 04 2e          	lea    (%r14,%rbp,1),%rax
   1d22c:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
   1d230:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   1d235:	eb 20                	jmp    1d257 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x167>
   1d237:	41 be 04 00 00 00    	mov    $0x4,%r14d
   1d23d:	31 db                	xor    %ebx,%ebx
   1d23f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
   1d244:	49 83 fd 02          	cmp    $0x2,%r13
   1d248:	73 c7                	jae    1d211 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x121>
   1d24a:	4c 89 f0             	mov    %r14,%rax
   1d24d:	4d 85 ed             	test   %r13,%r13
   1d250:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   1d255:	74 06                	je     1d25d <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x16d>
   1d257:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%rax)
   1d25d:	48 89 9c 24 80 00 00 	mov    %rbx,0x80(%rsp)
   1d264:	00 
   1d265:	4c 89 b4 24 88 00 00 	mov    %r14,0x88(%rsp)
   1d26c:	00 
   1d26d:	4c 89 ac 24 90 00 00 	mov    %r13,0x90(%rsp)
   1d274:	00 
   1d275:	48 89 bc 24 98 00 00 	mov    %rdi,0x98(%rsp)
   1d27c:	00 
   1d27d:	4c 89 7c 24 68       	mov    %r15,0x68(%rsp)
   1d282:	48 8d 44 24 70       	lea    0x70(%rsp),%rax
   1d287:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   1d28c:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
   1d293:	00 00 
   1d295:	4d 85 e4             	test   %r12,%r12
   1d298:	0f 84 11 06 00 00    	je     1d8af <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7bf>
   1d29e:	4c 8b b7 10 01 00 00 	mov    0x110(%rdi),%r14
   1d2a5:	4d 6b cc 70          	imul   $0x70,%r12,%r9
   1d2a9:	4d 01 f1             	add    %r14,%r9
   1d2ac:	48 8d ac 24 28 02 00 	lea    0x228(%rsp),%rbp
   1d2b3:	00 
   1d2b4:	48 8b 97 30 01 00 00 	mov    0x130(%rdi),%rdx
   1d2bb:	4c 8b 97 28 01 00 00 	mov    0x128(%rdi),%r10
   1d2c2:	4c 8b 47 58          	mov    0x58(%rdi),%r8
   1d2c6:	4c 8b 9f e8 00 00 00 	mov    0xe8(%rdi),%r11
   1d2cd:	4c 8b bf e0 00 00 00 	mov    0xe0(%rdi),%r15
   1d2d4:	4c 8b 67 50          	mov    0x50(%rdi),%r12
   1d2d8:	48 8b 47 38          	mov    0x38(%rdi),%rax
   1d2dc:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
   1d2e3:	00 
   1d2e4:	4c 8b 6f 40          	mov    0x40(%rdi),%r13
   1d2e8:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
   1d2ef:	00 00 
   1d2f1:	48 8d 05 80 0e 04 00 	lea    0x40e80(%rip),%rax        # 5e178 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0xc0>
   1d2f8:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   1d2fd:	48 8d 05 9c 0d 04 00 	lea    0x40d9c(%rip),%rax        # 5e0a0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.16.llvm.14256054827572741256>
   1d304:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   1d309:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
   1d30e:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
   1d315:	00 
   1d316:	4c 89 8c 24 b8 00 00 	mov    %r9,0xb8(%rsp)
   1d31d:	00 
   1d31e:	4c 89 94 24 b0 00 00 	mov    %r10,0xb0(%rsp)
   1d325:	00 
   1d326:	4c 89 9c 24 a8 00 00 	mov    %r11,0xa8(%rsp)
   1d32d:	00 
   1d32e:	4c 89 bc 24 d0 00 00 	mov    %r15,0xd0(%rsp)
   1d335:	00 
   1d336:	4c 89 a4 24 c8 00 00 	mov    %r12,0xc8(%rsp)
   1d33d:	00 
   1d33e:	4c 89 ac 24 a0 00 00 	mov    %r13,0xa0(%rsp)
   1d345:	00 
   1d346:	49 8b 46 10          	mov    0x10(%r14),%rax
   1d34a:	49 8b 76 18          	mov    0x18(%r14),%rsi
   1d34e:	48 39 c6             	cmp    %rax,%rsi
   1d351:	0f 82 ac 09 00 00    	jb     1dd03 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc13>
   1d357:	48 39 d6             	cmp    %rdx,%rsi
   1d35a:	0f 87 a3 09 00 00    	ja     1dd03 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc13>
   1d360:	48 39 f0             	cmp    %rsi,%rax
   1d363:	75 1a                	jne    1d37f <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x28f>
   1d365:	49 83 c6 70          	add    $0x70,%r14
   1d369:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1d36e:	ff c0                	inc    %eax
   1d370:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   1d375:	4d 39 ce             	cmp    %r9,%r14
   1d378:	75 cc                	jne    1d346 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x256>
   1d37a:	e9 46 09 00 00       	jmp    1dcc5 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbd5>
   1d37f:	f3 41 0f 10 46 28    	movss  0x28(%r14),%xmm0
   1d385:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
   1d38b:	48 8d 0c b6          	lea    (%rsi,%rsi,4),%rcx
   1d38f:	49 8d 0c ca          	lea    (%r10,%rcx,8),%rcx
   1d393:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
   1d39a:	00 
   1d39b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
   1d39f:	49 8d 1c c2          	lea    (%r10,%rax,8),%rbx
   1d3a3:	31 f6                	xor    %esi,%esi
   1d3a5:	48 8b 43 10          	mov    0x10(%rbx),%rax
   1d3a9:	80 7b 21 01          	cmpb   $0x1,0x21(%rbx)
   1d3ad:	75 40                	jne    1d3ef <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x2ff>
   1d3af:	4c 39 e8             	cmp    %r13,%rax
   1d3b2:	0f 83 ad 09 00 00    	jae    1dd65 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc75>
   1d3b8:	48 6b c0 38          	imul   $0x38,%rax,%rax
   1d3bc:	48 8b 8c 24 d8 00 00 	mov    0xd8(%rsp),%rcx
   1d3c3:	00 
   1d3c4:	f3 0f 10 44 01 24    	movss  0x24(%rcx,%rax,1),%xmm0
   1d3ca:	48 83 c3 28          	add    $0x28,%rbx
   1d3ce:	ff c6                	inc    %esi
   1d3d0:	f3 0f 10 4c 24 24    	movss  0x24(%rsp),%xmm1
   1d3d6:	f3 0f 58 c8          	addss  %xmm0,%xmm1
   1d3da:	f3 0f 11 4c 24 24    	movss  %xmm1,0x24(%rsp)
   1d3e0:	48 3b 9c 24 e8 00 00 	cmp    0xe8(%rsp),%rbx
   1d3e7:	00 
   1d3e8:	75 bb                	jne    1d3a5 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x2b5>
   1d3ea:	e9 76 ff ff ff       	jmp    1d365 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x275>
   1d3ef:	4c 39 c0             	cmp    %r8,%rax
   1d3f2:	0f 83 7e 09 00 00    	jae    1dd76 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc86>
   1d3f8:	89 74 24 28          	mov    %esi,0x28(%rsp)
   1d3fc:	4c 39 d8             	cmp    %r11,%rax
   1d3ff:	4c 8d 84 24 48 03 00 	lea    0x348(%rsp),%r8
   1d406:	00 
   1d407:	0f 83 4a 09 00 00    	jae    1dd57 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc67>
   1d40d:	48 8d 0c c0          	lea    (%rax,%rax,8),%rcx
   1d411:	48 c1 e1 04          	shl    $0x4,%rcx
   1d415:	49 8d 14 0c          	lea    (%r12,%rcx,1),%rdx
   1d419:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
   1d41d:	48 c1 e6 04          	shl    $0x4,%rsi
   1d421:	4c 01 fe             	add    %r15,%rsi
   1d424:	48 89 bc 24 60 01 00 	mov    %rdi,0x160(%rsp)
   1d42b:	00 
   1d42c:	48 89 94 24 68 01 00 	mov    %rdx,0x168(%rsp)
   1d433:	00 
   1d434:	48 89 b4 24 70 01 00 	mov    %rsi,0x170(%rsp)
   1d43b:	00 
   1d43c:	48 89 9c 24 78 01 00 	mov    %rbx,0x178(%rsp)
   1d443:	00 
   1d444:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
   1d449:	89 94 24 80 01 00 00 	mov    %edx,0x180(%rsp)
   1d450:	8b 54 24 28          	mov    0x28(%rsp),%edx
   1d454:	89 94 24 84 01 00 00 	mov    %edx,0x184(%rsp)
   1d45b:	89 84 24 88 01 00 00 	mov    %eax,0x188(%rsp)
   1d462:	41 0f b6 94 0c 8c 00 	movzbl 0x8c(%r12,%rcx,1),%edx
   1d469:	00 00 
   1d46b:	83 e2 01             	and    $0x1,%edx
   1d46e:	4c 89 c7             	mov    %r8,%rdi
   1d471:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
   1d478:	00 
   1d479:	4d 89 c5             	mov    %r8,%r13
   1d47c:	e8 2f 22 00 00       	call   1f6b0 <<parley::layout::run::Clusters<()>>::new>
   1d481:	ba 10 01 00 00       	mov    $0x110,%edx
   1d486:	4c 8d bc 24 38 02 00 	lea    0x238(%rsp),%r15
   1d48d:	00 
   1d48e:	4c 89 ff             	mov    %r15,%rdi
   1d491:	4c 89 ee             	mov    %r13,%rsi
   1d494:	ff 15 ce 2e 04 00    	call   *0x42ece(%rip)        # 60368 <memcpy@GLIBC_2.14>
   1d49a:	66 0f 6e 44 24 24    	movd   0x24(%rsp),%xmm0
   1d4a0:	66 0f 7e 44 24 08    	movd   %xmm0,0x8(%rsp)
   1d4a6:	eb 18                	jmp    1d4c0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3d0>
   1d4a8:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
   1d4ae:	f3 0f 58 c1          	addss  %xmm1,%xmm0
   1d4b2:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
   1d4b8:	4c 8d bc 24 38 02 00 	lea    0x238(%rsp),%r15
   1d4bf:	00 
   1d4c0:	48 8d bc 24 a8 01 00 	lea    0x1a8(%rsp),%rdi
   1d4c7:	00 
   1d4c8:	4c 89 fe             	mov    %r15,%rsi
   1d4cb:	e8 d0 24 00 00       	call   1f9a0 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1d4d0:	83 bc 24 a8 01 00 00 	cmpl   $0x1,0x1a8(%rsp)
   1d4d7:	01 
   1d4d8:	0f 85 33 03 00 00    	jne    1d811 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x721>
   1d4de:	0f 10 45 84          	movups -0x7c(%rbp),%xmm0
   1d4e2:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
   1d4e9:	00 
   1d4ea:	48 8b 84 24 f0 02 00 	mov    0x2f0(%rsp),%rax
   1d4f1:	00 
   1d4f2:	48 85 c0             	test   %rax,%rax
   1d4f5:	0f 84 1a 08 00 00    	je     1dd15 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc25>
   1d4fb:	4c 8b ac 24 38 02 00 	mov    0x238(%rsp),%r13
   1d502:	00 
   1d503:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
   1d50a:	00 
   1d50b:	0f 29 84 24 90 01 00 	movaps %xmm0,0x190(%rsp)
   1d512:	00 
   1d513:	4d 85 ed             	test   %r13,%r13
   1d516:	0f 84 f5 02 00 00    	je     1d811 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x721>
   1d51c:	4c 89 ac 24 a8 01 00 	mov    %r13,0x1a8(%rsp)
   1d523:	00 
   1d524:	48 8d 94 24 f8 02 00 	lea    0x2f8(%rsp),%rdx
   1d52b:	00 
   1d52c:	48 8b 8a 68 ff ff ff 	mov    -0x98(%rdx),%rcx
   1d533:	48 89 4d a8          	mov    %rcx,-0x58(%rbp)
   1d537:	0f 10 82 48 ff ff ff 	movups -0xb8(%rdx),%xmm0
   1d53e:	0f 10 8a 58 ff ff ff 	movups -0xa8(%rdx),%xmm1
   1d545:	0f 11 4d 98          	movups %xmm1,-0x68(%rbp)
   1d549:	0f 11 45 88          	movups %xmm0,-0x78(%rbp)
   1d54d:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
   1d554:	00 
   1d555:	48 8b 42 40          	mov    0x40(%rdx),%rax
   1d559:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   1d55d:	0f 10 02             	movups (%rdx),%xmm0
   1d560:	f3 0f 6f 4a 10       	movdqu 0x10(%rdx),%xmm1
   1d565:	f3 0f 6f 52 20       	movdqu 0x20(%rdx),%xmm2
   1d56a:	f3 0f 6f 5a 30       	movdqu 0x30(%rdx),%xmm3
   1d56f:	f3 0f 7f 5d e8       	movdqu %xmm3,-0x18(%rbp)
   1d574:	f3 0f 7f 55 d8       	movdqu %xmm2,-0x28(%rbp)
   1d579:	f3 0f 7f 4d c8       	movdqu %xmm1,-0x38(%rbp)
   1d57e:	0f 11 45 b8          	movups %xmm0,-0x48(%rbp)
   1d582:	0f 28 84 24 90 01 00 	movaps 0x190(%rsp),%xmm0
   1d589:	00 
   1d58a:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
   1d58e:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
   1d593:	f3 0f 7e 84 24 c8 01 	movq   0x1c8(%rsp),%xmm0
   1d59a:	00 00 
   1d59c:	66 0f 7f 44 24 50    	movdqa %xmm0,0x50(%rsp)
   1d5a2:	44 8b bc 24 28 02 00 	mov    0x228(%rsp),%r15d
   1d5a9:	00 
   1d5aa:	4c 3b 64 24 68       	cmp    0x68(%rsp),%r12
   1d5af:	75 0a                	jne    1d5bb <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4cb>
   1d5b1:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   1d5b6:	e8 a5 e3 ff ff       	call   1b960 <<alloc::raw_vec::RawVec<parley::editing::geometry::Entry>>::grow_one>
   1d5bb:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
   1d5c0:	4c 89 e1             	mov    %r12,%rcx
   1d5c3:	48 c1 e1 04          	shl    $0x4,%rcx
   1d5c7:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   1d5cc:	0f 13 04 08          	movlps %xmm0,(%rax,%rcx,1)
   1d5d0:	44 89 7c 08 08       	mov    %r15d,0x8(%rax,%rcx,1)
   1d5d5:	66 0f 6e 44 24 08    	movd   0x8(%rsp),%xmm0
   1d5db:	66 0f 7e 44 08 0c    	movd   %xmm0,0xc(%rax,%rcx,1)
   1d5e1:	49 8d 44 24 01       	lea    0x1(%r12),%rax
   1d5e6:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   1d5eb:	48 83 bc 24 c0 01 00 	cmpq   $0x0,0x1c0(%rsp)
   1d5f2:	00 00 
   1d5f4:	74 2e                	je     1d624 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x534>
   1d5f6:	8b bc 24 c8 01 00 00 	mov    0x1c8(%rsp),%edi
   1d5fd:	49 8b b5 18 01 00 00 	mov    0x118(%r13),%rsi
   1d604:	48 39 fe             	cmp    %rdi,%rsi
   1d607:	0f 86 3d 07 00 00    	jbe    1dd4a <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc5a>
   1d60d:	49 8b 85 10 01 00 00 	mov    0x110(%r13),%rax
   1d614:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
   1d618:	66 0f 6e 44 08 50    	movd   0x50(%rax,%rcx,1),%xmm0
   1d61e:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
   1d622:	eb 09                	jmp    1d62d <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x53d>
   1d624:	66 0f ef c0          	pxor   %xmm0,%xmm0
   1d628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   1d62d:	48 8b 8c 24 b0 01 00 	mov    0x1b0(%rsp),%rcx
   1d634:	00 
   1d635:	48 8b 94 24 b8 01 00 	mov    0x1b8(%rsp),%rdx
   1d63c:	00 
   1d63d:	f3 0f 7e 4a 44       	movq   0x44(%rdx),%xmm1
   1d642:	66 0f d6 8c 24 f0 00 	movq   %xmm1,0xf0(%rsp)
   1d649:	00 00 
   1d64b:	66 0f 7e 84 24 f8 00 	movd   %xmm0,0xf8(%rsp)
   1d652:	00 00 
   1d654:	89 84 24 fc 00 00 00 	mov    %eax,0xfc(%rsp)
   1d65b:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
   1d662:	83 e1 01             	and    $0x1,%ecx
   1d665:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
   1d66c:	00 
   1d66d:	48 8d b4 24 d8 01 00 	lea    0x1d8(%rsp),%rsi
   1d674:	00 
   1d675:	48 89 ea             	mov    %rbp,%rdx
   1d678:	ff 15 f2 2c 04 00    	call   *0x42cf2(%rip)        # 60370 <_DYNAMIC+0x258>
   1d67e:	66 0f 6f c8          	movdqa %xmm0,%xmm1
   1d682:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   1d688:	0f 84 1a fe ff ff    	je     1d4a8 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b8>
   1d68e:	66 0f 7e 4c 24 50    	movd   %xmm1,0x50(%rsp)
   1d694:	8b bc 24 d0 01 00 00 	mov    0x1d0(%rsp),%edi
   1d69b:	49 8b 75 58          	mov    0x58(%r13),%rsi
   1d69f:	48 39 fe             	cmp    %rdi,%rsi
   1d6a2:	0f 86 96 06 00 00    	jbe    1dd3e <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc4e>
   1d6a8:	49 8b 45 50          	mov    0x50(%r13),%rax
   1d6ac:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
   1d6b0:	48 c1 e1 04          	shl    $0x4,%rcx
   1d6b4:	f3 41 0f 6f 45 68    	movdqu 0x68(%r13),%xmm0
   1d6ba:	41 0f 10 8d 80 00 00 	movups 0x80(%r13),%xmm1
   1d6c1:	00 
   1d6c2:	f3 41 0f 6f 95 98 00 	movdqu 0x98(%r13),%xmm2
   1d6c9:	00 00 
   1d6cb:	f3 0f 7f 84 24 f0 00 	movdqu %xmm0,0xf0(%rsp)
   1d6d2:	00 00 
   1d6d4:	0f 11 8c 24 00 01 00 	movups %xmm1,0x100(%rsp)
   1d6db:	00 
   1d6dc:	f3 0f 7f 94 24 10 01 	movdqu %xmm2,0x110(%rsp)
   1d6e3:	00 00 
   1d6e5:	48 8b 44 08 50       	mov    0x50(%rax,%rcx,1),%rax
   1d6ea:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
   1d6f1:	00 
   1d6f2:	8b b4 24 28 02 00 00 	mov    0x228(%rsp),%esi
   1d6f9:	8b 94 24 2c 02 00 00 	mov    0x22c(%rsp),%edx
   1d700:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
   1d707:	00 
   1d708:	ff 15 52 2c 04 00    	call   *0x42c52(%rip)        # 60360 <_DYNAMIC+0x248>
   1d70e:	66 0f 6e 4c 24 50    	movd   0x50(%rsp),%xmm1
   1d714:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
   1d71b:	00 
   1d71c:	48 39 c2             	cmp    %rax,%rdx
   1d71f:	0f 82 44 01 00 00    	jb     1d869 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x779>
   1d725:	48 3b 94 24 90 00 00 	cmp    0x90(%rsp),%rdx
   1d72c:	00 
   1d72d:	0f 87 36 01 00 00    	ja     1d869 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x779>
   1d733:	48 89 d1             	mov    %rdx,%rcx
   1d736:	48 29 c1             	sub    %rax,%rcx
   1d739:	48 8d 34 85 00 00 00 	lea    0x0(,%rax,4),%rsi
   1d740:	00 
   1d741:	4c 01 ee             	add    %r13,%rsi
   1d744:	4c 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%r8
   1d74b:	00 
   1d74c:	48 8d 3c 95 00 00 00 	lea    0x0(,%rdx,4),%rdi
   1d753:	00 
   1d754:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   1d75b:	00 00 00 00 00 
   1d760:	4c 39 c7             	cmp    %r8,%rdi
   1d763:	74 11                	je     1d776 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x686>
   1d765:	43 83 7c 05 00 ff    	cmpl   $0xffffffff,0x0(%r13,%r8,1)
   1d76b:	4d 8d 40 04          	lea    0x4(%r8),%r8
   1d76f:	74 ef                	je     1d760 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x670>
   1d771:	e9 f3 00 00 00       	jmp    1d869 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x779>
   1d776:	4d 89 e0             	mov    %r12,%r8
   1d779:	49 c1 e8 20          	shr    $0x20,%r8
   1d77d:	0f 85 e6 00 00 00    	jne    1d869 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x779>
   1d783:	48 39 c2             	cmp    %rax,%rdx
   1d786:	0f 84 1c fd ff ff    	je     1d4a8 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b8>
   1d78c:	48 c1 e0 02          	shl    $0x2,%rax
   1d790:	48 29 c7             	sub    %rax,%rdi
   1d793:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
   1d797:	48 89 f2             	mov    %rsi,%rdx
   1d79a:	48 83 ff 1c          	cmp    $0x1c,%rdi
   1d79e:	72 4f                	jb     1d7ef <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x6ff>
   1d7a0:	48 c1 ef 02          	shr    $0x2,%rdi
   1d7a4:	48 ff c7             	inc    %rdi
   1d7a7:	49 89 f8             	mov    %rdi,%r8
   1d7aa:	48 ba f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rdx
   1d7b1:	ff ff 7f 
   1d7b4:	49 21 d0             	and    %rdx,%r8
   1d7b7:	4a 8d 14 86          	lea    (%rsi,%r8,4),%rdx
   1d7bb:	66 41 0f 6e c4       	movd   %r12d,%xmm0
   1d7c0:	66 0f 70 c0 00       	pshufd $0x0,%xmm0,%xmm0
   1d7c5:	4c 01 e8             	add    %r13,%rax
   1d7c8:	48 83 c0 10          	add    $0x10,%rax
   1d7cc:	45 31 c9             	xor    %r9d,%r9d
   1d7cf:	90                   	nop
   1d7d0:	f3 42 0f 7f 44 88 f0 	movdqu %xmm0,-0x10(%rax,%r9,4)
   1d7d7:	f3 42 0f 7f 04 88    	movdqu %xmm0,(%rax,%r9,4)
   1d7dd:	49 83 c1 08          	add    $0x8,%r9
   1d7e1:	4d 39 c8             	cmp    %r9,%r8
   1d7e4:	75 ea                	jne    1d7d0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x6e0>
   1d7e6:	4c 39 c7             	cmp    %r8,%rdi
   1d7e9:	0f 84 b9 fc ff ff    	je     1d4a8 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b8>
   1d7ef:	48 8d 04 8e          	lea    (%rsi,%rcx,4),%rax
   1d7f3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1d7fa:	84 00 00 00 00 00 
   1d800:	44 89 22             	mov    %r12d,(%rdx)
   1d803:	48 83 c2 04          	add    $0x4,%rdx
   1d807:	48 39 c2             	cmp    %rax,%rdx
   1d80a:	75 f4                	jne    1d800 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x710>
   1d80c:	e9 97 fc ff ff       	jmp    1d4a8 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b8>
   1d811:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1d818:	00 
   1d819:	e8 42 1b 00 00       	call   1f360 <<parley::layout::run::Run<()>>::advance>
   1d81e:	4c 8b bc 24 d0 00 00 	mov    0xd0(%rsp),%r15
   1d825:	00 
   1d826:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
   1d82d:	00 
   1d82e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1d833:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
   1d838:	48 8b 94 24 c0 00 00 	mov    0xc0(%rsp),%rdx
   1d83f:	00 
   1d840:	4c 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%r9
   1d847:	00 
   1d848:	4c 8b 94 24 b0 00 00 	mov    0xb0(%rsp),%r10
   1d84f:	00 
   1d850:	4c 8b 9c 24 a8 00 00 	mov    0xa8(%rsp),%r11
   1d857:	00 
   1d858:	4c 8b ac 24 a0 00 00 	mov    0xa0(%rsp),%r13
   1d85f:	00 
   1d860:	8b 74 24 28          	mov    0x28(%rsp),%esi
   1d864:	e9 61 fb ff ff       	jmp    1d3ca <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x2da>
   1d869:	48 8b 74 24 68       	mov    0x68(%rsp),%rsi
   1d86e:	48 85 f6             	test   %rsi,%rsi
   1d871:	74 14                	je     1d887 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x797>
   1d873:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
   1d878:	48 c1 e6 04          	shl    $0x4,%rsi
   1d87c:	ba 04 00 00 00       	mov    $0x4,%edx
   1d881:	ff 15 29 2b 04 00    	call   *0x42b29(%rip)        # 603b0 <_DYNAMIC+0x298>
   1d887:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
   1d88e:	00 
   1d88f:	48 85 f6             	test   %rsi,%rsi
   1d892:	0f 84 91 f8 ff ff    	je     1d129 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x39>
   1d898:	48 c1 e6 02          	shl    $0x2,%rsi
   1d89c:	ba 04 00 00 00       	mov    $0x4,%edx
   1d8a1:	4c 89 ef             	mov    %r13,%rdi
   1d8a4:	ff 15 06 2b 04 00    	call   *0x42b06(%rip)        # 603b0 <_DYNAMIC+0x298>
   1d8aa:	e9 7a f8 ff ff       	jmp    1d129 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x39>
   1d8af:	0f 10 00             	movups (%rax),%xmm0
   1d8b2:	0f 10 48 10          	movups 0x10(%rax),%xmm1
   1d8b6:	f3 0f 6f 50 20       	movdqu 0x20(%rax),%xmm2
   1d8bb:	66 0f 7f 94 24 50 01 	movdqa %xmm2,0x150(%rsp)
   1d8c2:	00 00 
   1d8c4:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
   1d8cb:	00 
   1d8cc:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
   1d8d3:	00 
   1d8d4:	66 0f 6f 84 24 30 01 	movdqa 0x130(%rsp),%xmm0
   1d8db:	00 00 
   1d8dd:	66 0f 6f 8c 24 40 01 	movdqa 0x140(%rsp),%xmm1
   1d8e4:	00 00 
   1d8e6:	66 0f 6f 94 24 50 01 	movdqa 0x150(%rsp),%xmm2
   1d8ed:	00 00 
   1d8ef:	f3 0f 7f 94 24 70 03 	movdqu %xmm2,0x370(%rsp)
   1d8f6:	00 00 
   1d8f8:	f3 0f 7f 8c 24 60 03 	movdqu %xmm1,0x360(%rsp)
   1d8ff:	00 00 
   1d901:	f3 0f 7f 84 24 50 03 	movdqu %xmm0,0x350(%rsp)
   1d908:	00 00 
   1d90a:	48 8b 8c 24 e0 00 00 	mov    0xe0(%rsp),%rcx
   1d911:	00 
   1d912:	4c 8b 21             	mov    (%rcx),%r12
   1d915:	48 8b 59 08          	mov    0x8(%rcx),%rbx
   1d919:	49 39 dc             	cmp    %rbx,%r12
   1d91c:	0f 97 c0             	seta   %al
   1d91f:	4c 89 bc 24 48 03 00 	mov    %r15,0x348(%rsp)
   1d926:	00 
   1d927:	0a 41 10             	or     0x10(%rcx),%al
   1d92a:	a8 01                	test   $0x1,%al
   1d92c:	0f 85 49 03 00 00    	jne    1dc7b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb8b>
   1d932:	48 8b 84 24 68 03 00 	mov    0x368(%rsp),%rax
   1d939:	00 
   1d93a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1d93f:	4c 8b ac 24 70 03 00 	mov    0x370(%rsp),%r13
   1d946:	00 
   1d947:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
   1d94e:	00 
   1d94f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
   1d954:	48 8b ac 24 58 03 00 	mov    0x358(%rsp),%rbp
   1d95b:	00 
   1d95c:	48 8b 84 24 78 03 00 	mov    0x378(%rsp),%rax
   1d963:	00 
   1d964:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1d969:	4d 89 e6             	mov    %r12,%r14
   1d96c:	0f 1f 40 00          	nopl   0x0(%rax)
   1d970:	49 39 dc             	cmp    %rbx,%r12
   1d973:	49 83 d6 00          	adc    $0x0,%r14
   1d977:	4d 85 e4             	test   %r12,%r12
   1d97a:	0f 84 20 02 00 00    	je     1dba0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab0>
   1d980:	49 8d 44 24 ff       	lea    -0x1(%r12),%rax
   1d985:	4c 39 e8             	cmp    %r13,%rax
   1d988:	0f 83 12 02 00 00    	jae    1dba0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab0>
   1d98e:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   1d993:	42 8b 44 a0 fc       	mov    -0x4(%rax,%r12,4),%eax
   1d998:	4d 39 ec             	cmp    %r13,%r12
   1d99b:	0f 83 2f 02 00 00    	jae    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1d9a1:	48 39 c5             	cmp    %rax,%rbp
   1d9a4:	0f 86 26 02 00 00    	jbe    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1d9aa:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
   1d9af:	42 8b 3c a1          	mov    (%rcx,%r12,4),%edi
   1d9b3:	48 39 fd             	cmp    %rdi,%rbp
   1d9b6:	0f 86 14 02 00 00    	jbe    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1d9bc:	48 89 c1             	mov    %rax,%rcx
   1d9bf:	48 c1 e1 04          	shl    $0x4,%rcx
   1d9c3:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   1d9c8:	48 01 f1             	add    %rsi,%rcx
   1d9cb:	48 89 fa             	mov    %rdi,%rdx
   1d9ce:	48 c1 e2 04          	shl    $0x4,%rdx
   1d9d2:	44 8b 01             	mov    (%rcx),%r8d
   1d9d5:	44 3b 04 16          	cmp    (%rsi,%rdx,1),%r8d
   1d9d9:	0f 85 f1 01 00 00    	jne    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1d9df:	48 03 54 24 10       	add    0x10(%rsp),%rdx
   1d9e4:	44 8b 49 04          	mov    0x4(%rcx),%r9d
   1d9e8:	44 3b 4a 04          	cmp    0x4(%rdx),%r9d
   1d9ec:	0f 85 de 01 00 00    	jne    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1d9f2:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   1d9f7:	4c 39 86 18 01 00 00 	cmp    %r8,0x118(%rsi)
   1d9fe:	0f 86 cc 01 00 00    	jbe    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da04:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   1da09:	48 8b b6 10 01 00 00 	mov    0x110(%rsi),%rsi
   1da10:	4d 6b c0 70          	imul   $0x70,%r8,%r8
   1da14:	4e 03 4c 06 10       	add    0x10(%rsi,%r8,1),%r9
   1da19:	4e 3b 4c 06 18       	cmp    0x18(%rsi,%r8,1),%r9
   1da1e:	0f 83 ac 01 00 00    	jae    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da24:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1da29:	4d 3b 8a 30 01 00 00 	cmp    0x130(%r10),%r9
   1da30:	0f 83 9a 01 00 00    	jae    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da36:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1da3b:	4d 8b 92 28 01 00 00 	mov    0x128(%r10),%r10
   1da42:	4f 8d 0c 89          	lea    (%r9,%r9,4),%r9
   1da46:	43 80 7c ca 21 00    	cmpb   $0x0,0x21(%r10,%r9,8)
   1da4c:	0f 85 7e 01 00 00    	jne    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da52:	4f 8d 0c ca          	lea    (%r10,%r9,8),%r9
   1da56:	4d 8b 49 10          	mov    0x10(%r9),%r9
   1da5a:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1da5f:	4d 3b 4a 58          	cmp    0x58(%r10),%r9
   1da63:	0f 83 67 01 00 00    	jae    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da69:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1da6e:	4d 3b 8a e8 00 00 00 	cmp    0xe8(%r10),%r9
   1da75:	0f 83 55 01 00 00    	jae    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1da7b:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
   1da80:	4d 8b 52 50          	mov    0x50(%r10),%r10
   1da84:	4f 8d 0c c9          	lea    (%r9,%r9,8),%r9
   1da88:	49 c1 e1 04          	shl    $0x4,%r9
   1da8c:	47 0f b6 9c 0a 8c 00 	movzbl 0x8c(%r10,%r9,1),%r11d
   1da93:	00 00 
   1da95:	4c 8d 57 01          	lea    0x1(%rdi),%r10
   1da99:	49 39 c2             	cmp    %rax,%r10
   1da9c:	0f 94 44 24 50       	sete   0x50(%rsp)
   1daa1:	45 31 d2             	xor    %r10d,%r10d
   1daa4:	4c 8d 48 01          	lea    0x1(%rax),%r9
   1daa8:	49 39 f9             	cmp    %rdi,%r9
   1daab:	40 0f 94 c7          	sete   %dil
   1daaf:	45 89 d9             	mov    %r11d,%r9d
   1dab2:	41 f6 c3 01          	test   $0x1,%r11b
   1dab6:	74 08                	je     1dac0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x9d0>
   1dab8:	0f b6 7c 24 50       	movzbl 0x50(%rsp),%edi
   1dabd:	45 31 d2             	xor    %r10d,%r10d
   1dac0:	41 88 fa             	mov    %dil,%r10b
   1dac3:	41 80 fa 01          	cmp    $0x1,%r10b
   1dac7:	0f 85 03 01 00 00    	jne    1dbd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xae0>
   1dacd:	41 f6 c1 01          	test   $0x1,%r9b
   1dad1:	75 03                	jne    1dad6 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x9e6>
   1dad3:	48 89 d1             	mov    %rdx,%rcx
   1dad6:	4c 01 c6             	add    %r8,%rsi
   1dad9:	f3 0f 10 41 0c       	movss  0xc(%rcx),%xmm0
   1dade:	f3 0f 10 4e 40       	movss  0x40(%rsi),%xmm1
   1dae3:	f3 0f 10 56 44       	movss  0x44(%rsi),%xmm2
   1dae8:	0f 28 d9             	movaps %xmm1,%xmm3
   1daeb:	f3 0f 5d 5e 48       	minss  0x48(%rsi),%xmm3
   1daf0:	0f 28 e3             	movaps %xmm3,%xmm4
   1daf3:	f3 0f c2 e3 03       	cmpunordss %xmm3,%xmm4
   1daf8:	0f 28 ec             	movaps %xmm4,%xmm5
   1dafb:	0f 55 eb             	andnps %xmm3,%xmm5
   1dafe:	0f 54 e1             	andps  %xmm1,%xmm4
   1db01:	0f 56 e5             	orps   %xmm5,%xmm4
   1db04:	f3 0f 10 4c 24 2c    	movss  0x2c(%rsp),%xmm1
   1db0a:	f3 0f 58 c8          	addss  %xmm0,%xmm1
   1db0e:	0f 28 da             	movaps %xmm2,%xmm3
   1db11:	f3 0f 5f 5e 4c       	maxss  0x4c(%rsi),%xmm3
   1db16:	0f 28 eb             	movaps %xmm3,%xmm5
   1db19:	f3 0f c2 eb 03       	cmpunordss %xmm3,%xmm5
   1db1e:	0f 28 f5             	movaps %xmm5,%xmm6
   1db21:	0f 55 f3             	andnps %xmm3,%xmm6
   1db24:	0f 54 ea             	andps  %xmm2,%xmm5
   1db27:	0f 56 ee             	orps   %xmm6,%xmm5
   1db2a:	0f 14 c8             	unpcklps %xmm0,%xmm1
   1db2d:	0f 14 ec             	unpcklps %xmm4,%xmm5
   1db30:	0f 16 cd             	movlhps %xmm5,%xmm1
   1db33:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
   1db36:	0f 5a d5             	cvtps2pd %xmm5,%xmm2
   1db39:	66 0f 6f c8          	movdqa %xmm0,%xmm1
   1db3d:	66 0f 6c ca          	punpcklqdq %xmm2,%xmm1
   1db41:	66 0f 6f d8          	movdqa %xmm0,%xmm3
   1db45:	66 0f 6d da          	punpckhqdq %xmm2,%xmm3
   1db49:	f3 0f 7f 9c 24 60 02 	movdqu %xmm3,0x260(%rsp)
   1db50:	00 00 
   1db52:	f3 0f 7f 8c 24 50 02 	movdqu %xmm1,0x250(%rsp)
   1db59:	00 00 
   1db5b:	f3 0f 7f 9c 24 40 02 	movdqu %xmm3,0x240(%rsp)
   1db62:	00 00 
   1db64:	66 0f d6 84 24 70 02 	movq   %xmm0,0x270(%rsp)
   1db6b:	00 00 
   1db6d:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1db72:	48 8b 00             	mov    (%rax),%rax
   1db75:	4c 31 e0             	xor    %r12,%rax
   1db78:	66 0f 6f c8          	movdqa %xmm0,%xmm1
   1db7c:	66 0f 6c ca          	punpcklqdq %xmm2,%xmm1
   1db80:	66 0f 6d c2          	punpckhqdq %xmm2,%xmm0
   1db84:	66 0f 6f d0          	movdqa %xmm0,%xmm2
   1db88:	66 0f 6f d9          	movdqa %xmm1,%xmm3
   1db8c:	e9 b4 00 00 00       	jmp    1dc45 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb55>
   1db91:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1db98:	0f 1f 84 00 00 00 00 
   1db9f:	00 
   1dba0:	31 c9                	xor    %ecx,%ecx
   1dba2:	4d 39 ec             	cmp    %r13,%r12
   1dba5:	73 46                	jae    1dbed <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xafd>
   1dba7:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   1dbac:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
   1dbb0:	49 89 c0             	mov    %rax,%r8
   1dbb3:	49 c1 e0 04          	shl    $0x4,%r8
   1dbb7:	4c 03 44 24 10       	add    0x10(%rsp),%r8
   1dbbc:	48 39 c5             	cmp    %rax,%rbp
   1dbbf:	b8 00 00 00 00       	mov    $0x0,%eax
   1dbc4:	4c 0f 46 c0          	cmovbe %rax,%r8
   1dbc8:	eb 26                	jmp    1dbf0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb00>
   1dbca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   1dbd0:	48 89 c1             	mov    %rax,%rcx
   1dbd3:	48 c1 e1 04          	shl    $0x4,%rcx
   1dbd7:	48 03 4c 24 10       	add    0x10(%rsp),%rcx
   1dbdc:	48 39 c5             	cmp    %rax,%rbp
   1dbdf:	b8 00 00 00 00       	mov    $0x0,%eax
   1dbe4:	48 0f 46 c8          	cmovbe %rax,%rcx
   1dbe8:	4d 39 ec             	cmp    %r13,%r12
   1dbeb:	72 ba                	jb     1dba7 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab7>
   1dbed:	45 31 c0             	xor    %r8d,%r8d
   1dbf0:	48 8d bc 24 38 02 00 	lea    0x238(%rsp),%rdi
   1dbf7:	00 
   1dbf8:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   1dbfd:	4c 89 e2             	mov    %r12,%rdx
   1dc00:	66 0f 6e 44 24 2c    	movd   0x2c(%rsp),%xmm0
   1dc06:	e8 e5 01 00 00       	call   1ddf0 <parley::editing::geometry::pair_from_entries::<()>>
   1dc0b:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1dc10:	48 8b 00             	mov    (%rax),%rax
   1dc13:	4c 31 e0             	xor    %r12,%rax
   1dc16:	48 83 bc 24 38 02 00 	cmpq   $0x1,0x238(%rsp)
   1dc1d:	00 01 
   1dc1f:	75 41                	jne    1dc62 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb72>
   1dc21:	f3 0f 6f 84 24 40 02 	movdqu 0x240(%rsp),%xmm0
   1dc28:	00 00 
   1dc2a:	f3 0f 6f 8c 24 50 02 	movdqu 0x250(%rsp),%xmm1
   1dc31:	00 00 
   1dc33:	f3 0f 6f 94 24 60 02 	movdqu 0x260(%rsp),%xmm2
   1dc3a:	00 00 
   1dc3c:	f3 0f 6f 9c 24 70 02 	movdqu 0x270(%rsp),%xmm3
   1dc43:	00 00 
   1dc45:	66 0f ef cb          	pxor   %xmm3,%xmm1
   1dc49:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1dc4d:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1dc51:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1dc56:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1dc5a:	66 48 0f 7e c9       	movq   %xmm1,%rcx
   1dc5f:	48 31 c8             	xor    %rcx,%rax
   1dc62:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   1dc67:	48 89 01             	mov    %rax,(%rcx)
   1dc6a:	49 39 dc             	cmp    %rbx,%r12
   1dc6d:	73 0c                	jae    1dc7b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb8b>
   1dc6f:	4d 89 f4             	mov    %r14,%r12
   1dc72:	49 39 de             	cmp    %rbx,%r14
   1dc75:	0f 86 f5 fc ff ff    	jbe    1d970 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x880>
   1dc7b:	4d 85 ff             	test   %r15,%r15
   1dc7e:	74 1a                	je     1dc9a <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbaa>
   1dc80:	48 8b bc 24 50 03 00 	mov    0x350(%rsp),%rdi
   1dc87:	00 
   1dc88:	49 c1 e7 04          	shl    $0x4,%r15
   1dc8c:	ba 04 00 00 00       	mov    $0x4,%edx
   1dc91:	4c 89 fe             	mov    %r15,%rsi
   1dc94:	ff 15 16 27 04 00    	call   *0x42716(%rip)        # 603b0 <_DYNAMIC+0x298>
   1dc9a:	48 8b b4 24 60 03 00 	mov    0x360(%rsp),%rsi
   1dca1:	00 
   1dca2:	48 85 f6             	test   %rsi,%rsi
   1dca5:	74 17                	je     1dcbe <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbce>
   1dca7:	48 8b bc 24 68 03 00 	mov    0x368(%rsp),%rdi
   1dcae:	00 
   1dcaf:	48 c1 e6 02          	shl    $0x2,%rsi
   1dcb3:	ba 04 00 00 00       	mov    $0x4,%edx
   1dcb8:	ff 15 f2 26 04 00    	call   *0x426f2(%rip)        # 603b0 <_DYNAMIC+0x298>
   1dcbe:	31 c0                	xor    %eax,%eax
   1dcc0:	e9 66 f4 ff ff       	jmp    1d12b <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b>
   1dcc5:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
   1dcca:	48 8d 44 24 70       	lea    0x70(%rsp),%rax
   1dccf:	0f 10 00             	movups (%rax),%xmm0
   1dcd2:	0f 10 48 10          	movups 0x10(%rax),%xmm1
   1dcd6:	f3 0f 6f 50 20       	movdqu 0x20(%rax),%xmm2
   1dcdb:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
   1dce2:	00 
   1dce3:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
   1dcea:	00 
   1dceb:	66 0f 7f 94 24 50 01 	movdqa %xmm2,0x150(%rsp)
   1dcf2:	00 00 
   1dcf4:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
   1dcf8:	0f 85 d6 fb ff ff    	jne    1d8d4 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7e4>
   1dcfe:	e9 26 f4 ff ff       	jmp    1d129 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x39>
   1dd03:	48 8d 0d 36 03 04 00 	lea    0x40336(%rip),%rcx        # 5e040 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.10.llvm.14256054827572741256>
   1dd0a:	48 89 c7             	mov    %rax,%rdi
   1dd0d:	ff 15 3d 26 04 00    	call   *0x4263d(%rip)        # 60350 <_DYNAMIC+0x238>
   1dd13:	eb 74                	jmp    1dd89 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc99>
   1dd15:	48 8d 3d bc 8a fe ff 	lea    -0x17544(%rip),%rdi        # 67d8 <anon.5cab36dad6fad55fc602ca21d50a03ec.0.llvm.4639087895861959750>
   1dd1c:	48 8d 15 b5 07 04 00 	lea    0x407b5(%rip),%rdx        # 5e4d8 <anon.5cab36dad6fad55fc602ca21d50a03ec.38.llvm.4639087895861959750>
   1dd23:	be 63 00 00 00       	mov    $0x63,%esi
   1dd28:	ff 15 2a 26 04 00    	call   *0x4262a(%rip)        # 60358 <_DYNAMIC+0x240>
   1dd2e:	eb 59                	jmp    1dd89 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc99>
   1dd30:	bf 04 00 00 00       	mov    $0x4,%edi
   1dd35:	4c 89 ee             	mov    %r13,%rsi
   1dd38:	ff 15 42 26 04 00    	call   *0x42642(%rip)        # 60380 <_DYNAMIC+0x268>
   1dd3e:	48 8d 05 73 03 04 00 	lea    0x40373(%rip),%rax        # 5e0b8 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256>
   1dd45:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   1dd4a:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
   1dd4f:	ff 15 f3 25 04 00    	call   *0x425f3(%rip)        # 60348 <_DYNAMIC+0x230>
   1dd55:	eb 32                	jmp    1dd89 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc99>
   1dd57:	4c 89 5c 24 30       	mov    %r11,0x30(%rsp)
   1dd5c:	48 8d 0d 2d 04 04 00 	lea    0x4042d(%rip),%rcx        # 5e190 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0xd8>
   1dd63:	eb 0c                	jmp    1dd71 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc81>
   1dd65:	4c 89 6c 24 30       	mov    %r13,0x30(%rsp)
   1dd6a:	48 8d 0d 37 04 04 00 	lea    0x40437(%rip),%rcx        # 5e1a8 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0xf0>
   1dd71:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
   1dd76:	48 89 c7             	mov    %rax,%rdi
   1dd79:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
   1dd7e:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
   1dd83:	ff 15 bf 25 04 00    	call   *0x425bf(%rip)        # 60348 <_DYNAMIC+0x230>
   1dd89:	0f 0b                	ud2
   1dd8b:	eb 1e                	jmp    1ddab <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcbb>
   1dd8d:	eb 1c                	jmp    1ddab <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcbb>
   1dd8f:	eb 1a                	jmp    1ddab <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcbb>
   1dd91:	48 89 c3             	mov    %rax,%rbx
   1dd94:	48 8d bc 24 48 03 00 	lea    0x348(%rsp),%rdi
   1dd9b:	00 
   1dd9c:	e8 bf ee ff ff       	call   1cc60 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
   1dda1:	48 89 df             	mov    %rbx,%rdi
   1dda4:	e8 a7 f1 03 00       	call   5cf50 <_Unwind_Resume@plt>
   1dda9:	eb 00                	jmp    1ddab <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcbb>
   1ddab:	48 89 c3             	mov    %rax,%rbx
   1ddae:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   1ddb3:	e8 a8 ee ff ff       	call   1cc60 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
   1ddb8:	48 89 df             	mov    %rbx,%rdi
   1ddbb:	e8 90 f1 03 00       	call   5cf50 <_Unwind_Resume@plt>
   1ddc0:	48 89 c3             	mov    %rax,%rbx
   1ddc3:	4d 85 ff             	test   %r15,%r15
   1ddc6:	75 08                	jne    1ddd0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xce0>
   1ddc8:	48 89 df             	mov    %rbx,%rdi
   1ddcb:	e8 80 f1 03 00       	call   5cf50 <_Unwind_Resume@plt>
   1ddd0:	ba 04 00 00 00       	mov    $0x4,%edx
   1ddd5:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   1ddda:	4c 89 ee             	mov    %r13,%rsi
   1dddd:	ff 15 cd 25 04 00    	call   *0x425cd(%rip)        # 603b0 <_DYNAMIC+0x298>
   1dde3:	48 89 df             	mov    %rbx,%rdi
   1dde6:	e8 65 f1 03 00       	call   5cf50 <_Unwind_Resume@plt>
