
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fb990 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>:
  6fb990:	55                   	push   %rbp
  6fb991:	41 57                	push   %r15
  6fb993:	41 56                	push   %r14
  6fb995:	41 55                	push   %r13
  6fb997:	41 54                	push   %r12
  6fb999:	53                   	push   %rbx
  6fb99a:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  6fb9a1:	4d 89 c4             	mov    %r8,%r12
  6fb9a4:	49 89 cf             	mov    %rcx,%r15
  6fb9a7:	49 89 f6             	mov    %rsi,%r14
  6fb9aa:	48 89 fb             	mov    %rdi,%rbx
  6fb9ad:	41 83 38 02          	cmpl   $0x2,(%r8)
  6fb9b1:	75 08                	jne    6fb9bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2b>
  6fb9b3:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fb9ba:	01 
  6fb9bb:	4d 85 ff             	test   %r15,%r15
  6fb9be:	0f 84 94 01 00 00    	je     6fbb58 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c8>
  6fb9c4:	41 80 be 1e 08 00 00 	cmpb   $0x1,0x81e(%r14)
  6fb9cb:	01 
  6fb9cc:	0f 85 86 01 00 00    	jne    6fbb58 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c8>
  6fb9d2:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  6fb9d9:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  6fb9e0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fb9e4:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  6fb9e9:	48 0f 44 ce          	cmove  %rsi,%rcx
  6fb9ed:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  6fb9f1:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  6fb9f8:	00 00 
  6fb9fa:	74 45                	je     6fba41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb1>
  6fb9fc:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  6fba03:	00 00 
  6fba05:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  6fba0c:	00 00 
  6fba0e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fba15:	00 
  6fba16:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  6fba1d:	00 
  6fba1e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6fba25:	00 
  6fba26:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  6fba2a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  6fba2e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fba35:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fba39:	88 4b 10             	mov    %cl,0x10(%rbx)
  6fba3c:	e9 5e 03 00 00       	jmp    6fbd9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fba41:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  6fba46:	41 83 ff 01          	cmp    $0x1,%r15d
  6fba4a:	0f 85 80 00 00 00    	jne    6fbad0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x140>
  6fba50:	48 89 d5             	mov    %rdx,%rbp
  6fba53:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  6fba5a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  6fba61:	49 c1 e4 04          	shl    $0x4,%r12
  6fba65:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6fba6c:	00 00 00 00 
  6fba70:	4d 85 e4             	test   %r12,%r12
  6fba73:	0f 84 7a 03 00 00    	je     6fbdf3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x463>
  6fba79:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  6fba7d:	48 8b 39             	mov    (%rcx),%rdi
  6fba80:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fba84:	ff 50 18             	call   *0x18(%rax)
  6fba87:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  6fba8b:	4c 89 e9             	mov    %r13,%rcx
  6fba8e:	4c 39 f8             	cmp    %r15,%rax
  6fba91:	75 dd                	jne    6fba70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xe0>
  6fba93:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  6fba9a:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  6fbaa1:	48 c1 e0 03          	shl    $0x3,%rax
  6fbaa5:	31 f6                	xor    %esi,%esi
  6fbaa7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fbaac:	0f 1f 40 00          	nopl   0x0(%rax)
  6fbab0:	48 89 f2             	mov    %rsi,%rdx
  6fbab3:	48 39 f0             	cmp    %rsi,%rax
  6fbab6:	74 0a                	je     6fbac2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x132>
  6fbab8:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  6fbabc:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  6fbac0:	75 ee                	jne    6fbab0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x120>
  6fbac2:	48 39 d0             	cmp    %rdx,%rax
  6fbac5:	0f 95 c1             	setne  %cl
  6fbac8:	48 89 ea             	mov    %rbp,%rdx
  6fbacb:	e9 7f 00 00 00       	jmp    6fbb4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1bf>
  6fbad0:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fbad7:	00 
  6fbad8:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  6fbadf:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  6fbae6:	49 c1 e5 04          	shl    $0x4,%r13
  6fbaea:	31 ed                	xor    %ebp,%ebp
  6fbaec:	0f 1f 40 00          	nopl   0x0(%rax)
  6fbaf0:	49 39 ed             	cmp    %rbp,%r13
  6fbaf3:	0f 84 0e 03 00 00    	je     6fbe07 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x477>
  6fbaf9:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  6fbafd:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  6fbb02:	4c 89 fe             	mov    %r15,%rsi
  6fbb05:	ff 50 30             	call   *0x30(%rax)
  6fbb08:	48 83 c5 10          	add    $0x10,%rbp
  6fbb0c:	84 c0                	test   %al,%al
  6fbb0e:	74 e0                	je     6fbaf0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160>
  6fbb10:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  6fbb15:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  6fbb1a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  6fbb21:	00 
  6fbb22:	4c 89 fa             	mov    %r15,%rdx
  6fbb25:	ff 50 60             	call   *0x60(%rax)
  6fbb28:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  6fbb2f:	00 
  6fbb30:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fbb37:	00 
  6fbb38:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fbb3c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fbb41:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fbb48:	00 
  6fbb49:	0f 85 c7 fe ff ff    	jne    6fba16 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fbb4f:	f6 c1 01             	test   $0x1,%cl
  6fbb52:	0f 84 f4 02 00 00    	je     6fbe4c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x4bc>
  6fbb58:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  6fbb5f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fbb64:	4c 89 f6             	mov    %r14,%rsi
  6fbb67:	31 c9                	xor    %ecx,%ecx
  6fbb69:	e8 92 ee ff ff       	call   6faa00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  6fbb6e:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  6fbb73:	75 16                	jne    6fbb8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fb>
  6fbb75:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  6fbb7c:	00 
  6fbb7d:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  6fbb84:	00 fe ff ff ff 
  6fbb89:	eb 41                	jmp    6fbbcc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x23c>
  6fbb8b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fbb92:	00 
  6fbb93:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6fbb9a:	00 
  6fbb9b:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  6fbba1:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  6fbba8:	00 00 
  6fbbaa:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  6fbbb1:	00 
  6fbbb2:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  6fbbb9:	00 
  6fbbba:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  6fbbc1:	00 00 
  6fbbc3:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  6fbbca:	00 00 
  6fbbcc:	40 b5 01             	mov    $0x1,%bpl
  6fbbcf:	45 31 ff             	xor    %r15d,%r15d
  6fbbd2:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  6fbbd9:	00 fe 
  6fbbdb:	0f 85 ba 00 00 00    	jne    6fbc9b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x30b>
  6fbbe1:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fbbe8:	00 
  6fbbe9:	4c 89 f6             	mov    %r14,%rsi
  6fbbec:	4c 89 e2             	mov    %r12,%rdx
  6fbbef:	e8 6c 5e 00 00       	call   701a60 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::reconcile_editing>
  6fbbf4:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fbbfb:	00 
  6fbbfc:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  6fbc03:	00 00 
  6fbc05:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fbc09:	0f 85 61 01 00 00    	jne    6fbd70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x3e0>
  6fbc0f:	48 8d 35 62 c0 96 ff 	lea    -0x693f9e(%rip),%rsi        # 67c78 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x99b>
  6fbc16:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fbc1d:	00 
  6fbc1e:	e8 9d 07 03 00       	call   72c3c0 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fbc23:	84 c0                	test   %al,%al
  6fbc25:	74 26                	je     6fbc4d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2bd>
  6fbc27:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbc2e:	48 85 c0             	test   %rax,%rax
  6fbc31:	0f 84 7a 01 00 00    	je     6fbdb1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x421>
  6fbc37:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fbc3e:	00 
  6fbc3f:	0f 95 c0             	setne  %al
  6fbc42:	44 08 e0             	or     %r12b,%al
  6fbc45:	a8 01                	test   $0x1,%al
  6fbc47:	0f 84 6e 01 00 00    	je     6fbdbb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x42b>
  6fbc4d:	48 8d 35 5c c0 96 ff 	lea    -0x693fa4(%rip),%rsi        # 67cb0 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x9d3>
  6fbc54:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fbc5b:	00 
  6fbc5c:	e8 5f 07 03 00       	call   72c3c0 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fbc61:	84 c0                	test   %al,%al
  6fbc63:	74 26                	je     6fbc8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2fb>
  6fbc65:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbc6c:	48 85 c0             	test   %rax,%rax
  6fbc6f:	0f 84 a7 01 00 00    	je     6fbe1c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x48c>
  6fbc75:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fbc7c:	00 
  6fbc7d:	0f 95 c0             	setne  %al
  6fbc80:	44 08 e0             	or     %r12b,%al
  6fbc83:	a8 01                	test   $0x1,%al
  6fbc85:	0f 84 9b 01 00 00    	je     6fbe26 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x496>
  6fbc8b:	48 89 df             	mov    %rbx,%rdi
  6fbc8e:	4c 89 f6             	mov    %r14,%rsi
  6fbc91:	e8 ea ef 01 00       	call   71ac80 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  6fbc96:	e9 04 01 00 00       	jmp    6fbd9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbc9b:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  6fbca2:	00 
  6fbca3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fbcaa:	00 
  6fbcab:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  6fbcb2:	00 
  6fbcb3:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  6fbcba:	00 
  6fbcbb:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  6fbcc2:	00 
  6fbcc3:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  6fbcca:	00 
  6fbccb:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  6fbcd2:	00 
  6fbcd3:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  6fbcda:	00 
  6fbcdb:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbce2:	48 85 c0             	test   %rax,%rax
  6fbce5:	74 41                	je     6fbd28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbce7:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fbcee:	48 85 c0             	test   %rax,%rax
  6fbcf1:	74 35                	je     6fbd28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbcf3:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fbcf7:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  6fbcfb:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  6fbcff:	80 f9 02             	cmp    $0x2,%cl
  6fbd02:	74 24                	je     6fbd28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbd04:	f6 07 01             	testb  $0x1,(%rdi)
  6fbd07:	75 17                	jne    6fbd20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fbd09:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fbd0d:	a8 01                	test   $0x1,%al
  6fbd0f:	75 0f                	jne    6fbd20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fbd11:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fbd15:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fbd1a:	0f 84 31 19 00 00    	je     6fd651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cc1>
  6fbd20:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fbd27:	01 
  6fbd28:	41 c6 86 1e 08 00 00 	movb   $0x0,0x81e(%r14)
  6fbd2f:	00 
  6fbd30:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fbd37:	00 00 00 00 
  6fbd3b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6fbd42:	00 
  6fbd43:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fbd47:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  6fbd4e:	00 00 
  6fbd50:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  6fbd57:	00 00 
  6fbd59:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  6fbd60:	00 
  6fbd61:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fbd65:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  6fbd6a:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  6fbd6e:	eb 2f                	jmp    6fbd9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbd70:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  6fbd77:	00 00 
  6fbd79:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  6fbd80:	00 00 
  6fbd82:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6fbd89:	00 
  6fbd8a:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6fbd8e:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  6fbd93:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  6fbd98:	48 89 03             	mov    %rax,(%rbx)
  6fbd9b:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  6fbd9f:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  6fbda6:	5b                   	pop    %rbx
  6fbda7:	41 5c                	pop    %r12
  6fbda9:	41 5d                	pop    %r13
  6fbdab:	41 5e                	pop    %r14
  6fbdad:	41 5f                	pop    %r15
  6fbdaf:	5d                   	pop    %rbp
  6fbdb0:	c3                   	ret
  6fbdb1:	41 80 fc 01          	cmp    $0x1,%r12b
  6fbdb5:	0f 84 92 fe ff ff    	je     6fbc4d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2bd>
  6fbdbb:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  6fbdc2:	00 00 
  6fbdc4:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  6fbdcb:	00 
  6fbdcc:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fbdd3:	00 
  6fbdd4:	74 16                	je     6fbdec <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x45c>
  6fbdd6:	84 c0                	test   %al,%al
  6fbdd8:	0f 84 c7 00 00 00    	je     6fbea5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x515>
  6fbdde:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fbde5:	ff 
  6fbde6:	0f 85 b9 00 00 00    	jne    6fbea5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x515>
  6fbdec:	31 c9                	xor    %ecx,%ecx
  6fbdee:	e9 be 00 00 00       	jmp    6fbeb1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x521>
  6fbdf3:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fbdfa:	00 
  6fbdfb:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fbe00:	b1 01                	mov    $0x1,%cl
  6fbe02:	e9 0f fc ff ff       	jmp    6fba16 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fbe07:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fbe0e:	00 
  6fbe0f:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fbe14:	44 89 f9             	mov    %r15d,%ecx
  6fbe17:	e9 fa fb ff ff       	jmp    6fba16 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fbe1c:	41 80 fc 01          	cmp    $0x1,%r12b
  6fbe20:	0f 84 65 fe ff ff    	je     6fbc8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2fb>
  6fbe26:	40 84 ed             	test   %bpl,%bpl
  6fbe29:	0f 85 15 18 00 00    	jne    6fd644 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cb4>
  6fbe2f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  6fbe33:	4c 89 f6             	mov    %r14,%rsi
  6fbe36:	31 d2                	xor    %edx,%edx
  6fbe38:	4c 89 f9             	mov    %r15,%rcx
  6fbe3b:	e8 a0 78 00 00       	call   7036e0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::publish_metadata>
  6fbe40:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fbe47:	e9 53 ff ff ff       	jmp    6fbd9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbe4c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  6fbe53:	00 
  6fbe54:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  6fbe5b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  6fbe62:	48 85 c0             	test   %rax,%rax
  6fbe65:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fbe6c:	00 
  6fbe6d:	0f 84 90 02 00 00    	je     6fc103 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbe73:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  6fbe7a:	48 85 c9             	test   %rcx,%rcx
  6fbe7d:	0f 84 9c 00 00 00    	je     6fbf1f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x58f>
  6fbe83:	48 89 ca             	mov    %rcx,%rdx
  6fbe86:	48 83 e2 07          	and    $0x7,%rdx
  6fbe8a:	74 4c                	je     6fbed8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x548>
  6fbe8c:	31 f6                	xor    %esi,%esi
  6fbe8e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe95:	48 ff c6             	inc    %rsi
  6fbe98:	48 39 f2             	cmp    %rsi,%rdx
  6fbe9b:	75 f1                	jne    6fbe8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x4fe>
  6fbe9d:	48 89 ca             	mov    %rcx,%rdx
  6fbea0:	48 29 f2             	sub    %rsi,%rdx
  6fbea3:	eb 36                	jmp    6fbedb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x54b>
  6fbea5:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fbeac:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fbeb1:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fbeb8:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  6fbebc:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fbec0:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  6fbec5:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  6fbec9:	88 43 30             	mov    %al,0x30(%rbx)
  6fbecc:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fbed3:	e9 c7 fe ff ff       	jmp    6fbd9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbed8:	48 89 ca             	mov    %rcx,%rdx
  6fbedb:	48 83 f9 08          	cmp    $0x8,%rcx
  6fbedf:	72 3e                	jb     6fbf1f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x58f>
  6fbee1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbee8:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbeef:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbef6:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbefd:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf04:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf0b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf12:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbf19:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  6fbf1d:	75 c2                	jne    6fbee1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x551>
  6fbf1f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  6fbf26:	00 
  6fbf27:	0f 84 d6 01 00 00    	je     6fc103 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbf2d:	80 38 00             	cmpb   $0x0,(%rax)
  6fbf30:	0f 85 cd 01 00 00    	jne    6fc103 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbf36:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  6fbf3d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  6fbf44:	00 
  6fbf45:	e8 56 81 04 00       	call   7440a0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  6fbf4a:	48 85 c0             	test   %rax,%rax
  6fbf4d:	0f 84 b0 01 00 00    	je     6fc103 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbf53:	48 8b 48 10          	mov    0x10(%rax),%rcx
  6fbf57:	48 c1 e1 02          	shl    $0x2,%rcx
  6fbf5b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  6fbf5f:	ba 04 00 00 00       	mov    $0x4,%edx
  6fbf64:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  6fbf69:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fbf6e:	b8 00 00 00 00       	mov    $0x0,%eax
  6fbf73:	48 0f 45 c1          	cmovne %rcx,%rax
  6fbf77:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fbf7c:	48 85 c0             	test   %rax,%rax
  6fbf7f:	0f 84 7e 01 00 00    	je     6fc103 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbf85:	45 31 ed             	xor    %r13d,%r13d
  6fbf88:	48 8b 05 09 d5 42 00 	mov    0x42d509(%rip),%rax        # b29498 <_DYNAMIC+0x398>
  6fbf8f:	48 83 c0 20          	add    $0x20,%rax
  6fbf93:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fbf98:	48 8b 05 01 d5 42 00 	mov    0x42d501(%rip),%rax        # b294a0 <_DYNAMIC+0x3a0>
  6fbf9f:	48 83 c0 20          	add    $0x20,%rax
  6fbfa3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fbfa8:	48 8b 05 f9 d4 42 00 	mov    0x42d4f9(%rip),%rax        # b294a8 <_DYNAMIC+0x3a8>
  6fbfaf:	48 83 c0 20          	add    $0x20,%rax
  6fbfb3:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fbfb8:	48 8b 05 f1 d4 42 00 	mov    0x42d4f1(%rip),%rax        # b294b0 <_DYNAMIC+0x3b0>
  6fbfbf:	48 83 c0 20          	add    $0x20,%rax
  6fbfc3:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6fbfc8:	48 8b 05 e9 d4 42 00 	mov    0x42d4e9(%rip),%rax        # b294b8 <_DYNAMIC+0x3b8>
  6fbfcf:	48 83 c0 20          	add    $0x20,%rax
  6fbfd3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fbfd8:	48 8b 05 e1 d4 42 00 	mov    0x42d4e1(%rip),%rax        # b294c0 <_DYNAMIC+0x3c0>
  6fbfdf:	48 83 c0 20          	add    $0x20,%rax
  6fbfe3:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fbfea:	00 
  6fbfeb:	48 8b 05 d6 d4 42 00 	mov    0x42d4d6(%rip),%rax        # b294c8 <_DYNAMIC+0x3c8>
  6fbff2:	48 83 c0 20          	add    $0x20,%rax
  6fbff6:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fbffd:	00 
  6fbffe:	48 8b 05 cb d4 42 00 	mov    0x42d4cb(%rip),%rax        # b294d0 <_DYNAMIC+0x3d0>
  6fc005:	48 83 c0 20          	add    $0x20,%rax
  6fc009:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fc00e:	48 8b 05 c3 d4 42 00 	mov    0x42d4c3(%rip),%rax        # b294d8 <_DYNAMIC+0x3d8>
  6fc015:	48 83 c0 20          	add    $0x20,%rax
  6fc019:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  6fc020:	00 
  6fc021:	48 8b 05 b8 d4 42 00 	mov    0x42d4b8(%rip),%rax        # b294e0 <_DYNAMIC+0x3e0>
  6fc028:	48 83 c0 20          	add    $0x20,%rax
  6fc02c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fc031:	48 8b 05 b0 d4 42 00 	mov    0x42d4b0(%rip),%rax        # b294e8 <_DYNAMIC+0x3e8>
  6fc038:	48 83 c0 20          	add    $0x20,%rax
  6fc03c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6fc043:	00 
  6fc044:	48 8b 05 a5 d4 42 00 	mov    0x42d4a5(%rip),%rax        # b294f0 <_DYNAMIC+0x3f0>
  6fc04b:	48 83 c0 20          	add    $0x20,%rax
  6fc04f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fc054:	48 8b 05 9d d4 42 00 	mov    0x42d49d(%rip),%rax        # b294f8 <_DYNAMIC+0x3f8>
  6fc05b:	48 83 c0 20          	add    $0x20,%rax
  6fc05f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fc064:	48 8d 2d 55 f2 95 ff 	lea    -0x6a0dab(%rip),%rbp        # 5b2c0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1460>
  6fc06b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fc070:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  6fc074:	ff 15 86 d4 42 00    	call   *0x42d486(%rip)        # b29500 <_DYNAMIC+0x400>
  6fc07a:	0f b7 c0             	movzwl %ax,%eax
  6fc07d:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  6fc082:	48 01 e9             	add    %rbp,%rcx
  6fc085:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fc08a:	ff e1                	jmp    *%rcx
  6fc08c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fc091:	eb 57                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc093:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fc09a:	00 
  6fc09b:	eb 4d                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc09d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fc0a2:	eb 46                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0a4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fc0a9:	eb 3f                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0ab:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  6fc0b2:	00 
  6fc0b3:	eb 35                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0b5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fc0ba:	eb 2e                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0bc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fc0c3:	00 
  6fc0c4:	eb 24                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0c6:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6fc0cb:	eb 1d                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0cd:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fc0d2:	eb 16                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0d4:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fc0db:	00 
  6fc0dc:	eb 0c                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0de:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fc0e3:	eb 05                	jmp    6fc0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc0e5:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fc0ea:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  6fc0ee:	0f 85 03 11 00 00    	jne    6fd1f7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1867>
  6fc0f4:	49 83 c5 04          	add    $0x4,%r13
  6fc0f8:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  6fc0fd:	0f 85 68 ff ff ff    	jne    6fc06b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x6db>
  6fc103:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  6fc10a:	00 00 
  6fc10c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fc113:	48 85 ed             	test   %rbp,%rbp
  6fc116:	0f 84 f2 10 00 00    	je     6fd20e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x187e>
  6fc11c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fc123:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fc12a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  6fc131:	48 89 c7             	mov    %rax,%rdi
  6fc134:	48 89 e9             	mov    %rbp,%rcx
  6fc137:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  6fc13e:	00 
  6fc13f:	45 89 d3             	mov    %r10d,%r11d
  6fc142:	41 c1 e3 05          	shl    $0x5,%r11d
  6fc146:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  6fc14d:	45 31 c9             	xor    %r9d,%r9d
  6fc150:	4d 39 cb             	cmp    %r9,%r11
  6fc153:	74 28                	je     6fc17d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7ed>
  6fc155:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  6fc15c:	00 
  6fc15d:	41 0f 97 c4          	seta   %r12b
  6fc161:	41 80 dc 00          	sbb    $0x0,%r12b
  6fc165:	49 83 c1 20          	add    $0x20,%r9
  6fc169:	49 ff c0             	inc    %r8
  6fc16c:	41 80 fc 01          	cmp    $0x1,%r12b
  6fc170:	74 de                	je     6fc150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7c0>
  6fc172:	45 0f b6 d4          	movzbl %r12b,%r10d
  6fc176:	45 85 d2             	test   %r10d,%r10d
  6fc179:	75 05                	jne    6fc180 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7f0>
  6fc17b:	eb 1c                	jmp    6fc199 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x809>
  6fc17d:	4d 89 d0             	mov    %r10,%r8
  6fc180:	48 83 ef 01          	sub    $0x1,%rdi
  6fc184:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc189:	0f 82 92 00 00 00    	jb     6fc221 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x891>
  6fc18f:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  6fc196:	00 
  6fc197:	eb 9e                	jmp    6fc137 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7a7>
  6fc199:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  6fc19f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc1a4:	75 7b                	jne    6fc221 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x891>
  6fc1a6:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  6fc1ab:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc1b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  6fc1b9:	4c 8d 05 78 f3 3f 00 	lea    0x3ff378(%rip),%r8        # afb538 <__frame_dummy_init_array_entry+0xca0>
  6fc1c0:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc1c5:	4c 89 f9             	mov    %r15,%rcx
  6fc1c8:	45 31 c9             	xor    %r9d,%r9d
  6fc1cb:	e8 20 8e 05 00       	call   754ff0 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::freeze>
  6fc1d0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fc1d5:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  6fc1da:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fc1e1:	00 
  6fc1e2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fc1e6:	0f 85 e6 00 00 00    	jne    6fc2d2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x942>
  6fc1ec:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fc1f3:	00 
  6fc1f4:	48 89 cd             	mov    %rcx,%rbp
  6fc1f7:	48 c1 ed 08          	shr    $0x8,%rbp
  6fc1fb:	b8 20 00 00 00       	mov    $0x20,%eax
  6fc200:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc205:	89 cf                	mov    %ecx,%edi
  6fc207:	e9 bb 12 00 00       	jmp    6fd4c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fc20c:	48 89 f9             	mov    %rdi,%rcx
  6fc20f:	48 83 e8 01          	sub    $0x1,%rax
  6fc213:	0f 82 f5 0f 00 00    	jb     6fd20e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x187e>
  6fc219:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  6fc220:	00 
  6fc221:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  6fc228:	41 89 f8             	mov    %edi,%r8d
  6fc22b:	41 c1 e0 05          	shl    $0x5,%r8d
  6fc22f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  6fc236:	45 31 ed             	xor    %r13d,%r13d
  6fc239:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6fc240:	4d 39 e8             	cmp    %r13,%r8
  6fc243:	74 c7                	je     6fc20c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x87c>
  6fc245:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  6fc24c:	00 
  6fc24d:	41 0f 97 c1          	seta   %r9b
  6fc251:	41 80 d9 00          	sbb    $0x0,%r9b
  6fc255:	49 83 c5 20          	add    $0x20,%r13
  6fc259:	48 ff c1             	inc    %rcx
  6fc25c:	41 80 f9 01          	cmp    $0x1,%r9b
  6fc260:	74 de                	je     6fc240 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x8b0>
  6fc262:	41 0f b6 f9          	movzbl %r9b,%edi
  6fc266:	85 ff                	test   %edi,%edi
  6fc268:	75 a5                	jne    6fc20f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x87f>
  6fc26a:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  6fc26f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6fc273:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc278:	74 41                	je     6fc2bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x92b>
  6fc27a:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc27f:	48 85 c0             	test   %rax,%rax
  6fc282:	0f 84 46 01 00 00    	je     6fc3ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa3e>
  6fc288:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc28d:	48 ff c8             	dec    %rax
  6fc290:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  6fc297:	ff ff 3f 
  6fc29a:	48 21 c7             	and    %rax,%rdi
  6fc29d:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  6fc2a1:	45 89 c8             	mov    %r9d,%r8d
  6fc2a4:	41 83 e0 03          	and    $0x3,%r8d
  6fc2a8:	48 83 ff 03          	cmp    $0x3,%rdi
  6fc2ac:	0f 83 25 01 00 00    	jae    6fc3d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa47>
  6fc2b2:	31 c0                	xor    %eax,%eax
  6fc2b4:	31 ff                	xor    %edi,%edi
  6fc2b6:	e9 b0 01 00 00       	jmp    6fc46b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xadb>
  6fc2bb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc2c2:	4c 8d 05 6f f2 3f 00 	lea    0x3ff26f(%rip),%r8        # afb538 <__frame_dummy_init_array_entry+0xca0>
  6fc2c9:	31 c0                	xor    %eax,%eax
  6fc2cb:	31 ff                	xor    %edi,%edi
  6fc2cd:	e9 d4 01 00 00       	jmp    6fc4a6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb16>
  6fc2d2:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fc2d7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fc2dc:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fc2e3:	00 
  6fc2e4:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  6fc2eb:	00 
  6fc2ec:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fc2f3:	00 
  6fc2f4:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  6fc2fb:	00 
  6fc2fc:	41 83 fd 02          	cmp    $0x2,%r13d
  6fc300:	0f 84 bc 13 00 00    	je     6fd6c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d32>
  6fc306:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  6fc30b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  6fc312:	00 
  6fc313:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  6fc318:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  6fc31f:	00 
  6fc320:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  6fc327:	00 
  6fc328:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc32f:	00 
  6fc330:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fc335:	ba 06 00 00 00       	mov    $0x6,%edx
  6fc33a:	ff 15 c8 d1 42 00    	call   *0x42d1c8(%rip)        # b29508 <_DYNAMIC+0x408>
  6fc340:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  6fc347:	00 
  6fc348:	80 fa ff             	cmp    $0xff,%dl
  6fc34b:	0f 84 79 0e 00 00    	je     6fd1ca <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x183a>
  6fc351:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  6fc358:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  6fc35f:	00 
  6fc360:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  6fc367:	00 
  6fc368:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  6fc36f:	00 
  6fc370:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  6fc377:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  6fc37e:	80 fa 02             	cmp    $0x2,%dl
  6fc381:	0f 85 35 0f 00 00    	jne    6fd2bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x192c>
  6fc387:	89 ea                	mov    %ebp,%edx
  6fc389:	48 c1 e0 20          	shl    $0x20,%rax
  6fc38d:	48 09 c8             	or     %rcx,%rax
  6fc390:	48 c1 e8 08          	shr    $0x8,%rax
  6fc394:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  6fc39b:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  6fc3a2:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  6fc3a9:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  6fc3b0:	00 
  6fc3b1:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  6fc3b8:	00 
  6fc3b9:	41 80 be 1f 08 00 00 	cmpb   $0x0,0x81f(%r14)
  6fc3c0:	00 
  6fc3c1:	0f 84 0c 0f 00 00    	je     6fd2d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1943>
  6fc3c7:	31 ed                	xor    %ebp,%ebp
  6fc3c9:	e9 24 0f 00 00       	jmp    6fd2f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1962>
  6fc3ce:	31 ff                	xor    %edi,%edi
  6fc3d0:	31 c0                	xor    %eax,%eax
  6fc3d2:	e9 b5 00 00 00       	jmp    6fc48c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xafc>
  6fc3d7:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6fc3dc:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  6fc3e3:	00 00 80 
  6fc3e6:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6fc3ea:	49 21 c1             	and    %rax,%r9
  6fc3ed:	31 c0                	xor    %eax,%eax
  6fc3ef:	31 ff                	xor    %edi,%edi
  6fc3f1:	44 8b 11             	mov    (%rcx),%r10d
  6fc3f4:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  6fc3f8:	45 89 d4             	mov    %r10d,%r12d
  6fc3fb:	41 f7 d4             	not    %r12d
  6fc3fe:	41 f6 c4 03          	test   $0x3,%r12b
  6fc402:	41 0f 94 c4          	sete   %r12b
  6fc406:	45 89 c3             	mov    %r8d,%r11d
  6fc409:	41 f7 d3             	not    %r11d
  6fc40c:	41 f6 c3 03          	test   $0x3,%r11b
  6fc410:	41 0f 94 c3          	sete   %r11b
  6fc414:	45 08 e3             	or     %r12b,%r11b
  6fc417:	8b 51 08             	mov    0x8(%rcx),%edx
  6fc41a:	41 89 d4             	mov    %edx,%r12d
  6fc41d:	41 f7 d4             	not    %r12d
  6fc420:	41 f6 c4 03          	test   $0x3,%r12b
  6fc424:	41 0f 94 c4          	sete   %r12b
  6fc428:	8b 71 0c             	mov    0xc(%rcx),%esi
  6fc42b:	48 83 c1 10          	add    $0x10,%rcx
  6fc42f:	21 f2                	and    %esi,%edx
  6fc431:	f7 d6                	not    %esi
  6fc433:	40 f6 c6 03          	test   $0x3,%sil
  6fc437:	40 0f 94 c6          	sete   %sil
  6fc43b:	44 08 e6             	or     %r12b,%sil
  6fc43e:	44 08 de             	or     %r11b,%sil
  6fc441:	40 08 f7             	or     %sil,%dil
  6fc444:	45 21 c2             	and    %r8d,%r10d
  6fc447:	41 21 d2             	and    %edx,%r10d
  6fc44a:	41 f7 d2             	not    %r10d
  6fc44d:	41 f6 c2 03          	test   $0x3,%r10b
  6fc451:	0f 95 c2             	setne  %dl
  6fc454:	08 d0                	or     %dl,%al
  6fc456:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  6fc45a:	75 95                	jne    6fc3f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa61>
  6fc45c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6fc461:	4d 85 c0             	test   %r8,%r8
  6fc464:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc469:	74 21                	je     6fc48c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xafc>
  6fc46b:	45 31 c9             	xor    %r9d,%r9d
  6fc46e:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  6fc472:	83 e2 03             	and    $0x3,%edx
  6fc475:	83 fa 03             	cmp    $0x3,%edx
  6fc478:	0f 95 c2             	setne  %dl
  6fc47b:	40 0f 94 c6          	sete   %sil
  6fc47f:	40 08 f7             	or     %sil,%dil
  6fc482:	08 d0                	or     %dl,%al
  6fc484:	49 ff c1             	inc    %r9
  6fc487:	4d 39 c8             	cmp    %r9,%r8
  6fc48a:	75 e2                	jne    6fc46e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xade>
  6fc48c:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc493:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  6fc498:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fc49f:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fc4a6:	40 0f b6 cf          	movzbl %dil,%ecx
  6fc4aa:	83 e1 01             	and    $0x1,%ecx
  6fc4ad:	89 0c 24             	mov    %ecx,(%rsp)
  6fc4b0:	44 0f b6 c8          	movzbl %al,%r9d
  6fc4b4:	41 83 e1 01          	and    $0x1,%r9d
  6fc4b8:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc4bd:	4c 89 f9             	mov    %r15,%rcx
  6fc4c0:	e8 2b 8b 05 00       	call   754ff0 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::freeze>
  6fc4c5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  6fc4ca:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6fc4cf:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fc4d6:	00 
  6fc4d7:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6fc4de:	00 
  6fc4df:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fc4e4:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  6fc4e9:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  6fc4ed:	75 1d                	jne    6fc50c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb7c>
  6fc4ef:	48 89 c5             	mov    %rax,%rbp
  6fc4f2:	48 c1 ed 08          	shr    $0x8,%rbp
  6fc4f6:	b9 20 00 00 00       	mov    $0x20,%ecx
  6fc4fb:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc500:	89 c7                	mov    %eax,%edi
  6fc502:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  6fc507:	e9 bb 0f 00 00       	jmp    6fd4c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fc50c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fc511:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fc518:	00 
  6fc519:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6fc520:	00 
  6fc521:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fc528:	00 00 
  6fc52a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  6fc531:	00 00 
  6fc533:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  6fc539:	0f 84 69 0c 00 00    	je     6fd1a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1818>
  6fc53f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc544:	48 85 c0             	test   %rax,%rax
  6fc547:	0f 84 5b 0c 00 00    	je     6fd1a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1818>
  6fc54d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fc552:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc557:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc55c:	48 c1 e0 02          	shl    $0x2,%rax
  6fc560:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fc565:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6fc569:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  6fc570:	00 
  6fc571:	45 31 e4             	xor    %r12d,%r12d
  6fc574:	48 83 f8 02          	cmp    $0x2,%rax
  6fc578:	0f 85 72 0b 00 00    	jne    6fd0f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1760>
  6fc57e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fc583:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fc587:	ff 15 73 cf 42 00    	call   *0x42cf73(%rip)        # b29500 <_DYNAMIC+0x400>
  6fc58d:	66 85 c0             	test   %ax,%ax
  6fc590:	0f 85 ba 12 00 00    	jne    6fd850 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ec0>
  6fc596:	49 83 c4 04          	add    $0x4,%r12
  6fc59a:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fc59f:	75 dd                	jne    6fc57e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xbee>
  6fc5a1:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc5a6:	48 85 c0             	test   %rax,%rax
  6fc5a9:	0f 84 dd 0d 00 00    	je     6fd38c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19fc>
  6fc5af:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc5b4:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  6fc5bb:	00 
  6fc5bc:	48 c1 e0 02          	shl    $0x2,%rax
  6fc5c0:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  6fc5c6:	66 0f 6f 0d 82 e2 95 	movdqa -0x6a1d7e(%rip),%xmm1        # 5a850 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9f0>
  6fc5cd:	ff 
  6fc5ce:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  6fc5d2:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  6fc5d9:	00 00 
  6fc5db:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  6fc5e2:	00 00 00 00 00 
  6fc5e7:	48 8d 0d 8a ef 3f 00 	lea    0x3fef8a(%rip),%rcx        # afb578 <__frame_dummy_init_array_entry+0xce0>
  6fc5ee:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fc5f3:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  6fc5fa:	00 00 80 
  6fc5fd:	48 ff c1             	inc    %rcx
  6fc600:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  6fc607:	00 
  6fc608:	48 8d 0d 95 e1 96 ff 	lea    -0x691e6b(%rip),%rcx        # 6a7a4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6fc60f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6fc616:	00 
  6fc617:	48 8d 0d ea ef 3f 00 	lea    0x3fefea(%rip),%rcx        # afb608 <__frame_dummy_init_array_entry+0xd70>
  6fc61e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6fc625:	00 
  6fc626:	48 8d 0d 63 ef 3f 00 	lea    0x3fef63(%rip),%rcx        # afb590 <__frame_dummy_init_array_entry+0xcf8>
  6fc62d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  6fc634:	00 
  6fc635:	48 8d 0d 3f e1 96 ff 	lea    -0x691ec1(%rip),%rcx        # 6a77b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6fc63c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  6fc643:	00 
  6fc644:	48 8d 0d cd e3 3f 00 	lea    0x3fe3cd(%rip),%rcx        # afaa18 <__frame_dummy_init_array_entry+0x180>
  6fc64b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  6fc652:	00 
  6fc653:	31 c9                	xor    %ecx,%ecx
  6fc655:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  6fc65c:	00 00 00 00 00 
  6fc661:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  6fc668:	00 00 00 00 00 
  6fc66d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fc674:	00 00 
  6fc676:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fc67b:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fc682:	00 
  6fc683:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  6fc688:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  6fc68b:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  6fc692:	89 e8                	mov    %ebp,%eax
  6fc694:	c1 e8 0f             	shr    $0xf,%eax
  6fc697:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fc69e:	48 39 c6             	cmp    %rax,%rsi
  6fc6a1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fc6a6:	0f 86 7c 11 00 00    	jbe    6fd828 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e98>
  6fc6ac:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  6fc6b3:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  6fc6b7:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  6fc6bb:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fc6c0:	89 ef                	mov    %ebp,%edi
  6fc6c2:	ff 15 38 ce 42 00    	call   *0x42ce38(%rip)        # b29500 <_DYNAMIC+0x400>
  6fc6c8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  6fc6cc:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  6fc6d0:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fc6d7:	00 
  6fc6d8:	8b 54 24 08          	mov    0x8(%rsp),%edx
  6fc6dc:	66 85 d2             	test   %dx,%dx
  6fc6df:	0f 84 31 01 00 00    	je     6fc816 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xe86>
  6fc6e5:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  6fc6ec:	02 
  6fc6ed:	0f 84 6d 0f 00 00    	je     6fd660 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd0>
  6fc6f3:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6fc6f8:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6fc6fd:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6fc704:	00 
  6fc705:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fc70a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  6fc70e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fc715:	00 00 
  6fc717:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  6fc71b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc722:	00 
  6fc723:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fc728:	ff 15 da cd 42 00    	call   *0x42cdda(%rip)        # b29508 <_DYNAMIC+0x408>
  6fc72e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  6fc735:	00 
  6fc736:	3c ff                	cmp    $0xff,%al
  6fc738:	0f 84 10 0d 00 00    	je     6fd44e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1abe>
  6fc73e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  6fc745:	00 
  6fc746:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  6fc74d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  6fc754:	00 
  6fc755:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  6fc75c:	00 
  6fc75d:	41 8b 78 10          	mov    0x10(%r8),%edi
  6fc761:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  6fc768:	00 
  6fc769:	41 89 79 10          	mov    %edi,0x10(%r9)
  6fc76d:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  6fc772:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  6fc777:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  6fc77e:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  6fc785:	00 
  6fc786:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  6fc78d:	00 
  6fc78e:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  6fc795:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6fc799:	44 0f b7 e9          	movzwl %cx,%r13d
  6fc79d:	48 8d 05 94 f1 3f 00 	lea    0x3ff194(%rip),%rax        # afb938 <__frame_dummy_init_array_entry+0x10a0>
  6fc7a4:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fc7a9:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  6fc7ad:	0f 84 c7 00 00 00    	je     6fc87a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xeea>
  6fc7b3:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc7b8:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  6fc7bf:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fc7c4:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  6fc7cb:	00 
  6fc7cc:	ff 15 3e cd 42 00    	call   *0x42cd3e(%rip)        # b29510 <_DYNAMIC+0x410>
  6fc7d2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fc7d7:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fc7dc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fc7e0:	0f 85 ab 0d 00 00    	jne    6fd591 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c01>
  6fc7e6:	40 80 ff 01          	cmp    $0x1,%dil
  6fc7ea:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc7ef:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fc7f4:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fc7f9:	0f 85 9e 08 00 00    	jne    6fd09d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x170d>
  6fc7ff:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fc806:	01 
  6fc807:	b0 01                	mov    $0x1,%al
  6fc809:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fc810:	00 
  6fc811:	e9 4e 08 00 00       	jmp    6fd064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fc816:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  6fc81c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc821:	0f 84 59 0e 00 00    	je     6fd680 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cf0>
  6fc827:	83 e5 03             	and    $0x3,%ebp
  6fc82a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  6fc82d:	83 f8 02             	cmp    $0x2,%eax
  6fc830:	0f 83 8a 00 00 00    	jae    6fc8c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf30>
  6fc836:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fc83d:	48 8b 38             	mov    (%rax),%rdi
  6fc840:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  6fc846:	48 85 ff             	test   %rdi,%rdi
  6fc849:	0f 84 19 0e 00 00    	je     6fd668 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd8>
  6fc84f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fc854:	ff 15 be cc 42 00    	call   *0x42ccbe(%rip)        # b29518 <_DYNAMIC+0x418>
  6fc85a:	48 85 c0             	test   %rax,%rax
  6fc85d:	0f 84 05 0e 00 00    	je     6fd668 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd8>
  6fc863:	83 fd 01             	cmp    $0x1,%ebp
  6fc866:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc86b:	0f 85 a6 00 00 00    	jne    6fc917 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf87>
  6fc871:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fc875:	e9 a1 00 00 00       	jmp    6fc91b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf8b>
  6fc87a:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  6fc881:	48 8b 00             	mov    (%rax),%rax
  6fc884:	48 8d 15 6d ea 95 ff 	lea    -0x6a1593(%rip),%rdx        # 5b2f8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1498>
  6fc88b:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  6fc88f:	48 01 d1             	add    %rdx,%rcx
  6fc892:	48 8d 05 77 f2 95 ff 	lea    -0x6a0d89(%rip),%rax        # 5bb10 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  6fc899:	ff e1                	jmp    *%rcx
  6fc89b:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  6fc8a2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fc8a7:	48 39 c6             	cmp    %rax,%rsi
  6fc8aa:	0f 86 3a 0f 00 00    	jbe    6fd7ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e5a>
  6fc8b0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fc8b4:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  6fc8bb:	e9 4e 03 00 00       	jmp    6fcc0e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x127e>
  6fc8c0:	85 ed                	test   %ebp,%ebp
  6fc8c2:	0f 85 18 0e 00 00    	jne    6fd6e0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d50>
  6fc8c8:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fc8cf:	00 
  6fc8d0:	8b 40 20             	mov    0x20(%rax),%eax
  6fc8d3:	89 c1                	mov    %eax,%ecx
  6fc8d5:	83 e1 07             	and    $0x7,%ecx
  6fc8d8:	83 f9 06             	cmp    $0x6,%ecx
  6fc8db:	74 74                	je     6fc951 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc8dd:	c1 e8 03             	shr    $0x3,%eax
  6fc8e0:	74 6f                	je     6fc951 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc8e2:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fc8e9:	ff c8                	dec    %eax
  6fc8eb:	48 39 c6             	cmp    %rax,%rsi
  6fc8ee:	0f 86 23 0f 00 00    	jbe    6fd817 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e87>
  6fc8f4:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  6fc8fb:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fc8ff:	48 c1 e0 04          	shl    $0x4,%rax
  6fc903:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  6fc908:	0f 84 59 0e 00 00    	je     6fd767 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1dd7>
  6fc90e:	48 01 c1             	add    %rax,%rcx
  6fc911:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  6fc915:	eb 13                	jmp    6fc92a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf9a>
  6fc917:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fc91b:	b0 01                	mov    $0x1,%al
  6fc91d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  6fc924:	00 
  6fc925:	48 85 ff             	test   %rdi,%rdi
  6fc928:	74 27                	je     6fc951 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc92a:	48 8b 07             	mov    (%rdi),%rax
  6fc92d:	48 d1 e8             	shr    $1,%rax
  6fc930:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fc935:	48 39 d0             	cmp    %rdx,%rax
  6fc938:	75 17                	jne    6fc951 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc93a:	48 83 c7 10          	add    $0x10,%rdi
  6fc93e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fc943:	ff 15 d7 cb 42 00    	call   *0x42cbd7(%rip)        # b29520 <bcmp@GLIBC_2.2.5>
  6fc949:	85 c0                	test   %eax,%eax
  6fc94b:	0f 84 3a 06 00 00    	je     6fcf8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x15fb>
  6fc951:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  6fc956:	4d 85 e4             	test   %r12,%r12
  6fc959:	75 6d                	jne    6fc9c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1038>
  6fc95b:	4c 8d 25 1e e7 95 ff 	lea    -0x6a18e2(%rip),%r12        # 5b080 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1220>
  6fc962:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6fc967:	48 85 f6             	test   %rsi,%rsi
  6fc96a:	74 41                	je     6fc9ad <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x101d>
  6fc96c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fc973:	00 00 
  6fc975:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc97a:	31 d2                	xor    %edx,%edx
  6fc97c:	31 c9                	xor    %ecx,%ecx
  6fc97e:	ff 15 a4 cb 42 00    	call   *0x42cba4(%rip)        # b29528 <_DYNAMIC+0x428>
  6fc984:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6fc989:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  6fc98d:	0f 85 6e 0e 00 00    	jne    6fd801 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e71>
  6fc993:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  6fc998:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  6fc99d:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fc9a2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fc9a7:	ff 15 bb c9 42 00    	call   *0x42c9bb(%rip)        # b29368 <memcpy@GLIBC_2.14>
  6fc9ad:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  6fc9b4:	00 00 
  6fc9b6:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  6fc9bd:	00 00 
  6fc9bf:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  6fc9c6:	00 00 
  6fc9c8:	85 ed                	test   %ebp,%ebp
  6fc9ca:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  6fc9cf:	0f 84 b1 00 00 00    	je     6fca86 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10f6>
  6fc9d5:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fc9dc:	48 8b 38             	mov    (%rax),%rdi
  6fc9df:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  6fc9e5:	48 85 ff             	test   %rdi,%rdi
  6fc9e8:	0f 84 2e 0d 00 00    	je     6fd71c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d8c>
  6fc9ee:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fc9f3:	ff 15 37 cb 42 00    	call   *0x42cb37(%rip)        # b29530 <_DYNAMIC+0x430>
  6fc9f9:	48 85 c0             	test   %rax,%rax
  6fc9fc:	0f 84 1a 0d 00 00    	je     6fd71c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d8c>
  6fca02:	83 fd 01             	cmp    $0x1,%ebp
  6fca05:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fca0a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fca0f:	0f 85 4d 01 00 00    	jne    6fcb62 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11d2>
  6fca15:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fca1a:	48 85 c9             	test   %rcx,%rcx
  6fca1d:	74 2c                	je     6fca4b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fca1f:	f6 01 01             	testb  $0x1,(%rcx)
  6fca22:	75 27                	jne    6fca4b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fca24:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fca28:	f6 c2 01             	test   $0x1,%dl
  6fca2b:	75 1e                	jne    6fca4b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fca2d:	ba 02 00 00 00       	mov    $0x2,%edx
  6fca32:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fca38:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fca3f:	00 
  6fca40:	48 f7 da             	neg    %rdx
  6fca43:	71 06                	jno    6fca4b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fca45:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fca4b:	48 89 c5             	mov    %rax,%rbp
  6fca4e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fca52:	48 85 ff             	test   %rdi,%rdi
  6fca55:	74 1c                	je     6fca73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fca57:	f6 07 01             	testb  $0x1,(%rdi)
  6fca5a:	75 17                	jne    6fca73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fca5c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fca60:	a8 01                	test   $0x1,%al
  6fca62:	75 0f                	jne    6fca73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fca64:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fca68:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fca6d:	0f 84 50 06 00 00    	je     6fd0c3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1733>
  6fca73:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fca78:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fca7c:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fca81:	e9 de 05 00 00       	jmp    6fd064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fca86:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fca8d:	00 
  6fca8e:	8b 78 20             	mov    0x20(%rax),%edi
  6fca91:	89 f8                	mov    %edi,%eax
  6fca93:	83 e0 07             	and    $0x7,%eax
  6fca96:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  6fca9c:	83 f8 06             	cmp    $0x6,%eax
  6fca9f:	0f 84 59 0c 00 00    	je     6fd6fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d6e>
  6fcaa5:	c1 ef 03             	shr    $0x3,%edi
  6fcaa8:	0f 84 50 0c 00 00    	je     6fd6fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d6e>
  6fcaae:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fcab5:	ff cf                	dec    %edi
  6fcab7:	48 39 fe             	cmp    %rdi,%rsi
  6fcaba:	0f 86 01 0d 00 00    	jbe    6fd7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e31>
  6fcac0:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fcac7:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6fcacb:	48 c1 e0 04          	shl    $0x4,%rax
  6fcacf:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fcad5:	0f 84 5f 0c 00 00    	je     6fd73a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1daa>
  6fcadb:	4d 85 e4             	test   %r12,%r12
  6fcade:	0f 84 68 0c 00 00    	je     6fd74c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1dbc>
  6fcae4:	41 f6 04 24 01       	testb  $0x1,(%r12)
  6fcae9:	75 2a                	jne    6fcb15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fcaeb:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  6fcaf0:	f6 c1 01             	test   $0x1,%cl
  6fcaf3:	75 20                	jne    6fcb15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fcaf5:	b9 02 00 00 00       	mov    $0x2,%ecx
  6fcafa:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  6fcb01:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  6fcb08:	00 
  6fcb09:	48 f7 d9             	neg    %rcx
  6fcb0c:	71 07                	jno    6fcb15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fcb0e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  6fcb15:	48 01 c5             	add    %rax,%rbp
  6fcb18:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  6fcb1c:	f6 07 01             	testb  $0x1,(%rdi)
  6fcb1f:	75 17                	jne    6fcb38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fcb21:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcb25:	a8 01                	test   $0x1,%al
  6fcb27:	75 0f                	jne    6fcb38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fcb29:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fcb2d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fcb32:	0f 84 7c 05 00 00    	je     6fd0b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1724>
  6fcb38:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fcb3c:	48 89 ef             	mov    %rbp,%rdi
  6fcb3f:	e8 7c 7e ff ff       	call   6f49c0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fcb44:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fcb4b:	ff 
  6fcb4c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fcb53:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fcb58:	e8 b3 89 04 00       	call   745510 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fcb5d:	e9 e1 04 00 00       	jmp    6fd043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16b3>
  6fcb62:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fcb67:	48 85 c9             	test   %rcx,%rcx
  6fcb6a:	74 2c                	je     6fcb98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcb6c:	f6 01 01             	testb  $0x1,(%rcx)
  6fcb6f:	75 27                	jne    6fcb98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcb71:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fcb75:	f6 c2 01             	test   $0x1,%dl
  6fcb78:	75 1e                	jne    6fcb98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcb7a:	ba 02 00 00 00       	mov    $0x2,%edx
  6fcb7f:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fcb85:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fcb8c:	00 
  6fcb8d:	48 f7 da             	neg    %rdx
  6fcb90:	71 06                	jno    6fcb98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcb92:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fcb98:	48 89 c5             	mov    %rax,%rbp
  6fcb9b:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fcb9f:	48 85 ff             	test   %rdi,%rdi
  6fcba2:	74 1c                	je     6fcbc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcba4:	f6 07 01             	testb  $0x1,(%rdi)
  6fcba7:	75 17                	jne    6fcbc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcba9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcbad:	a8 01                	test   $0x1,%al
  6fcbaf:	75 0f                	jne    6fcbc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcbb1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fcbb5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fcbba:	0f 84 12 05 00 00    	je     6fd0d2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1742>
  6fcbc0:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fcbc5:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fcbc9:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fcbce:	e9 91 04 00 00       	jmp    6fd064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fcbd3:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  6fcbda:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6fcbdf:	48 39 ce             	cmp    %rcx,%rsi
  6fcbe2:	0f 86 eb 0b 00 00    	jbe    6fd7d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e43>
  6fcbe8:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  6fcbef:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  6fcbf6:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  6fcbfa:	48 39 c6             	cmp    %rax,%rsi
  6fcbfd:	0f 86 d9 0b 00 00    	jbe    6fd7dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e4c>
  6fcc03:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fcc07:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  6fcc0e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  6fcc12:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  6fcc19:	00 
  6fcc1a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  6fcc1e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  6fcc25:	00 
  6fcc26:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  6fcc2a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  6fcc2f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  6fcc33:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  6fcc37:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  6fcc3e:	00 
  6fcc3f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  6fcc46:	00 
  6fcc47:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  6fcc4e:	00 00 
  6fcc50:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  6fcc57:	00 00 
  6fcc59:	eb 1a                	jmp    6fcc75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x12e5>
  6fcc5b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  6fcc62:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  6fcc69:	00 
  6fcc6a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6fcc6f:	ff 15 c3 c7 42 00    	call   *0x42c7c3(%rip)        # b29438 <_DYNAMIC+0x338>
  6fcc75:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  6fcc7c:	00 
  6fcc7d:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  6fcc84:	00 
  6fcc85:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  6fcc8c:	00 
  6fcc8d:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  6fcc94:	00 
  6fcc95:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  6fcc9c:	00 00 
  6fcc9e:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  6fcca5:	00 00 
  6fcca7:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  6fccae:	00 
  6fccaf:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  6fccb6:	00 
  6fccb7:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  6fccbe:	00 
  6fccbf:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  6fccc6:	00 
  6fccc7:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  6fccce:	00 00 
  6fccd0:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  6fccd6:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fccdd:	00 
  6fccde:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  6fcce5:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fccea:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  6fccef:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6fccf4:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  6fccfb:	00 
  6fccfc:	e8 ff 1f 07 00       	call   76ed00 <<gpui::property::Overrides>::update_base>
  6fcd01:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  6fcd08:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  6fcd0f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  6fcd16:	00 
  6fcd17:	48 c1 e5 20          	shl    $0x20,%rbp
  6fcd1b:	48 09 cd             	or     %rcx,%rbp
  6fcd1e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  6fcd25:	00 
  6fcd26:	83 f8 02             	cmp    $0x2,%eax
  6fcd29:	0f 84 ba 08 00 00    	je     6fd5e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c59>
  6fcd2f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  6fcd36:	00 
  6fcd37:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  6fcd3b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  6fcd42:	00 
  6fcd43:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  6fcd47:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  6fcd4b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  6fcd4f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  6fcd53:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  6fcd57:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  6fcd5b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  6fcd5f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6fcd63:	0f 11 02             	movups %xmm0,(%rdx)
  6fcd66:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  6fcd6d:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  6fcd74:	00 
  6fcd75:	48 89 e8             	mov    %rbp,%rax
  6fcd78:	48 c1 e8 20          	shr    $0x20,%rax
  6fcd7c:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  6fcd83:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  6fcd8a:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  6fcd91:	00 00 
  6fcd93:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  6fcd9a:	00 00 
  6fcd9c:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  6fcda3:	00 
  6fcda4:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  6fcdab:	00 
  6fcdac:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  6fcdb3:	00 00 
  6fcdb5:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  6fcdbc:	00 00 
  6fcdbe:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  6fcdc5:	00 
  6fcdc6:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  6fcdcd:	00 
  6fcdce:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  6fcdd5:	00 
  6fcdd6:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  6fcddd:	00 
  6fcdde:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  6fcde5:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  6fcdec:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  6fcdf3:	00 
  6fcdf4:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  6fcdfb:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  6fce02:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  6fce09:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  6fce10:	00 
  6fce11:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  6fce18:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  6fce1f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  6fce26:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  6fce2d:	00 
  6fce2e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  6fce35:	00 
  6fce36:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  6fce3d:	00 
  6fce3e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  6fce45:	01 
  6fce46:	75 1a                	jne    6fce62 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x14d2>
  6fce48:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  6fce4f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  6fce56:	0f 94 c1             	sete   %cl
  6fce59:	84 c8                	test   %cl,%al
  6fce5b:	75 0d                	jne    6fce6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x14da>
  6fce5d:	e9 38 01 00 00       	jmp    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce62:	a8 01                	test   $0x1,%al
  6fce64:	0f 85 30 01 00 00    	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce6a:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  6fce71:	00 
  6fce72:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  6fce79:	01 
  6fce7a:	75 1b                	jne    6fce97 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1507>
  6fce7c:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  6fce83:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  6fce8a:	0f 94 c1             	sete   %cl
  6fce8d:	84 c8                	test   %cl,%al
  6fce8f:	0f 84 05 01 00 00    	je     6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce95:	eb 08                	jmp    6fce9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x150f>
  6fce97:	a8 01                	test   $0x1,%al
  6fce99:	0f 85 fb 00 00 00    	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce9f:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  6fcea6:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  6fcead:	0f 85 e7 00 00 00    	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fceb3:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  6fceba:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  6fcec1:	0f 85 d3 00 00 00    	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcec7:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  6fcece:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  6fced5:	0f 85 bf 00 00 00    	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcedb:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  6fcee2:	00 
  6fcee3:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  6fceea:	0f 85 aa 00 00 00    	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcef0:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  6fcef7:	00 
  6fcef8:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  6fceff:	0f 85 95 00 00 00    	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf05:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  6fcf0c:	00 
  6fcf0d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  6fcf14:	0f 85 80 00 00 00    	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf1a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  6fcf21:	00 
  6fcf22:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  6fcf29:	75 6f                	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf2b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  6fcf32:	00 
  6fcf33:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  6fcf3a:	00 
  6fcf3b:	e8 70 ef 02 00       	call   72beb0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  6fcf40:	84 c0                	test   %al,%al
  6fcf42:	74 56                	je     6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf44:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  6fcf4b:	00 00 
  6fcf4d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  6fcf54:	00 00 
  6fcf56:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fcf5a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fcf5e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fcf63:	75 35                	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf65:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  6fcf6c:	00 00 
  6fcf6e:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  6fcf75:	00 00 
  6fcf77:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fcf7b:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fcf7f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fcf84:	75 14                	jne    6fcf9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcf86:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fcf8b:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fcf90:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fcf95:	e9 08 01 00 00       	jmp    6fd0a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1712>
  6fcf9a:	48 8d 05 97 e9 3f 00 	lea    0x3fe997(%rip),%rax        # afb938 <__frame_dummy_init_array_entry+0x10a0>
  6fcfa1:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fcfa6:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  6fcfaa:	75 11                	jne    6fcfbd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x162d>
  6fcfac:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fcfb3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fcfb8:	e8 53 85 04 00       	call   745510 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fcfbd:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  6fcfc3:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  6fcfc8:	75 5a                	jne    6fd024 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fcfca:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fcfd1:	00 
  6fcfd2:	8b 40 20             	mov    0x20(%rax),%eax
  6fcfd5:	89 c1                	mov    %eax,%ecx
  6fcfd7:	83 e1 07             	and    $0x7,%ecx
  6fcfda:	83 f9 06             	cmp    $0x6,%ecx
  6fcfdd:	74 45                	je     6fd024 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fcfdf:	c1 e8 03             	shr    $0x3,%eax
  6fcfe2:	74 40                	je     6fd024 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fcfe4:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fcfeb:	ff c8                	dec    %eax
  6fcfed:	48 39 c6             	cmp    %rax,%rsi
  6fcff0:	0f 86 fd 07 00 00    	jbe    6fd7f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e63>
  6fcff6:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fcffd:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fd001:	48 c1 e0 04          	shl    $0x4,%rax
  6fd005:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fd00b:	0f 84 65 07 00 00    	je     6fd776 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1de6>
  6fd011:	48 01 c5             	add    %rax,%rbp
  6fd014:	48 89 ef             	mov    %rbp,%rdi
  6fd017:	e8 a4 79 ff ff       	call   6f49c0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fd01c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fd023:	ff 
  6fd024:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  6fd02b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  6fd032:	4c 89 e6             	mov    %r12,%rsi
  6fd035:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  6fd03c:	00 
  6fd03d:	ff 15 f5 c4 42 00    	call   *0x42c4f5(%rip)        # b29538 <_DYNAMIC+0x438>
  6fd043:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fd04a:	01 
  6fd04b:	b0 01                	mov    $0x1,%al
  6fd04d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fd054:	00 
  6fd055:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd05a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fd05f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fd064:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  6fd06b:	00 
  6fd06c:	0f 94 c0             	sete   %al
  6fd06f:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  6fd076:	74 0c                	je     6fd084 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16f4>
  6fd078:	b0 01                	mov    $0x1,%al
  6fd07a:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fd081:	00 
  6fd082:	eb 19                	jmp    6fd09d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x170d>
  6fd084:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  6fd08b:	b0 01                	mov    $0x1,%al
  6fd08d:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fd094:	00 
  6fd095:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  6fd09c:	00 
  6fd09d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fd0a2:	48 83 c1 04          	add    $0x4,%rcx
  6fd0a6:	48 39 c8             	cmp    %rcx,%rax
  6fd0a9:	0f 85 cc f5 ff ff    	jne    6fc67b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xceb>
  6fd0af:	e9 ee 02 00 00       	jmp    6fd3a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a12>
  6fd0b4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd0b8:	ff 15 c2 c2 42 00    	call   *0x42c2c2(%rip)        # b29380 <_DYNAMIC+0x280>
  6fd0be:	e9 75 fa ff ff       	jmp    6fcb38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fd0c3:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd0c7:	ff 15 b3 c2 42 00    	call   *0x42c2b3(%rip)        # b29380 <_DYNAMIC+0x280>
  6fd0cd:	e9 a1 f9 ff ff       	jmp    6fca73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fd0d2:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd0d6:	ff 15 a4 c2 42 00    	call   *0x42c2a4(%rip)        # b29380 <_DYNAMIC+0x280>
  6fd0dc:	e9 df fa ff ff       	jmp    6fcbc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fd0e1:	49 83 c4 04          	add    $0x4,%r12
  6fd0e5:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fd0ea:	0f 84 b1 f4 ff ff    	je     6fc5a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xc11>
  6fd0f0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fd0f5:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fd0f9:	ff 15 01 c4 42 00    	call   *0x42c401(%rip)        # b29500 <_DYNAMIC+0x400>
  6fd0ff:	66 85 c0             	test   %ax,%ax
  6fd102:	74 dd                	je     6fd0e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1751>
  6fd104:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fd109:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  6fd10e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  6fd115:	00 
  6fd116:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  6fd11b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  6fd11f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fd126:	00 00 
  6fd128:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  6fd12c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fd133:	00 
  6fd134:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fd139:	89 c2                	mov    %eax,%edx
  6fd13b:	ff 15 c7 c3 42 00    	call   *0x42c3c7(%rip)        # b29508 <_DYNAMIC+0x408>
  6fd141:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  6fd148:	ff 
  6fd149:	75 96                	jne    6fd0e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1751>
  6fd14b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd152:	00 
  6fd153:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd15a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd161:	00 
  6fd162:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd166:	48 09 c5             	or     %rax,%rbp
  6fd169:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd16e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd173:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd178:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd17d:	48 85 f6             	test   %rsi,%rsi
  6fd180:	0f 8e 12 02 00 00    	jle    6fd398 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a08>
  6fd186:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd18b:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd18f:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd194:	ff 15 ae c1 42 00    	call   *0x42c1ae(%rip)        # b29348 <_DYNAMIC+0x248>
  6fd19a:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd19e:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd1a3:	e9 1f 03 00 00       	jmp    6fd4c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fd1a8:	31 ff                	xor    %edi,%edi
  6fd1aa:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd1af:	48 85 f6             	test   %rsi,%rsi
  6fd1b2:	7e 5c                	jle    6fd210 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd1b4:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd1b9:	89 fd                	mov    %edi,%ebp
  6fd1bb:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd1c0:	ff 15 82 c1 42 00    	call   *0x42c182(%rip)        # b29348 <_DYNAMIC+0x248>
  6fd1c6:	89 ef                	mov    %ebp,%edi
  6fd1c8:	eb 46                	jmp    6fd210 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd1ca:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd1d1:	00 
  6fd1d2:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd1d9:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd1e0:	00 
  6fd1e1:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd1e5:	48 09 c5             	or     %rax,%rbp
  6fd1e8:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd1ed:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd1f2:	e9 99 02 00 00       	jmp    6fd490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd1f7:	b0 01                	mov    $0x1,%al
  6fd1f9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fd1fe:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fd205:	48 85 ed             	test   %rbp,%rbp
  6fd208:	0f 85 0e ef ff ff    	jne    6fc11c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x78c>
  6fd20e:	31 ff                	xor    %edi,%edi
  6fd210:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  6fd215:	74 3c                	je     6fd253 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18c3>
  6fd217:	41 80 be 1f 08 00 00 	cmpb   $0x1,0x81f(%r14)
  6fd21e:	01 
  6fd21f:	75 32                	jne    6fd253 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18c3>
  6fd221:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fd226:	4c 89 f6             	mov    %r14,%rsi
  6fd229:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fd230:	00 
  6fd231:	31 c9                	xor    %ecx,%ecx
  6fd233:	e8 c8 d7 ff ff       	call   6faa00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  6fd238:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fd23d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd241:	75 1e                	jne    6fd261 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18d1>
  6fd243:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd24a:	ff ff 
  6fd24c:	31 ff                	xor    %edi,%edi
  6fd24e:	e9 94 02 00 00       	jmp    6fd4e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd253:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd25a:	ff ff 
  6fd25c:	e9 86 02 00 00       	jmp    6fd4e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd261:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fd266:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  6fd26b:	c1 e1 10             	shl    $0x10,%ecx
  6fd26e:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  6fd273:	09 ca                	or     %ecx,%edx
  6fd275:	48 c1 e2 20          	shl    $0x20,%rdx
  6fd279:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd27d:	48 09 d5             	or     %rdx,%rbp
  6fd280:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fd287:	00 
  6fd288:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd28f:	00 
  6fd290:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fd297:	00 00 
  6fd299:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  6fd2a0:	00 00 
  6fd2a2:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  6fd2a9:	00 
  6fd2aa:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  6fd2b1:	00 
  6fd2b2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd2b7:	e9 2b 02 00 00       	jmp    6fd4e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd2bc:	b8 20 00 00 00       	mov    $0x20,%eax
  6fd2c1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd2c6:	40 b7 0c             	mov    $0xc,%dil
  6fd2c9:	31 ed                	xor    %ebp,%ebp
  6fd2cb:	4d 89 f8             	mov    %r15,%r8
  6fd2ce:	e9 bd 01 00 00       	jmp    6fd490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd2d3:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  6fd2da:	48 8d 48 01          	lea    0x1(%rax),%rcx
  6fd2de:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  6fd2e5:	40 0f 94 c5          	sete   %bpl
  6fd2e9:	48 ff c0             	inc    %rax
  6fd2ec:	0f 84 d5 f0 ff ff    	je     6fc3c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa37>
  6fd2f2:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  6fd2f9:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fd300:	00 
  6fd301:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  6fd308:	00 
  6fd309:	ff 15 31 c2 42 00    	call   *0x42c231(%rip)        # b29540 <_DYNAMIC+0x440>
  6fd30f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  6fd316:	00 
  6fd317:	74 21                	je     6fd33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19aa>
  6fd319:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  6fd320:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  6fd327:	40 84 ed             	test   %bpl,%bpl
  6fd32a:	0f 84 48 01 00 00    	je     6fd478 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae8>
  6fd330:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  6fd337:	00 
  6fd338:	eb 16                	jmp    6fd350 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19c0>
  6fd33a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fd341:	00 00 00 00 
  6fd345:	31 d2                	xor    %edx,%edx
  6fd347:	40 84 ed             	test   %bpl,%bpl
  6fd34a:	0f 84 28 01 00 00    	je     6fd478 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae8>
  6fd350:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fd355:	4c 89 f6             	mov    %r14,%rsi
  6fd358:	e8 c3 37 00 00       	call   700b20 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::finish_color_slot>
  6fd35d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fd362:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fd367:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd36b:	0f 85 8c 00 00 00    	jne    6fd3fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a6d>
  6fd371:	40 f6 c7 01          	test   $0x1,%dil
  6fd375:	0f 84 f6 00 00 00    	je     6fd471 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae1>
  6fd37b:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd382:	ff ff 
  6fd384:	40 b7 02             	mov    $0x2,%dil
  6fd387:	e9 04 01 00 00       	jmp    6fd490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd38c:	31 ff                	xor    %edi,%edi
  6fd38e:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd393:	e9 12 fe ff ff       	jmp    6fd1aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd398:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd39d:	e9 25 01 00 00       	jmp    6fd4c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fd3a2:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fd3a9:	00 
  6fd3aa:	34 01                	xor    $0x1,%al
  6fd3ac:	0f b6 c0             	movzbl %al,%eax
  6fd3af:	31 ff                	xor    %edi,%edi
  6fd3b1:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  6fd3b8:	01 
  6fd3b9:	0f 45 f8             	cmovne %eax,%edi
  6fd3bc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd3c1:	48 85 c0             	test   %rax,%rax
  6fd3c4:	0f 84 e0 fd ff ff    	je     6fd1aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd3ca:	f6 00 01             	testb  $0x1,(%rax)
  6fd3cd:	0f 85 d7 fd ff ff    	jne    6fd1aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd3d3:	89 fd                	mov    %edi,%ebp
  6fd3d5:	48 8b 40 08          	mov    0x8(%rax),%rax
  6fd3d9:	a8 01                	test   $0x1,%al
  6fd3db:	75 14                	jne    6fd3f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a61>
  6fd3dd:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd3e2:	48 83 c0 08          	add    $0x8,%rax
  6fd3e6:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fd3eb:	0f 84 b5 03 00 00    	je     6fd7a6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e16>
  6fd3f1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd3f6:	89 ef                	mov    %ebp,%edi
  6fd3f8:	e9 ad fd ff ff       	jmp    6fd1aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd3fd:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd402:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6fd407:	c1 e0 10             	shl    $0x10,%eax
  6fd40a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6fd40f:	09 c1                	or     %eax,%ecx
  6fd411:	48 c1 e1 20          	shl    $0x20,%rcx
  6fd415:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd419:	48 09 cd             	or     %rcx,%rbp
  6fd41c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fd423:	00 
  6fd424:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd42b:	00 
  6fd42c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fd433:	00 
  6fd434:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  6fd43b:	00 
  6fd43c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fd443:	00 
  6fd444:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6fd44b:	00 
  6fd44c:	eb 42                	jmp    6fd490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd44e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd455:	00 
  6fd456:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd45d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd464:	00 
  6fd465:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd469:	48 09 c5             	or     %rax,%rbp
  6fd46c:	e9 85 01 00 00       	jmp    6fd5f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c66>
  6fd471:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  6fd478:	48 85 d2             	test   %rdx,%rdx
  6fd47b:	0f 95 c0             	setne  %al
  6fd47e:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  6fd485:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd48c:	ff ff 
  6fd48e:	31 ff                	xor    %edi,%edi
  6fd490:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6fd495:	48 85 f6             	test   %rsi,%rsi
  6fd498:	7e 22                	jle    6fd4bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b2c>
  6fd49a:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd49f:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fd4a4:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd4a8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd4ad:	ff 15 95 be 42 00    	call   *0x42be95(%rip)        # b29348 <_DYNAMIC+0x248>
  6fd4b3:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd4b7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd4bc:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  6fd4c1:	0f 84 49 fd ff ff    	je     6fd210 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd4c7:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  6fd4ce:	00 
  6fd4cf:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  6fd4d6:	00 
  6fd4d7:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  6fd4de:	00 
  6fd4df:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  6fd4e6:	00 
  6fd4e7:	40 0f b6 c7          	movzbl %dil,%eax
  6fd4eb:	48 c1 e5 08          	shl    $0x8,%rbp
  6fd4ef:	48 09 c5             	or     %rax,%rbp
  6fd4f2:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  6fd4f9:	00 
  6fd4fa:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fd501:	00 
  6fd502:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  6fd509:	00 00 
  6fd50b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  6fd512:	00 00 
  6fd514:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fd519:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  6fd520:	00 
  6fd521:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  6fd528:	00 
  6fd529:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  6fd530:	00 
  6fd531:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  6fd538:	00 
  6fd539:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  6fd540:	00 00 
  6fd542:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6fd549:	00 
  6fd54a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  6fd551:	00 
  6fd552:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  6fd559:	00 
  6fd55a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  6fd561:	00 
  6fd562:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  6fd569:	00 
  6fd56a:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fd571:	00 
  6fd572:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  6fd579:	00 
  6fd57a:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  6fd581:	00 
  6fd582:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  6fd589:	00 
  6fd58a:	31 ed                	xor    %ebp,%ebp
  6fd58c:	e9 41 e6 ff ff       	jmp    6fbbd2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x242>
  6fd591:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd596:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6fd59b:	c1 e0 10             	shl    $0x10,%eax
  6fd59e:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6fd5a3:	09 c1                	or     %eax,%ecx
  6fd5a5:	48 c1 e1 20          	shl    $0x20,%rcx
  6fd5a9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd5ad:	48 09 cd             	or     %rcx,%rbp
  6fd5b0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  6fd5b7:	00 
  6fd5b8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fd5bd:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd5c4:	00 
  6fd5c5:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fd5cc:	00 00 
  6fd5ce:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  6fd5d5:	00 00 
  6fd5d7:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fd5de:	00 
  6fd5df:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6fd5e6:	00 
  6fd5e7:	eb 17                	jmp    6fd600 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c70>
  6fd5e9:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  6fd5f0:	00 00 00 
  6fd5f3:	48 21 c5             	and    %rax,%rbp
  6fd5f6:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd5fb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd600:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fd605:	48 85 c9             	test   %rcx,%rcx
  6fd608:	0f 84 65 fb ff ff    	je     6fd173 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd60e:	f6 01 01             	testb  $0x1,(%rcx)
  6fd611:	0f 85 5c fb ff ff    	jne    6fd173 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd617:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fd61b:	a8 01                	test   $0x1,%al
  6fd61d:	0f 85 50 fb ff ff    	jne    6fd173 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd623:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd627:	48 8d 41 08          	lea    0x8(%rcx),%rax
  6fd62b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fd630:	0f 84 53 01 00 00    	je     6fd789 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1df9>
  6fd636:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd63b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd63f:	e9 34 fb ff ff       	jmp    6fd178 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e8>
  6fd644:	48 8d 3d 0d d7 3f 00 	lea    0x3fd70d(%rip),%rdi        # afad58 <__frame_dummy_init_array_entry+0x4c0>
  6fd64b:	ff 15 b7 bd 42 00    	call   *0x42bdb7(%rip)        # b29408 <_DYNAMIC+0x308>
  6fd651:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd655:	ff 15 25 bd 42 00    	call   *0x42bd25(%rip)        # b29380 <_DYNAMIC+0x280>
  6fd65b:	e9 c0 e6 ff ff       	jmp    6fbd20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fd660:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  6fd666:	eb 3c                	jmp    6fd6a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d14>
  6fd668:	48 8d 05 35 d1 96 ff 	lea    -0x692ecb(%rip),%rax        # 6a7a4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6fd66f:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6fd676:	00 
  6fd677:	48 8d 05 42 df 3f 00 	lea    0x3fdf42(%rip),%rax        # afb5c0 <__frame_dummy_init_array_entry+0xd28>
  6fd67e:	eb 1c                	jmp    6fd69c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d0c>
  6fd680:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  6fd686:	48 8d 05 03 d1 96 ff 	lea    -0x692efd(%rip),%rax        # 6a790 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b3>
  6fd68d:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6fd694:	00 
  6fd695:	48 8d 05 0c df 3f 00 	lea    0x3fdf0c(%rip),%rax        # afb5a8 <__frame_dummy_init_array_entry+0xd10>
  6fd69c:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  6fd6a3:	00 
  6fd6a4:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  6fd6ab:	00 
  6fd6ac:	4c 89 e6             	mov    %r12,%rsi
  6fd6af:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fd6b6:	00 
  6fd6b7:	ff 15 8b bd 42 00    	call   *0x42bd8b(%rip)        # b29448 <_DYNAMIC+0x348>
  6fd6bd:	e9 a7 01 00 00       	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd6c2:	48 8d 3d 9f d0 96 ff 	lea    -0x692f61(%rip),%rdi        # 6a768 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348b>
  6fd6c9:	48 8d 15 78 de 3f 00 	lea    0x3fde78(%rip),%rdx        # afb548 <__frame_dummy_init_array_entry+0xcb0>
  6fd6d0:	be 13 00 00 00       	mov    $0x13,%esi
  6fd6d5:	ff 15 6d bd 42 00    	call   *0x42bd6d(%rip)        # b29448 <_DYNAMIC+0x348>
  6fd6db:	e9 89 01 00 00       	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd6e0:	48 8d 3d fe d0 96 ff 	lea    -0x692f02(%rip),%rdi        # 6a7e5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3508>
  6fd6e7:	48 8d 15 32 df 3f 00 	lea    0x3fdf32(%rip),%rdx        # afb620 <__frame_dummy_init_array_entry+0xd88>
  6fd6ee:	be 93 00 00 00       	mov    $0x93,%esi
  6fd6f3:	ff 15 4f be 42 00    	call   *0x42be4f(%rip)        # b29548 <_DYNAMIC+0x448>
  6fd6f9:	e9 6b 01 00 00       	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd6fe:	48 8d 05 ca d0 96 ff 	lea    -0x692f36(%rip),%rax        # 6a7cf <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34f2>
  6fd705:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  6fd70c:	00 
  6fd70d:	48 8d 05 c4 de 3f 00 	lea    0x3fdec4(%rip),%rax        # afb5d8 <__frame_dummy_init_array_entry+0xd40>
  6fd714:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  6fd71b:	00 
  6fd71c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  6fd723:	00 
  6fd724:	4c 89 ee             	mov    %r13,%rsi
  6fd727:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  6fd72e:	00 
  6fd72f:	ff 15 13 bd 42 00    	call   *0x42bd13(%rip)        # b29448 <_DYNAMIC+0x348>
  6fd735:	e9 2f 01 00 00       	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd73a:	48 8d 3d d7 d2 3f 00 	lea    0x3fd2d7(%rip),%rdi        # afaa18 <__frame_dummy_init_array_entry+0x180>
  6fd741:	ff 15 c1 bc 42 00    	call   *0x42bcc1(%rip)        # b29408 <_DYNAMIC+0x308>
  6fd747:	e9 1d 01 00 00       	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd74c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd753:	00 00 
  6fd755:	48 8d 3d 94 de 3f 00 	lea    0x3fde94(%rip),%rdi        # afb5f0 <__frame_dummy_init_array_entry+0xd58>
  6fd75c:	ff 15 a6 bc 42 00    	call   *0x42bca6(%rip)        # b29408 <_DYNAMIC+0x308>
  6fd762:	e9 02 01 00 00       	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd767:	48 8d 05 7a d2 3f 00 	lea    0x3fd27a(%rip),%rax        # afa9e8 <__frame_dummy_init_array_entry+0x150>
  6fd76e:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  6fd775:	00 
  6fd776:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  6fd77d:	00 
  6fd77e:	ff 15 84 bc 42 00    	call   *0x42bc84(%rip)        # b29408 <_DYNAMIC+0x308>
  6fd784:	e9 e0 00 00 00       	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd789:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd78e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd792:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd797:	ff 15 e3 bb 42 00    	call   *0x42bbe3(%rip)        # b29380 <_DYNAMIC+0x280>
  6fd79d:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd7a1:	e9 d2 f9 ff ff       	jmp    6fd178 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e8>
  6fd7a6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd7ab:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd7af:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd7b4:	ff 15 c6 bb 42 00    	call   *0x42bbc6(%rip)        # b29380 <_DYNAMIC+0x280>
  6fd7ba:	89 ef                	mov    %ebp,%edi
  6fd7bc:	e9 e9 f9 ff ff       	jmp    6fd1aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd7c1:	48 8d 15 38 d2 3f 00 	lea    0x3fd238(%rip),%rdx        # afaa00 <__frame_dummy_init_array_entry+0x168>
  6fd7c8:	ff 15 8a bc 42 00    	call   *0x42bc8a(%rip)        # b29458 <_DYNAMIC+0x358>
  6fd7ce:	e9 96 00 00 00       	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd7d3:	48 8d 05 c6 d5 3f 00 	lea    0x3fd5c6(%rip),%rax        # afada0 <__frame_dummy_init_array_entry+0x508>
  6fd7da:	eb 47                	jmp    6fd823 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd7dc:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd7e1:	48 8d 05 d0 d5 3f 00 	lea    0x3fd5d0(%rip),%rax        # afadb8 <__frame_dummy_init_array_entry+0x520>
  6fd7e8:	eb 39                	jmp    6fd823 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd7ea:	48 8d 05 97 d5 3f 00 	lea    0x3fd597(%rip),%rax        # afad88 <__frame_dummy_init_array_entry+0x4f0>
  6fd7f1:	eb 30                	jmp    6fd823 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd7f3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd7f8:	48 8d 05 01 d2 3f 00 	lea    0x3fd201(%rip),%rax        # afaa00 <__frame_dummy_init_array_entry+0x168>
  6fd7ff:	eb 22                	jmp    6fd823 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd801:	48 85 ff             	test   %rdi,%rdi
  6fd804:	75 34                	jne    6fd83a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1eaa>
  6fd806:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd80d:	00 00 
  6fd80f:	ff 15 3b bd 42 00    	call   *0x42bd3b(%rip)        # b29550 <_DYNAMIC+0x450>
  6fd815:	eb 52                	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd817:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd81c:	48 8d 05 ad d1 3f 00 	lea    0x3fd1ad(%rip),%rax        # afa9d0 <__frame_dummy_init_array_entry+0x138>
  6fd823:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  6fd828:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd82d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  6fd832:	ff 15 20 bc 42 00    	call   *0x42bc20(%rip)        # b29458 <_DYNAMIC+0x358>
  6fd838:	eb 2f                	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd83a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  6fd83f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd846:	00 00 
  6fd848:	ff 15 22 bb 42 00    	call   *0x42bb22(%rip)        # b29370 <_DYNAMIC+0x270>
  6fd84e:	eb 19                	jmp    6fd869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd850:	48 8d 3d 24 cf 96 ff 	lea    -0x6930dc(%rip),%rdi        # 6a77b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6fd857:	48 8d 15 02 dd 3f 00 	lea    0x3fdd02(%rip),%rdx        # afb560 <__frame_dummy_init_array_entry+0xcc8>
  6fd85e:	be 15 00 00 00       	mov    $0x15,%esi
  6fd863:	ff 15 df bb 42 00    	call   *0x42bbdf(%rip)        # b29448 <_DYNAMIC+0x348>
  6fd869:	0f 0b                	ud2
  6fd86b:	49 89 c5             	mov    %rax,%r13
  6fd86e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd873:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fd877:	eb 6d                	jmp    6fd8e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd879:	49 89 c5             	mov    %rax,%r13
  6fd87c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd881:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fd885:	eb 5f                	jmp    6fd8e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd887:	49 89 c5             	mov    %rax,%r13
  6fd88a:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fd88e:	eb 56                	jmp    6fd8e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd890:	48 89 c3             	mov    %rax,%rbx
  6fd893:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fd89a:	00 
  6fd89b:	e8 40 a7 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fd8a0:	48 89 df             	mov    %rbx,%rdi
  6fd8a3:	e8 38 bc 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fd8a8:	eb 18                	jmp    6fd8c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f32>
  6fd8aa:	eb 16                	jmp    6fd8c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f32>
  6fd8ac:	eb 00                	jmp    6fd8ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f1e>
  6fd8ae:	49 89 c5             	mov    %rax,%r13
  6fd8b1:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fd8b8:	ff 
  6fd8b9:	eb 2b                	jmp    6fd8e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd8bb:	49 89 c5             	mov    %rax,%r13
  6fd8be:	eb 4d                	jmp    6fd90d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd8c0:	eb 21                	jmp    6fd8e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f53>
  6fd8c2:	49 89 c5             	mov    %rax,%r13
  6fd8c5:	eb 29                	jmp    6fd8f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f60>
  6fd8c7:	49 89 c5             	mov    %rax,%r13
  6fd8ca:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  6fd8d0:	7e 3b                	jle    6fd90d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd8d2:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd8d7:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd8dc:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6fd8e1:	eb 24                	jmp    6fd907 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f77>
  6fd8e3:	49 89 c5             	mov    %rax,%r13
  6fd8e6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd8eb:	e8 40 70 ff ff       	call   6f4930 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  6fd8f0:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  6fd8f6:	7e 15                	jle    6fd90d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd8f8:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd8fd:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd902:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd907:	ff 15 3b ba 42 00    	call   *0x42ba3b(%rip)        # b29348 <_DYNAMIC+0x248>
  6fd90d:	4c 89 ef             	mov    %r13,%rdi
  6fd910:	ff 15 52 bb 42 00    	call   *0x42bb52(%rip)        # b29468 <_DYNAMIC+0x368>
  6fd916:	49 89 c5             	mov    %rax,%r13
  6fd919:	48 89 d5             	mov    %rdx,%rbp
  6fd91c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  6fd923:	00 
  6fd924:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  6fd92b:	00 
  6fd92c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  6fd933:	00 fd ff ff ff 
  6fd938:	4c 89 f7             	mov    %r14,%rdi
  6fd93b:	e8 60 d1 01 00       	call   71aaa0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fd940:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  6fd947:	00 0f 00 00 00 
  6fd94c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6fd950:	48 85 c0             	test   %rax,%rax
  6fd953:	74 05                	je     6fd95a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fca>
  6fd955:	4c 89 ef             	mov    %r13,%rdi
  6fd958:	ff d0                	call   *%rax
  6fd95a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6fd95e:	48 85 f6             	test   %rsi,%rsi
  6fd961:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd966:	74 0d                	je     6fd975 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fe5>
  6fd968:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6fd96c:	4c 89 ef             	mov    %r13,%rdi
  6fd96f:	ff 15 d3 b9 42 00    	call   *0x42b9d3(%rip)        # b29348 <_DYNAMIC+0x248>
  6fd975:	31 ed                	xor    %ebp,%ebp
  6fd977:	e9 56 e2 ff ff       	jmp    6fbbd2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x242>
  6fd97c:	48 89 c3             	mov    %rax,%rbx
  6fd97f:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6fd983:	48 85 f6             	test   %rsi,%rsi
  6fd986:	74 2b                	je     6fd9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2023>
  6fd988:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6fd98c:	4c 89 ef             	mov    %r13,%rdi
  6fd98f:	ff 15 b3 b9 42 00    	call   *0x42b9b3(%rip)        # b29348 <_DYNAMIC+0x248>
  6fd995:	48 89 df             	mov    %rbx,%rdi
  6fd998:	e8 43 bb 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fd99d:	ff 15 d5 b9 42 00    	call   *0x42b9d5(%rip)        # b29378 <_DYNAMIC+0x278>
  6fd9a3:	48 89 c3             	mov    %rax,%rbx
  6fd9a6:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fd9ad:	00 
  6fd9ae:	e8 4d 74 ff ff       	call   6f4e00 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fd9b3:	48 89 df             	mov    %rbx,%rdi
  6fd9b6:	e8 25 bb 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fd9bb:	ff 15 b7 b9 42 00    	call   *0x42b9b7(%rip)        # b29378 <_DYNAMIC+0x278>
  6fd9c1:	ff 15 a9 ba 42 00    	call   *0x42baa9(%rip)        # b29470 <_DYNAMIC+0x370>
