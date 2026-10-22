
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fb8d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>:
  6fb8d0:	55                   	push   %rbp
  6fb8d1:	41 57                	push   %r15
  6fb8d3:	41 56                	push   %r14
  6fb8d5:	41 55                	push   %r13
  6fb8d7:	41 54                	push   %r12
  6fb8d9:	53                   	push   %rbx
  6fb8da:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  6fb8e1:	4d 89 c4             	mov    %r8,%r12
  6fb8e4:	49 89 cf             	mov    %rcx,%r15
  6fb8e7:	49 89 f6             	mov    %rsi,%r14
  6fb8ea:	48 89 fb             	mov    %rdi,%rbx
  6fb8ed:	41 83 38 02          	cmpl   $0x2,(%r8)
  6fb8f1:	75 08                	jne    6fb8fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2b>
  6fb8f3:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fb8fa:	01 
  6fb8fb:	4d 85 ff             	test   %r15,%r15
  6fb8fe:	0f 84 94 01 00 00    	je     6fba98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c8>
  6fb904:	41 80 be 1e 08 00 00 	cmpb   $0x1,0x81e(%r14)
  6fb90b:	01 
  6fb90c:	0f 85 86 01 00 00    	jne    6fba98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c8>
  6fb912:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  6fb919:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  6fb920:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fb924:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  6fb929:	48 0f 44 ce          	cmove  %rsi,%rcx
  6fb92d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  6fb931:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  6fb938:	00 00 
  6fb93a:	74 45                	je     6fb981 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb1>
  6fb93c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  6fb943:	00 00 
  6fb945:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  6fb94c:	00 00 
  6fb94e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fb955:	00 
  6fb956:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  6fb95d:	00 
  6fb95e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6fb965:	00 
  6fb966:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  6fb96a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  6fb96e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fb975:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb979:	88 4b 10             	mov    %cl,0x10(%rbx)
  6fb97c:	e9 5e 03 00 00       	jmp    6fbcdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fb981:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  6fb986:	41 83 ff 01          	cmp    $0x1,%r15d
  6fb98a:	0f 85 80 00 00 00    	jne    6fba10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x140>
  6fb990:	48 89 d5             	mov    %rdx,%rbp
  6fb993:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  6fb99a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  6fb9a1:	49 c1 e4 04          	shl    $0x4,%r12
  6fb9a5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6fb9ac:	00 00 00 00 
  6fb9b0:	4d 85 e4             	test   %r12,%r12
  6fb9b3:	0f 84 7a 03 00 00    	je     6fbd33 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x463>
  6fb9b9:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  6fb9bd:	48 8b 39             	mov    (%rcx),%rdi
  6fb9c0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fb9c4:	ff 50 18             	call   *0x18(%rax)
  6fb9c7:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  6fb9cb:	4c 89 e9             	mov    %r13,%rcx
  6fb9ce:	4c 39 f8             	cmp    %r15,%rax
  6fb9d1:	75 dd                	jne    6fb9b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xe0>
  6fb9d3:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  6fb9da:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  6fb9e1:	48 c1 e0 03          	shl    $0x3,%rax
  6fb9e5:	31 f6                	xor    %esi,%esi
  6fb9e7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fb9ec:	0f 1f 40 00          	nopl   0x0(%rax)
  6fb9f0:	48 89 f2             	mov    %rsi,%rdx
  6fb9f3:	48 39 f0             	cmp    %rsi,%rax
  6fb9f6:	74 0a                	je     6fba02 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x132>
  6fb9f8:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  6fb9fc:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  6fba00:	75 ee                	jne    6fb9f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x120>
  6fba02:	48 39 d0             	cmp    %rdx,%rax
  6fba05:	0f 95 c1             	setne  %cl
  6fba08:	48 89 ea             	mov    %rbp,%rdx
  6fba0b:	e9 7f 00 00 00       	jmp    6fba8f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1bf>
  6fba10:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fba17:	00 
  6fba18:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  6fba1f:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  6fba26:	49 c1 e5 04          	shl    $0x4,%r13
  6fba2a:	31 ed                	xor    %ebp,%ebp
  6fba2c:	0f 1f 40 00          	nopl   0x0(%rax)
  6fba30:	49 39 ed             	cmp    %rbp,%r13
  6fba33:	0f 84 0e 03 00 00    	je     6fbd47 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x477>
  6fba39:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  6fba3d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  6fba42:	4c 89 fe             	mov    %r15,%rsi
  6fba45:	ff 50 30             	call   *0x30(%rax)
  6fba48:	48 83 c5 10          	add    $0x10,%rbp
  6fba4c:	84 c0                	test   %al,%al
  6fba4e:	74 e0                	je     6fba30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160>
  6fba50:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  6fba55:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  6fba5a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  6fba61:	00 
  6fba62:	4c 89 fa             	mov    %r15,%rdx
  6fba65:	ff 50 60             	call   *0x60(%rax)
  6fba68:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  6fba6f:	00 
  6fba70:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fba77:	00 
  6fba78:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fba7c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fba81:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fba88:	00 
  6fba89:	0f 85 c7 fe ff ff    	jne    6fb956 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fba8f:	f6 c1 01             	test   $0x1,%cl
  6fba92:	0f 84 f4 02 00 00    	je     6fbd8c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x4bc>
  6fba98:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  6fba9f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fbaa4:	4c 89 f6             	mov    %r14,%rsi
  6fbaa7:	31 c9                	xor    %ecx,%ecx
  6fbaa9:	e8 62 ee ff ff       	call   6fa910 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  6fbaae:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  6fbab3:	75 16                	jne    6fbacb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fb>
  6fbab5:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  6fbabc:	00 
  6fbabd:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  6fbac4:	00 fe ff ff ff 
  6fbac9:	eb 41                	jmp    6fbb0c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x23c>
  6fbacb:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fbad2:	00 
  6fbad3:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6fbada:	00 
  6fbadb:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  6fbae1:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  6fbae8:	00 00 
  6fbaea:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  6fbaf1:	00 
  6fbaf2:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  6fbaf9:	00 
  6fbafa:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  6fbb01:	00 00 
  6fbb03:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  6fbb0a:	00 00 
  6fbb0c:	40 b5 01             	mov    $0x1,%bpl
  6fbb0f:	45 31 ff             	xor    %r15d,%r15d
  6fbb12:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  6fbb19:	00 fe 
  6fbb1b:	0f 85 ba 00 00 00    	jne    6fbbdb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x30b>
  6fbb21:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fbb28:	00 
  6fbb29:	4c 89 f6             	mov    %r14,%rsi
  6fbb2c:	4c 89 e2             	mov    %r12,%rdx
  6fbb2f:	e8 9c 5e 00 00       	call   7019d0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::reconcile_editing>
  6fbb34:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fbb3b:	00 
  6fbb3c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  6fbb43:	00 00 
  6fbb45:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fbb49:	0f 85 61 01 00 00    	jne    6fbcb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x3e0>
  6fbb4f:	48 8d 35 c2 c0 96 ff 	lea    -0x693f3e(%rip),%rsi        # 67c18 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x99b>
  6fbb56:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fbb5d:	00 
  6fbb5e:	e8 cd 07 03 00       	call   72c330 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fbb63:	84 c0                	test   %al,%al
  6fbb65:	74 26                	je     6fbb8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2bd>
  6fbb67:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbb6e:	48 85 c0             	test   %rax,%rax
  6fbb71:	0f 84 7a 01 00 00    	je     6fbcf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x421>
  6fbb77:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fbb7e:	00 
  6fbb7f:	0f 95 c0             	setne  %al
  6fbb82:	44 08 e0             	or     %r12b,%al
  6fbb85:	a8 01                	test   $0x1,%al
  6fbb87:	0f 84 6e 01 00 00    	je     6fbcfb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x42b>
  6fbb8d:	48 8d 35 bc c0 96 ff 	lea    -0x693f44(%rip),%rsi        # 67c50 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x9d3>
  6fbb94:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fbb9b:	00 
  6fbb9c:	e8 8f 07 03 00       	call   72c330 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fbba1:	84 c0                	test   %al,%al
  6fbba3:	74 26                	je     6fbbcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2fb>
  6fbba5:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbbac:	48 85 c0             	test   %rax,%rax
  6fbbaf:	0f 84 a7 01 00 00    	je     6fbd5c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x48c>
  6fbbb5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fbbbc:	00 
  6fbbbd:	0f 95 c0             	setne  %al
  6fbbc0:	44 08 e0             	or     %r12b,%al
  6fbbc3:	a8 01                	test   $0x1,%al
  6fbbc5:	0f 84 9b 01 00 00    	je     6fbd66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x496>
  6fbbcb:	48 89 df             	mov    %rbx,%rdi
  6fbbce:	4c 89 f6             	mov    %r14,%rsi
  6fbbd1:	e8 1a f0 01 00       	call   71abf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  6fbbd6:	e9 04 01 00 00       	jmp    6fbcdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbbdb:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  6fbbe2:	00 
  6fbbe3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fbbea:	00 
  6fbbeb:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  6fbbf2:	00 
  6fbbf3:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  6fbbfa:	00 
  6fbbfb:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  6fbc02:	00 
  6fbc03:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  6fbc0a:	00 
  6fbc0b:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  6fbc12:	00 
  6fbc13:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  6fbc1a:	00 
  6fbc1b:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fbc22:	48 85 c0             	test   %rax,%rax
  6fbc25:	74 41                	je     6fbc68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbc27:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fbc2e:	48 85 c0             	test   %rax,%rax
  6fbc31:	74 35                	je     6fbc68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbc33:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fbc37:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  6fbc3b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  6fbc3f:	80 f9 02             	cmp    $0x2,%cl
  6fbc42:	74 24                	je     6fbc68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fbc44:	f6 07 01             	testb  $0x1,(%rdi)
  6fbc47:	75 17                	jne    6fbc60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fbc49:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fbc4d:	a8 01                	test   $0x1,%al
  6fbc4f:	75 0f                	jne    6fbc60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fbc51:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fbc55:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fbc5a:	0f 84 31 19 00 00    	je     6fd591 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cc1>
  6fbc60:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fbc67:	01 
  6fbc68:	41 c6 86 1e 08 00 00 	movb   $0x0,0x81e(%r14)
  6fbc6f:	00 
  6fbc70:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fbc77:	00 00 00 00 
  6fbc7b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6fbc82:	00 
  6fbc83:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fbc87:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  6fbc8e:	00 00 
  6fbc90:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  6fbc97:	00 00 
  6fbc99:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  6fbca0:	00 
  6fbca1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fbca5:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  6fbcaa:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  6fbcae:	eb 2f                	jmp    6fbcdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbcb0:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  6fbcb7:	00 00 
  6fbcb9:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  6fbcc0:	00 00 
  6fbcc2:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6fbcc9:	00 
  6fbcca:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6fbcce:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  6fbcd3:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  6fbcd8:	48 89 03             	mov    %rax,(%rbx)
  6fbcdb:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  6fbcdf:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  6fbce6:	5b                   	pop    %rbx
  6fbce7:	41 5c                	pop    %r12
  6fbce9:	41 5d                	pop    %r13
  6fbceb:	41 5e                	pop    %r14
  6fbced:	41 5f                	pop    %r15
  6fbcef:	5d                   	pop    %rbp
  6fbcf0:	c3                   	ret
  6fbcf1:	41 80 fc 01          	cmp    $0x1,%r12b
  6fbcf5:	0f 84 92 fe ff ff    	je     6fbb8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2bd>
  6fbcfb:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  6fbd02:	00 00 
  6fbd04:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  6fbd0b:	00 
  6fbd0c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fbd13:	00 
  6fbd14:	74 16                	je     6fbd2c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x45c>
  6fbd16:	84 c0                	test   %al,%al
  6fbd18:	0f 84 c7 00 00 00    	je     6fbde5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x515>
  6fbd1e:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fbd25:	ff 
  6fbd26:	0f 85 b9 00 00 00    	jne    6fbde5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x515>
  6fbd2c:	31 c9                	xor    %ecx,%ecx
  6fbd2e:	e9 be 00 00 00       	jmp    6fbdf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x521>
  6fbd33:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fbd3a:	00 
  6fbd3b:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fbd40:	b1 01                	mov    $0x1,%cl
  6fbd42:	e9 0f fc ff ff       	jmp    6fb956 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fbd47:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fbd4e:	00 
  6fbd4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fbd54:	44 89 f9             	mov    %r15d,%ecx
  6fbd57:	e9 fa fb ff ff       	jmp    6fb956 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fbd5c:	41 80 fc 01          	cmp    $0x1,%r12b
  6fbd60:	0f 84 65 fe ff ff    	je     6fbbcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2fb>
  6fbd66:	40 84 ed             	test   %bpl,%bpl
  6fbd69:	0f 85 15 18 00 00    	jne    6fd584 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cb4>
  6fbd6f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  6fbd73:	4c 89 f6             	mov    %r14,%rsi
  6fbd76:	31 d2                	xor    %edx,%edx
  6fbd78:	4c 89 f9             	mov    %r15,%rcx
  6fbd7b:	e8 d0 78 00 00       	call   703650 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::publish_metadata>
  6fbd80:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fbd87:	e9 53 ff ff ff       	jmp    6fbcdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbd8c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  6fbd93:	00 
  6fbd94:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  6fbd9b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  6fbda2:	48 85 c0             	test   %rax,%rax
  6fbda5:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fbdac:	00 
  6fbdad:	0f 84 90 02 00 00    	je     6fc043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbdb3:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  6fbdba:	48 85 c9             	test   %rcx,%rcx
  6fbdbd:	0f 84 9c 00 00 00    	je     6fbe5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x58f>
  6fbdc3:	48 89 ca             	mov    %rcx,%rdx
  6fbdc6:	48 83 e2 07          	and    $0x7,%rdx
  6fbdca:	74 4c                	je     6fbe18 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x548>
  6fbdcc:	31 f6                	xor    %esi,%esi
  6fbdce:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbdd5:	48 ff c6             	inc    %rsi
  6fbdd8:	48 39 f2             	cmp    %rsi,%rdx
  6fbddb:	75 f1                	jne    6fbdce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x4fe>
  6fbddd:	48 89 ca             	mov    %rcx,%rdx
  6fbde0:	48 29 f2             	sub    %rsi,%rdx
  6fbde3:	eb 36                	jmp    6fbe1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x54b>
  6fbde5:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fbdec:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fbdf1:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fbdf8:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  6fbdfc:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fbe00:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  6fbe05:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  6fbe09:	88 43 30             	mov    %al,0x30(%rbx)
  6fbe0c:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fbe13:	e9 c7 fe ff ff       	jmp    6fbcdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fbe18:	48 89 ca             	mov    %rcx,%rdx
  6fbe1b:	48 83 f9 08          	cmp    $0x8,%rcx
  6fbe1f:	72 3e                	jb     6fbe5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x58f>
  6fbe21:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe28:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe2f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe36:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe3d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe44:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe4b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe52:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fbe59:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  6fbe5d:	75 c2                	jne    6fbe21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x551>
  6fbe5f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  6fbe66:	00 
  6fbe67:	0f 84 d6 01 00 00    	je     6fc043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbe6d:	80 38 00             	cmpb   $0x0,(%rax)
  6fbe70:	0f 85 cd 01 00 00    	jne    6fc043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbe76:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  6fbe7d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  6fbe84:	00 
  6fbe85:	e8 86 81 04 00       	call   744010 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  6fbe8a:	48 85 c0             	test   %rax,%rax
  6fbe8d:	0f 84 b0 01 00 00    	je     6fc043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbe93:	48 8b 48 10          	mov    0x10(%rax),%rcx
  6fbe97:	48 c1 e1 02          	shl    $0x2,%rcx
  6fbe9b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  6fbe9f:	ba 04 00 00 00       	mov    $0x4,%edx
  6fbea4:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  6fbea9:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fbeae:	b8 00 00 00 00       	mov    $0x0,%eax
  6fbeb3:	48 0f 45 c1          	cmovne %rcx,%rax
  6fbeb7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fbebc:	48 85 c0             	test   %rax,%rax
  6fbebf:	0f 84 7e 01 00 00    	je     6fc043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fbec5:	45 31 ed             	xor    %r13d,%r13d
  6fbec8:	48 8b 05 51 d5 42 00 	mov    0x42d551(%rip),%rax        # b29420 <_DYNAMIC+0x398>
  6fbecf:	48 83 c0 20          	add    $0x20,%rax
  6fbed3:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fbed8:	48 8b 05 49 d5 42 00 	mov    0x42d549(%rip),%rax        # b29428 <_DYNAMIC+0x3a0>
  6fbedf:	48 83 c0 20          	add    $0x20,%rax
  6fbee3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fbee8:	48 8b 05 41 d5 42 00 	mov    0x42d541(%rip),%rax        # b29430 <_DYNAMIC+0x3a8>
  6fbeef:	48 83 c0 20          	add    $0x20,%rax
  6fbef3:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fbef8:	48 8b 05 39 d5 42 00 	mov    0x42d539(%rip),%rax        # b29438 <_DYNAMIC+0x3b0>
  6fbeff:	48 83 c0 20          	add    $0x20,%rax
  6fbf03:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6fbf08:	48 8b 05 31 d5 42 00 	mov    0x42d531(%rip),%rax        # b29440 <_DYNAMIC+0x3b8>
  6fbf0f:	48 83 c0 20          	add    $0x20,%rax
  6fbf13:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fbf18:	48 8b 05 29 d5 42 00 	mov    0x42d529(%rip),%rax        # b29448 <_DYNAMIC+0x3c0>
  6fbf1f:	48 83 c0 20          	add    $0x20,%rax
  6fbf23:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fbf2a:	00 
  6fbf2b:	48 8b 05 1e d5 42 00 	mov    0x42d51e(%rip),%rax        # b29450 <_DYNAMIC+0x3c8>
  6fbf32:	48 83 c0 20          	add    $0x20,%rax
  6fbf36:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fbf3d:	00 
  6fbf3e:	48 8b 05 13 d5 42 00 	mov    0x42d513(%rip),%rax        # b29458 <_DYNAMIC+0x3d0>
  6fbf45:	48 83 c0 20          	add    $0x20,%rax
  6fbf49:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fbf4e:	48 8b 05 0b d5 42 00 	mov    0x42d50b(%rip),%rax        # b29460 <_DYNAMIC+0x3d8>
  6fbf55:	48 83 c0 20          	add    $0x20,%rax
  6fbf59:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  6fbf60:	00 
  6fbf61:	48 8b 05 00 d5 42 00 	mov    0x42d500(%rip),%rax        # b29468 <_DYNAMIC+0x3e0>
  6fbf68:	48 83 c0 20          	add    $0x20,%rax
  6fbf6c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fbf71:	48 8b 05 f8 d4 42 00 	mov    0x42d4f8(%rip),%rax        # b29470 <_DYNAMIC+0x3e8>
  6fbf78:	48 83 c0 20          	add    $0x20,%rax
  6fbf7c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6fbf83:	00 
  6fbf84:	48 8b 05 ed d4 42 00 	mov    0x42d4ed(%rip),%rax        # b29478 <_DYNAMIC+0x3f0>
  6fbf8b:	48 83 c0 20          	add    $0x20,%rax
  6fbf8f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fbf94:	48 8b 05 e5 d4 42 00 	mov    0x42d4e5(%rip),%rax        # b29480 <_DYNAMIC+0x3f8>
  6fbf9b:	48 83 c0 20          	add    $0x20,%rax
  6fbf9f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fbfa4:	48 8d 2d b5 f2 95 ff 	lea    -0x6a0d4b(%rip),%rbp        # 5b260 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1460>
  6fbfab:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fbfb0:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  6fbfb4:	ff 15 ce d4 42 00    	call   *0x42d4ce(%rip)        # b29488 <_DYNAMIC+0x400>
  6fbfba:	0f b7 c0             	movzwl %ax,%eax
  6fbfbd:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  6fbfc2:	48 01 e9             	add    %rbp,%rcx
  6fbfc5:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fbfca:	ff e1                	jmp    *%rcx
  6fbfcc:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fbfd1:	eb 57                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fbfd3:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fbfda:	00 
  6fbfdb:	eb 4d                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fbfdd:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fbfe2:	eb 46                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fbfe4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fbfe9:	eb 3f                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fbfeb:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  6fbff2:	00 
  6fbff3:	eb 35                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fbff5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fbffa:	eb 2e                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fbffc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fc003:	00 
  6fc004:	eb 24                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc006:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6fc00b:	eb 1d                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc00d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fc012:	eb 16                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc014:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fc01b:	00 
  6fc01c:	eb 0c                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc01e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fc023:	eb 05                	jmp    6fc02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fc025:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fc02a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  6fc02e:	0f 85 03 11 00 00    	jne    6fd137 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1867>
  6fc034:	49 83 c5 04          	add    $0x4,%r13
  6fc038:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  6fc03d:	0f 85 68 ff ff ff    	jne    6fbfab <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x6db>
  6fc043:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  6fc04a:	00 00 
  6fc04c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fc053:	48 85 ed             	test   %rbp,%rbp
  6fc056:	0f 84 f2 10 00 00    	je     6fd14e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x187e>
  6fc05c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fc063:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fc06a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  6fc071:	48 89 c7             	mov    %rax,%rdi
  6fc074:	48 89 e9             	mov    %rbp,%rcx
  6fc077:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  6fc07e:	00 
  6fc07f:	45 89 d3             	mov    %r10d,%r11d
  6fc082:	41 c1 e3 05          	shl    $0x5,%r11d
  6fc086:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  6fc08d:	45 31 c9             	xor    %r9d,%r9d
  6fc090:	4d 39 cb             	cmp    %r9,%r11
  6fc093:	74 28                	je     6fc0bd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7ed>
  6fc095:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  6fc09c:	00 
  6fc09d:	41 0f 97 c4          	seta   %r12b
  6fc0a1:	41 80 dc 00          	sbb    $0x0,%r12b
  6fc0a5:	49 83 c1 20          	add    $0x20,%r9
  6fc0a9:	49 ff c0             	inc    %r8
  6fc0ac:	41 80 fc 01          	cmp    $0x1,%r12b
  6fc0b0:	74 de                	je     6fc090 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7c0>
  6fc0b2:	45 0f b6 d4          	movzbl %r12b,%r10d
  6fc0b6:	45 85 d2             	test   %r10d,%r10d
  6fc0b9:	75 05                	jne    6fc0c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7f0>
  6fc0bb:	eb 1c                	jmp    6fc0d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x809>
  6fc0bd:	4d 89 d0             	mov    %r10,%r8
  6fc0c0:	48 83 ef 01          	sub    $0x1,%rdi
  6fc0c4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc0c9:	0f 82 92 00 00 00    	jb     6fc161 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x891>
  6fc0cf:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  6fc0d6:	00 
  6fc0d7:	eb 9e                	jmp    6fc077 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7a7>
  6fc0d9:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  6fc0df:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc0e4:	75 7b                	jne    6fc161 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x891>
  6fc0e6:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  6fc0eb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc0f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  6fc0f9:	4c 8d 05 08 f4 3f 00 	lea    0x3ff408(%rip),%r8        # afb508 <__frame_dummy_init_array_entry+0xca0>
  6fc100:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc105:	4c 89 f9             	mov    %r15,%rcx
  6fc108:	45 31 c9             	xor    %r9d,%r9d
  6fc10b:	e8 50 8e 05 00       	call   754f60 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::freeze>
  6fc110:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fc115:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  6fc11a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fc121:	00 
  6fc122:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fc126:	0f 85 e6 00 00 00    	jne    6fc212 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x942>
  6fc12c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fc133:	00 
  6fc134:	48 89 cd             	mov    %rcx,%rbp
  6fc137:	48 c1 ed 08          	shr    $0x8,%rbp
  6fc13b:	b8 20 00 00 00       	mov    $0x20,%eax
  6fc140:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc145:	89 cf                	mov    %ecx,%edi
  6fc147:	e9 bb 12 00 00       	jmp    6fd407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fc14c:	48 89 f9             	mov    %rdi,%rcx
  6fc14f:	48 83 e8 01          	sub    $0x1,%rax
  6fc153:	0f 82 f5 0f 00 00    	jb     6fd14e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x187e>
  6fc159:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  6fc160:	00 
  6fc161:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  6fc168:	41 89 f8             	mov    %edi,%r8d
  6fc16b:	41 c1 e0 05          	shl    $0x5,%r8d
  6fc16f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  6fc176:	45 31 ed             	xor    %r13d,%r13d
  6fc179:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6fc180:	4d 39 e8             	cmp    %r13,%r8
  6fc183:	74 c7                	je     6fc14c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x87c>
  6fc185:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  6fc18c:	00 
  6fc18d:	41 0f 97 c1          	seta   %r9b
  6fc191:	41 80 d9 00          	sbb    $0x0,%r9b
  6fc195:	49 83 c5 20          	add    $0x20,%r13
  6fc199:	48 ff c1             	inc    %rcx
  6fc19c:	41 80 f9 01          	cmp    $0x1,%r9b
  6fc1a0:	74 de                	je     6fc180 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x8b0>
  6fc1a2:	41 0f b6 f9          	movzbl %r9b,%edi
  6fc1a6:	85 ff                	test   %edi,%edi
  6fc1a8:	75 a5                	jne    6fc14f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x87f>
  6fc1aa:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  6fc1af:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6fc1b3:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc1b8:	74 41                	je     6fc1fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x92b>
  6fc1ba:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc1bf:	48 85 c0             	test   %rax,%rax
  6fc1c2:	0f 84 46 01 00 00    	je     6fc30e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa3e>
  6fc1c8:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc1cd:	48 ff c8             	dec    %rax
  6fc1d0:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  6fc1d7:	ff ff 3f 
  6fc1da:	48 21 c7             	and    %rax,%rdi
  6fc1dd:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  6fc1e1:	45 89 c8             	mov    %r9d,%r8d
  6fc1e4:	41 83 e0 03          	and    $0x3,%r8d
  6fc1e8:	48 83 ff 03          	cmp    $0x3,%rdi
  6fc1ec:	0f 83 25 01 00 00    	jae    6fc317 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa47>
  6fc1f2:	31 c0                	xor    %eax,%eax
  6fc1f4:	31 ff                	xor    %edi,%edi
  6fc1f6:	e9 b0 01 00 00       	jmp    6fc3ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xadb>
  6fc1fb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc202:	4c 8d 05 ff f2 3f 00 	lea    0x3ff2ff(%rip),%r8        # afb508 <__frame_dummy_init_array_entry+0xca0>
  6fc209:	31 c0                	xor    %eax,%eax
  6fc20b:	31 ff                	xor    %edi,%edi
  6fc20d:	e9 d4 01 00 00       	jmp    6fc3e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb16>
  6fc212:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fc217:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fc21c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fc223:	00 
  6fc224:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  6fc22b:	00 
  6fc22c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fc233:	00 
  6fc234:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  6fc23b:	00 
  6fc23c:	41 83 fd 02          	cmp    $0x2,%r13d
  6fc240:	0f 84 bc 13 00 00    	je     6fd602 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d32>
  6fc246:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  6fc24b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  6fc252:	00 
  6fc253:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  6fc258:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  6fc25f:	00 
  6fc260:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  6fc267:	00 
  6fc268:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc26f:	00 
  6fc270:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fc275:	ba 06 00 00 00       	mov    $0x6,%edx
  6fc27a:	ff 15 10 d2 42 00    	call   *0x42d210(%rip)        # b29490 <_DYNAMIC+0x408>
  6fc280:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  6fc287:	00 
  6fc288:	80 fa ff             	cmp    $0xff,%dl
  6fc28b:	0f 84 79 0e 00 00    	je     6fd10a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x183a>
  6fc291:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  6fc298:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  6fc29f:	00 
  6fc2a0:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  6fc2a7:	00 
  6fc2a8:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  6fc2af:	00 
  6fc2b0:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  6fc2b7:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  6fc2be:	80 fa 02             	cmp    $0x2,%dl
  6fc2c1:	0f 85 35 0f 00 00    	jne    6fd1fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x192c>
  6fc2c7:	89 ea                	mov    %ebp,%edx
  6fc2c9:	48 c1 e0 20          	shl    $0x20,%rax
  6fc2cd:	48 09 c8             	or     %rcx,%rax
  6fc2d0:	48 c1 e8 08          	shr    $0x8,%rax
  6fc2d4:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  6fc2db:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  6fc2e2:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  6fc2e9:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  6fc2f0:	00 
  6fc2f1:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  6fc2f8:	00 
  6fc2f9:	41 80 be 1f 08 00 00 	cmpb   $0x0,0x81f(%r14)
  6fc300:	00 
  6fc301:	0f 84 0c 0f 00 00    	je     6fd213 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1943>
  6fc307:	31 ed                	xor    %ebp,%ebp
  6fc309:	e9 24 0f 00 00       	jmp    6fd232 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1962>
  6fc30e:	31 ff                	xor    %edi,%edi
  6fc310:	31 c0                	xor    %eax,%eax
  6fc312:	e9 b5 00 00 00       	jmp    6fc3cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xafc>
  6fc317:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6fc31c:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  6fc323:	00 00 80 
  6fc326:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6fc32a:	49 21 c1             	and    %rax,%r9
  6fc32d:	31 c0                	xor    %eax,%eax
  6fc32f:	31 ff                	xor    %edi,%edi
  6fc331:	44 8b 11             	mov    (%rcx),%r10d
  6fc334:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  6fc338:	45 89 d4             	mov    %r10d,%r12d
  6fc33b:	41 f7 d4             	not    %r12d
  6fc33e:	41 f6 c4 03          	test   $0x3,%r12b
  6fc342:	41 0f 94 c4          	sete   %r12b
  6fc346:	45 89 c3             	mov    %r8d,%r11d
  6fc349:	41 f7 d3             	not    %r11d
  6fc34c:	41 f6 c3 03          	test   $0x3,%r11b
  6fc350:	41 0f 94 c3          	sete   %r11b
  6fc354:	45 08 e3             	or     %r12b,%r11b
  6fc357:	8b 51 08             	mov    0x8(%rcx),%edx
  6fc35a:	41 89 d4             	mov    %edx,%r12d
  6fc35d:	41 f7 d4             	not    %r12d
  6fc360:	41 f6 c4 03          	test   $0x3,%r12b
  6fc364:	41 0f 94 c4          	sete   %r12b
  6fc368:	8b 71 0c             	mov    0xc(%rcx),%esi
  6fc36b:	48 83 c1 10          	add    $0x10,%rcx
  6fc36f:	21 f2                	and    %esi,%edx
  6fc371:	f7 d6                	not    %esi
  6fc373:	40 f6 c6 03          	test   $0x3,%sil
  6fc377:	40 0f 94 c6          	sete   %sil
  6fc37b:	44 08 e6             	or     %r12b,%sil
  6fc37e:	44 08 de             	or     %r11b,%sil
  6fc381:	40 08 f7             	or     %sil,%dil
  6fc384:	45 21 c2             	and    %r8d,%r10d
  6fc387:	41 21 d2             	and    %edx,%r10d
  6fc38a:	41 f7 d2             	not    %r10d
  6fc38d:	41 f6 c2 03          	test   $0x3,%r10b
  6fc391:	0f 95 c2             	setne  %dl
  6fc394:	08 d0                	or     %dl,%al
  6fc396:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  6fc39a:	75 95                	jne    6fc331 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa61>
  6fc39c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6fc3a1:	4d 85 c0             	test   %r8,%r8
  6fc3a4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc3a9:	74 21                	je     6fc3cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xafc>
  6fc3ab:	45 31 c9             	xor    %r9d,%r9d
  6fc3ae:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  6fc3b2:	83 e2 03             	and    $0x3,%edx
  6fc3b5:	83 fa 03             	cmp    $0x3,%edx
  6fc3b8:	0f 95 c2             	setne  %dl
  6fc3bb:	40 0f 94 c6          	sete   %sil
  6fc3bf:	40 08 f7             	or     %sil,%dil
  6fc3c2:	08 d0                	or     %dl,%al
  6fc3c4:	49 ff c1             	inc    %r9
  6fc3c7:	4d 39 c8             	cmp    %r9,%r8
  6fc3ca:	75 e2                	jne    6fc3ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xade>
  6fc3cc:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fc3d3:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  6fc3d8:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fc3df:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fc3e6:	40 0f b6 cf          	movzbl %dil,%ecx
  6fc3ea:	83 e1 01             	and    $0x1,%ecx
  6fc3ed:	89 0c 24             	mov    %ecx,(%rsp)
  6fc3f0:	44 0f b6 c8          	movzbl %al,%r9d
  6fc3f4:	41 83 e1 01          	and    $0x1,%r9d
  6fc3f8:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc3fd:	4c 89 f9             	mov    %r15,%rcx
  6fc400:	e8 5b 8b 05 00       	call   754f60 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::freeze>
  6fc405:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  6fc40a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6fc40f:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fc416:	00 
  6fc417:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6fc41e:	00 
  6fc41f:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fc424:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  6fc429:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  6fc42d:	75 1d                	jne    6fc44c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb7c>
  6fc42f:	48 89 c5             	mov    %rax,%rbp
  6fc432:	48 c1 ed 08          	shr    $0x8,%rbp
  6fc436:	b9 20 00 00 00       	mov    $0x20,%ecx
  6fc43b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc440:	89 c7                	mov    %eax,%edi
  6fc442:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  6fc447:	e9 bb 0f 00 00       	jmp    6fd407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fc44c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fc451:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fc458:	00 
  6fc459:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6fc460:	00 
  6fc461:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fc468:	00 00 
  6fc46a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  6fc471:	00 00 
  6fc473:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  6fc479:	0f 84 69 0c 00 00    	je     6fd0e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1818>
  6fc47f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc484:	48 85 c0             	test   %rax,%rax
  6fc487:	0f 84 5b 0c 00 00    	je     6fd0e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1818>
  6fc48d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fc492:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc497:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fc49c:	48 c1 e0 02          	shl    $0x2,%rax
  6fc4a0:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fc4a5:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6fc4a9:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  6fc4b0:	00 
  6fc4b1:	45 31 e4             	xor    %r12d,%r12d
  6fc4b4:	48 83 f8 02          	cmp    $0x2,%rax
  6fc4b8:	0f 85 72 0b 00 00    	jne    6fd030 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1760>
  6fc4be:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fc4c3:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fc4c7:	ff 15 bb cf 42 00    	call   *0x42cfbb(%rip)        # b29488 <_DYNAMIC+0x400>
  6fc4cd:	66 85 c0             	test   %ax,%ax
  6fc4d0:	0f 85 ba 12 00 00    	jne    6fd790 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ec0>
  6fc4d6:	49 83 c4 04          	add    $0x4,%r12
  6fc4da:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fc4df:	75 dd                	jne    6fc4be <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xbee>
  6fc4e1:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fc4e6:	48 85 c0             	test   %rax,%rax
  6fc4e9:	0f 84 dd 0d 00 00    	je     6fd2cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19fc>
  6fc4ef:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fc4f4:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  6fc4fb:	00 
  6fc4fc:	48 c1 e0 02          	shl    $0x2,%rax
  6fc500:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  6fc506:	66 0f 6f 0d e2 e2 95 	movdqa -0x6a1d1e(%rip),%xmm1        # 5a7f0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9f0>
  6fc50d:	ff 
  6fc50e:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  6fc512:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  6fc519:	00 00 
  6fc51b:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  6fc522:	00 00 00 00 00 
  6fc527:	48 8d 0d 1a f0 3f 00 	lea    0x3ff01a(%rip),%rcx        # afb548 <__frame_dummy_init_array_entry+0xce0>
  6fc52e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fc533:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  6fc53a:	00 00 80 
  6fc53d:	48 ff c1             	inc    %rcx
  6fc540:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  6fc547:	00 
  6fc548:	48 8d 0d f5 e1 96 ff 	lea    -0x691e0b(%rip),%rcx        # 6a744 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6fc54f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6fc556:	00 
  6fc557:	48 8d 0d 7a f0 3f 00 	lea    0x3ff07a(%rip),%rcx        # afb5d8 <__frame_dummy_init_array_entry+0xd70>
  6fc55e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6fc565:	00 
  6fc566:	48 8d 0d f3 ef 3f 00 	lea    0x3feff3(%rip),%rcx        # afb560 <__frame_dummy_init_array_entry+0xcf8>
  6fc56d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  6fc574:	00 
  6fc575:	48 8d 0d 9f e1 96 ff 	lea    -0x691e61(%rip),%rcx        # 6a71b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6fc57c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  6fc583:	00 
  6fc584:	48 8d 0d 5d e4 3f 00 	lea    0x3fe45d(%rip),%rcx        # afa9e8 <__frame_dummy_init_array_entry+0x180>
  6fc58b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  6fc592:	00 
  6fc593:	31 c9                	xor    %ecx,%ecx
  6fc595:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  6fc59c:	00 00 00 00 00 
  6fc5a1:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  6fc5a8:	00 00 00 00 00 
  6fc5ad:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fc5b4:	00 00 
  6fc5b6:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fc5bb:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fc5c2:	00 
  6fc5c3:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  6fc5c8:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  6fc5cb:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  6fc5d2:	89 e8                	mov    %ebp,%eax
  6fc5d4:	c1 e8 0f             	shr    $0xf,%eax
  6fc5d7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fc5de:	48 39 c6             	cmp    %rax,%rsi
  6fc5e1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fc5e6:	0f 86 7c 11 00 00    	jbe    6fd768 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e98>
  6fc5ec:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  6fc5f3:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  6fc5f7:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  6fc5fb:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fc600:	89 ef                	mov    %ebp,%edi
  6fc602:	ff 15 80 ce 42 00    	call   *0x42ce80(%rip)        # b29488 <_DYNAMIC+0x400>
  6fc608:	89 44 24 08          	mov    %eax,0x8(%rsp)
  6fc60c:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  6fc610:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fc617:	00 
  6fc618:	8b 54 24 08          	mov    0x8(%rsp),%edx
  6fc61c:	66 85 d2             	test   %dx,%dx
  6fc61f:	0f 84 31 01 00 00    	je     6fc756 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xe86>
  6fc625:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  6fc62c:	02 
  6fc62d:	0f 84 6d 0f 00 00    	je     6fd5a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd0>
  6fc633:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6fc638:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6fc63d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6fc644:	00 
  6fc645:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fc64a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  6fc64e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fc655:	00 00 
  6fc657:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  6fc65b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc662:	00 
  6fc663:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fc668:	ff 15 22 ce 42 00    	call   *0x42ce22(%rip)        # b29490 <_DYNAMIC+0x408>
  6fc66e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  6fc675:	00 
  6fc676:	3c ff                	cmp    $0xff,%al
  6fc678:	0f 84 10 0d 00 00    	je     6fd38e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1abe>
  6fc67e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  6fc685:	00 
  6fc686:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  6fc68d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  6fc694:	00 
  6fc695:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  6fc69c:	00 
  6fc69d:	41 8b 78 10          	mov    0x10(%r8),%edi
  6fc6a1:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  6fc6a8:	00 
  6fc6a9:	41 89 79 10          	mov    %edi,0x10(%r9)
  6fc6ad:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  6fc6b2:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  6fc6b7:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  6fc6be:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  6fc6c5:	00 
  6fc6c6:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  6fc6cd:	00 
  6fc6ce:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  6fc6d5:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6fc6d9:	44 0f b7 e9          	movzwl %cx,%r13d
  6fc6dd:	48 8d 05 24 f2 3f 00 	lea    0x3ff224(%rip),%rax        # afb908 <__frame_dummy_init_array_entry+0x10a0>
  6fc6e4:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fc6e9:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  6fc6ed:	0f 84 c7 00 00 00    	je     6fc7ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xeea>
  6fc6f3:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc6f8:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  6fc6ff:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fc704:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  6fc70b:	00 
  6fc70c:	ff 15 86 cd 42 00    	call   *0x42cd86(%rip)        # b29498 <_DYNAMIC+0x410>
  6fc712:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fc717:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fc71c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fc720:	0f 85 ab 0d 00 00    	jne    6fd4d1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c01>
  6fc726:	40 80 ff 01          	cmp    $0x1,%dil
  6fc72a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc72f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fc734:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fc739:	0f 85 9e 08 00 00    	jne    6fcfdd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x170d>
  6fc73f:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fc746:	01 
  6fc747:	b0 01                	mov    $0x1,%al
  6fc749:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fc750:	00 
  6fc751:	e9 4e 08 00 00       	jmp    6fcfa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fc756:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  6fc75c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc761:	0f 84 59 0e 00 00    	je     6fd5c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cf0>
  6fc767:	83 e5 03             	and    $0x3,%ebp
  6fc76a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  6fc76d:	83 f8 02             	cmp    $0x2,%eax
  6fc770:	0f 83 8a 00 00 00    	jae    6fc800 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf30>
  6fc776:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fc77d:	48 8b 38             	mov    (%rax),%rdi
  6fc780:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  6fc786:	48 85 ff             	test   %rdi,%rdi
  6fc789:	0f 84 19 0e 00 00    	je     6fd5a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd8>
  6fc78f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fc794:	ff 15 06 cd 42 00    	call   *0x42cd06(%rip)        # b294a0 <_DYNAMIC+0x418>
  6fc79a:	48 85 c0             	test   %rax,%rax
  6fc79d:	0f 84 05 0e 00 00    	je     6fd5a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd8>
  6fc7a3:	83 fd 01             	cmp    $0x1,%ebp
  6fc7a6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc7ab:	0f 85 a6 00 00 00    	jne    6fc857 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf87>
  6fc7b1:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fc7b5:	e9 a1 00 00 00       	jmp    6fc85b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf8b>
  6fc7ba:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  6fc7c1:	48 8b 00             	mov    (%rax),%rax
  6fc7c4:	48 8d 15 cd ea 95 ff 	lea    -0x6a1533(%rip),%rdx        # 5b298 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1498>
  6fc7cb:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  6fc7cf:	48 01 d1             	add    %rdx,%rcx
  6fc7d2:	48 8d 05 d7 f2 95 ff 	lea    -0x6a0d29(%rip),%rax        # 5bab0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  6fc7d9:	ff e1                	jmp    *%rcx
  6fc7db:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  6fc7e2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fc7e7:	48 39 c6             	cmp    %rax,%rsi
  6fc7ea:	0f 86 3a 0f 00 00    	jbe    6fd72a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e5a>
  6fc7f0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fc7f4:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  6fc7fb:	e9 4e 03 00 00       	jmp    6fcb4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x127e>
  6fc800:	85 ed                	test   %ebp,%ebp
  6fc802:	0f 85 18 0e 00 00    	jne    6fd620 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d50>
  6fc808:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fc80f:	00 
  6fc810:	8b 40 20             	mov    0x20(%rax),%eax
  6fc813:	89 c1                	mov    %eax,%ecx
  6fc815:	83 e1 07             	and    $0x7,%ecx
  6fc818:	83 f9 06             	cmp    $0x6,%ecx
  6fc81b:	74 74                	je     6fc891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc81d:	c1 e8 03             	shr    $0x3,%eax
  6fc820:	74 6f                	je     6fc891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc822:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fc829:	ff c8                	dec    %eax
  6fc82b:	48 39 c6             	cmp    %rax,%rsi
  6fc82e:	0f 86 23 0f 00 00    	jbe    6fd757 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e87>
  6fc834:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  6fc83b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fc83f:	48 c1 e0 04          	shl    $0x4,%rax
  6fc843:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  6fc848:	0f 84 59 0e 00 00    	je     6fd6a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1dd7>
  6fc84e:	48 01 c1             	add    %rax,%rcx
  6fc851:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  6fc855:	eb 13                	jmp    6fc86a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf9a>
  6fc857:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fc85b:	b0 01                	mov    $0x1,%al
  6fc85d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  6fc864:	00 
  6fc865:	48 85 ff             	test   %rdi,%rdi
  6fc868:	74 27                	je     6fc891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc86a:	48 8b 07             	mov    (%rdi),%rax
  6fc86d:	48 d1 e8             	shr    $1,%rax
  6fc870:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fc875:	48 39 d0             	cmp    %rdx,%rax
  6fc878:	75 17                	jne    6fc891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fc87a:	48 83 c7 10          	add    $0x10,%rdi
  6fc87e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fc883:	ff 15 1f cc 42 00    	call   *0x42cc1f(%rip)        # b294a8 <bcmp@GLIBC_2.2.5>
  6fc889:	85 c0                	test   %eax,%eax
  6fc88b:	0f 84 3a 06 00 00    	je     6fcecb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x15fb>
  6fc891:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  6fc896:	4d 85 e4             	test   %r12,%r12
  6fc899:	75 6d                	jne    6fc908 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1038>
  6fc89b:	4c 8d 25 7e e7 95 ff 	lea    -0x6a1882(%rip),%r12        # 5b020 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1220>
  6fc8a2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6fc8a7:	48 85 f6             	test   %rsi,%rsi
  6fc8aa:	74 41                	je     6fc8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x101d>
  6fc8ac:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fc8b3:	00 00 
  6fc8b5:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc8ba:	31 d2                	xor    %edx,%edx
  6fc8bc:	31 c9                	xor    %ecx,%ecx
  6fc8be:	ff 15 ec cb 42 00    	call   *0x42cbec(%rip)        # b294b0 <_DYNAMIC+0x428>
  6fc8c4:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6fc8c9:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  6fc8cd:	0f 85 6e 0e 00 00    	jne    6fd741 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e71>
  6fc8d3:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  6fc8d8:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  6fc8dd:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fc8e2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fc8e7:	ff 15 03 ca 42 00    	call   *0x42ca03(%rip)        # b292f0 <memcpy@GLIBC_2.14>
  6fc8ed:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  6fc8f4:	00 00 
  6fc8f6:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  6fc8fd:	00 00 
  6fc8ff:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  6fc906:	00 00 
  6fc908:	85 ed                	test   %ebp,%ebp
  6fc90a:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  6fc90f:	0f 84 b1 00 00 00    	je     6fc9c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10f6>
  6fc915:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fc91c:	48 8b 38             	mov    (%rax),%rdi
  6fc91f:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  6fc925:	48 85 ff             	test   %rdi,%rdi
  6fc928:	0f 84 2e 0d 00 00    	je     6fd65c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d8c>
  6fc92e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fc933:	ff 15 7f cb 42 00    	call   *0x42cb7f(%rip)        # b294b8 <_DYNAMIC+0x430>
  6fc939:	48 85 c0             	test   %rax,%rax
  6fc93c:	0f 84 1a 0d 00 00    	je     6fd65c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d8c>
  6fc942:	83 fd 01             	cmp    $0x1,%ebp
  6fc945:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc94a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fc94f:	0f 85 4d 01 00 00    	jne    6fcaa2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11d2>
  6fc955:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fc95a:	48 85 c9             	test   %rcx,%rcx
  6fc95d:	74 2c                	je     6fc98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fc95f:	f6 01 01             	testb  $0x1,(%rcx)
  6fc962:	75 27                	jne    6fc98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fc964:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fc968:	f6 c2 01             	test   $0x1,%dl
  6fc96b:	75 1e                	jne    6fc98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fc96d:	ba 02 00 00 00       	mov    $0x2,%edx
  6fc972:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fc978:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fc97f:	00 
  6fc980:	48 f7 da             	neg    %rdx
  6fc983:	71 06                	jno    6fc98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fc985:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fc98b:	48 89 c5             	mov    %rax,%rbp
  6fc98e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fc992:	48 85 ff             	test   %rdi,%rdi
  6fc995:	74 1c                	je     6fc9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fc997:	f6 07 01             	testb  $0x1,(%rdi)
  6fc99a:	75 17                	jne    6fc9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fc99c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fc9a0:	a8 01                	test   $0x1,%al
  6fc9a2:	75 0f                	jne    6fc9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fc9a4:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fc9a8:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fc9ad:	0f 84 50 06 00 00    	je     6fd003 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1733>
  6fc9b3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fc9b8:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fc9bc:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fc9c1:	e9 de 05 00 00       	jmp    6fcfa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fc9c6:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fc9cd:	00 
  6fc9ce:	8b 78 20             	mov    0x20(%rax),%edi
  6fc9d1:	89 f8                	mov    %edi,%eax
  6fc9d3:	83 e0 07             	and    $0x7,%eax
  6fc9d6:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  6fc9dc:	83 f8 06             	cmp    $0x6,%eax
  6fc9df:	0f 84 59 0c 00 00    	je     6fd63e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d6e>
  6fc9e5:	c1 ef 03             	shr    $0x3,%edi
  6fc9e8:	0f 84 50 0c 00 00    	je     6fd63e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d6e>
  6fc9ee:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fc9f5:	ff cf                	dec    %edi
  6fc9f7:	48 39 fe             	cmp    %rdi,%rsi
  6fc9fa:	0f 86 01 0d 00 00    	jbe    6fd701 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e31>
  6fca00:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fca07:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6fca0b:	48 c1 e0 04          	shl    $0x4,%rax
  6fca0f:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fca15:	0f 84 5f 0c 00 00    	je     6fd67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1daa>
  6fca1b:	4d 85 e4             	test   %r12,%r12
  6fca1e:	0f 84 68 0c 00 00    	je     6fd68c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1dbc>
  6fca24:	41 f6 04 24 01       	testb  $0x1,(%r12)
  6fca29:	75 2a                	jne    6fca55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fca2b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  6fca30:	f6 c1 01             	test   $0x1,%cl
  6fca33:	75 20                	jne    6fca55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fca35:	b9 02 00 00 00       	mov    $0x2,%ecx
  6fca3a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  6fca41:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  6fca48:	00 
  6fca49:	48 f7 d9             	neg    %rcx
  6fca4c:	71 07                	jno    6fca55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fca4e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  6fca55:	48 01 c5             	add    %rax,%rbp
  6fca58:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  6fca5c:	f6 07 01             	testb  $0x1,(%rdi)
  6fca5f:	75 17                	jne    6fca78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fca61:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fca65:	a8 01                	test   $0x1,%al
  6fca67:	75 0f                	jne    6fca78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fca69:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fca6d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fca72:	0f 84 7c 05 00 00    	je     6fcff4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1724>
  6fca78:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fca7c:	48 89 ef             	mov    %rbp,%rdi
  6fca7f:	e8 4c 7e ff ff       	call   6f48d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fca84:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fca8b:	ff 
  6fca8c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fca93:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fca98:	e8 e3 89 04 00       	call   745480 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fca9d:	e9 e1 04 00 00       	jmp    6fcf83 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16b3>
  6fcaa2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fcaa7:	48 85 c9             	test   %rcx,%rcx
  6fcaaa:	74 2c                	je     6fcad8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcaac:	f6 01 01             	testb  $0x1,(%rcx)
  6fcaaf:	75 27                	jne    6fcad8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcab1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fcab5:	f6 c2 01             	test   $0x1,%dl
  6fcab8:	75 1e                	jne    6fcad8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcaba:	ba 02 00 00 00       	mov    $0x2,%edx
  6fcabf:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fcac5:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fcacc:	00 
  6fcacd:	48 f7 da             	neg    %rdx
  6fcad0:	71 06                	jno    6fcad8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fcad2:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fcad8:	48 89 c5             	mov    %rax,%rbp
  6fcadb:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fcadf:	48 85 ff             	test   %rdi,%rdi
  6fcae2:	74 1c                	je     6fcb00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcae4:	f6 07 01             	testb  $0x1,(%rdi)
  6fcae7:	75 17                	jne    6fcb00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcae9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcaed:	a8 01                	test   $0x1,%al
  6fcaef:	75 0f                	jne    6fcb00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fcaf1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fcaf5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fcafa:	0f 84 12 05 00 00    	je     6fd012 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1742>
  6fcb00:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fcb05:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fcb09:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fcb0e:	e9 91 04 00 00       	jmp    6fcfa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fcb13:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  6fcb1a:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6fcb1f:	48 39 ce             	cmp    %rcx,%rsi
  6fcb22:	0f 86 eb 0b 00 00    	jbe    6fd713 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e43>
  6fcb28:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  6fcb2f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  6fcb36:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  6fcb3a:	48 39 c6             	cmp    %rax,%rsi
  6fcb3d:	0f 86 d9 0b 00 00    	jbe    6fd71c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e4c>
  6fcb43:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fcb47:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  6fcb4e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  6fcb52:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  6fcb59:	00 
  6fcb5a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  6fcb5e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  6fcb65:	00 
  6fcb66:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  6fcb6a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  6fcb6f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  6fcb73:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  6fcb77:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  6fcb7e:	00 
  6fcb7f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  6fcb86:	00 
  6fcb87:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  6fcb8e:	00 00 
  6fcb90:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  6fcb97:	00 00 
  6fcb99:	eb 1a                	jmp    6fcbb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x12e5>
  6fcb9b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  6fcba2:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  6fcba9:	00 
  6fcbaa:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6fcbaf:	ff 15 0b c8 42 00    	call   *0x42c80b(%rip)        # b293c0 <_DYNAMIC+0x338>
  6fcbb5:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  6fcbbc:	00 
  6fcbbd:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  6fcbc4:	00 
  6fcbc5:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  6fcbcc:	00 
  6fcbcd:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  6fcbd4:	00 
  6fcbd5:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  6fcbdc:	00 00 
  6fcbde:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  6fcbe5:	00 00 
  6fcbe7:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  6fcbee:	00 
  6fcbef:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  6fcbf6:	00 
  6fcbf7:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  6fcbfe:	00 
  6fcbff:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  6fcc06:	00 
  6fcc07:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  6fcc0e:	00 00 
  6fcc10:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  6fcc16:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fcc1d:	00 
  6fcc1e:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  6fcc25:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fcc2a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  6fcc2f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6fcc34:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  6fcc3b:	00 
  6fcc3c:	e8 2f 20 07 00       	call   76ec70 <<gpui::property::Overrides>::update_base>
  6fcc41:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  6fcc48:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  6fcc4f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  6fcc56:	00 
  6fcc57:	48 c1 e5 20          	shl    $0x20,%rbp
  6fcc5b:	48 09 cd             	or     %rcx,%rbp
  6fcc5e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  6fcc65:	00 
  6fcc66:	83 f8 02             	cmp    $0x2,%eax
  6fcc69:	0f 84 ba 08 00 00    	je     6fd529 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c59>
  6fcc6f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  6fcc76:	00 
  6fcc77:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  6fcc7b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  6fcc82:	00 
  6fcc83:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  6fcc87:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  6fcc8b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  6fcc8f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  6fcc93:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  6fcc97:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  6fcc9b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  6fcc9f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6fcca3:	0f 11 02             	movups %xmm0,(%rdx)
  6fcca6:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  6fccad:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  6fccb4:	00 
  6fccb5:	48 89 e8             	mov    %rbp,%rax
  6fccb8:	48 c1 e8 20          	shr    $0x20,%rax
  6fccbc:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  6fccc3:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  6fccca:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  6fccd1:	00 00 
  6fccd3:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  6fccda:	00 00 
  6fccdc:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  6fcce3:	00 
  6fcce4:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  6fcceb:	00 
  6fccec:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  6fccf3:	00 00 
  6fccf5:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  6fccfc:	00 00 
  6fccfe:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  6fcd05:	00 
  6fcd06:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  6fcd0d:	00 
  6fcd0e:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  6fcd15:	00 
  6fcd16:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  6fcd1d:	00 
  6fcd1e:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  6fcd25:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  6fcd2c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  6fcd33:	00 
  6fcd34:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  6fcd3b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  6fcd42:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  6fcd49:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  6fcd50:	00 
  6fcd51:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  6fcd58:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  6fcd5f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  6fcd66:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  6fcd6d:	00 
  6fcd6e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  6fcd75:	00 
  6fcd76:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  6fcd7d:	00 
  6fcd7e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  6fcd85:	01 
  6fcd86:	75 1a                	jne    6fcda2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x14d2>
  6fcd88:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  6fcd8f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  6fcd96:	0f 94 c1             	sete   %cl
  6fcd99:	84 c8                	test   %cl,%al
  6fcd9b:	75 0d                	jne    6fcdaa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x14da>
  6fcd9d:	e9 38 01 00 00       	jmp    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcda2:	a8 01                	test   $0x1,%al
  6fcda4:	0f 85 30 01 00 00    	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcdaa:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  6fcdb1:	00 
  6fcdb2:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  6fcdb9:	01 
  6fcdba:	75 1b                	jne    6fcdd7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1507>
  6fcdbc:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  6fcdc3:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  6fcdca:	0f 94 c1             	sete   %cl
  6fcdcd:	84 c8                	test   %cl,%al
  6fcdcf:	0f 84 05 01 00 00    	je     6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcdd5:	eb 08                	jmp    6fcddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x150f>
  6fcdd7:	a8 01                	test   $0x1,%al
  6fcdd9:	0f 85 fb 00 00 00    	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcddf:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  6fcde6:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  6fcded:	0f 85 e7 00 00 00    	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcdf3:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  6fcdfa:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  6fce01:	0f 85 d3 00 00 00    	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce07:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  6fce0e:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  6fce15:	0f 85 bf 00 00 00    	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce1b:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  6fce22:	00 
  6fce23:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  6fce2a:	0f 85 aa 00 00 00    	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce30:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  6fce37:	00 
  6fce38:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  6fce3f:	0f 85 95 00 00 00    	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce45:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  6fce4c:	00 
  6fce4d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  6fce54:	0f 85 80 00 00 00    	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce5a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  6fce61:	00 
  6fce62:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  6fce69:	75 6f                	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce6b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  6fce72:	00 
  6fce73:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  6fce7a:	00 
  6fce7b:	e8 a0 ef 02 00       	call   72be20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  6fce80:	84 c0                	test   %al,%al
  6fce82:	74 56                	je     6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fce84:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  6fce8b:	00 00 
  6fce8d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  6fce94:	00 00 
  6fce96:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fce9a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fce9e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fcea3:	75 35                	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcea5:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  6fceac:	00 00 
  6fceae:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  6fceb5:	00 00 
  6fceb7:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fcebb:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fcebf:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fcec4:	75 14                	jne    6fceda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fcec6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fcecb:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fced0:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fced5:	e9 08 01 00 00       	jmp    6fcfe2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1712>
  6fceda:	48 8d 05 27 ea 3f 00 	lea    0x3fea27(%rip),%rax        # afb908 <__frame_dummy_init_array_entry+0x10a0>
  6fcee1:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fcee6:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  6fceea:	75 11                	jne    6fcefd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x162d>
  6fceec:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fcef3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fcef8:	e8 83 85 04 00       	call   745480 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fcefd:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  6fcf03:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  6fcf08:	75 5a                	jne    6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fcf0a:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fcf11:	00 
  6fcf12:	8b 40 20             	mov    0x20(%rax),%eax
  6fcf15:	89 c1                	mov    %eax,%ecx
  6fcf17:	83 e1 07             	and    $0x7,%ecx
  6fcf1a:	83 f9 06             	cmp    $0x6,%ecx
  6fcf1d:	74 45                	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fcf1f:	c1 e8 03             	shr    $0x3,%eax
  6fcf22:	74 40                	je     6fcf64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fcf24:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fcf2b:	ff c8                	dec    %eax
  6fcf2d:	48 39 c6             	cmp    %rax,%rsi
  6fcf30:	0f 86 fd 07 00 00    	jbe    6fd733 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e63>
  6fcf36:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fcf3d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fcf41:	48 c1 e0 04          	shl    $0x4,%rax
  6fcf45:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fcf4b:	0f 84 65 07 00 00    	je     6fd6b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1de6>
  6fcf51:	48 01 c5             	add    %rax,%rbp
  6fcf54:	48 89 ef             	mov    %rbp,%rdi
  6fcf57:	e8 74 79 ff ff       	call   6f48d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fcf5c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fcf63:	ff 
  6fcf64:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  6fcf6b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  6fcf72:	4c 89 e6             	mov    %r12,%rsi
  6fcf75:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  6fcf7c:	00 
  6fcf7d:	ff 15 3d c5 42 00    	call   *0x42c53d(%rip)        # b294c0 <_DYNAMIC+0x438>
  6fcf83:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fcf8a:	01 
  6fcf8b:	b0 01                	mov    $0x1,%al
  6fcf8d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fcf94:	00 
  6fcf95:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fcf9a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fcf9f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fcfa4:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  6fcfab:	00 
  6fcfac:	0f 94 c0             	sete   %al
  6fcfaf:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  6fcfb6:	74 0c                	je     6fcfc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16f4>
  6fcfb8:	b0 01                	mov    $0x1,%al
  6fcfba:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fcfc1:	00 
  6fcfc2:	eb 19                	jmp    6fcfdd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x170d>
  6fcfc4:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  6fcfcb:	b0 01                	mov    $0x1,%al
  6fcfcd:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fcfd4:	00 
  6fcfd5:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  6fcfdc:	00 
  6fcfdd:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fcfe2:	48 83 c1 04          	add    $0x4,%rcx
  6fcfe6:	48 39 c8             	cmp    %rcx,%rax
  6fcfe9:	0f 85 cc f5 ff ff    	jne    6fc5bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xceb>
  6fcfef:	e9 ee 02 00 00       	jmp    6fd2e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a12>
  6fcff4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcff8:	ff 15 0a c3 42 00    	call   *0x42c30a(%rip)        # b29308 <_DYNAMIC+0x280>
  6fcffe:	e9 75 fa ff ff       	jmp    6fca78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fd003:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd007:	ff 15 fb c2 42 00    	call   *0x42c2fb(%rip)        # b29308 <_DYNAMIC+0x280>
  6fd00d:	e9 a1 f9 ff ff       	jmp    6fc9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fd012:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd016:	ff 15 ec c2 42 00    	call   *0x42c2ec(%rip)        # b29308 <_DYNAMIC+0x280>
  6fd01c:	e9 df fa ff ff       	jmp    6fcb00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fd021:	49 83 c4 04          	add    $0x4,%r12
  6fd025:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fd02a:	0f 84 b1 f4 ff ff    	je     6fc4e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xc11>
  6fd030:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fd035:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fd039:	ff 15 49 c4 42 00    	call   *0x42c449(%rip)        # b29488 <_DYNAMIC+0x400>
  6fd03f:	66 85 c0             	test   %ax,%ax
  6fd042:	74 dd                	je     6fd021 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1751>
  6fd044:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fd049:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  6fd04e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  6fd055:	00 
  6fd056:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  6fd05b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  6fd05f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fd066:	00 00 
  6fd068:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  6fd06c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fd073:	00 
  6fd074:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fd079:	89 c2                	mov    %eax,%edx
  6fd07b:	ff 15 0f c4 42 00    	call   *0x42c40f(%rip)        # b29490 <_DYNAMIC+0x408>
  6fd081:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  6fd088:	ff 
  6fd089:	75 96                	jne    6fd021 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1751>
  6fd08b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd092:	00 
  6fd093:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd09a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd0a1:	00 
  6fd0a2:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd0a6:	48 09 c5             	or     %rax,%rbp
  6fd0a9:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd0ae:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd0b3:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd0b8:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd0bd:	48 85 f6             	test   %rsi,%rsi
  6fd0c0:	0f 8e 12 02 00 00    	jle    6fd2d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a08>
  6fd0c6:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd0cb:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd0cf:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd0d4:	ff 15 f6 c1 42 00    	call   *0x42c1f6(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fd0da:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd0de:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd0e3:	e9 1f 03 00 00       	jmp    6fd407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fd0e8:	31 ff                	xor    %edi,%edi
  6fd0ea:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd0ef:	48 85 f6             	test   %rsi,%rsi
  6fd0f2:	7e 5c                	jle    6fd150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd0f4:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd0f9:	89 fd                	mov    %edi,%ebp
  6fd0fb:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd100:	ff 15 ca c1 42 00    	call   *0x42c1ca(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fd106:	89 ef                	mov    %ebp,%edi
  6fd108:	eb 46                	jmp    6fd150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd10a:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd111:	00 
  6fd112:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd119:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd120:	00 
  6fd121:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd125:	48 09 c5             	or     %rax,%rbp
  6fd128:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd12d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd132:	e9 99 02 00 00       	jmp    6fd3d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd137:	b0 01                	mov    $0x1,%al
  6fd139:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fd13e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fd145:	48 85 ed             	test   %rbp,%rbp
  6fd148:	0f 85 0e ef ff ff    	jne    6fc05c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x78c>
  6fd14e:	31 ff                	xor    %edi,%edi
  6fd150:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  6fd155:	74 3c                	je     6fd193 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18c3>
  6fd157:	41 80 be 1f 08 00 00 	cmpb   $0x1,0x81f(%r14)
  6fd15e:	01 
  6fd15f:	75 32                	jne    6fd193 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18c3>
  6fd161:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fd166:	4c 89 f6             	mov    %r14,%rsi
  6fd169:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fd170:	00 
  6fd171:	31 c9                	xor    %ecx,%ecx
  6fd173:	e8 98 d7 ff ff       	call   6fa910 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  6fd178:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fd17d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd181:	75 1e                	jne    6fd1a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18d1>
  6fd183:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd18a:	ff ff 
  6fd18c:	31 ff                	xor    %edi,%edi
  6fd18e:	e9 94 02 00 00       	jmp    6fd427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd193:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd19a:	ff ff 
  6fd19c:	e9 86 02 00 00       	jmp    6fd427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd1a1:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fd1a6:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  6fd1ab:	c1 e1 10             	shl    $0x10,%ecx
  6fd1ae:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  6fd1b3:	09 ca                	or     %ecx,%edx
  6fd1b5:	48 c1 e2 20          	shl    $0x20,%rdx
  6fd1b9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd1bd:	48 09 d5             	or     %rdx,%rbp
  6fd1c0:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fd1c7:	00 
  6fd1c8:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd1cf:	00 
  6fd1d0:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fd1d7:	00 00 
  6fd1d9:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  6fd1e0:	00 00 
  6fd1e2:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  6fd1e9:	00 
  6fd1ea:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  6fd1f1:	00 
  6fd1f2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd1f7:	e9 2b 02 00 00       	jmp    6fd427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fd1fc:	b8 20 00 00 00       	mov    $0x20,%eax
  6fd201:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd206:	40 b7 0c             	mov    $0xc,%dil
  6fd209:	31 ed                	xor    %ebp,%ebp
  6fd20b:	4d 89 f8             	mov    %r15,%r8
  6fd20e:	e9 bd 01 00 00       	jmp    6fd3d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd213:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  6fd21a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  6fd21e:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  6fd225:	40 0f 94 c5          	sete   %bpl
  6fd229:	48 ff c0             	inc    %rax
  6fd22c:	0f 84 d5 f0 ff ff    	je     6fc307 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa37>
  6fd232:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  6fd239:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fd240:	00 
  6fd241:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  6fd248:	00 
  6fd249:	ff 15 79 c2 42 00    	call   *0x42c279(%rip)        # b294c8 <_DYNAMIC+0x440>
  6fd24f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  6fd256:	00 
  6fd257:	74 21                	je     6fd27a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19aa>
  6fd259:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  6fd260:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  6fd267:	40 84 ed             	test   %bpl,%bpl
  6fd26a:	0f 84 48 01 00 00    	je     6fd3b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae8>
  6fd270:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  6fd277:	00 
  6fd278:	eb 16                	jmp    6fd290 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19c0>
  6fd27a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fd281:	00 00 00 00 
  6fd285:	31 d2                	xor    %edx,%edx
  6fd287:	40 84 ed             	test   %bpl,%bpl
  6fd28a:	0f 84 28 01 00 00    	je     6fd3b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae8>
  6fd290:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fd295:	4c 89 f6             	mov    %r14,%rsi
  6fd298:	e8 f3 37 00 00       	call   700a90 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::finish_color_slot>
  6fd29d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fd2a2:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fd2a7:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd2ab:	0f 85 8c 00 00 00    	jne    6fd33d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a6d>
  6fd2b1:	40 f6 c7 01          	test   $0x1,%dil
  6fd2b5:	0f 84 f6 00 00 00    	je     6fd3b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae1>
  6fd2bb:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd2c2:	ff ff 
  6fd2c4:	40 b7 02             	mov    $0x2,%dil
  6fd2c7:	e9 04 01 00 00       	jmp    6fd3d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd2cc:	31 ff                	xor    %edi,%edi
  6fd2ce:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd2d3:	e9 12 fe ff ff       	jmp    6fd0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd2d8:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd2dd:	e9 25 01 00 00       	jmp    6fd407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fd2e2:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fd2e9:	00 
  6fd2ea:	34 01                	xor    $0x1,%al
  6fd2ec:	0f b6 c0             	movzbl %al,%eax
  6fd2ef:	31 ff                	xor    %edi,%edi
  6fd2f1:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  6fd2f8:	01 
  6fd2f9:	0f 45 f8             	cmovne %eax,%edi
  6fd2fc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd301:	48 85 c0             	test   %rax,%rax
  6fd304:	0f 84 e0 fd ff ff    	je     6fd0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd30a:	f6 00 01             	testb  $0x1,(%rax)
  6fd30d:	0f 85 d7 fd ff ff    	jne    6fd0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd313:	89 fd                	mov    %edi,%ebp
  6fd315:	48 8b 40 08          	mov    0x8(%rax),%rax
  6fd319:	a8 01                	test   $0x1,%al
  6fd31b:	75 14                	jne    6fd331 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a61>
  6fd31d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd322:	48 83 c0 08          	add    $0x8,%rax
  6fd326:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fd32b:	0f 84 b5 03 00 00    	je     6fd6e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e16>
  6fd331:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd336:	89 ef                	mov    %ebp,%edi
  6fd338:	e9 ad fd ff ff       	jmp    6fd0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd33d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd342:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6fd347:	c1 e0 10             	shl    $0x10,%eax
  6fd34a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6fd34f:	09 c1                	or     %eax,%ecx
  6fd351:	48 c1 e1 20          	shl    $0x20,%rcx
  6fd355:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd359:	48 09 cd             	or     %rcx,%rbp
  6fd35c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fd363:	00 
  6fd364:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd36b:	00 
  6fd36c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fd373:	00 
  6fd374:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  6fd37b:	00 
  6fd37c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fd383:	00 
  6fd384:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6fd38b:	00 
  6fd38c:	eb 42                	jmp    6fd3d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fd38e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fd395:	00 
  6fd396:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fd39d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fd3a4:	00 
  6fd3a5:	48 c1 e5 20          	shl    $0x20,%rbp
  6fd3a9:	48 09 c5             	or     %rax,%rbp
  6fd3ac:	e9 85 01 00 00       	jmp    6fd536 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c66>
  6fd3b1:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  6fd3b8:	48 85 d2             	test   %rdx,%rdx
  6fd3bb:	0f 95 c0             	setne  %al
  6fd3be:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  6fd3c5:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fd3cc:	ff ff 
  6fd3ce:	31 ff                	xor    %edi,%edi
  6fd3d0:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6fd3d5:	48 85 f6             	test   %rsi,%rsi
  6fd3d8:	7e 22                	jle    6fd3fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b2c>
  6fd3da:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd3df:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fd3e4:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd3e8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd3ed:	ff 15 dd be 42 00    	call   *0x42bedd(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fd3f3:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd3f7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fd3fc:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  6fd401:	0f 84 49 fd ff ff    	je     6fd150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fd407:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  6fd40e:	00 
  6fd40f:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  6fd416:	00 
  6fd417:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  6fd41e:	00 
  6fd41f:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  6fd426:	00 
  6fd427:	40 0f b6 c7          	movzbl %dil,%eax
  6fd42b:	48 c1 e5 08          	shl    $0x8,%rbp
  6fd42f:	48 09 c5             	or     %rax,%rbp
  6fd432:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  6fd439:	00 
  6fd43a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fd441:	00 
  6fd442:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  6fd449:	00 00 
  6fd44b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  6fd452:	00 00 
  6fd454:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fd459:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  6fd460:	00 
  6fd461:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  6fd468:	00 
  6fd469:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  6fd470:	00 
  6fd471:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  6fd478:	00 
  6fd479:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  6fd480:	00 00 
  6fd482:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6fd489:	00 
  6fd48a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  6fd491:	00 
  6fd492:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  6fd499:	00 
  6fd49a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  6fd4a1:	00 
  6fd4a2:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  6fd4a9:	00 
  6fd4aa:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fd4b1:	00 
  6fd4b2:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  6fd4b9:	00 
  6fd4ba:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  6fd4c1:	00 
  6fd4c2:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  6fd4c9:	00 
  6fd4ca:	31 ed                	xor    %ebp,%ebp
  6fd4cc:	e9 41 e6 ff ff       	jmp    6fbb12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x242>
  6fd4d1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd4d6:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6fd4db:	c1 e0 10             	shl    $0x10,%eax
  6fd4de:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6fd4e3:	09 c1                	or     %eax,%ecx
  6fd4e5:	48 c1 e1 20          	shl    $0x20,%rcx
  6fd4e9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fd4ed:	48 09 cd             	or     %rcx,%rbp
  6fd4f0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  6fd4f7:	00 
  6fd4f8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fd4fd:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fd504:	00 
  6fd505:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fd50c:	00 00 
  6fd50e:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  6fd515:	00 00 
  6fd517:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fd51e:	00 
  6fd51f:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6fd526:	00 
  6fd527:	eb 17                	jmp    6fd540 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c70>
  6fd529:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  6fd530:	00 00 00 
  6fd533:	48 21 c5             	and    %rax,%rbp
  6fd536:	b8 24 00 00 00       	mov    $0x24,%eax
  6fd53b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd540:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fd545:	48 85 c9             	test   %rcx,%rcx
  6fd548:	0f 84 65 fb ff ff    	je     6fd0b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd54e:	f6 01 01             	testb  $0x1,(%rcx)
  6fd551:	0f 85 5c fb ff ff    	jne    6fd0b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd557:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fd55b:	a8 01                	test   $0x1,%al
  6fd55d:	0f 85 50 fb ff ff    	jne    6fd0b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fd563:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fd567:	48 8d 41 08          	lea    0x8(%rcx),%rax
  6fd56b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fd570:	0f 84 53 01 00 00    	je     6fd6c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1df9>
  6fd576:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd57b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd57f:	e9 34 fb ff ff       	jmp    6fd0b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e8>
  6fd584:	48 8d 3d 9d d7 3f 00 	lea    0x3fd79d(%rip),%rdi        # afad28 <__frame_dummy_init_array_entry+0x4c0>
  6fd58b:	ff 15 ff bd 42 00    	call   *0x42bdff(%rip)        # b29390 <_DYNAMIC+0x308>
  6fd591:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd595:	ff 15 6d bd 42 00    	call   *0x42bd6d(%rip)        # b29308 <_DYNAMIC+0x280>
  6fd59b:	e9 c0 e6 ff ff       	jmp    6fbc60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fd5a0:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  6fd5a6:	eb 3c                	jmp    6fd5e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d14>
  6fd5a8:	48 8d 05 95 d1 96 ff 	lea    -0x692e6b(%rip),%rax        # 6a744 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6fd5af:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6fd5b6:	00 
  6fd5b7:	48 8d 05 d2 df 3f 00 	lea    0x3fdfd2(%rip),%rax        # afb590 <__frame_dummy_init_array_entry+0xd28>
  6fd5be:	eb 1c                	jmp    6fd5dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d0c>
  6fd5c0:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  6fd5c6:	48 8d 05 63 d1 96 ff 	lea    -0x692e9d(%rip),%rax        # 6a730 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b3>
  6fd5cd:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6fd5d4:	00 
  6fd5d5:	48 8d 05 9c df 3f 00 	lea    0x3fdf9c(%rip),%rax        # afb578 <__frame_dummy_init_array_entry+0xd10>
  6fd5dc:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  6fd5e3:	00 
  6fd5e4:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  6fd5eb:	00 
  6fd5ec:	4c 89 e6             	mov    %r12,%rsi
  6fd5ef:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fd5f6:	00 
  6fd5f7:	ff 15 d3 bd 42 00    	call   *0x42bdd3(%rip)        # b293d0 <_DYNAMIC+0x348>
  6fd5fd:	e9 a7 01 00 00       	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd602:	48 8d 3d ff d0 96 ff 	lea    -0x692f01(%rip),%rdi        # 6a708 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348b>
  6fd609:	48 8d 15 08 df 3f 00 	lea    0x3fdf08(%rip),%rdx        # afb518 <__frame_dummy_init_array_entry+0xcb0>
  6fd610:	be 13 00 00 00       	mov    $0x13,%esi
  6fd615:	ff 15 b5 bd 42 00    	call   *0x42bdb5(%rip)        # b293d0 <_DYNAMIC+0x348>
  6fd61b:	e9 89 01 00 00       	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd620:	48 8d 3d 5e d1 96 ff 	lea    -0x692ea2(%rip),%rdi        # 6a785 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3508>
  6fd627:	48 8d 15 c2 df 3f 00 	lea    0x3fdfc2(%rip),%rdx        # afb5f0 <__frame_dummy_init_array_entry+0xd88>
  6fd62e:	be 93 00 00 00       	mov    $0x93,%esi
  6fd633:	ff 15 97 be 42 00    	call   *0x42be97(%rip)        # b294d0 <_DYNAMIC+0x448>
  6fd639:	e9 6b 01 00 00       	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd63e:	48 8d 05 2a d1 96 ff 	lea    -0x692ed6(%rip),%rax        # 6a76f <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34f2>
  6fd645:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  6fd64c:	00 
  6fd64d:	48 8d 05 54 df 3f 00 	lea    0x3fdf54(%rip),%rax        # afb5a8 <__frame_dummy_init_array_entry+0xd40>
  6fd654:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  6fd65b:	00 
  6fd65c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  6fd663:	00 
  6fd664:	4c 89 ee             	mov    %r13,%rsi
  6fd667:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  6fd66e:	00 
  6fd66f:	ff 15 5b bd 42 00    	call   *0x42bd5b(%rip)        # b293d0 <_DYNAMIC+0x348>
  6fd675:	e9 2f 01 00 00       	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd67a:	48 8d 3d 67 d3 3f 00 	lea    0x3fd367(%rip),%rdi        # afa9e8 <__frame_dummy_init_array_entry+0x180>
  6fd681:	ff 15 09 bd 42 00    	call   *0x42bd09(%rip)        # b29390 <_DYNAMIC+0x308>
  6fd687:	e9 1d 01 00 00       	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd68c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd693:	00 00 
  6fd695:	48 8d 3d 24 df 3f 00 	lea    0x3fdf24(%rip),%rdi        # afb5c0 <__frame_dummy_init_array_entry+0xd58>
  6fd69c:	ff 15 ee bc 42 00    	call   *0x42bcee(%rip)        # b29390 <_DYNAMIC+0x308>
  6fd6a2:	e9 02 01 00 00       	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd6a7:	48 8d 05 0a d3 3f 00 	lea    0x3fd30a(%rip),%rax        # afa9b8 <__frame_dummy_init_array_entry+0x150>
  6fd6ae:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  6fd6b5:	00 
  6fd6b6:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  6fd6bd:	00 
  6fd6be:	ff 15 cc bc 42 00    	call   *0x42bccc(%rip)        # b29390 <_DYNAMIC+0x308>
  6fd6c4:	e9 e0 00 00 00       	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd6c9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd6ce:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd6d2:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd6d7:	ff 15 2b bc 42 00    	call   *0x42bc2b(%rip)        # b29308 <_DYNAMIC+0x280>
  6fd6dd:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fd6e1:	e9 d2 f9 ff ff       	jmp    6fd0b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e8>
  6fd6e6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd6eb:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd6ef:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd6f4:	ff 15 0e bc 42 00    	call   *0x42bc0e(%rip)        # b29308 <_DYNAMIC+0x280>
  6fd6fa:	89 ef                	mov    %ebp,%edi
  6fd6fc:	e9 e9 f9 ff ff       	jmp    6fd0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fd701:	48 8d 15 c8 d2 3f 00 	lea    0x3fd2c8(%rip),%rdx        # afa9d0 <__frame_dummy_init_array_entry+0x168>
  6fd708:	ff 15 d2 bc 42 00    	call   *0x42bcd2(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fd70e:	e9 96 00 00 00       	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd713:	48 8d 05 56 d6 3f 00 	lea    0x3fd656(%rip),%rax        # afad70 <__frame_dummy_init_array_entry+0x508>
  6fd71a:	eb 47                	jmp    6fd763 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd71c:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd721:	48 8d 05 60 d6 3f 00 	lea    0x3fd660(%rip),%rax        # afad88 <__frame_dummy_init_array_entry+0x520>
  6fd728:	eb 39                	jmp    6fd763 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd72a:	48 8d 05 27 d6 3f 00 	lea    0x3fd627(%rip),%rax        # afad58 <__frame_dummy_init_array_entry+0x4f0>
  6fd731:	eb 30                	jmp    6fd763 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd733:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd738:	48 8d 05 91 d2 3f 00 	lea    0x3fd291(%rip),%rax        # afa9d0 <__frame_dummy_init_array_entry+0x168>
  6fd73f:	eb 22                	jmp    6fd763 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fd741:	48 85 ff             	test   %rdi,%rdi
  6fd744:	75 34                	jne    6fd77a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1eaa>
  6fd746:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd74d:	00 00 
  6fd74f:	ff 15 83 bd 42 00    	call   *0x42bd83(%rip)        # b294d8 <_DYNAMIC+0x450>
  6fd755:	eb 52                	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd757:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fd75c:	48 8d 05 3d d2 3f 00 	lea    0x3fd23d(%rip),%rax        # afa9a0 <__frame_dummy_init_array_entry+0x138>
  6fd763:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  6fd768:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd76d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  6fd772:	ff 15 68 bc 42 00    	call   *0x42bc68(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fd778:	eb 2f                	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd77a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  6fd77f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fd786:	00 00 
  6fd788:	ff 15 6a bb 42 00    	call   *0x42bb6a(%rip)        # b292f8 <_DYNAMIC+0x270>
  6fd78e:	eb 19                	jmp    6fd7a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fd790:	48 8d 3d 84 cf 96 ff 	lea    -0x69307c(%rip),%rdi        # 6a71b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6fd797:	48 8d 15 92 dd 3f 00 	lea    0x3fdd92(%rip),%rdx        # afb530 <__frame_dummy_init_array_entry+0xcc8>
  6fd79e:	be 15 00 00 00       	mov    $0x15,%esi
  6fd7a3:	ff 15 27 bc 42 00    	call   *0x42bc27(%rip)        # b293d0 <_DYNAMIC+0x348>
  6fd7a9:	0f 0b                	ud2
  6fd7ab:	49 89 c5             	mov    %rax,%r13
  6fd7ae:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd7b3:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fd7b7:	eb 6d                	jmp    6fd826 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd7b9:	49 89 c5             	mov    %rax,%r13
  6fd7bc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fd7c1:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fd7c5:	eb 5f                	jmp    6fd826 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd7c7:	49 89 c5             	mov    %rax,%r13
  6fd7ca:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fd7ce:	eb 56                	jmp    6fd826 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd7d0:	48 89 c3             	mov    %rax,%rbx
  6fd7d3:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fd7da:	00 
  6fd7db:	e8 10 a7 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fd7e0:	48 89 df             	mov    %rbx,%rdi
  6fd7e3:	e8 c8 bc 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fd7e8:	eb 18                	jmp    6fd802 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f32>
  6fd7ea:	eb 16                	jmp    6fd802 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f32>
  6fd7ec:	eb 00                	jmp    6fd7ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f1e>
  6fd7ee:	49 89 c5             	mov    %rax,%r13
  6fd7f1:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fd7f8:	ff 
  6fd7f9:	eb 2b                	jmp    6fd826 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fd7fb:	49 89 c5             	mov    %rax,%r13
  6fd7fe:	eb 4d                	jmp    6fd84d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd800:	eb 21                	jmp    6fd823 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f53>
  6fd802:	49 89 c5             	mov    %rax,%r13
  6fd805:	eb 29                	jmp    6fd830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f60>
  6fd807:	49 89 c5             	mov    %rax,%r13
  6fd80a:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  6fd810:	7e 3b                	jle    6fd84d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd812:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd817:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fd81c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6fd821:	eb 24                	jmp    6fd847 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f77>
  6fd823:	49 89 c5             	mov    %rax,%r13
  6fd826:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fd82b:	e8 10 70 ff ff       	call   6f4840 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  6fd830:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  6fd836:	7e 15                	jle    6fd84d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fd838:	ba 01 00 00 00       	mov    $0x1,%edx
  6fd83d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fd842:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fd847:	ff 15 83 ba 42 00    	call   *0x42ba83(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fd84d:	4c 89 ef             	mov    %r13,%rdi
  6fd850:	ff 15 9a bb 42 00    	call   *0x42bb9a(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fd856:	49 89 c5             	mov    %rax,%r13
  6fd859:	48 89 d5             	mov    %rdx,%rbp
  6fd85c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  6fd863:	00 
  6fd864:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  6fd86b:	00 
  6fd86c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  6fd873:	00 fd ff ff ff 
  6fd878:	4c 89 f7             	mov    %r14,%rdi
  6fd87b:	e8 90 d1 01 00       	call   71aa10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fd880:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  6fd887:	00 0f 00 00 00 
  6fd88c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6fd890:	48 85 c0             	test   %rax,%rax
  6fd893:	74 05                	je     6fd89a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fca>
  6fd895:	4c 89 ef             	mov    %r13,%rdi
  6fd898:	ff d0                	call   *%rax
  6fd89a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6fd89e:	48 85 f6             	test   %rsi,%rsi
  6fd8a1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd8a6:	74 0d                	je     6fd8b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fe5>
  6fd8a8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6fd8ac:	4c 89 ef             	mov    %r13,%rdi
  6fd8af:	ff 15 1b ba 42 00    	call   *0x42ba1b(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fd8b5:	31 ed                	xor    %ebp,%ebp
  6fd8b7:	e9 56 e2 ff ff       	jmp    6fbb12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x242>
  6fd8bc:	48 89 c3             	mov    %rax,%rbx
  6fd8bf:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6fd8c3:	48 85 f6             	test   %rsi,%rsi
  6fd8c6:	74 2b                	je     6fd8f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2023>
  6fd8c8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6fd8cc:	4c 89 ef             	mov    %r13,%rdi
  6fd8cf:	ff 15 fb b9 42 00    	call   *0x42b9fb(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fd8d5:	48 89 df             	mov    %rbx,%rdi
  6fd8d8:	e8 d3 bb 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fd8dd:	ff 15 1d ba 42 00    	call   *0x42ba1d(%rip)        # b29300 <_DYNAMIC+0x278>
  6fd8e3:	48 89 c3             	mov    %rax,%rbx
  6fd8e6:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fd8ed:	00 
  6fd8ee:	e8 1d 74 ff ff       	call   6f4d10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fd8f3:	48 89 df             	mov    %rbx,%rdi
  6fd8f6:	e8 b5 bb 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fd8fb:	ff 15 ff b9 42 00    	call   *0x42b9ff(%rip)        # b29300 <_DYNAMIC+0x278>
  6fd901:	ff 15 f1 ba 42 00    	call   *0x42baf1(%rip)        # b293f8 <_DYNAMIC+0x370>
