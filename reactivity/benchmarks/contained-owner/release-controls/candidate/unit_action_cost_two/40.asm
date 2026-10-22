
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fb9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>:
  6fb9d0:	55                   	push   %rbp
  6fb9d1:	41 57                	push   %r15
  6fb9d3:	41 56                	push   %r14
  6fb9d5:	41 55                	push   %r13
  6fb9d7:	41 54                	push   %r12
  6fb9d9:	53                   	push   %rbx
  6fb9da:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  6fb9e1:	4d 89 c4             	mov    %r8,%r12
  6fb9e4:	49 89 cf             	mov    %rcx,%r15
  6fb9e7:	49 89 f6             	mov    %rsi,%r14
  6fb9ea:	48 89 fb             	mov    %rdi,%rbx
  6fb9ed:	41 83 38 02          	cmpl   $0x2,(%r8)
  6fb9f1:	75 08                	jne    6fb9fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2b>
  6fb9f3:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fb9fa:	01 
  6fb9fb:	4d 85 ff             	test   %r15,%r15
  6fb9fe:	0f 84 94 01 00 00    	je     6fbb98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c8>
  6fba04:	41 80 be 1e 08 00 00 	cmpb   $0x1,0x81e(%r14)
  6fba0b:	01 
  6fba0c:	0f 85 86 01 00 00    	jne    6fbb98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c8>
  6fba12:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  6fba19:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  6fba20:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fba24:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  6fba29:	48 0f 44 ce          	cmove  %rsi,%rcx
  6fba2d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  6fba31:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  6fba38:	00 00 
  6fba3a:	74 45                	je     6fba81 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb1>
  6fba3c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  6fba43:	00 00 
  6fba45:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  6fba4c:	00 00 
  6fba4e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fba55:	00 
  6fba56:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  6fba5d:	00 
  6fba5e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6fba65:	00 
  6fba66:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  6fba6a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  6fba6e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fba75:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fba79:	88 4b 10             	mov    %cl,0x10(%rbx)
  6fba7c:	e9 5e 03 00 00       	jmp    6fbddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fba81:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  6fba86:	41 83 ff 01          	cmp    $0x1,%r15d
  6fba8a:	0f 85 80 00 00 00    	jne    6fbb10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x140>
  6fba90:	48 89 d5             	mov    %rdx,%rbp
  6fba93:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  6fba9a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  6fbaa1:	49 c1 e4 04          	shl    $0x4,%r12
  6fbaa5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6fbaac:	00 00 00 00 
  6fbab0:	4d 85 e4             	test   %r12,%r12
  6fbab3:	0f 84 7a 03 00 00    	je     6fbe33 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x463>
  6fbab9:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  6fbabd:	48 8b 39             	mov    (%rcx),%rdi
  6fbac0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fbac4:	ff 50 18             	call   *0x18(%rax)
  6fbac7:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  6fbacb:	4c 89 e9             	mov    %r13,%rcx
  6fbace:	4c 39 f8             	cmp    %r15,%rax
  6fbad1:	75 dd                	jne    6fbab0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xe0>
  6fbad3:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  6fbada:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  6fbae1:	48 c1 e0 03          	shl    $0x3,%rax
  6fbae5:	31 f6                	xor    %esi,%esi
  6fbae7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fbaec:	0f 1f 40 00          	nopl   0x0(%rax)
  6fbaf0:	48 89 f2             	mov    %rsi,%rdx
  6fbaf3:	48 39 f0             	cmp    %rsi,%rax
  6fbaf6:	74 0a                	je     6fbb02 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x132>
  6fbaf8:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  6fbafc:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  6fbb00:	75 ee                	jne    6fbaf0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x120>
  6fbb02:	48 39 d0             	cmp    %rdx,%rax
  6fbb05:	0f 95 c1             	setne  %cl
  6fbb08:	48 89 ea             	mov    %rbp,%rdx
  6fbb0b:	e9 7f 00 00 00       	jmp    6fbb8f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1bf>
  6fbb10:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fbb17:	00 
  6fbb18:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  6fbb1f:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  6fbb26:	49 c1 e5 04          	shl    $0x4,%r13
  6fbb2a:	31 ed                	xor    %ebp,%ebp
  6fbb2c:	0f 1f 40 00          	nopl   0x0(%rax)
  6fbb30:	49 39 ed             	cmp    %rbp,%r13
  6fbb33:	0f 84 0e 03 00 00    	je     6fbe47 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x477>
  6fbb39:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  6fbb3d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  6fbb42:	4c 89 fe             	mov    %r15,%rsi
  6fbb45:	ff 50 30             	call   *0x30(%rax)
  6fbb48:	48 83 c5 10          	add    $0x10,%rbp
  6fbb4c:	84 c0                	test   %al,%al
  6fbb4e:	74 e0                	je     6fbb30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160>
  6fbb50:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  6fbb55:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  6fbb5a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  6fbb61:	00 
  6fbb62:	4c 89 fa             	mov    %r15,%rdx
  6fbb65:	ff 50 60             	call   *0x60(%rax)
  6fbb68:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  6fbb6f:	00 
  6fbb70:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fbb77:	00 
  6fbb78:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fbb7c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fbb81:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fbb88:	00 
  6fbb89:	0f 85 c7 fe ff ff    	jne    6fba56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fbb8f:	f6 c1 01             	test   $0x1,%cl
  6fbb92:	0f 84 f4 02 00 00    	je     6fbe8c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x4bc>
  6fbb98:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  6fbb9f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fbba4:	4c 89 f6             	mov    %r14,%rsi
  6fbba7:	31 c9                	xor    %ecx,%ecx
  6fbba9:	e8 62 ee ff ff       	call   6faa10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  6fbbae:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  6fbbb3:	75 16                	jne    6fbbcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fb>
  6fbbb5:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  6fbbbc:	00 
  6fbbbd:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  6fbbc4:	00 fe ff ff ff 
  6fbbc9:	eb 41                	jmp    6fbc0c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x23c>
  6fbbcb:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fbbd2:	00 
  6fbbd3:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6fbbda:	00 
  6fbbdb:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  6fbbe1:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  6fbbe8:	00 00 
  6fbbea:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  6fbbf1:	00 
  6fbbf2:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  6fbbf9:	00 
  6fbbfa:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  6fbc01:	00 00 
  6fbc03:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  6fbc0a:	00 00 
  6fbc0c:	40 b5 01             	mov    $0x1,%bpl
  6fbc0f:	45 31 ff             	xor    %r15d,%r15d
  6fbc12:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  6fbc19:	00 fe 
  6fbc1b:	0f 85 ba 00 00 00    	jne    6fbcdb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x30b>
  6fbc21:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fbc28:	00 
  6fbc29:	4c 89 f6             	mov    %r14,%rsi
  6fbc2c:	4c 89 e2             	mov    %r12,%rdx
  6fbc2f:	e8 9c 5e 00 00       	call   701ad0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::reconcile_editing>
  6fbc34:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fbc3b:	00 
  6fbc3c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  6fbc43:	00 00 
  6fbc45:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fbc49:	0f 85 61 01 00 00    	jne    6fbdb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x3e0>
  6fbc4f:	48 8d 35 32 c0 96 ff 	lea    -0x693fce(%rip),%rsi        # 67c88 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x99b>
  6fbc56:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fbc5d:	00 
  6fbc5e:	e8 cd 07 03 00       	call   72c430 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fbc63:	84 c0                	test   %al,%al
  6fbc65:	74 26                	je     6fbc8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2bd>
  6fbc67:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbc6e:	48 85 c0             	test   %rax,%rax
  6fbc71:	0f 84 7a 01 00 00    	je     6fbdf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x421>
  6fbc77:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fbc7e:	00 
  6fbc7f:	0f 95 c0             	setne  %al
  6fbc82:	44 08 e0             	or     %r12b,%al
  6fbc85:	a8 01                	test   $0x1,%al
  6fbc87:	0f 84 6e 01 00 00    	je     6fbdfb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x42b>
  6fbc8d:	48 8d 35 2c c0 96 ff 	lea    -0x693fd4(%rip),%rsi        # 67cc0 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x9d3>
  6fbc94:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fbc9b:	00 
  6fbc9c:	e8 8f 07 03 00       	call   72c430 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fbca1:	84 c0                	test   %al,%al
  6fbca3:	74 26                	je     6fbccb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2fb>
  6fbca5:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbcac:	48 85 c0             	test   %rax,%rax
  6fbcaf:	0f 84 a7 01 00 00    	je     6fbe5c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x48c>
  6fbcb5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fbcbc:	00 
  6fbcbd:	0f 95 c0             	setne  %al
  6fbcc0:	44 08 e0             	or     %r12b,%al
  6fbcc3:	a8 01                	test   $0x1,%al
  6fbcc5:	0f 84 9b 01 00 00    	je     6fbe66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x496>
  6fbccb:	48 89 df             	mov    %rbx,%rdi
  6fbcce:	4c 89 f6             	mov    %r14,%rsi
  6fbcd1:	e8 1a f0 01 00       	call   71acf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  6fbcd6:	e9 04 01 00 00       	jmp    6fbddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbcdb:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  6fbce2:	00 
  6fbce3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fbcea:	00 
  6fbceb:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  6fbcf2:	00 
  6fbcf3:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  6fbcfa:	00 
  6fbcfb:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  6fbd02:	00 
  6fbd03:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  6fbd0a:	00 
  6fbd0b:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  6fbd12:	00 
  6fbd13:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  6fbd1a:	00 
  6fbd1b:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbd22:	48 85 c0             	test   %rax,%rax
  6fbd25:	74 41                	je     6fbd68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbd27:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fbd2e:	48 85 c0             	test   %rax,%rax
  6fbd31:	74 35                	je     6fbd68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbd33:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fbd37:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  6fbd3b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  6fbd3f:	80 f9 02             	cmp    $0x2,%cl
  6fbd42:	74 24                	je     6fbd68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbd44:	f6 07 01             	testb  $0x1,(%rdi)
  6fbd47:	75 17                	jne    6fbd60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fbd49:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fbd4d:	a8 01                	test   $0x1,%al
  6fbd4f:	75 0f                	jne    6fbd60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fbd51:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fbd55:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fbd5a:	0f 84 31 19 00 00    	je     6fd691 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cc1>
  6fbd60:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fbd67:	01 
  6fbd68:	41 c6 86 1e 08 00 00 	movb   $0x0,0x81e(%r14)
  6fbd6f:	00 
  6fbd70:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fbd77:	00 00 00 00 
  6fbd7b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6fbd82:	00 
  6fbd83:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fbd87:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  6fbd8e:	00 00 
  6fbd90:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  6fbd97:	00 00 
  6fbd99:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  6fbda0:	00 
  6fbda1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fbda5:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  6fbdaa:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  6fbdae:	eb 2f                	jmp    6fbddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbdb0:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  6fbdb7:	00 00 
  6fbdb9:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  6fbdc0:	00 00 
  6fbdc2:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6fbdc9:	00 
  6fbdca:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6fbdce:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  6fbdd3:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  6fbdd8:	48 89 03             	mov    %rax,(%rbx)
  6fbddb:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  6fbddf:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  6fbde6:	5b                   	pop    %rbx
  6fbde7:	41 5c                	pop    %r12
  6fbde9:	41 5d                	pop    %r13
  6fbdeb:	41 5e                	pop    %r14
  6fbded:	41 5f                	pop    %r15
  6fbdef:	5d                   	pop    %rbp
  6fbdf0:	c3                   	ret
  6fbdf1:	41 80 fc 01          	cmp    $0x1,%r12b
  6fbdf5:	0f 84 92 fe ff ff    	je     6fbc8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2bd>
  6fbdfb:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  6fbe02:	00 00 
  6fbe04:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  6fbe0b:	00 
  6fbe0c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fbe13:	00 
  6fbe14:	74 16                	je     6fbe2c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x45c>
  6fbe16:	84 c0                	test   %al,%al
  6fbe18:	0f 84 c7 00 00 00    	je     6fbee5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x515>
  6fbe1e:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fbe25:	ff 
  6fbe26:	0f 85 b9 00 00 00    	jne    6fbee5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x515>
  6fbe2c:	31 c9                	xor    %ecx,%ecx
  6fbe2e:	e9 be 00 00 00       	jmp    6fbef1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x521>
  6fbe33:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fbe3a:	00 
  6fbe3b:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fbe40:	b1 01                	mov    $0x1,%cl
  6fbe42:	e9 0f fc ff ff       	jmp    6fba56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fbe47:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fbe4e:	00 
  6fbe4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fbe54:	44 89 f9             	mov    %r15d,%ecx
  6fbe57:	e9 fa fb ff ff       	jmp    6fba56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fbe5c:	41 80 fc 01          	cmp    $0x1,%r12b
  6fbe60:	0f 84 65 fe ff ff    	je     6fbccb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2fb>
  6fbe66:	40 84 ed             	test   %bpl,%bpl
  6fbe69:	0f 85 15 18 00 00    	jne    6fd684 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cb4>
  6fbe6f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  6fbe73:	4c 89 f6             	mov    %r14,%rsi
  6fbe76:	31 d2                	xor    %edx,%edx
  6fbe78:	4c 89 f9             	mov    %r15,%rcx
  6fbe7b:	e8 d0 78 00 00       	call   703750 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::publish_metadata>
  6fbe80:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fbe87:	e9 53 ff ff ff       	jmp    6fbddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbe8c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  6fbe93:	00 
  6fbe94:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  6fbe9b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  6fbea2:	48 85 c0             	test   %rax,%rax
  6fbea5:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fbeac:	00 
  6fbead:	0f 84 90 02 00 00    	je     6fc143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbeb3:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  6fbeba:	48 85 c9             	test   %rcx,%rcx
  6fbebd:	0f 84 9c 00 00 00    	je     6fbf5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x58f>
  6fbec3:	48 89 ca             	mov    %rcx,%rdx
  6fbec6:	48 83 e2 07          	and    $0x7,%rdx
  6fbeca:	74 4c                	je     6fbf18 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x548>
  6fbecc:	31 f6                	xor    %esi,%esi
  6fbece:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbed5:	48 ff c6             	inc    %rsi
  6fbed8:	48 39 f2             	cmp    %rsi,%rdx
  6fbedb:	75 f1                	jne    6fbece <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x4fe>
  6fbedd:	48 89 ca             	mov    %rcx,%rdx
  6fbee0:	48 29 f2             	sub    %rsi,%rdx
  6fbee3:	eb 36                	jmp    6fbf1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x54b>
  6fbee5:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fbeec:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fbef1:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fbef8:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  6fbefc:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fbf00:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  6fbf05:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  6fbf09:	88 43 30             	mov    %al,0x30(%rbx)
  6fbf0c:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fbf13:	e9 c7 fe ff ff       	jmp    6fbddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbf18:	48 89 ca             	mov    %rcx,%rdx
  6fbf1b:	48 83 f9 08          	cmp    $0x8,%rcx
  6fbf1f:	72 3e                	jb     6fbf5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x58f>
  6fbf21:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf28:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf2f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf36:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf3d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf44:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf4b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf52:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf59:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  6fbf5d:	75 c2                	jne    6fbf21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x551>
  6fbf5f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  6fbf66:	00 
  6fbf67:	0f 84 d6 01 00 00    	je     6fc143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbf6d:	80 38 00             	cmpb   $0x0,(%rax)
  6fbf70:	0f 85 cd 01 00 00    	jne    6fc143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbf76:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  6fbf7d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  6fbf84:	00 
  6fbf85:	e8 86 81 04 00       	call   744110 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  6fbf8a:	48 85 c0             	test   %rax,%rax
  6fbf8d:	0f 84 b0 01 00 00    	je     6fc143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbf93:	48 8b 48 10          	mov    0x10(%rax),%rcx
  6fbf97:	48 c1 e1 02          	shl    $0x2,%rcx
  6fbf9b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  6fbf9f:	ba 04 00 00 00       	mov    $0x4,%edx
  6fbfa4:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  6fbfa9:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fbfae:	b8 00 00 00 00       	mov    $0x0,%eax
  6fbfb3:	48 0f 45 c1          	cmovne %rcx,%rax
  6fbfb7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fbfbc:	48 85 c0             	test   %rax,%rax
  6fbfbf:	0f 84 7e 01 00 00    	je     6fc143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbfc5:	45 31 ed             	xor    %r13d,%r13d
  6fbfc8:	48 8b 05 39 d5 42 00 	mov    0x42d539(%rip),%rax        # b29508 <_DYNAMIC+0x398>
  6fbfcf:	48 83 c0 20          	add    $0x20,%rax
  6fbfd3:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fbfd8:	48 8b 05 31 d5 42 00 	mov    0x42d531(%rip),%rax        # b29510 <_DYNAMIC+0x3a0>
  6fbfdf:	48 83 c0 20          	add    $0x20,%rax
  6fbfe3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fbfe8:	48 8b 05 29 d5 42 00 	mov    0x42d529(%rip),%rax        # b29518 <_DYNAMIC+0x3a8>
  6fbfef:	48 83 c0 20          	add    $0x20,%rax
  6fbff3:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fbff8:	48 8b 05 21 d5 42 00 	mov    0x42d521(%rip),%rax        # b29520 <_DYNAMIC+0x3b0>
  6fbfff:	48 83 c0 20          	add    $0x20,%rax
  6fc003:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6fc008:	48 8b 05 19 d5 42 00 	mov    0x42d519(%rip),%rax        # b29528 <_DYNAMIC+0x3b8>
  6fc00f:	48 83 c0 20          	add    $0x20,%rax
  6fc013:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fc018:	48 8b 05 11 d5 42 00 	mov    0x42d511(%rip),%rax        # b29530 <_DYNAMIC+0x3c0>
  6fc01f:	48 83 c0 20          	add    $0x20,%rax
  6fc023:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fc02a:	00 
  6fc02b:	48 8b 05 06 d5 42 00 	mov    0x42d506(%rip),%rax        # b29538 <_DYNAMIC+0x3c8>
  6fc032:	48 83 c0 20          	add    $0x20,%rax
  6fc036:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fc03d:	00 
  6fc03e:	48 8b 05 fb d4 42 00 	mov    0x42d4fb(%rip),%rax        # b29540 <_DYNAMIC+0x3d0>
  6fc045:	48 83 c0 20          	add    $0x20,%rax
  6fc049:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fc04e:	48 8b 05 f3 d4 42 00 	mov    0x42d4f3(%rip),%rax        # b29548 <_DYNAMIC+0x3d8>
  6fc055:	48 83 c0 20          	add    $0x20,%rax
  6fc059:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  6fc060:	00 
  6fc061:	48 8b 05 e8 d4 42 00 	mov    0x42d4e8(%rip),%rax        # b29550 <_DYNAMIC+0x3e0>
  6fc068:	48 83 c0 20          	add    $0x20,%rax
  6fc06c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fc071:	48 8b 05 e0 d4 42 00 	mov    0x42d4e0(%rip),%rax        # b29558 <_DYNAMIC+0x3e8>
  6fc078:	48 83 c0 20          	add    $0x20,%rax
  6fc07c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6fc083:	00 
  6fc084:	48 8b 05 d5 d4 42 00 	mov    0x42d4d5(%rip),%rax        # b29560 <_DYNAMIC+0x3f0>
  6fc08b:	48 83 c0 20          	add    $0x20,%rax
  6fc08f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fc094:	48 8b 05 cd d4 42 00 	mov    0x42d4cd(%rip),%rax        # b29568 <_DYNAMIC+0x3f8>
  6fc09b:	48 83 c0 20          	add    $0x20,%rax
  6fc09f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fc0a4:	48 8d 2d 25 f2 95 ff 	lea    -0x6a0ddb(%rip),%rbp        # 5b2d0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1460>
  6fc0ab:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fc0b0:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  6fc0b4:	ff 15 b6 d4 42 00    	call   *0x42d4b6(%rip)        # b29570 <_DYNAMIC+0x400>
  6fc0ba:	0f b7 c0             	movzwl %ax,%eax
  6fc0bd:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  6fc0c2:	48 01 e9             	add    %rbp,%rcx
  6fc0c5:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fc0ca:	ff e1                	jmp    *%rcx
  6fc0cc:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fc0d1:	eb 57                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0d3:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fc0da:	00 
  6fc0db:	eb 4d                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0dd:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fc0e2:	eb 46                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0e4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fc0e9:	eb 3f                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0eb:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  6fc0f2:	00 
  6fc0f3:	eb 35                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0f5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fc0fa:	eb 2e                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0fc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fc103:	00 
  6fc104:	eb 24                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc106:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6fc10b:	eb 1d                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc10d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fc112:	eb 16                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc114:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fc11b:	00 
  6fc11c:	eb 0c                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc11e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fc123:	eb 05                	jmp    6fc12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc125:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fc12a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  6fc12e:	0f 85 03 11 00 00    	jne    6fd237 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1867>
  6fc134:	49 83 c5 04          	add    $0x4,%r13
  6fc138:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  6fc13d:	0f 85 68 ff ff ff    	jne    6fc0ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x6db>
  6fc143:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  6fc14a:	00 00 
  6fc14c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fc153:	48 85 ed             	test   %rbp,%rbp
  6fc156:	0f 84 f2 10 00 00    	je     6fd24e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x187e>
  6fc15c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fc163:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fc16a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  6fc171:	48 89 c7             	mov    %rax,%rdi
  6fc174:	48 89 e9             	mov    %rbp,%rcx
  6fc177:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  6fc17e:	00 
  6fc17f:	45 89 d3             	mov    %r10d,%r11d
  6fc182:	41 c1 e3 05          	shl    $0x5,%r11d
  6fc186:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  6fc18d:	45 31 c9             	xor    %r9d,%r9d
  6fc190:	4d 39 cb             	cmp    %r9,%r11
  6fc193:	74 28                	je     6fc1bd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7ed>
  6fc195:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  6fc19c:	00 
  6fc19d:	41 0f 97 c4          	seta   %r12b
  6fc1a1:	41 80 dc 00          	sbb    $0x0,%r12b
  6fc1a5:	49 83 c1 20          	add    $0x20,%r9
  6fc1a9:	49 ff c0             	inc    %r8
  6fc1ac:	41 80 fc 01          	cmp    $0x1,%r12b
  6fc1b0:	74 de                	je     6fc190 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7c0>
  6fc1b2:	45 0f b6 d4          	movzbl %r12b,%r10d
  6fc1b6:	45 85 d2             	test   %r10d,%r10d
  6fc1b9:	75 05                	jne    6fc1c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7f0>
  6fc1bb:	eb 1c                	jmp    6fc1d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x809>
  6fc1bd:	4d 89 d0             	mov    %r10,%r8
  6fc1c0:	48 83 ef 01          	sub    $0x1,%rdi
  6fc1c4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc1c9:	0f 82 92 00 00 00    	jb     6fc261 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x891>
  6fc1cf:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  6fc1d6:	00 
  6fc1d7:	eb 9e                	jmp    6fc177 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7a7>
  6fc1d9:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  6fc1df:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc1e4:	75 7b                	jne    6fc261 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x891>
  6fc1e6:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  6fc1eb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc1f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  6fc1f9:	4c 8d 05 a8 f3 3f 00 	lea    0x3ff3a8(%rip),%r8        # afb5a8 <__frame_dummy_init_array_entry+0xca0>
  6fc200:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc205:	4c 89 f9             	mov    %r15,%rcx
  6fc208:	45 31 c9             	xor    %r9d,%r9d
  6fc20b:	e8 50 8e 05 00       	call   755060 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::freeze>
  6fc210:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fc215:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  6fc21a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fc221:	00 
  6fc222:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fc226:	0f 85 e6 00 00 00    	jne    6fc312 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x942>
  6fc22c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fc233:	00 
  6fc234:	48 89 cd             	mov    %rcx,%rbp
  6fc237:	48 c1 ed 08          	shr    $0x8,%rbp
  6fc23b:	b8 20 00 00 00       	mov    $0x20,%eax
  6fc240:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc245:	89 cf                	mov    %ecx,%edi
  6fc247:	e9 bb 12 00 00       	jmp    6fd507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fc24c:	48 89 f9             	mov    %rdi,%rcx
  6fc24f:	48 83 e8 01          	sub    $0x1,%rax
  6fc253:	0f 82 f5 0f 00 00    	jb     6fd24e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x187e>
  6fc259:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  6fc260:	00 
  6fc261:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  6fc268:	41 89 f8             	mov    %edi,%r8d
  6fc26b:	41 c1 e0 05          	shl    $0x5,%r8d
  6fc26f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  6fc276:	45 31 ed             	xor    %r13d,%r13d
  6fc279:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6fc280:	4d 39 e8             	cmp    %r13,%r8
  6fc283:	74 c7                	je     6fc24c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x87c>
  6fc285:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  6fc28c:	00 
  6fc28d:	41 0f 97 c1          	seta   %r9b
  6fc291:	41 80 d9 00          	sbb    $0x0,%r9b
  6fc295:	49 83 c5 20          	add    $0x20,%r13
  6fc299:	48 ff c1             	inc    %rcx
  6fc29c:	41 80 f9 01          	cmp    $0x1,%r9b
  6fc2a0:	74 de                	je     6fc280 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x8b0>
  6fc2a2:	41 0f b6 f9          	movzbl %r9b,%edi
  6fc2a6:	85 ff                	test   %edi,%edi
  6fc2a8:	75 a5                	jne    6fc24f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x87f>
  6fc2aa:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  6fc2af:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6fc2b3:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc2b8:	74 41                	je     6fc2fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x92b>
  6fc2ba:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc2bf:	48 85 c0             	test   %rax,%rax
  6fc2c2:	0f 84 46 01 00 00    	je     6fc40e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa3e>
  6fc2c8:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc2cd:	48 ff c8             	dec    %rax
  6fc2d0:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  6fc2d7:	ff ff 3f 
  6fc2da:	48 21 c7             	and    %rax,%rdi
  6fc2dd:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  6fc2e1:	45 89 c8             	mov    %r9d,%r8d
  6fc2e4:	41 83 e0 03          	and    $0x3,%r8d
  6fc2e8:	48 83 ff 03          	cmp    $0x3,%rdi
  6fc2ec:	0f 83 25 01 00 00    	jae    6fc417 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa47>
  6fc2f2:	31 c0                	xor    %eax,%eax
  6fc2f4:	31 ff                	xor    %edi,%edi
  6fc2f6:	e9 b0 01 00 00       	jmp    6fc4ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xadb>
  6fc2fb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc302:	4c 8d 05 9f f2 3f 00 	lea    0x3ff29f(%rip),%r8        # afb5a8 <__frame_dummy_init_array_entry+0xca0>
  6fc309:	31 c0                	xor    %eax,%eax
  6fc30b:	31 ff                	xor    %edi,%edi
  6fc30d:	e9 d4 01 00 00       	jmp    6fc4e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb16>
  6fc312:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fc317:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fc31c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fc323:	00 
  6fc324:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  6fc32b:	00 
  6fc32c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fc333:	00 
  6fc334:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  6fc33b:	00 
  6fc33c:	41 83 fd 02          	cmp    $0x2,%r13d
  6fc340:	0f 84 bc 13 00 00    	je     6fd702 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d32>
  6fc346:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  6fc34b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  6fc352:	00 
  6fc353:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  6fc358:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  6fc35f:	00 
  6fc360:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  6fc367:	00 
  6fc368:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc36f:	00 
  6fc370:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fc375:	ba 06 00 00 00       	mov    $0x6,%edx
  6fc37a:	ff 15 f8 d1 42 00    	call   *0x42d1f8(%rip)        # b29578 <_DYNAMIC+0x408>
  6fc380:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  6fc387:	00 
  6fc388:	80 fa ff             	cmp    $0xff,%dl
  6fc38b:	0f 84 79 0e 00 00    	je     6fd20a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x183a>
  6fc391:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  6fc398:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  6fc39f:	00 
  6fc3a0:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  6fc3a7:	00 
  6fc3a8:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  6fc3af:	00 
  6fc3b0:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  6fc3b7:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  6fc3be:	80 fa 02             	cmp    $0x2,%dl
  6fc3c1:	0f 85 35 0f 00 00    	jne    6fd2fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x192c>
  6fc3c7:	89 ea                	mov    %ebp,%edx
  6fc3c9:	48 c1 e0 20          	shl    $0x20,%rax
  6fc3cd:	48 09 c8             	or     %rcx,%rax
  6fc3d0:	48 c1 e8 08          	shr    $0x8,%rax
  6fc3d4:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  6fc3db:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  6fc3e2:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  6fc3e9:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  6fc3f0:	00 
  6fc3f1:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  6fc3f8:	00 
  6fc3f9:	41 80 be 1f 08 00 00 	cmpb   $0x0,0x81f(%r14)
  6fc400:	00 
  6fc401:	0f 84 0c 0f 00 00    	je     6fd313 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1943>
  6fc407:	31 ed                	xor    %ebp,%ebp
  6fc409:	e9 24 0f 00 00       	jmp    6fd332 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1962>
  6fc40e:	31 ff                	xor    %edi,%edi
  6fc410:	31 c0                	xor    %eax,%eax
  6fc412:	e9 b5 00 00 00       	jmp    6fc4cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xafc>
  6fc417:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6fc41c:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  6fc423:	00 00 80 
  6fc426:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6fc42a:	49 21 c1             	and    %rax,%r9
  6fc42d:	31 c0                	xor    %eax,%eax
  6fc42f:	31 ff                	xor    %edi,%edi
  6fc431:	44 8b 11             	mov    (%rcx),%r10d
  6fc434:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  6fc438:	45 89 d4             	mov    %r10d,%r12d
  6fc43b:	41 f7 d4             	not    %r12d
  6fc43e:	41 f6 c4 03          	test   $0x3,%r12b
  6fc442:	41 0f 94 c4          	sete   %r12b
  6fc446:	45 89 c3             	mov    %r8d,%r11d
  6fc449:	41 f7 d3             	not    %r11d
  6fc44c:	41 f6 c3 03          	test   $0x3,%r11b
  6fc450:	41 0f 94 c3          	sete   %r11b
  6fc454:	45 08 e3             	or     %r12b,%r11b
  6fc457:	8b 51 08             	mov    0x8(%rcx),%edx
  6fc45a:	41 89 d4             	mov    %edx,%r12d
  6fc45d:	41 f7 d4             	not    %r12d
  6fc460:	41 f6 c4 03          	test   $0x3,%r12b
  6fc464:	41 0f 94 c4          	sete   %r12b
  6fc468:	8b 71 0c             	mov    0xc(%rcx),%esi
  6fc46b:	48 83 c1 10          	add    $0x10,%rcx
  6fc46f:	21 f2                	and    %esi,%edx
  6fc471:	f7 d6                	not    %esi
  6fc473:	40 f6 c6 03          	test   $0x3,%sil
  6fc477:	40 0f 94 c6          	sete   %sil
  6fc47b:	44 08 e6             	or     %r12b,%sil
  6fc47e:	44 08 de             	or     %r11b,%sil
  6fc481:	40 08 f7             	or     %sil,%dil
  6fc484:	45 21 c2             	and    %r8d,%r10d
  6fc487:	41 21 d2             	and    %edx,%r10d
  6fc48a:	41 f7 d2             	not    %r10d
  6fc48d:	41 f6 c2 03          	test   $0x3,%r10b
  6fc491:	0f 95 c2             	setne  %dl
  6fc494:	08 d0                	or     %dl,%al
  6fc496:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  6fc49a:	75 95                	jne    6fc431 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa61>
  6fc49c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6fc4a1:	4d 85 c0             	test   %r8,%r8
  6fc4a4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc4a9:	74 21                	je     6fc4cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xafc>
  6fc4ab:	45 31 c9             	xor    %r9d,%r9d
  6fc4ae:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  6fc4b2:	83 e2 03             	and    $0x3,%edx
  6fc4b5:	83 fa 03             	cmp    $0x3,%edx
  6fc4b8:	0f 95 c2             	setne  %dl
  6fc4bb:	40 0f 94 c6          	sete   %sil
  6fc4bf:	40 08 f7             	or     %sil,%dil
  6fc4c2:	08 d0                	or     %dl,%al
  6fc4c4:	49 ff c1             	inc    %r9
  6fc4c7:	4d 39 c8             	cmp    %r9,%r8
  6fc4ca:	75 e2                	jne    6fc4ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xade>
  6fc4cc:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc4d3:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  6fc4d8:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fc4df:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fc4e6:	40 0f b6 cf          	movzbl %dil,%ecx
  6fc4ea:	83 e1 01             	and    $0x1,%ecx
  6fc4ed:	89 0c 24             	mov    %ecx,(%rsp)
  6fc4f0:	44 0f b6 c8          	movzbl %al,%r9d
  6fc4f4:	41 83 e1 01          	and    $0x1,%r9d
  6fc4f8:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc4fd:	4c 89 f9             	mov    %r15,%rcx
  6fc500:	e8 5b 8b 05 00       	call   755060 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::freeze>
  6fc505:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  6fc50a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6fc50f:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fc516:	00 
  6fc517:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6fc51e:	00 
  6fc51f:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fc524:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  6fc529:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  6fc52d:	75 1d                	jne    6fc54c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb7c>
  6fc52f:	48 89 c5             	mov    %rax,%rbp
  6fc532:	48 c1 ed 08          	shr    $0x8,%rbp
  6fc536:	b9 20 00 00 00       	mov    $0x20,%ecx
  6fc53b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc540:	89 c7                	mov    %eax,%edi
  6fc542:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  6fc547:	e9 bb 0f 00 00       	jmp    6fd507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fc54c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fc551:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fc558:	00 
  6fc559:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6fc560:	00 
  6fc561:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fc568:	00 00 
  6fc56a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  6fc571:	00 00 
  6fc573:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  6fc579:	0f 84 69 0c 00 00    	je     6fd1e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1818>
  6fc57f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc584:	48 85 c0             	test   %rax,%rax
  6fc587:	0f 84 5b 0c 00 00    	je     6fd1e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1818>
  6fc58d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fc592:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc597:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc59c:	48 c1 e0 02          	shl    $0x2,%rax
  6fc5a0:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fc5a5:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6fc5a9:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  6fc5b0:	00 
  6fc5b1:	45 31 e4             	xor    %r12d,%r12d
  6fc5b4:	48 83 f8 02          	cmp    $0x2,%rax
  6fc5b8:	0f 85 72 0b 00 00    	jne    6fd130 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1760>
  6fc5be:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fc5c3:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fc5c7:	ff 15 a3 cf 42 00    	call   *0x42cfa3(%rip)        # b29570 <_DYNAMIC+0x400>
  6fc5cd:	66 85 c0             	test   %ax,%ax
  6fc5d0:	0f 85 ba 12 00 00    	jne    6fd890 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ec0>
  6fc5d6:	49 83 c4 04          	add    $0x4,%r12
  6fc5da:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fc5df:	75 dd                	jne    6fc5be <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xbee>
  6fc5e1:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc5e6:	48 85 c0             	test   %rax,%rax
  6fc5e9:	0f 84 dd 0d 00 00    	je     6fd3cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19fc>
  6fc5ef:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc5f4:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  6fc5fb:	00 
  6fc5fc:	48 c1 e0 02          	shl    $0x2,%rax
  6fc600:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  6fc606:	66 0f 6f 0d 52 e2 95 	movdqa -0x6a1dae(%rip),%xmm1        # 5a860 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9f0>
  6fc60d:	ff 
  6fc60e:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  6fc612:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  6fc619:	00 00 
  6fc61b:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  6fc622:	00 00 00 00 00 
  6fc627:	48 8d 0d ba ef 3f 00 	lea    0x3fefba(%rip),%rcx        # afb5e8 <__frame_dummy_init_array_entry+0xce0>
  6fc62e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fc633:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  6fc63a:	00 00 80 
  6fc63d:	48 ff c1             	inc    %rcx
  6fc640:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  6fc647:	00 
  6fc648:	48 8d 0d 65 e1 96 ff 	lea    -0x691e9b(%rip),%rcx        # 6a7b4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6fc64f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6fc656:	00 
  6fc657:	48 8d 0d 1a f0 3f 00 	lea    0x3ff01a(%rip),%rcx        # afb678 <__frame_dummy_init_array_entry+0xd70>
  6fc65e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6fc665:	00 
  6fc666:	48 8d 0d 93 ef 3f 00 	lea    0x3fef93(%rip),%rcx        # afb600 <__frame_dummy_init_array_entry+0xcf8>
  6fc66d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  6fc674:	00 
  6fc675:	48 8d 0d 0f e1 96 ff 	lea    -0x691ef1(%rip),%rcx        # 6a78b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6fc67c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  6fc683:	00 
  6fc684:	48 8d 0d fd e3 3f 00 	lea    0x3fe3fd(%rip),%rcx        # afaa88 <__frame_dummy_init_array_entry+0x180>
  6fc68b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  6fc692:	00 
  6fc693:	31 c9                	xor    %ecx,%ecx
  6fc695:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  6fc69c:	00 00 00 00 00 
  6fc6a1:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  6fc6a8:	00 00 00 00 00 
  6fc6ad:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fc6b4:	00 00 
  6fc6b6:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fc6bb:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fc6c2:	00 
  6fc6c3:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  6fc6c8:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  6fc6cb:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  6fc6d2:	89 e8                	mov    %ebp,%eax
  6fc6d4:	c1 e8 0f             	shr    $0xf,%eax
  6fc6d7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fc6de:	48 39 c6             	cmp    %rax,%rsi
  6fc6e1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fc6e6:	0f 86 7c 11 00 00    	jbe    6fd868 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e98>
  6fc6ec:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  6fc6f3:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  6fc6f7:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  6fc6fb:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fc700:	89 ef                	mov    %ebp,%edi
  6fc702:	ff 15 68 ce 42 00    	call   *0x42ce68(%rip)        # b29570 <_DYNAMIC+0x400>
  6fc708:	89 44 24 08          	mov    %eax,0x8(%rsp)
  6fc70c:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  6fc710:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fc717:	00 
  6fc718:	8b 54 24 08          	mov    0x8(%rsp),%edx
  6fc71c:	66 85 d2             	test   %dx,%dx
  6fc71f:	0f 84 31 01 00 00    	je     6fc856 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xe86>
  6fc725:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  6fc72c:	02 
  6fc72d:	0f 84 6d 0f 00 00    	je     6fd6a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd0>
  6fc733:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6fc738:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6fc73d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6fc744:	00 
  6fc745:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fc74a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  6fc74e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fc755:	00 00 
  6fc757:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  6fc75b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc762:	00 
  6fc763:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fc768:	ff 15 0a ce 42 00    	call   *0x42ce0a(%rip)        # b29578 <_DYNAMIC+0x408>
  6fc76e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  6fc775:	00 
  6fc776:	3c ff                	cmp    $0xff,%al
  6fc778:	0f 84 10 0d 00 00    	je     6fd48e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1abe>
  6fc77e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  6fc785:	00 
  6fc786:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  6fc78d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  6fc794:	00 
  6fc795:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  6fc79c:	00 
  6fc79d:	41 8b 78 10          	mov    0x10(%r8),%edi
  6fc7a1:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  6fc7a8:	00 
  6fc7a9:	41 89 79 10          	mov    %edi,0x10(%r9)
  6fc7ad:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  6fc7b2:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  6fc7b7:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  6fc7be:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  6fc7c5:	00 
  6fc7c6:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  6fc7cd:	00 
  6fc7ce:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  6fc7d5:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6fc7d9:	44 0f b7 e9          	movzwl %cx,%r13d
  6fc7dd:	48 8d 05 c4 f1 3f 00 	lea    0x3ff1c4(%rip),%rax        # afb9a8 <__frame_dummy_init_array_entry+0x10a0>
  6fc7e4:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fc7e9:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  6fc7ed:	0f 84 c7 00 00 00    	je     6fc8ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xeea>
  6fc7f3:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc7f8:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  6fc7ff:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fc804:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  6fc80b:	00 
  6fc80c:	ff 15 6e cd 42 00    	call   *0x42cd6e(%rip)        # b29580 <_DYNAMIC+0x410>
  6fc812:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fc817:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fc81c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fc820:	0f 85 ab 0d 00 00    	jne    6fd5d1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c01>
  6fc826:	40 80 ff 01          	cmp    $0x1,%dil
  6fc82a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc82f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fc834:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fc839:	0f 85 9e 08 00 00    	jne    6fd0dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x170d>
  6fc83f:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fc846:	01 
  6fc847:	b0 01                	mov    $0x1,%al
  6fc849:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fc850:	00 
  6fc851:	e9 4e 08 00 00       	jmp    6fd0a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fc856:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  6fc85c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc861:	0f 84 59 0e 00 00    	je     6fd6c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cf0>
  6fc867:	83 e5 03             	and    $0x3,%ebp
  6fc86a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  6fc86d:	83 f8 02             	cmp    $0x2,%eax
  6fc870:	0f 83 8a 00 00 00    	jae    6fc900 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf30>
  6fc876:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fc87d:	48 8b 38             	mov    (%rax),%rdi
  6fc880:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  6fc886:	48 85 ff             	test   %rdi,%rdi
  6fc889:	0f 84 19 0e 00 00    	je     6fd6a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd8>
  6fc88f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fc894:	ff 15 ee cc 42 00    	call   *0x42ccee(%rip)        # b29588 <_DYNAMIC+0x418>
  6fc89a:	48 85 c0             	test   %rax,%rax
  6fc89d:	0f 84 05 0e 00 00    	je     6fd6a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd8>
  6fc8a3:	83 fd 01             	cmp    $0x1,%ebp
  6fc8a6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc8ab:	0f 85 a6 00 00 00    	jne    6fc957 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf87>
  6fc8b1:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fc8b5:	e9 a1 00 00 00       	jmp    6fc95b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf8b>
  6fc8ba:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  6fc8c1:	48 8b 00             	mov    (%rax),%rax
  6fc8c4:	48 8d 15 3d ea 95 ff 	lea    -0x6a15c3(%rip),%rdx        # 5b308 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1498>
  6fc8cb:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  6fc8cf:	48 01 d1             	add    %rdx,%rcx
  6fc8d2:	48 8d 05 47 f2 95 ff 	lea    -0x6a0db9(%rip),%rax        # 5bb20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  6fc8d9:	ff e1                	jmp    *%rcx
  6fc8db:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  6fc8e2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fc8e7:	48 39 c6             	cmp    %rax,%rsi
  6fc8ea:	0f 86 3a 0f 00 00    	jbe    6fd82a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e5a>
  6fc8f0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fc8f4:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  6fc8fb:	e9 4e 03 00 00       	jmp    6fcc4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x127e>
  6fc900:	85 ed                	test   %ebp,%ebp
  6fc902:	0f 85 18 0e 00 00    	jne    6fd720 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d50>
  6fc908:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fc90f:	00 
  6fc910:	8b 40 20             	mov    0x20(%rax),%eax
  6fc913:	89 c1                	mov    %eax,%ecx
  6fc915:	83 e1 07             	and    $0x7,%ecx
  6fc918:	83 f9 06             	cmp    $0x6,%ecx
  6fc91b:	74 74                	je     6fc991 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc91d:	c1 e8 03             	shr    $0x3,%eax
  6fc920:	74 6f                	je     6fc991 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc922:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fc929:	ff c8                	dec    %eax
  6fc92b:	48 39 c6             	cmp    %rax,%rsi
  6fc92e:	0f 86 23 0f 00 00    	jbe    6fd857 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e87>
  6fc934:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  6fc93b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fc93f:	48 c1 e0 04          	shl    $0x4,%rax
  6fc943:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  6fc948:	0f 84 59 0e 00 00    	je     6fd7a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1dd7>
  6fc94e:	48 01 c1             	add    %rax,%rcx
  6fc951:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  6fc955:	eb 13                	jmp    6fc96a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf9a>
  6fc957:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fc95b:	b0 01                	mov    $0x1,%al
  6fc95d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  6fc964:	00 
  6fc965:	48 85 ff             	test   %rdi,%rdi
  6fc968:	74 27                	je     6fc991 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc96a:	48 8b 07             	mov    (%rdi),%rax
  6fc96d:	48 d1 e8             	shr    $1,%rax
  6fc970:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fc975:	48 39 d0             	cmp    %rdx,%rax
  6fc978:	75 17                	jne    6fc991 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc97a:	48 83 c7 10          	add    $0x10,%rdi
  6fc97e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fc983:	ff 15 07 cc 42 00    	call   *0x42cc07(%rip)        # b29590 <bcmp@GLIBC_2.2.5>
  6fc989:	85 c0                	test   %eax,%eax
  6fc98b:	0f 84 3a 06 00 00    	je     6fcfcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x15fb>
  6fc991:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  6fc996:	4d 85 e4             	test   %r12,%r12
  6fc999:	75 6d                	jne    6fca08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1038>
  6fc99b:	4c 8d 25 ee e6 95 ff 	lea    -0x6a1912(%rip),%r12        # 5b090 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1220>
  6fc9a2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6fc9a7:	48 85 f6             	test   %rsi,%rsi
  6fc9aa:	74 41                	je     6fc9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x101d>
  6fc9ac:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fc9b3:	00 00 
  6fc9b5:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc9ba:	31 d2                	xor    %edx,%edx
  6fc9bc:	31 c9                	xor    %ecx,%ecx
  6fc9be:	ff 15 d4 cb 42 00    	call   *0x42cbd4(%rip)        # b29598 <_DYNAMIC+0x428>
  6fc9c4:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6fc9c9:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  6fc9cd:	0f 85 6e 0e 00 00    	jne    6fd841 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e71>
  6fc9d3:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  6fc9d8:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  6fc9dd:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fc9e2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fc9e7:	ff 15 eb c9 42 00    	call   *0x42c9eb(%rip)        # b293d8 <memcpy@GLIBC_2.14>
  6fc9ed:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  6fc9f4:	00 00 
  6fc9f6:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  6fc9fd:	00 00 
  6fc9ff:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  6fca06:	00 00 
  6fca08:	85 ed                	test   %ebp,%ebp
  6fca0a:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  6fca0f:	0f 84 b1 00 00 00    	je     6fcac6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10f6>
  6fca15:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fca1c:	48 8b 38             	mov    (%rax),%rdi
  6fca1f:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  6fca25:	48 85 ff             	test   %rdi,%rdi
  6fca28:	0f 84 2e 0d 00 00    	je     6fd75c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d8c>
  6fca2e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fca33:	ff 15 67 cb 42 00    	call   *0x42cb67(%rip)        # b295a0 <_DYNAMIC+0x430>
  6fca39:	48 85 c0             	test   %rax,%rax
  6fca3c:	0f 84 1a 0d 00 00    	je     6fd75c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d8c>
  6fca42:	83 fd 01             	cmp    $0x1,%ebp
  6fca45:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fca4a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fca4f:	0f 85 4d 01 00 00    	jne    6fcba2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11d2>
  6fca55:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fca5a:	48 85 c9             	test   %rcx,%rcx
  6fca5d:	74 2c                	je     6fca8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fca5f:	f6 01 01             	testb  $0x1,(%rcx)
  6fca62:	75 27                	jne    6fca8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fca64:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fca68:	f6 c2 01             	test   $0x1,%dl
  6fca6b:	75 1e                	jne    6fca8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fca6d:	ba 02 00 00 00       	mov    $0x2,%edx
  6fca72:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fca78:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fca7f:	00 
  6fca80:	48 f7 da             	neg    %rdx
  6fca83:	71 06                	jno    6fca8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fca85:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fca8b:	48 89 c5             	mov    %rax,%rbp
  6fca8e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fca92:	48 85 ff             	test   %rdi,%rdi
  6fca95:	74 1c                	je     6fcab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fca97:	f6 07 01             	testb  $0x1,(%rdi)
  6fca9a:	75 17                	jne    6fcab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fca9c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcaa0:	a8 01                	test   $0x1,%al
  6fcaa2:	75 0f                	jne    6fcab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fcaa4:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fcaa8:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fcaad:	0f 84 50 06 00 00    	je     6fd103 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1733>
  6fcab3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fcab8:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fcabc:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fcac1:	e9 de 05 00 00       	jmp    6fd0a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fcac6:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fcacd:	00 
  6fcace:	8b 78 20             	mov    0x20(%rax),%edi
  6fcad1:	89 f8                	mov    %edi,%eax
  6fcad3:	83 e0 07             	and    $0x7,%eax
  6fcad6:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  6fcadc:	83 f8 06             	cmp    $0x6,%eax
  6fcadf:	0f 84 59 0c 00 00    	je     6fd73e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d6e>
  6fcae5:	c1 ef 03             	shr    $0x3,%edi
  6fcae8:	0f 84 50 0c 00 00    	je     6fd73e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d6e>
  6fcaee:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fcaf5:	ff cf                	dec    %edi
  6fcaf7:	48 39 fe             	cmp    %rdi,%rsi
  6fcafa:	0f 86 01 0d 00 00    	jbe    6fd801 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e31>
  6fcb00:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fcb07:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6fcb0b:	48 c1 e0 04          	shl    $0x4,%rax
  6fcb0f:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fcb15:	0f 84 5f 0c 00 00    	je     6fd77a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1daa>
  6fcb1b:	4d 85 e4             	test   %r12,%r12
  6fcb1e:	0f 84 68 0c 00 00    	je     6fd78c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1dbc>
  6fcb24:	41 f6 04 24 01       	testb  $0x1,(%r12)
  6fcb29:	75 2a                	jne    6fcb55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fcb2b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  6fcb30:	f6 c1 01             	test   $0x1,%cl
  6fcb33:	75 20                	jne    6fcb55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fcb35:	b9 02 00 00 00       	mov    $0x2,%ecx
  6fcb3a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  6fcb41:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  6fcb48:	00 
  6fcb49:	48 f7 d9             	neg    %rcx
  6fcb4c:	71 07                	jno    6fcb55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fcb4e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  6fcb55:	48 01 c5             	add    %rax,%rbp
  6fcb58:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  6fcb5c:	f6 07 01             	testb  $0x1,(%rdi)
  6fcb5f:	75 17                	jne    6fcb78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fcb61:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcb65:	a8 01                	test   $0x1,%al
  6fcb67:	75 0f                	jne    6fcb78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fcb69:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fcb6d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fcb72:	0f 84 7c 05 00 00    	je     6fd0f4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1724>
  6fcb78:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fcb7c:	48 89 ef             	mov    %rbp,%rdi
  6fcb7f:	e8 4c 7e ff ff       	call   6f49d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fcb84:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fcb8b:	ff 
  6fcb8c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fcb93:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fcb98:	e8 e3 89 04 00       	call   745580 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fcb9d:	e9 e1 04 00 00       	jmp    6fd083 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16b3>
  6fcba2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fcba7:	48 85 c9             	test   %rcx,%rcx
  6fcbaa:	74 2c                	je     6fcbd8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcbac:	f6 01 01             	testb  $0x1,(%rcx)
  6fcbaf:	75 27                	jne    6fcbd8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcbb1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fcbb5:	f6 c2 01             	test   $0x1,%dl
  6fcbb8:	75 1e                	jne    6fcbd8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcbba:	ba 02 00 00 00       	mov    $0x2,%edx
  6fcbbf:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fcbc5:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fcbcc:	00 
  6fcbcd:	48 f7 da             	neg    %rdx
  6fcbd0:	71 06                	jno    6fcbd8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcbd2:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fcbd8:	48 89 c5             	mov    %rax,%rbp
  6fcbdb:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fcbdf:	48 85 ff             	test   %rdi,%rdi
  6fcbe2:	74 1c                	je     6fcc00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcbe4:	f6 07 01             	testb  $0x1,(%rdi)
  6fcbe7:	75 17                	jne    6fcc00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcbe9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcbed:	a8 01                	test   $0x1,%al
  6fcbef:	75 0f                	jne    6fcc00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcbf1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fcbf5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fcbfa:	0f 84 12 05 00 00    	je     6fd112 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1742>
  6fcc00:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fcc05:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fcc09:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fcc0e:	e9 91 04 00 00       	jmp    6fd0a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fcc13:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  6fcc1a:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6fcc1f:	48 39 ce             	cmp    %rcx,%rsi
  6fcc22:	0f 86 eb 0b 00 00    	jbe    6fd813 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e43>
  6fcc28:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  6fcc2f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  6fcc36:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  6fcc3a:	48 39 c6             	cmp    %rax,%rsi
  6fcc3d:	0f 86 d9 0b 00 00    	jbe    6fd81c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e4c>
  6fcc43:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fcc47:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  6fcc4e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  6fcc52:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  6fcc59:	00 
  6fcc5a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  6fcc5e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  6fcc65:	00 
  6fcc66:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  6fcc6a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  6fcc6f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  6fcc73:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  6fcc77:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  6fcc7e:	00 
  6fcc7f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  6fcc86:	00 
  6fcc87:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  6fcc8e:	00 00 
  6fcc90:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  6fcc97:	00 00 
  6fcc99:	eb 1a                	jmp    6fccb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x12e5>
  6fcc9b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  6fcca2:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  6fcca9:	00 
  6fccaa:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6fccaf:	ff 15 f3 c7 42 00    	call   *0x42c7f3(%rip)        # b294a8 <_DYNAMIC+0x338>
  6fccb5:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  6fccbc:	00 
  6fccbd:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  6fccc4:	00 
  6fccc5:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  6fcccc:	00 
  6fcccd:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  6fccd4:	00 
  6fccd5:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  6fccdc:	00 00 
  6fccde:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  6fcce5:	00 00 
  6fcce7:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  6fccee:	00 
  6fccef:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  6fccf6:	00 
  6fccf7:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  6fccfe:	00 
  6fccff:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  6fcd06:	00 
  6fcd07:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  6fcd0e:	00 00 
  6fcd10:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  6fcd16:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fcd1d:	00 
  6fcd1e:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  6fcd25:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fcd2a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  6fcd2f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6fcd34:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  6fcd3b:	00 
  6fcd3c:	e8 2f 20 07 00       	call   76ed70 <<gpui::property::Overrides>::update_base>
  6fcd41:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  6fcd48:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  6fcd4f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  6fcd56:	00 
  6fcd57:	48 c1 e5 20          	shl    $0x20,%rbp
  6fcd5b:	48 09 cd             	or     %rcx,%rbp
  6fcd5e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  6fcd65:	00 
  6fcd66:	83 f8 02             	cmp    $0x2,%eax
  6fcd69:	0f 84 ba 08 00 00    	je     6fd629 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c59>
  6fcd6f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  6fcd76:	00 
  6fcd77:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  6fcd7b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  6fcd82:	00 
  6fcd83:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  6fcd87:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  6fcd8b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  6fcd8f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  6fcd93:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  6fcd97:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  6fcd9b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  6fcd9f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6fcda3:	0f 11 02             	movups %xmm0,(%rdx)
  6fcda6:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  6fcdad:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  6fcdb4:	00 
  6fcdb5:	48 89 e8             	mov    %rbp,%rax
  6fcdb8:	48 c1 e8 20          	shr    $0x20,%rax
  6fcdbc:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  6fcdc3:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  6fcdca:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  6fcdd1:	00 00 
  6fcdd3:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  6fcdda:	00 00 
  6fcddc:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  6fcde3:	00 
  6fcde4:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  6fcdeb:	00 
  6fcdec:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  6fcdf3:	00 00 
  6fcdf5:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  6fcdfc:	00 00 
  6fcdfe:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  6fce05:	00 
  6fce06:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  6fce0d:	00 
  6fce0e:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  6fce15:	00 
  6fce16:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  6fce1d:	00 
  6fce1e:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  6fce25:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  6fce2c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  6fce33:	00 
  6fce34:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  6fce3b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  6fce42:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  6fce49:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  6fce50:	00 
  6fce51:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  6fce58:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  6fce5f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  6fce66:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  6fce6d:	00 
  6fce6e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  6fce75:	00 
  6fce76:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  6fce7d:	00 
  6fce7e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  6fce85:	01 
  6fce86:	75 1a                	jne    6fcea2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x14d2>
  6fce88:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  6fce8f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  6fce96:	0f 94 c1             	sete   %cl
  6fce99:	84 c8                	test   %cl,%al
  6fce9b:	75 0d                	jne    6fceaa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x14da>
  6fce9d:	e9 38 01 00 00       	jmp    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcea2:	a8 01                	test   $0x1,%al
  6fcea4:	0f 85 30 01 00 00    	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fceaa:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  6fceb1:	00 
  6fceb2:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  6fceb9:	01 
  6fceba:	75 1b                	jne    6fced7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1507>
  6fcebc:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  6fcec3:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  6fceca:	0f 94 c1             	sete   %cl
  6fcecd:	84 c8                	test   %cl,%al
  6fcecf:	0f 84 05 01 00 00    	je     6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fced5:	eb 08                	jmp    6fcedf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x150f>
  6fced7:	a8 01                	test   $0x1,%al
  6fced9:	0f 85 fb 00 00 00    	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcedf:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  6fcee6:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  6fceed:	0f 85 e7 00 00 00    	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcef3:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  6fcefa:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  6fcf01:	0f 85 d3 00 00 00    	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf07:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  6fcf0e:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  6fcf15:	0f 85 bf 00 00 00    	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf1b:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  6fcf22:	00 
  6fcf23:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  6fcf2a:	0f 85 aa 00 00 00    	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf30:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  6fcf37:	00 
  6fcf38:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  6fcf3f:	0f 85 95 00 00 00    	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf45:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  6fcf4c:	00 
  6fcf4d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  6fcf54:	0f 85 80 00 00 00    	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf5a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  6fcf61:	00 
  6fcf62:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  6fcf69:	75 6f                	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf6b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  6fcf72:	00 
  6fcf73:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  6fcf7a:	00 
  6fcf7b:	e8 a0 ef 02 00       	call   72bf20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  6fcf80:	84 c0                	test   %al,%al
  6fcf82:	74 56                	je     6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf84:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  6fcf8b:	00 00 
  6fcf8d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  6fcf94:	00 00 
  6fcf96:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fcf9a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fcf9e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fcfa3:	75 35                	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcfa5:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  6fcfac:	00 00 
  6fcfae:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  6fcfb5:	00 00 
  6fcfb7:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fcfbb:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fcfbf:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fcfc4:	75 14                	jne    6fcfda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcfc6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fcfcb:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fcfd0:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fcfd5:	e9 08 01 00 00       	jmp    6fd0e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1712>
  6fcfda:	48 8d 05 c7 e9 3f 00 	lea    0x3fe9c7(%rip),%rax        # afb9a8 <__frame_dummy_init_array_entry+0x10a0>
  6fcfe1:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fcfe6:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  6fcfea:	75 11                	jne    6fcffd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x162d>
  6fcfec:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fcff3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fcff8:	e8 83 85 04 00       	call   745580 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fcffd:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  6fd003:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  6fd008:	75 5a                	jne    6fd064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fd00a:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fd011:	00 
  6fd012:	8b 40 20             	mov    0x20(%rax),%eax
  6fd015:	89 c1                	mov    %eax,%ecx
  6fd017:	83 e1 07             	and    $0x7,%ecx
  6fd01a:	83 f9 06             	cmp    $0x6,%ecx
  6fd01d:	74 45                	je     6fd064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fd01f:	c1 e8 03             	shr    $0x3,%eax
  6fd022:	74 40                	je     6fd064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fd024:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fd02b:	ff c8                	dec    %eax
  6fd02d:	48 39 c6             	cmp    %rax,%rsi
  6fd030:	0f 86 fd 07 00 00    	jbe    6fd833 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e63>
  6fd036:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fd03d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fd041:	48 c1 e0 04          	shl    $0x4,%rax
  6fd045:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fd04b:	0f 84 65 07 00 00    	je     6fd7b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1de6>
  6fd051:	48 01 c5             	add    %rax,%rbp
  6fd054:	48 89 ef             	mov    %rbp,%rdi
  6fd057:	e8 74 79 ff ff       	call   6f49d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fd05c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fd063:	ff 
  6fd064:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  6fd06b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  6fd072:	4c 89 e6             	mov    %r12,%rsi
  6fd075:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  6fd07c:	00 
  6fd07d:	ff 15 25 c5 42 00    	call   *0x42c525(%rip)        # b295a8 <_DYNAMIC+0x438>
  6fd083:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fd08a:	01 
  6fd08b:	b0 01                	mov    $0x1,%al
  6fd08d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fd094:	00 
  6fd095:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd09a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fd09f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fd0a4:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  6fd0ab:	00 
  6fd0ac:	0f 94 c0             	sete   %al
  6fd0af:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  6fd0b6:	74 0c                	je     6fd0c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16f4>
  6fd0b8:	b0 01                	mov    $0x1,%al
  6fd0ba:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fd0c1:	00 
  6fd0c2:	eb 19                	jmp    6fd0dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x170d>
  6fd0c4:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  6fd0cb:	b0 01                	mov    $0x1,%al
  6fd0cd:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fd0d4:	00 
  6fd0d5:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  6fd0dc:	00 
  6fd0dd:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fd0e2:	48 83 c1 04          	add    $0x4,%rcx
  6fd0e6:	48 39 c8             	cmp    %rcx,%rax
  6fd0e9:	0f 85 cc f5 ff ff    	jne    6fc6bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xceb>
  6fd0ef:	e9 ee 02 00 00       	jmp    6fd3e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a12>
  6fd0f4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd0f8:	ff 15 f2 c2 42 00    	call   *0x42c2f2(%rip)        # b293f0 <_DYNAMIC+0x280>
  6fd0fe:	e9 75 fa ff ff       	jmp    6fcb78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fd103:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd107:	ff 15 e3 c2 42 00    	call   *0x42c2e3(%rip)        # b293f0 <_DYNAMIC+0x280>
  6fd10d:	e9 a1 f9 ff ff       	jmp    6fcab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fd112:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd116:	ff 15 d4 c2 42 00    	call   *0x42c2d4(%rip)        # b293f0 <_DYNAMIC+0x280>
  6fd11c:	e9 df fa ff ff       	jmp    6fcc00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fd121:	49 83 c4 04          	add    $0x4,%r12
  6fd125:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fd12a:	0f 84 b1 f4 ff ff    	je     6fc5e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xc11>
  6fd130:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fd135:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fd139:	ff 15 31 c4 42 00    	call   *0x42c431(%rip)        # b29570 <_DYNAMIC+0x400>
  6fd13f:	66 85 c0             	test   %ax,%ax
  6fd142:	74 dd                	je     6fd121 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1751>
  6fd144:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fd149:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  6fd14e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  6fd155:	00 
  6fd156:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  6fd15b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  6fd15f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fd166:	00 00 
  6fd168:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  6fd16c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fd173:	00 
  6fd174:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fd179:	89 c2                	mov    %eax,%edx
  6fd17b:	ff 15 f7 c3 42 00    	call   *0x42c3f7(%rip)        # b29578 <_DYNAMIC+0x408>
  6fd181:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  6fd188:	ff 
  6fd189:	75 96                	jne    6fd121 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1751>
  6fd18b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd192:	00 
  6fd193:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd19a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd1a1:	00 
  6fd1a2:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd1a6:	48 09 c5             	or     %rax,%rbp
  6fd1a9:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd1ae:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd1b3:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd1b8:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd1bd:	48 85 f6             	test   %rsi,%rsi
  6fd1c0:	0f 8e 12 02 00 00    	jle    6fd3d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a08>
  6fd1c6:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd1cb:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd1cf:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd1d4:	ff 15 de c1 42 00    	call   *0x42c1de(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fd1da:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd1de:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd1e3:	e9 1f 03 00 00       	jmp    6fd507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fd1e8:	31 ff                	xor    %edi,%edi
  6fd1ea:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd1ef:	48 85 f6             	test   %rsi,%rsi
  6fd1f2:	7e 5c                	jle    6fd250 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd1f4:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd1f9:	89 fd                	mov    %edi,%ebp
  6fd1fb:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd200:	ff 15 b2 c1 42 00    	call   *0x42c1b2(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fd206:	89 ef                	mov    %ebp,%edi
  6fd208:	eb 46                	jmp    6fd250 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd20a:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd211:	00 
  6fd212:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd219:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd220:	00 
  6fd221:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd225:	48 09 c5             	or     %rax,%rbp
  6fd228:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd22d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd232:	e9 99 02 00 00       	jmp    6fd4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd237:	b0 01                	mov    $0x1,%al
  6fd239:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fd23e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fd245:	48 85 ed             	test   %rbp,%rbp
  6fd248:	0f 85 0e ef ff ff    	jne    6fc15c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x78c>
  6fd24e:	31 ff                	xor    %edi,%edi
  6fd250:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  6fd255:	74 3c                	je     6fd293 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18c3>
  6fd257:	41 80 be 1f 08 00 00 	cmpb   $0x1,0x81f(%r14)
  6fd25e:	01 
  6fd25f:	75 32                	jne    6fd293 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18c3>
  6fd261:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fd266:	4c 89 f6             	mov    %r14,%rsi
  6fd269:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fd270:	00 
  6fd271:	31 c9                	xor    %ecx,%ecx
  6fd273:	e8 98 d7 ff ff       	call   6faa10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  6fd278:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fd27d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd281:	75 1e                	jne    6fd2a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18d1>
  6fd283:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd28a:	ff ff 
  6fd28c:	31 ff                	xor    %edi,%edi
  6fd28e:	e9 94 02 00 00       	jmp    6fd527 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd293:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd29a:	ff ff 
  6fd29c:	e9 86 02 00 00       	jmp    6fd527 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd2a1:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fd2a6:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  6fd2ab:	c1 e1 10             	shl    $0x10,%ecx
  6fd2ae:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  6fd2b3:	09 ca                	or     %ecx,%edx
  6fd2b5:	48 c1 e2 20          	shl    $0x20,%rdx
  6fd2b9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd2bd:	48 09 d5             	or     %rdx,%rbp
  6fd2c0:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fd2c7:	00 
  6fd2c8:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd2cf:	00 
  6fd2d0:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fd2d7:	00 00 
  6fd2d9:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  6fd2e0:	00 00 
  6fd2e2:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  6fd2e9:	00 
  6fd2ea:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  6fd2f1:	00 
  6fd2f2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd2f7:	e9 2b 02 00 00       	jmp    6fd527 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd2fc:	b8 20 00 00 00       	mov    $0x20,%eax
  6fd301:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd306:	40 b7 0c             	mov    $0xc,%dil
  6fd309:	31 ed                	xor    %ebp,%ebp
  6fd30b:	4d 89 f8             	mov    %r15,%r8
  6fd30e:	e9 bd 01 00 00       	jmp    6fd4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd313:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  6fd31a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  6fd31e:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  6fd325:	40 0f 94 c5          	sete   %bpl
  6fd329:	48 ff c0             	inc    %rax
  6fd32c:	0f 84 d5 f0 ff ff    	je     6fc407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa37>
  6fd332:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  6fd339:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fd340:	00 
  6fd341:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  6fd348:	00 
  6fd349:	ff 15 61 c2 42 00    	call   *0x42c261(%rip)        # b295b0 <_DYNAMIC+0x440>
  6fd34f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  6fd356:	00 
  6fd357:	74 21                	je     6fd37a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19aa>
  6fd359:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  6fd360:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  6fd367:	40 84 ed             	test   %bpl,%bpl
  6fd36a:	0f 84 48 01 00 00    	je     6fd4b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae8>
  6fd370:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  6fd377:	00 
  6fd378:	eb 16                	jmp    6fd390 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19c0>
  6fd37a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fd381:	00 00 00 00 
  6fd385:	31 d2                	xor    %edx,%edx
  6fd387:	40 84 ed             	test   %bpl,%bpl
  6fd38a:	0f 84 28 01 00 00    	je     6fd4b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae8>
  6fd390:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fd395:	4c 89 f6             	mov    %r14,%rsi
  6fd398:	e8 f3 37 00 00       	call   700b90 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::finish_color_slot>
  6fd39d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fd3a2:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fd3a7:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd3ab:	0f 85 8c 00 00 00    	jne    6fd43d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a6d>
  6fd3b1:	40 f6 c7 01          	test   $0x1,%dil
  6fd3b5:	0f 84 f6 00 00 00    	je     6fd4b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae1>
  6fd3bb:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd3c2:	ff ff 
  6fd3c4:	40 b7 02             	mov    $0x2,%dil
  6fd3c7:	e9 04 01 00 00       	jmp    6fd4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd3cc:	31 ff                	xor    %edi,%edi
  6fd3ce:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd3d3:	e9 12 fe ff ff       	jmp    6fd1ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd3d8:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd3dd:	e9 25 01 00 00       	jmp    6fd507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fd3e2:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fd3e9:	00 
  6fd3ea:	34 01                	xor    $0x1,%al
  6fd3ec:	0f b6 c0             	movzbl %al,%eax
  6fd3ef:	31 ff                	xor    %edi,%edi
  6fd3f1:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  6fd3f8:	01 
  6fd3f9:	0f 45 f8             	cmovne %eax,%edi
  6fd3fc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd401:	48 85 c0             	test   %rax,%rax
  6fd404:	0f 84 e0 fd ff ff    	je     6fd1ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd40a:	f6 00 01             	testb  $0x1,(%rax)
  6fd40d:	0f 85 d7 fd ff ff    	jne    6fd1ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd413:	89 fd                	mov    %edi,%ebp
  6fd415:	48 8b 40 08          	mov    0x8(%rax),%rax
  6fd419:	a8 01                	test   $0x1,%al
  6fd41b:	75 14                	jne    6fd431 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a61>
  6fd41d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd422:	48 83 c0 08          	add    $0x8,%rax
  6fd426:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fd42b:	0f 84 b5 03 00 00    	je     6fd7e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e16>
  6fd431:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd436:	89 ef                	mov    %ebp,%edi
  6fd438:	e9 ad fd ff ff       	jmp    6fd1ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd43d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd442:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6fd447:	c1 e0 10             	shl    $0x10,%eax
  6fd44a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6fd44f:	09 c1                	or     %eax,%ecx
  6fd451:	48 c1 e1 20          	shl    $0x20,%rcx
  6fd455:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd459:	48 09 cd             	or     %rcx,%rbp
  6fd45c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fd463:	00 
  6fd464:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd46b:	00 
  6fd46c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fd473:	00 
  6fd474:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  6fd47b:	00 
  6fd47c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fd483:	00 
  6fd484:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6fd48b:	00 
  6fd48c:	eb 42                	jmp    6fd4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd48e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd495:	00 
  6fd496:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd49d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd4a4:	00 
  6fd4a5:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd4a9:	48 09 c5             	or     %rax,%rbp
  6fd4ac:	e9 85 01 00 00       	jmp    6fd636 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c66>
  6fd4b1:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  6fd4b8:	48 85 d2             	test   %rdx,%rdx
  6fd4bb:	0f 95 c0             	setne  %al
  6fd4be:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  6fd4c5:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd4cc:	ff ff 
  6fd4ce:	31 ff                	xor    %edi,%edi
  6fd4d0:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6fd4d5:	48 85 f6             	test   %rsi,%rsi
  6fd4d8:	7e 22                	jle    6fd4fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b2c>
  6fd4da:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd4df:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fd4e4:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd4e8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd4ed:	ff 15 c5 be 42 00    	call   *0x42bec5(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fd4f3:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd4f7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd4fc:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  6fd501:	0f 84 49 fd ff ff    	je     6fd250 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd507:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  6fd50e:	00 
  6fd50f:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  6fd516:	00 
  6fd517:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  6fd51e:	00 
  6fd51f:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  6fd526:	00 
  6fd527:	40 0f b6 c7          	movzbl %dil,%eax
  6fd52b:	48 c1 e5 08          	shl    $0x8,%rbp
  6fd52f:	48 09 c5             	or     %rax,%rbp
  6fd532:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  6fd539:	00 
  6fd53a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fd541:	00 
  6fd542:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  6fd549:	00 00 
  6fd54b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  6fd552:	00 00 
  6fd554:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fd559:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  6fd560:	00 
  6fd561:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  6fd568:	00 
  6fd569:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  6fd570:	00 
  6fd571:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  6fd578:	00 
  6fd579:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  6fd580:	00 00 
  6fd582:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6fd589:	00 
  6fd58a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  6fd591:	00 
  6fd592:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  6fd599:	00 
  6fd59a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  6fd5a1:	00 
  6fd5a2:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  6fd5a9:	00 
  6fd5aa:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fd5b1:	00 
  6fd5b2:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  6fd5b9:	00 
  6fd5ba:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  6fd5c1:	00 
  6fd5c2:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  6fd5c9:	00 
  6fd5ca:	31 ed                	xor    %ebp,%ebp
  6fd5cc:	e9 41 e6 ff ff       	jmp    6fbc12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x242>
  6fd5d1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd5d6:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6fd5db:	c1 e0 10             	shl    $0x10,%eax
  6fd5de:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6fd5e3:	09 c1                	or     %eax,%ecx
  6fd5e5:	48 c1 e1 20          	shl    $0x20,%rcx
  6fd5e9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd5ed:	48 09 cd             	or     %rcx,%rbp
  6fd5f0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  6fd5f7:	00 
  6fd5f8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fd5fd:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd604:	00 
  6fd605:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fd60c:	00 00 
  6fd60e:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  6fd615:	00 00 
  6fd617:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fd61e:	00 
  6fd61f:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6fd626:	00 
  6fd627:	eb 17                	jmp    6fd640 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c70>
  6fd629:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  6fd630:	00 00 00 
  6fd633:	48 21 c5             	and    %rax,%rbp
  6fd636:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd63b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd640:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fd645:	48 85 c9             	test   %rcx,%rcx
  6fd648:	0f 84 65 fb ff ff    	je     6fd1b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd64e:	f6 01 01             	testb  $0x1,(%rcx)
  6fd651:	0f 85 5c fb ff ff    	jne    6fd1b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd657:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fd65b:	a8 01                	test   $0x1,%al
  6fd65d:	0f 85 50 fb ff ff    	jne    6fd1b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd663:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd667:	48 8d 41 08          	lea    0x8(%rcx),%rax
  6fd66b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fd670:	0f 84 53 01 00 00    	je     6fd7c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1df9>
  6fd676:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd67b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd67f:	e9 34 fb ff ff       	jmp    6fd1b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e8>
  6fd684:	48 8d 3d 3d d7 3f 00 	lea    0x3fd73d(%rip),%rdi        # afadc8 <__frame_dummy_init_array_entry+0x4c0>
  6fd68b:	ff 15 e7 bd 42 00    	call   *0x42bde7(%rip)        # b29478 <_DYNAMIC+0x308>
  6fd691:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd695:	ff 15 55 bd 42 00    	call   *0x42bd55(%rip)        # b293f0 <_DYNAMIC+0x280>
  6fd69b:	e9 c0 e6 ff ff       	jmp    6fbd60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fd6a0:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  6fd6a6:	eb 3c                	jmp    6fd6e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d14>
  6fd6a8:	48 8d 05 05 d1 96 ff 	lea    -0x692efb(%rip),%rax        # 6a7b4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6fd6af:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6fd6b6:	00 
  6fd6b7:	48 8d 05 72 df 3f 00 	lea    0x3fdf72(%rip),%rax        # afb630 <__frame_dummy_init_array_entry+0xd28>
  6fd6be:	eb 1c                	jmp    6fd6dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d0c>
  6fd6c0:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  6fd6c6:	48 8d 05 d3 d0 96 ff 	lea    -0x692f2d(%rip),%rax        # 6a7a0 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b3>
  6fd6cd:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6fd6d4:	00 
  6fd6d5:	48 8d 05 3c df 3f 00 	lea    0x3fdf3c(%rip),%rax        # afb618 <__frame_dummy_init_array_entry+0xd10>
  6fd6dc:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  6fd6e3:	00 
  6fd6e4:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  6fd6eb:	00 
  6fd6ec:	4c 89 e6             	mov    %r12,%rsi
  6fd6ef:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fd6f6:	00 
  6fd6f7:	ff 15 bb bd 42 00    	call   *0x42bdbb(%rip)        # b294b8 <_DYNAMIC+0x348>
  6fd6fd:	e9 a7 01 00 00       	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd702:	48 8d 3d 6f d0 96 ff 	lea    -0x692f91(%rip),%rdi        # 6a778 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348b>
  6fd709:	48 8d 15 a8 de 3f 00 	lea    0x3fdea8(%rip),%rdx        # afb5b8 <__frame_dummy_init_array_entry+0xcb0>
  6fd710:	be 13 00 00 00       	mov    $0x13,%esi
  6fd715:	ff 15 9d bd 42 00    	call   *0x42bd9d(%rip)        # b294b8 <_DYNAMIC+0x348>
  6fd71b:	e9 89 01 00 00       	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd720:	48 8d 3d ce d0 96 ff 	lea    -0x692f32(%rip),%rdi        # 6a7f5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3508>
  6fd727:	48 8d 15 62 df 3f 00 	lea    0x3fdf62(%rip),%rdx        # afb690 <__frame_dummy_init_array_entry+0xd88>
  6fd72e:	be 93 00 00 00       	mov    $0x93,%esi
  6fd733:	ff 15 7f be 42 00    	call   *0x42be7f(%rip)        # b295b8 <_DYNAMIC+0x448>
  6fd739:	e9 6b 01 00 00       	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd73e:	48 8d 05 9a d0 96 ff 	lea    -0x692f66(%rip),%rax        # 6a7df <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34f2>
  6fd745:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  6fd74c:	00 
  6fd74d:	48 8d 05 f4 de 3f 00 	lea    0x3fdef4(%rip),%rax        # afb648 <__frame_dummy_init_array_entry+0xd40>
  6fd754:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  6fd75b:	00 
  6fd75c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  6fd763:	00 
  6fd764:	4c 89 ee             	mov    %r13,%rsi
  6fd767:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  6fd76e:	00 
  6fd76f:	ff 15 43 bd 42 00    	call   *0x42bd43(%rip)        # b294b8 <_DYNAMIC+0x348>
  6fd775:	e9 2f 01 00 00       	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd77a:	48 8d 3d 07 d3 3f 00 	lea    0x3fd307(%rip),%rdi        # afaa88 <__frame_dummy_init_array_entry+0x180>
  6fd781:	ff 15 f1 bc 42 00    	call   *0x42bcf1(%rip)        # b29478 <_DYNAMIC+0x308>
  6fd787:	e9 1d 01 00 00       	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd78c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd793:	00 00 
  6fd795:	48 8d 3d c4 de 3f 00 	lea    0x3fdec4(%rip),%rdi        # afb660 <__frame_dummy_init_array_entry+0xd58>
  6fd79c:	ff 15 d6 bc 42 00    	call   *0x42bcd6(%rip)        # b29478 <_DYNAMIC+0x308>
  6fd7a2:	e9 02 01 00 00       	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd7a7:	48 8d 05 aa d2 3f 00 	lea    0x3fd2aa(%rip),%rax        # afaa58 <__frame_dummy_init_array_entry+0x150>
  6fd7ae:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  6fd7b5:	00 
  6fd7b6:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  6fd7bd:	00 
  6fd7be:	ff 15 b4 bc 42 00    	call   *0x42bcb4(%rip)        # b29478 <_DYNAMIC+0x308>
  6fd7c4:	e9 e0 00 00 00       	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd7c9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd7ce:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd7d2:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd7d7:	ff 15 13 bc 42 00    	call   *0x42bc13(%rip)        # b293f0 <_DYNAMIC+0x280>
  6fd7dd:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd7e1:	e9 d2 f9 ff ff       	jmp    6fd1b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e8>
  6fd7e6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd7eb:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd7ef:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd7f4:	ff 15 f6 bb 42 00    	call   *0x42bbf6(%rip)        # b293f0 <_DYNAMIC+0x280>
  6fd7fa:	89 ef                	mov    %ebp,%edi
  6fd7fc:	e9 e9 f9 ff ff       	jmp    6fd1ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd801:	48 8d 15 68 d2 3f 00 	lea    0x3fd268(%rip),%rdx        # afaa70 <__frame_dummy_init_array_entry+0x168>
  6fd808:	ff 15 ba bc 42 00    	call   *0x42bcba(%rip)        # b294c8 <_DYNAMIC+0x358>
  6fd80e:	e9 96 00 00 00       	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd813:	48 8d 05 f6 d5 3f 00 	lea    0x3fd5f6(%rip),%rax        # afae10 <__frame_dummy_init_array_entry+0x508>
  6fd81a:	eb 47                	jmp    6fd863 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd81c:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd821:	48 8d 05 00 d6 3f 00 	lea    0x3fd600(%rip),%rax        # afae28 <__frame_dummy_init_array_entry+0x520>
  6fd828:	eb 39                	jmp    6fd863 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd82a:	48 8d 05 c7 d5 3f 00 	lea    0x3fd5c7(%rip),%rax        # afadf8 <__frame_dummy_init_array_entry+0x4f0>
  6fd831:	eb 30                	jmp    6fd863 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd833:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd838:	48 8d 05 31 d2 3f 00 	lea    0x3fd231(%rip),%rax        # afaa70 <__frame_dummy_init_array_entry+0x168>
  6fd83f:	eb 22                	jmp    6fd863 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd841:	48 85 ff             	test   %rdi,%rdi
  6fd844:	75 34                	jne    6fd87a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1eaa>
  6fd846:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd84d:	00 00 
  6fd84f:	ff 15 6b bd 42 00    	call   *0x42bd6b(%rip)        # b295c0 <_DYNAMIC+0x450>
  6fd855:	eb 52                	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd857:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd85c:	48 8d 05 dd d1 3f 00 	lea    0x3fd1dd(%rip),%rax        # afaa40 <__frame_dummy_init_array_entry+0x138>
  6fd863:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  6fd868:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd86d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  6fd872:	ff 15 50 bc 42 00    	call   *0x42bc50(%rip)        # b294c8 <_DYNAMIC+0x358>
  6fd878:	eb 2f                	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd87a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  6fd87f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd886:	00 00 
  6fd888:	ff 15 52 bb 42 00    	call   *0x42bb52(%rip)        # b293e0 <_DYNAMIC+0x270>
  6fd88e:	eb 19                	jmp    6fd8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd890:	48 8d 3d f4 ce 96 ff 	lea    -0x69310c(%rip),%rdi        # 6a78b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6fd897:	48 8d 15 32 dd 3f 00 	lea    0x3fdd32(%rip),%rdx        # afb5d0 <__frame_dummy_init_array_entry+0xcc8>
  6fd89e:	be 15 00 00 00       	mov    $0x15,%esi
  6fd8a3:	ff 15 0f bc 42 00    	call   *0x42bc0f(%rip)        # b294b8 <_DYNAMIC+0x348>
  6fd8a9:	0f 0b                	ud2
  6fd8ab:	49 89 c5             	mov    %rax,%r13
  6fd8ae:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd8b3:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fd8b7:	eb 6d                	jmp    6fd926 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd8b9:	49 89 c5             	mov    %rax,%r13
  6fd8bc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd8c1:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fd8c5:	eb 5f                	jmp    6fd926 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd8c7:	49 89 c5             	mov    %rax,%r13
  6fd8ca:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fd8ce:	eb 56                	jmp    6fd926 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd8d0:	48 89 c3             	mov    %rax,%rbx
  6fd8d3:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fd8da:	00 
  6fd8db:	e8 10 a7 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fd8e0:	48 89 df             	mov    %rbx,%rdi
  6fd8e3:	e8 68 bc 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fd8e8:	eb 18                	jmp    6fd902 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f32>
  6fd8ea:	eb 16                	jmp    6fd902 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f32>
  6fd8ec:	eb 00                	jmp    6fd8ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f1e>
  6fd8ee:	49 89 c5             	mov    %rax,%r13
  6fd8f1:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fd8f8:	ff 
  6fd8f9:	eb 2b                	jmp    6fd926 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd8fb:	49 89 c5             	mov    %rax,%r13
  6fd8fe:	eb 4d                	jmp    6fd94d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd900:	eb 21                	jmp    6fd923 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f53>
  6fd902:	49 89 c5             	mov    %rax,%r13
  6fd905:	eb 29                	jmp    6fd930 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f60>
  6fd907:	49 89 c5             	mov    %rax,%r13
  6fd90a:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  6fd910:	7e 3b                	jle    6fd94d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd912:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd917:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd91c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6fd921:	eb 24                	jmp    6fd947 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f77>
  6fd923:	49 89 c5             	mov    %rax,%r13
  6fd926:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd92b:	e8 10 70 ff ff       	call   6f4940 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  6fd930:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  6fd936:	7e 15                	jle    6fd94d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd938:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd93d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd942:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd947:	ff 15 6b ba 42 00    	call   *0x42ba6b(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fd94d:	4c 89 ef             	mov    %r13,%rdi
  6fd950:	ff 15 82 bb 42 00    	call   *0x42bb82(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fd956:	49 89 c5             	mov    %rax,%r13
  6fd959:	48 89 d5             	mov    %rdx,%rbp
  6fd95c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  6fd963:	00 
  6fd964:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  6fd96b:	00 
  6fd96c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  6fd973:	00 fd ff ff ff 
  6fd978:	4c 89 f7             	mov    %r14,%rdi
  6fd97b:	e8 90 d1 01 00       	call   71ab10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fd980:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  6fd987:	00 0f 00 00 00 
  6fd98c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6fd990:	48 85 c0             	test   %rax,%rax
  6fd993:	74 05                	je     6fd99a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fca>
  6fd995:	4c 89 ef             	mov    %r13,%rdi
  6fd998:	ff d0                	call   *%rax
  6fd99a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6fd99e:	48 85 f6             	test   %rsi,%rsi
  6fd9a1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd9a6:	74 0d                	je     6fd9b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fe5>
  6fd9a8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6fd9ac:	4c 89 ef             	mov    %r13,%rdi
  6fd9af:	ff 15 03 ba 42 00    	call   *0x42ba03(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fd9b5:	31 ed                	xor    %ebp,%ebp
  6fd9b7:	e9 56 e2 ff ff       	jmp    6fbc12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x242>
  6fd9bc:	48 89 c3             	mov    %rax,%rbx
  6fd9bf:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6fd9c3:	48 85 f6             	test   %rsi,%rsi
  6fd9c6:	74 2b                	je     6fd9f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2023>
  6fd9c8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6fd9cc:	4c 89 ef             	mov    %r13,%rdi
  6fd9cf:	ff 15 e3 b9 42 00    	call   *0x42b9e3(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fd9d5:	48 89 df             	mov    %rbx,%rdi
  6fd9d8:	e8 73 bb 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fd9dd:	ff 15 05 ba 42 00    	call   *0x42ba05(%rip)        # b293e8 <_DYNAMIC+0x278>
  6fd9e3:	48 89 c3             	mov    %rax,%rbx
  6fd9e6:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fd9ed:	00 
  6fd9ee:	e8 1d 74 ff ff       	call   6f4e10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fd9f3:	48 89 df             	mov    %rbx,%rdi
  6fd9f6:	e8 55 bb 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fd9fb:	ff 15 e7 b9 42 00    	call   *0x42b9e7(%rip)        # b293e8 <_DYNAMIC+0x278>
  6fda01:	ff 15 d9 ba 42 00    	call   *0x42bad9(%rip)        # b294e0 <_DYNAMIC+0x370>
