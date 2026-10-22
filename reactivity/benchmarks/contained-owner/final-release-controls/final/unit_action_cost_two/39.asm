
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fe8d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>:
  6fe8d0:	55                   	push   %rbp
  6fe8d1:	41 57                	push   %r15
  6fe8d3:	41 56                	push   %r14
  6fe8d5:	41 55                	push   %r13
  6fe8d7:	41 54                	push   %r12
  6fe8d9:	53                   	push   %rbx
  6fe8da:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  6fe8e1:	4d 89 c4             	mov    %r8,%r12
  6fe8e4:	49 89 cf             	mov    %rcx,%r15
  6fe8e7:	49 89 f6             	mov    %rsi,%r14
  6fe8ea:	48 89 fb             	mov    %rdi,%rbx
  6fe8ed:	41 83 38 02          	cmpl   $0x2,(%r8)
  6fe8f1:	75 08                	jne    6fe8fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2b>
  6fe8f3:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fe8fa:	01 
  6fe8fb:	4d 85 ff             	test   %r15,%r15
  6fe8fe:	0f 84 94 01 00 00    	je     6fea98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c8>
  6fe904:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  6fe90b:	01 
  6fe90c:	0f 85 86 01 00 00    	jne    6fea98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c8>
  6fe912:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  6fe919:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  6fe920:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fe924:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  6fe929:	48 0f 44 ce          	cmove  %rsi,%rcx
  6fe92d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  6fe931:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  6fe938:	00 00 
  6fe93a:	74 45                	je     6fe981 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb1>
  6fe93c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  6fe943:	00 00 
  6fe945:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  6fe94c:	00 00 
  6fe94e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fe955:	00 
  6fe956:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  6fe95d:	00 
  6fe95e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6fe965:	00 
  6fe966:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  6fe96a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  6fe96e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fe975:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe979:	88 4b 10             	mov    %cl,0x10(%rbx)
  6fe97c:	e9 5e 03 00 00       	jmp    6fecdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fe981:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  6fe986:	41 83 ff 01          	cmp    $0x1,%r15d
  6fe98a:	0f 85 80 00 00 00    	jne    6fea10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x140>
  6fe990:	48 89 d5             	mov    %rdx,%rbp
  6fe993:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  6fe99a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  6fe9a1:	49 c1 e4 04          	shl    $0x4,%r12
  6fe9a5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6fe9ac:	00 00 00 00 
  6fe9b0:	4d 85 e4             	test   %r12,%r12
  6fe9b3:	0f 84 7a 03 00 00    	je     6fed33 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x463>
  6fe9b9:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  6fe9bd:	48 8b 39             	mov    (%rcx),%rdi
  6fe9c0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fe9c4:	ff 50 18             	call   *0x18(%rax)
  6fe9c7:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  6fe9cb:	4c 89 e9             	mov    %r13,%rcx
  6fe9ce:	4c 39 f8             	cmp    %r15,%rax
  6fe9d1:	75 dd                	jne    6fe9b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xe0>
  6fe9d3:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  6fe9da:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  6fe9e1:	48 c1 e0 03          	shl    $0x3,%rax
  6fe9e5:	31 f6                	xor    %esi,%esi
  6fe9e7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fe9ec:	0f 1f 40 00          	nopl   0x0(%rax)
  6fe9f0:	48 89 f2             	mov    %rsi,%rdx
  6fe9f3:	48 39 f0             	cmp    %rsi,%rax
  6fe9f6:	74 0a                	je     6fea02 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x132>
  6fe9f8:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  6fe9fc:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  6fea00:	75 ee                	jne    6fe9f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x120>
  6fea02:	48 39 d0             	cmp    %rdx,%rax
  6fea05:	0f 95 c1             	setne  %cl
  6fea08:	48 89 ea             	mov    %rbp,%rdx
  6fea0b:	e9 7f 00 00 00       	jmp    6fea8f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1bf>
  6fea10:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fea17:	00 
  6fea18:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  6fea1f:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  6fea26:	49 c1 e5 04          	shl    $0x4,%r13
  6fea2a:	31 ed                	xor    %ebp,%ebp
  6fea2c:	0f 1f 40 00          	nopl   0x0(%rax)
  6fea30:	49 39 ed             	cmp    %rbp,%r13
  6fea33:	0f 84 0e 03 00 00    	je     6fed47 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x477>
  6fea39:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  6fea3d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  6fea42:	4c 89 fe             	mov    %r15,%rsi
  6fea45:	ff 50 30             	call   *0x30(%rax)
  6fea48:	48 83 c5 10          	add    $0x10,%rbp
  6fea4c:	84 c0                	test   %al,%al
  6fea4e:	74 e0                	je     6fea30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160>
  6fea50:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  6fea55:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  6fea5a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  6fea61:	00 
  6fea62:	4c 89 fa             	mov    %r15,%rdx
  6fea65:	ff 50 60             	call   *0x60(%rax)
  6fea68:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  6fea6f:	00 
  6fea70:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fea77:	00 
  6fea78:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fea7c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fea81:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fea88:	00 
  6fea89:	0f 85 c7 fe ff ff    	jne    6fe956 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fea8f:	f6 c1 01             	test   $0x1,%cl
  6fea92:	0f 84 f4 02 00 00    	je     6fed8c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x4bc>
  6fea98:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  6fea9f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6feaa4:	4c 89 f6             	mov    %r14,%rsi
  6feaa7:	31 c9                	xor    %ecx,%ecx
  6feaa9:	e8 62 ee ff ff       	call   6fd910 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  6feaae:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  6feab3:	75 16                	jne    6feacb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fb>
  6feab5:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  6feabc:	00 
  6feabd:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  6feac4:	00 fe ff ff ff 
  6feac9:	eb 41                	jmp    6feb0c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x23c>
  6feacb:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fead2:	00 
  6fead3:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6feada:	00 
  6feadb:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  6feae1:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  6feae8:	00 00 
  6feaea:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  6feaf1:	00 
  6feaf2:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  6feaf9:	00 
  6feafa:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  6feb01:	00 00 
  6feb03:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  6feb0a:	00 00 
  6feb0c:	40 b5 01             	mov    $0x1,%bpl
  6feb0f:	45 31 ff             	xor    %r15d,%r15d
  6feb12:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  6feb19:	00 fe 
  6feb1b:	0f 85 ba 00 00 00    	jne    6febdb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x30b>
  6feb21:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6feb28:	00 
  6feb29:	4c 89 f6             	mov    %r14,%rsi
  6feb2c:	4c 89 e2             	mov    %r12,%rdx
  6feb2f:	e8 2c 40 00 00       	call   702b60 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::reconcile_editing>
  6feb34:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6feb3b:	00 
  6feb3c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  6feb43:	00 00 
  6feb45:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6feb49:	0f 85 61 01 00 00    	jne    6fecb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x3e0>
  6feb4f:	48 8d 35 c2 90 96 ff 	lea    -0x696f3e(%rip),%rsi        # 67c18 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x99b>
  6feb56:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6feb5d:	00 
  6feb5e:	e8 cd d7 02 00       	call   72c330 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6feb63:	84 c0                	test   %al,%al
  6feb65:	74 26                	je     6feb8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2bd>
  6feb67:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6feb6e:	48 85 c0             	test   %rax,%rax
  6feb71:	0f 84 7a 01 00 00    	je     6fecf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x421>
  6feb77:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6feb7e:	00 
  6feb7f:	0f 95 c0             	setne  %al
  6feb82:	44 08 e0             	or     %r12b,%al
  6feb85:	a8 01                	test   $0x1,%al
  6feb87:	0f 84 6e 01 00 00    	je     6fecfb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x42b>
  6feb8d:	48 8d 35 bc 90 96 ff 	lea    -0x696f44(%rip),%rsi        # 67c50 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x9d3>
  6feb94:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6feb9b:	00 
  6feb9c:	e8 8f d7 02 00       	call   72c330 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6feba1:	84 c0                	test   %al,%al
  6feba3:	74 26                	je     6febcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2fb>
  6feba5:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6febac:	48 85 c0             	test   %rax,%rax
  6febaf:	0f 84 a7 01 00 00    	je     6fed5c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x48c>
  6febb5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6febbc:	00 
  6febbd:	0f 95 c0             	setne  %al
  6febc0:	44 08 e0             	or     %r12b,%al
  6febc3:	a8 01                	test   $0x1,%al
  6febc5:	0f 84 9b 01 00 00    	je     6fed66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x496>
  6febcb:	48 89 df             	mov    %rbx,%rdi
  6febce:	4c 89 f6             	mov    %r14,%rsi
  6febd1:	e8 ba a8 02 00       	call   729490 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  6febd6:	e9 04 01 00 00       	jmp    6fecdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6febdb:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  6febe2:	00 
  6febe3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6febea:	00 
  6febeb:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  6febf2:	00 
  6febf3:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  6febfa:	00 
  6febfb:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  6fec02:	00 
  6fec03:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  6fec0a:	00 
  6fec0b:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  6fec12:	00 
  6fec13:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  6fec1a:	00 
  6fec1b:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fec22:	48 85 c0             	test   %rax,%rax
  6fec25:	74 41                	je     6fec68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fec27:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fec2e:	48 85 c0             	test   %rax,%rax
  6fec31:	74 35                	je     6fec68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fec33:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fec37:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  6fec3b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  6fec3f:	80 f9 02             	cmp    $0x2,%cl
  6fec42:	74 24                	je     6fec68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fec44:	f6 07 01             	testb  $0x1,(%rdi)
  6fec47:	75 17                	jne    6fec60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6fec49:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fec4d:	a8 01                	test   $0x1,%al
  6fec4f:	75 0f                	jne    6fec60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6fec51:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fec55:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fec5a:	0f 84 31 19 00 00    	je     700591 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cc1>
  6fec60:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fec67:	01 
  6fec68:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  6fec6f:	00 
  6fec70:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fec77:	00 00 00 00 
  6fec7b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6fec82:	00 
  6fec83:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fec87:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  6fec8e:	00 00 
  6fec90:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  6fec97:	00 00 
  6fec99:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  6feca0:	00 
  6feca1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6feca5:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  6fecaa:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  6fecae:	eb 2f                	jmp    6fecdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fecb0:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  6fecb7:	00 00 
  6fecb9:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  6fecc0:	00 00 
  6fecc2:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6fecc9:	00 
  6fecca:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6fecce:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  6fecd3:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  6fecd8:	48 89 03             	mov    %rax,(%rbx)
  6fecdb:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  6fecdf:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  6fece6:	5b                   	pop    %rbx
  6fece7:	41 5c                	pop    %r12
  6fece9:	41 5d                	pop    %r13
  6feceb:	41 5e                	pop    %r14
  6feced:	41 5f                	pop    %r15
  6fecef:	5d                   	pop    %rbp
  6fecf0:	c3                   	ret
  6fecf1:	41 80 fc 01          	cmp    $0x1,%r12b
  6fecf5:	0f 84 92 fe ff ff    	je     6feb8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2bd>
  6fecfb:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  6fed02:	00 00 
  6fed04:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  6fed0b:	00 
  6fed0c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fed13:	00 
  6fed14:	74 16                	je     6fed2c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x45c>
  6fed16:	84 c0                	test   %al,%al
  6fed18:	0f 84 c7 00 00 00    	je     6fede5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x515>
  6fed1e:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fed25:	ff 
  6fed26:	0f 85 b9 00 00 00    	jne    6fede5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x515>
  6fed2c:	31 c9                	xor    %ecx,%ecx
  6fed2e:	e9 be 00 00 00       	jmp    6fedf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x521>
  6fed33:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fed3a:	00 
  6fed3b:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fed40:	b1 01                	mov    $0x1,%cl
  6fed42:	e9 0f fc ff ff       	jmp    6fe956 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fed47:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fed4e:	00 
  6fed4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fed54:	44 89 f9             	mov    %r15d,%ecx
  6fed57:	e9 fa fb ff ff       	jmp    6fe956 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fed5c:	41 80 fc 01          	cmp    $0x1,%r12b
  6fed60:	0f 84 65 fe ff ff    	je     6febcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2fb>
  6fed66:	40 84 ed             	test   %bpl,%bpl
  6fed69:	0f 85 15 18 00 00    	jne    700584 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cb4>
  6fed6f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  6fed73:	4c 89 f6             	mov    %r14,%rsi
  6fed76:	31 d2                	xor    %edx,%edx
  6fed78:	4c 89 f9             	mov    %r15,%rcx
  6fed7b:	e8 10 53 00 00       	call   704090 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::publish_metadata>
  6fed80:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fed87:	e9 53 ff ff ff       	jmp    6fecdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fed8c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  6fed93:	00 
  6fed94:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  6fed9b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  6feda2:	48 85 c0             	test   %rax,%rax
  6feda5:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fedac:	00 
  6fedad:	0f 84 90 02 00 00    	je     6ff043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fedb3:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  6fedba:	48 85 c9             	test   %rcx,%rcx
  6fedbd:	0f 84 9c 00 00 00    	je     6fee5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x58f>
  6fedc3:	48 89 ca             	mov    %rcx,%rdx
  6fedc6:	48 83 e2 07          	and    $0x7,%rdx
  6fedca:	74 4c                	je     6fee18 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x548>
  6fedcc:	31 f6                	xor    %esi,%esi
  6fedce:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fedd5:	48 ff c6             	inc    %rsi
  6fedd8:	48 39 f2             	cmp    %rsi,%rdx
  6feddb:	75 f1                	jne    6fedce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x4fe>
  6feddd:	48 89 ca             	mov    %rcx,%rdx
  6fede0:	48 29 f2             	sub    %rsi,%rdx
  6fede3:	eb 36                	jmp    6fee1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x54b>
  6fede5:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fedec:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fedf1:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fedf8:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  6fedfc:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fee00:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  6fee05:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  6fee09:	88 43 30             	mov    %al,0x30(%rbx)
  6fee0c:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fee13:	e9 c7 fe ff ff       	jmp    6fecdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fee18:	48 89 ca             	mov    %rcx,%rdx
  6fee1b:	48 83 f9 08          	cmp    $0x8,%rcx
  6fee1f:	72 3e                	jb     6fee5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x58f>
  6fee21:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee28:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee2f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee36:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee3d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee44:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee4b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee52:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee59:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  6fee5d:	75 c2                	jne    6fee21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x551>
  6fee5f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  6fee66:	00 
  6fee67:	0f 84 d6 01 00 00    	je     6ff043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fee6d:	80 38 00             	cmpb   $0x0,(%rax)
  6fee70:	0f 85 cd 01 00 00    	jne    6ff043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fee76:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  6fee7d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  6fee84:	00 
  6fee85:	e8 86 51 04 00       	call   744010 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  6fee8a:	48 85 c0             	test   %rax,%rax
  6fee8d:	0f 84 b0 01 00 00    	je     6ff043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fee93:	48 8b 48 10          	mov    0x10(%rax),%rcx
  6fee97:	48 c1 e1 02          	shl    $0x2,%rcx
  6fee9b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  6fee9f:	ba 04 00 00 00       	mov    $0x4,%edx
  6feea4:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  6feea9:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6feeae:	b8 00 00 00 00       	mov    $0x0,%eax
  6feeb3:	48 0f 45 c1          	cmovne %rcx,%rax
  6feeb7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6feebc:	48 85 c0             	test   %rax,%rax
  6feebf:	0f 84 7e 01 00 00    	je     6ff043 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6feec5:	45 31 ed             	xor    %r13d,%r13d
  6feec8:	48 8b 05 51 a5 42 00 	mov    0x42a551(%rip),%rax        # b29420 <_DYNAMIC+0x398>
  6feecf:	48 83 c0 20          	add    $0x20,%rax
  6feed3:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6feed8:	48 8b 05 49 a5 42 00 	mov    0x42a549(%rip),%rax        # b29428 <_DYNAMIC+0x3a0>
  6feedf:	48 83 c0 20          	add    $0x20,%rax
  6feee3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6feee8:	48 8b 05 41 a5 42 00 	mov    0x42a541(%rip),%rax        # b29430 <_DYNAMIC+0x3a8>
  6feeef:	48 83 c0 20          	add    $0x20,%rax
  6feef3:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6feef8:	48 8b 05 39 a5 42 00 	mov    0x42a539(%rip),%rax        # b29438 <_DYNAMIC+0x3b0>
  6feeff:	48 83 c0 20          	add    $0x20,%rax
  6fef03:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6fef08:	48 8b 05 31 a5 42 00 	mov    0x42a531(%rip),%rax        # b29440 <_DYNAMIC+0x3b8>
  6fef0f:	48 83 c0 20          	add    $0x20,%rax
  6fef13:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fef18:	48 8b 05 29 a5 42 00 	mov    0x42a529(%rip),%rax        # b29448 <_DYNAMIC+0x3c0>
  6fef1f:	48 83 c0 20          	add    $0x20,%rax
  6fef23:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fef2a:	00 
  6fef2b:	48 8b 05 1e a5 42 00 	mov    0x42a51e(%rip),%rax        # b29450 <_DYNAMIC+0x3c8>
  6fef32:	48 83 c0 20          	add    $0x20,%rax
  6fef36:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fef3d:	00 
  6fef3e:	48 8b 05 13 a5 42 00 	mov    0x42a513(%rip),%rax        # b29458 <_DYNAMIC+0x3d0>
  6fef45:	48 83 c0 20          	add    $0x20,%rax
  6fef49:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fef4e:	48 8b 05 0b a5 42 00 	mov    0x42a50b(%rip),%rax        # b29460 <_DYNAMIC+0x3d8>
  6fef55:	48 83 c0 20          	add    $0x20,%rax
  6fef59:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  6fef60:	00 
  6fef61:	48 8b 05 00 a5 42 00 	mov    0x42a500(%rip),%rax        # b29468 <_DYNAMIC+0x3e0>
  6fef68:	48 83 c0 20          	add    $0x20,%rax
  6fef6c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fef71:	48 8b 05 f8 a4 42 00 	mov    0x42a4f8(%rip),%rax        # b29470 <_DYNAMIC+0x3e8>
  6fef78:	48 83 c0 20          	add    $0x20,%rax
  6fef7c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6fef83:	00 
  6fef84:	48 8b 05 ed a4 42 00 	mov    0x42a4ed(%rip),%rax        # b29478 <_DYNAMIC+0x3f0>
  6fef8b:	48 83 c0 20          	add    $0x20,%rax
  6fef8f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fef94:	48 8b 05 e5 a4 42 00 	mov    0x42a4e5(%rip),%rax        # b29480 <_DYNAMIC+0x3f8>
  6fef9b:	48 83 c0 20          	add    $0x20,%rax
  6fef9f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fefa4:	48 8d 2d fd c2 95 ff 	lea    -0x6a3d03(%rip),%rbp        # 5b2a8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x14a8>
  6fefab:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fefb0:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  6fefb4:	ff 15 ce a4 42 00    	call   *0x42a4ce(%rip)        # b29488 <_DYNAMIC+0x400>
  6fefba:	0f b7 c0             	movzwl %ax,%eax
  6fefbd:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  6fefc2:	48 01 e9             	add    %rbp,%rcx
  6fefc5:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fefca:	ff e1                	jmp    *%rcx
  6fefcc:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fefd1:	eb 57                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fefd3:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fefda:	00 
  6fefdb:	eb 4d                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fefdd:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fefe2:	eb 46                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fefe4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fefe9:	eb 3f                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fefeb:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  6feff2:	00 
  6feff3:	eb 35                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6feff5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6feffa:	eb 2e                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6feffc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ff003:	00 
  6ff004:	eb 24                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff006:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6ff00b:	eb 1d                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff00d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6ff012:	eb 16                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff014:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6ff01b:	00 
  6ff01c:	eb 0c                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff01e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6ff023:	eb 05                	jmp    6ff02a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff025:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ff02a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  6ff02e:	0f 85 03 11 00 00    	jne    700137 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1867>
  6ff034:	49 83 c5 04          	add    $0x4,%r13
  6ff038:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  6ff03d:	0f 85 68 ff ff ff    	jne    6fefab <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x6db>
  6ff043:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  6ff04a:	00 00 
  6ff04c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6ff053:	48 85 ed             	test   %rbp,%rbp
  6ff056:	0f 84 f2 10 00 00    	je     70014e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x187e>
  6ff05c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6ff063:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6ff06a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  6ff071:	48 89 c7             	mov    %rax,%rdi
  6ff074:	48 89 e9             	mov    %rbp,%rcx
  6ff077:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  6ff07e:	00 
  6ff07f:	45 89 d3             	mov    %r10d,%r11d
  6ff082:	41 c1 e3 05          	shl    $0x5,%r11d
  6ff086:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  6ff08d:	45 31 c9             	xor    %r9d,%r9d
  6ff090:	4d 39 cb             	cmp    %r9,%r11
  6ff093:	74 28                	je     6ff0bd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7ed>
  6ff095:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  6ff09c:	00 
  6ff09d:	41 0f 97 c4          	seta   %r12b
  6ff0a1:	41 80 dc 00          	sbb    $0x0,%r12b
  6ff0a5:	49 83 c1 20          	add    $0x20,%r9
  6ff0a9:	49 ff c0             	inc    %r8
  6ff0ac:	41 80 fc 01          	cmp    $0x1,%r12b
  6ff0b0:	74 de                	je     6ff090 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7c0>
  6ff0b2:	45 0f b6 d4          	movzbl %r12b,%r10d
  6ff0b6:	45 85 d2             	test   %r10d,%r10d
  6ff0b9:	75 05                	jne    6ff0c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7f0>
  6ff0bb:	eb 1c                	jmp    6ff0d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x809>
  6ff0bd:	4d 89 d0             	mov    %r10,%r8
  6ff0c0:	48 83 ef 01          	sub    $0x1,%rdi
  6ff0c4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff0c9:	0f 82 92 00 00 00    	jb     6ff161 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x891>
  6ff0cf:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  6ff0d6:	00 
  6ff0d7:	eb 9e                	jmp    6ff077 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7a7>
  6ff0d9:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  6ff0df:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff0e4:	75 7b                	jne    6ff161 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x891>
  6ff0e6:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  6ff0eb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff0f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  6ff0f9:	4c 8d 05 08 c4 3f 00 	lea    0x3fc408(%rip),%r8        # afb508 <__frame_dummy_init_array_entry+0xca0>
  6ff100:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff105:	4c 89 f9             	mov    %r15,%rcx
  6ff108:	45 31 c9             	xor    %r9d,%r9d
  6ff10b:	e8 10 65 05 00       	call   755620 <<gpui::source::Sources<unit_action_cost_two::Model>>::freeze>
  6ff110:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6ff115:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  6ff11a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6ff121:	00 
  6ff122:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6ff126:	0f 85 e6 00 00 00    	jne    6ff212 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x942>
  6ff12c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6ff133:	00 
  6ff134:	48 89 cd             	mov    %rcx,%rbp
  6ff137:	48 c1 ed 08          	shr    $0x8,%rbp
  6ff13b:	b8 20 00 00 00       	mov    $0x20,%eax
  6ff140:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6ff145:	89 cf                	mov    %ecx,%edi
  6ff147:	e9 bb 12 00 00       	jmp    700407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6ff14c:	48 89 f9             	mov    %rdi,%rcx
  6ff14f:	48 83 e8 01          	sub    $0x1,%rax
  6ff153:	0f 82 f5 0f 00 00    	jb     70014e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x187e>
  6ff159:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  6ff160:	00 
  6ff161:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  6ff168:	41 89 f8             	mov    %edi,%r8d
  6ff16b:	41 c1 e0 05          	shl    $0x5,%r8d
  6ff16f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  6ff176:	45 31 ed             	xor    %r13d,%r13d
  6ff179:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6ff180:	4d 39 e8             	cmp    %r13,%r8
  6ff183:	74 c7                	je     6ff14c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x87c>
  6ff185:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  6ff18c:	00 
  6ff18d:	41 0f 97 c1          	seta   %r9b
  6ff191:	41 80 d9 00          	sbb    $0x0,%r9b
  6ff195:	49 83 c5 20          	add    $0x20,%r13
  6ff199:	48 ff c1             	inc    %rcx
  6ff19c:	41 80 f9 01          	cmp    $0x1,%r9b
  6ff1a0:	74 de                	je     6ff180 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x8b0>
  6ff1a2:	41 0f b6 f9          	movzbl %r9b,%edi
  6ff1a6:	85 ff                	test   %edi,%edi
  6ff1a8:	75 a5                	jne    6ff14f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x87f>
  6ff1aa:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  6ff1af:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6ff1b3:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff1b8:	74 41                	je     6ff1fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x92b>
  6ff1ba:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff1bf:	48 85 c0             	test   %rax,%rax
  6ff1c2:	0f 84 46 01 00 00    	je     6ff30e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa3e>
  6ff1c8:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff1cd:	48 ff c8             	dec    %rax
  6ff1d0:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  6ff1d7:	ff ff 3f 
  6ff1da:	48 21 c7             	and    %rax,%rdi
  6ff1dd:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  6ff1e1:	45 89 c8             	mov    %r9d,%r8d
  6ff1e4:	41 83 e0 03          	and    $0x3,%r8d
  6ff1e8:	48 83 ff 03          	cmp    $0x3,%rdi
  6ff1ec:	0f 83 25 01 00 00    	jae    6ff317 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa47>
  6ff1f2:	31 c0                	xor    %eax,%eax
  6ff1f4:	31 ff                	xor    %edi,%edi
  6ff1f6:	e9 b0 01 00 00       	jmp    6ff3ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xadb>
  6ff1fb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff202:	4c 8d 05 ff c2 3f 00 	lea    0x3fc2ff(%rip),%r8        # afb508 <__frame_dummy_init_array_entry+0xca0>
  6ff209:	31 c0                	xor    %eax,%eax
  6ff20b:	31 ff                	xor    %edi,%edi
  6ff20d:	e9 d4 01 00 00       	jmp    6ff3e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb16>
  6ff212:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6ff217:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6ff21c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6ff223:	00 
  6ff224:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  6ff22b:	00 
  6ff22c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6ff233:	00 
  6ff234:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  6ff23b:	00 
  6ff23c:	41 83 fd 02          	cmp    $0x2,%r13d
  6ff240:	0f 84 bc 13 00 00    	je     700602 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d32>
  6ff246:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  6ff24b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  6ff252:	00 
  6ff253:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  6ff258:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  6ff25f:	00 
  6ff260:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  6ff267:	00 
  6ff268:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ff26f:	00 
  6ff270:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6ff275:	ba 06 00 00 00       	mov    $0x6,%edx
  6ff27a:	ff 15 10 a2 42 00    	call   *0x42a210(%rip)        # b29490 <_DYNAMIC+0x408>
  6ff280:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  6ff287:	00 
  6ff288:	80 fa ff             	cmp    $0xff,%dl
  6ff28b:	0f 84 79 0e 00 00    	je     70010a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x183a>
  6ff291:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  6ff298:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  6ff29f:	00 
  6ff2a0:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  6ff2a7:	00 
  6ff2a8:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  6ff2af:	00 
  6ff2b0:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  6ff2b7:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  6ff2be:	80 fa 02             	cmp    $0x2,%dl
  6ff2c1:	0f 85 35 0f 00 00    	jne    7001fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x192c>
  6ff2c7:	89 ea                	mov    %ebp,%edx
  6ff2c9:	48 c1 e0 20          	shl    $0x20,%rax
  6ff2cd:	48 09 c8             	or     %rcx,%rax
  6ff2d0:	48 c1 e8 08          	shr    $0x8,%rax
  6ff2d4:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  6ff2db:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  6ff2e2:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  6ff2e9:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  6ff2f0:	00 
  6ff2f1:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  6ff2f8:	00 
  6ff2f9:	41 80 be 1f 07 00 00 	cmpb   $0x0,0x71f(%r14)
  6ff300:	00 
  6ff301:	0f 84 0c 0f 00 00    	je     700213 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1943>
  6ff307:	31 ed                	xor    %ebp,%ebp
  6ff309:	e9 24 0f 00 00       	jmp    700232 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1962>
  6ff30e:	31 ff                	xor    %edi,%edi
  6ff310:	31 c0                	xor    %eax,%eax
  6ff312:	e9 b5 00 00 00       	jmp    6ff3cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xafc>
  6ff317:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6ff31c:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  6ff323:	00 00 80 
  6ff326:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6ff32a:	49 21 c1             	and    %rax,%r9
  6ff32d:	31 c0                	xor    %eax,%eax
  6ff32f:	31 ff                	xor    %edi,%edi
  6ff331:	44 8b 11             	mov    (%rcx),%r10d
  6ff334:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  6ff338:	45 89 d4             	mov    %r10d,%r12d
  6ff33b:	41 f7 d4             	not    %r12d
  6ff33e:	41 f6 c4 03          	test   $0x3,%r12b
  6ff342:	41 0f 94 c4          	sete   %r12b
  6ff346:	45 89 c3             	mov    %r8d,%r11d
  6ff349:	41 f7 d3             	not    %r11d
  6ff34c:	41 f6 c3 03          	test   $0x3,%r11b
  6ff350:	41 0f 94 c3          	sete   %r11b
  6ff354:	45 08 e3             	or     %r12b,%r11b
  6ff357:	8b 51 08             	mov    0x8(%rcx),%edx
  6ff35a:	41 89 d4             	mov    %edx,%r12d
  6ff35d:	41 f7 d4             	not    %r12d
  6ff360:	41 f6 c4 03          	test   $0x3,%r12b
  6ff364:	41 0f 94 c4          	sete   %r12b
  6ff368:	8b 71 0c             	mov    0xc(%rcx),%esi
  6ff36b:	48 83 c1 10          	add    $0x10,%rcx
  6ff36f:	21 f2                	and    %esi,%edx
  6ff371:	f7 d6                	not    %esi
  6ff373:	40 f6 c6 03          	test   $0x3,%sil
  6ff377:	40 0f 94 c6          	sete   %sil
  6ff37b:	44 08 e6             	or     %r12b,%sil
  6ff37e:	44 08 de             	or     %r11b,%sil
  6ff381:	40 08 f7             	or     %sil,%dil
  6ff384:	45 21 c2             	and    %r8d,%r10d
  6ff387:	41 21 d2             	and    %edx,%r10d
  6ff38a:	41 f7 d2             	not    %r10d
  6ff38d:	41 f6 c2 03          	test   $0x3,%r10b
  6ff391:	0f 95 c2             	setne  %dl
  6ff394:	08 d0                	or     %dl,%al
  6ff396:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  6ff39a:	75 95                	jne    6ff331 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa61>
  6ff39c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6ff3a1:	4d 85 c0             	test   %r8,%r8
  6ff3a4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff3a9:	74 21                	je     6ff3cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xafc>
  6ff3ab:	45 31 c9             	xor    %r9d,%r9d
  6ff3ae:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  6ff3b2:	83 e2 03             	and    $0x3,%edx
  6ff3b5:	83 fa 03             	cmp    $0x3,%edx
  6ff3b8:	0f 95 c2             	setne  %dl
  6ff3bb:	40 0f 94 c6          	sete   %sil
  6ff3bf:	40 08 f7             	or     %sil,%dil
  6ff3c2:	08 d0                	or     %dl,%al
  6ff3c4:	49 ff c1             	inc    %r9
  6ff3c7:	4d 39 c8             	cmp    %r9,%r8
  6ff3ca:	75 e2                	jne    6ff3ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xade>
  6ff3cc:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff3d3:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  6ff3d8:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6ff3df:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6ff3e6:	40 0f b6 cf          	movzbl %dil,%ecx
  6ff3ea:	83 e1 01             	and    $0x1,%ecx
  6ff3ed:	89 0c 24             	mov    %ecx,(%rsp)
  6ff3f0:	44 0f b6 c8          	movzbl %al,%r9d
  6ff3f4:	41 83 e1 01          	and    $0x1,%r9d
  6ff3f8:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff3fd:	4c 89 f9             	mov    %r15,%rcx
  6ff400:	e8 1b 62 05 00       	call   755620 <<gpui::source::Sources<unit_action_cost_two::Model>>::freeze>
  6ff405:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  6ff40a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6ff40f:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6ff416:	00 
  6ff417:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6ff41e:	00 
  6ff41f:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6ff424:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  6ff429:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  6ff42d:	75 1d                	jne    6ff44c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb7c>
  6ff42f:	48 89 c5             	mov    %rax,%rbp
  6ff432:	48 c1 ed 08          	shr    $0x8,%rbp
  6ff436:	b9 20 00 00 00       	mov    $0x20,%ecx
  6ff43b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff440:	89 c7                	mov    %eax,%edi
  6ff442:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  6ff447:	e9 bb 0f 00 00       	jmp    700407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6ff44c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6ff451:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6ff458:	00 
  6ff459:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6ff460:	00 
  6ff461:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6ff468:	00 00 
  6ff46a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  6ff471:	00 00 
  6ff473:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  6ff479:	0f 84 69 0c 00 00    	je     7000e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1818>
  6ff47f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff484:	48 85 c0             	test   %rax,%rax
  6ff487:	0f 84 5b 0c 00 00    	je     7000e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1818>
  6ff48d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6ff492:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff497:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff49c:	48 c1 e0 02          	shl    $0x2,%rax
  6ff4a0:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff4a5:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6ff4a9:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  6ff4b0:	00 
  6ff4b1:	45 31 e4             	xor    %r12d,%r12d
  6ff4b4:	48 83 f8 02          	cmp    $0x2,%rax
  6ff4b8:	0f 85 72 0b 00 00    	jne    700030 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1760>
  6ff4be:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6ff4c3:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6ff4c7:	ff 15 bb 9f 42 00    	call   *0x429fbb(%rip)        # b29488 <_DYNAMIC+0x400>
  6ff4cd:	66 85 c0             	test   %ax,%ax
  6ff4d0:	0f 85 ba 12 00 00    	jne    700790 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ec0>
  6ff4d6:	49 83 c4 04          	add    $0x4,%r12
  6ff4da:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6ff4df:	75 dd                	jne    6ff4be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xbee>
  6ff4e1:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff4e6:	48 85 c0             	test   %rax,%rax
  6ff4e9:	0f 84 dd 0d 00 00    	je     7002cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19fc>
  6ff4ef:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff4f4:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  6ff4fb:	00 
  6ff4fc:	48 c1 e0 02          	shl    $0x2,%rax
  6ff500:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  6ff506:	66 0f 6f 0d e2 b2 95 	movdqa -0x6a4d1e(%rip),%xmm1        # 5a7f0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9f0>
  6ff50d:	ff 
  6ff50e:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  6ff512:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  6ff519:	00 00 
  6ff51b:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  6ff522:	00 00 00 00 00 
  6ff527:	48 8d 0d 1a c0 3f 00 	lea    0x3fc01a(%rip),%rcx        # afb548 <__frame_dummy_init_array_entry+0xce0>
  6ff52e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6ff533:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  6ff53a:	00 00 80 
  6ff53d:	48 ff c1             	inc    %rcx
  6ff540:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  6ff547:	00 
  6ff548:	48 8d 0d f5 b1 96 ff 	lea    -0x694e0b(%rip),%rcx        # 6a744 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6ff54f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6ff556:	00 
  6ff557:	48 8d 0d 7a c0 3f 00 	lea    0x3fc07a(%rip),%rcx        # afb5d8 <__frame_dummy_init_array_entry+0xd70>
  6ff55e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6ff565:	00 
  6ff566:	48 8d 0d f3 bf 3f 00 	lea    0x3fbff3(%rip),%rcx        # afb560 <__frame_dummy_init_array_entry+0xcf8>
  6ff56d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  6ff574:	00 
  6ff575:	48 8d 0d 9f b1 96 ff 	lea    -0x694e61(%rip),%rcx        # 6a71b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6ff57c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  6ff583:	00 
  6ff584:	48 8d 0d 5d b4 3f 00 	lea    0x3fb45d(%rip),%rcx        # afa9e8 <__frame_dummy_init_array_entry+0x180>
  6ff58b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  6ff592:	00 
  6ff593:	31 c9                	xor    %ecx,%ecx
  6ff595:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  6ff59c:	00 00 00 00 00 
  6ff5a1:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  6ff5a8:	00 00 00 00 00 
  6ff5ad:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff5b4:	00 00 
  6ff5b6:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6ff5bb:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6ff5c2:	00 
  6ff5c3:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  6ff5c8:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  6ff5cb:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  6ff5d2:	89 e8                	mov    %ebp,%eax
  6ff5d4:	c1 e8 0f             	shr    $0xf,%eax
  6ff5d7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6ff5de:	48 39 c6             	cmp    %rax,%rsi
  6ff5e1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff5e6:	0f 86 7c 11 00 00    	jbe    700768 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e98>
  6ff5ec:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  6ff5f3:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  6ff5f7:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  6ff5fb:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6ff600:	89 ef                	mov    %ebp,%edi
  6ff602:	ff 15 80 9e 42 00    	call   *0x429e80(%rip)        # b29488 <_DYNAMIC+0x400>
  6ff608:	89 44 24 08          	mov    %eax,0x8(%rsp)
  6ff60c:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  6ff610:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6ff617:	00 
  6ff618:	8b 54 24 08          	mov    0x8(%rsp),%edx
  6ff61c:	66 85 d2             	test   %dx,%dx
  6ff61f:	0f 84 31 01 00 00    	je     6ff756 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xe86>
  6ff625:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  6ff62c:	02 
  6ff62d:	0f 84 6d 0f 00 00    	je     7005a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd0>
  6ff633:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6ff638:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6ff63d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6ff644:	00 
  6ff645:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6ff64a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  6ff64e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6ff655:	00 00 
  6ff657:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  6ff65b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ff662:	00 
  6ff663:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6ff668:	ff 15 22 9e 42 00    	call   *0x429e22(%rip)        # b29490 <_DYNAMIC+0x408>
  6ff66e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  6ff675:	00 
  6ff676:	3c ff                	cmp    $0xff,%al
  6ff678:	0f 84 10 0d 00 00    	je     70038e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1abe>
  6ff67e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  6ff685:	00 
  6ff686:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  6ff68d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  6ff694:	00 
  6ff695:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  6ff69c:	00 
  6ff69d:	41 8b 78 10          	mov    0x10(%r8),%edi
  6ff6a1:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  6ff6a8:	00 
  6ff6a9:	41 89 79 10          	mov    %edi,0x10(%r9)
  6ff6ad:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  6ff6b2:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  6ff6b7:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  6ff6be:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  6ff6c5:	00 
  6ff6c6:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  6ff6cd:	00 
  6ff6ce:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  6ff6d5:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6ff6d9:	44 0f b7 e9          	movzwl %cx,%r13d
  6ff6dd:	48 8d 05 24 c2 3f 00 	lea    0x3fc224(%rip),%rax        # afb908 <__frame_dummy_init_array_entry+0x10a0>
  6ff6e4:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6ff6e9:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  6ff6ed:	0f 84 c7 00 00 00    	je     6ff7ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xeea>
  6ff6f3:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff6f8:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  6ff6ff:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6ff704:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  6ff70b:	00 
  6ff70c:	ff 15 86 9d 42 00    	call   *0x429d86(%rip)        # b29498 <_DYNAMIC+0x410>
  6ff712:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6ff717:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6ff71c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6ff720:	0f 85 ab 0d 00 00    	jne    7004d1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c01>
  6ff726:	40 80 ff 01          	cmp    $0x1,%dil
  6ff72a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff72f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ff734:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6ff739:	0f 85 9e 08 00 00    	jne    6fffdd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x170d>
  6ff73f:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6ff746:	01 
  6ff747:	b0 01                	mov    $0x1,%al
  6ff749:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6ff750:	00 
  6ff751:	e9 4e 08 00 00       	jmp    6fffa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ff756:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  6ff75c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff761:	0f 84 59 0e 00 00    	je     7005c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cf0>
  6ff767:	83 e5 03             	and    $0x3,%ebp
  6ff76a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  6ff76d:	83 f8 02             	cmp    $0x2,%eax
  6ff770:	0f 83 8a 00 00 00    	jae    6ff800 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf30>
  6ff776:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6ff77d:	48 8b 38             	mov    (%rax),%rdi
  6ff780:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  6ff786:	48 85 ff             	test   %rdi,%rdi
  6ff789:	0f 84 19 0e 00 00    	je     7005a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd8>
  6ff78f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ff794:	ff 15 06 9d 42 00    	call   *0x429d06(%rip)        # b294a0 <_DYNAMIC+0x418>
  6ff79a:	48 85 c0             	test   %rax,%rax
  6ff79d:	0f 84 05 0e 00 00    	je     7005a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd8>
  6ff7a3:	83 fd 01             	cmp    $0x1,%ebp
  6ff7a6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff7ab:	0f 85 a6 00 00 00    	jne    6ff857 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf87>
  6ff7b1:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6ff7b5:	e9 a1 00 00 00       	jmp    6ff85b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf8b>
  6ff7ba:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  6ff7c1:	48 8b 00             	mov    (%rax),%rax
  6ff7c4:	48 8d 15 15 bb 95 ff 	lea    -0x6a44eb(%rip),%rdx        # 5b2e0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x14e0>
  6ff7cb:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  6ff7cf:	48 01 d1             	add    %rdx,%rcx
  6ff7d2:	48 8d 05 d7 c2 95 ff 	lea    -0x6a3d29(%rip),%rax        # 5bab0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  6ff7d9:	ff e1                	jmp    *%rcx
  6ff7db:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  6ff7e2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6ff7e7:	48 39 c6             	cmp    %rax,%rsi
  6ff7ea:	0f 86 3a 0f 00 00    	jbe    70072a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e5a>
  6ff7f0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6ff7f4:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  6ff7fb:	e9 4e 03 00 00       	jmp    6ffb4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x127e>
  6ff800:	85 ed                	test   %ebp,%ebp
  6ff802:	0f 85 18 0e 00 00    	jne    700620 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d50>
  6ff808:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ff80f:	00 
  6ff810:	8b 40 20             	mov    0x20(%rax),%eax
  6ff813:	89 c1                	mov    %eax,%ecx
  6ff815:	83 e1 07             	and    $0x7,%ecx
  6ff818:	83 f9 06             	cmp    $0x6,%ecx
  6ff81b:	74 74                	je     6ff891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff81d:	c1 e8 03             	shr    $0x3,%eax
  6ff820:	74 6f                	je     6ff891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff822:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6ff829:	ff c8                	dec    %eax
  6ff82b:	48 39 c6             	cmp    %rax,%rsi
  6ff82e:	0f 86 23 0f 00 00    	jbe    700757 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e87>
  6ff834:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  6ff83b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6ff83f:	48 c1 e0 04          	shl    $0x4,%rax
  6ff843:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  6ff848:	0f 84 59 0e 00 00    	je     7006a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1dd7>
  6ff84e:	48 01 c1             	add    %rax,%rcx
  6ff851:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  6ff855:	eb 13                	jmp    6ff86a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf9a>
  6ff857:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6ff85b:	b0 01                	mov    $0x1,%al
  6ff85d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  6ff864:	00 
  6ff865:	48 85 ff             	test   %rdi,%rdi
  6ff868:	74 27                	je     6ff891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff86a:	48 8b 07             	mov    (%rdi),%rax
  6ff86d:	48 d1 e8             	shr    $1,%rax
  6ff870:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6ff875:	48 39 d0             	cmp    %rdx,%rax
  6ff878:	75 17                	jne    6ff891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff87a:	48 83 c7 10          	add    $0x10,%rdi
  6ff87e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6ff883:	ff 15 1f 9c 42 00    	call   *0x429c1f(%rip)        # b294a8 <bcmp@GLIBC_2.2.5>
  6ff889:	85 c0                	test   %eax,%eax
  6ff88b:	0f 84 3a 06 00 00    	je     6ffecb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x15fb>
  6ff891:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  6ff896:	4d 85 e4             	test   %r12,%r12
  6ff899:	75 6d                	jne    6ff908 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1038>
  6ff89b:	4c 8d 25 7e b7 95 ff 	lea    -0x6a4882(%rip),%r12        # 5b020 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1220>
  6ff8a2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6ff8a7:	48 85 f6             	test   %rsi,%rsi
  6ff8aa:	74 41                	je     6ff8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x101d>
  6ff8ac:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff8b3:	00 00 
  6ff8b5:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff8ba:	31 d2                	xor    %edx,%edx
  6ff8bc:	31 c9                	xor    %ecx,%ecx
  6ff8be:	ff 15 ec 9b 42 00    	call   *0x429bec(%rip)        # b294b0 <_DYNAMIC+0x428>
  6ff8c4:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6ff8c9:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  6ff8cd:	0f 85 6e 0e 00 00    	jne    700741 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e71>
  6ff8d3:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  6ff8d8:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  6ff8dd:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6ff8e2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6ff8e7:	ff 15 03 9a 42 00    	call   *0x429a03(%rip)        # b292f0 <memcpy@GLIBC_2.14>
  6ff8ed:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  6ff8f4:	00 00 
  6ff8f6:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  6ff8fd:	00 00 
  6ff8ff:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  6ff906:	00 00 
  6ff908:	85 ed                	test   %ebp,%ebp
  6ff90a:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  6ff90f:	0f 84 b1 00 00 00    	je     6ff9c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10f6>
  6ff915:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6ff91c:	48 8b 38             	mov    (%rax),%rdi
  6ff91f:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  6ff925:	48 85 ff             	test   %rdi,%rdi
  6ff928:	0f 84 2e 0d 00 00    	je     70065c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d8c>
  6ff92e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ff933:	ff 15 7f 9b 42 00    	call   *0x429b7f(%rip)        # b294b8 <_DYNAMIC+0x430>
  6ff939:	48 85 c0             	test   %rax,%rax
  6ff93c:	0f 84 1a 0d 00 00    	je     70065c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d8c>
  6ff942:	83 fd 01             	cmp    $0x1,%ebp
  6ff945:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff94a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6ff94f:	0f 85 4d 01 00 00    	jne    6ffaa2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11d2>
  6ff955:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6ff95a:	48 85 c9             	test   %rcx,%rcx
  6ff95d:	74 2c                	je     6ff98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ff95f:	f6 01 01             	testb  $0x1,(%rcx)
  6ff962:	75 27                	jne    6ff98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ff964:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6ff968:	f6 c2 01             	test   $0x1,%dl
  6ff96b:	75 1e                	jne    6ff98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ff96d:	ba 02 00 00 00       	mov    $0x2,%edx
  6ff972:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6ff978:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6ff97f:	00 
  6ff980:	48 f7 da             	neg    %rdx
  6ff983:	71 06                	jno    6ff98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ff985:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6ff98b:	48 89 c5             	mov    %rax,%rbp
  6ff98e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6ff992:	48 85 ff             	test   %rdi,%rdi
  6ff995:	74 1c                	je     6ff9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ff997:	f6 07 01             	testb  $0x1,(%rdi)
  6ff99a:	75 17                	jne    6ff9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ff99c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ff9a0:	a8 01                	test   $0x1,%al
  6ff9a2:	75 0f                	jne    6ff9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ff9a4:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ff9a8:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ff9ad:	0f 84 50 06 00 00    	je     700003 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1733>
  6ff9b3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ff9b8:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6ff9bc:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ff9c1:	e9 de 05 00 00       	jmp    6fffa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ff9c6:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ff9cd:	00 
  6ff9ce:	8b 78 20             	mov    0x20(%rax),%edi
  6ff9d1:	89 f8                	mov    %edi,%eax
  6ff9d3:	83 e0 07             	and    $0x7,%eax
  6ff9d6:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  6ff9dc:	83 f8 06             	cmp    $0x6,%eax
  6ff9df:	0f 84 59 0c 00 00    	je     70063e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d6e>
  6ff9e5:	c1 ef 03             	shr    $0x3,%edi
  6ff9e8:	0f 84 50 0c 00 00    	je     70063e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d6e>
  6ff9ee:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6ff9f5:	ff cf                	dec    %edi
  6ff9f7:	48 39 fe             	cmp    %rdi,%rsi
  6ff9fa:	0f 86 01 0d 00 00    	jbe    700701 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e31>
  6ffa00:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6ffa07:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6ffa0b:	48 c1 e0 04          	shl    $0x4,%rax
  6ffa0f:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6ffa15:	0f 84 5f 0c 00 00    	je     70067a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1daa>
  6ffa1b:	4d 85 e4             	test   %r12,%r12
  6ffa1e:	0f 84 68 0c 00 00    	je     70068c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1dbc>
  6ffa24:	41 f6 04 24 01       	testb  $0x1,(%r12)
  6ffa29:	75 2a                	jne    6ffa55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffa2b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  6ffa30:	f6 c1 01             	test   $0x1,%cl
  6ffa33:	75 20                	jne    6ffa55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffa35:	b9 02 00 00 00       	mov    $0x2,%ecx
  6ffa3a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  6ffa41:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  6ffa48:	00 
  6ffa49:	48 f7 d9             	neg    %rcx
  6ffa4c:	71 07                	jno    6ffa55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffa4e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  6ffa55:	48 01 c5             	add    %rax,%rbp
  6ffa58:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  6ffa5c:	f6 07 01             	testb  $0x1,(%rdi)
  6ffa5f:	75 17                	jne    6ffa78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6ffa61:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffa65:	a8 01                	test   $0x1,%al
  6ffa67:	75 0f                	jne    6ffa78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6ffa69:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ffa6d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ffa72:	0f 84 7c 05 00 00    	je     6ffff4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1724>
  6ffa78:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6ffa7c:	48 89 ef             	mov    %rbp,%rdi
  6ffa7f:	e8 4c 4e ff ff       	call   6f48d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6ffa84:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6ffa8b:	ff 
  6ffa8c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6ffa93:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ffa98:	e8 e3 59 04 00       	call   745480 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6ffa9d:	e9 e1 04 00 00       	jmp    6fff83 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16b3>
  6ffaa2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6ffaa7:	48 85 c9             	test   %rcx,%rcx
  6ffaaa:	74 2c                	je     6ffad8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffaac:	f6 01 01             	testb  $0x1,(%rcx)
  6ffaaf:	75 27                	jne    6ffad8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffab1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6ffab5:	f6 c2 01             	test   $0x1,%dl
  6ffab8:	75 1e                	jne    6ffad8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffaba:	ba 02 00 00 00       	mov    $0x2,%edx
  6ffabf:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6ffac5:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6ffacc:	00 
  6ffacd:	48 f7 da             	neg    %rdx
  6ffad0:	71 06                	jno    6ffad8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffad2:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6ffad8:	48 89 c5             	mov    %rax,%rbp
  6ffadb:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6ffadf:	48 85 ff             	test   %rdi,%rdi
  6ffae2:	74 1c                	je     6ffb00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffae4:	f6 07 01             	testb  $0x1,(%rdi)
  6ffae7:	75 17                	jne    6ffb00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffae9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffaed:	a8 01                	test   $0x1,%al
  6ffaef:	75 0f                	jne    6ffb00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffaf1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ffaf5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ffafa:	0f 84 12 05 00 00    	je     700012 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1742>
  6ffb00:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ffb05:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6ffb09:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ffb0e:	e9 91 04 00 00       	jmp    6fffa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ffb13:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  6ffb1a:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6ffb1f:	48 39 ce             	cmp    %rcx,%rsi
  6ffb22:	0f 86 eb 0b 00 00    	jbe    700713 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e43>
  6ffb28:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  6ffb2f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  6ffb36:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  6ffb3a:	48 39 c6             	cmp    %rax,%rsi
  6ffb3d:	0f 86 d9 0b 00 00    	jbe    70071c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e4c>
  6ffb43:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6ffb47:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  6ffb4e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  6ffb52:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  6ffb59:	00 
  6ffb5a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  6ffb5e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  6ffb65:	00 
  6ffb66:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  6ffb6a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  6ffb6f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  6ffb73:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  6ffb77:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  6ffb7e:	00 
  6ffb7f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  6ffb86:	00 
  6ffb87:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  6ffb8e:	00 00 
  6ffb90:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  6ffb97:	00 00 
  6ffb99:	eb 1a                	jmp    6ffbb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x12e5>
  6ffb9b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  6ffba2:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  6ffba9:	00 
  6ffbaa:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6ffbaf:	ff 15 0b 98 42 00    	call   *0x42980b(%rip)        # b293c0 <_DYNAMIC+0x338>
  6ffbb5:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  6ffbbc:	00 
  6ffbbd:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  6ffbc4:	00 
  6ffbc5:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  6ffbcc:	00 
  6ffbcd:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  6ffbd4:	00 
  6ffbd5:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  6ffbdc:	00 00 
  6ffbde:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  6ffbe5:	00 00 
  6ffbe7:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  6ffbee:	00 
  6ffbef:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  6ffbf6:	00 
  6ffbf7:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  6ffbfe:	00 
  6ffbff:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  6ffc06:	00 
  6ffc07:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  6ffc0e:	00 00 
  6ffc10:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  6ffc16:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ffc1d:	00 
  6ffc1e:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  6ffc25:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6ffc2a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  6ffc2f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6ffc34:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  6ffc3b:	00 
  6ffc3c:	e8 2f f0 06 00       	call   76ec70 <<gpui::property::Overrides>::update_base>
  6ffc41:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  6ffc48:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  6ffc4f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  6ffc56:	00 
  6ffc57:	48 c1 e5 20          	shl    $0x20,%rbp
  6ffc5b:	48 09 cd             	or     %rcx,%rbp
  6ffc5e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  6ffc65:	00 
  6ffc66:	83 f8 02             	cmp    $0x2,%eax
  6ffc69:	0f 84 ba 08 00 00    	je     700529 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c59>
  6ffc6f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  6ffc76:	00 
  6ffc77:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  6ffc7b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  6ffc82:	00 
  6ffc83:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  6ffc87:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  6ffc8b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  6ffc8f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  6ffc93:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  6ffc97:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  6ffc9b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  6ffc9f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6ffca3:	0f 11 02             	movups %xmm0,(%rdx)
  6ffca6:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  6ffcad:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  6ffcb4:	00 
  6ffcb5:	48 89 e8             	mov    %rbp,%rax
  6ffcb8:	48 c1 e8 20          	shr    $0x20,%rax
  6ffcbc:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  6ffcc3:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  6ffcca:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  6ffcd1:	00 00 
  6ffcd3:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  6ffcda:	00 00 
  6ffcdc:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  6ffce3:	00 
  6ffce4:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  6ffceb:	00 
  6ffcec:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  6ffcf3:	00 00 
  6ffcf5:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  6ffcfc:	00 00 
  6ffcfe:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  6ffd05:	00 
  6ffd06:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  6ffd0d:	00 
  6ffd0e:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  6ffd15:	00 
  6ffd16:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  6ffd1d:	00 
  6ffd1e:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  6ffd25:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  6ffd2c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  6ffd33:	00 
  6ffd34:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  6ffd3b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  6ffd42:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  6ffd49:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  6ffd50:	00 
  6ffd51:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  6ffd58:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  6ffd5f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  6ffd66:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  6ffd6d:	00 
  6ffd6e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  6ffd75:	00 
  6ffd76:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  6ffd7d:	00 
  6ffd7e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  6ffd85:	01 
  6ffd86:	75 1a                	jne    6ffda2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x14d2>
  6ffd88:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  6ffd8f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  6ffd96:	0f 94 c1             	sete   %cl
  6ffd99:	84 c8                	test   %cl,%al
  6ffd9b:	75 0d                	jne    6ffdaa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x14da>
  6ffd9d:	e9 38 01 00 00       	jmp    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffda2:	a8 01                	test   $0x1,%al
  6ffda4:	0f 85 30 01 00 00    	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffdaa:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  6ffdb1:	00 
  6ffdb2:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  6ffdb9:	01 
  6ffdba:	75 1b                	jne    6ffdd7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1507>
  6ffdbc:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  6ffdc3:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  6ffdca:	0f 94 c1             	sete   %cl
  6ffdcd:	84 c8                	test   %cl,%al
  6ffdcf:	0f 84 05 01 00 00    	je     6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffdd5:	eb 08                	jmp    6ffddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x150f>
  6ffdd7:	a8 01                	test   $0x1,%al
  6ffdd9:	0f 85 fb 00 00 00    	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffddf:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  6ffde6:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  6ffded:	0f 85 e7 00 00 00    	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffdf3:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  6ffdfa:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  6ffe01:	0f 85 d3 00 00 00    	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe07:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  6ffe0e:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  6ffe15:	0f 85 bf 00 00 00    	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe1b:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  6ffe22:	00 
  6ffe23:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  6ffe2a:	0f 85 aa 00 00 00    	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe30:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  6ffe37:	00 
  6ffe38:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  6ffe3f:	0f 85 95 00 00 00    	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe45:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  6ffe4c:	00 
  6ffe4d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  6ffe54:	0f 85 80 00 00 00    	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe5a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  6ffe61:	00 
  6ffe62:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  6ffe69:	75 6f                	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe6b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  6ffe72:	00 
  6ffe73:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  6ffe7a:	00 
  6ffe7b:	e8 a0 bf 02 00       	call   72be20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  6ffe80:	84 c0                	test   %al,%al
  6ffe82:	74 56                	je     6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe84:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  6ffe8b:	00 00 
  6ffe8d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  6ffe94:	00 00 
  6ffe96:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6ffe9a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6ffe9e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6ffea3:	75 35                	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffea5:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  6ffeac:	00 00 
  6ffeae:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  6ffeb5:	00 00 
  6ffeb7:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6ffebb:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6ffebf:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6ffec4:	75 14                	jne    6ffeda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffec6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ffecb:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6ffed0:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ffed5:	e9 08 01 00 00       	jmp    6fffe2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1712>
  6ffeda:	48 8d 05 27 ba 3f 00 	lea    0x3fba27(%rip),%rax        # afb908 <__frame_dummy_init_array_entry+0x10a0>
  6ffee1:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6ffee6:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  6ffeea:	75 11                	jne    6ffefd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x162d>
  6ffeec:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6ffef3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ffef8:	e8 83 55 04 00       	call   745480 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6ffefd:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  6fff03:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  6fff08:	75 5a                	jne    6fff64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fff0a:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fff11:	00 
  6fff12:	8b 40 20             	mov    0x20(%rax),%eax
  6fff15:	89 c1                	mov    %eax,%ecx
  6fff17:	83 e1 07             	and    $0x7,%ecx
  6fff1a:	83 f9 06             	cmp    $0x6,%ecx
  6fff1d:	74 45                	je     6fff64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fff1f:	c1 e8 03             	shr    $0x3,%eax
  6fff22:	74 40                	je     6fff64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fff24:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fff2b:	ff c8                	dec    %eax
  6fff2d:	48 39 c6             	cmp    %rax,%rsi
  6fff30:	0f 86 fd 07 00 00    	jbe    700733 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e63>
  6fff36:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fff3d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fff41:	48 c1 e0 04          	shl    $0x4,%rax
  6fff45:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fff4b:	0f 84 65 07 00 00    	je     7006b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1de6>
  6fff51:	48 01 c5             	add    %rax,%rbp
  6fff54:	48 89 ef             	mov    %rbp,%rdi
  6fff57:	e8 74 49 ff ff       	call   6f48d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fff5c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fff63:	ff 
  6fff64:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  6fff6b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  6fff72:	4c 89 e6             	mov    %r12,%rsi
  6fff75:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  6fff7c:	00 
  6fff7d:	ff 15 3d 95 42 00    	call   *0x42953d(%rip)        # b294c0 <_DYNAMIC+0x438>
  6fff83:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fff8a:	01 
  6fff8b:	b0 01                	mov    $0x1,%al
  6fff8d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fff94:	00 
  6fff95:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fff9a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fff9f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fffa4:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  6fffab:	00 
  6fffac:	0f 94 c0             	sete   %al
  6fffaf:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  6fffb6:	74 0c                	je     6fffc4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16f4>
  6fffb8:	b0 01                	mov    $0x1,%al
  6fffba:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fffc1:	00 
  6fffc2:	eb 19                	jmp    6fffdd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x170d>
  6fffc4:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  6fffcb:	b0 01                	mov    $0x1,%al
  6fffcd:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fffd4:	00 
  6fffd5:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  6fffdc:	00 
  6fffdd:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fffe2:	48 83 c1 04          	add    $0x4,%rcx
  6fffe6:	48 39 c8             	cmp    %rcx,%rax
  6fffe9:	0f 85 cc f5 ff ff    	jne    6ff5bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xceb>
  6fffef:	e9 ee 02 00 00       	jmp    7002e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a12>
  6ffff4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffff8:	ff 15 0a 93 42 00    	call   *0x42930a(%rip)        # b29308 <_DYNAMIC+0x280>
  6ffffe:	e9 75 fa ff ff       	jmp    6ffa78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  700003:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700007:	ff 15 fb 92 42 00    	call   *0x4292fb(%rip)        # b29308 <_DYNAMIC+0x280>
  70000d:	e9 a1 f9 ff ff       	jmp    6ff9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  700012:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700016:	ff 15 ec 92 42 00    	call   *0x4292ec(%rip)        # b29308 <_DYNAMIC+0x280>
  70001c:	e9 df fa ff ff       	jmp    6ffb00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  700021:	49 83 c4 04          	add    $0x4,%r12
  700025:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  70002a:	0f 84 b1 f4 ff ff    	je     6ff4e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xc11>
  700030:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  700035:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  700039:	ff 15 49 94 42 00    	call   *0x429449(%rip)        # b29488 <_DYNAMIC+0x400>
  70003f:	66 85 c0             	test   %ax,%ax
  700042:	74 dd                	je     700021 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1751>
  700044:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  700049:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  70004e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  700055:	00 
  700056:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  70005b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  70005f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  700066:	00 00 
  700068:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  70006c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  700073:	00 
  700074:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  700079:	89 c2                	mov    %eax,%edx
  70007b:	ff 15 0f 94 42 00    	call   *0x42940f(%rip)        # b29490 <_DYNAMIC+0x408>
  700081:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  700088:	ff 
  700089:	75 96                	jne    700021 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1751>
  70008b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  700092:	00 
  700093:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70009a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  7000a1:	00 
  7000a2:	48 c1 e5 20          	shl    $0x20,%rbp
  7000a6:	48 09 c5             	or     %rax,%rbp
  7000a9:	b8 24 00 00 00       	mov    $0x24,%eax
  7000ae:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7000b3:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7000b8:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7000bd:	48 85 f6             	test   %rsi,%rsi
  7000c0:	0f 8e 12 02 00 00    	jle    7002d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a08>
  7000c6:	ba 01 00 00 00       	mov    $0x1,%edx
  7000cb:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  7000cf:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7000d4:	ff 15 f6 91 42 00    	call   *0x4291f6(%rip)        # b292d0 <_DYNAMIC+0x248>
  7000da:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7000de:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7000e3:	e9 1f 03 00 00       	jmp    700407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  7000e8:	31 ff                	xor    %edi,%edi
  7000ea:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7000ef:	48 85 f6             	test   %rsi,%rsi
  7000f2:	7e 5c                	jle    700150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  7000f4:	ba 01 00 00 00       	mov    $0x1,%edx
  7000f9:	89 fd                	mov    %edi,%ebp
  7000fb:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  700100:	ff 15 ca 91 42 00    	call   *0x4291ca(%rip)        # b292d0 <_DYNAMIC+0x248>
  700106:	89 ef                	mov    %ebp,%edi
  700108:	eb 46                	jmp    700150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  70010a:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  700111:	00 
  700112:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  700119:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  700120:	00 
  700121:	48 c1 e5 20          	shl    $0x20,%rbp
  700125:	48 09 c5             	or     %rax,%rbp
  700128:	b8 24 00 00 00       	mov    $0x24,%eax
  70012d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700132:	e9 99 02 00 00       	jmp    7003d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  700137:	b0 01                	mov    $0x1,%al
  700139:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  70013e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  700145:	48 85 ed             	test   %rbp,%rbp
  700148:	0f 85 0e ef ff ff    	jne    6ff05c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x78c>
  70014e:	31 ff                	xor    %edi,%edi
  700150:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  700155:	74 3c                	je     700193 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18c3>
  700157:	41 80 be 1f 07 00 00 	cmpb   $0x1,0x71f(%r14)
  70015e:	01 
  70015f:	75 32                	jne    700193 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18c3>
  700161:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  700166:	4c 89 f6             	mov    %r14,%rsi
  700169:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  700170:	00 
  700171:	31 c9                	xor    %ecx,%ecx
  700173:	e8 98 d7 ff ff       	call   6fd910 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  700178:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  70017d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  700181:	75 1e                	jne    7001a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18d1>
  700183:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70018a:	ff ff 
  70018c:	31 ff                	xor    %edi,%edi
  70018e:	e9 94 02 00 00       	jmp    700427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  700193:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70019a:	ff ff 
  70019c:	e9 86 02 00 00       	jmp    700427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  7001a1:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  7001a6:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  7001ab:	c1 e1 10             	shl    $0x10,%ecx
  7001ae:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  7001b3:	09 ca                	or     %ecx,%edx
  7001b5:	48 c1 e2 20          	shl    $0x20,%rdx
  7001b9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  7001bd:	48 09 d5             	or     %rdx,%rbp
  7001c0:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  7001c7:	00 
  7001c8:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  7001cf:	00 
  7001d0:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  7001d7:	00 00 
  7001d9:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  7001e0:	00 00 
  7001e2:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  7001e9:	00 
  7001ea:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  7001f1:	00 
  7001f2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7001f7:	e9 2b 02 00 00       	jmp    700427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  7001fc:	b8 20 00 00 00       	mov    $0x20,%eax
  700201:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700206:	40 b7 0c             	mov    $0xc,%dil
  700209:	31 ed                	xor    %ebp,%ebp
  70020b:	4d 89 f8             	mov    %r15,%r8
  70020e:	e9 bd 01 00 00       	jmp    7003d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  700213:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  70021a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  70021e:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  700225:	40 0f 94 c5          	sete   %bpl
  700229:	48 ff c0             	inc    %rax
  70022c:	0f 84 d5 f0 ff ff    	je     6ff307 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa37>
  700232:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  700239:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  700240:	00 
  700241:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  700248:	00 
  700249:	ff 15 79 92 42 00    	call   *0x429279(%rip)        # b294c8 <_DYNAMIC+0x440>
  70024f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  700256:	00 
  700257:	74 21                	je     70027a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19aa>
  700259:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  700260:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  700267:	40 84 ed             	test   %bpl,%bpl
  70026a:	0f 84 48 01 00 00    	je     7003b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae8>
  700270:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  700277:	00 
  700278:	eb 16                	jmp    700290 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19c0>
  70027a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  700281:	00 00 00 00 
  700285:	31 d2                	xor    %edx,%edx
  700287:	40 84 ed             	test   %bpl,%bpl
  70028a:	0f 84 28 01 00 00    	je     7003b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae8>
  700290:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  700295:	4c 89 f6             	mov    %r14,%rsi
  700298:	e8 e3 0a 00 00       	call   700d80 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::finish_color_slot>
  70029d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  7002a2:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  7002a7:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7002ab:	0f 85 8c 00 00 00    	jne    70033d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a6d>
  7002b1:	40 f6 c7 01          	test   $0x1,%dil
  7002b5:	0f 84 f6 00 00 00    	je     7003b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae1>
  7002bb:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  7002c2:	ff ff 
  7002c4:	40 b7 02             	mov    $0x2,%dil
  7002c7:	e9 04 01 00 00       	jmp    7003d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  7002cc:	31 ff                	xor    %edi,%edi
  7002ce:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7002d3:	e9 12 fe ff ff       	jmp    7000ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  7002d8:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7002dd:	e9 25 01 00 00       	jmp    700407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  7002e2:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  7002e9:	00 
  7002ea:	34 01                	xor    $0x1,%al
  7002ec:	0f b6 c0             	movzbl %al,%eax
  7002ef:	31 ff                	xor    %edi,%edi
  7002f1:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  7002f8:	01 
  7002f9:	0f 45 f8             	cmovne %eax,%edi
  7002fc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  700301:	48 85 c0             	test   %rax,%rax
  700304:	0f 84 e0 fd ff ff    	je     7000ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  70030a:	f6 00 01             	testb  $0x1,(%rax)
  70030d:	0f 85 d7 fd ff ff    	jne    7000ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  700313:	89 fd                	mov    %edi,%ebp
  700315:	48 8b 40 08          	mov    0x8(%rax),%rax
  700319:	a8 01                	test   $0x1,%al
  70031b:	75 14                	jne    700331 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a61>
  70031d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  700322:	48 83 c0 08          	add    $0x8,%rax
  700326:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70032b:	0f 84 b5 03 00 00    	je     7006e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e16>
  700331:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  700336:	89 ef                	mov    %ebp,%edi
  700338:	e9 ad fd ff ff       	jmp    7000ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  70033d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700342:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  700347:	c1 e0 10             	shl    $0x10,%eax
  70034a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  70034f:	09 c1                	or     %eax,%ecx
  700351:	48 c1 e1 20          	shl    $0x20,%rcx
  700355:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  700359:	48 09 cd             	or     %rcx,%rbp
  70035c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  700363:	00 
  700364:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  70036b:	00 
  70036c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  700373:	00 
  700374:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  70037b:	00 
  70037c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  700383:	00 
  700384:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  70038b:	00 
  70038c:	eb 42                	jmp    7003d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  70038e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  700395:	00 
  700396:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70039d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  7003a4:	00 
  7003a5:	48 c1 e5 20          	shl    $0x20,%rbp
  7003a9:	48 09 c5             	or     %rax,%rbp
  7003ac:	e9 85 01 00 00       	jmp    700536 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c66>
  7003b1:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  7003b8:	48 85 d2             	test   %rdx,%rdx
  7003bb:	0f 95 c0             	setne  %al
  7003be:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  7003c5:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  7003cc:	ff ff 
  7003ce:	31 ff                	xor    %edi,%edi
  7003d0:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7003d5:	48 85 f6             	test   %rsi,%rsi
  7003d8:	7e 22                	jle    7003fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b2c>
  7003da:	ba 01 00 00 00       	mov    $0x1,%edx
  7003df:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  7003e4:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  7003e8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  7003ed:	ff 15 dd 8e 42 00    	call   *0x428edd(%rip)        # b292d0 <_DYNAMIC+0x248>
  7003f3:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7003f7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7003fc:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  700401:	0f 84 49 fd ff ff    	je     700150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  700407:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  70040e:	00 
  70040f:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  700416:	00 
  700417:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  70041e:	00 
  70041f:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  700426:	00 
  700427:	40 0f b6 c7          	movzbl %dil,%eax
  70042b:	48 c1 e5 08          	shl    $0x8,%rbp
  70042f:	48 09 c5             	or     %rax,%rbp
  700432:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  700439:	00 
  70043a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  700441:	00 
  700442:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  700449:	00 00 
  70044b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  700452:	00 00 
  700454:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  700459:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  700460:	00 
  700461:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  700468:	00 
  700469:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  700470:	00 
  700471:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  700478:	00 
  700479:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  700480:	00 00 
  700482:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  700489:	00 
  70048a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  700491:	00 
  700492:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  700499:	00 
  70049a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  7004a1:	00 
  7004a2:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  7004a9:	00 
  7004aa:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  7004b1:	00 
  7004b2:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  7004b9:	00 
  7004ba:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  7004c1:	00 
  7004c2:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  7004c9:	00 
  7004ca:	31 ed                	xor    %ebp,%ebp
  7004cc:	e9 41 e6 ff ff       	jmp    6feb12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x242>
  7004d1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7004d6:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  7004db:	c1 e0 10             	shl    $0x10,%eax
  7004de:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  7004e3:	09 c1                	or     %eax,%ecx
  7004e5:	48 c1 e1 20          	shl    $0x20,%rcx
  7004e9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  7004ed:	48 09 cd             	or     %rcx,%rbp
  7004f0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  7004f7:	00 
  7004f8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7004fd:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  700504:	00 
  700505:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  70050c:	00 00 
  70050e:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  700515:	00 00 
  700517:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  70051e:	00 
  70051f:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  700526:	00 
  700527:	eb 17                	jmp    700540 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c70>
  700529:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  700530:	00 00 00 
  700533:	48 21 c5             	and    %rax,%rbp
  700536:	b8 24 00 00 00       	mov    $0x24,%eax
  70053b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700540:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  700545:	48 85 c9             	test   %rcx,%rcx
  700548:	0f 84 65 fb ff ff    	je     7000b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  70054e:	f6 01 01             	testb  $0x1,(%rcx)
  700551:	0f 85 5c fb ff ff    	jne    7000b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  700557:	48 8b 41 08          	mov    0x8(%rcx),%rax
  70055b:	a8 01                	test   $0x1,%al
  70055d:	0f 85 50 fb ff ff    	jne    7000b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  700563:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  700567:	48 8d 41 08          	lea    0x8(%rcx),%rax
  70056b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  700570:	0f 84 53 01 00 00    	je     7006c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1df9>
  700576:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70057b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  70057f:	e9 34 fb ff ff       	jmp    7000b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e8>
  700584:	48 8d 3d 9d a7 3f 00 	lea    0x3fa79d(%rip),%rdi        # afad28 <__frame_dummy_init_array_entry+0x4c0>
  70058b:	ff 15 ff 8d 42 00    	call   *0x428dff(%rip)        # b29390 <_DYNAMIC+0x308>
  700591:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700595:	ff 15 6d 8d 42 00    	call   *0x428d6d(%rip)        # b29308 <_DYNAMIC+0x280>
  70059b:	e9 c0 e6 ff ff       	jmp    6fec60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  7005a0:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  7005a6:	eb 3c                	jmp    7005e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d14>
  7005a8:	48 8d 05 95 a1 96 ff 	lea    -0x695e6b(%rip),%rax        # 6a744 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  7005af:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  7005b6:	00 
  7005b7:	48 8d 05 d2 af 3f 00 	lea    0x3fafd2(%rip),%rax        # afb590 <__frame_dummy_init_array_entry+0xd28>
  7005be:	eb 1c                	jmp    7005dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d0c>
  7005c0:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  7005c6:	48 8d 05 63 a1 96 ff 	lea    -0x695e9d(%rip),%rax        # 6a730 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b3>
  7005cd:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  7005d4:	00 
  7005d5:	48 8d 05 9c af 3f 00 	lea    0x3faf9c(%rip),%rax        # afb578 <__frame_dummy_init_array_entry+0xd10>
  7005dc:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  7005e3:	00 
  7005e4:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  7005eb:	00 
  7005ec:	4c 89 e6             	mov    %r12,%rsi
  7005ef:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  7005f6:	00 
  7005f7:	ff 15 d3 8d 42 00    	call   *0x428dd3(%rip)        # b293d0 <_DYNAMIC+0x348>
  7005fd:	e9 a7 01 00 00       	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700602:	48 8d 3d ff a0 96 ff 	lea    -0x695f01(%rip),%rdi        # 6a708 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348b>
  700609:	48 8d 15 08 af 3f 00 	lea    0x3faf08(%rip),%rdx        # afb518 <__frame_dummy_init_array_entry+0xcb0>
  700610:	be 13 00 00 00       	mov    $0x13,%esi
  700615:	ff 15 b5 8d 42 00    	call   *0x428db5(%rip)        # b293d0 <_DYNAMIC+0x348>
  70061b:	e9 89 01 00 00       	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700620:	48 8d 3d 5e a1 96 ff 	lea    -0x695ea2(%rip),%rdi        # 6a785 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3508>
  700627:	48 8d 15 c2 af 3f 00 	lea    0x3fafc2(%rip),%rdx        # afb5f0 <__frame_dummy_init_array_entry+0xd88>
  70062e:	be 93 00 00 00       	mov    $0x93,%esi
  700633:	ff 15 97 8e 42 00    	call   *0x428e97(%rip)        # b294d0 <_DYNAMIC+0x448>
  700639:	e9 6b 01 00 00       	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70063e:	48 8d 05 2a a1 96 ff 	lea    -0x695ed6(%rip),%rax        # 6a76f <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34f2>
  700645:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  70064c:	00 
  70064d:	48 8d 05 54 af 3f 00 	lea    0x3faf54(%rip),%rax        # afb5a8 <__frame_dummy_init_array_entry+0xd40>
  700654:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  70065b:	00 
  70065c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  700663:	00 
  700664:	4c 89 ee             	mov    %r13,%rsi
  700667:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  70066e:	00 
  70066f:	ff 15 5b 8d 42 00    	call   *0x428d5b(%rip)        # b293d0 <_DYNAMIC+0x348>
  700675:	e9 2f 01 00 00       	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70067a:	48 8d 3d 67 a3 3f 00 	lea    0x3fa367(%rip),%rdi        # afa9e8 <__frame_dummy_init_array_entry+0x180>
  700681:	ff 15 09 8d 42 00    	call   *0x428d09(%rip)        # b29390 <_DYNAMIC+0x308>
  700687:	e9 1d 01 00 00       	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70068c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  700693:	00 00 
  700695:	48 8d 3d 24 af 3f 00 	lea    0x3faf24(%rip),%rdi        # afb5c0 <__frame_dummy_init_array_entry+0xd58>
  70069c:	ff 15 ee 8c 42 00    	call   *0x428cee(%rip)        # b29390 <_DYNAMIC+0x308>
  7006a2:	e9 02 01 00 00       	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  7006a7:	48 8d 05 0a a3 3f 00 	lea    0x3fa30a(%rip),%rax        # afa9b8 <__frame_dummy_init_array_entry+0x150>
  7006ae:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  7006b5:	00 
  7006b6:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  7006bd:	00 
  7006be:	ff 15 cc 8c 42 00    	call   *0x428ccc(%rip)        # b29390 <_DYNAMIC+0x308>
  7006c4:	e9 e0 00 00 00       	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  7006c9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  7006ce:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7006d2:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7006d7:	ff 15 2b 8c 42 00    	call   *0x428c2b(%rip)        # b29308 <_DYNAMIC+0x280>
  7006dd:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7006e1:	e9 d2 f9 ff ff       	jmp    7000b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e8>
  7006e6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  7006eb:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7006ef:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7006f4:	ff 15 0e 8c 42 00    	call   *0x428c0e(%rip)        # b29308 <_DYNAMIC+0x280>
  7006fa:	89 ef                	mov    %ebp,%edi
  7006fc:	e9 e9 f9 ff ff       	jmp    7000ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  700701:	48 8d 15 c8 a2 3f 00 	lea    0x3fa2c8(%rip),%rdx        # afa9d0 <__frame_dummy_init_array_entry+0x168>
  700708:	ff 15 d2 8c 42 00    	call   *0x428cd2(%rip)        # b293e0 <_DYNAMIC+0x358>
  70070e:	e9 96 00 00 00       	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700713:	48 8d 05 56 a6 3f 00 	lea    0x3fa656(%rip),%rax        # afad70 <__frame_dummy_init_array_entry+0x508>
  70071a:	eb 47                	jmp    700763 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  70071c:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  700721:	48 8d 05 60 a6 3f 00 	lea    0x3fa660(%rip),%rax        # afad88 <__frame_dummy_init_array_entry+0x520>
  700728:	eb 39                	jmp    700763 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  70072a:	48 8d 05 27 a6 3f 00 	lea    0x3fa627(%rip),%rax        # afad58 <__frame_dummy_init_array_entry+0x4f0>
  700731:	eb 30                	jmp    700763 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  700733:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  700738:	48 8d 05 91 a2 3f 00 	lea    0x3fa291(%rip),%rax        # afa9d0 <__frame_dummy_init_array_entry+0x168>
  70073f:	eb 22                	jmp    700763 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  700741:	48 85 ff             	test   %rdi,%rdi
  700744:	75 34                	jne    70077a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1eaa>
  700746:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  70074d:	00 00 
  70074f:	ff 15 83 8d 42 00    	call   *0x428d83(%rip)        # b294d8 <_DYNAMIC+0x450>
  700755:	eb 52                	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700757:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  70075c:	48 8d 05 3d a2 3f 00 	lea    0x3fa23d(%rip),%rax        # afa9a0 <__frame_dummy_init_array_entry+0x138>
  700763:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  700768:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70076d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  700772:	ff 15 68 8c 42 00    	call   *0x428c68(%rip)        # b293e0 <_DYNAMIC+0x358>
  700778:	eb 2f                	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70077a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  70077f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  700786:	00 00 
  700788:	ff 15 6a 8b 42 00    	call   *0x428b6a(%rip)        # b292f8 <_DYNAMIC+0x270>
  70078e:	eb 19                	jmp    7007a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700790:	48 8d 3d 84 9f 96 ff 	lea    -0x69607c(%rip),%rdi        # 6a71b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  700797:	48 8d 15 92 ad 3f 00 	lea    0x3fad92(%rip),%rdx        # afb530 <__frame_dummy_init_array_entry+0xcc8>
  70079e:	be 15 00 00 00       	mov    $0x15,%esi
  7007a3:	ff 15 27 8c 42 00    	call   *0x428c27(%rip)        # b293d0 <_DYNAMIC+0x348>
  7007a9:	0f 0b                	ud2
  7007ab:	49 89 c5             	mov    %rax,%r13
  7007ae:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7007b3:	48 89 45 10          	mov    %rax,0x10(%rbp)
  7007b7:	eb 6d                	jmp    700826 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  7007b9:	49 89 c5             	mov    %rax,%r13
  7007bc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7007c1:	48 89 45 08          	mov    %rax,0x8(%rbp)
  7007c5:	eb 5f                	jmp    700826 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  7007c7:	49 89 c5             	mov    %rax,%r13
  7007ca:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  7007ce:	eb 56                	jmp    700826 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  7007d0:	48 89 c3             	mov    %rax,%rbx
  7007d3:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  7007da:	00 
  7007db:	e8 10 77 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7007e0:	48 89 df             	mov    %rbx,%rdi
  7007e3:	e8 c8 8c 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  7007e8:	eb 18                	jmp    700802 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f32>
  7007ea:	eb 16                	jmp    700802 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f32>
  7007ec:	eb 00                	jmp    7007ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f1e>
  7007ee:	49 89 c5             	mov    %rax,%r13
  7007f1:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  7007f8:	ff 
  7007f9:	eb 2b                	jmp    700826 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  7007fb:	49 89 c5             	mov    %rax,%r13
  7007fe:	eb 4d                	jmp    70084d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  700800:	eb 21                	jmp    700823 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f53>
  700802:	49 89 c5             	mov    %rax,%r13
  700805:	eb 29                	jmp    700830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f60>
  700807:	49 89 c5             	mov    %rax,%r13
  70080a:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  700810:	7e 3b                	jle    70084d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  700812:	ba 01 00 00 00       	mov    $0x1,%edx
  700817:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70081c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  700821:	eb 24                	jmp    700847 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f77>
  700823:	49 89 c5             	mov    %rax,%r13
  700826:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70082b:	e8 10 40 ff ff       	call   6f4840 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  700830:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  700836:	7e 15                	jle    70084d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  700838:	ba 01 00 00 00       	mov    $0x1,%edx
  70083d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  700842:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  700847:	ff 15 83 8a 42 00    	call   *0x428a83(%rip)        # b292d0 <_DYNAMIC+0x248>
  70084d:	4c 89 ef             	mov    %r13,%rdi
  700850:	ff 15 9a 8b 42 00    	call   *0x428b9a(%rip)        # b293f0 <_DYNAMIC+0x368>
  700856:	49 89 c5             	mov    %rax,%r13
  700859:	48 89 d5             	mov    %rdx,%rbp
  70085c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  700863:	00 
  700864:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  70086b:	00 
  70086c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  700873:	00 fd ff ff ff 
  700878:	4c 89 f7             	mov    %r14,%rdi
  70087b:	e8 30 8a 02 00       	call   7292b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  700880:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  700887:	00 0f 00 00 00 
  70088c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  700890:	48 85 c0             	test   %rax,%rax
  700893:	74 05                	je     70089a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fca>
  700895:	4c 89 ef             	mov    %r13,%rdi
  700898:	ff d0                	call   *%rax
  70089a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70089e:	48 85 f6             	test   %rsi,%rsi
  7008a1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7008a6:	74 0d                	je     7008b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fe5>
  7008a8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  7008ac:	4c 89 ef             	mov    %r13,%rdi
  7008af:	ff 15 1b 8a 42 00    	call   *0x428a1b(%rip)        # b292d0 <_DYNAMIC+0x248>
  7008b5:	31 ed                	xor    %ebp,%ebp
  7008b7:	e9 56 e2 ff ff       	jmp    6feb12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x242>
  7008bc:	48 89 c3             	mov    %rax,%rbx
  7008bf:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  7008c3:	48 85 f6             	test   %rsi,%rsi
  7008c6:	74 2b                	je     7008f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2023>
  7008c8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  7008cc:	4c 89 ef             	mov    %r13,%rdi
  7008cf:	ff 15 fb 89 42 00    	call   *0x4289fb(%rip)        # b292d0 <_DYNAMIC+0x248>
  7008d5:	48 89 df             	mov    %rbx,%rdi
  7008d8:	e8 d3 8b 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  7008dd:	ff 15 1d 8a 42 00    	call   *0x428a1d(%rip)        # b29300 <_DYNAMIC+0x278>
  7008e3:	48 89 c3             	mov    %rax,%rbx
  7008e6:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  7008ed:	00 
  7008ee:	e8 1d 44 ff ff       	call   6f4d10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  7008f3:	48 89 df             	mov    %rbx,%rdi
  7008f6:	e8 b5 8b 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  7008fb:	ff 15 ff 89 42 00    	call   *0x4289ff(%rip)        # b29300 <_DYNAMIC+0x278>
  700901:	ff 15 f1 8a 42 00    	call   *0x428af1(%rip)        # b293f8 <_DYNAMIC+0x370>
