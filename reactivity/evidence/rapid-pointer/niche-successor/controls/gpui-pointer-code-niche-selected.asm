00000000006cfc80 <pointer_linked_control::position_only>:
  6cfc80:	cmp    $0xffffffff,%esi
  6cfc83:	je     6cfc97 <pointer_linked_control::position_only+0x17>
  6cfc85:	dec    %esi
  6cfc87:	mov    %esi,0x4(%rdi)
  6cfc8a:	movss  %xmm0,0x8(%rdi)
  6cfc8f:	mov    $0x1,%eax
  6cfc94:	mov    %eax,(%rdi)
  6cfc96:	ret
  6cfc97:	xor    %eax,%eax
  6cfc99:	mov    %eax,(%rdi)
  6cfc9b:	ret
  6cfc9c:	int3
  6cfc9d:	int3
  6cfc9e:	int3
  6cfc9f:	int3

00000000006d1090 <pointer_linked_control::dispatch>:
  6d1090:	push   %rbp
  6d1091:	push   %r15
  6d1093:	push   %r14
  6d1095:	push   %r13
  6d1097:	push   %r12
  6d1099:	push   %rbx
  6d109a:	sub    $0xd8,%rsp
  6d10a1:	mov    (%rcx),%r12d
  6d10a4:	test   %r12d,%r12d
  6d10a7:	je     6d10de <pointer_linked_control::dispatch+0x4e>
  6d10a9:	mov    0x8(%rdx),%r14
  6d10ad:	mov    0x10(%rdx),%r15
  6d10b1:	mov    0x18(%rdx),%rax
  6d10b5:	movq   $0x0,0x8(%rdx)
  6d10bd:	lea    -0x1(%r12),%r8d
  6d10c2:	lea    -0x691fe1(%rip),%r9        # 3f0e8 <GCC_except_table0+0x1bd4>
  6d10c9:	movslq (%r9,%r8,4),%r8
  6d10cd:	add    %r9,%r8
  6d10d0:	jmp    *%r8
  6d10d3:	movl   $0xffffffff,(%rdx)
  6d10d9:	jmp    6d11a7 <pointer_linked_control::dispatch+0x117>
  6d10de:	movd   0x4(%rcx),%xmm1
  6d10e3:	movd   0x8(%rcx),%xmm0
  6d10e8:	movd   %xmm1,%eax
  6d10ec:	movd   %xmm0,%ecx
  6d10f0:	mov    %eax,%r8d
  6d10f3:	and    $0x7fffffff,%r8d
  6d10fa:	cmp    $0x7f800000,%r8d
  6d1101:	setge  %r8b
  6d1105:	and    $0x7fffffff,%ecx
  6d110b:	cmp    $0x7f800000,%ecx
  6d1111:	setge  %cl
  6d1114:	or     %r8b,%cl
  6d1117:	je     6d112c <pointer_linked_control::dispatch+0x9c>
  6d1119:	movl   $0xffffffff,(%rdx)
  6d111f:	movq   $0x0,0x8(%rdx)
  6d1127:	xor    %r14d,%r14d
  6d112a:	jmp    6d11a7 <pointer_linked_control::dispatch+0x117>
  6d112c:	inc    %eax
  6d112e:	je     6d1ebe <pointer_linked_control::dispatch+0xe2e>
  6d1134:	mov    %eax,(%rdx)
  6d1136:	movd   %xmm0,0x4(%rdx)
  6d113b:	xor    %r14d,%r14d
  6d113e:	jmp    6d11a7 <pointer_linked_control::dispatch+0x117>
  6d1140:	mov    (%rdx),%ebp
  6d1142:	cmp    $0xffffffff,%ebp
  6d1145:	je     6d11a7 <pointer_linked_control::dispatch+0x117>
  6d1147:	mov    %rsi,%r14
  6d114a:	mov    %rdi,%rbx
  6d114d:	movups 0x8(%rcx),%xmm0
  6d1151:	movss  0x4(%rdx),%xmm1
  6d1156:	movss  %xmm1,0x4(%rsp)
  6d115c:	movaps %xmm0,%xmm1
  6d115f:	unpckhpd %xmm0,%xmm1
  6d1163:	lea    0x10(%rsp),%rdi
  6d1168:	movaps %xmm0,0x50(%rsp)
  6d116d:	call   *0x34699d(%rip)        # a17b10 <_DYNAMIC+0x4d8>
  6d1173:	cmpl   $0xfffffffe,0x10(%rsp)
  6d1178:	jne    6d1456 <pointer_linked_control::dispatch+0x3c6>
  6d117e:	mov    (%r14),%r15
  6d1181:	test   %r15,%r15
  6d1184:	mov    %rbx,%rax
  6d1187:	je     6d1552 <pointer_linked_control::dispatch+0x4c2>
  6d118d:	cmpb   $0x1,0x746(%r15)
  6d1195:	jne    6d1566 <pointer_linked_control::dispatch+0x4d6>
  6d119b:	movq   $0xe,(%rax)
  6d11a2:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d11a7:	mov    (%rsi),%rbx
  6d11aa:	test   %rbx,%rbx
  6d11ad:	je     6d11d8 <pointer_linked_control::dispatch+0x148>
  6d11af:	add    $0x8,%rsi
  6d11b3:	mov    %rbx,0xb8(%rsp)
  6d11bb:	mov    %rsi,0xc0(%rsp)
  6d11c3:	cmpb   $0x1,0x746(%rbx)
  6d11ca:	jne    6d11ec <pointer_linked_control::dispatch+0x15c>
  6d11cc:	movq   $0xe,(%rdi)
  6d11d3:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d11d8:	movq   $0xd,(%rdi)
  6d11df:	movq   $0x0,0x8(%rdi)
  6d11e7:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d11ec:	movq   $0x0,0x730(%rbx)
  6d11f7:	cmp    $0x3,%r12d
  6d11fb:	je     6d139c <pointer_linked_control::dispatch+0x30c>
  6d1201:	cmp    $0x2,%r12d
  6d1205:	je     6d132d <pointer_linked_control::dispatch+0x29d>
  6d120b:	test   %r12d,%r12d
  6d120e:	jne    6d16cd <pointer_linked_control::dispatch+0x63d>
  6d1214:	mov    0x638(%rbx),%rax
  6d121b:	test   %rax,%rax
  6d121e:	je     6d1236 <pointer_linked_control::dispatch+0x1a6>
  6d1220:	mov    0xd8(%rax),%rax
  6d1227:	test   %rax,%rax
  6d122a:	je     6d1236 <pointer_linked_control::dispatch+0x1a6>
  6d122c:	cmpb   $0x0,0x12(%rax)
  6d1230:	jne    6d16cd <pointer_linked_control::dispatch+0x63d>
  6d1236:	mov    0x8(%rdx),%r14
  6d123a:	test   %r14,%r14
  6d123d:	je     6d16cd <pointer_linked_control::dispatch+0x63d>
  6d1243:	cmp    0x5d8(%rbx),%r14
  6d124a:	jne    6d16c5 <pointer_linked_control::dispatch+0x635>
  6d1250:	mov    %rdi,%r13
  6d1253:	mov    %rdx,%r12
  6d1256:	mov    0x10(%rdx),%r15
  6d125a:	lea    0x70(%rsp),%rdi
  6d125f:	mov    %rbx,%rsi
  6d1262:	mov    %r15,%rdx
  6d1265:	call   6f6c00 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::resolve_identity>
  6d126a:	mov    0x70(%rsp),%rax
  6d126f:	cmp    $0xfffffffffffffffe,%rax
  6d1273:	jne    6d166a <pointer_linked_control::dispatch+0x5da>
  6d1279:	mov    0x78(%rsp),%rdi
  6d127e:	mov    0x2c8(%rbx),%rsi
  6d1285:	cmp    %rsi,%rdi
  6d1288:	jae    6d1f3b <pointer_linked_control::dispatch+0xeab>
  6d128e:	mov    0x2c0(%rbx),%rax
  6d1295:	lea    (%rdi,%rdi,4),%rcx
  6d1299:	mov    0x20(%rax,%rcx,8),%edi
  6d129d:	call   6e0690 <<gpui::runtime::Node>::kind>
  6d12a2:	cmp    $0x4,%al
  6d12a4:	jne    6d17e2 <pointer_linked_control::dispatch+0x752>
  6d12aa:	mov    %r12,%rax
  6d12ad:	mov    (%r12),%ecx
  6d12b1:	cmp    $0xffffffff,%ecx
  6d12b4:	je     6d1f4a <pointer_linked_control::dispatch+0xeba>
  6d12ba:	movd   0x4(%rax),%xmm1
  6d12bf:	dec    %ecx
  6d12c1:	movd   %ecx,%xmm0
  6d12c5:	lea    0x10(%rsp),%rdi
  6d12ca:	mov    %rbx,%rsi
  6d12cd:	mov    %r14,%rdx
  6d12d0:	mov    %r15,%rcx
  6d12d3:	mov    $0x1,%r8d
  6d12d9:	call   6d9fc0 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::select_pointer>
  6d12de:	mov    0x10(%rsp),%rax
  6d12e3:	cmp    $0xfffffffffffffffe,%rax
  6d12e7:	je     6d12f7 <pointer_linked_control::dispatch+0x267>
  6d12e9:	cmp    $0x11,%eax
  6d12ec:	jne    6d12f7 <pointer_linked_control::dispatch+0x267>
  6d12ee:	movq   $0x0,0x8(%r12)
  6d12f7:	mov    0x40(%rsp),%rax
  6d12fc:	mov    %rax,0x30(%r13)
  6d1300:	movups 0x10(%rsp),%xmm0
  6d1305:	movups 0x20(%rsp),%xmm1
  6d130a:	movups 0x30(%rsp),%xmm2
  6d130f:	movups %xmm2,0x20(%r13)
  6d1314:	movups %xmm1,0x10(%r13)
  6d1319:	movups %xmm0,0x0(%r13)
  6d131e:	lea    0x70(%rsp),%rdi
  6d1323:	call   6b8b20 <core::ptr::drop_glue::<core::result::Result<gpui::runtime::Commit, gpui::runtime::Error>>>
  6d1328:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d132d:	test   %r14,%r14
  6d1330:	sete   %r13b
  6d1334:	cmpb   $0x1,0x742(%rbx)
  6d133b:	jne    6d1390 <pointer_linked_control::dispatch+0x300>
  6d133d:	cmpb   $0x0,0x743(%rbx)
  6d1344:	jne    6d1390 <pointer_linked_control::dispatch+0x300>
  6d1346:	cmpb   $0x0,0x744(%rbx)
  6d134d:	je     6d1390 <pointer_linked_control::dispatch+0x300>
  6d134f:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d1357:	jne    6d1390 <pointer_linked_control::dispatch+0x300>
  6d1359:	mov    0x688(%rbx),%rax
  6d1360:	cmp    0x690(%rbx),%rax
  6d1367:	jne    6d1390 <pointer_linked_control::dispatch+0x300>
  6d1369:	mov    0x6a0(%rbx),%rax
  6d1370:	cmp    0x698(%rbx),%rax
  6d1377:	jne    6d1390 <pointer_linked_control::dispatch+0x300>
  6d1379:	movss  0x738(%rbx),%xmm0
  6d1381:	ucomiss 0x73c(%rbx),%xmm0
  6d1388:	jne    6d1390 <pointer_linked_control::dispatch+0x300>
  6d138a:	jnp    6d142c <pointer_linked_control::dispatch+0x39c>
  6d1390:	movq   $0x12,(%rdi)
  6d1397:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d139c:	test   %r14,%r14
  6d139f:	je     6d16cd <pointer_linked_control::dispatch+0x63d>
  6d13a5:	movzbl 0x742(%rbx),%ecx
  6d13ac:	movzbl 0x743(%rbx),%r8d
  6d13b4:	mov    %r8d,%r9d
  6d13b7:	not    %r9b
  6d13ba:	movzbl 0x744(%rbx),%esi
  6d13c1:	mov    %ecx,%r10d
  6d13c4:	and    %sil,%r10b
  6d13c7:	and    %r9b,%r10b
  6d13ca:	mov    0x5b0(%rbx),%r9
  6d13d1:	cmp    $0xffffffffffffffff,%r9
  6d13d5:	sete   %r11b
  6d13d9:	and    %r10b,%r11b
  6d13dc:	cmp    $0x1,%r11b
  6d13e0:	jne    6d147e <pointer_linked_control::dispatch+0x3ee>
  6d13e6:	mov    0x688(%rbx),%rax
  6d13ed:	cmp    0x690(%rbx),%rax
  6d13f4:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d13fa:	mov    0x6a0(%rbx),%rax
  6d1401:	cmp    0x698(%rbx),%rax
  6d1408:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d140e:	movss  0x738(%rbx),%xmm0
  6d1416:	ucomiss 0x73c(%rbx),%xmm0
  6d141d:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d1423:	jp     6d152b <pointer_linked_control::dispatch+0x49b>
  6d1429:	xor    %r13d,%r13d
  6d142c:	mov    0x638(%rbx),%rsi
  6d1433:	test   %rsi,%rsi
  6d1436:	je     6d1736 <pointer_linked_control::dispatch+0x6a6>
  6d143c:	mov    0xd8(%rsi),%rax
  6d1443:	test   %rax,%rax
  6d1446:	je     6d1736 <pointer_linked_control::dispatch+0x6a6>
  6d144c:	movzbl 0x12(%rax),%r9d
  6d1451:	jmp    6d1739 <pointer_linked_control::dispatch+0x6a9>
  6d1456:	mov    0x40(%rsp),%rax
  6d145b:	mov    %rax,0x30(%rbx)
  6d145f:	movups 0x10(%rsp),%xmm0
  6d1464:	movups 0x20(%rsp),%xmm1
  6d1469:	movups 0x30(%rsp),%xmm2
  6d146e:	movups %xmm2,0x20(%rbx)
  6d1472:	movups %xmm1,0x10(%rbx)
  6d1476:	movups %xmm0,(%rbx)
  6d1479:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d147e:	cmp    $0xffffffffffffffff,%r9
  6d1482:	sete   %r9b
  6d1486:	movq   $0x12,0x10(%rsp)
  6d148f:	not    %cl
  6d1491:	or     %r8b,%cl
  6d1494:	not    %sil
  6d1497:	or     %cl,%sil
  6d149a:	or     %r9b,%sil
  6d149d:	test   $0x1,%sil
  6d14a1:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d14a7:	mov    0x6a0(%rbx),%rcx
  6d14ae:	cmp    0x698(%rbx),%rcx
  6d14b5:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d14b7:	movss  0x738(%rbx),%xmm0
  6d14bf:	ucomiss 0x73c(%rbx),%xmm0
  6d14c6:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d14c8:	jp     6d152b <pointer_linked_control::dispatch+0x49b>
  6d14ca:	mov    0x690(%rbx),%rcx
  6d14d1:	cmp    $0xffffffffffffffff,%rcx
  6d14d5:	je     6d152b <pointer_linked_control::dispatch+0x49b>
  6d14d7:	inc    %rcx
  6d14da:	cmp    0x688(%rbx),%rcx
  6d14e1:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d14e3:	cmp    %rcx,0x6b8(%rbx)
  6d14ea:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d14ec:	test   %rax,%rax
  6d14ef:	je     6d152b <pointer_linked_control::dispatch+0x49b>
  6d14f1:	cmpq   $0x0,0x6a8(%rbx)
  6d14f9:	je     6d152b <pointer_linked_control::dispatch+0x49b>
  6d14fb:	cmp    %rax,0x6b0(%rbx)
  6d1502:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d1504:	cmp    0x5d8(%rbx),%r14
  6d150b:	jne    6d152b <pointer_linked_control::dispatch+0x49b>
  6d150d:	lea    0x10(%rsp),%rax
  6d1512:	mov    %rdi,%r13
  6d1515:	mov    %rax,%rdi
  6d1518:	mov    %rdx,%rbp
  6d151b:	call   6bdca0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6d1520:	mov    %rbp,%rdx
  6d1523:	mov    %r13,%rdi
  6d1526:	jmp    6d1429 <pointer_linked_control::dispatch+0x399>
  6d152b:	movups 0x18(%rsp),%xmm0
  6d1530:	movups 0x28(%rsp),%xmm1
  6d1535:	movups 0x38(%rsp),%xmm2
  6d153a:	movups %xmm2,0x28(%rdi)
  6d153e:	movups %xmm1,0x18(%rdi)
  6d1542:	movups %xmm0,0x8(%rdi)
  6d1546:	movq   $0x12,(%rdi)
  6d154d:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1552:	movq   $0xd,(%rax)
  6d1559:	movq   $0x0,0x8(%rax)
  6d1561:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1566:	cmpb   $0x1,0x742(%r15)
  6d156e:	jne    6d165e <pointer_linked_control::dispatch+0x5ce>
  6d1574:	cmpb   $0x0,0x743(%r15)
  6d157c:	jne    6d165e <pointer_linked_control::dispatch+0x5ce>
  6d1582:	cmpb   $0x0,0x744(%r15)
  6d158a:	je     6d165e <pointer_linked_control::dispatch+0x5ce>
  6d1590:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d1598:	jne    6d165e <pointer_linked_control::dispatch+0x5ce>
  6d159e:	mov    0x688(%r15),%rcx
  6d15a5:	cmp    0x690(%r15),%rcx
  6d15ac:	jne    6d165e <pointer_linked_control::dispatch+0x5ce>
  6d15b2:	mov    0x698(%r15),%rcx
  6d15b9:	cmp    %rcx,0x6a0(%r15)
  6d15c0:	jne    6d165e <pointer_linked_control::dispatch+0x5ce>
  6d15c6:	movss  0x738(%r15),%xmm0
  6d15cf:	ucomiss 0x73c(%r15),%xmm0
  6d15d7:	jne    6d165e <pointer_linked_control::dispatch+0x5ce>
  6d15dd:	jp     6d165e <pointer_linked_control::dispatch+0x5ce>
  6d15df:	mov    %ecx,%eax
  6d15e1:	cvtsi2ss %rax,%xmm2
  6d15e6:	dec    %ebp
  6d15e8:	shr    $0x20,%rcx
  6d15ec:	mov    %ecx,%eax
  6d15ee:	xorps  %xmm1,%xmm1
  6d15f1:	cvtsi2ss %rax,%xmm1
  6d15f6:	movd   %ebp,%xmm0
  6d15fa:	movq   $0x0,0x10(%rsp)
  6d1603:	movss  %xmm2,0x18(%rsp)
  6d1609:	movss  %xmm1,0x1c(%rsp)
  6d160f:	lea    0x10(%rsp),%rdi
  6d1614:	movd   %xmm0,0x8(%rsp)
  6d161a:	movss  0x4(%rsp),%xmm1
  6d1620:	call   *0x3464ba(%rip)        # a17ae0 <_DYNAMIC+0x4a8>
  6d1626:	test   %al,%al
  6d1628:	je     6d1eb2 <pointer_linked_control::dispatch+0xe22>
  6d162e:	mov    0x638(%r15),%rax
  6d1635:	test   %rax,%rax
  6d1638:	je     6d1b7c <pointer_linked_control::dispatch+0xaec>
  6d163e:	mov    0x100(%rax),%rsi
  6d1645:	test   %rsi,%rsi
  6d1648:	je     6d1b7c <pointer_linked_control::dispatch+0xaec>
  6d164e:	lea    0x70(%rsp),%rdi
  6d1653:	call   *0x34646f(%rip)        # a17ac8 <_DYNAMIC+0x490>
  6d1659:	jmp    6d1b8f <pointer_linked_control::dispatch+0xaff>
  6d165e:	movq   $0x12,(%rax)
  6d1665:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d166a:	cmp    $0xd,%rax
  6d166e:	jl     6d1696 <pointer_linked_control::dispatch+0x606>
  6d1670:	cmp    $0x21,%rax
  6d1674:	je     6d1696 <pointer_linked_control::dispatch+0x606>
  6d1676:	cmp    $0x26,%rax
  6d167a:	mov    %r13,%rdi
  6d167d:	mov    %r12,%rdx
  6d1680:	jne    6d16c5 <pointer_linked_control::dispatch+0x635>
  6d1682:	mov    0x78(%rsp),%rsi
  6d1687:	test   %rsi,%rsi
  6d168a:	je     6d16c5 <pointer_linked_control::dispatch+0x635>
  6d168c:	lea    0x80(%rsp),%rax
  6d1694:	jmp    6d16b1 <pointer_linked_control::dispatch+0x621>
  6d1696:	mov    0x88(%rsp),%rsi
  6d169e:	test   %rsi,%rsi
  6d16a1:	mov    %r13,%rdi
  6d16a4:	mov    %r12,%rdx
  6d16a7:	je     6d16c5 <pointer_linked_control::dispatch+0x635>
  6d16a9:	lea    0x90(%rsp),%rax
  6d16b1:	mov    (%rax),%rdi
  6d16b4:	mov    $0x1,%edx
  6d16b9:	call   *0x3461b9(%rip)        # a17878 <_DYNAMIC+0x240>
  6d16bf:	mov    %r13,%rdi
  6d16c2:	mov    %r12,%rdx
  6d16c5:	movq   $0x0,0x8(%rdx)
  6d16cd:	movups 0x688(%rbx),%xmm0
  6d16d4:	movzbl 0x744(%rbx),%eax
  6d16db:	cmpq   $0x0,0x6a8(%rbx)
  6d16e3:	je     6d16f3 <pointer_linked_control::dispatch+0x663>
  6d16e5:	test   %al,%al
  6d16e7:	je     6d16f7 <pointer_linked_control::dispatch+0x667>
  6d16e9:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d16f1:	jne    6d16f7 <pointer_linked_control::dispatch+0x667>
  6d16f3:	xor    %ecx,%ecx
  6d16f5:	jmp    6d1703 <pointer_linked_control::dispatch+0x673>
  6d16f7:	mov    0x6b8(%rbx),%rdx
  6d16fe:	mov    $0x1,%ecx
  6d1703:	mov    0x730(%rbx),%rsi
  6d170a:	mov    %rcx,0x8(%rdi)
  6d170e:	mov    %rdx,0x10(%rdi)
  6d1712:	movups %xmm0,0x18(%rdi)
  6d1716:	mov    %rsi,0x28(%rdi)
  6d171a:	mov    %al,0x30(%rdi)
  6d171d:	movq   $0xfffffffffffffffe,(%rdi)
  6d1724:	add    $0xd8,%rsp
  6d172b:	pop    %rbx
  6d172c:	pop    %r12
  6d172e:	pop    %r13
  6d1730:	pop    %r14
  6d1732:	pop    %r15
  6d1734:	pop    %rbp
  6d1735:	ret
  6d1736:	xor    %r9d,%r9d
  6d1739:	mov    (%rdx),%ecx
  6d173b:	movd   0x4(%rdx),%xmm1
  6d1740:	cmp    $0xffffffff,%ecx
  6d1743:	mov    %rcx,0x68(%rsp)
  6d1748:	je     6d17de <pointer_linked_control::dispatch+0x74e>
  6d174e:	lea    -0x1(%rcx),%eax
  6d1751:	movd   %eax,%xmm0
  6d1755:	test   %r9b,%r9b
  6d1758:	je     6d17f4 <pointer_linked_control::dispatch+0x764>
  6d175e:	test   %rsi,%rsi
  6d1761:	je     6d17de <pointer_linked_control::dispatch+0x74e>
  6d1763:	cmpq   $0x0,0xd8(%rsi)
  6d176b:	je     6d17de <pointer_linked_control::dispatch+0x74e>
  6d176d:	mov    0x2c8(%rbx),%rax
  6d1774:	cmp    $0x1c,%rax
  6d1778:	jb     6d17de <pointer_linked_control::dispatch+0x74e>
  6d177a:	movd   %xmm0,0x60(%rsp)
  6d1780:	mov    %rax,0xc8(%rsp)
  6d1788:	mov    %rsi,0xb0(%rsp)
  6d1790:	mov    0x100(%rsi),%rsi
  6d1797:	test   %rsi,%rsi
  6d179a:	mov    %rdi,0x48(%rsp)
  6d179f:	movd   %xmm1,0x4(%rsp)
  6d17a5:	mov    %r9d,0x50(%rsp)
  6d17aa:	mov    %r13d,0xac(%rsp)
  6d17b2:	je     6d1c66 <pointer_linked_control::dispatch+0xbd6>
  6d17b8:	lea    0x70(%rsp),%rdi
  6d17bd:	mov    %rdx,%rbp
  6d17c0:	call   *0x346302(%rip)        # a17ac8 <_DYNAMIC+0x490>
  6d17c6:	mov    0x50(%rsp),%r9d
  6d17cb:	movd   0x4(%rsp),%xmm1
  6d17d1:	mov    %rbp,%rdx
  6d17d4:	mov    0x48(%rsp),%rdi
  6d17d9:	jmp    6d1c79 <pointer_linked_control::dispatch+0xbe9>
  6d17de:	xor    %ebp,%ebp
  6d17e0:	jmp    6d1843 <pointer_linked_control::dispatch+0x7b3>
  6d17e2:	lea    0x70(%rsp),%rdi
  6d17e7:	call   6b8b20 <core::ptr::drop_glue::<core::result::Result<gpui::runtime::Commit, gpui::runtime::Error>>>
  6d17ec:	mov    %r13,%rdi
  6d17ef:	jmp    6d16cd <pointer_linked_control::dispatch+0x63d>
  6d17f4:	mov    %r9d,0x50(%rsp)
  6d17f9:	mov    %rdx,0x8(%rsp)
  6d17fe:	mov    %rdi,%rbp
  6d1801:	mov    %rbx,%rdi
  6d1804:	movd   %xmm1,0x4(%rsp)
  6d180a:	call   6f6ee0 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::hit>
  6d180f:	test   $0x1,%al
  6d1811:	je     6d182e <pointer_linked_control::dispatch+0x79e>
  6d1813:	lea    0x5d8(%rbx),%rdi
  6d181a:	mov    %rdx,%rsi
  6d181d:	call   *0x34629d(%rip)        # a17ac0 <_DYNAMIC+0x488>
  6d1823:	mov    %rdx,%r8
  6d1826:	mov    %rbp,%rdi
  6d1829:	mov    %rax,%rbp
  6d182c:	jmp    6d1833 <pointer_linked_control::dispatch+0x7a3>
  6d182e:	mov    %rbp,%rdi
  6d1831:	xor    %ebp,%ebp
  6d1833:	mov    0x8(%rsp),%rdx
  6d1838:	movd   0x4(%rsp),%xmm1
  6d183e:	mov    0x50(%rsp),%r9d
  6d1843:	cmp    $0x2,%r12d
  6d1847:	jne    6d194a <pointer_linked_control::dispatch+0x8ba>
  6d184d:	mov    0x610(%rbx),%r14
  6d1854:	mov    0x618(%rbx),%rcx
  6d185b:	test   %rbp,%rbp
  6d185e:	sete   %al
  6d1861:	or     %r9b,%al
  6d1864:	test   $0x1,%al
  6d1866:	je     6d198a <pointer_linked_control::dispatch+0x8fa>
  6d186c:	mov    %r8,%r13
  6d186f:	mov    %rdx,%r15
  6d1872:	mov    %rdi,%r12
  6d1875:	movq   $0x0,0x610(%rbx)
  6d1880:	lea    0x10(%rsp),%rdi
  6d1885:	mov    %rbx,%rsi
  6d1888:	mov    %r14,%rdx
  6d188b:	call   6da5e0 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::publish_focus_change>
  6d1890:	mov    0x10(%rsp),%rax
  6d1895:	movups 0x18(%rsp),%xmm0
  6d189a:	movaps %xmm0,0x70(%rsp)
  6d189f:	movups 0x28(%rsp),%xmm0
  6d18a4:	movaps %xmm0,0x80(%rsp)
  6d18ac:	movups 0x38(%rsp),%xmm0
  6d18b1:	movaps %xmm0,0x90(%rsp)
  6d18b9:	cmp    $0xfffffffffffffffe,%rax
  6d18bd:	jne    6d1a8d <pointer_linked_control::dispatch+0x9fd>
  6d18c3:	movaps 0x70(%rsp),%xmm0
  6d18c8:	movaps 0x80(%rsp),%xmm1
  6d18d0:	movaps 0x90(%rsp),%xmm2
  6d18d8:	movaps %xmm2,0x30(%rsp)
  6d18dd:	movaps %xmm1,0x20(%rsp)
  6d18e2:	movaps %xmm0,0x10(%rsp)
  6d18e7:	mov    0x638(%rbx),%rax
  6d18ee:	test   %rax,%rax
  6d18f1:	je     6d1901 <pointer_linked_control::dispatch+0x871>
  6d18f3:	cmpq   $0x0,0xd8(%rax)
  6d18fb:	jne    6d1ac4 <pointer_linked_control::dispatch+0xa34>
  6d1901:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d1909:	je     6d1ac4 <pointer_linked_control::dispatch+0xa34>
  6d190f:	mov    0x690(%rbx),%rax
  6d1916:	cmp    $0xffffffffffffffff,%rax
  6d191a:	je     6d1ac4 <pointer_linked_control::dispatch+0xa34>
  6d1920:	inc    %rax
  6d1923:	cmp    0x688(%rbx),%rax
  6d192a:	jne    6d1ac4 <pointer_linked_control::dispatch+0xa34>
  6d1930:	cmpq   $0x0,0x6a8(%rbx)
  6d1938:	je     6d1ac4 <pointer_linked_control::dispatch+0xa34>
  6d193e:	mov    0x6b0(%rbx),%rax
  6d1945:	jmp    6d1ac6 <pointer_linked_control::dispatch+0xa36>
  6d194a:	test   %r13b,%r13b
  6d194d:	jne    6d16cd <pointer_linked_control::dispatch+0x63d>
  6d1953:	test   %rbp,%rbp
  6d1956:	je     6d16cd <pointer_linked_control::dispatch+0x63d>
  6d195c:	cmp    %rbp,%r14
  6d195f:	jne    6d16cd <pointer_linked_control::dispatch+0x63d>
  6d1965:	cmp    %r8,%r15
  6d1968:	jne    6d16cd <pointer_linked_control::dispatch+0x63d>
  6d196e:	test   %r9b,%r9b
  6d1971:	je     6d1b00 <pointer_linked_control::dispatch+0xa70>
  6d1977:	mov    %rbx,%rsi
  6d197a:	mov    %r14,%rdx
  6d197d:	mov    %r15,%rcx
  6d1980:	call   6dddd0 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::inspector_select>
  6d1985:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d198a:	cmp    0x5d8(%rbx),%rbp
  6d1991:	jne    6d1abd <pointer_linked_control::dispatch+0xa2d>
  6d1997:	movd   %xmm1,0x4(%rsp)
  6d199d:	mov    %rcx,0x50(%rsp)
  6d19a2:	mov    %rdx,%r15
  6d19a5:	mov    %rdi,%r12
  6d19a8:	lea    0x10(%rsp),%rdi
  6d19ad:	mov    %rbx,%rsi
  6d19b0:	mov    %r8,%r13
  6d19b3:	mov    %r8,%rdx
  6d19b6:	call   6f6c00 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::resolve_identity>
  6d19bb:	mov    0x10(%rsp),%rcx
  6d19c0:	mov    0x18(%rsp),%rax
  6d19c5:	cmp    $0xfffffffffffffffe,%rcx
  6d19c9:	jne    6d1b26 <pointer_linked_control::dispatch+0xa96>
  6d19cf:	mov    0x2c8(%rbx),%rsi
  6d19d6:	cmp    %rsi,%rax
  6d19d9:	jae    6d1f59 <pointer_linked_control::dispatch+0xec9>
  6d19df:	mov    0x2c0(%rbx),%rcx
  6d19e6:	lea    (%rax,%rax,4),%rax
  6d19ea:	mov    0x20(%rcx,%rax,8),%edi
  6d19ee:	call   6e0690 <<gpui::runtime::Node>::kind>
  6d19f3:	cmp    $0x4,%al
  6d19f5:	jne    6d1b50 <pointer_linked_control::dispatch+0xac0>
  6d19fb:	mov    0x68(%rsp),%rax
  6d1a00:	cmp    $0xffffffff,%eax
  6d1a03:	je     6d1f69 <pointer_linked_control::dispatch+0xed9>
  6d1a09:	dec    %eax
  6d1a0b:	movd   %eax,%xmm0
  6d1a0f:	lea    0x10(%rsp),%rdi
  6d1a14:	mov    %rbx,%rsi
  6d1a17:	mov    %rbp,%rdx
  6d1a1a:	mov    %r13,%rcx
  6d1a1d:	movss  0x4(%rsp),%xmm1
  6d1a23:	xor    %r8d,%r8d
  6d1a26:	call   6d9fc0 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::select_pointer>
  6d1a2b:	mov    0x10(%rsp),%rax
  6d1a30:	movups 0x38(%rsp),%xmm0
  6d1a35:	movaps %xmm0,0x90(%rsp)
  6d1a3d:	movups 0x28(%rsp),%xmm1
  6d1a42:	movaps %xmm1,0x80(%rsp)
  6d1a4a:	movups 0x18(%rsp),%xmm2
  6d1a4f:	movaps %xmm2,0x70(%rsp)
  6d1a54:	movups %xmm0,0x28(%r12)
  6d1a5a:	movups %xmm1,0x18(%r12)
  6d1a60:	movups %xmm2,0x8(%r12)
  6d1a66:	cmp    $0xfffffffffffffffe,%rax
  6d1a6a:	jne    6d1e35 <pointer_linked_control::dispatch+0xda5>
  6d1a70:	mov    %rbp,0x8(%r15)
  6d1a74:	mov    %r13,0x10(%r15)
  6d1a78:	movq   $0x0,0x18(%r15)
  6d1a80:	movq   $0xfffffffffffffffe,(%r12)
  6d1a88:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1a8d:	movaps 0x70(%rsp),%xmm0
  6d1a92:	movaps 0x80(%rsp),%xmm1
  6d1a9a:	movaps 0x90(%rsp),%xmm2
  6d1aa2:	movups %xmm2,0x28(%r12)
  6d1aa8:	movups %xmm1,0x18(%r12)
  6d1aae:	movups %xmm0,0x8(%r12)
  6d1ab4:	mov    %rax,(%r12)
  6d1ab8:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1abd:	mov    $0x11,%ecx
  6d1ac2:	jmp    6d1b29 <pointer_linked_control::dispatch+0xa99>
  6d1ac4:	xor    %eax,%eax
  6d1ac6:	mov    %rbp,0x8(%r15)
  6d1aca:	mov    %r13,0x10(%r15)
  6d1ace:	mov    %rax,0x18(%r15)
  6d1ad2:	movaps 0x10(%rsp),%xmm0
  6d1ad7:	movaps 0x20(%rsp),%xmm1
  6d1adc:	movaps 0x30(%rsp),%xmm2
  6d1ae1:	movups %xmm2,0x28(%r12)
  6d1ae7:	movups %xmm1,0x18(%r12)
  6d1aed:	movups %xmm0,0x8(%r12)
  6d1af3:	movq   $0xfffffffffffffffe,(%r12)
  6d1afb:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1b00:	movq   $0x0,0x10(%rsp)
  6d1b09:	lea    0xb8(%rsp),%rsi
  6d1b11:	lea    0x10(%rsp),%r8
  6d1b16:	mov    %r14,%rdx
  6d1b19:	mov    %r15,%rcx
  6d1b1c:	call   6d5020 <<gpui::runtime::RuntimeMut<pointer_linked_control::Model, ()>>::activate_with_editing>
  6d1b21:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1b26:	mov    %r12,%rdi
  6d1b29:	mov    0x40(%rsp),%rdx
  6d1b2e:	mov    %rdx,0x30(%rdi)
  6d1b32:	movups 0x20(%rsp),%xmm0
  6d1b37:	movups 0x30(%rsp),%xmm1
  6d1b3c:	movups %xmm1,0x20(%rdi)
  6d1b40:	movups %xmm0,0x10(%rdi)
  6d1b44:	mov    %rcx,(%rdi)
  6d1b47:	mov    %rax,0x8(%rdi)
  6d1b4b:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1b50:	lea    0x10(%rsp),%rdi
  6d1b55:	mov    %rbx,%rsi
  6d1b58:	mov    %rbp,%rdx
  6d1b5b:	mov    %r13,%rcx
  6d1b5e:	call   6dc390 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::focus>
  6d1b63:	mov    0x10(%rsp),%rax
  6d1b68:	cmp    $0xfffffffffffffffe,%rax
  6d1b6c:	jne    6d1df0 <pointer_linked_control::dispatch+0xd60>
  6d1b72:	mov    0x50(%rsp),%rcx
  6d1b77:	jmp    6d1880 <pointer_linked_control::dispatch+0x7f0>
  6d1b7c:	movq   $0x4,0x70(%rsp)
  6d1b85:	pxor   %xmm0,%xmm0
  6d1b89:	movdqu %xmm0,0x78(%rsp)
  6d1b8f:	mov    %rbx,%rax
  6d1b92:	mov    0x5a8(%r15),%rcx
  6d1b99:	mov    %rcx,0x68(%rsp)
  6d1b9e:	test   %rcx,%rcx
  6d1ba1:	je     6d1c5a <pointer_linked_control::dispatch+0xbca>
  6d1ba7:	mov    0x5a0(%r15),%rbp
  6d1bae:	mov    0x68(%rsp),%rcx
  6d1bb3:	mov    %rcx,%r13
  6d1bb6:	shl    $0x6,%r13
  6d1bba:	lea    -0x1(%rcx),%r12
  6d1bbe:	jmp    6d1c23 <pointer_linked_control::dispatch+0xb93>
  6d1bc0:	mov    0x80(%rsp),%rax
  6d1bc8:	mov    %rax,0x20(%rsp)
  6d1bcd:	movups 0x70(%rsp),%xmm0
  6d1bd2:	movaps %xmm0,0x10(%rsp)
  6d1bd7:	mov    0x638(%r15),%rax
  6d1bde:	test   %rax,%rax
  6d1be1:	je     6d1c56 <pointer_linked_control::dispatch+0xbc6>
  6d1be3:	cmpq   $0x0,(%rax)
  6d1be7:	setne  %al
  6d1bea:	movzbl %al,%ecx
  6d1bed:	mov    %rbp,%rdi
  6d1bf0:	mov    0x68(%rsp),%rsi
  6d1bf5:	lea    0x10(%rsp),%rdx
  6d1bfa:	mov    %r12,%r8
  6d1bfd:	movd   0x8(%rsp),%xmm0
  6d1c03:	movss  0x4(%rsp),%xmm1
  6d1c09:	call   *0x345f09(%rip)        # a17b18 <_DYNAMIC+0x4e0>
  6d1c0f:	test   %al,%al
  6d1c11:	mov    %rbx,%rax
  6d1c14:	jne    6d1e3e <pointer_linked_control::dispatch+0xdae>
  6d1c1a:	dec    %r12
  6d1c1d:	add    $0xffffffffffffffc0,%r13
  6d1c21:	je     6d1c5a <pointer_linked_control::dispatch+0xbca>
  6d1c23:	cmpb   $0x0,-0x2(%rbp,%r13,1)
  6d1c29:	jne    6d1bc0 <pointer_linked_control::dispatch+0xb30>
  6d1c2b:	movzbl -0x3(%rbp,%r13,1),%ecx
  6d1c31:	sub    $0x2,%cl
  6d1c34:	movzbl %cl,%ecx
  6d1c37:	mov    $0x8,%edx
  6d1c3c:	cmovb  %edx,%ecx
  6d1c3f:	cmp    $0x7,%cl
  6d1c42:	je     6d1bc0 <pointer_linked_control::dispatch+0xb30>
  6d1c48:	movzbl %cl,%ecx
  6d1c4b:	cmp    $0x4,%ecx
  6d1c4e:	je     6d1bc0 <pointer_linked_control::dispatch+0xb30>
  6d1c54:	jmp    6d1c1a <pointer_linked_control::dispatch+0xb8a>
  6d1c56:	xor    %eax,%eax
  6d1c58:	jmp    6d1bea <pointer_linked_control::dispatch+0xb5a>
  6d1c5a:	movq   $0x19,(%rax)
  6d1c61:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1c66:	movq   $0x4,0x70(%rsp)
  6d1c6f:	pxor   %xmm0,%xmm0
  6d1c73:	movdqu %xmm0,0x78(%rsp)
  6d1c79:	mov    0x5a8(%rbx),%r13
  6d1c80:	test   %r13,%r13
  6d1c83:	je     6d1de1 <pointer_linked_control::dispatch+0xd51>
  6d1c89:	mov    0x5a0(%rbx),%rsi
  6d1c90:	mov    %r13,%rbp
  6d1c93:	shl    $0x6,%rbp
  6d1c97:	add    $0xffffffffffffffc0,%rbp
  6d1c9b:	mov    %rdx,0x8(%rsp)
  6d1ca0:	mov    %rsi,0xd0(%rsp)
  6d1ca8:	jmp    6d1cb8 <pointer_linked_control::dispatch+0xc28>
  6d1caa:	add    $0xffffffffffffffc0,%rbp
  6d1cae:	cmp    $0xffffffffffffffc0,%rbp
  6d1cb2:	je     6d1dd2 <pointer_linked_control::dispatch+0xd42>
  6d1cb8:	cmpb   $0x0,0x3e(%rsi,%rbp,1)
  6d1cbd:	je     6d1caa <pointer_linked_control::dispatch+0xc1a>
  6d1cbf:	mov    %rbp,%r8
  6d1cc2:	shr    $0x6,%r8
  6d1cc6:	mov    0x80(%rsp),%rax
  6d1cce:	mov    %rax,0x20(%rsp)
  6d1cd3:	movups 0x70(%rsp),%xmm0
  6d1cd8:	movaps %xmm0,0x10(%rsp)
  6d1cdd:	xor    %ecx,%ecx
  6d1cdf:	mov    0xb0(%rsp),%rax
  6d1ce7:	cmpq   $0x0,(%rax)
  6d1ceb:	setne  %cl
  6d1cee:	mov    %rsi,%rdi
  6d1cf1:	mov    %r13,%rsi
  6d1cf4:	lea    0x10(%rsp),%rdx
  6d1cf9:	movd   0x60(%rsp),%xmm0
  6d1cff:	movss  0x4(%rsp),%xmm1
  6d1d05:	call   *0x345e0d(%rip)        # a17b18 <_DYNAMIC+0x4e0>
  6d1d0b:	mov    0xd0(%rsp),%rsi
  6d1d13:	mov    0x50(%rsp),%r9d
  6d1d18:	movd   0x4(%rsp),%xmm1
  6d1d1e:	mov    0x8(%rsp),%rdx
  6d1d23:	mov    0x48(%rsp),%rdi
  6d1d28:	test   %al,%al
  6d1d2a:	je     6d1caa <pointer_linked_control::dispatch+0xc1a>
  6d1d30:	lea    0x5d8(%rbx),%rdi
  6d1d37:	mov    0x20(%rsi,%rbp,1),%rsi
  6d1d3c:	call   *0x345d7e(%rip)        # a17ac0 <_DYNAMIC+0x488>
  6d1d42:	mov    %rdx,%r8
  6d1d45:	cmp    0x5d8(%rbx),%rax
  6d1d4c:	jne    6d1dae <pointer_linked_control::dispatch+0xd1e>
  6d1d4e:	mov    %rax,%rbp
  6d1d51:	lea    0x10(%rsp),%rdi
  6d1d56:	mov    %rbx,%rsi
  6d1d59:	mov    %r8,0x60(%rsp)
  6d1d5e:	mov    %r8,%rdx
  6d1d61:	call   6f6c00 <<gpui::runtime::Runtime<pointer_linked_control::Model>>::resolve_identity>
  6d1d66:	mov    0x10(%rsp),%rcx
  6d1d6b:	mov    0x18(%rsp),%rax
  6d1d70:	cmp    $0xfffffffffffffffe,%rcx
  6d1d74:	jne    6d1ed7 <pointer_linked_control::dispatch+0xe47>
  6d1d7a:	mov    0xb0(%rsp),%rcx
  6d1d82:	cmpq   $0x0,0xd8(%rcx)
  6d1d8a:	mov    0x60(%rsp),%r8
  6d1d8f:	je     6d1dae <pointer_linked_control::dispatch+0xd1e>
  6d1d91:	mov    0xc8(%rsp),%rdx
  6d1d99:	add    $0xffffffffffffffe4,%rdx
  6d1d9d:	cmp    $0x2,%rax
  6d1da1:	setae  %cl
  6d1da4:	cmp    %rdx,%rax
  6d1da7:	setb   %al
  6d1daa:	test   %al,%cl
  6d1dac:	jne    6d1db0 <pointer_linked_control::dispatch+0xd20>
  6d1dae:	xor    %ebp,%ebp
  6d1db0:	mov    0x48(%rsp),%rdi
  6d1db5:	mov    0x8(%rsp),%rdx
  6d1dba:	movd   0x4(%rsp),%xmm1
  6d1dc0:	mov    0x50(%rsp),%r9d
  6d1dc5:	mov    0xac(%rsp),%r13d
  6d1dcd:	jmp    6d1843 <pointer_linked_control::dispatch+0x7b3>
  6d1dd2:	xor    %ebp,%ebp
  6d1dd4:	mov    0xac(%rsp),%r13d
  6d1ddc:	jmp    6d1843 <pointer_linked_control::dispatch+0x7b3>
  6d1de1:	xor    %ebp,%ebp
  6d1de3:	mov    0xac(%rsp),%r13d
  6d1deb:	jmp    6d1843 <pointer_linked_control::dispatch+0x7b3>
  6d1df0:	mov    0x38(%rsp),%rcx
  6d1df5:	movzbl 0x40(%rsp),%edx
  6d1dfa:	mov    0x44(%rsp),%esi
  6d1dfe:	mov    %esi,0x34(%r12)
  6d1e03:	mov    0x41(%rsp),%esi
  6d1e07:	mov    %esi,0x31(%r12)
  6d1e0c:	movups 0x18(%rsp),%xmm0
  6d1e11:	movups 0x28(%rsp),%xmm1
  6d1e16:	mov    %rax,(%r12)
  6d1e1a:	movups %xmm0,0x8(%r12)
  6d1e20:	movups %xmm1,0x18(%r12)
  6d1e26:	mov    %rcx,0x28(%r12)
  6d1e2b:	mov    %dl,0x30(%r12)
  6d1e30:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1e35:	mov    %rax,(%r12)
  6d1e39:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1e3e:	movq   $0x19,0x10(%rsp)
  6d1e47:	lea    0x10(%rsp),%rdi
  6d1e4c:	call   6bdca0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6d1e51:	mov    %r12,0xc0(%rsp)
  6d1e59:	movq   $0x1,0xb8(%rsp)
  6d1e65:	lea    0xb8(%rsp),%rdi
  6d1e6d:	mov    %r15,%rsi
  6d1e70:	mov    %r15,%rdx
  6d1e73:	call   6cd950 <<core::iter::sources::from_fn::FromFn<<gpui::runtime::Win<pointer_linked_control::Model>>::scroll_at_2d::{closure#2}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::traits::iterator::Iterator::any::check<usize, <gpui::runtime::Win<pointer_linked_control::Model>>::scroll_at_2d::{closure#3}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  6d1e78:	test   %al,%al
  6d1e7a:	je     6d1eb2 <pointer_linked_control::dispatch+0xe22>
  6d1e7c:	movq   $0x1,0x18(%rsp)
  6d1e85:	mov    %r12,0x20(%rsp)
  6d1e8a:	movaps 0x50(%rsp),%xmm0
  6d1e8f:	movups %xmm0,0x28(%rsp)
  6d1e94:	movq   $0x3,0x10(%rsp)
  6d1e9d:	lea    0x10(%rsp),%rdx
  6d1ea2:	mov    %rbx,%rdi
  6d1ea5:	mov    %r14,%rsi
  6d1ea8:	call   6df6f0 <<gpui::runtime::Win<pointer_linked_control::Model>>::apply_scroll_plan>
  6d1ead:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1eb2:	movq   $0x19,(%rbx)
  6d1eb9:	jmp    6d1724 <pointer_linked_control::dispatch+0x694>
  6d1ebe:	lea    -0x685114(%rip),%rdi        # 4cdb1 <GCC_except_table0+0xf89d>
  6d1ec5:	lea    0x326efc(%rip),%rdx        # 9f8dc8 <__frame_dummy_init_array_entry+0xd88>
  6d1ecc:	mov    $0x22,%esi
  6d1ed1:	call   *0x345b49(%rip)        # a17a20 <_DYNAMIC+0x3e8>
  6d1ed7:	mov    0x28(%rsp),%rsi
  6d1edc:	mov    0x30(%rsp),%rdi
  6d1ee1:	cmp    $0xc,%rcx
  6d1ee5:	jle    6d1f02 <pointer_linked_control::dispatch+0xe72>
  6d1ee7:	cmp    $0x21,%rcx
  6d1eeb:	je     6d1f02 <pointer_linked_control::dispatch+0xe72>
  6d1eed:	cmp    $0x26,%rcx
  6d1ef1:	jne    6d1f12 <pointer_linked_control::dispatch+0xe82>
  6d1ef3:	test   %rax,%rax
  6d1ef6:	je     6d1f12 <pointer_linked_control::dispatch+0xe82>
  6d1ef8:	mov    0x20(%rsp),%rdi
  6d1efd:	mov    %rax,%rsi
  6d1f00:	jmp    6d1f07 <pointer_linked_control::dispatch+0xe77>
  6d1f02:	test   %rsi,%rsi
  6d1f05:	je     6d1f12 <pointer_linked_control::dispatch+0xe82>
  6d1f07:	mov    $0x1,%edx
  6d1f0c:	call   *0x345966(%rip)        # a17878 <_DYNAMIC+0x240>
  6d1f12:	xor    %ebp,%ebp
  6d1f14:	mov    0x48(%rsp),%rdi
  6d1f19:	mov    0x8(%rsp),%rdx
  6d1f1e:	movd   0x4(%rsp),%xmm1
  6d1f24:	mov    0x60(%rsp),%r8
  6d1f29:	mov    0x50(%rsp),%r9d
  6d1f2e:	mov    0xac(%rsp),%r13d
  6d1f36:	jmp    6d1843 <pointer_linked_control::dispatch+0x7b3>
  6d1f3b:	lea    0x326e9e(%rip),%rdx        # 9f8de0 <__frame_dummy_init_array_entry+0xda0>
  6d1f42:	call   *0x345960(%rip)        # a178a8 <_DYNAMIC+0x270>
  6d1f48:	jmp    6d1f57 <pointer_linked_control::dispatch+0xec7>
  6d1f4a:	lea    0x326ea7(%rip),%rdi        # 9f8df8 <__frame_dummy_init_array_entry+0xdb8>
  6d1f51:	call   *0x3459b9(%rip)        # a17910 <_DYNAMIC+0x2d8>
  6d1f57:	ud2
  6d1f59:	lea    0x326eb0(%rip),%rdx        # 9f8e10 <__frame_dummy_init_array_entry+0xdd0>
  6d1f60:	mov    %rax,%rdi
  6d1f63:	call   *0x34593f(%rip)        # a178a8 <_DYNAMIC+0x270>
  6d1f69:	lea    0x326eb8(%rip),%rdi        # 9f8e28 <__frame_dummy_init_array_entry+0xde8>
  6d1f70:	call   *0x34599a(%rip)        # a17910 <_DYNAMIC+0x2d8>
  6d1f76:	mov    %rax,%rbx
  6d1f79:	lea    0x70(%rsp),%rdi
  6d1f7e:	call   6b8b20 <core::ptr::drop_glue::<core::result::Result<gpui::runtime::Commit, gpui::runtime::Error>>>
  6d1f83:	mov    %rbx,%rdi
  6d1f86:	call   9f6c90 <_Unwind_Resume@plt>
  6d1f8b:	int3
  6d1f8c:	int3
  6d1f8d:	int3
  6d1f8e:	int3
  6d1f8f:	int3

