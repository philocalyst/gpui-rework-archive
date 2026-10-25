
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fad30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>:
  6fad30:	55                   	push   %rbp
  6fad31:	41 57                	push   %r15
  6fad33:	41 56                	push   %r14
  6fad35:	41 55                	push   %r13
  6fad37:	41 54                	push   %r12
  6fad39:	53                   	push   %rbx
  6fad3a:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  6fad41:	4d 89 c4             	mov    %r8,%r12
  6fad44:	49 89 cf             	mov    %rcx,%r15
  6fad47:	49 89 f6             	mov    %rsi,%r14
  6fad4a:	48 89 fb             	mov    %rdi,%rbx
  6fad4d:	41 83 38 02          	cmpl   $0x2,(%r8)
  6fad51:	75 08                	jne    6fad5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2b>
  6fad53:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fad5a:	01 
  6fad5b:	4d 85 ff             	test   %r15,%r15
  6fad5e:	0f 84 94 01 00 00    	je     6faef8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c8>
  6fad64:	41 80 be 1e 08 00 00 	cmpb   $0x1,0x81e(%r14)
  6fad6b:	01 
  6fad6c:	0f 85 86 01 00 00    	jne    6faef8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c8>
  6fad72:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  6fad79:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  6fad80:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fad84:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  6fad89:	48 0f 44 ce          	cmove  %rsi,%rcx
  6fad8d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  6fad91:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  6fad98:	00 00 
  6fad9a:	74 45                	je     6fade1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb1>
  6fad9c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  6fada3:	00 00 
  6fada5:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  6fadac:	00 00 
  6fadae:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fadb5:	00 
  6fadb6:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  6fadbd:	00 
  6fadbe:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6fadc5:	00 
  6fadc6:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  6fadca:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  6fadce:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fadd5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fadd9:	88 4b 10             	mov    %cl,0x10(%rbx)
  6faddc:	e9 5e 03 00 00       	jmp    6fb13f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fade1:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  6fade6:	41 83 ff 01          	cmp    $0x1,%r15d
  6fadea:	0f 85 80 00 00 00    	jne    6fae70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x140>
  6fadf0:	48 89 d5             	mov    %rdx,%rbp
  6fadf3:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  6fadfa:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  6fae01:	49 c1 e4 04          	shl    $0x4,%r12
  6fae05:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6fae0c:	00 00 00 00 
  6fae10:	4d 85 e4             	test   %r12,%r12
  6fae13:	0f 84 7a 03 00 00    	je     6fb193 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x463>
  6fae19:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  6fae1d:	48 8b 39             	mov    (%rcx),%rdi
  6fae20:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fae24:	ff 50 18             	call   *0x18(%rax)
  6fae27:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  6fae2b:	4c 89 e9             	mov    %r13,%rcx
  6fae2e:	4c 39 f8             	cmp    %r15,%rax
  6fae31:	75 dd                	jne    6fae10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xe0>
  6fae33:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  6fae3a:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  6fae41:	48 c1 e0 03          	shl    $0x3,%rax
  6fae45:	31 f6                	xor    %esi,%esi
  6fae47:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fae4c:	0f 1f 40 00          	nopl   0x0(%rax)
  6fae50:	48 89 f2             	mov    %rsi,%rdx
  6fae53:	48 39 f0             	cmp    %rsi,%rax
  6fae56:	74 0a                	je     6fae62 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x132>
  6fae58:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  6fae5c:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  6fae60:	75 ee                	jne    6fae50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x120>
  6fae62:	48 39 d0             	cmp    %rdx,%rax
  6fae65:	0f 95 c1             	setne  %cl
  6fae68:	48 89 ea             	mov    %rbp,%rdx
  6fae6b:	e9 7f 00 00 00       	jmp    6faeef <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1bf>
  6fae70:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fae77:	00 
  6fae78:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  6fae7f:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  6fae86:	49 c1 e5 04          	shl    $0x4,%r13
  6fae8a:	31 ed                	xor    %ebp,%ebp
  6fae8c:	0f 1f 40 00          	nopl   0x0(%rax)
  6fae90:	49 39 ed             	cmp    %rbp,%r13
  6fae93:	0f 84 0e 03 00 00    	je     6fb1a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x477>
  6fae99:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  6fae9d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  6faea2:	4c 89 fe             	mov    %r15,%rsi
  6faea5:	ff 50 30             	call   *0x30(%rax)
  6faea8:	48 83 c5 10          	add    $0x10,%rbp
  6faeac:	84 c0                	test   %al,%al
  6faeae:	74 e0                	je     6fae90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160>
  6faeb0:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  6faeb5:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  6faeba:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  6faec1:	00 
  6faec2:	4c 89 fa             	mov    %r15,%rdx
  6faec5:	ff 50 60             	call   *0x60(%rax)
  6faec8:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  6faecf:	00 
  6faed0:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6faed7:	00 
  6faed8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6faedc:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6faee1:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6faee8:	00 
  6faee9:	0f 85 c7 fe ff ff    	jne    6fadb6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6faeef:	f6 c1 01             	test   $0x1,%cl
  6faef2:	0f 84 f4 02 00 00    	je     6fb1ec <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x4bc>
  6faef8:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  6faeff:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6faf04:	4c 89 f6             	mov    %r14,%rsi
  6faf07:	31 c9                	xor    %ecx,%ecx
  6faf09:	e8 92 f5 ff ff       	call   6fa4a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  6faf0e:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  6faf13:	75 16                	jne    6faf2b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fb>
  6faf15:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  6faf1c:	00 
  6faf1d:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  6faf24:	00 fe ff ff ff 
  6faf29:	eb 41                	jmp    6faf6c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x23c>
  6faf2b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6faf32:	00 
  6faf33:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6faf3a:	00 
  6faf3b:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  6faf41:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  6faf48:	00 00 
  6faf4a:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  6faf51:	00 
  6faf52:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  6faf59:	00 
  6faf5a:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  6faf61:	00 00 
  6faf63:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  6faf6a:	00 00 
  6faf6c:	40 b5 01             	mov    $0x1,%bpl
  6faf6f:	45 31 ff             	xor    %r15d,%r15d
  6faf72:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  6faf79:	00 fe 
  6faf7b:	0f 85 ba 00 00 00    	jne    6fb03b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x30b>
  6faf81:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6faf88:	00 
  6faf89:	4c 89 f6             	mov    %r14,%rsi
  6faf8c:	4c 89 e2             	mov    %r12,%rdx
  6faf8f:	e8 6c 57 00 00       	call   700700 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::reconcile_editing>
  6faf94:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6faf9b:	00 
  6faf9c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  6fafa3:	00 00 
  6fafa5:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fafa9:	0f 85 61 01 00 00    	jne    6fb110 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x3e0>
  6fafaf:	48 8d 35 c2 ca 96 ff 	lea    -0x69353e(%rip),%rsi        # 67a78 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x98b>
  6fafb6:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fafbd:	00 
  6fafbe:	e8 3d 00 03 00       	call   72b000 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fafc3:	84 c0                	test   %al,%al
  6fafc5:	74 26                	je     6fafed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2bd>
  6fafc7:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fafce:	48 85 c0             	test   %rax,%rax
  6fafd1:	0f 84 7a 01 00 00    	je     6fb151 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x421>
  6fafd7:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fafde:	00 
  6fafdf:	0f 95 c0             	setne  %al
  6fafe2:	44 08 e0             	or     %r12b,%al
  6fafe5:	a8 01                	test   $0x1,%al
  6fafe7:	0f 84 6e 01 00 00    	je     6fb15b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x42b>
  6fafed:	48 8d 35 bc ca 96 ff 	lea    -0x693544(%rip),%rsi        # 67ab0 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x9c3>
  6faff4:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6faffb:	00 
  6faffc:	e8 ff ff 02 00       	call   72b000 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fb001:	84 c0                	test   %al,%al
  6fb003:	74 26                	je     6fb02b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2fb>
  6fb005:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fb00c:	48 85 c0             	test   %rax,%rax
  6fb00f:	0f 84 a7 01 00 00    	je     6fb1bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x48c>
  6fb015:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fb01c:	00 
  6fb01d:	0f 95 c0             	setne  %al
  6fb020:	44 08 e0             	or     %r12b,%al
  6fb023:	a8 01                	test   $0x1,%al
  6fb025:	0f 84 9b 01 00 00    	je     6fb1c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x496>
  6fb02b:	48 89 df             	mov    %rbx,%rdi
  6fb02e:	4c 89 f6             	mov    %r14,%rsi
  6fb031:	e8 ea e8 01 00       	call   719920 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  6fb036:	e9 04 01 00 00       	jmp    6fb13f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fb03b:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  6fb042:	00 
  6fb043:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fb04a:	00 
  6fb04b:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  6fb052:	00 
  6fb053:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  6fb05a:	00 
  6fb05b:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  6fb062:	00 
  6fb063:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  6fb06a:	00 
  6fb06b:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  6fb072:	00 
  6fb073:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  6fb07a:	00 
  6fb07b:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fb082:	48 85 c0             	test   %rax,%rax
  6fb085:	74 41                	je     6fb0c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fb087:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fb08e:	48 85 c0             	test   %rax,%rax
  6fb091:	74 35                	je     6fb0c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fb093:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fb097:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  6fb09b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  6fb09f:	80 f9 02             	cmp    $0x2,%cl
  6fb0a2:	74 24                	je     6fb0c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x398>
  6fb0a4:	f6 07 01             	testb  $0x1,(%rdi)
  6fb0a7:	75 17                	jne    6fb0c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fb0a9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fb0ad:	a8 01                	test   $0x1,%al
  6fb0af:	75 0f                	jne    6fb0c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fb0b1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fb0b5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fb0ba:	0f 84 31 19 00 00    	je     6fc9f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cc1>
  6fb0c0:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fb0c7:	01 
  6fb0c8:	41 c6 86 1e 08 00 00 	movb   $0x0,0x81e(%r14)
  6fb0cf:	00 
  6fb0d0:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fb0d7:	00 00 00 00 
  6fb0db:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6fb0e2:	00 
  6fb0e3:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fb0e7:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  6fb0ee:	00 00 
  6fb0f0:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  6fb0f7:	00 00 
  6fb0f9:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  6fb100:	00 
  6fb101:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fb105:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  6fb10a:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  6fb10e:	eb 2f                	jmp    6fb13f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fb110:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  6fb117:	00 00 
  6fb119:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  6fb120:	00 00 
  6fb122:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6fb129:	00 
  6fb12a:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6fb12e:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  6fb133:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  6fb138:	48 89 03             	mov    %rax,(%rbx)
  6fb13b:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  6fb13f:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  6fb146:	5b                   	pop    %rbx
  6fb147:	41 5c                	pop    %r12
  6fb149:	41 5d                	pop    %r13
  6fb14b:	41 5e                	pop    %r14
  6fb14d:	41 5f                	pop    %r15
  6fb14f:	5d                   	pop    %rbp
  6fb150:	c3                   	ret
  6fb151:	41 80 fc 01          	cmp    $0x1,%r12b
  6fb155:	0f 84 92 fe ff ff    	je     6fafed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2bd>
  6fb15b:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  6fb162:	00 00 
  6fb164:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  6fb16b:	00 
  6fb16c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fb173:	00 
  6fb174:	74 16                	je     6fb18c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x45c>
  6fb176:	84 c0                	test   %al,%al
  6fb178:	0f 84 c7 00 00 00    	je     6fb245 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x515>
  6fb17e:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fb185:	ff 
  6fb186:	0f 85 b9 00 00 00    	jne    6fb245 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x515>
  6fb18c:	31 c9                	xor    %ecx,%ecx
  6fb18e:	e9 be 00 00 00       	jmp    6fb251 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x521>
  6fb193:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fb19a:	00 
  6fb19b:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fb1a0:	b1 01                	mov    $0x1,%cl
  6fb1a2:	e9 0f fc ff ff       	jmp    6fadb6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fb1a7:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fb1ae:	00 
  6fb1af:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fb1b4:	44 89 f9             	mov    %r15d,%ecx
  6fb1b7:	e9 fa fb ff ff       	jmp    6fadb6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x86>
  6fb1bc:	41 80 fc 01          	cmp    $0x1,%r12b
  6fb1c0:	0f 84 65 fe ff ff    	je     6fb02b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2fb>
  6fb1c6:	40 84 ed             	test   %bpl,%bpl
  6fb1c9:	0f 85 15 18 00 00    	jne    6fc9e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cb4>
  6fb1cf:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  6fb1d3:	4c 89 f6             	mov    %r14,%rsi
  6fb1d6:	31 d2                	xor    %edx,%edx
  6fb1d8:	4c 89 f9             	mov    %r15,%rcx
  6fb1db:	e8 a0 71 00 00       	call   702380 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::publish_metadata>
  6fb1e0:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fb1e7:	e9 53 ff ff ff       	jmp    6fb13f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fb1ec:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  6fb1f3:	00 
  6fb1f4:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  6fb1fb:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  6fb202:	48 85 c0             	test   %rax,%rax
  6fb205:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fb20c:	00 
  6fb20d:	0f 84 90 02 00 00    	je     6fb4a3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fb213:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  6fb21a:	48 85 c9             	test   %rcx,%rcx
  6fb21d:	0f 84 9c 00 00 00    	je     6fb2bf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x58f>
  6fb223:	48 89 ca             	mov    %rcx,%rdx
  6fb226:	48 83 e2 07          	and    $0x7,%rdx
  6fb22a:	74 4c                	je     6fb278 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x548>
  6fb22c:	31 f6                	xor    %esi,%esi
  6fb22e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb235:	48 ff c6             	inc    %rsi
  6fb238:	48 39 f2             	cmp    %rsi,%rdx
  6fb23b:	75 f1                	jne    6fb22e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x4fe>
  6fb23d:	48 89 ca             	mov    %rcx,%rdx
  6fb240:	48 29 f2             	sub    %rsi,%rdx
  6fb243:	eb 36                	jmp    6fb27b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x54b>
  6fb245:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fb24c:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fb251:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fb258:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  6fb25c:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fb260:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  6fb265:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  6fb269:	88 43 30             	mov    %al,0x30(%rbx)
  6fb26c:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fb273:	e9 c7 fe ff ff       	jmp    6fb13f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x40f>
  6fb278:	48 89 ca             	mov    %rcx,%rdx
  6fb27b:	48 83 f9 08          	cmp    $0x8,%rcx
  6fb27f:	72 3e                	jb     6fb2bf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x58f>
  6fb281:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb288:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb28f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb296:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb29d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb2a4:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb2ab:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb2b2:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fb2b9:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  6fb2bd:	75 c2                	jne    6fb281 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x551>
  6fb2bf:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  6fb2c6:	00 
  6fb2c7:	0f 84 d6 01 00 00    	je     6fb4a3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fb2cd:	80 38 00             	cmpb   $0x0,(%rax)
  6fb2d0:	0f 85 cd 01 00 00    	jne    6fb4a3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fb2d6:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  6fb2dd:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  6fb2e4:	00 
  6fb2e5:	e8 76 78 04 00       	call   742b60 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  6fb2ea:	48 85 c0             	test   %rax,%rax
  6fb2ed:	0f 84 b0 01 00 00    	je     6fb4a3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fb2f3:	48 8b 48 10          	mov    0x10(%rax),%rcx
  6fb2f7:	48 c1 e1 02          	shl    $0x2,%rcx
  6fb2fb:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  6fb2ff:	ba 04 00 00 00       	mov    $0x4,%edx
  6fb304:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  6fb309:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fb30e:	b8 00 00 00 00       	mov    $0x0,%eax
  6fb313:	48 0f 45 c1          	cmovne %rcx,%rax
  6fb317:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fb31c:	48 85 c0             	test   %rax,%rax
  6fb31f:	0f 84 7e 01 00 00    	je     6fb4a3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x773>
  6fb325:	45 31 ed             	xor    %r13d,%r13d
  6fb328:	48 8b 05 11 cd 42 00 	mov    0x42cd11(%rip),%rax        # b28040 <_DYNAMIC+0x388>
  6fb32f:	48 83 c0 20          	add    $0x20,%rax
  6fb333:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fb338:	48 8b 05 09 cd 42 00 	mov    0x42cd09(%rip),%rax        # b28048 <_DYNAMIC+0x390>
  6fb33f:	48 83 c0 20          	add    $0x20,%rax
  6fb343:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fb348:	48 8b 05 01 cd 42 00 	mov    0x42cd01(%rip),%rax        # b28050 <_DYNAMIC+0x398>
  6fb34f:	48 83 c0 20          	add    $0x20,%rax
  6fb353:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fb358:	48 8b 05 f9 cc 42 00 	mov    0x42ccf9(%rip),%rax        # b28058 <_DYNAMIC+0x3a0>
  6fb35f:	48 83 c0 20          	add    $0x20,%rax
  6fb363:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6fb368:	48 8b 05 f1 cc 42 00 	mov    0x42ccf1(%rip),%rax        # b28060 <_DYNAMIC+0x3a8>
  6fb36f:	48 83 c0 20          	add    $0x20,%rax
  6fb373:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fb378:	48 8b 05 e9 cc 42 00 	mov    0x42cce9(%rip),%rax        # b28068 <_DYNAMIC+0x3b0>
  6fb37f:	48 83 c0 20          	add    $0x20,%rax
  6fb383:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fb38a:	00 
  6fb38b:	48 8b 05 de cc 42 00 	mov    0x42ccde(%rip),%rax        # b28070 <_DYNAMIC+0x3b8>
  6fb392:	48 83 c0 20          	add    $0x20,%rax
  6fb396:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fb39d:	00 
  6fb39e:	48 8b 05 d3 cc 42 00 	mov    0x42ccd3(%rip),%rax        # b28078 <_DYNAMIC+0x3c0>
  6fb3a5:	48 83 c0 20          	add    $0x20,%rax
  6fb3a9:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fb3ae:	48 8b 05 cb cc 42 00 	mov    0x42cccb(%rip),%rax        # b28080 <_DYNAMIC+0x3c8>
  6fb3b5:	48 83 c0 20          	add    $0x20,%rax
  6fb3b9:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  6fb3c0:	00 
  6fb3c1:	48 8b 05 c0 cc 42 00 	mov    0x42ccc0(%rip),%rax        # b28088 <_DYNAMIC+0x3d0>
  6fb3c8:	48 83 c0 20          	add    $0x20,%rax
  6fb3cc:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fb3d1:	48 8b 05 b8 cc 42 00 	mov    0x42ccb8(%rip),%rax        # b28090 <_DYNAMIC+0x3d8>
  6fb3d8:	48 83 c0 20          	add    $0x20,%rax
  6fb3dc:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6fb3e3:	00 
  6fb3e4:	48 8b 05 ad cc 42 00 	mov    0x42ccad(%rip),%rax        # b28098 <_DYNAMIC+0x3e0>
  6fb3eb:	48 83 c0 20          	add    $0x20,%rax
  6fb3ef:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fb3f4:	48 8b 05 a5 cc 42 00 	mov    0x42cca5(%rip),%rax        # b280a0 <_DYNAMIC+0x3e8>
  6fb3fb:	48 83 c0 20          	add    $0x20,%rax
  6fb3ff:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fb404:	48 8d 2d c5 fc 95 ff 	lea    -0x6a033b(%rip),%rbp        # 5b0d0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1460>
  6fb40b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb410:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  6fb414:	ff 15 8e cc 42 00    	call   *0x42cc8e(%rip)        # b280a8 <_DYNAMIC+0x3f0>
  6fb41a:	0f b7 c0             	movzwl %ax,%eax
  6fb41d:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  6fb422:	48 01 e9             	add    %rbp,%rcx
  6fb425:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fb42a:	ff e1                	jmp    *%rcx
  6fb42c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fb431:	eb 57                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb433:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fb43a:	00 
  6fb43b:	eb 4d                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb43d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fb442:	eb 46                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb444:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fb449:	eb 3f                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb44b:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  6fb452:	00 
  6fb453:	eb 35                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb455:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fb45a:	eb 2e                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb45c:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fb463:	00 
  6fb464:	eb 24                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb466:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6fb46b:	eb 1d                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb46d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb472:	eb 16                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb474:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fb47b:	00 
  6fb47c:	eb 0c                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb47e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb483:	eb 05                	jmp    6fb48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x75a>
  6fb485:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fb48a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  6fb48e:	0f 85 03 11 00 00    	jne    6fc597 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1867>
  6fb494:	49 83 c5 04          	add    $0x4,%r13
  6fb498:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  6fb49d:	0f 85 68 ff ff ff    	jne    6fb40b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x6db>
  6fb4a3:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  6fb4aa:	00 00 
  6fb4ac:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fb4b3:	48 85 ed             	test   %rbp,%rbp
  6fb4b6:	0f 84 f2 10 00 00    	je     6fc5ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x187e>
  6fb4bc:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fb4c3:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fb4ca:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  6fb4d1:	48 89 c7             	mov    %rax,%rdi
  6fb4d4:	48 89 e9             	mov    %rbp,%rcx
  6fb4d7:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  6fb4de:	00 
  6fb4df:	45 89 d3             	mov    %r10d,%r11d
  6fb4e2:	41 c1 e3 05          	shl    $0x5,%r11d
  6fb4e6:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  6fb4ed:	45 31 c9             	xor    %r9d,%r9d
  6fb4f0:	4d 39 cb             	cmp    %r9,%r11
  6fb4f3:	74 28                	je     6fb51d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7ed>
  6fb4f5:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  6fb4fc:	00 
  6fb4fd:	41 0f 97 c4          	seta   %r12b
  6fb501:	41 80 dc 00          	sbb    $0x0,%r12b
  6fb505:	49 83 c1 20          	add    $0x20,%r9
  6fb509:	49 ff c0             	inc    %r8
  6fb50c:	41 80 fc 01          	cmp    $0x1,%r12b
  6fb510:	74 de                	je     6fb4f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7c0>
  6fb512:	45 0f b6 d4          	movzbl %r12b,%r10d
  6fb516:	45 85 d2             	test   %r10d,%r10d
  6fb519:	75 05                	jne    6fb520 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7f0>
  6fb51b:	eb 1c                	jmp    6fb539 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x809>
  6fb51d:	4d 89 d0             	mov    %r10,%r8
  6fb520:	48 83 ef 01          	sub    $0x1,%rdi
  6fb524:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fb529:	0f 82 92 00 00 00    	jb     6fb5c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x891>
  6fb52f:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  6fb536:	00 
  6fb537:	eb 9e                	jmp    6fb4d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x7a7>
  6fb539:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  6fb53f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fb544:	75 7b                	jne    6fb5c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x891>
  6fb546:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  6fb54b:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fb552:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  6fb559:	4c 8d 05 20 ec 3f 00 	lea    0x3fec20(%rip),%r8        # afa180 <__frame_dummy_init_array_entry+0xc58>
  6fb560:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fb565:	4c 89 f9             	mov    %r15,%rcx
  6fb568:	45 31 c9             	xor    %r9d,%r9d
  6fb56b:	e8 40 85 05 00       	call   753ab0 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::freeze>
  6fb570:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fb575:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  6fb57a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fb581:	00 
  6fb582:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fb586:	0f 85 e6 00 00 00    	jne    6fb672 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x942>
  6fb58c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fb593:	00 
  6fb594:	48 89 cd             	mov    %rcx,%rbp
  6fb597:	48 c1 ed 08          	shr    $0x8,%rbp
  6fb59b:	b8 20 00 00 00       	mov    $0x20,%eax
  6fb5a0:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fb5a5:	89 cf                	mov    %ecx,%edi
  6fb5a7:	e9 bb 12 00 00       	jmp    6fc867 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fb5ac:	48 89 f9             	mov    %rdi,%rcx
  6fb5af:	48 83 e8 01          	sub    $0x1,%rax
  6fb5b3:	0f 82 f5 0f 00 00    	jb     6fc5ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x187e>
  6fb5b9:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  6fb5c0:	00 
  6fb5c1:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  6fb5c8:	41 89 f8             	mov    %edi,%r8d
  6fb5cb:	41 c1 e0 05          	shl    $0x5,%r8d
  6fb5cf:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  6fb5d6:	45 31 ed             	xor    %r13d,%r13d
  6fb5d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6fb5e0:	4d 39 e8             	cmp    %r13,%r8
  6fb5e3:	74 c7                	je     6fb5ac <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x87c>
  6fb5e5:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  6fb5ec:	00 
  6fb5ed:	41 0f 97 c1          	seta   %r9b
  6fb5f1:	41 80 d9 00          	sbb    $0x0,%r9b
  6fb5f5:	49 83 c5 20          	add    $0x20,%r13
  6fb5f9:	48 ff c1             	inc    %rcx
  6fb5fc:	41 80 f9 01          	cmp    $0x1,%r9b
  6fb600:	74 de                	je     6fb5e0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x8b0>
  6fb602:	41 0f b6 f9          	movzbl %r9b,%edi
  6fb606:	85 ff                	test   %edi,%edi
  6fb608:	75 a5                	jne    6fb5af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x87f>
  6fb60a:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  6fb60f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6fb613:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fb618:	74 41                	je     6fb65b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x92b>
  6fb61a:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fb61f:	48 85 c0             	test   %rax,%rax
  6fb622:	0f 84 46 01 00 00    	je     6fb76e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa3e>
  6fb628:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fb62d:	48 ff c8             	dec    %rax
  6fb630:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  6fb637:	ff ff 3f 
  6fb63a:	48 21 c7             	and    %rax,%rdi
  6fb63d:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  6fb641:	45 89 c8             	mov    %r9d,%r8d
  6fb644:	41 83 e0 03          	and    $0x3,%r8d
  6fb648:	48 83 ff 03          	cmp    $0x3,%rdi
  6fb64c:	0f 83 25 01 00 00    	jae    6fb777 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa47>
  6fb652:	31 c0                	xor    %eax,%eax
  6fb654:	31 ff                	xor    %edi,%edi
  6fb656:	e9 b0 01 00 00       	jmp    6fb80b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xadb>
  6fb65b:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fb662:	4c 8d 05 17 eb 3f 00 	lea    0x3feb17(%rip),%r8        # afa180 <__frame_dummy_init_array_entry+0xc58>
  6fb669:	31 c0                	xor    %eax,%eax
  6fb66b:	31 ff                	xor    %edi,%edi
  6fb66d:	e9 d4 01 00 00       	jmp    6fb846 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb16>
  6fb672:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fb677:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fb67c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fb683:	00 
  6fb684:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  6fb68b:	00 
  6fb68c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fb693:	00 
  6fb694:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  6fb69b:	00 
  6fb69c:	41 83 fd 02          	cmp    $0x2,%r13d
  6fb6a0:	0f 84 bc 13 00 00    	je     6fca62 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d32>
  6fb6a6:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  6fb6ab:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  6fb6b2:	00 
  6fb6b3:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  6fb6b8:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  6fb6bf:	00 
  6fb6c0:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  6fb6c7:	00 
  6fb6c8:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fb6cf:	00 
  6fb6d0:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fb6d5:	ba 06 00 00 00       	mov    $0x6,%edx
  6fb6da:	ff 15 d0 c9 42 00    	call   *0x42c9d0(%rip)        # b280b0 <_DYNAMIC+0x3f8>
  6fb6e0:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  6fb6e7:	00 
  6fb6e8:	80 fa ff             	cmp    $0xff,%dl
  6fb6eb:	0f 84 79 0e 00 00    	je     6fc56a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x183a>
  6fb6f1:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  6fb6f8:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  6fb6ff:	00 
  6fb700:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  6fb707:	00 
  6fb708:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  6fb70f:	00 
  6fb710:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  6fb717:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  6fb71e:	80 fa 02             	cmp    $0x2,%dl
  6fb721:	0f 85 35 0f 00 00    	jne    6fc65c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x192c>
  6fb727:	89 ea                	mov    %ebp,%edx
  6fb729:	48 c1 e0 20          	shl    $0x20,%rax
  6fb72d:	48 09 c8             	or     %rcx,%rax
  6fb730:	48 c1 e8 08          	shr    $0x8,%rax
  6fb734:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  6fb73b:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  6fb742:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  6fb749:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  6fb750:	00 
  6fb751:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  6fb758:	00 
  6fb759:	41 80 be 1f 08 00 00 	cmpb   $0x0,0x81f(%r14)
  6fb760:	00 
  6fb761:	0f 84 0c 0f 00 00    	je     6fc673 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1943>
  6fb767:	31 ed                	xor    %ebp,%ebp
  6fb769:	e9 24 0f 00 00       	jmp    6fc692 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1962>
  6fb76e:	31 ff                	xor    %edi,%edi
  6fb770:	31 c0                	xor    %eax,%eax
  6fb772:	e9 b5 00 00 00       	jmp    6fb82c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xafc>
  6fb777:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6fb77c:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  6fb783:	00 00 80 
  6fb786:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6fb78a:	49 21 c1             	and    %rax,%r9
  6fb78d:	31 c0                	xor    %eax,%eax
  6fb78f:	31 ff                	xor    %edi,%edi
  6fb791:	44 8b 11             	mov    (%rcx),%r10d
  6fb794:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  6fb798:	45 89 d4             	mov    %r10d,%r12d
  6fb79b:	41 f7 d4             	not    %r12d
  6fb79e:	41 f6 c4 03          	test   $0x3,%r12b
  6fb7a2:	41 0f 94 c4          	sete   %r12b
  6fb7a6:	45 89 c3             	mov    %r8d,%r11d
  6fb7a9:	41 f7 d3             	not    %r11d
  6fb7ac:	41 f6 c3 03          	test   $0x3,%r11b
  6fb7b0:	41 0f 94 c3          	sete   %r11b
  6fb7b4:	45 08 e3             	or     %r12b,%r11b
  6fb7b7:	8b 51 08             	mov    0x8(%rcx),%edx
  6fb7ba:	41 89 d4             	mov    %edx,%r12d
  6fb7bd:	41 f7 d4             	not    %r12d
  6fb7c0:	41 f6 c4 03          	test   $0x3,%r12b
  6fb7c4:	41 0f 94 c4          	sete   %r12b
  6fb7c8:	8b 71 0c             	mov    0xc(%rcx),%esi
  6fb7cb:	48 83 c1 10          	add    $0x10,%rcx
  6fb7cf:	21 f2                	and    %esi,%edx
  6fb7d1:	f7 d6                	not    %esi
  6fb7d3:	40 f6 c6 03          	test   $0x3,%sil
  6fb7d7:	40 0f 94 c6          	sete   %sil
  6fb7db:	44 08 e6             	or     %r12b,%sil
  6fb7de:	44 08 de             	or     %r11b,%sil
  6fb7e1:	40 08 f7             	or     %sil,%dil
  6fb7e4:	45 21 c2             	and    %r8d,%r10d
  6fb7e7:	41 21 d2             	and    %edx,%r10d
  6fb7ea:	41 f7 d2             	not    %r10d
  6fb7ed:	41 f6 c2 03          	test   $0x3,%r10b
  6fb7f1:	0f 95 c2             	setne  %dl
  6fb7f4:	08 d0                	or     %dl,%al
  6fb7f6:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  6fb7fa:	75 95                	jne    6fb791 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa61>
  6fb7fc:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6fb801:	4d 85 c0             	test   %r8,%r8
  6fb804:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fb809:	74 21                	je     6fb82c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xafc>
  6fb80b:	45 31 c9             	xor    %r9d,%r9d
  6fb80e:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  6fb812:	83 e2 03             	and    $0x3,%edx
  6fb815:	83 fa 03             	cmp    $0x3,%edx
  6fb818:	0f 95 c2             	setne  %dl
  6fb81b:	40 0f 94 c6          	sete   %sil
  6fb81f:	40 08 f7             	or     %sil,%dil
  6fb822:	08 d0                	or     %dl,%al
  6fb824:	49 ff c1             	inc    %r9
  6fb827:	4d 39 c8             	cmp    %r9,%r8
  6fb82a:	75 e2                	jne    6fb80e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xade>
  6fb82c:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fb833:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  6fb838:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fb83f:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fb846:	40 0f b6 cf          	movzbl %dil,%ecx
  6fb84a:	83 e1 01             	and    $0x1,%ecx
  6fb84d:	89 0c 24             	mov    %ecx,(%rsp)
  6fb850:	44 0f b6 c8          	movzbl %al,%r9d
  6fb854:	41 83 e1 01          	and    $0x1,%r9d
  6fb858:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fb85d:	4c 89 f9             	mov    %r15,%rcx
  6fb860:	e8 4b 82 05 00       	call   753ab0 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::freeze>
  6fb865:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  6fb86a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6fb86f:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fb876:	00 
  6fb877:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6fb87e:	00 
  6fb87f:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fb884:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  6fb889:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  6fb88d:	75 1d                	jne    6fb8ac <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xb7c>
  6fb88f:	48 89 c5             	mov    %rax,%rbp
  6fb892:	48 c1 ed 08          	shr    $0x8,%rbp
  6fb896:	b9 20 00 00 00       	mov    $0x20,%ecx
  6fb89b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fb8a0:	89 c7                	mov    %eax,%edi
  6fb8a2:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  6fb8a7:	e9 bb 0f 00 00       	jmp    6fc867 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fb8ac:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fb8b1:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fb8b8:	00 
  6fb8b9:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6fb8c0:	00 
  6fb8c1:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fb8c8:	00 00 
  6fb8ca:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  6fb8d1:	00 00 
  6fb8d3:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  6fb8d9:	0f 84 69 0c 00 00    	je     6fc548 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1818>
  6fb8df:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fb8e4:	48 85 c0             	test   %rax,%rax
  6fb8e7:	0f 84 5b 0c 00 00    	je     6fc548 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1818>
  6fb8ed:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fb8f2:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fb8f7:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fb8fc:	48 c1 e0 02          	shl    $0x2,%rax
  6fb900:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fb905:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6fb909:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  6fb910:	00 
  6fb911:	45 31 e4             	xor    %r12d,%r12d
  6fb914:	48 83 f8 02          	cmp    $0x2,%rax
  6fb918:	0f 85 72 0b 00 00    	jne    6fc490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1760>
  6fb91e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb923:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fb927:	ff 15 7b c7 42 00    	call   *0x42c77b(%rip)        # b280a8 <_DYNAMIC+0x3f0>
  6fb92d:	66 85 c0             	test   %ax,%ax
  6fb930:	0f 85 ba 12 00 00    	jne    6fcbf0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ec0>
  6fb936:	49 83 c4 04          	add    $0x4,%r12
  6fb93a:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fb93f:	75 dd                	jne    6fb91e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xbee>
  6fb941:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fb946:	48 85 c0             	test   %rax,%rax
  6fb949:	0f 84 dd 0d 00 00    	je     6fc72c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19fc>
  6fb94f:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fb954:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  6fb95b:	00 
  6fb95c:	48 c1 e0 02          	shl    $0x2,%rax
  6fb960:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  6fb966:	66 0f 6f 0d f2 ec 95 	movdqa -0x6a130e(%rip),%xmm1        # 5a660 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9f0>
  6fb96d:	ff 
  6fb96e:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  6fb972:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  6fb979:	00 00 
  6fb97b:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  6fb982:	00 00 00 00 00 
  6fb987:	48 8d 0d 32 e8 3f 00 	lea    0x3fe832(%rip),%rcx        # afa1c0 <__frame_dummy_init_array_entry+0xc98>
  6fb98e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fb993:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  6fb99a:	00 00 80 
  6fb99d:	48 ff c1             	inc    %rcx
  6fb9a0:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  6fb9a7:	00 
  6fb9a8:	48 8d 0d f5 eb 96 ff 	lea    -0x69140b(%rip),%rcx        # 6a5a4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b7>
  6fb9af:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6fb9b6:	00 
  6fb9b7:	48 8d 0d 92 e8 3f 00 	lea    0x3fe892(%rip),%rcx        # afa250 <__frame_dummy_init_array_entry+0xd28>
  6fb9be:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6fb9c5:	00 
  6fb9c6:	48 8d 0d 0b e8 3f 00 	lea    0x3fe80b(%rip),%rcx        # afa1d8 <__frame_dummy_init_array_entry+0xcb0>
  6fb9cd:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  6fb9d4:	00 
  6fb9d5:	48 8d 0d 9f eb 96 ff 	lea    -0x691461(%rip),%rcx        # 6a57b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348e>
  6fb9dc:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  6fb9e3:	00 
  6fb9e4:	48 8d 0d bd dc 3f 00 	lea    0x3fdcbd(%rip),%rcx        # af96a8 <__frame_dummy_init_array_entry+0x180>
  6fb9eb:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  6fb9f2:	00 
  6fb9f3:	31 c9                	xor    %ecx,%ecx
  6fb9f5:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  6fb9fc:	00 00 00 00 00 
  6fba01:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  6fba08:	00 00 00 00 00 
  6fba0d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fba14:	00 00 
  6fba16:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fba1b:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fba22:	00 
  6fba23:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  6fba28:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  6fba2b:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  6fba32:	89 e8                	mov    %ebp,%eax
  6fba34:	c1 e8 0f             	shr    $0xf,%eax
  6fba37:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fba3e:	48 39 c6             	cmp    %rax,%rsi
  6fba41:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fba46:	0f 86 7c 11 00 00    	jbe    6fcbc8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e98>
  6fba4c:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  6fba53:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  6fba57:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  6fba5b:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fba60:	89 ef                	mov    %ebp,%edi
  6fba62:	ff 15 40 c6 42 00    	call   *0x42c640(%rip)        # b280a8 <_DYNAMIC+0x3f0>
  6fba68:	89 44 24 08          	mov    %eax,0x8(%rsp)
  6fba6c:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  6fba70:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fba77:	00 
  6fba78:	8b 54 24 08          	mov    0x8(%rsp),%edx
  6fba7c:	66 85 d2             	test   %dx,%dx
  6fba7f:	0f 84 31 01 00 00    	je     6fbbb6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xe86>
  6fba85:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  6fba8c:	02 
  6fba8d:	0f 84 6d 0f 00 00    	je     6fca00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd0>
  6fba93:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6fba98:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6fba9d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6fbaa4:	00 
  6fbaa5:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fbaaa:	48 89 41 10          	mov    %rax,0x10(%rcx)
  6fbaae:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fbab5:	00 00 
  6fbab7:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  6fbabb:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fbac2:	00 
  6fbac3:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fbac8:	ff 15 e2 c5 42 00    	call   *0x42c5e2(%rip)        # b280b0 <_DYNAMIC+0x3f8>
  6fbace:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  6fbad5:	00 
  6fbad6:	3c ff                	cmp    $0xff,%al
  6fbad8:	0f 84 10 0d 00 00    	je     6fc7ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1abe>
  6fbade:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  6fbae5:	00 
  6fbae6:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  6fbaed:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  6fbaf4:	00 
  6fbaf5:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  6fbafc:	00 
  6fbafd:	41 8b 78 10          	mov    0x10(%r8),%edi
  6fbb01:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  6fbb08:	00 
  6fbb09:	41 89 79 10          	mov    %edi,0x10(%r9)
  6fbb0d:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  6fbb12:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  6fbb17:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  6fbb1e:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  6fbb25:	00 
  6fbb26:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  6fbb2d:	00 
  6fbb2e:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  6fbb35:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6fbb39:	44 0f b7 e9          	movzwl %cx,%r13d
  6fbb3d:	48 8d 05 3c ea 3f 00 	lea    0x3fea3c(%rip),%rax        # afa580 <__frame_dummy_init_array_entry+0x1058>
  6fbb44:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fbb49:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  6fbb4d:	0f 84 c7 00 00 00    	je     6fbc1a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xeea>
  6fbb53:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fbb58:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  6fbb5f:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fbb64:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  6fbb6b:	00 
  6fbb6c:	ff 15 46 c5 42 00    	call   *0x42c546(%rip)        # b280b8 <_DYNAMIC+0x400>
  6fbb72:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fbb77:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fbb7c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fbb80:	0f 85 ab 0d 00 00    	jne    6fc931 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c01>
  6fbb86:	40 80 ff 01          	cmp    $0x1,%dil
  6fbb8a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fbb8f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fbb94:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fbb99:	0f 85 9e 08 00 00    	jne    6fc43d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x170d>
  6fbb9f:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fbba6:	01 
  6fbba7:	b0 01                	mov    $0x1,%al
  6fbba9:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fbbb0:	00 
  6fbbb1:	e9 4e 08 00 00       	jmp    6fc404 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fbbb6:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  6fbbbc:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fbbc1:	0f 84 59 0e 00 00    	je     6fca20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cf0>
  6fbbc7:	83 e5 03             	and    $0x3,%ebp
  6fbbca:	8d 45 ff             	lea    -0x1(%rbp),%eax
  6fbbcd:	83 f8 02             	cmp    $0x2,%eax
  6fbbd0:	0f 83 8a 00 00 00    	jae    6fbc60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf30>
  6fbbd6:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fbbdd:	48 8b 38             	mov    (%rax),%rdi
  6fbbe0:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  6fbbe6:	48 85 ff             	test   %rdi,%rdi
  6fbbe9:	0f 84 19 0e 00 00    	je     6fca08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd8>
  6fbbef:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fbbf4:	ff 15 c6 c4 42 00    	call   *0x42c4c6(%rip)        # b280c0 <_DYNAMIC+0x408>
  6fbbfa:	48 85 c0             	test   %rax,%rax
  6fbbfd:	0f 84 05 0e 00 00    	je     6fca08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1cd8>
  6fbc03:	83 fd 01             	cmp    $0x1,%ebp
  6fbc06:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fbc0b:	0f 85 a6 00 00 00    	jne    6fbcb7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf87>
  6fbc11:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fbc15:	e9 a1 00 00 00       	jmp    6fbcbb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf8b>
  6fbc1a:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  6fbc21:	48 8b 00             	mov    (%rax),%rax
  6fbc24:	48 8d 15 dd f4 95 ff 	lea    -0x6a0b23(%rip),%rdx        # 5b108 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1498>
  6fbc2b:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  6fbc2f:	48 01 d1             	add    %rdx,%rcx
  6fbc32:	48 8d 05 e7 fc 95 ff 	lea    -0x6a0319(%rip),%rax        # 5b920 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  6fbc39:	ff e1                	jmp    *%rcx
  6fbc3b:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  6fbc42:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fbc47:	48 39 c6             	cmp    %rax,%rsi
  6fbc4a:	0f 86 3a 0f 00 00    	jbe    6fcb8a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e5a>
  6fbc50:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fbc54:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  6fbc5b:	e9 4e 03 00 00       	jmp    6fbfae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x127e>
  6fbc60:	85 ed                	test   %ebp,%ebp
  6fbc62:	0f 85 18 0e 00 00    	jne    6fca80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d50>
  6fbc68:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fbc6f:	00 
  6fbc70:	8b 40 20             	mov    0x20(%rax),%eax
  6fbc73:	89 c1                	mov    %eax,%ecx
  6fbc75:	83 e1 07             	and    $0x7,%ecx
  6fbc78:	83 f9 06             	cmp    $0x6,%ecx
  6fbc7b:	74 74                	je     6fbcf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fbc7d:	c1 e8 03             	shr    $0x3,%eax
  6fbc80:	74 6f                	je     6fbcf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fbc82:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fbc89:	ff c8                	dec    %eax
  6fbc8b:	48 39 c6             	cmp    %rax,%rsi
  6fbc8e:	0f 86 23 0f 00 00    	jbe    6fcbb7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e87>
  6fbc94:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  6fbc9b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fbc9f:	48 c1 e0 04          	shl    $0x4,%rax
  6fbca3:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  6fbca8:	0f 84 59 0e 00 00    	je     6fcb07 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1dd7>
  6fbcae:	48 01 c1             	add    %rax,%rcx
  6fbcb1:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  6fbcb5:	eb 13                	jmp    6fbcca <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xf9a>
  6fbcb7:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fbcbb:	b0 01                	mov    $0x1,%al
  6fbcbd:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  6fbcc4:	00 
  6fbcc5:	48 85 ff             	test   %rdi,%rdi
  6fbcc8:	74 27                	je     6fbcf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fbcca:	48 8b 07             	mov    (%rdi),%rax
  6fbccd:	48 d1 e8             	shr    $1,%rax
  6fbcd0:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fbcd5:	48 39 d0             	cmp    %rdx,%rax
  6fbcd8:	75 17                	jne    6fbcf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xfc1>
  6fbcda:	48 83 c7 10          	add    $0x10,%rdi
  6fbcde:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fbce3:	ff 15 df c3 42 00    	call   *0x42c3df(%rip)        # b280c8 <bcmp@GLIBC_2.2.5>
  6fbce9:	85 c0                	test   %eax,%eax
  6fbceb:	0f 84 3a 06 00 00    	je     6fc32b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x15fb>
  6fbcf1:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  6fbcf6:	4d 85 e4             	test   %r12,%r12
  6fbcf9:	75 6d                	jne    6fbd68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1038>
  6fbcfb:	4c 8d 25 8e f1 95 ff 	lea    -0x6a0e72(%rip),%r12        # 5ae90 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1220>
  6fbd02:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6fbd07:	48 85 f6             	test   %rsi,%rsi
  6fbd0a:	74 41                	je     6fbd4d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x101d>
  6fbd0c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fbd13:	00 00 
  6fbd15:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fbd1a:	31 d2                	xor    %edx,%edx
  6fbd1c:	31 c9                	xor    %ecx,%ecx
  6fbd1e:	ff 15 ac c3 42 00    	call   *0x42c3ac(%rip)        # b280d0 <_DYNAMIC+0x418>
  6fbd24:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6fbd29:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  6fbd2d:	0f 85 6e 0e 00 00    	jne    6fcba1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e71>
  6fbd33:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  6fbd38:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  6fbd3d:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fbd42:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fbd47:	ff 15 d3 c1 42 00    	call   *0x42c1d3(%rip)        # b27f20 <memcpy@GLIBC_2.14>
  6fbd4d:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  6fbd54:	00 00 
  6fbd56:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  6fbd5d:	00 00 
  6fbd5f:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  6fbd66:	00 00 
  6fbd68:	85 ed                	test   %ebp,%ebp
  6fbd6a:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  6fbd6f:	0f 84 b1 00 00 00    	je     6fbe26 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10f6>
  6fbd75:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fbd7c:	48 8b 38             	mov    (%rax),%rdi
  6fbd7f:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  6fbd85:	48 85 ff             	test   %rdi,%rdi
  6fbd88:	0f 84 2e 0d 00 00    	je     6fcabc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d8c>
  6fbd8e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fbd93:	ff 15 3f c3 42 00    	call   *0x42c33f(%rip)        # b280d8 <_DYNAMIC+0x420>
  6fbd99:	48 85 c0             	test   %rax,%rax
  6fbd9c:	0f 84 1a 0d 00 00    	je     6fcabc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d8c>
  6fbda2:	83 fd 01             	cmp    $0x1,%ebp
  6fbda5:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fbdaa:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fbdaf:	0f 85 4d 01 00 00    	jne    6fbf02 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11d2>
  6fbdb5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fbdba:	48 85 c9             	test   %rcx,%rcx
  6fbdbd:	74 2c                	je     6fbdeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fbdbf:	f6 01 01             	testb  $0x1,(%rcx)
  6fbdc2:	75 27                	jne    6fbdeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fbdc4:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fbdc8:	f6 c2 01             	test   $0x1,%dl
  6fbdcb:	75 1e                	jne    6fbdeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fbdcd:	ba 02 00 00 00       	mov    $0x2,%edx
  6fbdd2:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fbdd8:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fbddf:	00 
  6fbde0:	48 f7 da             	neg    %rdx
  6fbde3:	71 06                	jno    6fbdeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10bb>
  6fbde5:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fbdeb:	48 89 c5             	mov    %rax,%rbp
  6fbdee:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fbdf2:	48 85 ff             	test   %rdi,%rdi
  6fbdf5:	74 1c                	je     6fbe13 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fbdf7:	f6 07 01             	testb  $0x1,(%rdi)
  6fbdfa:	75 17                	jne    6fbe13 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fbdfc:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fbe00:	a8 01                	test   $0x1,%al
  6fbe02:	75 0f                	jne    6fbe13 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fbe04:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fbe08:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fbe0d:	0f 84 50 06 00 00    	je     6fc463 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1733>
  6fbe13:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fbe18:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fbe1c:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fbe21:	e9 de 05 00 00       	jmp    6fc404 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fbe26:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fbe2d:	00 
  6fbe2e:	8b 78 20             	mov    0x20(%rax),%edi
  6fbe31:	89 f8                	mov    %edi,%eax
  6fbe33:	83 e0 07             	and    $0x7,%eax
  6fbe36:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  6fbe3c:	83 f8 06             	cmp    $0x6,%eax
  6fbe3f:	0f 84 59 0c 00 00    	je     6fca9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d6e>
  6fbe45:	c1 ef 03             	shr    $0x3,%edi
  6fbe48:	0f 84 50 0c 00 00    	je     6fca9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d6e>
  6fbe4e:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fbe55:	ff cf                	dec    %edi
  6fbe57:	48 39 fe             	cmp    %rdi,%rsi
  6fbe5a:	0f 86 01 0d 00 00    	jbe    6fcb61 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e31>
  6fbe60:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fbe67:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6fbe6b:	48 c1 e0 04          	shl    $0x4,%rax
  6fbe6f:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fbe75:	0f 84 5f 0c 00 00    	je     6fcada <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1daa>
  6fbe7b:	4d 85 e4             	test   %r12,%r12
  6fbe7e:	0f 84 68 0c 00 00    	je     6fcaec <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1dbc>
  6fbe84:	41 f6 04 24 01       	testb  $0x1,(%r12)
  6fbe89:	75 2a                	jne    6fbeb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fbe8b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  6fbe90:	f6 c1 01             	test   $0x1,%cl
  6fbe93:	75 20                	jne    6fbeb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fbe95:	b9 02 00 00 00       	mov    $0x2,%ecx
  6fbe9a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  6fbea1:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  6fbea8:	00 
  6fbea9:	48 f7 d9             	neg    %rcx
  6fbeac:	71 07                	jno    6fbeb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1185>
  6fbeae:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  6fbeb5:	48 01 c5             	add    %rax,%rbp
  6fbeb8:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  6fbebc:	f6 07 01             	testb  $0x1,(%rdi)
  6fbebf:	75 17                	jne    6fbed8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fbec1:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fbec5:	a8 01                	test   $0x1,%al
  6fbec7:	75 0f                	jne    6fbed8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fbec9:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fbecd:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fbed2:	0f 84 7c 05 00 00    	je     6fc454 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1724>
  6fbed8:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fbedc:	48 89 ef             	mov    %rbp,%rdi
  6fbedf:	e8 7c 85 ff ff       	call   6f4460 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fbee4:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fbeeb:	ff 
  6fbeec:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fbef3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fbef8:	e8 d3 80 04 00       	call   743fd0 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fbefd:	e9 e1 04 00 00       	jmp    6fc3e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16b3>
  6fbf02:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fbf07:	48 85 c9             	test   %rcx,%rcx
  6fbf0a:	74 2c                	je     6fbf38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fbf0c:	f6 01 01             	testb  $0x1,(%rcx)
  6fbf0f:	75 27                	jne    6fbf38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fbf11:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fbf15:	f6 c2 01             	test   $0x1,%dl
  6fbf18:	75 1e                	jne    6fbf38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fbf1a:	ba 02 00 00 00       	mov    $0x2,%edx
  6fbf1f:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fbf25:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fbf2c:	00 
  6fbf2d:	48 f7 da             	neg    %rdx
  6fbf30:	71 06                	jno    6fbf38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1208>
  6fbf32:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fbf38:	48 89 c5             	mov    %rax,%rbp
  6fbf3b:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fbf3f:	48 85 ff             	test   %rdi,%rdi
  6fbf42:	74 1c                	je     6fbf60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fbf44:	f6 07 01             	testb  $0x1,(%rdi)
  6fbf47:	75 17                	jne    6fbf60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fbf49:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fbf4d:	a8 01                	test   $0x1,%al
  6fbf4f:	75 0f                	jne    6fbf60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fbf51:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fbf55:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fbf5a:	0f 84 12 05 00 00    	je     6fc472 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1742>
  6fbf60:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fbf65:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fbf69:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fbf6e:	e9 91 04 00 00       	jmp    6fc404 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16d4>
  6fbf73:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  6fbf7a:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6fbf7f:	48 39 ce             	cmp    %rcx,%rsi
  6fbf82:	0f 86 eb 0b 00 00    	jbe    6fcb73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e43>
  6fbf88:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  6fbf8f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  6fbf96:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  6fbf9a:	48 39 c6             	cmp    %rax,%rsi
  6fbf9d:	0f 86 d9 0b 00 00    	jbe    6fcb7c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e4c>
  6fbfa3:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fbfa7:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  6fbfae:	48 8b 48 50          	mov    0x50(%rax),%rcx
  6fbfb2:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  6fbfb9:	00 
  6fbfba:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  6fbfbe:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  6fbfc5:	00 
  6fbfc6:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  6fbfca:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  6fbfcf:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  6fbfd3:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  6fbfd7:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  6fbfde:	00 
  6fbfdf:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  6fbfe6:	00 
  6fbfe7:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  6fbfee:	00 00 
  6fbff0:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  6fbff7:	00 00 
  6fbff9:	eb 1a                	jmp    6fc015 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x12e5>
  6fbffb:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  6fc002:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  6fc009:	00 
  6fc00a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6fc00f:	ff 15 db bf 42 00    	call   *0x42bfdb(%rip)        # b27ff0 <_DYNAMIC+0x338>
  6fc015:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  6fc01c:	00 
  6fc01d:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  6fc024:	00 
  6fc025:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  6fc02c:	00 
  6fc02d:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  6fc034:	00 
  6fc035:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  6fc03c:	00 00 
  6fc03e:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  6fc045:	00 00 
  6fc047:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  6fc04e:	00 
  6fc04f:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  6fc056:	00 
  6fc057:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  6fc05e:	00 
  6fc05f:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  6fc066:	00 
  6fc067:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  6fc06e:	00 00 
  6fc070:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  6fc076:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc07d:	00 
  6fc07e:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  6fc085:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fc08a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  6fc08f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6fc094:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  6fc09b:	00 
  6fc09c:	e8 5f a9 05 00       	call   756a00 <<gpui::property::Overrides>::update_base>
  6fc0a1:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  6fc0a8:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  6fc0af:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  6fc0b6:	00 
  6fc0b7:	48 c1 e5 20          	shl    $0x20,%rbp
  6fc0bb:	48 09 cd             	or     %rcx,%rbp
  6fc0be:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  6fc0c5:	00 
  6fc0c6:	83 f8 02             	cmp    $0x2,%eax
  6fc0c9:	0f 84 ba 08 00 00    	je     6fc989 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c59>
  6fc0cf:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  6fc0d6:	00 
  6fc0d7:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  6fc0db:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  6fc0e2:	00 
  6fc0e3:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  6fc0e7:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  6fc0eb:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  6fc0ef:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  6fc0f3:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  6fc0f7:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  6fc0fb:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  6fc0ff:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6fc103:	0f 11 02             	movups %xmm0,(%rdx)
  6fc106:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  6fc10d:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  6fc114:	00 
  6fc115:	48 89 e8             	mov    %rbp,%rax
  6fc118:	48 c1 e8 20          	shr    $0x20,%rax
  6fc11c:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  6fc123:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  6fc12a:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  6fc131:	00 00 
  6fc133:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  6fc13a:	00 00 
  6fc13c:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  6fc143:	00 
  6fc144:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  6fc14b:	00 
  6fc14c:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  6fc153:	00 00 
  6fc155:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  6fc15c:	00 00 
  6fc15e:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  6fc165:	00 
  6fc166:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  6fc16d:	00 
  6fc16e:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  6fc175:	00 
  6fc176:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  6fc17d:	00 
  6fc17e:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  6fc185:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  6fc18c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  6fc193:	00 
  6fc194:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  6fc19b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  6fc1a2:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  6fc1a9:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  6fc1b0:	00 
  6fc1b1:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  6fc1b8:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  6fc1bf:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  6fc1c6:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  6fc1cd:	00 
  6fc1ce:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  6fc1d5:	00 
  6fc1d6:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  6fc1dd:	00 
  6fc1de:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  6fc1e5:	01 
  6fc1e6:	75 1a                	jne    6fc202 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x14d2>
  6fc1e8:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  6fc1ef:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  6fc1f6:	0f 94 c1             	sete   %cl
  6fc1f9:	84 c8                	test   %cl,%al
  6fc1fb:	75 0d                	jne    6fc20a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x14da>
  6fc1fd:	e9 38 01 00 00       	jmp    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc202:	a8 01                	test   $0x1,%al
  6fc204:	0f 85 30 01 00 00    	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc20a:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  6fc211:	00 
  6fc212:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  6fc219:	01 
  6fc21a:	75 1b                	jne    6fc237 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1507>
  6fc21c:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  6fc223:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  6fc22a:	0f 94 c1             	sete   %cl
  6fc22d:	84 c8                	test   %cl,%al
  6fc22f:	0f 84 05 01 00 00    	je     6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc235:	eb 08                	jmp    6fc23f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x150f>
  6fc237:	a8 01                	test   $0x1,%al
  6fc239:	0f 85 fb 00 00 00    	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc23f:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  6fc246:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  6fc24d:	0f 85 e7 00 00 00    	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc253:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  6fc25a:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  6fc261:	0f 85 d3 00 00 00    	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc267:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  6fc26e:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  6fc275:	0f 85 bf 00 00 00    	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc27b:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  6fc282:	00 
  6fc283:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  6fc28a:	0f 85 aa 00 00 00    	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc290:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  6fc297:	00 
  6fc298:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  6fc29f:	0f 85 95 00 00 00    	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc2a5:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  6fc2ac:	00 
  6fc2ad:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  6fc2b4:	0f 85 80 00 00 00    	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc2ba:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  6fc2c1:	00 
  6fc2c2:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  6fc2c9:	75 6f                	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc2cb:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  6fc2d2:	00 
  6fc2d3:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  6fc2da:	00 
  6fc2db:	e8 10 e8 02 00       	call   72aaf0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  6fc2e0:	84 c0                	test   %al,%al
  6fc2e2:	74 56                	je     6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc2e4:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  6fc2eb:	00 00 
  6fc2ed:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  6fc2f4:	00 00 
  6fc2f6:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fc2fa:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fc2fe:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fc303:	75 35                	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc305:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  6fc30c:	00 00 
  6fc30e:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  6fc315:	00 00 
  6fc317:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fc31b:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fc31f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fc324:	75 14                	jne    6fc33a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x160a>
  6fc326:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc32b:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fc330:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fc335:	e9 08 01 00 00       	jmp    6fc442 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1712>
  6fc33a:	48 8d 05 3f e2 3f 00 	lea    0x3fe23f(%rip),%rax        # afa580 <__frame_dummy_init_array_entry+0x1058>
  6fc341:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fc346:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  6fc34a:	75 11                	jne    6fc35d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x162d>
  6fc34c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fc353:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fc358:	e8 73 7c 04 00       	call   743fd0 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fc35d:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  6fc363:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  6fc368:	75 5a                	jne    6fc3c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fc36a:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fc371:	00 
  6fc372:	8b 40 20             	mov    0x20(%rax),%eax
  6fc375:	89 c1                	mov    %eax,%ecx
  6fc377:	83 e1 07             	and    $0x7,%ecx
  6fc37a:	83 f9 06             	cmp    $0x6,%ecx
  6fc37d:	74 45                	je     6fc3c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fc37f:	c1 e8 03             	shr    $0x3,%eax
  6fc382:	74 40                	je     6fc3c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1694>
  6fc384:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fc38b:	ff c8                	dec    %eax
  6fc38d:	48 39 c6             	cmp    %rax,%rsi
  6fc390:	0f 86 fd 07 00 00    	jbe    6fcb93 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e63>
  6fc396:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fc39d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fc3a1:	48 c1 e0 04          	shl    $0x4,%rax
  6fc3a5:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fc3ab:	0f 84 65 07 00 00    	je     6fcb16 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1de6>
  6fc3b1:	48 01 c5             	add    %rax,%rbp
  6fc3b4:	48 89 ef             	mov    %rbp,%rdi
  6fc3b7:	e8 a4 80 ff ff       	call   6f4460 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fc3bc:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fc3c3:	ff 
  6fc3c4:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  6fc3cb:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  6fc3d2:	4c 89 e6             	mov    %r12,%rsi
  6fc3d5:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  6fc3dc:	00 
  6fc3dd:	ff 15 fd bc 42 00    	call   *0x42bcfd(%rip)        # b280e0 <_DYNAMIC+0x428>
  6fc3e3:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  6fc3ea:	01 
  6fc3eb:	b0 01                	mov    $0x1,%al
  6fc3ed:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fc3f4:	00 
  6fc3f5:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc3fa:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fc3ff:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fc404:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  6fc40b:	00 
  6fc40c:	0f 94 c0             	sete   %al
  6fc40f:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  6fc416:	74 0c                	je     6fc424 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x16f4>
  6fc418:	b0 01                	mov    $0x1,%al
  6fc41a:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fc421:	00 
  6fc422:	eb 19                	jmp    6fc43d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x170d>
  6fc424:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  6fc42b:	b0 01                	mov    $0x1,%al
  6fc42d:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fc434:	00 
  6fc435:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  6fc43c:	00 
  6fc43d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fc442:	48 83 c1 04          	add    $0x4,%rcx
  6fc446:	48 39 c8             	cmp    %rcx,%rax
  6fc449:	0f 85 cc f5 ff ff    	jne    6fba1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xceb>
  6fc44f:	e9 ee 02 00 00       	jmp    6fc742 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a12>
  6fc454:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fc458:	ff 15 da ba 42 00    	call   *0x42bada(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fc45e:	e9 75 fa ff ff       	jmp    6fbed8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x11a8>
  6fc463:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fc467:	ff 15 cb ba 42 00    	call   *0x42bacb(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fc46d:	e9 a1 f9 ff ff       	jmp    6fbe13 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x10e3>
  6fc472:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fc476:	ff 15 bc ba 42 00    	call   *0x42babc(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fc47c:	e9 df fa ff ff       	jmp    6fbf60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1230>
  6fc481:	49 83 c4 04          	add    $0x4,%r12
  6fc485:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fc48a:	0f 84 b1 f4 ff ff    	je     6fb941 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xc11>
  6fc490:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fc495:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fc499:	ff 15 09 bc 42 00    	call   *0x42bc09(%rip)        # b280a8 <_DYNAMIC+0x3f0>
  6fc49f:	66 85 c0             	test   %ax,%ax
  6fc4a2:	74 dd                	je     6fc481 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1751>
  6fc4a4:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fc4a9:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  6fc4ae:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  6fc4b5:	00 
  6fc4b6:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  6fc4bb:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  6fc4bf:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fc4c6:	00 00 
  6fc4c8:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  6fc4cc:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc4d3:	00 
  6fc4d4:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fc4d9:	89 c2                	mov    %eax,%edx
  6fc4db:	ff 15 cf bb 42 00    	call   *0x42bbcf(%rip)        # b280b0 <_DYNAMIC+0x3f8>
  6fc4e1:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  6fc4e8:	ff 
  6fc4e9:	75 96                	jne    6fc481 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1751>
  6fc4eb:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fc4f2:	00 
  6fc4f3:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fc4fa:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fc501:	00 
  6fc502:	48 c1 e5 20          	shl    $0x20,%rbp
  6fc506:	48 09 c5             	or     %rax,%rbp
  6fc509:	b8 24 00 00 00       	mov    $0x24,%eax
  6fc50e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc513:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc518:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fc51d:	48 85 f6             	test   %rsi,%rsi
  6fc520:	0f 8e 12 02 00 00    	jle    6fc738 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a08>
  6fc526:	ba 01 00 00 00       	mov    $0x1,%edx
  6fc52b:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fc52f:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fc534:	ff 15 c6 b9 42 00    	call   *0x42b9c6(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fc53a:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fc53e:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fc543:	e9 1f 03 00 00       	jmp    6fc867 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fc548:	31 ff                	xor    %edi,%edi
  6fc54a:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fc54f:	48 85 f6             	test   %rsi,%rsi
  6fc552:	7e 5c                	jle    6fc5b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fc554:	ba 01 00 00 00       	mov    $0x1,%edx
  6fc559:	89 fd                	mov    %edi,%ebp
  6fc55b:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fc560:	ff 15 9a b9 42 00    	call   *0x42b99a(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fc566:	89 ef                	mov    %ebp,%edi
  6fc568:	eb 46                	jmp    6fc5b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fc56a:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fc571:	00 
  6fc572:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fc579:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fc580:	00 
  6fc581:	48 c1 e5 20          	shl    $0x20,%rbp
  6fc585:	48 09 c5             	or     %rax,%rbp
  6fc588:	b8 24 00 00 00       	mov    $0x24,%eax
  6fc58d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc592:	e9 99 02 00 00       	jmp    6fc830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fc597:	b0 01                	mov    $0x1,%al
  6fc599:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fc59e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fc5a5:	48 85 ed             	test   %rbp,%rbp
  6fc5a8:	0f 85 0e ef ff ff    	jne    6fb4bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x78c>
  6fc5ae:	31 ff                	xor    %edi,%edi
  6fc5b0:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  6fc5b5:	74 3c                	je     6fc5f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18c3>
  6fc5b7:	41 80 be 1f 08 00 00 	cmpb   $0x1,0x81f(%r14)
  6fc5be:	01 
  6fc5bf:	75 32                	jne    6fc5f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18c3>
  6fc5c1:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc5c6:	4c 89 f6             	mov    %r14,%rsi
  6fc5c9:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fc5d0:	00 
  6fc5d1:	31 c9                	xor    %ecx,%ecx
  6fc5d3:	e8 c8 de ff ff       	call   6fa4a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  6fc5d8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fc5dd:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fc5e1:	75 1e                	jne    6fc601 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x18d1>
  6fc5e3:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fc5ea:	ff ff 
  6fc5ec:	31 ff                	xor    %edi,%edi
  6fc5ee:	e9 94 02 00 00       	jmp    6fc887 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fc5f3:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fc5fa:	ff ff 
  6fc5fc:	e9 86 02 00 00       	jmp    6fc887 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fc601:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fc606:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  6fc60b:	c1 e1 10             	shl    $0x10,%ecx
  6fc60e:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  6fc613:	09 ca                	or     %ecx,%edx
  6fc615:	48 c1 e2 20          	shl    $0x20,%rdx
  6fc619:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fc61d:	48 09 d5             	or     %rdx,%rbp
  6fc620:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fc627:	00 
  6fc628:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fc62f:	00 
  6fc630:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fc637:	00 00 
  6fc639:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  6fc640:	00 00 
  6fc642:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  6fc649:	00 
  6fc64a:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  6fc651:	00 
  6fc652:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc657:	e9 2b 02 00 00       	jmp    6fc887 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b57>
  6fc65c:	b8 20 00 00 00       	mov    $0x20,%eax
  6fc661:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc666:	40 b7 0c             	mov    $0xc,%dil
  6fc669:	31 ed                	xor    %ebp,%ebp
  6fc66b:	4d 89 f8             	mov    %r15,%r8
  6fc66e:	e9 bd 01 00 00       	jmp    6fc830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fc673:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  6fc67a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  6fc67e:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  6fc685:	40 0f 94 c5          	sete   %bpl
  6fc689:	48 ff c0             	inc    %rax
  6fc68c:	0f 84 d5 f0 ff ff    	je     6fb767 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0xa37>
  6fc692:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  6fc699:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fc6a0:	00 
  6fc6a1:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  6fc6a8:	00 
  6fc6a9:	ff 15 39 ba 42 00    	call   *0x42ba39(%rip)        # b280e8 <_DYNAMIC+0x430>
  6fc6af:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  6fc6b6:	00 
  6fc6b7:	74 21                	je     6fc6da <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19aa>
  6fc6b9:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  6fc6c0:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  6fc6c7:	40 84 ed             	test   %bpl,%bpl
  6fc6ca:	0f 84 48 01 00 00    	je     6fc818 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae8>
  6fc6d0:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  6fc6d7:	00 
  6fc6d8:	eb 16                	jmp    6fc6f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x19c0>
  6fc6da:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fc6e1:	00 00 00 00 
  6fc6e5:	31 d2                	xor    %edx,%edx
  6fc6e7:	40 84 ed             	test   %bpl,%bpl
  6fc6ea:	0f 84 28 01 00 00    	je     6fc818 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae8>
  6fc6f0:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fc6f5:	4c 89 f6             	mov    %r14,%rsi
  6fc6f8:	e8 c3 30 00 00       	call   6ff7c0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::finish_color_slot>
  6fc6fd:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fc702:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fc707:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fc70b:	0f 85 8c 00 00 00    	jne    6fc79d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a6d>
  6fc711:	40 f6 c7 01          	test   $0x1,%dil
  6fc715:	0f 84 f6 00 00 00    	je     6fc811 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ae1>
  6fc71b:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fc722:	ff ff 
  6fc724:	40 b7 02             	mov    $0x2,%dil
  6fc727:	e9 04 01 00 00       	jmp    6fc830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fc72c:	31 ff                	xor    %edi,%edi
  6fc72e:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc733:	e9 12 fe ff ff       	jmp    6fc54a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fc738:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fc73d:	e9 25 01 00 00       	jmp    6fc867 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b37>
  6fc742:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fc749:	00 
  6fc74a:	34 01                	xor    $0x1,%al
  6fc74c:	0f b6 c0             	movzbl %al,%eax
  6fc74f:	31 ff                	xor    %edi,%edi
  6fc751:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  6fc758:	01 
  6fc759:	0f 45 f8             	cmovne %eax,%edi
  6fc75c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fc761:	48 85 c0             	test   %rax,%rax
  6fc764:	0f 84 e0 fd ff ff    	je     6fc54a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fc76a:	f6 00 01             	testb  $0x1,(%rax)
  6fc76d:	0f 85 d7 fd ff ff    	jne    6fc54a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fc773:	89 fd                	mov    %edi,%ebp
  6fc775:	48 8b 40 08          	mov    0x8(%rax),%rax
  6fc779:	a8 01                	test   $0x1,%al
  6fc77b:	75 14                	jne    6fc791 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1a61>
  6fc77d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fc782:	48 83 c0 08          	add    $0x8,%rax
  6fc786:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fc78b:	0f 84 b5 03 00 00    	je     6fcb46 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e16>
  6fc791:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc796:	89 ef                	mov    %ebp,%edi
  6fc798:	e9 ad fd ff ff       	jmp    6fc54a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fc79d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc7a2:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6fc7a7:	c1 e0 10             	shl    $0x10,%eax
  6fc7aa:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6fc7af:	09 c1                	or     %eax,%ecx
  6fc7b1:	48 c1 e1 20          	shl    $0x20,%rcx
  6fc7b5:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fc7b9:	48 09 cd             	or     %rcx,%rbp
  6fc7bc:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fc7c3:	00 
  6fc7c4:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fc7cb:	00 
  6fc7cc:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fc7d3:	00 
  6fc7d4:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  6fc7db:	00 
  6fc7dc:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fc7e3:	00 
  6fc7e4:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6fc7eb:	00 
  6fc7ec:	eb 42                	jmp    6fc830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b00>
  6fc7ee:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fc7f5:	00 
  6fc7f6:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fc7fd:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fc804:	00 
  6fc805:	48 c1 e5 20          	shl    $0x20,%rbp
  6fc809:	48 09 c5             	or     %rax,%rbp
  6fc80c:	e9 85 01 00 00       	jmp    6fc996 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c66>
  6fc811:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  6fc818:	48 85 d2             	test   %rdx,%rdx
  6fc81b:	0f 95 c0             	setne  %al
  6fc81e:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  6fc825:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6fc82c:	ff ff 
  6fc82e:	31 ff                	xor    %edi,%edi
  6fc830:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6fc835:	48 85 f6             	test   %rsi,%rsi
  6fc838:	7e 22                	jle    6fc85c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1b2c>
  6fc83a:	ba 01 00 00 00       	mov    $0x1,%edx
  6fc83f:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fc844:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fc848:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fc84d:	ff 15 ad b6 42 00    	call   *0x42b6ad(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fc853:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fc857:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fc85c:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  6fc861:	0f 84 49 fd ff ff    	je     6fc5b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1880>
  6fc867:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  6fc86e:	00 
  6fc86f:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  6fc876:	00 
  6fc877:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  6fc87e:	00 
  6fc87f:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  6fc886:	00 
  6fc887:	40 0f b6 c7          	movzbl %dil,%eax
  6fc88b:	48 c1 e5 08          	shl    $0x8,%rbp
  6fc88f:	48 09 c5             	or     %rax,%rbp
  6fc892:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  6fc899:	00 
  6fc89a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fc8a1:	00 
  6fc8a2:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  6fc8a9:	00 00 
  6fc8ab:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  6fc8b2:	00 00 
  6fc8b4:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fc8b9:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  6fc8c0:	00 
  6fc8c1:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  6fc8c8:	00 
  6fc8c9:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  6fc8d0:	00 
  6fc8d1:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  6fc8d8:	00 
  6fc8d9:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  6fc8e0:	00 00 
  6fc8e2:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6fc8e9:	00 
  6fc8ea:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  6fc8f1:	00 
  6fc8f2:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  6fc8f9:	00 
  6fc8fa:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  6fc901:	00 
  6fc902:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  6fc909:	00 
  6fc90a:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fc911:	00 
  6fc912:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  6fc919:	00 
  6fc91a:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  6fc921:	00 
  6fc922:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  6fc929:	00 
  6fc92a:	31 ed                	xor    %ebp,%ebp
  6fc92c:	e9 41 e6 ff ff       	jmp    6faf72 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x242>
  6fc931:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc936:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6fc93b:	c1 e0 10             	shl    $0x10,%eax
  6fc93e:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6fc943:	09 c1                	or     %eax,%ecx
  6fc945:	48 c1 e1 20          	shl    $0x20,%rcx
  6fc949:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6fc94d:	48 09 cd             	or     %rcx,%rbp
  6fc950:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  6fc957:	00 
  6fc958:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fc95d:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fc964:	00 
  6fc965:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fc96c:	00 00 
  6fc96e:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  6fc975:	00 00 
  6fc977:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fc97e:	00 
  6fc97f:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6fc986:	00 
  6fc987:	eb 17                	jmp    6fc9a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1c70>
  6fc989:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  6fc990:	00 00 00 
  6fc993:	48 21 c5             	and    %rax,%rbp
  6fc996:	b8 24 00 00 00       	mov    $0x24,%eax
  6fc99b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fc9a0:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fc9a5:	48 85 c9             	test   %rcx,%rcx
  6fc9a8:	0f 84 65 fb ff ff    	je     6fc513 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fc9ae:	f6 01 01             	testb  $0x1,(%rcx)
  6fc9b1:	0f 85 5c fb ff ff    	jne    6fc513 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fc9b7:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fc9bb:	a8 01                	test   $0x1,%al
  6fc9bd:	0f 85 50 fb ff ff    	jne    6fc513 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e3>
  6fc9c3:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fc9c7:	48 8d 41 08          	lea    0x8(%rcx),%rax
  6fc9cb:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fc9d0:	0f 84 53 01 00 00    	je     6fcb29 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1df9>
  6fc9d6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fc9db:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fc9df:	e9 34 fb ff ff       	jmp    6fc518 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e8>
  6fc9e4:	48 8d 3d b5 cf 3f 00 	lea    0x3fcfb5(%rip),%rdi        # af99a0 <__frame_dummy_init_array_entry+0x478>
  6fc9eb:	ff 15 cf b5 42 00    	call   *0x42b5cf(%rip)        # b27fc0 <_DYNAMIC+0x308>
  6fc9f1:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fc9f5:	ff 15 3d b5 42 00    	call   *0x42b53d(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fc9fb:	e9 c0 e6 ff ff       	jmp    6fb0c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x390>
  6fca00:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  6fca06:	eb 3c                	jmp    6fca44 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d14>
  6fca08:	48 8d 05 95 db 96 ff 	lea    -0x69246b(%rip),%rax        # 6a5a4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b7>
  6fca0f:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6fca16:	00 
  6fca17:	48 8d 05 ea d7 3f 00 	lea    0x3fd7ea(%rip),%rax        # afa208 <__frame_dummy_init_array_entry+0xce0>
  6fca1e:	eb 1c                	jmp    6fca3c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1d0c>
  6fca20:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  6fca26:	48 8d 05 63 db 96 ff 	lea    -0x69249d(%rip),%rax        # 6a590 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34a3>
  6fca2d:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6fca34:	00 
  6fca35:	48 8d 05 b4 d7 3f 00 	lea    0x3fd7b4(%rip),%rax        # afa1f0 <__frame_dummy_init_array_entry+0xcc8>
  6fca3c:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  6fca43:	00 
  6fca44:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  6fca4b:	00 
  6fca4c:	4c 89 e6             	mov    %r12,%rsi
  6fca4f:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fca56:	00 
  6fca57:	ff 15 a3 b5 42 00    	call   *0x42b5a3(%rip)        # b28000 <_DYNAMIC+0x348>
  6fca5d:	e9 a7 01 00 00       	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fca62:	48 8d 3d ff da 96 ff 	lea    -0x692501(%rip),%rdi        # 6a568 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x347b>
  6fca69:	48 8d 15 20 d7 3f 00 	lea    0x3fd720(%rip),%rdx        # afa190 <__frame_dummy_init_array_entry+0xc68>
  6fca70:	be 13 00 00 00       	mov    $0x13,%esi
  6fca75:	ff 15 85 b5 42 00    	call   *0x42b585(%rip)        # b28000 <_DYNAMIC+0x348>
  6fca7b:	e9 89 01 00 00       	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fca80:	48 8d 3d 5e db 96 ff 	lea    -0x6924a2(%rip),%rdi        # 6a5e5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34f8>
  6fca87:	48 8d 15 da d7 3f 00 	lea    0x3fd7da(%rip),%rdx        # afa268 <__frame_dummy_init_array_entry+0xd40>
  6fca8e:	be 93 00 00 00       	mov    $0x93,%esi
  6fca93:	ff 15 57 b6 42 00    	call   *0x42b657(%rip)        # b280f0 <_DYNAMIC+0x438>
  6fca99:	e9 6b 01 00 00       	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fca9e:	48 8d 05 2a db 96 ff 	lea    -0x6924d6(%rip),%rax        # 6a5cf <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34e2>
  6fcaa5:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  6fcaac:	00 
  6fcaad:	48 8d 05 6c d7 3f 00 	lea    0x3fd76c(%rip),%rax        # afa220 <__frame_dummy_init_array_entry+0xcf8>
  6fcab4:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  6fcabb:	00 
  6fcabc:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  6fcac3:	00 
  6fcac4:	4c 89 ee             	mov    %r13,%rsi
  6fcac7:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  6fcace:	00 
  6fcacf:	ff 15 2b b5 42 00    	call   *0x42b52b(%rip)        # b28000 <_DYNAMIC+0x348>
  6fcad5:	e9 2f 01 00 00       	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fcada:	48 8d 3d c7 cb 3f 00 	lea    0x3fcbc7(%rip),%rdi        # af96a8 <__frame_dummy_init_array_entry+0x180>
  6fcae1:	ff 15 d9 b4 42 00    	call   *0x42b4d9(%rip)        # b27fc0 <_DYNAMIC+0x308>
  6fcae7:	e9 1d 01 00 00       	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fcaec:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fcaf3:	00 00 
  6fcaf5:	48 8d 3d 3c d7 3f 00 	lea    0x3fd73c(%rip),%rdi        # afa238 <__frame_dummy_init_array_entry+0xd10>
  6fcafc:	ff 15 be b4 42 00    	call   *0x42b4be(%rip)        # b27fc0 <_DYNAMIC+0x308>
  6fcb02:	e9 02 01 00 00       	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fcb07:	48 8d 05 6a cb 3f 00 	lea    0x3fcb6a(%rip),%rax        # af9678 <__frame_dummy_init_array_entry+0x150>
  6fcb0e:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  6fcb15:	00 
  6fcb16:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  6fcb1d:	00 
  6fcb1e:	ff 15 9c b4 42 00    	call   *0x42b49c(%rip)        # b27fc0 <_DYNAMIC+0x308>
  6fcb24:	e9 e0 00 00 00       	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fcb29:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fcb2e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcb32:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fcb37:	ff 15 fb b3 42 00    	call   *0x42b3fb(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fcb3d:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fcb41:	e9 d2 f9 ff ff       	jmp    6fc518 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x17e8>
  6fcb46:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fcb4b:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fcb4f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fcb54:	ff 15 de b3 42 00    	call   *0x42b3de(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fcb5a:	89 ef                	mov    %ebp,%edi
  6fcb5c:	e9 e9 f9 ff ff       	jmp    6fc54a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x181a>
  6fcb61:	48 8d 15 28 cb 3f 00 	lea    0x3fcb28(%rip),%rdx        # af9690 <__frame_dummy_init_array_entry+0x168>
  6fcb68:	ff 15 a2 b4 42 00    	call   *0x42b4a2(%rip)        # b28010 <_DYNAMIC+0x358>
  6fcb6e:	e9 96 00 00 00       	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fcb73:	48 8d 05 6e ce 3f 00 	lea    0x3fce6e(%rip),%rax        # af99e8 <__frame_dummy_init_array_entry+0x4c0>
  6fcb7a:	eb 47                	jmp    6fcbc3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fcb7c:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fcb81:	48 8d 05 78 ce 3f 00 	lea    0x3fce78(%rip),%rax        # af9a00 <__frame_dummy_init_array_entry+0x4d8>
  6fcb88:	eb 39                	jmp    6fcbc3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fcb8a:	48 8d 05 3f ce 3f 00 	lea    0x3fce3f(%rip),%rax        # af99d0 <__frame_dummy_init_array_entry+0x4a8>
  6fcb91:	eb 30                	jmp    6fcbc3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fcb93:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fcb98:	48 8d 05 f1 ca 3f 00 	lea    0x3fcaf1(%rip),%rax        # af9690 <__frame_dummy_init_array_entry+0x168>
  6fcb9f:	eb 22                	jmp    6fcbc3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1e93>
  6fcba1:	48 85 ff             	test   %rdi,%rdi
  6fcba4:	75 34                	jne    6fcbda <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1eaa>
  6fcba6:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fcbad:	00 00 
  6fcbaf:	ff 15 43 b5 42 00    	call   *0x42b543(%rip)        # b280f8 <_DYNAMIC+0x440>
  6fcbb5:	eb 52                	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fcbb7:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fcbbc:	48 8d 05 9d ca 3f 00 	lea    0x3fca9d(%rip),%rax        # af9660 <__frame_dummy_init_array_entry+0x138>
  6fcbc3:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  6fcbc8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fcbcd:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  6fcbd2:	ff 15 38 b4 42 00    	call   *0x42b438(%rip)        # b28010 <_DYNAMIC+0x358>
  6fcbd8:	eb 2f                	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fcbda:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  6fcbdf:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fcbe6:	00 00 
  6fcbe8:	ff 15 3a b3 42 00    	call   *0x42b33a(%rip)        # b27f28 <_DYNAMIC+0x270>
  6fcbee:	eb 19                	jmp    6fcc09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1ed9>
  6fcbf0:	48 8d 3d 84 d9 96 ff 	lea    -0x69267c(%rip),%rdi        # 6a57b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348e>
  6fcbf7:	48 8d 15 aa d5 3f 00 	lea    0x3fd5aa(%rip),%rdx        # afa1a8 <__frame_dummy_init_array_entry+0xc80>
  6fcbfe:	be 15 00 00 00       	mov    $0x15,%esi
  6fcc03:	ff 15 f7 b3 42 00    	call   *0x42b3f7(%rip)        # b28000 <_DYNAMIC+0x348>
  6fcc09:	0f 0b                	ud2
  6fcc0b:	49 89 c5             	mov    %rax,%r13
  6fcc0e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fcc13:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fcc17:	eb 6d                	jmp    6fcc86 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fcc19:	49 89 c5             	mov    %rax,%r13
  6fcc1c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fcc21:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fcc25:	eb 5f                	jmp    6fcc86 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fcc27:	49 89 c5             	mov    %rax,%r13
  6fcc2a:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fcc2e:	eb 56                	jmp    6fcc86 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fcc30:	48 89 c3             	mov    %rax,%rbx
  6fcc33:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fcc3a:	00 
  6fcc3b:	e8 40 ae ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fcc40:	48 89 df             	mov    %rbx,%rdi
  6fcc43:	e8 28 b5 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fcc48:	eb 18                	jmp    6fcc62 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f32>
  6fcc4a:	eb 16                	jmp    6fcc62 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f32>
  6fcc4c:	eb 00                	jmp    6fcc4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f1e>
  6fcc4e:	49 89 c5             	mov    %rax,%r13
  6fcc51:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fcc58:	ff 
  6fcc59:	eb 2b                	jmp    6fcc86 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f56>
  6fcc5b:	49 89 c5             	mov    %rax,%r13
  6fcc5e:	eb 4d                	jmp    6fccad <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fcc60:	eb 21                	jmp    6fcc83 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f53>
  6fcc62:	49 89 c5             	mov    %rax,%r13
  6fcc65:	eb 29                	jmp    6fcc90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f60>
  6fcc67:	49 89 c5             	mov    %rax,%r13
  6fcc6a:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  6fcc70:	7e 3b                	jle    6fccad <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fcc72:	ba 01 00 00 00       	mov    $0x1,%edx
  6fcc77:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6fcc7c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6fcc81:	eb 24                	jmp    6fcca7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f77>
  6fcc83:	49 89 c5             	mov    %rax,%r13
  6fcc86:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6fcc8b:	e8 40 77 ff ff       	call   6f43d0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  6fcc90:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  6fcc96:	7e 15                	jle    6fccad <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1f7d>
  6fcc98:	ba 01 00 00 00       	mov    $0x1,%edx
  6fcc9d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fcca2:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fcca7:	ff 15 53 b2 42 00    	call   *0x42b253(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fccad:	4c 89 ef             	mov    %r13,%rdi
  6fccb0:	ff 15 6a b3 42 00    	call   *0x42b36a(%rip)        # b28020 <_DYNAMIC+0x368>
  6fccb6:	49 89 c5             	mov    %rax,%r13
  6fccb9:	48 89 d5             	mov    %rdx,%rbp
  6fccbc:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  6fccc3:	00 
  6fccc4:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  6fcccb:	00 
  6fcccc:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  6fccd3:	00 fd ff ff ff 
  6fccd8:	4c 89 f7             	mov    %r14,%rdi
  6fccdb:	e8 60 ca 01 00       	call   719740 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fcce0:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  6fcce7:	00 0f 00 00 00 
  6fccec:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6fccf0:	48 85 c0             	test   %rax,%rax
  6fccf3:	74 05                	je     6fccfa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fca>
  6fccf5:	4c 89 ef             	mov    %r13,%rdi
  6fccf8:	ff d0                	call   *%rax
  6fccfa:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6fccfe:	48 85 f6             	test   %rsi,%rsi
  6fcd01:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fcd06:	74 0d                	je     6fcd15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x1fe5>
  6fcd08:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6fcd0c:	4c 89 ef             	mov    %r13,%rdi
  6fcd0f:	ff 15 eb b1 42 00    	call   *0x42b1eb(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fcd15:	31 ed                	xor    %ebp,%ebp
  6fcd17:	e9 56 e2 ff ff       	jmp    6faf72 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x242>
  6fcd1c:	48 89 c3             	mov    %rax,%rbx
  6fcd1f:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6fcd23:	48 85 f6             	test   %rsi,%rsi
  6fcd26:	74 2b                	je     6fcd53 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing+0x2023>
  6fcd28:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6fcd2c:	4c 89 ef             	mov    %r13,%rdi
  6fcd2f:	ff 15 cb b1 42 00    	call   *0x42b1cb(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fcd35:	48 89 df             	mov    %rbx,%rdi
  6fcd38:	e8 33 b4 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fcd3d:	ff 15 ed b1 42 00    	call   *0x42b1ed(%rip)        # b27f30 <_DYNAMIC+0x278>
  6fcd43:	48 89 c3             	mov    %rax,%rbx
  6fcd46:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fcd4d:	00 
  6fcd4e:	e8 4d 7b ff ff       	call   6f48a0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fcd53:	48 89 df             	mov    %rbx,%rdi
  6fcd56:	e8 15 b4 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fcd5b:	ff 15 cf b1 42 00    	call   *0x42b1cf(%rip)        # b27f30 <_DYNAMIC+0x278>
  6fcd61:	ff 15 c1 b2 42 00    	call   *0x42b2c1(%rip)        # b28028 <_DYNAMIC+0x370>
