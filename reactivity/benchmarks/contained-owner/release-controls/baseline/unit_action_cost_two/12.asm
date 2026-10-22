
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007085d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select>:
  7085d0:	41 57                	push   %r15
  7085d2:	41 56                	push   %r14
  7085d4:	41 55                	push   %r13
  7085d6:	41 54                	push   %r12
  7085d8:	53                   	push   %rbx
  7085d9:	48 83 ec 60          	sub    $0x60,%rsp
  7085dd:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  7085e4:	74 0c                	je     7085f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x22>
  7085e6:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  7085ed:	e9 69 01 00 00       	jmp    70875b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x18b>
  7085f2:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  7085f9:	0f 85 14 01 00 00    	jne    708713 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x143>
  7085ff:	49 89 d6             	mov    %rdx,%r14
  708602:	48 89 fb             	mov    %rdi,%rbx
  708605:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70860a:	49 89 f4             	mov    %rsi,%r12
  70860d:	49 89 cf             	mov    %rcx,%r15
  708610:	48 89 ca             	mov    %rcx,%rdx
  708613:	e8 98 0a 01 00       	call   7190b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  708618:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  70861d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  708622:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  708626:	0f 85 ee 00 00 00    	jne    70871a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x14a>
  70862c:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  708633:	00 
  708634:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  708639:	48 85 f6             	test   %rsi,%rsi
  70863c:	48 89 df             	mov    %rbx,%rdi
  70863f:	0f 84 29 01 00 00    	je     70876e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x19e>
  708645:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  70864c:	00 
  70864d:	0f 84 1b 01 00 00    	je     70876e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x19e>
  708653:	4c 89 e2             	mov    %r12,%rdx
  708656:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  70865d:	00 
  70865e:	48 83 fe 1c          	cmp    $0x1c,%rsi
  708662:	0f 82 d2 00 00 00    	jb     70873a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x16a>
  708668:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  70866c:	48 83 f8 02          	cmp    $0x2,%rax
  708670:	0f 93 c1             	setae  %cl
  708673:	48 39 f0             	cmp    %rsi,%rax
  708676:	0f 92 c0             	setb   %al
  708679:	84 c1                	test   %al,%cl
  70867b:	0f 84 e8 00 00 00    	je     708769 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x199>
  708681:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  708688:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  70868c:	0f 84 f7 00 00 00    	je     708789 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1b9>
  708692:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  708699:	00 00 
  70869b:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7086a0:	e8 db f3 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7086a5:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  7086ac:	00 
  7086ad:	48 85 c0             	test   %rax,%rax
  7086b0:	0f 84 ba 00 00 00    	je     708770 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1a0>
  7086b6:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  7086bd:	48 85 c0             	test   %rax,%rax
  7086c0:	0f 84 aa 00 00 00    	je     708770 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1a0>
  7086c6:	4c 89 e6             	mov    %r12,%rsi
  7086c9:	49 ff c5             	inc    %r13
  7086cc:	4c 89 30             	mov    %r14,(%rax)
  7086cf:	4c 89 78 08          	mov    %r15,0x8(%rax)
  7086d3:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  7086d9:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  7086e0:	00 
  7086e1:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  7086e8:	00 
  7086e9:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  7086f0:	00 00 00 00 00 
  7086f5:	41 c6 84 24 1f 08 00 	movb   $0x1,0x81f(%r12)
  7086fc:	00 01 
  7086fe:	48 89 df             	mov    %rbx,%rdi
  708701:	48 83 c4 60          	add    $0x60,%rsp
  708705:	5b                   	pop    %rbx
  708706:	41 5c                	pop    %r12
  708708:	41 5d                	pop    %r13
  70870a:	41 5e                	pop    %r14
  70870c:	41 5f                	pop    %r15
  70870e:	e9 0d 12 01 00       	jmp    719920 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  708713:	b9 11 00 00 00       	mov    $0x11,%ecx
  708718:	eb 03                	jmp    70871d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x14d>
  70871a:	48 89 df             	mov    %rbx,%rdi
  70871d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  708722:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  708727:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70872c:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  708731:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  708736:	0f 29 04 24          	movaps %xmm0,(%rsp)
  70873a:	48 89 0f             	mov    %rcx,(%rdi)
  70873d:	48 89 47 08          	mov    %rax,0x8(%rdi)
  708741:	0f 28 04 24          	movaps (%rsp),%xmm0
  708745:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  70874a:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70874e:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  708752:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  708757:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70875b:	48 83 c4 60          	add    $0x60,%rsp
  70875f:	5b                   	pop    %rbx
  708760:	41 5c                	pop    %r12
  708762:	41 5d                	pop    %r13
  708764:	41 5e                	pop    %r14
  708766:	41 5f                	pop    %r15
  708768:	c3                   	ret
  708769:	b9 11 00 00 00       	mov    $0x11,%ecx
  70876e:	eb ca                	jmp    70873a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x16a>
  708770:	48 8d 3d 4e 1c 96 ff 	lea    -0x69e3b2(%rip),%rdi        # 6a3c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32d8>
  708777:	48 8d 15 12 15 3f 00 	lea    0x3f1512(%rip),%rdx        # af9c90 <__frame_dummy_init_array_entry+0x768>
  70877e:	be 11 00 00 00       	mov    $0x11,%esi
  708783:	ff 15 77 f8 41 00    	call   *0x41f877(%rip)        # b28000 <_DYNAMIC+0x348>
  708789:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  708790:	eb c9                	jmp    70875b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x18b>
