
/tmp/gpui-style-startup-base-target/release/examples/literal_startup:     file format elf64-x86-64


Disassembly of section .text:

00000000004ee250 <literal_startup::literal_builder_probe>:
  4ee250:	53                   	push   %rbx
  4ee251:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
  4ee258:	48 89 fb             	mov    %rdi,%rbx
  4ee25b:	c6 84 24 c8 00 00 00 	movb   $0x0,0xc8(%rsp)
  4ee262:	00 
  4ee263:	48 c7 44 24 38 ff ff 	movq   $0xffffffffffffffff,0x38(%rsp)
  4ee26a:	ff ff 
  4ee26c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  4ee273:	00 00 
  4ee275:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
  4ee27c:	00 00 
  4ee27e:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
  4ee285:	00 00 
  4ee287:	0f 10 05 36 9e b5 ff 	movups -0x4a61ca(%rip),%xmm0        # 480c4 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398>
  4ee28e:	0f 11 44 24 50       	movups %xmm0,0x50(%rsp)
  4ee293:	0f 10 05 3a 9e b5 ff 	movups -0x4a61c6(%rip),%xmm0        # 480d4 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398+0x10>
  4ee29a:	0f 11 44 24 60       	movups %xmm0,0x60(%rsp)
  4ee29f:	0f 10 05 3e 9e b5 ff 	movups -0x4a61c2(%rip),%xmm0        # 480e4 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398+0x20>
  4ee2a6:	0f 11 44 24 70       	movups %xmm0,0x70(%rsp)
  4ee2ab:	0f 10 05 42 9e b5 ff 	movups -0x4a61be(%rip),%xmm0        # 480f4 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398+0x30>
  4ee2b2:	0f 11 84 24 80 00 00 	movups %xmm0,0x80(%rsp)
  4ee2b9:	00 
  4ee2ba:	0f 10 05 43 9e b5 ff 	movups -0x4a61bd(%rip),%xmm0        # 48104 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398+0x40>
  4ee2c1:	0f 11 84 24 90 00 00 	movups %xmm0,0x90(%rsp)
  4ee2c8:	00 
  4ee2c9:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  4ee2d0:	00 03 00 
  4ee2d3:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  4ee2da:	00 
  4ee2db:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  4ee2e2:	00 00 00 00 00 
  4ee2e7:	0f 57 c0             	xorps  %xmm0,%xmm0
  4ee2ea:	0f 11 84 24 b8 00 00 	movups %xmm0,0xb8(%rsp)
  4ee2f1:	00 
  4ee2f2:	48 8d 05 df a7 b5 ff 	lea    -0x4a5821(%rip),%rax        # 48ad8 <anon.6ba7146c6aa0f0ae89a42e7891a41f44.7.llvm.11103893389065245635>
  4ee2f9:	48 89 04 24          	mov    %rax,(%rsp)
  4ee2fd:	89 f0                	mov    %esi,%eax
  4ee2ff:	0f 57 c0             	xorps  %xmm0,%xmm0
  4ee302:	f2 48 0f 2a c0       	cvtsi2sd %rax,%xmm0
  4ee307:	48 c7 44 24 08 05 00 	movq   $0x5,0x8(%rsp)
  4ee30e:	00 00 
  4ee310:	66 48 0f 7e c1       	movq   %xmm0,%rcx
  4ee315:	48 be 00 00 00 00 00 	movabs $0xfff0000000000000,%rsi
  4ee31c:	00 f0 ff 
  4ee31f:	48 01 ce             	add    %rcx,%rsi
  4ee322:	48 c1 ee 35          	shr    $0x35,%rsi
  4ee326:	81 fe ff 03 00 00    	cmp    $0x3ff,%esi
  4ee32c:	40 0f 92 c6          	setb   %sil
  4ee330:	48 85 c9             	test   %rcx,%rcx
  4ee333:	0f 94 c1             	sete   %cl
  4ee336:	40 0f 99 c7          	setns  %dil
  4ee33a:	40 20 f7             	and    %sil,%dil
  4ee33d:	40 08 cf             	or     %cl,%dil
  4ee340:	0f 84 28 01 00 00    	je     4ee46e <literal_startup::literal_builder_probe+0x21e>
  4ee346:	0f 57 c0             	xorps  %xmm0,%xmm0
  4ee349:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  4ee34e:	c7 44 24 50 01 00 00 	movl   $0x1,0x50(%rsp)
  4ee355:	00 
  4ee356:	f3 0f 11 44 24 54    	movss  %xmm0,0x54(%rsp)
  4ee35c:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  4ee361:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  4ee366:	0f 10 54 24 40       	movups 0x40(%rsp),%xmm2
  4ee36b:	0f 10 5c 24 6c       	movups 0x6c(%rsp),%xmm3
  4ee370:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  4ee377:	00 
  4ee378:	0f 29 8c 24 e0 00 00 	movaps %xmm1,0xe0(%rsp)
  4ee37f:	00 
  4ee380:	0f 29 94 24 f0 00 00 	movaps %xmm2,0xf0(%rsp)
  4ee387:	00 
  4ee388:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  4ee38d:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
  4ee394:	00 
  4ee395:	0f 11 9c 24 1c 01 00 	movups %xmm3,0x11c(%rsp)
  4ee39c:	00 
  4ee39d:	0f 10 44 24 7c       	movups 0x7c(%rsp),%xmm0
  4ee3a2:	0f 11 84 24 2c 01 00 	movups %xmm0,0x12c(%rsp)
  4ee3a9:	00 
  4ee3aa:	0f 10 84 24 8c 00 00 	movups 0x8c(%rsp),%xmm0
  4ee3b1:	00 
  4ee3b2:	0f 11 84 24 3c 01 00 	movups %xmm0,0x13c(%rsp)
  4ee3b9:	00 
  4ee3ba:	0f 10 84 24 9c 00 00 	movups 0x9c(%rsp),%xmm0
  4ee3c1:	00 
  4ee3c2:	0f 11 84 24 4c 01 00 	movups %xmm0,0x14c(%rsp)
  4ee3c9:	00 
  4ee3ca:	0f 10 84 24 ac 00 00 	movups 0xac(%rsp),%xmm0
  4ee3d1:	00 
  4ee3d2:	0f 11 84 24 5c 01 00 	movups %xmm0,0x15c(%rsp)
  4ee3d9:	00 
  4ee3da:	0f 10 84 24 bc 00 00 	movups 0xbc(%rsp),%xmm0
  4ee3e1:	00 
  4ee3e2:	0f 11 84 24 6c 01 00 	movups %xmm0,0x16c(%rsp)
  4ee3e9:	00 
  4ee3ea:	8b 84 24 cc 00 00 00 	mov    0xcc(%rsp),%eax
  4ee3f1:	89 84 24 7c 01 00 00 	mov    %eax,0x17c(%rsp)
  4ee3f8:	c7 84 24 08 01 00 00 	movl   $0x1,0x108(%rsp)
  4ee3ff:	01 00 00 00 
  4ee403:	0f 28 05 66 94 b5 ff 	movaps -0x4a6b9a(%rip),%xmm0        # 47870 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x1250>
  4ee40a:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  4ee411:	00 
  4ee412:	0f 10 02             	movups (%rdx),%xmm0
  4ee415:	0f 11 84 24 1c 01 00 	movups %xmm0,0x11c(%rsp)
  4ee41c:	00 
  4ee41d:	0f 10 02             	movups (%rdx),%xmm0
  4ee420:	0f 11 84 24 2c 01 00 	movups %xmm0,0x12c(%rsp)
  4ee427:	00 
  4ee428:	0f 28 05 d1 94 b5 ff 	movaps -0x4a6b2f(%rip),%xmm0        # 47900 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x12e0>
  4ee42f:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  4ee434:	f2 0f 10 05 14 8b b5 	movsd  -0x4a74ec(%rip),%xmm0        # 46f50 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x930>
  4ee43b:	ff 
  4ee43c:	f2 0f 11 44 24 30    	movsd  %xmm0,0x30(%rsp)
  4ee442:	48 8d b4 24 d0 00 00 	lea    0xd0(%rsp),%rsi
  4ee449:	00 
  4ee44a:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  4ee44f:	48 89 df             	mov    %rbx,%rdi
  4ee452:	ff 15 e0 84 2d 00    	call   *0x2d84e0(%rip)        # 7c6938 <_DYNAMIC+0x5a0>
  4ee458:	c7 83 84 00 00 00 00 	movl   $0x20000,0x84(%rbx)
  4ee45f:	00 02 00 
  4ee462:	48 89 d8             	mov    %rbx,%rax
  4ee465:	48 81 c4 80 01 00 00 	add    $0x180,%rsp
  4ee46c:	5b                   	pop    %rbx
  4ee46d:	c3                   	ret
  4ee46e:	48 89 e0             	mov    %rsp,%rax
  4ee471:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  4ee476:	48 8d 05 d3 ec 00 00 	lea    0xecd3(%rip),%rax        # 4fd150 <<&str as core::fmt::Display>::fmt>
  4ee47d:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  4ee482:	48 8d 3d f2 08 b5 ff 	lea    -0x4af70e(%rip),%rdi        # 3ed7b <anon.92dd3145bac80cf215b9d7fafbb74c84.0.llvm.12650873719306534212>
  4ee489:	48 8d 15 78 72 2b 00 	lea    0x2b7278(%rip),%rdx        # 7a5708 <anon.92dd3145bac80cf215b9d7fafbb74c84.2.llvm.12650873719306534212>
  4ee490:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  4ee495:	ff 15 9d 81 2d 00    	call   *0x2d819d(%rip)        # 7c6638 <_DYNAMIC+0x2a0>
  4ee49b:	0f 0b                	ud2
  4ee49d:	48 89 c3             	mov    %rax,%rbx
  4ee4a0:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  4ee4a5:	e8 76 1a 01 00       	call   4fff20 <core::ptr::drop_glue::<gpui::element::El>>
  4ee4aa:	48 89 df             	mov    %rbx,%rdi
  4ee4ad:	e8 be 4f 2b 00       	call   7a3470 <_Unwind_Resume@plt>
  4ee4b2:	ff 15 78 81 2d 00    	call   *0x2d8178(%rip)        # 7c6630 <_DYNAMIC+0x298>
