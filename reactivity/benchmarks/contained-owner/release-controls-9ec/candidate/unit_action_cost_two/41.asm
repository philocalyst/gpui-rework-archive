
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fe960 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>:
  6fe960:	55                   	push   %rbp
  6fe961:	41 57                	push   %r15
  6fe963:	41 56                	push   %r14
  6fe965:	41 55                	push   %r13
  6fe967:	41 54                	push   %r12
  6fe969:	53                   	push   %rbx
  6fe96a:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  6fe971:	4d 89 c4             	mov    %r8,%r12
  6fe974:	49 89 cf             	mov    %rcx,%r15
  6fe977:	49 89 f6             	mov    %rsi,%r14
  6fe97a:	48 89 fb             	mov    %rdi,%rbx
  6fe97d:	41 83 38 02          	cmpl   $0x2,(%r8)
  6fe981:	75 08                	jne    6fe98b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2b>
  6fe983:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fe98a:	01 
  6fe98b:	4d 85 ff             	test   %r15,%r15
  6fe98e:	0f 84 94 01 00 00    	je     6feb28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c8>
  6fe994:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  6fe99b:	01 
  6fe99c:	0f 85 86 01 00 00    	jne    6feb28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c8>
  6fe9a2:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  6fe9a9:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  6fe9b0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fe9b4:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  6fe9b9:	48 0f 44 ce          	cmove  %rsi,%rcx
  6fe9bd:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  6fe9c1:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  6fe9c8:	00 00 
  6fe9ca:	74 45                	je     6fea11 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb1>
  6fe9cc:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  6fe9d3:	00 00 
  6fe9d5:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  6fe9dc:	00 00 
  6fe9de:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fe9e5:	00 
  6fe9e6:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  6fe9ed:	00 
  6fe9ee:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6fe9f5:	00 
  6fe9f6:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  6fe9fa:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  6fe9fe:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fea05:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fea09:	88 4b 10             	mov    %cl,0x10(%rbx)
  6fea0c:	e9 5e 03 00 00       	jmp    6fed6f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fea11:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  6fea16:	41 83 ff 01          	cmp    $0x1,%r15d
  6fea1a:	0f 85 80 00 00 00    	jne    6feaa0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x140>
  6fea20:	48 89 d5             	mov    %rdx,%rbp
  6fea23:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  6fea2a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  6fea31:	49 c1 e4 04          	shl    $0x4,%r12
  6fea35:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6fea3c:	00 00 00 00 
  6fea40:	4d 85 e4             	test   %r12,%r12
  6fea43:	0f 84 7a 03 00 00    	je     6fedc3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x463>
  6fea49:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  6fea4d:	48 8b 39             	mov    (%rcx),%rdi
  6fea50:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fea54:	ff 50 18             	call   *0x18(%rax)
  6fea57:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  6fea5b:	4c 89 e9             	mov    %r13,%rcx
  6fea5e:	4c 39 f8             	cmp    %r15,%rax
  6fea61:	75 dd                	jne    6fea40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xe0>
  6fea63:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  6fea6a:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  6fea71:	48 c1 e0 03          	shl    $0x3,%rax
  6fea75:	31 f6                	xor    %esi,%esi
  6fea77:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fea7c:	0f 1f 40 00          	nopl   0x0(%rax)
  6fea80:	48 89 f2             	mov    %rsi,%rdx
  6fea83:	48 39 f0             	cmp    %rsi,%rax
  6fea86:	74 0a                	je     6fea92 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x132>
  6fea88:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  6fea8c:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  6fea90:	75 ee                	jne    6fea80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x120>
  6fea92:	48 39 d0             	cmp    %rdx,%rax
  6fea95:	0f 95 c1             	setne  %cl
  6fea98:	48 89 ea             	mov    %rbp,%rdx
  6fea9b:	e9 7f 00 00 00       	jmp    6feb1f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1bf>
  6feaa0:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6feaa7:	00 
  6feaa8:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  6feaaf:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  6feab6:	49 c1 e5 04          	shl    $0x4,%r13
  6feaba:	31 ed                	xor    %ebp,%ebp
  6feabc:	0f 1f 40 00          	nopl   0x0(%rax)
  6feac0:	49 39 ed             	cmp    %rbp,%r13
  6feac3:	0f 84 0e 03 00 00    	je     6fedd7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x477>
  6feac9:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  6feacd:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  6fead2:	4c 89 fe             	mov    %r15,%rsi
  6fead5:	ff 50 30             	call   *0x30(%rax)
  6fead8:	48 83 c5 10          	add    $0x10,%rbp
  6feadc:	84 c0                	test   %al,%al
  6feade:	74 e0                	je     6feac0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160>
  6feae0:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  6feae5:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  6feaea:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  6feaf1:	00 
  6feaf2:	4c 89 fa             	mov    %r15,%rdx
  6feaf5:	ff 50 60             	call   *0x60(%rax)
  6feaf8:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  6feaff:	00 
  6feb00:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6feb07:	00 
  6feb08:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6feb0c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6feb11:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6feb18:	00 
  6feb19:	0f 85 c7 fe ff ff    	jne    6fe9e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6feb1f:	f6 c1 01             	test   $0x1,%cl
  6feb22:	0f 84 f4 02 00 00    	je     6fee1c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x4bc>
  6feb28:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  6feb2f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6feb34:	4c 89 f6             	mov    %r14,%rsi
  6feb37:	31 c9                	xor    %ecx,%ecx
  6feb39:	e8 92 ee ff ff       	call   6fd9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  6feb3e:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  6feb43:	75 16                	jne    6feb5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fb>
  6feb45:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  6feb4c:	00 
  6feb4d:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  6feb54:	00 fe ff ff ff 
  6feb59:	eb 41                	jmp    6feb9c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x23c>
  6feb5b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6feb62:	00 
  6feb63:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6feb6a:	00 
  6feb6b:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  6feb71:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  6feb78:	00 00 
  6feb7a:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  6feb81:	00 
  6feb82:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  6feb89:	00 
  6feb8a:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  6feb91:	00 00 
  6feb93:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  6feb9a:	00 00 
  6feb9c:	40 b5 01             	mov    $0x1,%bpl
  6feb9f:	45 31 ff             	xor    %r15d,%r15d
  6feba2:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  6feba9:	00 fe 
  6febab:	0f 85 ba 00 00 00    	jne    6fec6b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x30b>
  6febb1:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6febb8:	00 
  6febb9:	4c 89 f6             	mov    %r14,%rsi
  6febbc:	4c 89 e2             	mov    %r12,%rdx
  6febbf:	e8 2c 40 00 00       	call   702bf0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::reconcile_editing>
  6febc4:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6febcb:	00 
  6febcc:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  6febd3:	00 00 
  6febd5:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6febd9:	0f 85 61 01 00 00    	jne    6fed40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x3e0>
  6febdf:	48 8d 35 92 90 96 ff 	lea    -0x696f6e(%rip),%rsi        # 67c78 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x99b>
  6febe6:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6febed:	00 
  6febee:	e8 cd d7 02 00       	call   72c3c0 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6febf3:	84 c0                	test   %al,%al
  6febf5:	74 26                	je     6fec1d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2bd>
  6febf7:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6febfe:	48 85 c0             	test   %rax,%rax
  6fec01:	0f 84 7a 01 00 00    	je     6fed81 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x421>
  6fec07:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fec0e:	00 
  6fec0f:	0f 95 c0             	setne  %al
  6fec12:	44 08 e0             	or     %r12b,%al
  6fec15:	a8 01                	test   $0x1,%al
  6fec17:	0f 84 6e 01 00 00    	je     6fed8b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x42b>
  6fec1d:	48 8d 35 8c 90 96 ff 	lea    -0x696f74(%rip),%rsi        # 67cb0 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x9d3>
  6fec24:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fec2b:	00 
  6fec2c:	e8 8f d7 02 00       	call   72c3c0 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fec31:	84 c0                	test   %al,%al
  6fec33:	74 26                	je     6fec5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2fb>
  6fec35:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fec3c:	48 85 c0             	test   %rax,%rax
  6fec3f:	0f 84 a7 01 00 00    	je     6fedec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x48c>
  6fec45:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fec4c:	00 
  6fec4d:	0f 95 c0             	setne  %al
  6fec50:	44 08 e0             	or     %r12b,%al
  6fec53:	a8 01                	test   $0x1,%al
  6fec55:	0f 84 9b 01 00 00    	je     6fedf6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x496>
  6fec5b:	48 89 df             	mov    %rbx,%rdi
  6fec5e:	4c 89 f6             	mov    %r14,%rsi
  6fec61:	e8 ba a8 02 00       	call   729520 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  6fec66:	e9 04 01 00 00       	jmp    6fed6f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fec6b:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  6fec72:	00 
  6fec73:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fec7a:	00 
  6fec7b:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  6fec82:	00 
  6fec83:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  6fec8a:	00 
  6fec8b:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  6fec92:	00 
  6fec93:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  6fec9a:	00 
  6fec9b:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  6feca2:	00 
  6feca3:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  6fecaa:	00 
  6fecab:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fecb2:	48 85 c0             	test   %rax,%rax
  6fecb5:	74 41                	je     6fecf8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fecb7:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fecbe:	48 85 c0             	test   %rax,%rax
  6fecc1:	74 35                	je     6fecf8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fecc3:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fecc7:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  6feccb:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  6feccf:	80 f9 02             	cmp    $0x2,%cl
  6fecd2:	74 24                	je     6fecf8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fecd4:	f6 07 01             	testb  $0x1,(%rdi)
  6fecd7:	75 17                	jne    6fecf0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6fecd9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fecdd:	a8 01                	test   $0x1,%al
  6fecdf:	75 0f                	jne    6fecf0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6fece1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fece5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fecea:	0f 84 31 19 00 00    	je     700621 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cc1>
  6fecf0:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fecf7:	01 
  6fecf8:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  6fecff:	00 
  6fed00:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fed07:	00 00 00 00 
  6fed0b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6fed12:	00 
  6fed13:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fed17:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  6fed1e:	00 00 
  6fed20:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  6fed27:	00 00 
  6fed29:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  6fed30:	00 
  6fed31:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fed35:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  6fed3a:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  6fed3e:	eb 2f                	jmp    6fed6f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fed40:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  6fed47:	00 00 
  6fed49:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  6fed50:	00 00 
  6fed52:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6fed59:	00 
  6fed5a:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6fed5e:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  6fed63:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  6fed68:	48 89 03             	mov    %rax,(%rbx)
  6fed6b:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  6fed6f:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  6fed76:	5b                   	pop    %rbx
  6fed77:	41 5c                	pop    %r12
  6fed79:	41 5d                	pop    %r13
  6fed7b:	41 5e                	pop    %r14
  6fed7d:	41 5f                	pop    %r15
  6fed7f:	5d                   	pop    %rbp
  6fed80:	c3                   	ret
  6fed81:	41 80 fc 01          	cmp    $0x1,%r12b
  6fed85:	0f 84 92 fe ff ff    	je     6fec1d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2bd>
  6fed8b:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  6fed92:	00 00 
  6fed94:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  6fed9b:	00 
  6fed9c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6feda3:	00 
  6feda4:	74 16                	je     6fedbc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x45c>
  6feda6:	84 c0                	test   %al,%al
  6feda8:	0f 84 c7 00 00 00    	je     6fee75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x515>
  6fedae:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fedb5:	ff 
  6fedb6:	0f 85 b9 00 00 00    	jne    6fee75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x515>
  6fedbc:	31 c9                	xor    %ecx,%ecx
  6fedbe:	e9 be 00 00 00       	jmp    6fee81 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x521>
  6fedc3:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fedca:	00 
  6fedcb:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fedd0:	b1 01                	mov    $0x1,%cl
  6fedd2:	e9 0f fc ff ff       	jmp    6fe9e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fedd7:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fedde:	00 
  6feddf:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fede4:	44 89 f9             	mov    %r15d,%ecx
  6fede7:	e9 fa fb ff ff       	jmp    6fe9e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fedec:	41 80 fc 01          	cmp    $0x1,%r12b
  6fedf0:	0f 84 65 fe ff ff    	je     6fec5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2fb>
  6fedf6:	40 84 ed             	test   %bpl,%bpl
  6fedf9:	0f 85 15 18 00 00    	jne    700614 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cb4>
  6fedff:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  6fee03:	4c 89 f6             	mov    %r14,%rsi
  6fee06:	31 d2                	xor    %edx,%edx
  6fee08:	4c 89 f9             	mov    %r15,%rcx
  6fee0b:	e8 10 53 00 00       	call   704120 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::publish_metadata>
  6fee10:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fee17:	e9 53 ff ff ff       	jmp    6fed6f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fee1c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  6fee23:	00 
  6fee24:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  6fee2b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  6fee32:	48 85 c0             	test   %rax,%rax
  6fee35:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fee3c:	00 
  6fee3d:	0f 84 90 02 00 00    	je     6ff0d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fee43:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  6fee4a:	48 85 c9             	test   %rcx,%rcx
  6fee4d:	0f 84 9c 00 00 00    	je     6feeef <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x58f>
  6fee53:	48 89 ca             	mov    %rcx,%rdx
  6fee56:	48 83 e2 07          	and    $0x7,%rdx
  6fee5a:	74 4c                	je     6feea8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x548>
  6fee5c:	31 f6                	xor    %esi,%esi
  6fee5e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fee65:	48 ff c6             	inc    %rsi
  6fee68:	48 39 f2             	cmp    %rsi,%rdx
  6fee6b:	75 f1                	jne    6fee5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x4fe>
  6fee6d:	48 89 ca             	mov    %rcx,%rdx
  6fee70:	48 29 f2             	sub    %rsi,%rdx
  6fee73:	eb 36                	jmp    6feeab <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x54b>
  6fee75:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fee7c:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fee81:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fee88:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  6fee8c:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fee90:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  6fee95:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  6fee99:	88 43 30             	mov    %al,0x30(%rbx)
  6fee9c:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6feea3:	e9 c7 fe ff ff       	jmp    6fed6f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6feea8:	48 89 ca             	mov    %rcx,%rdx
  6feeab:	48 83 f9 08          	cmp    $0x8,%rcx
  6feeaf:	72 3e                	jb     6feeef <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x58f>
  6feeb1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feeb8:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feebf:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feec6:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feecd:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feed4:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feedb:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feee2:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6feee9:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  6feeed:	75 c2                	jne    6feeb1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x551>
  6feeef:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  6feef6:	00 
  6feef7:	0f 84 d6 01 00 00    	je     6ff0d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6feefd:	80 38 00             	cmpb   $0x0,(%rax)
  6fef00:	0f 85 cd 01 00 00    	jne    6ff0d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fef06:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  6fef0d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  6fef14:	00 
  6fef15:	e8 86 51 04 00       	call   7440a0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  6fef1a:	48 85 c0             	test   %rax,%rax
  6fef1d:	0f 84 b0 01 00 00    	je     6ff0d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fef23:	48 8b 48 10          	mov    0x10(%rax),%rcx
  6fef27:	48 c1 e1 02          	shl    $0x2,%rcx
  6fef2b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  6fef2f:	ba 04 00 00 00       	mov    $0x4,%edx
  6fef34:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  6fef39:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fef3e:	b8 00 00 00 00       	mov    $0x0,%eax
  6fef43:	48 0f 45 c1          	cmovne %rcx,%rax
  6fef47:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fef4c:	48 85 c0             	test   %rax,%rax
  6fef4f:	0f 84 7e 01 00 00    	je     6ff0d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fef55:	45 31 ed             	xor    %r13d,%r13d
  6fef58:	48 8b 05 39 a5 42 00 	mov    0x42a539(%rip),%rax        # b29498 <_DYNAMIC+0x398>
  6fef5f:	48 83 c0 20          	add    $0x20,%rax
  6fef63:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fef68:	48 8b 05 31 a5 42 00 	mov    0x42a531(%rip),%rax        # b294a0 <_DYNAMIC+0x3a0>
  6fef6f:	48 83 c0 20          	add    $0x20,%rax
  6fef73:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fef78:	48 8b 05 29 a5 42 00 	mov    0x42a529(%rip),%rax        # b294a8 <_DYNAMIC+0x3a8>
  6fef7f:	48 83 c0 20          	add    $0x20,%rax
  6fef83:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fef88:	48 8b 05 21 a5 42 00 	mov    0x42a521(%rip),%rax        # b294b0 <_DYNAMIC+0x3b0>
  6fef8f:	48 83 c0 20          	add    $0x20,%rax
  6fef93:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6fef98:	48 8b 05 19 a5 42 00 	mov    0x42a519(%rip),%rax        # b294b8 <_DYNAMIC+0x3b8>
  6fef9f:	48 83 c0 20          	add    $0x20,%rax
  6fefa3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fefa8:	48 8b 05 11 a5 42 00 	mov    0x42a511(%rip),%rax        # b294c0 <_DYNAMIC+0x3c0>
  6fefaf:	48 83 c0 20          	add    $0x20,%rax
  6fefb3:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fefba:	00 
  6fefbb:	48 8b 05 06 a5 42 00 	mov    0x42a506(%rip),%rax        # b294c8 <_DYNAMIC+0x3c8>
  6fefc2:	48 83 c0 20          	add    $0x20,%rax
  6fefc6:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fefcd:	00 
  6fefce:	48 8b 05 fb a4 42 00 	mov    0x42a4fb(%rip),%rax        # b294d0 <_DYNAMIC+0x3d0>
  6fefd5:	48 83 c0 20          	add    $0x20,%rax
  6fefd9:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fefde:	48 8b 05 f3 a4 42 00 	mov    0x42a4f3(%rip),%rax        # b294d8 <_DYNAMIC+0x3d8>
  6fefe5:	48 83 c0 20          	add    $0x20,%rax
  6fefe9:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  6feff0:	00 
  6feff1:	48 8b 05 e8 a4 42 00 	mov    0x42a4e8(%rip),%rax        # b294e0 <_DYNAMIC+0x3e0>
  6feff8:	48 83 c0 20          	add    $0x20,%rax
  6feffc:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6ff001:	48 8b 05 e0 a4 42 00 	mov    0x42a4e0(%rip),%rax        # b294e8 <_DYNAMIC+0x3e8>
  6ff008:	48 83 c0 20          	add    $0x20,%rax
  6ff00c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6ff013:	00 
  6ff014:	48 8b 05 d5 a4 42 00 	mov    0x42a4d5(%rip),%rax        # b294f0 <_DYNAMIC+0x3f0>
  6ff01b:	48 83 c0 20          	add    $0x20,%rax
  6ff01f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6ff024:	48 8b 05 cd a4 42 00 	mov    0x42a4cd(%rip),%rax        # b294f8 <_DYNAMIC+0x3f8>
  6ff02b:	48 83 c0 20          	add    $0x20,%rax
  6ff02f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6ff034:	48 8d 2d cd c2 95 ff 	lea    -0x6a3d33(%rip),%rbp        # 5b308 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x14a8>
  6ff03b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6ff040:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  6ff044:	ff 15 b6 a4 42 00    	call   *0x42a4b6(%rip)        # b29500 <_DYNAMIC+0x400>
  6ff04a:	0f b7 c0             	movzwl %ax,%eax
  6ff04d:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  6ff052:	48 01 e9             	add    %rbp,%rcx
  6ff055:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6ff05a:	ff e1                	jmp    *%rcx
  6ff05c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6ff061:	eb 57                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff063:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6ff06a:	00 
  6ff06b:	eb 4d                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff06d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6ff072:	eb 46                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff074:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6ff079:	eb 3f                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff07b:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  6ff082:	00 
  6ff083:	eb 35                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff085:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6ff08a:	eb 2e                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff08c:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ff093:	00 
  6ff094:	eb 24                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff096:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6ff09b:	eb 1d                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff09d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6ff0a2:	eb 16                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0a4:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6ff0ab:	00 
  6ff0ac:	eb 0c                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0ae:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6ff0b3:	eb 05                	jmp    6ff0ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6ff0b5:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ff0ba:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  6ff0be:	0f 85 03 11 00 00    	jne    7001c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1867>
  6ff0c4:	49 83 c5 04          	add    $0x4,%r13
  6ff0c8:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  6ff0cd:	0f 85 68 ff ff ff    	jne    6ff03b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x6db>
  6ff0d3:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  6ff0da:	00 00 
  6ff0dc:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6ff0e3:	48 85 ed             	test   %rbp,%rbp
  6ff0e6:	0f 84 f2 10 00 00    	je     7001de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x187e>
  6ff0ec:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6ff0f3:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6ff0fa:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  6ff101:	48 89 c7             	mov    %rax,%rdi
  6ff104:	48 89 e9             	mov    %rbp,%rcx
  6ff107:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  6ff10e:	00 
  6ff10f:	45 89 d3             	mov    %r10d,%r11d
  6ff112:	41 c1 e3 05          	shl    $0x5,%r11d
  6ff116:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  6ff11d:	45 31 c9             	xor    %r9d,%r9d
  6ff120:	4d 39 cb             	cmp    %r9,%r11
  6ff123:	74 28                	je     6ff14d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7ed>
  6ff125:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  6ff12c:	00 
  6ff12d:	41 0f 97 c4          	seta   %r12b
  6ff131:	41 80 dc 00          	sbb    $0x0,%r12b
  6ff135:	49 83 c1 20          	add    $0x20,%r9
  6ff139:	49 ff c0             	inc    %r8
  6ff13c:	41 80 fc 01          	cmp    $0x1,%r12b
  6ff140:	74 de                	je     6ff120 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7c0>
  6ff142:	45 0f b6 d4          	movzbl %r12b,%r10d
  6ff146:	45 85 d2             	test   %r10d,%r10d
  6ff149:	75 05                	jne    6ff150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7f0>
  6ff14b:	eb 1c                	jmp    6ff169 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x809>
  6ff14d:	4d 89 d0             	mov    %r10,%r8
  6ff150:	48 83 ef 01          	sub    $0x1,%rdi
  6ff154:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff159:	0f 82 92 00 00 00    	jb     6ff1f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x891>
  6ff15f:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  6ff166:	00 
  6ff167:	eb 9e                	jmp    6ff107 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7a7>
  6ff169:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  6ff16f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff174:	75 7b                	jne    6ff1f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x891>
  6ff176:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  6ff17b:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff182:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  6ff189:	4c 8d 05 a8 c3 3f 00 	lea    0x3fc3a8(%rip),%r8        # afb538 <__frame_dummy_init_array_entry+0xca0>
  6ff190:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff195:	4c 89 f9             	mov    %r15,%rcx
  6ff198:	45 31 c9             	xor    %r9d,%r9d
  6ff19b:	e8 10 65 05 00       	call   7556b0 <<gpui::source::Sources<unit_action_cost_two::Model>>::freeze>
  6ff1a0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6ff1a5:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  6ff1aa:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6ff1b1:	00 
  6ff1b2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6ff1b6:	0f 85 e6 00 00 00    	jne    6ff2a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x942>
  6ff1bc:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6ff1c3:	00 
  6ff1c4:	48 89 cd             	mov    %rcx,%rbp
  6ff1c7:	48 c1 ed 08          	shr    $0x8,%rbp
  6ff1cb:	b8 20 00 00 00       	mov    $0x20,%eax
  6ff1d0:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6ff1d5:	89 cf                	mov    %ecx,%edi
  6ff1d7:	e9 bb 12 00 00       	jmp    700497 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6ff1dc:	48 89 f9             	mov    %rdi,%rcx
  6ff1df:	48 83 e8 01          	sub    $0x1,%rax
  6ff1e3:	0f 82 f5 0f 00 00    	jb     7001de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x187e>
  6ff1e9:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  6ff1f0:	00 
  6ff1f1:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  6ff1f8:	41 89 f8             	mov    %edi,%r8d
  6ff1fb:	41 c1 e0 05          	shl    $0x5,%r8d
  6ff1ff:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  6ff206:	45 31 ed             	xor    %r13d,%r13d
  6ff209:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6ff210:	4d 39 e8             	cmp    %r13,%r8
  6ff213:	74 c7                	je     6ff1dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x87c>
  6ff215:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  6ff21c:	00 
  6ff21d:	41 0f 97 c1          	seta   %r9b
  6ff221:	41 80 d9 00          	sbb    $0x0,%r9b
  6ff225:	49 83 c5 20          	add    $0x20,%r13
  6ff229:	48 ff c1             	inc    %rcx
  6ff22c:	41 80 f9 01          	cmp    $0x1,%r9b
  6ff230:	74 de                	je     6ff210 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x8b0>
  6ff232:	41 0f b6 f9          	movzbl %r9b,%edi
  6ff236:	85 ff                	test   %edi,%edi
  6ff238:	75 a5                	jne    6ff1df <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x87f>
  6ff23a:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  6ff23f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6ff243:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff248:	74 41                	je     6ff28b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x92b>
  6ff24a:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff24f:	48 85 c0             	test   %rax,%rax
  6ff252:	0f 84 46 01 00 00    	je     6ff39e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa3e>
  6ff258:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff25d:	48 ff c8             	dec    %rax
  6ff260:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  6ff267:	ff ff 3f 
  6ff26a:	48 21 c7             	and    %rax,%rdi
  6ff26d:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  6ff271:	45 89 c8             	mov    %r9d,%r8d
  6ff274:	41 83 e0 03          	and    $0x3,%r8d
  6ff278:	48 83 ff 03          	cmp    $0x3,%rdi
  6ff27c:	0f 83 25 01 00 00    	jae    6ff3a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa47>
  6ff282:	31 c0                	xor    %eax,%eax
  6ff284:	31 ff                	xor    %edi,%edi
  6ff286:	e9 b0 01 00 00       	jmp    6ff43b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xadb>
  6ff28b:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff292:	4c 8d 05 9f c2 3f 00 	lea    0x3fc29f(%rip),%r8        # afb538 <__frame_dummy_init_array_entry+0xca0>
  6ff299:	31 c0                	xor    %eax,%eax
  6ff29b:	31 ff                	xor    %edi,%edi
  6ff29d:	e9 d4 01 00 00       	jmp    6ff476 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb16>
  6ff2a2:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6ff2a7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6ff2ac:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6ff2b3:	00 
  6ff2b4:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  6ff2bb:	00 
  6ff2bc:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6ff2c3:	00 
  6ff2c4:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  6ff2cb:	00 
  6ff2cc:	41 83 fd 02          	cmp    $0x2,%r13d
  6ff2d0:	0f 84 bc 13 00 00    	je     700692 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d32>
  6ff2d6:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  6ff2db:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  6ff2e2:	00 
  6ff2e3:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  6ff2e8:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  6ff2ef:	00 
  6ff2f0:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  6ff2f7:	00 
  6ff2f8:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ff2ff:	00 
  6ff300:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6ff305:	ba 06 00 00 00       	mov    $0x6,%edx
  6ff30a:	ff 15 f8 a1 42 00    	call   *0x42a1f8(%rip)        # b29508 <_DYNAMIC+0x408>
  6ff310:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  6ff317:	00 
  6ff318:	80 fa ff             	cmp    $0xff,%dl
  6ff31b:	0f 84 79 0e 00 00    	je     70019a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x183a>
  6ff321:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  6ff328:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  6ff32f:	00 
  6ff330:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  6ff337:	00 
  6ff338:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  6ff33f:	00 
  6ff340:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  6ff347:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  6ff34e:	80 fa 02             	cmp    $0x2,%dl
  6ff351:	0f 85 35 0f 00 00    	jne    70028c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x192c>
  6ff357:	89 ea                	mov    %ebp,%edx
  6ff359:	48 c1 e0 20          	shl    $0x20,%rax
  6ff35d:	48 09 c8             	or     %rcx,%rax
  6ff360:	48 c1 e8 08          	shr    $0x8,%rax
  6ff364:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  6ff36b:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  6ff372:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  6ff379:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  6ff380:	00 
  6ff381:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  6ff388:	00 
  6ff389:	41 80 be 1f 07 00 00 	cmpb   $0x0,0x71f(%r14)
  6ff390:	00 
  6ff391:	0f 84 0c 0f 00 00    	je     7002a3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1943>
  6ff397:	31 ed                	xor    %ebp,%ebp
  6ff399:	e9 24 0f 00 00       	jmp    7002c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1962>
  6ff39e:	31 ff                	xor    %edi,%edi
  6ff3a0:	31 c0                	xor    %eax,%eax
  6ff3a2:	e9 b5 00 00 00       	jmp    6ff45c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xafc>
  6ff3a7:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6ff3ac:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  6ff3b3:	00 00 80 
  6ff3b6:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6ff3ba:	49 21 c1             	and    %rax,%r9
  6ff3bd:	31 c0                	xor    %eax,%eax
  6ff3bf:	31 ff                	xor    %edi,%edi
  6ff3c1:	44 8b 11             	mov    (%rcx),%r10d
  6ff3c4:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  6ff3c8:	45 89 d4             	mov    %r10d,%r12d
  6ff3cb:	41 f7 d4             	not    %r12d
  6ff3ce:	41 f6 c4 03          	test   $0x3,%r12b
  6ff3d2:	41 0f 94 c4          	sete   %r12b
  6ff3d6:	45 89 c3             	mov    %r8d,%r11d
  6ff3d9:	41 f7 d3             	not    %r11d
  6ff3dc:	41 f6 c3 03          	test   $0x3,%r11b
  6ff3e0:	41 0f 94 c3          	sete   %r11b
  6ff3e4:	45 08 e3             	or     %r12b,%r11b
  6ff3e7:	8b 51 08             	mov    0x8(%rcx),%edx
  6ff3ea:	41 89 d4             	mov    %edx,%r12d
  6ff3ed:	41 f7 d4             	not    %r12d
  6ff3f0:	41 f6 c4 03          	test   $0x3,%r12b
  6ff3f4:	41 0f 94 c4          	sete   %r12b
  6ff3f8:	8b 71 0c             	mov    0xc(%rcx),%esi
  6ff3fb:	48 83 c1 10          	add    $0x10,%rcx
  6ff3ff:	21 f2                	and    %esi,%edx
  6ff401:	f7 d6                	not    %esi
  6ff403:	40 f6 c6 03          	test   $0x3,%sil
  6ff407:	40 0f 94 c6          	sete   %sil
  6ff40b:	44 08 e6             	or     %r12b,%sil
  6ff40e:	44 08 de             	or     %r11b,%sil
  6ff411:	40 08 f7             	or     %sil,%dil
  6ff414:	45 21 c2             	and    %r8d,%r10d
  6ff417:	41 21 d2             	and    %edx,%r10d
  6ff41a:	41 f7 d2             	not    %r10d
  6ff41d:	41 f6 c2 03          	test   $0x3,%r10b
  6ff421:	0f 95 c2             	setne  %dl
  6ff424:	08 d0                	or     %dl,%al
  6ff426:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  6ff42a:	75 95                	jne    6ff3c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa61>
  6ff42c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6ff431:	4d 85 c0             	test   %r8,%r8
  6ff434:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff439:	74 21                	je     6ff45c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xafc>
  6ff43b:	45 31 c9             	xor    %r9d,%r9d
  6ff43e:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  6ff442:	83 e2 03             	and    $0x3,%edx
  6ff445:	83 fa 03             	cmp    $0x3,%edx
  6ff448:	0f 95 c2             	setne  %dl
  6ff44b:	40 0f 94 c6          	sete   %sil
  6ff44f:	40 08 f7             	or     %sil,%dil
  6ff452:	08 d0                	or     %dl,%al
  6ff454:	49 ff c1             	inc    %r9
  6ff457:	4d 39 c8             	cmp    %r9,%r8
  6ff45a:	75 e2                	jne    6ff43e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xade>
  6ff45c:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6ff463:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  6ff468:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6ff46f:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6ff476:	40 0f b6 cf          	movzbl %dil,%ecx
  6ff47a:	83 e1 01             	and    $0x1,%ecx
  6ff47d:	89 0c 24             	mov    %ecx,(%rsp)
  6ff480:	44 0f b6 c8          	movzbl %al,%r9d
  6ff484:	41 83 e1 01          	and    $0x1,%r9d
  6ff488:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff48d:	4c 89 f9             	mov    %r15,%rcx
  6ff490:	e8 1b 62 05 00       	call   7556b0 <<gpui::source::Sources<unit_action_cost_two::Model>>::freeze>
  6ff495:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  6ff49a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6ff49f:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6ff4a6:	00 
  6ff4a7:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6ff4ae:	00 
  6ff4af:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6ff4b4:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  6ff4b9:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  6ff4bd:	75 1d                	jne    6ff4dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb7c>
  6ff4bf:	48 89 c5             	mov    %rax,%rbp
  6ff4c2:	48 c1 ed 08          	shr    $0x8,%rbp
  6ff4c6:	b9 20 00 00 00       	mov    $0x20,%ecx
  6ff4cb:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff4d0:	89 c7                	mov    %eax,%edi
  6ff4d2:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  6ff4d7:	e9 bb 0f 00 00       	jmp    700497 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6ff4dc:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6ff4e1:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6ff4e8:	00 
  6ff4e9:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6ff4f0:	00 
  6ff4f1:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6ff4f8:	00 00 
  6ff4fa:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  6ff501:	00 00 
  6ff503:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  6ff509:	0f 84 69 0c 00 00    	je     700178 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1818>
  6ff50f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff514:	48 85 c0             	test   %rax,%rax
  6ff517:	0f 84 5b 0c 00 00    	je     700178 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1818>
  6ff51d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6ff522:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff527:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6ff52c:	48 c1 e0 02          	shl    $0x2,%rax
  6ff530:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff535:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6ff539:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  6ff540:	00 
  6ff541:	45 31 e4             	xor    %r12d,%r12d
  6ff544:	48 83 f8 02          	cmp    $0x2,%rax
  6ff548:	0f 85 72 0b 00 00    	jne    7000c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1760>
  6ff54e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6ff553:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6ff557:	ff 15 a3 9f 42 00    	call   *0x429fa3(%rip)        # b29500 <_DYNAMIC+0x400>
  6ff55d:	66 85 c0             	test   %ax,%ax
  6ff560:	0f 85 ba 12 00 00    	jne    700820 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ec0>
  6ff566:	49 83 c4 04          	add    $0x4,%r12
  6ff56a:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6ff56f:	75 dd                	jne    6ff54e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xbee>
  6ff571:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6ff576:	48 85 c0             	test   %rax,%rax
  6ff579:	0f 84 dd 0d 00 00    	je     70035c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19fc>
  6ff57f:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6ff584:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  6ff58b:	00 
  6ff58c:	48 c1 e0 02          	shl    $0x2,%rax
  6ff590:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  6ff596:	66 0f 6f 0d b2 b2 95 	movdqa -0x6a4d4e(%rip),%xmm1        # 5a850 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9f0>
  6ff59d:	ff 
  6ff59e:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  6ff5a2:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  6ff5a9:	00 00 
  6ff5ab:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  6ff5b2:	00 00 00 00 00 
  6ff5b7:	48 8d 0d ba bf 3f 00 	lea    0x3fbfba(%rip),%rcx        # afb578 <__frame_dummy_init_array_entry+0xce0>
  6ff5be:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6ff5c3:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  6ff5ca:	00 00 80 
  6ff5cd:	48 ff c1             	inc    %rcx
  6ff5d0:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  6ff5d7:	00 
  6ff5d8:	48 8d 0d c5 b1 96 ff 	lea    -0x694e3b(%rip),%rcx        # 6a7a4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  6ff5df:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6ff5e6:	00 
  6ff5e7:	48 8d 0d 1a c0 3f 00 	lea    0x3fc01a(%rip),%rcx        # afb608 <__frame_dummy_init_array_entry+0xd70>
  6ff5ee:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6ff5f5:	00 
  6ff5f6:	48 8d 0d 93 bf 3f 00 	lea    0x3fbf93(%rip),%rcx        # afb590 <__frame_dummy_init_array_entry+0xcf8>
  6ff5fd:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  6ff604:	00 
  6ff605:	48 8d 0d 6f b1 96 ff 	lea    -0x694e91(%rip),%rcx        # 6a77b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  6ff60c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  6ff613:	00 
  6ff614:	48 8d 0d fd b3 3f 00 	lea    0x3fb3fd(%rip),%rcx        # afaa18 <__frame_dummy_init_array_entry+0x180>
  6ff61b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  6ff622:	00 
  6ff623:	31 c9                	xor    %ecx,%ecx
  6ff625:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  6ff62c:	00 00 00 00 00 
  6ff631:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  6ff638:	00 00 00 00 00 
  6ff63d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff644:	00 00 
  6ff646:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6ff64b:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6ff652:	00 
  6ff653:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  6ff658:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  6ff65b:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  6ff662:	89 e8                	mov    %ebp,%eax
  6ff664:	c1 e8 0f             	shr    $0xf,%eax
  6ff667:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6ff66e:	48 39 c6             	cmp    %rax,%rsi
  6ff671:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff676:	0f 86 7c 11 00 00    	jbe    7007f8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e98>
  6ff67c:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  6ff683:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  6ff687:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  6ff68b:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6ff690:	89 ef                	mov    %ebp,%edi
  6ff692:	ff 15 68 9e 42 00    	call   *0x429e68(%rip)        # b29500 <_DYNAMIC+0x400>
  6ff698:	89 44 24 08          	mov    %eax,0x8(%rsp)
  6ff69c:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  6ff6a0:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6ff6a7:	00 
  6ff6a8:	8b 54 24 08          	mov    0x8(%rsp),%edx
  6ff6ac:	66 85 d2             	test   %dx,%dx
  6ff6af:	0f 84 31 01 00 00    	je     6ff7e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xe86>
  6ff6b5:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  6ff6bc:	02 
  6ff6bd:	0f 84 6d 0f 00 00    	je     700630 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd0>
  6ff6c3:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6ff6c8:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6ff6cd:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6ff6d4:	00 
  6ff6d5:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6ff6da:	48 89 41 10          	mov    %rax,0x10(%rcx)
  6ff6de:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6ff6e5:	00 00 
  6ff6e7:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  6ff6eb:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ff6f2:	00 
  6ff6f3:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6ff6f8:	ff 15 0a 9e 42 00    	call   *0x429e0a(%rip)        # b29508 <_DYNAMIC+0x408>
  6ff6fe:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  6ff705:	00 
  6ff706:	3c ff                	cmp    $0xff,%al
  6ff708:	0f 84 10 0d 00 00    	je     70041e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1abe>
  6ff70e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  6ff715:	00 
  6ff716:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  6ff71d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  6ff724:	00 
  6ff725:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  6ff72c:	00 
  6ff72d:	41 8b 78 10          	mov    0x10(%r8),%edi
  6ff731:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  6ff738:	00 
  6ff739:	41 89 79 10          	mov    %edi,0x10(%r9)
  6ff73d:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  6ff742:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  6ff747:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  6ff74e:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  6ff755:	00 
  6ff756:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  6ff75d:	00 
  6ff75e:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  6ff765:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6ff769:	44 0f b7 e9          	movzwl %cx,%r13d
  6ff76d:	48 8d 05 c4 c1 3f 00 	lea    0x3fc1c4(%rip),%rax        # afb938 <__frame_dummy_init_array_entry+0x10a0>
  6ff774:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6ff779:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  6ff77d:	0f 84 c7 00 00 00    	je     6ff84a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xeea>
  6ff783:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff788:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  6ff78f:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6ff794:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  6ff79b:	00 
  6ff79c:	ff 15 6e 9d 42 00    	call   *0x429d6e(%rip)        # b29510 <_DYNAMIC+0x410>
  6ff7a2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6ff7a7:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6ff7ac:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6ff7b0:	0f 85 ab 0d 00 00    	jne    700561 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c01>
  6ff7b6:	40 80 ff 01          	cmp    $0x1,%dil
  6ff7ba:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff7bf:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ff7c4:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6ff7c9:	0f 85 9e 08 00 00    	jne    70006d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x170d>
  6ff7cf:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6ff7d6:	01 
  6ff7d7:	b0 01                	mov    $0x1,%al
  6ff7d9:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6ff7e0:	00 
  6ff7e1:	e9 4e 08 00 00       	jmp    700034 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ff7e6:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  6ff7ec:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff7f1:	0f 84 59 0e 00 00    	je     700650 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cf0>
  6ff7f7:	83 e5 03             	and    $0x3,%ebp
  6ff7fa:	8d 45 ff             	lea    -0x1(%rbp),%eax
  6ff7fd:	83 f8 02             	cmp    $0x2,%eax
  6ff800:	0f 83 8a 00 00 00    	jae    6ff890 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf30>
  6ff806:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6ff80d:	48 8b 38             	mov    (%rax),%rdi
  6ff810:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  6ff816:	48 85 ff             	test   %rdi,%rdi
  6ff819:	0f 84 19 0e 00 00    	je     700638 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd8>
  6ff81f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ff824:	ff 15 ee 9c 42 00    	call   *0x429cee(%rip)        # b29518 <_DYNAMIC+0x418>
  6ff82a:	48 85 c0             	test   %rax,%rax
  6ff82d:	0f 84 05 0e 00 00    	je     700638 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd8>
  6ff833:	83 fd 01             	cmp    $0x1,%ebp
  6ff836:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff83b:	0f 85 a6 00 00 00    	jne    6ff8e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf87>
  6ff841:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6ff845:	e9 a1 00 00 00       	jmp    6ff8eb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf8b>
  6ff84a:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  6ff851:	48 8b 00             	mov    (%rax),%rax
  6ff854:	48 8d 15 e5 ba 95 ff 	lea    -0x6a451b(%rip),%rdx        # 5b340 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x14e0>
  6ff85b:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  6ff85f:	48 01 d1             	add    %rdx,%rcx
  6ff862:	48 8d 05 a7 c2 95 ff 	lea    -0x6a3d59(%rip),%rax        # 5bb10 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  6ff869:	ff e1                	jmp    *%rcx
  6ff86b:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  6ff872:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6ff877:	48 39 c6             	cmp    %rax,%rsi
  6ff87a:	0f 86 3a 0f 00 00    	jbe    7007ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e5a>
  6ff880:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6ff884:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  6ff88b:	e9 4e 03 00 00       	jmp    6ffbde <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x127e>
  6ff890:	85 ed                	test   %ebp,%ebp
  6ff892:	0f 85 18 0e 00 00    	jne    7006b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d50>
  6ff898:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ff89f:	00 
  6ff8a0:	8b 40 20             	mov    0x20(%rax),%eax
  6ff8a3:	89 c1                	mov    %eax,%ecx
  6ff8a5:	83 e1 07             	and    $0x7,%ecx
  6ff8a8:	83 f9 06             	cmp    $0x6,%ecx
  6ff8ab:	74 74                	je     6ff921 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff8ad:	c1 e8 03             	shr    $0x3,%eax
  6ff8b0:	74 6f                	je     6ff921 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff8b2:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6ff8b9:	ff c8                	dec    %eax
  6ff8bb:	48 39 c6             	cmp    %rax,%rsi
  6ff8be:	0f 86 23 0f 00 00    	jbe    7007e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e87>
  6ff8c4:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  6ff8cb:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6ff8cf:	48 c1 e0 04          	shl    $0x4,%rax
  6ff8d3:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  6ff8d8:	0f 84 59 0e 00 00    	je     700737 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1dd7>
  6ff8de:	48 01 c1             	add    %rax,%rcx
  6ff8e1:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  6ff8e5:	eb 13                	jmp    6ff8fa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf9a>
  6ff8e7:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6ff8eb:	b0 01                	mov    $0x1,%al
  6ff8ed:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  6ff8f4:	00 
  6ff8f5:	48 85 ff             	test   %rdi,%rdi
  6ff8f8:	74 27                	je     6ff921 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff8fa:	48 8b 07             	mov    (%rdi),%rax
  6ff8fd:	48 d1 e8             	shr    $1,%rax
  6ff900:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6ff905:	48 39 d0             	cmp    %rdx,%rax
  6ff908:	75 17                	jne    6ff921 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6ff90a:	48 83 c7 10          	add    $0x10,%rdi
  6ff90e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6ff913:	ff 15 07 9c 42 00    	call   *0x429c07(%rip)        # b29520 <bcmp@GLIBC_2.2.5>
  6ff919:	85 c0                	test   %eax,%eax
  6ff91b:	0f 84 3a 06 00 00    	je     6fff5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x15fb>
  6ff921:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  6ff926:	4d 85 e4             	test   %r12,%r12
  6ff929:	75 6d                	jne    6ff998 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1038>
  6ff92b:	4c 8d 25 4e b7 95 ff 	lea    -0x6a48b2(%rip),%r12        # 5b080 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1220>
  6ff932:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6ff937:	48 85 f6             	test   %rsi,%rsi
  6ff93a:	74 41                	je     6ff97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x101d>
  6ff93c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff943:	00 00 
  6ff945:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6ff94a:	31 d2                	xor    %edx,%edx
  6ff94c:	31 c9                	xor    %ecx,%ecx
  6ff94e:	ff 15 d4 9b 42 00    	call   *0x429bd4(%rip)        # b29528 <_DYNAMIC+0x428>
  6ff954:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6ff959:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  6ff95d:	0f 85 6e 0e 00 00    	jne    7007d1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e71>
  6ff963:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  6ff968:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  6ff96d:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6ff972:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6ff977:	ff 15 eb 99 42 00    	call   *0x4299eb(%rip)        # b29368 <memcpy@GLIBC_2.14>
  6ff97d:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  6ff984:	00 00 
  6ff986:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  6ff98d:	00 00 
  6ff98f:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  6ff996:	00 00 
  6ff998:	85 ed                	test   %ebp,%ebp
  6ff99a:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  6ff99f:	0f 84 b1 00 00 00    	je     6ffa56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10f6>
  6ff9a5:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6ff9ac:	48 8b 38             	mov    (%rax),%rdi
  6ff9af:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  6ff9b5:	48 85 ff             	test   %rdi,%rdi
  6ff9b8:	0f 84 2e 0d 00 00    	je     7006ec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d8c>
  6ff9be:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ff9c3:	ff 15 67 9b 42 00    	call   *0x429b67(%rip)        # b29530 <_DYNAMIC+0x430>
  6ff9c9:	48 85 c0             	test   %rax,%rax
  6ff9cc:	0f 84 1a 0d 00 00    	je     7006ec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d8c>
  6ff9d2:	83 fd 01             	cmp    $0x1,%ebp
  6ff9d5:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff9da:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6ff9df:	0f 85 4d 01 00 00    	jne    6ffb32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11d2>
  6ff9e5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6ff9ea:	48 85 c9             	test   %rcx,%rcx
  6ff9ed:	74 2c                	je     6ffa1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ff9ef:	f6 01 01             	testb  $0x1,(%rcx)
  6ff9f2:	75 27                	jne    6ffa1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ff9f4:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6ff9f8:	f6 c2 01             	test   $0x1,%dl
  6ff9fb:	75 1e                	jne    6ffa1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ff9fd:	ba 02 00 00 00       	mov    $0x2,%edx
  6ffa02:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6ffa08:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6ffa0f:	00 
  6ffa10:	48 f7 da             	neg    %rdx
  6ffa13:	71 06                	jno    6ffa1b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6ffa15:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6ffa1b:	48 89 c5             	mov    %rax,%rbp
  6ffa1e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6ffa22:	48 85 ff             	test   %rdi,%rdi
  6ffa25:	74 1c                	je     6ffa43 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ffa27:	f6 07 01             	testb  $0x1,(%rdi)
  6ffa2a:	75 17                	jne    6ffa43 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ffa2c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffa30:	a8 01                	test   $0x1,%al
  6ffa32:	75 0f                	jne    6ffa43 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6ffa34:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ffa38:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ffa3d:	0f 84 50 06 00 00    	je     700093 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1733>
  6ffa43:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ffa48:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6ffa4c:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ffa51:	e9 de 05 00 00       	jmp    700034 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ffa56:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6ffa5d:	00 
  6ffa5e:	8b 78 20             	mov    0x20(%rax),%edi
  6ffa61:	89 f8                	mov    %edi,%eax
  6ffa63:	83 e0 07             	and    $0x7,%eax
  6ffa66:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  6ffa6c:	83 f8 06             	cmp    $0x6,%eax
  6ffa6f:	0f 84 59 0c 00 00    	je     7006ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d6e>
  6ffa75:	c1 ef 03             	shr    $0x3,%edi
  6ffa78:	0f 84 50 0c 00 00    	je     7006ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d6e>
  6ffa7e:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6ffa85:	ff cf                	dec    %edi
  6ffa87:	48 39 fe             	cmp    %rdi,%rsi
  6ffa8a:	0f 86 01 0d 00 00    	jbe    700791 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e31>
  6ffa90:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6ffa97:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6ffa9b:	48 c1 e0 04          	shl    $0x4,%rax
  6ffa9f:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6ffaa5:	0f 84 5f 0c 00 00    	je     70070a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1daa>
  6ffaab:	4d 85 e4             	test   %r12,%r12
  6ffaae:	0f 84 68 0c 00 00    	je     70071c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1dbc>
  6ffab4:	41 f6 04 24 01       	testb  $0x1,(%r12)
  6ffab9:	75 2a                	jne    6ffae5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffabb:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  6ffac0:	f6 c1 01             	test   $0x1,%cl
  6ffac3:	75 20                	jne    6ffae5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffac5:	b9 02 00 00 00       	mov    $0x2,%ecx
  6ffaca:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  6ffad1:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  6ffad8:	00 
  6ffad9:	48 f7 d9             	neg    %rcx
  6ffadc:	71 07                	jno    6ffae5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6ffade:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  6ffae5:	48 01 c5             	add    %rax,%rbp
  6ffae8:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  6ffaec:	f6 07 01             	testb  $0x1,(%rdi)
  6ffaef:	75 17                	jne    6ffb08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6ffaf1:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffaf5:	a8 01                	test   $0x1,%al
  6ffaf7:	75 0f                	jne    6ffb08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6ffaf9:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ffafd:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ffb02:	0f 84 7c 05 00 00    	je     700084 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1724>
  6ffb08:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6ffb0c:	48 89 ef             	mov    %rbp,%rdi
  6ffb0f:	e8 ac 4e ff ff       	call   6f49c0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6ffb14:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6ffb1b:	ff 
  6ffb1c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6ffb23:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6ffb28:	e8 e3 59 04 00       	call   745510 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6ffb2d:	e9 e1 04 00 00       	jmp    700013 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16b3>
  6ffb32:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6ffb37:	48 85 c9             	test   %rcx,%rcx
  6ffb3a:	74 2c                	je     6ffb68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffb3c:	f6 01 01             	testb  $0x1,(%rcx)
  6ffb3f:	75 27                	jne    6ffb68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffb41:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6ffb45:	f6 c2 01             	test   $0x1,%dl
  6ffb48:	75 1e                	jne    6ffb68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffb4a:	ba 02 00 00 00       	mov    $0x2,%edx
  6ffb4f:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6ffb55:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6ffb5c:	00 
  6ffb5d:	48 f7 da             	neg    %rdx
  6ffb60:	71 06                	jno    6ffb68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6ffb62:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6ffb68:	48 89 c5             	mov    %rax,%rbp
  6ffb6b:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6ffb6f:	48 85 ff             	test   %rdi,%rdi
  6ffb72:	74 1c                	je     6ffb90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffb74:	f6 07 01             	testb  $0x1,(%rdi)
  6ffb77:	75 17                	jne    6ffb90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffb79:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ffb7d:	a8 01                	test   $0x1,%al
  6ffb7f:	75 0f                	jne    6ffb90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6ffb81:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6ffb85:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ffb8a:	0f 84 12 05 00 00    	je     7000a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1742>
  6ffb90:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ffb95:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6ffb99:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6ffb9e:	e9 91 04 00 00       	jmp    700034 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6ffba3:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  6ffbaa:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6ffbaf:	48 39 ce             	cmp    %rcx,%rsi
  6ffbb2:	0f 86 eb 0b 00 00    	jbe    7007a3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e43>
  6ffbb8:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  6ffbbf:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  6ffbc6:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  6ffbca:	48 39 c6             	cmp    %rax,%rsi
  6ffbcd:	0f 86 d9 0b 00 00    	jbe    7007ac <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e4c>
  6ffbd3:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6ffbd7:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  6ffbde:	48 8b 48 50          	mov    0x50(%rax),%rcx
  6ffbe2:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  6ffbe9:	00 
  6ffbea:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  6ffbee:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  6ffbf5:	00 
  6ffbf6:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  6ffbfa:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  6ffbff:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  6ffc03:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  6ffc07:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  6ffc0e:	00 
  6ffc0f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  6ffc16:	00 
  6ffc17:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  6ffc1e:	00 00 
  6ffc20:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  6ffc27:	00 00 
  6ffc29:	eb 1a                	jmp    6ffc45 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x12e5>
  6ffc2b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  6ffc32:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  6ffc39:	00 
  6ffc3a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6ffc3f:	ff 15 f3 97 42 00    	call   *0x4297f3(%rip)        # b29438 <_DYNAMIC+0x338>
  6ffc45:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  6ffc4c:	00 
  6ffc4d:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  6ffc54:	00 
  6ffc55:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  6ffc5c:	00 
  6ffc5d:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  6ffc64:	00 
  6ffc65:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  6ffc6c:	00 00 
  6ffc6e:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  6ffc75:	00 00 
  6ffc77:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  6ffc7e:	00 
  6ffc7f:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  6ffc86:	00 
  6ffc87:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  6ffc8e:	00 
  6ffc8f:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  6ffc96:	00 
  6ffc97:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  6ffc9e:	00 00 
  6ffca0:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  6ffca6:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ffcad:	00 
  6ffcae:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  6ffcb5:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6ffcba:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  6ffcbf:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6ffcc4:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  6ffccb:	00 
  6ffccc:	e8 2f f0 06 00       	call   76ed00 <<gpui::property::Overrides>::update_base>
  6ffcd1:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  6ffcd8:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  6ffcdf:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  6ffce6:	00 
  6ffce7:	48 c1 e5 20          	shl    $0x20,%rbp
  6ffceb:	48 09 cd             	or     %rcx,%rbp
  6ffcee:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  6ffcf5:	00 
  6ffcf6:	83 f8 02             	cmp    $0x2,%eax
  6ffcf9:	0f 84 ba 08 00 00    	je     7005b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c59>
  6ffcff:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  6ffd06:	00 
  6ffd07:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  6ffd0b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  6ffd12:	00 
  6ffd13:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  6ffd17:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  6ffd1b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  6ffd1f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  6ffd23:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  6ffd27:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  6ffd2b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  6ffd2f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6ffd33:	0f 11 02             	movups %xmm0,(%rdx)
  6ffd36:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  6ffd3d:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  6ffd44:	00 
  6ffd45:	48 89 e8             	mov    %rbp,%rax
  6ffd48:	48 c1 e8 20          	shr    $0x20,%rax
  6ffd4c:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  6ffd53:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  6ffd5a:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  6ffd61:	00 00 
  6ffd63:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  6ffd6a:	00 00 
  6ffd6c:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  6ffd73:	00 
  6ffd74:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  6ffd7b:	00 
  6ffd7c:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  6ffd83:	00 00 
  6ffd85:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  6ffd8c:	00 00 
  6ffd8e:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  6ffd95:	00 
  6ffd96:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  6ffd9d:	00 
  6ffd9e:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  6ffda5:	00 
  6ffda6:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  6ffdad:	00 
  6ffdae:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  6ffdb5:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  6ffdbc:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  6ffdc3:	00 
  6ffdc4:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  6ffdcb:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  6ffdd2:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  6ffdd9:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  6ffde0:	00 
  6ffde1:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  6ffde8:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  6ffdef:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  6ffdf6:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  6ffdfd:	00 
  6ffdfe:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  6ffe05:	00 
  6ffe06:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  6ffe0d:	00 
  6ffe0e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  6ffe15:	01 
  6ffe16:	75 1a                	jne    6ffe32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x14d2>
  6ffe18:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  6ffe1f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  6ffe26:	0f 94 c1             	sete   %cl
  6ffe29:	84 c8                	test   %cl,%al
  6ffe2b:	75 0d                	jne    6ffe3a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x14da>
  6ffe2d:	e9 38 01 00 00       	jmp    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe32:	a8 01                	test   $0x1,%al
  6ffe34:	0f 85 30 01 00 00    	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe3a:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  6ffe41:	00 
  6ffe42:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  6ffe49:	01 
  6ffe4a:	75 1b                	jne    6ffe67 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1507>
  6ffe4c:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  6ffe53:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  6ffe5a:	0f 94 c1             	sete   %cl
  6ffe5d:	84 c8                	test   %cl,%al
  6ffe5f:	0f 84 05 01 00 00    	je     6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe65:	eb 08                	jmp    6ffe6f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x150f>
  6ffe67:	a8 01                	test   $0x1,%al
  6ffe69:	0f 85 fb 00 00 00    	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe6f:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  6ffe76:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  6ffe7d:	0f 85 e7 00 00 00    	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe83:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  6ffe8a:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  6ffe91:	0f 85 d3 00 00 00    	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffe97:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  6ffe9e:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  6ffea5:	0f 85 bf 00 00 00    	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffeab:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  6ffeb2:	00 
  6ffeb3:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  6ffeba:	0f 85 aa 00 00 00    	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffec0:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  6ffec7:	00 
  6ffec8:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  6ffecf:	0f 85 95 00 00 00    	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffed5:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  6ffedc:	00 
  6ffedd:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  6ffee4:	0f 85 80 00 00 00    	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffeea:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  6ffef1:	00 
  6ffef2:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  6ffef9:	75 6f                	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6ffefb:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  6fff02:	00 
  6fff03:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  6fff0a:	00 
  6fff0b:	e8 a0 bf 02 00       	call   72beb0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  6fff10:	84 c0                	test   %al,%al
  6fff12:	74 56                	je     6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff14:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  6fff1b:	00 00 
  6fff1d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  6fff24:	00 00 
  6fff26:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fff2a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fff2e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fff33:	75 35                	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff35:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  6fff3c:	00 00 
  6fff3e:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  6fff45:	00 00 
  6fff47:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6fff4b:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6fff4f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6fff54:	75 14                	jne    6fff6a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fff56:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fff5b:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fff60:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fff65:	e9 08 01 00 00       	jmp    700072 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1712>
  6fff6a:	48 8d 05 c7 b9 3f 00 	lea    0x3fb9c7(%rip),%rax        # afb938 <__frame_dummy_init_array_entry+0x10a0>
  6fff71:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fff76:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  6fff7a:	75 11                	jne    6fff8d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x162d>
  6fff7c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fff83:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fff88:	e8 83 55 04 00       	call   745510 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fff8d:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  6fff93:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  6fff98:	75 5a                	jne    6ffff4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fff9a:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fffa1:	00 
  6fffa2:	8b 40 20             	mov    0x20(%rax),%eax
  6fffa5:	89 c1                	mov    %eax,%ecx
  6fffa7:	83 e1 07             	and    $0x7,%ecx
  6fffaa:	83 f9 06             	cmp    $0x6,%ecx
  6fffad:	74 45                	je     6ffff4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fffaf:	c1 e8 03             	shr    $0x3,%eax
  6fffb2:	74 40                	je     6ffff4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fffb4:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fffbb:	ff c8                	dec    %eax
  6fffbd:	48 39 c6             	cmp    %rax,%rsi
  6fffc0:	0f 86 fd 07 00 00    	jbe    7007c3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e63>
  6fffc6:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fffcd:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fffd1:	48 c1 e0 04          	shl    $0x4,%rax
  6fffd5:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fffdb:	0f 84 65 07 00 00    	je     700746 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1de6>
  6fffe1:	48 01 c5             	add    %rax,%rbp
  6fffe4:	48 89 ef             	mov    %rbp,%rdi
  6fffe7:	e8 d4 49 ff ff       	call   6f49c0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fffec:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6ffff3:	ff 
  6ffff4:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  6ffffb:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  700002:	4c 89 e6             	mov    %r12,%rsi
  700005:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  70000c:	00 
  70000d:	ff 15 25 95 42 00    	call   *0x429525(%rip)        # b29538 <_DYNAMIC+0x438>
  700013:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70001a:	01 
  70001b:	b0 01                	mov    $0x1,%al
  70001d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  700024:	00 
  700025:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70002a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70002f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  700034:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  70003b:	00 
  70003c:	0f 94 c0             	sete   %al
  70003f:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  700046:	74 0c                	je     700054 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16f4>
  700048:	b0 01                	mov    $0x1,%al
  70004a:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  700051:	00 
  700052:	eb 19                	jmp    70006d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x170d>
  700054:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  70005b:	b0 01                	mov    $0x1,%al
  70005d:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  700064:	00 
  700065:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  70006c:	00 
  70006d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  700072:	48 83 c1 04          	add    $0x4,%rcx
  700076:	48 39 c8             	cmp    %rcx,%rax
  700079:	0f 85 cc f5 ff ff    	jne    6ff64b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xceb>
  70007f:	e9 ee 02 00 00       	jmp    700372 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a12>
  700084:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700088:	ff 15 f2 92 42 00    	call   *0x4292f2(%rip)        # b29380 <_DYNAMIC+0x280>
  70008e:	e9 75 fa ff ff       	jmp    6ffb08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  700093:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700097:	ff 15 e3 92 42 00    	call   *0x4292e3(%rip)        # b29380 <_DYNAMIC+0x280>
  70009d:	e9 a1 f9 ff ff       	jmp    6ffa43 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  7000a2:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7000a6:	ff 15 d4 92 42 00    	call   *0x4292d4(%rip)        # b29380 <_DYNAMIC+0x280>
  7000ac:	e9 df fa ff ff       	jmp    6ffb90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  7000b1:	49 83 c4 04          	add    $0x4,%r12
  7000b5:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  7000ba:	0f 84 b1 f4 ff ff    	je     6ff571 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xc11>
  7000c0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7000c5:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  7000c9:	ff 15 31 94 42 00    	call   *0x429431(%rip)        # b29500 <_DYNAMIC+0x400>
  7000cf:	66 85 c0             	test   %ax,%ax
  7000d2:	74 dd                	je     7000b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1751>
  7000d4:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7000d9:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  7000de:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  7000e5:	00 
  7000e6:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  7000eb:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  7000ef:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  7000f6:	00 00 
  7000f8:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  7000fc:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  700103:	00 
  700104:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  700109:	89 c2                	mov    %eax,%edx
  70010b:	ff 15 f7 93 42 00    	call   *0x4293f7(%rip)        # b29508 <_DYNAMIC+0x408>
  700111:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  700118:	ff 
  700119:	75 96                	jne    7000b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1751>
  70011b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  700122:	00 
  700123:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70012a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  700131:	00 
  700132:	48 c1 e5 20          	shl    $0x20,%rbp
  700136:	48 09 c5             	or     %rax,%rbp
  700139:	b8 24 00 00 00       	mov    $0x24,%eax
  70013e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700143:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  700148:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  70014d:	48 85 f6             	test   %rsi,%rsi
  700150:	0f 8e 12 02 00 00    	jle    700368 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a08>
  700156:	ba 01 00 00 00       	mov    $0x1,%edx
  70015b:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  70015f:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  700164:	ff 15 de 91 42 00    	call   *0x4291de(%rip)        # b29348 <_DYNAMIC+0x248>
  70016a:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  70016e:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  700173:	e9 1f 03 00 00       	jmp    700497 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  700178:	31 ff                	xor    %edi,%edi
  70017a:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  70017f:	48 85 f6             	test   %rsi,%rsi
  700182:	7e 5c                	jle    7001e0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  700184:	ba 01 00 00 00       	mov    $0x1,%edx
  700189:	89 fd                	mov    %edi,%ebp
  70018b:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  700190:	ff 15 b2 91 42 00    	call   *0x4291b2(%rip)        # b29348 <_DYNAMIC+0x248>
  700196:	89 ef                	mov    %ebp,%edi
  700198:	eb 46                	jmp    7001e0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  70019a:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  7001a1:	00 
  7001a2:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  7001a9:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  7001b0:	00 
  7001b1:	48 c1 e5 20          	shl    $0x20,%rbp
  7001b5:	48 09 c5             	or     %rax,%rbp
  7001b8:	b8 24 00 00 00       	mov    $0x24,%eax
  7001bd:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7001c2:	e9 99 02 00 00       	jmp    700460 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  7001c7:	b0 01                	mov    $0x1,%al
  7001c9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7001ce:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  7001d5:	48 85 ed             	test   %rbp,%rbp
  7001d8:	0f 85 0e ef ff ff    	jne    6ff0ec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x78c>
  7001de:	31 ff                	xor    %edi,%edi
  7001e0:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  7001e5:	74 3c                	je     700223 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18c3>
  7001e7:	41 80 be 1f 07 00 00 	cmpb   $0x1,0x71f(%r14)
  7001ee:	01 
  7001ef:	75 32                	jne    700223 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18c3>
  7001f1:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  7001f6:	4c 89 f6             	mov    %r14,%rsi
  7001f9:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  700200:	00 
  700201:	31 c9                	xor    %ecx,%ecx
  700203:	e8 c8 d7 ff ff       	call   6fd9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  700208:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  70020d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  700211:	75 1e                	jne    700231 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18d1>
  700213:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70021a:	ff ff 
  70021c:	31 ff                	xor    %edi,%edi
  70021e:	e9 94 02 00 00       	jmp    7004b7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  700223:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70022a:	ff ff 
  70022c:	e9 86 02 00 00       	jmp    7004b7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  700231:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  700236:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  70023b:	c1 e1 10             	shl    $0x10,%ecx
  70023e:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  700243:	09 ca                	or     %ecx,%edx
  700245:	48 c1 e2 20          	shl    $0x20,%rdx
  700249:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  70024d:	48 09 d5             	or     %rdx,%rbp
  700250:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  700257:	00 
  700258:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  70025f:	00 
  700260:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  700267:	00 00 
  700269:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  700270:	00 00 
  700272:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  700279:	00 
  70027a:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  700281:	00 
  700282:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700287:	e9 2b 02 00 00       	jmp    7004b7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  70028c:	b8 20 00 00 00       	mov    $0x20,%eax
  700291:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700296:	40 b7 0c             	mov    $0xc,%dil
  700299:	31 ed                	xor    %ebp,%ebp
  70029b:	4d 89 f8             	mov    %r15,%r8
  70029e:	e9 bd 01 00 00       	jmp    700460 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  7002a3:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  7002aa:	48 8d 48 01          	lea    0x1(%rax),%rcx
  7002ae:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  7002b5:	40 0f 94 c5          	sete   %bpl
  7002b9:	48 ff c0             	inc    %rax
  7002bc:	0f 84 d5 f0 ff ff    	je     6ff397 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa37>
  7002c2:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  7002c9:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  7002d0:	00 
  7002d1:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  7002d8:	00 
  7002d9:	ff 15 61 92 42 00    	call   *0x429261(%rip)        # b29540 <_DYNAMIC+0x440>
  7002df:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  7002e6:	00 
  7002e7:	74 21                	je     70030a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19aa>
  7002e9:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  7002f0:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  7002f7:	40 84 ed             	test   %bpl,%bpl
  7002fa:	0f 84 48 01 00 00    	je     700448 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae8>
  700300:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  700307:	00 
  700308:	eb 16                	jmp    700320 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19c0>
  70030a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  700311:	00 00 00 00 
  700315:	31 d2                	xor    %edx,%edx
  700317:	40 84 ed             	test   %bpl,%bpl
  70031a:	0f 84 28 01 00 00    	je     700448 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae8>
  700320:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  700325:	4c 89 f6             	mov    %r14,%rsi
  700328:	e8 e3 0a 00 00       	call   700e10 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::finish_color_slot>
  70032d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  700332:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  700337:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70033b:	0f 85 8c 00 00 00    	jne    7003cd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a6d>
  700341:	40 f6 c7 01          	test   $0x1,%dil
  700345:	0f 84 f6 00 00 00    	je     700441 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae1>
  70034b:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  700352:	ff ff 
  700354:	40 b7 02             	mov    $0x2,%dil
  700357:	e9 04 01 00 00       	jmp    700460 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  70035c:	31 ff                	xor    %edi,%edi
  70035e:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  700363:	e9 12 fe ff ff       	jmp    70017a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  700368:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  70036d:	e9 25 01 00 00       	jmp    700497 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  700372:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  700379:	00 
  70037a:	34 01                	xor    $0x1,%al
  70037c:	0f b6 c0             	movzbl %al,%eax
  70037f:	31 ff                	xor    %edi,%edi
  700381:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  700388:	01 
  700389:	0f 45 f8             	cmovne %eax,%edi
  70038c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  700391:	48 85 c0             	test   %rax,%rax
  700394:	0f 84 e0 fd ff ff    	je     70017a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  70039a:	f6 00 01             	testb  $0x1,(%rax)
  70039d:	0f 85 d7 fd ff ff    	jne    70017a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  7003a3:	89 fd                	mov    %edi,%ebp
  7003a5:	48 8b 40 08          	mov    0x8(%rax),%rax
  7003a9:	a8 01                	test   $0x1,%al
  7003ab:	75 14                	jne    7003c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a61>
  7003ad:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7003b2:	48 83 c0 08          	add    $0x8,%rax
  7003b6:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  7003bb:	0f 84 b5 03 00 00    	je     700776 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e16>
  7003c1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7003c6:	89 ef                	mov    %ebp,%edi
  7003c8:	e9 ad fd ff ff       	jmp    70017a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  7003cd:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7003d2:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  7003d7:	c1 e0 10             	shl    $0x10,%eax
  7003da:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  7003df:	09 c1                	or     %eax,%ecx
  7003e1:	48 c1 e1 20          	shl    $0x20,%rcx
  7003e5:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  7003e9:	48 09 cd             	or     %rcx,%rbp
  7003ec:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  7003f3:	00 
  7003f4:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  7003fb:	00 
  7003fc:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  700403:	00 
  700404:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  70040b:	00 
  70040c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  700413:	00 
  700414:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  70041b:	00 
  70041c:	eb 42                	jmp    700460 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  70041e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  700425:	00 
  700426:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70042d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  700434:	00 
  700435:	48 c1 e5 20          	shl    $0x20,%rbp
  700439:	48 09 c5             	or     %rax,%rbp
  70043c:	e9 85 01 00 00       	jmp    7005c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c66>
  700441:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  700448:	48 85 d2             	test   %rdx,%rdx
  70044b:	0f 95 c0             	setne  %al
  70044e:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  700455:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70045c:	ff ff 
  70045e:	31 ff                	xor    %edi,%edi
  700460:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  700465:	48 85 f6             	test   %rsi,%rsi
  700468:	7e 22                	jle    70048c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b2c>
  70046a:	ba 01 00 00 00       	mov    $0x1,%edx
  70046f:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  700474:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  700478:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70047d:	ff 15 c5 8e 42 00    	call   *0x428ec5(%rip)        # b29348 <_DYNAMIC+0x248>
  700483:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  700487:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  70048c:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  700491:	0f 84 49 fd ff ff    	je     7001e0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  700497:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  70049e:	00 
  70049f:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  7004a6:	00 
  7004a7:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  7004ae:	00 
  7004af:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  7004b6:	00 
  7004b7:	40 0f b6 c7          	movzbl %dil,%eax
  7004bb:	48 c1 e5 08          	shl    $0x8,%rbp
  7004bf:	48 09 c5             	or     %rax,%rbp
  7004c2:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  7004c9:	00 
  7004ca:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  7004d1:	00 
  7004d2:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  7004d9:	00 00 
  7004db:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  7004e2:	00 00 
  7004e4:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7004e9:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  7004f0:	00 
  7004f1:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  7004f8:	00 
  7004f9:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  700500:	00 
  700501:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  700508:	00 
  700509:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  700510:	00 00 
  700512:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  700519:	00 
  70051a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  700521:	00 
  700522:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  700529:	00 
  70052a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  700531:	00 
  700532:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  700539:	00 
  70053a:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  700541:	00 
  700542:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  700549:	00 
  70054a:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  700551:	00 
  700552:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  700559:	00 
  70055a:	31 ed                	xor    %ebp,%ebp
  70055c:	e9 41 e6 ff ff       	jmp    6feba2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x242>
  700561:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  700566:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  70056b:	c1 e0 10             	shl    $0x10,%eax
  70056e:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  700573:	09 c1                	or     %eax,%ecx
  700575:	48 c1 e1 20          	shl    $0x20,%rcx
  700579:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  70057d:	48 09 cd             	or     %rcx,%rbp
  700580:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  700587:	00 
  700588:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  70058d:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  700594:	00 
  700595:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  70059c:	00 00 
  70059e:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  7005a5:	00 00 
  7005a7:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  7005ae:	00 
  7005af:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  7005b6:	00 
  7005b7:	eb 17                	jmp    7005d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c70>
  7005b9:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  7005c0:	00 00 00 
  7005c3:	48 21 c5             	and    %rax,%rbp
  7005c6:	b8 24 00 00 00       	mov    $0x24,%eax
  7005cb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7005d0:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  7005d5:	48 85 c9             	test   %rcx,%rcx
  7005d8:	0f 84 65 fb ff ff    	je     700143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  7005de:	f6 01 01             	testb  $0x1,(%rcx)
  7005e1:	0f 85 5c fb ff ff    	jne    700143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  7005e7:	48 8b 41 08          	mov    0x8(%rcx),%rax
  7005eb:	a8 01                	test   $0x1,%al
  7005ed:	0f 85 50 fb ff ff    	jne    700143 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  7005f3:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  7005f7:	48 8d 41 08          	lea    0x8(%rcx),%rax
  7005fb:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  700600:	0f 84 53 01 00 00    	je     700759 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1df9>
  700606:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70060b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  70060f:	e9 34 fb ff ff       	jmp    700148 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e8>
  700614:	48 8d 3d 3d a7 3f 00 	lea    0x3fa73d(%rip),%rdi        # afad58 <__frame_dummy_init_array_entry+0x4c0>
  70061b:	ff 15 e7 8d 42 00    	call   *0x428de7(%rip)        # b29408 <_DYNAMIC+0x308>
  700621:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700625:	ff 15 55 8d 42 00    	call   *0x428d55(%rip)        # b29380 <_DYNAMIC+0x280>
  70062b:	e9 c0 e6 ff ff       	jmp    6fecf0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  700630:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  700636:	eb 3c                	jmp    700674 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d14>
  700638:	48 8d 05 65 a1 96 ff 	lea    -0x695e9b(%rip),%rax        # 6a7a4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34c7>
  70063f:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  700646:	00 
  700647:	48 8d 05 72 af 3f 00 	lea    0x3faf72(%rip),%rax        # afb5c0 <__frame_dummy_init_array_entry+0xd28>
  70064e:	eb 1c                	jmp    70066c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d0c>
  700650:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  700656:	48 8d 05 33 a1 96 ff 	lea    -0x695ecd(%rip),%rax        # 6a790 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b3>
  70065d:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  700664:	00 
  700665:	48 8d 05 3c af 3f 00 	lea    0x3faf3c(%rip),%rax        # afb5a8 <__frame_dummy_init_array_entry+0xd10>
  70066c:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  700673:	00 
  700674:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  70067b:	00 
  70067c:	4c 89 e6             	mov    %r12,%rsi
  70067f:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  700686:	00 
  700687:	ff 15 bb 8d 42 00    	call   *0x428dbb(%rip)        # b29448 <_DYNAMIC+0x348>
  70068d:	e9 a7 01 00 00       	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700692:	48 8d 3d cf a0 96 ff 	lea    -0x695f31(%rip),%rdi        # 6a768 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348b>
  700699:	48 8d 15 a8 ae 3f 00 	lea    0x3faea8(%rip),%rdx        # afb548 <__frame_dummy_init_array_entry+0xcb0>
  7006a0:	be 13 00 00 00       	mov    $0x13,%esi
  7006a5:	ff 15 9d 8d 42 00    	call   *0x428d9d(%rip)        # b29448 <_DYNAMIC+0x348>
  7006ab:	e9 89 01 00 00       	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  7006b0:	48 8d 3d 2e a1 96 ff 	lea    -0x695ed2(%rip),%rdi        # 6a7e5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3508>
  7006b7:	48 8d 15 62 af 3f 00 	lea    0x3faf62(%rip),%rdx        # afb620 <__frame_dummy_init_array_entry+0xd88>
  7006be:	be 93 00 00 00       	mov    $0x93,%esi
  7006c3:	ff 15 7f 8e 42 00    	call   *0x428e7f(%rip)        # b29548 <_DYNAMIC+0x448>
  7006c9:	e9 6b 01 00 00       	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  7006ce:	48 8d 05 fa a0 96 ff 	lea    -0x695f06(%rip),%rax        # 6a7cf <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34f2>
  7006d5:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  7006dc:	00 
  7006dd:	48 8d 05 f4 ae 3f 00 	lea    0x3faef4(%rip),%rax        # afb5d8 <__frame_dummy_init_array_entry+0xd40>
  7006e4:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  7006eb:	00 
  7006ec:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  7006f3:	00 
  7006f4:	4c 89 ee             	mov    %r13,%rsi
  7006f7:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  7006fe:	00 
  7006ff:	ff 15 43 8d 42 00    	call   *0x428d43(%rip)        # b29448 <_DYNAMIC+0x348>
  700705:	e9 2f 01 00 00       	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70070a:	48 8d 3d 07 a3 3f 00 	lea    0x3fa307(%rip),%rdi        # afaa18 <__frame_dummy_init_array_entry+0x180>
  700711:	ff 15 f1 8c 42 00    	call   *0x428cf1(%rip)        # b29408 <_DYNAMIC+0x308>
  700717:	e9 1d 01 00 00       	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70071c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  700723:	00 00 
  700725:	48 8d 3d c4 ae 3f 00 	lea    0x3faec4(%rip),%rdi        # afb5f0 <__frame_dummy_init_array_entry+0xd58>
  70072c:	ff 15 d6 8c 42 00    	call   *0x428cd6(%rip)        # b29408 <_DYNAMIC+0x308>
  700732:	e9 02 01 00 00       	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700737:	48 8d 05 aa a2 3f 00 	lea    0x3fa2aa(%rip),%rax        # afa9e8 <__frame_dummy_init_array_entry+0x150>
  70073e:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  700745:	00 
  700746:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  70074d:	00 
  70074e:	ff 15 b4 8c 42 00    	call   *0x428cb4(%rip)        # b29408 <_DYNAMIC+0x308>
  700754:	e9 e0 00 00 00       	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700759:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70075e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  700762:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  700767:	ff 15 13 8c 42 00    	call   *0x428c13(%rip)        # b29380 <_DYNAMIC+0x280>
  70076d:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  700771:	e9 d2 f9 ff ff       	jmp    700148 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e8>
  700776:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70077b:	48 8b 47 08          	mov    0x8(%rdi),%rax
  70077f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  700784:	ff 15 f6 8b 42 00    	call   *0x428bf6(%rip)        # b29380 <_DYNAMIC+0x280>
  70078a:	89 ef                	mov    %ebp,%edi
  70078c:	e9 e9 f9 ff ff       	jmp    70017a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  700791:	48 8d 15 68 a2 3f 00 	lea    0x3fa268(%rip),%rdx        # afaa00 <__frame_dummy_init_array_entry+0x168>
  700798:	ff 15 ba 8c 42 00    	call   *0x428cba(%rip)        # b29458 <_DYNAMIC+0x358>
  70079e:	e9 96 00 00 00       	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  7007a3:	48 8d 05 f6 a5 3f 00 	lea    0x3fa5f6(%rip),%rax        # afada0 <__frame_dummy_init_array_entry+0x508>
  7007aa:	eb 47                	jmp    7007f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  7007ac:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7007b1:	48 8d 05 00 a6 3f 00 	lea    0x3fa600(%rip),%rax        # afadb8 <__frame_dummy_init_array_entry+0x520>
  7007b8:	eb 39                	jmp    7007f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  7007ba:	48 8d 05 c7 a5 3f 00 	lea    0x3fa5c7(%rip),%rax        # afad88 <__frame_dummy_init_array_entry+0x4f0>
  7007c1:	eb 30                	jmp    7007f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  7007c3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7007c8:	48 8d 05 31 a2 3f 00 	lea    0x3fa231(%rip),%rax        # afaa00 <__frame_dummy_init_array_entry+0x168>
  7007cf:	eb 22                	jmp    7007f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  7007d1:	48 85 ff             	test   %rdi,%rdi
  7007d4:	75 34                	jne    70080a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1eaa>
  7007d6:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  7007dd:	00 00 
  7007df:	ff 15 6b 8d 42 00    	call   *0x428d6b(%rip)        # b29550 <_DYNAMIC+0x450>
  7007e5:	eb 52                	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  7007e7:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7007ec:	48 8d 05 dd a1 3f 00 	lea    0x3fa1dd(%rip),%rax        # afa9d0 <__frame_dummy_init_array_entry+0x138>
  7007f3:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  7007f8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  7007fd:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  700802:	ff 15 50 8c 42 00    	call   *0x428c50(%rip)        # b29458 <_DYNAMIC+0x358>
  700808:	eb 2f                	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  70080a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  70080f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  700816:	00 00 
  700818:	ff 15 52 8b 42 00    	call   *0x428b52(%rip)        # b29370 <_DYNAMIC+0x270>
  70081e:	eb 19                	jmp    700839 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  700820:	48 8d 3d 54 9f 96 ff 	lea    -0x6960ac(%rip),%rdi        # 6a77b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x349e>
  700827:	48 8d 15 32 ad 3f 00 	lea    0x3fad32(%rip),%rdx        # afb560 <__frame_dummy_init_array_entry+0xcc8>
  70082e:	be 15 00 00 00       	mov    $0x15,%esi
  700833:	ff 15 0f 8c 42 00    	call   *0x428c0f(%rip)        # b29448 <_DYNAMIC+0x348>
  700839:	0f 0b                	ud2
  70083b:	49 89 c5             	mov    %rax,%r13
  70083e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  700843:	48 89 45 10          	mov    %rax,0x10(%rbp)
  700847:	eb 6d                	jmp    7008b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  700849:	49 89 c5             	mov    %rax,%r13
  70084c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  700851:	48 89 45 08          	mov    %rax,0x8(%rbp)
  700855:	eb 5f                	jmp    7008b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  700857:	49 89 c5             	mov    %rax,%r13
  70085a:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  70085e:	eb 56                	jmp    7008b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  700860:	48 89 c3             	mov    %rax,%rbx
  700863:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70086a:	00 
  70086b:	e8 70 77 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  700870:	48 89 df             	mov    %rbx,%rdi
  700873:	e8 68 8c 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  700878:	eb 18                	jmp    700892 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f32>
  70087a:	eb 16                	jmp    700892 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f32>
  70087c:	eb 00                	jmp    70087e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f1e>
  70087e:	49 89 c5             	mov    %rax,%r13
  700881:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  700888:	ff 
  700889:	eb 2b                	jmp    7008b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  70088b:	49 89 c5             	mov    %rax,%r13
  70088e:	eb 4d                	jmp    7008dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  700890:	eb 21                	jmp    7008b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f53>
  700892:	49 89 c5             	mov    %rax,%r13
  700895:	eb 29                	jmp    7008c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f60>
  700897:	49 89 c5             	mov    %rax,%r13
  70089a:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  7008a0:	7e 3b                	jle    7008dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  7008a2:	ba 01 00 00 00       	mov    $0x1,%edx
  7008a7:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  7008ac:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7008b1:	eb 24                	jmp    7008d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f77>
  7008b3:	49 89 c5             	mov    %rax,%r13
  7008b6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  7008bb:	e8 70 40 ff ff       	call   6f4930 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  7008c0:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  7008c6:	7e 15                	jle    7008dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  7008c8:	ba 01 00 00 00       	mov    $0x1,%edx
  7008cd:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7008d2:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7008d7:	ff 15 6b 8a 42 00    	call   *0x428a6b(%rip)        # b29348 <_DYNAMIC+0x248>
  7008dd:	4c 89 ef             	mov    %r13,%rdi
  7008e0:	ff 15 82 8b 42 00    	call   *0x428b82(%rip)        # b29468 <_DYNAMIC+0x368>
  7008e6:	49 89 c5             	mov    %rax,%r13
  7008e9:	48 89 d5             	mov    %rdx,%rbp
  7008ec:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  7008f3:	00 
  7008f4:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  7008fb:	00 
  7008fc:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  700903:	00 fd ff ff ff 
  700908:	4c 89 f7             	mov    %r14,%rdi
  70090b:	e8 30 8a 02 00       	call   729340 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  700910:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  700917:	00 0f 00 00 00 
  70091c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  700920:	48 85 c0             	test   %rax,%rax
  700923:	74 05                	je     70092a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fca>
  700925:	4c 89 ef             	mov    %r13,%rdi
  700928:	ff d0                	call   *%rax
  70092a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70092e:	48 85 f6             	test   %rsi,%rsi
  700931:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  700936:	74 0d                	je     700945 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fe5>
  700938:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70093c:	4c 89 ef             	mov    %r13,%rdi
  70093f:	ff 15 03 8a 42 00    	call   *0x428a03(%rip)        # b29348 <_DYNAMIC+0x248>
  700945:	31 ed                	xor    %ebp,%ebp
  700947:	e9 56 e2 ff ff       	jmp    6feba2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x242>
  70094c:	48 89 c3             	mov    %rax,%rbx
  70094f:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  700953:	48 85 f6             	test   %rsi,%rsi
  700956:	74 2b                	je     700983 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2023>
  700958:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70095c:	4c 89 ef             	mov    %r13,%rdi
  70095f:	ff 15 e3 89 42 00    	call   *0x4289e3(%rip)        # b29348 <_DYNAMIC+0x248>
  700965:	48 89 df             	mov    %rbx,%rdi
  700968:	e8 73 8b 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  70096d:	ff 15 05 8a 42 00    	call   *0x428a05(%rip)        # b29378 <_DYNAMIC+0x278>
  700973:	48 89 c3             	mov    %rax,%rbx
  700976:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70097d:	00 
  70097e:	e8 7d 44 ff ff       	call   6f4e00 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  700983:	48 89 df             	mov    %rbx,%rdi
  700986:	e8 55 8b 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  70098b:	ff 15 e7 89 42 00    	call   *0x4289e7(%rip)        # b29378 <_DYNAMIC+0x278>
  700991:	ff 15 d9 8a 42 00    	call   *0x428ad9(%rip)        # b29470 <_DYNAMIC+0x370>
