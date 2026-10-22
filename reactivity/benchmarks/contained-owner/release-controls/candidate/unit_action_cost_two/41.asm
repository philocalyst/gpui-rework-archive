
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fe9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>:
  6fe9d0:	55                   	push   %rbp
  6fe9d1:	41 57                	push   %r15
  6fe9d3:	41 56                	push   %r14
  6fe9d5:	41 55                	push   %r13
  6fe9d7:	41 54                	push   %r12
  6fe9d9:	53                   	push   %rbx
  6fe9da:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  6fe9e1:	4d 89 c4             	mov    %r8,%r12
  6fe9e4:	49 89 cf             	mov    %rcx,%r15
  6fe9e7:	49 89 f6             	mov    %rsi,%r14
  6fe9ea:	48 89 fb             	mov    %rdi,%rbx
  6fe9ed:	41 83 38 02          	cmpl   $0x2,(%r8)
  6fe9f1:	75 08                	jne    6fe9fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2b>
  6fe9f3:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fe9fa:	01 
  6fe9fb:	4d 85 ff             	test   %r15,%r15
  6fe9fe:	0f 84 94 01 00 00    	je     6feb98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c8>
  6fea04:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  6fea0b:	01 
  6fea0c:	0f 85 86 01 00 00    	jne    6feb98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c8>
  6fea12:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  6fea19:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  6fea20:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fea24:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  6fea29:	48 0f 44 ce          	cmove  %rsi,%rcx
  6fea2d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  6fea31:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  6fea38:	00 00 
  6fea3a:	74 45                	je     6fea81 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb1>
  6fea3c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  6fea43:	00 00 
  6fea45:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  6fea4c:	00 00 
  6fea4e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fea55:	00 
  6fea56:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  6fea5d:	00 
  6fea5e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6fea65:	00 
  6fea66:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  6fea6a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  6fea6e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fea75:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fea79:	88 4b 10             	mov    %cl,0x10(%rbx)
  6fea7c:	e9 5e 03 00 00       	jmp    6feddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fea81:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  6fea86:	41 83 ff 01          	cmp    $0x1,%r15d
  6fea8a:	0f 85 80 00 00 00    	jne    6feb10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x140>
  6fea90:	48 89 d5             	mov    %rdx,%rbp
  6fea93:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  6fea9a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  6feaa1:	49 c1 e4 04          	shl    $0x4,%r12
  6feaa5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6feaac:	00 00 00 00 
  6feab0:	4d 85 e4             	test   %r12,%r12
  6feab3:	0f 84 7a 03 00 00    	je     6fee33 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x463>
  6feab9:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  6feabd:	48 8b 39             	mov    (%rcx),%rdi
  6feac0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6feac4:	ff 50 18             	call   *0x18(%rax)
  6feac7:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  6feacb:	4c 89 e9             	mov    %r13,%rcx
  6feace:	4c 39 f8             	cmp    %r15,%rax
  6fead1:	75 dd                	jne    6feab0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xe0>
  6fead3:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  6feada:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  6feae1:	48 c1 e0 03          	shl    $0x3,%rax
  6feae5:	31 f6                	xor    %esi,%esi
  6feae7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6feaec:	0f 1f 40 00          	nopl   0x0(%rax)
  6feaf0:	48 89 f2             	mov    %rsi,%rdx
  6feaf3:	48 39 f0             	cmp    %rsi,%rax
  6feaf6:	74 0a                	je     6feb02 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x132>
  6feaf8:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  6feafc:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  6feb00:	75 ee                	jne    6feaf0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x120>
  6feb02:	48 39 d0             	cmp    %rdx,%rax
  6feb05:	0f 95 c1             	setne  %cl
  6feb08:	48 89 ea             	mov    %rbp,%rdx
  6feb0b:	e9 7f 00 00 00       	jmp    6feb8f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1bf>
  6feb10:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6feb17:	00 
  6feb18:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  6feb1f:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  6feb26:	49 c1 e5 04          	shl    $0x4,%r13
  6feb2a:	31 ed                	xor    %ebp,%ebp
  6feb2c:	0f 1f 40 00          	nopl   0x0(%rax)
  6feb30:	49 39 ed             	cmp    %rbp,%r13
  6feb33:	0f 84 0e 03 00 00    	je     6fee47 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x477>
  6feb39:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  6feb3d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  6feb42:	4c 89 fe             	mov    %r15,%rsi
  6feb45:	ff 50 30             	call   *0x30(%rax)
  6feb48:	48 83 c5 10          	add    $0x10,%rbp
  6feb4c:	84 c0                	test   %al,%al
  6feb4e:	74 e0                	je     6feb30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160>
  6feb50:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  6feb55:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  6feb5a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  6feb61:	00 
  6feb62:	4c 89 fa             	mov    %r15,%rdx
  6feb65:	ff 50 60             	call   *0x60(%rax)
  6feb68:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  6feb6f:	00 
  6feb70:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6feb77:	00 
  6feb78:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6feb7c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6feb81:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6feb88:	00 
  6feb89:	0f 85 c7 fe ff ff    	jne    6fea56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6feb8f:	f6 c1 01             	test   $0x1,%cl
  6feb92:	0f 84 f4 02 00 00    	je     6fee8c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x4bc>
  6feb98:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  6feb9f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6feba4:	4c 89 f6             	mov    %r14,%rsi
  6feba7:	31 c9                	xor    %ecx,%ecx
  6feba9:	e8 62 ee ff ff       	call   6fda10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  6febae:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  6febb3:	75 16                	jne    6febcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fb>
  6febb5:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  6febbc:	00 
  6febbd:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  6febc4:	00 fe ff ff ff 
  6febc9:	eb 41                	jmp    6fec0c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x23c>
  6febcb:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6febd2:	00 
  6febd3:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6febda:	00 
  6febdb:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  6febe1:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  6febe8:	00 00 
  6febea:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  6febf1:	00 
  6febf2:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  6febf9:	00 
  6febfa:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  6fec01:	00 00 
  6fec03:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  6fec0a:	00 00 
  6fec0c:	40 b5 01             	mov    $0x1,%bpl
  6fec0f:	45 31 ff             	xor    %r15d,%r15d
  6fec12:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  6fec19:	00 fe 
  6fec1b:	0f 85 ba 00 00 00    	jne    6fecdb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x30b>
  6fec21:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fec28:	00 
  6fec29:	4c 89 f6             	mov    %r14,%rsi
  6fec2c:	4c 89 e2             	mov    %r12,%rdx
  6fec2f:	e8 2c 40 00 00       	call   702c60 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::reconcile_editing>
  6fec34:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fec3b:	00 
  6fec3c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  6fec43:	00 00 
  6fec45:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fec49:	0f 85 61 01 00 00    	jne    6fedb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x3e0>
  6fec4f:	48 8d 35 32 90 96 ff 	lea    -0x696fce(%rip),%rsi        # 67c88 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x99b>
  6fec56:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fec5d:	00 
  6fec5e:	e8 cd d7 02 00       	call   72c430 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fec63:	84 c0                	test   %al,%al
  6fec65:	74 26                	je     6fec8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2bd>
  6fec67:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fec6e:	48 85 c0             	test   %rax,%rax
  6fec71:	0f 84 7a 01 00 00    	je     6fedf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x421>
  6fec77:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fec7e:	00 
  6fec7f:	0f 95 c0             	setne  %al
  6fec82:	44 08 e0             	or     %r12b,%al
  6fec85:	a8 01                	test   $0x1,%al
  6fec87:	0f 84 6e 01 00 00    	je     6fedfb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x42b>
  6fec8d:	48 8d 35 2c 90 96 ff 	lea    -0x696fd4(%rip),%rsi        # 67cc0 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x9d3>
  6fec94:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fec9b:	00 
  6fec9c:	e8 8f d7 02 00       	call   72c430 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6feca1:	84 c0                	test   %al,%al
  6feca3:	74 26                	je     6feccb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2fb>
  6feca5:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fecac:	48 85 c0             	test   %rax,%rax
  6fecaf:	0f 84 a7 01 00 00    	je     6fee5c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x48c>
  6fecb5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fecbc:	00 
  6fecbd:	0f 95 c0             	setne  %al
  6fecc0:	44 08 e0             	or     %r12b,%al
  6fecc3:	a8 01                	test   $0x1,%al
  6fecc5:	0f 84 9b 01 00 00    	je     6fee66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x496>
  6feccb:	48 89 df             	mov    %rbx,%rdi
  6fecce:	4c 89 f6             	mov    %r14,%rsi
  6fecd1:	e8 ba a8 02 00       	call   729590 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  6fecd6:	e9 04 01 00 00       	jmp    6feddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fecdb:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  6fece2:	00 
  6fece3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fecea:	00 
  6feceb:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  6fecf2:	00 
  6fecf3:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  6fecfa:	00 
  6fecfb:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  6fed02:	00 
  6fed03:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  6fed0a:	00 
  6fed0b:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  6fed12:	00 
  6fed13:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  6fed1a:	00 
  6fed1b:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fed22:	48 85 c0             	test   %rax,%rax
  6fed25:	74 41                	je     6fed68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fed27:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fed2e:	48 85 c0             	test   %rax,%rax
  6fed31:	74 35                	je     6fed68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fed33:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fed37:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  6fed3b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  6fed3f:	80 f9 02             	cmp    $0x2,%cl
  6fed42:	74 24                	je     6fed68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fed44:	f6 07 01             	testb  $0x1,(%rdi)
  6fed47:	75 17                	jne    6fed60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6fed49:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fed4d:	a8 01                	test   $0x1,%al
  6fed4f:	75 0f                	jne    6fed60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6fed51:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fed55:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fed5a:	0f 84 31 19 00 00    	je     700691 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cc1>
  6fed60:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fed67:	01 
  6fed68:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  6fed6f:	00 
  6fed70:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fed77:	00 00 00 00 
  6fed7b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6fed82:	00 
  6fed83:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fed87:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  6fed8e:	00 00 
  6fed90:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  6fed97:	00 00 
  6fed99:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  6feda0:	00 
  6feda1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6feda5:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  6fedaa:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  6fedae:	eb 2f                	jmp    6feddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fedb0:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  6fedb7:	00 00 
  6fedb9:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  6fedc0:	00 00 
  6fedc2:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6fedc9:	00 
  6fedca:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6fedce:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  6fedd3:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  6fedd8:	48 89 03             	mov    %rax,(%rbx)
  6feddb:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  6feddf:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  6fede6:	5b                   	pop    %rbx
  6fede7:	41 5c                	pop    %r12
  6fede9:	41 5d                	pop    %r13
  6fedeb:	41 5e                	pop    %r14
  6feded:	41 5f                	pop    %r15
  6fedef:	5d                   	pop    %rbp
  6fedf0:	c3                   	ret
  6fedf1:	41 80 fc 01          	cmp    $0x1,%r12b
  6fedf5:	0f 84 92 fe ff ff    	je     6fec8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2bd>
  6fedfb:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  6fee02:	00 00 
  6fee04:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  6fee0b:	00 
  6fee0c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fee13:	00 
  6fee14:	74 16                	je     6fee2c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x45c>
  6fee16:	84 c0                	test   %al,%al
  6fee18:	0f 84 c7 00 00 00    	je     6feee5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x515>
  6fee1e:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fee25:	ff 
  6fee26:	0f 85 b9 00 00 00    	jne    6feee5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x515>
  6fee2c:	31 c9                	xor    %ecx,%ecx
  6fee2e:	e9 be 00 00 00       	jmp    6feef1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x521>
  6fee33:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fee3a:	00 
  6fee3b:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fee40:	b1 01                	mov    $0x1,%cl
  6fee42:	e9 0f fc ff ff       	jmp    6fea56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fee47:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fee4e:	00 
  6fee4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fee54:	44 89 f9             	mov    %r15d,%ecx
  6fee57:	e9 fa fb ff ff       	jmp    6fea56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fee5c:	41 80 fc 01          	cmp    $0x1,%r12b
  6fee60:	0f 84 65 fe ff ff    	je     6feccb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2fb>
  6fee66:	40 84 ed             	test   %bpl,%bpl
  6fee69:	0f 85 15 18 00 00    	jne    700684 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cb4>
  6fee6f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  6fee73:	4c 89 f6             	mov    %r14,%rsi
  6fee76:	31 d2                	xor    %edx,%edx
  6fee78:	4c 89 f9             	mov    %r15,%rcx
  6fee7b:	e8 10 53 00 00       	call   704190 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::publish_metadata>
  6fee80:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fee87:	e9 53 ff ff ff       	jmp    6feddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fee8c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  6fee93:	00 
  6fee94:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  6fee9b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  6feea2:	48 85 c0             	test   %rax,%rax
  6feea5:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6feeac:	00 
  6feead:	0f 84 90 02 00 00    	je     6ff143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6feeb3:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  6feeba:	48 85 c9             	test   %rcx,%rcx
  6feebd:	0f 84 9c 00 00 00    	je     6fef5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x58f>
  6feec3:	48 89 ca             	mov    %rcx,%rdx
  6feec6:	48 83 e2 07          	and    $0x7,%rdx
  6feeca:	74 4c                	je     6fef18 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x548>
  6feecc:	31 f6                	xor    %esi,%esi
  6feece:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feed5:	48 ff c6             	inc    %rsi
  6feed8:	48 39 f2             	cmp    %rsi,%rdx
  6feedb:	75 f1                	jne    6feece <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x4fe>
  6feedd:	48 89 ca             	mov    %rcx,%rdx
  6feee0:	48 29 f2             	sub    %rsi,%rdx
  6feee3:	eb 36                	jmp    6fef1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x54b>
  6feee5:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6feeec:	b9 01 00 00 00       	mov    $0x1,%ecx
  6feef1:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6feef8:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  6feefc:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fef00:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  6fef05:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  6fef09:	88 43 30             	mov    %al,0x30(%rbx)
  6fef0c:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fef13:	e9 c7 fe ff ff       	jmp    6feddf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fef18:	48 89 ca             	mov    %rcx,%rdx
  6fef1b:	48 83 f9 08          	cmp    $0x8,%rcx
  6fef1f:	72 3e                	jb     6fef5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x58f>
  6fef21:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fef28:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fef2f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fef36:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fef3d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fef44:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fef4b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fef52:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fef59:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  6fef5d:	75 c2                	jne    6fef21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x551>
  6fef5f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  6fef66:	00 
  6fef67:	0f 84 d6 01 00 00    	je     6ff143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fef6d:	80 38 00             	cmpb   $0x0,(%rax)
  6fef70:	0f 85 cd 01 00 00    	jne    6ff143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fef76:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  6fef7d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  6fef84:	00 
  6fef85:	e8 86 51 04 00       	call   744110 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  6fef8a:	48 85 c0             	test   %rax,%rax
  6fef8d:	0f 84 b0 01 00 00    	je     6ff143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fef93:	48 8b 48 10          	mov    0x10(%rax),%rcx
  6fef97:	48 c1 e1 02          	shl    $0x2,%rcx
  6fef9b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  6fef9f:	ba 04 00 00 00       	mov    $0x4,%edx
  6fefa4:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  6fefa9:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fefae:	b8 00 00 00 00       	mov    $0x0,%eax
  6fefb3:	48 0f 45 c1          	cmovne %rcx,%rax
  6fefb7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fefbc:	48 85 c0             	test   %rax,%rax
  6fefbf:	0f 84 7e 01 00 00    	je     6ff143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fefc5:	45 31 ed             	xor    %r13d,%r13d
  6fefc8:	48 8b 05 39 a5 42 00 	mov    0x42a539(%rip),%rax        # b29508 <_DYNAMIC+0x398>
  6fefcf:	48 83 c0 20          	add    $0x20,%rax
  6fefd3:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fefd8:	48 8b 05 31 a5 42 00 	mov    0x42a531(%rip),%rax        # b29510 <_DYNAMIC+0x3a0>
  6fefdf:	48 83 c0 20          	add    $0x20,%rax
  6fefe3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fefe8:	48 8b 05 29 a5 42 00 	mov    0x42a529(%rip),%rax        # b29518 <_DYNAMIC+0x3a8>
  6fefef:	48 83 c0 20          	add    $0x20,%rax
  6feff3:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6feff8:	48 8b 05 21 a5 42 00 	mov    0x42a521(%rip),%rax        # b29520 <_DYNAMIC+0x3b0>
  6fefff:	48 83 c0 20          	add    $0x20,%rax
  6ff003:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6ff008:	48 8b 05 19 a5 42 00 	mov    0x42a519(%rip),%rax        # b29528 <_DYNAMIC+0x3b8>
  6ff00f:	48 83 c0 20          	add    $0x20,%rax
  6ff013:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6ff018:	48 8b 05 11 a5 42 00 	mov    0x42a511(%rip),%rax        # b29530 <_DYNAMIC+0x3c0>
  6ff01f:	48 83 c0 20          	add    $0x20,%rax
  6ff023:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6ff02a:	00 
  6ff02b:	48 8b 05 06 a5 42 00 	mov    0x42a506(%rip),%rax        # b29538 <_DYNAMIC+0x3c8>
  6ff032:	48 83 c0 20          	add    $0x20,%rax
  6ff036:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6ff03d:	00 
  6ff03e:	48 8b 05 fb a4 42 00 	mov    0x42a4fb(%rip),%rax        # b29540 <_DYNAMIC+0x3d0>
  6ff045:	48 83 c0 20          	add    $0x20,%rax
  6ff049:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6ff04e:	48 8b 05 f3 a4 42 00 	mov    0x42a4f3(%rip),%rax        # b29548 <_DYNAMIC+0x3d8>
  6ff055:	48 83 c0 20          	add    $0x20,%rax
  6ff059:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  6ff060:	00 
  6ff061:	48 8b 05 e8 a4 42 00 	mov    0x42a4e8(%rip),%rax        # b29550 <_DYNAMIC+0x3e0>
  6ff068:	48 83 c0 20          	add    $0x20,%rax
  6ff06c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6ff071:	48 8b 05 e0 a4 42 00 	mov    0x42a4e0(%rip),%rax        # b29558 <_DYNAMIC+0x3e8>
  6ff078:	48 83 c0 20          	add    $0x20,%rax
  6ff07c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6ff083:	00 
  6ff084:	48 8b 05 d5 a4 42 00 	mov    0x42a4d5(%rip),%rax        # b29560 <_DYNAMIC+0x3f0>
  6ff08b:	48 83 c0 20          	add    $0x20,%rax
  6ff08f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6ff094:	48 8b 05 cd a4 42 00 	mov    0x42a4cd(%rip),%rax        # b29568 <_DYNAMIC+0x3f8>
  6ff09b:	48 83 c0 20          	add    $0x20,%rax
  6ff09f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6ff0a4:	48 8d 2d 6d c2 95 ff 	lea    -0x6a3d93(%rip),%rbp        # 5b318 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x14a8>
  6ff0ab:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6ff0b0:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  6ff0b4:	ff 15 b6 a4 42 00    	call   *0x42a4b6(%rip)        # b29570 <_DYNAMIC+0x400>
  6ff0ba:	0f b7 c0             	movzwl %ax,%eax
  6ff0bd:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  6ff0c2:	48 01 e9             	add    %rbp,%rcx
  6ff0c5:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6ff0ca:	ff e1                	jmp    *%rcx
  6ff0cc:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6ff0d1:	eb 57                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0d3:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6ff0da:	00 
  6ff0db:	eb 4d                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0dd:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6ff0e2:	eb 46                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0e4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6ff0e9:	eb 3f                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0eb:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  6ff0f2:	00 
  6ff0f3:	eb 35                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0f5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6ff0fa:	eb 2e                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0fc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ff103:	00 
  6ff104:	eb 24                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff106:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6ff10b:	eb 1d                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff10d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6ff112:	eb 16                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff114:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6ff11b:	00 
  6ff11c:	eb 0c                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff11e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6ff123:	eb 05                	jmp    6ff12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff125:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ff12a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  6ff12e:	0f 85 03 11 00 00    	jne    700237 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1867>
  6ff134:	49 83 c5 04          	add    $0x4,%r13
  6ff138:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  6ff13d:	0f 85 68 ff ff ff    	jne    6ff0ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x6db>
  6ff143:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  6ff14a:	00 00 
  6ff14c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6ff153:	48 85 ed             	test   %rbp,%rbp
  6ff156:	0f 84 f2 10 00 00    	je     70024e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x187e>
  6ff15c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6ff163:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6ff16a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  6ff171:	48 89 c7             	mov    %rax,%rdi
  6ff174:	48 89 e9             	mov    %rbp,%rcx
  6ff177:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  6ff17e:	00 
  6ff17f:	45 89 d3             	mov    %r10d,%r11d
  6ff182:	41 c1 e3 05          	shl    $0x5,%r11d
  6ff186:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  6ff18d:	45 31 c9             	xor    %r9d,%r9d
  6ff190:	4d 39 cb             	cmp    %r9,%r11
  6ff193:	74 28                	je     6ff1bd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7ed>
  6ff195:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  6ff19c:	00 
  6ff19d:	41 0f 97 c4          	seta   %r12b
  6ff1a1:	41 80 dc 00          	sbb    $0x0,%r12b
  6ff1a5:	49 83 c1 20          	add    $0x20,%r9
  6ff1a9:	49 ff c0             	inc    %r8
  6ff1ac:	41 80 fc 01          	cmp    $0x1,%r12b
  6ff1b0:	74 de                	je     6ff190 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7c0>
  6ff1b2:	45 0f b6 d4          	movzbl %r12b,%r10d
  6ff1b6:	45 85 d2             	test   %r10d,%r10d
  6ff1b9:	75 05                	jne    6ff1c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7f0>
  6ff1bb:	eb 1c                	jmp    6ff1d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x809>
  6ff1bd:	4d 89 d0             	mov    %r10,%r8
  6ff1c0:	48 83 ef 01          	sub    $0x1,%rdi
  6ff1c4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff1c9:	0f 82 92 00 00 00    	jb     6ff261 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x891>
  6ff1cf:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  6ff1d6:	00 
  6ff1d7:	eb 9e                	jmp    6ff177 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7a7>
  6ff1d9:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  6ff1df:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff1e4:	75 7b                	jne    6ff261 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x891>
  6ff1e6:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  6ff1eb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff1f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  6ff1f9:	4c 8d 05 a8 c3 3f 00 	lea    0x3fc3a8(%rip),%r8        # afb5a8 <__frame_dummy_init_array_entry+0xca0>
  6ff200:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff205:	4c 89 f9             	mov    %r15,%rcx
  6ff208:	45 31 c9             	xor    %r9d,%r9d
  6ff20b:	e8 10 65 05 00       	call   755720 <<gpui::source::Sources<unit_action_cost_two::Model>>::freeze>
  6ff210:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6ff215:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  6ff21a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6ff221:	00 
  6ff222:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6ff226:	0f 85 e6 00 00 00    	jne    6ff312 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x942>
  6ff22c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6ff233:	00 
  6ff234:	48 89 cd             	mov    %rcx,%rbp
  6ff237:	48 c1 ed 08          	shr    $0x8,%rbp
  6ff23b:	b8 20 00 00 00       	mov    $0x20,%eax
  6ff240:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6ff245:	89 cf                	mov    %ecx,%edi
  6ff247:	e9 bb 12 00 00       	jmp    700507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6ff24c:	48 89 f9             	mov    %rdi,%rcx
  6ff24f:	48 83 e8 01          	sub    $0x1,%rax
  6ff253:	0f 82 f5 0f 00 00    	jb     70024e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x187e>
  6ff259:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  6ff260:	00 
  6ff261:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  6ff268:	41 89 f8             	mov    %edi,%r8d
  6ff26b:	41 c1 e0 05          	shl    $0x5,%r8d
  6ff26f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  6ff276:	45 31 ed             	xor    %r13d,%r13d
  6ff279:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6ff280:	4d 39 e8             	cmp    %r13,%r8
  6ff283:	74 c7                	je     6ff24c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x87c>
  6ff285:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  6ff28c:	00 
  6ff28d:	41 0f 97 c1          	seta   %r9b
  6ff291:	41 80 d9 00          	sbb    $0x0,%r9b
  6ff295:	49 83 c5 20          	add    $0x20,%r13
  6ff299:	48 ff c1             	inc    %rcx
  6ff29c:	41 80 f9 01          	cmp    $0x1,%r9b
  6ff2a0:	74 de                	je     6ff280 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x8b0>
  6ff2a2:	41 0f b6 f9          	movzbl %r9b,%edi
  6ff2a6:	85 ff                	test   %edi,%edi
  6ff2a8:	75 a5                	jne    6ff24f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x87f>
  6ff2aa:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  6ff2af:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6ff2b3:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff2b8:	74 41                	je     6ff2fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x92b>
  6ff2ba:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff2bf:	48 85 c0             	test   %rax,%rax
  6ff2c2:	0f 84 46 01 00 00    	je     6ff40e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa3e>
  6ff2c8:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff2cd:	48 ff c8             	dec    %rax
  6ff2d0:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  6ff2d7:	ff ff 3f 
  6ff2da:	48 21 c7             	and    %rax,%rdi
  6ff2dd:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  6ff2e1:	45 89 c8             	mov    %r9d,%r8d
  6ff2e4:	41 83 e0 03          	and    $0x3,%r8d
  6ff2e8:	48 83 ff 03          	cmp    $0x3,%rdi
  6ff2ec:	0f 83 25 01 00 00    	jae    6ff417 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa47>
  6ff2f2:	31 c0                	xor    %eax,%eax
  6ff2f4:	31 ff                	xor    %edi,%edi
  6ff2f6:	e9 b0 01 00 00       	jmp    6ff4ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xadb>
  6ff2fb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff302:	4c 8d 05 9f c2 3f 00 	lea    0x3fc29f(%rip),%r8        # afb5a8 <__frame_dummy_init_array_entry+0xca0>
  6ff309:	31 c0                	xor    %eax,%eax
  6ff30b:	31 ff                	xor    %edi,%edi
  6ff30d:	e9 d4 01 00 00       	jmp    6ff4e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb16>
  6ff312:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6ff317:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6ff31c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6ff323:	00 
  6ff324:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  6ff32b:	00 
  6ff32c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6ff333:	00 
  6ff334:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  6ff33b:	00 
  6ff33c:	41 83 fd 02          	cmp    $0x2,%r13d
  6ff340:	0f 84 bc 13 00 00    	je     700702 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d32>
  6ff346:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  6ff34b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  6ff352:	00 
  6ff353:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  6ff358:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  6ff35f:	00 
  6ff360:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  6ff367:	00 
  6ff368:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ff36f:	00 
  6ff370:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6ff375:	ba 06 00 00 00       	mov    $0x6,%edx
  6ff37a:	ff 15 f8 a1 42 00    	call   *0x42a1f8(%rip)        # b29578 <_DYNAMIC+0x408>
  6ff380:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  6ff387:	00 
  6ff388:	80 fa ff             	cmp    $0xff,%dl
  6ff38b:	0f 84 79 0e 00 00    	je     70020a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x183a>
  6ff391:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  6ff398:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  6ff39f:	00 
  6ff3a0:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  6ff3a7:	00 
  6ff3a8:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  6ff3af:	00 
  6ff3b0:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  6ff3b7:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  6ff3be:	80 fa 02             	cmp    $0x2,%dl
  6ff3c1:	0f 85 35 0f 00 00    	jne    7002fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x192c>
  6ff3c7:	89 ea                	mov    %ebp,%edx
  6ff3c9:	48 c1 e0 20          	shl    $0x20,%rax
  6ff3cd:	48 09 c8             	or     %rcx,%rax
  6ff3d0:	48 c1 e8 08          	shr    $0x8,%rax
  6ff3d4:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  6ff3db:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  6ff3e2:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  6ff3e9:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  6ff3f0:	00 
  6ff3f1:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  6ff3f8:	00 
  6ff3f9:	41 80 be 1f 07 00 00 	cmpb   $0x0,0x71f(%r14)
  6ff400:	00 
  6ff401:	0f 84 0c 0f 00 00    	je     700313 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1943>
  6ff407:	31 ed                	xor    %ebp,%ebp
  6ff409:	e9 24 0f 00 00       	jmp    700332 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1962>
  6ff40e:	31 ff                	xor    %edi,%edi
  6ff410:	31 c0                	xor    %eax,%eax
  6ff412:	e9 b5 00 00 00       	jmp    6ff4cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xafc>
  6ff417:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6ff41c:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  6ff423:	00 00 80 
  6ff426:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6ff42a:	49 21 c1             	and    %rax,%r9
  6ff42d:	31 c0                	xor    %eax,%eax
  6ff42f:	31 ff                	xor    %edi,%edi
  6ff431:	44 8b 11             	mov    (%rcx),%r10d
  6ff434:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  6ff438:	45 89 d4             	mov    %r10d,%r12d
  6ff43b:	41 f7 d4             	not    %r12d
  6ff43e:	41 f6 c4 03          	test   $0x3,%r12b
  6ff442:	41 0f 94 c4          	sete   %r12b
  6ff446:	45 89 c3             	mov    %r8d,%r11d
  6ff449:	41 f7 d3             	not    %r11d
  6ff44c:	41 f6 c3 03          	test   $0x3,%r11b
  6ff450:	41 0f 94 c3          	sete   %r11b
  6ff454:	45 08 e3             	or     %r12b,%r11b
  6ff457:	8b 51 08             	mov    0x8(%rcx),%edx
  6ff45a:	41 89 d4             	mov    %edx,%r12d
  6ff45d:	41 f7 d4             	not    %r12d
  6ff460:	41 f6 c4 03          	test   $0x3,%r12b
  6ff464:	41 0f 94 c4          	sete   %r12b
  6ff468:	8b 71 0c             	mov    0xc(%rcx),%esi
  6ff46b:	48 83 c1 10          	add    $0x10,%rcx
  6ff46f:	21 f2                	and    %esi,%edx
  6ff471:	f7 d6                	not    %esi
  6ff473:	40 f6 c6 03          	test   $0x3,%sil
  6ff477:	40 0f 94 c6          	sete   %sil
  6ff47b:	44 08 e6             	or     %r12b,%sil
  6ff47e:	44 08 de             	or     %r11b,%sil
  6ff481:	40 08 f7             	or     %sil,%dil
  6ff484:	45 21 c2             	and    %r8d,%r10d
  6ff487:	41 21 d2             	and    %edx,%r10d
  6ff48a:	41 f7 d2             	not    %r10d
  6ff48d:	41 f6 c2 03          	test   $0x3,%r10b
  6ff491:	0f 95 c2             	setne  %dl
  6ff494:	08 d0                	or     %dl,%al
  6ff496:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  6ff49a:	75 95                	jne    6ff431 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa61>
  6ff49c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6ff4a1:	4d 85 c0             	test   %r8,%r8
  6ff4a4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff4a9:	74 21                	je     6ff4cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xafc>
  6ff4ab:	45 31 c9             	xor    %r9d,%r9d
  6ff4ae:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  6ff4b2:	83 e2 03             	and    $0x3,%edx
  6ff4b5:	83 fa 03             	cmp    $0x3,%edx
  6ff4b8:	0f 95 c2             	setne  %dl
  6ff4bb:	40 0f 94 c6          	sete   %sil
  6ff4bf:	40 08 f7             	or     %sil,%dil
  6ff4c2:	08 d0                	or     %dl,%al
  6ff4c4:	49 ff c1             	inc    %r9
  6ff4c7:	4d 39 c8             	cmp    %r9,%r8
  6ff4ca:	75 e2                	jne    6ff4ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xade>
  6ff4cc:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff4d3:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  6ff4d8:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6ff4df:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6ff4e6:	40 0f b6 cf          	movzbl %dil,%ecx
  6ff4ea:	83 e1 01             	and    $0x1,%ecx
  6ff4ed:	89 0c 24             	mov    %ecx,(%rsp)
  6ff4f0:	44 0f b6 c8          	movzbl %al,%r9d
  6ff4f4:	41 83 e1 01          	and    $0x1,%r9d
  6ff4f8:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff4fd:	4c 89 f9             	mov    %r15,%rcx
  6ff500:	e8 1b 62 05 00       	call   755720 <<gpui::source::Sources<unit_action_cost_two::Model>>::freeze>
  6ff505:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  6ff50a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6ff50f:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6ff516:	00 
  6ff517:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6ff51e:	00 
  6ff51f:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6ff524:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  6ff529:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  6ff52d:	75 1d                	jne    6ff54c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb7c>
  6ff52f:	48 89 c5             	mov    %rax,%rbp
  6ff532:	48 c1 ed 08          	shr    $0x8,%rbp
  6ff536:	b9 20 00 00 00       	mov    $0x20,%ecx
  6ff53b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff540:	89 c7                	mov    %eax,%edi
  6ff542:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  6ff547:	e9 bb 0f 00 00       	jmp    700507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6ff54c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6ff551:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6ff558:	00 
  6ff559:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6ff560:	00 
  6ff561:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6ff568:	00 00 
  6ff56a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  6ff571:	00 00 
  6ff573:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  6ff579:	0f 84 69 0c 00 00    	je     7001e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1818>
  6ff57f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff584:	48 85 c0             	test   %rax,%rax
  6ff587:	0f 84 5b 0c 00 00    	je     7001e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1818>
  6ff58d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6ff592:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff597:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff59c:	48 c1 e0 02          	shl    $0x2,%rax
  6ff5a0:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff5a5:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6ff5a9:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  6ff5b0:	00 
  6ff5b1:	45 31 e4             	xor    %r12d,%r12d
  6ff5b4:	48 83 f8 02          	cmp    $0x2,%rax
  6ff5b8:	0f 85 72 0b 00 00    	jne    700130 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1760>
  6ff5be:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6ff5c3:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6ff5c7:	ff 15 a3 9f 42 00    	call   *0x429fa3(%rip)        # b29570 <_DYNAMIC+0x400>
  6ff5cd:	66 85 c0             	test   %ax,%ax
  6ff5d0:	0f 85 ba 12 00 00    	jne    700890 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ec0>
  6ff5d6:	49 83 c4 04          	add    $0x4,%r12
  6ff5da:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6ff5df:	75 dd                	jne    6ff5be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xbee>
  6ff5e1:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff5e6:	48 85 c0             	test   %rax,%rax
  6ff5e9:	0f 84 dd 0d 00 00    	je     7003cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19fc>
  6ff5ef:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff5f4:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  6ff5fb:	00 
  6ff5fc:	48 c1 e0 02          	shl    $0x2,%rax
  6ff600:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  6ff606:	66 0f 6f 0d 52 b2 95 	movdqa -0x6a4dae(%rip),%xmm1        # 5a860 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9f0>
  6ff60d:	ff 
  6ff60e:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  6ff612:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  6ff619:	00 00 
  6ff61b:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  6ff622:	00 00 00 00 00 
  6ff627:	48 8d 0d ba bf 3f 00 	lea    0x3fbfba(%rip),%rcx        # afb5e8 <__frame_dummy_init_array_entry+0xce0>
  6ff62e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6ff633:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  6ff63a:	00 00 80 
  6ff63d:	48 ff c1             	inc    %rcx
  6ff640:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  6ff647:	00 
  6ff648:	48 8d 0d 65 b1 96 ff 	lea    -0x694e9b(%rip),%rcx        # 6a7b4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6ff64f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6ff656:	00 
  6ff657:	48 8d 0d 1a c0 3f 00 	lea    0x3fc01a(%rip),%rcx        # afb678 <__frame_dummy_init_array_entry+0xd70>
  6ff65e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6ff665:	00 
  6ff666:	48 8d 0d 93 bf 3f 00 	lea    0x3fbf93(%rip),%rcx        # afb600 <__frame_dummy_init_array_entry+0xcf8>
  6ff66d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  6ff674:	00 
  6ff675:	48 8d 0d 0f b1 96 ff 	lea    -0x694ef1(%rip),%rcx        # 6a78b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6ff67c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  6ff683:	00 
  6ff684:	48 8d 0d fd b3 3f 00 	lea    0x3fb3fd(%rip),%rcx        # afaa88 <__frame_dummy_init_array_entry+0x180>
  6ff68b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  6ff692:	00 
  6ff693:	31 c9                	xor    %ecx,%ecx
  6ff695:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  6ff69c:	00 00 00 00 00 
  6ff6a1:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  6ff6a8:	00 00 00 00 00 
  6ff6ad:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff6b4:	00 00 
  6ff6b6:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6ff6bb:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6ff6c2:	00 
  6ff6c3:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  6ff6c8:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  6ff6cb:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  6ff6d2:	89 e8                	mov    %ebp,%eax
  6ff6d4:	c1 e8 0f             	shr    $0xf,%eax
  6ff6d7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6ff6de:	48 39 c6             	cmp    %rax,%rsi
  6ff6e1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff6e6:	0f 86 7c 11 00 00    	jbe    700868 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e98>
  6ff6ec:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  6ff6f3:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  6ff6f7:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  6ff6fb:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6ff700:	89 ef                	mov    %ebp,%edi
  6ff702:	ff 15 68 9e 42 00    	call   *0x429e68(%rip)        # b29570 <_DYNAMIC+0x400>
  6ff708:	89 44 24 08          	mov    %eax,0x8(%rsp)
  6ff70c:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  6ff710:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6ff717:	00 
  6ff718:	8b 54 24 08          	mov    0x8(%rsp),%edx
  6ff71c:	66 85 d2             	test   %dx,%dx
  6ff71f:	0f 84 31 01 00 00    	je     6ff856 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xe86>
  6ff725:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  6ff72c:	02 
  6ff72d:	0f 84 6d 0f 00 00    	je     7006a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd0>
  6ff733:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6ff738:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6ff73d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6ff744:	00 
  6ff745:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6ff74a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  6ff74e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6ff755:	00 00 
  6ff757:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  6ff75b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ff762:	00 
  6ff763:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6ff768:	ff 15 0a 9e 42 00    	call   *0x429e0a(%rip)        # b29578 <_DYNAMIC+0x408>
  6ff76e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  6ff775:	00 
  6ff776:	3c ff                	cmp    $0xff,%al
  6ff778:	0f 84 10 0d 00 00    	je     70048e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1abe>
  6ff77e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  6ff785:	00 
  6ff786:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  6ff78d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  6ff794:	00 
  6ff795:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  6ff79c:	00 
  6ff79d:	41 8b 78 10          	mov    0x10(%r8),%edi
  6ff7a1:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  6ff7a8:	00 
  6ff7a9:	41 89 79 10          	mov    %edi,0x10(%r9)
  6ff7ad:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  6ff7b2:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  6ff7b7:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  6ff7be:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  6ff7c5:	00 
  6ff7c6:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  6ff7cd:	00 
  6ff7ce:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  6ff7d5:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6ff7d9:	44 0f b7 e9          	movzwl %cx,%r13d
  6ff7dd:	48 8d 05 c4 c1 3f 00 	lea    0x3fc1c4(%rip),%rax        # afb9a8 <__frame_dummy_init_array_entry+0x10a0>
  6ff7e4:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6ff7e9:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  6ff7ed:	0f 84 c7 00 00 00    	je     6ff8ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xeea>
  6ff7f3:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff7f8:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  6ff7ff:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6ff804:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  6ff80b:	00 
  6ff80c:	ff 15 6e 9d 42 00    	call   *0x429d6e(%rip)        # b29580 <_DYNAMIC+0x410>
  6ff812:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6ff817:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6ff81c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6ff820:	0f 85 ab 0d 00 00    	jne    7005d1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c01>
  6ff826:	40 80 ff 01          	cmp    $0x1,%dil
  6ff82a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff82f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ff834:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6ff839:	0f 85 9e 08 00 00    	jne    7000dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x170d>
  6ff83f:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6ff846:	01 
  6ff847:	b0 01                	mov    $0x1,%al
  6ff849:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6ff850:	00 
  6ff851:	e9 4e 08 00 00       	jmp    7000a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ff856:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  6ff85c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff861:	0f 84 59 0e 00 00    	je     7006c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cf0>
  6ff867:	83 e5 03             	and    $0x3,%ebp
  6ff86a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  6ff86d:	83 f8 02             	cmp    $0x2,%eax
  6ff870:	0f 83 8a 00 00 00    	jae    6ff900 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf30>
  6ff876:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6ff87d:	48 8b 38             	mov    (%rax),%rdi
  6ff880:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  6ff886:	48 85 ff             	test   %rdi,%rdi
  6ff889:	0f 84 19 0e 00 00    	je     7006a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd8>
  6ff88f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ff894:	ff 15 ee 9c 42 00    	call   *0x429cee(%rip)        # b29588 <_DYNAMIC+0x418>
  6ff89a:	48 85 c0             	test   %rax,%rax
  6ff89d:	0f 84 05 0e 00 00    	je     7006a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd8>
  6ff8a3:	83 fd 01             	cmp    $0x1,%ebp
  6ff8a6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff8ab:	0f 85 a6 00 00 00    	jne    6ff957 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf87>
  6ff8b1:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6ff8b5:	e9 a1 00 00 00       	jmp    6ff95b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf8b>
  6ff8ba:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  6ff8c1:	48 8b 00             	mov    (%rax),%rax
  6ff8c4:	48 8d 15 85 ba 95 ff 	lea    -0x6a457b(%rip),%rdx        # 5b350 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x14e0>
  6ff8cb:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  6ff8cf:	48 01 d1             	add    %rdx,%rcx
  6ff8d2:	48 8d 05 47 c2 95 ff 	lea    -0x6a3db9(%rip),%rax        # 5bb20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  6ff8d9:	ff e1                	jmp    *%rcx
  6ff8db:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  6ff8e2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6ff8e7:	48 39 c6             	cmp    %rax,%rsi
  6ff8ea:	0f 86 3a 0f 00 00    	jbe    70082a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e5a>
  6ff8f0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6ff8f4:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  6ff8fb:	e9 4e 03 00 00       	jmp    6ffc4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x127e>
  6ff900:	85 ed                	test   %ebp,%ebp
  6ff902:	0f 85 18 0e 00 00    	jne    700720 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d50>
  6ff908:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ff90f:	00 
  6ff910:	8b 40 20             	mov    0x20(%rax),%eax
  6ff913:	89 c1                	mov    %eax,%ecx
  6ff915:	83 e1 07             	and    $0x7,%ecx
  6ff918:	83 f9 06             	cmp    $0x6,%ecx
  6ff91b:	74 74                	je     6ff991 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff91d:	c1 e8 03             	shr    $0x3,%eax
  6ff920:	74 6f                	je     6ff991 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff922:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6ff929:	ff c8                	dec    %eax
  6ff92b:	48 39 c6             	cmp    %rax,%rsi
  6ff92e:	0f 86 23 0f 00 00    	jbe    700857 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e87>
  6ff934:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  6ff93b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6ff93f:	48 c1 e0 04          	shl    $0x4,%rax
  6ff943:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  6ff948:	0f 84 59 0e 00 00    	je     7007a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1dd7>
  6ff94e:	48 01 c1             	add    %rax,%rcx
  6ff951:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  6ff955:	eb 13                	jmp    6ff96a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf9a>
  6ff957:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6ff95b:	b0 01                	mov    $0x1,%al
  6ff95d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  6ff964:	00 
  6ff965:	48 85 ff             	test   %rdi,%rdi
  6ff968:	74 27                	je     6ff991 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff96a:	48 8b 07             	mov    (%rdi),%rax
  6ff96d:	48 d1 e8             	shr    $1,%rax
  6ff970:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6ff975:	48 39 d0             	cmp    %rdx,%rax
  6ff978:	75 17                	jne    6ff991 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff97a:	48 83 c7 10          	add    $0x10,%rdi
  6ff97e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6ff983:	ff 15 07 9c 42 00    	call   *0x429c07(%rip)        # b29590 <bcmp@GLIBC_2.2.5>
  6ff989:	85 c0                	test   %eax,%eax
  6ff98b:	0f 84 3a 06 00 00    	je     6fffcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x15fb>
  6ff991:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  6ff996:	4d 85 e4             	test   %r12,%r12
  6ff999:	75 6d                	jne    6ffa08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1038>
  6ff99b:	4c 8d 25 ee b6 95 ff 	lea    -0x6a4912(%rip),%r12        # 5b090 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1220>
  6ff9a2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6ff9a7:	48 85 f6             	test   %rsi,%rsi
  6ff9aa:	74 41                	je     6ff9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x101d>
  6ff9ac:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff9b3:	00 00 
  6ff9b5:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff9ba:	31 d2                	xor    %edx,%edx
  6ff9bc:	31 c9                	xor    %ecx,%ecx
  6ff9be:	ff 15 d4 9b 42 00    	call   *0x429bd4(%rip)        # b29598 <_DYNAMIC+0x428>
  6ff9c4:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6ff9c9:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  6ff9cd:	0f 85 6e 0e 00 00    	jne    700841 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e71>
  6ff9d3:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  6ff9d8:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  6ff9dd:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6ff9e2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6ff9e7:	ff 15 eb 99 42 00    	call   *0x4299eb(%rip)        # b293d8 <memcpy@GLIBC_2.14>
  6ff9ed:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  6ff9f4:	00 00 
  6ff9f6:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  6ff9fd:	00 00 
  6ff9ff:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  6ffa06:	00 00 
  6ffa08:	85 ed                	test   %ebp,%ebp
  6ffa0a:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  6ffa0f:	0f 84 b1 00 00 00    	je     6ffac6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10f6>
  6ffa15:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6ffa1c:	48 8b 38             	mov    (%rax),%rdi
  6ffa1f:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  6ffa25:	48 85 ff             	test   %rdi,%rdi
  6ffa28:	0f 84 2e 0d 00 00    	je     70075c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d8c>
  6ffa2e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ffa33:	ff 15 67 9b 42 00    	call   *0x429b67(%rip)        # b295a0 <_DYNAMIC+0x430>
  6ffa39:	48 85 c0             	test   %rax,%rax
  6ffa3c:	0f 84 1a 0d 00 00    	je     70075c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d8c>
  6ffa42:	83 fd 01             	cmp    $0x1,%ebp
  6ffa45:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ffa4a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6ffa4f:	0f 85 4d 01 00 00    	jne    6ffba2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11d2>
  6ffa55:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6ffa5a:	48 85 c9             	test   %rcx,%rcx
  6ffa5d:	74 2c                	je     6ffa8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ffa5f:	f6 01 01             	testb  $0x1,(%rcx)
  6ffa62:	75 27                	jne    6ffa8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ffa64:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6ffa68:	f6 c2 01             	test   $0x1,%dl
  6ffa6b:	75 1e                	jne    6ffa8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ffa6d:	ba 02 00 00 00       	mov    $0x2,%edx
  6ffa72:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6ffa78:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6ffa7f:	00 
  6ffa80:	48 f7 da             	neg    %rdx
  6ffa83:	71 06                	jno    6ffa8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ffa85:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6ffa8b:	48 89 c5             	mov    %rax,%rbp
  6ffa8e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6ffa92:	48 85 ff             	test   %rdi,%rdi
  6ffa95:	74 1c                	je     6ffab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ffa97:	f6 07 01             	testb  $0x1,(%rdi)
  6ffa9a:	75 17                	jne    6ffab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ffa9c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffaa0:	a8 01                	test   $0x1,%al
  6ffaa2:	75 0f                	jne    6ffab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ffaa4:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ffaa8:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ffaad:	0f 84 50 06 00 00    	je     700103 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1733>
  6ffab3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ffab8:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6ffabc:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ffac1:	e9 de 05 00 00       	jmp    7000a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ffac6:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ffacd:	00 
  6fface:	8b 78 20             	mov    0x20(%rax),%edi
  6ffad1:	89 f8                	mov    %edi,%eax
  6ffad3:	83 e0 07             	and    $0x7,%eax
  6ffad6:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  6ffadc:	83 f8 06             	cmp    $0x6,%eax
  6ffadf:	0f 84 59 0c 00 00    	je     70073e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d6e>
  6ffae5:	c1 ef 03             	shr    $0x3,%edi
  6ffae8:	0f 84 50 0c 00 00    	je     70073e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d6e>
  6ffaee:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6ffaf5:	ff cf                	dec    %edi
  6ffaf7:	48 39 fe             	cmp    %rdi,%rsi
  6ffafa:	0f 86 01 0d 00 00    	jbe    700801 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e31>
  6ffb00:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6ffb07:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6ffb0b:	48 c1 e0 04          	shl    $0x4,%rax
  6ffb0f:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6ffb15:	0f 84 5f 0c 00 00    	je     70077a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1daa>
  6ffb1b:	4d 85 e4             	test   %r12,%r12
  6ffb1e:	0f 84 68 0c 00 00    	je     70078c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1dbc>
  6ffb24:	41 f6 04 24 01       	testb  $0x1,(%r12)
  6ffb29:	75 2a                	jne    6ffb55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffb2b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  6ffb30:	f6 c1 01             	test   $0x1,%cl
  6ffb33:	75 20                	jne    6ffb55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffb35:	b9 02 00 00 00       	mov    $0x2,%ecx
  6ffb3a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  6ffb41:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  6ffb48:	00 
  6ffb49:	48 f7 d9             	neg    %rcx
  6ffb4c:	71 07                	jno    6ffb55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffb4e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  6ffb55:	48 01 c5             	add    %rax,%rbp
  6ffb58:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  6ffb5c:	f6 07 01             	testb  $0x1,(%rdi)
  6ffb5f:	75 17                	jne    6ffb78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6ffb61:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffb65:	a8 01                	test   $0x1,%al
  6ffb67:	75 0f                	jne    6ffb78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6ffb69:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ffb6d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ffb72:	0f 84 7c 05 00 00    	je     7000f4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1724>
  6ffb78:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6ffb7c:	48 89 ef             	mov    %rbp,%rdi
  6ffb7f:	e8 4c 4e ff ff       	call   6f49d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6ffb84:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6ffb8b:	ff 
  6ffb8c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6ffb93:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ffb98:	e8 e3 59 04 00       	call   745580 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6ffb9d:	e9 e1 04 00 00       	jmp    700083 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16b3>
  6ffba2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6ffba7:	48 85 c9             	test   %rcx,%rcx
  6ffbaa:	74 2c                	je     6ffbd8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffbac:	f6 01 01             	testb  $0x1,(%rcx)
  6ffbaf:	75 27                	jne    6ffbd8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffbb1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6ffbb5:	f6 c2 01             	test   $0x1,%dl
  6ffbb8:	75 1e                	jne    6ffbd8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffbba:	ba 02 00 00 00       	mov    $0x2,%edx
  6ffbbf:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6ffbc5:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6ffbcc:	00 
  6ffbcd:	48 f7 da             	neg    %rdx
  6ffbd0:	71 06                	jno    6ffbd8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffbd2:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6ffbd8:	48 89 c5             	mov    %rax,%rbp
  6ffbdb:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6ffbdf:	48 85 ff             	test   %rdi,%rdi
  6ffbe2:	74 1c                	je     6ffc00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffbe4:	f6 07 01             	testb  $0x1,(%rdi)
  6ffbe7:	75 17                	jne    6ffc00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffbe9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffbed:	a8 01                	test   $0x1,%al
  6ffbef:	75 0f                	jne    6ffc00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffbf1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ffbf5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ffbfa:	0f 84 12 05 00 00    	je     700112 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1742>
  6ffc00:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ffc05:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6ffc09:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ffc0e:	e9 91 04 00 00       	jmp    7000a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ffc13:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  6ffc1a:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6ffc1f:	48 39 ce             	cmp    %rcx,%rsi
  6ffc22:	0f 86 eb 0b 00 00    	jbe    700813 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e43>
  6ffc28:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  6ffc2f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  6ffc36:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  6ffc3a:	48 39 c6             	cmp    %rax,%rsi
  6ffc3d:	0f 86 d9 0b 00 00    	jbe    70081c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e4c>
  6ffc43:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6ffc47:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  6ffc4e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  6ffc52:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  6ffc59:	00 
  6ffc5a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  6ffc5e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  6ffc65:	00 
  6ffc66:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  6ffc6a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  6ffc6f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  6ffc73:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  6ffc77:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  6ffc7e:	00 
  6ffc7f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  6ffc86:	00 
  6ffc87:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  6ffc8e:	00 00 
  6ffc90:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  6ffc97:	00 00 
  6ffc99:	eb 1a                	jmp    6ffcb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x12e5>
  6ffc9b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  6ffca2:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  6ffca9:	00 
  6ffcaa:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6ffcaf:	ff 15 f3 97 42 00    	call   *0x4297f3(%rip)        # b294a8 <_DYNAMIC+0x338>
  6ffcb5:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  6ffcbc:	00 
  6ffcbd:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  6ffcc4:	00 
  6ffcc5:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  6ffccc:	00 
  6ffccd:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  6ffcd4:	00 
  6ffcd5:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  6ffcdc:	00 00 
  6ffcde:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  6ffce5:	00 00 
  6ffce7:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  6ffcee:	00 
  6ffcef:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  6ffcf6:	00 
  6ffcf7:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  6ffcfe:	00 
  6ffcff:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  6ffd06:	00 
  6ffd07:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  6ffd0e:	00 00 
  6ffd10:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  6ffd16:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ffd1d:	00 
  6ffd1e:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  6ffd25:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6ffd2a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  6ffd2f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6ffd34:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  6ffd3b:	00 
  6ffd3c:	e8 2f f0 06 00       	call   76ed70 <<gpui::property::Overrides>::update_base>
  6ffd41:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  6ffd48:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  6ffd4f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  6ffd56:	00 
  6ffd57:	48 c1 e5 20          	shl    $0x20,%rbp
  6ffd5b:	48 09 cd             	or     %rcx,%rbp
  6ffd5e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  6ffd65:	00 
  6ffd66:	83 f8 02             	cmp    $0x2,%eax
  6ffd69:	0f 84 ba 08 00 00    	je     700629 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c59>
  6ffd6f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  6ffd76:	00 
  6ffd77:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  6ffd7b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  6ffd82:	00 
  6ffd83:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  6ffd87:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  6ffd8b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  6ffd8f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  6ffd93:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  6ffd97:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  6ffd9b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  6ffd9f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6ffda3:	0f 11 02             	movups %xmm0,(%rdx)
  6ffda6:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  6ffdad:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  6ffdb4:	00 
  6ffdb5:	48 89 e8             	mov    %rbp,%rax
  6ffdb8:	48 c1 e8 20          	shr    $0x20,%rax
  6ffdbc:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  6ffdc3:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  6ffdca:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  6ffdd1:	00 00 
  6ffdd3:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  6ffdda:	00 00 
  6ffddc:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  6ffde3:	00 
  6ffde4:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  6ffdeb:	00 
  6ffdec:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  6ffdf3:	00 00 
  6ffdf5:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  6ffdfc:	00 00 
  6ffdfe:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  6ffe05:	00 
  6ffe06:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  6ffe0d:	00 
  6ffe0e:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  6ffe15:	00 
  6ffe16:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  6ffe1d:	00 
  6ffe1e:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  6ffe25:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  6ffe2c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  6ffe33:	00 
  6ffe34:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  6ffe3b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  6ffe42:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  6ffe49:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  6ffe50:	00 
  6ffe51:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  6ffe58:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  6ffe5f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  6ffe66:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  6ffe6d:	00 
  6ffe6e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  6ffe75:	00 
  6ffe76:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  6ffe7d:	00 
  6ffe7e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  6ffe85:	01 
  6ffe86:	75 1a                	jne    6ffea2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x14d2>
  6ffe88:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  6ffe8f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  6ffe96:	0f 94 c1             	sete   %cl
  6ffe99:	84 c8                	test   %cl,%al
  6ffe9b:	75 0d                	jne    6ffeaa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x14da>
  6ffe9d:	e9 38 01 00 00       	jmp    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffea2:	a8 01                	test   $0x1,%al
  6ffea4:	0f 85 30 01 00 00    	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffeaa:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  6ffeb1:	00 
  6ffeb2:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  6ffeb9:	01 
  6ffeba:	75 1b                	jne    6ffed7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1507>
  6ffebc:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  6ffec3:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  6ffeca:	0f 94 c1             	sete   %cl
  6ffecd:	84 c8                	test   %cl,%al
  6ffecf:	0f 84 05 01 00 00    	je     6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffed5:	eb 08                	jmp    6ffedf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x150f>
  6ffed7:	a8 01                	test   $0x1,%al
  6ffed9:	0f 85 fb 00 00 00    	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffedf:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  6ffee6:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  6ffeed:	0f 85 e7 00 00 00    	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffef3:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  6ffefa:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  6fff01:	0f 85 d3 00 00 00    	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff07:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  6fff0e:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  6fff15:	0f 85 bf 00 00 00    	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff1b:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  6fff22:	00 
  6fff23:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  6fff2a:	0f 85 aa 00 00 00    	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff30:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  6fff37:	00 
  6fff38:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  6fff3f:	0f 85 95 00 00 00    	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff45:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  6fff4c:	00 
  6fff4d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  6fff54:	0f 85 80 00 00 00    	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff5a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  6fff61:	00 
  6fff62:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  6fff69:	75 6f                	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff6b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  6fff72:	00 
  6fff73:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  6fff7a:	00 
  6fff7b:	e8 a0 bf 02 00       	call   72bf20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  6fff80:	84 c0                	test   %al,%al
  6fff82:	74 56                	je     6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff84:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  6fff8b:	00 00 
  6fff8d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  6fff94:	00 00 
  6fff96:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fff9a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fff9e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fffa3:	75 35                	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fffa5:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  6fffac:	00 00 
  6fffae:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  6fffb5:	00 00 
  6fffb7:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fffbb:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fffbf:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fffc4:	75 14                	jne    6fffda <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fffc6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fffcb:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fffd0:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fffd5:	e9 08 01 00 00       	jmp    7000e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1712>
  6fffda:	48 8d 05 c7 b9 3f 00 	lea    0x3fb9c7(%rip),%rax        # afb9a8 <__frame_dummy_init_array_entry+0x10a0>
  6fffe1:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fffe6:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  6fffea:	75 11                	jne    6ffffd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x162d>
  6fffec:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6ffff3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ffff8:	e8 83 55 04 00       	call   745580 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6ffffd:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  700003:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  700008:	75 5a                	jne    700064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  70000a:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  700011:	00 
  700012:	8b 40 20             	mov    0x20(%rax),%eax
  700015:	89 c1                	mov    %eax,%ecx
  700017:	83 e1 07             	and    $0x7,%ecx
  70001a:	83 f9 06             	cmp    $0x6,%ecx
  70001d:	74 45                	je     700064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  70001f:	c1 e8 03             	shr    $0x3,%eax
  700022:	74 40                	je     700064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  700024:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  70002b:	ff c8                	dec    %eax
  70002d:	48 39 c6             	cmp    %rax,%rsi
  700030:	0f 86 fd 07 00 00    	jbe    700833 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e63>
  700036:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  70003d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  700041:	48 c1 e0 04          	shl    $0x4,%rax
  700045:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  70004b:	0f 84 65 07 00 00    	je     7007b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1de6>
  700051:	48 01 c5             	add    %rax,%rbp
  700054:	48 89 ef             	mov    %rbp,%rdi
  700057:	e8 74 49 ff ff       	call   6f49d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  70005c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  700063:	ff 
  700064:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  70006b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  700072:	4c 89 e6             	mov    %r12,%rsi
  700075:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  70007c:	00 
  70007d:	ff 15 25 95 42 00    	call   *0x429525(%rip)        # b295a8 <_DYNAMIC+0x438>
  700083:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70008a:	01 
  70008b:	b0 01                	mov    $0x1,%al
  70008d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  700094:	00 
  700095:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70009a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70009f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  7000a4:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  7000ab:	00 
  7000ac:	0f 94 c0             	sete   %al
  7000af:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  7000b6:	74 0c                	je     7000c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16f4>
  7000b8:	b0 01                	mov    $0x1,%al
  7000ba:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7000c1:	00 
  7000c2:	eb 19                	jmp    7000dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x170d>
  7000c4:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  7000cb:	b0 01                	mov    $0x1,%al
  7000cd:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7000d4:	00 
  7000d5:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  7000dc:	00 
  7000dd:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7000e2:	48 83 c1 04          	add    $0x4,%rcx
  7000e6:	48 39 c8             	cmp    %rcx,%rax
  7000e9:	0f 85 cc f5 ff ff    	jne    6ff6bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xceb>
  7000ef:	e9 ee 02 00 00       	jmp    7003e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a12>
  7000f4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7000f8:	ff 15 f2 92 42 00    	call   *0x4292f2(%rip)        # b293f0 <_DYNAMIC+0x280>
  7000fe:	e9 75 fa ff ff       	jmp    6ffb78 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  700103:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700107:	ff 15 e3 92 42 00    	call   *0x4292e3(%rip)        # b293f0 <_DYNAMIC+0x280>
  70010d:	e9 a1 f9 ff ff       	jmp    6ffab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  700112:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700116:	ff 15 d4 92 42 00    	call   *0x4292d4(%rip)        # b293f0 <_DYNAMIC+0x280>
  70011c:	e9 df fa ff ff       	jmp    6ffc00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  700121:	49 83 c4 04          	add    $0x4,%r12
  700125:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  70012a:	0f 84 b1 f4 ff ff    	je     6ff5e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xc11>
  700130:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  700135:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  700139:	ff 15 31 94 42 00    	call   *0x429431(%rip)        # b29570 <_DYNAMIC+0x400>
  70013f:	66 85 c0             	test   %ax,%ax
  700142:	74 dd                	je     700121 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1751>
  700144:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  700149:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  70014e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  700155:	00 
  700156:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  70015b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  70015f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  700166:	00 00 
  700168:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  70016c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  700173:	00 
  700174:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  700179:	89 c2                	mov    %eax,%edx
  70017b:	ff 15 f7 93 42 00    	call   *0x4293f7(%rip)        # b29578 <_DYNAMIC+0x408>
  700181:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  700188:	ff 
  700189:	75 96                	jne    700121 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1751>
  70018b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  700192:	00 
  700193:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70019a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  7001a1:	00 
  7001a2:	48 c1 e5 20          	shl    $0x20,%rbp
  7001a6:	48 09 c5             	or     %rax,%rbp
  7001a9:	b8 24 00 00 00       	mov    $0x24,%eax
  7001ae:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7001b3:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7001b8:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7001bd:	48 85 f6             	test   %rsi,%rsi
  7001c0:	0f 8e 12 02 00 00    	jle    7003d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a08>
  7001c6:	ba 01 00 00 00       	mov    $0x1,%edx
  7001cb:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  7001cf:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7001d4:	ff 15 de 91 42 00    	call   *0x4291de(%rip)        # b293b8 <_DYNAMIC+0x248>
  7001da:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7001de:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7001e3:	e9 1f 03 00 00       	jmp    700507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  7001e8:	31 ff                	xor    %edi,%edi
  7001ea:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7001ef:	48 85 f6             	test   %rsi,%rsi
  7001f2:	7e 5c                	jle    700250 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  7001f4:	ba 01 00 00 00       	mov    $0x1,%edx
  7001f9:	89 fd                	mov    %edi,%ebp
  7001fb:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  700200:	ff 15 b2 91 42 00    	call   *0x4291b2(%rip)        # b293b8 <_DYNAMIC+0x248>
  700206:	89 ef                	mov    %ebp,%edi
  700208:	eb 46                	jmp    700250 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  70020a:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  700211:	00 
  700212:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  700219:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  700220:	00 
  700221:	48 c1 e5 20          	shl    $0x20,%rbp
  700225:	48 09 c5             	or     %rax,%rbp
  700228:	b8 24 00 00 00       	mov    $0x24,%eax
  70022d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700232:	e9 99 02 00 00       	jmp    7004d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  700237:	b0 01                	mov    $0x1,%al
  700239:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  70023e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  700245:	48 85 ed             	test   %rbp,%rbp
  700248:	0f 85 0e ef ff ff    	jne    6ff15c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x78c>
  70024e:	31 ff                	xor    %edi,%edi
  700250:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  700255:	74 3c                	je     700293 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18c3>
  700257:	41 80 be 1f 07 00 00 	cmpb   $0x1,0x71f(%r14)
  70025e:	01 
  70025f:	75 32                	jne    700293 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18c3>
  700261:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  700266:	4c 89 f6             	mov    %r14,%rsi
  700269:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  700270:	00 
  700271:	31 c9                	xor    %ecx,%ecx
  700273:	e8 98 d7 ff ff       	call   6fda10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  700278:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  70027d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  700281:	75 1e                	jne    7002a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18d1>
  700283:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70028a:	ff ff 
  70028c:	31 ff                	xor    %edi,%edi
  70028e:	e9 94 02 00 00       	jmp    700527 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  700293:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70029a:	ff ff 
  70029c:	e9 86 02 00 00       	jmp    700527 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  7002a1:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  7002a6:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  7002ab:	c1 e1 10             	shl    $0x10,%ecx
  7002ae:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  7002b3:	09 ca                	or     %ecx,%edx
  7002b5:	48 c1 e2 20          	shl    $0x20,%rdx
  7002b9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  7002bd:	48 09 d5             	or     %rdx,%rbp
  7002c0:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  7002c7:	00 
  7002c8:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  7002cf:	00 
  7002d0:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  7002d7:	00 00 
  7002d9:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  7002e0:	00 00 
  7002e2:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  7002e9:	00 
  7002ea:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  7002f1:	00 
  7002f2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7002f7:	e9 2b 02 00 00       	jmp    700527 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  7002fc:	b8 20 00 00 00       	mov    $0x20,%eax
  700301:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700306:	40 b7 0c             	mov    $0xc,%dil
  700309:	31 ed                	xor    %ebp,%ebp
  70030b:	4d 89 f8             	mov    %r15,%r8
  70030e:	e9 bd 01 00 00       	jmp    7004d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  700313:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  70031a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  70031e:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  700325:	40 0f 94 c5          	sete   %bpl
  700329:	48 ff c0             	inc    %rax
  70032c:	0f 84 d5 f0 ff ff    	je     6ff407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa37>
  700332:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  700339:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  700340:	00 
  700341:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  700348:	00 
  700349:	ff 15 61 92 42 00    	call   *0x429261(%rip)        # b295b0 <_DYNAMIC+0x440>
  70034f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  700356:	00 
  700357:	74 21                	je     70037a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19aa>
  700359:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  700360:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  700367:	40 84 ed             	test   %bpl,%bpl
  70036a:	0f 84 48 01 00 00    	je     7004b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae8>
  700370:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  700377:	00 
  700378:	eb 16                	jmp    700390 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19c0>
  70037a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  700381:	00 00 00 00 
  700385:	31 d2                	xor    %edx,%edx
  700387:	40 84 ed             	test   %bpl,%bpl
  70038a:	0f 84 28 01 00 00    	je     7004b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae8>
  700390:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  700395:	4c 89 f6             	mov    %r14,%rsi
  700398:	e8 e3 0a 00 00       	call   700e80 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::finish_color_slot>
  70039d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  7003a2:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  7003a7:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7003ab:	0f 85 8c 00 00 00    	jne    70043d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a6d>
  7003b1:	40 f6 c7 01          	test   $0x1,%dil
  7003b5:	0f 84 f6 00 00 00    	je     7004b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae1>
  7003bb:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  7003c2:	ff ff 
  7003c4:	40 b7 02             	mov    $0x2,%dil
  7003c7:	e9 04 01 00 00       	jmp    7004d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  7003cc:	31 ff                	xor    %edi,%edi
  7003ce:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7003d3:	e9 12 fe ff ff       	jmp    7001ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  7003d8:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7003dd:	e9 25 01 00 00       	jmp    700507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  7003e2:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  7003e9:	00 
  7003ea:	34 01                	xor    $0x1,%al
  7003ec:	0f b6 c0             	movzbl %al,%eax
  7003ef:	31 ff                	xor    %edi,%edi
  7003f1:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  7003f8:	01 
  7003f9:	0f 45 f8             	cmovne %eax,%edi
  7003fc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  700401:	48 85 c0             	test   %rax,%rax
  700404:	0f 84 e0 fd ff ff    	je     7001ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  70040a:	f6 00 01             	testb  $0x1,(%rax)
  70040d:	0f 85 d7 fd ff ff    	jne    7001ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  700413:	89 fd                	mov    %edi,%ebp
  700415:	48 8b 40 08          	mov    0x8(%rax),%rax
  700419:	a8 01                	test   $0x1,%al
  70041b:	75 14                	jne    700431 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a61>
  70041d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  700422:	48 83 c0 08          	add    $0x8,%rax
  700426:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70042b:	0f 84 b5 03 00 00    	je     7007e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e16>
  700431:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  700436:	89 ef                	mov    %ebp,%edi
  700438:	e9 ad fd ff ff       	jmp    7001ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  70043d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700442:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  700447:	c1 e0 10             	shl    $0x10,%eax
  70044a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  70044f:	09 c1                	or     %eax,%ecx
  700451:	48 c1 e1 20          	shl    $0x20,%rcx
  700455:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  700459:	48 09 cd             	or     %rcx,%rbp
  70045c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  700463:	00 
  700464:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  70046b:	00 
  70046c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  700473:	00 
  700474:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  70047b:	00 
  70047c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  700483:	00 
  700484:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  70048b:	00 
  70048c:	eb 42                	jmp    7004d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  70048e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  700495:	00 
  700496:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70049d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  7004a4:	00 
  7004a5:	48 c1 e5 20          	shl    $0x20,%rbp
  7004a9:	48 09 c5             	or     %rax,%rbp
  7004ac:	e9 85 01 00 00       	jmp    700636 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c66>
  7004b1:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  7004b8:	48 85 d2             	test   %rdx,%rdx
  7004bb:	0f 95 c0             	setne  %al
  7004be:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  7004c5:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  7004cc:	ff ff 
  7004ce:	31 ff                	xor    %edi,%edi
  7004d0:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7004d5:	48 85 f6             	test   %rsi,%rsi
  7004d8:	7e 22                	jle    7004fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b2c>
  7004da:	ba 01 00 00 00       	mov    $0x1,%edx
  7004df:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  7004e4:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  7004e8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  7004ed:	ff 15 c5 8e 42 00    	call   *0x428ec5(%rip)        # b293b8 <_DYNAMIC+0x248>
  7004f3:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7004f7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7004fc:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  700501:	0f 84 49 fd ff ff    	je     700250 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  700507:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  70050e:	00 
  70050f:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  700516:	00 
  700517:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  70051e:	00 
  70051f:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  700526:	00 
  700527:	40 0f b6 c7          	movzbl %dil,%eax
  70052b:	48 c1 e5 08          	shl    $0x8,%rbp
  70052f:	48 09 c5             	or     %rax,%rbp
  700532:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  700539:	00 
  70053a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  700541:	00 
  700542:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  700549:	00 00 
  70054b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  700552:	00 00 
  700554:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  700559:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  700560:	00 
  700561:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  700568:	00 
  700569:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  700570:	00 
  700571:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  700578:	00 
  700579:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  700580:	00 00 
  700582:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  700589:	00 
  70058a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  700591:	00 
  700592:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  700599:	00 
  70059a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  7005a1:	00 
  7005a2:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  7005a9:	00 
  7005aa:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  7005b1:	00 
  7005b2:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  7005b9:	00 
  7005ba:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  7005c1:	00 
  7005c2:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  7005c9:	00 
  7005ca:	31 ed                	xor    %ebp,%ebp
  7005cc:	e9 41 e6 ff ff       	jmp    6fec12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x242>
  7005d1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7005d6:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  7005db:	c1 e0 10             	shl    $0x10,%eax
  7005de:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  7005e3:	09 c1                	or     %eax,%ecx
  7005e5:	48 c1 e1 20          	shl    $0x20,%rcx
  7005e9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  7005ed:	48 09 cd             	or     %rcx,%rbp
  7005f0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  7005f7:	00 
  7005f8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7005fd:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  700604:	00 
  700605:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  70060c:	00 00 
  70060e:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  700615:	00 00 
  700617:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  70061e:	00 
  70061f:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  700626:	00 
  700627:	eb 17                	jmp    700640 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c70>
  700629:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  700630:	00 00 00 
  700633:	48 21 c5             	and    %rax,%rbp
  700636:	b8 24 00 00 00       	mov    $0x24,%eax
  70063b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700640:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  700645:	48 85 c9             	test   %rcx,%rcx
  700648:	0f 84 65 fb ff ff    	je     7001b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  70064e:	f6 01 01             	testb  $0x1,(%rcx)
  700651:	0f 85 5c fb ff ff    	jne    7001b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  700657:	48 8b 41 08          	mov    0x8(%rcx),%rax
  70065b:	a8 01                	test   $0x1,%al
  70065d:	0f 85 50 fb ff ff    	jne    7001b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  700663:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  700667:	48 8d 41 08          	lea    0x8(%rcx),%rax
  70066b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  700670:	0f 84 53 01 00 00    	je     7007c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1df9>
  700676:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70067b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  70067f:	e9 34 fb ff ff       	jmp    7001b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e8>
  700684:	48 8d 3d 3d a7 3f 00 	lea    0x3fa73d(%rip),%rdi        # afadc8 <__frame_dummy_init_array_entry+0x4c0>
  70068b:	ff 15 e7 8d 42 00    	call   *0x428de7(%rip)        # b29478 <_DYNAMIC+0x308>
  700691:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700695:	ff 15 55 8d 42 00    	call   *0x428d55(%rip)        # b293f0 <_DYNAMIC+0x280>
  70069b:	e9 c0 e6 ff ff       	jmp    6fed60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  7006a0:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  7006a6:	eb 3c                	jmp    7006e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d14>
  7006a8:	48 8d 05 05 a1 96 ff 	lea    -0x695efb(%rip),%rax        # 6a7b4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  7006af:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  7006b6:	00 
  7006b7:	48 8d 05 72 af 3f 00 	lea    0x3faf72(%rip),%rax        # afb630 <__frame_dummy_init_array_entry+0xd28>
  7006be:	eb 1c                	jmp    7006dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d0c>
  7006c0:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  7006c6:	48 8d 05 d3 a0 96 ff 	lea    -0x695f2d(%rip),%rax        # 6a7a0 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b3>
  7006cd:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  7006d4:	00 
  7006d5:	48 8d 05 3c af 3f 00 	lea    0x3faf3c(%rip),%rax        # afb618 <__frame_dummy_init_array_entry+0xd10>
  7006dc:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  7006e3:	00 
  7006e4:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  7006eb:	00 
  7006ec:	4c 89 e6             	mov    %r12,%rsi
  7006ef:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  7006f6:	00 
  7006f7:	ff 15 bb 8d 42 00    	call   *0x428dbb(%rip)        # b294b8 <_DYNAMIC+0x348>
  7006fd:	e9 a7 01 00 00       	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700702:	48 8d 3d 6f a0 96 ff 	lea    -0x695f91(%rip),%rdi        # 6a778 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348b>
  700709:	48 8d 15 a8 ae 3f 00 	lea    0x3faea8(%rip),%rdx        # afb5b8 <__frame_dummy_init_array_entry+0xcb0>
  700710:	be 13 00 00 00       	mov    $0x13,%esi
  700715:	ff 15 9d 8d 42 00    	call   *0x428d9d(%rip)        # b294b8 <_DYNAMIC+0x348>
  70071b:	e9 89 01 00 00       	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700720:	48 8d 3d ce a0 96 ff 	lea    -0x695f32(%rip),%rdi        # 6a7f5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3508>
  700727:	48 8d 15 62 af 3f 00 	lea    0x3faf62(%rip),%rdx        # afb690 <__frame_dummy_init_array_entry+0xd88>
  70072e:	be 93 00 00 00       	mov    $0x93,%esi
  700733:	ff 15 7f 8e 42 00    	call   *0x428e7f(%rip)        # b295b8 <_DYNAMIC+0x448>
  700739:	e9 6b 01 00 00       	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70073e:	48 8d 05 9a a0 96 ff 	lea    -0x695f66(%rip),%rax        # 6a7df <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34f2>
  700745:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  70074c:	00 
  70074d:	48 8d 05 f4 ae 3f 00 	lea    0x3faef4(%rip),%rax        # afb648 <__frame_dummy_init_array_entry+0xd40>
  700754:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  70075b:	00 
  70075c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  700763:	00 
  700764:	4c 89 ee             	mov    %r13,%rsi
  700767:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  70076e:	00 
  70076f:	ff 15 43 8d 42 00    	call   *0x428d43(%rip)        # b294b8 <_DYNAMIC+0x348>
  700775:	e9 2f 01 00 00       	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70077a:	48 8d 3d 07 a3 3f 00 	lea    0x3fa307(%rip),%rdi        # afaa88 <__frame_dummy_init_array_entry+0x180>
  700781:	ff 15 f1 8c 42 00    	call   *0x428cf1(%rip)        # b29478 <_DYNAMIC+0x308>
  700787:	e9 1d 01 00 00       	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70078c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  700793:	00 00 
  700795:	48 8d 3d c4 ae 3f 00 	lea    0x3faec4(%rip),%rdi        # afb660 <__frame_dummy_init_array_entry+0xd58>
  70079c:	ff 15 d6 8c 42 00    	call   *0x428cd6(%rip)        # b29478 <_DYNAMIC+0x308>
  7007a2:	e9 02 01 00 00       	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  7007a7:	48 8d 05 aa a2 3f 00 	lea    0x3fa2aa(%rip),%rax        # afaa58 <__frame_dummy_init_array_entry+0x150>
  7007ae:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  7007b5:	00 
  7007b6:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  7007bd:	00 
  7007be:	ff 15 b4 8c 42 00    	call   *0x428cb4(%rip)        # b29478 <_DYNAMIC+0x308>
  7007c4:	e9 e0 00 00 00       	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  7007c9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  7007ce:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7007d2:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7007d7:	ff 15 13 8c 42 00    	call   *0x428c13(%rip)        # b293f0 <_DYNAMIC+0x280>
  7007dd:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7007e1:	e9 d2 f9 ff ff       	jmp    7001b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e8>
  7007e6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  7007eb:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7007ef:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7007f4:	ff 15 f6 8b 42 00    	call   *0x428bf6(%rip)        # b293f0 <_DYNAMIC+0x280>
  7007fa:	89 ef                	mov    %ebp,%edi
  7007fc:	e9 e9 f9 ff ff       	jmp    7001ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  700801:	48 8d 15 68 a2 3f 00 	lea    0x3fa268(%rip),%rdx        # afaa70 <__frame_dummy_init_array_entry+0x168>
  700808:	ff 15 ba 8c 42 00    	call   *0x428cba(%rip)        # b294c8 <_DYNAMIC+0x358>
  70080e:	e9 96 00 00 00       	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700813:	48 8d 05 f6 a5 3f 00 	lea    0x3fa5f6(%rip),%rax        # afae10 <__frame_dummy_init_array_entry+0x508>
  70081a:	eb 47                	jmp    700863 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  70081c:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  700821:	48 8d 05 00 a6 3f 00 	lea    0x3fa600(%rip),%rax        # afae28 <__frame_dummy_init_array_entry+0x520>
  700828:	eb 39                	jmp    700863 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  70082a:	48 8d 05 c7 a5 3f 00 	lea    0x3fa5c7(%rip),%rax        # afadf8 <__frame_dummy_init_array_entry+0x4f0>
  700831:	eb 30                	jmp    700863 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  700833:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  700838:	48 8d 05 31 a2 3f 00 	lea    0x3fa231(%rip),%rax        # afaa70 <__frame_dummy_init_array_entry+0x168>
  70083f:	eb 22                	jmp    700863 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  700841:	48 85 ff             	test   %rdi,%rdi
  700844:	75 34                	jne    70087a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1eaa>
  700846:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  70084d:	00 00 
  70084f:	ff 15 6b 8d 42 00    	call   *0x428d6b(%rip)        # b295c0 <_DYNAMIC+0x450>
  700855:	eb 52                	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700857:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  70085c:	48 8d 05 dd a1 3f 00 	lea    0x3fa1dd(%rip),%rax        # afaa40 <__frame_dummy_init_array_entry+0x138>
  700863:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  700868:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70086d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  700872:	ff 15 50 8c 42 00    	call   *0x428c50(%rip)        # b294c8 <_DYNAMIC+0x358>
  700878:	eb 2f                	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70087a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  70087f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  700886:	00 00 
  700888:	ff 15 52 8b 42 00    	call   *0x428b52(%rip)        # b293e0 <_DYNAMIC+0x270>
  70088e:	eb 19                	jmp    7008a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700890:	48 8d 3d f4 9e 96 ff 	lea    -0x69610c(%rip),%rdi        # 6a78b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  700897:	48 8d 15 32 ad 3f 00 	lea    0x3fad32(%rip),%rdx        # afb5d0 <__frame_dummy_init_array_entry+0xcc8>
  70089e:	be 15 00 00 00       	mov    $0x15,%esi
  7008a3:	ff 15 0f 8c 42 00    	call   *0x428c0f(%rip)        # b294b8 <_DYNAMIC+0x348>
  7008a9:	0f 0b                	ud2
  7008ab:	49 89 c5             	mov    %rax,%r13
  7008ae:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7008b3:	48 89 45 10          	mov    %rax,0x10(%rbp)
  7008b7:	eb 6d                	jmp    700926 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  7008b9:	49 89 c5             	mov    %rax,%r13
  7008bc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7008c1:	48 89 45 08          	mov    %rax,0x8(%rbp)
  7008c5:	eb 5f                	jmp    700926 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  7008c7:	49 89 c5             	mov    %rax,%r13
  7008ca:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  7008ce:	eb 56                	jmp    700926 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  7008d0:	48 89 c3             	mov    %rax,%rbx
  7008d3:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  7008da:	00 
  7008db:	e8 10 77 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7008e0:	48 89 df             	mov    %rbx,%rdi
  7008e3:	e8 68 8c 3f 00       	call   af9550 <_Unwind_Resume@plt>
  7008e8:	eb 18                	jmp    700902 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f32>
  7008ea:	eb 16                	jmp    700902 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f32>
  7008ec:	eb 00                	jmp    7008ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f1e>
  7008ee:	49 89 c5             	mov    %rax,%r13
  7008f1:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  7008f8:	ff 
  7008f9:	eb 2b                	jmp    700926 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  7008fb:	49 89 c5             	mov    %rax,%r13
  7008fe:	eb 4d                	jmp    70094d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  700900:	eb 21                	jmp    700923 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f53>
  700902:	49 89 c5             	mov    %rax,%r13
  700905:	eb 29                	jmp    700930 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f60>
  700907:	49 89 c5             	mov    %rax,%r13
  70090a:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  700910:	7e 3b                	jle    70094d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  700912:	ba 01 00 00 00       	mov    $0x1,%edx
  700917:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70091c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  700921:	eb 24                	jmp    700947 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f77>
  700923:	49 89 c5             	mov    %rax,%r13
  700926:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70092b:	e8 10 40 ff ff       	call   6f4940 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  700930:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  700936:	7e 15                	jle    70094d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  700938:	ba 01 00 00 00       	mov    $0x1,%edx
  70093d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  700942:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  700947:	ff 15 6b 8a 42 00    	call   *0x428a6b(%rip)        # b293b8 <_DYNAMIC+0x248>
  70094d:	4c 89 ef             	mov    %r13,%rdi
  700950:	ff 15 82 8b 42 00    	call   *0x428b82(%rip)        # b294d8 <_DYNAMIC+0x368>
  700956:	49 89 c5             	mov    %rax,%r13
  700959:	48 89 d5             	mov    %rdx,%rbp
  70095c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  700963:	00 
  700964:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  70096b:	00 
  70096c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  700973:	00 fd ff ff ff 
  700978:	4c 89 f7             	mov    %r14,%rdi
  70097b:	e8 30 8a 02 00       	call   7293b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  700980:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  700987:	00 0f 00 00 00 
  70098c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  700990:	48 85 c0             	test   %rax,%rax
  700993:	74 05                	je     70099a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fca>
  700995:	4c 89 ef             	mov    %r13,%rdi
  700998:	ff d0                	call   *%rax
  70099a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70099e:	48 85 f6             	test   %rsi,%rsi
  7009a1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7009a6:	74 0d                	je     7009b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fe5>
  7009a8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  7009ac:	4c 89 ef             	mov    %r13,%rdi
  7009af:	ff 15 03 8a 42 00    	call   *0x428a03(%rip)        # b293b8 <_DYNAMIC+0x248>
  7009b5:	31 ed                	xor    %ebp,%ebp
  7009b7:	e9 56 e2 ff ff       	jmp    6fec12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x242>
  7009bc:	48 89 c3             	mov    %rax,%rbx
  7009bf:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  7009c3:	48 85 f6             	test   %rsi,%rsi
  7009c6:	74 2b                	je     7009f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2023>
  7009c8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  7009cc:	4c 89 ef             	mov    %r13,%rdi
  7009cf:	ff 15 e3 89 42 00    	call   *0x4289e3(%rip)        # b293b8 <_DYNAMIC+0x248>
  7009d5:	48 89 df             	mov    %rbx,%rdi
  7009d8:	e8 73 8b 3f 00       	call   af9550 <_Unwind_Resume@plt>
  7009dd:	ff 15 05 8a 42 00    	call   *0x428a05(%rip)        # b293e8 <_DYNAMIC+0x278>
  7009e3:	48 89 c3             	mov    %rax,%rbx
  7009e6:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  7009ed:	00 
  7009ee:	e8 1d 44 ff ff       	call   6f4e10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  7009f3:	48 89 df             	mov    %rbx,%rdi
  7009f6:	e8 55 8b 3f 00       	call   af9550 <_Unwind_Resume@plt>
  7009fb:	ff 15 e7 89 42 00    	call   *0x4289e7(%rip)        # b293e8 <_DYNAMIC+0x278>
  700a01:	ff 15 d9 8a 42 00    	call   *0x428ad9(%rip)        # b294e0 <_DYNAMIC+0x370>
