
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680060 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>:
  680060:	55                   	push   %rbp
  680061:	41 57                	push   %r15
  680063:	41 56                	push   %r14
  680065:	41 55                	push   %r13
  680067:	41 54                	push   %r12
  680069:	53                   	push   %rbx
  68006a:	50                   	push   %rax
  68006b:	4c 8b 0a             	mov    (%rdx),%r9
  68006e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  680072:	4c 8b 52 10          	mov    0x10(%rdx),%r10
  680076:	48 8b 42 18          	mov    0x18(%rdx),%rax
  68007a:	48 c1 e1 02          	shl    $0x2,%rcx
  68007e:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  680082:	31 db                	xor    %ebx,%ebx
  680084:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  68008b:	00 00 00 00 00 
  680090:	48 39 d9             	cmp    %rbx,%rcx
  680093:	0f 84 6b 01 00 00    	je     680204 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1a4>
  680099:	45 0f b6 5c 19 08    	movzbl 0x8(%r9,%rbx,1),%r11d
  68009f:	48 83 c3 0c          	add    $0xc,%rbx
  6800a3:	41 f6 c3 02          	test   $0x2,%r11b
  6800a7:	74 e7                	je     680090 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x30>
  6800a9:	48 c1 e0 02          	shl    $0x2,%rax
  6800ad:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6800b1:	31 c9                	xor    %ecx,%ecx
  6800b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6800ba:	84 00 00 00 00 00 
  6800c0:	48 39 c8             	cmp    %rcx,%rax
  6800c3:	0f 84 3b 01 00 00    	je     680204 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1a4>
  6800c9:	4c 8d 71 0c          	lea    0xc(%rcx),%r14
  6800cd:	41 f6 44 0a 08 01    	testb  $0x1,0x8(%r10,%rcx,1)
  6800d3:	4c 89 f1             	mov    %r14,%rcx
  6800d6:	74 e8                	je     6800c0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x60>
  6800d8:	41 8b 54 19 f4       	mov    -0xc(%r9,%rbx,1),%edx
  6800dd:	4c 8b 7e 20          	mov    0x20(%rsi),%r15
  6800e1:	48 8b 4e 28          	mov    0x28(%rsi),%rcx
  6800e5:	48 89 c8             	mov    %rcx,%rax
  6800e8:	48 85 c9             	test   %rcx,%rcx
  6800eb:	74 4c                	je     680139 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xd9>
  6800ed:	45 31 c0             	xor    %r8d,%r8d
  6800f0:	48 83 f9 01          	cmp    $0x1,%rcx
  6800f4:	74 2b                	je     680121 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xc1>
  6800f6:	48 89 c8             	mov    %rcx,%rax
  6800f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  680100:	4d 89 c4             	mov    %r8,%r12
  680103:	49 89 c5             	mov    %rax,%r13
  680106:	49 d1 ed             	shr    $1,%r13
  680109:	4d 01 e8             	add    %r13,%r8
  68010c:	4b 8d 2c 40          	lea    (%r8,%r8,2),%rbp
  680110:	41 39 14 ef          	cmp    %edx,(%r15,%rbp,8)
  680114:	4d 0f 47 c4          	cmova  %r12,%r8
  680118:	4c 29 e8             	sub    %r13,%rax
  68011b:	48 83 f8 01          	cmp    $0x1,%rax
  68011f:	77 df                	ja     680100 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0xa0>
  680121:	4f 8d 24 40          	lea    (%r8,%r8,2),%r12
  680125:	31 c0                	xor    %eax,%eax
  680127:	43 39 14 e7          	cmp    %edx,(%r15,%r12,8)
  68012b:	0f 96 c0             	setbe  %al
  68012e:	4c 01 c0             	add    %r8,%rax
  680131:	48 83 f8 01          	cmp    $0x1,%rax
  680135:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  680139:	48 39 c8             	cmp    %rcx,%rax
  68013c:	0f 83 0f 02 00 00    	jae    680351 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x2f1>
  680142:	4c 8d 24 40          	lea    (%rax,%rax,2),%r12
  680146:	49 89 c0             	mov    %rax,%r8
  680149:	41 f6 c3 01          	test   $0x1,%r11b
  68014d:	74 74                	je     6801c3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x163>
  68014f:	49 89 c0             	mov    %rax,%r8
  680152:	85 d2                	test   %edx,%edx
  680154:	74 6d                	je     6801c3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x163>
  680156:	49 89 c0             	mov    %rax,%r8
  680159:	48 85 c0             	test   %rax,%rax
  68015c:	74 65                	je     6801c3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x163>
  68015e:	4f 8d 1c e7          	lea    (%r15,%r12,8),%r11
  680162:	49 89 c0             	mov    %rax,%r8
  680165:	41 39 53 ec          	cmp    %edx,-0x14(%r11)
  680169:	75 58                	jne    6801c3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x163>
  68016b:	45 31 c0             	xor    %r8d,%r8d
  68016e:	49 89 cb             	mov    %rcx,%r11
  680171:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  680178:	0f 1f 84 00 00 00 00 
  68017f:	00 
  680180:	4d 89 dd             	mov    %r11,%r13
  680183:	49 d1 ed             	shr    $1,%r13
  680186:	4b 8d 2c 28          	lea    (%r8,%r13,1),%rbp
  68018a:	4c 8d 24 6d 00 00 00 	lea    0x0(,%rbp,2),%r12
  680191:	00 
  680192:	49 01 ec             	add    %rbp,%r12
  680195:	43 39 54 e7 04       	cmp    %edx,0x4(%r15,%r12,8)
  68019a:	4c 0f 42 c5          	cmovb  %rbp,%r8
  68019e:	4d 29 eb             	sub    %r13,%r11
  6801a1:	49 83 fb 01          	cmp    $0x1,%r11
  6801a5:	77 d9                	ja     680180 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x120>
  6801a7:	4f 8d 1c 40          	lea    (%r8,%r8,2),%r11
  6801ab:	43 39 54 df 04       	cmp    %edx,0x4(%r15,%r11,8)
  6801b0:	49 83 d0 00          	adc    $0x0,%r8
  6801b4:	4c 8d 59 ff          	lea    -0x1(%rcx),%r11
  6801b8:	4d 39 c3             	cmp    %r8,%r11
  6801bb:	4d 0f 42 c3          	cmovb  %r11,%r8
  6801bf:	4c 8d 24 40          	lea    (%rax,%rax,2),%r12
  6801c3:	49 39 c8             	cmp    %rcx,%r8
  6801c6:	0f 83 98 01 00 00    	jae    680364 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x304>
  6801cc:	43 8b 4c 32 f4       	mov    -0xc(%r10,%r14,1),%ecx
  6801d1:	47 8b 5c e7 04       	mov    0x4(%r15,%r12,8),%r11d
  6801d6:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
  6801da:	4f 8d 04 c7          	lea    (%r15,%r8,8),%r8
  6801de:	f3 41 0f 10 4c 19 f8 	movss  -0x8(%r9,%rbx,1),%xmm1
  6801e5:	f3 43 0f 10 54 32 f8 	movss  -0x8(%r10,%r14,1),%xmm2
  6801ec:	44 39 d9             	cmp    %r11d,%ecx
  6801ef:	77 1c                	ja     68020d <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1ad>
  6801f1:	0f 2e ca             	ucomiss %xmm2,%xmm1
  6801f4:	75 02                	jne    6801f8 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x198>
  6801f6:	7b 15                	jnp    68020d <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1ad>
  6801f8:	0f 2e d1             	ucomiss %xmm1,%xmm2
  6801fb:	40 0f 96 c6          	setbe  %sil
  6801ff:	e9 b6 00 00 00       	jmp    6802ba <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x25a>
  680204:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  680208:	e9 1c 01 00 00       	jmp    680329 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x2c9>
  68020d:	4c 8b 4e 08          	mov    0x8(%rsi),%r9
  680211:	48 8b 76 10          	mov    0x10(%rsi),%rsi
  680215:	49 89 f2             	mov    %rsi,%r10
  680218:	48 85 f6             	test   %rsi,%rsi
  68021b:	74 46                	je     680263 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x203>
  68021d:	45 31 d2             	xor    %r10d,%r10d
  680220:	48 83 fe 01          	cmp    $0x1,%rsi
  680224:	74 2d                	je     680253 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1f3>
  680226:	48 89 f3             	mov    %rsi,%rbx
  680229:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  680230:	49 89 de             	mov    %rbx,%r14
  680233:	49 d1 ee             	shr    $1,%r14
  680236:	4f 8d 3c 16          	lea    (%r14,%r10,1),%r15
  68023a:	4f 8d 24 7f          	lea    (%r15,%r15,2),%r12
  68023e:	47 8b 64 e1 10       	mov    0x10(%r9,%r12,8),%r12d
  680243:	4c 39 e0             	cmp    %r12,%rax
  680246:	4d 0f 47 d7          	cmova  %r15,%r10
  68024a:	4c 29 f3             	sub    %r14,%rbx
  68024d:	48 83 fb 01          	cmp    $0x1,%rbx
  680251:	77 dd                	ja     680230 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x1d0>
  680253:	4b 8d 1c 52          	lea    (%r10,%r10,2),%rbx
  680257:	41 8b 5c d9 10       	mov    0x10(%r9,%rbx,8),%ebx
  68025c:	48 39 c3             	cmp    %rax,%rbx
  68025f:	49 83 d2 00          	adc    $0x0,%r10
  680263:	49 c1 e2 03          	shl    $0x3,%r10
  680267:	4f 8d 14 52          	lea    (%r10,%r10,2),%r10
  68026b:	4b 8d 1c 11          	lea    (%r9,%r10,1),%rbx
  68026f:	48 c1 e6 03          	shl    $0x3,%rsi
  680273:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  680277:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  68027e:	00 00 
  680280:	4c 39 d6             	cmp    %r10,%rsi
  680283:	0f 84 af 00 00 00    	je     680338 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x2d8>
  680289:	49 89 de             	mov    %rbx,%r14
  68028c:	8b 5b 10             	mov    0x10(%rbx),%ebx
  68028f:	48 39 d8             	cmp    %rbx,%rax
  680292:	0f 85 a0 00 00 00    	jne    680338 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x2d8>
  680298:	49 8d 5e 18          	lea    0x18(%r14),%rbx
  68029c:	49 83 c2 18          	add    $0x18,%r10
  6802a0:	41 39 16             	cmp    %edx,(%r14)
  6802a3:	77 db                	ja     680280 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x220>
  6802a5:	41 3b 56 04          	cmp    0x4(%r14),%edx
  6802a9:	77 d5                	ja     680280 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x220>
  6802ab:	43 0f b6 74 11 fd    	movzbl -0x3(%r9,%r10,1),%esi
  6802b1:	44 39 d9             	cmp    %r11d,%ecx
  6802b4:	0f 87 89 00 00 00    	ja     680343 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x2e3>
  6802ba:	0f 28 c1             	movaps %xmm1,%xmm0
  6802bd:	f3 0f 5d c2          	minss  %xmm2,%xmm0
  6802c1:	0f 28 d8             	movaps %xmm0,%xmm3
  6802c4:	f3 0f c2 d8 03       	cmpunordss %xmm0,%xmm3
  6802c9:	0f 28 e3             	movaps %xmm3,%xmm4
  6802cc:	0f 55 e0             	andnps %xmm0,%xmm4
  6802cf:	0f 54 d9             	andps  %xmm1,%xmm3
  6802d2:	0f 56 dc             	orps   %xmm4,%xmm3
  6802d5:	0f 28 c2             	movaps %xmm2,%xmm0
  6802d8:	f3 0f 5c c1          	subss  %xmm1,%xmm0
  6802dc:	0f 54 05 dd 4e 9a ff 	andps  -0x65b123(%rip),%xmm0        # 251c0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  6802e3:	44 39 d9             	cmp    %r11d,%ecx
  6802e6:	f3 41 0f 10 60 08    	movss  0x8(%r8),%xmm4
  6802ec:	f3 41 0f 10 68 0c    	movss  0xc(%r8),%xmm5
  6802f2:	89 17                	mov    %edx,(%rdi)
  6802f4:	c6 47 04 01          	movb   $0x1,0x4(%rdi)
  6802f8:	89 4f 08             	mov    %ecx,0x8(%rdi)
  6802fb:	c6 47 0c 00          	movb   $0x0,0xc(%rdi)
  6802ff:	f3 0f 11 5f 10       	movss  %xmm3,0x10(%rdi)
  680304:	f3 0f 11 67 14       	movss  %xmm4,0x14(%rdi)
  680309:	f3 0f 11 47 18       	movss  %xmm0,0x18(%rdi)
  68030e:	f3 0f 11 6f 1c       	movss  %xmm5,0x1c(%rdi)
  680313:	48 89 47 20          	mov    %rax,0x20(%rdi)
  680317:	f3 0f 11 4f 28       	movss  %xmm1,0x28(%rdi)
  68031c:	f3 0f 11 57 2c       	movss  %xmm2,0x2c(%rdi)
  680321:	0f 97 47 30          	seta   0x30(%rdi)
  680325:	40 88 77 31          	mov    %sil,0x31(%rdi)
  680329:	48 83 c4 08          	add    $0x8,%rsp
  68032d:	5b                   	pop    %rbx
  68032e:	41 5c                	pop    %r12
  680330:	41 5d                	pop    %r13
  680332:	41 5e                	pop    %r14
  680334:	41 5f                	pop    %r15
  680336:	5d                   	pop    %rbp
  680337:	c3                   	ret
  680338:	31 f6                	xor    %esi,%esi
  68033a:	44 39 d9             	cmp    %r11d,%ecx
  68033d:	0f 86 77 ff ff ff    	jbe    6802ba <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x25a>
  680343:	0f 28 d9             	movaps %xmm1,%xmm3
  680346:	40 84 f6             	test   %sil,%sil
  680349:	74 98                	je     6802e3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x283>
  68034b:	f3 0f 5c d8          	subss  %xmm0,%xmm3
  68034f:	eb 92                	jmp    6802e3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}+0x283>
  680351:	48 8d 15 c0 d5 0f 00 	lea    0xfd5c0(%rip),%rdx        # 77d918 <anon.11946e5055af849423ef6f6fa3ccb0e0.6.llvm.6812186184794855116+0x18>
  680358:	48 89 c7             	mov    %rax,%rdi
  68035b:	48 89 ce             	mov    %rcx,%rsi
  68035e:	ff 15 54 73 10 00    	call   *0x107354(%rip)        # 7876b8 <_DYNAMIC+0x398>
  680364:	48 8d 15 c5 d5 0f 00 	lea    0xfd5c5(%rip),%rdx        # 77d930 <anon.11946e5055af849423ef6f6fa3ccb0e0.6.llvm.6812186184794855116+0x30>
  68036b:	4c 89 c7             	mov    %r8,%rdi
  68036e:	48 89 ce             	mov    %rcx,%rsi
  680371:	ff 15 41 73 10 00    	call   *0x107341(%rip)        # 7876b8 <_DYNAMIC+0x398>
