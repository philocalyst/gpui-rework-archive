00000000006cfc50 <pointer_linked_control::position_only>:
  6cfc50:	movd   %xmm0,%ecx
  6cfc54:	and    $0x7fffffff,%ecx
  6cfc5a:	xor    %eax,%eax
  6cfc5c:	cmp    $0x7f7fffff,%ecx
  6cfc62:	jg     6cfc73 <pointer_linked_control::position_only+0x23>
  6cfc64:	movd   %xmm0,0x4(%rdi)
  6cfc69:	movss  %xmm1,0x8(%rdi)
  6cfc6e:	mov    $0x1,%eax
  6cfc73:	mov    %eax,(%rdi)
  6cfc75:	ret
  6cfc76:	int3
  6cfc77:	int3
  6cfc78:	int3
  6cfc79:	int3
  6cfc7a:	int3
  6cfc7b:	int3
  6cfc7c:	int3
  6cfc7d:	int3
  6cfc7e:	int3
  6cfc7f:	int3

00000000006d1080 <pointer_linked_control::dispatch>:
  6d1080:	push   %rbp
  6d1081:	push   %r15
  6d1083:	push   %r14
  6d1085:	push   %r13
  6d1087:	push   %r12
  6d1089:	push   %rbx
  6d108a:	sub    $0xe8,%rsp
  6d1091:	mov    (%rcx),%r13d
  6d1094:	test   %r13d,%r13d
  6d1097:	je     6d10ca <pointer_linked_control::dispatch+0x4a>
  6d1099:	mov    0x8(%rdx),%r14
  6d109d:	mov    0x10(%rdx),%r15
  6d10a1:	mov    0x18(%rdx),%rax
  6d10a5:	movq   $0x0,0x8(%rdx)
  6d10ad:	lea    -0x1(%r13),%r8d
  6d10b1:	lea    -0x691fe8(%rip),%r9        # 3f0d0 <GCC_except_table0+0x1bd4>
  6d10b8:	movslq (%r9,%r8,4),%r8
  6d10bc:	add    %r9,%r8
  6d10bf:	jmp    *%r8
  6d10c2:	movl   $0x7fc00000,(%rdx)
  6d10c8:	jmp    6d1137 <pointer_linked_control::dispatch+0xb7>
  6d10ca:	movsd  0x4(%rcx),%xmm0
  6d10cf:	movaps %xmm0,%xmm1
  6d10d2:	shufps $0x55,%xmm0,%xmm1
  6d10d6:	movd   %xmm1,%eax
  6d10da:	movd   %xmm0,%ecx
  6d10de:	and    $0x7fffffff,%ecx
  6d10e4:	cmp    $0x7f800000,%ecx
  6d10ea:	setge  %cl
  6d10ed:	and    $0x7fffffff,%eax
  6d10f2:	cmp    $0x7f800000,%eax
  6d10f7:	setge  %al
  6d10fa:	or     %cl,%al
  6d10fc:	je     6d1111 <pointer_linked_control::dispatch+0x91>
  6d10fe:	movl   $0x7fc00000,(%rdx)
  6d1104:	movq   $0x0,0x8(%rdx)
  6d110c:	xor    %r14d,%r14d
  6d110f:	jmp    6d1137 <pointer_linked_control::dispatch+0xb7>
  6d1111:	movlpd %xmm0,(%rdx)
  6d1115:	xor    %r14d,%r14d
  6d1118:	jmp    6d1137 <pointer_linked_control::dispatch+0xb7>
  6d111a:	movd   (%rdx),%xmm0
  6d111e:	movd   %xmm0,%r8d
  6d1123:	and    $0x7fffffff,%r8d
  6d112a:	cmp    $0x7f7fffff,%r8d
  6d1131:	jle    6d13ef <pointer_linked_control::dispatch+0x36f>
  6d1137:	mov    (%rsi),%rbx
  6d113a:	test   %rbx,%rbx
  6d113d:	je     6d1168 <pointer_linked_control::dispatch+0xe8>
  6d113f:	add    $0x8,%rsi
  6d1143:	mov    %rbx,0xc0(%rsp)
  6d114b:	mov    %rsi,0xc8(%rsp)
  6d1153:	cmpb   $0x1,0x746(%rbx)
  6d115a:	jne    6d117c <pointer_linked_control::dispatch+0xfc>
  6d115c:	movq   $0xe,(%rdi)
  6d1163:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1168:	movq   $0xd,(%rdi)
  6d116f:	movq   $0x0,0x8(%rdi)
  6d1177:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d117c:	movq   $0x0,0x730(%rbx)
  6d1187:	cmp    $0x3,%r13d
  6d118b:	je     6d1335 <pointer_linked_control::dispatch+0x2b5>
  6d1191:	cmp    $0x2,%r13d
  6d1195:	je     6d12c6 <pointer_linked_control::dispatch+0x246>
  6d119b:	test   %r13d,%r13d
  6d119e:	jne    6d16cf <pointer_linked_control::dispatch+0x64f>
  6d11a4:	mov    0x638(%rbx),%rax
  6d11ab:	test   %rax,%rax
  6d11ae:	je     6d11c6 <pointer_linked_control::dispatch+0x146>
  6d11b0:	mov    0xd8(%rax),%rax
  6d11b7:	test   %rax,%rax
  6d11ba:	je     6d11c6 <pointer_linked_control::dispatch+0x146>
  6d11bc:	cmpb   $0x0,0x12(%rax)
  6d11c0:	jne    6d16cf <pointer_linked_control::dispatch+0x64f>
  6d11c6:	mov    0x8(%rdx),%r14
  6d11ca:	test   %r14,%r14
  6d11cd:	je     6d16cf <pointer_linked_control::dispatch+0x64f>
  6d11d3:	cmp    0x5d8(%rbx),%r14
  6d11da:	jne    6d16c7 <pointer_linked_control::dispatch+0x647>
  6d11e0:	mov    %rdi,%r13
  6d11e3:	mov    %rdx,%r12
  6d11e6:	mov    0x10(%rdx),%r15
  6d11ea:	lea    0x70(%rsp),%rdi
  6d11ef:	mov    %rbx,%rsi
  6d11f2:	mov    %r15,%rdx
  6d11f5:	call   6f6c10 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::resolve_identity>
  6d11fa:	mov    0x70(%rsp),%rax
  6d11ff:	cmp    $0xfffffffffffffffe,%rax
  6d1203:	jne    6d1660 <pointer_linked_control::dispatch+0x5e0>
  6d1209:	mov    0x78(%rsp),%rdi
  6d120e:	mov    0x2c8(%rbx),%rsi
  6d1215:	cmp    %rsi,%rdi
  6d1218:	jae    6d1f41 <pointer_linked_control::dispatch+0xec1>
  6d121e:	mov    0x2c0(%rbx),%rax
  6d1225:	lea    (%rdi,%rdi,4),%rcx
  6d1229:	mov    0x20(%rax,%rcx,8),%edi
  6d122d:	call   6e06a0 <<gpui::runtime::Node>::kind>
  6d1232:	cmp    $0x4,%al
  6d1234:	jne    6d17f1 <pointer_linked_control::dispatch+0x771>
  6d123a:	mov    %r12,%rax
  6d123d:	movd   (%r12),%xmm0
  6d1243:	movd   %xmm0,%ecx
  6d1247:	and    $0x7fffffff,%ecx
  6d124d:	cmp    $0x7f7fffff,%ecx
  6d1253:	jg     6d1f50 <pointer_linked_control::dispatch+0xed0>
  6d1259:	movss  0x4(%rax),%xmm1
  6d125e:	lea    0x20(%rsp),%rdi
  6d1263:	mov    %rbx,%rsi
  6d1266:	mov    %r14,%rdx
  6d1269:	mov    %r15,%rcx
  6d126c:	mov    $0x1,%r8d
  6d1272:	call   6d9fd0 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::select_pointer>
  6d1277:	mov    0x20(%rsp),%rax
  6d127c:	cmp    $0xfffffffffffffffe,%rax
  6d1280:	je     6d1290 <pointer_linked_control::dispatch+0x210>
  6d1282:	cmp    $0x11,%eax
  6d1285:	jne    6d1290 <pointer_linked_control::dispatch+0x210>
  6d1287:	movq   $0x0,0x8(%r12)
  6d1290:	mov    0x50(%rsp),%rax
  6d1295:	mov    %rax,0x30(%r13)
  6d1299:	movups 0x20(%rsp),%xmm0
  6d129e:	movups 0x30(%rsp),%xmm1
  6d12a3:	movups 0x40(%rsp),%xmm2
  6d12a8:	movups %xmm2,0x20(%r13)
  6d12ad:	movups %xmm1,0x10(%r13)
  6d12b2:	movups %xmm0,0x0(%r13)
  6d12b7:	lea    0x70(%rsp),%rdi
  6d12bc:	call   6b8af0 <core::ptr::drop_glue::<core::result::Result<gpui::runtime::Commit, gpui::runtime::Error>>>
  6d12c1:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d12c6:	test   %r14,%r14
  6d12c9:	sete   %r12b
  6d12cd:	cmpb   $0x1,0x742(%rbx)
  6d12d4:	jne    6d1329 <pointer_linked_control::dispatch+0x2a9>
  6d12d6:	cmpb   $0x0,0x743(%rbx)
  6d12dd:	jne    6d1329 <pointer_linked_control::dispatch+0x2a9>
  6d12df:	cmpb   $0x0,0x744(%rbx)
  6d12e6:	je     6d1329 <pointer_linked_control::dispatch+0x2a9>
  6d12e8:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d12f0:	jne    6d1329 <pointer_linked_control::dispatch+0x2a9>
  6d12f2:	mov    0x688(%rbx),%rax
  6d12f9:	cmp    0x690(%rbx),%rax
  6d1300:	jne    6d1329 <pointer_linked_control::dispatch+0x2a9>
  6d1302:	mov    0x6a0(%rbx),%rax
  6d1309:	cmp    0x698(%rbx),%rax
  6d1310:	jne    6d1329 <pointer_linked_control::dispatch+0x2a9>
  6d1312:	movss  0x738(%rbx),%xmm0
  6d131a:	ucomiss 0x73c(%rbx),%xmm0
  6d1321:	jne    6d1329 <pointer_linked_control::dispatch+0x2a9>
  6d1323:	jnp    6d13c5 <pointer_linked_control::dispatch+0x345>
  6d1329:	movq   $0x12,(%rdi)
  6d1330:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1335:	test   %r14,%r14
  6d1338:	je     6d16cf <pointer_linked_control::dispatch+0x64f>
  6d133e:	movzbl 0x742(%rbx),%ecx
  6d1345:	movzbl 0x743(%rbx),%r8d
  6d134d:	mov    %r8d,%r9d
  6d1350:	not    %r9b
  6d1353:	movzbl 0x744(%rbx),%esi
  6d135a:	mov    %ecx,%r10d
  6d135d:	and    %sil,%r10b
  6d1360:	and    %r9b,%r10b
  6d1363:	mov    0x5b0(%rbx),%r9
  6d136a:	cmp    $0xffffffffffffffff,%r9
  6d136e:	sete   %r11b
  6d1372:	and    %r10b,%r11b
  6d1375:	cmp    $0x1,%r11b
  6d1379:	jne    6d147c <pointer_linked_control::dispatch+0x3fc>
  6d137f:	mov    0x688(%rbx),%rax
  6d1386:	cmp    0x690(%rbx),%rax
  6d138d:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d1393:	mov    0x6a0(%rbx),%rax
  6d139a:	cmp    0x698(%rbx),%rax
  6d13a1:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d13a7:	movss  0x738(%rbx),%xmm0
  6d13af:	ucomiss 0x73c(%rbx),%xmm0
  6d13b6:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d13bc:	jp     6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d13c2:	xor    %r12d,%r12d
  6d13c5:	mov    0x638(%rbx),%rcx
  6d13cc:	test   %rcx,%rcx
  6d13cf:	je     6d1738 <pointer_linked_control::dispatch+0x6b8>
  6d13d5:	mov    0xd8(%rcx),%rax
  6d13dc:	test   %rax,%rax
  6d13df:	je     6d1738 <pointer_linked_control::dispatch+0x6b8>
  6d13e5:	movzbl 0x12(%rax),%r9d
  6d13ea:	jmp    6d173b <pointer_linked_control::dispatch+0x6bb>
  6d13ef:	movd   %xmm0,0x8(%rsp)
  6d13f5:	mov    %rsi,%r14
  6d13f8:	mov    %rdi,%rbx
  6d13fb:	movups 0x8(%rcx),%xmm0
  6d13ff:	movss  0x4(%rdx),%xmm1
  6d1404:	movss  %xmm1,0xc(%rsp)
  6d140a:	movaps %xmm0,%xmm1
  6d140d:	unpckhpd %xmm0,%xmm1
  6d1411:	lea    0x20(%rsp),%rdi
  6d1416:	movaps %xmm0,0xd0(%rsp)
  6d141e:	call   *0x3466e4(%rip)        # a17b08 <_DYNAMIC+0x4d8>
  6d1424:	cmpl   $0xfffffffe,0x20(%rsp)
  6d1429:	jne    6d1454 <pointer_linked_control::dispatch+0x3d4>
  6d142b:	mov    (%r14),%r15
  6d142e:	test   %r15,%r15
  6d1431:	mov    %rbx,%rax
  6d1434:	je     6d1550 <pointer_linked_control::dispatch+0x4d0>
  6d143a:	cmpb   $0x1,0x746(%r15)
  6d1442:	jne    6d1564 <pointer_linked_control::dispatch+0x4e4>
  6d1448:	movq   $0xe,(%rax)
  6d144f:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1454:	mov    0x50(%rsp),%rax
  6d1459:	mov    %rax,0x30(%rbx)
  6d145d:	movups 0x20(%rsp),%xmm0
  6d1462:	movups 0x30(%rsp),%xmm1
  6d1467:	movups 0x40(%rsp),%xmm2
  6d146c:	movups %xmm2,0x20(%rbx)
  6d1470:	movups %xmm1,0x10(%rbx)
  6d1474:	movups %xmm0,(%rbx)
  6d1477:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d147c:	cmp    $0xffffffffffffffff,%r9
  6d1480:	sete   %r9b
  6d1484:	movq   $0x12,0x20(%rsp)
  6d148d:	not    %cl
  6d148f:	or     %r8b,%cl
  6d1492:	not    %sil
  6d1495:	or     %cl,%sil
  6d1498:	or     %r9b,%sil
  6d149b:	test   $0x1,%sil
  6d149f:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14a5:	mov    0x6a0(%rbx),%rcx
  6d14ac:	cmp    0x698(%rbx),%rcx
  6d14b3:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14b5:	movss  0x738(%rbx),%xmm0
  6d14bd:	ucomiss 0x73c(%rbx),%xmm0
  6d14c4:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14c6:	jp     6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14c8:	mov    0x690(%rbx),%rcx
  6d14cf:	cmp    $0xffffffffffffffff,%rcx
  6d14d3:	je     6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14d5:	inc    %rcx
  6d14d8:	cmp    0x688(%rbx),%rcx
  6d14df:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14e1:	cmp    %rcx,0x6b8(%rbx)
  6d14e8:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14ea:	test   %rax,%rax
  6d14ed:	je     6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14ef:	cmpq   $0x0,0x6a8(%rbx)
  6d14f7:	je     6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d14f9:	cmp    %rax,0x6b0(%rbx)
  6d1500:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d1502:	cmp    0x5d8(%rbx),%r14
  6d1509:	jne    6d1529 <pointer_linked_control::dispatch+0x4a9>
  6d150b:	lea    0x20(%rsp),%rax
  6d1510:	mov    %rdi,%r12
  6d1513:	mov    %rax,%rdi
  6d1516:	mov    %rdx,%rbp
  6d1519:	call   6bdc70 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6d151e:	mov    %rbp,%rdx
  6d1521:	mov    %r12,%rdi
  6d1524:	jmp    6d13c2 <pointer_linked_control::dispatch+0x342>
  6d1529:	movups 0x28(%rsp),%xmm0
  6d152e:	movups 0x38(%rsp),%xmm1
  6d1533:	movups 0x48(%rsp),%xmm2
  6d1538:	movups %xmm2,0x28(%rdi)
  6d153c:	movups %xmm1,0x18(%rdi)
  6d1540:	movups %xmm0,0x8(%rdi)
  6d1544:	movq   $0x12,(%rdi)
  6d154b:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1550:	movq   $0xd,(%rax)
  6d1557:	movq   $0x0,0x8(%rax)
  6d155f:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1564:	cmpb   $0x1,0x742(%r15)
  6d156c:	jne    6d168c <pointer_linked_control::dispatch+0x60c>
  6d1572:	cmpb   $0x0,0x743(%r15)
  6d157a:	jne    6d168c <pointer_linked_control::dispatch+0x60c>
  6d1580:	cmpb   $0x0,0x744(%r15)
  6d1588:	je     6d168c <pointer_linked_control::dispatch+0x60c>
  6d158e:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d1596:	jne    6d168c <pointer_linked_control::dispatch+0x60c>
  6d159c:	mov    0x688(%r15),%rcx
  6d15a3:	cmp    0x690(%r15),%rcx
  6d15aa:	jne    6d168c <pointer_linked_control::dispatch+0x60c>
  6d15b0:	mov    0x698(%r15),%rcx
  6d15b7:	cmp    %rcx,0x6a0(%r15)
  6d15be:	jne    6d168c <pointer_linked_control::dispatch+0x60c>
  6d15c4:	movss  0x738(%r15),%xmm0
  6d15cd:	ucomiss 0x73c(%r15),%xmm0
  6d15d5:	jne    6d168c <pointer_linked_control::dispatch+0x60c>
  6d15db:	jp     6d168c <pointer_linked_control::dispatch+0x60c>
  6d15e1:	mov    %rcx,%rax
  6d15e4:	shr    $0x20,%rax
  6d15e8:	mov    %ecx,%ecx
  6d15ea:	xorps  %xmm0,%xmm0
  6d15ed:	cvtsi2ss %rcx,%xmm0
  6d15f2:	mov    %eax,%eax
  6d15f4:	xorps  %xmm1,%xmm1
  6d15f7:	cvtsi2ss %rax,%xmm1
  6d15fc:	movq   $0x0,0x20(%rsp)
  6d1605:	movss  %xmm0,0x28(%rsp)
  6d160b:	movss  %xmm1,0x2c(%rsp)
  6d1611:	lea    0x20(%rsp),%rdi
  6d1616:	movss  0x8(%rsp),%xmm0
  6d161c:	movss  0xc(%rsp),%xmm1
  6d1622:	call   *0x3464b0(%rip)        # a17ad8 <_DYNAMIC+0x4a8>
  6d1628:	test   %al,%al
  6d162a:	je     6d1ecb <pointer_linked_control::dispatch+0xe4b>
  6d1630:	mov    0x638(%r15),%rax
  6d1637:	test   %rax,%rax
  6d163a:	je     6d1ba0 <pointer_linked_control::dispatch+0xb20>
  6d1640:	mov    0x100(%rax),%rsi
  6d1647:	test   %rsi,%rsi
  6d164a:	je     6d1ba0 <pointer_linked_control::dispatch+0xb20>
  6d1650:	lea    0x70(%rsp),%rdi
  6d1655:	call   *0x346465(%rip)        # a17ac0 <_DYNAMIC+0x490>
  6d165b:	jmp    6d1bb1 <pointer_linked_control::dispatch+0xb31>
  6d1660:	cmp    $0xd,%rax
  6d1664:	jl     6d1698 <pointer_linked_control::dispatch+0x618>
  6d1666:	cmp    $0x21,%rax
  6d166a:	je     6d1698 <pointer_linked_control::dispatch+0x618>
  6d166c:	cmp    $0x26,%rax
  6d1670:	mov    %r13,%rdi
  6d1673:	mov    %r12,%rdx
  6d1676:	jne    6d16c7 <pointer_linked_control::dispatch+0x647>
  6d1678:	mov    0x78(%rsp),%rsi
  6d167d:	test   %rsi,%rsi
  6d1680:	je     6d16c7 <pointer_linked_control::dispatch+0x647>
  6d1682:	lea    0x80(%rsp),%rax
  6d168a:	jmp    6d16b3 <pointer_linked_control::dispatch+0x633>
  6d168c:	movq   $0x12,(%rax)
  6d1693:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1698:	mov    0x88(%rsp),%rsi
  6d16a0:	test   %rsi,%rsi
  6d16a3:	mov    %r13,%rdi
  6d16a6:	mov    %r12,%rdx
  6d16a9:	je     6d16c7 <pointer_linked_control::dispatch+0x647>
  6d16ab:	lea    0x90(%rsp),%rax
  6d16b3:	mov    (%rax),%rdi
  6d16b6:	mov    $0x1,%edx
  6d16bb:	call   *0x3461af(%rip)        # a17870 <_DYNAMIC+0x240>
  6d16c1:	mov    %r13,%rdi
  6d16c4:	mov    %r12,%rdx
  6d16c7:	movq   $0x0,0x8(%rdx)
  6d16cf:	movups 0x688(%rbx),%xmm0
  6d16d6:	movzbl 0x744(%rbx),%eax
  6d16dd:	cmpq   $0x0,0x6a8(%rbx)
  6d16e5:	je     6d16f5 <pointer_linked_control::dispatch+0x675>
  6d16e7:	test   %al,%al
  6d16e9:	je     6d16f9 <pointer_linked_control::dispatch+0x679>
  6d16eb:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d16f3:	jne    6d16f9 <pointer_linked_control::dispatch+0x679>
  6d16f5:	xor    %ecx,%ecx
  6d16f7:	jmp    6d1705 <pointer_linked_control::dispatch+0x685>
  6d16f9:	mov    0x6b8(%rbx),%rdx
  6d1700:	mov    $0x1,%ecx
  6d1705:	mov    0x730(%rbx),%rsi
  6d170c:	mov    %rcx,0x8(%rdi)
  6d1710:	mov    %rdx,0x10(%rdi)
  6d1714:	movups %xmm0,0x18(%rdi)
  6d1718:	mov    %rsi,0x28(%rdi)
  6d171c:	mov    %al,0x30(%rdi)
  6d171f:	movq   $0xfffffffffffffffe,(%rdi)
  6d1726:	add    $0xe8,%rsp
  6d172d:	pop    %rbx
  6d172e:	pop    %r12
  6d1730:	pop    %r13
  6d1732:	pop    %r14
  6d1734:	pop    %r15
  6d1736:	pop    %rbp
  6d1737:	ret
  6d1738:	xor    %r9d,%r9d
  6d173b:	movd   (%rdx),%xmm0
  6d173f:	movss  0x4(%rdx),%xmm1
  6d1744:	movd   %xmm0,%eax
  6d1748:	and    $0x7fffffff,%eax
  6d174d:	cmp    $0x7f7fffff,%eax
  6d1752:	mov    %eax,0xd0(%rsp)
  6d1759:	jle    6d1762 <pointer_linked_control::dispatch+0x6e2>
  6d175b:	xor    %ebp,%ebp
  6d175d:	jmp    6d185e <pointer_linked_control::dispatch+0x7de>
  6d1762:	test   %r9b,%r9b
  6d1765:	je     6d1803 <pointer_linked_control::dispatch+0x783>
  6d176b:	test   %rcx,%rcx
  6d176e:	je     6d175b <pointer_linked_control::dispatch+0x6db>
  6d1770:	cmpq   $0x0,0xd8(%rcx)
  6d1778:	je     6d175b <pointer_linked_control::dispatch+0x6db>
  6d177a:	mov    0x2c8(%rbx),%rsi
  6d1781:	cmp    $0x1c,%rsi
  6d1785:	jb     6d175b <pointer_linked_control::dispatch+0x6db>
  6d1787:	mov    %rsi,0xe0(%rsp)
  6d178f:	mov    0x100(%rcx),%rsi
  6d1796:	test   %rsi,%rsi
  6d1799:	mov    %rdi,0x60(%rsp)
  6d179e:	mov    %rdx,0x10(%rsp)
  6d17a3:	movd   %xmm0,0x8(%rsp)
  6d17a9:	movss  %xmm1,0xc(%rsp)
  6d17af:	mov    %rcx,0xb8(%rsp)
  6d17b7:	mov    %r12d,0xb4(%rsp)
  6d17bf:	je     6d1c88 <pointer_linked_control::dispatch+0xc08>
  6d17c5:	lea    0x70(%rsp),%rdi
  6d17ca:	mov    %r9d,%ebp
  6d17cd:	call   *0x3462ed(%rip)        # a17ac0 <_DYNAMIC+0x490>
  6d17d3:	mov    %ebp,%r9d
  6d17d6:	movss  0xc(%rsp),%xmm1
  6d17dc:	movd   0x8(%rsp),%xmm0
  6d17e2:	mov    0x10(%rsp),%rdx
  6d17e7:	mov    0x60(%rsp),%rdi
  6d17ec:	jmp    6d1c99 <pointer_linked_control::dispatch+0xc19>
  6d17f1:	lea    0x70(%rsp),%rdi
  6d17f6:	call   6b8af0 <core::ptr::drop_glue::<core::result::Result<gpui::runtime::Commit, gpui::runtime::Error>>>
  6d17fb:	mov    %r13,%rdi
  6d17fe:	jmp    6d16cf <pointer_linked_control::dispatch+0x64f>
  6d1803:	mov    %r9d,0x18(%rsp)
  6d1808:	mov    %rdx,0x10(%rsp)
  6d180d:	mov    %rdi,%rbp
  6d1810:	mov    %rbx,%rdi
  6d1813:	movd   %xmm0,0x8(%rsp)
  6d1819:	movss  %xmm1,0xc(%rsp)
  6d181f:	call   6f6ef0 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::hit>
  6d1824:	test   $0x1,%al
  6d1826:	je     6d1843 <pointer_linked_control::dispatch+0x7c3>
  6d1828:	lea    0x5d8(%rbx),%rdi
  6d182f:	mov    %rdx,%rsi
  6d1832:	call   *0x346280(%rip)        # a17ab8 <_DYNAMIC+0x488>
  6d1838:	mov    %rdx,%r8
  6d183b:	mov    %rbp,%rdi
  6d183e:	mov    %rax,%rbp
  6d1841:	jmp    6d1848 <pointer_linked_control::dispatch+0x7c8>
  6d1843:	mov    %rbp,%rdi
  6d1846:	xor    %ebp,%ebp
  6d1848:	mov    0x10(%rsp),%rdx
  6d184d:	movd   0x8(%rsp),%xmm0
  6d1853:	movss  0xc(%rsp),%xmm1
  6d1859:	mov    0x18(%rsp),%r9d
  6d185e:	cmp    $0x2,%r13d
  6d1862:	jne    6d1965 <pointer_linked_control::dispatch+0x8e5>
  6d1868:	mov    0x610(%rbx),%r14
  6d186f:	mov    0x618(%rbx),%rcx
  6d1876:	test   %rbp,%rbp
  6d1879:	sete   %al
  6d187c:	or     %r9b,%al
  6d187f:	test   $0x1,%al
  6d1881:	je     6d19a5 <pointer_linked_control::dispatch+0x925>
  6d1887:	mov    %r8,%r13
  6d188a:	mov    %rdx,%r15
  6d188d:	mov    %rdi,%r12
  6d1890:	movq   $0x0,0x610(%rbx)
  6d189b:	lea    0x20(%rsp),%rdi
  6d18a0:	mov    %rbx,%rsi
  6d18a3:	mov    %r14,%rdx
  6d18a6:	call   6da5f0 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::publish_focus_change>
  6d18ab:	mov    0x20(%rsp),%rax
  6d18b0:	movups 0x28(%rsp),%xmm0
  6d18b5:	movaps %xmm0,0x70(%rsp)
  6d18ba:	movups 0x38(%rsp),%xmm0
  6d18bf:	movaps %xmm0,0x80(%rsp)
  6d18c7:	movups 0x48(%rsp),%xmm0
  6d18cc:	movaps %xmm0,0x90(%rsp)
  6d18d4:	cmp    $0xfffffffffffffffe,%rax
  6d18d8:	jne    6d1ab1 <pointer_linked_control::dispatch+0xa31>
  6d18de:	movaps 0x70(%rsp),%xmm0
  6d18e3:	movaps 0x80(%rsp),%xmm1
  6d18eb:	movaps 0x90(%rsp),%xmm2
  6d18f3:	movaps %xmm2,0x40(%rsp)
  6d18f8:	movaps %xmm1,0x30(%rsp)
  6d18fd:	movaps %xmm0,0x20(%rsp)
  6d1902:	mov    0x638(%rbx),%rax
  6d1909:	test   %rax,%rax
  6d190c:	je     6d191c <pointer_linked_control::dispatch+0x89c>
  6d190e:	cmpq   $0x0,0xd8(%rax)
  6d1916:	jne    6d1ae8 <pointer_linked_control::dispatch+0xa68>
  6d191c:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d1924:	je     6d1ae8 <pointer_linked_control::dispatch+0xa68>
  6d192a:	mov    0x690(%rbx),%rax
  6d1931:	cmp    $0xffffffffffffffff,%rax
  6d1935:	je     6d1ae8 <pointer_linked_control::dispatch+0xa68>
  6d193b:	inc    %rax
  6d193e:	cmp    0x688(%rbx),%rax
  6d1945:	jne    6d1ae8 <pointer_linked_control::dispatch+0xa68>
  6d194b:	cmpq   $0x0,0x6a8(%rbx)
  6d1953:	je     6d1ae8 <pointer_linked_control::dispatch+0xa68>
  6d1959:	mov    0x6b0(%rbx),%rax
  6d1960:	jmp    6d1aea <pointer_linked_control::dispatch+0xa6a>
  6d1965:	test   %r12b,%r12b
  6d1968:	jne    6d16cf <pointer_linked_control::dispatch+0x64f>
  6d196e:	test   %rbp,%rbp
  6d1971:	je     6d16cf <pointer_linked_control::dispatch+0x64f>
  6d1977:	cmp    %rbp,%r14
  6d197a:	jne    6d16cf <pointer_linked_control::dispatch+0x64f>
  6d1980:	cmp    %r8,%r15
  6d1983:	jne    6d16cf <pointer_linked_control::dispatch+0x64f>
  6d1989:	test   %r9b,%r9b
  6d198c:	je     6d1b24 <pointer_linked_control::dispatch+0xaa4>
  6d1992:	mov    %rbx,%rsi
  6d1995:	mov    %r14,%rdx
  6d1998:	mov    %r15,%rcx
  6d199b:	call   6ddde0 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::inspector_select>
  6d19a0:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d19a5:	cmp    0x5d8(%rbx),%rbp
  6d19ac:	jne    6d1ae1 <pointer_linked_control::dispatch+0xa61>
  6d19b2:	movss  %xmm1,0xc(%rsp)
  6d19b8:	movd   %xmm0,0x8(%rsp)
  6d19be:	mov    %rcx,0x18(%rsp)
  6d19c3:	mov    %rdx,%r15
  6d19c6:	mov    %rdi,%r12
  6d19c9:	lea    0x20(%rsp),%rdi
  6d19ce:	mov    %rbx,%rsi
  6d19d1:	mov    %r8,%r13
  6d19d4:	mov    %r8,%rdx
  6d19d7:	call   6f6c10 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::resolve_identity>
  6d19dc:	mov    0x20(%rsp),%rcx
  6d19e1:	mov    0x28(%rsp),%rax
  6d19e6:	cmp    $0xfffffffffffffffe,%rcx
  6d19ea:	jne    6d1b4a <pointer_linked_control::dispatch+0xaca>
  6d19f0:	mov    0x2c8(%rbx),%rsi
  6d19f7:	cmp    %rsi,%rax
  6d19fa:	jae    6d1f5f <pointer_linked_control::dispatch+0xedf>
  6d1a00:	mov    0x2c0(%rbx),%rcx
  6d1a07:	lea    (%rax,%rax,4),%rax
  6d1a0b:	mov    0x20(%rcx,%rax,8),%edi
  6d1a0f:	call   6e06a0 <<gpui::runtime::Node>::kind>
  6d1a14:	cmp    $0x4,%al
  6d1a16:	jne    6d1b74 <pointer_linked_control::dispatch+0xaf4>
  6d1a1c:	cmpl   $0x7f7fffff,0xd0(%rsp)
  6d1a27:	jg     6d1f6f <pointer_linked_control::dispatch+0xeef>
  6d1a2d:	lea    0x20(%rsp),%rdi
  6d1a32:	mov    %rbx,%rsi
  6d1a35:	mov    %rbp,%rdx
  6d1a38:	mov    %r13,%rcx
  6d1a3b:	movss  0x8(%rsp),%xmm0
  6d1a41:	movss  0xc(%rsp),%xmm1
  6d1a47:	xor    %r8d,%r8d
  6d1a4a:	call   6d9fd0 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::select_pointer>
  6d1a4f:	mov    0x20(%rsp),%rax
  6d1a54:	movups 0x48(%rsp),%xmm0
  6d1a59:	movaps %xmm0,0x90(%rsp)
  6d1a61:	movups 0x38(%rsp),%xmm1
  6d1a66:	movaps %xmm1,0x80(%rsp)
  6d1a6e:	movups 0x28(%rsp),%xmm2
  6d1a73:	movaps %xmm2,0x70(%rsp)
  6d1a78:	movups %xmm0,0x28(%r12)
  6d1a7e:	movups %xmm1,0x18(%r12)
  6d1a84:	movups %xmm2,0x8(%r12)
  6d1a8a:	cmp    $0xfffffffffffffffe,%rax
  6d1a8e:	jne    6d1e4b <pointer_linked_control::dispatch+0xdcb>
  6d1a94:	mov    %rbp,0x8(%r15)
  6d1a98:	mov    %r13,0x10(%r15)
  6d1a9c:	movq   $0x0,0x18(%r15)
  6d1aa4:	movq   $0xfffffffffffffffe,(%r12)
  6d1aac:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1ab1:	movaps 0x70(%rsp),%xmm0
  6d1ab6:	movaps 0x80(%rsp),%xmm1
  6d1abe:	movaps 0x90(%rsp),%xmm2
  6d1ac6:	movups %xmm2,0x28(%r12)
  6d1acc:	movups %xmm1,0x18(%r12)
  6d1ad2:	movups %xmm0,0x8(%r12)
  6d1ad8:	mov    %rax,(%r12)
  6d1adc:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1ae1:	mov    $0x11,%ecx
  6d1ae6:	jmp    6d1b4d <pointer_linked_control::dispatch+0xacd>
  6d1ae8:	xor    %eax,%eax
  6d1aea:	mov    %rbp,0x8(%r15)
  6d1aee:	mov    %r13,0x10(%r15)
  6d1af2:	mov    %rax,0x18(%r15)
  6d1af6:	movaps 0x20(%rsp),%xmm0
  6d1afb:	movaps 0x30(%rsp),%xmm1
  6d1b00:	movaps 0x40(%rsp),%xmm2
  6d1b05:	movups %xmm2,0x28(%r12)
  6d1b0b:	movups %xmm1,0x18(%r12)
  6d1b11:	movups %xmm0,0x8(%r12)
  6d1b17:	movq   $0xfffffffffffffffe,(%r12)
  6d1b1f:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1b24:	movq   $0x0,0x20(%rsp)
  6d1b2d:	lea    0xc0(%rsp),%rsi
  6d1b35:	lea    0x20(%rsp),%r8
  6d1b3a:	mov    %r14,%rdx
  6d1b3d:	mov    %r15,%rcx
  6d1b40:	call   6d5030 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::activate_with_editing>
  6d1b45:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1b4a:	mov    %r12,%rdi
  6d1b4d:	mov    0x50(%rsp),%rdx
  6d1b52:	mov    %rdx,0x30(%rdi)
  6d1b56:	movups 0x30(%rsp),%xmm0
  6d1b5b:	movups 0x40(%rsp),%xmm1
  6d1b60:	movups %xmm1,0x20(%rdi)
  6d1b64:	movups %xmm0,0x10(%rdi)
  6d1b68:	mov    %rcx,(%rdi)
  6d1b6b:	mov    %rax,0x8(%rdi)
  6d1b6f:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1b74:	lea    0x20(%rsp),%rdi
  6d1b79:	mov    %rbx,%rsi
  6d1b7c:	mov    %rbp,%rdx
  6d1b7f:	mov    %r13,%rcx
  6d1b82:	call   6dc3a0 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::focus>
  6d1b87:	mov    0x20(%rsp),%rax
  6d1b8c:	cmp    $0xfffffffffffffffe,%rax
  6d1b90:	jne    6d1e06 <pointer_linked_control::dispatch+0xd86>
  6d1b96:	mov    0x18(%rsp),%rcx
  6d1b9b:	jmp    6d189b <pointer_linked_control::dispatch+0x81b>
  6d1ba0:	movq   $0x4,0x70(%rsp)
  6d1ba9:	xorps  %xmm0,%xmm0
  6d1bac:	movups %xmm0,0x78(%rsp)
  6d1bb1:	mov    %rbx,%rax
  6d1bb4:	mov    0x5a8(%r15),%rcx
  6d1bbb:	mov    %rcx,0x10(%rsp)
  6d1bc0:	test   %rcx,%rcx
  6d1bc3:	je     6d1c7c <pointer_linked_control::dispatch+0xbfc>
  6d1bc9:	mov    0x5a0(%r15),%rbp
  6d1bd0:	mov    0x10(%rsp),%rcx
  6d1bd5:	mov    %rcx,%r13
  6d1bd8:	shl    $0x6,%r13
  6d1bdc:	lea    -0x1(%rcx),%r12
  6d1be0:	jmp    6d1c45 <pointer_linked_control::dispatch+0xbc5>
  6d1be2:	mov    0x80(%rsp),%rax
  6d1bea:	mov    %rax,0x30(%rsp)
  6d1bef:	movups 0x70(%rsp),%xmm0
  6d1bf4:	movaps %xmm0,0x20(%rsp)
  6d1bf9:	mov    0x638(%r15),%rax
  6d1c00:	test   %rax,%rax
  6d1c03:	je     6d1c78 <pointer_linked_control::dispatch+0xbf8>
  6d1c05:	cmpq   $0x0,(%rax)
  6d1c09:	setne  %al
  6d1c0c:	movss  0x8(%rsp),%xmm0
  6d1c12:	movzbl %al,%ecx
  6d1c15:	mov    %rbp,%rdi
  6d1c18:	mov    0x10(%rsp),%rsi
  6d1c1d:	lea    0x20(%rsp),%rdx
  6d1c22:	mov    %r12,%r8
  6d1c25:	movss  0xc(%rsp),%xmm1
  6d1c2b:	call   *0x345edf(%rip)        # a17b10 <_DYNAMIC+0x4e0>
  6d1c31:	test   %al,%al
  6d1c33:	mov    %rbx,%rax
  6d1c36:	jne    6d1e54 <pointer_linked_control::dispatch+0xdd4>
  6d1c3c:	dec    %r12
  6d1c3f:	add    $0xffffffffffffffc0,%r13
  6d1c43:	je     6d1c7c <pointer_linked_control::dispatch+0xbfc>
  6d1c45:	cmpb   $0x0,-0x2(%rbp,%r13,1)
  6d1c4b:	jne    6d1be2 <pointer_linked_control::dispatch+0xb62>
  6d1c4d:	movzbl -0x3(%rbp,%r13,1),%ecx
  6d1c53:	sub    $0x2,%cl
  6d1c56:	movzbl %cl,%ecx
  6d1c59:	mov    $0x8,%edx
  6d1c5e:	cmovb  %edx,%ecx
  6d1c61:	cmp    $0x7,%cl
  6d1c64:	je     6d1be2 <pointer_linked_control::dispatch+0xb62>
  6d1c6a:	movzbl %cl,%ecx
  6d1c6d:	cmp    $0x4,%ecx
  6d1c70:	je     6d1be2 <pointer_linked_control::dispatch+0xb62>
  6d1c76:	jmp    6d1c3c <pointer_linked_control::dispatch+0xbbc>
  6d1c78:	xor    %eax,%eax
  6d1c7a:	jmp    6d1c0c <pointer_linked_control::dispatch+0xb8c>
  6d1c7c:	movq   $0x19,(%rax)
  6d1c83:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1c88:	movq   $0x4,0x70(%rsp)
  6d1c91:	xorps  %xmm2,%xmm2
  6d1c94:	movups %xmm2,0x78(%rsp)
  6d1c99:	mov    0x5a8(%rbx),%r12
  6d1ca0:	test   %r12,%r12
  6d1ca3:	je     6d1df7 <pointer_linked_control::dispatch+0xd77>
  6d1ca9:	mov    0x5a0(%rbx),%rsi
  6d1cb0:	mov    %r12,%rbp
  6d1cb3:	shl    $0x6,%rbp
  6d1cb7:	add    $0xffffffffffffffc0,%rbp
  6d1cbb:	mov    %r9d,0x18(%rsp)
  6d1cc0:	mov    %rsi,0x68(%rsp)
  6d1cc5:	jmp    6d1cd5 <pointer_linked_control::dispatch+0xc55>
  6d1cc7:	add    $0xffffffffffffffc0,%rbp
  6d1ccb:	cmp    $0xffffffffffffffc0,%rbp
  6d1ccf:	je     6d1de8 <pointer_linked_control::dispatch+0xd68>
  6d1cd5:	cmpb   $0x0,0x3e(%rsi,%rbp,1)
  6d1cda:	je     6d1cc7 <pointer_linked_control::dispatch+0xc47>
  6d1cdc:	mov    %rbp,%r8
  6d1cdf:	shr    $0x6,%r8
  6d1ce3:	mov    0x80(%rsp),%rax
  6d1ceb:	mov    %rax,0x30(%rsp)
  6d1cf0:	movups 0x70(%rsp),%xmm2
  6d1cf5:	movaps %xmm2,0x20(%rsp)
  6d1cfa:	xor    %ecx,%ecx
  6d1cfc:	mov    0xb8(%rsp),%rax
  6d1d04:	cmpq   $0x0,(%rax)
  6d1d08:	setne  %cl
  6d1d0b:	mov    %rsi,%rdi
  6d1d0e:	mov    %r12,%rsi
  6d1d11:	lea    0x20(%rsp),%rdx
  6d1d16:	call   *0x345df4(%rip)        # a17b10 <_DYNAMIC+0x4e0>
  6d1d1c:	mov    0x68(%rsp),%rsi
  6d1d21:	mov    0x18(%rsp),%r9d
  6d1d26:	movss  0xc(%rsp),%xmm1
  6d1d2c:	movd   0x8(%rsp),%xmm0
  6d1d32:	mov    0x10(%rsp),%rdx
  6d1d37:	mov    0x60(%rsp),%rdi
  6d1d3c:	test   %al,%al
  6d1d3e:	je     6d1cc7 <pointer_linked_control::dispatch+0xc47>
  6d1d40:	lea    0x5d8(%rbx),%rdi
  6d1d47:	mov    0x20(%rsi,%rbp,1),%rsi
  6d1d4c:	call   *0x345d66(%rip)        # a17ab8 <_DYNAMIC+0x488>
  6d1d52:	mov    %rdx,%r8
  6d1d55:	cmp    0x5d8(%rbx),%rax
  6d1d5c:	jne    6d1dbe <pointer_linked_control::dispatch+0xd3e>
  6d1d5e:	mov    %rax,%rbp
  6d1d61:	lea    0x20(%rsp),%rdi
  6d1d66:	mov    %rbx,%rsi
  6d1d69:	mov    %r8,0x68(%rsp)
  6d1d6e:	mov    %r8,%rdx
  6d1d71:	call   6f6c10 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::resolve_identity>
  6d1d76:	mov    0x20(%rsp),%rcx
  6d1d7b:	mov    0x28(%rsp),%rax
  6d1d80:	cmp    $0xfffffffffffffffe,%rcx
  6d1d84:	jne    6d1ed7 <pointer_linked_control::dispatch+0xe57>
  6d1d8a:	mov    0xb8(%rsp),%rcx
  6d1d92:	cmpq   $0x0,0xd8(%rcx)
  6d1d9a:	mov    0x68(%rsp),%r8
  6d1d9f:	je     6d1dbe <pointer_linked_control::dispatch+0xd3e>
  6d1da1:	mov    0xe0(%rsp),%rdx
  6d1da9:	add    $0xffffffffffffffe4,%rdx
  6d1dad:	cmp    $0x2,%rax
  6d1db1:	setae  %cl
  6d1db4:	cmp    %rdx,%rax
  6d1db7:	setb   %al
  6d1dba:	test   %al,%cl
  6d1dbc:	jne    6d1dc0 <pointer_linked_control::dispatch+0xd40>
  6d1dbe:	xor    %ebp,%ebp
  6d1dc0:	mov    0x60(%rsp),%rdi
  6d1dc5:	mov    0x10(%rsp),%rdx
  6d1dca:	movd   0x8(%rsp),%xmm0
  6d1dd0:	movss  0xc(%rsp),%xmm1
  6d1dd6:	mov    0x18(%rsp),%r9d
  6d1ddb:	mov    0xb4(%rsp),%r12d
  6d1de3:	jmp    6d185e <pointer_linked_control::dispatch+0x7de>
  6d1de8:	xor    %ebp,%ebp
  6d1dea:	mov    0xb4(%rsp),%r12d
  6d1df2:	jmp    6d185e <pointer_linked_control::dispatch+0x7de>
  6d1df7:	xor    %ebp,%ebp
  6d1df9:	mov    0xb4(%rsp),%r12d
  6d1e01:	jmp    6d185e <pointer_linked_control::dispatch+0x7de>
  6d1e06:	mov    0x48(%rsp),%rcx
  6d1e0b:	movzbl 0x50(%rsp),%edx
  6d1e10:	mov    0x54(%rsp),%esi
  6d1e14:	mov    %esi,0x34(%r12)
  6d1e19:	mov    0x51(%rsp),%esi
  6d1e1d:	mov    %esi,0x31(%r12)
  6d1e22:	movups 0x28(%rsp),%xmm0
  6d1e27:	movups 0x38(%rsp),%xmm1
  6d1e2c:	mov    %rax,(%r12)
  6d1e30:	movups %xmm0,0x8(%r12)
  6d1e36:	movups %xmm1,0x18(%r12)
  6d1e3c:	mov    %rcx,0x28(%r12)
  6d1e41:	mov    %dl,0x30(%r12)
  6d1e46:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1e4b:	mov    %rax,(%r12)
  6d1e4f:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1e54:	movq   $0x19,0x20(%rsp)
  6d1e5d:	lea    0x20(%rsp),%rdi
  6d1e62:	call   6bdc70 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6d1e67:	mov    %r12,0xc8(%rsp)
  6d1e6f:	movq   $0x1,0xc0(%rsp)
  6d1e7b:	lea    0xc0(%rsp),%rdi
  6d1e83:	mov    %r15,%rsi
  6d1e86:	mov    %r15,%rdx
  6d1e89:	call   6cd920 <<core::iter::sources::from_fn::FromFn<<gpui::runtime::Win<pointer_linked_control::Model>>::scroll_at_2d::{closure#2}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::traits::iterator::Iterator::any::check<usize, <gpui::runtime::Win<pointer_linked_control::Model>>::scroll_at_2d::{closure#3}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  6d1e8e:	test   %al,%al
  6d1e90:	je     6d1ecb <pointer_linked_control::dispatch+0xe4b>
  6d1e92:	movq   $0x1,0x28(%rsp)
  6d1e9b:	mov    %r12,0x30(%rsp)
  6d1ea0:	movaps 0xd0(%rsp),%xmm0
  6d1ea8:	movups %xmm0,0x38(%rsp)
  6d1ead:	movq   $0x3,0x20(%rsp)
  6d1eb6:	lea    0x20(%rsp),%rdx
  6d1ebb:	mov    %rbx,%rdi
  6d1ebe:	mov    %r14,%rsi
  6d1ec1:	call   6df700 <<gpui::runtime::Win<pointer_linked_control::Model>>::apply_scroll_plan>
  6d1ec6:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1ecb:	movq   $0x19,(%rbx)
  6d1ed2:	jmp    6d1726 <pointer_linked_control::dispatch+0x6a6>
  6d1ed7:	mov    0x38(%rsp),%rsi
  6d1edc:	mov    0x40(%rsp),%rdi
  6d1ee1:	cmp    $0xc,%rcx
  6d1ee5:	jle    6d1f02 <pointer_linked_control::dispatch+0xe82>
  6d1ee7:	cmp    $0x21,%rcx
  6d1eeb:	je     6d1f02 <pointer_linked_control::dispatch+0xe82>
  6d1eed:	cmp    $0x26,%rcx
  6d1ef1:	jne    6d1f12 <pointer_linked_control::dispatch+0xe92>
  6d1ef3:	test   %rax,%rax
  6d1ef6:	je     6d1f12 <pointer_linked_control::dispatch+0xe92>
  6d1ef8:	mov    0x30(%rsp),%rdi
  6d1efd:	mov    %rax,%rsi
  6d1f00:	jmp    6d1f07 <pointer_linked_control::dispatch+0xe87>
  6d1f02:	test   %rsi,%rsi
  6d1f05:	je     6d1f12 <pointer_linked_control::dispatch+0xe92>
  6d1f07:	mov    $0x1,%edx
  6d1f0c:	call   *0x34595e(%rip)        # a17870 <_DYNAMIC+0x240>
  6d1f12:	xor    %ebp,%ebp
  6d1f14:	mov    0x60(%rsp),%rdi
  6d1f19:	mov    0x10(%rsp),%rdx
  6d1f1e:	movd   0x8(%rsp),%xmm0
  6d1f24:	movss  0xc(%rsp),%xmm1
  6d1f2a:	mov    0x68(%rsp),%r8
  6d1f2f:	mov    0x18(%rsp),%r9d
  6d1f34:	mov    0xb4(%rsp),%r12d
  6d1f3c:	jmp    6d185e <pointer_linked_control::dispatch+0x7de>
  6d1f41:	lea    0x326e90(%rip),%rdx        # 9f8dd8 <__frame_dummy_init_array_entry+0xd88>
  6d1f48:	call   *0x345952(%rip)        # a178a0 <_DYNAMIC+0x270>
  6d1f4e:	jmp    6d1f5d <pointer_linked_control::dispatch+0xedd>
  6d1f50:	lea    0x326e99(%rip),%rdi        # 9f8df0 <__frame_dummy_init_array_entry+0xda0>
  6d1f57:	call   *0x3459ab(%rip)        # a17908 <_DYNAMIC+0x2d8>
  6d1f5d:	ud2
  6d1f5f:	lea    0x326ea2(%rip),%rdx        # 9f8e08 <__frame_dummy_init_array_entry+0xdb8>
  6d1f66:	mov    %rax,%rdi
  6d1f69:	call   *0x345931(%rip)        # a178a0 <_DYNAMIC+0x270>
  6d1f6f:	lea    0x326eaa(%rip),%rdi        # 9f8e20 <__frame_dummy_init_array_entry+0xdd0>
  6d1f76:	call   *0x34598c(%rip)        # a17908 <_DYNAMIC+0x2d8>
  6d1f7c:	mov    %rax,%rbx
  6d1f7f:	lea    0x70(%rsp),%rdi
  6d1f84:	call   6b8af0 <core::ptr::drop_glue::<core::result::Result<gpui::runtime::Commit, gpui::runtime::Error>>>
  6d1f89:	mov    %rbx,%rdi
  6d1f8c:	call   9f6ca0 <_Unwind_Resume@plt>
  6d1f91:	int3
  6d1f92:	int3
  6d1f93:	int3
  6d1f94:	int3
  6d1f95:	int3
  6d1f96:	int3
  6d1f97:	int3
  6d1f98:	int3
  6d1f99:	int3
  6d1f9a:	int3
  6d1f9b:	int3
  6d1f9c:	int3
  6d1f9d:	int3
  6d1f9e:	int3
  6d1f9f:	int3

