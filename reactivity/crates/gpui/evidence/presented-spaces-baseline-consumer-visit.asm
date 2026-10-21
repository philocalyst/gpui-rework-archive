
/tmp/gpui-spaces-inline-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004e4200 <presented_space_consumer::inspect>:
  4e4200:	55                   	push   %rbp
  4e4201:	41 57                	push   %r15
  4e4203:	41 56                	push   %r14
  4e4205:	41 55                	push   %r13
  4e4207:	41 54                	push   %r12
  4e4209:	53                   	push   %rbx
  4e420a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  4e4211:	48 85 ff             	test   %rdi,%rdi
  4e4214:	0f 84 12 01 00 00    	je     4e432c <presented_space_consumer::inspect+0x12c>
  4e421a:	80 bf 4e 09 00 00 00 	cmpb   $0x0,0x94e(%rdi)
  4e4221:	0f 85 0c 01 00 00    	jne    4e4333 <presented_space_consumer::inspect+0x133>
  4e4227:	80 bf 4c 09 00 00 01 	cmpb   $0x1,0x94c(%rdi)
  4e422e:	0f 85 06 01 00 00    	jne    4e433a <presented_space_consumer::inspect+0x13a>
  4e4234:	48 8d 8f 80 07 00 00 	lea    0x780(%rdi),%rcx
  4e423b:	48 8b 9f 48 07 00 00 	mov    0x748(%rdi),%rbx
  4e4242:	48 8b 97 00 08 00 00 	mov    0x800(%rdi),%rdx
  4e4249:	48 8d 42 18          	lea    0x18(%rdx),%rax
  4e424d:	48 85 d2             	test   %rdx,%rdx
  4e4250:	48 0f 45 d0          	cmovne %rax,%rdx
  4e4254:	48 8b 87 50 07 00 00 	mov    0x750(%rdi),%rax
  4e425b:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  4e4260:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
  4e4265:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  4e426a:	0f 10 87 d8 07 00 00 	movups 0x7d8(%rdi),%xmm0
  4e4271:	0f 11 44 24 40       	movups %xmm0,0x40(%rsp)
  4e4276:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
  4e427b:	48 85 c0             	test   %rax,%rax
  4e427e:	0f 84 90 00 00 00    	je     4e4314 <presented_space_consumer::inspect+0x114>
  4e4284:	48 c1 e0 04          	shl    $0x4,%rax
  4e4288:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  4e428c:	4c 8d bc 24 84 00 00 	lea    0x84(%rsp),%r15
  4e4293:	00 
  4e4294:	45 31 f6             	xor    %r14d,%r14d
  4e4297:	4c 8d 64 24 58       	lea    0x58(%rsp),%r12
  4e429c:	0f 1f 40 00          	nopl   0x0(%rax)
  4e42a0:	f3 0f 10 43 30       	movss  0x30(%rbx),%xmm0
  4e42a5:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  4e42ab:	0f 2e c0             	ucomiss %xmm0,%xmm0
  4e42ae:	bd 00 00 00 00       	mov    $0x0,%ebp
  4e42b3:	7a 15                	jp     4e42ca <presented_space_consumer::inspect+0xca>
  4e42b5:	8b 43 44             	mov    0x44(%rbx),%eax
  4e42b8:	89 44 24 20          	mov    %eax,0x20(%rsp)
  4e42bc:	0f 10 43 34          	movups 0x34(%rbx),%xmm0
  4e42c0:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  4e42c5:	bd 01 00 00 00       	mov    $0x1,%ebp
  4e42ca:	4c 89 ff             	mov    %r15,%rdi
  4e42cd:	48 89 de             	mov    %rbx,%rsi
  4e42d0:	48 8d 54 24 28       	lea    0x28(%rsp),%rdx
  4e42d5:	ff 15 35 7a 2b 00    	call   *0x2b7a35(%rip)        # 79bd10 <_DYNAMIC+0x2a0>
  4e42db:	89 6c 24 58          	mov    %ebp,0x58(%rsp)
  4e42df:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  4e42e5:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  4e42eb:	8b 44 24 20          	mov    0x20(%rsp),%eax
  4e42ef:	41 89 47 ec          	mov    %eax,-0x14(%r15)
  4e42f3:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  4e42f8:	41 0f 11 47 dc       	movups %xmm0,-0x24(%r15)
  4e42fd:	0f 10 03             	movups (%rbx),%xmm0
  4e4300:	41 0f 11 47 f0       	movups %xmm0,-0x10(%r15)
  4e4305:	49 ff c6             	inc    %r14
  4e4308:	48 83 c3 50          	add    $0x50,%rbx
  4e430c:	49 83 c5 b0          	add    $0xffffffffffffffb0,%r13
  4e4310:	75 8e                	jne    4e42a0 <presented_space_consumer::inspect+0xa0>
  4e4312:	eb 03                	jmp    4e4317 <presented_space_consumer::inspect+0x117>
  4e4314:	45 31 f6             	xor    %r14d,%r14d
  4e4317:	4c 89 f0             	mov    %r14,%rax
  4e431a:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  4e4321:	5b                   	pop    %rbx
  4e4322:	41 5c                	pop    %r12
  4e4324:	41 5d                	pop    %r13
  4e4326:	41 5e                	pop    %r14
  4e4328:	41 5f                	pop    %r15
  4e432a:	5d                   	pop    %rbp
  4e432b:	c3                   	ret
  4e432c:	b8 0d 00 00 00       	mov    $0xd,%eax
  4e4331:	eb 0c                	jmp    4e433f <presented_space_consumer::inspect+0x13f>
  4e4333:	b8 0e 00 00 00       	mov    $0xe,%eax
  4e4338:	eb 05                	jmp    4e433f <presented_space_consumer::inspect+0x13f>
  4e433a:	b8 12 00 00 00       	mov    $0x12,%eax
  4e433f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  4e4344:	48 8d 3d d5 0d b6 ff 	lea    -0x49f22b(%rip),%rdi        # 45120 <anon.9b6a2bf137718cf6323b54db08c0c337.2.llvm.8356091296274331725+0x204>
  4e434b:	48 8d 0d fe 72 29 00 	lea    0x2972fe(%rip),%rcx        # 77b650 <anon.9b6a2bf137718cf6323b54db08c0c337.1.llvm.8356091296274331725+0x138>
  4e4352:	4c 8d 05 df 72 29 00 	lea    0x2972df(%rip),%r8        # 77b638 <anon.9b6a2bf137718cf6323b54db08c0c337.1.llvm.8356091296274331725+0x120>
  4e4359:	48 8d 54 24 58       	lea    0x58(%rsp),%rdx
  4e435e:	be 2b 00 00 00       	mov    $0x2b,%esi
  4e4363:	ff 15 2f 7a 2b 00    	call   *0x2b7a2f(%rip)        # 79bd98 <_DYNAMIC+0x328>
  4e4369:	0f 0b                	ud2
  4e436b:	48 89 c3             	mov    %rax,%rbx
  4e436e:	48 8d 7c 24 58       	lea    0x58(%rsp),%rdi
  4e4373:	e8 78 f5 ff ff       	call   4e38f0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  4e4378:	48 89 df             	mov    %rbx,%rdi
  4e437b:	e8 a0 56 29 00       	call   779a20 <_Unwind_Resume@plt>
